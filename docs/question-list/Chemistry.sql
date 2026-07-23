-- ============================================================================
-- Insert 170 factual questions on Chemistry.
-- Subtopics: Organic Chemistry, Inorganic Chemistry, Physical Chemistry,
-- Analytical Chemistry, Biochemistry, Chemical Reactions, Elements, Periodic Table.
-- ============================================================================

DO $$
DECLARE
    cat_id_organic       BIGINT;
    cat_id_inorganic     BIGINT;
    cat_id_physical      BIGINT;
    cat_id_analytical    BIGINT;
    cat_id_biochemistry  BIGINT;
    cat_id_reactions     BIGINT;
    cat_id_elements      BIGINT;
    cat_id_periodic      BIGINT;
    q_id                 BIGINT;
    correct_opt_id       BIGINT;
    opt_texts            TEXT[];
    q_rec                RECORD;
BEGIN
    -- ------------------------------------------------------------------------
    -- Create categories (hierarchical under chemistry)
    -- ------------------------------------------------------------------------
    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('chemistry', 'Chemistry', 1, 0)
        ON CONFLICT (path) DO NOTHING;

    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('chemistry.organic_chemistry',      'Organic Chemistry', 1, 1),
        ('chemistry.inorganic_chemistry',    'Inorganic Chemistry', 1, 2),
        ('chemistry.physical_chemistry',     'Physical Chemistry', 1, 3),
        ('chemistry.analytical_chemistry',   'Analytical Chemistry', 1, 4),
        ('chemistry.biochemistry',           'Biochemistry', 1, 5),
        ('chemistry.chemical_reactions',     'Chemical Reactions', 1, 6),
        ('chemistry.elements',               'Elements', 1, 7),
        ('chemistry.periodic_table',         'Periodic Table', 1, 8)
        ON CONFLICT (path) DO NOTHING;

    -- Get category IDs
    SELECT id INTO cat_id_organic     FROM categories WHERE path = 'chemistry.organic_chemistry';
    SELECT id INTO cat_id_inorganic   FROM categories WHERE path = 'chemistry.inorganic_chemistry';
    SELECT id INTO cat_id_physical    FROM categories WHERE path = 'chemistry.physical_chemistry';
    SELECT id INTO cat_id_analytical  FROM categories WHERE path = 'chemistry.analytical_chemistry';
    SELECT id INTO cat_id_biochemistry FROM categories WHERE path = 'chemistry.biochemistry';
    SELECT id INTO cat_id_reactions   FROM categories WHERE path = 'chemistry.chemical_reactions';
    SELECT id INTO cat_id_elements    FROM categories WHERE path = 'chemistry.elements';
    SELECT id INTO cat_id_periodic   FROM categories WHERE path = 'chemistry.periodic_table';

    -- ========================================================================
    -- 1. ORGANIC CHEMISTRY (22 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the general formula of alkanes?',
         ARRAY['CₙH₂ₙ₊₂', 'CₙH₂ₙ', 'CₙH₂ₙ₋₂', 'CₙH₂ₙ₊₄'], 0,
         'Alkanes are saturated hydrocarbons with single bonds.'),
        ('Which functional group is present in alcohols?',
         ARRAY['Hydroxyl (-OH)', 'Carbonyl (C=O)', 'Carboxyl (-COOH)', 'Amino (-NH₂)'], 0,
         'Alcohols contain the hydroxyl group.'),
        ('What is the name of the simplest alkene?',
         ARRAY['Ethene', 'Methane', 'Ethane', 'Propyne'], 0,
         'Ethene (C₂H₄) is the simplest alkene.'),
        ('What type of bonding is characteristic of organic compounds?',
         ARRAY['Covalent bonds (mostly C‑C and C‑H)', 'Ionic bonds', 'Metallic bonds', 'Hydrogen bonds'], 0,
         'Organic compounds are based on carbon with covalent bonds.'),
        ('What is a functional group?',
         ARRAY['A specific atom or group that gives a compound its characteristic properties', 'A type of bond', 'A carbon skeleton', 'A type of isomer'], 0,
         'Functional groups determine reactivity.'),
        ('Which compound is a carboxylic acid?',
         ARRAY['Ethanoic acid (acetic acid)', 'Ethanol', 'Ethanal', 'Ethene'], 0,
         'Carboxylic acids contain the -COOH group.'),
        ('What is the name of the reaction when an alcohol reacts with a carboxylic acid?',
         ARRAY['Esterification', 'Hydrolysis', 'Oxidation', 'Reduction'], 0,
         'Esterification produces an ester and water.'),
        ('What is a polymer?',
         ARRAY['A large molecule made of repeating smaller units (monomers)', 'A small molecule', 'A type of catalyst', 'A type of isomer'], 0,
         'Polymers are long chains of monomers.'),
        ('Which hydrocarbon is a cyclic alkane?',
         ARRAY['Cyclohexane', 'Hexane', 'Hexene', 'Benzene'], 0,
         'Cyclohexane is a saturated cyclic hydrocarbon.'),
        ('What is the functional group of an aldehyde?',
         ARRAY['Carbonyl (-CHO)', 'Hydroxyl (-OH)', 'Carboxyl (-COOH)', 'Ether (-O-)'], 0,
         'Aldehydes have a carbonyl group attached to at least one hydrogen.'),
        ('What is the functional group of a ketone?',
         ARRAY['Carbonyl (C=O) with two carbon groups', 'Carbonyl with one hydrogen', 'Hydroxyl', 'Ester'], 0,
         'Ketones have the carbonyl group bonded to two carbon atoms.'),
        ('Which compound is an aromatic hydrocarbon?',
         ARRAY['Benzene', 'Cyclohexane', 'Hexane', 'Ethene'], 0,
         'Benzene has a delocalised π‑electron system.'),
        ('What is the process of breaking down a large hydrocarbon into smaller ones?',
         ARRAY['Cracking', 'Hydrolysis', 'Polymerization', 'Oxidation'], 0,
         'Cracking is used in the petroleum industry.'),
        ('What is the general formula of alkenes?',
         ARRAY['CₙH₂ₙ', 'CₙH₂ₙ₊₂', 'CₙH₂ₙ₋₂', 'CₙH₂ₙ₊₄'], 0,
         'Alkenes have one double bond.'),
        ('What is a saturated hydrocarbon?',
         ARRAY['A hydrocarbon with only single bonds', 'A hydrocarbon with double bonds', 'A hydrocarbon with triple bonds', 'A cyclic hydrocarbon'], 0,
         'Alkanes are saturated hydrocarbons.'),
        ('Which catalyst is used in the hydrogenation of alkenes?',
         ARRAY['Nickel (Ni) or platinum (Pt)', 'Sulfuric acid', 'Sodium hydroxide', 'Iron'], 0,
         'Hydrogenation uses transition metal catalysts.'),
        ('What is an isomer?',
         ARRAY['Compounds with the same molecular formula but different structure', 'Compounds with different formulas but same structure', 'Compounds with the same properties', 'Compounds with the same boiling point'], 0,
         'Isomers have different connectivity or arrangement.'),
        ('What type of isomerism is shown by 1‑butene and 2‑butene?',
         ARRAY['Position isomerism', 'Chain isomerism', 'Functional group isomerism', 'Geometric isomerism'], 0,
         'The double bond position differs.'),
        ('What is the functional group of an ester?',
         ARRAY['‑COO‑', '‑OH', '‑COOH', '‑O‑'], 0,
         'Esters have the general formula RCOOR''.'),
        ('What is the product of the hydrolysis of an ester?',
         ARRAY['Carboxylic acid and alcohol', 'Two carboxylic acids', 'Two alcohols', 'Aldehyde and alcohol'], 0,
         'Hydrolysis breaks the ester bond.'),
        ('Which reagent is used to test for alkenes?',
         ARRAY['Bromine water (decolourisation)', 'Lucas reagent', 'Tollen''s reagent', 'Fehling''s solution'], 0,
         'Alkenes decolourise bromine water.'),
        ('What is the term for a carbon that is attached to four different groups?',
         ARRAY['Chiral carbon', 'Stereocenter', 'Asymmetric carbon', 'All of the above'], 3,
         'Such a carbon is chiral, a stereocenter, and asymmetric.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_organic, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 2. INORGANIC CHEMISTRY (22 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the most abundant element in the Earth''s crust?',
         ARRAY['Oxygen', 'Silicon', 'Aluminium', 'Iron'], 0,
         'Oxygen makes up about 46.6% of the Earth''s crust.'),
        ('What is the most abundant metal in the Earth''s crust?',
         ARRAY['Aluminium', 'Iron', 'Calcium', 'Sodium'], 0,
         'Aluminium is the most abundant metal (8.2%).'),
        ('What type of bonding is found in sodium chloride?',
         ARRAY['Ionic bonding', 'Covalent bonding', 'Metallic bonding', 'Hydrogen bonding'], 0,
         'NaCl is an ionic compound formed by electron transfer.'),
        ('What is the colour of chlorine gas?',
         ARRAY['Yellow‑green', 'Colourless', 'Red‑brown', 'Blue‑green'], 0,
         'Chlorine gas is a greenish‑yellow.'),
        ('What is the oxidation state of oxygen in most compounds?',
         ARRAY['−2 (except peroxides)', '+2', '−1', '+1'], 0,
         'Oxygen usually has an oxidation state of −2.'),
        ('What is the formula of sulfuric acid?',
         ARRAY['H₂SO₄', 'HCl', 'HNO₃', 'H₃PO₄'], 0,
         'Sulfuric acid is H₂SO₄.'),
        ('What is the common name for sodium bicarbonate?',
         ARRAY['Baking soda', 'Washing soda', 'Caustic soda', 'Soda ash'], 0,
         'Baking soda is used in cooking and as an antacid.'),
        ('What is the charge on a nitrate ion?',
         ARRAY['−1', '−2', '+1', '+2'], 0,
         'Nitrate is NO₃⁻.'),
        ('Which element is a liquid at room temperature?',
         ARRAY['Mercury', 'Bromine (also)', 'Gallium', 'Caesium'], 0,
         'Mercury (Hg) and bromine (Br₂) are liquid at room temperature.'),
        ('What is the pH of a neutral solution?',
         ARRAY['7', '0', '14', '1'], 0,
         'At 25°C, pH = 7.'),
        ('Which gas is known as laughing gas?',
         ARRAY['Nitrous oxide (N₂O)', 'Nitric oxide (NO)', 'Nitrogen dioxide (NO₂)', 'Ammonia (NH₃)'], 0,
         'Nitrous oxide is used as an anaesthetic.'),
        ('What is the most common oxidation state of alkali metals?',
         ARRAY['+1', '+2', '+3', '0'], 0,
         'Alkali metals (Li, Na, K, etc.) form +1 ions.'),
        ('What is the name of the ore from which aluminium is extracted?',
         ARRAY['Bauxite', 'Haematite', 'Galena', 'Malachite'], 0,
         'Bauxite is the primary aluminium ore.'),
        ('What is the unit of pH?',
         ARRAY['No unit (logarithmic)', 'Moles per litre', 'Grams per litre', 'Parts per million'], 0,
         'pH is a dimensionless logarithmic measure.'),
        ('Which acid is present in the stomach?',
         ARRAY['Hydrochloric acid (HCl)', 'Sulfuric acid', 'Nitric acid', 'Phosphoric acid'], 0,
         'Gastric juice contains HCl.'),
        ('What is the chemical formula of table salt?',
         ARRAY['NaCl', 'KCl', 'CaCl₂', 'Na₂CO₃'], 0,
         'Sodium chloride is common salt.'),
        ('What is the process of heating a solid to produce a gas?',
         ARRAY['Sublimation (solid → gas)', 'Condensation', 'Vaporisation', 'Deposition'], 0,
         'Sublimation is the direct transition from solid to gas.'),
        ('Which element is the lightest metal?',
         ARRAY['Lithium', 'Sodium', 'Magnesium', 'Aluminium'], 0,
         'Lithium has the lowest density of all metals.'),
        ('What is the main component of natural gas?',
         ARRAY['Methane (CH₄)', 'Ethane', 'Propane', 'Butane'], 0,
         'Natural gas is mainly methane.'),
        ('What is the colour of copper sulfate solution?',
         ARRAY['Blue', 'Green', 'Pink', 'Colourless'], 0,
         'Hydrated copper sulfate is blue.'),
        ('Which compound is used to bleach water in swimming pools?',
         ARRAY['Chlorine (Cl₂)', 'Oxygen', 'Bromine', 'Iodine'], 0,
         'Chlorine is a disinfectant.'),
        ('What is the name for salts containing water of crystallisation?',
         ARRAY['Hydrates', 'Anhydrous salts', 'Double salts', 'Basic salts'], 0,
         'Hydrates have water molecules incorporated into their crystalline structure.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_inorganic, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 3. PHYSICAL CHEMISTRY (22 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the ideal gas law?',
         ARRAY['PV = nRT', 'P = nRT/V', 'V = nRT/P', 'All are correct forms'], 3,
         'The ideal gas law relates pressure, volume, temperature, and amount.'),
        ('What is the value of the universal gas constant (R) in J/(mol·K)?',
         ARRAY['8.314', '0.0821', '1.987', '4.184'], 0,
         'R = 8.314 J/mol·K.'),
        ('What is the term for a process where no heat is exchanged with the surroundings?',
         ARRAY['Adiabatic', 'Isothermal', 'Isobaric', 'Isochoric'], 0,
         'Adiabatic means Q = 0.'),
        ('What is the measure of disorder in a system?',
         ARRAY['Entropy', 'Enthalpy', 'Gibbs free energy', 'Internal energy'], 0,
         'Entropy (S) is a measure of randomness.'),
        ('What is the change in enthalpy at constant pressure?',
         ARRAY['ΔH = q_p', 'ΔH = ΔU + PΔV', 'Both', 'Neither'], 2,
         'At constant pressure, ΔH = q_p = ΔU + PΔV.'),
        ('What is the standard state of a gas?',
         ARRAY['1 atm pressure and ideal behaviour', '0°C', '25°C', '1 Pa'], 0,
         'Standard pressure is 1 atm (101.3 kPa).'),
        ('What is the van der Waals equation?',
         ARRAY['(P + a(n/V)²)(V - nb) = nRT', 'PV = nRT', 'P = nRT/(V - nb)', 'P + a(n/V)² = nRT/V'], 0,
         'The van der Waals equation accounts for intermolecular forces and molecular volume.'),
        ('What is the rate of a chemical reaction dependent on?',
         ARRAY['Concentration, temperature, and catalysts', 'Only concentration', 'Only temperature', 'Only catalysts'], 0,
         'Reaction rate is influenced by multiple factors.'),
        ('What is the Arrhenius equation used for?',
         ARRAY['To relate rate constant to temperature and activation energy', 'To calculate equilibrium constants', 'To determine reaction orders', 'To calculate pH'], 0,
         'k = A e^(-Ea/RT).'),
        ('What is a catalyst?',
         ARRAY['A substance that increases reaction rate without being consumed', 'A substance that changes the product', 'A substance that decreases reaction rate', 'A substance that is consumed'], 0,
         'Catalysts lower the activation energy.'),
        ('What is the equilibrium constant K?',
         ARRAY['The ratio of product concentrations to reactant concentrations at equilibrium (raised to stoichiometric coefficients)', 'The ratio of reactants to products', 'The rate of reaction', 'The activation energy'], 0,
         'K describes the composition of an equilibrium mixture.'),
        ('What is Le Chatelier''s principle?',
         ARRAY['If a system at equilibrium is disturbed, it shifts to counteract the change', 'Equilibrium is always stable', 'Equilibrium never shifts', 'Equilibrium is independent of conditions'], 0,
         'Le Chatelier''s principle predicts the response to changes in concentration, temperature, or pressure.'),
        ('What is the pH of a 0.01 M HCl solution?',
         ARRAY['2', '1', '3', '4'], 0,
         'pH = -log(0.01) = 2.'),
        ('What is the collision theory of reaction rates?',
         ARRAY['Reactions occur when particles collide with sufficient energy and proper orientation', 'Reactions occur spontaneously', 'Reactions occur when particles collide without energy', 'Reactions occur only in solution'], 0,
         'Collision theory explains why some reactions are fast and others slow.'),
        ('What is the effect of temperature on reaction rate?',
         ARRAY['Rate increases with temperature (roughly doubles per 10°C)', 'Rate decreases with temperature', 'Rate is independent of temperature', 'Rate is inversely proportional'], 0,
         'Higher temperature gives more molecules with sufficient energy.'),
        ('What is the difference between an exothermic and endothermic reaction?',
         ARRAY['Exothermic releases heat (ΔH < 0); endothermic absorbs heat (ΔH > 0)', 'Exothermic absorbs heat', 'Endothermic releases heat', 'No difference'], 0,
         'Heat flow distinguishes them.'),
        ('What is the unit of reaction rate?',
         ARRAY['mol/(L·s)', 'mol/s', 'L/s', 'mol/L'], 0,
         'Rate is change in concentration per unit time.'),
        ('What is the order of reaction?',
         ARRAY['The exponent to which concentration is raised in the rate law', 'The stoichiometric coefficient', 'The molecularity', 'The activation energy'], 0,
         'Rate law: rate = k[A]^m[B]^n.'),
        ('What is a half‑life in reaction kinetics?',
         ARRAY['The time for half of the reactant to be consumed', 'The time for the reaction to finish', 'The time for the rate to halve', 'The time for the concentration to double'], 0,
         'For first‑order reactions, t₁/₂ = ln2/k.'),
        ('What is the van''t Hoff factor (i)?',
         ARRAY['The number of particles produced when a solute dissolves', 'The number of moles', 'The volume', 'The pressure'], 0,
         'i is used in colligative properties.'),
        ('What is the relationship between pressure and volume for an ideal gas at constant temperature?',
         ARRAY['Boyle''s law: P₁V₁ = P₂V₂', 'Charles''s law: V/T = constant', 'Gay‑Lussac''s law: P/T = constant', 'Avogadro''s law: V/n = constant'], 0,
         'Boyle''s law states inverse proportionality.'),
        ('What is a state function in thermodynamics?',
         ARRAY['A property that depends only on the current state, not the path', 'A property that depends on the path', 'A property that changes with path', 'A property that is never constant'], 0,
         'Examples: internal energy, enthalpy, entropy, Gibbs free energy.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_physical, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 4. ANALYTICAL CHEMISTRY (22 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the purpose of titration?',
         ARRAY['To determine the concentration of a solution', 'To measure pH', 'To separate mixtures', 'To identify compounds'], 0,
         'Titration involves adding a reagent until the reaction is complete.'),
        ('What is the endpoint of a titration?',
         ARRAY['The point where the indicator changes colour', 'The equivalence point', 'The starting point', 'The half‑equivalence point'], 0,
         'The endpoint is often chosen to be as close as possible to the equivalence point.'),
        ('Which indicator is commonly used for strong acid‑strong base titrations?',
         ARRAY['Phenolphthalein', 'Methyl orange', 'Litmus', 'Bromothymol blue'], 0,
         'Phenolphthalein (colourless to pink) is common.'),
        ('What is chromatography?',
         ARRAY['A technique to separate components of a mixture based on differential partitioning', 'A method to purify metals', 'A technique to measure density', 'A technique to heat substances'], 0,
         'Chromatography uses a stationary and mobile phase.'),
        ('What is a standard solution?',
         ARRAY['A solution of known concentration', 'A solution of unknown concentration', 'A solution of pure solvent', 'A solution of high concentration'], 0,
         'Standard solutions are used in titrations.'),
        ('What is the role of a buffer solution?',
         ARRAY['To resist changes in pH when small amounts of acid or base are added', 'To change pH dramatically', 'To act as a strong acid', 'To act as a strong base'], 0,
         'Buffers contain a weak acid and its conjugate base.'),
        ('What is the pH of a buffer solution?',
         ARRAY['Given by the Henderson‑Hasselbalch equation', 'Always 7', 'Always acidic', 'Always basic'], 0,
         'pH = pKa + log([A⁻]/[HA]).'),
        ('What is spectroscopy?',
         ARRAY['The study of interaction between electromagnetic radiation and matter', 'The study of chemical reactions', 'The study of crystal structures', 'The study of organic compounds'], 0,
         'Spectroscopy is used to identify and quantify compounds.'),
        ('What does UV‑Vis spectroscopy measure?',
         ARRAY['Absorption of ultraviolet and visible light', 'Emission of infrared radiation', 'Nuclear magnetic resonance', 'Mass spectrometry'], 0,
         'UV‑Vis is used for quantification of absorbing species.'),
        ('What is mass spectrometry?',
         ARRAY['A technique that measures the mass‑to‑charge ratio of ions', 'A technique that measures colour', 'A technique that measures pH', 'A technique that measures conductivity'], 0,
         'Mass spectrometry gives molecular mass and structure information.'),
        ('What is the use of a flame test?',
         ARRAY['To identify metal ions based on characteristic colours', 'To measure acidity', 'To determine concentration', 'To separate mixtures'], 0,
         'Flame tests are qualitative.'),
        ('What is the use of a pH meter?',
         ARRAY['To measure the pH of a solution', 'To measure temperature', 'To measure conductivity', 'To measure absorbance'], 0,
         'pH meters use a glass electrode.'),
        ('What is the primary standard used in acid‑base titrations?',
         ARRAY['Potassium hydrogen phthalate (KHP)', 'Sodium hydroxide', 'Hydrochloric acid', 'Sulfuric acid'], 0,
         'KHP is a primary standard because it is stable and pure.'),
        ('What is a blank titration?',
         ARRAY['A titration without the analyte to correct for impurities', 'A titration with excess reagent', 'A titration with no indicator', 'A titration with a different analyte'], 0,
         'Blank corrections improve accuracy.'),
        ('What is the difference between accuracy and precision?',
         ARRAY['Accuracy is closeness to true value; precision is reproducibility', 'Accuracy is reproducibility; precision is closeness to true value', 'They are the same', 'Accuracy is always better'], 0,
         'Both are important in analytical chemistry.'),
        ('What is a calibration curve?',
         ARRAY['A plot of instrument response against known concentrations', 'A plot of pH against volume', 'A plot of temperature against time', 'A plot of absorbance against wavelength'], 0,
         'Calibration curves are used to determine concentration of unknowns.'),
        ('What is the principle of gel electrophoresis?',
         ARRAY['Separation of charged molecules (like DNA or proteins) in a gel under an electric field', 'Separation by size only', 'Separation by colour', 'Separation by density'], 0,
         'Electrophoresis is used in biochemistry.'),
        ('What is an indicator?',
         ARRAY['A substance that changes colour to signal the endpoint of a titration', 'A substance that changes pH', 'A substance that acts as a catalyst', 'A substance that buffers pH'], 0,
         'Indicators are often weak acids or bases.'),
        ('What is the purpose of a desiccator?',
         ARRAY['To dry substances or keep them free of moisture', 'To heat substances', 'To cool substances', 'To measure mass'], 0,
         'Desiccators contain a drying agent like silica gel.'),
        ('What is the difference between qualitative and quantitative analysis?',
         ARRAY['Qualitative identifies what; quantitative measures how much', 'Quantitative identifies what; qualitative measures how much', 'Both are the same', 'Qualitative is always accurate'], 0,
         'Analytical chemistry encompasses both.'),
        ('What is a Faraday cage used for in analytical chemistry?',
         ARRAY['To shield against electromagnetic interference', 'To contain samples', 'To heat samples', 'To measure pH'], 0,
         'Faraday cages protect sensitive measurements.'),
        ('What is the principle of spectrophotometry?',
         ARRAY['Measures how much light is absorbed or transmitted by a sample', 'Measures the mass of ions', 'Measures pH', 'Measures temperature'], 0,
         'Beer‑Lambert law relates absorbance to concentration.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_analytical, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 5. BIOCHEMISTRY (22 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the monomer of proteins?',
         ARRAY['Amino acids', 'Nucleotides', 'Monosaccharides', 'Fatty acids'], 0,
         'Proteins are polymers of amino acids.'),
        ('What is the monomer of nucleic acids?',
         ARRAY['Nucleotides', 'Amino acids', 'Glucose', 'Fatty acids'], 0,
         'DNA and RNA are made of nucleotides.'),
        ('What is the monomer of carbohydrates?',
         ARRAY['Monosaccharides', 'Amino acids', 'Nucleotides', 'Glycerol'], 0,
         'Carbohydrates are polymers of simple sugars.'),
        ('What is an enzyme?',
         ARRAY['A protein that catalyses biochemical reactions', 'A substrate', 'A product', 'A lipid'], 0,
         'Enzymes are biological catalysts.'),
        ('What is the active site of an enzyme?',
         ARRAY['The region where the substrate binds and catalysis occurs', 'The region where the product is released', 'The allosteric site', 'The regulatory site'], 0,
         'The active site is usually a pocket or cleft.'),
        ('What is the difference between DNA and RNA in biochemistry?',
         ARRAY['DNA contains deoxyribose and thymine; RNA contains ribose and uracil', 'DNA is single‑stranded; RNA is double‑stranded', 'DNA is found only in cytoplasm; RNA only in nucleus', 'Both are identical'], 0,
         'DNA stores genetic information; RNA is involved in protein synthesis.'),
        ('What is the role of ATP in cells?',
         ARRAY['It is the main energy currency for cellular processes', 'It stores genetic information', 'It builds proteins', 'It forms cell membranes'], 0,
         'ATP hydrolysis releases energy.'),
        ('Which organelles are responsible for producing ATP?',
         ARRAY['Mitochondria (in eukaryotes)', 'Ribosomes', 'Nucleus', 'Golgi apparatus'], 0,
         'Mitochondria are the powerhouse of the cell.'),
        ('What is glycolysis?',
         ARRAY['The breakdown of glucose to pyruvate, producing ATP', 'The synthesis of glucose', 'The breakdown of fatty acids', 'The citric acid cycle'], 0,
         'Glycolysis occurs in the cytoplasm.'),
        ('What is the Krebs cycle?',
         ARRAY['A series of reactions that oxidise acetyl‑CoA to CO₂ and generate energy', 'The cycle of glycolysis', 'The electron transport chain', 'The Calvin cycle'], 0,
         'The Krebs cycle takes place in the mitochondrial matrix.'),
        ('What is the electron transport chain?',
         ARRAY['A series of protein complexes that use electrons to pump protons and generate ATP', 'A chain of glucose molecules', 'A chain of amino acids', 'A chain of nucleotides'], 0,
         'ETC is located in the inner mitochondrial membrane.'),
        ('What is the role of chlorophyll in photosynthesis?',
         ARRAY['It absorbs light energy to drive electron transport', 'It fixes CO₂', 'It releases O₂', 'It synthesises ATP'], 0,
         'Chlorophyll is a pigment.'),
        ('What is the Calvin cycle?',
         ARRAY['The fixation of CO₂ into carbohydrates using ATP and NADPH', 'The breakdown of glucose', 'The synthesis of amino acids', 'The synthesis of lipids'], 0,
         'The Calvin cycle is light‑independent.'),
        ('What is an anabolic pathway?',
         ARRAY['Synthesis of larger molecules from smaller ones, consuming energy', 'Breakdown of molecules, releasing energy', 'Conversion of energy', 'Transport of molecules'], 0,
         'Anabolic reactions require ATP.'),
        ('What is a catabolic pathway?',
         ARRAY['Breakdown of molecules to release energy', 'Synthesis of molecules', 'Storage of energy', 'Transport of molecules'], 0,
         'Catabolism releases energy from nutrients.'),
        ('What is the function of a ribosome?',
         ARRAY['To synthesise proteins from amino acids', 'To synthesise lipids', 'To synthesise carbohydrates', 'To synthesise nucleic acids'], 0,
         'Ribosomes translate mRNA into protein.'),
        ('What is a codon?',
         ARRAY['A triplet of nucleotides on mRNA that codes for an amino acid', 'A triplet on tRNA', 'An amino acid', 'A type of protein'], 0,
         'Codons are read during translation.'),
        ('What is the role of tRNA?',
         ARRAY['To bring specific amino acids to the ribosome according to the codon', 'To carry the genetic message', 'To form the ribosome', 'To synthesise ATP'], 0,
         'tRNA has an anticodon and carries an amino acid.'),
        ('What is the difference between saturated and unsaturated fatty acids?',
         ARRAY['Saturated have no double bonds; unsaturated have one or more double bonds', 'Saturated have double bonds; unsaturated have none', 'Saturated are liquid at room temperature; unsaturated are solid', 'No difference'], 0,
         'Unsaturated fats are often liquid (oils).'),
        ('What is a peptide bond?',
         ARRAY['The covalent bond between the carboxyl group of one amino acid and the amino group of another', 'The bond between sugars', 'The bond between fatty acids and glycerol', 'The bond between nucleotides'], 0,
         'Peptide bonds link amino acids in proteins.'),
        ('What is the primary structure of a protein?',
         ARRAY['The linear sequence of amino acids', 'The α‑helix or β‑sheet', 'The 3D shape', 'The assembly of multiple subunits'], 0,
         'Primary structure is the amino acid sequence.'),
        ('What is the effect of pH on enzyme activity?',
         ARRAY['Enzymes have an optimal pH; activity decreases outside that range', 'Enzymes are unaffected by pH', 'Enzymes work best at extreme pH', 'Enzymes work best at neutral pH'], 0,
         'pH changes can denature enzymes.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_biochemistry, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 6. CHEMICAL REACTIONS (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What type of reaction is combination?',
         ARRAY['Two or more reactants form a single product (A + B → AB)', 'A compound breaks down (AB → A + B)', 'Exchange of partners (AB + CD → AD + CB)', 'Oxidation‑reduction'], 0,
         'Synthesis reactions combine simpler substances.'),
        ('What is a decomposition reaction?',
         ARRAY['A compound breaks down into simpler substances (AB → A + B)', 'Two or more combine', 'Exchange of ions', 'Acid‑base reaction'], 0,
         'Decomposition is the reverse of combination.'),
        ('What is a displacement reaction?',
         ARRAY['A more reactive element displaces a less reactive one from a compound', 'A compound breaks down', 'Two compounds exchange ions', 'A compound reacts with oxygen'], 0,
         'Example: Zn + CuSO₄ → ZnSO₄ + Cu.'),
        ('What is a redox reaction?',
         ARRAY['A reaction where oxidation and reduction occur simultaneously', 'A reaction with no electron transfer', 'A reaction with only oxidation', 'A reaction with only reduction'], 0,
         'Redox involves electron transfer.'),
        ('What is oxidation?',
         ARRAY['Loss of electrons (increase in oxidation state)', 'Gain of electrons', 'Addition of oxygen', 'Removal of hydrogen'], 0,
         'Oxidation can be defined as loss of electrons or gain of oxygen.'),
        ('What is reduction?',
         ARRAY['Gain of electrons (decrease in oxidation state)', 'Loss of electrons', 'Addition of hydrogen', 'Removal of oxygen'], 0,
         'Reduction is gain of electrons.'),
        ('What is an acid‑base reaction?',
         ARRAY['A reaction between an acid and a base to produce salt and water (neutralisation)', 'A reaction that produces gas', 'A reaction that produces a precipitate', 'A reaction that transfers electrons'], 0,
         'Neutralisation is a specific type of acid‑base reaction.'),
        ('What is the Arrhenius definition of an acid?',
         ARRAY['A substance that increases H⁺ concentration in water', 'A substance that increases OH⁻ concentration', 'A proton donor', 'A proton acceptor'], 0,
         'Arrhenius acids release H⁺ in water.'),
        ('What is the Bronsted‑Lowry definition of an acid?',
         ARRAY['A proton donor', 'A proton acceptor', 'An electron pair donor', 'An electron pair acceptor'], 0,
         'Bronsted‑Lowry acids are proton donors.'),
        ('What is a conjugate acid‑base pair?',
         ARRAY['Two species that differ by one proton (H⁺)', 'Two species that differ by one electron', 'Two species that differ by one neutron', 'Two species that are identical'], 0,
         'Example: HCl/Cl⁻, NH₄⁺/NH₃.'),
        ('What is a precipitation reaction?',
         ARRAY['The formation of an insoluble solid from the mixing of two solutions', 'The formation of gas', 'The formation of water', 'The transfer of electrons'], 0,
         'Precipitates form when ions combine to form a sparingly soluble compound.'),
        ('What is a combustion reaction?',
         ARRAY['A reaction with oxygen, producing heat and usually light', 'A reaction with water', 'A reaction with acid', 'A reaction with base'], 0,
         'Combustion often produces CO₂ and H₂O.'),
        ('What is the law of conservation of mass?',
         ARRAY['Mass is neither created nor destroyed in a chemical reaction', 'Mass can be created', 'Mass can be destroyed', 'Mass changes by energy'], 0,
         'The total mass of reactants equals the total mass of products.'),
        ('What is a chemical equation?',
         ARRAY['A symbolic representation of a chemical reaction', 'A physical equation', 'A mathematical equation', 'An algebraic equation'], 0,
         'Chemical equations show reactants and products.'),
        ('What does a coefficient in a chemical equation indicate?',
         ARRAY['The number of moles of a substance', 'The charge', 'The state', 'The temperature'], 0,
         'Coefficients are used for balancing.'),
        ('What is the activity series of metals used for?',
         ARRAY['To predict displacement reactions', 'To measure pH', 'To identify elements', 'To determine density'], 0,
         'More reactive metals displace less reactive ones.'),
        ('What is an exothermic reaction?',
         ARRAY['A reaction that releases heat (ΔH < 0)', 'A reaction that absorbs heat (ΔH > 0)', 'A reaction that does not change temperature', 'A reaction that produces light'], 0,
         'Exothermic reactions often feel hot.'),
        ('What is an endothermic reaction?',
         ARRAY['A reaction that absorbs heat (ΔH > 0)', 'A reaction that releases heat (ΔH < 0)', 'A reaction that is spontaneous', 'A reaction that is fast'], 0,
         'Endothermic reactions feel cold.'),
        ('What is the role of a catalyst?',
         ARRAY['It speeds up a reaction without being consumed', 'It is consumed', 'It changes the products', 'It stops the reaction'], 0,
         'Catalysts provide an alternative pathway.'),
        ('What is the meaning of "reaction rate"?',
         ARRAY['The change in concentration of a reactant or product per unit time', 'The total time for completion', 'The energy change', 'The activation energy'], 0,
         'Rate can be expressed in mol/(L·s).')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_reactions, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 7. ELEMENTS (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the chemical symbol for gold?',
         ARRAY['Au', 'Ag', 'Fe', 'Cu'], 0,
         'Au comes from Latin "aurum".'),
        ('What is the chemical symbol for silver?',
         ARRAY['Ag', 'Au', 'Fe', 'Sn'], 0,
         'Ag from Latin "argentum".'),
        ('What is the symbol for tin?',
         ARRAY['Sn', 'Sb', 'Ti', 'Te'], 0,
         'Sn from Latin "stannum".'),
        ('Which element is the most abundant in the universe?',
         ARRAY['Hydrogen', 'Helium', 'Oxygen', 'Carbon'], 0,
         'Hydrogen makes up about 75% of the universe''s mass.'),
        ('Which element is the most abundant in the Earth''s atmosphere?',
         ARRAY['Nitrogen', 'Oxygen', 'Argon', 'Carbon dioxide'], 0,
         'Nitrogen is about 78% of the atmosphere.'),
        ('Which element is a noble gas?',
         ARRAY['Helium (He)', 'Sodium (Na)', 'Chlorine (Cl)', 'Magnesium (Mg)'], 0,
         'Noble gases include He, Ne, Ar, Kr, Xe, Rn.'),
        ('What is the lightest element?',
         ARRAY['Hydrogen', 'Helium', 'Lithium', 'Beryllium'], 0,
         'Hydrogen has atomic number 1.'),
        ('What is the heaviest naturally occurring element?',
         ARRAY['Uranium (U)', 'Plutonium (Pu)', 'Lead (Pb)', 'Gold (Au)'], 0,
         'Uranium (atomic number 92) is the heaviest natural.'),
        ('Which element has the highest melting point?',
         ARRAY['Tungsten (W)', 'Carbon (diamond)', 'Osmium', 'Rhenium'], 0,
         'Tungsten melts at 3422°C.'),
        ('Which element has the highest thermal conductivity?',
         ARRAY['Silver', 'Copper', 'Gold', 'Aluminium'], 0,
         'Silver has the highest electrical and thermal conductivity.'),
        ('What is the most abundant metal in the human body?',
         ARRAY['Calcium', 'Potassium', 'Sodium', 'Iron'], 0,
         'Calcium is the most abundant metal, mainly in bones.'),
        ('Which element is used in the production of steel?',
         ARRAY['Iron', 'Copper', 'Aluminium', 'Zinc'], 0,
         'Steel is an alloy of iron and carbon.'),
        ('What is the chemical symbol for lead?',
         ARRAY['Pb', 'Pb', 'Pd', 'Pt'], 0,
         'Pb from Latin "plumbum".'),
        ('Which element is a liquid at room temperature (besides mercury)?',
         ARRAY['Bromine (Br₂)', 'Gallium (Ga)', 'Caesium (Cs)', 'Francium (Fr)'], 0,
         'Bromine is the only non‑metal liquid at room temperature.'),
        ('What is the most reactive metal?',
         ARRAY['Francium (Fr) (but rare)', 'Caesium (Cs)', 'Potassium (K)', 'Sodium (Na)'], 0,
         'Francium is the most reactive but extremely rare.'),
        ('What is the most abundant element in the Earth''s core?',
         ARRAY['Iron', 'Nickel', 'Oxygen', 'Silicon'], 0,
         'The core is mostly iron and nickel.'),
        ('Which element is used as a fuel in nuclear reactors?',
         ARRAY['Uranium‑235', 'Plutonium‑239', 'Both', 'Thorium'], 2,
         'Both U‑235 and Pu‑239 are fissionable.'),
        ('What is the symbol for copper?',
         ARRAY['Cu', 'Co', 'Cr', 'Ca'], 0,
         'Cu from Latin "cuprum".'),
        ('Which element is a key component of chlorophyll?',
         ARRAY['Magnesium', 'Iron', 'Manganese', 'Zinc'], 0,
         'Chlorophyll contains magnesium.'),
        ('What is the symbol for sodium?',
         ARRAY['Na', 'S', 'So', 'Nd'], 0,
         'Na from Latin "natrium".')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_elements, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 8. PERIODIC TABLE (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Who is credited with creating the first widely recognised periodic table?',
         ARRAY['Dmitri Mendeleev', 'Lothar Meyer', 'John Newlands', 'Henry Moseley'], 0,
         'Mendeleev published his table in 1869, arranging elements by atomic mass and predicting missing elements.'),
        ('How is the modern periodic table arranged?',
         ARRAY['By increasing atomic number', 'By increasing atomic mass', 'By increasing atomic radius', 'By increasing electronegativity'], 0,
         'The modern table is ordered by atomic number (number of protons).'),
        ('What are the vertical columns called in the periodic table?',
         ARRAY['Groups or families', 'Periods', 'Series', 'Blocks'], 0,
         'Groups are numbered 1–18 and contain elements with similar chemical properties.'),
        ('What are the horizontal rows called?',
         ARRAY['Periods', 'Groups', 'Series', 'Blocks'], 0,
         'There are seven periods, corresponding to the number of electron shells.'),
        ('Which group contains the noble gases?',
         ARRAY['Group 18', 'Group 1', 'Group 2', 'Group 17'], 0,
         'Noble gases (He, Ne, Ar, Kr, Xe, Rn) are in Group 18 (or 8A).'),
        ('Which group contains the alkali metals?',
         ARRAY['Group 1', 'Group 2', 'Group 17', 'Group 18'], 0,
         'Alkali metals (Li, Na, K, etc.) are in Group 1 (except hydrogen).'),
        ('Which group contains the halogens?',
         ARRAY['Group 17', 'Group 1', 'Group 2', 'Group 18'], 0,
         'Halogens (F, Cl, Br, I, At) are in Group 17.'),
        ('What is the trend of atomic radius across a period?',
         ARRAY['Decreases from left to right', 'Increases from left to right', 'Remains constant', 'First increases then decreases'], 0,
         'Effective nuclear charge increases, pulling electrons closer.'),
        ('What is the trend of atomic radius down a group?',
         ARRAY['Increases', 'Decreases', 'Remains constant', 'Increases then decreases'], 0,
         'New electron shells are added, making atoms larger.'),
        ('What is the trend of electronegativity across a period?',
         ARRAY['Increases from left to right', 'Decreases from left to right', 'Remains constant', 'Increases then decreases'], 0,
         'Electronegativity increases as atoms become smaller and more eager to gain electrons.'),
        ('Which element has the highest electronegativity?',
         ARRAY['Fluorine', 'Oxygen', 'Chlorine', 'Nitrogen'], 0,
         'Fluorine has the highest electronegativity (Pauling scale: 3.98).'),
        ('Which element has the lowest electronegativity?',
         ARRAY['Francium (or Caesium if considering stable)', 'Lithium', 'Sodium', 'Potassium'], 0,
         'Francium has the lowest electronegativity (~0.7), but Caesium is often cited as the most electropositive.'),
        ('What is the trend of ionisation energy across a period?',
         ARRAY['Increases from left to right', 'Decreases from left to right', 'Remains constant', 'Increases then decreases'], 0,
         'Ionisation energy increases with increasing nuclear charge and decreasing radius.'),
        ('What is the trend of ionisation energy down a group?',
         ARRAY['Decreases', 'Increases', 'Remains constant', 'Decreases then increases'], 0,
         'Outer electrons are farther from the nucleus and more shielded, so easier to remove.'),
        ('Which group contains elements with a full valence shell?',
         ARRAY['Group 18 (noble gases)', 'Group 1', 'Group 2', 'Group 17'], 0,
         'Noble gases have completely filled outermost s and p subshells (except He).'),
        ('How many periods are there in the periodic table?',
         ARRAY['7', '8', '6', '9'], 0,
         'There are 7 periods, though period 7 includes the actinides.'),
        ('How many groups are there in the main‑group elements?',
         ARRAY['8 main groups (1–2 and 13–18)', '18', '10', '12'], 0,
         'Main groups are s‑block (1–2) and p‑block (13–18), totaling 8 groups, but the IUPAC numbers 1–18.'),
        ('Which element has the smallest atomic radius?',
         ARRAY['Helium', 'Neon', 'Fluorine', 'Hydrogen'], 0,
         'Helium has the smallest atomic radius because it has only one shell and high effective nuclear charge.'),
        ('Which element has the largest atomic radius?',
         ARRAY['Francium (or Caesium)', 'Rubidium', 'Potassium', 'Sodium'], 0,
         'Francium is the largest atom (theoretical), but Caesium is the largest stable.'),
        ('What is the basis for Mendeleev''s prediction of unknown elements?',
         ARRAY['He left gaps and predicted properties based on atomic mass and periodicity', 'He used atomic number', 'He used electron configuration', 'He used isotopes'], 0,
         'Mendeleev predicted eka‑aluminium (gallium), eka‑silicon (germanium), etc., with remarkable accuracy.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_periodic, q_rec.column1, 'single_choice', q_rec.column4)
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