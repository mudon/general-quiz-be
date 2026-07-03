import { pool } from '../../db/pool';
import { AppError } from '../auth/service';

interface CategoryRow {
  id: string;
  path: string;
  name: string;
  icon: string | null;
  tier: number;
  sort_order: number;
  created_at: string;
  depth: number;
  parent_path: string | null;
  parent_id: string | null;
}

export interface CategoryTree {
  id: string;
  name: string;
  path: string;
  icon: string | null;
  tier: number;
  sortOrder: number;
  depth: number;
  parentId: string | null;
  children: CategoryTree[];
}

export interface CreateCategoryInput {
  name: string;
  parentId?: string | null;
  icon?: string | null;
  sortOrder?: number;
}

export interface UpdateCategoryInput {
  name?: string;
  icon?: string | null;
  sortOrder?: number;
}

function toLabel(name: string): string {
  return name.toLowerCase().replace(/[^a-z0-9_]/g, '_').replace(/_+/g, '_').replace(/^_|_$/g, '');
}

function mapRow(row: CategoryRow): CategoryTree {
  return {
    id: row.id,
    name: row.name,
    path: row.path,
    icon: row.icon,
    tier: row.tier,
    sortOrder: row.sort_order,
    depth: row.depth,
    parentId: row.parent_id,
    children: [],
  };
}

function buildTree(rows: CategoryRow[]): CategoryTree[] {
  const map = new Map<string, CategoryTree>();
  const roots: CategoryTree[] = [];

  for (const row of rows) {
    map.set(row.path, mapRow(row));
  }

  for (const [, node] of map) {
    const parentPath = rows.find(r => r.path === node.path)?.parent_path;
    if (parentPath && map.has(parentPath)) {
      map.get(parentPath)!.children.push(node);
    } else {
      roots.push(node);
    }
  }

  return roots;
}

export async function getAll(maxTier?: number): Promise<CategoryTree[]> {
  const result = await pool.query<CategoryRow>(`
    SELECT cwp.*
    FROM categories_with_parent cwp
    ORDER BY cwp.path
  `);
  return result.rows.map(mapRow);
}

export async function getTree(maxTier?: number): Promise<CategoryTree[]> {
  const result = await pool.query<CategoryRow>(`
    SELECT cwp.*
    FROM categories_with_parent cwp
    ORDER BY cwp.sort_order, cwp.path
  `);
  return buildTree(result.rows);
}

export async function getById(id: string): Promise<CategoryTree> {
  const result = await pool.query<CategoryRow>(`
    SELECT cwp.*
    FROM categories_with_parent cwp
    WHERE cwp.id = $1
  `, [id]);

  if (!result.rowCount || result.rowCount === 0) {
    throw new AppError(404, 'Category not found');
  }

  return mapRow(result.rows[0]!);
}

export async function create(input: CreateCategoryInput): Promise<CategoryTree> {
  const label = toLabel(input.name);
  let path: string;

  if (input.parentId) {
    const parent = await pool.query<{ path: string }>(
      'SELECT path FROM categories WHERE id = $1',
      [input.parentId]
    );
    if (!parent.rowCount || parent.rowCount === 0) {
      throw new AppError(404, 'Parent category not found');
    }
    path = `${parent.rows[0]!.path}.${label}`;
  } else {
    path = label;
  }

  const result = await pool.query<CategoryRow>(`
    INSERT INTO categories (path, name, icon, sort_order)
    VALUES ($1, $2, $3, $4)
    RETURNING *
  `, [path, input.name, input.icon ?? null, input.sortOrder ?? 0]);

  return await getById(result.rows[0]!.id);
}

export async function update(id: string, input: UpdateCategoryInput): Promise<CategoryTree> {
  const existing = await pool.query<CategoryRow>(
    'SELECT * FROM categories WHERE id = $1', [id]
  );
  if (!existing.rowCount || existing.rowCount === 0) {
    throw new AppError(404, 'Category not found');
  }

  const oldRow = existing.rows[0]!;

  const newName = input.name ?? oldRow.name;
  const newIcon = input.icon !== undefined ? input.icon : oldRow.icon;
  const newSortOrder = input.sortOrder ?? oldRow.sort_order;

  // If name changed, update the path and all descendant paths
  if (input.name && input.name !== oldRow.name) {
    const newLabel = toLabel(input.name);
    const oldPrefix = oldRow.path;
    const newPrefix = oldPrefix.includes('.')
      ? oldPrefix.slice(0, oldPrefix.lastIndexOf('.') + 1) + newLabel
      : newLabel;

    await pool.query(`
      UPDATE categories SET
        path = text2ltree(replace(ltree2text(path), $1, $2)),
        name = CASE WHEN id = $3 THEN $4 ELSE name END,
        icon = $5,
        sort_order = $6
      WHERE path <@ $7
    `, [oldPrefix, newPrefix, id, newName, newIcon, newSortOrder, oldRow.path]);
  } else {
    await pool.query(
      'UPDATE categories SET icon = $2, sort_order = $3 WHERE id = $1',
      [id, newIcon, newSortOrder]
    );
  }

  return await getById(id);
}

export async function remove(id: string): Promise<void> {
  const existing = await pool.query('SELECT path FROM categories WHERE id = $1', [id]);
  if (!existing.rowCount || existing.rowCount === 0) {
    throw new AppError(404, 'Category not found');
  }

  const categoryPath = existing.rows[0]!.path;

  // delete deepest descendants first to avoid orphaned rows
  await pool.query(`
    DELETE FROM categories
    WHERE path <@ $1
    ORDER BY nlevel(path) DESC
  `, [categoryPath]);
}

export interface CompletionStatus {
  categoryId: string;
  totalQuestions: number;
  answeredQuestions: number;
  completed: boolean;
}

export async function getCompletionStatus(userId: string): Promise<CompletionStatus[]> {
  const result = await pool.query<{
    category_id: string; total: string; answered: string;
  }>(
    `SELECT
       c.id AS category_id,
       (SELECT COUNT(DISTINCT q.id) FROM questions q
        JOIN categories sub ON sub.id = q.category_id
        WHERE sub.path <@ c.path)::text AS total,
       (SELECT COUNT(DISTINCT ua.question_id) FROM user_answers ua
        JOIN questions q ON q.id = ua.question_id
        JOIN categories sub ON sub.id = q.category_id
        WHERE sub.path <@ c.path AND ua.user_id = $1)::text AS answered
     FROM categories c
     WHERE EXISTS (
       SELECT 1 FROM questions q2
       JOIN categories sub ON sub.id = q2.category_id
       WHERE sub.path <@ c.path
     )
     ORDER BY c.path`,
    [userId]
  );

  return result.rows.map(r => {
    const total = parseInt(r.total, 10);
    const answered = parseInt(r.answered, 10);
    return {
      categoryId: r.category_id,
      totalQuestions: total,
      answeredQuestions: answered,
      completed: total > 0 && answered >= total,
    };
  });
}
