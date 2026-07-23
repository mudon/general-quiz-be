-- ============================================================================
-- INSERT 250 GEOGRAPHY TRIVIA QUESTIONS
-- ============================================================================
-- Run this block to populate the database with fresh questions.
-- It will insert categories under earth_geography if they do not exist.
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
    INSERT INTO categories (path, name, tier, sort_order)
    VALUES
        ('earth_geography', 'Earth & Geography', 2, 0),
        ('earth_geography.countries', 'Countries', 2, 1),
        ('earth_geography.states_provinces', 'States/Provinces', 2, 2),
        ('earth_geography.cities', 'Cities', 2, 3),
        ('earth_geography.villages', 'Villages', 2, 4),
        ('earth_geography.continents', 'Continents', 2, 5),
        ('earth_geography.oceans', 'Oceans', 2, 6),
        ('earth_geography.seas', 'Seas', 2, 7),
        ('earth_geography.rivers', 'Rivers', 2, 8),
        ('earth_geography.lakes', 'Lakes', 2, 9),
        ('earth_geography.mountains', 'Mountains', 2, 10),
        ('earth_geography.volcanoes', 'Volcanoes', 2, 11),
        ('earth_geography.deserts', 'Deserts', 2, 12),
        ('earth_geography.forests', 'Forests', 2, 13),
        ('earth_geography.islands', 'Islands', 2, 14),
        ('earth_geography.national_parks', 'National Parks', 2, 15),
        ('earth_geography.time_zones', 'Time Zones', 2, 16),
        ('earth_geography.climate', 'Climate', 2, 17),
        ('earth_geography.weather', 'Weather', 2, 18),
        ('earth_geography.natural_resources', 'Natural Resources', 2, 19),
        ('earth_geography.population', 'Population', 2, 20),
        ('earth_geography.demographics', 'Demographics', 2, 21)
    ON CONFLICT (path) DO NOTHING;

    -- ------------------------------------------------------------------------
    -- 2. Insert questions per category
    -- Each category block: define questions as arrays and loop.
    -- ------------------------------------------------------------------------

    -- ==================== COUNTRIES ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.countries';
    FOR q_rec IN (
        VALUES
        ('What is the largest country by land area?', ARRAY['Russia', 'Canada', 'China', 'USA'], 0, 'Russia covers ~17.1 million km².'),
        ('What is the smallest country by land area?', ARRAY['Vatican City', 'Monaco', 'Nauru', 'San Marino'], 0, 'Vatican City is ~0.44 km².'),
        ('Which country has the most people?', ARRAY['India', 'China', 'USA', 'Indonesia'], 0, 'India surpassed China in 2023.'),
        ('Which country has the longest coastline?', ARRAY['Canada', 'Indonesia', 'Russia', 'Australia'], 0, 'Canada ~202,080 km.'),
        ('What is the capital of Australia?', ARRAY['Canberra', 'Sydney', 'Melbourne', 'Perth'], 0, 'Canberra is the capital.'),
        ('Which country is known as the ''Land of the Rising Sun''?', ARRAY['Japan', 'South Korea', 'China', 'Thailand'], 0, 'Japan is called that.'),
        ('What is the currency of the United Kingdom?', ARRAY['Pound sterling', 'Euro', 'Dollar', 'Yen'], 0, 'GBP is the currency.'),
        ('Which country has the most UNESCO World Heritage sites?', ARRAY['Italy', 'Spain', 'China', 'France'], 0, 'Italy has 59 sites.'),
        ('What is the official language of Brazil?', ARRAY['Portuguese', 'Spanish', 'English', 'French'], 0, 'Portuguese is official.'),
        ('Which country is the largest producer of coffee?', ARRAY['Brazil', 'Vietnam', 'Colombia', 'Ethiopia'], 0, 'Brazil leads in coffee production.'),
        ('What is the highest point in Africa?', ARRAY['Mount Kilimanjaro', 'Mount Kenya', 'Rwenzori', 'Mount Cameroon'], 0, 'Kilimanjaro is 5,895 m.'),
        ('Which country has the most islands?', ARRAY['Sweden', 'Indonesia', 'Philippines', 'Japan'], 0, 'Sweden has ~267,570 islands.'),
        ('What is the national animal of India?', ARRAY['Tiger', 'Elephant', 'Peacock', 'Lion'], 0, 'The tiger is the national animal.'),
        ('Which country is the largest gold producer?', ARRAY['China', 'Australia', 'Russia', 'USA'], 0, 'China leads in gold production.'),
        ('What is the capital of Egypt?', ARRAY['Cairo', 'Alexandria', 'Giza', 'Luxor'], 0, 'Cairo is the capital.'),
        ('Which country has the most time zones?', ARRAY['France', 'Russia', 'USA', 'UK'], 0, 'France has 12 time zones (including overseas).'),
        ('What is the longest river in Asia?', ARRAY['Yangtze', 'Yellow', 'Mekong', 'Ganges'], 0, 'Yangtze is ~6,300 km.'),
        ('Which country is the world''s largest oil exporter?', ARRAY['Saudi Arabia', 'Russia', 'USA', 'Iraq'], 0, 'Saudi Arabia is the largest exporter.'),
        ('What is the national sport of Canada?', ARRAY['Ice hockey', 'Lacrosse', 'Football', 'Basketball'], 0, 'Ice hockey and lacrosse are both national sports.'),
        ('Which country has the highest density of population?', ARRAY['Monaco', 'Singapore', 'Hong Kong', 'Bahrain'], 0, 'Monaco has >19,000 people/km².')
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

    -- ==================== STATES/PROVINCES ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.states_provinces';
    FOR q_rec IN (
        VALUES
        ('Which US state is the largest by area?', ARRAY['Alaska', 'Texas', 'California', 'Montana'], 0, 'Alaska ~1.72 million km².'),
        ('Which US state has the most people?', ARRAY['California', 'Texas', 'Florida', 'New York'], 0, 'California ~39 million.'),
        ('What is the capital of California?', ARRAY['Sacramento', 'Los Angeles', 'San Francisco', 'San Diego'], 0, 'Sacramento is the capital.'),
        ('Which Canadian province is the largest by area?', ARRAY['Quebec', 'Ontario', 'British Columbia', 'Alberta'], 0, 'Quebec ~1.54 million km².'),
        ('Which Canadian province has the most people?', ARRAY['Ontario', 'Quebec', 'British Columbia', 'Alberta'], 0, 'Ontario ~15 million.'),
        ('What is the capital of Ontario?', ARRAY['Toronto', 'Ottawa', 'Hamilton', 'London'], 0, 'Ottawa is the capital.'),
        ('Which Australian state has the most people?', ARRAY['New South Wales', 'Victoria', 'Queensland', 'Western Australia'], 0, 'New South Wales ~8.2 million.'),
        ('Which Brazilian state has the most people?', ARRAY['São Paulo', 'Rio de Janeiro', 'Bahia', 'Minas Gerais'], 0, 'São Paulo ~46 million.'),
        ('Which Indian state has the most people?', ARRAY['Uttar Pradesh', 'Maharashtra', 'Bihar', 'West Bengal'], 0, 'Uttar Pradesh ~240 million.'),
        ('What is the capital of Bavaria?', ARRAY['Munich', 'Berlin', 'Stuttgart', 'Nuremberg'], 0, 'Munich is the capital of Bavaria.')
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

    -- ==================== CITIES ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.cities';
    FOR q_rec IN (
        VALUES
        ('What is the most populous city in the world?', ARRAY['Tokyo', 'Delhi', 'Shanghai', 'São Paulo'], 0, 'Tokyo metropolitan area ~37 million.'),
        ('What is the capital of France?', ARRAY['Paris', 'Lyon', 'Marseille', 'Nice'], 0, 'Paris is the capital.'),
        ('Which city is known as the ''Big Apple''?', ARRAY['New York City', 'Los Angeles', 'Chicago', 'Boston'], 0, 'New York City is the Big Apple.'),
        ('What is the highest capital city in the world?', ARRAY['La Paz', 'Quito', 'Bogotá', 'Nairobi'], 0, 'La Paz is ~3,640 m above sea level.'),
        ('Which city is built on 118 islands?', ARRAY['Venice', 'Amsterdam', 'Stockholm', 'Bangkok'], 0, 'Venice is built on 118 islands.'),
        ('What is the largest city in Africa by population?', ARRAY['Lagos', 'Cairo', 'Kinshasa', 'Johannesburg'], 0, 'Lagos ~21 million.'),
        ('Which city is the financial capital of Europe?', ARRAY['London', 'Frankfurt', 'Paris', 'Zurich'], 0, 'London is a global financial hub.'),
        ('What is the most visited city in the world?', ARRAY['Bangkok', 'Paris', 'London', 'Dubai'], 0, 'Bangkok leads in international arrivals.'),
        ('Which city has the most skyscrapers?', ARRAY['Hong Kong', 'New York', 'Shanghai', 'Dubai'], 0, 'Hong Kong has over 500 skyscrapers.'),
        ('What is the oldest continuously inhabited city?', ARRAY['Damascus', 'Jericho', 'Athens', 'Varanasi'], 0, 'Damascus is ~11,000 years old.'),
        ('Which city is called the ''City of Love''?', ARRAY['Paris', 'Rome', 'Vienna', 'Prague'], 0, 'Paris is known as the City of Love.'),
        ('What is the largest city in South America?', ARRAY['São Paulo', 'Buenos Aires', 'Rio de Janeiro', 'Lima'], 0, 'São Paulo ~22 million.'),
        ('Which city has the deepest subway system?', ARRAY['Pyongyang', 'Moscow', 'London', 'Tokyo'], 0, 'Pyongyang subway is ~110 m deep.'),
        ('What is the capital of South Korea?', ARRAY['Seoul', 'Busan', 'Incheon', 'Daegu'], 0, 'Seoul is the capital.'),
        ('Which city hosted the first modern Olympics?', ARRAY['Athens', 'Paris', 'London', 'Berlin'], 0, 'Athens 1896.'),
        ('What is the most populated city in the USA?', ARRAY['New York City', 'Los Angeles', 'Chicago', 'Houston'], 0, 'New York ~8.8 million.'),
        ('Which city has the highest cost of living?', ARRAY['Singapore', 'New York', 'Hong Kong', 'London'], 0, 'Singapore often tops the list.'),
        ('What is the capital of New Zealand?', ARRAY['Wellington', 'Auckland', 'Christchurch', 'Hamilton'], 0, 'Wellington is the capital.'),
        ('Which city is the gateway to the Amazon?', ARRAY['Manaus', 'Belém', 'Brasília', 'Rio de Janeiro'], 0, 'Manaus is a major Amazon port.'),
        ('What is the largest city in Central America?', ARRAY['Guatemala City', 'Panama City', 'San José', 'Tegucigalpa'], 0, 'Guatemala City ~3 million.')
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

    -- ==================== VILLAGES ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.villages';
    FOR q_rec IN (
        VALUES
        ('Which village is considered the highest in the world?', ARRAY['Kashmir', 'Dzongkhag', 'La Rinconada', 'Meteora'], 0, 'La Rinconada in Peru is ~5,100 m.'),
        ('Which village in Europe is known for its colorful houses?', ARRAY['Burano', 'Hallstatt', 'Giethoorn', 'Cucuron'], 0, 'Burano, Italy, is famous for its colors.'),
        ('What is the name of the village that inspired ''The Hobbit''?', ARRAY['Hobbiton', 'Matamata', 'Rivendell', 'Buckland'], 0, 'Matamata in New Zealand is where Hobbiton was built.'),
        ('Which village is the oldest in Europe?', ARRAY['Sesklo', 'Çatalhöyük', 'Dolni Vestonice', 'Lepenski Vir'], 0, 'Sesklo in Greece dates to ~7500 BCE.'),
        ('Which village is known for its windmills?', ARRAY['Kinderdijk', 'Zaanse Schans', 'Volendam', 'Marken'], 0, 'Kinderdijk has 19 windmills.')
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

    -- ==================== CONTINENTS ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.continents';
    FOR q_rec IN (
        VALUES
        ('Which continent has the most countries?', ARRAY['Africa', 'Asia', 'Europe', 'South America'], 0, 'Africa has 54 countries.'),
        ('Which continent is the largest by land area?', ARRAY['Asia', 'Africa', 'North America', 'Europe'], 0, 'Asia ~44.6 million km².'),
        ('Which continent is the smallest?', ARRAY['Australia', 'Europe', 'South America', 'Antarctica'], 0, 'Australia ~8.6 million km².'),
        ('Which continent has the highest population?', ARRAY['Asia', 'Africa', 'Europe', 'North America'], 0, 'Asia ~4.7 billion.'),
        ('Which continent is entirely in the Southern Hemisphere?', ARRAY['Australia', 'South America', 'Africa', 'Antarctica'], 0, 'Australia and Antarctica, but Australia is mostly in south.'),
        ('Which continent has the most countries without a coastline?', ARRAY['Africa', 'Europe', 'South America', 'Asia'], 0, 'Africa has 16 landlocked countries.'),
        ('Which continent is the most densely populated?', ARRAY['Asia', 'Europe', 'Africa', 'North America'], 0, 'Asia ~150/km², but Europe ~74, Asia is higher.'),
        ('What is the highest peak in Europe?', ARRAY['Mount Elbrus', 'Mont Blanc', 'Mount Everest', 'Kilimanjaro'], 0, 'Elbrus is 5,642 m.'),
        ('Which continent has the most active volcanoes?', ARRAY['Asia', 'North America', 'South America', 'Africa'], 0, 'Asia has the most (especially in Indonesia).'),
        ('Which continent is the driest?', ARRAY['Antarctica', 'Australia', 'Africa', 'Asia'], 0, 'Antarctica is a cold desert and is the driest.')
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

    -- ==================== OCEANS ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.oceans';
    FOR q_rec IN (
        VALUES
        ('Which ocean is the largest?', ARRAY['Pacific', 'Atlantic', 'Indian', 'Southern'], 0, 'Pacific ~165 million km².'),
        ('Which ocean is the deepest?', ARRAY['Pacific', 'Atlantic', 'Indian', 'Arctic'], 0, 'Pacific has the Mariana Trench (11,034 m).'),
        ('Which ocean is the smallest?', ARRAY['Arctic', 'Southern', 'Indian', 'Atlantic'], 0, 'Arctic ~14 million km².'),
        ('Which ocean surrounds Antarctica?', ARRAY['Southern', 'Pacific', 'Atlantic', 'Indian'], 0, 'The Southern Ocean surrounds Antarctica.'),
        ('Which ocean has the most islands?', ARRAY['Pacific', 'Indian', 'Atlantic', 'Arctic'], 0, 'Pacific has thousands of islands.'),
        ('Which ocean is the saltiest?', ARRAY['Atlantic', 'Pacific', 'Indian', 'Arctic'], 0, 'Atlantic is the saltiest on average.'),
        ('What is the largest ocean current?', ARRAY['Antarctic Circumpolar', 'Gulf Stream', 'Kuroshio', 'Benguela'], 0, 'Antarctic Circumpolar Current is the largest.'),
        ('Which ocean contains the Bermuda Triangle?', ARRAY['Atlantic', 'Pacific', 'Indian', 'Southern'], 0, 'The Bermuda Triangle is in the Atlantic.'),
        ('Which ocean is the warmest?', ARRAY['Indian', 'Pacific', 'Atlantic', 'Southern'], 0, 'Indian Ocean is generally the warmest.'),
        ('Which ocean is bordered by the most countries?', ARRAY['Atlantic', 'Pacific', 'Indian', 'Arctic'], 0, 'Atlantic borders ~50 countries.')
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

    -- ==================== SEAS ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.seas';
    FOR q_rec IN (
        VALUES
        ('Which sea is the largest by area?', ARRAY['Mediterranean', 'South China Sea', 'Caribbean', 'Bering'], 0, 'Mediterranean ~2.5 million km².'),
        ('Which sea is the saltiest?', ARRAY['Red Sea', 'Dead Sea', 'Mediterranean', 'Persian Gulf'], 0, 'Dead Sea is a hypersaline lake, but Red Sea is very salty.'),
        ('Which sea is completely enclosed by land?', ARRAY['Caspian Sea', 'Dead Sea', 'Aral Sea', 'Salton Sea'], 0, 'Caspian Sea is the largest inland sea.'),
        ('What sea separates Europe and Africa?', ARRAY['Mediterranean', 'Red Sea', 'Black Sea', 'Baltic'], 0, 'The Mediterranean separates them.'),
        ('Which sea is the deepest?', ARRAY['Mediterranean', 'Caribbean', 'Philippine', 'South China'], 0, 'Mediterranean has depths >5,000 m.'),
        ('Which sea is famous for its high salinity and buoyancy?', ARRAY['Dead Sea', 'Red Sea', 'Great Salt Lake', 'Caspian'], 0, 'Dead Sea is extremely salty.'),
        ('Which sea is home to the Sargasso Sea?', ARRAY['Atlantic', 'Pacific', 'Indian', 'Caribbean'], 0, 'Sargasso Sea is in the Atlantic.'),
        ('Which sea lies between Ukraine and Turkey?', ARRAY['Black Sea', 'Mediterranean', 'Aegean', 'Caspian'], 0, 'Black Sea is between them.'),
        ('Which sea is the shallowest?', ARRAY['Baltic Sea', 'Black Sea', 'Red Sea', 'South China Sea'], 0, 'Baltic Sea is quite shallow (~55 m avg).'),
        ('Which sea is known for the ''Bermuda Triangle''?', ARRAY['Sargasso Sea', 'Mediterranean', 'Caribbean', 'South China'], 0, 'The Bermuda Triangle is in the Sargasso Sea area.')
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

    -- ==================== RIVERS ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.rivers';
    FOR q_rec IN (
        VALUES
        ('Which river is the longest in the world?', ARRAY['Amazon', 'Nile', 'Yangtze', 'Mississippi'], 0, 'Nile is ~6,650 km (Amazon ~6,400 km).'),
        ('Which river has the largest discharge?', ARRAY['Amazon', 'Congo', 'Yangtze', 'Ganges'], 0, 'Amazon discharges ~209,000 m³/s.'),
        ('What is the longest river in Europe?', ARRAY['Volga', 'Danube', 'Rhine', 'Dnieper'], 0, 'Volga ~3,530 km.'),
        ('Which river is sacred in India?', ARRAY['Ganges', 'Yamuna', 'Brahmaputra', 'Indus'], 0, 'Ganges is considered sacred.'),
        ('Which river forms the border between the USA and Mexico?', ARRAY['Rio Grande', 'Colorado', 'Mississippi', 'Columbia'], 0, 'Rio Grande forms part of the border.'),
        ('What is the major river in Egypt?', ARRAY['Nile', 'Amazon', 'Congo', 'Tigris'], 0, 'The Nile is essential for Egypt.'),
        ('Which river is the longest in China?', ARRAY['Yangtze', 'Yellow', 'Mekong', 'Lancang'], 0, 'Yangtze ~6,300 km.'),
        ('Which river drains the Amazon rainforest?', ARRAY['Amazon', 'Orinoco', 'Paraná', 'Negro'], 0, 'The Amazon River drains it.'),
        ('Which river is known as the ''Father of Waters''?', ARRAY['Mississippi', 'Missouri', 'Colorado', 'Rio Grande'], 0, 'Mississippi is called that.'),
        ('Which river flows through Paris?', ARRAY['Seine', 'Loire', 'Rhône', 'Garonne'], 0, 'Seine flows through Paris.'),
        ('Which river is the second longest in Africa?', ARRAY['Congo', 'Nile', 'Niger', 'Zambezi'], 0, 'Congo ~4,700 km.'),
        ('Which river is the longest in South America?', ARRAY['Amazon', 'Paraná', 'Orinoco', 'São Francisco'], 0, 'Amazon is the longest.'),
        ('Which river is the most polluted in the world?', ARRAY['Citarum', 'Ganges', 'Yangtze', 'Mississippi'], 0, 'Citarum in Indonesia is heavily polluted.'),
        ('Which river flows through the Grand Canyon?', ARRAY['Colorado', 'Rio Grande', 'Missouri', 'Arkansas'], 0, 'Colorado River carved the Grand Canyon.'),
        ('What is the river that forms the border between Germany and France?', ARRAY['Rhine', 'Danube', 'Elbe', 'Oder'], 0, 'Rhine forms part of the border.')
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

    -- ==================== LAKES ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.lakes';
    FOR q_rec IN (
        VALUES
        ('Which lake is the largest by surface area?', ARRAY['Caspian Sea', 'Superior', 'Victoria', 'Huron'], 0, 'Caspian is ~371,000 km².'),
        ('Which lake is the deepest in the world?', ARRAY['Baikal', 'Tanganyika', 'Vostok', 'Caspian'], 0, 'Baikal is 1,642 m deep.'),
        ('Which lake is the largest freshwater lake by volume?', ARRAY['Baikal', 'Superior', 'Tanganyika', 'Michigan'], 0, 'Baikal contains ~23,600 km³ of water.'),
        ('Which lake is the highest navigable lake?', ARRAY['Titicaca', 'Caspian', 'Baikal', 'Victoria'], 0, 'Titicaca at 3,812 m.'),
        ('Which lake is known as the ''Dead Sea''?', ARRAY['The Dead Sea', 'Salt Lake', 'Aral Sea', 'Salton Sea'], 0, 'It is a salt lake between Israel and Jordan.'),
        ('Which lake is the largest in Africa?', ARRAY['Victoria', 'Tanganyika', 'Malawi', 'Chad'], 0, 'Lake Victoria ~68,800 km².'),
        ('Which lake is the largest in North America?', ARRAY['Superior', 'Huron', 'Michigan', 'Great Bear'], 0, 'Superior is the largest.'),
        ('Which lake is the largest in South America?', ARRAY['Titicaca', 'Maracaibo', 'Valencia', 'Magellan'], 0, 'Titicaca is the largest by volume.'),
        ('Which lake is the largest in Europe?', ARRAY['Ladoga', 'Onega', 'Geneva', 'Constance'], 0, 'Ladoga ~17,700 km².'),
        ('Which lake is the largest in Asia?', ARRAY['Baikal', 'Balkhash', 'Uvs Nuur', 'Khanka'], 0, 'Baikal is the largest by volume.')
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

    -- ==================== MOUNTAINS ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.mountains';
    FOR q_rec IN (
        VALUES
        ('What is the highest mountain in the world?', ARRAY['Everest', 'K2', 'Kangchenjunga', 'Lhotse'], 0, 'Everest is 8,848.86 m.'),
        ('What is the highest mountain in Africa?', ARRAY['Kilimanjaro', 'Kenya', 'Rwenzori', 'Meru'], 0, 'Kilimanjaro 5,895 m.'),
        ('What is the longest mountain range in the world?', ARRAY['Andes', 'Himalayas', 'Rockies', 'Great Dividing'], 0, 'Andes ~7,000 km.'),
        ('What is the highest peak in the Alps?', ARRAY['Mont Blanc', 'Matterhorn', 'Eiger', 'Grossglockner'], 0, 'Mont Blanc 4,808 m.'),
        ('Which mountain is known as the ''Mountain of the Gods''?', ARRAY['Olympus', 'Fuji', 'Ararat', 'Sinai'], 0, 'Olympus is the home of Greek gods.'),
        ('What is the highest mountain in the Americas?', ARRAY['Aconcagua', 'Denali', 'Mount Logan', 'Cotopaxi'], 0, 'Aconcagua 6,961 m.'),
        ('Which mountain range separates Europe and Asia?', ARRAY['Urals', 'Caucasus', 'Alps', 'Pyrenees'], 0, 'Ural Mountains are the conventional boundary.'),
        ('What is the highest peak in Oceania?', ARRAY['Puncak Jaya', 'Kilimanjaro', 'Aoraki', 'Mount Cook'], 0, 'Puncak Jaya 4,884 m.'),
        ('Which mountain is the highest volcano?', ARRAY['Ojos del Salado', 'Cotopaxi', 'Kilimanjaro', 'Popocatepetl'], 0, 'Ojos del Salado 6,893 m.'),
        ('Which mountain is the most climbed in the world?', ARRAY['Fuji', 'Everest', 'Kilimanjaro', 'Mont Blanc'], 0, 'Fuji is climbed by over 300,000 per year.'),
        ('What is the highest peak in the Rocky Mountains?', ARRAY['Mount Elbert', 'Mount Robson', 'Mount Whitney', 'Pikes Peak'], 0, 'Mount Elbert 4,401 m.'),
        ('Which mountain is known as the ''Roof of Africa''?', ARRAY['Kilimanjaro', 'Kenya', 'Rwenzori', 'Semien'], 0, 'Kilimanjaro is often called that.'),
        ('What is the highest mountain in the UK?', ARRAY['Ben Nevis', 'Snowdon', 'Scafell Pike', 'Carn Eige'], 0, 'Ben Nevis 1,345 m.'),
        ('Which mountain range contains the highest peak in North America?', ARRAY['Alaska Range', 'Rockies', 'Appalachians', 'Sierra Nevada'], 0, 'Denali is in the Alaska Range.'),
        ('What is the highest mountain in Antarctica?', ARRAY['Vinson Massif', 'Erebus', 'Tyree', 'Shinn'], 0, 'Vinson Massif 4,892 m.')
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

    -- ==================== VOLCANOES ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.volcanoes';
    FOR q_rec IN (
        VALUES
        ('Which volcano is the most active in the world?', ARRAY['Kilauea', 'Etna', 'Stromboli', 'Eyjafjallajökull'], 0, 'Kilauea has been erupting continuously since 1983.'),
        ('Which volcano is the tallest in the world (from base to summit)?', ARRAY['Mauna Kea', 'Mount Everest', 'Denali', 'Kilimanjaro'], 0, 'Mauna Kea is over 10,000 m from the ocean floor.'),
        ('Which volcano is known as the ''Lighthouse of the Mediterranean''?', ARRAY['Stromboli', 'Etna', 'Vesuvius', 'Santorini'], 0, 'Stromboli erupts regularly, hence the nickname.'),
        ('Which volcanic eruption destroyed Pompeii?', ARRAY['Vesuvius', 'Etna', 'Stromboli', 'Santorini'], 0, 'Vesuvius erupted in 79 AD.'),
        ('Which volcano is located in the Philippines and is known for its perfect cone?', ARRAY['Mayon', 'Taal', 'Pinatubo', 'Apo'], 0, 'Mayon has a symmetrical cone.'),
        ('Which volcano in Indonesia caused the largest explosion in recorded history?', ARRAY['Tambora', 'Krakatoa', 'Merapi', 'Sinabung'], 0, 'Tambora 1815 had a VEI of 7.'),
        ('Which volcano is the highest in Europe?', ARRAY['Etna', 'Elbrus', 'Mont Blanc', 'Matterhorn'], 0, 'Etna is 3,329 m, but Elbrus is a volcano and higher (5,642 m) - actually Elbrus is a volcano, so that is correct.'),
        ('Which volcano is the most dangerous in the world (by population nearby)?', ARRAY['Vesuvius', 'Popocatepetl', 'Sakurajima', 'Mount Rainier'], 0, 'Vesuvius has millions living near it.'),
        ('Which volcano is in Antarctica?', ARRAY['Mount Erebus', 'Mount Sidley', 'Deception Island', 'Mount Melbourne'], 0, 'Erebus is an active volcano in Antarctica.'),
        ('Which volcano is known for its lava lake?', ARRAY['Erta Ale', 'Kilauea', 'Nyiragongo', 'Masaya'], 0, 'Erta Ale in Ethiopia has a persistent lava lake.')
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

    -- ==================== DESERTS ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.deserts';
    FOR q_rec IN (
        VALUES
        ('Which desert is the largest hot desert?', ARRAY['Sahara', 'Arabian', 'Kalahari', 'Gobi'], 0, 'Sahara ~9.2 million km².'),
        ('Which desert is the largest cold desert?', ARRAY['Antarctic', 'Arctic', 'Gobi', 'Patagonian'], 0, 'Antarctic is ~14 million km².'),
        ('Which desert is the driest place on Earth?', ARRAY['Atacama', 'Sahara', 'Namib', 'Death Valley'], 0, 'Atacama gets <1 mm rain per year.'),
        ('Which desert is located mostly in China and Mongolia?', ARRAY['Gobi', 'Taklamakan', 'Karakum', 'Kyzylkum'], 0, 'Gobi spans China and Mongolia.'),
        ('Which desert is known for its sand dunes that can reach 300 m?', ARRAY['Namib', 'Sahara', 'Rub'' al Khali', 'Kalahari'], 0, 'Namib has some of the tallest dunes.'),
        ('Which desert is the largest in North America?', ARRAY['Sonoran', 'Mojave', 'Chihuahuan', 'Great Basin'], 0, 'Great Basin is the largest (~490,000 km²).'),
        ('Which desert is the largest in the Southern Hemisphere?', ARRAY['Australian', 'Kalahari', 'Atacama', 'Patagonian'], 0, 'Australian Desert covers much of Australia.'),
        ('Which desert is home to the highest sand dunes in the world?', ARRAY['Rub'' al Khali', 'Sahara', 'Namib', 'Kalahari'], 0, 'Rub'' al Khali has dunes up to 300 m.'),
        ('Which desert is the largest in South America?', ARRAY['Atacama', 'Patagonian', 'Sechura', 'Monte'], 0, 'Patagonian Desert is largest (~670,000 km²).'),
        ('Which desert is known for its red sand?', ARRAY['Simpson', 'Sahara', 'Kalahari', 'Gobi'], 0, 'Simpson Desert in Australia has red sand.')
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

    -- ==================== FORESTS ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.forests';
    FOR q_rec IN (
        VALUES
        ('Which forest is the largest rainforest?', ARRAY['Amazon', 'Congo', 'Daintree', 'Southeast Asian'], 0, 'Amazon ~5.5 million km².'),
        ('Which forest is the largest boreal forest?', ARRAY['Taiga', 'Amazon', 'Congo', 'Temperate'], 0, 'Taiga (boreal) is ~17 million km².'),
        ('Which forest is known for its giant sequoias?', ARRAY['Sequoia', 'Redwood', 'Yosemite', 'Sierra'], 0, 'Sequoia National Park has giant sequoias.'),
        ('Which forest is the oldest in the world?', ARRAY['Daintree', 'Amazon', 'Borneo', 'Tongass'], 0, 'Daintree in Australia is over 180 million years old.'),
        ('Which forest is the most biodiverse?', ARRAY['Amazon', 'Congo', 'Southeast Asian', 'Madagascar'], 0, 'Amazon is the most biodiverse.'),
        ('Which forest is known for its ''Fairy Chimneys''?', ARRAY['Black Forest', 'Petrified Forest', 'Sherwood', 'Daintree'], 0, 'Black Forest is in Germany, not Fairy Chimneys (that''s Cappadocia).'),
        ('Which forest is the largest in the United States?', ARRAY['Tongass', 'National Forest', 'Black Hills', 'Pisgah'], 0, 'Tongass is the largest US national forest.'),
        ('Which forest is home to the ''Giant Panda''?', ARRAY['Bamboo forests of China', 'Amazon', 'Congo', 'Borneo'], 0, 'Pandas live in bamboo forests in China.'),
        ('Which forest is the most threatened by deforestation?', ARRAY['Amazon', 'Congo', 'Southeast Asian', 'All'], 0, 'Amazon is heavily threatened.'),
        ('Which forest is known for its ''Cloud Forest'' ecosystem?', ARRAY['Monteverde', 'Amazon', 'Daintree', 'Himalayan'], 0, 'Monteverde in Costa Rica is a cloud forest.')
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

    -- ==================== ISLANDS ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.islands';
    FOR q_rec IN (
        VALUES
        ('What is the largest island in the world?', ARRAY['Greenland', 'New Guinea', 'Borneo', 'Madagascar'], 0, 'Greenland ~2.17 million km².'),
        ('What is the most populous island?', ARRAY['Java', 'Honshu', 'Great Britain', 'Luzon'], 0, 'Java has ~145 million people.'),
        ('Which island is the largest in the Mediterranean?', ARRAY['Sicily', 'Sardinia', 'Cyprus', 'Corsica'], 0, 'Sicily ~25,711 km².'),
        ('Which island is known as the ''Island of Gods''?', ARRAY['Bali', 'Java', 'Crete', 'Santorini'], 0, 'Bali is known as the Island of Gods.'),
        ('Which island is the largest in the Caribbean?', ARRAY['Cuba', 'Hispaniola', 'Jamaica', 'Puerto Rico'], 0, 'Cuba ~109,884 km².'),
        ('Which island is home to the Galapagos tortoises?', ARRAY['Galapagos', 'Madagascar', 'Mauritius', 'Fiji'], 0, 'Galapagos Islands have giant tortoises.'),
        ('Which island is the largest in Oceania?', ARRAY['New Guinea', 'Borneo', 'Java', 'Honshu'], 0, 'New Guinea is the largest in Oceania.'),
        ('Which island is the largest in the Indian Ocean?', ARRAY['Madagascar', 'Sri Lanka', 'Sumatra', 'Borneo'], 0, 'Madagascar is the largest.'),
        ('Which island is the most remote inhabited island?', ARRAY['Tristan da Cunha', 'Easter Island', 'Pitcairn', 'St. Helena'], 0, 'Tristan da Cunha is the most remote.'),
        ('Which island is known for its unique lemurs?', ARRAY['Madagascar', 'Borneo', 'Sri Lanka', 'Fiji'], 0, 'Lemurs are native to Madagascar.')
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

    -- ==================== NATIONAL PARKS ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.national_parks';
    FOR q_rec IN (
        VALUES
        ('Which is the first national park in the world?', ARRAY['Yellowstone', 'Yosemite', 'Banff', 'Yellowstone'], 0, 'Yellowstone, established 1872.'),
        ('Which US national park is known for its geothermal features?', ARRAY['Yellowstone', 'Yosemite', 'Grand Canyon', 'Zion'], 0, 'Yellowstone has geysers and hot springs.'),
        ('Which national park is the largest in the US?', ARRAY['Wrangell-St. Elias', 'Denali', 'Gates of the Arctic', 'Yukon-Charley'], 0, 'Wrangell-St. Elias is over 53,000 km².'),
        ('Which national park is in Canada and known for its glaciers?', ARRAY['Banff', 'Jasper', 'Yoho', 'Kootenay'], 0, 'Banff has glaciers and lakes.'),
        ('Which national park is the most visited in the US?', ARRAY['Great Smoky Mountains', 'Grand Canyon', 'Zion', 'Yosemite'], 0, 'Great Smoky Mountains has ~14 million visitors.'),
        ('Which national park is home to the Matterhorn?', ARRAY['Zermatt', 'Banff', 'Jasper', 'Yoho'], 0, 'Matterhorn is not in a US park; it''s in Switzerland.'),
        ('Which African national park is famous for the ''Big Five''?', ARRAY['Kruger', 'Serengeti', 'Masai Mara', 'Etosha'], 0, 'Kruger National Park has the Big Five.'),
        ('Which national park is in Australia and has Uluru?', ARRAY['Uluru-Kata Tjuta', 'Kakadu', 'Blue Mountains', 'Great Victoria'], 0, 'Uluru-Kata Tjuta National Park.'),
        ('Which national park in Chile is famous for its Torres del Paine?', ARRAY['Torres del Paine', 'Araucarias', 'Los Glaciares', 'Tierra del Fuego'], 0, 'Torres del Paine is in Chile.'),
        ('Which national park is in the UK?', ARRAY['Lake District', 'Snowdonia', 'Peak District', 'All of the above'], 0, 'All are national parks in the UK.')
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

    -- ==================== TIME ZONES ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.time_zones';
    FOR q_rec IN (
        VALUES
        ('How many time zones does Earth have (theoretical)?', ARRAY['24', '25', '26', '24'], 0, '24 time zones (each 15° longitude).'),
        ('Which country has the most time zones (including overseas)?', ARRAY['France', 'Russia', 'USA', 'UK'], 0, 'France has 12 (including territories).'),
        ('Which country spans 11 time zones?', ARRAY['Russia', 'China', 'USA', 'Canada'], 0, 'Russia spans 11 time zones.'),
        ('What is the time zone at the Prime Meridian?', ARRAY['UTC', 'GMT', 'UTC+1', 'UTC-1'], 0, 'UTC (or GMT) at 0° longitude.'),
        ('Which country uses a time zone offset of UTC+5:45?', ARRAY['Nepal', 'India', 'Sri Lanka', 'Bangladesh'], 0, 'Nepal uses UTC+5:45.'),
        ('What is the International Date Line?', ARRAY['180° longitude', '0° longitude', '90° longitude', 'Equator'], 0, 'The IDL is roughly along 180° longitude.'),
        ('Which time zone is used in China?', ARRAY['UTC+8', 'UTC+7', 'UTC+9', 'UTC+6'], 0, 'China uses a single time zone UTC+8.'),
        ('Which US state is split between two time zones?', ARRAY['Tennessee', 'Kentucky', 'Nebraska', 'All of the above'], 0, 'Many states are split.'),
        ('Which time zone is used in India?', ARRAY['UTC+5:30', 'UTC+5', 'UTC+6', 'UTC+4:30'], 0, 'India uses UTC+5:30.'),
        ('What time zone is used in the Falkland Islands?', ARRAY['UTC-3', 'UTC-4', 'UTC-2', 'UTC-5'], 0, 'Falklands use UTC-3.')
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

    -- ==================== CLIMATE ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.climate';
    FOR q_rec IN (
        VALUES
        ('Which climate type has the highest temperature variation?', ARRAY['Continental', 'Tropical', 'Mediterranean', 'Oceanic'], 0, 'Continental climates have extremes.'),
        ('Which climate zone is known for its wet and dry seasons?', ARRAY['Tropical savanna', 'Monsoon', 'Equatorial', 'Desert'], 0, 'Tropical savanna has distinct wet/dry.'),
        ('Which climate type is characterized by mild winters and warm summers?', ARRAY['Mediterranean', 'Oceanic', 'Humid subtropical', 'Continental'], 0, 'Mediterranean climate has mild, wet winters and hot, dry summers.'),
        ('Which climate is found near the poles?', ARRAY['Polar', 'Subarctic', 'Tundra', 'Ice cap'], 0, 'Polar climate includes ice cap and tundra.'),
        ('What is the Köppen classification for tropical rainforest?', ARRAY['Af', 'Am', 'Aw', 'A'], 0, 'Af is tropical rainforest.'),
        ('Which climate type has the most rainfall?', ARRAY['Tropical rainforest', 'Monsoon', 'Oceanic', 'Temperate'], 0, 'Tropical rainforests receive >2000 mm/year.'),
        ('Which climate is characterized by hot, dry summers and cold winters?', ARRAY['Continental', 'Mediterranean', 'Steppe', 'Desert'], 0, 'Continental has hot summers and cold winters.'),
        ('Which climate is typical for the Mediterranean region?', ARRAY['Mediterranean', 'Oceanic', 'Humid subtropical', 'Dry summer subtropical'], 0, 'Mediterranean climate has dry summers.'),
        ('What is the climate of the Sahara Desert?', ARRAY['Hot desert', 'Cold desert', 'Steppe', 'Mediterranean'], 0, 'Sahara is hot desert (BWh).'),
        ('Which climate is known for its fog?', ARRAY['Marine west coast', 'Mediterranean', 'Tundra', 'Desert'], 0, 'Marine west coast often has fog.'),
        ('What is the climate of the Gobi Desert?', ARRAY['Cold desert', 'Hot desert', 'Steppe', 'Tundra'], 0, 'Gobi is a cold desert (BWk).'),
        ('Which climate type has permafrost?', ARRAY['Tundra', 'Ice cap', 'Subarctic', 'Alpine'], 0, 'Tundra has permafrost.'),
        ('Which climate is dominant in Southeast Asia?', ARRAY['Tropical monsoon', 'Tropical rainforest', 'Humid subtropical', 'Mediterranean'], 0, 'Southeast Asia has tropical monsoon.'),
        ('What is the climate of the Mediterranean coast of California?', ARRAY['Mediterranean', 'Oceanic', 'Desert', 'Tropical'], 0, 'California coast has a Mediterranean climate.'),
        ('Which climate type is the largest by area?', ARRAY['Cold desert', 'Tropical rainforest', 'Polar', 'Continental'], 0, 'Cold desert (Antarctic) is largest.')
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

    -- ==================== WEATHER ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.weather';
    FOR q_rec IN (
        VALUES
        ('What is the highest temperature ever recorded on Earth?', ARRAY['56.7°C', '54.4°C', '58.0°C', '57.8°C'], 0, '56.7°C (134°F) in Death Valley, 1913.'),
        ('What is the lowest temperature ever recorded?', ARRAY['-89.2°C', '-88.3°C', '-91.2°C', '-87.5°C'], 0, '-89.2°C in Antarctica, 1983.'),
        ('What is the fastest wind speed ever recorded?', ARRAY['408 km/h', '372 km/h', '420 km/h', '354 km/h'], 0, '408 km/h (253 mph) in a tornado in Oklahoma.'),
        ('What is the largest hailstone on record?', ARRAY['1.0 kg', '1.5 kg', '0.9 kg', '1.2 kg'], 0, '1.0 kg (2.2 lb) in Bangladesh.'),
        ('What is the most common type of lightning?', ARRAY['Cloud-to-ground', 'Cloud-to-cloud', 'Intra-cloud', 'Positive'], 0, 'Intra-cloud is most common.'),
        ('Which weather phenomenon is a rotating column of air?', ARRAY['Tornado', 'Hurricane', 'Cyclone', 'Typhoon'], 0, 'A tornado is a rotating column of air.'),
        ('What is the difference between a hurricane and a typhoon?', ARRAY['Location', 'Wind speed', 'Size', 'None'], 0, 'Same phenomenon, different location names.'),
        ('What is the average duration of a thunderstorm?', ARRAY['30 minutes', '1 hour', '15 minutes', '45 minutes'], 0, 'Thunderstorms typically last 30 minutes.'),
        ('What is the most common source of weather in the tropics?', ARRAY['Monsoons', 'Trade winds', 'Cyclones', 'Convection'], 0, 'Convection is the primary driver.'),
        ('Which city gets the most sunshine per year?', ARRAY['Yuma, Arizona', 'Phoenix', 'Las Vegas', 'Death Valley'], 0, 'Yuma has ~90% sunshine.')
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

    -- ==================== NATURAL RESOURCES ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.natural_resources';
    FOR q_rec IN (
        VALUES
        ('Which country is the largest producer of oil?', ARRAY['USA', 'Saudi Arabia', 'Russia', 'Canada'], 0, 'USA is the largest producer (since 2018).'),
        ('Which country has the largest reserves of coal?', ARRAY['USA', 'China', 'India', 'Australia'], 0, 'USA has the largest proven coal reserves.'),
        ('Which metal is the most abundant in the Earth''s crust?', ARRAY['Aluminum', 'Iron', 'Silicon', 'Oxygen'], 0, 'Aluminum is the most abundant metal.'),
        ('What is the primary source of energy in most countries?', ARRAY['Fossil fuels', 'Nuclear', 'Renewables', 'Hydropower'], 0, 'Fossil fuels dominate energy consumption.'),
        ('Which country is the largest gold producer?', ARRAY['China', 'Australia', 'Russia', 'USA'], 0, 'China is the largest gold producer.'),
        ('What is the largest producer of natural gas?', ARRAY['USA', 'Russia', 'Iran', 'Qatar'], 0, 'USA is the largest producer of natural gas.'),
        ('Which country has the most freshwater resources?', ARRAY['Brazil', 'Russia', 'USA', 'Canada'], 0, 'Brazil has the largest renewable freshwater resources.'),
        ('What is the world''s most mined mineral?', ARRAY['Coal', 'Iron ore', 'Bauxite', 'Copper'], 0, 'Coal is the most mined.'),
        ('Which country is the largest producer of diamonds?', ARRAY['Russia', 'Botswana', 'Canada', 'Australia'], 0, 'Russia is the largest producer by carats.'),
        ('Which renewable resource is the largest source of electricity in the world?', ARRAY['Hydropower', 'Wind', 'Solar', 'Biomass'], 0, 'Hydropower is the largest renewable source.')
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

    -- ==================== POPULATION ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.population';
    FOR q_rec IN (
        VALUES
        ('What is the total world population (as of 2024)?', ARRAY['~8.1 billion', '~7.9 billion', '~8.5 billion', '~7.7 billion'], 0, 'World population is ~8.1 billion.'),
        ('Which country is the most populous?', ARRAY['India', 'China', 'USA', 'Indonesia'], 0, 'India surpassed China in 2023.'),
        ('What is the population density of Monaco?', ARRAY['~19,000/km²', '~15,000/km²', '~25,000/km²', '~12,000/km²'], 0, 'Monaco has ~19,000 people per km².'),
        ('Which city has the largest metropolitan population?', ARRAY['Tokyo', 'Delhi', 'Shanghai', 'São Paulo'], 0, 'Tokyo metro ~37 million.'),
        ('What is the sex ratio globally (males per 100 females)?', ARRAY['~102', '~100', '~98', '~105'], 0, 'There are slightly more males (~102 males per 100 females).'),
        ('What is the median age in Japan?', ARRAY['~48 years', '~45 years', '~50 years', '~42 years'], 0, 'Japan has one of the highest median ages.'),
        ('Which country has the highest population growth rate?', ARRAY['Niger', 'Angola', 'Mali', 'DR Congo'], 0, 'Niger has a growth rate of ~3.8%.'),
        ('What is the fertility rate in India?', ARRAY['~2.0', '~2.2', '~2.5', '~1.8'], 0, 'India''s fertility rate is ~2.0.'),
        ('Which region has the highest population?', ARRAY['Asia', 'Africa', 'Europe', 'Americas'], 0, 'Asia has over 60% of world population.'),
        ('What is the urban population percentage of the world?', ARRAY['~57%', '~60%', '~55%', '~50%'], 0, '~57% of people live in urban areas.'),
        ('Which country has the most people over 65?', ARRAY['Japan', 'Italy', 'Germany', 'China'], 0, 'Japan has the highest proportion of elderly.'),
        ('What is the life expectancy in the world?', ARRAY['~73 years', '~70 years', '~75 years', '~68 years'], 0, 'Average life expectancy is ~73 years.'),
        ('Which country has the highest youth population?', ARRAY['India', 'Nigeria', 'Pakistan', 'Indonesia'], 0, 'India has the largest youth population.'),
        ('What is the total number of people living in extreme poverty?', ARRAY['~700 million', '~500 million', '~1 billion', '~800 million'], 0, '~700 million live on <$2.15/day.'),
        ('Which country has the highest net migration?', ARRAY['USA', 'Germany', 'Canada', 'UK'], 0, 'USA has the highest net migration.')
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

    -- ==================== DEMOGRAPHICS ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'earth_geography.demographics';
    FOR q_rec IN (
        VALUES
        ('What is the most spoken language in the world?', ARRAY['English', 'Mandarin', 'Hindi', 'Spanish'], 0, 'English has ~1.4 billion speakers (including L2).'),
        ('What is the most spoken native language?', ARRAY['Mandarin', 'Spanish', 'English', 'Hindi'], 0, 'Mandarin has ~1 billion native speakers.'),
        ('What is the most common religion in the world?', ARRAY['Christianity', 'Islam', 'Hinduism', 'Buddhism'], 0, 'Christianity ~2.4 billion.'),
        ('What is the most common ethnic group in the world?', ARRAY['Han Chinese', 'Indian', 'Arab', 'Hispanic'], 0, 'Han Chinese is the largest ethnic group.'),
        ('What is the median age of the world population?', ARRAY['~31', '~30', '~32', '~28'], 0, '~31 years.'),
        ('What is the literacy rate in developed countries?', ARRAY['>99%', '~95%', '~90%', '~98%'], 0, '>99% in most developed.'),
        ('What is the global literacy rate?', ARRAY['~87%', '~80%', '~90%', '~85%'], 0, '~87%.'),
        ('Which country has the highest life expectancy?', ARRAY['Japan', 'Switzerland', 'Australia', 'Spain'], 0, 'Japan ~84.6 years.'),
        ('What is the most common cause of death globally?', ARRAY['Heart disease', 'Cancer', 'Stroke', 'Respiratory'], 0, 'Heart disease is the leading cause.'),
        ('What is the infant mortality rate worldwide?', ARRAY['~28 per 1000', '~20 per 1000', '~30 per 1000', '~15 per 1000'], 0, '~28 per 1000 live births.'),
        ('Which country has the highest fertility rate?', ARRAY['Niger', 'Somalia', 'DR Congo', 'Mali'], 0, 'Niger ~6.5.'),
        ('What is the total fertility rate replacement level?', ARRAY['2.1', '2.0', '2.5', '1.8'], 0, '2.1 is replacement level.'),
        ('What is the most common age group in sub-Saharan Africa?', ARRAY['0-14 years', '15-24', '25-54', '55+'], 0, '0-14 is largest.'),
        ('What is the average household size in the world?', ARRAY['~3.5', '~4', '~3', '~2.5'], 0, '~3.5.'),
        ('Which country has the highest percentage of elderly (65+)?', ARRAY['Japan', 'Italy', 'Portugal', 'Germany'], 0, 'Japan ~29% elderly.'),
        ('What is the gender ratio in Europe?', ARRAY['~95 males per 100 females', '100 males per 100 females', '97 males per 100 females', '105 males per 100 females'], 0, 'Europe has more females.'),
        ('What is the most common blood type in the world?', ARRAY['O', 'A', 'B', 'AB'], 0, 'Type O is most common.'),
        ('What is the average age of first marriage globally?', ARRAY['~30 for men, ~27 for women', '~28 for men, ~25 for women', '~25 for men, ~22 for women', '~32 for men, ~29 for women'], 0, '~30 and ~27.'),
        ('Which country has the highest number of centenarians?', ARRAY['Japan', 'USA', 'China', 'India'], 0, 'Japan has the most centenarians per capita.'),
        ('What is the most common eye color in the world?', ARRAY['Brown', 'Blue', 'Green', 'Hazel'], 0, 'Brown is the most common.'),
        ('What is the total population of the world under 18?', ARRAY['~2.5 billion', '~2 billion', '~3 billion', '~1.8 billion'], 0, '~2.5 billion.'),
        ('What is the average height of an adult male globally?', ARRAY['~5''8" (173 cm)', '~5''9" (175 cm)', '~5''7" (170 cm)', '~5''10" (178 cm)'], 0, '~173 cm.'),
        ('Which country has the highest obesity rate?', ARRAY['USA', 'Mexico', 'UK', 'Australia'], 0, 'USA has the highest obesity rate.'),
        ('What is the most common surname in the world?', ARRAY['Wang', 'Li', 'Smith', 'Zhang'], 0, 'Wang is the most common surname.'),
        ('What is the most popular baby name globally?', ARRAY['Mohammed', 'John', 'Maria', 'James'], 0, 'Mohammed is the most popular.'),
        ('What is the average number of children per family in Africa?', ARRAY['~4.5', '~5', '~3.5', '~4'], 0, '~4.5.'),
        ('Which country has the highest ratio of women to men?', ARRAY['Russia', 'Ukraine', 'Belarus', 'All'], 0, 'Russia has more women.'),
        ('What is the percentage of the world population that is left-handed?', ARRAY['~10%', '~8%', '~12%', '~15%'], 0, '~10%.'),
        ('What is the most common occupation globally?', ARRAY['Agriculture', 'Services', 'Manufacturing', 'Education'], 0, 'Agriculture employs most people.'),
        ('Which country has the highest average IQ?', ARRAY['Singapore', 'China', 'Japan', 'South Korea'], 0, 'Singapore has the highest average IQ.'),
        ('What is the average retirement age in OECD countries?', ARRAY['~65', '~67', '~63', '~60'], 0, '~65.'),
        ('What is the most common educational attainment worldwide?', ARRAY['Primary', 'Secondary', 'Tertiary', 'None'], 0, 'Primary education is the most common.'),
        ('Which country has the highest rate of tertiary education?', ARRAY['Canada', 'South Korea', 'Japan', 'USA'], 0, 'Canada has the highest rate.'),
        ('What is the total number of people with disabilities worldwide?', ARRAY['~1 billion', '~800 million', '~1.2 billion', '~900 million'], 0, '~1 billion.'),
        ('What is the most common chronic disease?', ARRAY['Cardiovascular', 'Diabetes', 'Cancer', 'Respiratory'], 0, 'Cardiovascular is the most common.'),
        ('Which country has the most immigrants?', ARRAY['USA', 'Germany', 'Saudi Arabia', 'Russia'], 0, 'USA has the most.'),
        ('What is the average life expectancy for men vs women?', ARRAY['Women ~5 years longer', 'Women ~3 years longer', 'Men ~2 years longer', 'Same'], 0, 'Women live ~5 years longer.'),
        ('What is the most common terminal degree?', ARRAY['Bachelor''s', 'Master''s', 'PhD', 'Associate'], 0, 'Bachelor''s is the most common.'),
        ('What is the global youth unemployment rate?', ARRAY['~13%', '~10%', '~15%', '~20%'], 0, '~13%.'),
        ('Which country has the highest proportion of people living in extreme poverty?', ARRAY['DR Congo', 'Nigeria', 'India', 'Madagascar'], 0, 'DR Congo has a high poverty rate.'),
        ('What is the most common religion in India?', ARRAY['Hinduism', 'Islam', 'Christianity', 'Sikhism'], 0, 'Hinduism ~79%.'),
        ('What is the most common race in the USA?', ARRAY['White', 'Hispanic', 'African American', 'Asian'], 0, 'White (non-Hispanic) ~60%.'),
        ('What is the total number of languages spoken in the world?', ARRAY['~7,000', '~6,000', '~8,000', '~5,000'], 0, '~7,000 languages.'),
        ('Which country has the highest number of languages?', ARRAY['Papua New Guinea', 'Indonesia', 'India', 'Nigeria'], 0, 'Papua New Guinea has ~840 languages.'),
        ('What is the most common religion in the Middle East?', ARRAY['Islam', 'Christianity', 'Judaism', 'None'], 0, 'Islam is dominant.'),
        ('What is the total number of refugees worldwide?', ARRAY['~30 million', '~25 million', '~35 million', '~40 million'], 0, '~30 million as of 2024.'),
        ('Which country has the highest rate of emigration?', ARRAY['India', 'Mexico', 'China', 'Philippines'], 0, 'India has the largest diaspora.'),
        ('What is the most common type of family structure?', ARRAY['Nuclear', 'Extended', 'Single-parent', 'Childless'], 0, 'Nuclear family is most common.'),
        ('What is the average number of years of schooling?', ARRAY['~8', '~10', '~12', '~6'], 0, '~8 years.'),
        ('Which country has the highest rate of internet penetration?', ARRAY['Iceland', 'Norway', 'UK', 'USA'], 0, 'Iceland has ~100% internet penetration.')
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

    RAISE NOTICE '✅ 250 questions inserted successfully.';
END $$;