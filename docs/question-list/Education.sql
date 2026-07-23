-- ============================================================================
-- Insert 100 factual questions on Education.
-- Subtopics: Primary Education, Secondary Education, Universities,
-- Online Learning, Exams, Scholarships, Teaching Methods.
-- ============================================================================

DO $$
DECLARE
    cat_id_primary        BIGINT;
    cat_id_secondary      BIGINT;
    cat_id_universities   BIGINT;
    cat_id_online         BIGINT;
    cat_id_exams          BIGINT;
    cat_id_scholarships   BIGINT;
    cat_id_teaching       BIGINT;
    q_id                  BIGINT;
    correct_opt_id        BIGINT;
    opt_texts             TEXT[];
    q_rec                 RECORD;
BEGIN
    -- ------------------------------------------------------------------------
    -- Create categories (hierarchical under education)
    -- ------------------------------------------------------------------------
    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('education', 'Education', 2, 0)
        ON CONFLICT (path) DO NOTHING;

    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('education.primary_education',    'Primary Education', 2, 1),
        ('education.secondary_education',  'Secondary Education', 2, 2),
        ('education.universities',         'Universities', 2, 3),
        ('education.online_learning',      'Online Learning', 2, 4),
        ('education.exams',                'Exams', 2, 5),
        ('education.scholarships',         'Scholarships', 2, 6),
        ('education.teaching_methods',     'Teaching Methods', 2, 7)
        ON CONFLICT (path) DO NOTHING;

    -- Get category IDs
    SELECT id INTO cat_id_primary    FROM categories WHERE path = 'education.primary_education';
    SELECT id INTO cat_id_secondary  FROM categories WHERE path = 'education.secondary_education';
    SELECT id INTO cat_id_universities FROM categories WHERE path = 'education.universities';
    SELECT id INTO cat_id_online     FROM categories WHERE path = 'education.online_learning';
    SELECT id INTO cat_id_exams      FROM categories WHERE path = 'education.exams';
    SELECT id INTO cat_id_scholarships FROM categories WHERE path = 'education.scholarships';
    SELECT id INTO cat_id_teaching   FROM categories WHERE path = 'education.teaching_methods';

    -- ========================================================================
    -- 1. PRIMARY EDUCATION (14 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the typical age range for primary education in most countries?',
         ARRAY['5 to 11 years', '3 to 5 years', '11 to 18 years', '18 to 22 years'], 0,
         'Primary education usually covers ages 5–11, though it varies by country.'),
        ('What is the primary goal of primary education?',
         ARRAY['To build foundational literacy, numeracy, and social skills', 'To prepare for university', 'To provide vocational training', 'To teach advanced sciences'], 0,
         'Primary education focuses on basic skills and overall development.'),
        ('Which subject is typically the core of primary education worldwide?',
         ARRAY['Reading, writing, and mathematics', 'History and geography', 'Science and technology', 'Art and music'], 0,
         'Literacy and numeracy are universal foundations.'),
        ('What is the role of a primary school teacher?',
         ARRAY['To guide students through multiple subjects and social development', 'To specialise in one subject', 'To manage school administration', 'To provide counselling only'], 0,
         'Primary teachers often cover a broad curriculum.'),
        ('What is the typical class size in many primary schools?',
         ARRAY['20 to 30 students', '5 to 10 students', '40 to 50 students', '10 to 15 students'], 0,
         'Class sizes vary, but 20–30 is common in many regions.'),
        ('Which international assessment measures primary school performance?',
         ARRAY['PIRLS (Progress in International Reading Literacy Study)', 'PISA', 'TIMSS', 'NAEP'], 0,
         'PIRLS focuses on reading literacy for grade 4.'),
        ('What is the importance of recess in primary school?',
         ARRAY['To allow physical activity, social interaction, and cognitive breaks', 'To continue learning outdoors', 'To eat lunch', 'To complete homework'], 0,
         'Recess supports child development and well‑being.'),
        ('Which country has the highest primary school enrollment rate?',
         ARRAY['Many developed countries have near‑universal enrollment (over 99%)', 'United States', 'China', 'India'], 0,
         'Most OECD countries achieve close to 100% enrollment.'),
        ('What is the typical length of a primary school day?',
         ARRAY['5 to 7 hours', '3 to 4 hours', '8 to 10 hours', '2 to 3 hours'], 0,
         'School days range from 5 to 7 hours, depending on the country.'),
        ('What is the role of parents in primary education?',
         ARRAY['To support learning at home and communicate with teachers', 'To replace teachers', 'To set the curriculum', 'To assess student progress'], 0,
         'Parental involvement is a key factor in student success.'),
        ('What is the common term for the first year of primary school?',
         ARRAY['Kindergarten or Grade 1', 'Pre‑school', 'Nursery', 'Grade 0'], 0,
         'In many systems, Kindergarten is the first year of primary.'),
        ('Which subject is often taught through storytelling in primary schools?',
         ARRAY['Language arts and social studies', 'Mathematics', 'Science', 'Physical education'], 0,
         'Storytelling supports literacy and cultural understanding.'),
        ('What is the significance of the "Year 6" or "Grade 6" in primary education?',
         ARRAY['It is often the final year before transitioning to secondary school', 'It is the starting year', 'It is a mid‑term assessment', 'It is an optional year'], 0,
         'Grade 6 marks the end of primary in many systems.'),
        ('Which skill is most emphasised in primary physical education?',
         ARRAY['Basic motor skills, coordination, and teamwork', 'Competitive sports', 'Fitness testing', 'Advanced gymnastics'], 0,
         'PE focuses on fundamental movement and cooperation.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_primary, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;

        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;

        SELECT id INTO correct_opt_id FROM question_options
        WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ========================================================================
    -- 2. SECONDARY EDUCATION (14 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the typical age range for secondary education?',
         ARRAY['11 to 18 years', '5 to 11 years', '18 to 22 years', '22 to 26 years'], 0,
         'Secondary education generally covers ages 11–18, with some variation.'),
        ('What is the difference between middle school and high school?',
         ARRAY['Middle school is typically grades 6–8; high school is grades 9–12', 'They are the same', 'Middle school is ages 5–11', 'High school is ages 11–14'], 0,
         'This is common in the US; other countries may have different structures.'),
        ('What is a common secondary school leaving qualification?',
         ARRAY['High school diploma, GCSE, or equivalent', 'Bachelor''s degree', 'Master''s degree', 'PhD'], 0,
         'Secondary education often ends with a diploma or certificate.'),
        ('What is the purpose of vocational education in secondary school?',
         ARRAY['To provide practical skills for specific careers', 'To prepare solely for university', 'To teach general subjects', 'To focus on physical education'], 0,
         'Vocational tracks offer career‑oriented training.'),
        ('Which international assessment is designed for 15‑year‑olds?',
         ARRAY['PISA (Programme for International Student Assessment)', 'TIMSS', 'PIRLS', 'NAEP'], 0,
         'PISA assesses reading, maths, and science literacy.'),
        ('What is a typical high school graduation requirement in many countries?',
         ARRAY['Completion of a set number of credits and passing exit exams', 'Only attendance', 'Submission of a research paper', 'Volunteer hours only'], 0,
         'Graduation often involves both coursework and assessments.'),
        ('What is the role of a school counsellor in secondary education?',
         ARRAY['To provide academic, career, and personal support to students', 'To teach science', 'To maintain school facilities', 'To manage finances'], 0,
         'Counsellors help students with social and emotional development.'),
        ('Which country has a tracked secondary system with Gymnasium, Realschule, and Hauptschule?',
         ARRAY['Germany', 'France', 'United Kingdom', 'Japan'], 0,
         'Germany tracks students into different pathways based on ability and career goals.'),
        ('What is the purpose of extracurricular activities in secondary school?',
         ARRAY['To develop interests, skills, and social networks beyond academics', 'To replace academic subjects', 'To extend the school day', 'To raise funds'], 0,
         'Activities like sports, clubs, and arts enrich student experience.'),
        ('Which subject is usually required in all years of secondary education?',
         ARRAY['English/language arts and mathematics', 'Only science', 'Only history', 'Only physical education'], 0,
         'Literacy and numeracy are typically required throughout.'),
        ('What is the "matriculation" exam?',
         ARRAY['An exam that qualifies students for university entrance in many countries', 'A primary school exam', 'A vocational exam', 'A language proficiency test'], 0,
         'Matriculation is a common term for university entrance exams.'),
        ('What is the typical duration of high school (secondary) in the US?',
         ARRAY['4 years (grades 9–12)', '5 years', '3 years', '6 years'], 0,
         'US high school is typically four years.'),
        ('What is the importance of career guidance in secondary school?',
         ARRAY['To help students make informed decisions about their future education and careers', 'To tell students which career to choose', 'To focus only on university', 'To replace academic advising'], 0,
         'Career guidance supports informed decision‑making.'),
        ('Which country has the highest high school graduation rate?',
         ARRAY['South Korea, Japan, and many European countries', 'United States', 'Australia', 'Canada'], 0,
         'Several countries have rates above 90%.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_secondary, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;

        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;

        SELECT id INTO correct_opt_id FROM question_options
        WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ========================================================================
    -- 3. UNIVERSITIES (15 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the highest academic degree offered by universities?',
         ARRAY['Doctorate (PhD or equivalent)', 'Master''s degree', 'Bachelor''s degree', 'Associate degree'], 0,
         'The doctorate is the most advanced research degree.'),
        ('Which university is the oldest in the world?',
         ARRAY['University of Bologna (founded 1088)', 'University of Oxford', 'University of Cambridge', 'Harvard University'], 0,
         'The University of Bologna is widely considered the oldest.'),
        ('What is a typical requirement for university admission?',
         ARRAY['High school diploma or equivalent and entrance exams', 'Work experience only', 'Recommendation letters only', 'No requirements'], 0,
         'Admission requirements vary but often include prior education and testing.'),
        ('What is the role of a university professor?',
         ARRAY['To teach, conduct research, and publish scholarly work', 'To only teach', 'To only do research', 'To manage university finances'], 0,
         'Professors are engaged in both teaching and research.'),
        ('What is the difference between a "college" and a "university"?',
         ARRAY['A university typically offers graduate degrees and has multiple colleges; a college often focuses on undergraduate education', 'They are the same', 'College is only for vocational training', 'University is only for research'], 0,
         'This distinction is common in the US and some other countries.'),
        ('What is the purpose of a bachelor''s degree?',
         ARRAY['To provide a broad undergraduate education in a chosen field', 'To prepare for a specific job without further study', 'To complete research', 'To become a professor'], 0,
         'A bachelor''s is the first level of higher education.'),
        ('What is the "QS World University Rankings"?',
         ARRAY['A ranking of universities based on academic reputation, employer reputation, and research impact', 'A ranking of primary schools', 'A ranking of vocational colleges', 'A ranking of online courses'], 0,
         'QS is a popular global university ranking.'),
        ('Which country has the most universities in the top 100 globally?',
         ARRAY['United States', 'United Kingdom', 'China', 'Germany'], 0,
         'The US consistently leads with the highest number of top‑ranked universities.'),
        ('What is the typical duration of a bachelor''s degree?',
         ARRAY['3 to 4 years', '2 years', '5 to 6 years', '1 year'], 0,
         'Most bachelor''s degrees take 3–4 years of full‑time study.'),
        ('What is the purpose of a master''s degree?',
         ARRAY['To provide advanced specialization beyond the bachelor''s', 'To replace the bachelor''s', 'To teach basic skills', 'To conduct primary research without supervision'], 0,
         'Master''s degrees offer deeper knowledge and skills.'),
        ('What is the "liberal arts" education?',
         ARRAY['A broad curriculum covering humanities, sciences, and social sciences', 'A degree in arts only', 'A vocational programme', 'A technical programme'], 0,
         'Liberal arts colleges emphasize well‑rounded education.'),
        ('Which university is known for its massive open online courses (MOOCs)?',
         ARRAY['Stanford and MIT (edX, Coursera, etc.)', 'University of Bologna', 'University of Oxford', 'Harvard only'], 0,
         'Many top universities offer MOOCs through platforms like edX and Coursera.'),
        ('What is a university accreditation?',
         ARRAY['A recognition that a university meets quality standards', 'A type of scholarship', 'A type of degree', 'A tuition fee'], 0,
         'Accreditation ensures institutional quality and eligibility for federal aid.'),
        ('What is the student‑faculty ratio commonly used to measure?',
         ARRAY['The number of students per faculty member, indicating class size and individual attention', 'The ratio of male to female students', 'The ratio of domestic to international students', 'The number of library books per student'], 0,
         'A lower ratio often suggests more personalised instruction.'),
        ('Which field is a university research centre typically focused on?',
         ARRAY['Various disciplines, from sciences to humanities', 'Only technology', 'Only medicine', 'Only law'], 0,
         'Research centres cover a wide range of fields.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_universities, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;

        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;

        SELECT id INTO correct_opt_id FROM question_options
        WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ========================================================================
    -- 4. ONLINE LEARNING (15 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the main advantage of online learning?',
         ARRAY['Flexibility and accessibility from anywhere', 'No need for a teacher', 'Less expensive always', 'Faster completion'], 0,
         'Online learning offers time and location flexibility.'),
        ('Which platform is known for offering free online courses from top universities?',
         ARRAY['Coursera and edX', 'YouTube only', 'Facebook', 'LinkedIn Learning'], 0,
         'Coursera and edX partner with universities to provide free and paid courses.'),
        ('What is a MOOC?',
         ARRAY['Massive Open Online Course', 'Mobile Online Open Course', 'Managed Open Online Course', 'Multiple Online Open Course'], 0,
         'MOOCs are open to large numbers of students.'),
        ('Which technology is essential for live online classes?',
         ARRAY['Video conferencing software (Zoom, Teams, etc.)', 'Email', 'Text messaging', 'Radio'], 0,
         'Video conferencing enables real‑time interaction.'),
        ('What is asynchronous learning?',
         ARRAY['Learning where students access materials and complete assignments at their own pace', 'Learning where everyone meets at the same time', 'Learning without any schedule', 'Learning with no assignments'], 0,
         'Asynchronous learning does not require simultaneous attendance.'),
        ('What is synchronous learning?',
         ARRAY['Learning that happens in real‑time with live instruction', 'Learning with no live component', 'Learning pre‑recorded', 'Learning at your own pace'], 0,
         'Synchronous learning often uses live video sessions.'),
        ('Which feature is common in online learning platforms?',
         ARRAY['Discussion forums, quizzes, and progress tracking', 'Only video playback', 'Only text materials', 'No interaction'], 0,
         'Learning Management Systems (LMS) offer these features.'),
        ('What is the role of a learning management system (LMS)?',
         ARRAY['To manage course content, assignments, and student records', 'To make videos only', 'To conduct exams only', 'To facilitate chats'], 0,
         'LMS platforms like Canvas, Moodle, and Blackboard are widely used.'),
        ('Which is a common challenge of online learning?',
         ARRAY['Lack of face‑to‑face interaction and self‑motivation issues', 'Too much interaction', 'No internet required', 'Easy for everyone'], 0,
         'Online learning requires self‑discipline and good internet access.'),
        ('What is a "hybrid" or "blended" learning model?',
         ARRAY['Combining online and in‑person instruction', 'Only online', 'Only in‑person', 'Using only textbooks'], 0,
         'Hybrid learning blends the best of both worlds.'),
        ('Which organisation offers many free certificates through online learning?',
         ARRAY['Google, Microsoft, and various MOOC providers', 'Only universities', 'Only governments', 'Only private companies'], 0,
         'Many tech companies offer free certification courses.'),
        ('What is the purpose of a discussion forum in online learning?',
         ARRAY['To facilitate peer interaction and Q&A', 'To submit assignments', 'To take exams', 'To download materials'], 0,
         'Forums build community and help clarify doubts.'),
        ('What is micro‑learning?',
         ARRAY['Short, focused learning modules', 'Long lectures', 'Learning without breaks', 'Learning only on weekends'], 0,
         'Micro‑learning is popular for busy professionals.'),
        ('Which technology helps in proctoring online exams?',
         ARRAY['AI‑based proctoring software that monitors student behaviour', 'No proctoring', 'In‑person proctoring only', 'Written exams only'], 0,
         'Online proctoring uses camera and screen monitoring.'),
        ('What is the future trend in online learning?',
         ARRAY['Personalised learning paths using AI and adaptive technologies', 'No change from current methods', 'More traditional lectures', 'Less interaction'], 0,
         'AI personalisation is a growing trend.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_online, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;

        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;

        SELECT id INTO correct_opt_id FROM question_options
        WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ========================================================================
    -- 5. EXAMS (14 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the purpose of formative assessment?',
         ARRAY['To monitor student learning and provide ongoing feedback', 'To assign final grades', 'To rank students', 'To standardize education'], 0,
         'Formative assessment helps improve learning during the course.'),
        ('What is the purpose of summative assessment?',
         ARRAY['To evaluate student learning at the end of a unit or course', 'To give feedback during learning', 'To plan future lessons', 'To decide on teaching methods'], 0,
         'Summative assessments (like final exams) measure overall achievement.'),
        ('What is a standardized test?',
         ARRAY['A test administered and scored in a consistent manner', 'A test that is different for each student', 'A test given only in one country', 'A test with no correct answers'], 0,
         'Standardized tests allow comparison across populations.'),
        ('Which exam is widely used for university admissions in the US?',
         ARRAY['SAT or ACT', 'GRE', 'GMAT', 'TOEFL'], 0,
         'The SAT and ACT are common undergraduate admissions tests.'),
        ('What is the "IB Diploma"?',
         ARRAY['International Baccalaureate diploma, a rigorous pre‑university programme', 'A professional certification', 'A language test', 'A vocational qualification'], 0,
         'The IB Diploma is recognised worldwide for university admission.'),
        ('What is the purpose of a "pop quiz"?',
         ARRAY['An unannounced short test to assess understanding and encourage regular study', 'A final exam', 'A project', 'A practical assessment'], 0,
         'Pop quizzes are formative and encourage consistent learning.'),
        ('Which test evaluates English proficiency for non‑native speakers?',
         ARRAY['TOEFL or IELTS', 'GRE', 'GMAT', 'SAT'], 0,
         'TOEFL and IELTS are the most common English proficiency tests.'),
        ('What is a "multiple‑choice" question?',
         ARRAY['A question with several pre‑selected answer options, typically one correct', 'A question with only one answer', 'A question requiring a long written response', 'A question that is open‑ended'], 0,
         'Multiple‑choice questions are common in standardized exams.'),
        ('What is the purpose of a "midterm" exam?',
         ARRAY['To assess student progress halfway through a course', 'To give a final grade', 'To test only the first week''s material', 'To replace the final exam'], 0,
         'Midterms cover the first half of course content.'),
        ('Which factor most influences exam performance?',
         ARRAY['Preparation, study habits, and test‑taking strategies', 'Luck alone', 'Natural intelligence only', 'Prior knowledge of the topic'], 0,
         'Preparation and strategies greatly affect outcomes.'),
        ('What is "exam anxiety"?',
         ARRAY['Stress and nervousness experienced before or during an exam', 'A sign of intelligence', 'A disease', 'A lack of preparation'], 0,
         'Exam anxiety can affect performance.'),
        ('What is the purpose of a "portfolio" assessment?',
         ARRAY['A collection of student work showing progress and achievement over time', 'A single test score', 'A final exam', 'A teacher evaluation'], 0,
         'Portfolios provide a holistic view of learning.'),
        ('Which organisation administers the PISA test?',
         ARRAY['OECD (Organisation for Economic Co‑operation and Development)', 'UNESCO', 'World Bank', 'UNICEF'], 0,
         'PISA is conducted by the OECD.'),
        ('What is the typical scoring range for the SAT?',
         ARRAY['400 to 1600 (combined)', '200 to 800 (each section)', '1 to 100', '0 to 100%'], 0,
         'The SAT combines evidence‑based reading and writing (200‑800) and math (200‑800).')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_exams, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;

        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;

        SELECT id INTO correct_opt_id FROM question_options
        WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ========================================================================
    -- 6. SCHOLARSHIPS (14 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is a scholarship?',
         ARRAY['Financial aid awarded to students to support their education, based on merit or need', 'A loan', 'A salary for studying', 'A grant for research'], 0,
         'Scholarships do not require repayment.'),
        ('What is the difference between a scholarship and a grant?',
         ARRAY['Scholarships are often merit‑based; grants are often need‑based', 'They are the same', 'Grants are always for research', 'Scholarships are for graduate students only'], 0,
         'The terms are sometimes used interchangeably, but grants are typically need‑based.'),
        ('Which is a common criterion for academic scholarships?',
         ARRAY['High GPA and standardized test scores', 'Financial need only', 'Athletic ability only', 'Country of origin'], 0,
         'Academic scholarships reward academic achievement.'),
        ('What is a "full‑ride" scholarship?',
         ARRAY['A scholarship that covers tuition, fees, room, board, and books', 'A scholarship that covers tuition only', 'A scholarship that covers housing only', 'A scholarship that requires repayment'], 0,
         'Full‑ride scholarships cover all expenses.'),
        ('Which organisation offers the prestigious Rhodes Scholarship?',
         ARRAY['The Rhodes Trust (for study at Oxford)', 'Fulbright Commission', 'Chevening', 'DAAD'], 0,
         'The Rhodes Scholarship is one of the oldest international scholarships.'),
        ('What is the Fulbright Program?',
         ARRAY['A US government programme that funds international educational exchange', 'A scholarship for US students only', 'A scholarship for non‑US citizens only', 'A sports scholarship'], 0,
         'Fulbright supports study, research, and teaching abroad.'),
        ('What is the Chevening Scholarship?',
         ARRAY['A UK government scholarship for international students to study in the UK', 'A US government scholarship', 'A scholarship for UK students abroad', 'A European scholarship'], 0,
         'Chevening is funded by the UK Foreign Office.'),
        ('What is a "need‑based" scholarship?',
         ARRAY['A scholarship awarded based on financial need', 'A scholarship based on academic merit', 'A scholarship based on athletic ability', 'A scholarship based on community service'], 0,
         'Need‑based aid helps students from low‑income families.'),
        ('What is the deadline for most scholarship applications?',
         ARRAY['Varies, but often months before the academic year starts', 'The day school starts', 'Any time during the year', 'Only in December'], 0,
         'Deadlines vary widely, but early application is recommended.'),
        ('Which scholarship is for women in STEM fields?',
         ARRAY['SWE (Society of Women Engineers) scholarships and AAUW', 'Rhodes', 'Fulbright', 'Chevening'], 0,
         'Many organisations support women in STEM.'),
        ('What is a "merit" scholarship?',
         ARRAY['A scholarship awarded for outstanding academic, artistic, or athletic achievement', 'A scholarship based on financial need', 'A scholarship for minority groups', 'A scholarship for international students'], 0,
         'Merit scholarships reward excellence.'),
        ('What is the role of the Free Application for Federal Student Aid (FAFSA) in the US?',
         ARRAY['To determine eligibility for federal and institutional need‑based aid', 'To apply for scholarships only', 'To apply for admission', 'To register for exams'], 0,
         'FAFSA is required for federal student aid.'),
        ('Which scholarship is offered by the Gates Foundation?',
         ARRAY['Gates Millennium Scholars (for US students)', 'Gates Cambridge', 'Both', 'Neither'], 2,
         'The Gates Foundation supports several scholarship programmes.'),
        ('What is the typical content of a scholarship application?',
         ARRAY['Personal statement, transcripts, letters of recommendation, and sometimes interviews', 'Only a test score', 'Only an essay', 'Only financial documents'], 0,
         'Applications are multi‑faceted.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_scholarships, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;

        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;

        SELECT id INTO correct_opt_id FROM question_options
        WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ========================================================================
    -- 7. TEACHING METHODS (14 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the traditional "lecture" method?',
         ARRAY['A teacher‑centred presentation of information to a large group', 'A student‑centred discussion', 'A practical hands‑on activity', 'A group project'], 0,
         'Lectures are common in higher education and large classes.'),
        ('What is "active learning"?',
         ARRAY['Learning that involves student participation, discussion, and problem‑solving', 'Passive listening', 'Only reading', 'Only watching videos'], 0,
         'Active learning engages students in the learning process.'),
        ('What is the "flipped classroom" model?',
         ARRAY['Students learn content at home (via videos) and practice in class', 'Teachers lecture at home and students practice in class', 'The entire class is online', 'No homework'], 0,
         'The flipped classroom reverses traditional lecture and homework.'),
        ('What is "project‑based learning" (PBL)?',
         ARRAY['Students learn through the completion of a meaningful project', 'Learning through lectures only', 'Learning through tests only', 'Learning through field trips'], 0,
         'PBL develops critical thinking and collaboration.'),
        ('What is the role of technology in modern teaching?',
         ARRAY['To enhance learning with tools like computers, tablets, and educational software', 'To replace teachers', 'To create distractions', 'To reduce costs'], 0,
         'Technology is a tool to support and enrich education.'),
        ('What is "differentiated instruction"?',
         ARRAY['Tailoring teaching to meet the different learning needs of students', 'Teaching the same way to all students', 'Only teaching advanced students', 'Only teaching struggling students'], 0,
         'Differentiation addresses diverse learners in the same classroom.'),
        ('What is the "Socratic method"?',
         ARRAY['A teaching approach using questioning to stimulate critical thinking', 'A lecture style', 'A group project method', 'A demonstration method'], 0,
         'The Socratic method is used in law and philosophy.'),
        ('What is "cooperative learning"?',
         ARRAY['Students work together in small groups to achieve a common goal', 'Students work individually', 'Students compete with each other', 'Students listen to a lecture'], 0,
         'Cooperative learning develops teamwork and communication.'),
        ('What is the purpose of classroom management?',
         ARRAY['To create an orderly environment conducive to learning', 'To maintain strict discipline only', 'To punish misbehaviour', 'To allow chaos'], 0,
         'Effective classroom management promotes positive learning.'),
        ('What is "scaffolding" in teaching?',
         ARRAY['Providing temporary support to help students master a new skill, then removing it', 'Providing no support', 'Giving answers directly', 'Making learning harder'], 0,
         'Scaffolding is like a construction scaffold – temporary support.'),
        ('What is "assessment for learning"?',
         ARRAY['Using assessment to guide instruction and improve student learning', 'Using assessment only for grades', 'Final exams only', 'Pop quizzes only'], 0,
         'Formative assessment is assessment for learning.'),
        ('Which approach is emphasised in early childhood education?',
         ARRAY['Play‑based learning and exploration', 'Rote memorisation', 'Long lectures', 'Heavy homework'], 0,
         'Play is central to developmentally appropriate practice.'),
        ('What is "inquiry‑based learning"?',
         ARRAY['Students learn by asking questions and conducting investigations', 'Students are given all answers', 'Students memorise facts', 'Students only read textbooks'], 0,
         'Inquiry stimulates curiosity and deeper understanding.'),
        ('What is the role of feedback in teaching?',
         ARRAY['To help students understand their strengths and areas for improvement', 'To assign grades only', 'To praise students only', 'To criticise students'], 0,
         'Effective feedback is specific and constructive.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_teaching, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;

        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;

        SELECT id INTO correct_opt_id FROM question_options
        WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

END $$;