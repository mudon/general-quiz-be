-- ============================================================================
-- INSERT 250 AGRICULTURE + ENERGY TRIVIA QUESTIONS
-- ============================================================================
-- Covers: Agriculture (Crops, Livestock, Irrigation, Farming, Fertilizers, 
-- Organic Farming, Food Security) and Energy (Oil, Gas, Coal, Nuclear, Solar, 
-- Wind, Hydroelectric, Geothermal, Hydrogen).
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
        ('agriculture', 'Agriculture', '🌾', 3, 0),
        ('agriculture.crops', 'Crops', NULL, 3, 1),
        ('agriculture.livestock', 'Livestock', NULL, 3, 2),
        ('agriculture.irrigation', 'Irrigation', NULL, 3, 3),
        ('agriculture.farming', 'Farming', NULL, 3, 4),
        ('agriculture.fertilizers', 'Fertilizers', NULL, 3, 5),
        ('agriculture.organic_farming', 'Organic Farming', NULL, 0, 6),
        ('agriculture.food_security', 'Food Security', NULL, 3, 7),

        ('energy', 'Energy', '⚡', 3, 8),
        ('energy.oil', 'Oil', NULL, 3, 9),
        ('energy.gas', 'Gas', NULL, 3, 10),
        ('energy.coal', 'Coal', NULL, 3, 11),
        ('energy.nuclear', 'Nuclear', NULL, 3, 12),
        ('energy.solar', 'Solar', NULL, 0, 13),
        ('energy.wind', 'Wind', NULL, 3, 14),
        ('energy.hydroelectric', 'Hydroelectric', NULL, 3, 15),
        ('energy.geothermal', 'Geothermal', NULL, 3, 16),
        ('energy.hydrogen', 'Hydrogen', NULL, 3, 17)
    ON CONFLICT (path) DO NOTHING;

    -- ------------------------------------------------------------------------
    -- 2. Insert questions per category
    -- ------------------------------------------------------------------------

    -- ==================== CROPS (20) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'agriculture.crops';
    FOR q_rec IN (
        VALUES
        ('What is the most widely grown cereal crop in the world?', ARRAY['Wheat', 'Rice', 'Corn (Maize)', 'Barley'], 0, 'Wheat is grown on the largest area globally.'),
        ('Which country is the largest producer of rice?', ARRAY['China', 'India', 'Indonesia', 'Bangladesh'], 0, 'China is the world''s top rice producer.'),
        ('What is the primary crop used to make tequila?', ARRAY['Blue agave', 'Sugarcane', 'Corn', 'Wheat'], 0, 'Tequila is distilled from blue agave.'),
        ('Which crop is known as the "king of cereals"?', ARRAY['Wheat', 'Rice', 'Maize', 'Barley'], 0, 'Wheat is often called the king of cereals due to its importance.'),
        ('What is the most traded agricultural commodity in the world?', ARRAY['Soybeans', 'Wheat', 'Corn', 'Coffee'], 0, 'Soybeans are the most traded by value.'),
        ('Which country is the largest producer of sugarcane?', ARRAY['Brazil', 'India', 'China', 'Thailand'], 0, 'Brazil is the largest sugarcane producer.'),
        ('What is the scientific name for common wheat?', ARRAY['Triticum aestivum', 'Zea mays', 'Oryza sativa', 'Hordeum vulgare'], 0, 'Triticum aestivum is bread wheat.'),
        ('Which crop is the main source of edible oil in the world?', ARRAY['Soybean', 'Palm oil', 'Sunflower', 'Rapeseed'], 0, 'Palm oil is the most produced vegetable oil.'),
        ('What is the most consumed fruit globally?', ARRAY['Tomato (botanically a fruit)', 'Banana', 'Apple', 'Orange'], 0, 'Tomatoes are the most produced fruit (but often used as vegetable).'),
        ('Which country is the largest producer of coffee?', ARRAY['Brazil', 'Vietnam', 'Colombia', 'Ethiopia'], 0, 'Brazil is the world''s largest coffee producer.'),
        ('What is the main crop used for biofuel production in the US?', ARRAY['Corn', 'Soybean', 'Sugarcane', 'Wheat'], 0, 'Corn is the primary feedstock for ethanol.'),
        ('Which crop is the staple food of most of Africa?', ARRAY['Cassava', 'Maize', 'Rice', 'Millet'], 0, 'Maize is a staple in many African countries.'),
        ('What is the largest producer of cocoa?', ARRAY['Côte d''Ivoire', 'Ghana', 'Indonesia', 'Nigeria'], 0, 'Côte d''Ivoire produces over 40% of the world''s cocoa.'),
        ('Which crop is used to make linen?', ARRAY['Flax', 'Cotton', 'Hemp', 'Jute'], 0, 'Linen is made from the flax plant.'),
        ('What is the world''s most expensive spice by weight?', ARRAY['Saffron', 'Vanilla', 'Cardamom', 'Cinnamon'], 0, 'Saffron is the most expensive spice.'),
        ('Which country is the largest producer of tea?', ARRAY['China', 'India', 'Kenya', 'Sri Lanka'], 0, 'China is the largest tea producer.'),
        ('What is the main ingredient in tofu?', ARRAY['Soybeans', 'Wheat', 'Rice', 'Corn'], 0, 'Tofu is made from soy milk.'),
        ('Which crop is known as the "miracle crop" for its drought tolerance?', ARRAY['Pearl millet', 'Sorghum', 'Quinoa', 'Amaranth'], 0, 'Pearl millet is highly drought-tolerant.'),
        ('What is the most cultivated root vegetable?', ARRAY['Potato', 'Sweet potato', 'Cassava', 'Carrot'], 0, 'Potatoes are the most cultivated root crop.'),
        ('Which country is the largest producer of olives?', ARRAY['Spain', 'Italy', 'Greece', 'Turkey'], 0, 'Spain is the top olive producer.')
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

    -- ==================== LIVESTOCK (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'agriculture.livestock';
    FOR q_rec IN (
        VALUES
        ('Which animal is the most numerous livestock species in the world?', ARRAY['Chickens', 'Cattle', 'Sheep', 'Goats'], 0, 'There are over 25 billion chickens globally.'),
        ('Which country has the largest cattle herd?', ARRAY['India', 'Brazil', 'China', 'United States'], 0, 'India has the largest cattle population.'),
        ('What is the main product of the dairy industry?', ARRAY['Milk', 'Meat', 'Wool', 'Leather'], 0, 'Milk is the primary dairy product.'),
        ('Which animal is known as the "ship of the desert"?', ARRAY['Camel', 'Donkey', 'Horse', 'Llama'], 0, 'Camels are used for transport in deserts.'),
        ('What is the most consumed meat in the world?', ARRAY['Pork', 'Poultry', 'Beef', 'Lamb'], 0, 'Pork is the most widely eaten meat.'),
        ('Which country is the largest producer of chicken meat?', ARRAY['United States', 'China', 'Brazil', 'Russia'], 0, 'The US is the top poultry producer.'),
        ('What is the term for a castrated male cattle?', ARRAY['Steer', 'Bull', 'Ox', 'Heifer'], 0, 'A steer is a castrated male bovine.'),
        ('What is the primary source of wool globally?', ARRAY['Sheep', 'Alpaca', 'Goat', 'Rabbit'], 0, 'Sheep produce the vast majority of wool.'),
        ('Which country is the largest producer of pork?', ARRAY['China', 'United States', 'Germany', 'Spain'], 0, 'China is the top pork producer.'),
        ('What is the name of the practice of raising fish commercially?', ARRAY['Aquaculture', 'Pisciculture', 'Mariculture', 'All of the above'], 0, 'Aquaculture is the general term for fish farming.'),
        ('Which livestock species has the longest gestation period?', ARRAY['Cattle (9 months)', 'Sheep (5 months)', 'Goats (5 months)', 'Pigs (3.5 months)'], 0, 'Cattle have a gestation of about 280 days.'),
        ('What is the main purpose of raising bees in agriculture?', ARRAY['Pollination and honey production', 'Meat production', 'Wool production', 'Milk production'], 0, 'Bees are crucial for pollination and produce honey.'),
        ('Which country has the largest number of pigs?', ARRAY['China', 'United States', 'Vietnam', 'Germany'], 0, 'China has over 400 million pigs.'),
        ('What is the average lifespan of a dairy cow?', ARRAY['~5-6 years (productive)', '~10-12 years', '~2-3 years', '~15-20 years'], 0, 'Dairy cows are typically culled after 5-6 lactations.'),
        ('What is the term for a group of geese?', ARRAY['Gaggle', 'Flock', 'Herd', 'Pod'], 0, 'A gaggle is the correct term for geese on the ground.'),
        ('Which country is the largest producer of goat meat?', ARRAY['China', 'India', 'Pakistan', 'Nigeria'], 0, 'China is the largest goat meat producer.'),
        ('What is the most common breed of dairy cattle in the US?', ARRAY['Holstein', 'Jersey', 'Guernsey', 'Brown Swiss'], 0, 'Holsteins are the most common dairy breed.'),
        ('What is the process of giving birth in sheep called?', ARRAY['Lambing', 'Calving', 'Farrowing', 'Kidding'], 0, 'Lambing is the term for sheep giving birth.')
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

    -- ==================== IRRIGATION (15) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'agriculture.irrigation';
    FOR q_rec IN (
        VALUES
        ('What is the most common method of irrigation worldwide?', ARRAY['Flood irrigation', 'Drip irrigation', 'Sprinkler irrigation', 'Center pivot'], 0, 'Flood (surface) irrigation is still the most widely used.'),
        ('Which irrigation method is most water-efficient?', ARRAY['Drip irrigation', 'Sprinkler irrigation', 'Flood irrigation', 'Basin irrigation'], 0, 'Drip irrigation delivers water directly to roots, reducing waste.'),
        ('What is a center-pivot irrigation system?', ARRAY['A rotating sprinkler arm on wheels', 'A network of underground pipes', 'A gravity-fed canal system', 'A manual watering can'], 0, 'Center pivots are common in large-scale farming.'),
        ('Which country has the largest area under irrigation?', ARRAY['China', 'India', 'United States', 'Pakistan'], 0, 'China has the largest irrigated area.'),
        ('What is the main source of irrigation water in arid regions?', ARRAY['Groundwater', 'Rainfall', 'Glacial melt', 'Desalination'], 0, 'Groundwater is heavily used in dry areas.'),
        ('What is the practice of supplying water to crops through pipes and drip nozzles called?', ARRAY['Drip irrigation', 'Furrow irrigation', 'Border strip irrigation', 'Subirrigation'], 0, 'Drip irrigation is also known as trickle irrigation.'),
        ('What is the primary advantage of sprinkler irrigation?', ARRAY['Even distribution over uneven terrain', 'Low cost', 'High water efficiency', 'Simple installation'], 0, 'Sprinklers work well on hilly land.'),
        ('What is the term for the amount of water needed to saturate the soil?', ARRAY['Field capacity', 'Wilting point', 'Permanent wilting point', 'Saturation'], 0, 'Field capacity is the water held after excess drainage.'),
        ('Which crop is most commonly grown using flood irrigation?', ARRAY['Rice', 'Wheat', 'Corn', 'Soybean'], 0, 'Rice paddies are typically flooded.'),
        ('What is the main problem associated with excessive irrigation?', ARRAY['Salinization', 'Erosion', 'Pest infestation', 'Nutrient loss'], 0, 'Salinisation occurs when water evaporates leaving salts behind.'),
        ('What is a qanat?', ARRAY['An ancient underground water channel', 'A modern pump', 'A type of sprinkler', 'A storage tank'], 0, 'Qanats are traditional irrigation systems in the Middle East.'),
        ('What is the efficiency of traditional surface irrigation typically?', ARRAY['~40-60%', '~70-80%', '~90-95%', '~30-40%'], 0, 'Surface irrigation efficiency is relatively low.'),
        ('Which country uses the most water for irrigation?', ARRAY['India', 'China', 'USA', 'Pakistan'], 0, 'India is the largest user of water for irrigation.'),
        ('What is the practice of applying water directly to the root zone of plants?', ARRAY['Subsurface drip irrigation', 'Furrow irrigation', 'Basin irrigation', 'Sprinkler irrigation'], 0, 'Subsurface drip places water below the surface.'),
        ('What is the primary driver of the adoption of drip irrigation?', ARRAY['Water scarcity', 'Low cost', 'Government subsidies', 'Easy installation'], 0, 'Water scarcity drives the adoption of efficient methods.')
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

    -- ==================== FARMING (20) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'agriculture.farming';
    FOR q_rec IN (
        VALUES
        ('What is the practice of growing a single crop over a large area called?', ARRAY['Monoculture', 'Polyculture', 'Crop rotation', 'Intercropping'], 0, 'Monoculture is common in industrial agriculture.'),
        ('What is the term for farming without synthetic inputs?', ARRAY['Organic farming', 'Conventional farming', 'Intensive farming', 'Subsistence farming'], 0, 'Organic farming relies on natural methods.'),
        ('What is the main purpose of crop rotation?', ARRAY['Maintain soil fertility and break pest cycles', 'Increase yield', 'Reduce labour', 'Increase irrigation efficiency'], 0, 'Rotation helps manage nutrients and pests.'),
        ('Which type of agriculture is practiced for family consumption?', ARRAY['Subsistence farming', 'Commercial farming', 'Plantation farming', 'Shifting cultivation'], 0, 'Subsistence farming produces food for the farmer''s family.'),
        ('What is the process of preparing land for planting called?', ARRAY['Tillage', 'Harvesting', 'Sowing', 'Irrigation'], 0, 'Tillage includes ploughing and harrowing.'),
        ('What is the term for the removal of trees to create farmland?', ARRAY['Deforestation', 'Reforestation', 'Afforestation', 'Slash-and-burn'], 0, 'Deforestation is the clearing of forests.'),
        ('Which farming practice involves keeping animals and growing crops together?', ARRAY['Mixed farming', 'Arable farming', 'Pastoral farming', 'Agroforestry'], 0, 'Mixed farming integrates crops and livestock.'),
        ('What is the name of the farming method that uses no ploughing?', ARRAY['No-till farming', 'Conservation tillage', 'Strip-till', 'Minimum tillage'], 0, 'No-till reduces soil erosion.'),
        ('Which country has the highest number of organic farms?', ARRAY['India', 'Australia', 'China', 'United States'], 0, 'Australia has the largest area of organic farmland.'),
        ('What is the primary goal of precision agriculture?', ARRAY['Optimise inputs based on variability', 'Maximise yield at all costs', 'Reduce labour', 'Increase pesticide use'], 0, 'Precision uses technology to apply resources precisely.'),
        ('What is the practice of growing two or more crops simultaneously on the same land?', ARRAY['Intercropping', 'Monocropping', 'Crop rotation', 'Alley cropping'], 0, 'Intercropping improves diversity.'),
        ('Which type of farming is highly capital-intensive and uses advanced technology?', ARRAY['Intensive farming', 'Extensive farming', 'Subsistence farming', 'Shifting cultivation'], 0, 'Intensive farming uses high inputs per area.'),
        ('What is the name of the system where farmers rent land from landlords?', ARRAY['Tenant farming', 'Sharecropping', 'Plantation', 'Agribusiness'], 0, 'Tenant farmers pay rent to use land.'),
        ('What is the leading cause of soil degradation in agriculture?', ARRAY['Erosion', 'Salinisation', 'Nutrient depletion', 'Compaction'], 0, 'Erosion is the primary form of degradation.'),
        ('Which crop is often used as a "cover crop" to improve soil health?', ARRAY['Rye', 'Corn', 'Wheat', 'Soybean'], 0, 'Rye and other cover crops prevent erosion and add organic matter.'),
        ('What is the term for agriculture that is environmentally sustainable?', ARRAY['Sustainable agriculture', 'Industrial agriculture', 'Conventional agriculture', 'Subsistence agriculture'], 0, 'Sustainable agriculture balances economic, social, and environmental factors.'),
        ('What is the typical size of a smallholder farm?', ARRAY['< 2 hectares', '10-50 hectares', '> 100 hectares', '5-10 hectares'], 0, 'Smallholders generally operate on less than 2 ha.'),
        ('What is the process of removing weeds called?', ARRAY['Weeding', 'Harvesting', 'Tillage', 'Fertilisation'], 0, 'Weeding controls unwanted plants.'),
        ('Which region has the highest percentage of agricultural land?', ARRAY['South Asia', 'Europe', 'North America', 'Africa'], 0, 'South Asia has a high proportion of land under agriculture.'),
        ('What is the main output of aquaculture?', ARRAY['Fish and seafood', 'Crops', 'Livestock', 'Dairy'], 0, 'Aquaculture produces aquatic animals and plants.')
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

    -- ==================== FERTILIZERS (15) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'agriculture.fertilizers';
    FOR q_rec IN (
        VALUES
        ('What are the three primary macronutrients in fertilisers?', ARRAY['Nitrogen, Phosphorus, Potassium', 'Nitrogen, Carbon, Hydrogen', 'Phosphorus, Potassium, Calcium', 'Nitrogen, Phosphorus, Sulfur'], 0, 'These are the N-P-K elements.'),
        ('What is the main role of nitrogen in plants?', ARRAY['Promote leaf growth', 'Promote root growth', 'Promote flowering', 'Promote fruit development'], 0, 'Nitrogen is essential for vegetative growth and chlorophyll.'),
        ('Which fertiliser is most commonly used to supply nitrogen?', ARRAY['Urea', 'Superphosphate', 'Potassium chloride', 'Ammonium nitrate'], 0, 'Urea is a high-nitrogen fertiliser.'),
        ('What is the process of converting nitrogen gas into a usable form called?', ARRAY['Nitrogen fixation', 'Nitrification', 'Denitrification', 'Ammonification'], 0, 'Biological fixation occurs in legume nodules.'),
        ('Which element is critical for root development and flowering?', ARRAY['Phosphorus', 'Nitrogen', 'Potassium', 'Calcium'], 0, 'Phosphorus promotes strong root growth.'),
        ('What is the term for a fertiliser that contains all three primary nutrients?', ARRAY['Complete fertiliser', 'Compound fertiliser', 'Mixed fertiliser', 'Slow-release'], 0, 'Complete fertilisers have N-P-K.'),
        ('What is a common source of potassium fertiliser?', ARRAY['Potash', 'Rock phosphate', 'Lime', 'Gypsum'], 0, 'Potash is mined for potassium.'),
        ('What is the issue with over-application of nitrogen fertilisers?', ARRAY['Water pollution and greenhouse gas emissions', 'Soil acidification', 'Crop wilting', 'Pest outbreaks'], 0, 'Excess nitrogen can leach to water and emit N₂O.'),
        ('What is the Haber-Bosch process used for?', ARRAY['Synthetic nitrogen production', 'Phosphate extraction', 'Potash mining', 'Sulphur recovery'], 0, 'It fixes atmospheric nitrogen into ammonia.'),
        ('Which type of fertiliser is derived from plant and animal waste?', ARRAY['Organic fertiliser', 'Chemical fertiliser', 'Mineral fertiliser', 'Synthetic fertiliser'], 0, 'Organic fertilisers are from natural sources.'),
        ('What is the main source of phosphorus fertiliser?', ARRAY['Rock phosphate', 'Potash', 'Urea', 'Ammonia'], 0, 'Phosphate rock is the primary source.'),
        ('What is the effect of phosphorus on water bodies (eutrophication)?', ARRAY['Algal blooms', 'Acidification', 'Salinisation', 'Heavy metal contamination'], 0, 'Excess phosphorus causes algal blooms.'),
        ('What is the recommended application method for fertilisers to reduce losses?', ARRAY['Split application', 'Broadcasting', 'Band placement', 'Foliar spray'], 0, 'Split application matches plant uptake and reduces leaching.'),
        ('What is the role of potassium in plants?', ARRAY['Regulating water balance and enzyme activation', 'Protein synthesis', 'Cell wall formation', 'Photosynthesis'], 0, 'Potassium helps with stomatal control and stress tolerance.'),
        ('What is the term for the nutrient content label on a fertiliser bag?', ARRAY['N-P-K ratio', 'Analysis', 'Grade', 'All of the above'], 0, 'The N-P-K ratio describes the percent of each nutrient.')
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

    -- ==================== ORGANIC FARMING (16) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'agriculture.organic_farming';
    FOR q_rec IN (
        VALUES
        ('What is the main principle of organic farming?', ARRAY['Avoid synthetic chemicals and promote ecological balance', 'Maximise yield with technology', 'Use only natural pesticides', 'No GMOs'], 0, 'Organic farming emphasises sustainability and natural inputs.'),
        ('Which certification is most recognised for organic produce?', ARRAY['USDA Organic', 'EU Organic', 'JAS', 'All of the above'], 0, 'Many countries have their own organic certification.'),
        ('What is the role of green manure in organic farming?', ARRAY['Add organic matter and nutrients to soil', 'Suppress weeds', 'Control pests', 'All of the above'], 0, 'Green manure crops are ploughed in to enrich soil.'),
        ('Which pest control method is preferred in organic farming?', ARRAY['Biological control (natural predators)', 'Chemical insecticides', 'Synthetic herbicides', 'Genetic modification'], 0, 'Biological control uses beneficial insects.'),
        ('What is the primary source of nitrogen in organic systems?', ARRAY['Legume cover crops', 'Urea', 'Anhydrous ammonia', 'Compost'], 0, 'Legumes fix atmospheric nitrogen.'),
        ('What is the global market size of organic food (approx. 2023)?', ARRAY['> $200 billion', '~$100 billion', '~$50 billion', '~$300 billion'], 0, 'The organic market is over $200 billion.'),
        ('Which country has the highest area of certified organic farmland?', ARRAY['Australia', 'Argentina', 'China', 'United States'], 0, 'Australia has about half of the world''s organic land.'),
        ('What is the practice of interplanting different species to enhance biodiversity?', ARRAY['Polyculture', 'Monoculture', 'Crop rotation', 'Contour farming'], 0, 'Polyculture is a key organic practice.'),
        ('Is the use of genetically modified organisms (GMOs) allowed in certified organic production?', ARRAY['No', 'Yes, with restrictions', 'Sometimes', 'It depends on the country'], 0, 'GMOs are prohibited in organic agriculture.'),
        ('What is the role of compost in organic farming?', ARRAY['Supplies nutrients and improves soil structure', 'Kills pests', 'Weed control', 'Increase pH'], 0, 'Compost is a slow-release organic fertiliser.'),
        ('What is the maximum allowable percentage of synthetic substances in organic products?', ARRAY['5% (by weight)', '0%', '10%', '15%'], 0, 'Organic products must be at least 95% organic.'),
        ('What is the term for raising animals without using antibiotics or growth hormones?', ARRAY['Organic livestock farming', 'Conventional livestock farming', 'Factory farming', 'Intensive farming'], 0, 'Organic animal husbandry prohibits routine antibiotics.'),
        ('Which country is the largest market for organic food?', ARRAY['United States', 'Germany', 'France', 'China'], 0, 'The US is the largest organic market.'),
        ('What is a common method for weed control in organic farming?', ARRAY['Mechanical cultivation and mulching', 'Chemical herbicides', 'Flame weeding', 'Solarization'], 0, 'Mulching suppresses weeds without chemicals.'),
        ('What is the principle of soil conservation in organic farming?', ARRAY['Maintain soil cover and organic matter', 'Deep ploughing', 'Heavy irrigation', 'Frequent tillage'], 0, 'Conservation practices protect soil health.'),
        ('What is the concept of "certified organic" in the EU?', ARRAY['Products comply with EU regulations on organic production', 'Products are locally produced', 'Products are fair trade', 'Products are non-GMO'], 0, 'EU organic certification ensures compliance with organic standards.')
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

    -- ==================== FOOD SECURITY (16) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'agriculture.food_security';
    FOR q_rec IN (
        VALUES
        ('What is the definition of food security?', ARRAY['Access to sufficient, safe, nutritious food at all times', 'Having enough food for today only', 'Food availability only', 'Food safety only'], 0, 'Food security has four pillars: availability, access, utilisation, and stability.'),
        ('What is the term for the state of not having enough food?', ARRAY['Food insecurity', 'Famine', 'Malnutrition', 'Hunger'], 0, 'Food insecurity is a broader concept.'),
        ('Which region has the highest prevalence of food insecurity?', ARRAY['Sub-Saharan Africa', 'South Asia', 'Latin America', 'South-East Asia'], 0, 'Sub-Saharan Africa has the highest rates.'),
        ('What is the main cause of food insecurity globally?', ARRAY['Poverty', 'Climate change', 'Conflict', 'All of the above'], 0, 'Multiple factors contribute.'),
        ('What is the goal of the UN Sustainable Development Goal 2?', ARRAY['Zero hunger', 'Clean water and sanitation', 'Good health and well-being', 'Quality education'], 0, 'SDG 2 aims to end hunger and achieve food security.'),
        ('What is the minimum amount of kilocalories per person per day considered adequate?', ARRAY['~2,100 kcal', '~1,500 kcal', '~2,500 kcal', '~3,000 kcal'], 0, 'The average requirement is around 2,100 kcal.'),
        ('Which organisation issues the "Global Report on Food Crises"?', ARRAY['FAO and WFP', 'WHO', 'UNDP', 'World Bank'], 0, 'The Food and Agriculture Organization and World Food Programme publish it.'),
        ('What is the term for the ability to produce enough food for a growing population?', ARRAY['Food self-sufficiency', 'Food sovereignty', 'Food aid', 'Food import'], 0, 'Self-sufficiency means domestic production meets demand.'),
        ('Which continent imports the most food?', ARRAY['Africa', 'Asia', 'Europe', 'North America'], 0, 'Africa imports over 85% of its food, but Asia imports large volumes too; Africa is more food-insecure.'),
        ('What is the impact of climate change on food security?', ARRAY['Reduced crop yields and increased variability', 'Increased yields', 'No effect', 'More stable production'], 0, 'Climate change threatens agricultural productivity.'),
        ('What is the concept of "food loss" vs "food waste"?', ARRAY['Loss occurs in supply chain; waste occurs at retail/consumption', 'Loss is waste in all stages', 'Loss is waste at consumption', 'They are the same'], 0, 'Food loss is early in the supply chain; waste is at later stages.'),
        ('What is the main strategy to reduce food insecurity in developing countries?', ARRAY['Improve agricultural productivity and access to markets', 'Increase food imports', 'Reduce population', 'Decrease consumption'], 0, 'Productivity and market access are key.'),
        ('What is the approximate number of undernourished people in the world (2024)?', ARRAY['~735 million', '~500 million', '~1 billion', '~300 million'], 0, 'FAO estimates around 735 million.'),
        ('Which nutrient deficiency is the most common among food-insecure populations?', ARRAY['Iron', 'Vitamin A', 'Iodine', 'Zinc'], 0, 'Iron deficiency anaemia is widespread.'),
        ('What is the role of food reserves in food security?', ARRAY['Buffer against supply shocks', 'To increase exports', 'To reduce prices', 'To create waste'], 0, 'Strategic reserves stabilise markets during shortages.'),
        ('What is the "right to food" concept?', ARRAY['Everyone should have access to adequate food', 'Only citizens of a country have the right', 'Food should be free', 'Only the poor have the right'], 0, 'It is a human right recognised by the UN.')
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

    -- ==================== OIL (16) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'energy.oil';
    FOR q_rec IN (
        VALUES
        ('Which country is the largest producer of crude oil?', ARRAY['United States', 'Saudi Arabia', 'Russia', 'Canada'], 0, 'The US has been the top producer since 2018.'),
        ('What is the main use of crude oil globally?', ARRAY['Transportation fuels', 'Electricity generation', 'Plastics', 'Heating'], 0, 'The majority is refined into gasoline, diesel, and jet fuel.'),
        ('Which organisation regulates oil production among major exporters?', ARRAY['OPEC', 'IEA', 'EIA', 'UN'], 0, 'OPEC (Organization of the Petroleum Exporting Countries) coordinates production.'),
        ('What is the unit of measurement for crude oil?', ARRAY['Barrel (bbl)', 'Ton', 'Cubic metre', 'Gallon'], 0, 'One barrel is 42 US gallons.'),
        ('Which country has the largest proven oil reserves?', ARRAY['Venezuela', 'Saudi Arabia', 'Canada', 'Iran'], 0, 'Venezuela has the largest reserves (over 300 billion barrels).'),
        ('What is the process of separating crude oil into its components called?', ARRAY['Fractional distillation', 'Cracking', 'Catalytic conversion', 'Hydrotreating'], 0, 'Distillation separates by boiling point.'),
        ('What is the price benchmark for crude oil in Europe?', ARRAY['Brent Crude', 'WTI', 'Dubai Crude', 'OPEC Basket'], 0, 'Brent is the main European benchmark.'),
        ('Which country is the largest consumer of oil?', ARRAY['United States', 'China', 'India', 'Japan'], 0, 'The US consumes about 20% of the world''s oil.'),
        ('What is the main environmental concern associated with oil extraction?', ARRAY['Oil spills and greenhouse gas emissions', 'Deforestation', 'Water scarcity', 'Soil erosion'], 0, 'Spills and emissions are primary concerns.'),
        ('What is the term for oil that is easily extracted without complex methods?', ARRAY['Conventional oil', 'Unconventional oil', 'Tight oil', 'Heavy oil'], 0, 'Conventional oil flows freely to wells.'),
        ('Which country has the largest oil refinery capacity?', ARRAY['United States', 'China', 'Russia', 'India'], 0, 'The US has the highest refining capacity.'),
        ('What is the main gas associated with crude oil production?', ARRAY['Natural gas', 'Methane', 'Propane', 'Butane'], 0, 'Associated gas is often burned or captured.'),
        ('What is the primary use of petroleum coke?', ARRAY['Fuel in industrial processes', 'Plastic production', 'Asphalt', 'Fertiliser'], 0, 'Pet coke is used as a fuel in cement and power plants.'),
        ('Which strait is a key chokepoint for oil transport?', ARRAY['Strait of Hormuz', 'Bosphorus', 'Suez Canal', 'Malacca Strait'], 0, 'Hormuz is critical for Middle East oil exports.'),
        ('What is the term for the first stage of oil refining?', ARRAY['Distillation', 'Cracking', 'Reforming', 'Alkylation'], 0, 'Distillation separates crude into fractions.'),
        ('What is the approximate share of oil in the global energy mix?', ARRAY['~32%', '~25%', '~40%', '~18%'], 0, 'Oil accounts for about 32% of global energy consumption.')
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

    -- ==================== GAS (16) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'energy.gas';
    FOR q_rec IN (
        VALUES
        ('What is the primary component of natural gas?', ARRAY['Methane', 'Ethane', 'Propane', 'Butane'], 0, 'Methane (CH₄) is 70-90% of natural gas.'),
        ('Which country is the largest producer of natural gas?', ARRAY['United States', 'Russia', 'Iran', 'Qatar'], 0, 'The US is the top producer, followed by Russia.'),
        ('What is the process of injecting fluid to fracture rock for gas extraction?', ARRAY['Hydraulic fracturing (fracking)', 'Acidising', 'Steam injection', 'Horizontal drilling'], 0, 'Fracking is used for unconventional gas.'),
        ('What is the main use of natural gas in the residential sector?', ARRAY['Heating and cooking', 'Electricity generation', 'Transport fuel', 'Industrial feedstock'], 0, 'Residential use is primarily for heating and cooking.'),
        ('What is LNG (Liquefied Natural Gas)?', ARRAY['Gas cooled to liquid for transport', 'Gas compressed to high pressure', 'Gas mixed with other hydrocarbons', 'Gas in a pipeline'], 0, 'LNG is cooled to -162°C for shipping.'),
        ('Which country has the largest natural gas reserves?', ARRAY['Russia', 'Iran', 'Qatar', 'United States'], 0, 'Russia holds the largest reserves.'),
        ('What is the main greenhouse gas emitted from natural gas combustion?', ARRAY['CO₂', 'Methane', 'N₂O', 'NOx'], 0, 'CO₂ is the primary emission, though methane leaks are significant.'),
        ('What is the unit of measurement for natural gas volume?', ARRAY['Cubic feet (or cubic metres)', 'Barrels', 'Tonnes', 'Litres'], 0, 'Gas is typically measured in cubic feet (or m^3).'),
        ('Which sector consumes the most natural gas?', ARRAY['Electricity generation', 'Industry', 'Residential', 'Transport'], 0, 'Electricity generation is the largest consumer globally.'),
        ('What is the term for gas that is extracted along with crude oil?', ARRAY['Associated gas', 'Non-associated gas', 'Coalbed methane', 'Shale gas'], 0, 'Associated gas is found in oil reservoirs.'),
        ('Which pipeline is a major route for Russian gas to Europe?', ARRAY['Nord Stream', 'Druzhba', 'Yamal-Europe', 'All of the above'], 0, 'Nord Stream is the largest to Europe, but multiple exist.'),
        ('What is the main advantage of natural gas compared to coal?', ARRAY['Lower CO₂ emissions per unit of energy', 'Cheaper', 'More abundant', 'Easier to transport'], 0, 'Gas emits about 50% less CO₂ than coal for electricity.'),
        ('What is the term for gas trapped in shale rock?', ARRAY['Shale gas', 'Tight gas', 'Coalbed methane', 'Conventional gas'], 0, 'Shale gas is extracted by fracking.'),
        ('Which country is the largest importer of LNG?', ARRAY['Japan', 'China', 'South Korea', 'India'], 0, 'Japan is the top LNG importer.'),
        ('What is the primary by-product of natural gas processing?', ARRAY['Natural gas liquids (NGLs)', 'Sulphur', 'Helium', 'All of the above'], 0, 'NGLs (ethane, propane, butane) are extracted.'),
        ('What is the typical methane content in natural gas?', ARRAY['~85-95%', '~70-80%', '~60-70%', '~50-60%'], 0, 'Pipeline natural gas is mostly methane.')
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

    -- ==================== COAL (14) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'energy.coal';
    FOR q_rec IN (
        VALUES
        ('What is the highest rank of coal?', ARRAY['Anthracite', 'Bituminous', 'Sub-bituminous', 'Lignite'], 0, 'Anthracite has the highest carbon content.'),
        ('Which country is the largest producer of coal?', ARRAY['China', 'India', 'United States', 'Indonesia'], 0, 'China produces more than half of the world''s coal.'),
        ('What is the main use of coal globally?', ARRAY['Electricity generation', 'Steel production', 'Cement manufacturing', 'Residential heating'], 0, 'About 60% of coal is used for electricity.'),
        ('What is the term for the process of converting coal into a gas?', ARRAY['Coal gasification', 'Coal liquefaction', 'Carbonisation', 'Coking'], 0, 'Gasification produces syngas (CO + H₂).'),
        ('Which country has the largest coal reserves?', ARRAY['United States', 'Russia', 'China', 'India'], 0, 'The US holds the largest proven reserves.'),
        ('What is the main environmental issue with coal combustion?', ARRAY['High CO₂ and other emissions (SO₂, NOx, particulates)', 'Water consumption', 'Land use', 'Methane leaks'], 0, 'Coal is the most carbon-intensive fossil fuel.'),
        ('What is the unit used to measure coal energy content?', ARRAY['BTU (British Thermal Unit) or kcal/kg', 'Barrels', 'Tonnes of oil equivalent', 'Cubic feet'], 0, 'BTU is common in the US.'),
        ('What is the term for the coal that is used to make steel?', ARRAY['Metallurgical (coking) coal', 'Steam coal', 'Thermal coal', 'Lignite'], 0, 'Coking coal is used in blast furnaces.'),
        ('Which country is the largest consumer of coal?', ARRAY['China', 'India', 'United States', 'Germany'], 0, 'China consumes about half of global coal.'),
        ('What is the primary method of mining coal in the US?', ARRAY['Surface (open-pit) mining', 'Underground mining', 'Mountaintop removal', 'All of the above'], 0, 'Surface mining is the most common in the US.'),
        ('What is the approximate share of coal in the global electricity mix (2024)?', ARRAY['~35%', '~45%', '~25%', '~15%'], 0, 'Coal provides about 35% of global electricity.'),
        ('What is the main pollutant from coal that causes acid rain?', ARRAY['Sulphur dioxide (SO₂)', 'Nitrogen oxides (NOx)', 'Mercury', 'Particulate matter'], 0, 'SO₂ emissions lead to acid rain.'),
        ('What is the term for the residue left after coal combustion?', ARRAY['Coal ash', 'Slag', 'Fly ash', 'Bottom ash'], 0, 'Coal ash includes fly ash and bottom ash.'),
        ('Which country has the highest per capita coal consumption?', ARRAY['Australia', 'China', 'United States', 'South Africa'], 0, 'Australia has high per capita consumption due to mining and electricity.')
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

    -- ==================== NUCLEAR (16) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'energy.nuclear';
    FOR q_rec IN (
        VALUES
        ('What is the fuel used in most nuclear reactors?', ARRAY['Uranium-235', 'Plutonium-239', 'Thorium-232', 'Uranium-238'], 0, 'Uranium-235 is the most common fissile material.'),
        ('Which country has the most nuclear reactors?', ARRAY['United States', 'France', 'China', 'Russia'], 0, 'The US has about 94 reactors.'),
        ('What is the process of splitting an atom''s nucleus called?', ARRAY['Nuclear fission', 'Nuclear fusion', 'Radioactive decay', 'Transmutation'], 0, 'Fission releases energy in nuclear reactors.'),
        ('Which country generates the highest percentage of its electricity from nuclear power?', ARRAY['France', 'Slovakia', 'Ukraine', 'Belgium'], 0, 'France gets about 70% of its electricity from nuclear.'),
        ('What is the most common type of reactor in use?', ARRAY['Pressurised water reactor (PWR)', 'Boiling water reactor (BWR)', 'CANDU', 'Fast breeder reactor'], 0, 'PWRs are the most numerous.'),
        ('What is the half-life of Uranium-238?', ARRAY['4.5 billion years', '700 million years', '24,000 years', '5,730 years'], 0, 'U-238 has a long half-life.'),
        ('What is the main waste product of nuclear fission?', ARRAY['Spent fuel (high-level waste)', 'CO₂', 'Fly ash', 'Sulphur dioxide'], 0, 'Spent nuclear fuel is highly radioactive.'),
        ('Which country is the largest producer of uranium?', ARRAY['Kazakhstan', 'Canada', 'Australia', 'Russia'], 0, 'Kazakhstan is the top producer.'),
        ('What is the purpose of control rods in a reactor?', ARRAY['Absorb neutrons to control fission rate', 'Increase fission rate', 'Cool the core', 'Shield radiation'], 0, 'Control rods regulate the chain reaction.'),
        ('What is the name of the first commercial nuclear power plant?', ARRAY['Obninsk (USSR)', 'Shippingport (US)', 'Calder Hall (UK)', 'Indian Point (US)'], 0, 'Obninsk was the first, but Shippingport was the first commercial (1957).'),
        ('What is the term for combining light nuclei to form heavier ones?', ARRAY['Nuclear fusion', 'Nuclear fission', 'Radioactive decay', 'Nuclear transmutation'], 0, 'Fusion powers the sun; it is not yet commercially viable.'),
        ('What is the typical capacity of a large nuclear reactor?', ARRAY['~1,000 MW', '~500 MW', '~2,000 MW', '~100 MW'], 0, 'Many reactors are around 1 GW.'),
        ('What is the main advantage of nuclear power in terms of emissions?', ARRAY['Very low greenhouse gas emissions during operation', 'Zero waste', 'No mining impact', 'Low water use'], 0, 'Nuclear is low-carbon, but waste is an issue.'),
        ('Which country has the most nuclear power plants under construction?', ARRAY['China', 'India', 'Russia', 'United States'], 0, 'China is building many new reactors.'),
        ('What is the main barrier to the expansion of nuclear power?', ARRAY['High cost, waste management, and public perception', 'Lack of fuel', 'Lack of technology', 'Climate change'], 0, 'Cost and waste are major obstacles.'),
        ('What is the accident at Chernobyl classified as?', ARRAY['Level 7 (major accident)', 'Level 5 (accident)', 'Level 6 (serious accident)', 'Level 4 (incident)'], 0, 'Chernobyl and Fukushima are Level 7.'),
        ('What is the typical fuel enrichment level for commercial reactors?', ARRAY['~3-5% U-235', '~20%', '~90%', '~1%'], 0, 'Low-enriched uranium is used in most reactors.')
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

    -- ==================== SOLAR (18) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'energy.solar';
    FOR q_rec IN (
        VALUES
        ('What is the primary technology for converting sunlight into electricity?', ARRAY['Photovoltaic (PV) cells', 'Concentrated solar power (CSP)', 'Solar thermal panels', 'Solar water heaters'], 0, 'PV panels are the most widespread.'),
        ('Which country has the largest installed solar capacity?', ARRAY['China', 'United States', 'Germany', 'India'], 0, 'China leads by far, with over 300 GW.'),
        ('What is the typical efficiency of commercial silicon PV panels?', ARRAY['~15-22%', '~5-10%', '~30-40%', '~10-15%'], 0, 'Monocrystalline panels are around 20-22%.'),
        ('What is the main advantage of solar energy?', ARRAY['Renewable and abundant', 'Low cost', 'No land use', '24/7 availability'], 0, 'Solar is limitless and clean.'),
        ('What is the role of an inverter in a solar PV system?', ARRAY['Convert DC to AC', 'Convert AC to DC', 'Store energy', 'Track the sun'], 0, 'Inverters are essential for grid connection.'),
        ('Which country has the highest solar radiation per square metre?', ARRAY['Australia', 'USA', 'Saudi Arabia', 'Chile'], 0, 'Australia has high solar insolation.'),
        ('What is the term for a system that tracks the sun''s movement?', ARRAY['Solar tracker', 'Concentrator', 'Reflector', 'Sun follower'], 0, 'Trackers increase output by 20-40%.'),
        ('What is the largest solar farm in the world (as of 2024)?', ARRAY['Bhadla Solar Park (India)', 'Tengger Desert Solar Park (China)', 'Solar Star (US)', 'Noor Abu Dhabi (UAE)'], 0, 'Bhadla is over 2.2 GW.'),
        ('What is the main material used in most PV cells?', ARRAY['Silicon', 'Cadmium telluride', 'Copper indium gallium selenide', 'Perovskite'], 0, 'Silicon dominates the market.'),
        ('What is the primary cost driver for solar PV?', ARRAY['Module cost (panels)', 'Installation labour', 'Inverters', 'Permitting'], 0, 'Module costs have declined dramatically.'),
        ('What is the concept of "solar leasing"?', ARRAY['Renting a solar system rather than buying', 'Leasing land for solar farms', 'Leasing panels', 'Leasing inverters'], 0, 'Many homeowners lease solar systems.'),
        ('What is the approximate global installed solar capacity (2024)?', ARRAY['~1,000 GW', '~500 GW', '~1,500 GW', '~2,000 GW'], 0, 'It exceeded 1,000 GW in 2023.'),
        ('Which country has the highest per capita solar capacity?', ARRAY['Australia', 'Netherlands', 'Germany', 'Japan'], 0, 'Australia leads in per capita.'),
        ('What is the main challenge with solar energy?', ARRAY['Intermittency (sun doesn''t shine 24/7)', 'High cost', 'Low efficiency', 'Land requirement'], 0, 'Storage and grid integration are key challenges.'),
        ('What is the term for the solar resource that reaches the Earth''s surface?', ARRAY['Solar irradiance', 'Solar insolation', 'Solar flux', 'Solar power'], 0, 'Insolation is the amount of solar radiation received.'),
        ('What is the efficiency record for a laboratory solar cell?', ARRAY['>47% (multi-junction)', '~25%', '~30%', '~40%'], 0, 'Multi-junction cells have exceeded 47%.'),
        ('What is the role of battery storage in solar systems?', ARRAY['Store excess energy for use at night', 'Convert DC to AC', 'Reduce panel temperature', 'Increase efficiency'], 0, 'Batteries enable self-consumption.'),
        ('Which country has the largest floating solar farm?', ARRAY['China', 'Japan', 'South Korea', 'India'], 0, 'China has several large floating solar installations.')
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

    -- ==================== WIND (16) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'energy.wind';
    FOR q_rec IN (
        VALUES
        ('What is the main component of a wind turbine that converts wind to rotational energy?', ARRAY['Blades and rotor', 'Generator', 'Gearbox', 'Tower'], 0, 'The blades capture wind energy.'),
        ('Which country has the most installed wind power capacity?', ARRAY['China', 'United States', 'Germany', 'India'], 0, 'China leads with over 400 GW (onshore + offshore).'),
        ('What is the typical capacity of an onshore wind turbine?', ARRAY['~2-5 MW', '~10 MW', '~1 MW', '~500 kW'], 0, 'Modern onshore turbines are around 3-5 MW.'),
        ('What is the term for a group of wind turbines?', ARRAY['Wind farm', 'Wind park', 'Wind power plant', 'All of the above'], 0, 'Commonly called a wind farm.'),
        ('What is the cut-in wind speed for most turbines?', ARRAY['~3-4 m/s', '~10 m/s', '~1 m/s', '~20 m/s'], 0, 'Turbines start generating at about 3-4 m/s.'),
        ('What is the main advantage of offshore wind?', ARRAY['Higher and more consistent wind speeds', 'Lower cost', 'Easier maintenance', 'No visual impact'], 0, 'Offshore winds are stronger and steadier.'),
        ('Which country is the leader in offshore wind?', ARRAY['China', 'United Kingdom', 'Germany', 'Netherlands'], 0, 'China overtook the UK recently, but UK has long been a leader.'),
        ('What is the typical hub height of a modern onshore turbine?', ARRAY['~100 metres', '~50 metres', '~150 metres', '~200 metres'], 0, 'Hub heights are around 100 m.'),
        ('What is the main environmental concern of wind turbines?', ARRAY['Bird and bat collisions', 'Noise', 'Visual impact', 'All of the above'], 0, 'Wildlife impacts are a primary concern.'),
        ('What is the term for the upper limit of wind speed at which a turbine stops to prevent damage?', ARRAY['Cut-out speed', 'Cut-in speed', 'Rated speed', 'Survival speed'], 0, 'Cut-out is typically around 25 m/s.'),
        ('What is the approximate capacity factor of onshore wind?', ARRAY['~30-40%', '~50-60%', '~20%', '~70%'], 0, 'Capacity factor is about 35% onshore, 45% offshore.'),
        ('Which country has the highest share of wind in its electricity mix?', ARRAY['Denmark', 'Germany', 'Spain', 'Portugal'], 0, 'Denmark gets over 50% from wind.'),
        ('What is the role of a transformer in a wind farm?', ARRAY['Step up voltage for grid transmission', 'Convert AC to DC', 'Store energy', 'Control blade pitch'], 0, 'Transformers increase voltage for efficient transmission.'),
        ('What is the average lifespan of a wind turbine?', ARRAY['~20-25 years', '10-15 years', '30-35 years', '40-50 years'], 0, 'Typical design life is 20-25 years.'),
        ('What is the largest offshore wind farm in the world (as of 2024)?', ARRAY['Dogger Bank (UK)', 'Hornsea (UK)', 'Walney (UK)', 'Borssele (Netherlands)'], 0, 'Dogger Bank will be 3.6 GW, but Hornsea 2 is 1.3 GW.'),
        ('What is the primary material used for wind turbine blades?', ARRAY['Fiberglass reinforced plastic', 'Steel', 'Aluminium', 'Carbon fibre'], 0, 'Glass-fiber composites are most common.')
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

    -- ==================== HYDROELECTRIC (14) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'energy.hydroelectric';
    FOR q_rec IN (
        VALUES
        ('What is the largest source of renewable electricity globally?', ARRAY['Hydropower', 'Wind', 'Solar', 'Bioenergy'], 0, 'Hydropower is the largest renewable source.'),
        ('Which country generates the most electricity from hydro?', ARRAY['China', 'Brazil', 'Canada', 'United States'], 0, 'China is the largest producer.'),
        ('What is the term for a dam that stores water in a reservoir?', ARRAY['Storage hydro', 'Run-of-river', 'Pumped storage', 'Tidal'], 0, 'Storage hydro uses a reservoir to manage flow.'),
        ('What is the world''s largest hydroelectric plant by capacity?', ARRAY['Three Gorges Dam (China)', 'Itaipu (Brazil/Paraguay)', 'Xiluodu (China)', 'Bel Monte (Brazil)'], 0, 'Three Gorges is 22.5 GW.'),
        ('What is the primary advantage of pumped-storage hydro?', ARRAY['Energy storage (pumps water uphill during low demand)', 'Low cost', 'No environmental impact', 'Small footprint'], 0, 'Pumped storage is the largest form of grid storage.'),
        ('What is the approximate global hydropower capacity (2024)?', ARRAY['~1,300 GW', '~1,000 GW', '~1,500 GW', '~2,000 GW'], 0, 'Installed capacity is about 1,300 GW.'),
        ('Which country has the highest share of hydro in its electricity?', ARRAY['Norway', 'Brazil', 'Canada', 'Paraguay'], 0, 'Norway gets over 90% from hydro.'),
        ('What is the main environmental impact of large dams?', ARRAY['Displacement of people and ecosystems', 'Greenhouse gas emissions', 'Water quality', 'All of the above'], 0, 'Large dams have significant social and ecological effects.'),
        ('What is the typical efficiency of a hydro turbine?', ARRAY['~90%', '~70%', '~80%', '~95%'], 0, 'Hydro turbines are highly efficient, 85-95%.'),
        ('What is the term for a hydro plant that uses the natural flow of a river without a large reservoir?', ARRAY['Run-of-river', 'Storage', 'Pumped', 'Tidal'], 0, 'Run-of-river has minimal storage.'),
        ('Which country has the largest hydropower potential?', ARRAY['DR Congo', 'China', 'Brazil', 'Russia'], 0, 'DR Congo has the largest untapped potential.'),
        ('What is the name of the hydro plant that used to be the largest before Three Gorges?', ARRAY['Itaipu Dam', 'Guri Dam', 'Grand Coulee', 'Sayano-Shushenskaya'], 0, 'Itaipu (14 GW) was the largest before 2012.'),
        ('What is the approximate capacity factor of hydro?', ARRAY['~30-50%', '~60-80%', '~20-30%', '~80-90%'], 0, 'Hydro can have high capacity factors, often 40-60%.'),
        ('What is the main challenge for new large hydro projects?', ARRAY['Environmental and social concerns, high cost', 'Lack of water', 'Low efficiency', 'Technological limits'], 0, 'New projects face strong opposition due to impacts.')
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

    -- ==================== GEOTHERMAL (10) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'energy.geothermal';
    FOR q_rec IN (
        VALUES
        ('What is the primary source of geothermal energy?', ARRAY['Earth''s internal heat', 'Sun', 'Nuclear reactions in the crust', 'Radioactive decay'], 0, 'Geothermal energy comes from the Earth''s core.'),
        ('Which country is the largest producer of geothermal electricity?', ARRAY['United States', 'Indonesia', 'Philippines', 'Turkey'], 0, 'The US has the most installed capacity.'),
        ('What is the typical temperature of geothermal reservoirs used for electricity generation?', ARRAY['>150°C', '50-100°C', '100-150°C', '<50°C'], 0, 'High-temperature reservoirs are needed for power generation.'),
        ('What is the main advantage of geothermal energy?', ARRAY['Baseload (reliable, constant)', 'Low cost', 'No environmental impact', 'Quick to deploy'], 0, 'Geothermal provides continuous power.'),
        ('What is the term for a geothermal power plant that uses steam from underground?', ARRAY['Dry steam', 'Flash steam', 'Binary cycle', 'All of the above'], 0, 'Dry steam is the oldest technology.'),
        ('Which country generates the highest percentage of its electricity from geothermal?', ARRAY['Iceland', 'El Salvador', 'Kenya', 'New Zealand'], 0, 'Iceland gets over 25% of its electricity from geothermal.'),
        ('What is the primary environmental concern with geothermal?', ARRAY['Subsurface water depletion and induced seismicity', 'CO₂ emissions', 'Land use', 'Water pollution'], 0, 'Geothermal can cause earthquakes and groundwater issues.'),
        ('What is the typical capacity of a geothermal plant?', ARRAY['10-100 MW', '1-10 MW', '100-500 MW', '>500 MW'], 0, 'Most are in the 10-100 MW range.'),
        ('What is the global installed geothermal capacity (2024)?', ARRAY['~16 GW', '~10 GW', '~20 GW', '~30 GW'], 0, 'Geothermal is about 16 GW.'),
        ('What is the use of geothermal heat pumps?', ARRAY['Heating and cooling buildings', 'Electricity generation', 'Industrial processes', 'Water desalination'], 0, 'Heat pumps use shallow ground heat for HVAC.')
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

    -- ==================== HYDROGEN (10) ====================
    SELECT id INTO cat_id FROM categories WHERE path = 'energy.hydrogen';
    FOR q_rec IN (
        VALUES
        ('What is the most abundant element in the universe?', ARRAY['Hydrogen', 'Helium', 'Oxygen', 'Carbon'], 0, 'Hydrogen is the most abundant, mostly in stars.'),
        ('What is the colour of hydrogen produced from fossil fuels (without CCS) called?', ARRAY['Grey hydrogen', 'Blue hydrogen', 'Green hydrogen', 'Brown hydrogen'], 0, 'Grey hydrogen is from natural gas reforming.'),
        ('What is hydrogen produced using renewable electricity called?', ARRAY['Green hydrogen', 'Blue hydrogen', 'Grey hydrogen', 'Pink hydrogen'], 0, 'Green hydrogen is produced by electrolysis with renewables.'),
        ('What is the main method of producing hydrogen today?', ARRAY['Steam methane reforming (SMR) of natural gas', 'Electrolysis', 'Coal gasification', 'Biomass gasification'], 0, 'SMR produces about 95% of hydrogen.'),
        ('What is the primary use of hydrogen today?', ARRAY['Ammonia production and refining', 'Transport fuel', 'Electricity generation', 'Heating'], 0, 'Most hydrogen is used in industry, especially ammonia and oil refining.'),
        ('What is the role of electrolysers in hydrogen production?', ARRAY['Split water into hydrogen and oxygen using electricity', 'Reform natural gas', 'Compress hydrogen', 'Store hydrogen'], 0, 'Electrolysers use electricity to produce hydrogen.'),
        ('Which country aims to become a global hydrogen exporter?', ARRAY['Australia', 'Germany', 'Japan', 'United States'], 0, 'Australia has major hydrogen export projects.'),
        ('What is the energy density of hydrogen by weight compared to gasoline?', ARRAY['~3x higher (per kg)', '~1x', '~2x lower', '~5x higher'], 0, 'Hydrogen has about 3x the energy per kg of gasoline.'),
        ('What is the main challenge for hydrogen as a fuel?', ARRAY['Storage and transport (low density, high pressure)', 'Cost', 'Efficiency', 'All of the above'], 0, 'Hydrogen is difficult to store and transport efficiently.'),
        ('What is the fuel cell that uses hydrogen to produce electricity?', ARRAY['Proton Exchange Membrane (PEM) fuel cell', 'Solid oxide fuel cell', 'Alkaline fuel cell', 'Phosphoric acid fuel cell'], 0, 'PEM fuel cells are used in many vehicles.')
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

    RAISE NOTICE '✅ 250 agriculture and energy questions inserted successfully.';
END $$;