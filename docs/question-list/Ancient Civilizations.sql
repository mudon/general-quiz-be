-- ============================================================================
-- Insert 200 factual questions on Ancient Civilizations.
-- Subtopics: Egypt, Rome, Greece, Persia, China, Maya, Aztec, Inca,
-- Mesopotamia, Indus Valley.
-- ============================================================================

DO $$
DECLARE
    cat_id_egypt          BIGINT;
    cat_id_rome           BIGINT;
    cat_id_greece         BIGINT;
    cat_id_persia         BIGINT;
    cat_id_china          BIGINT;
    cat_id_maya           BIGINT;
    cat_id_aztec          BIGINT;
    cat_id_inca           BIGINT;
    cat_id_mesopotamia    BIGINT;
    cat_id_indus          BIGINT;
    q_id                  BIGINT;
    correct_opt_id        BIGINT;
    opt_texts             TEXT[];
    q_rec                 RECORD;
BEGIN
    -- ------------------------------------------------------------------------
    -- Create categories (hierarchical under ancient_civilizations)
    -- ------------------------------------------------------------------------
    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('ancient_civilizations', 'Ancient Civilizations', 2, 0)
        ON CONFLICT (path) DO NOTHING;

    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('ancient_civilizations.egypt',          'Egypt', 2, 1),
        ('ancient_civilizations.rome',           'Rome', 2, 2),
        ('ancient_civilizations.greece',         'Greece', 2, 3),
        ('ancient_civilizations.persia',         'Persia', 2, 4),
        ('ancient_civilizations.china',          'China', 2, 5),
        ('ancient_civilizations.maya',           'Maya', 2, 6),
        ('ancient_civilizations.aztec',          'Aztec', 2, 7),
        ('ancient_civilizations.inca',           'Inca', 2, 8),
        ('ancient_civilizations.mesopotamia',    'Mesopotamia', 2, 9),
        ('ancient_civilizations.indus_valley',   'Indus Valley', 2, 10)
        ON CONFLICT (path) DO NOTHING;

    -- Get category IDs
    SELECT id INTO cat_id_egypt       FROM categories WHERE path = 'ancient_civilizations.egypt';
    SELECT id INTO cat_id_rome        FROM categories WHERE path = 'ancient_civilizations.rome';
    SELECT id INTO cat_id_greece      FROM categories WHERE path = 'ancient_civilizations.greece';
    SELECT id INTO cat_id_persia      FROM categories WHERE path = 'ancient_civilizations.persia';
    SELECT id INTO cat_id_china       FROM categories WHERE path = 'ancient_civilizations.china';
    SELECT id INTO cat_id_maya        FROM categories WHERE path = 'ancient_civilizations.maya';
    SELECT id INTO cat_id_aztec       FROM categories WHERE path = 'ancient_civilizations.aztec';
    SELECT id INTO cat_id_inca        FROM categories WHERE path = 'ancient_civilizations.inca';
    SELECT id INTO cat_id_mesopotamia FROM categories WHERE path = 'ancient_civilizations.mesopotamia';
    SELECT id INTO cat_id_indus       FROM categories WHERE path = 'ancient_civilizations.indus_valley';

    -- ========================================================================
    -- 1. EGYPT (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What river was the lifeblood of Ancient Egypt?',
         ARRAY['Nile', 'Tigris', 'Euphrates', 'Indus'], 0,
         'The Nile provided water, fertile soil, and transportation.'),
        ('Who is credited with uniting Upper and Lower Egypt?',
         ARRAY['Narmer (Menes)', 'Ramesses II', 'Hatshepsut', 'Tutankhamun'], 0,
         'Narmer is considered the first pharaoh of a unified Egypt, c. 3100 BCE.'),
        ('What is the Great Sphinx?',
         ARRAY['A monumental limestone statue with a lion body and human head', 'A pyramid', 'A temple', 'An obelisk'], 0,
         'The Great Sphinx of Giza stands near the pyramids.'),
        ('Which pharaoh built the largest pyramid at Giza?',
         ARRAY['Khufu (Cheops)', 'Khafre', 'Menkaure', 'Sneferu'], 0,
         'The Great Pyramid was built for Pharaoh Khufu.'),
        ('What is the ancient Egyptian writing system called?',
         ARRAY['Hieroglyphics', 'Cuneiform', 'Sanskrit', 'Linear A'], 0,
         'Hieroglyphics were a formal writing system combining logographic and alphabetic elements.'),
        ('What was the capital of Egypt during the Old Kingdom?',
         ARRAY['Memphis', 'Thebes', 'Alexandria', 'Heliopolis'], 0,
         'Memphis was the administrative and religious centre of the Old Kingdom.'),
        ('What is the "Book of the Dead"?',
         ARRAY['A collection of funerary spells and texts', 'A historical chronicle', 'A book of laws', 'A medical treatise'], 0,
         'These spells were intended to guide the dead through the underworld.'),
        ('Which female pharaoh ruled as a king?',
         ARRAY['Hatshepsut', 'Cleopatra VII', 'Nefertiti', 'Merneith'], 0,
         'Hatshepsut (c. 1479–1458 BCE) ruled as a full pharaoh.'),
        ('What was the Rosetta Stone?',
         ARRAY['A decree inscribed in three scripts that helped decipher hieroglyphs', 'A building stone', 'A jewelled amulet', 'A royal crown'], 0,
         'It featured Ancient Greek, Demotic, and Hieroglyphic scripts.'),
        ('What was the primary writing material for everyday use?',
         ARRAY['Papyrus', 'Parchment', 'Clay tablets', 'Silk'], 0,
         'Papyrus was made from the papyrus plant and was widely used.'),
        ('Which god was associated with the afterlife and resurrection?',
         ARRAY['Osiris', 'Ra', 'Anubis', 'Horus'], 0,
         'Osiris was the god of the underworld.'),
        ('Which pharaoh is famous for his largely intact tomb discovered in 1922?',
         ARRAY['Tutankhamun', 'Ramesses II', 'Akhenaten', 'Thutmose III'], 0,
         'Howard Carter discovered the tomb of Tutankhamun.'),
        ('What is the Valley of the Kings?',
         ARRAY['A royal burial ground for pharaohs', 'A palace complex', 'A military fortress', 'A temple city'], 0,
         'Pharaohs of the New Kingdom were buried there.'),
        ('Which substance was used in mummification as a drying agent?',
         ARRAY['Natron salt', 'Cedar oil', 'Lime', 'Bitumen'], 0,
         'Natron is a naturally occurring salt mixture used to desiccate bodies.'),
        ('Who was the architect of the Step Pyramid at Saqqara?',
         ARRAY['Imhotep', 'Hemiunu', 'Senenmut', 'Kha'], 0,
         'Imhotep served as chancellor to Pharaoh Djoser and designed the Step Pyramid.'),
        ('What system of exchange was used in early Egypt?',
         ARRAY['Barter system', 'Gold coins', 'Silver coins', 'Paper money'], 0,
         'Early Egypt relied on barter before the introduction of coined money.'),
        ('Who was the sun god often represented with a falcon head?',
         ARRAY['Ra', 'Amun', 'Ptah', 'Seth'], 0,
         'Ra was the primary sun god and had a falcon head.'),
        ('What annual event was crucial for Egyptian agriculture?',
         ARRAY['Flooding of the Nile (inundation)', 'Summer rains', 'Winter frost', 'Desert winds'], 0,
         'The annual inundation brought nutrient‑rich silt to the farmlands.'),
        ('Which pharaoh fought the Hittites at the Battle of Kadesh?',
         ARRAY['Ramesses II', 'Thutmose III', 'Akhenaten', 'Seti I'], 0,
         'Ramesses II led his army at Kadesh, one of the largest chariot battles.'),
        ('Which animal was considered sacred and often mummified?',
         ARRAY['Cats', 'Dogs', 'Crocodiles', 'Scarabs'], 0,
         'Cats were associated with the goddess Bastet and were revered.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_egypt, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 2. ROME (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('According to legend, who founded the city of Rome?',
         ARRAY['Romulus and Remus', 'Aeneas', 'Julius Caesar', 'Augustus'], 0,
         'Legend says Romulus founded Rome in 753 BCE after killing Remus.'),
        ('What form of government did Rome have before the Empire?',
         ARRAY['Republic', 'Monarchy', 'Oligarchy', 'Democracy'], 0,
         'The Roman Republic lasted from 509 BCE to 27 BCE.'),
        ('What was the official language of the Roman Empire?',
         ARRAY['Latin', 'Greek', 'Etruscan', 'Aramaic'], 0,
         'Latin was the official language, though Greek was widely spoken in the East.'),
        ('Who was the first Roman Emperor?',
         ARRAY['Augustus', 'Julius Caesar', 'Tiberius', 'Nero'], 0,
         'Augustus (formerly Octavian) became the first emperor in 27 BCE.'),
        ('What is the Colosseum known for?',
         ARRAY['Gladiatorial contests and public spectacles', 'Religious ceremonies', 'Government meetings', 'Baths'], 0,
         'The Colosseum was the largest amphitheatre and hosted combats and shows.'),
        ('Which mountain range runs the length of Italy?',
         ARRAY['Apennines', 'Alps', 'Himalayas', 'Andes'], 0,
         'The Apennines form the spine of the Italian peninsula.'),
        ('What was the "Pax Romana"?',
         ARRAY['A 200‑year period of relative peace and stability', 'A series of civil wars', 'A plague', 'An economic depression'], 0,
         'The Pax Romana lasted from 27 BCE to 180 CE.'),
        ('Which Roman leader was assassinated on the Ides of March (15 March 44 BCE)?',
         ARRAY['Julius Caesar', 'Pompey', 'Sulla', 'Marcus Aurelius'], 0,
         'Caesar was assassinated by a group of senators.'),
        ('What system of aqueducts provided?',
         ARRAY['Fresh water to cities', 'Waste removal', 'Transportation', 'Defense'], 0,
         'Aqueducts brought water from distant sources into urban centres.'),
        ('What was the Roman law code called?',
         ARRAY['The Twelve Tables', 'The Justinian Code', 'The Corpus Juris', 'The Lex Romana'], 0,
         'The Twelve Tables were the earliest written code of Roman law (c. 450 BCE).'),
        ('Which religion was adopted as the official state religion under Emperor Theodosius I?',
         ARRAY['Christianity', 'Mithraism', 'Judaism', 'Paganism'], 0,
         'Theodosius I made Nicene Christianity the state church in 380 CE.'),
        ('What was the main currency of the Roman Empire?',
         ARRAY['Denarius', 'Aureus', 'Sestertius', 'Solidus'], 0,
         'The denarius was the standard silver coin for centuries.'),
        ('Which civilisation did Rome fight in the Punic Wars?',
         ARRAY['Carthage', 'Greece', 'Persia', 'Egypt'], 0,
         'The three Punic Wars (264–146 BCE) were fought against Carthage.'),
        ('What is the "Rubicon" famous for?',
         ARRAY['Julius Caesar crossing it and starting a civil war', 'A major battle', 'A treaty', 'A building project'], 0,
         '"Crossing the Rubicon" meant an irrevocable step.'),
        ('Which volcano buried the city of Pompeii?',
         ARRAY['Mount Vesuvius', 'Mount Etna', 'Mount Stromboli', 'Mount Vesuvius in 79 CE'], 0,
         'Vesuvius erupted in 79 CE, burying Pompeii and Herculaneum.'),
        ('What was the Roman "Forum"?',
         ARRAY['The central public square for commerce and politics', 'A temple', 'A theatre', 'A library'], 0,
         'The Forum was the heart of Roman public life.'),
        ('Which Roman emperor built a massive wall across northern Britain?',
         ARRAY['Hadrian', 'Antoninus Pius', 'Septimius Severus', 'Claudius'], 0,
         'Hadrian''s Wall was built in the 2nd century CE.'),
        ('What was a "legion" in the Roman army?',
         ARRAY['A military unit of about 5,000 heavy infantry', 'A small squad', 'A cavalry unit', 'A naval fleet'], 0,
         'Legions were the main fighting units of the Roman army.'),
        ('Who wrote the "Aeneid"?',
         ARRAY['Virgil', 'Ovid', 'Livy', 'Cicero'], 0,
         'Virgil (70–19 BCE) wrote the Aeneid, an epic poem about Rome''s founding.'),
        ('What was the Roman "Gladiator" profession?',
         ARRAY['Armed combatants who fought in public arenas', 'Charioteers', 'Politicians', 'Priests'], 0,
         'Gladiators fought each other or wild beasts for public entertainment.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_rome, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 3. GREECE (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What was the centre of the Minoan civilisation on Crete?',
         ARRAY['Knossos', 'Mycenae', 'Athens', 'Sparta'], 0,
         'Knossos was the largest Bronze Age settlement on Crete, associated with King Minos.'),
        ('Which Greek city‑state was known for its military prowess and discipline?',
         ARRAY['Sparta', 'Athens', 'Corinth', 'Thebes'], 0,
         'Sparta was a militaristic society with a powerful hoplite army.'),
        ('What was the democratic system in ancient Athens called?',
         ARRAY['Direct democracy (male citizen participation)', 'Representative democracy', 'Oligarchy', 'Tyranny'], 0,
         'Athens had a direct democracy where citizens voted on legislation and executive bills.'),
        ('Which battle in 480 BCE saw a small Greek force hold off the Persian army?',
         ARRAY['Thermopylae', 'Marathon', 'Salamis', 'Plataea'], 0,
         'Leonidas and 300 Spartans made a stand at Thermopylae.'),
        ('Who was the philosopher who taught Plato?',
         ARRAY['Socrates', 'Aristotle', 'Pythagoras', 'Herodotus'], 0,
         'Socrates was the teacher of Plato, and Plato taught Aristotle.'),
        ('What is the "Iliad" and "Odyssey" traditionally attributed to?',
         ARRAY['Homer', 'Sophocles', 'Euripides', 'Hesiod'], 0,
         'Homer is the epic poet credited with these foundational works.'),
        ('What was the name of the Greek sacred site with a famous oracle?',
         ARRAY['Delphi', 'Olympia', 'Epidaurus', 'Mycenae'], 0,
         'The Oracle of Delphi was the most important oracle in the Greek world.'),
        ('Which city‑state was a major naval power and rival to Sparta?',
         ARRAY['Athens', 'Thebes', 'Argos', 'Corinth'], 0,
         'Athens had a powerful navy and led the Delian League.'),
        ('What was the "Peloponnesian War"?',
         ARRAY['A war between Athens and Sparta (431–404 BCE)', 'A war between Greece and Persia', 'A war between Athens and Thebes', 'A war between Sparta and Thebes'], 0,
         'The Peloponnesian War was a devastating conflict between Athens and its allies and the Peloponnesian League led by Sparta.'),
        ('Who was the king of Macedon who conquered the Greek city‑states?',
         ARRAY['Philip II', 'Alexander the Great', 'Cassander', 'Demetrius'], 0,
         'Philip II united Greece under Macedonian hegemony in the 4th century BCE.'),
        ('What was the "Macedonian Phalanx"?',
         ARRAY['A tight infantry formation armed with long pikes (sarissas)', 'A cavalry formation', 'A naval strategy', 'A siege engine'], 0,
         'The phalanx was the core tactical unit of the Macedonian army.'),
        ('Which Greek philosopher tutored Alexander the Great?',
         ARRAY['Aristotle', 'Plato', 'Socrates', 'Pythagoras'], 0,
         'Aristotle was Alexander''s tutor from age 13 to 16.'),
        ('What is the "Parthenon"?',
         ARRAY['A temple dedicated to Athena on the Acropolis in Athens', 'A temple to Zeus at Olympia', 'A theatre', 'A stadium'], 0,
         'The Parthenon is a Doric temple built in the 5th century BCE.'),
        ('What was the "Hellenistic" period?',
         ARRAY['The spread of Greek culture after Alexander''s conquests', 'The Classical period', 'The Archaic period', 'The Byzantine period'], 0,
         'The Hellenistic period lasted from Alexander''s death (323 BCE) to the Roman conquest.'),
        ('Which ancient Greek historian is known as the "Father of History"?',
         ARRAY['Herodotus', 'Thucydides', 'Xenophon', 'Plutarch'], 0,
         'Herodotus wrote the "Histories" on the Greco‑Persian Wars.'),
        ('What was a "hoplite"?',
         ARRAY['A heavily armed Greek infantryman', 'A light infantryman', 'A cavalryman', 'A naval officer'], 0,
         'Hoplites were citizen‑soldiers armed with a spear and shield.'),
        ('Which Greek god was the king of the gods?',
         ARRAY['Zeus', 'Poseidon', 'Hades', 'Ares'], 0,
         'Zeus was the sky and thunder god, ruler of Mount Olympus.'),
        ('What was the Olympic Games in ancient Greece?',
         ARRAY['Athletic competitions held in Olympia every four years', 'Theatrical competitions', 'Religious festivals only', 'Military games'], 0,
         'The Games were held in honour of Zeus from 776 BCE.'),
        ('Who was the Greek physician often called the "Father of Medicine"?',
         ARRAY['Hippocrates', 'Galen', 'Herophilos', 'Erasistratus'], 0,
         'Hippocrates (c. 460–370 BCE) is credited with the Hippocratic Oath.'),
        ('What was the "bireme" or "trireme"?',
         ARRAY['An ancient Greek warship with multiple banks of oars', 'A merchant ship', 'A fishing boat', 'A cargo barge'], 0,
         'The trireme was a fast, manoeuvrable warship with three rows of oars.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_greece, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 4. PERSIA (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Who founded the Achaemenid Empire (first Persian Empire)?',
         ARRAY['Cyrus the Great', 'Darius the Great', 'Xerxes', 'Cambyses'], 0,
         'Cyrus the Great (c. 600–530 BCE) founded the empire.'),
        ('What was the capital of the Achaemenid Empire?',
         ARRAY['Persepolis', 'Susa', 'Ecbatana', 'Babylon'], 0,
         'Persepolis was the ceremonial capital and one of several administrative centres.'),
        ('What was the official religion of the Achaemenid Empire?',
         ARRAY['Zoroastrianism', 'Mithraism', 'Manichaeism', 'Judaism'], 0,
         'Zoroastrianism, founded by Zoroaster, was the state religion.'),
        ('Which king is associated with the Royal Road and a system of couriers?',
         ARRAY['Darius the Great', 'Cyrus the Great', 'Xerxes', 'Artaxerxes'], 0,
         'Darius improved the Royal Road and established a postal system.'),
        ('What was the main Persian fighting unit?',
         ARRAY['Immortals (10,000 elite infantry)', 'Hoplites', 'Cataphracts', 'Chariots'], 0,
         'The Immortals were the elite Persian infantry.'),
        ('What was the Persian "satrapy" system?',
         ARRAY['Administrative provinces ruled by governors (satraps)', 'Military districts', 'Religious temples', 'Tax collection offices'], 0,
         'The empire was divided into satrapies for efficient governance.'),
        ('Which Persian king invaded Greece in 480 BCE?',
         ARRAY['Xerxes I', 'Darius I', 'Cyrus the Great', 'Cambyses'], 0,
         'Xerxes led the famous invasion that included the battles of Thermopylae and Salamis.'),
        ('What was the "Behistun Inscription"?',
         ARRAY['A multilingual inscription by Darius that helped decipher cuneiform', 'A royal decree', 'A religious text', 'A military campaign log'], 0,
         'The inscription in Old Persian, Elamite, and Babylonian was key to understanding cuneiform.'),
        ('Which city fell to Cyrus the Great in 539 BCE?',
         ARRAY['Babylon', 'Nineveh', 'Athens', 'Jerusalem'], 0,
         'Cyrus conquered Babylon and allowed the Jews to return to Jerusalem.'),
        ('What was the Persian "Qanat"?',
         ARRAY['Underground irrigation channels', 'A type of chariot', 'A religious temple', 'A fortress'], 0,
         'Qanats were efficient water management systems.'),
        ('Who was the last Achaemenid king, defeated by Alexander the Great?',
         ARRAY['Darius III', 'Xerxes II', 'Artaxerxes III', 'Darius II'], 0,
         'Darius III was defeated at Issus (333 BCE) and Gaugamela (331 BCE).'),
        ('What was the common language of administration in the Achaemenid Empire?',
         ARRAY['Aramaic', 'Old Persian', 'Elamite', 'Greek'], 0,
         'Aramaic was used as a lingua franca across the empire.'),
        ('Which Persian king was known for his massive building projects at Persepolis?',
         ARRAY['Darius I and Xerxes I', 'Cyrus the Great', 'Artaxerxes', 'Darius III'], 0,
         'Darius and Xerxes were the main builders of Persepolis.'),
        ('What did the Persian Empire use for standardised trade?',
         ARRAY['A uniform coinage system (daric)', 'Barter', 'Silver ingots', 'Gold nuggets'], 0,
         'Darius introduced the daric gold coin to facilitate trade.'),
        ('Which people did the Persians conquer in 525 BCE, under Cambyses?',
         ARRAY['Egypt', 'India', 'Greece', 'Phoenicia'], 0,
         'Cambyses II conquered Egypt, bringing it into the empire.'),
        ('What was the "Royal Road" connecting?',
         ARRAY['Sardis in Lydia to Susa in Elam', 'Persepolis to Babylon', 'Ecbatana to Pasargadae', 'Susa to Jerusalem'], 0,
         'The Royal Road was a major highway for communication.'),
        ('Which religion influenced Zoroastrianism?',
         ARRAY['Pre‑Iranian polytheism, reformed by Zoroaster', 'Judaism', 'Buddhism', 'Hinduism'], 0,
         'Zoroaster reformed the ancient Iranian religion.'),
        ('What was the role of the "Magi"?',
         ARRAY['Priestly class in Zoroastrianism', 'Military commanders', 'Satraps', 'Merchants'], 0,
         'The Magi were the priestly caste.'),
        ('Which Greek historian wrote extensively about the Persian Empire?',
         ARRAY['Herodotus', 'Thucydides', 'Xenophon', 'Ctesias'], 0,
         'Herodotus is the major primary source for the Persian Wars.'),
        ('What architectural feature is common in Persian palaces?',
         ARRAY['Hypostyle halls with columns', 'Gothic arches', 'Domes', 'Minarets'], 0,
         'Persian palaces featured large columned halls, like the Apadana at Persepolis.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_persia, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 5. CHINA (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the name of the first emperor of a unified China?',
         ARRAY['Qin Shi Huang', 'Han Wudi', 'Sui Wendi', 'Tang Taizong'], 0,
         'Qin Shi Huang unified China in 221 BCE and began the Qin dynasty.'),
        ('What was the Terracotta Army?',
         ARRAY['Thousands of clay soldiers buried with Qin Shi Huang', 'A real army', 'A military fort', 'A ceremonial palace'], 0,
         'The terracotta warriors were built to accompany the emperor in the afterlife.'),
        ('Which dynasty is known for the development of the Silk Road?',
         ARRAY['Han Dynasty', 'Tang Dynasty', 'Qin Dynasty', 'Song Dynasty'], 0,
         'The Han dynasty (206 BCE – 220 CE) opened trade routes to the West.'),
        ('What was the main philosophy promoted by the Han dynasty?',
         ARRAY['Confucianism', 'Daoism', 'Legalism', 'Buddhism'], 0,
         'Emperor Wu of Han adopted Confucianism as the state ideology.'),
        ('Which Chinese philosopher is the founder of Confucianism?',
         ARRAY['Confucius (Kong Fuzi)', 'Laozi', 'Mencius', 'Xunzi'], 0,
         'Confucius lived c. 551–479 BCE and his teachings shaped Chinese society.'),
        ('What is the Great Wall of China?',
         ARRAY['A series of fortifications built over centuries', 'A single continuous wall', 'A moat', 'A palace wall'], 0,
         'The Great Wall was built to protect northern borders from nomadic groups.'),
        ('Which ancient Chinese dynasty was the first to leave written records (oracle bones)?',
         ARRAY['Shang Dynasty', 'Zhou Dynasty', 'Qin Dynasty', 'Han Dynasty'], 0,
         'Shang (c. 1600–1046 BCE) used oracle bones for divination.'),
        ('What was the "Mandate of Heaven"?',
         ARRAY['The divine right to rule, based on just governance', 'A military mandate', 'A religious edict', 'A legal code'], 0,
         'The Mandate justified dynastic succession and allowed for rebellion against tyrants.'),
        ('Which dynasty is often called the "Golden Age" of Chinese poetry and culture?',
         ARRAY['Tang Dynasty', 'Song Dynasty', 'Han Dynasty', 'Ming Dynasty'], 0,
         'The Tang (618–907 CE) saw great poets like Li Bai and Du Fu.'),
        ('What was the "Silk Road"?',
         ARRAY['A trade network connecting China with the Mediterranean', 'A road paved with silk', 'A route only for silk trade', 'A military road'], 0,
         'The Silk Road facilitated cultural and economic exchange between East and West.'),
        ('Which invention is attributed to ancient China?',
         ARRAY['Paper', 'Steel', 'Gunpowder', 'All of the above'], 3,
         'Ancient China gave us paper, gunpowder, the compass, and woodblock printing.'),
        ('What was the role of the "civil service examination" system?',
         ARRAY['Recruiting bureaucrats based on merit', 'Military selection', 'Religious office', 'Tax collection'], 0,
         'Exams based on Confucian classics were used to select officials.'),
        ('Which Chinese military general wrote "The Art of War"?',
         ARRAY['Sun Tzu', 'Sun Bin', 'Zhuge Liang', 'Han Xin'], 0,
         'Sun Tzu wrote the famous treatise on military strategy.'),
        ('What was the "Yellow River" called by ancient Chinese?',
         ARRAY['Cradle of Chinese civilisation', 'The Great River', 'The Yangtze', 'The Dragon River'], 0,
         'The Yellow River (Huang He) is considered the birthplace of Chinese civilisation.'),
        ('Which dynasty was founded by the Mongols?',
         ARRAY['Yuan Dynasty', 'Ming Dynasty', 'Qing Dynasty', 'Song Dynasty'], 0,
         'Kublai Khan established the Yuan dynasty in 1271.'),
        ('What is the "Dragon" in Chinese culture?',
         ARRAY['A mythical beast symbolising power and good fortune', 'A real animal', 'A demon', 'A water spirit'], 0,
         'The dragon is an imperial symbol and represents yang.'),
        ('Which ancient Chinese dynasty was known for bronze casting?',
         ARRAY['Shang Dynasty', 'Zhou Dynasty', 'Han Dynasty', 'Tang Dynasty'], 0,
         'Shang bronzes are famous for their ritual vessels.'),
        ('What was the "Han" ethnic group named after?',
         ARRAY['The Han dynasty', 'The Han river', 'A mythical ancestor', 'A mountain'], 0,
         'The ethnic majority of China takes its name from the Han dynasty.'),
        ('What was the "compass" originally used for?',
         ARRAY['Divination and navigation', 'Military strategy', 'Agriculture', 'Construction'], 0,
         'The ancient Chinese developed the compass for geomancy and later navigation.'),
        ('What was the length of the Great Wall (approximately) in total?',
         ARRAY['Over 21,000 kilometres across all dynasties', '5,000 km', '10,000 km', '15,000 km'], 0,
         'The total length of the Great Wall is over 21,000 km.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_china, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 6. MAYA (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Where did the Maya civilisation primarily develop?',
         ARRAY['Mesoamerica (Mexico, Guatemala, Belize, Honduras)', 'South America', 'North America', 'Central America'], 0,
         'The Maya flourished in the Yucatán Peninsula and surrounding areas.'),
        ('What was the Maya writing system called?',
         ARRAY['Maya hieroglyphic writing (logosyllabic)', 'Cuneiform', 'Quipu', 'Olmec script'], 0,
         'Maya glyphs were a complex logosyllabic system.'),
        ('Which Maya city is famous for its towering pyramids?',
         ARRAY['Tikal', 'Chichén Itzá', 'Copán', 'Palenque'], 0,
         'Tikal, in Guatemala, has some of the tallest Maya pyramids.'),
        ('What was the Maya calendar system?',
         ARRAY['Several interlocking cycles (Tzolkʼin, Haab, Long Count)', 'A single solar calendar', 'A lunar calendar', 'A seasonal calendar'], 0,
         'The Maya used a 260‑day Tzolkʼin, a 365‑day Haab, and a Long Count for historical dates.'),
        ('What was the Maya "Long Count" used for?',
         ARRAY['Tracking long periods of time, often for historical records', 'Tracking days', 'Tracking lunar cycles', 'Tracking trade'], 0,
         'The Long Count counted days since a mythological creation date.'),
        ('Which Maya city was a major centre for astronomy and mathematics?',
         ARRAY['Copán', 'Chichén Itzá', 'Uxmal', 'Mayapán'], 0,
         'Copán, in Honduras, was a significant intellectual centre.'),
        ('What were the Maya "stelae"?',
         ARRAY['Carved stone slabs often depicting rulers and events', 'Pyramids', 'Temples', 'Ball courts'], 0,
         'Stelae were erected in plazas to commemorate important events.'),
        ('Which crop was the staple of the Maya diet?',
         ARRAY['Maize (corn)', 'Wheat', 'Rice', 'Potatoes'], 0,
         'Maize was the fundamental food and part of their creation mythology.'),
        ('What was a "cenote"?',
         ARRAY['A natural sinkhole used for water and rituals', 'A temple', 'A palace', 'A ball court'], 0,
         'Cenotes were vital for water in the Yucatán and were often sacrificial sites.'),
        ('What did the Maya use for religious rituals, including human sacrifice?',
         ARRAY['Bloodletting and offerings to deities', 'Fire', 'Music', 'Dance'], 0,
         'Bloodletting by rulers and nobles was common; human sacrifice was also practiced.'),
        ('Which Maya king of Palenque is known for his elaborate tomb?',
         ARRAY['Kʼinich Janaab Pakal (Pacal the Great)', 'Jasaw Chan Kʼawiil I', 'Yax Kuk Mo', 'Cauac Sky'], 0,
         'Pacal''s tomb in the Temple of the Inscriptions is famous.'),
        ('What was the Maya ball game called?',
         ARRAY['Pok‑ta‑pok', 'Ulama', 'Jai alai', 'Pitz'], 0,
         'The ball game had deep religious significance.'),
        ('What was the main building material for Maya structures?',
         ARRAY['Limestone', 'Granite', 'Mudbrick', 'Wood'], 0,
         'Limestone was abundant and used for large stone structures.'),
        ('What is the "Dresden Codex"?',
         ARRAY['One of the few surviving Maya books (codices)', 'A Spanish colonial document', 'A European map', 'A Maya carving'], 0,
         'The Dresden Codex is a pre‑Columbian Maya book with astronomical tables.'),
        ('What happened to the Classic Maya civilisation?',
         ARRAY['A collapse around 900 CE, due to multiple factors', 'They were destroyed by the Spanish', 'They disappeared without a trace', 'They evolved into the Aztec'], 0,
         'The Classic Maya collapse saw a decline of lowland cities; causes include drought, deforestation, and warfare.'),
        ('Who was the Maya rain god?',
         ARRAY['Chaac', 'Kukulkan', 'Itzamna', 'Bolon Dzacab'], 0,
         'Chaac was the god of rain and lightning, often depicted with a beard.'),
        ('What is the significance of "Chichén Itzá"?',
         ARRAY['A major Maya city with the pyramid of El Castillo', 'The oldest Maya city', 'The Maya capital', 'A Maya port'], 0,
         'Chichén Itzá is a UNESCO World Heritage site and a major archaeological site.'),
        ('What was the Maya concept of the universe?',
         ARRAY['A three‑layered world (sky, earth, underworld)', 'A flat disc', 'A sphere', 'A cube'], 0,
         'They believed in a universe with 13 heavens, the earth, and 9 underworld levels.'),
        ('Which group of people did the Maya trade with?',
         ARRAY['Other Mesoamerican groups like the Aztec and Olmec', 'Europeans before 1492', 'Incas', 'North American tribes'], 0,
         'They traded with other cultures across Mesoamerica.'),
        ('What was the "Popol Vuh"?',
         ARRAY['The Maya creation myth and epic', 'A codex', 'A royal genealogy', 'A military chronicle'], 0,
         'The Popol Vuh is a sacred Kʼicheʼ Maya book.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_maya, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 7. AZTEC (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Where was the Aztec Empire centred?',
         ARRAY['Central Mexico (Valley of Mexico)', 'Yucatán Peninsula', 'Andes Mountains', 'Amazon Basin'], 0,
         'The Aztec capital Tenochtitlan was on an island in Lake Texcoco, now Mexico City.'),
        ('What was the name of the Aztec capital?',
         ARRAY['Tenochtitlan', 'Teotihuacan', 'Tlatelolco', 'Coyoacán'], 0,
         'Tenochtitlan was a magnificent city, with over 200,000 inhabitants at its peak.'),
        ('Which god was the patron of the Aztecs, associated with war and the sun?',
         ARRAY['Huitzilopochtli', 'Quetzalcoatl', 'Tlaloc', 'Tezcatlipoca'], 0,
         'Huitzilopochtli guided the Aztecs to found Tenochtitlan.'),
        ('What was the Aztec writing system?',
         ARRAY['Pictographic and ideographic glyphs', 'Hieroglyphics', 'Cuneiform', 'Quipu'], 0,
         'Aztec writing was not a full phonetic script but used symbols and glyphs.'),
        ('What was the main economic activity of the Aztecs?',
         ARRAY['Agriculture (chinampas) and trade', 'Mining', 'Herding', 'Fishing'], 0,
         'Chinampas were floating gardens for intensive agriculture.'),
        ('Which Spanish conquistador led the expedition against the Aztecs?',
         ARRAY['Hernán Cortés', 'Francisco Pizarro', 'Juan Ponce de León', 'Hernando de Soto'], 0,
         'Cortés arrived in 1519 and allied with native groups to defeat the Aztecs.'),
        ('What was the "Triple Alliance"?',
         ARRAY['The alliance of Tenochtitlan, Texcoco, and Tlacopan', 'The Aztec gods', 'A trade union', 'A military pact with Spain'], 0,
         'These three city‑states formed the Aztec Empire.'),
        ('What was the role of the "calpulli"?',
         ARRAY['A clan‑based social unit or neighbourhood', 'A military rank', 'A temple', 'A market'], 0,
         'Calpulli were the basic units of organisation and landholding.'),
        ('What was the Aztec view of human sacrifice?',
         ARRAY['It was essential to nourish the gods and maintain cosmic order', 'It was forbidden', 'Only done in emergencies', 'It was a punishment'], 0,
         'They believed sacrifices were necessary to sustain the sun and the universe.'),
        ('Who was the Aztec emperor at the time of Spanish conquest?',
         ARRAY['Moctezuma II', 'Moctezuma I', 'Axayacatl', 'Ahuitzotl'], 0,
         'Moctezuma II (also Montezuma) ruled from 1502 to 1520.'),
        ('What was the "chinampa" system?',
         ARRAY['Artificial islands built on lake beds for farming', 'Irrigation canals', 'Terrace farming', 'Slash‑and‑burn agriculture'], 0,
         'Chinampas were highly productive and allowed year‑round cropping.'),
        ('What was the Aztec calendar stone?',
         ARRAY['A massive monolith depicting the sun stone and cosmic eras', 'A simple lunar calendar', 'A temple floor', 'A sacrificial altar'], 0,
         'The Sun Stone weighs about 24 tons and represents the Aztec cosmology.'),
        ('What was the main Aztec market called?',
         ARRAY['Tlatelolco market', 'Tenochtitlan market', 'Texcoco market', 'Teotihuacan market'], 0,
         'The Tlatelolco market was one of the largest in the Americas.'),
        ('What was the Aztec "Feathered Serpent" god?',
         ARRAY['Quetzalcoatl', 'Kukulkan (Maya counterpart)', 'Tlaloc', 'Tezcatlipoca'], 0,
         'Quetzalcoatl was the wind god and a creator deity.'),
        ('What was the "Nahuatl" language?',
         ARRAY['The language of the Aztecs', 'A Maya language', 'An Incan language', 'A Zapotec language'], 0,
         'Nahuatl was the lingua franca of the Aztec Empire.'),
        ('What was the Aztec "flower war"?',
         ARRAY['Ceremonial warfare with the primary purpose of taking captives', 'A war over flowers', 'A religious festival', 'A trade conflict'], 0,
         'Flower wars were set battles designed to obtain sacrificial victims.'),
        ('Which social class was at the top of Aztec society?',
         ARRAY['Nobility (pipiltin)', 'Priests', 'Merchants (pochteca)', 'Commoners (macehualtin)'], 0,
         'The pipiltin were the ruling elite.'),
        ('What was the Spanish strategy against the Aztecs?',
         ARRAY['Alliance with native enemies and use of superior weaponry', 'Overwhelming naval force', 'Diplomatic negotiations only', 'Long siege'], 0,
         'Cortés allied with the Tlaxcalans and other groups hostile to the Aztecs.'),
        ('What happened to Moctezuma II?',
         ARRAY['He was killed (probably by his own people) during the Spanish siege', 'He fled to Spain', 'He converted to Christianity', 'He died of smallpox'], 0,
         'Moctezuma died in 1520 during the battle for Tenochtitlan.'),
        ('What is the Aztec empire known for?',
         ARRAY['A sophisticated urban culture with complex religion and art', 'Extensive architecture', 'Agriculture', 'All of the above'], 3,
         'The Aztecs had all these elements of a great civilisation.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_aztec, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 8. INCA (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Where was the Inca Empire located?',
         ARRAY['Andes Mountains of South America', 'Mesoamerica', 'North America', 'Amazon Basin'], 0,
         'The Inca Empire extended along the Andes from modern Colombia to Chile.'),
        ('What was the capital of the Inca Empire?',
         ARRAY['Cusco (Cuzco)', 'Machu Picchu', 'Quito', 'Lima'], 0,
         'Cusco was the administrative, political, and religious centre.'),
        ('Which king is considered the first Inca emperor?',
         ARRAY['Pachacuti', 'Manco Capac (legendary), historically Sapa Inca', 'Atahualpa', 'Huayna Capac'], 0,
         'Pachacuti (1438–1471) transformed the Inca state into an empire.'),
        ('What was the official language of the Inca Empire?',
         ARRAY['Quechua', 'Aymara', 'Spanish', 'Nahuatl'], 0,
         'Quechua was promoted by the Incas as the lingua franca.'),
        ('What was the Inca road system called?',
         ARRAY['Qhapaq Ñan (Royal Road)', 'The Great Inca Trail', 'Camino Real', 'Inca Path'], 0,
         'The Qhapaq Ñan was an extensive network of roads covering over 40,000 km.'),
        ('What was the primary agricultural technique of the Incas?',
         ARRAY['Terracing (andenes)', 'Chinampas', 'Slash‑and‑burn', 'Irrigation canals'], 0,
         'Terracing allowed farming on steep mountain slopes.'),
        ('What was the Inca record‑keeping system called?',
         ARRAY['Quipu (knots on strings)', 'Writing', 'Pictographs', 'Glyphs'], 0,
         'Quipus used knotted cords to record numerical and possibly narrative information.'),
        ('Who was the Spanish conquistador who captured the Inca emperor Atahualpa?',
         ARRAY['Francisco Pizarro', 'Hernán Cortés', 'Pedro de Alvarado', 'Vasco Núñez de Balboa'], 0,
         'Pizarro captured Atahualpa in 1532 at Cajamarca.'),
        ('What was the Inca religious focus?',
         ARRAY['Worship of the Sun god (Inti)', 'Worship of the moon', 'Worship of the earth', 'Polytheistic with Inti as top'], 0,
         'Inti was the most important deity, and the emperor was his representative.'),
        ('What was the Inca concept of "mita"?',
         ARRAY['A labour tax (corvée) for state projects', 'A religious festival', 'A military service', 'A trading system'], 0,
         'Mita was a rotational labour draft for public works, agriculture, and mining.'),
        ('Which Inca site is known as a magnificent mountaintop citadel?',
         ARRAY['Machu Picchu', 'Ollantaytambo', 'Sacsayhuamán', 'Pisac'], 0,
         'Machu Picchu was rediscovered by Hiram Bingham in 1911.'),
        ('What was the Inca social class structure?',
         ARRAY['Sapa Inca, nobility, commoners, and mitmaq (colonists)', 'Priests, warriors, farmers', 'Castle system', 'Egalitarian'], 0,
         'Inca society was hierarchical with the Sapa Inca (emperor) at the top.'),
        ('Which city was the second capital of the Inca Empire?',
         ARRAY['Quito', 'Cusco', 'Tiahuanaco', 'Chan Chan'], 0,
         'Quito was an important northern administrative centre.'),
        ('What was the Inca "puquios"?',
         ARRAY['Underground irrigation channels', 'Roads', 'Temples', 'Markets'], 0,
         'Puquios were water systems, often associated with the Nazca region.'),
        ('What happened to the Inca Empire after the Spanish conquest?',
         ARRAY['It collapsed and was absorbed into the Spanish colonial system', 'It continued independently', 'It allied with Spain', 'It moved to the Amazon'], 0,
         'After the fall of Atahualpa, the empire fragmented and fell to the Spanish.'),
        ('Which Inca ruler is famous for the saying "The earth is a mother"?',
         ARRAY['Pachacuti', 'Atahualpa', 'Huayna Capac', 'Manco Capac'], 0,
         'Pachacuti is credited with many moral and cosmological sayings.'),
        ('What was the Inca "mummy cult"?',
         ARRAY['Worship of royal mummies, which were paraded and consulted', 'Burial of servants with kings', 'Mummification of all dead', 'Cremation'], 0,
         'Deceased emperors were mummified and kept their palaces.'),
        ('What was the main metal used by the Incas for tools and ornaments?',
         ARRAY['Gold, silver, copper, and bronze', 'Iron', 'Steel', 'Tin'], 0,
         'They worked metals for jewellery, ritual objects, and some tools.'),
        ('What was the Inca province system?',
         ARRAY['The empire was divided into four regions (suyu)', 'It was a single territory', 'It was organised by clans', 'It was a federation of cities'], 0,
         'Tawantinsuyu means "four corners" – the four suyu.'),
        ('Which disease was devastating to the Incas before Pizarro arrived?',
         ARRAY['Smallpox (which killed Huayna Capac)', 'Influenza', 'Measles', 'Typhoid'], 0,
         'Smallpox spread from Europe and killed the Sapa Inca Huayna Capac, sparking a civil war.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_inca, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 9. MESOPOTAMIA (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What does "Mesopotamia" mean?',
         ARRAY['Land between the rivers (Tigris and Euphrates)', 'Land of the gods', 'Cradle of civilisation', 'Holy land'], 0,
         'The name comes from ancient Greek, meaning the land between two rivers.'),
        ('Which writing system was invented in Mesopotamia?',
         ARRAY['Cuneiform', 'Hieroglyphics', 'Sanskrit', 'Linear B'], 0,
         'Cuneiform evolved from pictographs and was used on clay tablets.'),
        ('What was the first known code of law called?',
         ARRAY['Code of Hammurabi', 'Twelve Tables', 'Code of Ur‑Nammu', 'Justinian Code'], 0,
         'Hammurabi (c. 1754 BCE) issued a comprehensive legal code.'),
        ('Which Mesopotamian king built the Hanging Gardens?',
         ARRAY['Nebuchadnezzar II', 'Sargon of Akkad', 'Hammurabi', 'Ashurbanipal'], 0,
         'Nebuchadnezzar II (c. 605–562 BCE) is credited with building the Hanging Gardens of Babylon.'),
        ('What was the first empire in history?',
         ARRAY['Akkadian Empire (Sargon of Akkad)', 'Babylonian Empire', 'Assyrian Empire', 'Persian Empire'], 0,
         'Sargon of Akkad established the first true empire around 2334 BCE.'),
        ('Which Mesopotamian city was famous for its library?',
         ARRAY['Nineveh (Assurbanipal''s library)', 'Babylon', 'Ur', 'Uruk'], 0,
         'Assurbanipal''s library at Nineveh contained thousands of clay tablets.'),
        ('What was the standard building material in Mesopotamia?',
         ARRAY['Mudbrick and baked brick', 'Stone', 'Wood', 'Metal'], 0,
         'They used sun‑dried and kiln‑fired bricks, due to the lack of stone.'),
        ('Which ziggurat is the most famous, associated with Babylon?',
         ARRAY['Etemenanki (Tower of Babel)', 'Ziggurat of Ur', 'Ziggurat of Uruk', 'Ziggurat of Aqar Quf'], 0,
         'Etemenanki was a massive ziggurat dedicated to Marduk.'),
        ('What was the Mesopotamian number system?',
         ARRAY['Sexagesimal (base‑60)', 'Decimal (base‑10)', 'Base‑12', 'Base‑20'], 0,
         'The base‑60 system gave us 60 minutes in an hour.'),
        ('Which epic poem comes from Mesopotamia?',
         ARRAY['Epic of Gilgamesh', 'Iliad', 'Odyssey', 'Aeneid'], 0,
         'The Epic of Gilgamesh is one of the oldest surviving works of literature.'),
        ('What was the role of the "Sumerians"?',
         ARRAY['The first urban civilisation in southern Mesopotamia', 'A later Babylonian group', 'An Assyrian dynasty', 'A Persian tribe'], 0,
         'Sumer was the earliest known civilisation in the region (c. 4500‑1900 BCE).'),
        ('Which god was the king of the gods in Mesopotamian mythology?',
         ARRAY['Enlil (later Marduk)', 'Anu', 'Ea', 'Ishtar'], 0,
         'Enlil was the chief god, later replaced by Marduk.'),
        ('What was the "Ishtar Gate"?',
         ARRAY['A grand gate in Babylon decorated with blue‑glazed bricks', 'A temple gate', 'A city wall', 'A palace entrance'], 0,
         'The Ishtar Gate was dedicated to the goddess Ishtar.'),
        ('What was the "Code of Ur‑Nammu"?',
         ARRAY['An earlier law code from the Ur III dynasty (c. 2100 BCE)', 'A later Babylonian code', 'An Assyrian code', 'A Persian code'], 0,
         'It is one of the oldest surviving law codes, predating Hammurabi.'),
        ('Which Assyrian king was known for his brutal military campaigns?',
         ARRAY['Ashurnasirpal II', 'Tiglath‑Pileser III', 'Sennacherib', 'All of the above'], 3,
         'Assyrian kings were known for their harsh treatment of conquered peoples.'),
        ('What was the Mesopotamian "ziggurat"?',
         ARRAY['A terraced step pyramid temple', 'A tomb', 'A palace', 'A city wall'], 0,
         'Ziggurats served as temples to the gods, often at the centre of cities.'),
        ('What is the "Babylonian Captivity" (or Exile)?',
         ARRAY['The forced relocation of Jews to Babylon (6th century BCE)', 'The enslavement of Babylonians', 'A military occupation', 'A trade embargo'], 0,
         'Nebuchadnezzar II captured Jerusalem and exiled many Jews.'),
        ('Which river was crucial to Mesopotamia?',
         ARRAY['Tigris and Euphrates', 'Nile', 'Indus', 'Jordan'], 0,
         'The Tigris and Euphrates flowed through Mesopotamia.'),
        ('What was the main Mesopotamian beer made from?',
         ARRAY['Barley', 'Wheat', 'Dates', 'Grapes'], 0,
         'Barley was the primary grain for beer, a staple drink.'),
        ('What was the "lunar calendar" based on?',
         ARRAY['Phases of the moon (12 lunar months)', 'The sun', 'The stars', 'The planets'], 0,
         'Mesopotamians used a lunar calendar, with intercalary months to align with the solar year.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_mesopotamia, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 10. INDUS VALLEY (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Where was the Indus Valley civilisation located?',
         ARRAY['Pakistan and northwestern India', 'Bangladesh', 'Nepal', 'Sri Lanka'], 0,
         'It flourished in the Indus River basin, covering what is now Pakistan and parts of India.'),
        ('Which two cities are the best‑known urban centres of the Indus Valley?',
         ARRAY['Mohenjo‑Daro and Harappa', 'Thebes and Memphis', 'Athens and Sparta', 'Rome and Carthage'], 0,
         'Mohenjo‑Daro and Harappa were major cities with sophisticated urban planning.'),
        ('What was the Indus Valley script?',
         ARRAY['An undeciphered writing system (symbols)', 'Cuneiform', 'Hieroglyphics', 'Sanskrit'], 0,
         'Despite thousands of seals, the script remains largely undeciphered.'),
        ('What was the typical layout of a Indus city?',
         ARRAY['Grid pattern with separate citadel and lower city', 'Irregular streets', 'Circular layout', 'No planning'], 0,
         'Cities were carefully planned with a grid system, advanced drainage, and urban infrastructure.'),
        ('What was the main agricultural crop of the Indus Valley?',
         ARRAY['Wheat and barley', 'Rice', 'Maize', 'Potatoes'], 0,
         'Archaeological evidence shows wheat, barley, peas, and dates were grown.'),
        ('Which animal was commonly depicted on Indus seals?',
         ARRAY['Unicorn, bull, elephant', 'Lion', 'Tiger', 'Horse'], 0,
         'The "unicorn" (a mythical bull‑like animal) is frequent on seals.'),
        ('What was the main material for carving seals?',
         ARRAY['Steatite', 'Clay', 'Bronze', 'Wood'], 0,
         'Steatite (soapstone) was carved to make intricate seals.'),
        ('What system of weights and measures was used?',
         ARRAY['Standardised, based on a decimal system', 'No standardisation', 'Based on body parts', 'Based on grains'], 0,
         'They had highly standardised weights (e.g., in multiples of 16).'),
        ('What was the status of the Indus civilisation when it ended?',
         ARRAY['It declined gradually (c. 1900–1300 BCE) for unclear reasons', 'It was conquered by Persia', 'It was invaded by Aryans', 'It collapsed suddenly in war'], 0,
         'Causes include climate change, drying of the Ghaggar‑Hakra river, and possibly Aryan migration.'),
        ('What was the "Great Bath" at Mohenjo‑Daro?',
         ARRAY['A large public water tank, likely for ritual bathing', 'A swimming pool', 'A reservoir', 'A washing area'], 0,
         'The Great Bath is a well‑built structure with steps and waterproofing.'),
        ('What was the dominant religion of the Indus Valley?',
         ARRAY['Unknown, but likely a form of proto‑Hinduism with mother goddess and pashupati', 'Vedic Hinduism', 'Jainism', 'Buddhism'], 0,
         'Seals show a figure possibly representing a proto‑Shiva, and female figurines.'),
        ('Which metal was NOT used by the Indus Valley?',
         ARRAY['Iron', 'Copper', 'Bronze', 'Lead'], 0,
         'Iron was not used in the Mature Harappan period (c. 2600‑1900 BCE).'),
        ('What was the main export of the Indus Valley?',
         ARRAY['Carnelian beads, cotton textiles, and ivory', 'Wool', 'Silk', 'Spices'], 0,
         'They traded with Mesopotamia and other regions.'),
        ('What type of government did the Indus Valley have?',
         ARRAY['Unknown, possibly a priest‑king or oligarchic system', 'Monarchy', 'Democracy', 'No government'], 0,
         'There is no clear evidence of a single ruler or centralised state.'),
        ('What was the "Citadel" in Indus cities?',
         ARRAY['An elevated, fortified area housing public buildings', 'A palace', 'A temple', 'A royal residence'], 0,
         'The citadel was likely used for religious and administrative purposes.'),
        ('Which animal was domesticated in the Indus Valley?',
         ARRAY['Zebu (humped cattle)', 'Horse', 'Camel', 'Chicken'], 0,
         'Zebu was a common domestic animal.'),
        ('What was the system of drainage like?',
         ARRAY['Sophisticated covered drains along the streets', 'Open ditches', 'No drainage', 'Underground pipes'], 0,
         'The Indus Valley is known for its remarkable urban sanitation.'),
        ('Which civilisation did the Indus Valley trade with?',
         ARRAY['Mesopotamia (Sumer)', 'Egypt', 'China', 'Greece'], 0,
         'Trade links with Mesopotamian cities have been confirmed.'),
        ('What was the end date of the mature Indus period?',
         ARRAY['c. 1900 BCE', 'c. 1500 BCE', 'c. 2500 BCE', 'c. 1000 BCE'], 0,
         'Mature Harappan phase ended around 1900 BCE, followed by a decline.'),
        ('What was the "Pashupati" seal?',
         ARRAY['A seal depicting a figure surrounded by animals, possibly a proto‑Shiva', 'A royal seal', 'A trade seal', 'A harvest seal'], 0,
         'The figure is in a yogic posture, identified by some as Shiva Pashupati.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_indus, q_rec.column1, 'single_choice', q_rec.column4)
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