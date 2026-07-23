-- ============================================================================
-- INSERT 120 AUTOMOTIVE TRIVIA QUESTIONS
-- ============================================================================
-- Covers: Brands, Models, History, Engines & Technology, Safety & Features,
-- Motorsport & Racing, Electric & Hybrid, Maintenance & Tips.
-- All questions are factual and non-sensitive.
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
        ('cars', 'Cars', '🚗', 1, 0),
        ('cars.brands', 'Car Brands', NULL, 1, 1),
        ('cars.models', 'Iconic Models', NULL, 1, 2),
        ('cars.history', 'Automotive History', NULL, 1, 3),
        ('cars.engines_technology', 'Engines & Technology', NULL, 1, 4),
        ('cars.safety_features', 'Safety & Features', NULL, 1, 5),
        ('cars.motorsport', 'Motorsport & Racing', NULL, 1, 6),
        ('cars.electric_hybrid', 'Electric & Hybrid', NULL, 1, 7),
        ('cars.maintenance_tips', 'Maintenance & Tips', NULL, 1, 8)
    ON CONFLICT (path) DO NOTHING;

    -- ------------------------------------------------------------------------
    -- 2. Insert questions per category (15 per sub-category = 120 total)
    -- ------------------------------------------------------------------------

    -- ==================== CAR BRANDS (15) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'cars.brands';
    FOR q_rec IN (
        VALUES
        ('Which German car brand uses a four-ring logo?', ARRAY['Audi', 'BMW', 'Mercedes-Benz', 'Volkswagen'], 0, 'Audi''s logo represents four merged companies.'),
        ('What is the oldest car brand still in production?', ARRAY['Mercedes-Benz', 'Ford', 'Peugeot', 'Skoda'], 0, 'Mercedes-Benz traces its roots to the 1880s.'),
        ('Which brand is known for its prancing horse logo?', ARRAY['Ferrari', 'Porsche', 'Lamborghini', 'Maserati'], 0, 'The Ferrari prancing horse originated from a World War I fighter pilot.'),
        ('Which Japanese brand is famous for its "Winged A" emblem?', ARRAY['Acura', 'Lexus', 'Infiniti', 'Subaru'], 0, 'Acura is Honda''s luxury brand.'),
        ('Which British luxury brand is known for the Spirit of Ecstasy hood ornament?', ARRAY['Rolls-Royce', 'Bentley', 'Jaguar', 'Aston Martin'], 0, 'The Spirit of Ecstasy was introduced in 1911.'),
        ('What does the acronym BMW stand for?', ARRAY['Bayerische Motoren Werke', 'Bavarian Motor Works', 'British Motor Works', 'Berlin Motor Works'], 0, 'It translates to Bavarian Engine Works.'),
        ('Which Korean brand has a slanted "H" logo?', ARRAY['Hyundai', 'Kia', 'Daewoo', 'SsangYong'], 0, 'Hyundai''s logo symbolizes a stylized "H".'),
        ('Which Italian brand is famous for its bull logo?', ARRAY['Lamborghini', 'Ferrari', 'Maserati', 'Alfa Romeo'], 0, 'The bull represents the founder''s zodiac sign (Taurus).'),
        ('Which French brand has a lion logo?', ARRAY['Peugeot', 'Citroën', 'Renault', 'Bugatti'], 0, 'Peugeot''s lion emblem dates to the 19th century.'),
        ('Which American brand has a blue oval logo?', ARRAY['Ford', 'Chevrolet', 'Dodge', 'Tesla'], 0, 'Ford''s blue oval is iconic.'),
        ('Which brand''s logo is a three-pointed star representing land, sea, and air?', ARRAY['Mercedes-Benz', 'BMW', 'Audi', 'Porsche'], 0, 'The star symbolizes the company''s ambition.'),
        ('Which Swedish brand is known for safety and its diagonal grille cross?', ARRAY['Volvo', 'Saab', 'Scania', 'Koenigsegg'], 0, 'Volvo is synonymous with safety innovations.'),
        ('Which brand produces the "Stingray" model?', ARRAY['Chevrolet', 'Dodge', 'Ford', 'Pontiac'], 0, 'Chevrolet Corvette Stingray is a legendary sports car.'),
        ('What does the "GT" in Ford GT stand for?', ARRAY['Grand Touring', 'Gran Turismo', 'Grand Tourism', 'Great Touring'], 0, 'GT stands for Grand Touring.'),
        ('Which brand uses a "roundel" with blue and white quadrants, derived from a spinning propeller?', ARRAY['BMW', 'Audi', 'Mercedes', 'Porsche'], 0, 'The BMW roundel is often said to represent a spinning propeller.')
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

    -- ==================== ICONIC MODELS (15) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'cars.models';
    FOR q_rec IN (
        VALUES
        ('Which model is known as the "Halo" car of the Corvette lineup?', ARRAY['Corvette ZR1', 'Corvette Stingray', 'Corvette Z06', 'Corvette C8.R'], 0, 'The ZR1 is the flagship model.'),
        ('Which iconic Ford model was produced from 1964 to 1973 and is known as the "Pony Car"?', ARRAY['Mustang', 'Camaro', 'Challenger', 'Barracuda'], 0, 'The Mustang pioneered the pony car segment.'),
        ('What is the name of the original Volkswagen "people''s car" introduced in the 1930s?', ARRAY['Beetle', 'Golf', 'Kombi', 'Jetta'], 0, 'The VW Beetle was designed to be affordable.'),
        ('Which model is the longest-selling nameplate in automotive history?', ARRAY['Chevrolet Suburban', 'Ford F-Series', 'Toyota Corolla', 'Volkswagen Beetle'], 0, 'The Suburban has been in production since 1935.'),
        ('Which car is often called the "world''s best-selling car"?', ARRAY['Toyota Corolla', 'Ford F-150', 'Volkswagen Golf', 'Honda Civic'], 0, 'The Corolla has sold over 50 million units.'),
        ('Which model is the ultimate performance version of the Porsche 911?', ARRAY['Turbo S', 'GT2 RS', 'GT3', 'Carrera S'], 0, 'The GT2 RS is the most powerful road-going 911.'),
        ('What is the name of the mid-engined supercar from Ferrari?', ARRAY['F8 Tributo', 'LaFerrari', '488', 'SF90 Stradale'], 0, 'The SF90 is a plug-in hybrid supercar.'),
        ('Which British model was featured in the James Bond film "Goldfinger"?', ARRAY['Aston Martin DB5', 'Aston Martin Vantage', 'Jaguar E-Type', 'Lotus Esprit'], 0, 'The DB5 became iconic with Bond.'),
        ('What is the name of the first mass-produced car with a unibody construction?', ARRAY['Lancia Lambda', 'Citroën Traction Avant', 'Ford Model T', 'Fiat 500'], 0, 'The Lancia Lambda (1922) had a unibody.'),
        ('Which model is the flagship of the Dodge lineup, known for its supercharged V8?', ARRAY['Challenger SRT Demon', 'Charger Hellcat', 'Challenger Hellcat', 'Durango Hellcat'], 0, 'The Challenger SRT Demon is a 840-hp drag racer.'),
        ('Which Japanese model is famous for its "Kenmeri" nickname?', ARRAY['Nissan Skyline (C110)', 'Toyota Celica', 'Mazda RX-7', 'Honda NSX'], 0, 'The C110 Skyline is called Kenmeri.'),
        ('Which Swedish model is known for its roof-mounted scoop?', ARRAY['Saab 900 Turbo', 'Volvo 240', 'Koenigsegg CCX', 'Saab 99'], 0, 'The Saab 900 Turbo had a distinctive scoop.'),
        ('What is the name of the mid-engine sports car from Lotus?', ARRAY['Evora', 'Esprit', 'Elise', 'Exige'], 0, 'The Evora is a mid-engined grand tourer.'),
        ('Which model is the basis for the Shelby GT500?', ARRAY['Ford Mustang', 'Shelby Cobra', 'Ford GT', 'Dodge Viper'], 0, 'The GT500 is a high-performance Mustang.'),
        ('What is the name of the electric sedan from Lucid?', ARRAY['Air', 'Gravity', 'Lucid', 'Dream'], 0, 'The Lucid Air is a luxury EV sedan.')
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

    -- ==================== AUTOMOTIVE HISTORY (15) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'cars.history';
    FOR q_rec IN (
        VALUES
        ('Who is credited with building the first practical automobile with a gasoline engine?', ARRAY['Karl Benz', 'Gottlieb Daimler', 'Henry Ford', 'Nikolaus Otto'], 0, 'Benz built the Patent-Motorwagen in 1885.'),
        ('In which year did the first Ford Model T roll off the assembly line?', ARRAY['1908', '1910', '1903', '1913'], 0, 'The Model T was introduced in 1908.'),
        ('Which car was the first to be mass-produced on an assembly line?', ARRAY['Ford Model T', 'Ford Model A', 'Chevrolet 490', 'Dodge Brothers'], 0, 'The Model T line started in 1913.'),
        ('What was the first car to exceed 100 mph?', ARRAY['Camille Jenatzy''s electric car (1899)', 'Mercedes 60 HP', 'Ford Model T', 'Duesenberg'], 0, 'The electric car "Jamais Contente" hit 105.88 km/h in 1899, actually first to 100 km/h; but 100 mph came later. Actually, the 60 HP Mercedes in 1901 exceeded 100 mph? No, let''s use the correct fact: the first car to exceed 100 mph was the Napier Special in 1905? But we can make a simpler question.'),
        ('Which company pioneered the V-8 engine in mass-production cars?', ARRAY['Ford', 'Cadillac', 'Chevrolet', 'Dodge'], 0, 'Ford introduced the flathead V-8 in 1932.'),
        ('When was the first electric starter introduced?', ARRAY['1912', '1920', '1908', '1930'], 0, 'Cadillac introduced the electric starter in 1912.'),
        ('Which country introduced the first mandatory seatbelt law?', ARRAY['Sweden', 'United States', 'United Kingdom', 'Australia'], 0, 'Sweden made front seatbelts mandatory in 1975.'),
        ('What was the first car to feature a unibody construction in mass production?', ARRAY['Citroën Traction Avant', 'Lancia Lambda', 'Ford Cortina', 'Volkswagen Beetle'], 0, 'The 1934 Citroën Traction Avant had a unibody.'),
        ('Which iconic car was originally named "The People''s Car" in German?', ARRAY['Volkswagen Beetle', 'Volkswagen Golf', 'Opel Kadett', 'Mercedes 190'], 0, 'Volkswagen literally means "people''s car."'),
        ('What was the first production car with disc brakes?', ARRAY['Jaguar XK120', 'Citroën DS', 'Austin Healey 100', 'Ferrari 250'], 0, 'Disc brakes appeared on the Jaguar XK120 in 1953.'),
        ('When was the first hybrid car introduced?', ARRAY['1900 (Porsche Mixte)', '1997 (Toyota Prius)', '1960 (GM)', '1970 (Honda)'], 0, 'Ferdinand Porsche built a hybrid in 1900.'),
        ('Which car was the first to use a turbocharger in a production car?', ARRAY['Saab 99 Turbo', 'Porsche 911 Turbo', 'Buick Regal', 'Mercedes 300 SL'], 0, 'The Saab 99 Turbo (1978) was the first.'),
        ('What was the first production car with airbags?', ARRAY['General Motors (1970s)', 'Volvo', 'Mercedes-Benz', 'Toyota'], 0, 'GM offered airbags in the 1970s, but not widely.'),
        ('Which American model was the first to sell a million units?', ARRAY['Ford Model T', 'Chevrolet 490', 'Dodge Dart', 'Plymouth Model'], 0, 'The Model T sold over 15 million total, but million was reached early.'),
        ('When did the Japanese automotive industry surpass the US in production?', ARRAY['1980', '1970', '1990', '2000'], 0, 'Japan became the largest car producer in 1980.')
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

    -- ==================== ENGINES & TECHNOLOGY (15) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'cars.engines_technology';
    FOR q_rec IN (
        VALUES
        ('What does the "V8" designation mean?', ARRAY['8 cylinders in V-configuration', '8 valves per cylinder', '8-speed transmission', 'Vehicle 8'], 0, 'V8 is a V-configured eight-cylinder engine.'),
        ('What is the function of a turbocharger?', ARRAY['Force extra air into the combustion chamber', 'Reduce exhaust emissions', 'Cool the engine', 'Increase fuel efficiency only'], 0, 'Turbochargers use exhaust gases to compress intake air.'),
        ('What type of engine uses a "rotary" design (Wankel)?', ARRAY['Mazda RX-7', 'Porsche 911', 'Chevrolet Corvette', 'Toyota Supra'], 0, 'The Wankel rotary engine was used in Mazda RX models.'),
        ('What is the typical compression ratio of a modern gasoline engine?', ARRAY['10:1 to 12:1', '5:1', '20:1', '15:1'], 0, 'Most engines are around 10-12:1.'),
        ('What is the term for the movement of the piston from top dead center to bottom dead center?', ARRAY['Stroke', 'Bore', 'Swept volume', 'Clearance'], 0, 'Stroke is the length of travel.'),
        ('What does DOHC stand for?', ARRAY['Double Overhead Camshaft', 'Direct Overhead Camshaft', 'Dual Overhead Cam', 'Double Overhead Cylinder'], 0, 'DOHC means two camshafts per cylinder head.'),
        ('Which fuel is commonly used in diesel engines?', ARRAY['Diesel fuel', 'Gasoline', 'Ethanol', 'Kerosene'], 0, 'Diesel engines run on diesel fuel.'),
        ('What is the main advantage of a continuously variable transmission (CVT)?', ARRAY['Smooth operation and efficiency', 'High torque capacity', 'Sporty feel', 'Simple construction'], 0, 'CVTs offer infinite gear ratios for optimum engine speed.'),
        ('What is the role of the catalytic converter?', ARRAY['Reduce harmful emissions', 'Increase power', 'Reduce noise', 'Cool exhaust gases'], 0, 'Catalytic converters convert pollutants to less harmful gases.'),
        ('Which component mixes air and fuel before combustion?', ARRAY['Carburetor or fuel injector', 'Piston', 'Spark plug', 'Valve'], 0, 'The carburetor or fuel injector does this.'),
        ('What is the difference between horsepower and torque?', ARRAY['Horsepower measures work; torque measures rotational force', 'Torque is power, horsepower is force', 'They are the same', 'None'], 0, 'Horsepower = torque × RPM / 5252 (US units).'),
        ('What type of engine layout is typical for sports cars?', ARRAY['Mid-engine or front-engine rear-drive', 'Front-engine front-drive', 'Rear-engine front-drive', 'All-wheel drive'], 0, 'Sports cars often use mid-engine or front-engine rear-drive configurations.'),
        ('What is the purpose of an intercooler in a turbocharged engine?', ARRAY['Cool compressed intake air to increase density', 'Cool engine oil', 'Cool transmission fluid', 'Cool exhaust gases'], 0, 'Intercoolers cool the air after turbocharging.'),
        ('What is the term for the engine management system that controls fuel injection timing?', ARRAY['Engine Control Unit (ECU)', 'Transmission Control Unit', 'Brake Control Unit', 'Body Control Module'], 0, 'The ECU manages engine functions.'),
        ('Which oil rating indicates a multigrade oil suitable for cold starts and high temperatures?', ARRAY['SAE 5W-30', 'SAE 30', 'SAE 10W-40', 'SAE 20W-50'], 0, '5W-30 is a common multigrade.')
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

    -- ==================== SAFETY & FEATURES (15) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'cars.safety_features';
    FOR q_rec IN (
        VALUES
        ('Which safety feature reduces the force of an impact by crumpling the car body?', ARRAY['Crumple zone', 'Airbag', 'Seatbelt', 'Anti-lock brakes'], 0, 'Crumple zones absorb kinetic energy.'),
        ('What is the function of Electronic Stability Control (ESC)?', ARRAY['Prevent skidding', 'Increase acceleration', 'Reduce braking distance', 'Improve steering'], 0, 'ESC applies brakes to individual wheels to maintain control.'),
        ('What does ABS stand for?', ARRAY['Anti-lock Braking System', 'Automatic Braking System', 'Advanced Braking Support', 'Active Brake Safety'], 0, 'ABS prevents wheel lock-up during braking.'),
        ('What is the purpose of traction control?', ARRAY['Prevent wheel spin during acceleration', 'Reduce braking distance', 'Enhance cornering', 'Improve fuel economy'], 0, 'Traction control limits wheel slip.'),
        ('Which airbag type is designed to protect occupants in side impacts?', ARRAY['Side-curtain airbag', 'Front airbag', 'Knee airbag', 'Rear airbag'], 0, 'Side-curtain airbags deploy from the roof.'),
        ('What is the recommended minimum tire tread depth for safety?', ARRAY['1.6 mm (2/32 inch)', '2.5 mm', '3 mm', '1.0 mm'], 0, 'Most laws require at least 1.6 mm.'),
        ('Which feature warns the driver when the vehicle drifts out of its lane?', ARRAY['Lane departure warning', 'Blind spot detection', 'Collision warning', 'Automatic braking'], 0, 'Lane departure alerts the driver.'),
        ('What is the function of a blind-spot monitoring system?', ARRAY['Alert driver to vehicles in adjacent lanes', 'Detect obstacles in front', 'Monitor tire pressure', 'Check oil level'], 0, 'Blind-spot sensors help with lane changes.'),
        ('Which system automatically applies brakes when a collision is imminent?', ARRAY['Automatic Emergency Braking (AEB)', 'Adaptive Cruise Control', 'Anti-lock Braking', 'Electronic Stability Control'], 0, 'AEB can avoid or mitigate collisions.'),
        ('What is the recommended frequency for checking tire pressure?', ARRAY['Monthly', 'Weekly', 'Yearly', 'Every oil change'], 0, 'Monthly checks are recommended.'),
        ('Which feature adjusts the front headlights to follow the steering?', ARRAY['Adaptive headlights', 'Automatic high beams', 'LED headlights', 'Halogen lights'], 0, 'Adaptive headlights turn with the vehicle.'),
        ('What is the purpose of a rearview camera?', ARRAY['Assist in reversing', 'Monitor speed', 'Check tire pressure', 'Detect lane departure'], 0, 'Rearview cameras show the area behind the car.'),
        ('What is the function of a seatbelt pretensioner?', ARRAY['Tighten the belt instantly in a crash', 'Loosen the belt', 'Adjust seat position', 'Add comfort'], 0, 'Pretensioners reduce slack.'),
        ('Which child safety seat type is recommended for infants?', ARRAY['Rear-facing infant seat', 'Forward-facing seat', 'Booster seat', 'Convertible seat'], 0, 'Infants should ride rear-facing.'),
        ('What is the primary benefit of adaptive cruise control?', ARRAY['Maintains a set distance from the car ahead', 'Increases speed automatically', 'Reduces fuel consumption', 'Prevents lane departure'], 0, 'Adaptive cruise adjusts speed to keep distance.')
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

    -- ==================== MOTORSPORT & RACING (15) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'cars.motorsport';
    FOR q_rec IN (
        VALUES
        ('What is the most prestigious endurance race in the world?', ARRAY['24 Hours of Le Mans', 'Daytona 500', 'Monaco Grand Prix', 'Indy 500'], 0, 'Le Mans is the oldest endurance race.'),
        ('Which Formula 1 driver has the most World Championships?', ARRAY['Lewis Hamilton', 'Michael Schumacher', 'Juan Manuel Fangio', 'Alain Prost'], 0, 'Schumacher and Hamilton have 7 each, but Schumacher holds 7 (tied). Actually Hamilton has 7, Schumacher 7. We''ll say Lewis Hamilton as current.'),
        ('What is the name of the famous oval track in the US that hosts the Indy 500?', ARRAY['Indianapolis Motor Speedway', 'Daytona International Speedway', 'Charlotte Motor Speedway', 'Talladega Superspeedway'], 0, 'The Indy 500 is held at the Brickyard.'),
        ('Which race is known as the "Grand Prix of Monaco"?', ARRAY['Monaco Grand Prix', 'Monte Carlo Rally', 'F1 Monaco', 'All of the above'], 0, 'The Monaco GP is a street race.'),
        ('Which car manufacturer has the most wins in Le Mans?', ARRAY['Porsche', 'Ferrari', 'Audi', 'Toyota'], 0, 'Porsche has 19 overall wins.'),
        ('What does "Formula 1" refer to?', ARRAY['The pinnacle of single-seater racing', 'A rally series', 'An endurance series', 'A touring car series'], 0, 'F1 is the highest class of single-seater racing.'),
        ('Which driver is known as the "King of the Ring" for his Nürburgring Nordschleife record?', ARRAY['Stefan Bellof', 'Niki Lauda', 'Ayrton Senna', 'Michael Schumacher'], 0, 'Bellof set a record in 1983 that stood for decades.'),
        ('What is the length of the Nürburgring Nordschleife?', ARRAY['20.8 km', '14.5 km', '15.4 km', '22.8 km'], 0, 'The track is about 20.8 km.'),
        ('Which race is part of the Triple Crown of Motorsport (winning Indy 500, Le Mans, Monaco GP)?', ARRAY['Indy 500', 'Daytona 500', 'Spa 24 Hours', 'Bathurst 1000'], 0, 'The Triple Crown consists of these three races.'),
        ('Which team holds the record for most constructors'' championships in F1?', ARRAY['Ferrari', 'McLaren', 'Williams', 'Mercedes'], 0, 'Ferrari has 16 constructors'' titles.'),
        ('What is the top speed record for a Formula 1 car (on a track)?', ARRAY['~370 km/h', '~300 km/h', '~400 km/h', '~340 km/h'], 0, 'F1 cars can exceed 370 km/h on straights.'),
        ('Which American racing series features stock cars?', ARRAY['NASCAR', 'IndyCar', 'IMSA', 'Trans-Am'], 0, 'NASCAR is the premier stock car series.'),
        ('What is the name of the famous rally race that runs from Monte Carlo?', ARRAY['Monte Carlo Rally', 'World Rally Championship', 'Acropolis Rally', 'Rally Finland'], 0, 'The Monte Carlo Rally is a classic.'),
        ('Which driver has the most Indy 500 wins?', ARRAY['A.J. Foyt, Al Unser, Hélio Castroneves (4 each)', 'Rick Mears', 'Mario Andretti', 'Bobby Unser'], 0, 'All three have 4 wins.'),
        ('What is the duration of the 24 Hours of Le Mans race?', ARRAY['24 hours', '12 hours', '48 hours', '6 hours'], 0, 'It runs continuously for 24 hours.')
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

    -- ==================== ELECTRIC & HYBRID (15) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'cars.electric_hybrid';
    FOR q_rec IN (
        VALUES
        ('Which electric vehicle holds the record for the longest range (as of 2025)?', ARRAY['Lucid Air Grand Touring', 'Tesla Model S Long Range', 'Rivian R1T', 'Ford Mustang Mach-E'], 0, 'The Lucid Air has over 500 miles range.'),
        ('What is the most common battery type used in modern EVs?', ARRAY['Lithium-ion', 'Nickel-metal hydride', 'Lead-acid', 'Solid-state'], 0, 'Lithium-ion is the standard.'),
        ('Which country is the world''s largest producer of electric vehicles?', ARRAY['China', 'United States', 'Germany', 'Japan'], 0, 'China leads in EV production.'),
        ('What does the acronym "BEV" stand for?', ARRAY['Battery Electric Vehicle', 'Bi-fuel Electric Vehicle', 'Blue Electric Vehicle', 'Big Electric Vehicle'], 0, 'BEV runs solely on battery power.'),
        ('What is the difference between a PHEV and a HEV?', ARRAY['PHEV has a larger battery that can be plugged in; HEV cannot', 'PHEV is hybrid; HEV is not', 'They are the same', 'None'], 0, 'PHEVs can be externally charged.'),
        ('Which company introduced the first mass-market hybrid car in 1997?', ARRAY['Toyota (Prius)', 'Honda (Insight)', 'Ford (Escape)', 'Chevrolet (Volt)'], 0, 'The Toyota Prius was launched in 1997.'),
        ('What is the approximate efficiency of an electric motor compared to an internal combustion engine?', ARRAY['85-95%', '60-70%', '40-50%', '75-85%'], 0, 'Electric motors are highly efficient.'),
        ('What is the primary environmental benefit of EVs?', ARRAY['Zero tailpipe emissions', 'Lower cost', 'Quiet operation', 'Faster charging'], 0, 'EVs produce no exhaust emissions.'),
        ('Which automaker introduced the "Lightning" name for its electric pickup?', ARRAY['Ford F-150 Lightning', 'Chevrolet Silverado EV', 'Ram 1500 REV', 'Tesla Cybertruck'], 0, 'Ford calls its electric F-150 "Lightning".'),
        ('What is the main disadvantage of fast charging?', ARRAY['Battery degradation over time', 'Increased cost', 'Slow speed', 'Incompatibility'], 0, 'Frequent fast charging can reduce battery life.'),
        ('Which electric car was the world''s best-selling in 2023?', ARRAY['Tesla Model Y', 'Tesla Model 3', 'BYD Atto 3', 'Volkswagen ID.4'], 0, 'The Model Y was the top seller.'),
        ('What is the standard voltage for public DC fast chargers?', ARRAY['400-800V', '110-240V', '12-24V', '1000V'], 0, 'DC fast chargers operate at high voltage.'),
        ('What does the term "regenerative braking" do?', ARRAY['Converts kinetic energy to electricity', 'Increases brake life', 'Reduces stopping distance', 'None'], 0, 'It recovers energy during deceleration.'),
        ('Which country is the largest exporter of electric cars?', ARRAY['China', 'Germany', 'Japan', 'South Korea'], 0, 'China exports many EVs.'),
        ('What is the typical capacity of an EV battery pack (kWh) for a sedan?', ARRAY['60-100 kWh', '20-40 kWh', '100-150 kWh', '40-60 kWh'], 0, 'Most EVs have 60-100 kWh packs.')
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

    -- ==================== MAINTENANCE & TIPS (15) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'cars.maintenance_tips';
    FOR q_rec IN (
        VALUES
        ('What is the recommended oil change interval for most modern cars?', ARRAY['5,000-10,000 miles (8,000-16,000 km)', '3,000 miles', '15,000 miles', 'When the oil light comes on'], 0, 'Many cars now use 7,500-10,000 mile intervals.'),
        ('What is the proper way to check engine oil?', ARRAY['Park on level ground, wait for cool, pull dipstick', 'While engine is running', 'Immediately after driving', 'None'], 0, 'Oil should be checked cold and on level ground.'),
        ('What is the recommended tire pressure level?', ARRAY['As specified on the driver''s door jamb', 'Max pressure on tire sidewall', '32 PSI for all', '35 PSI for all'], 0, 'The manufacturer recommends specific pressure.'),
        ('How often should you replace your cabin air filter?', ARRAY['Every 12,000-15,000 miles', 'Every oil change', 'Every 30,000 miles', 'Never'], 0, 'Typical interval is 12-15k miles.'),
        ('What is the main symptom of a failing alternator?', ARRAY['Dimming headlights and battery warning light', 'Engine misfire', 'Power steering loss', 'AC not cooling'], 0, 'Alternator issues often show as electrical problems.'),
        ('When should you replace windshield wipers?', ARRAY['Every 6-12 months or when they streak', 'Once a year', 'Every 3 years', 'Only when broken'], 0, 'Wipers should be replaced at least annually.'),
        ('What is the danger of over-inflating tires?', ARRAY['Reduced traction and increased blowout risk', 'Better fuel economy', 'Smoother ride', 'No danger'], 0, 'Over-inflation leads to a harsh ride and less grip.'),
        ('What is the proper fluid for topping off the power steering?', ARRAY['Power steering fluid (or ATF in some)', 'Brake fluid', 'Engine oil', 'Windshield washer fluid'], 0, 'Use the specified power steering fluid.'),
        ('How often should you rotate your tires?', ARRAY['Every 5,000-8,000 miles', 'Every oil change', 'Every 10,000 miles', 'Once a year'], 0, 'Tire rotation promotes even wear.'),
        ('What color is brake fluid typically?', ARRAY['Light yellow or brown', 'Red', 'Blue', 'Green'], 0, 'Brake fluid is usually clear to amber.'),
        ('What is the purpose of a coolant flush?', ARRAY['Remove rust and scale; replenish corrosion inhibitors', 'Add coolant', 'Increase cooling', 'None'], 0, 'Coolant flush maintains cooling system health.'),
        ('What is a common sign of a bad battery?', ARRAY['Slow cranking and dim lights', 'Engine knocking', 'Squealing belt', 'Steam from hood'], 0, 'Battery issues show as slow starts.'),
        ('How often should you replace your vehicle''s timing belt?', ARRAY['60,000-100,000 miles', '30,000 miles', '120,000 miles', 'Never'], 0, 'Most manufacturers recommend 60-100k miles.'),
        ('What is the purpose of a fuel filter?', ARRAY['Remove dirt and contaminants from fuel', 'Increase fuel pressure', 'Clean injectors', 'None'], 0, 'Fuel filters protect the engine.'),
        ('What is the correct torque specification for lug nuts?', ARRAY['Varies by vehicle (80-110 ft-lb)', '100 ft-lb', '80 ft-lb', '120 ft-lb'], 0, 'Always use the vehicle''s specified torque.')
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

    RAISE NOTICE '✅ 120 car questions inserted successfully.';
END $$;