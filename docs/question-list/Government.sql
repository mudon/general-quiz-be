-- ============================================================================
-- INSERT 200 GOVERNMENT TRIVIA QUESTIONS (Global Focus)
-- ============================================================================
-- Covers: Executive, Legislature, Judiciary, Constitutions, Ministries,
-- Public Administration, Elections, Voting Systems, Political Parties,
-- Public Policy, Civil Service.
-- All questions are factual, non‑sensitive, and include many countries.
-- ============================================================================

DO $$
DECLARE
    cat_id BIGINT;
    q_id   BIGINT;
    correct_opt_id BIGINT;
    opt_texts TEXT[];
    q_rec RECORD;
BEGIN

    -- ------------------------------------------------------------------------
    -- 1. Ensure category tree exists
    -- ------------------------------------------------------------------------
    INSERT INTO categories (path, name, icon, tier, sort_order)
    VALUES
        ('government', 'Government', '🏛', 3, 0),
        ('government.executive_branch', 'Executive Branch', NULL, 3, 1),
        ('government.legislature', 'Legislature', NULL, 3, 2),
        ('government.judiciary', 'Judiciary', NULL, 0, 3),
        ('government.constitutions', 'Constitutions', NULL, 3, 4),
        ('government.ministries', 'Ministries', NULL, 3, 5),
        ('government.public_administration', 'Public Administration', NULL, 3, 6),
        ('government.elections', 'Elections', NULL, 0, 7),
        ('government.voting_systems', 'Voting Systems', NULL, 3, 8),
        ('government.political_parties', 'Political Parties', NULL, 3, 9),
        ('government.public_policy', 'Public Policy', NULL, 3, 10),
        ('government.civil_service', 'Civil Service', NULL, 3, 11)
    ON CONFLICT (path) DO NOTHING;

    -- ------------------------------------------------------------------------
    -- 2. Insert 200 questions across all sub‑categories
    -- ------------------------------------------------------------------------

    -- ==================== EXECUTIVE BRANCH (20) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'government.executive_branch';
    FOR q_rec IN (
        VALUES
        ('In a parliamentary system, who is usually the head of government?', ARRAY['Prime Minister', 'President', 'Chancellor', 'Monarch'], 0, 'The Prime Minister leads the government in most parliamentary democracies.'),
        ('Which country has a semi‑presidential system with both a President and a Prime Minister?', ARRAY['France', 'USA', 'UK', 'China'], 0, 'France has a directly elected President and a Prime Minister accountable to parliament.'),
        ('What is the term length for the President of Brazil?', ARRAY['4 years', '5 years', '6 years', '3 years'], 0, 'The Brazilian president serves a four‑year term.'),
        ('Who is the head of state in the United Kingdom?', ARRAY['The Monarch', 'The Prime Minister', 'The Speaker', 'The Lord Chancellor'], 0, 'The British monarch is the ceremonial head of state.'),
        ('What is the title of the head of government in Germany?', ARRAY['Chancellor', 'President', 'Prime Minister', 'Premier'], 0, 'The Chancellor is the head of government in Germany.'),
        ('What is the executive branch’s power to reject legislation called?', ARRAY['Veto', 'Override', 'Filibuster', 'Cloture'], 0, 'A veto is the executive’s authority to block a bill.'),
        ('Who appoints the Prime Minister of India?', ARRAY['The President', 'The Parliament', 'The People', 'The Supreme Court'], 0, 'The President of India appoints the Prime Minister, usually the leader of the majority party.'),
        ('What is the term length for the President of Russia?', ARRAY['6 years', '4 years', '5 years', '7 years'], 0, 'The Russian president serves a six‑year term.'),
        ('What is the executive body of the European Union?', ARRAY['European Commission', 'European Parliament', 'Council of the EU', 'European Council'], 0, 'The Commission proposes and implements EU policies.'),
        ('In the US, who is third in the line of presidential succession?', ARRAY['President pro tempore of the Senate', 'Speaker of the House', 'Secretary of State', 'Vice President'], 0, 'After VP and Speaker, the President pro tempore is third.'),
        ('Which country’s executive is collectively known as the ''Federal Council''?', ARRAY['Switzerland', 'Austria', 'Germany', 'Belgium'], 0, 'Switzerland has a seven‑member Federal Council.'),
        ('What is the primary role of the executive branch in a presidential system?', ARRAY['Enforce laws', 'Make laws', 'Interpret laws', 'Review laws'], 0, 'The executive is responsible for enforcing legislation.'),
        ('How often are general elections held for the Prime Minister in Japan?', ARRAY['Every 4 years', 'Every 5 years', 'Every 3 years', 'At the PM’s discretion'], 0, 'Japan’s House of Representatives elections are held every four years (can be earlier).'),
        ('Who is the head of government in Australia?', ARRAY['Prime Minister', 'Governor‑General', 'President', 'Chancellor'], 0, 'Australia’s head of government is the Prime Minister.'),
        ('What is the executive order?', ARRAY['A directive issued by the head of government', 'A law passed by parliament', 'A court ruling', 'A treaty'], 0, 'Executive orders direct government agencies.'),
        ('Which country has a President who is both head of state and head of government?', ARRAY['United States', 'India', 'Germany', 'United Kingdom'], 0, 'In the US, the President is both head of state and government.'),
        ('What is the cabinet in a parliamentary system?', ARRAY['A group of senior ministers', 'A legislative committee', 'A judicial panel', 'A civil service board'], 0, 'The cabinet is composed of government ministers who lead departments.'),
        ('Who is the commander‑in‑chief of the Canadian Armed Forces?', ARRAY['The Monarch', 'The Prime Minister', 'The Governor‑General', 'The Chief of Defence Staff'], 0, 'The British monarch, represented by the Governor‑General, is the formal commander‑in‑chief.'),
        ('What is the term length for the President of South Africa?', ARRAY['5 years', '4 years', '6 years', '7 years'], 0, 'The South African President serves a five‑year term.'),
        ('What is the ''reserve power'' of the executive in some Westminster systems?', ARRAY['Power to dissolve parliament', 'Power to veto legislation', 'Power to amend the constitution', 'Power to appoint judges'], 0, 'Reserve powers include dissolving parliament or appointing a prime minister.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;
        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;
        SELECT id INTO correct_opt_id FROM question_options WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ==================== LEGISLATURE (20) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'government.legislature';
    FOR q_rec IN (
        VALUES
        ('What is a bicameral legislature?', ARRAY['Two chambers', 'One chamber', 'Three chambers', 'Four chambers'], 0, 'Bicameral means having two houses (e.g., upper and lower).'),
        ('What is the lower house of the UK Parliament called?', ARRAY['House of Commons', 'House of Lords', 'National Assembly', 'Senate'], 0, 'The House of Commons is the elected lower chamber.'),
        ('How many members are in the United States Senate?', ARRAY['100', '435', '535', '50'], 0, 'Each state has two senators, totaling 100.'),
        ('What is the term length for members of the German Bundestag?', ARRAY['4 years', '5 years', '6 years', '3 years'], 0, 'Bundestag members serve a four‑year term.'),
        ('What is the upper house of the Indian Parliament called?', ARRAY['Rajya Sabha', 'Lok Sabha', 'Vidhan Sabha', 'Council of States'], 0, 'Rajya Sabha is the upper house (Council of States).'),
        ('Which country has a unicameral legislature?', ARRAY['China', 'USA', 'UK', 'Germany'], 0, 'China’s National People’s Congress is unicameral.'),
        ('What is the primary function of the legislature?', ARRAY['Make laws', 'Enforce laws', 'Interpret laws', 'Adjudicate disputes'], 0, 'Legislatures pass, amend, and repeal laws.'),
        ('Who is the presiding officer of the US House of Representatives?', ARRAY['Speaker of the House', 'Majority Leader', 'President pro tempore', 'Vice President'], 0, 'The Speaker is elected by the House members.'),
        ('What is the minimum age to be a member of the Australian House of Representatives?', ARRAY['18', '21', '25', '30'], 0, 'Candidates must be at least 18 years old.'),
        ('What is the process of redrawing electoral district boundaries called?', ARRAY['Redistricting', 'Gerrymandering', 'Apportionment', 'Reapportionment'], 0, 'Redistricting is the drawing of new district lines.'),
        ('How many members are in the French National Assembly?', ARRAY['577', '348', '435', '600'], 0, 'The National Assembly has 577 deputies.'),
        ('What is the upper house of the Japanese Diet called?', ARRAY['House of Councillors', 'House of Representatives', 'Senate', 'Chamber of Peers'], 0, 'The House of Councillors is Japan’s upper house.'),
        ('What is the term length for a US House of Representatives member?', ARRAY['2 years', '4 years', '6 years', '8 years'], 0, 'House members are elected every two years.'),
        ('In a parliamentary system, what happens if the government loses a confidence vote?', ARRAY['The government must resign', 'The legislature is dissolved', 'The election is postponed', 'The judiciary intervenes'], 0, 'A loss of confidence usually forces the government to resign or call an election.'),
        ('What is the lower house of Russia’s parliament called?', ARRAY['State Duma', 'Federation Council', 'National Assembly', 'Congress'], 0, 'The State Duma is Russia’s lower house.'),
        ('Who is the President of the Indian Lok Sabha?', ARRAY['Speaker', 'Vice President', 'Prime Minister', 'Chief Justice'], 0, 'The Lok Sabha has a Speaker who presides over proceedings.'),
        ('What is a private member’s bill?', ARRAY['A bill introduced by a non‑minister', 'A bill introduced by the government', 'A bill for private companies', 'A bill for local councils'], 0, 'Private member’s bills are introduced by individual members of parliament.'),
        ('Which country’s legislature is called the Federal Assembly?', ARRAY['Switzerland', 'Germany', 'Brazil', 'Canada'], 0, 'The Swiss Federal Assembly is the country’s bicameral legislature.'),
        ('What is the term for delaying a bill through prolonged speaking?', ARRAY['Filibuster', 'Cloture', 'Gerrymander', 'Veto'], 0, 'A filibuster is a tactic to delay legislation.'),
        ('How many electoral divisions (seats) are in the UK House of Commons?', ARRAY['650', '435', '577', '543'], 0, 'The UK House of Commons has 650 seats (as of the 2024 boundary review).')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;
        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;
        SELECT id INTO correct_opt_id FROM question_options WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ==================== JUDICIARY (20) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'government.judiciary';
    FOR q_rec IN (
        VALUES
        ('What is the highest court in the United States?', ARRAY['Supreme Court', 'Court of Appeals', 'District Court', 'Circuit Court'], 0, 'The Supreme Court is the highest federal court.'),
        ('How many justices serve on the US Supreme Court?', ARRAY['9', '7', '11', '13'], 0, 'There are nine justices, including the Chief Justice.'),
        ('What is the highest court in the United Kingdom?', ARRAY['Supreme Court of the UK', 'House of Lords', 'Privy Council', 'Court of Appeal'], 0, 'The UK Supreme Court is the final court of appeal.'),
        ('What is the term for the power of courts to declare laws unconstitutional?', ARRAY['Judicial review', 'Habeas corpus', 'Stare decisis', 'Certiorari'], 0, 'Judicial review allows courts to invalidate laws contrary to the constitution.'),
        ('Which country operates under a civil law system (as opposed to common law)?', ARRAY['France', 'England', 'Australia', 'Canada'], 0, 'France follows the civil law tradition based on codes.'),
        ('What is the minimum age for a US Supreme Court justice?', ARRAY['No constitutional minimum', '30', '35', '40'], 0, 'The US Constitution does not specify a minimum age.'),
        ('What is the highest court in Australia?', ARRAY['High Court of Australia', 'Supreme Court', 'Federal Court', 'Court of Appeal'], 0, 'The High Court is the ultimate court of appeal.'),
        ('What is the writ that protects against unlawful detention?', ARRAY['Habeas corpus', 'Certiorari', 'Mandamus', 'Prohibition'], 0, 'Habeas corpus requires a court to review the legality of detention.'),
        ('How long do federal judges in the US serve?', ARRAY['Life', '10 years', '15 years', '20 years'], 0, 'Federal judges serve during good behaviour, effectively life.'),
        ('What is the highest court in India?', ARRAY['Supreme Court of India', 'High Court', 'District Court', 'Tribunal'], 0, 'The Supreme Court of India is the apex court.'),
        ('What is the doctrine of ''stare decisis''?', ARRAY['Stand by previous decisions', 'Stand by the constitution', 'Stand by the legislature', 'Stand by the executive'], 0, 'Stare decisis means courts follow precedents.'),
        ('Which country has a separate constitutional court?', ARRAY['Germany', 'USA', 'UK', 'Canada'], 0, 'Germany’s Federal Constitutional Court is separate from ordinary courts.'),
        ('What is the minimum number of judges required to hear a case in the US Supreme Court (quorum)?', ARRAY['6', '5', '4', '9'], 0, 'A quorum of six justices is needed for a case.'),
        ('What is the highest court in Brazil?', ARRAY['Supreme Federal Court', 'Superior Court of Justice', 'Federal Court', 'Constitutional Court'], 0, 'The Supreme Federal Court is Brazil’s highest court.'),
        ('What is the primary role of the judiciary?', ARRAY['Interpret and apply the law', 'Make laws', 'Enforce laws', 'Administer elections'], 0, 'The judiciary interprets the law in individual cases.'),
        ('What is the term for a panel of appellate judges?', ARRAY['Bench', 'Jury', 'Panel', 'Chamber'], 0, 'Appeals are often heard by a panel of judges.'),
        ('Which court is the highest in the European Union legal order?', ARRAY['Court of Justice of the EU', 'General Court', 'European Court of Human Rights', 'Federal Court'], 0, 'The CJEU is the highest EU court.'),
        ('What is the age of retirement for UK Supreme Court justices?', ARRAY['70', '65', '75', '80'], 0, 'UK Supreme Court justices retire at age 70.'),
        ('What is judicial independence?', ARRAY['Judges are free from outside influence', 'Judges are elected', 'Judges serve short terms', 'Judges can be removed by the executive'], 0, 'Independent judges make decisions based on law, not political pressure.'),
        ('Which country’s highest court is called the ''Constitutional Court''?', ARRAY['South Africa', 'USA', 'UK', 'Japan'], 0, 'South Africa has a Constitutional Court as its highest court for constitutional matters.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;
        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;
        SELECT id INTO correct_opt_id FROM question_options WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ==================== CONSTITUTIONS (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'government.constitutions';
    FOR q_rec IN (
        VALUES
        ('What is the oldest written constitution still in effect?', ARRAY['US Constitution', 'UK Magna Carta', 'San Marino Constitution', 'French Constitution'], 0, 'The US Constitution (ratified 1788) is the oldest codified constitution.'),
        ('What is the supreme law of the land in the US?', ARRAY['The Constitution', 'Federal statutes', 'Executive orders', 'Common law'], 0, 'The Constitution is the highest legal authority.'),
        ('How many amendments does the US Constitution have?', ARRAY['27', '10', '15', '20'], 0, 'There have been 27 amendments to the US Constitution.'),
        ('What are the first ten amendments to the US Constitution called?', ARRAY['Bill of Rights', 'Articles of Confederation', 'Federalist Papers', 'Declaration'], 0, 'The Bill of Rights enumerates fundamental liberties.'),
        ('Which country has an uncodified (unwritten) constitution?', ARRAY['United Kingdom', 'Canada', 'New Zealand', 'All of the above'], 0, 'The UK, New Zealand, and Israel have uncodified constitutions.'),
        ('What is the principle of the separation of powers?', ARRAY['Dividing government into branches', 'Dividing power between federal and state', 'Dividing power between chambers', 'Dividing power between monarch and parliament'], 0, 'Separation of powers allocates functions to legislative, executive, and judicial branches.'),
        ('What is a federal constitution?', ARRAY['Dividing power between national and regional governments', 'Unitary system', 'Confederation', 'Oligarchy'], 0, 'Federalism shares sovereignty between central and constituent units.'),
        ('What is the Preamble to the US Constitution?', ARRAY['An introductory statement of purpose', 'A list of amendments', 'The Bill of Rights', 'A conclusion'], 0, 'The preamble sets out the objectives of the government.'),
        ('What is the length of the Indian Constitution (approx. words)?', ARRAY['Over 140,000 words', '7,500 words', '50,000 words', '10,000 words'], 0, 'India’s is the longest constitution in the world.'),
        ('What is a constitutional monarchy?', ARRAY['A monarch with limited powers under a constitution', 'A monarch with absolute powers', 'An elected monarch', 'A republic with a ceremonial president'], 0, 'In a constitutional monarchy, the monarch’s role is defined and restricted by law.'),
        ('What is the amendment process in the US?', ARRAY['2/3 of Congress + 3/4 of states', 'Simple majority of Congress', '2/3 of states only', 'Presidential signature'], 0, 'Article V requires supermajorities at both federal and state levels.'),
        ('What is the fundamental principle of popular sovereignty?', ARRAY['Government derives power from the people', 'Power derives from the monarch', 'Power derives from the military', 'Power derives from the courts'], 0, 'Popular sovereignty places ultimate authority in the hands of the people.'),
        ('Which country’s constitution includes a ''Charter of Rights and Freedoms''?', ARRAY['Canada', 'Australia', 'New Zealand', 'USA'], 0, 'The Canadian Charter of Rights and Freedoms is part of the Constitution Act, 1982.'),
        ('What is the Bill of Rights in the US context?', ARRAY['The first ten amendments', 'The entire constitution', 'A declaration of independence', 'A treaty with England'], 0, 'The Bill of Rights protects individual liberties against government infringement.'),
        ('Which country has the shortest written constitution?', ARRAY['Monaco', 'United States', 'India', 'France'], 0, 'Monaco’s constitution is one of the shortest.'),
        ('What is the supreme law in the United Kingdom?', ARRAY['Acts of Parliament', 'The Magna Carta', 'The Bill of Rights 1689', 'Common law'], 0, 'In the UK, parliamentary sovereignty means Acts of Parliament are supreme.'),
        ('What is the concept of ''convention'' in constitutional law?', ARRAY['Unwritten practices and norms', 'Written amendments', 'Treaties', 'Judicial rulings'], 0, 'Constitutional conventions are unwritten rules followed by political actors.'),
        ('What is the structure of the German Basic Law (Grundgesetz)?', ARRAY['A codified constitution', 'An unwritten constitution', 'A royal charter', 'A treaty'], 0, 'The Basic Law is a fully codified constitution that serves as Germany’s supreme law.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;
        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;
        SELECT id INTO correct_opt_id FROM question_options WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ==================== MINISTRIES (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'government.ministries';
    FOR q_rec IN (
        VALUES
        ('What is a ministry in government?', ARRAY['A department with a specific policy portfolio', 'A legislative committee', 'A judicial chamber', 'An electoral commission'], 0, 'Ministries are administrative units responsible for specific policy areas.'),
        ('Which ministry typically handles foreign affairs?', ARRAY['Ministry of Foreign Affairs', 'Ministry of Interior', 'Ministry of Defence', 'Ministry of Finance'], 0, 'The foreign ministry conducts international relations.'),
        ('What is the UK equivalent of a ministry?', ARRAY['Department', 'Office', 'Agency', 'Commission'], 0, 'In the UK, ministries are often called departments (e.g., Home Office).'),
        ('Which ministry is responsible for taxation and revenue collection?', ARRAY['Ministry of Finance', 'Ministry of Revenue', 'Treasury', 'All of the above'], 0, 'Various names exist, but all handle fiscal matters.'),
        ('Who is the head of a ministry?', ARRAY['Minister', 'Secretary', 'Director', 'Commissioner'], 0, 'A minister (or secretary of state) leads a ministry.'),
        ('What does the Ministry of Health typically oversee?', ARRAY['Public health and healthcare', 'Environmental protection', 'Transportation', 'Agriculture'], 0, 'Health ministries manage healthcare systems and public health.'),
        ('Which ministry is responsible for internal security and law enforcement?', ARRAY['Ministry of Interior/Home', 'Ministry of Defence', 'Ministry of Justice', 'Ministry of Foreign Affairs'], 0, 'The interior ministry oversees police and domestic security.'),
        ('How many executive departments (ministries) does the US federal government have?', ARRAY['15', '20', '12', '18'], 0, 'There are 15 executive departments.'),
        ('What is the ministry of education responsible for?', ARRAY['Schools and education policy', 'Labour unions', 'Military training', 'Healthcare'], 0, 'Education ministries set curricula and fund schools.'),
        ('Which ministry handles national defence?', ARRAY['Ministry of Defence', 'Ministry of Interior', 'Ministry of Foreign Affairs', 'Ministry of Justice'], 0, 'The defence ministry oversees the armed forces.'),
        ('What is the equivalent of a ministry in Australia?', ARRAY['Department', 'Agency', 'Portfolio', 'Office'], 0, 'Australia uses the term ''department'' (e.g., Department of Defence).'),
        ('What is the term for the ministry that manages infrastructure and transport?', ARRAY['Ministry of Transport', 'Ministry of Public Works', 'Ministry of Infrastructure', 'All of the above'], 0, 'Various names but all handle transportation and infrastructure.'),
        ('Which ministry is responsible for environmental protection in many countries?', ARRAY['Ministry of Environment', 'Ministry of Energy', 'Ministry of Agriculture', 'Ministry of Health'], 0, 'Environment ministries focus on conservation and pollution control.'),
        ('What is the role of the Ministry of Foreign Affairs?', ARRAY['Manage diplomatic relations', 'Manage domestic security', 'Manage finance', 'Manage education'], 0, 'It conducts diplomacy and represents the country abroad.'),
        ('Who appoints the heads of ministries in a presidential system?', ARRAY['The President', 'The Legislature', 'The Judiciary', 'The People'], 0, 'The President appoints cabinet secretaries with (sometimes) legislative approval.'),
        ('What is the UK Home Office responsible for?', ARRAY['Immigration, security, and policing', 'Foreign affairs', 'Defence', 'Finance'], 0, 'The Home Office handles internal affairs, including immigration.'),
        ('What is a ministry of agriculture responsible for?', ARRAY['Farming and food production', 'Healthcare', 'Energy', 'Education'], 0, 'Agriculture ministries support farmers and ensure food security.'),
        ('In Germany, what is a ministry called?', ARRAY['Bundesministerium', 'Department', 'Office', 'Agency'], 0, 'German federal ministries are called Bundesministerium (e.g., Bundesministerium für Gesundheit).')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;
        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;
        SELECT id INTO correct_opt_id FROM question_options WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ==================== PUBLIC ADMINISTRATION (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'government.public_administration';
    FOR q_rec IN (
        VALUES
        ('What is public administration?', ARRAY['Implementation of government policy', 'Making laws', 'Interpreting laws', 'Election management'], 0, 'Public administration is the execution of public policy.'),
        ('What is a bureaucracy?', ARRAY['A system of non‑elected officials', 'A legislative body', 'A judicial body', 'A political party'], 0, 'Bureaucracy refers to the administrative machinery of government.'),
        ('What is the principle of meritocracy in civil service?', ARRAY['Appointment based on ability', 'Appointment based on political affiliation', 'Appointment by inheritance', 'Appointment by lottery'], 0, 'Meritocracy uses competitive exams and performance to select officials.'),
        ('What does the acronym ''SOP'' stand for in public administration?', ARRAY['Standard Operating Procedure', 'Senior Official Protocol', 'Statutory Order Process', 'Special Operations Plan'], 0, 'SOPs are detailed, written instructions for routine tasks.'),
        ('Which term describes the division of work into specialised tasks?', ARRAY['Specialisation', 'Standardisation', 'Centralisation', 'Decentralisation'], 0, 'Division of labour increases efficiency in large organisations.'),
        ('What is administrative law?', ARRAY['Law governing government agencies', 'Criminal law', 'Civil law', 'Constitutional law'], 0, 'Administrative law regulates the powers and procedures of administrative agencies.'),
        ('What is a public service delivery?', ARRAY['Providing government services to citizens', 'Making laws', 'Adjudicating disputes', 'Managing elections'], 0, 'It refers to the direct provision of services like healthcare, education, etc.'),
        ('What is the concept of ''accountability'' in public administration?', ARRAY['Officials must answer for their actions', 'Officials must be elected', 'Officials must be appointed', 'Officials must be neutral'], 0, 'Accountability ensures that public servants are answerable to the public.'),
        ('What is a government agency?', ARRAY['An administrative unit with specific functions', 'A legislative committee', 'A court', 'A political party'], 0, 'Agencies implement specific policies (e.g., EPA, FDA).'),
        ('What is the difference between centralisation and decentralisation?', ARRAY['Centralisation concentrates power; decentralisation disperses it', 'Centralisation disperses power; decentralisation concentrates it', 'They are the same', 'None of the above'], 0, 'Centralisation keeps decision‑making at the top; decentralisation delegates it.'),
        ('What is a ''policy cycle'' in public administration?', ARRAY['A model of policy stages (agenda, formulation, implementation, evaluation)', 'An election cycle', 'A budget cycle', 'A judicial cycle'], 0, 'The policy cycle describes the life of a policy from inception to review.'),
        ('What is the function of an ombudsman?', ARRAY['Investigate complaints against government', 'Prosecute criminals', 'Make laws', 'Adjudicate constitutional issues'], 0, 'Ombudsmen handle citizen grievances about administrative conduct.'),
        ('What is ''sunshine law''?', ARRAY['Law requiring open meetings and records', 'Law about renewable energy', 'Law about solar panels', 'Law about government budgets'], 0, 'Sunshine laws promote transparency by opening government proceedings.'),
        ('What is the ''spoils system''?', ARRAY['Appointing officials based on political loyalty', 'Appointing based on merit', 'Appointing based on elections', 'Appointing based on inheritance'], 0, 'The spoils system rewards supporters with government jobs.'),
        ('What is the core value of the New Public Management (NPM) movement?', ARRAY['Efficiency and customer orientation', 'Rule of law', 'Hierarchy', 'Central planning'], 0, 'NPM emphasises performance, efficiency, and treating citizens as customers.'),
        ('What is a public‑private partnership (PPP)?', ARRAY['Government and private sector jointly provide services', 'Government sells public assets', 'Private sector takes over government', 'Government becomes a private company'], 0, 'PPPs leverage private capital for public projects.'),
        ('What is the role of a city manager in council‑manager governments?', ARRAY['Chief administrative officer', 'Elected mayor', 'Chief judge', 'Police chief'], 0, 'The city manager is appointed to oversee daily administration.'),
        ('What is regulatory capture?', ARRAY['When regulatory agencies favour the industries they oversee', 'When regulators are captured by criminals', 'When agencies are abolished', 'When regulators are elected'], 0, 'Regulatory capture occurs when agencies are dominated by the interests they regulate.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;
        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;
        SELECT id INTO correct_opt_id FROM question_options WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ==================== ELECTIONS (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'government.elections';
    FOR q_rec IN (
        VALUES
        ('What is a general election?', ARRAY['An election for all seats in a legislature', 'An election for a single seat', 'An election for a local council', 'A by‑election'], 0, 'General elections fill all parliamentary seats.'),
        ('What is a by‑election?', ARRAY['An election to fill a vacant seat between general elections', 'A general election', 'A primary election', 'A referendum'], 0, 'By‑elections are held when a seat becomes vacant.'),
        ('What is the Electoral College in the United States?', ARRAY['A body of electors that formally elects the President', 'A college for studying elections', 'A congressional committee', 'A voting machine'], 0, 'The Electoral College is the constitutionally mandated process for electing the President.'),
        ('How many electoral votes are needed to win the US presidency?', ARRAY['270', '538', '435', '100'], 0, 'A candidate needs a majority of the 538 electoral votes (270).'),
        ('What is voter turnout?', ARRAY['The percentage of eligible voters who cast a ballot', 'The number of seats won', 'The number of candidates', 'The number of polling stations'], 0, 'Turnout measures participation in an election.'),
        ('What is a primary election?', ARRAY['An election to select a party’s candidate', 'A general election', 'A local election', 'A national referendum'], 0, 'Primaries decide which candidate runs for a party in the general election.'),
        ('Which country uses a compulsory voting system?', ARRAY['Australia', 'USA', 'UK', 'Canada'], 0, 'Australia has compulsory voting for all eligible citizens.'),
        ('What is an independent candidate?', ARRAY['A candidate not affiliated with a political party', 'A candidate from a major party', 'A candidate appointed by the government', 'A candidate from a coalition'], 0, 'Independent candidates run without party backing.'),
        ('What is the term length between federal elections in Australia?', ARRAY['3 years', '4 years', '5 years', '2 years'], 0, 'Australia’s House of Representatives has a maximum term of 3 years.'),
        ('What is a swing in election results?', ARRAY['A change in vote share from one election to another', 'A candidate switching parties', 'A judicial decision', 'A policy change'], 0, 'Swing measures the shift in support between parties.'),
        ('What is a landslide victory?', ARRAY['A decisive win by a large margin', 'A win by a narrow margin', 'A loss', 'A tied election'], 0, 'A landslide indicates overwhelming public support.'),
        ('What is the role of an election commission?', ARRAY['To oversee and administer elections', 'To create laws', 'To appoint judges', 'To run the government'], 0, 'Election commissions ensure free and fair elections.'),
        ('What is a referendum?', ARRAY['A direct vote on a specific policy or issue', 'A general election', 'A primary election', 'A by‑election'], 0, 'Referendums ask citizens to decide directly on a particular question.'),
        ('What is the voter registration process?', ARRAY['The procedure to enrol eligible voters on the electoral roll', 'The procedure to count votes', 'The procedure to nominate candidates', 'The procedure to conduct exit polls'], 0, 'Registration confirms that a citizen is eligible to vote.'),
        ('Which country has the oldest continuous national election?', ARRAY['United Kingdom', 'United States', 'Sweden', 'Netherlands'], 0, 'The UK has held parliamentary elections since the 13th century (though modern form from 19th century).'),
        ('What is an election recount?', ARRAY['A re‑tallying of votes due to a close result', 'A new election', 'An appeal to court', 'A voter registration drive'], 0, 'Recounts are conducted when the margin is very narrow.'),
        ('What is an early election?', ARRAY['An election called before the scheduled date', 'An election held at the scheduled date', 'An election postponed', 'A local election'], 0, 'Early elections are often called by the government to secure a new mandate.'),
        ('What is the voting age in most countries?', ARRAY['18', '16', '21', '20'], 0, 'The vast majority of countries have a voting age of 18.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;
        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;
        SELECT id INTO correct_opt_id FROM question_options WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ==================== VOTING SYSTEMS (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'government.voting_systems';
    FOR q_rec IN (
        VALUES
        ('What is the First‑Past‑The‑Post (FPTP) system?', ARRAY['The candidate with the most votes wins', 'Candidates need 50%+1 to win', 'Voters rank candidates', 'Seats are awarded proportionally'], 0, 'FPTP is a plurality system used in the UK, US, and India.'),
        ('What is Proportional Representation (PR)?', ARRAY['Seats reflect the proportion of votes each party receives', 'The winner takes all', 'Voters rank candidates', 'A two‑round system'], 0, 'PR aims to match seat share to vote share.'),
        ('What is the Alternative Vote (AV) also known as?', ARRAY['Instant‑runoff voting', 'Single transferable vote', 'Party‑list PR', 'FPTP'], 0, 'AV uses ranked preferences to achieve a majority winner.'),
        ('Which country uses the Mixed‑Member Proportional (MMP) system?', ARRAY['Germany', 'USA', 'UK', 'France'], 0, 'Germany uses MMP, combining FPTP and PR.'),
        ('What is the Single Transferable Vote (STV) system?', ARRAY['Voters rank candidates; seats allocated proportionally in multi‑member districts', 'Voters choose one candidate', 'Voters choose one party', 'Voters approve or reject candidates'], 0, 'STV is used in Ireland and Malta.'),
        ('What is the Two‑Round system?', ARRAY['If no majority, a second runoff is held', 'Candidates need a plurality', 'Voters rank candidates', 'Seats are allocated proportionally'], 0, 'Used in France for presidential and parliamentary elections.'),
        ('What is a party‑list system?', ARRAY['Voters vote for a party, and seats are allocated based on party vote share', 'Voters vote for individual candidates', 'Voters rank candidates', 'A hybrid system'], 0, 'Party‑list PR is used in many European countries.'),
        ('What is the difference between open and closed party lists?', ARRAY['Open: voters can influence order; closed: order is fixed', 'Open: voters choose only party; closed: voters choose candidates', 'Open: closed to the public; closed: open to the public', 'No difference'], 0, 'Open lists allow voters to prefer candidates; closed lists use party‑determined order.'),
        ('Which system does the United Kingdom use for its general elections?', ARRAY['First‑Past‑The‑Post', 'Proportional Representation', 'Mixed‑Member Proportional', 'Alternative Vote'], 0, 'The UK uses FPTP for parliamentary elections.'),
        ('What is a ''quota'' in proportional representation?', ARRAY['The minimum number of votes needed for a party to win a seat', 'The number of seats in parliament', 'The number of candidates per party', 'The number of voters required to register'], 0, 'Quotas (e.g., Hare quota) determine seat allocation.'),
        ('What is the Electoral College system in the US?', ARRAY['Indirect election via electors', 'Direct popular vote', 'Ranked choice voting', 'Proportional representation'], 0, 'The Electoral College is a unique indirect voting system.'),
        ('Which country uses the Alternative Vote for its lower house?', ARRAY['Australia', 'UK', 'USA', 'France'], 0, 'Australia’s House of Representatives uses AV.'),
        ('What is the D’Hondt method?', ARRAY['A formula for allocating seats in PR', 'A type of electoral fraud', 'A voter registration system', 'A campaign finance method'], 0, 'The D’Hondt method is used in many PR systems.'),
        ('What is a ''threshold'' in proportional representation?', ARRAY['A minimum percentage of votes a party must get to enter parliament', 'The maximum number of seats a party can win', 'The number of voters needed', 'The number of candidates'], 0, 'Thresholds (e.g., 5%) prevent fragmentation.'),
        ('What is ''gerrymandering''?', ARRAY['Manipulating district boundaries for political advantage', 'Counting votes incorrectly', 'Voter suppression', 'Campaign finance abuse'], 0, 'Gerrymandering draws districts to favour a party.'),
        ('What is the Sainte‑Laguë method?', ARRAY['A seat allocation formula in PR', 'A type of primary election', 'A voter registration method', 'A campaign strategy'], 0, 'Sainte‑Laguë is used in countries like Norway and Sweden.'),
        ('What is the difference between a direct and indirect election?', ARRAY['Direct: voters elect directly; indirect: electors choose', 'Direct: by secret ballot; indirect: by open vote', 'Direct: for executive; indirect: for legislature', 'No difference'], 0, 'Direct elections are popular votes; indirect elections involve intermediaries.'),
        ('What is a ''runoff election''?', ARRAY['A second election between the top two candidates when no one gets a majority', 'An election held on the same day', 'A by‑election', 'A primary election'], 0, 'Runoffs ensure that the winner has a majority.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;
        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;
        SELECT id INTO correct_opt_id FROM question_options WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ==================== POLITICAL PARTIES (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'government.political_parties';
    FOR q_rec IN (
        VALUES
        ('What is a political party?', ARRAY['An organisation that seeks political power', 'A government agency', 'A court', 'A non‑profit charity'], 0, 'Parties are groups of people with shared political goals.'),
        ('What is a two‑party system?', ARRAY['Two major parties dominate', 'Only two parties exist', 'More than two parties', 'No parties'], 0, 'The US and UK are classic examples of two‑party systems.'),
        ('What is a multi‑party system?', ARRAY['Multiple parties compete, often forming coalitions', 'Two parties compete', 'One party dominates', 'No parties'], 0, 'Most European countries have multi‑party systems.'),
        ('What is the role of an opposition party?', ARRAY['To challenge and scrutinise the government', 'To support the government', 'To run the government', 'To appoint judges'], 0, 'The opposition holds the government accountable.'),
        ('What is a coalition government?', ARRAY['A government formed by two or more parties', 'A one‑party government', 'A military government', 'A caretaker government'], 0, 'Coalitions are common in multi‑party systems.'),
        ('What is the political spectrum?', ARRAY['A system to classify ideologies (left‑right)', 'A map of electoral districts', 'A list of candidates', 'A constitutional principle'], 0, 'The spectrum ranges from left (egalitarian) to right (traditional).'),
        ('What is a single‑party state?', ARRAY['Only one party is legally allowed', 'Multiple parties but one dominates', 'No parties', 'Two parties'], 0, 'China and Cuba are single‑party states.'),
        ('What is a party platform?', ARRAY['A set of principles and policy positions', 'A building', 'A leadership election', 'A fundraising event'], 0, 'Platforms outline what a party stands for.'),
        ('What is a ''third party'' in a two‑party system?', ARRAY['A party with minor influence', 'A major party', 'A ruling party', 'An illegal party'], 0, 'Third parties often have limited electoral success.'),
        ('Which party colour is typically associated with conservatism in many countries?', ARRAY['Blue', 'Red', 'Green', 'Yellow'], 0, 'In many (but not all) contexts, blue is for conservatives.'),
        ('What is a ''grassroots movement''?', ARRAY['A political effort driven by ordinary people', 'A top‑down initiative', 'A government programme', 'A parliamentary committee'], 0, 'Grassroots campaigns build support from the bottom up.'),
        ('What is a political party’s ''leadership election''?', ARRAY['An election to choose the party leader', 'A general election', 'A primary election', 'A referendum'], 0, 'Leadership elections are internal party processes.'),
        ('What is the main function of a party whip?', ARRAY['Ensuring party members vote according to party line', 'Fundraising', 'Writing policy', 'Managing campaigns'], 0, 'Whips maintain discipline and organise legislative business.'),
        ('Which country has a longstanding two‑party system?', ARRAY['United States', 'India', 'France', 'Germany'], 0, 'The US has historically been dominated by Democrats and Republicans.'),
        ('What is a party convention?', ARRAY['A large meeting of party members to set policy or nominate candidates', 'A court session', 'A parliamentary sitting', 'A referendum'], 0, 'Conventions are major party events.'),
        ('What is the ''left‑right'' political spectrum?', ARRAY['A way of classifying ideologies', 'A voting system', 'A type of coalition', 'A constitutional principle'], 0, 'Left typically favours social equality; right favours tradition and hierarchy.'),
        ('What is a coalition agreement?', ARRAY['A formal agreement between coalition parties on policy goals', 'A law passed by parliament', 'A judicial decision', 'A campaign promise'], 0, 'Coalition agreements govern the joint programme of a coalition government.'),
        ('What is the oldest political party in the world?', ARRAY['Democratic Party (US)', 'Conservative Party (UK)', 'Labour Party (UK)', 'Socialist Party (France)'], 0, 'The US Democratic Party traces its roots to the 1790s, but the Conservative Party (UK) also claims deep roots.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;
        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;
        SELECT id INTO correct_opt_id FROM question_options WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ==================== PUBLIC POLICY (16) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'government.public_policy';
    FOR q_rec IN (
        VALUES
        ('What is public policy?', ARRAY['A course of action taken by government', 'A private business decision', 'A personal opinion', 'A court ruling'], 0, 'Public policy is what governments decide to do or not do.'),
        ('What are the main stages of the policy cycle?', ARRAY['Agenda setting, formulation, adoption, implementation, evaluation', 'Election, appointment, dismissal', 'Arrest, trial, appeal', 'Budget, audit, review'], 0, 'The policy cycle is a standard model for analysis.'),
        ('What is evidence‑based policy?', ARRAY['Policy informed by research and data', 'Policy based on ideology', 'Policy based on public opinion', 'Policy based on tradition'], 0, 'Evidence‑based policy uses empirical findings.'),
        ('What is a ''white paper'' in policy?', ARRAY['A government document outlining policy proposals', 'A blank document', 'A constitution', 'A judicial opinion'], 0, 'White papers are formal policy statements.'),
        ('What is the difference between a policy and a law?', ARRAY['Policy is a guideline; law is legally enforceable', 'Policy is legally enforceable; law is a guideline', 'They are the same', 'Policy is international; law is domestic'], 0, 'Laws have legal force; policies guide decision‑making.'),
        ('What is a ''policy analysis''?', ARRAY['Evaluating policy options and impacts', 'Writing a law', 'Implementing a law', 'Adjudicating a case'], 0, 'Analysis assesses the costs and benefits of different policies.'),
        ('What is welfare policy?', ARRAY['Government programmes for social welfare', 'Defence policy', 'Foreign policy', 'Tax policy'], 0, 'Welfare policy includes healthcare, social security, and housing.'),
        ('What is fiscal policy?', ARRAY['Government taxation and spending', 'Monetary policy', 'Trade policy', 'Industrial policy'], 0, 'Fiscal policy uses budget measures to influence the economy.'),
        ('What is foreign policy?', ARRAY['A country’s strategy for international relations', 'Domestic policy', 'Economic policy', 'Environmental policy'], 0, 'Foreign policy governs how a country interacts with others.'),
        ('What is a policy evaluation?', ARRAY['Assessing the outcomes of a policy', 'Creating a policy', 'Implementing a policy', 'Repealing a policy'], 0, 'Evaluation determines if a policy is achieving its goals.'),
        ('What is regulatory policy?', ARRAY['Rules and standards set by government', 'International treaties', 'Tax rates', 'Public services'], 0, 'Regulatory policy covers health, safety, environmental, and economic standards.'),
        ('What is the ''policy window'' (Kingdon’s model)?', ARRAY['An opportunity to advocate for policy change', 'A closed decision‑making process', 'A budget cycle', 'An election period'], 0, 'The policy window occurs when problems, solutions, and politics align.'),
        ('What is distributive policy?', ARRAY['Allocating resources and benefits to groups', 'Redistributing wealth from rich to poor', 'Regulating behaviour', 'Handling foreign affairs'], 0, 'Distributive policies grant subsidies, tax breaks, or grants.'),
        ('What is redistributive policy?', ARRAY['Shifting wealth or benefits from one group to another', 'Allocating benefits equally', 'Regulating markets', 'Implementing treaties'], 0, 'Redistributive policies aim to reduce inequality (e.g., progressive tax).'),
        ('What is a policy ''stakeholder''?', ARRAY['A person or group affected by or interested in a policy', 'A government official', 'A politician', 'A judge'], 0, 'Stakeholders have a vested interest in policy outcomes.'),
        ('What is the concept of ''subsidiarity'' in policy?', ARRAY['Decisions should be made at the lowest competent level', 'Decisions should be made at the highest level', 'Decisions should be made by the courts', 'Decisions should be made by experts'], 0, 'Subsidiarity is a principle in EU policy and federalism.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;
        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;
        SELECT id INTO correct_opt_id FROM question_options WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    -- ==================== CIVIL SERVICE (16) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'government.civil_service';
    FOR q_rec IN (
        VALUES
        ('What is the civil service?', ARRAY['Permanent, professional government employees', 'Elected officials', 'Military personnel', 'Judges'], 0, 'Civil servants are non‑elected officials who implement policies.'),
        ('What is the principle of political neutrality in the civil service?', ARRAY['Civil servants serve the government of the day regardless of political affiliation', 'Civil servants must belong to the ruling party', 'Civil servants must vote for the ruling party', 'Civil servants cannot vote'], 0, 'Neutrality ensures continuity and professionalism.'),
        ('What is a civil service exam?', ARRAY['A competitive test for hiring civil servants', 'A test for elected officials', 'A judicial exam', 'A military exam'], 0, 'Exams are used to ensure merit‑based recruitment.'),
        ('What is the tenure of a typical civil servant in most countries?', ARRAY['Permanent and pensionable', 'Temporary for one term', 'Elected every 4 years', 'Appointed by the monarch'], 0, 'Civil servants typically have secure, career‑long positions.'),
        ('What is a ''permanent secretary'' in the UK civil service?', ARRAY['The most senior civil servant in a department', 'A junior official', 'An elected official', 'A political advisor'], 0, 'Permanent secretaries are the administrative heads of departments.'),
        ('What is the Senior Executive Service (SES) in the US?', ARRAY['A corps of top‑level civil servants', 'A military rank', 'A judicial position', 'An elected office'], 0, 'SES members are senior leaders in federal agencies.'),
        ('What is ''bureaucratic discretion''?', ARRAY['The freedom civil servants have to interpret and apply rules', 'A law passed by congress', 'An executive order', 'A court ruling'], 0, 'Discretion allows officials to make judgments in specific cases.'),
        ('What is the difference between a political appointee and a career civil servant?', ARRAY['Appointees serve at political will; career civil servants are permanent', 'Appointees are permanent; career civil servants are temporary', 'They are the same', 'Appointees are elected; career civil servants are appointed'], 0, 'Political appointees change with administration; career staff remain.'),
        ('What is the ''Spoils System'' in US history?', ARRAY['Appointing government jobs based on party loyalty', 'Appointing based on merit', 'Appointing based on exams', 'Appointing based on seniority'], 0, 'The spoils system was reformed after the Pendleton Act.'),
        ('Which act established the modern US civil service system?', ARRAY['Pendleton Civil Service Reform Act (1883)', 'Hatch Act', 'Civil Rights Act', 'Budget and Accounting Act'], 0, 'The Pendleton Act introduced merit‑based hiring.'),
        ('What is a ''code of conduct'' for civil servants?', ARRAY['Rules governing ethical behaviour and standards', 'A law for elections', 'A military code', 'A judicial code'], 0, 'Codes of conduct ensure integrity and accountability.'),
        ('What is the role of an ombudsman in relation to the civil service?', ARRAY['Investigating citizen complaints about administrative actions', 'Managing personnel', 'Creating policy', 'Adjudicating legal disputes'], 0, 'Ombudsmen are watchdogs for administrative fairness.'),
        ('What is ''delegated legislation''?', ARRAY['Rules made by civil servants under authority delegated by parliament', 'Laws passed by parliament', 'Judicial decisions', 'Constitutional amendments'], 0, 'Civil servants draft regulations and orders under enabling laws.'),
        ('What is the principle of ''ministerial responsibility''?', ARRAY['Ministers are answerable to parliament for their department’s actions', 'Civil servants are answerable to the public', 'Ministers are not accountable', 'Civil servants are elected'], 0, 'Ministers take political responsibility for their departments.'),
        ('What is the concept of ''accountability'' in civil service?', ARRAY['Civil servants are answerable for their actions and decisions', 'Civil servants are elected', 'Civil servants are immune from scrutiny', 'Civil servants can ignore the law'], 0, 'Accountability ensures transparency and trust.'),
        ('What is the typical path to becoming a senior civil servant in many countries?', ARRAY['Merit‑based promotion through competitive exams and performance', 'Political appointment', 'Inheritance', 'Election'], 0, 'Most senior civil servants rise through the ranks based on merit.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id, q_rec.column1, 'single_choice', q_rec.column4)
        RETURNING id INTO q_id;
        opt_texts := q_rec.column2;
        FOR i IN 0..3 LOOP
            INSERT INTO question_options (question_id, option_text, sort_order)
            VALUES (q_id, opt_texts[i+1], i);
        END LOOP;
        SELECT id INTO correct_opt_id FROM question_options WHERE question_id = q_id AND sort_order = q_rec.column3;
        INSERT INTO answers (question_id, single_choice_answer) VALUES (q_id, correct_opt_id);
    END LOOP;

    RAISE NOTICE '✅ 200 government questions inserted successfully.';
END $$;