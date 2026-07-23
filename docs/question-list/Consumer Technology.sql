-- ============================================================================
-- Insert 130 factual questions on Consumer Technology.
-- Subtopics: Smartphones, Tablets, Computers, Smart Homes, Wearables,
-- Cameras, Audio Equipment, Gaming Consoles.
-- ============================================================================

DO $$
DECLARE
    cat_id_smartphones   BIGINT;
    cat_id_tablets       BIGINT;
    cat_id_computers     BIGINT;
    cat_id_smart_homes   BIGINT;
    cat_id_wearables     BIGINT;
    cat_id_cameras       BIGINT;
    cat_id_audio         BIGINT;
    cat_id_gaming        BIGINT;
    q_id                 BIGINT;
    correct_opt_id       BIGINT;
    opt_texts            TEXT[];
    q_rec                RECORD;
BEGIN
    -- ------------------------------------------------------------------------
    -- Create categories (hierarchical under consumer_technology)
    -- ------------------------------------------------------------------------
    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('consumer_technology', 'Consumer Technology', 3, 0)
        ON CONFLICT (path) DO NOTHING;

    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('consumer_technology.smartphones',        'Smartphones', 0, 1),
        ('consumer_technology.tablets',            'Tablets', 3, 2),
        ('consumer_technology.computers',          'Computers', 0, 3),
        ('consumer_technology.smart_homes',        'Smart Homes', 3, 4),
        ('consumer_technology.wearables',          'Wearables', 3, 5),
        ('consumer_technology.cameras',            'Cameras', 3, 6),
        ('consumer_technology.audio_equipment',    'Audio Equipment', 3, 7),
        ('consumer_technology.gaming_consoles',    'Gaming Consoles', 3, 8)
        ON CONFLICT (path) DO NOTHING;

    -- Get category IDs
    SELECT id INTO cat_id_smartphones FROM categories WHERE path = 'consumer_technology.smartphones';
    SELECT id INTO cat_id_tablets     FROM categories WHERE path = 'consumer_technology.tablets';
    SELECT id INTO cat_id_computers   FROM categories WHERE path = 'consumer_technology.computers';
    SELECT id INTO cat_id_smart_homes FROM categories WHERE path = 'consumer_technology.smart_homes';
    SELECT id INTO cat_id_wearables   FROM categories WHERE path = 'consumer_technology.wearables';
    SELECT id INTO cat_id_cameras     FROM categories WHERE path = 'consumer_technology.cameras';
    SELECT id INTO cat_id_audio       FROM categories WHERE path = 'consumer_technology.audio_equipment';
    SELECT id INTO cat_id_gaming      FROM categories WHERE path = 'consumer_technology.gaming_consoles';

    -- ========================================================================
    -- 1. SMARTPHONES (17 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Which company released the first commercially available smartphone?',
         ARRAY['IBM (Simon Personal Communicator)', 'Apple', 'Nokia', 'BlackBerry'], 0,
         'The IBM Simon was released in 1994, featuring a touchscreen and basic apps.'),
        ('What does "OLED" stand for?',
         ARRAY['Organic Light‑Emitting Diode', 'Optical Liquid Emitting Display', 'Organic Liquid Emitting Diode', 'Optical Light‑Emitting Display'], 0,
         'OLED displays are known for vibrant colours and deep blacks.'),
        ('What is the most common operating system for smartphones?',
         ARRAY['Android and iOS', 'Windows Phone', 'BlackBerry OS', 'Symbian'], 0,
         'Android and iOS dominate the global smartphone market.'),
        ('Which company manufactures the iPhone?',
         ARRAY['Apple Inc.', 'Samsung', 'Google', 'OnePlus'], 0,
         'Apple introduced the first iPhone in 2007.'),
        ('What is 5G technology?',
         ARRAY['The fifth generation of cellular network technology', 'The fifth version of GPS', 'The fifth generation of Wi‑Fi', 'The fifth version of Bluetooth'], 0,
         '5G offers higher speeds, lower latency, and greater capacity than 4G.'),
        ('What is the typical storage unit for smartphone internal memory?',
         ARRAY['Gigabytes (GB) and Terabytes (TB)', 'Megabytes (MB)', 'Kilobytes (KB)', 'Petabytes (PB)'], 0,
         'Most modern phones have 64GB to 1TB of internal storage.'),
        ('What is the purpose of a smartphone''s gyroscope?',
         ARRAY['To detect orientation and rotation for motion‑sensitive apps', 'To measure temperature', 'To measure altitude', 'To detect magnetic fields'], 0,
         'Gyroscopes enable features like screen rotation and motion‑based games.'),
        ('Which technology is used for wireless charging in smartphones?',
         ARRAY['Qi (inductive charging)', 'USB‑C', 'Bluetooth', 'NFC'], 0,
         'Qi is the standard for wireless charging, used by many brands.'),
        ('What does the abbreviation "RAM" stand for?',
         ARRAY['Random Access Memory', 'Read‑Only Memory', 'Random Application Memory', 'Rapid Access Module'], 0,
         'RAM is used for temporary data storage while apps are running.'),
        ('Which company produces the Galaxy series of smartphones?',
         ARRAY['Samsung', 'Google', 'Huawei', 'Xiaomi'], 0,
         'Samsung''s Galaxy line includes the S, Z Fold, and Z Flip series.'),
        ('What is the function of a smartphone''s proximity sensor?',
         ARRAY['To turn off the screen during calls when held near the ear', 'To measure distance to the user', 'To detect fingerprints', 'To measure ambient light'], 0,
         'Proximity sensors prevent accidental touches during calls.'),
        ('What is IP68 rating?',
         ARRAY['Dust‑tight and waterproof beyond 1 metre for 30 minutes', 'Water‑resistant up to 1 metre', 'Dust‑proof only', 'Water‑proof only'], 0,
         'IP68 means the device is protected against dust and can withstand immersion.'),
        ('What is NFC used for on smartphones?',
         ARRAY['Contactless payments and data transfer', 'Wi‑Fi connection', 'Bluetooth pairing', 'GPS navigation'], 0,
         'NFC (Near‑Field Communication) enables mobile payments like Google Pay and Apple Pay.'),
        ('Which operating system was developed by Google?',
         ARRAY['Android', 'iOS', 'HarmonyOS', 'Tizen'], 0,
         'Android is based on the Linux kernel and was acquired by Google in 2005.'),
        ('What is the "notch" on some smartphones?',
         ARRAY['A cutout at the top of the display for sensors and camera', 'A physical button', 'A charging port', 'A speaker grille'], 0,
         'The notch houses the front camera and sensors, allowing for a larger screen.'),
        ('What is the average battery life of a modern smartphone?',
         ARRAY['1 to 2 days with moderate use', 'Less than 6 hours', 'Over 1 week', '3 to 4 days'], 0,
         'Most smartphones can last a full day and often two days with moderate usage.'),
        ('What is the purpose of a smartphone''s accelerometer?',
         ARRAY['To detect movement and tilt for screen rotation and fitness tracking', 'To detect a fingerprint', 'To measure heart rate', 'To detect ambient light'], 0,
         'Accelerometers are used for step counting, auto‑rotate, and gaming.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_smartphones, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 2. TABLETS (16 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What company introduced the iPad?',
         ARRAY['Apple', 'Samsung', 'Microsoft', 'Amazon'], 0,
         'Apple released the first iPad in 2010.'),
        ('What is a tablet?',
         ARRAY['A portable device with a touchscreen, larger than a smartphone but smaller than a laptop', 'A device with a physical keyboard', 'A device that runs only desktop software', 'A device with no screen'], 0,
         'Tablets are designed for media consumption, web browsing, and productivity.'),
        ('Which operating system is most commonly used on tablets?',
         ARRAY['iPadOS, Android, and Windows', 'macOS', 'Linux', 'Chrome OS'], 0,
         'Apple uses iPadOS, while many others use Android or Windows.'),
        ('What is the main advantage of a tablet over a smartphone?',
         ARRAY['Larger screen for better viewing and productivity', 'Better battery life', 'More storage', 'Better cameras'], 0,
         'The larger screen enhances reading, drawing, and multitasking.'),
        ('What is the primary input method for a tablet?',
         ARRAY['Touchscreen and stylus (optional)', 'Keyboard only', 'Mouse only', 'Voice only'], 0,
         'Most tablets use a touchscreen interface, with optional stylus support.'),
        ('Which company produces the Galaxy Tab?',
         ARRAY['Samsung', 'Apple', 'Huawei', 'Lenovo'], 0,
         'Samsung''s Galaxy Tab is a major competitor to the iPad.'),
        ('What is a "2‑in‑1" tablet?',
         ARRAY['A tablet that can also function as a laptop with a detachable keyboard', 'A tablet that folds in half', 'A tablet with two screens', 'A tablet with dual‑boot capability'], 0,
         '2‑in‑1 devices combine the portability of a tablet with the functionality of a laptop.'),
        ('What is the typical screen size range for tablets?',
         ARRAY['7 to 13 inches', '4 to 6 inches', '15 to 20 inches', '20 to 30 inches'], 0,
         'Most tablets range from compact 7‑inch models to large 13‑inch models.'),
        ('Which tablet is designed for note‑taking with a stylus?',
         ARRAY['iPad with Apple Pencil and Samsung Galaxy Tab with S Pen', 'Kindle Fire', 'Google Nexus', 'Asus Transformer'], 0,
         'These tablets offer stylus support for writing and drawing.'),
        ('What is the Kindle Fire?',
         ARRAY['An Amazon tablet designed for media consumption and shopping', 'An Apple tablet', 'A Samsung tablet', 'A Google tablet'], 0,
         'The Kindle Fire is known for its low cost and integration with Amazon services.'),
        ('Which tablet runs on Microsoft Windows?',
         ARRAY['Microsoft Surface', 'iPad', 'Galaxy Tab', 'Lenovo Yoga'], 0,
         'The Microsoft Surface Pro runs full Windows, functioning as a laptop replacement.'),
        ('What is the typical battery life of a tablet?',
         ARRAY['8 to 12 hours', '2 to 4 hours', '20 to 30 hours', '50 hours'], 0,
         'Tablets generally offer all‑day battery life for media and productivity.'),
        ('What is the purpose of a tablet''s "do not disturb" mode?',
         ARRAY['To mute notifications and calls during specific times', 'To turn off the screen', 'To disable Wi‑Fi', 'To enable airplane mode'], 0,
         'Do Not Disturb mode prevents interruptions during work, school, or sleep.'),
        ('What is the most common port for charging tablets?',
         ARRAY['USB‑C or Lightning', 'USB‑A', 'HDMI', 'Ethernet'], 0,
         'USB‑C is becoming the standard; Apple uses Lightning for some models.'),
        ('Which tablet is known for its high‑resolution display for graphic design?',
         ARRAY['iPad Pro and Samsung Galaxy Tab S series', 'Kindle Fire', 'Asus ZenPad', 'Lenovo Tab'], 0,
         'These tablets feature high refresh rates and colour‑accurate displays.'),
        ('What is a stylus used for on a tablet?',
         ARRAY['For precise input, drawing, and note‑taking', 'For playing games', 'For making calls', 'For charging'], 0,
         'Styluses improve precision for artists, students, and professionals.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_tablets, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 3. COMPUTERS (17 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the main component of a computer that processes data?',
         ARRAY['CPU (Central Processing Unit)', 'GPU', 'RAM', 'Hard drive'], 0,
         'The CPU is the "brain" of the computer, executing instructions.'),
        ('What does RAM stand for?',
         ARRAY['Random Access Memory', 'Read‑Only Memory', 'Rapid Application Memory', 'Real‑time Access Module'], 0,
         'RAM is used for temporary data storage while the computer is running.'),
        ('What is the typical unit for computer hard drive storage?',
         ARRAY['Gigabytes (GB) and Terabytes (TB)', 'Megabytes (MB)', 'Kilobytes (KB)', 'Petabytes (PB)'], 0,
         'Hard drives range from 256GB to 20TB.'),
        ('What is the difference between HDD and SSD?',
         ARRAY['HDD is mechanical (spinning disks); SSD is solid‑state (faster, no moving parts)', 'SSD is mechanical; HDD is solid‑state', 'Both are mechanical', 'Both are solid‑state'], 0,
         'SSDs are much faster and more reliable than HDDs.'),
        ('Which company produces Windows operating system?',
         ARRAY['Microsoft', 'Apple', 'Google', 'IBM'], 0,
         'Microsoft Windows is the most widely used desktop OS.'),
        ('What is the role of the GPU?',
         ARRAY['To render graphics and perform parallel computations', 'To manage memory', 'To process general tasks', 'To connect to the internet'], 0,
         'GPUs are essential for gaming, video editing, and AI workloads.'),
        ('What is the most common port for connecting a monitor?',
         ARRAY['HDMI and DisplayPort', 'USB‑A', 'Ethernet', '3.5mm audio'], 0,
         'HDMI and DisplayPort are standard video connectors.'),
        ('Which computer is known as a "laptop"?',
         ARRAY['A portable computer with a built‑in keyboard and screen', 'A desktop computer', 'A tablet', 'A server'], 0,
         'Laptops are designed for mobility and battery operation.'),
        ('What is a desktop computer?',
         ARRAY['A stationary computer with separate monitor, keyboard, and tower', 'A portable computer', 'A tablet with a keyboard', 'A mini‑computer'], 0,
         'Desktops are often more powerful and upgradable than laptops.'),
        ('What is the role of an operating system?',
         ARRAY['To manage hardware and software resources for the computer', 'To process data', 'To store files', 'To connect to networks'], 0,
         'OS examples: Windows, macOS, Linux, Chrome OS.'),
        ('What is a Wi‑Fi network used for in computing?',
         ARRAY['To connect devices wirelessly to the internet and each other', 'To charge devices', 'To display images', 'To play audio'], 0,
         'Wi‑Fi is the most common wireless networking standard.'),
        ('Which company produces the Mac?',
         ARRAY['Apple', 'Microsoft', 'Dell', 'Lenovo'], 0,
         'Apple''s Mac lineup includes laptops and desktops running macOS.'),
        ('What is cloud computing?',
         ARRAY['Storing and accessing data and programs over the internet', 'Storing data on a local hard drive', 'Using a physical server', 'Using a USB drive'], 0,
         'Cloud computing enables remote storage and on‑demand access.'),
        ('What is the function of a router?',
         ARRAY['To direct network traffic between devices and the internet', 'To store files', 'To print documents', 'To display graphics'], 0,
         'Routers connect multiple devices to a single internet connection.'),
        ('What is an Ethernet cable used for?',
         ARRAY['To provide a wired network connection to a computer', 'To charge a laptop', 'To connect a monitor', 'To play audio'], 0,
         'Ethernet provides a stable and high‑speed internet connection.'),
        ('What is the typical screen size for a laptop?',
         ARRAY['13 to 17 inches', '7 to 12 inches', '18 to 24 inches', '24 to 32 inches'], 0,
         'Laptops range from compact ultra‑portables to larger workstation models.'),
        ('What is a graphics card used for?',
         ARRAY['To process and render images, videos, and 3D graphics', 'To manage memory', 'To connect to the internet', 'To store files'], 0,
         'Graphics cards (GPUs) are essential for gaming and creative work.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_computers, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 4. SMART HOMES (16 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is a smart home?',
         ARRAY['A home equipped with internet‑connected devices for automation and remote control', 'A home with solar panels', 'A home with a security system', 'A home with a smart TV'], 0,
         'Smart home devices include thermostats, lights, locks, and speakers.'),
        ('Which voice assistant is made by Amazon?',
         ARRAY['Alexa', 'Google Assistant', 'Siri', 'Bixby'], 0,
         'Alexa powers Amazon''s Echo smart speakers and many smart home devices.'),
        ('What is Google''s smart home assistant called?',
         ARRAY['Google Assistant', 'Alexa', 'Siri', 'Bixby'], 0,
         'Google Assistant is available on Nest devices and Android phones.'),
        ('Which smart home protocol operates on a mesh network?',
         ARRAY['Zigbee and Z‑Wave', 'Wi‑Fi', 'Bluetooth', 'Thread'], 0,
         'Zigbee and Z‑Wave are mesh protocols optimised for smart home devices.'),
        ('What is a smart thermostat?',
         ARRAY['A device that automatically adjusts heating and cooling for energy efficiency', 'A device that controls lights', 'A device that locks doors', 'A device that plays music'], 0,
         'Nest and Ecobee are popular smart thermostat brands.'),
        ('What is the purpose of a smart lock?',
         ARRAY['To enable remote locking and unlocking of doors', 'To control lights', 'To adjust the thermostat', 'To play music'], 0,
         'Smart locks can be controlled via smartphone, voice, or keypad.'),
        ('Which device is used to control lights, plugs, and appliances remotely?',
         ARRAY['Smart bulbs and smart plugs', 'Smart TV', 'Smart speaker', 'Smart thermostat'], 0,
         'Smart plugs allow any appliance to be controlled remotely.'),
        ('What is the role of a smart speaker?',
         ARRAY['To play audio and enable voice control of other smart devices', 'To control the thermostat only', 'To lock doors', 'To monitor security cameras'], 0,
         'Smart speakers are hubs for voice‑controlled home automation.'),
        ('What is HomeKit?',
         ARRAY['Apple''s smart home platform for controlling compatible devices', 'Google''s smart home platform', 'Amazon''s smart home platform', 'Samsung''s smart home platform'], 0,
         'HomeKit allows users to control HomeKit‑enabled devices via iOS.'),
        ('What is the purpose of a smart security camera?',
         ARRAY['To monitor and record video of the home, accessible remotely', 'To play music', 'To control lights', 'To adjust the thermostat'], 0,
         'Smart cameras provide live streaming, motion detection, and cloud storage.'),
        ('What is the main communication standard for many smart home devices?',
         ARRAY['Wi‑Fi and Zigbee', 'Ethernet', 'USB‑C', 'HDMI'], 0,
         'Wi‑Fi is common, while Zigbee is used for low‑power devices.'),
        ('What is the Matter standard?',
         ARRAY['A new connectivity standard for smart home interoperability', 'A type of speaker', 'A smart lock brand', 'A smart display'], 0,
         'Matter aims to simplify compatibility between brands.'),
        ('What is a smart plug used for?',
         ARRAY['To turn any device on or off remotely via an app or voice', 'To charge a phone', 'To play music', 'To measure energy usage only'], 0,
         'Smart plugs are an affordable entry into home automation.'),
        ('Which feature allows a smart home to learn user habits?',
         ARRAY['Machine learning and artificial intelligence', 'Manual programming', 'Remote control only', 'Voice commands only'], 0,
         'Smart thermostats and lighting systems use AI to optimise schedules.'),
        ('What is the purpose of a smart doorbell?',
         ARRAY['To show who is at the door via video and enable two‑way audio', 'To play music', 'To control the lights', 'To adjust the temperature'], 0,
         'Smart doorbells like Ring allow remote viewing and communication.'),
        ('What is the benefit of a smart home hub?',
         ARRAY['To centralise control of multiple smart devices from different brands', 'To control a single device', 'To play music', 'To display photos'], 0,
         'Hubs like SmartThings and Hubitat enable integration and automation.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_smart_homes, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 5. WEARABLES (16 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What are wearables?',
         ARRAY['Electronic devices that can be worn on the body, often for health and fitness tracking', 'Devices worn on a desk', 'Devices that are not portable', 'Devices that are implanted'], 0,
         'Common wearables include smartwatches, fitness trackers, and smart glasses.'),
        ('Which company produces the Apple Watch?',
         ARRAY['Apple', 'Samsung', 'Fitbit', 'Garmin'], 0,
         'Apple Watch is the best‑selling smartwatch globally.'),
        ('What is the primary function of a fitness tracker?',
         ARRAY['To monitor physical activity, heart rate, and sleep patterns', 'To play music', 'To make calls', 'To send messages'], 0,
         'Fitness trackers help users monitor their health and fitness goals.'),
        ('Which wearable is often used for navigation and outdoor activities?',
         ARRAY['Garmin (smartwatches and GPS watches)', 'Apple Watch', 'Fitbit', 'Samsung Galaxy Watch'], 0,
         'Garmin is known for GPS‑enabled devices for running, cycling, and hiking.'),
        ('What is a smartwatch?',
         ARRAY['A wearable device that offers smartphone features like notifications and apps', 'A device that only tells time', 'A device that is always offline', 'A device that only tracks steps'], 0,
         'Smartwatches connect to a smartphone for calls, messages, and apps.'),
        ('Which wearable is designed for virtual reality?',
         ARRAY['VR headsets like Oculus and HTC Vive', 'Smartwatches', 'Fitness trackers', 'Smart glasses'], 0,
         'VR headsets provide immersive virtual environments for gaming and training.'),
        ('What is augmented reality (AR) in wearables?',
         ARRAY['Digital overlay on the real world, viewed through devices like smart glasses', 'Fully virtual environments', 'Text messaging', 'Audio playback'], 0,
         'AR glasses like Google Glass and Vuzix display information in the user''s field of view.'),
        ('What is a typical battery life for a smartwatch?',
         ARRAY['1 to 2 days (depending on usage)', '10 to 20 hours', '1 month', '1 year'], 0,
         'Most smartwatches need daily or every‑other‑day charging.'),
        ('What is the purpose of a heart rate monitor in wearables?',
         ARRAY['To track the user''s heart rate during activity and rest', 'To track sleep only', 'To measure blood pressure', 'To measure oxygen levels'], 0,
         'Optical heart rate sensors use light to detect blood flow changes.'),
        ('Which company produces the Fitbit?',
         ARRAY['Google (formerly Fitbit Inc.)', 'Apple', 'Garmin', 'Samsung'], 0,
         'Google acquired Fitbit in 2021 for its fitness tracking technology.'),
        ('What is the main advantage of a wearable over a smartphone for fitness?',
         ARRAY['It is more convenient and continuously tracks metrics without being held', 'It has a larger screen', 'It has better battery life', 'It has more storage'], 0,
         'Wearables provide continuous, hands‑free monitoring.'),
        ('What is SPO2 monitoring in wearables?',
         ARRAY['Measuring blood oxygen saturation levels', 'Measuring heart rate', 'Measuring steps', 'Measuring calories'], 0,
         'SPO2 monitoring became popular during the COVID‑19 pandemic.'),
        ('What is the typical use of a chest‑worn heart rate monitor?',
         ARRAY['More accurate heart rate tracking for athletes during intense exercise', 'Daily step counting', 'Sleep tracking', 'GPS navigation'], 0,
         'Chest straps use ECG technology for higher accuracy.'),
        ('Which wearable is designed for children''s safety?',
         ARRAY['Smartwatches with GPS tracking and SOS features', 'Fitness trackers', 'VR headsets', 'Smart glasses'], 0,
         'Kids'' smartwatches allow parents to track location and communicate.'),
        ('What is a biometric sensor in wearables?',
         ARRAY['A sensor that measures physiological data like heart rate, ECG, or blood pressure', 'A camera', 'A microphone', 'A GPS sensor'], 0,
         'Biometric sensors are used for health monitoring and authentication.'),
        ('What is the purpose of sleep tracking in wearables?',
         ARRAY['To monitor sleep patterns, duration, and quality', 'To measure steps during sleep', 'To track heart rate only during sleep', 'To measure oxygen levels'], 0,
         'Sleep tracking can identify sleep stages and disturbances.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_wearables, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 6. CAMERAS (16 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What does the "f‑stop" on a camera lens refer to?',
         ARRAY['The aperture size (focal length divided by diameter)', 'The shutter speed', 'The ISO sensitivity', 'The focal length'], 0,
         'A lower f‑stop (e.g., f/1.8) indicates a wider aperture, allowing more light.'),
        ('What is a DSLR camera?',
         ARRAY['Digital Single‑Lens Reflex camera (uses a mirror to direct light to the viewfinder)', 'Digital Still Lens Reflex', 'Digital Single Lens Recording', 'Digital Sensor Lens Reflex'], 0,
         'DSLRs are known for high image quality and interchangeable lenses.'),
        ('What is a mirrorless camera?',
         ARRAY['A camera without a mirror mechanism, using an electronic viewfinder', 'A camera with a mirror', 'A camera with a fixed lens', 'A camera without a lens'], 0,
         'Mirrorless cameras are lighter and more compact than DSLRs.'),
        ('Which sensor size is larger: full‑frame or crop sensor?',
         ARRAY['Full‑frame (36x24mm)', 'Crop sensor (APS‑C)', 'Both are the same', 'Crop sensor is larger'], 0,
         'Full‑frame sensors are larger, offering better low‑light performance.'),
        ('What is the purpose of a camera''s shutter?',
         ARRAY['To control the duration of light exposure to the sensor', 'To control aperture', 'To adjust ISO', 'To autofocus'], 0,
         'Shutter speed determines how long the sensor is exposed to light.'),
        ('What is ISO in photography?',
         ARRAY['The camera''s sensitivity to light', 'The aperture size', 'The shutter speed', 'The focal length'], 0,
         'A higher ISO allows shooting in low light but increases noise.'),
        ('What is the main advantage of a prime lens?',
         ARRAY['Wider aperture and better sharpness compared to zoom lenses', 'Variable focal length', 'Lower weight', 'Cheaper price'], 0,
         'Prime lenses have a fixed focal length but often provide superior image quality.'),
        ('What is a "point and shoot" camera?',
         ARRAY['A compact camera with a fixed lens, designed for simplicity', 'A professional camera with interchangeable lenses', 'A camera for underwater use', 'A camera with a large sensor'], 0,
         'Point‑and‑shoot cameras are popular for casual photography.'),
        ('What is a "gimbal" used for in video?',
         ARRAY['To stabilise the camera and reduce shake', 'To hold the camera at a fixed angle', 'To attach a microphone', 'To control focus'], 0,
         'Gimbals use motors to maintain a steady shot while moving.'),
        ('What is a "hot shoe" on a camera?',
         ARRAY['A mount for attaching external flash units and accessories', 'A power connector', 'A battery slot', 'A memory card slot'], 0,
         'The hot shoe provides electrical contacts for triggering flashes.'),
        ('Which camera brand is known for its "L‑series" professional lenses?',
         ARRAY['Canon', 'Nikon', 'Sony', 'Fujifilm'], 0,
         'Canon''s L‑series lenses are renowned for their build quality and optical performance.'),
        ('What is a "raw" image file?',
         ARRAY['An unprocessed file containing all data captured by the camera sensor', 'A compressed image file', 'A video file', 'A type of lens'], 0,
         'RAW files allow more flexibility in post‑processing.'),
        ('What is autofocus?',
         ARRAY['The camera''s ability to automatically adjust the lens to achieve sharp focus', 'Manual focus', 'Fixed focus', 'Focus bracketing'], 0,
         'Modern cameras use phase‑detection and contrast‑detection AF.'),
        ('What is a "light meter" used for?',
         ARRAY['To measure the amount of light in a scene for proper exposure', 'To measure the distance to the subject', 'To measure colour temperature', 'To measure the size of the sensor'], 0,
         'Light meters help set the correct exposure settings.'),
        ('Which device is used to capture high‑quality video with a large sensor?',
         ARRAY['Cinema cameras and mirrorless/DSLRs with video capabilities', 'Point‑and‑shoot cameras', 'Action cameras', 'Webcams'], 0,
         'Large‑sensor cameras are used for professional video production.'),
        ('What is the most common memory card type for cameras?',
         ARRAY['SD (Secure Digital)', 'CF (CompactFlash)', 'MicroSD', 'Memory Stick'], 0,
         'SD cards are the standard for most consumer and pro cameras.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_cameras, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 7. AUDIO EQUIPMENT (16 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What are headphones?',
         ARRAY['A personal audio device worn over or in the ears', 'A device for recording audio', 'A device for amplifying sound', 'A device for mixing audio'], 0,
         'Headphones come in over‑ear, on‑ear, and in‑ear (earbuds) styles.'),
        ('What is the difference between open‑back and closed‑back headphones?',
         ARRAY['Open‑back allow sound leakage for a more natural soundstage; closed‑back isolate sound', 'Closed‑back leak sound; open‑back isolate', 'Both are the same', 'Open‑back are for recording only'], 0,
         'Open‑back headphones are preferred for critical listening; closed‑back for monitoring.'),
        ('What is a digital‑to‑analogue converter (DAC)?',
         ARRAY['A device that converts digital audio signals to analogue signals for speakers or headphones', 'A device that converts analogue to digital', 'A type of amplifier', 'A type of speaker'], 0,
         'DACs are essential for high‑quality audio playback.'),
        ('What is a soundbar?',
         ARRAY['A compact speaker system designed to improve TV audio', 'A portable speaker', 'A subwoofer', 'A pair of bookshelf speakers'], 0,
         'Soundbars are popular for home theatre setups.'),
        ('Which file format is known for lossless audio?',
         ARRAY['FLAC (Free Lossless Audio Codec)', 'MP3', 'AAC', 'WMA'], 0,
         'FLAC preserves all audio data without quality loss.'),
        ('What is the impedance of headphones?',
         ARRAY['The resistance to electrical current; higher impedance requires more power', 'The sensitivity of the headphones', 'The frequency response', 'The distortion level'], 0,
         'Low‑impedance headphones (16‑32Ω) can be driven by smartphones; high‑impedance (250Ω+) need headphone amplifiers.'),
        ('What is a subwoofer used for?',
         ARRAY['To reproduce low‑frequency sounds (bass)', 'To reproduce mid‑range frequencies', 'To reproduce high frequencies', 'To amplify audio signals'], 0,
         'Subwoofers add depth to music and movies.'),
        ('Which brand is famous for its noise‑cancelling headphones?',
         ARRAY['Sony (WH‑1000XM series) and Bose', 'Apple', 'Sennheiser', 'AKG'], 0,
         'Sony and Bose are leaders in active noise cancellation.'),
        ('What is active noise cancellation (ANC)?',
         ARRAY['The use of microphones and electronics to cancel ambient noise', 'The use of physical materials to block sound', 'A software effect', 'A type of microphone'], 0,
         'ANC improves the listening experience in noisy environments.'),
        ('What is a studio monitor?',
         ARRAY['A speaker designed for accurate, uncoloured sound reproduction in a studio', 'A regular speaker', 'A soundbar', 'A portable speaker'], 0,
         'Studio monitors are essential for audio production.'),
        ('What is the most common connector for wired headphones?',
         ARRAY['3.5mm audio jack', 'USB‑C', 'Lightning', '6.35mm jack'], 0,
         'The 3.5mm jack is the universal standard for wired headphones.'),
        ('What is a portable Bluetooth speaker?',
         ARRAY['A battery‑powered speaker that connects wirelessly via Bluetooth', 'A wired speaker', 'A soundbar', 'A studio monitor'], 0,
         'Bluetooth speakers are popular for outdoor and casual listening.'),
        ('What is the dynamic range of audio?',
         ARRAY['The difference between the loudest and quietest parts of a recording', 'The frequency range', 'The distortion level', 'The bitrate'], 0,
         'A wider dynamic range allows for more expressive audio.'),
        ('Which audio format is commonly used for streaming?',
         ARRAY['AAC and MP3 (compressed)', 'FLAC (lossless)', 'WAV', 'AIFF'], 0,
         'Streaming services use compressed formats to save bandwidth.'),
        ('What is a headphone amplifier?',
         ARRAY['A device that increases the power of the audio signal to drive high‑impedance headphones', 'A device that reduces audio power', 'A type of equaliser', 'A type of DAC'], 0,
         'Headphone amps improve sound quality with demanding headphones.'),
        ('What is a condenser microphone?',
         ARRAY['A microphone that requires external power and is sensitive to sound', 'A dynamic microphone', 'A ribbon microphone', 'A USB microphone'], 0,
         'Condenser mics are preferred for studio vocals and acoustic instruments.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_audio, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 8. GAMING CONSOLES (16 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Which company produces the PlayStation console?',
         ARRAY['Sony', 'Microsoft', 'Nintendo', 'Sega'], 0,
         'Sony''s PlayStation is one of the best‑selling console brands.'),
        ('Which company produces the Xbox console?',
         ARRAY['Microsoft', 'Sony', 'Nintendo', 'Sega'], 0,
         'Microsoft''s Xbox competes with PlayStation in the home console market.'),
        ('Which company produces the Nintendo Switch?',
         ARRAY['Nintendo', 'Sony', 'Microsoft', 'Sega'], 0,
         'The Switch is a hybrid console that can be used as a handheld or home console.'),
        ('What is the primary function of a gaming console?',
         ARRAY['To play video games on a TV or monitor', 'To stream movies only', 'To browse the internet only', 'To play music'], 0,
         'Consoles are specialised for gaming but also offer media features.'),
        ('What is the latest generation of PlayStation?',
         ARRAY['PlayStation 5 (PS5)', 'PlayStation 4 (PS4)', 'PlayStation 3 (PS3)', 'PlayStation 6 (PS6)'], 0,
         'The PS5 was released in 2020.'),
        ('What is the latest generation of Xbox?',
         ARRAY['Xbox Series X and Series S', 'Xbox One', 'Xbox 360', 'Xbox Series Z'], 0,
         'Xbox Series X and S were released in 2020.'),
        ('What is the handheld mode of the Nintendo Switch?',
         ARRAY['A mode where the console is used as a portable device with a built‑in screen', 'A mode where the console is docked to a TV', 'A mode where the console is connected to a PC', 'A mode where the console is offline'], 0,
         'The Switch can be played handheld, tabletop, or docked.'),
        ('What is a gaming controller?',
         ARRAY['A device used to control video games, typically with buttons and analog sticks', 'A type of game', 'A console accessory for streaming', 'A memory card'], 0,
         'Controllers are the primary input method for most consoles.'),
        ('Which accessory is used for immersive VR gaming on consoles?',
         ARRAY['PS VR2 (for PlayStation) and Xbox VR (rare)', 'A gaming mouse', 'A keyboard', 'A steering wheel'], 0,
         'VR headsets provide immersive gaming experiences.'),
        ('What is the main advantage of a gaming console over a PC?',
         ARRAY['Plug‑and‑play ease and exclusive game titles', 'Higher graphics settings', 'Better keyboard support', 'Easier upgradability'], 0,
         'Consoles are optimised for gaming and often have exclusive titles.'),
        ('Which game is a flagship exclusive for PlayStation?',
         ARRAY['God of War and The Last of Us', 'Halo', 'Zelda', 'Mario'], 0,
         'PlayStation has many highly acclaimed exclusive franchises.'),
        ('Which game is a flagship exclusive for Xbox?',
         ARRAY['Halo and Forza', 'God of War', 'Mario', 'Zelda'], 0,
         'Xbox exclusives include Halo, Forza, and Gears of War.'),
        ('Which game is a flagship exclusive for Nintendo?',
         ARRAY['Super Mario, Zelda, and Pokémon', 'Halo', 'God of War', 'Forza'], 0,
         'Nintendo''s exclusive titles are its major selling point.'),
        ('What is cloud gaming on consoles?',
         ARRAY['Playing games streamed from the cloud without downloading them', 'Playing games offline', 'Playing games on a PC', 'Playing games on a phone'], 0,
         'Xbox Cloud Gaming and PlayStation Now offer cloud streaming.'),
        ('What is the typical storage capacity of a modern console?',
         ARRAY['512GB to 1TB (expandable)', '100GB', '2TB to 5TB', '100GB to 200GB'], 0,
         'Modern consoles use solid‑state drives (SSDs) for fast loading times.'),
        ('What is a "cross‑platform" game?',
         ARRAY['A game that can be played on multiple different console brands and PC', 'A game that is exclusive to one console', 'A game that requires a subscription', 'A game that is only available on cloud'], 0,
         'Cross‑platform games allow players on different systems to play together.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_gaming, q_rec.column1, 'single_choice', q_rec.column4)
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