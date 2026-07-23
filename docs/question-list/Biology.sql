-- ============================================================================
-- Insert 250 factual questions on Biology.
-- Subtopics: Cells, DNA, Evolution, Ecology, Marine Biology, Zoology, Botany,
-- Genetics, Human Biology, Biotechnology.
-- ============================================================================

DO $$
DECLARE
    cat_id_cells          BIGINT;
    cat_id_dna            BIGINT;
    cat_id_evolution      BIGINT;
    cat_id_ecology        BIGINT;
    cat_id_marine         BIGINT;
    cat_id_zoology        BIGINT;
    cat_id_botany         BIGINT;
    cat_id_genetics       BIGINT;
    cat_id_human          BIGINT;
    cat_id_biotech        BIGINT;
    q_id                  BIGINT;
    correct_opt_id        BIGINT;
    opt_texts             TEXT[];
    q_rec                 RECORD;
BEGIN
    -- ------------------------------------------------------------------------
    -- Create categories (hierarchical under biology)
    -- ------------------------------------------------------------------------
    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('biology', 'Biology', 1, 0)
        ON CONFLICT (path) DO NOTHING;

    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('biology.cells',           'Cells', 1, 1),
        ('biology.dna',             'DNA', 1, 2),
        ('biology.evolution',       'Evolution', 1, 3),
        ('biology.ecology',         'Ecology', 1, 4),
        ('biology.marine_biology',  'Marine Biology', 1, 5),
        ('biology.zoology',         'Zoology', 1, 6),
        ('biology.botany',          'Botany', 1, 7),
        ('biology.genetics',        'Genetics', 1, 8),
        ('biology.human_biology',   'Human Biology', 1, 9),
        ('biology.biotechnology',   'Biotechnology', 1, 10)
        ON CONFLICT (path) DO NOTHING;

    -- Get category IDs
    SELECT id INTO cat_id_cells    FROM categories WHERE path = 'biology.cells';
    SELECT id INTO cat_id_dna      FROM categories WHERE path = 'biology.dna';
    SELECT id INTO cat_id_evolution FROM categories WHERE path = 'biology.evolution';
    SELECT id INTO cat_id_ecology  FROM categories WHERE path = 'biology.ecology';
    SELECT id INTO cat_id_marine   FROM categories WHERE path = 'biology.marine_biology';
    SELECT id INTO cat_id_zoology  FROM categories WHERE path = 'biology.zoology';
    SELECT id INTO cat_id_botany   FROM categories WHERE path = 'biology.botany';
    SELECT id INTO cat_id_genetics FROM categories WHERE path = 'biology.genetics';
    SELECT id INTO cat_id_human    FROM categories WHERE path = 'biology.human_biology';
    SELECT id INTO cat_id_biotech  FROM categories WHERE path = 'biology.biotechnology';

    -- ========================================================================
    -- 1. CELLS (25 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the basic unit of life?',
         ARRAY['Cell', 'Atom', 'Molecule', 'Tissue'], 0,
         'The cell is the smallest structural and functional unit of living organisms.'),
        ('Which organelle is known as the powerhouse of the cell?',
         ARRAY['Mitochondria', 'Ribosomes', 'Endoplasmic reticulum', 'Golgi apparatus'], 0,
         'Mitochondria generate ATP through cellular respiration.'),
        ('What is the main function of the nucleus?',
         ARRAY['To contain genetic material and control cell activities', 'To produce proteins', 'To synthesise lipids', 'To digest waste'], 0,
         'The nucleus houses DNA and coordinates cell functions.'),
        ('Which organelle is responsible for photosynthesis?',
         ARRAY['Chloroplast', 'Mitochondria', 'Chromoplast', 'Leucoplast'], 0,
         'Chloroplasts contain chlorophyll and perform photosynthesis.'),
        ('What is the cell membrane mainly composed of?',
         ARRAY['Phospholipid bilayer', 'Protein', 'Carbohydrate', 'Nucleic acid'], 0,
         'The phospholipid bilayer provides a semi‑permeable barrier.'),
        ('Which organelle modifies, sorts, and packages proteins?',
         ARRAY['Golgi apparatus', 'Rough ER', 'Smooth ER', 'Lysosomes'], 0,
         'The Golgi complex processes proteins for secretion or intracellular use.'),
        ('What is the function of ribosomes?',
         ARRAY['Protein synthesis', 'Lipid synthesis', 'Energy production', 'Waste breakdown'], 0,
         'Ribosomes translate mRNA into polypeptide chains.'),
        ('What is the cytoplasm?',
         ARRAY['The gel‑like substance within the cell membrane', 'The outer covering of the cell', 'The genetic material', 'The energy‑producing organelle'], 0,
         'Cytoplasm fills the cell and contains organelles.'),
        ('Which organelle contains digestive enzymes?',
         ARRAY['Lysosomes', 'Peroxisomes', 'Vacuoles', 'Centrioles'], 0,
         'Lysosomes break down waste materials and cellular debris.'),
        ('What is the cytoskeleton made of?',
         ARRAY['Microtubules, microfilaments, and intermediate filaments', 'Cellulose', 'Chitin', 'Collagen'], 0,
         'The cytoskeleton provides structure and aids in movement.'),
        ('Which type of cell has a nucleus?',
         ARRAY['Eukaryotic cell', 'Prokaryotic cell', 'Both', 'Neither'], 0,
         'Eukaryotes have a membrane‑bound nucleus; prokaryotes do not.'),
        ('What is the function of the cell wall in plants?',
         ARRAY['To provide structural support and protection', 'To store genetic material', 'To synthesize proteins', 'To produce energy'], 0,
         'The cell wall is made of cellulose and gives rigidity.'),
        ('What is the process of cell division in somatic cells called?',
         ARRAY['Mitosis', 'Meiosis', 'Binary fission', 'Budding'], 0,
         'Mitosis produces two identical daughter cells.'),
        ('Which organelle is involved in lipid synthesis?',
         ARRAY['Smooth endoplasmic reticulum', 'Rough ER', 'Golgi', 'Mitochondria'], 0,
         'Smooth ER lacks ribosomes and synthesises lipids and detoxifies.'),
        ('What is the role of the nucleolus?',
         ARRAY['Production of ribosomal RNA', 'DNA replication', 'Protein folding', 'Cell respiration'], 0,
         'The nucleolus assembles ribosome subunits.'),
        ('Which type of endoplasmic reticulum has ribosomes attached?',
         ARRAY['Rough ER', 'Smooth ER', 'Both', 'Neither'], 0,
         'Rough ER is studded with ribosomes and is involved in protein synthesis.'),
        ('What is the difference between plant and animal cells?',
         ARRAY['Plant cells have a cell wall, chloroplasts, and a large central vacuole', 'Animal cells have a cell wall', 'Plant cells have centrioles', 'No difference'], 0,
         'Plant cells have unique structures not found in animal cells.'),
        ('What is the main energy currency of the cell?',
         ARRAY['ATP', 'ADP', 'Glucose', 'NADH'], 0,
         'ATP (adenosine triphosphate) provides energy for cellular processes.'),
        ('Which organelle is responsible for detoxifying harmful substances?',
         ARRAY['Peroxisomes', 'Lysosomes', 'Smooth ER', 'Both peroxisomes and smooth ER'], 3,
         'Peroxisomes break down fatty acids and detoxify, while smooth ER also detoxifies.'),
        ('What is the plasma membrane composed of?',
         ARRAY['Lipids, proteins, and carbohydrates', 'Only proteins', 'Only lipids', 'Nucleic acids'], 0,
         'The fluid mosaic model includes a phospholipid bilayer with embedded proteins and carbohydrates.'),
        ('What is the function of vacuoles in plant cells?',
         ARRAY['Storage of water and nutrients; maintain turgor pressure', 'Energy production', 'Protein synthesis', 'DNA replication'], 0,
         'The central vacuole stores water and helps maintain cell rigidity.'),
        ('Which organelle is involved in cell division in animal cells?',
         ARRAY['Centrioles', 'Chloroplasts', 'Vacuoles', 'Ribosomes'], 0,
         'Centrioles help organise the mitotic spindle.'),
        ('What is the outer boundary of a eukaryotic cell?',
         ARRAY['Plasma membrane', 'Cell wall', 'Glycocalyx', 'Capsule'], 0,
         'All eukaryotic cells have a plasma membrane; plants have an additional cell wall.'),
        ('Which organelle is responsible for generating ATP in plant cells?',
         ARRAY['Mitochondria and chloroplasts', 'Only mitochondria', 'Only chloroplasts', 'Neither'], 0,
         'Plant cells produce ATP via mitochondria (respiration) and chloroplasts (photosynthesis).'),
        ('What is the term for the internal fluid of a chloroplast?',
         ARRAY['Stroma', 'Thylakoid', 'Granum', 'Matrix'], 0,
         'The stroma is the fluid‑filled space where the Calvin cycle occurs.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_cells, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 2. DNA (25 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What does DNA stand for?',
         ARRAY['Deoxyribonucleic acid', 'Dideoxyribonucleic acid', 'Deoxynucleic acid', 'Dinitro nucleic acid'], 0,
         'DNA is the hereditary material in most organisms.'),
        ('What is the shape of a DNA molecule?',
         ARRAY['Double helix', 'Single strand', 'Triple helix', 'Circular'], 0,
         'The double helix was described by Watson and Crick in 1953.'),
        ('Which four nitrogenous bases are found in DNA?',
         ARRAY['Adenine, thymine, guanine, cytosine', 'Adenine, uracil, guanine, cytosine', 'Adenine, guanine, cytosine, thymine', 'All of the above'], 0,
         'Adenine (A), thymine (T), guanine (G), cytosine (C) – purines and pyrimidines.'),
        ('What is the complementary base to adenine?',
         ARRAY['Thymine', 'Uracil', 'Guanine', 'Cytosine'], 0,
         'A pairs with T (two hydrogen bonds).'),
        ('What is the sugar in DNA?',
         ARRAY['Deoxyribose', 'Ribose', 'Glucose', 'Fructose'], 0,
         'Deoxyribose is a five‑carbon sugar.'),
        ('What is a gene?',
         ARRAY['A segment of DNA that codes for a protein or functional RNA', 'An entire chromosome', 'A protein', 'A nucleotide'], 0,
         'Genes are the basic units of heredity.'),
        ('What is the process of copying DNA called?',
         ARRAY['Replication', 'Transcription', 'Translation', 'Transformation'], 0,
         'DNA replication occurs before cell division.'),
        ('Which enzyme unwinds the DNA double helix during replication?',
         ARRAY['Helicase', 'DNA polymerase', 'Ligase', 'Primase'], 0,
         'Helicase breaks hydrogen bonds between base pairs.'),
        ('What is the "central dogma" of molecular biology?',
         ARRAY['DNA → RNA → Protein', 'RNA → DNA → Protein', 'Protein → DNA → RNA', 'DNA → Protein → RNA'], 0,
         'The flow of genetic information from DNA to RNA to protein.'),
        ('What is a mutation?',
         ARRAY['A change in the DNA sequence', 'A protein change', 'A change in RNA', 'A cell division error'], 0,
         'Mutations can be spontaneous or induced and may affect phenotype.'),
        ('Which type of RNA carries the genetic code from the nucleus to the ribosome?',
         ARRAY['mRNA', 'tRNA', 'rRNA', 'snRNA'], 0,
         'Messenger RNA (mRNA) carries the template for protein synthesis.'),
        ('What is the function of tRNA?',
         ARRAY['To bring amino acids to the ribosome', 'To carry genetic information', 'To form the ribosome', 'To splice RNA'], 0,
         'Transfer RNA (tRNA) has anticodons and carries specific amino acids.'),
        ('What is the result of DNA replication?',
         ARRAY['Two identical DNA molecules', 'Two different DNA molecules', 'One DNA and one RNA', 'One DNA and one protein'], 0,
         'Semiconservative replication yields two daughter molecules each with one old and one new strand.'),
        ('What is the name of the enzyme that joins Okazaki fragments?',
         ARRAY['DNA ligase', 'DNA polymerase', 'Primase', 'Topoisomerase'], 0,
         'Ligase seals nicks in the sugar‑phosphate backbone.'),
        ('What is the genetic code?',
         ARRAY['The set of rules by which nucleotide triplets (codons) specify amino acids', 'The sequence of DNA in a chromosome', 'The set of all proteins', 'The RNA sequence'], 0,
         'The genetic code is degenerate and universal.'),
        ('What is the structure of a nucleotide?',
         ARRAY['A phosphate group, a sugar, and a nitrogenous base', 'A phosphate and a sugar only', 'A sugar and a base', 'A phosphate and a base'], 0,
         'Nucleotides are the monomers of nucleic acids.'),
        ('What is the difference between DNA and RNA?',
         ARRAY['DNA has deoxyribose and thymine; RNA has ribose and uracil', 'DNA is single‑stranded; RNA is double‑stranded', 'No difference', 'DNA is found only in the nucleus'], 0,
         'RNA typically has uracil instead of thymine and uses ribose.'),
        ('What is the function of DNA polymerase?',
         ARRAY['To synthesise DNA strands by adding nucleotides', 'To unwind DNA', 'To join DNA fragments', 'To transcribe RNA'], 0,
         'DNA polymerase adds nucleotides to the growing chain.'),
        ('What is a codon?',
         ARRAY['A sequence of three nucleotides that code for an amino acid', 'A sequence of three amino acids', 'A protein', 'A gene'], 0,
         'Codons are on mRNA and specify amino acids.'),
        ('What is the role of the promoter in transcription?',
         ARRAY['To signal where RNA polymerase should bind', 'To stop transcription', 'To splice introns', 'To add a cap'], 0,
         'Promoters are DNA sequences upstream of genes that initiate transcription.'),
        ('What is the human genome size?',
         ARRAY['About 3 billion base pairs', 'About 3 million base pairs', 'About 3 trillion base pairs', 'About 3 thousand base pairs'], 0,
         'The human haploid genome has approximately 3.2 billion base pairs.'),
        ('What is epigenetics?',
         ARRAY['Changes in gene expression without altering the DNA sequence', 'Mutation of DNA', 'Changing the DNA sequence', 'RNA editing'], 0,
         'Epigenetic modifications include DNA methylation and histone acetylation.'),
        ('What is the purpose of DNA repair mechanisms?',
         ARRAY['To correct damaged DNA', 'To replicate DNA', 'To transcribe DNA', 'To degrade DNA'], 0,
         'DNA repair maintains genomic integrity.'),
        ('Which nitrogenous base is found in RNA but not DNA?',
         ARRAY['Uracil', 'Thymine', 'Guanine', 'Cytosine'], 0,
         'Uracil replaces thymine in RNA.'),
        ('What is a plasmid?',
         ARRAY['A small circular DNA molecule in bacteria, often used in genetic engineering', 'A type of chromosome', 'A type of RNA', 'A viral genome'], 0,
         'Plasmids are extrachromosomal and can replicate independently.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_dna, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 3. EVOLUTION (25 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Who proposed the theory of natural selection?',
         ARRAY['Charles Darwin and Alfred Russel Wallace', 'Jean‑Baptiste Lamarck', 'Gregor Mendel', 'Thomas Malthus'], 0,
         'Darwin and Wallace independently conceived the idea of evolution by natural selection.'),
        ('What is the process by which individuals with advantageous traits are more likely to survive and reproduce?',
         ARRAY['Natural selection', 'Artificial selection', 'Genetic drift', 'Gene flow'], 0,
         'Natural selection drives adaptation.'),
        ('What is the name for remains or traces of ancient life?',
         ARRAY['Fossils', 'Genes', 'Homologies', 'Analogies'], 0,
         'Fossils provide direct evidence of past organisms.'),
        ('What is the study of the distribution of species across different geographic regions?',
         ARRAY['Biogeography', 'Ecology', 'Genetics', 'Paleontology'], 0,
         'Biogeography supports evolution by showing patterns of dispersal and isolation.'),
        ('What is the difference between homologous and analogous structures?',
         ARRAY['Homologous share a common ancestry; analogous share similar function but not ancestry', 'Homologous have similar function; analogous have similar structure', 'Both are the same', 'Homologous are found in plants; analogous in animals'], 0,
         'Homologous structures (e.g., vertebrate forelimbs) indicate common descent.'),
        ('What is the main source of genetic variation in populations?',
         ARRAY['Mutation and sexual reproduction (recombination)', 'Natural selection', 'Genetic drift', 'Migration'], 0,
         'Mutations create new alleles; recombination shuffles them.'),
        ('What is the "founder effect" in population genetics?',
         ARRAY['A new population established by a few individuals leads to reduced genetic diversity', 'A large population loses alleles', 'Migration increases diversity', 'Selection changes allele frequencies'], 0,
         'Founder effect is a type of genetic drift.'),
        ('What is the theory of "punctuated equilibrium"?',
         ARRAY['Long periods of stasis interrupted by rapid change', 'Gradual change over time', 'No change', 'Continuous change'], 0,
         'Proposed by Eldredge and Gould.'),
        ('What is the age of the Earth, according to modern geology?',
         ARRAY['About 4.5 billion years', 'About 6,000 years', 'About 1 billion years', 'About 3.8 billion years'], 0,
         'Radiometric dating indicates Earth is 4.54 billion years old.'),
        ('Which structures are remnants of organs that had a function in ancestors?',
         ARRAY['Vestigial structures', 'Homologous structures', 'Analogous structures', 'Fossils'], 0,
         'Examples: human appendix, whale pelvis, and snake hind limbs.'),
        ('What is the biological species concept?',
         ARRAY['A group of interbreeding populations that produce viable, fertile offspring', 'A group with similar morphology', 'A group that shares a recent ancestor', 'A group with similar ecology'], 0,
         'Defined by Ernst Mayr; not applicable to asexual organisms.'),
        ('What is allopatric speciation?',
         ARRAY['Speciation due to geographic isolation', 'Speciation within the same area', 'Polyploidy', 'Hybridisation'], 0,
         'Geographic isolation leads to reproductive isolation.'),
        ('What is the role of fossils in evolutionary biology?',
         ARRAY['They provide historical evidence of life and transitional forms', 'They are only used to date rocks', 'They show no change', 'They are artifacts'], 0,
         'Fossils document the history of life on Earth.'),
        ('What is the "tree of life" in evolution?',
         ARRAY['A diagram showing the evolutionary relationships among all organisms', 'A classification system', 'A timeline', 'A phylogenetic tree'], 0,
         'Phylogenetic trees represent common ancestry.'),
        ('What is natural selection often described as?',
         ARRAY['Survival of the fittest', 'Survival of the strongest', 'Survival of the most intelligent', 'Survival of the largest'], 0,
         '"Fittest" refers to reproductive success, not just strength.'),
        ('Which type of selection favors one extreme phenotype?',
         ARRAY['Directional selection', 'Stabilizing selection', 'Disruptive selection', 'Balancing selection'], 0,
         'Directional selection shifts the mean of a trait.'),
        ('What is the "Red Queen" hypothesis?',
         ARRAY['Organisms must constantly adapt to keep up with evolving competitors and predators', 'Sexual selection', 'Climate change', 'Extinction events'], 0,
         'From Lewis Carroll: "It takes all the running you can do, to keep in the same place."'),
        ('What is the difference between macroevolution and microevolution?',
         ARRAY['Macroevolution is large‑scale change above species level; microevolution is change within populations', 'Microevolution is small; macroevolution is large', 'They are the same', 'Macroevolution is faster'], 0,
         'Microevolution leads to macroevolution over long periods.'),
        ('What are phylogenetic trees based on?',
         ARRAY['Shared derived characteristics (synapomorphies)', 'Similarities in habitat', 'Behaviour', 'Size'], 0,
         'Cladistics uses shared derived traits to infer relationships.'),
        ('What is the "Cambrian explosion"?',
         ARRAY['A rapid diversification of animal life ~541 million years ago', 'A mass extinction', 'The appearance of dinosaurs', 'The origin of life'], 0,
         'Many major animal phyla appear in the Cambrian fossil record.'),
        ('What is the endosymbiotic theory?',
         ARRAY['Eukaryotic organelles like mitochondria and chloroplasts originated from free‑living prokaryotes', 'Cells evolved from viruses', 'Eukaryotes evolved from bacteria', 'All life comes from a single ancestor'], 0,
         'Proposed by Lynn Margulis, supported by organellar DNA and ribosomes.'),
        ('What is a "fitness" in evolutionary terms?',
         ARRAY['The ability of an organism to survive and reproduce', 'Physical strength', 'Speed', 'Intelligence'], 0,
         'Fitness is measured by reproductive success.'),
        ('What is genetic drift?',
         ARRAY['Random changes in allele frequencies, especially in small populations', 'Non‑random mating', 'Migration', 'Natural selection'], 0,
         'Genetic drift is a stochastic evolutionary force.'),
        ('Which scientist proposed that giraffes got long necks by stretching?',
         ARRAY['Jean‑Baptiste Lamarck', 'Darwin', 'Wallace', 'Mendel'], 0,
         'Lamarck proposed inheritance of acquired characteristics, which is not supported.'),
        ('What is a "molecular clock" used for?',
         ARRAY['Estimating time of divergence between species using DNA mutations', 'Measuring time using genes', 'Clocking mutations', 'Absolute dating'], 0,
         'Molecular clocks rely on neutral mutation rates.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_evolution, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 4. ECOLOGY (25 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is ecology?',
         ARRAY['The study of interactions between organisms and their environment', 'The study of genetics', 'The study of cells', 'The study of evolution'], 0,
         'Ecology encompasses biotic and abiotic interactions.'),
        ('What is an ecosystem?',
         ARRAY['A community of living organisms and their physical environment', 'All the organisms in an area', 'The non‑living parts of an environment', 'A population'], 0,
         'Ecosystems include both biotic and abiotic components.'),
        ('What is a biome?',
         ARRAY['A large geographic area with similar climate and vegetation', 'A small habitat', 'A single species range', 'A specific ecosystem'], 0,
         'Examples: desert, tropical rainforest, taiga.'),
        ('Which trophic level produces its own food?',
         ARRAY['Producers (autotrophs)', 'Primary consumers', 'Secondary consumers', 'Decomposers'], 0,
         'Producers convert sunlight or chemical energy into organic matter.'),
        ('What is the 10% rule in ecology?',
         ARRAY['Only about 10% of energy is transferred from one trophic level to the next', '10% of energy is lost as heat', '10% of organisms survive', '10% of biomass is consumed'], 0,
         'Energy transfer is inefficient; most is lost as heat.'),
        ('What is a food chain?',
         ARRAY['A linear sequence of who eats whom', 'A complex network of feeding relationships', 'A cycle of energy', 'A pyramid of biomass'], 0,
         'A food chain shows a single path of energy flow.'),
        ('What is a food web?',
         ARRAY['Interconnected food chains representing multiple feeding relationships', 'A single chain', 'A pyramid', 'A cycle'], 0,
         'Food webs are more realistic than food chains.'),
        ('Which type of organism breaks down dead organic matter?',
         ARRAY['Decomposers (e.g., fungi, bacteria)', 'Producers', 'Consumers', 'Parasites'], 0,
         'Decomposers recycle nutrients back into the ecosystem.'),
        ('What is a keystone species?',
         ARRAY['A species that has a disproportionately large effect on its ecosystem', 'The most abundant species', 'The top predator', 'A rare species'], 0,
         'Examples: sea otters, wolves, starfish.'),
        ('What is an invasive species?',
         ARRAY['A non‑native species that causes harm to the environment or economy', 'A native species', 'An endangered species', 'A keystone species'], 0,
         'Invasive species can outcompete natives and disrupt ecosystems.'),
        ('What is carrying capacity?',
         ARRAY['The maximum population size an environment can sustain', 'The minimum population size', 'The average population size', 'The death rate'], 0,
         'Carrying capacity depends on resources and limiting factors.'),
        ('What is biodiversity?',
         ARRAY['The variety of life in all its forms', 'The number of species', 'The genetic diversity', 'All of the above'], 3,
         'Biodiversity includes genetic, species, and ecosystem diversity.'),
        ('What is the carbon cycle?',
         ARRAY['The movement of carbon through the environment and organisms', 'The movement of nitrogen', 'The water cycle', 'The phosphorus cycle'], 0,
         'Carbon is exchanged through photosynthesis, respiration, decomposition, and fossil fuel burning.'),
        ('What is the greenhouse effect?',
         ARRAY['Natural warming of Earth due to gases trapping heat', 'An artificial climate change', 'Cooling of Earth', 'Ozone depletion'], 0,
         'The greenhouse effect is natural; human activities enhance it.'),
        ('What is a population?',
         ARRAY['A group of individuals of the same species living in the same area', 'All different species in an area', 'A community plus abiotic factors', 'An ecosystem'], 0,
         'Population ecology studies dynamics and interactions.'),
        ('What is a limiting factor?',
         ARRAY['Any resource or environmental condition that restricts population growth', 'A factor that increases growth', 'A factor that does not affect growth', 'Only water'], 0,
         'Limiting factors include food, water, space, and disease.'),
        ('What is succession?',
         ARRAY['The gradual replacement of one community by another over time', 'A sudden change', 'A cyclical change', 'A change without replacement'], 0,
         'Primary succession starts on bare rock; secondary on disturbed soil.'),
        ('What is the difference between primary and secondary succession?',
         ARRAY['Primary occurs on lifeless areas; secondary on areas where a community was destroyed', 'Primary is faster', 'Secondary starts with soil', 'Both are the same'], 0,
         'Secondary succession begins on existing soil, so it is faster.'),
        ('What is a "niche"?',
         ARRAY['The role and position of a species in its ecosystem', 'The habitat', 'The range', 'The population size'], 0,
         'A niche includes food, habitat, behaviour, and interactions.'),
        ('What is competition?',
         ARRAY['Interaction where organisms vie for the same limited resource', 'Cooperation', 'Predation', 'Mutualism'], 0,
         'Competition can be intraspecific or interspecific.'),
        ('What is mutualism?',
         ARRAY['A symbiotic relationship where both organisms benefit', 'One benefits, one is unaffected', 'One benefits, one is harmed', 'Neither benefits'], 0,
         'Examples: bees and flowers, nitrogen‑fixing bacteria and legumes.'),
        ('What is an herbivore?',
         ARRAY['An organism that eats plants', 'An organism that eats meat', 'An organism that eats both', 'An organism that eats dead material'], 0,
         'Herbivores are primary consumers.'),
        ('What is the role of wetlands in ecosystems?',
         ARRAY['They filter water, control flooding, and provide habitat', 'They are used for farming', 'They produce salt', 'They are arid'], 0,
         'Wetlands are among the most productive ecosystems.'),
        ('What is an apex predator?',
         ARRAY['A predator at the top of the food chain, with no natural enemies', 'A predator that eats many prey', 'A predator that is rare', 'A predator that is small'], 0,
         'Apex predators include lions, sharks, and eagles.'),
        ('What is the water cycle?',
         ARRAY['The continuous movement of water through evaporation, condensation, precipitation, and runoff', 'The cycle of carbon', 'The cycle of nitrogen', 'The cycle of phosphorus'], 0,
         'The water cycle is driven by solar energy and gravity.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_ecology, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 5. MARINE BIOLOGY (25 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What percentage of Earth''s surface is covered by oceans?',
         ARRAY['About 71%', 'About 50%', 'About 80%', 'About 90%'], 0,
         'Oceans cover most of Earth''s surface.'),
        ('What is the largest ocean on Earth?',
         ARRAY['Pacific Ocean', 'Atlantic Ocean', 'Indian Ocean', 'Southern Ocean'], 0,
         'The Pacific is the largest and deepest.'),
        ('What is the primary source of energy for most marine ecosystems?',
         ARRAY['Sunlight (photosynthesis)', 'Chemosynthesis', 'Geothermal heat', 'Tides'], 0,
         'Sunlight supports phytoplankton, the base of the marine food web.'),
        ('What is the deepest known point in the ocean?',
         ARRAY['Mariana Trench (Challenger Deep)', 'Tonga Trench', 'Puerto Rico Trench', 'Java Trench'], 0,
         'Challenger Deep is about 11,000 meters deep.'),
        ('What is a coral reef?',
         ARRAY['A diverse ecosystem built by coral polyps and calcium carbonate', 'A rock formation', 'A type of algae', 'A type of fish'], 0,
         'Coral reefs are often called the "rainforests of the sea."'),
        ('Which organism is responsible for most of the oxygen production in the ocean?',
         ARRAY['Phytoplankton (microalgae)', 'Seaweed', 'Coral', 'Fish'], 0,
         'Phytoplankton perform ~50% of global photosynthesis.'),
        ('What is the largest fish in the world?',
         ARRAY['Whale shark', 'Great white shark', 'Manta ray', 'Ocean sunfish'], 0,
         'The whale shark (Rhincodon typus) is the largest fish.'),
        ('What is the largest marine mammal?',
         ARRAY['Blue whale', 'Fin whale', 'Humpback whale', 'Sperm whale'], 0,
         'Blue whales are the largest animals ever known.'),
        ('What is an estuary?',
         ARRAY['Where freshwater meets saltwater (river mouth)', 'A deep ocean trench', 'A coral reef', 'An underwater mountain'], 0,
         'Estuaries are highly productive transitional zones.'),
        ('What is the process by which some deep‑sea organisms produce light?',
         ARRAY['Bioluminescence', 'Fluorescence', 'Chemosynthesis', 'Photosynthesis'], 0,
         'Bioluminescence is used for predation, communication, and camouflage.'),
        ('What is a plankton?',
         ARRAY['Small, drifting organisms in the water column', 'Bottom‑dwelling organisms', 'Free‑swimming organisms', 'Microscopic plants only'], 0,
         'Plankton includes both phytoplankton (plants) and zooplankton (animals).'),
        ('What is a nekton?',
         ARRAY['Actively swimming organisms (fish, squid, marine mammals)', 'Drifting organisms', 'Bottom dwellers', 'Algae'], 0,
         'Nekton can move independently of currents.'),
        ('What is the intertidal zone?',
         ARRAY['The area between high and low tide', 'The deep ocean', 'The open ocean', 'The sea floor'], 0,
         'Organisms in the intertidal zone must tolerate drying and wave action.'),
        ('What is a kelp forest?',
         ARRAY['A dense underwater ecosystem dominated by large brown algae', 'A tropical coral reef', 'A seagrass meadow', 'A deep‑sea vent'], 0,
         'Kelp forests provide habitat for many species.'),
        ('What is the Great Barrier Reef?',
         ARRAY['The world''s largest coral reef system, off Australia', 'A rocky shore', 'An ocean trench', 'A group of islands'], 0,
         'It is a UNESCO World Heritage site and can be seen from space.'),
        ('What is ocean acidification?',
         ARRAY['A decrease in ocean pH due to CO2 absorption', 'An increase in ocean temperature', 'A decrease in salinity', 'An increase in water acidity from pollution'], 0,
         'CO2 dissolves in seawater, forming carbonic acid.'),
        ('What is a marine protected area (MPA)?',
         ARRAY['A designated region of the ocean with conservation measures', 'An area without fishing', 'An area with no human activity', 'A scientific research zone'], 0,
         'MPAs help protect biodiversity and restore fish stocks.'),
        ('What is the main threat to coral reefs globally?',
         ARRAY['Climate change (bleaching), ocean acidification, and pollution', 'Overfishing', 'Tidal waves', 'Volcanic activity'], 0,
         'Global warming causes coral bleaching.'),
        ('Which sea animal has three hearts?',
         ARRAY['Octopus', 'Whale', 'Dolphin', 'Shark'], 0,
         'The octopus has three hearts; two pump blood to the gills.'),
        ('What is the longest migration of any animal?',
         ARRAY['Arctic tern (polar to polar)', 'Humpback whale', 'Salmon', 'Sea turtle'], 0,
         'Arctic terns migrate up to 70,000 km annually.'),
        ('What is the role of mangroves?',
         ARRAY['Coastal protection, nursery habitat, and carbon storage', 'They are tree farms', 'They are fishing grounds', 'They are tourist attractions'], 0,
         'Mangroves are critical for shoreline stability and biodiversity.'),
        ('What is the difference between a dolphin and a porpoise?',
         ARRAY['Dolphins have hooked dorsal fins and conical teeth; porpoises have triangular fins and spade‑shaped teeth', 'They are the same', 'Dolphins are smaller', 'Porpoises live in rivers'], 0,
         'Porpoises are smaller and have different body shape.'),
        ('What is the water temperature at the bottom of the deep ocean?',
         ARRAY['Near freezing (~4°C or less)', 'Warm (~20°C)', 'Boiling', 'Variable'], 0,
         'Deep ocean water is very cold, typically 0‑4°C.'),
        ('What is a hydrothermal vent?',
         ARRAY['A fissure on the seafloor that releases heated, mineral‑rich water', 'A volcanic crater', 'A deep trench', 'A coral formation'], 0,
         'Hydrothermal vents support chemosynthetic ecosystems.'),
        ('What is the main source of food in the deep sea?',
         ARRAY['Marine snow (organic debris falling from above) and chemosynthesis', 'Photosynthesis', 'Land runoff', 'Fishing'], 0,
         'Deep‑sea organisms rely on detritus and vent bacteria.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_marine, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 6. ZOOLOGY (25 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the scientific study of animals called?',
         ARRAY['Zoology', 'Botany', 'Ecology', 'Genetics'], 0,
         'Zoology is a branch of biology focused on the animal kingdom.'),
        ('Which group of animals is known for having a backbone?',
         ARRAY['Vertebrates', 'Invertebrates', 'Arthropods', 'Mollusks'], 0,
         'Vertebrates include mammals, birds, reptiles, amphibians, and fish.'),
        ('What is the largest group of animals (by species count)?',
         ARRAY['Insects (Arthropoda)', 'Mollusks', 'Chordates', 'Nematodes'], 0,
         'Insects make up over 80% of all animal species.'),
        ('Which animal is the fastest land animal?',
         ARRAY['Cheetah', 'Lion', 'Pronghorn', 'Horse'], 0,
         'The cheetah can reach speeds up to 120 km/h.'),
        ('What is the largest living bird by weight?',
         ARRAY['Ostrich', 'Emu', 'Cassowary', 'Penguin'], 0,
         'The ostrich is the heaviest and lays the largest eggs.'),
        ('Which animal is known for its ability to regenerate limbs?',
         ARRAY['Axolotl (salamander)', 'Starfish', 'Lizard', 'Crab'], 0,
         'Axolotls can regenerate limbs, spinal cord, and parts of the heart and brain.'),
        ('What type of symmetry do starfish exhibit?',
         ARRAY['Radial symmetry (pentaradial)', 'Bilateral symmetry', 'Asymmetry', 'Spherical symmetry'], 0,
         'Adult echinoderms have radial symmetry.'),
        ('What is the function of a mammal''s hair?',
         ARRAY['Insulation, camouflage, and sensory functions', 'Only insulation', 'For flight', 'For swimming'], 0,
         'Hair is a key characteristic of mammals.'),
        ('Which animal has the longest lifespan?',
         ARRAY['Greenland shark (over 400 years)', 'Elephant', 'Tortoise', 'Parrot'], 0,
         'Greenland sharks are the longest‑lived vertebrates known.'),
        ('What is a defining feature of reptiles?',
         ARRAY['Scaly skin and lay amniotic eggs', 'Fur and milk', 'Feathers', 'Gills'], 0,
         'Reptiles have dry, scaly skin and are ectothermic.'),
        ('Which class of animals is endothermic (warm‑blooded)?',
         ARRAY['Mammals and birds', 'Reptiles', 'Amphibians', 'Fish'], 0,
         'Mammals and birds regulate their body temperature internally.'),
        ('What is a metamorphosis?',
         ARRAY['A drastic change in body form during development', 'A slow change', 'No change', 'A reproductive change'], 0,
         'Insects and amphibians undergo metamorphosis.'),
        ('What is the role of a kangaroo''s pouch?',
         ARRAY['To carry and nurse its underdeveloped young (joeys)', 'To store food', 'To serve as a weapon', 'To attract mates'], 0,
         'Marsupials raise their young in a pouch.'),
        ('Which mammal can fly?',
         ARRAY['Bats', 'Flying squirrels', 'Sugar gliders', 'Flying lemurs (colugos)'], 0,
         'Bats are the only mammals capable of true powered flight.'),
        ('What is a vertebrate?',
         ARRAY['An animal with a backbone', 'An animal without a backbone', 'A plant', 'A fungus'], 0,
         'Vertebrates include fish, amphibians, reptiles, birds, and mammals.'),
        ('What is an invertebrate?',
         ARRAY['An animal without a backbone', 'An animal with a backbone', 'A plant', 'A bacterium'], 0,
         'Over 95% of animal species are invertebrates.'),
        ('Which animal is known for its complex social structure, like bees?',
         ARRAY['Honeybees', 'Ants', 'Termites', 'All of the above'], 3,
         'Many insects are eusocial.'),
        ('What is the main diet of a carnivore?',
         ARRAY['Meat', 'Plants', 'Both plants and meat', 'Fungi'], 0,
         'Carnivores are flesh‑eaters.'),
        ('Which animal is considered the closest living relative to humans?',
         ARRAY['Chimpanzees and bonobos', 'Gorillas', 'Orangutans', 'Monkeys'], 0,
         'We share about 98.8% of our DNA with chimpanzees.'),
        ('What is the scientific name for the order of primates that includes humans, apes, and monkeys?',
         ARRAY['Primates', 'Carnivora', 'Rodentia', 'Chiroptera'], 0,
         'Primates include prosimians and anthropoids.'),
        ('Which animal can change colour for camouflage?',
         ARRAY['Chameleon', 'Octopus', 'Cutlefish', 'All of the above'], 3,
         'Many cephalopods and lizards have chromatophores.'),
        ('What is a characteristic of amphibians?',
         ARRAY['They have a two‑stage life cycle (aquatic larvae, terrestrial adults)', 'They have fur', 'They have feathers', 'They have dry skin'], 0,
         'Amphibians typically lay eggs in water and breathe through skin.'),
        ('What is the largest land animal?',
         ARRAY['African elephant', 'White rhinoceros', 'Hippopotamus', 'Giraffe'], 0,
         'African elephants are the largest living terrestrial animals.'),
        ('What is the main function of a bird''s feathers?',
         ARRAY['Flight, insulation, and display', 'Only flight', 'Only insulation', 'Only for display'], 0,
         'Feathers have multiple functions.'),
        ('Which group of animals lays eggs with a hard shell?',
         ARRAY['Birds and reptiles', 'Mammals', 'Amphibians', 'Fish'], 0,
         'Birds and reptiles have amniotic eggs with shells.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_zoology, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 7. BOTANY (25 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the scientific study of plants called?',
         ARRAY['Botany', 'Zoology', 'Microbiology', 'Ecology'], 0,
         'Botany is the branch of biology dealing with plant life.'),
        ('What organelle is responsible for photosynthesis in plants?',
         ARRAY['Chloroplast', 'Mitochondria', 'Nucleus', 'Vacuole'], 0,
         'Chloroplasts contain chlorophyll and convert light energy to chemical energy.'),
        ('What are the three main tissue systems in plants?',
         ARRAY['Dermal, vascular, and ground tissues', 'Epidermal, vascular, and mesophyll', 'Cortex, pith, and epidermis', 'Xylem, phloem, and parenchyma'], 0,
         'These tissues are found in all vascular plants.'),
        ('What is the main structural component of plant cell walls?',
         ARRAY['Cellulose', 'Chitin', 'Pectin', 'Lignin'], 0,
         'Cellulose is a polysaccharide that provides rigidity.'),
        ('What is the difference between xylem and phloem?',
         ARRAY['Xylem transports water and minerals; phloem transports sugars', 'Xylem transports sugars; phloem transports water', 'They both transport water', 'They both transport sugars'], 0,
         'Xylem is unidirectional (roots to shoots); phloem is bidirectional.'),
        ('What is a plant hormone that promotes growth and cell elongation?',
         ARRAY['Auxin', 'Gibberellin', 'Cytokinin', 'Abscisic acid'], 0,
         'Auxins are responsible for phototropism and apical dominance.'),
        ('What is the male reproductive structure of a flower?',
         ARRAY['Stamen (anther and filament)', 'Pistil (carpel)', 'Sepal', 'Petal'], 0,
         'The stamen produces pollen.'),
        ('What is the female reproductive structure of a flower?',
         ARRAY['Pistil (stigma, style, ovary)', 'Stamen', 'Sepal', 'Petal'], 0,
         'The pistil contains the ovary, which produces ovules.'),
        ('What is pollination?',
         ARRAY['Transfer of pollen from anther to stigma', 'Fertilisation of the ovule', 'Seed dispersal', 'Growth of pollen tube'], 0,
         'Pollination is a prerequisite for fertilisation.'),
        ('What is a fruit in botanical terms?',
         ARRAY['The mature ovary of a flower, often containing seeds', 'A sweet edible part', 'The root', 'The leaf'], 0,
         'Fruits protect and help disperse seeds.'),
        ('What is the main function of roots?',
         ARRAY['Anchorage, absorption of water and minerals, and storage', 'Photosynthesis', 'Support of leaves', 'Gas exchange'], 0,
         'Roots anchor the plant and take up nutrients.'),
        ('Which plants have vascular tissue?',
         ARRAY['Vascular plants (tracheophytes)', 'Non‑vascular plants (bryophytes)', 'Algae', 'Fungi'], 0,
         'Vascular plants include ferns, gymnosperms, and angiosperms.'),
        ('What are the two main groups of flowering plants?',
         ARRAY['Monocots and dicots (or eudicots)', 'Gymnosperms and angiosperms', 'Conifers and cycads', 'Annuals and perennials'], 0,
         'Monocots have one cotyledon; dicots have two.'),
        ('What is photosynthesis?',
         ARRAY['The conversion of sunlight, water, and CO2 into glucose and oxygen', 'The conversion of glucose into energy', 'The breakdown of water', 'The synthesis of proteins'], 0,
         'Photosynthesis is the basis of most food chains.'),
        ('What is the light‑independent reaction of photosynthesis called?',
         ARRAY['Calvin cycle', 'Krebs cycle', 'Electron transport chain', 'Glycolysis'], 0,
         'The Calvin cycle uses ATP and NADPH to fix CO2 into sugars.'),
        ('What is a seed?',
         ARRAY['A fertilised ovule containing an embryo and stored food', 'A gamete', 'A spore', 'A fruit'], 0,
         'Seeds allow for dormancy and dispersal.'),
        ('What is the role of stomata in leaves?',
         ARRAY['Gas exchange (CO2 in, O2 out) and transpiration', 'Water absorption', 'Sugar transport', 'Photosynthesis'], 0,
         'Stomata open and close to regulate water loss and gas uptake.'),
        ('What is transpiration?',
         ARRAY['Loss of water vapour from plant surfaces, especially leaves', 'Absorption of water', 'Transport of sugars', 'Cell division'], 0,
         'Transpiration drives water movement through the plant.'),
        ('What are mycorrhizae?',
         ARRAY['Symbiotic associations between fungi and plant roots', 'Plant diseases', 'Parasitic plants', 'Algae in lichens'], 0,
         'Mycorrhizae enhance nutrient uptake for the plant.'),
        ('What is the largest group of plants?',
         ARRAY['Angiosperms (flowering plants)', 'Gymnosperms', 'Ferns', 'Mosses'], 0,
         'Angiosperms are the most diverse plant group, with over 300,000 species.'),
        ('What is a deciduous plant?',
         ARRAY['A plant that sheds its leaves annually', 'An evergreen plant', 'A plant that lives for many years', 'A plant that grows in deserts'], 0,
         'Deciduous trees lose leaves in autumn to conserve water.'),
        ('What is a perennial plant?',
         ARRAY['A plant that lives for more than two years', 'A plant that completes its cycle in one year', 'A plant that lives for two years', 'A plant that dies after flowering'], 0,
         'Perennials regrow each season.'),
        ('What is the process of germination?',
         ARRAY['The growth of a seed into a young plant', 'The death of a plant', 'The flower opening', 'The leaf fall'], 0,
         'Germination requires water, oxygen, and suitable temperature.'),
        ('Which plant hormone promotes ripening of fruit?',
         ARRAY['Ethylene', 'Auxin', 'Gibberellin', 'Cytokinin'], 0,
         'Ethylene is a gaseous hormone that stimulates ripening.'),
        ('What is the function of root hairs?',
         ARRAY['To increase surface area for water and mineral absorption', 'To anchor the plant', 'To store starch', 'To produce hormones'], 0,
         'Root hairs are extensions of epidermal cells.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_botany, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 8. GENETICS (25 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Who is known as the father of modern genetics?',
         ARRAY['Gregor Mendel', 'Charles Darwin', 'James Watson', 'Francis Crick'], 0,
         'Mendel''s pea plant experiments established the laws of inheritance.'),
        ('What is an allele?',
         ARRAY['A variant form of a gene', 'A chromosome', 'A phenotype', 'A genotype'], 0,
         'Alleles are alternative versions of a gene at a given locus.'),
        ('What is the difference between genotype and phenotype?',
         ARRAY['Genotype is the genetic makeup; phenotype is the observable traits', 'Phenotype is genetic; genotype is observable', 'They are the same', 'Genotype is environmental'], 0,
         'Phenotype results from genotype and environment.'),
        ('What is a dominant allele?',
         ARRAY['An allele that masks the expression of a recessive allele when present', 'An allele that is only expressed in homozygotes', 'An allele that is rare', 'An allele that causes disease'], 0,
         'Dominant alleles express their trait even if heterozygous.'),
        ('What is a recessive allele?',
         ARRAY['An allele that is only expressed in the homozygous state', 'An allele that is always expressed', 'An allele that is common', 'An allele that is dominant'], 0,
         'Recessive alleles require two copies for expression.'),
        ('What is the principle of segregation?',
         ARRAY['Alleles for a trait separate during gamete formation', 'Alleles for different traits assort independently', 'Alleles are inherited together', 'Genes are on chromosomes'], 0,
         'Mendel''s first law.'),
        ('What is the principle of independent assortment?',
         ARRAY['Genes for different traits are inherited independently (if on different chromosomes)', 'Genes always stay together', 'Traits are linked', 'All genes are on the same chromosome'], 0,
         'This holds for genes on different chromosomes.'),
        ('What is a Punnett square used for?',
         ARRAY['To predict the genotypes and phenotypes of offspring from a cross', 'To map genes', 'To sequence DNA', 'To measure fitness'], 0,
         'Punnett squares are a simple tool for Mendelian genetics.'),
        ('What is a dihybrid cross?',
         ARRAY['A cross involving two traits', 'A cross involving one trait', 'A cross involving multiple alleles', 'A cross involving sex‑linked traits'], 0,
         'Mendel conducted dihybrid crosses for seed shape and colour.'),
        ('What is a test cross?',
         ARRAY['Crossing an individual with a homozygous recessive to determine its genotype', 'Crossing two heterozygotes', 'Crossing two dominant phenotypes', 'Crossing to test for disease'], 0,
         'A test cross reveals if an individual is homozygous or heterozygous dominant.'),
        ('What is incomplete dominance?',
         ARRAY['Heterozygotes show an intermediate phenotype (e.g., pink flowers from red and white)', 'One allele completely masks another', 'Both alleles are expressed', 'No dominant allele'], 0,
         'Example: snapdragon flower colour.'),
        ('What is codominance?',
         ARRAY['Both alleles are fully expressed in the heterozygote (e.g., AB blood type)', 'One allele is dominant', 'Heterozygote is intermediate', 'Neither allele is expressed'], 0,
         'ABO blood types are an example.'),
        ('What is a sex‑linked trait?',
         ARRAY['A trait determined by genes on the sex chromosomes (usually X)', 'A trait linked to gender', 'A trait influenced by sex hormones', 'A trait that only occurs in one sex'], 0,
         'Examples: hemophilia, color blindness.'),
        ('What is a pedigree?',
         ARRAY['A diagram showing the inheritance of a trait through generations', 'A family tree', 'A genetic map', 'A chromosome chart'], 0,
         'Pedigrees are used to study human inheritance.'),
        ('What is a karyotype?',
         ARRAY['An image of an individual''s chromosomes, arranged in pairs', 'A gene sequence', 'A protein structure', 'A cell division stage'], 0,
         'Karyotypes can detect chromosomal abnormalities.'),
        ('What is a mutation?',
         ARRAY['A change in the DNA sequence', 'A change in phenotype', 'A change in environment', 'A change in protein'], 0,
         'Mutations are the source of new alleles.'),
        ('What is the difference between a germline mutation and a somatic mutation?',
         ARRAY['Germline mutations are heritable; somatic mutations are not', 'Somatic mutations are heritable; germline are not', 'Both are heritable', 'Neither is heritable'], 0,
         'Germline mutations affect gametes and can be passed to offspring.'),
        ('What is a gene pool?',
         ARRAY['All the alleles in a population', 'All the genes in an individual', 'All the chromosomes', 'All the phenotypes'], 0,
         'The gene pool is the total genetic diversity of a population.'),
        ('What is genetic drift?',
         ARRAY['Random changes in allele frequencies in a population', 'Non‑random changes', 'Migration', 'Natural selection'], 0,
         'Genetic drift is more pronounced in small populations.'),
        ('What is a bottleneck effect?',
         ARRAY['A drastic reduction in population size leading to reduced genetic diversity', 'A population increase', 'Gene flow', 'Mutation'], 0,
         'Bottlenecks reduce genetic variation.'),
        ('What is the structure of a chromosome?',
         ARRAY['DNA tightly coiled around proteins (histones)', 'RNA', 'Protein only', 'Lipids'], 0,
         'Chromosomes are composed of chromatin.'),
        ('What is a homologous chromosome pair?',
         ARRAY['Two chromosomes with the same genes, one from each parent', 'Two identical chromosomes', 'Two chromosomes that pair during mitosis', 'Chromosomes from the same parent'], 0,
         'Homologs have the same loci but may have different alleles.'),
        ('What is a linkage group?',
         ARRAY['Genes on the same chromosome that tend to be inherited together', 'Genes that are independent', 'Genes that are on different chromosomes', 'All genes'], 0,
         'Linkage can be broken by recombination.'),
        ('What is the recombination frequency used for?',
         ARRAY['To estimate the distance between genes on a chromosome', 'To determine mutation rates', 'To predict phenotype', 'To measure gene expression'], 0,
         'Recombination frequency is proportional to physical distance.'),
        ('What is the "Central Dogma" revised to include reverse transcription?',
         ARRAY['DNA → RNA → Protein, but also RNA → DNA (in retroviruses)', 'Only DNA → RNA → Protein', 'Protein → DNA', 'RNA only'], 0,
         'Retroviruses use reverse transcriptase to make DNA from RNA.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_genetics, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 9. HUMAN BIOLOGY (25 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the largest organ of the human body?',
         ARRAY['Skin', 'Liver', 'Brain', 'Heart'], 0,
         'The skin is the largest organ by surface area and weight.'),
        ('What is the function of the heart?',
         ARRAY['To pump blood throughout the body', 'To filter blood', 'To produce hormones', 'To store nutrients'], 0,
         'The heart is the central pump of the circulatory system.'),
        ('How many chambers does the human heart have?',
         ARRAY['4 (two atria, two ventricles)', '2', '3', '5'], 0,
         'The heart has four chambers.'),
        ('What is the function of the kidneys?',
         ARRAY['Filter blood to remove waste and regulate water balance', 'Produce urine only', 'Store urine', 'Regulate blood sugar'], 0,
         'Kidneys maintain homeostasis.'),
        ('What is the main function of the lungs?',
         ARRAY['Gas exchange (oxygen in, carbon dioxide out)', 'Filter air', 'Produce mucus', 'Regulate pH'], 0,
         'Lungs are the primary organs of respiration.'),
        ('What is the role of red blood cells?',
         ARRAY['Transport oxygen from lungs to tissues', 'Fight infections', 'Clot blood', 'Transport nutrients'], 0,
         'Red blood cells contain haemoglobin for oxygen transport.'),
        ('What is the function of white blood cells?',
         ARRAY['Immune response and defence against pathogens', 'Transport oxygen', 'Clot blood', 'Carry nutrients'], 0,
         'White blood cells are key to the immune system.'),
        ('What is the largest gland in the human body?',
         ARRAY['Liver', 'Pancreas', 'Thyroid', 'Adrenal'], 0,
         'The liver performs many metabolic functions.'),
        ('What is the main function of the pancreas?',
         ARRAY['Digestive enzyme production and blood sugar regulation (insulin/glucagon)', 'Produce bile', 'Filter blood', 'Store glycogen'], 0,
         'The pancreas has both endocrine and exocrine functions.'),
        ('What is the role of the small intestine?',
         ARRAY['Absorption of nutrients', 'Water absorption', 'Digestion of proteins only', 'Storage of waste'], 0,
         'The small intestine is where most digestion and absorption occur.'),
        ('What is the function of the large intestine?',
         ARRAY['Water absorption and formation of faeces', 'Absorption of nutrients', 'Digestion of carbohydrates', 'Production of bile'], 0,
         'The large intestine compacts waste and absorbs water.'),
        ('What is the brain made up of?',
         ARRAY['Neurons and glial cells', 'Only neurons', 'Only connective tissue', 'Muscle cells'], 0,
         'The brain consists of billions of neurons and support cells.'),
        ('What part of the brain controls balance and coordination?',
         ARRAY['Cerebellum', 'Cerebrum', 'Brainstem', 'Hypothalamus'], 0,
         'The cerebellum fine‑tunes motor movements.'),
        ('What is the function of the hypothalamus?',
         ARRAY['Homeostasis: regulates temperature, hunger, thirst, and hormones', 'Motor control', 'Memory', 'Language'], 0,
         'The hypothalamus links the nervous and endocrine systems.'),
        ('What is the endocrine system?',
         ARRAY['A system of glands that secrete hormones into the blood', 'A system of nerves', 'A system of bones', 'A system of muscles'], 0,
         'Endocrine glands include the pituitary, thyroid, and adrenal glands.'),
        ('What hormone regulates blood sugar?',
         ARRAY['Insulin and glucagon', 'Thyroxine', 'Adrenaline', 'Cortisol'], 0,
         'Insulin lowers blood glucose; glucagon raises it.'),
        ('What is the function of the skeleton?',
         ARRAY['Support, protection, movement, blood cell production, and mineral storage', 'Only support', 'Only movement', 'Only protection'], 0,
         'Bones have multiple functions.'),
        ('How many bones are in the adult human body?',
         ARRAY['206', '180', '300', '250'], 0,
         'The average adult human has 206 bones.'),
        ('What is the main component of bone?',
         ARRAY['Collagen and calcium phosphate', 'Calcium carbonate', 'Hydroxyapatite', 'Keratin'], 0,
         'Bone is a composite of organic collagen and inorganic minerals.'),
        ('What is the role of muscles in movement?',
         ARRAY['Muscles contract and relax to produce movement', 'Muscles store energy', 'Muscles support bones', 'Muscles regulate temperature'], 0,
         'Muscles work in antagonistic pairs.'),
        ('What is the basic functional unit of the kidney?',
         ARRAY['Nephron', 'Glomerulus', 'Bowman''s capsule', 'Renal corpuscle'], 0,
         'The nephron filters blood and produces urine.'),
        ('What is the function of platelets?',
         ARRAY['Blood clotting (coagulation)', 'Oxygen transport', 'Immune defence', 'Nutrient transport'], 0,
         'Platelets are cell fragments that initiate clotting.'),
        ('What is the role of the lymphatic system?',
         ARRAY['Fluid balance, immune defence, and fat absorption', 'Blood transport', 'Gas exchange', 'Waste removal'], 0,
         'The lymphatic system is part of the circulatory and immune systems.'),
        ('What is the average normal body temperature for humans?',
         ARRAY['37°C (98.6°F)', '36°C', '38°C', '40°C'], 0,
         'Normal oral temperature is about 37°C.'),
        ('What is the function of the autonomic nervous system?',
         ARRAY['Regulates involuntary functions (heart rate, digestion, etc.)', 'Voluntary movement', 'Sensory perception', 'Memory'], 0,
         'The autonomic system includes sympathetic and parasympathetic divisions.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_human, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 10. BIOTECHNOLOGY (25 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is biotechnology?',
         ARRAY['The use of living organisms or their parts to make useful products', 'The study of biological systems', 'Genetic engineering only', 'Manufacturing drugs'], 0,
         'Biotechnology spans fermentation, genetic engineering, and more.'),
        ('What is recombinant DNA?',
         ARRAY['DNA molecules from different sources joined together', 'DNA that is naturally mutated', 'DNA in bacteria', 'DNA from viruses'], 0,
         'Recombinant DNA is a key tool in genetic engineering.'),
        ('What is a restriction enzyme used for?',
         ARRAY['To cut DNA at specific sequences', 'To join DNA fragments', 'To replicate DNA', 'To sequence DNA'], 0,
         'Restriction enzymes are "molecular scissors" used in cloning.'),
        ('What is a vector in genetic engineering?',
         ARRAY['A DNA molecule used to carry foreign DNA into a host cell (e.g., plasmid)', 'A carrier organism', 'A type of virus', 'A host cell'], 0,
         'Vectors are used to clone and express genes.'),
        ('What is a PCR (polymerase chain reaction) used for?',
         ARRAY['To amplify a specific DNA sequence', 'To sequence DNA', 'To cut DNA', 'To synthesise proteins'], 0,
         'PCR is essential for many molecular biology techniques.'),
        ('What is CRISPR‑Cas9?',
         ARRAY['A gene‑editing tool that allows precise modification of DNA', 'A virus', 'A type of PCR', 'A restriction enzyme'], 0,
         'CRISPR is a revolutionary genome editing technology.'),
        ('What is the role of DNA ligase?',
         ARRAY['To join DNA fragments together', 'To cut DNA', 'To unwind DNA', 'To synthesise RNA'], 0,
         'Ligase seals nicks in the sugar‑phosphate backbone.'),
        ('What is a transgenic organism?',
         ARRAY['An organism that contains genes from another species', 'An organism with a mutation', 'A clone', 'A genetically modified organism (GMO)'], 0,
         'Transgenic organisms are used in research, agriculture, and medicine.'),
        ('What is the purpose of the Human Genome Project?',
         ARRAY['To map and sequence the entire human genome', 'To clone humans', 'To cure all diseases', 'To create transgenic humans'], 0,
         'The Human Genome Project was completed in 2003.'),
        ('What is gene therapy?',
         ARRAY['Introducing functional genes into cells to treat genetic disorders', 'Removing genes', 'Cloning', 'Gene editing only'], 0,
         'Gene therapy aims to correct disease‑causing mutations.'),
        ('What is a vaccine?',
         ARRAY['A biological preparation that provides immunity to a disease', 'A type of antibiotic', 'A therapeutic drug', 'A diagnostic test'], 0,
         'Vaccines stimulate the immune system to recognise pathogens.'),
        ('What is a monoclonal antibody?',
         ARRAY['A single type of antibody produced by a cloned cell line', 'A mixture of antibodies', 'An antibody from a mouse', 'An antibody to a virus'], 0,
         'Monoclonal antibodies are used in diagnostics and therapy.'),
        ('What is fermentation in biotechnology?',
         ARRAY['The use of microorganisms to produce food, beverages, and chemicals', 'A form of genetic engineering', 'A type of cell division', 'A type of respiration'], 0,
         'Fermentation is one of the oldest biotechnological processes.'),
        ('What is the role of yeast in biotechnology?',
         ARRAY['Used in baking, brewing, and as a model organism for genetics', 'Used to produce insulin', 'Used to kill bacteria', 'Used to create vaccines'], 0,
         'Yeast (Saccharomyces cerevisiae) is a key organism.'),
        ('What is an example of a GMO (genetically modified organism)?',
         ARRAY['Bt corn (engineered to produce insecticide)', 'Organic corn', 'Wild rice', 'Natural tomatoes'], 0,
         'Bt corn is a common GMO.'),
        ('What is the role of bioremediation?',
         ARRAY['Using organisms to remove pollutants from the environment', 'Producing biofuels', 'Creating drugs', 'Modifying genes'], 0,
         'Bioremediation uses bacteria or plants to clean up oil spills or heavy metals.'),
        ('What is a restriction fragment length polymorphism (RFLP) used for?',
         ARRAY['DNA fingerprinting and genetic mapping', 'Gene cloning', 'Gene expression', 'Protein analysis'], 0,
         'RFLP is a molecular technique for identifying individuals or strains.'),
        ('What is a plasmid?',
         ARRAY['A small circular DNA molecule in bacteria, used as a vector', 'A viral genome', 'A chromosome', 'A type of RNA'], 0,
         'Plasmids are widely used in genetic engineering.'),
        ('What is the difference between a cDNA library and a genomic library?',
         ARRAY['cDNA library contains only expressed genes (mRNA reverse transcribed); genomic library contains all genomic DNA', 'Both contain all genes', 'Genomic library contains expressed genes', 'No difference'], 0,
         'cDNA libraries are useful for studying active genes.'),
        ('What is a stem cell?',
         ARRAY['A cell that can differentiate into multiple cell types', 'A cell that is already differentiated', 'A cell that causes cancer', 'A bacterial cell'], 0,
         'Stem cells are undifferentiated and can divide to give rise to various cell types.'),
        ('What is somatic cell nuclear transfer (SCNT)?',
         ARRAY['A technique used in cloning (e.g., Dolly the sheep)', 'Gene editing', 'In vitro fertilisation', 'PCR'], 0,
         'SCNT involves transferring a somatic nucleus into an enucleated egg cell.'),
        ('What is the purpose of gel electrophoresis?',
         ARRAY['To separate DNA, RNA, or proteins based on size and charge', 'To amplify DNA', 'To cut DNA', 'To sequence DNA'], 0,
         'Gel electrophoresis is a common laboratory technique.'),
        ('What is a knockout mouse?',
         ARRAY['A mouse in which a specific gene has been inactivated', 'A mouse with a new gene inserted', 'A transgenic mouse', 'A cloned mouse'], 0,
         'Knockout mice are used to study gene function.'),
        ('What is the role of bioinformatics?',
         ARRAY['Using computational tools to analyse biological data', 'Growing organisms', 'Manufacturing drugs', 'Cloning'], 0,
         'Bioinformatics is essential for genomics and proteomics.'),
        ('What is the potential benefit of genetically modified crops?',
         ARRAY['Increased yield, pest resistance, and improved nutrition', 'They are always harmful', 'They reduce biodiversity', 'They are less nutritious'], 0,
         'GM crops can help address food security challenges.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_biotech, q_rec.column1, 'single_choice', q_rec.column4)
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