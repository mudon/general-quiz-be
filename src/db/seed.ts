import { pool } from './pool';

async function seed() {
  await seedCategories();
  await seedQuestions();
  console.log('Seed complete');
  process.exit(0);
}

// questions already seeded separately — skip
async function seedQuestions() {
  const existing = await pool.query('SELECT COUNT(*) AS c FROM questions');
  if (parseInt(existing.rows[0]!.c, 10) > 0) {
    console.log('Questions already exist, skipping');
    return;
  }
  console.log('Run src/db/seedQuestions.ts to seed questions');
}

async function seedCategories() {
  const cats: { path: string; name: string; icon: string }[] = [
    { path: 'science',             name: 'Science',               icon: 'microscope' },
    { path: 'history',             name: 'History',               icon: 'scroll' },
    { path: 'geography',           name: 'Geography',             icon: 'globe' },
    { path: 'entertainment',       name: 'Entertainment',         icon: 'film' },
    { path: 'technology',          name: 'Technology',            icon: 'laptop' },
    { path: 'sports',              name: 'Sports',                icon: 'trophy' },
    { path: 'food',                name: 'Food & Drinks',         icon: 'utensils' },
    { path: 'science.biology',     name: 'Biology',               icon: 'dna' },
    { path: 'science.physics',     name: 'Physics',               icon: 'atom' },
    { path: 'science.chemistry',   name: 'Chemistry',             icon: 'flask' },
    { path: 'science.space',       name: 'Space & Astronomy',     icon: 'rocket' },
    { path: 'science.math',        name: 'Mathematics',           icon: 'calculator' },
    { path: 'history.ancient',     name: 'Ancient History',       icon: 'landmark' },
    { path: 'history.medieval',    name: 'Medieval History',      icon: 'swords' },
    { path: 'history.modern',      name: 'Modern History',        icon: 'building' },
    { path: 'history.ww2',         name: 'World War II',          icon: 'helmet' },
    { path: 'geography.countries', name: 'Countries',             icon: 'map' },
    { path: 'geography.capitals',  name: 'Capitals',              icon: 'city' },
    { path: 'geography.oceans',    name: 'Oceans & Seas',         icon: 'waves' },
    { path: 'geography.landmarks', name: 'Landmarks',             icon: 'monument' },
    { path: 'entertainment.movies',name: 'Movies',                icon: 'clapperboard' },
    { path: 'entertainment.music', name: 'Music',                 icon: 'music' },
    { path: 'entertainment.tv',    name: 'TV Shows',              icon: 'tv' },
    { path: 'entertainment.gaming',name: 'Video Games',           icon: 'gamepad' },
    { path: 'technology.ai',       name: 'AI',                    icon: 'brain' },
    { path: 'technology.web',      name: 'Web Development',       icon: 'globe' },
    { path: 'technology.mobile',   name: 'Mobile Development',    icon: 'smartphone' },
    { path: 'technology.cyber',    name: 'Cybersecurity',         icon: 'shield' },
    { path: 'sports.football',     name: 'Football',              icon: 'football' },
    { path: 'sports.basketball',   name: 'Basketball',            icon: 'basketball' },
    { path: 'sports.olympics',     name: 'Olympic Games',         icon: 'medal' },
    { path: 'food.cuisine',        name: 'World Cuisine',         icon: 'bowl' },
    { path: 'food.desserts',       name: 'Desserts',              icon: 'cake' },
    { path: 'food.beverages',      name: 'Beverages',             icon: 'coffee' },
    { path: 'science.biology.genetics',   name: 'Genetics',       icon: 'dna' },
    { path: 'science.physics.quantum',    name: 'Quantum Physics',icon: 'bolt' },
    { path: 'science.chemistry.elements', name: 'Elements',       icon: 'beaker' },
    { path: 'history.ww2.battles',        name: 'Battles',        icon: 'bomb' },
    { path: 'geography.countries.africa', name: 'African Countries', icon: 'compass' },
    { path: 'entertainment.movies.oscars',name: 'Oscar Winners',  icon: 'award' },
  ];

  for (const c of cats) {
    await pool.query(
      `INSERT INTO categories (path, name, icon) VALUES ($1::ltree, $2, $3) ON CONFLICT (path) DO UPDATE SET name = EXCLUDED.name, icon = EXCLUDED.icon`,
      [c.path, c.name, c.icon]
    );
  }
  console.log(`Seeded ${cats.length} categories`);
}

seed();
