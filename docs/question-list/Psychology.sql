-- ============================================================================
-- Insert 250 factual questions on Psychology.
-- Subtopics: Cognitive Psychology, Clinical Psychology, Social Psychology,
-- Behavioral Science, Personality, Memory, Learning, Emotions.
-- ============================================================================

DO $$
DECLARE
    cat_id_cognitive   BIGINT;
    cat_id_clinical    BIGINT;
    cat_id_social      BIGINT;
    cat_id_behavioral  BIGINT;
    cat_id_personality BIGINT;
    cat_id_memory      BIGINT;
    cat_id_learning    BIGINT;
    cat_id_emotions    BIGINT;
    q_id               BIGINT;
    correct_opt_id     BIGINT;
    opt_texts          TEXT[];
    q_rec              RECORD;
BEGIN
    -- ------------------------------------------------------------------------
    -- Create categories (hierarchical under psychology)
    -- ------------------------------------------------------------------------
    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('psychology', 'Psychology', 2, 0)
        ON CONFLICT (path) DO NOTHING;

    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('psychology.cognitive_psychology', 'Cognitive Psychology', 2, 1),
        ('psychology.clinical_psychology',  'Clinical Psychology', 2, 2),
        ('psychology.social_psychology',    'Social Psychology', 2, 3),
        ('psychology.behavioral_science',   'Behavioral Science', 2, 4),
        ('psychology.personality',          'Personality', 2, 5),
        ('psychology.memory',               'Memory', 2, 6),
        ('psychology.learning',             'Learning', 2, 7),
        ('psychology.emotions',             'Emotions', 2, 8)
        ON CONFLICT (path) DO NOTHING;

    -- Get category IDs
    SELECT id INTO cat_id_cognitive  FROM categories WHERE path = 'psychology.cognitive_psychology';
    SELECT id INTO cat_id_clinical   FROM categories WHERE path = 'psychology.clinical_psychology';
    SELECT id INTO cat_id_social     FROM categories WHERE path = 'psychology.social_psychology';
    SELECT id INTO cat_id_behavioral FROM categories WHERE path = 'psychology.behavioral_science';
    SELECT id INTO cat_id_personality FROM categories WHERE path = 'psychology.personality';
    SELECT id INTO cat_id_memory     FROM categories WHERE path = 'psychology.memory';
    SELECT id INTO cat_id_learning   FROM categories WHERE path = 'psychology.learning';
    SELECT id INTO cat_id_emotions   FROM categories WHERE path = 'psychology.emotions';

    -- ========================================================================
    -- 1. COGNITIVE PSYCHOLOGY (32 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is cognitive psychology?',
         ARRAY['The study of mental processes such as attention, memory, and problem‑solving', 'The study of observable behaviour', 'The study of personality', 'The study of social interactions'], 0,
         'Cognitive psychology focuses on internal mental representations and processes.'),
        ('Who is considered the father of cognitive psychology?',
         ARRAY['Ulric Neisser', 'B.F. Skinner', 'Sigmund Freud', 'Jean Piaget'], 0,
         'Neisser coined the term "cognitive psychology" in 1967.'),
        ('What is the "information processing" model?',
         ARRAY['A framework comparing the mind to a computer that processes information', 'A model of behaviour', 'A theory of personality', 'A model of emotions'], 0,
         'This model emphasises input, storage, retrieval, and output.'),
        ('Which brain structure is crucial for forming new memories?',
         ARRAY['Hippocampus', 'Amygdala', 'Cerebellum', 'Prefrontal cortex'], 0,
         'The hippocampus is essential for declarative memory consolidation.'),
        ('What is "attention" in cognitive psychology?',
         ARRAY['The ability to focus on specific stimuli while ignoring others', 'The ability to remember information', 'The ability to solve problems', 'The ability to understand language'], 0,
         'Attention is selective and limited in capacity.'),
        ('What is the "cocktail party effect"?',
         ARRAY['The ability to focus on one conversation while filtering out others', 'The inability to hear in noisy environments', 'A type of memory loss', 'A social phenomenon'], 0,
         'It demonstrates selective attention and the processing of unattended stimuli.'),
        ('What is working memory?',
         ARRAY['A system for temporarily holding and manipulating information', 'Long‑term storage of facts', 'Memory for events', 'Memory for skills'], 0,
         'Working memory includes the phonological loop, visuospatial sketchpad, and central executive.'),
        ('What is the capacity of short‑term memory according to George Miller?',
         ARRAY['7 ± 2 items', '5 items', '10 items', '3 items'], 0,
         'Miller''s classic paper "The Magical Number Seven, Plus or Minus Two".'),
        ('What is a "schema" in cognitive psychology?',
         ARRAY['A mental framework that organises and interprets information', 'A type of memory test', 'A neural pathway', 'A cognitive bias'], 0,
         'Schemas help us process information quickly but can lead to errors.'),
        ('What is the Stroop effect?',
         ARRAY['Interference in reaction time when naming the colour of a word that spells a different colour', 'A memory illusion', 'A perception error', 'A language disorder'], 0,
         'The Stroop effect demonstrates the automaticity of reading.'),
        ('What is "confirmation bias"?',
         ARRAY['Tendency to search for or interpret information in a way that confirms one''s preconceptions', 'Tendency to remember negative information', 'Tendency to overestimate one''s abilities', 'Tendency to conform to group opinions'], 0,
         'Confirmation bias is a common cognitive bias.'),
        ('What is "cognitive dissonance"?',
         ARRAY['The discomfort felt when holding contradictory beliefs or attitudes', 'The tendency to agree with others', 'The ability to hold two ideas simultaneously', 'A memory error'], 0,
         'Cognitive dissonance theory was proposed by Festinger.'),
        ('What is "availability heuristic"?',
         ARRAY['Judging the likelihood of events based on how easily examples come to mind', 'Judging based on similarity to a prototype', 'Overestimating rare events', 'Using logic and reasoning'], 0,
         'The availability heuristic can lead to biases in risk perception.'),
        ('What is "anchoring bias"?',
         ARRAY['Relying too heavily on the first piece of information encountered', 'Underestimating the importance of new information', 'Overestimating one''s own knowledge', 'Ignoring base rates'], 0,
         'Anchoring affects decision‑making and estimation.'),
        ('Which part of the brain is responsible for executive functions?',
         ARRAY['Prefrontal cortex', 'Occipital lobe', 'Temporal lobe', 'Cerebellum'], 0,
         'The prefrontal cortex is involved in planning, impulse control, and decision‑making.'),
        ('What is a "mental set"?',
         ARRAY['A tendency to approach problems in a fixed way based on past experience', 'A set of mental abilities', 'A type of memory', 'A cognitive bias'], 0,
         'Mental sets can hinder problem‑solving when they are inappropriate.'),
        ('What is "functional fixedness"?',
         ARRAY['The inability to see an object as having a function beyond its usual one', 'The ability to think flexibly', 'A type of memory failure', 'A learning style'], 0,
         'Functional fixedness is a barrier to creativity.'),
        ('What is "semantic memory"?',
         ARRAY['Memory for facts and general knowledge', 'Memory for personal events', 'Memory for skills and procedures', 'Memory for emotional events'], 0,
         'Semantic memory is a type of declarative memory.'),
        ('What is "episodic memory"?',
         ARRAY['Memory for specific events or episodes from one''s own life', 'Memory for facts', 'Memory for how to do things', 'Memory for emotional experiences'], 0,
         'Episodic memory is autobiographical.'),
        ('What is "procedural memory"?',
         ARRAY['Memory for skills, habits, and how to perform tasks', 'Memory for facts', 'Memory for events', 'Memory for faces'], 0,
         'Procedural memory is implicit and often unconscious.'),
        ('What is "false memory"?',
         ARRAY['A recollection of an event that did not happen or is distorted', 'A memory that is always accurate', 'A memory of an emotional event', 'A memory of a dream'], 0,
         'False memories can be implanted or emerge spontaneously.'),
        ('What is the "primacy effect" in serial recall?',
         ARRAY['Better recall of items presented at the beginning of a list', 'Better recall of items at the end', 'Better recall of middle items', 'No difference'], 0,
         'The primacy effect is due to rehearsal and transfer to long‑term memory.'),
        ('What is the "recency effect"?',
         ARRAY['Better recall of items presented at the end of a list', 'Better recall of items at the beginning', 'Better recall of middle items', 'No difference'], 0,
         'The recency effect reflects information in short‑term memory.'),
        ('What is "chunking"?',
         ARRAY['Grouping individual bits of information into larger units', 'Breaking information into smaller pieces', 'Rehearsing information', 'Using imagery to remember'], 0,
         'Chunking increases short‑term memory capacity.'),
        ('Which model of memory has three stores: sensory, short‑term, and long‑term?',
         ARRAY['Atkinson‑Shiffrin model', 'Baddeley''s working memory model', 'Levels of processing', 'Parallel distributed processing'], 0,
         'The Atkinson‑Shiffrin model is also called the modal model.'),
        ('What is "proactive interference"?',
         ARRAY['Old memories interfering with the recall of new information', 'New memories interfering with old', 'Forgetting due to decay', 'Forgetting due to lack of use'], 0,
         'Proactive interference occurs when prior learning disrupts new learning.'),
        ('What is "retroactive interference"?',
         ARRAY['New information interfering with the recall of old information', 'Old interfering with new', 'Forgetting due to decay', 'Forgetting due to lack of use'], 0,
         'Retroactive interference happens when new learning disrupts old memories.'),
        ('What is "intelligence" in cognitive psychology?',
         ARRAY['The ability to learn, reason, and solve problems', 'A single measure of mental ability', 'A personality trait', 'A learned behaviour'], 0,
         'Intelligence is multifaceted and debated.'),
        ('Who proposed the triarchic theory of intelligence?',
         ARRAY['Robert Sternberg', 'Howard Gardner', 'Alfred Binet', 'Charles Spearman'], 0,
         'Sternberg''s theory includes analytical, creative, and practical intelligence.'),
        ('Which psychologist proposed multiple intelligences?',
         ARRAY['Howard Gardner', 'Robert Sternberg', 'Charles Spearman', 'Louis Thurstone'], 0,
         'Gardner identified eight distinct intelligences.'),
        ('What is the "Flynn effect"?',
         ARRAY['The observed rise in IQ scores over generations', 'The decline in intelligence over time', 'The heritability of intelligence', 'The effect of education on IQ'], 0,
         'The Flynn effect is named after James Flynn.'),
        ('What is "metacognition"?',
         ARRAY['Awareness and understanding of one''s own thought processes', 'The ability to learn languages', 'Memory for procedures', 'Social cognition'], 0,
         'Metacognition includes planning, monitoring, and evaluating one''s learning.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_cognitive, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 2. CLINICAL PSYCHOLOGY (32 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is clinical psychology?',
         ARRAY['The branch of psychology concerned with the assessment and treatment of mental illness and emotional disorders', 'The study of normal behaviour', 'The study of social interactions', 'The study of brain function'], 0,
         'Clinical psychologists use psychotherapy and assessment.'),
        ('Which disorder is characterized by persistent sadness, loss of interest, and changes in sleep/appetite?',
         ARRAY['Major depressive disorder', 'Bipolar disorder', 'Generalized anxiety disorder', 'Schizophrenia'], 0,
         'Depression is a mood disorder with cognitive, emotional, and physical symptoms.'),
        ('What is the most common anxiety disorder?',
         ARRAY['Generalized anxiety disorder', 'Panic disorder', 'Phobias', 'Social anxiety disorder'], 0,
         'Specific phobias are the most common, but GAD is also frequent.'),
        ('Which personality disorder is characterized by unstable relationships, self‑image, and intense emotions?',
         ARRAY['Borderline personality disorder', 'Narcissistic personality disorder', 'Antisocial personality disorder', 'Histrionic personality disorder'], 0,
         'BPD involves a pattern of instability in mood, behaviour, and identity.'),
        ('What is the primary symptom of schizophrenia?',
         ARRAY['Delusions and hallucinations', 'Depressed mood', 'Memory loss', 'Anxiety'], 0,
         'Positive symptoms of schizophrenia include hallucinations and delusions.'),
        ('What is the difference between a clinical psychologist and a psychiatrist?',
         ARRAY['Psychiatrists are medical doctors and can prescribe medication; clinical psychologists cannot (in most states)', 'Clinical psychologists prescribe medication', 'They are the same', 'Psychiatrists only do therapy'], 0,
         'Psychiatrists have an MD/DO; clinical psychologists have a PhD/PsyD.'),
        ('What is cognitive‑behavioral therapy (CBT)?',
         ARRAY['A therapy that combines cognitive and behavioral approaches to change maladaptive thoughts and behaviours', 'A therapy focusing only on feelings', 'A therapy focusing on early childhood', 'A therapy using medication'], 0,
         'CBT is evidence‑based for many disorders.'),
        ('Which disorder involves excessive worry and apprehension that is difficult to control?',
         ARRAY['Generalized anxiety disorder', 'Panic disorder', 'Obsessive‑compulsive disorder', 'Post‑traumatic stress disorder'], 0,
         'GAD is characterised by chronic excessive worry.'),
        ('What is the primary feature of panic disorder?',
         ARRAY['Recurrent unexpected panic attacks', 'Fear of public places', 'Excessive worry', 'Compulsive behaviours'], 0,
         'Panic attacks are sudden surges of intense fear or discomfort.'),
        ('Which disorder is marked by intrusive thoughts and repetitive behaviours?',
         ARRAY['Obsessive‑compulsive disorder (OCD)', 'PTSD', 'Social anxiety disorder', 'Specific phobia'], 0,
         'OCD involves obsessions and compulsions.'),
        ('What is the most common eating disorder?',
         ARRAY['Binge eating disorder', 'Anorexia nervosa', 'Bulimia nervosa', 'Avoidant/restrictive food intake disorder'], 0,
         'Binge eating disorder is the most common eating disorder globally.'),
        ('Which condition is a dissociative disorder?',
         ARRAY['Dissociative identity disorder (DID)', 'Schizophrenia', 'Bipolar disorder', 'Panic disorder'], 0,
         'DID involves multiple distinct identities or personality states.'),
        ('What is the "bio‑psycho‑social" model?',
         ARRAY['A framework that considers biological, psychological, and social factors in understanding health and illness', 'A model focusing only on biological causes', 'A model focusing only on psychological causes', 'A model focusing only on social causes'], 0,
         'This model is widely used in clinical psychology.'),
        ('What is the therapeutic alliance?',
         ARRAY['The collaborative relationship between therapist and client', 'The agreement on treatment goals', 'The insurance contract', 'The assessment phase'], 0,
         'The therapeutic alliance is a strong predictor of positive outcomes.'),
        ('What is a "phobia"?',
         ARRAY['A persistent, excessive fear of a specific object or situation', 'A general feeling of anxiety', 'A mood disturbance', 'A personality trait'], 0,
         'Phobias are irrational fears that lead to avoidance.'),
        ('Which therapy emphasizes unconditional positive regard, empathy, and congruence?',
         ARRAY['Person‑centered therapy (Carl Rogers)', 'CBT', 'Psychoanalysis', 'Gestalt therapy'], 0,
         'Rogers developed client‑centered therapy.'),
        ('What is a "psychoactive drug"?',
         ARRAY['A substance that affects the brain and alters mood, perception, or behaviour', 'A medication for physical illness', 'A vitamin', 'A hormone'], 0,
         'Psychoactive drugs are used to treat mental disorders.'),
        ('What is the dopamine hypothesis of schizophrenia?',
         ARRAY['The idea that schizophrenia is caused by excess dopamine activity in the brain', 'The idea that schizophrenia is caused by low serotonin', 'The idea that schizophrenia is caused by genetics only', 'The idea that schizophrenia is caused by stress'], 0,
         'The dopamine hypothesis is supported by the efficacy of antipsychotics.'),
        ('Which disorder is characterized by alternating periods of depression and mania?',
         ARRAY['Bipolar disorder', 'Major depressive disorder', 'Cyclothymic disorder', 'Disruptive mood dysregulation disorder'], 0,
         'Bipolar I includes manic episodes; Bipolar II includes hypomanic episodes.'),
        ('What is the purpose of diagnostic classification systems like the DSM?',
         ARRAY['To provide a standardised set of criteria for mental disorders', 'To prescribe medication', 'To guide therapy techniques', 'To define normal behaviour'], 0,
         'The DSM is used by clinicians and researchers worldwide.'),
        ('Which personality disorder is characterized by a pervasive pattern of grandiosity, need for admiration, and lack of empathy?',
         ARRAY['Narcissistic personality disorder', 'Antisocial personality disorder', 'Histrionic personality disorder', 'Borderline personality disorder'], 0,
         'Narcissistic personality is marked by a sense of entitlement.'),
        ('What is "exposure therapy"?',
         ARRAY['A therapy that involves facing the feared object or situation in a controlled way', 'A therapy that avoids fear', 'A therapy that uses relaxation only', 'A therapy that changes thoughts'], 0,
         'Exposure therapy is effective for anxiety disorders.'),
        ('Which disorder is common in children and involves inattention, hyperactivity, and impulsivity?',
         ARRAY['ADHD (Attention‑Deficit/Hyperactivity Disorder)', 'Autism spectrum disorder', 'Conduct disorder', 'Anxiety disorder'], 0,
         'ADHD is one of the most common childhood disorders.'),
        ('What is the "medical model" of mental illness?',
         ARRAY['The view that mental disorders have biological causes and should be treated like physical illnesses', 'The view that mental disorders are caused by social factors', 'The view that mental disorders are caused by psychological factors', 'The view that mental disorders are not real'], 0,
         'The medical model has led to the development of psychopharmacology.'),
        ('Which therapy technique is associated with Sigmund Freud?',
         ARRAY['Psychoanalysis', 'Behavioral therapy', 'Cognitive therapy', 'Humanistic therapy'], 0,
         'Psychoanalysis emphasises unconscious processes and childhood experiences.'),
        ('What is the difference between normal sadness and clinical depression?',
         ARRAY['Clinical depression is persistent, severe, and interferes with functioning', 'Normal sadness lasts longer', 'They are the same', 'Clinical depression is always caused by a traumatic event'], 0,
         'Duration, intensity, and impairment distinguish clinical depression.'),
        ('What is the "Diathesis‑stress model"?',
         ARRAY['A model that suggests mental disorders develop from a combination of predisposition (diathesis) and environmental stress', 'A model that emphasises only genetics', 'A model that emphasises only stress', 'A model that emphasises only learning'], 0,
         'The diathesis‑stress model explains why some people develop disorders under stress.'),
        ('Which disorder is characterised by a persistent and excessive fear of being judged or embarrassed in social situations?',
         ARRAY['Social anxiety disorder', 'Agoraphobia', 'Generalized anxiety disorder', 'Panic disorder'], 0,
         'Social anxiety disorder is also called social phobia.'),
        ('What is a "psychotic break"?',
         ARRAY['An episode where a person loses contact with reality, often including hallucinations or delusions', 'A panic attack', 'A depressive episode', 'A manic episode'], 0,
         'Psychotic breaks can occur in schizophrenia, severe depression, or substance use.'),
        ('What is the prevalence of mental disorders globally?',
         ARRAY['About 1 in 4 people experience a mental disorder in their lifetime', 'About 1 in 10', 'About 1 in 50', 'Less than 5%'], 0,
         'Mental disorders are highly prevalent worldwide.'),
        ('Which therapy is often used for borderline personality disorder?',
         ARRAY['Dialectical behavior therapy (DBT)', 'CBT', 'Psychoanalysis', 'Family therapy'], 0,
         'DBT was developed by Marsha Linehan specifically for BPD.'),
        ('What is the role of a clinical psychologist in assessment?',
         ARRAY['To conduct diagnostic interviews and psychological testing', 'To prescribe medication', 'To perform brain surgery', 'To provide physical therapy'], 0,
         'Psychological assessment is a core competency of clinical psychologists.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_clinical, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 3. SOCIAL PSYCHOLOGY (31 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is social psychology?',
         ARRAY['The scientific study of how people''s thoughts, feelings, and behaviours are influenced by the actual, imagined, or implied presence of others', 'The study of individual differences', 'The study of brain processes', 'The study of human evolution'], 0,
         'Social psychology focuses on social influence and social perception.'),
        ('What is the "bystander effect"?',
         ARRAY['The phenomenon where individuals are less likely to help in an emergency when other people are present', 'The tendency to help more when alone', 'The tendency to imitate others', 'The tendency to conform'], 0,
         'The bystander effect was famously studied after the Kitty Genovese case.'),
        ('What is "social facilitation"?',
         ARRAY['The tendency for people to perform better on simple tasks when others are present', 'The tendency to perform worse on complex tasks', 'The tendency to conform', 'The tendency to obey authority'], 0,
         'Social facilitation enhances dominant responses.'),
        ('What is "social loafing"?',
         ARRAY['The tendency for individuals to exert less effort in a group than when alone', 'The tendency to work harder in a group', 'The tendency to lead a group', 'The tendency to avoid group tasks'], 0,
         'Social loafing is more common in large groups and when tasks are simple.'),
        ('What is "groupthink"?',
         ARRAY['A mode of thinking in which group members strive for unanimity at the expense of realistic appraisal', 'A type of decision‑making that encourages dissent', 'A group discussion technique', 'A type of leadership'], 0,
         'Groupthink can lead to poor decisions, as in the Bay of Pigs.'),
        ('What is "deindividuation"?',
         ARRAY['The loss of self‑awareness and individual accountability in a group, often leading to impulsive behaviour', 'The tendency to conform to group norms', 'The tendency to follow a leader', 'The tendency to become more self‑conscious'], 0,
         'Deindividuation is common in mobs and online environments.'),
        ('What is "compliance" in social psychology?',
         ARRAY['The act of changing one''s behaviour in response to a direct request', 'Changing behaviour in response to authority', 'Changing behaviour to match the group', 'Changing attitude due to persuasion'], 0,
         'Compliance is distinct from conformity and obedience.'),
        ('What is "obedience"?',
         ARRAY['Following orders from an authority figure', 'Following group norms', 'Complying with a request', 'Changing one''s attitude'], 0,
         'Stanley Milgram''s experiments demonstrated obedience to authority.'),
        ('What is "conformity"?',
         ARRAY['Adjusting one''s behaviour or thinking to coincide with a group standard', 'Following a direct order', 'Complying with a request', 'Changing one''s attitude due to persuasive arguments'], 0,
         'Asch''s conformity experiments showed the power of social pressure.'),
        ('Which experiment is famous for studying conformity?',
         ARRAY['Asch''s line judgment experiment', 'Milgram''s obedience experiment', 'Zimbardo''s prison experiment', 'Sherif''s autokinetic effect'], 0,
         'Asch''s experiment demonstrated conformity to a unanimous majority.'),
        ('Which experiment is famous for studying obedience?',
         ARRAY['Milgram''s electric shock experiment', 'Asch''s line experiment', 'Zimbardo''s prison experiment', 'Sherif''s autokinetic effect'], 0,
         'Milgram found that a majority of participants would deliver dangerous shocks under authority.'),
        ('What is the "Stanford prison experiment" known for?',
         ARRAY['It showed how social roles and situational factors can lead to abusive behaviour', 'It demonstrated conformity', 'It showed obedience to authority', 'It studied groupthink'], 0,
         'Zimbardo''s experiment was terminated early due to extreme behaviour.'),
        ('What is the "foot‑in‑the‑door" technique?',
         ARRAY['A persuasion strategy where making a small request first increases likelihood of agreeing to a larger request later', 'A strategy where a large request is made first', 'A strategy involving social proof', 'A strategy involving scarcity'], 0,
         'This technique leverages the principle of consistency.'),
        ('What is "cognitive dissonance" in social psychology?',
         ARRAY['The discomfort experienced when holding contradictory beliefs or engaging in behaviour that contradicts one''s attitudes', 'The tendency to conform', 'The tendency to obey authority', 'The tendency to justify one''s actions'], 0,
         'Festinger''s cognitive dissonance theory has been influential.'),
        ('What is the "fundamental attribution error"?',
         ARRAY['The tendency to overestimate dispositional causes and underestimate situational causes for others'' behaviour', 'The tendency to overestimate situational causes', 'The tendency to blame the victim', 'The tendency to attribute success to luck'], 0,
         'This error is also called correspondence bias.'),
        ('What is the "self‑serving bias"?',
         ARRAY['The tendency to attribute positive outcomes to internal factors and negative outcomes to external factors', 'The tendency to blame oneself for failures', 'The tendency to attribute success to luck', 'The tendency to see oneself as average'], 0,
         'The self‑serving bias protects self‑esteem.'),
        ('What is "stereotype"?',
         ARRAY['A generalized belief about a group of people', 'A negative attitude toward a group', 'A behaviour toward a group', 'A prejudice'], 0,
         'Stereotypes can be explicit or implicit.'),
        ('What is "prejudice"?',
         ARRAY['A negative attitude or feeling toward a person based on their group membership', 'A generalized belief', 'A behaviour', 'A cognitive bias'], 0,
         'Prejudice is an affective component.'),
        ('What is "discrimination"?',
         ARRAY['Unfair behaviour toward a person based on group membership', 'A negative attitude', 'A stereotype', 'A cognitive process'], 0,
         'Discrimination is the behavioural component.'),
        ('What is "implicit bias"?',
         ARRAY['Unconscious attitudes or stereotypes that affect judgment and behaviour', 'Explicitly held biases', 'A type of prejudice', 'A type of discrimination'], 0,
         'Implicit biases are measured with the Implicit Association Test (IAT).'),
        ('What is the "contact hypothesis"?',
         ARRAY['The idea that interpersonal contact between groups can reduce prejudice under certain conditions', 'The idea that contact increases prejudice', 'The idea that contact has no effect', 'The idea that contact only works in lab settings'], 0,
         'Contact theory is supported by research when conditions are optimal.'),
        ('What is the "halo effect"?',
         ARRAY['The tendency for one positive characteristic (e.g., attractiveness) to spill over to other aspects of a person', 'The tendency to judge others harshly', 'The tendency to overestimate one''s own abilities', 'The tendency to conform'], 0,
         'The halo effect influences first impressions.'),
        ('What is "attribution theory"?',
         ARRAY['A framework for explaining how people interpret and understand the causes of behaviour', 'A theory of personality', 'A theory of learning', 'A theory of memory'], 0,
         'Attribution theory explores internal vs. external attributions.'),
        ('What is "social comparison theory"?',
         ARRAY['The idea that people evaluate themselves by comparing with others', 'The idea that people compare themselves to their past', 'The idea that people compare themselves to their ideal self', 'The idea that people avoid comparisons'], 0,
         'Social comparison theory was proposed by Leon Festinger.'),
        ('What is "reciprocal liking"?',
         ARRAY['The tendency to like people who like us', 'The tendency to dislike people who like us', 'The tendency to be indifferent', 'The tendency to conform to group liking'], 0,
         'Reciprocal liking is a strong predictor of attraction.'),
        ('What is the "mere exposure effect"?',
         ARRAY['The tendency to develop a preference for stimuli after repeated exposure', 'The tendency to dislike new stimuli', 'The tendency to prefer novelty', 'The tendency to avoid familiarity'], 0,
         'Mere exposure applies to people, objects, and music.'),
        ('What is "aggression" in social psychology?',
         ARRAY['Behaviour intended to harm another person', 'Assertive behaviour', 'Defensive behaviour', 'Competitive behaviour'], 0,
         'Aggression can be hostile or instrumental.'),
        ('Which theory of aggression suggests it is learned through observation?',
         ARRAY['Social learning theory (Bandura)', 'Frustration‑aggression theory', 'Instinct theory', 'General aggression model'], 0,
         'Bandura''s Bobo doll experiment demonstrated observational learning of aggression.'),
        ('What is "prosocial behaviour"?',
         ARRAY['Behaviour intended to benefit others', 'Behaviour that harms others', 'Behaviour that is self‑serving', 'Behaviour that is neutral'], 0,
         'Prosocial behaviour includes helping, cooperating, and altruism.'),
        ('What is "altruism"?',
         ARRAY['Unselfish concern for the welfare of others', 'Behaviour that benefits oneself', 'Behaviour that is forced', 'Behaviour that is reciprocal'], 0,
         'Altruism is often contrasted with egoism.'),
        ('What is the "diffusion of responsibility"?',
         ARRAY['The tendency for individuals to feel less personal responsibility in the presence of others', 'The tendency to take more responsibility in groups', 'The tendency to blame others', 'The tendency to help more in groups'], 0,
         'Diffusion of responsibility contributes to the bystander effect.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_social, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 4. BEHAVIORAL SCIENCE (31 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is behavioral science?',
         ARRAY['The interdisciplinary study of human and animal behaviour, including psychology, sociology, anthropology, and neuroscience', 'The study of the brain only', 'The study of mental illness only', 'The study of social structures only'], 0,
         'Behavioral science integrates multiple disciplines.'),
        ('What is classical conditioning?',
         ARRAY['A learning process where a neutral stimulus becomes associated with a meaningful stimulus', 'A learning process where behaviour is reinforced', 'A learning process through observation', 'A learning process through insight'], 0,
         'Pavlov''s dogs are the classic example.'),
        ('Who is known for classical conditioning?',
         ARRAY['Ivan Pavlov', 'B.F. Skinner', 'John Watson', 'Edward Thorndike'], 0,
         'Pavlov discovered conditioned reflexes.'),
        ('What is operant conditioning?',
         ARRAY['A learning process where behaviour is strengthened or weakened by consequences (reinforcement or punishment)', 'A learning process where a neutral stimulus becomes a conditioned stimulus', 'A learning process through observation', 'A learning process through insight'], 0,
         'Operant conditioning was studied by Skinner.'),
        ('Who is known for operant conditioning?',
         ARRAY['B.F. Skinner', 'Ivan Pavlov', 'John Watson', 'Albert Bandura'], 0,
         'Skinner developed the Skinner box and principles of reinforcement.'),
        ('What is positive reinforcement?',
         ARRAY['Adding a rewarding stimulus after a behaviour to increase its frequency', 'Removing an aversive stimulus to increase behaviour', 'Adding an aversive stimulus to decrease behaviour', 'Removing a rewarding stimulus to decrease behaviour'], 0,
         'Positive reinforcement strengthens behaviour.'),
        ('What is negative reinforcement?',
         ARRAY['Removing an aversive stimulus after a behaviour to increase its frequency', 'Adding a rewarding stimulus', 'Adding an aversive stimulus', 'Removing a rewarding stimulus'], 0,
         'Negative reinforcement strengthens behaviour by removing something unpleasant.'),
        ('What is punishment?',
         ARRAY['Adding an aversive stimulus or removing a rewarding stimulus to decrease behaviour', 'Adding a rewarding stimulus to decrease behaviour', 'Removing an aversive stimulus to decrease behaviour', 'Adding a neutral stimulus to decrease behaviour'], 0,
         'Punishment can be positive or negative.'),
        ('What is observational learning?',
         ARRAY['Learning by watching others and imitating their behaviour', 'Learning through reinforcement', 'Learning through conditioning', 'Learning through insight'], 0,
         'Bandura''s social learning theory emphasizes observational learning.'),
        ('Who conducted the Bobo doll experiment?',
         ARRAY['Albert Bandura', 'B.F. Skinner', 'Ivan Pavlov', 'John Watson'], 0,
         'Bandura demonstrated that children imitate aggressive models.'),
        ('What is "shaping" in operant conditioning?',
         ARRAY['Reinforcing successive approximations of a desired behaviour', 'Reinforcing only the final behaviour', 'Punishing undesired behaviours', 'Using a fixed ratio schedule'], 0,
         'Shaping is used to teach complex behaviours.'),
        ('What is a "schedule of reinforcement"?',
         ARRAY['A rule that determines when reinforcement is delivered', 'A type of punishment', 'A type of conditioned stimulus', 'A type of observational learning'], 0,
         'Schedules include fixed/variable and ratio/interval combinations.'),
        ('What is a "fixed‑ratio schedule"?',
         ARRAY['Reinforcement after a fixed number of responses', 'Reinforcement after a variable number of responses', 'Reinforcement after a fixed time interval', 'Reinforcement after a variable time interval'], 0,
         'Fixed‑ratio produces high response rates.'),
        ('What is a "variable‑ratio schedule"?',
         ARRAY['Reinforcement after an unpredictable number of responses', 'Reinforcement after a fixed number', 'Reinforcement after a fixed time', 'Reinforcement after a variable time'], 0,
         'Variable‑ratio schedules produce the highest response rates and are resistant to extinction.'),
        ('What is "extinction" in operant conditioning?',
         ARRAY['The weakening of a behaviour when reinforcement is removed', 'The strengthening of a behaviour when reinforcement is added', 'The removal of an aversive stimulus', 'The presentation of a conditioned stimulus'], 0,
         'Extinction leads to the decrease of the behaviour.'),
        ('What is "stimulus generalization"?',
         ARRAY['The tendency to respond to stimuli that are similar to the conditioned stimulus', 'The tendency to respond only to the exact conditioned stimulus', 'The tendency to not respond to similar stimuli', 'The tendency to respond to all stimuli'], 0,
         'Generalisation is a key concept in conditioning.'),
        ('What is "discrimination" in conditioning?',
         ARRAY['The ability to distinguish between different stimuli and respond appropriately', 'The inability to distinguish stimuli', 'The tendency to generalize', 'The tendency to avoid certain stimuli'], 0,
         'Discrimination is learned through differential reinforcement.'),
        ('What is a "token economy"?',
         ARRAY['A system that uses tokens as secondary reinforcers to encourage desired behaviours', 'A system of financial rewards', 'A system of punishment', 'A system of observation'], 0,
         'Token economies are used in therapeutic settings.'),
        ('What is "behavioral therapy"?',
         ARRAY['A therapeutic approach that applies learning principles to change maladaptive behaviours', 'A therapy that focuses on unconscious conflicts', 'A therapy that focuses on cognitive restructuring', 'A therapy that uses medication'], 0,
         'Behavioral therapy is evidence‑based for many disorders.'),
        ('What is "systematic desensitization"?',
         ARRAY['A technique for reducing anxiety by gradual exposure to a feared stimulus while relaxing', 'A technique for increasing anxiety', 'A technique for treating depression', 'A technique for improving memory'], 0,
         'Systematic desensitization is a form of counterconditioning.'),
        ('Who developed systematic desensitization?',
         ARRAY['Joseph Wolpe', 'B.F. Skinner', 'Albert Bandura', 'Carl Rogers'], 0,
         'Wolpe applied classical conditioning to therapy.'),
        ('What is "aversion therapy"?',
         ARRAY['A therapy that pairs an undesirable behaviour with an aversive stimulus to reduce that behaviour', 'A therapy that uses pleasant stimuli', 'A therapy that uses relaxation', 'A therapy that uses cognitive restructuring'], 0,
         'Aversion therapy is used for addictions and paraphilias.'),
        ('What is "habituation"?',
         ARRAY['A decrease in response to a repeated stimulus over time', 'An increase in response to a repeated stimulus', 'No change in response', 'A conditioned response'], 0,
         'Habituation is a simple form of learning.'),
        ('What is "sensitization"?',
         ARRAY['An increase in response to a repeated stimulus', 'A decrease in response', 'No change', 'A conditioned response'], 0,
         'Sensitization often occurs with strong or harmful stimuli.'),
        ('What is "classical conditioning" in behaviorism?',
         ARRAY['Learning through association between stimuli', 'Learning through consequences', 'Learning through observation', 'Learning through insight'], 0,
         'Classical conditioning is a fundamental concept in behavioral science.'),
        ('What is "stimulus control"?',
         ARRAY['When a behaviour is influenced by the presence or absence of certain stimuli', 'When a behaviour is controlled by reinforcement only', 'When a behaviour is free from external influence', 'When a behaviour is genetically determined'], 0,
         'Stimulus control is central to discrimination learning.'),
        ('What is "modeling" in behavioral science?',
         ARRAY['Learning by observing and imitating others', 'Learning by reinforcement', 'Learning by conditioning', 'Learning by trial and error'], 0,
         'Modeling is a key component of social learning theory.'),
        ('What is "self‑efficacy"?',
         ARRAY['A person''s belief in their ability to succeed in specific situations', 'A person''s self‑esteem', 'A person''s general intelligence', 'A person''s emotional stability'], 0,
         'Self‑efficacy influences motivation and behaviour.'),
        ('Who introduced the concept of self‑efficacy?',
         ARRAY['Albert Bandura', 'B.F. Skinner', 'Carl Rogers', 'Abraham Maslow'], 0,
         'Bandura defined self‑efficacy as a core component of social cognitive theory.'),
        ('What is "behavioral economics"?',
         ARRAY['The study of how psychological factors influence economic decisions', 'The study of financial markets', 'The study of consumer behavior only', 'The study of macroeconomic policy'], 0,
         'Behavioral economics integrates psychology and economics.'),
        ('What is "nudge" theory?',
         ARRAY['A concept that suggests using positive reinforcement and indirect suggestions to influence behaviour', 'A theory of coercion', 'A theory of punishment', 'A theory of rational decision‑making'], 0,
         'Nudge theory, developed by Thaler and Sunstein, is used in public policy.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_behavioral, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 5. PERSONALITY (31 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is personality?',
         ARRAY['The unique set of enduring traits and characteristics that define an individual', 'The way a person behaves in one specific situation', 'A person''s intelligence', 'A person''s physical appearance'], 0,
         'Personality is relatively stable over time.'),
        ('Which theory emphasizes unconscious motives and conflicts in shaping personality?',
         ARRAY['Psychoanalytic theory', 'Trait theory', 'Humanistic theory', 'Social‑cognitive theory'], 0,
         'Freud''s psychoanalytic theory is the foundation of this approach.'),
        ('Who proposed the psychoanalytic theory of personality?',
         ARRAY['Sigmund Freud', 'Carl Rogers', 'Gordon Allport', 'Hans Eysenck'], 0,
         'Freud developed the id, ego, and superego model.'),
        ('What are the three structures of personality according to Freud?',
         ARRAY['Id, ego, and superego', 'Conscious, preconscious, unconscious', 'Oral, anal, phallic', 'Introvert, extrovert, ambivert'], 0,
         'These structures operate at different levels of awareness.'),
        ('Which theory identifies the "Big Five" personality traits?',
         ARRAY['Five‑Factor Model (OCEAN)', 'Eysenck''s three‑factor model', 'Cattell''s 16PF', 'Allport''s trait theory'], 0,
         'The Big Five are Openness, Conscientiousness, Extraversion, Agreeableness, Neuroticism.'),
        ('What are the Big Five personality traits?',
         ARRAY['Openness, Conscientiousness, Extraversion, Agreeableness, Neuroticism', 'Extroversion, Introversion, Neuroticism, Psychoticism, Intelligence', 'Sincerity, Honesty, Kindness, Intelligence, Humour', 'Dominance, Influence, Steadiness, Compliance, Conscientiousness'], 0,
         'OCEAN is a common acronym.'),
        ('What is the trait theory of personality?',
         ARRAY['The view that personality consists of stable traits that differ between individuals', 'The view that personality is determined by unconscious drives', 'The view that personality is a product of conditioning', 'The view that personality is based on self‑actualisation'], 0,
         'Trait theories focus on identifying and measuring personality dimensions.'),
        ('Who developed the MMPI?',
         ARRAY['Hathaway and McKinley', 'Rorschach', 'Eysenck', 'Allport'], 0,
         'The Minnesota Multiphasic Personality Inventory is a widely used clinical assessment.'),
        ('What is the Rorschach inkblot test?',
         ARRAY['A projective test that uses ambiguous inkblots to assess personality', 'A self‑report questionnaire', 'A clinical interview', 'An observational assessment'], 0,
         'The Rorschach is used to uncover unconscious thoughts and feelings.'),
        ('What is the Thematic Apperception Test (TAT)?',
         ARRAY['A projective test where individuals tell stories about ambiguous pictures', 'A self‑report test', 'An inkblot test', 'A behavioral observation'], 0,
         'The TAT reveals motives and conflicts.'),
        ('Which theory emphasizes personal growth and self‑actualization?',
         ARRAY['Humanistic theory', 'Psychoanalytic theory', 'Behavioral theory', 'Trait theory'], 0,
         'Humanistic psychologists like Maslow and Rogers focus on human potential.'),
        ('Who proposed the hierarchy of needs?',
         ARRAY['Abraham Maslow', 'Carl Rogers', 'Sigmund Freud', 'B.F. Skinner'], 0,
         'Maslow''s hierarchy includes physiological, safety, love, esteem, and self‑actualisation.'),
        ('Who developed client‑centered therapy?',
         ARRAY['Carl Rogers', 'Abraham Maslow', 'Sigmund Freud', 'Albert Bandura'], 0,
         'Rogers emphasized unconditional positive regard, empathy, and congruence.'),
        ('What is the "self‑concept" according to Rogers?',
         ARRAY['The organized set of perceptions and beliefs about oneself', 'The ideal self', 'The actual self', 'The social self'], 0,
         'Rogers believed that incongruence between self‑concept and reality leads to distress.'),
        ('What is the "locus of control"?',
         ARRAY['The degree to which people believe they have control over their own lives', 'The control exerted by others', 'The control exerted by fate', 'The control exerted by genetics'], 0,
         'Internal locus of control is associated with better outcomes.'),
        ('What is the social‑cognitive theory of personality?',
         ARRAY['A theory that emphasizes the interaction between personality traits and the environment', 'A theory that focuses on unconscious drives', 'A theory that focuses on traits', 'A theory that focuses on biological factors'], 0,
         'Bandura''s theory includes self‑efficacy and reciprocal determinism.'),
        ('What is "reciprocal determinism"?',
         ARRAY['The interaction between behaviour, cognitive factors, and environment in shaping personality', 'The interaction between genes and environment', 'The interaction between conscious and unconscious processes', 'The interaction between traits and situations'], 0,
         'Bandura proposed that these three factors influence each other.'),
        ('What is the "person‑situation controversy"?',
         ARRAY['A debate about whether personality or situation determines behaviour', 'A debate about nature vs. nurture', 'A debate about conscious vs. unconscious', 'A debate about trait vs. type'], 0,
         'This controversy questions the consistency of personality across situations.'),
        ('What is "self‑monitoring"?',
         ARRAY['The tendency to regulate one''s behaviour to fit social situations', 'The tendency to be consistent across situations', 'The tendency to be introverted', 'The tendency to be neurotic'], 0,
         'High self‑monitors adjust their behaviour to different contexts.'),
        ('Which personality disorder is characterised by an excessive need for admiration and lack of empathy?',
         ARRAY['Narcissistic personality disorder', 'Borderline personality disorder', 'Antisocial personality disorder', 'Avoidant personality disorder'], 0,
         'Narcissists have grandiose sense of self‑importance.'),
        ('Which personality disorder involves a pattern of social inhibition and feelings of inadequacy?',
         ARRAY['Avoidant personality disorder', 'Dependent personality disorder', 'Schizoid personality disorder', 'Paranoid personality disorder'], 0,
         'Avoidant individuals fear rejection and criticism.'),
        ('What is the difference between introversion and extraversion?',
         ARRAY['Extraverts are outgoing and seek stimulation; introverts are reserved and prefer less stimulation', 'Introverts are outgoing; extraverts are reserved', 'Extraverts are shy', 'Introverts are aggressive'], 0,
         'These are two ends of a continuum in many personality theories.'),
        ('Who introduced the concept of the collective unconscious?',
         ARRAY['Carl Jung', 'Sigmund Freud', 'Alfred Adler', 'Karen Horney'], 0,
         'Jung proposed the collective unconscious, containing archetypes.'),
        ('What is an "archetype" in Jungian psychology?',
         ARRAY['A universal, inherited pattern of thought or imagery', 'A type of trait', 'A defence mechanism', 'A coping strategy'], 0,
         'Archetypes include the persona, shadow, anima/animus.'),
        ('What is "defense mechanism" in psychoanalytic theory?',
         ARRAY['Unconscious strategies used to reduce anxiety by distorting reality', 'Conscious coping strategies', 'A type of personality trait', 'A type of learning'], 0,
         'Repression, projection, and rationalisation are examples.'),
        ('Which defence mechanism involves attributing one''s own unacceptable thoughts to others?',
         ARRAY['Projection', 'Repression', 'Rationalization', 'Displacement'], 0,
         'Projection is a common defence.'),
        ('What is the "impostor syndrome"?',
         ARRAY['A feeling of intellectual fraudulence despite clear success', 'A personality disorder', 'A type of anxiety disorder', 'A mood disorder'], 0,
         'Impostor syndrome is common among high achievers.'),
        ('What is "self‑esteem"?',
         ARRAY['One''s overall evaluation of one''s own worth', 'One''s belief in one''s abilities', 'One''s emotional stability', 'One''s level of extraversion'], 0,
         'Self‑esteem is a component of personality.'),
        ('What is the "dark triad" of personality?',
         ARRAY['Narcissism, Machiavellianism, and psychopathy', 'Neuroticism, extraversion, openness', 'Anxiety, depression, hostility', 'Aggression, impulsivity, antisociality'], 0,
         'These are socially aversive personality traits.'),
        ('What is "Machiavellianism"?',
         ARRAY['A personality trait characterised by manipulation and exploitation of others', 'A type of extraversion', 'A type of neuroticism', 'A type of openness'], 0,
         'Machiavellian individuals are strategic and cynical.'),
        ('What is "psychopathy"?',
         ARRAY['A personality trait involving callousness, lack of empathy, and antisocial behaviour', 'A type of anxiety', 'A type of mood disorder', 'A type of schizophrenia'], 0,
         'Psychopathy is associated with criminality in some cases.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_personality, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 6. MEMORY (31 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is memory?',
         ARRAY['The mental ability to encode, store, and retrieve information', 'The ability to recognise faces', 'The ability to speak', 'The ability to think logically'], 0,
         'Memory is a cognitive process.'),
        ('What are the three main stages of memory processing?',
         ARRAY['Encoding, storage, retrieval', 'Input, processing, output', 'Sensation, perception, cognition', 'Attention, rehearsal, forgetting'], 0,
         'These stages are fundamental to memory models.'),
        ('What is the capacity of iconic memory (sensory memory for vision)?',
         ARRAY['A few hundred milliseconds', 'A few seconds', 'A few minutes', 'Permanent'], 0,
         'Iconic memory is very brief, lasting under one second.'),
        ('What is the duration of echoic memory (auditory sensory memory)?',
         ARRAY['2 to 4 seconds', 'Less than 1 second', '1 to 2 seconds', 'Permanent'], 0,
         'Echoic memory lasts longer than iconic memory.'),
        ('What is short‑term memory capacity?',
         ARRAY['7 ± 2 chunks', '3 ± 1 chunks', '10 ± 2 chunks', 'Unlimited'], 0,
         'George Miller''s classic estimate.'),
        ('What is the duration of short‑term memory without rehearsal?',
         ARRAY['About 20‑30 seconds', 'Several minutes', 'A few hours', 'Permanent'], 0,
         'Information decays rapidly without rehearsal.'),
        ('What is the capacity of long‑term memory?',
         ARRAY['Essentially unlimited', 'About 1 million bits', 'About 100,000 items', 'About 100 GB'], 0,
         'Long‑term memory has no known limit.'),
        ('What is the difference between explicit and implicit memory?',
         ARRAY['Explicit memory is conscious; implicit memory is unconscious', 'Implicit is conscious; explicit is unconscious', 'Both are conscious', 'Both are unconscious'], 0,
         'Explicit memory includes episodic and semantic; implicit includes procedural and priming.'),
        ('What is "semantic memory"?',
         ARRAY['Memory for facts and general knowledge', 'Memory for personal events', 'Memory for skills', 'Memory for emotional experiences'], 0,
         'Semantic memory is a type of declarative memory.'),
        ('What is "episodic memory"?',
         ARRAY['Memory for specific personal events and experiences', 'Memory for facts', 'Memory for skills', 'Memory for language'], 0,
         'Episodic memory is autobiographical.'),
        ('What is "procedural memory"?',
         ARRAY['Memory for motor skills and habits', 'Memory for facts', 'Memory for events', 'Memory for faces'], 0,
         'Procedural memory is often implicit.'),
        ('What is "prospective memory"?',
         ARRAY['Memory for future intentions and plans', 'Memory for past events', 'Memory for facts', 'Memory for skills'], 0,
         'Prospective memory includes remembering to take medication or attend appointments.'),
        ('What is the "encoding specificity principle"?',
         ARRAY['Information retrieval is better when the context at retrieval matches the context at encoding', 'Information is encoded with specific features', 'Information is stored in specific locations in the brain', 'Information is forgotten after encoding'], 0,
         'This principle was proposed by Tulving.'),
        ('What is the "spacing effect"?',
         ARRAY['Learning is better when spaced over time rather than massed', 'Learning is better when massed', 'No difference', 'Spacing leads to more forgetting'], 0,
         'Spaced repetition is a key study strategy.'),
        ('What is "mnemonic"?',
         ARRAY['A memory‑enhancing technique or device', 'A type of amnesia', 'A type of memory loss', 'A type of memory test'], 0,
         'Mnemonics include acronyms, imagery, and method of loci.'),
        ('What is the "method of loci"?',
         ARRAY['A mnemonic technique involving visualising items in a familiar spatial location', 'A method of repetition', 'A method of association', 'A method of chunking'], 0,
         'The method of loci is used by memory champions.'),
        ('What is "flashbulb memory"?',
         ARRAY['A vivid, detailed memory of an emotionally significant event', 'A memory that is false', 'A memory of a dream', 'A memory that is very short'], 0,
         'Flashbulb memories are not always accurate.'),
        ('What is the "misinformation effect"?',
         ARRAY['The tendency for post‑event information to interfere with memory of the original event', 'The tendency to forget information', 'The tendency to remember information accurately', 'The tendency to create false memories without any suggestion'], 0,
         'Elizabeth Loftus demonstrated the misinformation effect.'),
        ('What is "source confusion" (source monitoring error)?',
         ARRAY['Mistaking the source of a memory (e.g., dream vs. reality)', 'Mistaking the content of a memory', 'Mistaking the date of a memory', 'Mistaking the emotion of a memory'], 0,
         'Source confusion contributes to false memories.'),
        ('Which brain structure is crucial for declarative memory?',
         ARRAY['Hippocampus', 'Amygdala', 'Cerebellum', 'Basal ganglia'], 0,
         'The hippocampus is essential for explicit memory.'),
        ('Which brain structure is important for procedural memory?',
         ARRAY['Cerebellum and basal ganglia', 'Hippocampus', 'Amygdala', 'Prefrontal cortex'], 0,
         'Procedural memory relies on these regions.'),
        ('What is "amnesia"?',
         ARRAY['Memory loss due to brain injury or disease', 'The ability to remember everything', 'A type of learning', 'A type of intelligence'], 0,
         'Amnesia can be anterograde or retrograde.'),
        ('What is "anterograde amnesia"?',
         ARRAY['The inability to form new memories after an event', 'The inability to remember past events', 'The inability to remember faces', 'The inability to remember language'], 0,
         'Anterograde amnesia is often caused by hippocampal damage.'),
        ('What is "retrograde amnesia"?',
         ARRAY['The inability to remember events that occurred before an event', 'The inability to form new memories', 'The inability to remember short‑term memories', 'The inability to remember motor skills'], 0,
         'Retrograde amnesia varies in severity.'),
        ('What is "forgetting" in psychology?',
         ARRAY['The inability to retrieve, recognise, or recall information', 'The permanent loss of information', 'The removal of information from memory', 'The failure to encode information'], 0,
         'Forgetting can occur due to decay, interference, or retrieval failure.'),
        ('What is the "curve of forgetting"?',
         ARRAY['A graph showing that memory declines exponentially over time without rehearsal', 'A graph showing that memory improves over time', 'A graph showing a linear decline', 'A graph showing no decline'], 0,
         'Ebbinghaus''s curve shows rapid forgetting soon after learning.'),
        ('Who conducted the classic experiment on forgetting using nonsense syllables?',
         ARRAY['Hermann Ebbinghaus', 'Elizabeth Loftus', 'Frederic Bartlett', 'John Atkinson'], 0,
         'Ebbinghaus used nonsense syllables to study memory.'),
        ('What is "interference" in memory?',
         ARRAY['The process by which similar memories impair retrieval', 'The process of memory enhancement', 'The process of memory consolidation', 'The process of memory encoding'], 0,
         'Interference can be proactive or retroactive.'),
        ('What is "state‑dependent memory"?',
         ARRAY['The phenomenon that retrieval is better when internal state matches encoding state', 'The phenomenon that memory depends on location', 'The phenomenon that memory depends on time', 'The phenomenon that memory depends on mood only'], 0,
         'State‑dependent memory is often studied with mood and drug states.'),
        ('What is "mood‑congruent memory"?',
         ARRAY['The tendency to recall information that matches one''s current mood', 'The tendency to recall information that contrasts with one''s current mood', 'The tendency to recall positive information', 'The tendency to recall negative information'], 0,
         'Mood‑congruent memory is a form of state‑dependent memory.'),
        ('What is "childhood amnesia"?',
         ARRAY['The inability to recall events from early childhood (before age 3‑4)', 'The inability to recall events from adolescence', 'The inability to recall events from school years', 'The inability to recall events from adulthood'], 0,
         'Childhood amnesia is a universal phenomenon.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_memory, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 7. LEARNING (31 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is learning in psychology?',
         ARRAY['A relatively permanent change in behaviour or knowledge resulting from experience', 'A temporary change in behaviour', 'A change due to maturation', 'A change due to instinct'], 0,
         'Learning is distinct from maturation or instinct.'),
        ('Which type of learning involves a neutral stimulus becoming associated with a response?',
         ARRAY['Classical conditioning', 'Operant conditioning', 'Observational learning', 'Cognitive learning'], 0,
         'Classical conditioning is also called Pavlovian conditioning.'),
        ('Which type of learning involves consequences that increase or decrease behaviour?',
         ARRAY['Operant conditioning', 'Classical conditioning', 'Observational learning', 'Insight learning'], 0,
         'Operant conditioning was studied by Skinner.'),
        ('What is "acquisition" in classical conditioning?',
         ARRAY['The initial stage of learning where the neutral stimulus becomes associated with the unconditioned stimulus', 'The weakening of a conditioned response', 'The reappearance of a response after extinction', 'The generalisation of a response'], 0,
         'Acquisition is the establishment of the conditioned response.'),
        ('What is "extinction" in classical conditioning?',
         ARRAY ['The weakening of the conditioned response when the conditioned stimulus is presented without the unconditioned stimulus', 'The removal of the unconditioned stimulus', 'The strengthening of the response', 'The generalisation of the response'], 0,
         'Extinction leads to the disappearance of the conditioned response.'),
        ('What is "spontaneous recovery" in classical conditioning?',
         ARRAY['The reappearance of a conditioned response after extinction and rest', 'The initial learning of the conditioned response', 'The weakening of the response', 'The generalisation of the response'], 0,
         'Spontaneous recovery shows that extinction does not erase the original learning.'),
        ('What is "generalisation" in classical conditioning?',
         ARRAY['The tendency to respond to stimuli similar to the conditioned stimulus', 'The tendency to respond only to the conditioned stimulus', 'The tendency not to respond to similar stimuli', 'The tendency to respond to all stimuli'], 0,
         'Generalisation helps explain how fears can spread.'),
        ('What is "discrimination" in classical conditioning?',
         ARRAY['The ability to distinguish between the conditioned stimulus and other stimuli', 'The inability to distinguish', 'The generalisation of a response', 'The extinction of a response'], 0,
         'Discrimination is learned through differential reinforcement.'),
        ('What is "positive reinforcement" in operant conditioning?',
         ARRAY['Adding a pleasant stimulus to increase a behaviour', 'Removing a pleasant stimulus to decrease behaviour', 'Adding an unpleasant stimulus to decrease behaviour', 'Removing an unpleasant stimulus to increase behaviour'], 0,
         'Positive reinforcement strengthens behaviour.'),
        ('What is "negative reinforcement"?',
         ARRAY['Removing an unpleasant stimulus to increase a behaviour', 'Adding a pleasant stimulus', 'Adding an unpleasant stimulus', 'Removing a pleasant stimulus'], 0,
         'Negative reinforcement increases behaviour by removal of something aversive.'),
        ('What is "positive punishment"?',
         ARRAY['Adding an unpleasant stimulus to decrease a behaviour', 'Removing an unpleasant stimulus to increase behaviour', 'Adding a pleasant stimulus to increase behaviour', 'Removing a pleasant stimulus to decrease behaviour'], 0,
         'Positive punishment involves the addition of an aversive consequence.'),
        ('What is "negative punishment"?',
         ARRAY['Removing a pleasant stimulus to decrease a behaviour', 'Adding an unpleasant stimulus', 'Removing an unpleasant stimulus', 'Adding a pleasant stimulus'], 0,
         'Negative punishment is also called omission training.'),
        ('What is "schedule of reinforcement"?',
         ARRAY['A rule specifying how often reinforcement is delivered', 'A type of punishment', 'A type of conditioned stimulus', 'A type of observational learning'], 0,
         'Schedules include fixed/variable and ratio/interval.'),
        ('What is a "fixed‑interval schedule"?',
         ARRAY['Reinforcement after a fixed time interval', 'Reinforcement after a variable time interval', 'Reinforcement after a fixed number of responses', 'Reinforcement after a variable number of responses'], 0,
         'Fixed‑interval schedules produce scalloped response patterns.'),
        ('What is a "variable‑interval schedule"?',
         ARRAY['Reinforcement after a variable time interval', 'Reinforcement after a fixed time', 'Reinforcement after a fixed number', 'Reinforcement after a variable number'], 0,
         'Variable‑interval schedules produce steady, moderate rates of responding.'),
        ('What is "shaping" in operant conditioning?',
         ARRAY ['Reinforcing successive approximations of a target behaviour', 'Reinforcing only the final behaviour', 'Punishing undesirable behaviours', 'Using a fixed ratio schedule'], 0,
         'Shaping is used to train complex behaviours.'),
        ('What is "chaining" in operant conditioning?',
         ARRAY['Reinforcing a sequence of behaviours in a specific order', 'Reinforcing a single behaviour', 'Reinforcing random behaviours', 'Punishing a sequence'], 0,
         'Chaining is used to teach multi‑step tasks.'),
        ('What is "observational learning"?',
         ARRAY['Learning by watching and imitating others', 'Learning through reinforcement', 'Learning through conditioning', 'Learning through trial and error'], 0,
         'Observational learning involves attention, retention, reproduction, and motivation.'),
        ('Who conducted the Bobo doll experiment?',
         ARRAY['Albert Bandura', 'B.F. Skinner', 'Ivan Pavlov', 'John Watson'], 0,
         'Bandura''s experiment showed that children imitate aggressive models.'),
        ('What is "latent learning"?',
         ARRAY['Learning that occurs without reinforcement and is not immediately expressed', 'Learning that is reinforced immediately', 'Learning through observation', 'Learning through conditioning'], 0,
         'Latent learning was demonstrated by Tolman''s rat experiments.'),
        ('What is "insight learning"?',
         ARRAY['A sudden realisation of a solution to a problem', 'Learning through trial and error', 'Learning through observation', 'Learning through conditioning'], 0,
         'Insight learning was described by Gestalt psychologists.'),
        ('What is "learning curve"?',
         ARRAY['A graphical representation of the rate of learning over time', 'A curve showing forgetting', 'A curve showing reinforcement schedules', 'A curve showing motivation'], 0,
         'Learning curves can show plateaus.'),
        ('What is "overlearning"?',
         ARRAY['Continued practice beyond mastery to strengthen memory', 'Learning too much information', 'Learning without understanding', 'Learning that leads to confusion'], 0,
         'Overlearning helps prevent forgetting.'),
        ('What is "transfer of learning"?',
         ARRAY['The influence of previous learning on new learning', 'The forgetting of previous learning', 'The inability to learn new things', 'The generalisation of learning across contexts'], 0,
         'Transfer can be positive or negative.'),
        ('What is "positive transfer"?',
         ARRAY['When prior learning helps new learning', 'When prior learning hinders new learning', 'When there is no effect', 'When learning is lost'], 0,
         'Positive transfer occurs when skills overlap.'),
        ('What is "negative transfer"?',
         ARRAY['When prior learning hinders new learning', 'When prior learning helps new learning', 'When there is no effect', 'When learning is lost'], 0,
         'Negative transfer occurs when old habits interfere with new ones.'),
        ('What is "plateau" in a learning curve?',
         ARRAY['A period of no apparent progress in learning', 'A period of rapid learning', 'A period of decline', 'A period of forgetting'], 0,
         'Plateaus are common in complex skill acquisition.'),
        ('What is "motivation" in learning?',
         ARRAY['The drive that initiates and directs behaviour toward a goal', 'The ability to learn', 'The capacity for memory', 'The reinforcement value'], 0,
         'Motivation is essential for effective learning.'),
        ('What is "extrinsic motivation"?',
         ARRAY['Motivation driven by external rewards or punishments', 'Motivation driven by internal satisfaction', 'Motivation that is innate', 'Motivation that is learned'], 0,
         'Extrinsic motivation can sometimes undermine intrinsic motivation.'),
        ('What is "intrinsic motivation"?',
         ARRAY['Motivation driven by internal rewards, such as interest or enjoyment', 'Motivation driven by external rewards', 'Motivation that is innate', 'Motivation that is learned'], 0,
         'Intrinsic motivation leads to greater engagement.'),
        ('What is the "zone of proximal development" (ZPD)?',
         ARRAY['The difference between what a learner can do without help and what they can do with guidance', 'The stage of cognitive development', 'The level of performance', 'The area of learning difficulty'], 0,
         'ZPD was introduced by Vygotsky.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_learning, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 8. EMOTIONS (31 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is emotion in psychology?',
         ARRAY['A complex state involving physiological arousal, subjective feeling, and behavioural expression', 'A cognitive process', 'A type of personality', 'A type of memory'], 0,
         'Emotions have multiple components.'),
        ('Which theory suggests that emotions are caused by physiological reactions?',
         ARRAY['James‑Lange theory', 'Cannon‑Bard theory', 'Schachter‑Singer theory', 'Appraisal theory'], 0,
         'The James‑Lange theory proposes that we feel emotion after we perceive bodily changes.'),
        ('Which theory proposes that emotional experience and physiological arousal occur simultaneously?',
         ARRAY['Cannon‑Bard theory', 'James‑Lange theory', 'Schachter‑Singer theory', 'Lazarus theory'], 0,
         'The Cannon‑Bard theory rejects the James‑Lange sequence.'),
        ('Which theory emphasizes cognitive appraisal in emotion?',
         ARRAY['Lazarus''s appraisal theory', 'James‑Lange', 'Cannon‑Bard', 'Schachter‑Singer'], 0,
         'Appraisal theory holds that emotions are based on how we evaluate events.'),
        ('Which theory includes a two‑factor model where emotion is based on arousal and cognitive label?',
         ARRAY['Schachter‑Singer two‑factor theory', 'James‑Lange', 'Cannon‑Bard', 'Lazarus'], 0,
         'Schachter and Singer showed that arousal plus context determines emotion.'),
        ('What is the "facial feedback hypothesis"?',
         ARRAY['Facial expressions can influence emotional experience', 'Emotions influence facial expressions', 'Facial expressions are irrelevant to emotion', 'Emotions are always internal'], 0,
         'Facial feedback suggests that smiling can make you feel happier.'),
        ('Which brain structure is key to emotional processing, especially fear?',
         ARRAY['Amygdala', 'Hippocampus', 'Prefrontal cortex', 'Cerebellum'], 0,
         'The amygdala is critical for fear conditioning and emotional memory.'),
        ('What is the function of the hypothalamus in emotion?',
         ARRAY['It regulates autonomic nervous system and endocrine responses related to emotion', 'It processes visual emotions', 'It stores emotional memories', 'It controls voluntary movement'], 0,
         'The hypothalamus is involved in the stress response.'),
        ('Which neurotransmitter is associated with pleasure and reward?',
         ARRAY['Dopamine', 'Serotonin', 'Norepinephrine', 'Acetylcholine'], 0,
         'Dopamine is involved in the brain''s reward circuit.'),
        ('What is the "fight‑or‑flight" response?',
         ARRAY['A physiological response to a perceived threat, preparing the body for action', 'A response to a positive event', 'A relaxation response', 'A sleep response'], 0,
         'The fight‑or‑flight response is mediated by the sympathetic nervous system.'),
        ('What is the role of the sympathetic nervous system in emotion?',
         ARRAY['It mobilises the body for action (fight or flight)', 'It calms the body (rest and digest)', 'It controls voluntary movement', 'It processes sensory information'], 0,
         'The sympathetic system is active during emotional arousal.'),
        ('What is the role of the parasympathetic nervous system in emotion?',
         ARRAY['It calms the body and promotes relaxation', 'It mobilises the body for action', 'It controls voluntary movement', 'It processes sensory information'], 0,
         'The parasympathetic system is active during relaxation and recovery.'),
        ('What is "emotional intelligence"?',
         ARRAY['The ability to perceive, understand, manage, and use emotions effectively', 'The ability to feel emotions strongly', 'The ability to avoid emotions', 'The ability to suppress emotions'], 0,
         'Emotional intelligence includes empathy and self‑regulation.'),
        ('What are the basic emotions according to Paul Ekman?',
         ARRAY ['Happiness, sadness, fear, anger, surprise, disgust', 'Love, hate, joy, sorrow', 'Pleasure, pain, excitement', 'Interest, joy, surprise, anger, fear, sadness'], 0,
         'Ekman proposed six basic emotions with universal facial expressions.'),
        ('What is "mood" compared to emotion?',
         ARRAY['Moods are longer‑lasting and less intense than emotions', 'Moods are shorter and more intense', 'Moods are the same as emotions', 'Moods are cognitive, emotions are physiological'], 0,
         'Moods often persist without a clear trigger.'),
        ('What is "emotion regulation"?',
         ARRAY['The processes by which individuals influence which emotions they have, when, and how they experience them', 'The suppression of all emotions', 'The expression of all emotions', 'The avoidance of emotions'], 0,
         'Emotion regulation is important for mental health.'),
        ('What is "cognitive reappraisal"?',
         ARRAY['Changing the way one thinks about a situation to change its emotional impact', 'Suppressing the expression of emotion', 'Ignoring emotions', 'Acting on emotions impulsively'], 0,
         'Cognitive reappraisal is an effective strategy for emotion regulation.'),
        ('What is "suppression" in emotion regulation?',
         ARRAY['Inhibiting the outward expression of emotion', 'Changing the situation', 'Changing the meaning of the situation', 'Accepting emotions'], 0,
         'Suppression can be costly in terms of cognitive resources.'),
        ('What is "display rules"?',
         ARRAY['Cultural rules about when and how to express emotions', 'Rules about what emotions to feel', 'Rules about how to suppress emotions', 'Rules about how to change emotions'], 0,
         'Display rules vary across cultures.'),
        ('What is "empathy"?',
         ARRAY['The ability to understand and share the feelings of another person', 'The ability to feel sorry for someone', 'The ability to ignore others'' emotions', 'The ability to express one''s own emotions'], 0,
         'Empathy is a key social skill.'),
        ('What is "sympathy"?',
         ARRAY['Feelings of concern or pity for another person', 'Understanding another''s emotions', 'Sharing another''s emotions', 'Ignoring another''s emotions'], 0,
         'Sympathy involves concern but not necessarily sharing the emotion.'),
        ('What is "affective neuroscience"?',
         ARRAY['The study of the neural basis of emotion', 'The study of cognition', 'The study of behaviour', 'The study of personality'], 0,
         'Affective neuroscience examines brain systems involved in emotion.'),
        ('Which limbic system structure is crucial for emotional memory?',
         ARRAY['Amygdala', 'Hippocampus', 'Hypothalamus', 'Thalamus'], 0,
         'The amygdala plays a key role in emotional memory consolidation.'),
        ('What is "emotional contagion"?',
         ARRAY['The spread of emotions from one person to another', 'The feeling of a single emotion', 'The suppression of emotion', 'The regulation of emotion'], 0,
         'Emotional contagion can occur via mimicry.'),
        ('What is "stress"?',
         ARRAY['The body''s response to a perceived threat or demand', 'A type of emotion', 'A cognitive process', 'A personality trait'], 0,
         'Stress involves both psychological and physiological reactions.'),
        ('Which hormone is released in response to stress?',
         ARRAY['Cortisol', 'Dopamine', 'Serotonin', 'Oxytocin'], 0,
         'Cortisol is a glucocorticoid released by the adrenal cortex.'),
        ('What is the "general adaptation syndrome" (GAS)?',
         ARRAY['A model of stress response with alarm, resistance, and exhaustion stages', 'A model of emotion regulation', 'A model of learning', 'A model of memory'], 0,
         'GAS was proposed by Hans Selye.'),
        ('What is "post‑traumatic stress disorder" (PTSD)?',
         ARRAY['A disorder following exposure to a traumatic event, characterised by re‑experiencing, avoidance, and hyperarousal', 'A mood disorder', 'An anxiety disorder', 'A personality disorder'], 0,
         'PTSD is a trauma‑related disorder.'),
        ('Which therapy is effective for PTSD?',
         ARRAY['Trauma‑focused CBT and EMDR', 'Psychoanalysis', 'Person‑centered therapy', 'Group therapy only'], 0,
         'Trauma‑focused therapies are evidence‑based.'),
        ('What is "anxiety"?',
         ARRAY['A feeling of worry, nervousness, or unease about an uncertain outcome', 'A specific emotion', 'A mood state', 'A personality trait'], 0,
         'Anxiety is a common emotion with adaptive functions.'),
        ('What is "happiness" in psychology?',
         ARRAY['A state of well‑being and positive affect', 'The absence of negative emotions', 'The goal of all human behaviour', 'A fleeting emotion'], 0,
         'Happiness is often studied under the rubric of subjective well‑being.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_emotions, q_rec.column1, 'single_choice', q_rec.column4)
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