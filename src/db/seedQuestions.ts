import { pool } from './pool';

type QType = 'single_choice' | 'multiple_choice' | 'fill_in_blank';

interface Q {
  cat: string;
  text: string;
  type: QType;
  opts: string[];
  ans: number | number[] | string;
  alts?: string[];
  expl?: string;
}

const questions: Q[] = [
  // Geography: Capitals
  { cat: 'geography.capitals', type: 'single_choice', text: 'What is the capital of France?', opts: ['Paris', 'London', 'Berlin', 'Madrid'], ans: 0, expl: 'Paris has been the capital of France since the 10th century.' },
  { cat: 'geography.capitals', type: 'single_choice', text: 'What is the capital of Japan?', opts: ['Seoul', 'Beijing', 'Tokyo', 'Bangkok'], ans: 2, expl: 'Tokyo became the capital of Japan in 1868.' },
  { cat: 'geography.capitals', type: 'single_choice', text: 'What is the capital of Australia?', opts: ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'], ans: 2, expl: 'Canberra was chosen as a compromise between Sydney and Melbourne.' },
  { cat: 'geography.capitals', type: 'fill_in_blank', text: 'What is the capital of Italy?', opts: [], ans: 'Rome', alts: ['roma'], expl: 'Rome is known as the Eternal City.' },

  // Geography: Countries
  { cat: 'geography.countries', type: 'single_choice', text: 'Which country has the largest population?', opts: ['India', 'China', 'USA', 'Indonesia'], ans: 0, expl: 'India surpassed China in population in 2023.' },
  { cat: 'geography.countries', type: 'single_choice', text: 'Which is the smallest country in the world by area?', opts: ['Monaco', 'Vatican City', 'San Marino', 'Liechtenstein'], ans: 1, expl: 'Vatican City is only 0.44 km2.' },

  // Geography: Oceans
  { cat: 'geography.oceans', type: 'single_choice', text: 'What is the largest ocean on Earth?', opts: ['Atlantic', 'Indian', 'Pacific', 'Arctic'], ans: 2, expl: 'The Pacific Ocean covers about 63 million square miles.' },
  { cat: 'geography.oceans', type: 'multiple_choice', text: 'Which of these border the United States?', opts: ['Atlantic Ocean', 'Pacific Ocean', 'Indian Ocean', 'Arctic Ocean'], ans: [0, 1], expl: 'The US borders the Atlantic (east) and Pacific (west).' },

  // Geography: Landmarks
  { cat: 'geography.landmarks', type: 'single_choice', text: 'In which city is the Eiffel Tower located?', opts: ['Rome', 'London', 'Paris', 'Berlin'], ans: 2, expl: 'Built for the 1889 World Fair in Paris.' },
  { cat: 'geography.landmarks', type: 'multiple_choice', text: 'Which of these are Wonders of the Ancient World?', opts: ['Great Pyramid of Giza', 'Colosseum', 'Hanging Gardens of Babylon', 'Stonehenge'], ans: [0, 2], expl: 'The Great Pyramid and Hanging Gardens are two of the Seven Wonders.' },

  // Science: Biology
  { cat: 'science.biology', type: 'single_choice', text: 'What is the powerhouse of the cell?', opts: ['Nucleus', 'Mitochondria', 'Ribosome', 'Endoplasmic Reticulum'], ans: 1, expl: 'Mitochondria produce ATP, the energy currency of the cell.' },
  { cat: 'science.biology', type: 'single_choice', text: 'How many chromosomes do humans have?', opts: ['23', '44', '46', '48'], ans: 2, expl: 'Humans have 23 pairs, totaling 46 chromosomes.' },
  { cat: 'science.biology.genetics', type: 'fill_in_blank', text: 'The molecule that carries genetic information is ___', opts: [], ans: 'DNA', alts: ['deoxyribonucleic acid', 'dna'], expl: 'DNA stands for Deoxyribonucleic Acid.' },

  // Science: Physics
  { cat: 'science.physics', type: 'single_choice', text: 'What is the speed of light in a vacuum?', opts: ['300,000 km/s', '150,000 km/s', '500,000 km/s', '1,000,000 km/s'], ans: 0, expl: 'Light travels at approximately 299,792 km/s.' },
  { cat: 'science.physics', type: 'fill_in_blank', text: 'The force that keeps us on the ground is called ___', opts: [], ans: 'gravity', expl: 'Gravity is one of the four fundamental forces.' },
  { cat: 'science.physics.quantum', type: 'single_choice', text: 'Who is considered the father of quantum theory?', opts: ['Albert Einstein', 'Max Planck', 'Niels Bohr', 'Erwin Schrodinger'], ans: 1, expl: 'Max Planck introduced the quantum of action in 1900.' },

  // Science: Chemistry
  { cat: 'science.chemistry', type: 'fill_in_blank', text: 'The chemical symbol for gold is ___', opts: [], ans: 'Au', expl: 'Au comes from the Latin word aurum.' },
  { cat: 'science.chemistry.elements', type: 'single_choice', text: 'What is the atomic number of Carbon?', opts: ['4', '6', '8', '12'], ans: 1, expl: 'Carbon has 6 protons, making its atomic number 6.' },
  { cat: 'science.chemistry', type: 'fill_in_blank', text: 'Water has the chemical formula ___', opts: [], ans: 'H2O', alts: ['h2o'], expl: 'Each water molecule has 2 hydrogen atoms and 1 oxygen atom.' },

  // Science: Space
  { cat: 'science.space', type: 'single_choice', text: 'Which planet is known as the Red Planet?', opts: ['Venus', 'Mars', 'Jupiter', 'Saturn'], ans: 1, expl: 'Mars appears red due to iron oxide (rust) on its surface.' },
  { cat: 'science.space', type: 'multiple_choice', text: 'Which of these are gas giants?', opts: ['Earth', 'Jupiter', 'Saturn', 'Mars'], ans: [1, 2], expl: 'Jupiter and Saturn are gas giants, while Earth and Mars are terrestrial.' },

  // Science: Math
  { cat: 'science.math', type: 'single_choice', text: 'What is the value of Pi to two decimal places?', opts: ['3.14', '3.16', '3.12', '3.18'], ans: 0, expl: 'Pi is approximately 3.14159...' },

  // History
  { cat: 'history.ancient', type: 'single_choice', text: 'Which ancient civilization built the pyramids?', opts: ['Romans', 'Greeks', 'Egyptians', 'Persians'], ans: 2, expl: 'The Great Pyramid of Giza was built around 2560 BCE.' },
  { cat: 'history.ww2', type: 'single_choice', text: 'In what year did World War II end?', opts: ['1943', '1944', '1945', '1946'], ans: 2, expl: 'WWII ended in 1945 with the surrender of Germany and Japan.' },
  { cat: 'history.ww2.battles', type: 'fill_in_blank', text: 'The Allied invasion of Normandy in 1944 is known as ___', opts: [], ans: 'D-Day', alts: ['d-day', 'd day', 'Operation Overlord'], expl: 'D-Day on June 6, 1944, was the largest seaborne invasion in history.' },
  { cat: 'history.modern', type: 'single_choice', text: 'Who was the first person to walk on the Moon?', opts: ['Buzz Aldrin', 'Neil Armstrong', 'Yuri Gagarin', 'John Glenn'], ans: 1, expl: 'Neil Armstrong stepped onto the lunar surface on July 20, 1969.' },

  // Entertainment: Movies
  { cat: 'entertainment.movies', type: 'single_choice', text: 'Which movie won the first Academy Award for Best Picture?', opts: ['Wings', 'Sunrise', 'The Jazz Singer', 'Metropolis'], ans: 0, expl: 'Wings (1927) won the first Best Picture Oscar in 1929.' },
  { cat: 'entertainment.movies.oscars', type: 'multiple_choice', text: 'Which of these films have won Best Picture?', opts: ['Titanic', 'The Shawshank Redemption', 'Forrest Gump', 'Pulp Fiction'], ans: [0, 2], expl: 'Titanic (1997) and Forrest Gump (1994) won Best Picture.' },

  // Entertainment: Music
  { cat: 'entertainment.music', type: 'single_choice', text: 'Which band performed at the first Live Aid concert in 1985?', opts: ['Queen', 'The Beatles', 'Led Zeppelin', 'Pink Floyd'], ans: 0, expl: 'Queen Live Aid is considered one of the greatest live performances.' },

  // Food
  { cat: 'food.cuisine', type: 'single_choice', text: 'Sushi originated in which country?', opts: ['China', 'Korea', 'Japan', 'Thailand'], ans: 2, expl: 'Sushi originated in Japan, with earliest mentions dating to the 8th century.' },
  { cat: 'food.desserts', type: 'fill_in_blank', text: 'Tiramisu is a famous dessert from which country?', opts: [], ans: 'Italy', alts: ['italia'], expl: 'Tiramisu originated in the Veneto region of Italy in the 1960s.' },

  // Technology
  { cat: 'technology', type: 'single_choice', text: 'Who invented the World Wide Web?', opts: ['Tim Berners-Lee', 'Bill Gates', 'Steve Jobs', 'Vint Cerf'], ans: 0, expl: 'Sir Tim Berners-Lee invented the World Wide Web in 1989.' },
  { cat: 'technology.ai', type: 'fill_in_blank', text: 'The programming language most used in AI and machine learning is ___', opts: [], ans: 'Python', alts: ['python'], expl: 'Python dominates AI/ML due to its rich ecosystem of libraries.' },
  { cat: 'technology.web', type: 'single_choice', text: 'What does HTML stand for?', opts: ['HyperText Markup Language', 'High Tech Modern Language', 'HyperText Modern Link', 'Home Tool Markup Language'], ans: 0, expl: 'HTML is the standard markup language for web pages.' },

  // Sports
  { cat: 'sports.football', type: 'single_choice', text: 'Which country has won the most FIFA World Cup titles?', opts: ['Germany', 'Argentina', 'Brazil', 'Italy'], ans: 2, expl: 'Brazil has won the World Cup 5 times.' },
  { cat: 'sports.olympics', type: 'single_choice', text: 'Where did the ancient Olympic Games originate?', opts: ['Rome', 'Athens', 'Olympia', 'Sparta'], ans: 2, expl: 'The ancient Olympics were held in Olympia, Greece starting 776 BCE.' },
  { cat: 'sports.basketball', type: 'fill_in_blank', text: 'The NBA championship trophy is named after ___', opts: [], ans: 'Larry O\'Brien', alts: ['larry obrien', 'larry o brien', 'obrien'], expl: 'The Larry O\'Brien Trophy has been awarded since 1977.' },
];

async function seedQuestions() {
  const existing = await pool.query('SELECT COUNT(*) AS c FROM questions');
  if (parseInt(existing.rows[0]!.c, 10) > 0) {
    console.log('Questions already exist, skipping');
    return;
  }

  const client = await pool.connect();

  for (const q of questions) {
    try { await client.query('BEGIN');

      // find category id
      const catRes = await client.query<{ id: string }>(
        'SELECT id FROM categories WHERE path = $1::ltree', [q.cat]
      );
      if (!catRes.rowCount || catRes.rowCount === 0) {
        console.log(`Category not found: ${q.cat}, skipping`);
        await client.query('ROLLBACK');
        continue;
      }
      const catId = catRes.rows[0]!.id;

      // insert question
      const qRes = await client.query<{ id: string }>(
        'INSERT INTO questions (category_id, question_text, question_type, explanation) VALUES ($1, $2, $3, $4) RETURNING id',
        [catId, q.text, q.type, q.expl ?? null]
      );
      const qId = qRes.rows[0]!.id;

      // insert options
      const optIds: string[] = [];
      for (let i = 0; i < q.opts.length; i++) {
        const oRes = await client.query<{ id: string }>(
          'INSERT INTO question_options (question_id, option_text, sort_order) VALUES ($1, $2, $3) RETURNING id',
          [qId, q.opts[i]!, i]
        );
        optIds.push(oRes.rows[0]!.id);
      }

      // insert answer
      if (q.type === 'single_choice') {
        const idx = q.ans as number;
        await client.query(
          'INSERT INTO answers (question_id, single_choice_answer) VALUES ($1, $2)',
          [qId, optIds[idx]!]
        );
      } else if (q.type === 'multiple_choice') {
        const indices = q.ans as number[];
        const aRes = await client.query<{ id: string }>(
          'INSERT INTO answers (question_id) VALUES ($1) RETURNING id', [qId]
        );
        const aId = aRes.rows[0]!.id;
        for (const idx of indices) {
          await client.query(
            'INSERT INTO multiple_choice_answer_options (answer_id, option_id) VALUES ($1, $2)',
            [aId, optIds[idx]!]
          );
        }
      } else if (q.type === 'fill_in_blank') {
        const text = q.ans as string;
        await client.query(
          'INSERT INTO answers (question_id, fill_in_answer, fill_in_alternatives) VALUES ($1, $2, $3)',
          [qId, text, q.alts ?? null]
        );
      }

      await client.query('COMMIT');
    } catch (err) {
      await client.query('ROLLBACK');
      console.error(`Failed to seed: ${q.text}`, err);
    }
  }

  client.release();
  console.log(`Seeded ${questions.length} questions`);
}

seedQuestions();
