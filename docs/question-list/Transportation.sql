-- ============================================================================
-- INSERT 140 TRANSPORTATION TRIVIA QUESTIONS
-- ============================================================================
-- Covers: Roads, Railways, Aviation, Shipping, Space Travel, Public Transit,
-- Traffic, Infrastructure. All questions are factual and non‑sensitive.
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
        ('transportation', 'Transportation', '🚢', 2, 0),
        ('transportation.roads', 'Roads', NULL, 2, 1),
        ('transportation.railways', 'Railways', NULL, 2, 2),
        ('transportation.aviation', 'Aviation', NULL, 2, 3),
        ('transportation.shipping', 'Shipping', NULL, 2, 4),
        ('transportation.space_travel', 'Space Travel', NULL, 2, 5),
        ('transportation.public_transit', 'Public Transit', NULL, 2, 6),
        ('transportation.traffic', 'Traffic', NULL, 2, 7),
        ('transportation.infrastructure', 'Infrastructure', NULL, 2, 8)
    ON CONFLICT (path) DO NOTHING;

    -- ------------------------------------------------------------------------
    -- 2. Insert questions per category
    -- ------------------------------------------------------------------------

    -- ==================== ROADS (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'transportation.roads';
    FOR q_rec IN (
        VALUES
        ('What is the longest road in the world?', ARRAY['Pan‑American Highway', 'Trans‑Siberian Highway', 'Route 66', 'US‑Route 20'], 0, 'The Pan‑American Highway is about 30,000 km.'),
        ('Which country has the largest road network (total length)?', ARRAY['United States', 'China', 'India', 'Russia'], 0, 'The US has over 6.8 million km of roads.'),
        ('What is the most common type of road surface in the world?', ARRAY['Asphalt', 'Concrete', 'Gravel', 'Dirt'], 0, 'Asphalt is used for about 90% of paved roads.'),
        ('What is the highest paved road in the world?', ARRAY['Khardung La (India)', 'Tianmen Mountain Road (China)', 'Mauna Kea Road (Hawaii)', 'Pikes Peak Highway (USA)'], 0, 'Khardung La is at about 5,359 m.'),
        ('Which country has the most highways (motorways)?', ARRAY['China', 'United States', 'Spain', 'Germany'], 0, 'China has over 160,000 km of expressways.'),
        ('What is the famous US highway that runs from Chicago to Santa Monica?', ARRAY['Route 66', 'US‑1', 'US‑101', 'Interstate 40'], 0, 'Route 66 is a historic highway.'),
        ('What is the name of the world’s longest road tunnel?', ARRAY['Lærdal Tunnel (Norway)', 'Gotthard Base Tunnel (Switzerland)', 'Channel Tunnel', 'Seikan Tunnel'], 0, 'Lærdal is 24.5 km long.'),
        ('Which city has the most congested roads?', ARRAY['London', 'Los Angeles', 'Moscow', 'Bangalore'], 0, 'Bangalore often tops traffic congestion lists.'),
        ('What is the legal maximum speed limit on German Autobahns?', ARRAY['No general limit (advisory 130 km/h)', '120 km/h', '130 km/h', '100 km/h'], 0, 'Germany has no blanket speed limit on many Autobahn sections.'),
        ('What is the world’s busiest road bridge?', ARRAY['George Washington Bridge (US)', 'Sydney Harbour Bridge (Australia)', 'Golden Gate Bridge (US)', 'Brooklyn Bridge (US)'], 0, 'The George Washington Bridge carries over 100 million vehicles per year.'),
        ('What is the concept of "road diet"?', ARRAY['Reducing lanes to improve safety and mobility', 'Restricting heavy vehicles', 'Removing roads', 'Closing roads at night'], 0, 'Road diets convert four‑lane roads to three lanes to reduce speeding.'),
        ('Which country has the highest road density (km per 100 km²)?', ARRAY['Belgium', 'Netherlands', 'Japan', 'United Kingdom'], 0, 'Belgium has one of the highest road densities.'),
        ('What is the first paved road in history?', ARRAY['Roman Appian Way', 'Giza Road', 'Silk Road', 'Inca Road'], 0, 'The Appian Way was built in 312 BC.'),
        ('What is the primary cause of road pavement deterioration?', ARRAY['Heavy traffic and weathering', 'Poor construction', 'Chemical spills', 'Earthquakes'], 0, 'Traffic load and climate are main factors.'),
        ('Which country uses left‑hand traffic?', ARRAY['Japan', 'USA', 'France', 'Germany'], 0, 'Japan drives on the left (about 35% of countries).'),
        ('What is the typical width of a single lane on a highway?', ARRAY['3.5 metres', '2.5 metres', '4 metres', '5 metres'], 0, 'Standard lane width is 3.5 m in most countries.'),
        ('What is the total length of the US Interstate Highway System?', ARRAY['~78,000 km', '~50,000 km', '~100,000 km', '~60,000 km'], 0, 'The Interstate system is about 78,000 km.'),
        ('What is the name of the road connecting Alaska to the rest of North America?', ARRAY['Alaska Highway', 'Trans‑Canada Highway', 'Yellowhead Highway', 'Dempster Highway'], 0, 'The Alaska Highway was built during WWII.')
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

    -- ==================== RAILWAYS (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'transportation.railways';
    FOR q_rec IN (
        VALUES
        ('Which country has the longest railway network?', ARRAY['United States', 'China', 'Russia', 'India'], 0, 'The US has over 220,000 km of rail lines.'),
        ('What is the longest railway line in the world?', ARRAY['Trans‑Siberian Railway', 'Canadian Pacific Railway', 'Shanghai‑Kunming', 'Indian Railways' ], 0, 'The Trans‑Siberian is about 9,289 km.'),
        ('What is the fastest commercial train in operation?', ARRAY['Shanghai Maglev', 'CRH (China) Fuxing', 'TGV (France)', 'Shinkansen (Japan)'], 0, 'The Shanghai Maglev reaches 431 km/h.'),
        ('What is the standard gauge width for most railways?', ARRAY['1,435 mm', '1,520 mm', '1,067 mm', '1,000 mm'], 0, '1435 mm is used by about 60% of the world’s railways.'),
        ('Which country has the most high‑speed rail (HSR) track?', ARRAY['China', 'Spain', 'Japan', 'France'], 0, 'China has over 40,000 km of HSR.'),
        ('What is the name of the train that runs from London to Paris under the English Channel?', ARRAY['Eurostar', 'TGV', 'ICE', 'Thalys'], 0, 'Eurostar uses the Channel Tunnel.'),
        ('What is the busiest railway station in the world by platform traffic?', ARRAY['Shinjuku Station (Tokyo)', 'Grand Central (NY)', 'Beijing West', 'Clapham Junction (UK)'], 0, 'Shinjuku handles over 3 million passengers per day.'),
        ('Which country was the first to have a public railway?', ARRAY['United Kingdom', 'United States', 'Germany', 'France'], 0, 'The Stockton‑Darlington Railway opened in 1825.'),
        ('What is the highest railway in the world?', ARRAY['Qinghai‑Tibet Railway', 'Andean Railway', 'Cuzco‑Machu Picchu', 'Rhaetian Railway'], 0, 'The Qinghai‑Tibet reaches 5,072 m.'),
        ('What is the typical voltage used for overhead catenary on high‑speed lines?', ARRAY['25 kV AC', '1.5 kV DC', '15 kV AC', '3 kV DC'], 0, '25 kV AC is the standard for HSR.'),
        ('Which country has the highest railway density?', ARRAY['Switzerland', 'Japan', 'Belgium', 'Netherlands'], 0, 'Switzerland has about 130 km per 1,000 km².'),
        ('What is the name of the Australian railway that crosses the Nullarbor Plain?', ARRAY['Trans‑Australian Railway', 'Indian Pacific', 'The Ghan', 'Overland'], 0, 'The Indian Pacific runs from Sydney to Perth.'),
        ('What is the heaviest freight train ever recorded?', ARRAY['Over 100,000 tonnes (Australia)', '50,000 tonnes (US)', '30,000 tonnes (Russia)', '20,000 tonnes (Brazil)'], 0, 'BHP Billiton operated a train of over 100,000 tonnes in Australia.'),
        ('What is the purpose of a railway sleeper (tie)?', ARRAY['To support rails and distribute load', 'To guide trains', 'To provide electricity', 'To signal trains'], 0, 'Sleepers hold rails at gauge and transfer loads to the ballast.'),
        ('Which company operates the largest rail network in India?', ARRAY['Indian Railways', 'Konkan Railway', 'Delhi Metro', 'Mumbai Railways'], 0, 'Indian Railways is a state‑owned entity with over 120,000 km.'),
        ('What is the longest railway tunnel in the world?', ARRAY['Gotthard Base Tunnel (Switzerland)', 'Channel Tunnel', 'Seikan Tunnel (Japan)', 'Lærdal Tunnel (Norway)'], 0, 'Gotthard is 57.1 km (rail).'),
        ('What is the principle of magnetic levitation (maglev) trains?', ARRAY['Use magnets to lift and propel', 'Use wheels on steel rails', 'Use air cushion', 'Use linear motors on track'], 0, 'Maglev uses electromagnetic force for both levitation and propulsion.'),
        ('Which country is the largest exporter of railway technology?', ARRAY['China', 'Germany', 'Japan', 'France'], 0, 'China has become a major exporter of rail systems.')
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

    -- ==================== AVIATION (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'transportation.aviation';
    FOR q_rec IN (
        VALUES
        ('Which airline is the largest by passengers carried?', ARRAY['American Airlines', 'Delta', 'United', 'China Southern'], 0, 'American Airlines has historically led in passengers.'),
        ('What is the world’s busiest airport by passenger traffic?', ARRAY['Hartsfield‑Jackson Atlanta (ATL)', 'Dubai (DXB)', 'Tokyo Haneda (HND)', 'London Heathrow (LHR)'], 0, 'ATL has been the busiest for decades.'),
        ('What is the cruising altitude of commercial jets typically?', ARRAY['35,000 feet (~10,700 m)', '25,000 feet', '45,000 feet', '50,000 feet'], 0, 'Most jetliners cruise at FL350 (35,000 ft).'),
        ('What is the most produced commercial airliner?', ARRAY['Boeing 737', 'Airbus A320', 'Boeing 747', 'Airbus A380'], 0, 'The 737 family has over 15,000 built.'),
        ('Which country has the most airports?', ARRAY['United States', 'China', 'Brazil', 'Mexico'], 0, 'The US has over 5,000 public airports.'),
        ('What is the fastest commercial aircraft in service (retired?)?', ARRAY['Concorde (retired)', 'Boeing 747', 'Airbus A380', 'Boeing 777'], 0, 'Concorde cruised at Mach 2.04 but retired in 2003.'),
        ('What is the largest passenger aircraft?', ARRAY['Airbus A380', 'Boeing 747‑8', 'Antonov An‑225 (cargo)', 'Lockheed C‑5'], 0, 'The A380 is the largest passenger jet.'),
        ('What is the primary cause of aviation delays?', ARRAY['Weather', 'Air traffic control', 'Mechanical issues', 'Security'], 0, 'Weather is the largest cause of delays.'),
        ('What is the ICAO (International Civil Aviation Organization) responsible for?', ARRAY['Setting global aviation standards', 'Managing airports', 'Operating airlines', 'Controlling airspace'], 0, 'ICAO develops international standards for aviation safety and efficiency.'),
        ('Which airline alliance is the largest?', ARRAY['Star Alliance', 'SkyTeam', 'oneworld', 'U‑Fly'], 0, 'Star Alliance is the largest with 26 member airlines.'),
        ('What is the principle of flight for a fixed‑wing aircraft?', ARRAY['Lift generated by wings due to airflow', 'Thrust from engines', 'Buoyancy', 'Magnus effect'], 0, 'Lift is created by Bernoulli’s principle and Newton’s third law.'),
        ('What is the world’s longest non‑stop commercial flight?', ARRAY['New York‑Singapore (SQ24)', 'Perth‑London', 'Auckland‑Doha', 'Sydney‑Dallas'], 0, 'SQ24 from New York JFK to Singapore is about 15,400 km, 18 hours.'),
        ('Which country has the highest aviation safety record?', ARRAY['Australia', 'Canada', 'UK', 'Japan'], 0, 'Australia is often cited for its excellent safety record.'),
        ('What is the role of air traffic control (ATC)?', ARRAY['Separate and route aircraft safely', 'Maintain aircraft', 'Provide weather info', 'Sell tickets'], 0, 'ATC ensures safe and orderly flow of traffic.'),
        ('What is the typical takeoff speed of a Boeing 737?', ARRAY['~250‑280 km/h', '~200 km/h', '~300 km/h', '~350 km/h'], 0, 'Typical V1 is around 140 knots (250 km/h).'),
        ('Which aircraft is known as "Jumbo Jet"?', ARRAY['Boeing 747', 'Airbus A380', 'Boeing 777', 'McDonnell Douglas DC‑10'], 0, 'The 747 was the first widebody, nicknamed Jumbo.'),
        ('What is the difference between a jet and a turboprop?', ARRAY['Jet uses turbines; turboprop uses turbine to drive propeller', 'Jet is faster; turboprop is slower', 'Both use turbines but different propulsion', 'All of the above'], 0, 'Turboprops are efficient at lower speeds and altitudes.'),
        ('Which organization operates the European air traffic control?', ARRAY['Eurocontrol', 'EASA', 'IATA', 'ICAO'], 0, 'Eurocontrol coordinates air traffic in Europe.')
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

    -- ==================== SHIPPING (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'transportation.shipping';
    FOR q_rec IN (
        VALUES
        ('What is the largest ship by gross tonnage?', ARRAY['Seawise Giant (formerly) - 260,000 GT', 'Ever Ace (container)', 'Oasis of the Seas (cruise)', 'TI Class (supertanker)'], 0, 'Seawise Giant was 458 m, 260,000 GT; now scrapped.'),
        ('Which country has the largest merchant fleet?', ARRAY['China', 'Greece', 'Japan', 'Singapore'], 0, 'China (including Hong Kong) is the largest in terms of number of ships.'),
        ('What is the busiest port in the world by container volume?', ARRAY['Shanghai', 'Singapore', 'Shenzhen', 'Ningbo‑Zhoushan'], 0, 'Shanghai handles over 47 million TEU annually.'),
        ('What is the Suez Canal?', ARRAY['A man‑made waterway in Egypt connecting Mediterranean to Red Sea', 'A canal in Panama', 'A river in Europe', 'A strait'], 0, 'The Suez Canal is a key shipping route.'),
        ('What is the primary fuel used by large ocean‑going vessels?', ARRAY['Heavy fuel oil (bunker fuel)', 'Diesel', 'LNG', 'Electricity'], 0, 'Heavy fuel oil is the most common, though regulations are tightening.'),
        ('What is the Panama Canal expansion called?', ARRAY['Third set of locks', 'Panama Canal Expansion', 'New Panamax', 'All of the above'], 0, 'It was completed in 2016.'),
        ('Which strait is the most important chokepoint for oil shipping?', ARRAY['Strait of Hormuz', 'Malacca Strait', 'Bosphorus', 'Suez Canal'], 0, 'Hormuz is critical for Persian Gulf exports.'),
        ('What is the average speed of a container ship?', ARRAY['~20 knots (37 km/h)', '~30 knots', '~10 knots', '~25 knots'], 0, 'Container ships typically steam at 18‑23 knots.'),
        ('What is the name of the system for tracking ships?', ARRAY['Automatic Identification System (AIS)', 'GPS', 'Radar', 'Vessel Traffic Service'], 0, 'AIS is mandatory for large vessels.'),
        ('Which country is the largest shipbuilder?', ARRAY['China', 'South Korea', 'Japan', 'Vietnam'], 0, 'China leads in shipbuilding by tonnage.'),
        ('What is the concept of "cabotage"?', ARRAY['Coastal shipping restricted to domestic vessels', 'International shipping', 'Cargo handling', 'Ship registration'], 0, 'Cabotage laws protect domestic shipping industries.'),
        ('What is the largest container ship currently operating (as of 2025)?', ARRAY['MSC Irina (24,000+ TEU)', 'Ever Alot (24,000+ TEU)', 'HMM Algeciras (24,000 TEU)', 'CMA CGM Jacques Saade (23,000 TEU)'], 0, 'Several ships exceed 24,000 TEU, with MSC Irina among the largest.'),
        ('What is the average lifespan of a commercial cargo ship?', ARRAY['25‑30 years', '15‑20 years', '30‑40 years', '10‑15 years'], 0, 'Ships are typically scrapped after about 25‑30 years.'),
        ('What is the primary role of the International Maritime Organization (IMO)?', ARRAY['Regulate shipping safety and environmental performance', 'Promote trade', 'Build ships', 'Manage ports'], 0, 'IMO sets global standards for shipping.'),
        ('What is the term for the line on a ship’s hull indicating maximum load?', ARRAY['Plimsoll line', 'Load line', 'Draft mark', 'Waterline'], 0, 'The Plimsoll line shows safe loading levels.'),
        ('Which canal connects the Atlantic and Pacific oceans?', ARRAY['Panama Canal', 'Suez Canal', 'Kiel Canal', 'Welland Canal'], 0, 'The Panama Canal provides that link.'),
        ('What is the most common type of cargo ship?', ARRAY['Bulk carrier', 'Container ship', 'Tanker', 'General cargo'], 0, 'Bulk carriers account for about 40% of the fleet by tonnage.'),
        ('What is the typical draft of a large container ship?', ARRAY['~15‑16 metres', '~20 metres', '~10 metres', '~25 metres'], 0, 'Post‑Panamax ships have drafts of about 15 m.')
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

    -- ==================== SPACE TRAVEL (16) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'transportation.space_travel';
    FOR q_rec IN (
        VALUES
        ('Who was the first human in space?', ARRAY['Yuri Gagarin', 'Alan Shepard', 'Neil Armstrong', 'John Glenn'], 0, 'Gagarin orbited Earth in 1961.'),
        ('Who was the first person to walk on the Moon?', ARRAY['Neil Armstrong', 'Buzz Aldrin', 'Yuri Gagarin', 'John Young'], 0, 'Armstrong stepped on the Moon in 1969.'),
        ('What is the name of the spacecraft that carried humans to the Moon?', ARRAY['Apollo', 'Soyuz', 'Gemini', 'Mercury'], 0, 'Apollo missions used the Command and Lunar Modules.'),
        ('Which country has the most satellites in orbit?', ARRAY['United States', 'China', 'Russia', 'India'], 0, 'The US has over 5,000 satellites (including commercial).'),
        ('What is the International Space Station (ISS)?', ARRAY['A habitable artificial satellite', 'A lunar base', 'A Mars rover', 'A telescope'], 0, 'The ISS is a multinational space station.'),
        ('What is the average speed of the ISS in orbit?', ARRAY['~28,000 km/h', '~20,000 km/h', '~35,000 km/h', '~15,000 km/h'], 0, 'The ISS orbits at about 7.7 km/s.'),
        ('Which private company is a leader in reusable rockets?', ARRAY['SpaceX', 'Blue Origin', 'Virgin Galactic', 'Rocket Lab'], 0, 'SpaceX pioneered reusable Falcon 9 boosters.'),
        ('What is the longest single spaceflight by a human?', ARRAY['Valery Polyakov (437 days)', 'Scott Kelly (340 days)', 'Mikhail Kornienko (340 days)', 'Peggy Whitson (289 days)'], 0, 'Polyakov spent 437 continuous days on Mir.'),
        ('What is the name of the first space tourist?', ARRAY['Dennis Tito', 'Jeff Bezos', 'Richard Branson', 'Elon Musk'], 0, 'Tito visited the ISS in 2001.'),
        ('What is the primary rocket used by NASA for deep space exploration (planned)?', ARRAY['Space Launch System (SLS)', 'Falcon Heavy', 'Starship', 'Ariane 6'], 0, 'SLS is NASA’s heavy‑lift vehicle for Artemis missions.'),
        ('Which country was the first to successfully land a rover on Mars?', ARRAY['United States (Sojourner, 1997)', 'Soviet Union', 'China (Zhurong)', 'India (Mangalyaan)'], 0, 'Sojourner was the first rover on Mars.'),
        ('What is the name of the mission that first landed humans on the Moon?', ARRAY['Apollo 11', 'Apollo 13', 'Apollo 8', 'Apollo 17'], 0, 'Apollo 11 landed on July 20, 1969.'),
        ('What is the approximate cost per kg to launch to Low Earth Orbit?', ARRAY['~$5,000‑$10,000', '~$20,000', '~$2,000', '~$30,000'], 0, 'Costs have dropped to around $5,000‑10,000/kg with reusable rockets.'),
        ('What is the furthest human‑made object from Earth?', ARRAY['Voyager 1', 'Voyager 2', 'Pioneer 10', 'New Horizons'], 0, 'Voyager 1 is over 24 billion km away and in interstellar space.'),
        ('What is the name of the Chinese space station?', ARRAY['Tiangong', 'Skylab', 'Mir', 'ISS'], 0, 'Tiangong is China’s modular space station.'),
        ('What is the primary purpose of the Artemis program?', ARRAY['Return humans to the Moon and establish a sustainable presence', 'Mars landing', 'Build a space station', 'Study asteroids'], 0, 'Artemis aims for the first woman and next man on the Moon.')
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

    -- ==================== PUBLIC TRANSIT (17) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'transportation.public_transit';
    FOR q_rec IN (
        VALUES
        ('What is the most used public transit mode in the world?', ARRAY['Buses', 'Trains', 'Metro', 'Trams'], 0, 'Buses carry the majority of public transit passengers.'),
        ('Which city has the longest metro system by route length?', ARRAY['Shanghai', 'London', 'New York City', 'Moscow'], 0, 'Shanghai Metro has over 800 km.'),
        ('Which city has the oldest underground metro system?', ARRAY['London (1863)', 'Paris (1900)', 'New York (1904)', 'Budapest (1896)'], 0, 'The London Underground is the oldest.'),
        ('What is the busiest metro system by annual ridership?', ARRAY['Tokyo Metro (and Toei)', 'Moscow', 'Seoul', 'Shanghai'], 0, 'Tokyo’s combined metro systems have about 3.5 billion annual rides.'),
        ('What is a light rail system?', ARRAY['A tram‑like system with dedicated lanes', 'A bus rapid transit', 'A heavy rail subway', 'A cable car'], 0, 'Light rail is a modernized tram system, often with priority signals.'),
        ('Which city has the largest bus rapid transit (BRT) system?', ARRAY['Bogotá (TransMilenio)', 'Mexico City (Metrobús)', 'Istanbul (Metrobus)', 'Guangzhou BRT'], 0, 'TransMilenio is often cited as the most extensive BRT.'),
        ('What is the typical headway (frequency) of a metro system during peak hours?', ARRAY['2‑5 minutes', '10‑15 minutes', '1‑2 minutes', '5‑10 minutes'], 0, 'Many metro systems run every 2‑5 minutes at peak.'),
        ('Which country has the highest per capita public transit ridership?', ARRAY['Japan', 'South Korea', 'Switzerland', 'Russia'], 0, 'Japan has very high transit usage per person.'),
        ('What is the term for a system that combines rail and road in a single corridor?', ARRAY['Tram‑train', 'Light rail', 'Streetcar', 'Interurban'], 0, 'Tram‑trains run on both heavy rail and street tram lines.'),
        ('What is the main advantage of electric buses over diesel?', ARRAY['Reduced local pollution and noise', 'Faster', 'Higher capacity', 'Lower infrastructure cost'], 0, 'Electric buses lower emissions and noise in cities.'),
        ('Which city has the first fully automated driverless metro?', ARRAY['London (Docklands Light Railway)', 'Singapore (North‑East Line)', 'Vancouver (SkyTrain)', 'Paris (Line 14)'], 0, 'Vancouver’s SkyTrain (1986) was one of the first.'),
        ('What is the role of park‑and‑ride facilities?', ARRAY['Encourage car‑to‑transit transfer', 'Parking for long‑term', 'Bus depots', 'Metro stations'], 0, 'Park‑and‑ride lots allow commuters to park and take transit.'),
        ('Which US city has the highest public transit ridership?', ARRAY['New York City', 'Washington DC', 'Chicago', 'San Francisco'], 0, 'NYC transit accounts for about 40% of US transit trips.'),
        ('What is the length of the longest subway line in the world?', ARRAY['Shanghai Line 11 (82 km)', 'Seoul Line 1 (200 km with branches)', 'Moscow Arbatsko‑Pokrovskaya (45 km)', 'London Central (74 km)'], 0, 'Shanghai Line 11 is over 80 km.'),
        ('What is a "proof‑of‑payment" system?', ARRAY['Passengers must show ticket upon inspection (no gates)', 'Ticket machines at every stop', 'Electronic ticketing', 'Free fares'], 0, 'Proof‑of‑payment (POP) is used in many European systems.'),
        ('Which city has the most extensive tram (streetcar) network?', ARRAY['Melbourne', 'St. Petersburg', 'Budapest', 'Zurich'], 0, 'Melbourne has over 250 km of tram lines.'),
        ('What is the typical fare collection method for bus systems in many cities?', ARRAY['Contactless smart card', 'Cash only', 'Mobile app', 'All of the above'], 0, 'Contactless smart cards (e.g., Oyster, Octopus) are common.')
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

    -- ==================== TRAFFIC (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'transportation.traffic';
    FOR q_rec IN (
        VALUES
        ('What is the main cause of traffic congestion?', ARRAY['Too many vehicles for road capacity', 'Weather', 'Accidents', 'Traffic lights'], 0, 'Congestion occurs when demand exceeds supply.'),
        ('What is the concept of induced demand in traffic?', ARRAY['Building more roads leads to more traffic', 'Demand decreases with road building', 'Traffic is independent of road supply', 'Road building reduces congestion permanently'], 0, 'Induced demand is a well‑established phenomenon.'),
        ('What is a traffic signal that prioritizes buses?', ARRAY['Transit signal priority (TSP)', 'Green wave', 'Adaptive control', 'Pre‑emption'], 0, 'TSP extends green lights for approaching buses.'),
        ('Which city is known for its high congestion (often ranked worst)?', ARRAY['Los Angeles', 'London', 'Mumbai', 'Moscow'], 0, 'Los Angeles often tops congestion rankings.'),
        ('What is the purpose of a roundabout?', ARRAY['Reduce conflict points and improve flow', 'Increase speed', 'Add traffic signals', 'Widen roads'], 0, 'Roundabouts reduce collisions and keep traffic moving.'),
        ('What is the average commute time in the US?', ARRAY['~27 minutes', '~20 minutes', '~35 minutes', '~45 minutes'], 0, 'The average one‑way commute is about 27 minutes.'),
        ('What is the term for temporary lane assignment changes based on time of day?', ARRAY['Reversible lanes', 'HOV lanes', 'Bus lanes', 'Shoulder lanes'], 0, 'Reversible lanes change direction to match peak flows.'),
        ('What is the main purpose of speed bumps?', ARRAY['Calm traffic', 'Reduce emissions', 'Increase speed', 'Guide pedestrians'], 0, 'Speed bumps are traffic calming devices.'),
        ('Which country has the highest rate of car ownership?', ARRAY['United States', 'Italy', 'Germany', 'Japan'], 0, 'The US has about 850 cars per 1,000 people.'),
        ('What is the role of adaptive traffic control systems?', ARRAY['Adjust signal timings based on real‑time traffic', 'Fixed timing', 'Manual control', 'Emergency vehicle pre‑emption'], 0, 'Adaptive systems optimize traffic flow.'),
        ('What is the term for a street designed for both pedestrians and vehicles with minimal separation?', ARRAY['Shared space', 'Pedestrian zone', 'Road diet', 'Boulevard'], 0, 'Shared space removes traffic lights and barriers to encourage shared use.'),
        ('What is the approximate cost of traffic congestion in the US per year?', ARRAY['~$100 billion', '~$50 billion', '~$200 billion', '~$150 billion'], 0, 'Studies estimate congestion costs over $100 billion annually.'),
        ('What is the concept of "road pricing" (congestion pricing)?', ARRAY['Charging drivers to use certain roads at peak times', 'Taxing fuel', 'Toll roads', 'Parking fees'], 0, 'Congestion pricing is used in London, Singapore, etc.'),
        ('What is a major benefit of high‑occupancy vehicle (HOV) lanes?', ARRAY['Encourage carpooling and reduce traffic', 'Increase speed', 'Lower emissions', 'All of the above'], 0, 'HOV lanes reward carpoolers and reduce overall vehicle trips.'),
        ('What is the typical design speed of a local urban street?', ARRAY['30‑50 km/h', '60‑80 km/h', '20‑30 km/h', '50‑70 km/h'], 0, 'Local streets are designed for lower speeds.'),
        ('Which European city is famous for its extensive cycling infrastructure?', ARRAY['Copenhagen', 'Amsterdam', 'Berlin', 'Paris'], 0, 'Copenhagen and Amsterdam are world leaders in cycling.'),
        ('What is the term for the amount of time a signal stays green?', ARRAY['Green interval', 'Cycle length', 'Phase', 'Offset'], 0, 'The green interval is the time for a specific movement.'),
        ('What is the primary cause of most road accidents?', ARRAY['Human error', 'Vehicle defects', 'Road conditions', 'Weather'], 0, 'Human error accounts for about 90% of crashes.')
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

    -- ==================== INFRASTRUCTURE (17) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'transportation.infrastructure';
    FOR q_rec IN (
        VALUES
        ('What is the world’s longest bridge (by total length)?', ARRAY['Danyang‑Kunshan Grand Bridge (China)', 'Lake Pontchartrain Causeway (US)', 'Hong Kong‑Zhuhai‑Macau Bridge (China)', 'Millau Viaduct (France)'], 0, 'The Danyang‑Kunshan bridge is over 164 km.'),
        ('What is the longest suspension bridge?', ARRAY['Akashi Kaikyo Bridge (Japan)', 'Yangtze River Bridge (China)', 'Golden Gate Bridge (US)', 'Great Belt Bridge (Denmark)'], 0, 'Akashi Kaikyo is 1,991 m main span.'),
        ('What is the deepest tunnel in the world (road)?', ARRAY['Ryfast (Norway)', 'Gotthard Base Tunnel (rail)', 'Channel Tunnel', 'Seikan Tunnel'], 0, 'Ryfast reaches 292 m below sea level.'),
        ('What is the largest seaport in the world by area?', ARRAY['Port of Shanghai', 'Port of Singapore', 'Port of Rotterdam', 'Port of Los Angeles'], 0, 'Shanghai is the largest by cargo tonnage and area.'),
        ('Which country has the highest number of airports?', ARRAY['United States', 'Brazil', 'Mexico', 'Russia'], 0, 'The US has over 5,000 public airports.'),
        ('What is the largest international border crossing by vehicle traffic?', ARRAY['San Ysidro (US‑Mexico)', 'Ambassador Bridge (US‑Canada)', 'Tijuana crossing', 'Blaine (US‑Canada)'], 0, 'San Ysidro handles millions of vehicles per year.'),
        ('What is the typical design life of a highway pavement?', ARRAY['20‑30 years', '10‑15 years', '40‑50 years', '5‑10 years'], 0, 'Pavements are designed for 20‑30 years, but require regular maintenance.'),
        ('What is the total length of the world’s road network?', ARRAY['~65 million km', '~40 million km', '~100 million km', '~30 million km'], 0, 'Global road network is estimated at 65 million km.'),
        ('Which country has the longest coastline, necessitating extensive port infrastructure?', ARRAY['Canada', 'Indonesia', 'Russia', 'Australia'], 0, 'Canada has the longest coastline (~202,000 km).'),
        ('What is the main material used for bridge construction in modern times?', ARRAY['Reinforced concrete and steel', 'Wood', 'Stone', 'Aluminium'], 0, 'Concrete and steel are dominant materials.'),
        ('What is the term for a tunnel that runs under a body of water?', ARRAY['Subaqueous tunnel', 'Subterranean tunnel', 'Cut‑and‑cover', 'Bore tunnel'], 0, 'Subaqueous tunnels are built under rivers or seas.'),
        ('What is the cost per kilometre of building a high‑speed rail line (approx.)?', ARRAY['$10‑50 million', '$1‑5 million', '$100‑200 million', '$50‑100 million'], 0, 'HSR costs vary, but often exceed $30 million per km in developed countries.'),
        ('Which country has the most bridges?', ARRAY['China', 'United States', 'Germany', 'Brazil'], 0, 'China has over 1 million bridges.'),
        ('What is the role of a flyover (overpass) in urban areas?', ARRAY['Separate conflicting traffic streams', 'Reduce speed', 'Provide parking', 'Increase pedestrian access'], 0, 'Flyovers allow free‑flow movement at intersections.'),
        ('What is the largest airport terminal building in the world?', ARRAY['Dubai International (Terminal 3)', 'Beijing Daxing (Terminal 1)', 'Istanbul Airport', 'Los Angeles (Tom Bradley)'], 0, 'Dubai T3 is the largest by floor area.'),
        ('What is the average lifespan of a railway track?', ARRAY['30‑50 years (with maintenance)', '10‑20 years', '50‑100 years', '5‑10 years'], 0, 'Properly maintained track can last 50+ years.'),
        ('Which country has the highest density of railway lines per capita?', ARRAY['Switzerland', 'Japan', 'Belgium', 'Netherlands'], 0, 'Switzerland has a high density of rail per person.')
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

    RAISE NOTICE '✅ 140 transportation questions inserted successfully.';
END $$;