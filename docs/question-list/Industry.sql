-- ============================================================================
-- Insert 170 factual questions on Industry.
-- Subtopics: Manufacturing, Construction, Mining, Agriculture, Fisheries,
-- Forestry, Logistics, Retail, Telecommunications.
-- ============================================================================

DO $$
DECLARE
    cat_id_manufacturing  BIGINT;
    cat_id_construction   BIGINT;
    cat_id_mining         BIGINT;
    cat_id_agriculture    BIGINT;
    cat_id_fisheries      BIGINT;
    cat_id_forestry       BIGINT;
    cat_id_logistics      BIGINT;
    cat_id_retail         BIGINT;
    cat_id_telecom        BIGINT;
    q_id                  BIGINT;
    correct_opt_id        BIGINT;
    opt_texts             TEXT[];
    q_rec                 RECORD;
BEGIN
    -- ------------------------------------------------------------------------
    -- Create categories (hierarchical under industry)
    -- ------------------------------------------------------------------------
    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('industry', 'Industry', 3, 0)
        ON CONFLICT (path) DO NOTHING;

    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('industry.manufacturing',      'Manufacturing', 0, 1),
        ('industry.construction',       'Construction', 3, 2),
        ('industry.mining',             'Mining', 3, 3),
        ('industry.agriculture',        'Agriculture', 3, 4),
        ('industry.fisheries',          'Fisheries', 3, 5),
        ('industry.forestry',           'Forestry', 3, 6),
        ('industry.logistics',          'Logistics', 3, 7),
        ('industry.retail',             'Retail', 3, 8),
        ('industry.telecommunications', 'Telecommunications', 3, 9)
        ON CONFLICT (path) DO NOTHING;

    -- Get category IDs
    SELECT id INTO cat_id_manufacturing FROM categories WHERE path = 'industry.manufacturing';
    SELECT id INTO cat_id_construction  FROM categories WHERE path = 'industry.construction';
    SELECT id INTO cat_id_mining        FROM categories WHERE path = 'industry.mining';
    SELECT id INTO cat_id_agriculture   FROM categories WHERE path = 'industry.agriculture';
    SELECT id INTO cat_id_fisheries     FROM categories WHERE path = 'industry.fisheries';
    SELECT id INTO cat_id_forestry      FROM categories WHERE path = 'industry.forestry';
    SELECT id INTO cat_id_logistics     FROM categories WHERE path = 'industry.logistics';
    SELECT id INTO cat_id_retail        FROM categories WHERE path = 'industry.retail';
    SELECT id INTO cat_id_telecom       FROM categories WHERE path = 'industry.telecommunications';

    -- ========================================================================
    -- 1. MANUFACTURING (19 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is manufacturing?',
         ARRAY['The process of converting raw materials into finished goods', 'The extraction of raw materials', 'The distribution of products', 'The design of products'], 0,
         'Manufacturing adds value by transforming materials into useful products.'),
        ('Which manufacturing method involves shaping metal by pouring molten metal into a mould?',
         ARRAY['Casting', 'Forging', 'Machining', 'Welding'], 0,
         'Casting is one of the oldest manufacturing processes.'),
        ('What is the "assembly line" known for?',
         ARRAY['A production process where products are assembled in a sequential manner', 'A process where products are made individually', 'A process for repairing products', 'A process for packaging products'], 0,
         'Henry Ford popularised the assembly line for mass production.'),
        ('Which manufacturing process uses a computer-controlled cutting tool to remove material?',
         ARRAY['CNC machining', 'Injection moulding', '3D printing', 'Casting'], 0,
         'CNC (Computer Numerical Control) machining is precise and automated.'),
        ('What is 3D printing also known as?',
         ARRAY['Additive manufacturing', 'Subtractive manufacturing', 'Formative manufacturing', 'Injection moulding'], 0,
         '3D printing builds objects layer by layer.'),
        ('Which industry is responsible for producing steel?',
         ARRAY['Metal manufacturing', 'Plastic manufacturing', 'Textile manufacturing', 'Food manufacturing'], 0,
         'Steel production is a major industrial activity.'),
        ('What is "just-in-time" (JIT) manufacturing?',
         ARRAY['A production strategy that aims to reduce inventory by producing only what is needed when it is needed', 'A strategy to produce as much as possible', 'A strategy to outsource production', 'A strategy to automate all processes'], 0,
         'JIT was developed by Toyota to minimise waste.'),
        ('Which manufacturing technique involves heating metal and then hammering it into shape?',
         ARRAY['Forging', 'Casting', 'Extrusion', 'Rolling'], 0,
         'Forging improves the strength of metal.'),
        ('What is the primary raw material for making paper?',
         ARRAY['Wood pulp', 'Recycled plastic', 'Cotton', 'Synthetic fibres'], 0,
         'Paper manufacturing uses wood pulp from trees.'),
        ('Which sector is a major consumer of manufacturing output?',
         ARRAY['Construction, automotive, and electronics', 'Agriculture', 'Mining', 'Fisheries'], 0,
         'These sectors rely heavily on manufactured goods.'),
        ('What is "lean manufacturing"?',
         ARRAY['A production philosophy that minimises waste while maximising value', 'A strategy to produce with minimal labour', 'A strategy to use only renewable materials', 'A strategy to maximise inventory'], 0,
         'Lean manufacturing originated from Toyota''s production system.'),
        ('Which material is commonly used in plastic manufacturing?',
         ARRAY['Petrochemicals derived from crude oil', 'Wood', 'Cotton', 'Glass'], 0,
         'Plastics are synthetic polymers from petrochemicals.'),
        ('What is the role of quality control in manufacturing?',
         ARRAY['To ensure products meet specified standards and regulations', 'To increase production speed', 'To reduce costs at all costs', 'To design new products'], 0,
         'Quality control is essential for customer satisfaction and safety.'),
        ('Which manufacturing process is used to create semiconductor chips?',
         ARRAY['Photolithography', 'Casting', 'Forging', 'Extrusion'], 0,
         'Photolithography is used in the fabrication of integrated circuits.'),
        ('What is the largest manufacturing country in the world?',
         ARRAY['China', 'United States', 'Germany', 'Japan'], 0,
         'China is the world''s leading manufacturer by output.'),
        ('Which industry is a major user of robotics in manufacturing?',
         ARRAY['Automotive, electronics, and heavy machinery', 'Textiles', 'Food processing', 'Construction materials'], 0,
         'Robotics automates repetitive and dangerous tasks.'),
        ('What is "sustainable manufacturing"?',
         ARRAY['Producing goods while minimising environmental impact', 'Producing only recyclable goods', 'Producing at any cost', 'Producing without energy'], 0,
         'Sustainable manufacturing addresses resource efficiency and pollution.'),
        ('Which manufacturing process is used for making chocolate?',
         ARRAY['Conching and tempering', 'Casting', 'Extrusion', 'Forging'], 0,
         'Chocolate manufacturing involves conching to develop flavour and texture.'),
        ('What is the role of automation in modern manufacturing?',
         ARRAY['To reduce labour costs and increase efficiency and precision', 'To eliminate all human workers', 'To increase manual labour', 'To reduce product quality'], 0,
         'Automation is a key driver of productivity.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_manufacturing, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 2. CONSTRUCTION (19 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is construction?',
         ARRAY['The process of building infrastructure, buildings, and other structures', 'The process of designing structures', 'The process of manufacturing building materials', 'The process of demolishing structures'], 0,
         'Construction encompasses residential, commercial, and civil projects.'),
        ('Which material is the most common building material in the world?',
         ARRAY['Concrete', 'Wood', 'Steel', 'Brick'], 0,
         'Concrete is the most widely used man‑made material.'),
        ('What is the role of an architect in construction?',
         ARRAY['To design buildings and ensure they are functional and aesthetically pleasing', 'To build the structure', 'To supply materials', 'To finance projects'], 0,
         'Architects create blueprints and oversee construction.'),
        ('Which heavy machine is used to dig foundations and move earth?',
         ARRAY['Excavator', 'Crane', 'Bulldozer', 'Dumper truck'], 0,
         'Excavators are essential for earthmoving.'),
        ('What is a "skyscraper"?',
         ARRAY['A very tall, multi‑storey building', 'A type of bridge', 'A type of tunnel', 'A type of dam'], 0,
         'Skyscrapers are typically over 150 metres tall.'),
        ('Which construction project is designed to cross a body of water?',
         ARRAY['Bridge', 'Dam', 'Tunnel', 'Road'], 0,
         'Bridges connect land over water or obstacles.'),
        ('What is the foundation of a building?',
         ARRAY['The structural element that transfers loads to the ground', 'The roof', 'The walls', 'The floor'], 0,
         'Foundations can be shallow or deep.'),
        ('Which system is used to lift materials to high floors during construction?',
         ARRAY['Tower crane', 'Excavator', 'Bulldozer', 'Concrete pump'], 0,
         'Tower cranes are essential for high‑rise construction.'),
        ('What is "sustainable construction"?',
         ARRAY ['Building with minimal environmental impact and resource efficiency', 'Building without planning', 'Building with only local materials', 'Building only small structures'], 0,
         'Sustainable construction includes green building certifications like LEED.'),
        ('Which construction equipment is used for compacting soil?',
         ARRAY ['Roller', 'Crane', 'Excavator', 'Dumper'], 0,
         'Rollers ensure stable foundations.'),
        ('What is the purpose of scaffolding in construction?',
         ARRAY['To provide temporary support and access for workers', 'To permanently support a building', 'To lift heavy materials', 'To finish concrete surfaces'], 0,
         'Scaffolding is essential for safety and access during construction.'),
        ('Which material is commonly used for structural steel?',
         ARRAY['Carbon steel', 'Cast iron', 'Aluminium', 'Copper'], 0,
         'Carbon steel has high strength and is weldable.'),
        ('What is a "blueprint" in construction?',
         ARRAY['A detailed technical drawing used as a guide for construction', 'A type of paint', 'A building material', 'A safety document'], 0,
         'Blueprints show dimensions, materials, and structural details.'),
        ('Which type of construction involves building tunnels and bridges?',
         ARRAY['Civil engineering construction', 'Residential construction', 'Commercial construction', 'Industrial construction'], 0,
         'Civil engineering projects are large‑scale public works.'),
        ('What is the role of a construction manager?',
         ARRAY['To plan, coordinate, and oversee construction projects', 'To design the building', 'To pour concrete', 'To supply materials'], 0,
         'Construction managers ensure projects are on time and on budget.'),
        ('Which safety equipment is mandatory on construction sites?',
         ARRAY['Hard hats, safety glasses, and high‑visibility vests', 'Swim goggles', 'Earplugs only', 'Respirators only'], 0,
         'Personal protective equipment (PPE) is essential on construction sites.'),
        ('What is a "bulldozer" used for?',
         ARRAY['To push large quantities of soil and rubble', 'To lift heavy materials', 'To dig deep holes', 'To mix concrete'], 0,
         'Bulldozers are powerful earthmoving machines.'),
        ('Which construction material is made from a mixture of cement, water, sand, and aggregate?',
         ARRAY['Concrete', 'Mortar', 'Asphalt', 'Plaster'], 0,
         'Concrete is reinforced with steel for structural strength.'),
        ('What is the purpose of rebar in concrete construction?',
         ARRAY['To reinforce concrete and increase tensile strength', 'To decorate the surface', 'To hold the concrete together during pouring', 'To allow water drainage'], 0,
         'Rebar (reinforcing bar) prevents cracking.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_construction, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 3. MINING (19 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is mining?',
         ARRAY['The extraction of valuable minerals and ores from the Earth', 'The processing of minerals', 'The recycling of metals', 'The manufacturing of metals'], 0,
         'Mining provides essential raw materials for industry.'),
        ('What is the difference between surface mining and underground mining?',
         ARRAY['Surface mining removes materials from the surface; underground mining extracts from below the surface', 'Surface mining is deeper', 'Underground mining is always open‑pit', 'There is no difference'], 0,
         'Surface mining is used for shallow deposits; underground for deep deposits.'),
        ('Which metal is extracted from the ore bauxite?',
         ARRAY['Aluminium', 'Iron', 'Copper', 'Gold'], 0,
         'Bauxite is the primary source of aluminium.'),
        ('What is the primary ore of iron?',
         ARRAY['Haematite', 'Galena', 'Bauxite', 'Chalcopyrite'], 0,
         'Haematite and magnetite are the main iron ores.'),
        ('Which mineral is extracted from the ore galena?',
         ARRAY['Lead', 'Zinc', 'Copper', 'Silver'], 0,
         'Galena is a primary source of lead.'),
        ('What is "open‑pit mining"?',
         ARRAY['A surface mining method that creates a large, open excavation', 'A method that mines underground', 'A method that uses explosives only', 'A method for extracting oil'], 0,
         'Open‑pit mining is used for large, near‑surface deposits.'),
        ('Which method is used to extract minerals from underground without surface disruption?',
         ARRAY['Shaft and drift mining', 'Open‑pit mining', 'Placer mining', 'Strip mining'], 0,
         'Shaft and drift mining access ore bodies deep underground.'),
        ('What is the role of a crusher in mining?',
         ARRAY['To break down large rocks into smaller pieces for processing', 'To separate minerals from waste', 'To transport ore', 'To refine metals'], 0,
         'Crushing is the first step in mineral processing.'),
        ('Which valuable metal is commonly recovered from placer deposits?',
         ARRAY['Gold', 'Iron', 'Bauxite', 'Copper'], 0,
         'Placer mining recovers gold and other heavy minerals from alluvial deposits.'),
        ('What is "tailings" in mining?',
         ARRAY['Waste material remaining after the valuable minerals have been extracted', 'The extracted minerals', 'The topsoil', 'The equipment'], 0,
         'Tailings management is critical for environmental protection.'),
        ('Which country is the world''s largest producer of coal?',
         ARRAY['China', 'India', 'United States', 'Australia'], 0,
         'China is the largest coal producer by a significant margin.'),
        ('What is the purpose of a "conveyor belt" in mining?',
         ARRAY['To transport extracted materials efficiently over distances', 'To crush ore', 'To separate minerals', 'To drill holes'], 0,
         'Conveyor belts are widely used in mining operations.'),
        ('Which mineral is the hardest known natural substance?',
         ARRAY['Diamond', 'Quartz', 'Topaz', 'Corundum'], 0,
         'Diamond is the hardest natural material.'),
        ('What is "underground mining" commonly used for?',
         ARRAY['Extracting deep mineral deposits, including coal, gold, and diamonds', 'Mining only surface deposits', 'Extracting oil and gas', 'Mining only sand and gravel'], 0,
         'Underground mining is used when ore bodies are too deep for surface mining.'),
        ('Which mining method is used to extract oil sands?',
         ARRAY['Surface mining (open‑pit) and in‑situ extraction', 'Underground mining', 'Placer mining', 'Hydraulic mining'], 0,
         'Oil sands are extracted through surface mining or in‑situ techniques.'),
        ('What is the role of a "hoist" in underground mining?',
         ARRAY['To lift workers and materials into and out of the mine shaft', 'To transport ore on the surface', 'To crush ore', 'To ventilate the mine'], 0,
         'Hoists are critical for access to underground mines.'),
        ('Which gas is a major safety concern in underground coal mines?',
         ARRAY['Methane (explosive)', 'Carbon dioxide', 'Oxygen', 'Nitrogen'], 0,
         'Methane (CH₄) can accumulate and cause explosions.'),
        ('What is "strip mining" used for?',
         ARRAY['Mining shallow deposits by removing layers of soil and rock above the ore', 'Mining deep deposits', 'Mining underwater deposits', 'Mining only precious metals'], 0,
         'Strip mining is commonly used for coal and phosphate.'),
        ('Which mineral is the primary source of copper?',
         ARRAY['Chalcopyrite', 'Galena', 'Bauxite', 'Haematite'], 0,
         'Chalcopyrite is the most important copper ore.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_mining, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 4. AGRICULTURE (19 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is agriculture?',
         ARRAY['The practice of cultivating crops and raising livestock for food, fibre, and other products', 'The practice of hunting and gathering', 'The practice of extracting minerals', 'The practice of manufacturing goods'], 0,
         'Agriculture is the backbone of civilisation.'),
        ('Which crop is the most widely grown cereal in the world?',
         ARRAY['Wheat', 'Rice', 'Maize (corn)', 'Barley'], 0,
         'Wheat, rice, and maize are the top three cereals.'),
        ('What is "subsistence agriculture"?',
         ARRAY['Farming primarily to provide food for the farmer''s family, not for sale', 'Large‑scale commercial farming', 'Organic farming', 'Intensive farming'], 0,
         'Subsistence agriculture is common in developing countries.'),
        ('What is "intensive agriculture"?',
         ARRAY['A farming system that uses high inputs of labour, capital, and technology to maximise yield per unit area', 'Farming that uses minimal inputs', 'Farming that only uses organic methods', 'Farming that is purely for subsistence'], 0,
         'Intensive agriculture is common in developed countries.'),
        ('Which agricultural practice involves growing crops on steep slopes in steps?',
         ARRAY['Terracing', 'Irrigation', 'Crop rotation', 'Slash and burn'], 0,
         'Terracing reduces erosion and allows farming on hillsides.'),
        ('What is "irrigation"?',
         ARRAY['The artificial application of water to crops', 'The removal of water from soil', 'The process of fertilising', 'The practice of crop rotation'], 0,
         'Irrigation is essential for agriculture in arid and semi‑arid regions.'),
        ('Which animal is raised primarily for milk production?',
         ARRAY['Cattle (dairy cows)', 'Sheep', 'Goats', 'Chickens'], 0,
         'Dairy cows are the primary source of milk globally.'),
        ('What is "crop rotation"?',
         ARRAY['The practice of planting different crops in succession on the same land', 'The practice of always planting the same crop', 'The practice of planting multiple crops together', 'The practice of not planting any crops'], 0,
         'Crop rotation helps maintain soil fertility and reduce pests.'),
        ('Which country is the largest producer of rice?',
         ARRAY['China', 'India', 'Indonesia', 'Bangladesh'], 0,
         'China and India are the largest rice producers.'),
        ('What is "organic farming"?',
         ARRAY['Farming without synthetic pesticides, fertilisers, or genetically modified organisms', 'Farming using only chemical inputs', 'Farming for profit only', 'Farming without any technology'], 0,
         'Organic farming emphasises natural inputs and sustainability.'),
        ('Which agricultural machine is used for harvesting grain crops?',
         ARRAY['Combine harvester', 'Tractor', 'Plough', 'Seeder'], 0,
         'Combine harvesters cut, thresh, and clean grain in one pass.'),
        ('What is "aquaculture" in agriculture?',
         ARRAY['The farming of aquatic organisms such as fish, shellfish, and algae', 'The farming of only freshwater fish', 'The farming of only marine fish', 'The farming of plants'], 0,
         'Aquaculture is growing rapidly to meet seafood demand.'),
        ('Which soil type is most fertile for agriculture?',
         ARRAY['Loam (balanced sand, silt, and clay)', 'Sand', 'Clay', 'Peat'], 0,
         'Loam has good drainage and nutrient retention.'),
        ('What is "monoculture" farming?',
         ARRAY['The cultivation of a single crop species in a given area', 'The cultivation of multiple crops', 'The cultivation of only organic crops', 'The cultivation of only genetically modified crops'], 0,
         'Monoculture is common in industrial agriculture but can lead to soil degradation.'),
        ('Which country is the world''s largest soybean producer?',
         ARRAY['United States', 'Brazil', 'Argentina', 'China'], 0,
         'The US and Brazil are the top soybean producers.'),
        ('What is the role of pollinators in agriculture?',
         ARRAY['They transfer pollen, essential for fruit and seed production', 'They eat pests', 'They fertilise the soil', 'They spread seeds'], 0,
         'Bees and other pollinators are vital for many crops.'),
        ('Which agricultural practice can help prevent soil erosion?',
         ARRAY['Contour ploughing, terracing, and cover cropping', 'Ploughing up and down slopes', 'Burning crop residues', 'Using only chemical fertilisers'], 0,
         'Soil conservation practices maintain agricultural productivity.'),
        ('What is "agribusiness"?',
         ARRAY['Commercial agriculture integrated with processing, distribution, and marketing', 'Small‑scale subsistence farming', 'Organic farming only', 'Agricultural research'], 0,
         'Agribusiness encompasses all sectors of the agricultural industry.'),
        ('Which crop is the most widely grown for oil production?',
         ARRAY['Soybean', 'Palm oil', 'Rapeseed', 'Sunflower'], 0,
         'Soybean and palm oil are the leading vegetable oils.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_agriculture, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 5. FISHERIES (18 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What are fisheries?',
         ARRAY ['The harvesting, cultivation, and management of fish and other aquatic organisms', 'The hunting of marine mammals', 'The extraction of salt from the sea', 'The mining of seabed minerals'], 0,
         'Fisheries include both capture fisheries and aquaculture.'),
        ('What is the difference between capture fisheries and aquaculture?',
         ARRAY['Capture fisheries involve catching wild fish; aquaculture involves farming fish', 'Capture fisheries are for freshwater only', 'Aquaculture is for marine fish only', 'There is no difference'], 0,
         'Aquaculture is rapidly growing to meet global seafood demand.'),
        ('Which fish is the most consumed worldwide?',
         ARRAY['Tuna', 'Salmon', 'Cod', 'Anchovies'], 0,
         'Tuna and salmon are among the most consumed, but whitefish like cod are also important.'),
        ('What is overfishing?',
         ARRAY['The removal of fish from a population faster than it can reproduce', 'The sustainable harvesting of fish', 'The farming of fish', 'The conservation of fish stocks'], 0,
         'Overfishing is a major threat to global fisheries.'),
        ('What is the "maximum sustainable yield" (MSY)?',
         ARRAY['The largest catch that can be taken without reducing the population''s ability to recover', 'The minimum catch required', 'The total fish stock', 'The catch that maximises profit'], 0,
         'MSY is a target for sustainable fisheries management.'),
        ('Which region has the largest fisheries in the world?',
         ARRAY['Asia (China, Japan, Indonesia)', 'North America', 'Europe', 'South America'], 0,
         'China is the world''s largest fishing nation by volume.'),
        ('What is "bycatch"?',
         ARRAY['Unintended catch of non‑target species during fishing', 'The intended catch', 'The total catch', 'The catch from aquaculture'], 0,
         'Bycatch includes dolphins, turtles, and other marine life.'),
        ('Which fishing method is most responsible for habitat damage?',
         ARRAY['Bottom trawling', 'Line fishing', 'Gillnetting', 'Pole and line fishing'], 0,
         'Bottom trawling damages seafloor habitats.'),
        ('What is "aquaculture"?',
         ARRAY['The farming of aquatic organisms', 'The capture of wild fish', 'The processing of fish', 'The marketing of seafood'], 0,
         'Aquaculture includes freshwater and marine farming.'),
        ('Which species is the most commonly farmed in aquaculture?',
         ARRAY['Tilapia, salmon, and carp', 'Tuna', 'Cod', 'Sardines'], 0,
         'Tilapia, carp, and salmon are the most farmed species globally.'),
        ('What is the role of fisheries management?',
         ARRAY['To ensure sustainable fish stocks and regulate fishing activities', 'To maximise fish catch', 'To eliminate fishing', 'To promote only aquaculture'], 0,
         'Fisheries management uses quotas, seasonal closures, and gear restrictions.'),
        ('Which international organisation sets fishing quotas in the Atlantic?',
         ARRAY['ICCAT and NAFO', 'FAO', 'WHO', 'UNEP'], 0,
         'ICCAT manages tuna and other species; NAFO manages Northwest Atlantic fisheries.'),
        ('What is "fish meal" used for?',
         ARRAY['As a high‑protein feed for livestock and aquaculture', 'As human food', 'As fertiliser', 'As fuel'], 0,
         'Fish meal is a major component of animal feeds.'),
        ('Which environmental issue is caused by aquaculture?',
         ARRAY['Pollution from waste and feed, and disease transmission', 'Overfishing only', 'Habitat destruction only', 'Climate change'], 0,
         'Aquaculture can cause water pollution and disease spread.'),
        ('What is "sustainable seafood"?',
         ARRAY['Seafood that is caught or farmed in a way that ensures long‑term viability', 'Seafood that is cheap', 'Seafood that is only wild‑caught', 'Seafood that is only farmed'], 0,
         'Sustainability certifications like MSC and ASC are available.'),
        ('Which fishing method is considered the most selective and environmentally friendly?',
         ARRAY['Pole and line fishing', 'Bottom trawling', 'Drift netting', 'Longlining'], 0,
         'Pole and line fishing has low bycatch.'),
        ('What is the role of marine protected areas (MPAs) in fisheries?',
         ARRAY['To conserve marine biodiversity and allow fish stocks to recover', 'To eliminate fishing entirely', 'To promote aquaculture only', 'To increase fishing effort'], 0,
         'MPAs help rebuild fish populations.'),
        ('Which country is the largest exporter of seafood?',
         ARRAY['China', 'Norway', 'Chile', 'Vietnam'], 0,
         'Norway is the largest exporter of salmon; China is a major exporter overall.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_fisheries, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 6. FORESTRY (18 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is forestry?',
         ARRAY ['The science and practice of managing forests for timber, conservation, and other resources', 'The cutting down of all trees', 'The planting of trees only', 'The study of wildlife'], 0,
         'Forestry balances economic, ecological, and social goals.'),
        ('What is the difference between a forest and a plantation?',
         ARRAY['Forests are natural or semi‑natural; plantations are artificially established', 'Forests are always old‑growth', 'Plantations are always sustainable', 'There is no difference'], 0,
         'Plantations are often monocultures of fast‑growing species.'),
        ('Which tree species is most commonly planted for timber in temperate regions?',
         ARRAY['Pine, spruce, and oak', 'Teak', 'Mahogany', 'Eucalyptus'], 0,
         'Softwoods like pine and spruce dominate temperate timber production.'),
        ('What is "deforestation"?',
         ARRAY['The clearing of forests for other land uses', 'The natural loss of trees', 'The sustainable harvesting of timber', 'The planting of new forests'], 0,
         'Deforestation is a major cause of biodiversity loss and climate change.'),
        ('What is "afforestation"?',
         ARRAY['The planting of trees in an area that was not previously forested', 'The planting of trees in an area that was previously forested', 'The removal of trees', 'The conservation of existing forests'], 0,
         'Afforestation can help sequester carbon.'),
        ('What is "reforestation"?',
         ARRAY['The replanting of trees in a forest that has been harvested or damaged', 'The planting in non‑forested areas', 'The removal of trees', 'The conservation of forests'], 0,
         'Reforestation restores forest cover after logging or fire.'),
        ('Which product is a major output of forestry?',
         ARRAY['Timber, paper, and wood products', 'Metals', 'Crude oil', 'Agricultural crops'], 0,
         'Forestry provides raw materials for many industries.'),
        ('What is "sustainable forestry"?',
         ARRAY['Forest management that maintains biodiversity, productivity, and ecological processes for future generations', 'Forest management that maximises timber output', 'Forest management that only conserves wildlife', 'Forest management that uses only natural regeneration'], 0,
         'Sustainable forestry is certified by organisations like the FSC.'),
        ('Which country has the largest forest area?',
         ARRAY['Russia', 'Brazil', 'Canada', 'China'], 0,
         'Russia has the largest forest area, followed by Brazil.'),
        ('What is a "selective logging" approach?',
         ARRAY['Removing only certain trees, leaving the forest structure largely intact', 'Removing all trees', 'Removing trees in a single block', 'Removing only dead trees'], 0,
         'Selective logging is a more sustainable alternative to clear‑cutting.'),
        ('Which tree species is native to the Amazon rainforest?',
         ARRAY['Mahogany and Brazil nut tree', 'Pine', 'Oak', 'Maple'], 0,
         'The Amazon is home to thousands of tree species.'),
        ('What is "agroforestry"?',
         ARRAY['Integrating trees with agricultural crops and livestock', 'Planting only trees on farmland', 'Replacing agriculture with forests', 'Planting only food crops'], 0,
         'Agroforestry improves soil health and biodiversity.'),
        ('Which product is derived from tree sap?',
         ARRAY['Maple syrup, rubber, and resin', 'Oil', 'Coal', 'Natural gas'], 0,
         'Tree sap yields many valuable products.'),
        ('What is the role of forest fire in forest ecology?',
         ARRAY['It can be a natural part of many ecosystems, promoting regeneration', 'It is always destructive', 'It eliminates all wildlife', 'It has no role'], 0,
         'Some ecosystems depend on periodic fires for regeneration.'),
        ('Which certification is for sustainable forest products?',
         ARRAY['FSC (Forest Stewardship Council)', 'LEED', 'ISO 9001', 'Organic certification'], 0,
         'FSC certification ensures responsible forest management.'),
        ('What is the primary cause of deforestation in the Amazon?',
         ARRAY['Agriculture (cattle ranching and soybean farming)', 'Urbanisation', 'Mining', 'Timber extraction alone'], 0,
         'Agriculture is the leading driver of Amazon deforestation.'),
        ('Which forest type is known as the "lungs of the Earth"?',
         ARRAY['Amazon rainforest', 'Taiga (boreal forest)', 'Temperate forest', 'Mangrove forests'], 0,
         'The Amazon produces about 20% of the world''s oxygen.'),
        ('What is "wood pellet" used for?',
         ARRAY['Bioenergy and heating fuel', 'Paper production', 'Building materials', 'Furniture'], 0,
         'Wood pellets are a renewable energy source.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_forestry, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 7. LOGISTICS (18 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is logistics?',
         ARRAY['The management of the flow of goods, services, and information from origin to consumption', 'The manufacturing of goods', 'The retail sale of goods', 'The marketing of products'], 0,
         'Logistics is a key part of supply chain management.'),
        ('What is a supply chain?',
         ARRAY['The network of organisations and activities involved in producing and delivering a product', 'The manufacturing process only', 'The retail process only', 'The distribution process only'], 0,
         'Supply chains include suppliers, manufacturers, distributors, and retailers.'),
        ('Which mode of transport is most commonly used for international trade?',
         ARRAY['Shipping (maritime transport)', 'Air freight', 'Rail', 'Road'], 0,
         'Maritime shipping carries about 80% of global trade by volume.'),
        ('What is "inventory management"?',
         ARRAY['The oversight of stock levels, ordering, and storage of goods', 'The marketing of products', 'The manufacturing of products', 'The transportation of goods'], 0,
         'Inventory management balances supply and demand.'),
        ('Which logistics term describes the movement of goods from a distribution center to the final customer?',
         ARRAY['Last‑mile delivery', 'First‑mile delivery', 'Cross‑docking', 'Freight forwarding'], 0,
         'Last‑mile delivery is the final stage of logistics.'),
        ('What is a "warehouse" used for?',
         ARRAY['To store goods before distribution or sale', 'To manufacture products', 'To sell products', 'To dispose of waste'], 0,
         'Warehouses are essential for storage and consolidation.'),
        ('Which logistics technology is used for tracking goods?',
         ARRAY['GPS and RFID', 'Radio only', 'Television', 'Satellite phones'], 0,
         'RFID and GPS enable real‑time tracking of shipments.'),
        ('What is "freight forwarding"?',
         ARRAY['The coordination of the transportation of goods on behalf of shippers', 'The driving of trucks', 'The storage of goods', 'The selling of goods'], 0,
         'Freight forwarders arrange transport and customs clearance.'),
        ('Which city has the busiest port in the world?',
         ARRAY['Shanghai, China', 'Singapore', 'Rotterdam', 'Los Angeles'], 0,
         'Shanghai is the world''s busiest container port.'),
        ('What is "just‑in‑time" (JIT) delivery?',
         ARRAY['A logistics strategy that delivers goods exactly when they are needed', 'A strategy to hold large inventories', 'A strategy to delay deliveries', 'A strategy to use only air freight'], 0,
         'JIT minimises inventory holding costs.'),
        ('Which mode of transport is fastest but most expensive?',
         ARRAY['Air freight', 'Maritime shipping', 'Rail', 'Road'], 0,
         'Air freight is used for high‑value, time‑sensitive goods.'),
        ('What is "reverse logistics"?',
         ARRAY['The process of managing returns, repairs, and recycling of products', 'The forward movement of goods', 'The marketing of products', 'The manufacturing of products'], 0,
         'Reverse logistics handles product returns and waste management.'),
        ('Which logistics function involves customs clearance?',
         ARRAY['International trade logistics', 'Domestic distribution', 'Warehousing', 'Inventory management'], 0,
         'Customs clearance is essential for cross‑border trade.'),
        ('What is "fulfilment center" in e‑commerce logistics?',
         ARRAY['A facility that stores, packs, and ships online orders', 'A retail store', 'A manufacturing plant', 'A corporate office'], 0,
         'Fulfilment centers are critical for online retail.'),
        ('Which logistics company is known for global parcel delivery?',
         ARRAY['DHL, FedEx, UPS', 'Maersk', 'ExxonMobil', 'Walmart'], 0,
         'These companies are leaders in express delivery.'),
        ('What is "intermodal transport"?',
         ARRAY['Using multiple modes of transport (e.g., ship, rail, truck) for a single shipment', 'Using only one mode', 'Using only air and road', 'Using only rail and road'], 0,
         'Intermodal transport is efficient for long‑distance freight.'),
        ('What is the role of a logistics manager?',
         ARRAY['To plan, coordinate, and optimise the movement of goods', 'To drive trucks', 'To sell products', 'To manufacture products'], 0,
         'Logistics managers oversee supply chain operations.'),
        ('Which factor is most important in logistics efficiency?',
         ARRAY['Optimising routes, reducing delays, and minimising costs', 'Using the most expensive transport', 'Holding large inventories', 'Ignoring customer needs'], 0,
         'Efficiency reduces costs and improves service.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_logistics, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 8. RETAIL (19 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is retail?',
         ARRAY['The sale of goods or services to consumers for personal use', 'The wholesale sale of goods', 'The manufacturing of goods', 'The distribution of goods'], 0,
         'Retail is the final stage of the supply chain.'),
        ('Which retail format sells a wide variety of goods at low prices?',
         ARRAY['Big‑box store or hypermarket', 'Specialty store', 'Convenience store', 'Online retailer'], 0,
         'Big‑box retailers like Walmart offer a wide range at competitive prices.'),
        ('What is e‑commerce?',
         ARRAY['The buying and selling of goods and services over the internet', 'The sale of goods in physical stores', 'The wholesale trade', 'The marketing of products'], 0,
         'E‑commerce has grown rapidly with the rise of the internet.'),
        ('Which retailer is the largest in the world by revenue?',
         ARRAY['Walmart', 'Amazon', 'Costco', 'Aldi'], 0,
         'Walmart consistently ranks as the largest retailer globally.'),
        ('What is "omni‑channel retail"?',
         ARRAY['An integrated strategy that combines physical stores, online, and mobile channels', 'A strategy that uses only online channels', 'A strategy that uses only physical stores', 'A strategy that uses only mobile apps'], 0,
         'Omni‑channel retail provides a seamless customer experience.'),
        ('Which retail format is open long hours and sells convenience items?',
         ARRAY['Convenience store', 'Big‑box store', 'Specialty store', 'Warehouse club'], 0,
         'Convenience stores are often open 24/7.'),
        ('What is "shrinkage" in retail?',
         ARRAY['Loss of inventory due to theft, damage, or errors', 'An increase in sales', 'The growth of the store', 'The number of employees'], 0,
         'Shrinkage is a major concern for retailers.'),
        ('What is a "pop‑up shop"?',
         ARRAY['A temporary retail space that opens for a limited time', 'A permanent store', 'An online store', 'A wholesale outlet'], 0,
         'Pop‑up shops create buzz and test new markets.'),
        ('Which factor is most important in retail location?',
         ARRAY['Foot traffic and accessibility', 'The colour of the building', 'The size of the parking lot', 'The age of the building'], 0,
         'Location is a key driver of retail success.'),
        ('What is "merchandising" in retail?',
         ARRAY['The promotion and presentation of products to encourage sales', 'The manufacturing of products', 'The distribution of products', 'The accounting of sales'], 0,
         'Merchandising includes pricing, display, and assortment.'),
        ('Which retail strategy involves offering products at a discount to attract customers?',
         ARRAY['Sale or promotional pricing', 'Luxury pricing', 'Premium pricing', 'Price skimming'], 0,
         'Sales promotions drive foot traffic and clear inventory.'),
        ('What is the role of a supply chain in retail?',
         ARRAY ['To ensure products are available when and where customers want them', 'To only manufacture products', 'To only sell products', 'To only advertise products'], 0,
         'An efficient supply chain is critical for retail success.'),
        ('Which country has the highest e‑commerce penetration?',
         ARRAY['South Korea and China', 'United States', 'United Kingdom', 'Germany'], 0,
         'South Korea and China have very high e‑commerce adoption.'),
        ('What is "private label" or "store brand"?',
         ARRAY['A product manufactured for a retailer and sold under the retailer''s brand', 'A product sold by a third party', 'A luxury product', 'A discontinued product'], 0,
         'Private labels often offer better margins for retailers.'),
        ('Which retail metric measures sales per square foot?',
         ARRAY['Sales per square foot (productivity)', 'Gross margin', 'Inventory turnover', 'Customer satisfaction'], 0,
         'Sales per square foot is a key performance indicator for physical retail.'),
        ('What is "customer loyalty" in retail?',
         ARRAY['The tendency of customers to continue purchasing from a particular retailer', 'The tendency to try new retailers', 'The tendency to buy only discounted items', 'The tendency to buy online'], 0,
         'Loyalty programs and excellent service build customer loyalty.'),
        ('Which retail channel is growing fastest worldwide?',
         ARRAY['Online (e‑commerce)', 'Physical stores', 'Catalog sales', 'Direct mail'], 0,
         'E‑commerce growth outpaces brick‑and‑mortar retail.'),
        ('What is the "customer journey" in retail?',
         ARRAY['The entire experience a customer has with a brand, from awareness to purchase', 'The process of returning a product', 'The marketing campaign', 'The supply chain process'], 0,
         'The customer journey includes all touchpoints.'),
        ('Which type of retailer sells directly to consumers without intermediaries?',
         ARRAY['Direct‑to‑consumer (D2C) brands', 'Wholesalers', 'Distributors', 'Franchisees'], 0,
         'D2C brands have gained popularity by eliminating middlemen.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_retail, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 9. TELECOMMUNICATIONS (19 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is telecommunications?',
         ARRAY['The transmission of information over distances using electronic or optical means', 'The manufacturing of phones', 'The sale of phones', 'The broadcasting of radio'], 0,
         'Telecommunications includes voice, data, and video transmission.'),
        ('Which technology is the foundation of modern telecommunications?',
         ARRAY['Fibre optics and wireless networks', 'Telegraph', 'Pigeon post', 'Smoke signals'], 0,
         'Fibre optics and wireless are the backbone of modern telecoms.'),
        ('What does "5G" stand for?',
         ARRAY['Fifth generation of mobile network technology', 'Five‑Gigabit network', 'Fifth generation of Wi‑Fi', 'Global network standard'], 0,
         '5G offers high speed, low latency, and massive connectivity.'),
        ('Which company is the world''s largest telecom equipment provider?',
         ARRAY['Huawei', 'Ericsson', 'Nokia', 'Cisco'], 0,
         'Huawei and Ericsson are leading suppliers of telecom equipment.'),
        ('What is a "fibre‑optic cable"?',
         ARRAY ['A cable that uses light pulses to transmit data over long distances', 'A copper cable', 'A wireless signal', 'A satellite link'], 0,
         'Fibre optics offer high bandwidth and low loss.'),
        ('Which organisation standardises global telecommunications?',
         ARRAY['ITU (International Telecommunication Union)', 'ISO', 'IEEE', 'WTO'], 0,
         'The ITU is a UN agency for information and communication technologies.'),
        ('What is "latency" in telecommunications?',
         ARRAY['The delay between sending and receiving data', 'The speed of data transmission', 'The amount of data transferred', 'The strength of the signal'], 0,
         'Low latency is critical for applications like gaming and video calls.'),
        ('Which technology allows multiple devices to connect wirelessly to the internet?',
         ARRAY['Wi‑Fi', 'Ethernet', 'Fibre optics', 'Satellite'], 0,
         'Wi‑Fi is the most common wireless local area network.'),
        ('What does "broadband" mean?',
         ARRAY['High‑speed internet access', 'Narrowband', 'Dial‑up', 'Satellite internet'], 0,
         'Broadband provides fast, always‑on internet connectivity.'),
        ('Which country has the fastest average internet speed?',
         ARRAY['South Korea', 'United States', 'United Kingdom', 'Japan'], 0,
         'South Korea consistently ranks among the fastest broadband speeds.'),
        ('What is a "satellite" used for in telecommunications?',
         ARRAY['To relay signals for communication over long distances', 'To only broadcast TV', 'To only provide internet in remote areas', 'To only take photos'], 0,
         'Satellites are used for telephony, broadcasting, and internet.'),
        ('Which telecommunications protocol is used for the internet?',
         ARRAY['TCP/IP', 'HTTP', 'FTP', 'SMTP'], 0,
         'TCP/IP is the foundational protocol suite of the internet.'),
        ('What is "VoIP" (Voice over IP)?',
         ARRAY['A technology that allows voice calls over the internet', 'A type of video call', 'A text messaging service', 'A type of email'], 0,
         'VoIP services include Skype, Zoom, and WhatsApp.'),
        ('What is the purpose of a "router" in telecommunications?',
         ARRAY['To direct data packets between networks', 'To transmit signals wirelessly', 'To amplify signals', 'To store data'], 0,
         'Routers are essential for network connectivity.'),
        ('Which technology is used for short‑range wireless communication?',
         ARRAY['Bluetooth and NFC', 'Wi‑Fi', '5G', 'Satellite'], 0,
         'Bluetooth and NFC are used for close‑range connections.'),
        ('What is "cloud computing" in telecommunications?',
         ARRAY['Delivery of computing services over the internet', 'Physical storage on hard drives', 'Local network storage', 'Satellite transmission'], 0,
         'Cloud computing relies on robust telecommunications infrastructure.'),
        ('Which sector consumes the most telecom bandwidth?',
         ARRAY['Video streaming and cloud services', 'Voice calls', 'Text messages', 'Email'], 0,
         'Video streaming (e.g., Netflix, YouTube) accounts for the majority of traffic.'),
        ('What is the role of the "Internet of Things" (IoT)?',
         ARRAY['Connecting everyday devices to the internet for data exchange', 'Connecting only phones', 'Connecting only computers', 'Connecting only sensors'], 0,
         'IoT includes smart homes, wearables, and industrial sensors.'),
        ('Which telecom technology is expected to revolutionise industry and society?',
         ARRAY['5G and future 6G networks', '3G', '4G', 'Wi‑Fi only'], 0,
         '5G enables new applications like autonomous vehicles and smart cities.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_telecom, q_rec.column1, 'single_choice', q_rec.column4)
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