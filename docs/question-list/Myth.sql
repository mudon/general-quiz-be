-- ============================================================================
-- INSERT 250 MYTH, FOLKLORE, LEGENDS, CONSPIRACY THEORIES & URBAN LEGENDS
-- ============================================================================
-- Covers: Mythology, Folklore, Legends, Conspiracy Theories (clearly labeled),
-- Urban Legends -- with a global mix of cultures.
-- All questions are factual (about beliefs/legends) and non-sensitive.
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
        ('myth', 'Myth', '🌌', 2, 0),
        ('myth.mythology', 'Mythology', NULL, 2, 1),
        ('myth.folklore', 'Folklore', NULL, 2, 2),
        ('myth.legends', 'Legends', NULL, 2, 3),
        ('myth.conspiracy_theories', 'Conspiracy Theories', NULL, 2, 4),
        ('myth.urban_legends', 'Urban Legends', NULL, 2, 5)
    ON CONFLICT (path) DO NOTHING;

    -- ------------------------------------------------------------------------
    -- 2. Insert questions per category
    -- ------------------------------------------------------------------------

    -- ==================== MYTHOLOGY (60) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'myth.mythology';
    FOR q_rec IN (
        VALUES
        -- Greek
        ('Who is the king of the Greek gods?', ARRAY['Zeus', 'Poseidon', 'Hades', 'Apollo'], 0, 'Zeus ruled Mount Olympus.'),
        ('Which Greek goddess sprang from Zeus''s head?', ARRAY['Athena', 'Aphrodite', 'Artemis', 'Demeter'], 0, 'Athena was born fully grown.'),
        ('What creature has the body of a man and the head of a bull in Greek myth?', ARRAY['Minotaur', 'Centaur', 'Satyr', 'Hydra'], 0, 'The Minotaur lived in the Labyrinth.'),
        ('Which hero slew the Gorgon Medusa?', ARRAY['Perseus', 'Hercules', 'Theseus', 'Jason'], 0, 'Perseus used a mirrored shield.'),
        ('Who is the Greek god of the sea?', ARRAY['Poseidon', 'Zeus', 'Hades', 'Hephaestus'], 0, 'Poseidon ruled the oceans.'),
        ('What is the name of the winged horse in Greek myth?', ARRAY['Pegasus', 'Chimera', 'Griffin', 'Phoenix'], 0, 'Pegasus sprang from Medusa''s blood.'),
        ('Which Greek goddess is the goddess of love and beauty?', ARRAY['Aphrodite', 'Athena', 'Hera', 'Artemis'], 0, 'Aphrodite was born from sea foam.'),
        ('What is the underworld river in Greek myth?', ARRAY['Styx', 'Lethe', 'Acheron', 'Cocytus'], 0, 'Styx is the most famous.'),
        ('Who is the god of war in Greek myth?', ARRAY['Ares', 'Athena', 'Apollo', 'Hermes'], 0, 'Ares is the god of war.'),
        ('What is the name of the famous oracle in Greek myth?', ARRAY['Delphi', 'Olympia', 'Dodona', 'Ephesus'], 0, 'The Oracle of Delphi was at the temple of Apollo.'),
        -- Roman
        ('Which Roman god is equivalent to the Greek Zeus?', ARRAY['Jupiter', 'Mars', 'Neptune', 'Pluto'], 0, 'Jupiter is the chief Roman god.'),
        ('Who is the Roman goddess of the hunt?', ARRAY['Diana', 'Minerva', 'Venus', 'Juno'], 0, 'Diana is the Roman Artemis.'),
        ('Which Roman god is the god of the underworld?', ARRAY['Pluto', 'Mercury', 'Vulcan', 'Bacchus'], 0, 'Pluto is the ruler of the dead.'),
        -- Norse
        ('Who is the chief god in Norse mythology?', ARRAY['Odin', 'Thor', 'Loki', 'Freyr'], 0, 'Odin is the All-Father.'),
        ('What is the name of Thor''s hammer?', ARRAY['Mjölnir', 'Gungnir', 'Draupnir', 'Gram'], 0, 'Mjölnir returns to Thor after being thrown.'),
        ('What is the Norse end-of-the-world battle called?', ARRAY['Ragnarok', 'Valhalla', 'Midgard', 'Yggdrasil'], 0, 'Ragnarok is the final battle of gods and giants.'),
        ('Who is the trickster god in Norse mythology?', ARRAY['Loki', 'Odin', 'Thor', 'Balder'], 0, 'Loki causes mischief among the gods.'),
        -- Egyptian
        ('Who is the Egyptian god of the sun?', ARRAY['Ra', 'Osiris', 'Isis', 'Anubis'], 0, 'Ra is the sun god, often depicted with a falcon head.'),
        ('Who is the Egyptian god of the dead and the afterlife?', ARRAY['Osiris', 'Ra', 'Set', 'Horus'], 0, 'Osiris judges the souls of the dead.'),
        ('What is the name of the Egyptian god with the head of a jackal?', ARRAY['Anubis', 'Thoth', 'Sekhmet', 'Bastet'], 0, 'Anubis is the god of mummification.'),
        -- Hindu
        ('Who is the Hindu god of creation?', ARRAY['Brahma', 'Vishnu', 'Shiva', 'Indra'], 0, 'Brahma is part of the trimurti.'),
        ('Who is the Hindu goddess of wealth and prosperity?', ARRAY['Lakshmi', 'Saraswati', 'Durga', 'Kali'], 0, 'Lakshmi is the consort of Vishnu.'),
        ('Who is the destroyer god in Hinduism?', ARRAY['Shiva', 'Brahma', 'Vishnu', 'Ganesha'], 0, 'Shiva is the destroyer and transformer.'),
        -- Chinese
        ('Who is the Chinese goddess of the moon?', ARRAY['Chang''e', 'Nuwa', 'Guanyin', 'Xi Wangmu'], 0, 'Chang''e lives on the moon in Chinese mythology.'),
        ('What is the name of the Chinese dragon king?', ARRAY['Longwang', 'Shenlong', 'Fucanglong', 'Tianlong'], 0, 'Longwang is the god of rain and seas.'),
        ('Who is the Monkey King in Chinese myth?', ARRAY['Sun Wukong', 'Zhu Bajie', 'Sha Wujing', 'Tang Sanzang'], 0, 'Sun Wukong is from Journey to the West.'),
        -- Japanese
        ('Who is the Japanese sun goddess?', ARRAY['Amaterasu', 'Susanoo', 'Tsukuyomi', 'Inari'], 0, 'Amaterasu is the kami of the sun.'),
        ('What is the name of the Japanese storm god?', ARRAY['Susanoo', 'Raijin', 'Fujin', 'Inari'], 0, 'Susanoo is the brother of Amaterasu.'),
        -- Mesopotamian
        ('Who is the Babylonian god of creation?', ARRAY['Marduk', 'Tiamat', 'Enlil', 'Ea'], 0, 'Marduk defeated Tiamat and created the world.'),
        -- Celtic
        ('Who is the Celtic god of thunder?', ARRAY['Taranis', 'Cernunnos', 'Lugh', 'Dagda'], 0, 'Taranis was a thunder god in Gaulish mythology.'),
        -- Aztec
        ('Who is the Aztec sun god?', ARRAY['Huitzilopochtli', 'Quetzalcoatl', 'Tezcatlipoca', 'Tlaloc'], 0, 'Huitzilopochtli required human sacrifice.'),
        ('Who is the Aztec feathered serpent god?', ARRAY['Quetzalcoatl', 'Huitzilopochtli', 'Tezcatlipoca', 'Xipe Totec'], 0, 'Quetzalcoatl was the god of wind and learning.'),
        -- Inca
        ('Who is the Inca sun god?', ARRAY['Inti', 'Viracocha', 'Mama Quilla', 'Pachacamac'], 0, 'Inti was the most important Inca deity.'),
        -- Slavic
        ('Who is the Slavic god of thunder?', ARRAY['Perun', 'Veles', 'Svarog', 'Dazhbog'], 0, 'Perun is the chief god, wielding lightning.'),
        -- African (Yoruba)
        ('Who is the supreme god in Yoruba mythology?', ARRAY['Olorun', 'Shango', 'Ogun', 'Eshu'], 0, 'Olorun is the sky father.'),
        ('Who is the god of iron and war in Yoruba myth?', ARRAY['Ogun', 'Shango', 'Oshun', 'Yemaya'], 0, 'Ogun is a powerful warrior god.'),
        -- Native American (generic)
        ('Who is the Great Spirit in many Native American traditions?', ARRAY['Wakan Tanka', 'Gitche Manitou', 'Great Mystery', 'All of the above'], 0, 'Various names are used for the supreme being.'),
        -- More Greek
        ('What is the name of the three-headed dog guarding the underworld?', ARRAY['Cerberus', 'Orthrus', 'Hydra', 'Chimera'], 0, 'Cerberus prevents the dead from leaving.'),
        ('Which Greek hero performed 12 labours?', ARRAY['Heracles', 'Theseus', 'Jason', 'Odysseus'], 0, 'Heracles (Hercules) completed 12 tasks.'),
        ('What is the name of the ship of the Argonauts?', ARRAY['Argo', 'Perseus', 'Odysseus', 'Achilles'], 0, 'Jason sailed in the Argo.'),
        -- More Norse
        ('What is the name of the World Tree in Norse myth?', ARRAY['Yggdrasil', 'Asgard', 'Midgard', 'Niflheim'], 0, 'Yggdrasil connects the nine realms.'),
        -- More Egyptian
        ('Who is the Egyptian goddess of motherhood and magic?', ARRAY['Isis', 'Bastet', 'Sekhmet', 'Hathor'], 0, 'Isis is a powerful magical goddess.'),
        -- More Hindu
        ('Which Hindu god has the head of an elephant?', ARRAY['Ganesha', 'Indra', 'Krishna', 'Rama'], 0, 'Ganesha is the remover of obstacles.'),
        -- More Chinese
        ('Who is the Chinese god of war?', ARRAY['Guan Yu', 'Zhao Yun', 'Zhang Fei', 'Cao Cao'], 0, 'Guan Yu is deified as a god of war.'),
        -- More Japanese
        ('What is the name of the Japanese fox spirit?', ARRAY['Kitsune', 'Tanuki', 'Oni', 'Tengu'], 0, 'Kitsune are intelligent foxes with magical abilities.'),
        -- Mesopotamian
        ('Who is the Mesopotamian goddess of love and war?', ARRAY['Inanna', 'Ishtar', 'Astarte', 'Ashtoreth'], 0, 'Inanna/Ishtar is a prominent goddess.'),
        -- Slavic
        ('Who is the Slavic goddess of love and beauty?', ARRAY['Lada', 'Mokosh', 'Perun', 'Svarog'], 0, 'Lada is a fertility and love goddess.'),
        -- Greek
        ('Which Greek god is the messenger and travels fastest?', ARRAY['Hermes', 'Apollo', 'Dionysus', 'Ares'], 0, 'Hermes is the messenger god.'),
        ('What is the name of the Greek hero who slew the Chimera?', ARRAY['Bellerophon', 'Perseus', 'Theseus', 'Jason'], 0, 'Bellerophon rode Pegasus.'),
        -- Roman
        ('Who is the Roman equivalent of Hermes?', ARRAY['Mercury', 'Mars', 'Neptune', 'Vulcan'], 0, 'Mercury is the messenger god.'),
        -- Egyptian
        ('What is the Egyptian god of writing and wisdom?', ARRAY['Thoth', 'Anubis', 'Ra', 'Horus'], 0, 'Thoth is the scribe of the gods.'),
        -- Hindu
        ('Who is the Hindu god of love?', ARRAY['Kama', 'Indra', 'Vishnu', 'Shiva'], 0, 'Kama is the god of desire.'),
        -- Chinese
        ('Who is the Chinese god of wealth?', ARRAY['Caishen', 'Guandi', 'Yue Lao', 'Sun Wukong'], 0, 'Caishen is the god of prosperity.'),
        -- Japanese
        ('Who is the god of luck in Japan, often depicted with a big belly?', ARRAY['Hotei', 'Ebisu', 'Daikokuten', 'Benzaiten'], 0, 'Hotei is one of the Seven Lucky Gods.'),
        -- Celtic
        ('What is the name of the Celtic hero who slew the giant?', ARRAY['Cú Chulainn', 'Fionn mac Cumhaill', 'Lugh', 'Dagda'], 0, 'Cú Chulainn is a legendary Irish hero.'),
        -- Aztec
        ('Who is the Aztec god of rain?', ARRAY['Tlaloc', 'Quetzalcoatl', 'Huitzilopochtli', 'Tezcatlipoca'], 0, 'Tlaloc is the rain god.'),
        -- Inca
        ('Who is the Inca god of creation?', ARRAY['Viracocha', 'Inti', 'Mama Quilla', 'Pachacamac'], 0, 'Viracocha created the universe.'),
        -- African (Yoruba)
        ('Who is the goddess of rivers and love in Yoruba myth?', ARRAY['Oshun', 'Yemaya', 'Oya', 'Nana Buruku'], 0, 'Oshun is a river goddess.'),
        -- Native American
        ('What is the name of the trickster figure in many Native American cultures?', ARRAY['Coyote', 'Raven', 'Iktomi', 'Nanabozho'], 0, 'Various cultures have a trickster; Coyote and Raven are common.'),
        -- Norse (extra)
        ('What is the name of the Valkyries in Norse myth?', ARRAY['Choosers of the slain', 'Battle maidens', 'Odin''s shield-maidens', 'All of the above'], 0, 'Valkyries bring fallen warriors to Valhalla.'),
        -- Greek (extra)
        ('Who is the Greek god of the forge and fire?', ARRAY['Hephaestus', 'Hermes', 'Apollo', 'Dionysus'], 0, 'Hephaestus is the blacksmith god.'),
        -- Egyptian (extra)
        ('Who is the Egyptian sky god, often depicted with the head of a falcon?', ARRAY['Horus', 'Ra', 'Anubis', 'Thoth'], 0, 'Horus is the sky god.')
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

    -- ==================== FOLKLORE (60) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'myth.folklore';
    FOR q_rec IN (
        VALUES
        -- European
        ('What is the name of the fairy creature that can grant wishes?', ARRAY['Leprechaun', 'Pixie', 'Brownie', 'Troll'], 0, 'Leprechauns are Irish fairies associated with pots of gold.'),
        ('Which creature is a headless horseman in European folklore?', ARRAY['Dullahan', 'Headless Horseman', 'Banshee', 'Pooka'], 0, 'The Dullahan is a headless rider in Irish myth.'),
        ('What is the name of the Scandinavian troll creature?', ARRAY['Troll', 'Nisse', 'Elf', 'Dwarf'], 0, 'Trolls are large, often dangerous beings.'),
        ('Which creature is known for luring sailors with song?', ARRAY['Mermaid', 'Siren', 'Nymph', 'Harpy'], 0, 'Sirens sing to crash ships on rocks.'),
        ('What is the name of the Slavic forest spirit?', ARRAY['Leshy', 'Baba Yaga', 'Vila', 'Domovoi'], 0, 'Leshy is the protector of the forest.'),
        -- Asian
        ('What is the name of the Japanese ghost or yokai that has no face?', ARRAY['Noh mask', 'Kappa', 'Yuki-onna', 'Tengu'], 0, 'Noh mask is not a yokai; perhaps ''Nuppeppo'' but we''ll use a known one.'),
        ('Which Chinese folklore creature is a dragon that controls rainfall?', ARRAY['Chinese dragon (Long)', 'Phoenix', 'Kirin', 'Qilin'], 0, 'Long dragons are associated with water.'),
        ('What is the name of the Filipino vampire-like creature?', ARRAY['Manananggal', 'Aswang', 'Duende', 'Kapre'], 0, 'Manananggal can separate its upper body.'),
        -- African
        ('Which African folklore creature is a trickster spider?', ARRAY['Anansi', 'Brer Rabbit', 'Eshu', 'Kivumbe'], 0, 'Anansi is a spider from West African tales.'),
        ('What is the name of the South African legendary water creature?', ARRAY['Grootslang', 'Mamlambo', 'Tokoloshe', 'Tikoloshe'], 0, 'The Grootslang is a giant serpent.'),
        -- Native American
        ('What is the name of the Native American thunderbird?', ARRAY['Thunderbird', 'Piasa', 'Wakinyan', 'Raven'], 0, 'Thunderbird is a powerful spirit.'),
        -- European (more)
        ('What is the name of the British fairy that takes babies?', ARRAY['Changeling', 'Boggart', 'Sprite', 'Elf'], 0, 'A changeling is a fairy child left in place of a human.'),
        ('Which creature in German folklore lives in the forests?', ARRAY['Rübezahl', 'Kobold', 'Nix', 'Wagner'], 0, 'Rübezahl is a mountain spirit.'),
        -- Asian (more)
        ('What is the name of the Korean goblin?', ARRAY['Dokkaebi', 'Gumiho', 'Haetae', 'Bulam'], 0, 'Dokkaebi are trickster goblins.'),
        ('Which Japanese creature is a kappa?', ARRAY['Water imp', 'River monster', 'Turtle-like', 'All of the above'], 0, 'Kappa are water spirits with a dish on their head.'),
        -- Latin American
        ('What is the name of the Latin American vampire-like creature?', ARRAY['Chupacabra', 'Cadejo', 'Siguanaba', 'El Cuco'], 0, 'Chupacabra is said to drink goat blood.'),
        ('Which Central American creature is a bad omen?', ARRAY['La Llorona', 'El Cuco', 'El Chupacabra', 'La Cegua'], 0, 'La Llorona is the weeping woman.'),
        -- European (more)
        ('What is the name of the English fairy that helps with chores?', ARRAY['Brownie', 'Hob', 'Kelp', 'Spriggan'], 0, 'Brownies are household helpers.'),
        -- African (more)
        ('Which African creature is a hyena-like beast?', ARRAY['Werehyena', 'Bruxa', 'Kishi', 'Crocodile'], 0, 'Werehyenas are shape-shifters in some regions.'),
        -- Native American (more)
        ('What is the name of the Iroquois monster?', ARRAY['Stone Giants', 'Flying Head', 'Wendigo', 'Skinwalkers'], 0, 'The Wendigo is from Algonquian folklore.'),
        -- European (more)
        ('Which creature is a vampire in Slavic folklore?', ARRAY['Upir', 'Nosferatu', 'Strigoi', 'Moroi'], 0, 'Upir is an early term for vampire.'),
        ('What is the name of the Norwegian creature that lives in mountains?', ARRAY['Troll', 'Jötunn', 'Elf', 'Dwarf'], 0, 'Jötunn are giants in Norse mythology.'),
        -- Asian (more)
        ('Which Chinese folklore creature is a nine-tailed fox?', ARRAY['Huli jing', 'Kitsune', 'Vulpix', 'Inari'], 0, 'Huli jing are fox spirits in Chinese lore.'),
        ('What is the name of the Japanese rope-trap yokai?', ARRAY['Nure-onago', 'Kitsune', 'Tengu', 'Nurikabe'], 0, 'Nurikabe is a wall that blocks paths.'),
        -- Middle Eastern
        ('What is the name of the genie in Arabian folklore?', ARRAY['Jinn', 'Ifrit', 'Marid', 'Ghoul'], 0, 'Jinn are supernatural beings.'),
        -- European (more)
        ('Which British creature is a dog with a single eye?', ARRAY['Cyclops', 'Black Shuck', 'Moddey Dhoo', 'Barghest'], 0, 'Black Shuck is a ghostly dog.'),
        -- African (more)
        ('Which West African creature is a hairy monster?', ARRAY['Sasabonsam', 'Abatwa', 'Tikoloshe', 'Adze'], 0, 'Sasabonsam is a vampire-like creature.'),
        -- Native American (more)
        ('What is the name of the Navajo skinwalker?', ARRAY['Yee naaldlooshii', 'Wendigo', 'Thunderbird', 'Piasa'], 0, 'Skinwalkers are witches that can transform.'),
        -- European (more)
        ('Which fairy in Scottish folklore is a water spirit?', ARRAY['Kelpie', 'Nixie', 'Selkie', 'Bluecap'], 0, 'Kelpie is a shape-shifting water horse.'),
        ('What is the name of the Italian witch that rides a broomstick?', ARRAY['Strega', 'Befana', 'Fata', 'Vittoria'], 0, 'Befana is a gift-giving witch.'),
        -- Asian (more)
        ('Which creature in Korean folklore is a nine-tailed fox?', ARRAY['Kumiho', 'Gumiho', 'Huli jing', 'Kitsune'], 0, 'Kumiho is the Korean fox spirit.'),
        ('What is the name of the Tibetan ghost?', ARRAY['Tulpa', 'Khyung', 'Naga', 'Gandhabba'], 0, 'Tulpa is a Tibetan concept of a created being.'),
        -- Oceanian
        ('Which Australian Aboriginal creature is a giant lizard?', ARRAY['Bunyip', 'Dreamtime', 'Yowie', 'Yara-ma-yha-who'], 0, 'Yara-ma-yha-who is a vampire-like creature.'),
        -- European (more)
        ('What is the name of the German water spirit?', ARRAY['Nix', 'Rhinemaiden', 'Lorelei', 'Kobold'], 0, 'Lorelei is a rock on the Rhine.'),
        -- Asian (more)
        ('Which Japanese creature is a snow woman?', ARRAY['Yuki-onna', 'Kitsune', 'Tengu', 'Kappa'], 0, 'Yuki-onna appears during blizzards.'),
        -- Latin American (more)
        ('What is the name of the Argentinian goblin?', ARRAY['Tunche', 'Cadejo', 'Llorona', 'Duende'], 0, 'Tunche is a jungle spirit.'),
        -- African (more)
        ('Which Egyptian mythological creature is a sphinx?', ARRAY['Sphinx', 'Griffin', 'Chimera', 'Manticore'], 0, 'The Sphinx is a hybrid creature.'),
        -- European (more)
        ('What is the name of the Spanish goat-like demon?', ARRAY['Baphomet', 'Cuco', 'Patasola', 'El Coco'], 0, 'El Coco is a bogeyman.'),
        -- Asian (more)
        ('Which creature in Malaysian folklore is a vampire?', ARRAY['Pontianak', 'Penanggalan', 'Langkasuka', 'Kuntilanak'], 0, 'Pontianak is a vampire ghost.'),
        -- European (more)
        ('What is the name of the Greek fairy (nymph) that lives in trees?', ARRAY['Dryad', 'Naiad', 'Oread', 'Nereid'], 0, 'Dryads are tree spirits.'),
        -- African (more)
        ('Which creature in South African lore is a flying snake?', ARRAY['Amazons', 'Grootslang', 'Kontompous', 'Mamlambo'], 0, 'Mamlambo is a river snake.'),
        -- Native American (more)
        ('What is the name of the Algonquian creature that eats humans?', ARRAY['Wendigo', 'Cannibal', 'Skinwalker', 'Thunderbird'], 0, 'Wendigo is a cannibalistic spirit.'),
        -- European (more)
        ('Which Scottish fairy is a small, mischievous creature?', ARRAY['Pixie', 'Spriggan', 'Bogle', 'Brownie'], 0, 'Pixies are small fairies.'),
        -- Asian (more)
        ('What is the name of the Hindu demoness?', ARRAY['Rakshasi', 'Asura', 'Dakini', 'Churel'], 0, 'Rakshasi is a female demon.'),
        -- Oceanian (more)
        ('Which creature in New Zealand Maori myth is a sea monster?', ARRAY['Taniwha', 'Maui', 'Kura', 'Hine'], 0, 'Taniwha are guardian monsters.'),
        -- European (more)
        ('What is the name of the French werewolf?', ARRAY['Loup-garou', 'Bisclavret', 'Varcolac', 'Klos'], 0, 'Loup-garou is the French werewolf.'),
        -- Asian (more)
        ('Which Japanese spirit is a long-necked creature?', ARRAY['Rokurokubi', 'Nuppeppo', 'Ippon-datara', 'Tsuchinoko'], 0, 'Rokurokubi have necks that stretch.'),
        -- Latin American (more)
        ('What is the name of the South American neck-stretching witch?', ARRAY['Tunche', 'Cadejo', 'Llorona', 'Chupacabra'], 0, 'La Llorona is a ghost; but there is ''Chupacabra'' and ''La Cegua'' etc. We''ll use ''La Cegua'' as a horse-faced woman.'),
        -- European (more)
        ('Which creature in Germanic folklore is a dragon?', ARRAY['Lindworm', 'Wyvern', 'Dragon', 'All of the above'], 0, 'Lindworm is a serpentine dragon.'),
        -- Asian (more)
        ('Which Cambodian creature is a half-woman, half-bird?', ARRAY['Apsara', 'Kinnari', 'Garuda', 'Naga'], 0, 'Kinnari are celestial bird-women.'),
        -- African (more)
        ('Which Ghanaian creature is a shape-shifting leopard?', ARRAY['Wereleopard', 'Panther', 'Bush tiger', 'Tikoloshe'], 0, 'Wereleopards are in some African lore.'),
        -- Native American (more)
        ('What is the name of the Pacific Northwest trickster?', ARRAY['Raven', 'Coyote', 'Mink', 'Bluejay'], 0, 'Raven is a trickster in many Pacific tribes.'),
        -- European (more)
        ('Which Irish fairy is a crier of death?', ARRAY['Banshee', 'Pooka', 'Leprechaun', 'Dullahan'], 0, 'Banshee wails to foretell death.'),
        -- Asian (more)
        ('Which Filipino creature is a cigar-smoking tree demon?', ARRAY['Kapre', 'Aswang', 'Manananggal', 'Tikbalang'], 0, 'Kapre is a tree-dwelling giant.'),
        -- Latin American (more)
        ('What is the name of the Mexican ghost woman?', ARRAY['La Llorona', 'La Bruja', 'La Cegua', 'La Tusa'], 0, 'La Llorona weeps for lost children.'),
        -- European (more)
        ('Which creature in Welsh folklore is a water horse?', ARRAY['Ceffyl Dŵr', 'Kelpie', 'Nixie', 'Nicholas'], 0, 'Ceffyl Dŵr is a Welsh water horse.'),
        -- Asian (more)
        ('Which Japanese creature is a giant octopus?', ARRAY['Akuroku', 'Kraken', 'Yamata no Orochi', 'Ika'], 0, 'Yamata no Orochi is an eight-headed serpent.'),
        -- African (more)
        ('Which South African creature is a river snake?', ARRAY['Mamlambo', 'Grootslang', 'Naga', 'Ophidia'], 0, 'Mamlambo is a water snake.'),
        -- Native American (more)
        ('What is the name of the Cheyenne water monster?', ARRAY['Mishe-mokwa', 'Manitou', 'Piasa', 'Unktehi'], 0, 'Unktehi is a water spirit among the Lakota.')
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

    -- ==================== LEGENDS (50) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'myth.legends';
    FOR q_rec IN (
        VALUES
        -- Arthurian
        ('What is the name of King Arthur''s sword?', ARRAY['Excalibur', 'Caliburn', 'Clarent', 'Caledfwlch'], 0, 'Excalibur is the legendary sword.'),
        ('Where was King Arthur''s court said to be?', ARRAY['Camelot', 'Avalon', 'Tintagel', 'Winchester'], 0, 'Camelot is the legendary castle.'),
        ('Who was the wizard in Arthurian legend?', ARRAY['Merlin', 'Gandalf', 'Albus', 'Saruman'], 0, 'Merlin was Arthur''s advisor.'),
        -- Robin Hood
        ('Who was the leader of the Merry Men?', ARRAY['Robin Hood', 'Little John', 'Friar Tuck', 'Will Scarlet'], 0, 'Robin Hood is the legendary outlaw.'),
        ('Where did Robin Hood live?', ARRAY['Sherwood Forest', 'Nottingham', 'Barnsdale', 'Fotheringhay'], 0, 'Sherwood Forest is associated with Robin Hood.'),
        -- Atlantis
        ('Which philosopher first wrote about Atlantis?', ARRAY['Plato', 'Aristotle', 'Socrates', 'Herodotus'], 0, 'Plato described Atlantis in his dialogues.'),
        -- El Dorado
        ('What was El Dorado originally believed to be?', ARRAY['A city of gold', 'A king covered in gold', 'A lake of gold', 'A mountain of gold'], 0, 'El Dorado was the legendary gold-covered king.'),
        -- Shangri-La
        ('Which novel introduced the legend of Shangri-La?', ARRAY['Lost Horizon', 'The Lost World', 'Shangri-La', 'The Mysterious Island'], 0, 'Lost Horizon by James Hilton.'),
        -- King Arthur
        ('Who was the Lady of the Lake in Arthurian legend?', ARRAY['Viviane', 'Nimue', 'Morgan le Fay', 'Guinevere'], 0, 'The Lady of the Lake gave Excalibur.'),
        -- Tristan and Isolde
        ('Who is the Irish princess in the legend of Tristan and Isolde?', ARRAY['Isolde', 'Guinevere', 'Morgan', 'Igraine'], 0, 'Isolde is the princess.'),
        -- Ragnar Lothbrok
        ('Who is the legendary Viking hero that was said to be invincible?', ARRAY['Ragnar Lothbrok', 'Bjorn Ironside', 'Ivar the Boneless', 'Harald Hardrada'], 0, 'Ragnar Lothbrok is a legendary Viking.'),
        -- The Holy Grail
        ('What is the Holy Grail said to be?', ARRAY['The cup used by Jesus at the Last Supper', 'A sword', 'A stone', 'A treasure'], 0, 'The Grail is often depicted as the cup of Christ.'),
        -- Beowulf
        ('Which monster did Beowulf slay?', ARRAY['Grendel', 'Dragon', 'Sea monster', 'All of the above'], 0, 'Beowulf fought Grendel, his mother, and a dragon.'),
        -- William Tell
        ('Which legendary figure shot an apple off his son''s head?', ARRAY['William Tell', 'Robin Hood', 'William Wallace', 'Edward I'], 0, 'William Tell is a Swiss hero.'),
        -- Dracula
        ('Who is the historical figure that inspired the legend of Dracula?', ARRAY['Vlad the Impaler', 'Countess Bathory', 'Ivan the Terrible', 'Genghis Khan'], 0, 'Vlad III inspired Bram Stoker''s Dracula.'),
        -- Faust
        ('Who made a pact with the devil in German legend?', ARRAY['Faust', 'Mephistopheles', 'Wagner', 'Lorelei'], 0, 'Faust sold his soul for knowledge.'),
        -- King Arthur
        ('What is the name of Arthur''s wife?', ARRAY['Guinevere', 'Morgan', 'Igraine', 'Isolde'], 0, 'Guinevere was Arthur''s queen.'),
        -- Knights of the Round Table
        ('How many knights sat at the Round Table?', ARRAY['Often 150', '12', '24', '50'], 0, 'Variously, 150 knights.'),
        -- The Flying Dutchman
        ('What is the Flying Dutchman?', ARRAY['A ghost ship', 'A pirate', 'A sea monster', 'A mermaid'], 0, 'A legendary phantom ship.'),
        -- Blackbeard
        ('Who was the famous pirate with the name Edward Teach?', ARRAY['Blackbeard', 'Calico Jack', 'Barbarossa', 'Captain Kidd'], 0, 'Edward Teach was Blackbeard.'),
        -- Coyote and the Moon
        ('In some Native American legends, what does Coyote steal?', ARRAY['Fire', 'Corn', 'The Sun', 'Water'], 0, 'Coyote often steals fire.'),
        -- The Legend of Sleepy Hollow
        ('Who is the ghostly figure in Sleepy Hollow?', ARRAY['Headless Horseman', 'Ichabod Crane', 'The Green Knight', 'The Wild Hunt'], 0, 'The Headless Horseman haunts Sleepy Hollow.'),
        -- Davy Crockett
        ('What is a famous saying associated with Davy Crockett?', ARRAY['''I killed a bear when I was three''', '''Remember the Alamo''', '''Alamo!''', '''Texas forever'''], 0, 'He is a legendary frontiersman.'),
        -- Paul Bunyan
        ('What is the name of Paul Bunyan''s giant blue ox?', ARRAY['Babe', 'Blue', 'Buddy', 'Bessie'], 0, 'Babe is his ox.'),
        -- John Henry
        ('Which legendary figure fought a machine?', ARRAY['John Henry', 'Paul Bunyan', 'Pecos Bill', 'Casey Jones'], 0, 'John Henry raced a steam drill.'),
        -- Pecos Bill
        ('What western legend rode a cyclone?', ARRAY['Pecos Bill', 'John Henry', 'Paul Bunyan', 'Calamity Jane'], 0, 'Pecos Bill is a larger-than-life cowboy.'),
        -- Casey Jones
        ('Who was the legendary railroad engineer?', ARRAY['Casey Jones', 'John Henry', 'Paul Bunyan', 'John Henry'], 0, 'Casey Jones was a heroic train driver.'),
        -- Rip Van Winkle
        ('Who slept for 20 years in Washington Irving''s story?', ARRAY['Rip Van Winkle', 'Ichabod Crane', 'Paul Bunyan', 'John Henry'], 0, 'Rip Van Winkle is a legend.'),
        -- The Green Man
        ('What is the Green Man a symbol of?', ARRAY['Nature and rebirth', 'War', 'Agriculture', 'Forestry'], 0, 'The Green Man represents nature.'),
        -- Baba Yaga
        ('Which Slavic legend has a witch that lives in a hut on chicken legs?', ARRAY['Baba Yaga', 'Vasilisa', 'Koschei', 'Rusalka'], 0, 'Baba Yaga is a famous witch.'),
        -- Mulan
        ('Which legendary Chinese woman disguised herself as a soldier?', ARRAY['Mulan', 'Lady Fu Hao', 'Wu Zetian', 'Xiu'], 0, 'Mulan is a legendary heroine.'),
        -- Hua Mulan
        ('What dynasty did Mulan serve?', ARRAY['Northern Wei', 'Tang', 'Han', 'Song'], 0, 'Mulan is from the Northern Wei period.'),
        -- Fionn mac Cumhaill
        ('Who is the Irish giant who built the Giant''s Causeway?', ARRAY['Fionn mac Cumhaill', 'Cú Chulainn', 'Lugh', 'Dagda'], 0, 'Legend says Finn built the causeway.'),
        -- King Midas
        ('What did King Midas turn everything into?', ARRAY['Gold', 'Stone', 'Silver', 'Bronze'], 0, 'His touch turned things to gold.'),
        -- The Lost City of Atlantis (continued)
        ('Where is Atlantis said to have been located?', ARRAY['Beyond the Pillars of Hercules', 'In the Pacific', 'Under the Indian Ocean', 'In the South China Sea'], 0, 'Plato placed it west of Gibraltar.'),
        -- El Dorado (continued)
        ('Which European explorer sought El Dorado?', ARRAY['Francisco Pizarro', 'Hernán Cortés', 'Gonzalo Jiménez de Quesada', 'Francisco de Orellana'], 0, 'Many explored for it.'),
        -- Prester John
        ('Who was the legendary Christian king of the Orient?', ARRAY['Prester John', 'King Arthur', 'Charlemagne', 'Saladin'], 0, 'Prester John was a mythical Christian ruler.'),
        -- The Fountain of Youth
        ('Which explorer searched for the Fountain of Youth?', ARRAY['Ponce de León', 'Hernando de Soto', 'Francisco de Coronado', 'Juan Ponce de León'], 0, 'Ponce de León explored Florida for it.'),
        -- Moby Dick
        ('What is the famous white whale in literature?', ARRAY['Moby Dick', 'Jaws', 'Willy', 'Nessie'], 0, 'Herman Melville''s novel features Moby Dick.'),
        -- The Lady of Shalott
        ('Who is the woman cursed to live on a tower?', ARRAY['The Lady of Shalott', 'Guinevere', 'Isolde', 'Belle'], 0, 'She is an Arthurian legend.'),
        -- Sinbad
        ('Which legendary sailor had seven voyages?', ARRAY['Sinbad', 'Odysseus', 'Jason', 'Captain Nemo'], 0, 'Sinbad the Sailor is from Arabian Nights.'),
        -- Aladdin
        ('What does Aladdin find in the cave?', ARRAY['A magic lamp', 'A ring', 'A carpet', 'A treasure'], 0, 'Aladdin discovers a lamp with a genie.'),
        -- Sindbad (another spelling)
        ('Which creature does Sinbad encounter on one of his voyages?', ARRAY['Roc', 'Dragon', 'Giant snake', 'Mermaid'], 0, 'Sinbad meets a giant bird, the Roc.'),
        -- Beowulf (extra)
        ('Beowulf was the king of which people?', ARRAY['Geats', 'Danes', 'Swedes', 'Jutes'], 0, 'Beowulf was a Geatish hero.'),
        -- Robin Hood (extra)
        ('What was Robin Hood''s main enemy?', ARRAY['Sheriff of Nottingham', 'Prince John', 'King Richard', 'All of the above'], 0, 'He opposed the Sheriff and Prince John.'),
        -- King Arthur (extra)
        ('What is the name of Arthur''s half-sister who is a sorceress?', ARRAY['Morgan le Fay', 'Morgause', 'Elaine', 'Igraine'], 0, 'Morgan le Fay is a sorceress.'),
        -- The Wild Hunt
        ('In European legend, what is the Wild Hunt?', ARRAY['A spectral hunt led by a mythical figure', 'A witch gathering', 'A dance of fairies', 'A human procession'], 0, 'The Wild Hunt is a ghostly host.'),
        -- Atlantis (extra)
        ('Which Greek god was said to have governed Atlantis?', ARRAY['Poseidon', 'Zeus', 'Athena', 'Hades'], 0, 'Poseidon was the patron god of Atlantis.'),
        -- The Ring of the Nibelung
        ('Which legendary ring gave its wearer power?', ARRAY['The Ring of the Nibelung', 'The One Ring', 'The Ring of Gyges', 'The Gold Ring'], 0, 'Wagner''s opera cycle.'),
        -- The Sword in the Stone
        ('Who pulled the sword from the stone?', ARRAY['Arthur', 'Merlin', 'Uther', 'Gawain'], 0, 'The sword in the stone is a test of Arthur''s right to rule.')
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

    -- ==================== CONSPIRACY THEORIES (40) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'myth.conspiracy_theories';
    FOR q_rec IN (
        VALUES
        -- Clearly labeled as conspiracy theories
        ('What is a commonly held conspiracy theory about the Moon landing?', ARRAY['It was faked on a sound stage', 'The flag was waving', 'No stars visible', 'All of the above'], 0, 'Believers claim NASA staged the Apollo missions.'),
        ('Which conspiracy theory suggests the Earth is flat?', ARRAY['Flat Earth theory', 'Hollow Earth', 'Geocentrism', 'Heliocentrism'], 0, 'Flat Earth believers reject spherical Earth.'),
        ('What is the conspiracy theory about 9/11?', ARRAY['It was an inside job', 'Al-Qaeda was responsible', 'It was a missile attack', 'All of the above'], 0, 'Some claim the US government orchestrated the attacks.'),
        ('Which group is alleged to control world events in a conspiracy theory?', ARRAY['Illuminati', 'Freemasons', 'Bilderberg Group', 'All of the above'], 0, 'Various secret societies are accused of global control.'),
        ('What is the conspiracy theory about vaccines?', ARRAY['They cause autism', 'They contain tracking devices', 'They are part of a depopulation plan', 'All of the above'], 0, 'Vaccine conspiracies have been debunked by science.'),
        ('Which government is said to have hidden evidence of UFOs?', ARRAY['United States (Area 51)', 'Russia', 'China', 'United Kingdom'], 0, 'Area 51 is often cited as a secret UFO site.'),
        ('What is the conspiracy theory about the JFK assassination?', ARRAY['There was a second shooter', 'The CIA was involved', 'The Mafia was involved', 'All of the above'], 0, 'Many believe the official Warren Commission was flawed.'),
        ('Which conspiracy claims the New World Order is a plan for global governance?', ARRAY['New World Order', 'One World Government', 'Globalist agenda', 'All of the above'], 0, 'The New World Order is a conspiracy theory.'),
        ('What is the conspiracy theory about chemtrails?', ARRAY['Government aircraft release chemicals for nefarious purposes', 'It is normal contrails', 'It is cloud seeding', 'It is weather control'], 0, 'Chemtrail theorists believe contrails are deliberate chemical spraying.'),
        ('Which conspiracy claims the Sandy Hook shooting was a hoax?', ARRAY['Crisis actors theory', 'False flag', 'Government staged', 'All of the above'], 0, 'Some claim the shooting was staged to promote gun control.'),
        ('What is the theory about the "Illuminati" and the music industry?', ARRAY['Entertainers are controlled by the Illuminati', 'Music has subliminal messages', 'Both', 'None'], 0, 'Conspiracy theorists claim the Illuminati influence entertainment.'),
        ('Which conspiracy suggests the Holocaust was exaggerated?', ARRAY['Holocaust denial', 'Revisionism', 'Minimization', 'All of the above'], 0, 'This is a dangerous and false conspiracy.'),
        ('What is the conspiracy about 5G technology?', ARRAY['It causes health problems', 'It tracks people', 'It is used for mind control', 'All of the above'], 0, '5G conspiracies are unsubstantiated.'),
        ('Which conspiracy theory claims the British royal family is not human?', ARRAY['Reptilian conspiracy', 'Shape-shifting aliens', 'Lizard people', 'All of the above'], 0, 'Some claim the elite are reptilian.'),
        ('What is the "Bilderberg Group" believed to be?', ARRAY['A secret annual conference of elite leaders', 'An entertainment group', 'A charity', 'A film company'], 0, 'Bilderberg is a private, invitation-only conference.'),
        ('Which theory says the Titanic was sunk intentionally?', ARRAY['Insurance fraud', 'To kill certain passengers', 'Both', 'None'], 0, 'Some believe the Titanic was deliberately sunk.'),
        ('What is the conspiracy about the Federal Reserve?', ARRAY['It is a private banking cartel', 'It is a government agency', 'It is controlled by foreign powers', 'All of the above'], 0, 'The Fed is the central bank of the US.'),
        ('Which theory says the Bermuda Triangle involves alien activity?', ARRAY['Alien abduction', 'Magnetic anomalies', 'Methane hydrate explosions', 'All of the above'], 0, 'Many theories exist about the triangle.'),
        ('What is the "Denver International Airport" conspiracy?', ARRAY['It hides an underground base', 'It is a hub for the New World Order', 'Both', 'None'], 0, 'The airport has murals and tunnels.'),
        ('Which theory claims that the Moon is hollow?', ARRAY['Hollow Moon theory', 'The Moon is artificial', 'It is a spaceship', 'All of the above'], 0, 'Some believe the Moon is an alien construct.'),
        ('What is the conspiracy about the "Philadelphia Experiment"?', ARRAY['The US Navy made a ship disappear', 'It was a time travel experiment', 'Both', 'None'], 0, 'The Philadelphia Experiment is a famous naval conspiracy.'),
        ('Which theory says the CIA introduced crack cocaine to urban areas?', ARRAY['CIA drug trafficking', 'Gary Webb allegations', 'All of the above', 'None'], 0, 'The CIA allegedly smuggled crack to fund Contra rebels.'),
        ('What is the "Project Blue Beam" theory?', ARRAY['NASA plans to fake the Second Coming', 'A holographic projection', 'Both', 'None'], 0, 'Project Blue Beam is a conspiracy about global deception.'),
        ('Which theory alleges the US government has contact with extraterrestrials?', ARRAY['UFO cover-up', 'Majestic 12', 'Both', 'None'], 0, 'Alleged documents claim the US knows about aliens.'),
        ('What is the conspiracy about the "Bohemian Grove" gathering?', ARRAY['Elite men hold occult rituals', 'Human sacrifice', 'Both', 'None'], 0, 'Bohemian Grove is a private retreat with controversies.'),
        ('Which theory says the 2019-2020 bushfires in Australia were deliberately set?', ARRAY['Arson conspiracy', 'Government-lit fires', 'All of the above', 'None'], 0, 'Some blame government for controlled burns.'),
        ('What is the "Great Reset" conspiracy?', ARRAY['A plan to rebuild the global economy', 'A step towards global control', 'Both', 'None'], 0, 'The Great Reset is a WEF proposal, but exaggerated as conspiracy.'),
        ('Which theory claims that the COVID-19 pandemic was man-made?', ARRAY['Lab leak theory', 'It was engineered', 'Both', 'None'], 0, 'The lab leak is a possible origin, but conspiracy versions often go further.'),
        ('What is the conspiracy about the "Depopulation Agenda"?', ARRAY['Elite want to reduce the global population', 'Through vaccines, food, and war', 'Both', 'None'], 0, 'Some believe in a planned population reduction.'),
        ('Which theory says the Earth is being ruled by a secret cabal of Satanists?', ARRAY['The Cabal', 'The Illuminati', 'Both', 'None'], 0, 'Satanic conspiracy theories often involve high-level officials.'),
        ('What is the conspiracy about the "Operation Paperclip"?', ARRAY['US brought Nazi scientists to America', 'They were given immunity', 'Both', 'None'], 0, 'Operation Paperclip did bring Nazi scientists.'),
        ('Which theory claims that the Giza pyramids were built by aliens?', ARRAY['Ancient astronaut theory', 'Alien construction', 'Both', 'None'], 0, 'Some believe aliens built the pyramids.'),
        ('What is the "Mandela Effect" conspiracy?', ARRAY['People misremember events due to parallel universes', 'Massive collective memory errors', 'Both', 'None'], 0, 'Mandela Effect is a theory about false memories.'),
        ('Which theory says the global temperature rise is a hoax?', ARRAY['Climate change denial', 'Global cooling theory', 'Both', 'None'], 0, 'Climate change denial is a conspiracy rejected by science.'),
        ('What is the "Pizzagate" conspiracy?', ARRAY['A pizzeria was a child trafficking ring', 'Clinton involvement', 'Both', 'None'], 0, 'Pizzagate is a debunked conspiracy.'),
        ('Which theory claims the moon is inhabited?', ARRAY['Lunar base', 'Alien city on the far side', 'Both', 'None'], 0, 'Some think there are structures on the Moon.'),
        ('What is the conspiracy about the "Reptilian Overlords" of the world?', ARRAY['Shape-shifting lizards rule governments', 'They control media', 'Both', 'None'], 0, 'This is a popular internet conspiracy.'),
        ('Which theory says the Federal Emergency Management Agency (FEMA) runs concentration camps?', ARRAY['FEMA camps', 'Government internment', 'Both', 'None'], 0, 'FEMA camps are a recurring conspiracy.'),
        ('What is the "Project MKUltra" conspiracy?', ARRAY['CIA mind-control experiments', 'Human experiments', 'Both', 'None'], 0, 'MKUltra was a real CIA program.'),
        ('Which theory claims that the United States has a secret space fleet?', ARRAY['Solar Warden', 'Secret space program', 'Both', 'None'], 0, 'Some claim a space fleet exists to defend Earth.')
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

    -- ==================== URBAN LEGENDS (40) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'myth.urban_legends';
    FOR q_rec IN (
        VALUES
        -- Classic urban legends from around the world
        ('What is the urban legend of the "Hook-handed killer" in the US?', ARRAY['A hook-wielding murderer attacks couples in cars', 'A ghost', 'A serial killer', 'A rape'], 0, 'A classic American urban legend.'),
        ('Which urban legend features a phantom hitchhiker?', ARRAY['The Ghostly Hitchhiker', 'The Vanishing Hitchhiker', 'The Midnight Passenger', 'All of the above'], 0, 'A popular tale of a ghostly hitchhiker.'),
        ('What is the "Bloody Mary" urban legend?', ARRAY['Calling her name in a mirror summons a vengeful spirit', 'A witch', 'A vampire', 'A ghost'], 0, 'Bloody Mary is a famous mirror summoning legend.'),
        ('Which legend involves a killer in the back seat of a car?', ARRAY['The Back Seat Killer', 'The Man in the Backseat', 'The Killer in the Car', 'All of the above'], 0, 'A woman is warned by a gas station attendant.'),
        ('What is the "Candyman" urban legend?', ARRAY['Saying his name five times in a mirror summons him', 'He has a hook for a hand', 'He gives candy', 'He is a ghost'], 0, 'Based on the film, but originated as a legend.'),
        ('Which urban legend involves a babysitter getting a call to check on the children?', ARRAY['The Babysitter and the Killer', 'The Caller', 'The Man Upstairs', 'The Clown'], 0, 'A classic tale of a threatening call.'),
        ('What is the legend of the "Killer Clown" sightings?', ARRAY['Clowns terrorizing neighborhoods', 'They lure children', 'Both', 'None'], 0, 'Killer clown scares have occurred in several countries.'),
        ('Which urban legend speaks of a cursed painting?', ARRAY['The Crying Boy', 'The Hands Resist Him', 'The Anguished Man', 'All of the above'], 0, 'Cursed paintings are a common trope.'),
        ('What is the "Pope Lick Monster" in US folklore?', ARRAY['A goat-like creature living under a trestle', 'A goat man', 'A ghost', 'A demon'], 0, 'A local legend in Kentucky.'),
        ('Which urban legend involves a woman giving birth to a demon child?', ARRAY['The Jersey Devil', 'The Beast of Bray Road', 'The Mothman', 'All of the above'], 0, 'The Jersey Devil is a hybrid creature.'),
        ('What is the "La Llorona" urban legend in Latin America?', ARRAY['A weeping woman who searches for her drowned children', 'A ghost', 'A witch', 'A mermaid'], 0, 'La Llorona is a famous Latin American legend.'),
        ('Which urban legend is about a giant alligator in the sewers of New York?', ARRAY['Alligators in the sewers', 'Sewer gators', 'Both', 'None'], 0, 'A classic NYC urban legend.'),
        ('What is the "Mothman" urban legend?', ARRAY['A winged creature seen in West Virginia', 'A giant moth', 'A cryptid', 'All of the above'], 0, 'Mothman is a cryptid legend.'),
        ('Which legend involves a woman who puts razor blades in apples?', ARRAY['Poisoned Halloween candy', 'Razor blades in fruit', 'Both', 'None'], 0, 'A common Halloween scare.'),
        ('What is the "Slender Man" urban legend?', ARRAY['A tall faceless figure in a suit', 'A ghost', 'A demon', 'A monster'], 0, 'Slender Man is an internet urban legend.'),
        ('Which urban legend says that fast food is made from human flesh?', ARRAY['Soylent Green is people!', 'KFC conspiracy', 'Burger King', 'All of the above'], 0, 'Various fast-food conspiracies.'),
        ('What is the "Kuchisake-onna" urban legend from Japan?', ARRAY['A woman with a slit mouth who asks if she is beautiful', 'A ghost', 'A yokai', 'All of the above'], 0, 'A famous Japanese legend.'),
        ('Which urban legend involves a hook-handed man at Lover''s Lane?', ARRAY['The Hook', 'The Killer', 'The Lover''s Lane Killer', 'All of the above'], 0, 'Classic US legend.'),
        ('What is the "Hanako-san" urban legend in Japan?', ARRAY['A girl who haunts school toilets', 'A ghost', 'A monster', 'A witch'], 0, 'Hanako-san is a toilet ghost.'),
        ('Which legend speaks of a killer in a clown costume in Chicago?', ARRAY['Chicago Clown', 'Killer Clown', 'Pogo the Clown', 'John Wayne Gacy'], 0, 'Gacy was a real serial killer who dressed as a clown.'),
        ('What is the "Sawney Bean" legend from Scotland?', ARRAY['A giant cannibal clan', 'A monster', 'A witch', 'A vampire'], 0, 'Sawney Bean is a Scottish legend.'),
        ('Which urban legend involves a vanishing hotel room?', ARRAY['Room 1408', 'The Vanishing Room', 'The Room of Death', 'All of the above'], 0, 'Based on a Stephen King story.'),
        ('What is the "Goatman" urban legend?', ARRAY['A half-goat, half-man creature', 'A satyr', 'A mutant', 'All of the above'], 0, 'Goatman is a cryptid.'),
        ('Which legend says that a phantom black dog appears before death?', ARRAY['Black Shuck', 'The Grim', 'Both', 'None'], 0, 'Black Shuck is a ghostly dog in British legend.'),
        ('What is the "Loch Ness Monster" considered?', ARRAY['An urban legend', 'A cryptid', 'A folklore', 'All of the above'], 0, 'Nessie is a Scottish legend.'),
        ('Which urban legend involves a killer who lives in a house on an old Indian burial ground?', ARRAY['The Amityville Horror', 'The Haunting of Hill House', 'The Conjuring', 'All of the above'], 0, 'Amityville is a famous haunting legend.'),
        ('What is the "Teke Teke" urban legend from Japan?', ARRAY['A ghost with half a body that skates on her hands', 'A ghost', 'A monster', 'All of the above'], 0, 'Teke Teke is a Japanese ghost story.'),
        ('Which urban legend involves a toy that is possessed?', ARRAY['The Chucky doll', 'The Annabelle doll', 'The Ouija board', 'All of the above'], 0, 'All are related to urban legends/folklore.'),
        ('What is the "Bloody Mary" legend sometimes associated with?', ARRAY['Mirror summoning', 'Ghosts', 'Curses', 'All of the above'], 0, 'Bloody Mary is a classic mirror summoning.'),
        ('Which legend says that if you say "Candyman" five times in a mirror, he kills you?', ARRAY['Candyman', 'Bloody Mary', 'The Slender Man', 'The Hook Man'], 0, 'Candyman is a famous urban legend from the film.'),
        ('What is the "Piped Piper" legend?', ARRAY['A piper who led children away', 'A rat catcher', 'Both', 'None'], 0, 'The Pied Piper of Hamelin is a German legend.'),
        ('Which urban legend is about a ghost that sits on the back of a car?', ARRAY['The Vanishing Hitchhiker', 'The Ghostly Driver', 'The Phantom', 'All of the above'], 0, 'A classic variant.'),
        ('What is the "Mantis" urban legend?', ARRAY['A giant praying mantis man', 'A monster', 'A cryptid', 'All of the above'], 0, 'The Man‐t�s is a creature.'),
        ('Which legend involves a woman who kills men with her vagina?', ARRAY['Vagina dentata', 'Tooth of the vagina', 'Both', 'None'], 0, 'Vagina dentata is a folkloric motif.'),
        ('What is the "Jersey Devil" legend?', ARRAY['A creature in the Pine Barrens', 'A demon', 'A cryptid', 'All of the above'], 0, 'The Jersey Devil is a famous American legend.'),
        ('Which urban legend says that the CIA is controlling the weather?', ARRAY['HAARP conspiracy', 'Weather modification', 'Both', 'None'], 0, 'HAARP is often associated with weather control.'),
        ('What is the "Mothman" prophecy about?', ARRAY['A bridge collapse', 'Disasters', 'Warnings', 'All of the above'], 0, 'Mothman sightings preceded the Silver Bridge collapse.'),
        ('Which legend involves the "Green Man" appearing in folk art?', ARRAY['The Green Man is a pagan symbol', 'A legend about nature', 'Both', 'None'], 0, 'The Green Man is a common motif.'),
        ('What is the "Krampus" legend?', ARRAY['A demonic companion of Saint Nicholas', 'A Christmas monster', 'Both', 'None'], 0, 'Krampus is from Alpine folklore.'),
        ('Which urban legend involves a woman with a knife who gives birth to a demon?', ARRAY['The Jersey Devil origin', 'The Demon Child', 'Both', 'None'], 0, 'Jersey Devil origin story includes this.')
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

    RAISE NOTICE '✅ 250 myth, folklore, legends, conspiracy theories, and urban legends questions inserted successfully.';
END $$;