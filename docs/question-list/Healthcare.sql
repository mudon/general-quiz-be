-- ============================================================================
-- Insert 130 factual questions on Healthcare.
-- Subtopics: Hospitals, Medical Devices, Vaccination, Public Health,
-- Emergency Medicine, Pediatrics, Cardiology, Neurology, Oncology.
-- ============================================================================

DO $$
DECLARE
    cat_id_hospitals     BIGINT;
    cat_id_devices       BIGINT;
    cat_id_vaccination   BIGINT;
    cat_id_public_health BIGINT;
    cat_id_emergency     BIGINT;
    cat_id_pediatrics    BIGINT;
    cat_id_cardiology    BIGINT;
    cat_id_neurology     BIGINT;
    cat_id_oncology      BIGINT;
    q_id                 BIGINT;
    correct_opt_id       BIGINT;
    opt_texts            TEXT[];
    q_rec                RECORD;
BEGIN
    -- ------------------------------------------------------------------------
    -- Create categories (hierarchical under healthcare)
    -- ------------------------------------------------------------------------
    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('healthcare', 'Healthcare', 2, 0)
        ON CONFLICT (path) DO NOTHING;

    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('healthcare.hospitals',        'Hospitals', 2, 1),
        ('healthcare.medical_devices',  'Medical Devices', 2, 2),
        ('healthcare.vaccination',      'Vaccination', 2, 3),
        ('healthcare.public_health',    'Public Health', 2, 4),
        ('healthcare.emergency_medicine', 'Emergency Medicine', 2, 5),
        ('healthcare.pediatrics',       'Pediatrics', 2, 6),
        ('healthcare.cardiology',       'Cardiology', 2, 7),
        ('healthcare.neurology',        'Neurology', 2, 8),
        ('healthcare.oncology',         'Oncology', 2, 9)
        ON CONFLICT (path) DO NOTHING;

    -- Get category IDs
    SELECT id INTO cat_id_hospitals   FROM categories WHERE path = 'healthcare.hospitals';
    SELECT id INTO cat_id_devices     FROM categories WHERE path = 'healthcare.medical_devices';
    SELECT id INTO cat_id_vaccination FROM categories WHERE path = 'healthcare.vaccination';
    SELECT id INTO cat_id_public_health FROM categories WHERE path = 'healthcare.public_health';
    SELECT id INTO cat_id_emergency   FROM categories WHERE path = 'healthcare.emergency_medicine';
    SELECT id INTO cat_id_pediatrics  FROM categories WHERE path = 'healthcare.pediatrics';
    SELECT id INTO cat_id_cardiology  FROM categories WHERE path = 'healthcare.cardiology';
    SELECT id INTO cat_id_neurology   FROM categories WHERE path = 'healthcare.neurology';
    SELECT id INTO cat_id_oncology    FROM categories WHERE path = 'healthcare.oncology';

    -- ========================================================================
    -- 1. HOSPITALS (14 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the primary purpose of a hospital?',
         ARRAY['To provide patient care, diagnosis, and treatment', 'To conduct research only', 'To train doctors only', 'To provide administrative services'], 0,
         'Hospitals are institutions for medical care.'),
        ('Which type of hospital provides care for a wide range of conditions?',
         ARRAY['General hospital', 'Specialty hospital', 'Teaching hospital', 'Community hospital'], 0,
         'General hospitals handle many medical issues.'),
        ('What is a "teaching hospital"?',
         ARRAY['A hospital affiliated with a medical school for training', 'A hospital that only teaches', 'A hospital for research only', 'A hospital for children'], 0,
         'Teaching hospitals combine patient care with medical education.'),
        ('What is the role of an emergency department (ED)?',
         ARRAY['To provide immediate care for acute illnesses and injuries', 'To perform scheduled surgeries', 'To manage chronic conditions', 'To conduct routine check‑ups'], 0,
         'The ED treats urgent and life‑threatening conditions.'),
        ('Which hospital accreditation is recognised internationally?',
         ARRAY['JCI (Joint Commission International)', 'ISO', 'NHS', 'CDC'], 0,
         'JCI is a global standard for healthcare quality.'),
        ('What is an "intensive care unit" (ICU)?',
         ARRAY['A unit for critically ill patients requiring constant monitoring', 'A unit for minor injuries', 'A unit for rehabilitation', 'A unit for mental health'], 0,
         'ICUs provide specialised care for severely ill patients.'),
        ('What is the average length of stay in a hospital?',
         ARRAY['Varies by condition, but often a few days', 'Always more than a week', 'Always one day', 'Less than 24 hours'], 0,
         'Length of stay depends on medical necessity.'),
        ('Which department in a hospital performs diagnostic imaging?',
         ARRAY['Radiology', 'Pathology', 'Cardiology', 'Neurology'], 0,
         'Radiology includes X‑rays, CT, MRI, and ultrasound.'),
        ('What is the role of hospital administration?',
         ARRAY['To manage operations, finances, and staff scheduling', 'To treat patients', 'To perform surgeries', 'To conduct research'], 0,
         'Administration supports the clinical mission.'),
        ('Which type of hospital focuses on psychiatric care?',
         ARRAY['Psychiatric hospital', 'General hospital', 'Rehabilitation hospital', 'Long‑term care facility'], 0,
         'Psychiatric hospitals treat mental health conditions.'),
        ('What is the "patient‑centered care" approach?',
         ARRAY['Care that respects and responds to patient preferences, needs, and values', 'Care that is driven by doctors only', 'Care that focuses on cost', 'Care that uses only technology'], 0,
         'Patient‑centered care improves outcomes and satisfaction.'),
        ('What is the purpose of hospital infection control?',
         ARRAY['To prevent the spread of infections within the hospital', 'To treat infections', 'To isolate patients', 'To reduce costs'], 0,
         'Infection control is critical for patient and staff safety.'),
        ('Which hospital department is responsible for laboratory tests?',
         ARRAY['Clinical pathology', 'Radiology', 'Pharmacy', 'Nutrition'], 0,
         'Pathology performs blood tests, microbiology, and histology.'),
        ('What is a "level 1 trauma center"?',
         ARRAY['A facility providing the highest level of trauma care, 24/7', 'A basic emergency room', 'A clinic', 'A rehabilitation center'], 0,
         'Level 1 trauma centers have immediate surgical capabilities and research.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_hospitals, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 2. MEDICAL DEVICES (14 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is a stethoscope used for?',
         ARRAY['To listen to internal sounds (heart, lungs, etc.)', 'To measure blood pressure', 'To take temperature', 'To examine the eyes'], 0,
         'Stethoscopes are a fundamental diagnostic tool.'),
        ('Which device measures blood pressure?',
         ARRAY['Sphygmomanometer', 'Thermometer', 'Pulse oximeter', 'Stethoscope'], 0,
         'A sphygmomanometer has a cuff and gauge.'),
        ('What is the function of a pulse oximeter?',
         ARRAY['To measure blood oxygen saturation', 'To measure heart rate', 'To measure blood pressure', 'To measure temperature'], 0,
         'Pulse oximetry is non‑invasive and widely used.'),
        ('Which imaging device uses magnetic fields?',
         ARRAY['MRI (Magnetic Resonance Imaging)', 'CT scan', 'X‑ray', 'Ultrasound'], 0,
         'MRI uses strong magnetic fields and radio waves.'),
        ('What is an ECG (or EKG) machine used for?',
         ARRAY['To record the electrical activity of the heart', 'To image the heart', 'To measure blood pressure', 'To listen to heart sounds'], 0,
         'ECG is essential for diagnosing arrhythmias and ischaemia.'),
        ('What is a defibrillator used for?',
         ARRAY['To deliver a shock to restore normal heart rhythm', 'To pace the heart', 'To monitor heart activity', 'To perform CPR'], 0,
         'Defibrillators are used in cardiac arrest and arrhythmias.'),
        ('Which device is used to ventilate patients who cannot breathe on their own?',
         ARRAY['Mechanical ventilator', 'CPAP machine', 'Oxygen mask', 'Pulse oximeter'], 0,
         'Ventilators deliver breaths to support respiratory function.'),
        ('What is the purpose of a endoscope?',
         ARRAY['To view inside the body through natural openings or incisions', 'To examine the skin', 'To listen to heart sounds', 'To measure blood glucose'], 0,
         'Endoscopy is used for diagnostics and some surgeries.'),
        ('Which device is used to measure blood glucose?',
         ARRAY['Glucometer', 'Thermometer', 'Sphygmomanometer', 'Pulse oximeter'], 0,
         'Glucometers are essential for diabetes management.'),
        ('What is a hearing aid?',
         ARRAY['A device worn to amplify sound for people with hearing loss', 'A device to measure hearing', 'A device to treat ear infections', 'A device to remove earwax'], 0,
         'Hearing aids are custom‑fitted and have microprocessors.'),
        ('Which imaging technique uses sound waves?',
         ARRAY['Ultrasound', 'X‑ray', 'CT scan', 'MRI'], 0,
         'Ultrasound is safe and commonly used in obstetrics.'),
        ('What is a pacemaker?',
         ARRAY['An implantable device that regulates heart rhythm', 'A device to monitor heart activity', 'A device to shock the heart', 'A device to assist blood circulation'], 0,
         'Pacemakers treat bradycardia and certain arrhythmias.'),
        ('Which device is used for minimally invasive surgery?',
         ARRAY['Laparoscope and robotic surgical systems', 'Scalpel', 'Stethoscope', 'Sphygmomanometer'], 0,
         'Laparoscopy allows surgery with small incisions.'),
        ('What is a nebulizer?',
         ARRAY['A device that delivers medication in the form of a mist to the lungs', 'A device to measure lung capacity', 'A device to deliver oxygen', 'A device to ventilate'], 0,
         'Nebulizers are used for asthma and COPD.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_devices, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 3. VACCINATION (14 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is a vaccine?',
         ARRAY['A biological preparation that provides active acquired immunity to a disease', 'A medication to treat infections', 'A type of antibiotic', 'A therapeutic drug'], 0,
         'Vaccines stimulate the immune system to fight pathogens.'),
        ('Which disease was eradicated by vaccination?',
         ARRAY['Smallpox', 'Polio', 'Measles', 'Tuberculosis'], 0,
         'Smallpox was officially declared eradicated in 1980.'),
        ('What is the principle behind a vaccine?',
         ARRAY['To mimic infection and trigger immune memory', 'To directly kill the pathogen', 'To provide immediate immunity', 'To block pathogen entry'], 0,
         'Vaccines create memory cells for future protection.'),
        ('Which vaccine is given to children against polio?',
         ARRAY['IPV (inactivated) or OPV (oral)', 'BCG', 'DPT', 'MMR'], 0,
         'Polio vaccines are given globally to prevent paralysis.'),
        ('What is the MMR vaccine?',
         ARRAY['Measles, Mumps, Rubella', 'Meningitis, Measles, Rubella', 'Mumps, Measles, Rotavirus', 'Measles, Mumps, Rota'], 0,
         'MMR is a combined vaccine.'),
        ('What is "herd immunity"?',
         ARRAY['Protection of a population when a large proportion is immune, reducing spread', 'Immunity gained from the herd', 'Immunity given by animals', 'Immunity from natural infection'], 0,
         'Herd immunity protects vulnerable individuals.'),
        ('Which vaccine is given at birth in many countries?',
         ARRAY['BCG (tuberculosis) and Hepatitis B', 'Polio', 'DPT', 'MMR'], 0,
         'BCG and Hepatitis B are often given at birth.'),
        ('What is the "booster" dose?',
         ARRAY['A later dose to reinforce immunity after the primary series', 'The first dose', 'A dose for a different disease', 'A dose given only to adults'], 0,
         'Boosters extend protection over time.'),
        ('Which virus is prevented by the human papillomavirus (HPV) vaccine?',
         ARRAY['Cervical and other cancers caused by HPV', 'Flu', 'Hepatitis B', 'HIV'], 0,
         'HPV vaccine prevents several types of cancer.'),
        ('What is the typical interval for COVID‑19 vaccine boosters?',
         ARRAY['Varies, but often 6‑12 months after primary series', 'Once a year', 'Every month', 'Never'], 0,
         'Recommendations evolve based on variants and immunity.'),
        ('Which vaccine is given annually to protect against seasonal influenza?',
         ARRAY['Flu shot', 'MMR', 'DPT', 'Polio'], 0,
         'Influenza vaccines are updated yearly.'),
        ('What is the "cold chain" for vaccines?',
         ARRAY['The temperature‑controlled supply chain to maintain vaccine potency', 'A vaccine distribution network', 'A cold storage facility', 'A delivery method'], 0,
         'Maintaining the cold chain is critical for vaccine efficacy.'),
        ('Which disease is prevented by the DTaP vaccine?',
         ARRAY['Diphtheria, Tetanus, Pertussis (whooping cough)', 'Dengue, Typhoid, Paratyphoid', 'Diphtheria, Tetanus, Pneumonia', 'Diphtheria, Tuberculosis, Pertussis'], 0,
         'DTaP is a common childhood vaccine.'),
        ('What is the role of adjuvants in vaccines?',
         ARRAY['To enhance the immune response to the vaccine', 'To kill the pathogen', 'To preserve the vaccine', 'To reduce side effects'], 0,
         'Adjuvants make vaccines more effective.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_vaccination, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 4. PUBLIC HEALTH (15 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is public health?',
         ARRAY['The science of protecting and improving the health of populations', 'Individual patient care', 'Medical research', 'Hospital administration'], 0,
         'Public health focuses on prevention and community health.'),
        ('Which organisation is the leading global public health agency?',
         ARRAY['World Health Organization (WHO)', 'CDC', 'NHS', 'UNICEF'], 0,
         'WHO is the UN agency for international health.'),
        ('What is the "social determinants of health"?',
         ARRAY['The conditions in which people are born, grow, live, work, and age', 'Genetic factors', 'Access to healthcare only', 'Diet and exercise only'], 0,
         'Social determinants include income, education, housing, and environment.'),
        ('Which is a major public health achievement of the 20th century?',
         ARRAY['Vaccination and water fluoridation', 'Discovery of antibiotics', 'Development of vaccines', 'All of the above'], 3,
         'All contributed to increased life expectancy.'),
        ('What is epidemiology?',
         ARRAY['The study of disease patterns, causes, and effects in populations', 'The study of individual patients', 'The study of hospital management', 'The study of pharmacology'], 0,
         'Epidemiology is the cornerstone of public health.'),
        ('Which measure is used to compare health status across countries?',
         ARRAY['Life expectancy and infant mortality rate', 'GDP', 'Population size', 'Number of hospitals'], 0,
         'Life expectancy and infant mortality are key indicators.'),
        ('What is the main goal of health promotion?',
         ARRAY['To enable people to increase control over and improve their health', 'To treat all diseases', 'To build more hospitals', 'To reduce costs'], 0,
         'Health promotion includes education and behaviour change.'),
        ('Which public health intervention is effective in reducing tobacco use?',
         ARRAY['Taxation, bans on advertising, and smoke‑free policies', 'Only education', 'Only medication', 'Only counselling'], 0,
         'Comprehensive approaches are most effective.'),
        ('What is "preventive medicine"?',
         ARRAY['Medical practices designed to prevent disease', 'Treatment after disease develops', 'Emergency medicine', 'Surgery'], 0,
         'Prevention includes screening, vaccination, and lifestyle interventions.'),
        ('Which global pandemic was declared by WHO in 2020?',
         ARRAY['COVID‑19', 'H1N1', 'Ebola', 'Zika'], 0,
         'COVID‑19 was declared a pandemic in March 2020.'),
        ('What is the role of contact tracing in public health?',
         ARRAY['To identify and notify people who have been in contact with an infected person', 'To track patient symptoms', 'To monitor hospital capacity', 'To enforce quarantine'], 0,
         'Contact tracing helps contain outbreaks.'),
        ('Which disease is targeted by the Global Polio Eradication Initiative?',
         ARRAY['Polio', 'Measles', 'Malaria', 'Tuberculosis'], 0,
         'The initiative aims to eradicate polio worldwide.'),
        ('What is the "One Health" approach?',
         ARRAY['An approach integrating human, animal, and environmental health', 'One health system for all', 'A single healthcare provider', 'A focus only on humans'], 0,
         'One Health addresses zoonotic diseases and environmental health.'),
        ('Which public health measure reduces the spread of respiratory infections?',
         ARRAY['Hand hygiene and respiratory etiquette', 'Antibiotics', 'Vitamin supplements', 'Exercise'], 0,
         'Simple measures like hand washing are key.'),
        ('What is the impact of climate change on public health?',
         ARRAY['Increased heat‑related illness, vector‑borne diseases, and extreme weather events', 'Only mental health effects', 'No impact', 'Reduced allergies'], 0,
         'Climate change poses significant health risks.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_public_health, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 5. EMERGENCY MEDICINE (14 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the primary goal of emergency medicine?',
         ARRAY['To stabilise patients with acute, life‑threatening conditions', 'To provide primary care', 'To perform long‑term treatments', 'To manage chronic diseases'], 0,
         'Emergency medicine focuses on immediate life‑saving interventions.'),
        ('What does the "ABC" approach stand for in emergency care?',
         ARRAY['Airway, Breathing, Circulation', 'Airway, Breathing, Chest', 'Airway, Blood, Circulation', 'Airway, Bleeding, Compression'], 0,
         'ABC is the priority in trauma and resuscitation.'),
        ('What is a "triage" system?',
         ARRAY['A process of prioritising patients based on severity of condition', 'A process of treating all patients equally', 'A process of diagnosing all patients', 'A process of discharging patients'], 0,
         'Triage ensures that the most urgent patients are seen first.'),
        ('Which condition is managed with an automated external defibrillator (AED)?',
         ARRAY['Cardiac arrest (ventricular fibrillation)', 'Stroke', 'Heart attack', 'Pneumonia'], 0,
         'AEDs treat life‑threatening arrhythmias.'),
        ('What is the first step in treating a severe allergic reaction (anaphylaxis)?',
         ARRAY['Administer epinephrine (adrenaline)', 'Give antihistamines', 'Start IV fluids', 'Oxygen therapy'], 0,
         'Epinephrine is the first‑line treatment for anaphylaxis.'),
        ('What is the main cause of preventable death in trauma patients?',
         ARRAY['Uncontrolled haemorrhage', 'Respiratory failure', 'Infection', 'Head injury'], 0,
         'Bleeding is a leading cause of preventable trauma deaths.'),
        ('What is the "golden hour" in emergency medicine?',
         ARRAY['The first hour after injury, critical for treatment', 'The first hour after birth', 'The hour after diagnosis', 'The hour before surgery'], 0,
         'Rapid intervention improves outcomes in trauma.'),
        ('Which medication is used to reverse opioid overdose?',
         ARRAY['Naloxone (Narcan)', 'Epinephrine', 'Atropine', 'Flumazenil'], 0,
         'Naloxone is an opioid antagonist.'),
        ('What is the recommended compression depth for adult CPR?',
         ARRAY['At least 2 inches (5 cm)', '1 inch', '1.5 inches', '3 inches'], 0,
         'Adequate depth is crucial for effective chest compressions.'),
        ('Which sign indicates a stroke (FAST)?',
         ARRAY['Face drooping, Arm weakness, Speech difficulty, Time to call', 'Fever, Aches, Sneezing, Tiredness', 'Fracture, Ankle swelling, Stiffness, Tingling', 'Fainting, Anxiety, Sweating, Tachycardia'], 0,
         'FAST is a mnemonic for stroke recognition.'),
        ('What is the primary treatment for a heart attack?',
         ARRAY['Aspirin, oxygen, and reperfusion therapy', 'Antibiotics', 'Antihistamines', 'Painkillers only'], 0,
         'Aspirin and reperfusion (e.g., PCI) are critical.'),
        ('Which condition is characterised by a sudden loss of consciousness and motor control?',
         ARRAY['Seizure', 'Stroke', 'Fainting', 'Heart attack'], 0,
         'Seizures involve abnormal brain electrical activity.'),
        ('What is the purpose of a cervical collar in trauma?',
         ARRAY['To immobilise the neck and prevent spinal cord injury', 'To support the head', 'To prevent bleeding', 'To assist breathing'], 0,
         'Cervical collars are used in suspected spine injury.'),
        ('What is the role of a trauma team?',
         ARRAY['To coordinate rapid assessment and treatment of severely injured patients', 'To provide routine care', 'To administer vaccines', 'To perform elective surgery'], 0,
         'Trauma teams include multiple specialties for rapid response.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_emergency, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 6. PEDIATRICS (15 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is pediatrics?',
         ARRAY['The branch of medicine dealing with children and their diseases', 'The branch of medicine dealing with adults', 'The branch of medicine dealing with elderly', 'The branch of medicine dealing with surgery'], 0,
         'Pediatrics covers infant, child, and adolescent health.'),
        ('What is the typical growth marker used in pediatrics?',
         ARRAY['Growth charts (height, weight, BMI)', 'Blood pressure only', 'Temperature only', 'Heart rate only'], 0,
         'Growth charts track development against population norms.'),
        ('Which vaccine is given to children at birth?',
         ARRAY['Hepatitis B and BCG (depending on country)', 'MMR', 'Polio', 'DPT'], 0,
         'Hepatitis B is often given at birth; BCG in many countries.'),
        ('What is the most common chronic disease in children?',
         ARRAY['Asthma', 'Diabetes', 'Obesity', 'Hypertension'], 0,
         'Asthma is a leading chronic condition in children.'),
        ('Which condition is characterised by recurrent episodes of wheezing and breathlessness?',
         ARRAY['Asthma', 'Bronchitis', 'Cystic fibrosis', 'Pneumonia'], 0,
         'Asthma involves airway inflammation and bronchoconstriction.'),
        ('What is the recommended age for the first dose of MMR vaccine?',
         ARRAY['12‑15 months', 'Birth', '6 months', '18‑24 months'], 0,
         'MMR is typically given at 12‑15 months.'),
        ('Which nutrient is crucial for bone development in children?',
         ARRAY['Calcium and Vitamin D', 'Iron', 'Vitamin C', 'Protein'], 0,
         'Calcium and Vitamin D are essential for growing bones.'),
        ('What is "failure to thrive" in pediatrics?',
         ARRAY['Inadequate weight gain or growth in a child', 'A lack of appetite', 'A developmental delay', 'A behavioural issue'], 0,
         'Failure to thrive may be due to medical or social factors.'),
        ('Which condition is a common cause of fever in children?',
         ARRAY['Viral upper respiratory infections', 'Appendicitis', 'Meningitis', 'Urinary tract infection'], 0,
         'Most fevers in children are due to viral infections.'),
        ('What is the purpose of well‑child visits?',
         ARRAY['To monitor growth, development, and provide preventive care', 'To treat acute illnesses only', 'To give immunizations only', 'To perform routine blood tests'], 0,
         'Well‑child visits are comprehensive check‑ups.'),
        ('Which developmental milestone is typically achieved by 12 months?',
         ARRAY['Walking independently or with support', 'Speaking in sentences', 'Riding a tricycle', 'Writing letters'], 0,
         'Most children take their first steps around 12 months.'),
        ('What is the most common cause of hospitalization in children under 1 year?',
         ARRAY['Respiratory infections (e.g., RSV)', 'Trauma', 'Gastroenteritis', 'Congenital anomalies'], 0,
         'Respiratory infections are a leading cause of infant hospitalisation.'),
        ('Which medication is commonly used to treat fever in children?',
         ARRAY['Acetaminophen or ibuprofen', 'Aspirin', 'Codeine', 'Antibiotics'], 0,
         'Acetaminophen and ibuprofen are safe for fever in children.'),
        ('What is the normal heart rate for a newborn?',
         ARRAY['120‑160 beats per minute', '60‑100 beats per minute', '80‑120 beats per minute', '40‑60 beats per minute'], 0,
         'Newborns have higher heart rates than older children.'),
        ('What is the purpose of newborn screening?',
         ARRAY['To detect rare but serious conditions early', 'To diagnose all diseases', 'To test for allergies', 'To measure growth'], 0,
         'Newborn screening can prevent severe outcomes.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_pediatrics, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 7. CARDIOLOGY (15 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is cardiology?',
         ARRAY['The medical specialty dealing with disorders of the heart and blood vessels', 'The study of the lungs', 'The study of the brain', 'The study of the kidneys'], 0,
         'Cardiology covers heart diseases and their management.'),
        ('What is the most common cause of heart attacks?',
         ARRAY['Coronary artery disease (atherosclerosis)', 'Stress', 'Infections', 'Arrhythmias'], 0,
         'Atherosclerosis leads to blockage of coronary arteries.'),
        ('What is a "heart attack" medically called?',
         ARRAY['Myocardial infarction', 'Cardiac arrest', 'Heart failure', 'Angina'], 0,
         'Myocardial infarction is death of heart muscle due to ischemia.'),
        ('Which diagnostic test is used to visualize coronary arteries?',
         ARRAY['Coronary angiography', 'Echocardiogram', 'ECG', 'Cardiac MRI'], 0,
         'Angiography uses contrast dye to show blockages.'),
        ('What is the normal resting heart rate for an adult?',
         ARRAY['60‑100 beats per minute', '40‑60', '100‑120', '120‑160'], 0,
         'The normal range is 60‑100 bpm.'),
        ('Which condition is characterized by an irregular heartbeat?',
         ARRAY['Arrhythmia', 'Heart failure', 'Angina', 'Hypertension'], 0,
         'Arrhythmias include atrial fibrillation, etc.'),
        ('What is the main risk factor for developing hypertension?',
         ARRAY['Age, obesity, salt intake, and genetics', 'Smoking', 'Diabetes', 'All of the above'], 3,
         'Multiple factors contribute to hypertension.'),
        ('What is the role of statins in cardiology?',
         ARRAY['To lower cholesterol and reduce cardiovascular risk', 'To lower blood pressure', 'To thin the blood', 'To reduce heart rate'], 0,
         'Statins are HMG‑CoA reductase inhibitors.'),
        ('What is a "pacemaker" used for?',
         ARRAY['To treat bradycardia and certain arrhythmias', 'To treat high blood pressure', 'To treat heart failure', 'To prevent heart attacks'], 0,
         'Pacemakers provide electrical stimulation when the heart rate is too slow.'),
        ('Which valve is commonly affected by rheumatic heart disease?',
         ARRAY['Mitral valve', 'Aortic valve', 'Pulmonary valve', 'Tricuspid valve'], 0,
         'Mitral stenosis is a common sequela of rheumatic fever.'),
        ('What is the procedure to open blocked coronary arteries?',
         ARRAY['Percutaneous coronary intervention (PCI or angioplasty)', 'Bypass surgery', 'Valve replacement', 'Heart transplant'], 0,
         'PCI uses a balloon and often a stent to open arteries.'),
        ('Which symptom is typical of angina?',
         ARRAY['Chest pain or pressure that occurs with exertion', 'Shortness of breath only', 'Palpitations only', 'Fainting'], 0,
         'Angina is due to transient myocardial ischemia.'),
        ('What is heart failure?',
         ARRAY['The inability of the heart to pump blood effectively', 'The heart stops beating', 'A heart attack', 'A valve problem'], 0,
         'Heart failure can be systolic or diastolic.'),
        ('Which drug is commonly used to treat heart failure?',
         ARRAY['ACE inhibitors and beta‑blockers', 'Antibiotics', 'Antihistamines', 'Anticoagulants only'], 0,
         'ACE inhibitors and beta‑blockers improve outcomes.'),
        ('What is the purpose of a stress test?',
         ARRAY['To evaluate heart function under physical stress to detect ischemia', 'To measure resting heart rate', 'To check blood pressure', 'To assess lung function'], 0,
         'Stress tests can reveal coronary artery disease.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_cardiology, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 8. NEUROLOGY (14 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is neurology?',
         ARRAY['The medical specialty dealing with disorders of the nervous system', 'The study of the heart', 'The study of the lungs', 'The study of the kidneys'], 0,
         'Neurology covers the brain, spinal cord, nerves, and muscles.'),
        ('Which condition is characterized by recurrent seizures?',
         ARRAY['Epilepsy', 'Stroke', 'Parkinson''s disease', 'Multiple sclerosis'], 0,
         'Epilepsy is a chronic seizure disorder.'),
        ('What is the most common type of stroke?',
         ARRAY['Ischemic stroke (blockage)', 'Hemorrhagic stroke', 'Transient ischemic attack', 'Embolic stroke'], 0,
         'Ischemic strokes account for about 87% of all strokes.'),
        ('What is Parkinson''s disease caused by?',
         ARRAY['Loss of dopamine‑producing neurons in the substantia nigra', 'Excess dopamine', 'Myelin damage', 'Brain infection'], 0,
         'The loss of dopamine leads to movement disorders.'),
        ('Which neurotransmitter is deficient in Alzheimer''s disease?',
         ARRAY['Acetylcholine', 'Dopamine', 'Serotonin', 'GABA'], 0,
         'Alzheimer''s is associated with acetylcholine deficiency.'),
        ('What is a "TIA" (transient ischemic attack)?',
         ARRAY['A temporary stroke‑like episode that resolves within 24 hours', 'A permanent stroke', 'A seizure', 'A migraine'], 0,
         'TIA is a warning sign for future strokes.'),
        ('Which diagnostic test is commonly used for neurological disorders?',
         ARRAY['MRI and CT scan', 'ECG', 'Echocardiogram', 'Blood glucose test'], 0,
         'Brain imaging is key for diagnosis.'),
        ('What is the function of the cerebellum?',
         ARRAY['Coordination and balance', 'Higher cognitive functions', 'Vision processing', 'Regulation of heart rate'], 0,
         'The cerebellum fine‑tunes motor movements.'),
        ('Which disease is characterized by progressive muscle weakness and atrophy?',
         ARRAY['Multiple sclerosis', 'Amyotrophic lateral sclerosis (ALS)', 'Parkinson''s', 'Alzheimer''s'], 0,
         'ALS affects motor neurons.'),
        ('What is the myelin sheath?',
         ARRAY['The insulating layer around nerve fibres that speeds transmission', 'A neurotransmitter', 'A type of neuron', 'A brain structure'], 0,
         'Myelin damage is seen in multiple sclerosis.'),
        ('Which infection can cause meningitis?',
         ARRAY['Bacteria, viruses, and fungi', 'Only bacteria', 'Only viruses', 'Only parasites'], 0,
         'Meningitis is inflammation of the meninges.'),
        ('What is a neurological "reflex"?',
         ARRAY['An involuntary response to a stimulus', 'A voluntary movement', 'A type of seizure', 'A cognitive function'], 0,
         'Reflexes are used in neurological exams.'),
        ('Which symptom is classic of a migraine?',
         ARRAY['Severe, throbbing headache with nausea and visual changes', 'Fever', 'Muscle stiffness', 'Joint pain'], 0,
         'Migraines often have aura and are unilateral.'),
        ('What is the purpose of a lumbar puncture?',
         ARRAY['To obtain cerebrospinal fluid for analysis', 'To measure blood pressure', 'To treat a headache', 'To inject medication'], 0,
         'CSF analysis helps diagnose infections and other neurological conditions.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_neurology, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 9. ONCOLOGY (15 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is oncology?',
         ARRAY['The branch of medicine dealing with the prevention, diagnosis, and treatment of cancer', 'The study of the heart', 'The study of the lungs', 'The study of the skin'], 0,
         'Oncology covers all aspects of cancer care.'),
        ('What is the most common type of cancer worldwide?',
         ARRAY['Lung cancer', 'Breast cancer', 'Colorectal cancer', 'Prostate cancer'], 0,
         'Lung cancer is the most commonly diagnosed cancer globally.'),
        ('What is the leading cause of cancer death worldwide?',
         ARRAY['Lung cancer', 'Breast cancer', 'Colorectal cancer', 'Stomach cancer'], 0,
         'Lung cancer is the deadliest cancer.'),
        ('What is a tumour?',
         ARRAY['An abnormal mass of tissue', 'A type of infection', 'A genetic disorder', 'An autoimmune condition'], 0,
         'Tumours can be benign or malignant.'),
        ('What is metastasis?',
         ARRAY['The spread of cancer cells to other parts of the body', 'The growth of a tumour', 'The removal of a tumour', 'The treatment of cancer'], 0,
         'Metastasis is a hallmark of malignancy.'),
        ('Which cancer is associated with HPV infection?',
         ARRAY['Cervical cancer', 'Liver cancer', 'Lung cancer', 'Colon cancer'], 0,
         'HPV is a major cause of cervical cancer.'),
        ('What is the purpose of chemotherapy?',
         ARRAY['To kill cancer cells by targeting rapidly dividing cells', 'To boost the immune system', 'To relieve pain', 'To shrink tumours only'], 0,
         'Chemotherapy is systemic treatment for many cancers.'),
        ('Which imaging test is commonly used for cancer screening?',
         ARRAY['Mammography (breast), CT, MRI, and PET scans', 'ECG', 'Echocardiogram', 'Blood glucose test'], 0,
         'Screening tests detect cancer early.'),
        ('What is radiation therapy?',
         ARRAY['The use of high‑energy radiation to kill cancer cells', 'The use of drugs to kill cancer cells', 'The use of surgery to remove tumours', 'The use of immunotherapy'], 0,
         'Radiation is targeted to specific areas.'),
        ('What is the most common cancer in women?',
         ARRAY['Breast cancer', 'Lung cancer', 'Colorectal cancer', 'Cervical cancer'], 0,
         'Breast cancer is the most frequent female cancer.'),
        ('What is the most common cancer in men?',
         ARRAY['Prostate cancer', 'Lung cancer', 'Colorectal cancer', 'Bladder cancer'], 0,
         'Prostate cancer is the most common male cancer.'),
        ('Which treatment uses the body''s immune system to fight cancer?',
         ARRAY['Immunotherapy', 'Chemotherapy', 'Radiation therapy', 'Surgery'], 0,
         'Immunotherapy includes checkpoint inhibitors and CAR‑T cells.'),
        ('What is a biopsy?',
         ARRAY['The removal of a tissue sample for diagnosis', 'A type of imaging', 'A blood test', 'A type of surgery'], 0,
         'Biopsy is essential for confirming malignancy.'),
        ('Which cancer is strongly linked to smoking?',
         ARRAY['Lung cancer', 'Breast cancer', 'Prostate cancer', 'Colon cancer'], 0,
         'Lung cancer is strongly associated with tobacco use.'),
        ('What is the role of palliative care in oncology?',
         ARRAY['To improve quality of life and manage symptoms, regardless of curative intent', 'To cure cancer', 'To provide only end‑of‑life care', 'To replace curative treatment'], 0,
         'Palliative care is supportive and can be given alongside curative treatments.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_oncology, q_rec.column1, 'single_choice', q_rec.column4)
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