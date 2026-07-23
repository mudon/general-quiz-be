-- ============================================================================
-- Insert 100 factual questions on Artificial Intelligence.
-- Subtopics: Machine Learning, Deep Learning, Neural Networks, Computer Vision,
-- NLP, Robotics, Expert Systems, Reinforcement Learning, AI Ethics.
-- ============================================================================

DO $$
DECLARE
    cat_id_ml          BIGINT;
    cat_id_dl          BIGINT;
    cat_id_nn          BIGINT;
    cat_id_cv          BIGINT;
    cat_id_nlp         BIGINT;
    cat_id_robotics    BIGINT;
    cat_id_expert      BIGINT;
    cat_id_rl          BIGINT;
    cat_id_ethics      BIGINT;
    q_id               BIGINT;
    correct_opt_id     BIGINT;
    opt_texts          TEXT[];
    q_rec              RECORD;
BEGIN
    -- ------------------------------------------------------------------------
    -- Create categories (hierarchical under artificial_intelligence)
    -- ------------------------------------------------------------------------
    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('artificial_intelligence', 'Artificial Intelligence', 2, 0)
        ON CONFLICT (path) DO NOTHING;

    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('artificial_intelligence.machine_learning',        'Machine Learning', 2, 1),
        ('artificial_intelligence.deep_learning',           'Deep Learning', 2, 2),
        ('artificial_intelligence.neural_networks',         'Neural Networks', 2, 3),
        ('artificial_intelligence.computer_vision',         'Computer Vision', 2, 4),
        ('artificial_intelligence.natural_language_processing', 'Natural Language Processing', 2, 5),
        ('artificial_intelligence.robotics',                'Robotics', 2, 6),
        ('artificial_intelligence.expert_systems',          'Expert Systems', 2, 7),
        ('artificial_intelligence.reinforcement_learning',  'Reinforcement Learning', 2, 8),
        ('artificial_intelligence.ai_ethics',               'AI Ethics', 2, 9)
        ON CONFLICT (path) DO NOTHING;

    -- Get category IDs
    SELECT id INTO cat_id_ml        FROM categories WHERE path = 'artificial_intelligence.machine_learning';
    SELECT id INTO cat_id_dl        FROM categories WHERE path = 'artificial_intelligence.deep_learning';
    SELECT id INTO cat_id_nn        FROM categories WHERE path = 'artificial_intelligence.neural_networks';
    SELECT id INTO cat_id_cv        FROM categories WHERE path = 'artificial_intelligence.computer_vision';
    SELECT id INTO cat_id_nlp       FROM categories WHERE path = 'artificial_intelligence.natural_language_processing';
    SELECT id INTO cat_id_robotics  FROM categories WHERE path = 'artificial_intelligence.robotics';
    SELECT id INTO cat_id_expert    FROM categories WHERE path = 'artificial_intelligence.expert_systems';
    SELECT id INTO cat_id_rl        FROM categories WHERE path = 'artificial_intelligence.reinforcement_learning';
    SELECT id INTO cat_id_ethics    FROM categories WHERE path = 'artificial_intelligence.ai_ethics';

    -- ========================================================================
    -- 1. MACHINE LEARNING (12 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the fundamental goal of machine learning?',
         ARRAY['To enable computers to learn from data without explicit programming', 'To replace human reasoning', 'To create general intelligence', 'To perform calculations faster'], 0,
         'ML algorithms improve their performance with experience (data).'),
        ('What is the difference between supervised and unsupervised learning?',
         ARRAY['Supervised uses labelled data; unsupervised uses unlabelled data', 'Unsupervised uses labelled data; supervised uses unlabelled', 'Both use labelled data', 'Both use unlabelled data'], 0,
         'In supervised learning, each training example has an input and a desired output.'),
        ('Which of the following is a supervised learning task?',
         ARRAY['Classification and regression', 'Clustering', 'Dimensionality reduction', 'Association rule mining'], 0,
         'Classification and regression are classic supervised learning problems.'),
        ('Which algorithm is often used for binary classification?',
         ARRAY['Logistic regression', 'Linear regression', 'K‑means', 'PCA'], 0,
         'Logistic regression is used for classification, not regression.'),
        ('What is overfitting in machine learning?',
         ARRAY['A model that performs well on training data but poorly on new data', 'A model that performs poorly on training data', 'A model that learns too slowly', 'A model that has too few parameters'], 0,
         'Overfitting occurs when a model learns noise instead of the underlying pattern.'),
        ('What is the purpose of a test set?',
         ARRAY['To evaluate the model''s performance on unseen data', 'To train the model', 'To adjust hyperparameters', 'To select features'], 0,
         'The test set gives an unbiased estimate of generalization error.'),
        ('Which metric is commonly used for classification tasks?',
         ARRAY['Accuracy', 'Mean squared error', 'R²', 'Silhouette score'], 0,
         'Accuracy is the fraction of correct predictions.'),
        ('What is feature selection?',
         ARRAY['Choosing a subset of relevant features to use in model construction', 'Creating new features from existing ones', 'Normalising feature values', 'Removing outliers'], 0,
         'Feature selection improves interpretability and reduces overfitting.'),
        ('What is the "curse of dimensionality"?',
         ARRAY['The phenomenon where the data becomes sparse and hard to model as the number of features increases', 'The problem of many parameters', 'The difficulty of visualizing high‑dimensional data', 'The increased computational cost'], 0,
         'High‑dimensional spaces require exponentially more data for reliable predictions.'),
        ('Which algorithm is a type of ensemble learning?',
         ARRAY['Random Forest', 'K‑Nearest Neighbors', 'Support Vector Machine', 'Naive Bayes'], 0,
         'Random Forest is an ensemble of decision trees.'),
        ('What is a confusion matrix used for?',
         ARRAY['To visualise the performance of a classification model', 'To calculate regression errors', 'To identify outliers', 'To perform dimensionality reduction'], 0,
         'It shows true positives, false positives, true negatives, false negatives.'),
        ('What is bias‑variance tradeoff?',
         ARRAY['The balance between the error due to simplifying assumptions and the error due to sensitivity to training data', 'The tradeoff between training time and test time', 'The tradeoff between model complexity and accuracy', 'The tradeoff between speed and memory'], 0,
         'Low bias often leads to high variance and vice versa.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_ml, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 2. DEEP LEARNING (11 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What distinguishes deep learning from traditional machine learning?',
         ARRAY['It uses multiple layers of nonlinear transformations (deep neural networks)', 'It uses only linear models', 'It requires less data', 'It does not require feature engineering'], 0,
         'Deep learning automatically learns hierarchical representations.'),
        ('What is a convolutional neural network (CNN) primarily used for?',
         ARRAY['Image and spatial data analysis', 'Sequential data such as text', 'Time series forecasting', 'Reinforcement learning'], 0,
         'CNNs are designed with convolutional layers that are effective for image recognition.'),
        ('Which activation function is commonly used in deep networks to avoid vanishing gradients?',
         ARRAY['ReLU (Rectified Linear Unit)', 'Sigmoid', 'Tanh', 'Softmax'], 0,
         'ReLU helps mitigate the vanishing gradient problem because its derivative is constant for positive inputs.'),
        ('What is a recurrent neural network (RNN) good for?',
         ARRAY['Sequence data like time series or text', 'Image classification', 'Object detection', 'Clustering'], 0,
         'RNNs have loops that allow information to persist over time steps.'),
        ('What is the role of a loss function in deep learning?',
         ARRAY['To measure the difference between the predicted output and the target', 'To count the number of parameters', 'To initialise weights', 'To select a learning rate'], 0,
         'The loss guides the optimisation process (e.g., gradient descent).'),
        ('What is backpropagation?',
         ARRAY['The algorithm to compute gradients of the loss with respect to all weights', 'The forward pass of data', 'A method to initialise weights', 'A technique for data augmentation'], 0,
         'Backpropagation uses the chain rule to propagate error backward through the network.'),
        ('What is a dropout layer used for in deep learning?',
         ARRAY['To prevent overfitting by randomly dropping units during training', 'To reduce the number of layers', 'To speed up training', 'To increase model capacity'], 0,
         'Dropout forces the network to learn redundant representations.'),
        ('Which architecture is famous for image classification, winning the ImageNet challenge in 2012?',
         ARRAY['AlexNet', 'VGGNet', 'ResNet', 'Inception'], 0,
         'AlexNet, by Krizhevsky et al., marked a breakthrough for deep learning.'),
        ('What is a batch normalisation layer?',
         ARRAY['A layer that normalises the input to a layer to accelerate training', 'A layer that reduces the number of parameters', 'A layer that adds noise for regularisation', 'A layer that performs pooling'], 0,
         'Batch norm reduces internal covariate shift and allows higher learning rates.'),
        ('Which type of deep learning model is designed for unsupervised feature learning?',
         ARRAY['Autoencoder', 'CNN', 'RNN', 'Transformer'], 0,
         'Autoencoders learn compressed representations by reconstructing inputs.'),
        ('What is the typical activation function for the output layer in multi‑class classification?',
         ARRAY['Softmax', 'Sigmoid', 'ReLU', 'Tanh'], 0,
         'Softmax outputs a probability distribution over classes.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_dl, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 3. NEURAL NETWORKS (11 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the basic unit of a neural network?',
         ARRAY['Neuron (or perceptron)', 'Layer', 'Synapse', 'Weight'], 0,
         'A neuron computes a weighted sum of inputs and applies an activation function.'),
        ('What is the function of weights in a neural network?',
         ARRAY['To determine the strength of connections between neurons', 'To add bias to the network', 'To store the output', 'To initialize the network'], 0,
         'Weights are adjusted during training to minimise the loss.'),
        ('What is a bias in a neural network?',
         ARRAY['A constant added to the weighted sum to allow shifting the activation function', 'A random initial value', 'A penalty term', 'A gradient'], 0,
         'Bias units allow the neuron to fit the data better.'),
        ('What is the activation function of a neuron?',
         ARRAY['A nonlinear function that determines the output based on the weighted sum', 'The input to the neuron', 'The loss function', 'The learning rate'], 0,
         'Common activations: ReLU, sigmoid, tanh.'),
        ('What is the perceptron?',
         ARRAY['A single‑layer neural network with a step activation function', 'A multi‑layer network', 'A convolutional network', 'A recurrent network'], 0,
         'The perceptron is a simple binary classifier introduced by Rosenblatt.'),
        ('What is a hidden layer?',
         ARRAY['A layer between the input and output layers', 'The output layer', 'The input layer', 'A layer that is not used'], 0,
         'Hidden layers allow the network to learn complex patterns.'),
        ('What is the universal approximation theorem?',
         ARRAY['A theorem stating that a feedforward neural network with a single hidden layer can approximate any continuous function', 'A theorem about gradient descent', 'A theorem about the optimal number of hidden layers', 'A theorem about data efficiency'], 0,
         'However, it does not guarantee that the network is easy to train.'),
        ('What is a multilayer perceptron (MLP)?',
         ARRAY['A feedforward neural network with one or more hidden layers', 'A single‑layer perceptron', 'A recurrent neural network', 'A convolutional neural network'], 0,
         'MLPs are the classic type of artificial neural network.'),
        ('What is a feedforward neural network?',
         ARRAY['A network where connections do not form cycles (information flows forward)', 'A network with loops', 'A network that uses time delay', 'A network with feedback connections'], 0,
         'The opposite is recurrent neural networks.'),
        ('What is the role of the learning rate in training neural networks?',
         ARRAY['It controls the step size when updating weights during gradient descent', 'It controls the number of epochs', 'It controls the batch size', 'It controls the number of neurons'], 0,
         'A high learning rate can cause divergence; a low rate slows convergence.'),
        ('What is stochastic gradient descent (SGD)?',
         ARRAY['An optimisation algorithm that updates weights using a random subset of training examples (minibatch)', 'An algorithm that uses all examples', 'An algorithm for feature selection', 'An algorithm for initialisation'], 0,
         'SGD is computationally efficient and introduces noise that helps escape local minima.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_nn, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 4. COMPUTER VISION (11 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is computer vision?',
         ARRAY['A field of AI that enables computers to interpret and understand visual information from images or videos', 'A type of database', 'A kind of display technology', 'A graphics rendering tool'], 0,
         'Computer vision aims to replicate human visual perception.'),
        ('What is an image classification task?',
         ARRAY['Assigning a label to an entire image', 'Detecting objects within an image', 'Segmenting an image into regions', 'Generating new images'], 0,
         'Example: classifying images as "cat" or "dog".'),
        ('What is object detection?',
         ARRAY['Locating and classifying multiple objects within an image', 'Classifying the whole image', 'Segmenting the image', 'Tracking objects in video'], 0,
         'Object detection produces bounding boxes around objects.'),
        ('What is image segmentation?',
         ARRAY['Partitioning an image into segments (pixel‑level classification)', 'Classifying the whole image', 'Detecting objects', 'Generating images'], 0,
         'Segmentation assigns a class to every pixel.'),
        ('What is a convolutional layer in the context of computer vision?',
         ARRAY['A layer that applies a set of learnable filters to extract features', 'A layer that performs pooling', 'A layer that flattens features', 'A layer that applies dropout'], 0,
         'Convolutional layers learn spatial hierarchies of features.'),
        ('What is transfer learning in computer vision?',
         ARRAY['Using a model pre‑trained on a large dataset and fine‑tuning it on a specific task', 'Training a model from scratch', 'Transferring data between tasks', 'Using multiple models in parallel'], 0,
         'Transfer learning reduces the need for large amounts of labelled data.'),
        ('What is a generative adversarial network (GAN) used for in vision?',
         ARRAY['Generating new images that look realistic', 'Classifying images', 'Segmenting images', 'Tracking objects'], 0,
         'GANs consist of a generator and a discriminator.'),
        ('What is the purpose of a pooling layer in a CNN?',
         ARRAY['To reduce the spatial dimensions of the feature maps', 'To increase the depth', 'To add non‑linearity', 'To regularize'], 0,
         'Pooling (e.g., max‑pooling) reduces computational load and provides some translation invariance.'),
        ('What is the role of a fully connected layer in a CNN?',
         ARRAY['To perform classification based on features extracted by convolutional layers', 'To extract features', 'To reduce dimensionality', 'To perform convolution'], 0,
         'Fully connected layers are often at the end of a CNN.'),
        ('Which architecture is known for introducing residual connections to ease training of very deep networks?',
         ARRAY['ResNet', 'VGG', 'AlexNet', 'Inception'], 0,
         'ResNet (Residual Networks) introduced skip connections to address the vanishing gradient problem.'),
        ('What is a semantic segmentation task?',
         ARRAY['Classifying each pixel into a category (e.g., road, pedestrian, sky)', 'Detecting objects with bounding boxes', 'Classifying the entire image', 'Tracking moving objects'], 0,
         'Semantic segmentation is used in autonomous driving and medical imaging.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_cv, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 5. NLP (11 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What does NLP stand for?',
         ARRAY['Natural Language Processing', 'Non‑Linear Programming', 'Neural Language Processing', 'Numerical Logic Programming'], 0,
         'NLP is the subfield of AI focusing on interaction between computers and human language.'),
        ('What is tokenization in NLP?',
         ARRAY['Splitting text into smaller units (tokens) such as words or subwords', 'Converting text to numbers', 'Classifying text', 'Removing stop words'], 0,
         'Tokenization is a fundamental preprocessing step.'),
        ('What is a word embedding?',
         ARRAY['A dense vector representation of a word that captures semantic meaning', 'A sparse representation', 'A count of word occurrences', 'A matrix of probabilities'], 0,
         'Examples: Word2Vec, GloVe, BERT embeddings.'),
        ('What is the main goal of machine translation?',
         ARRAY['Automatic translation of text from one language to another', 'Summarising text', 'Analyzing sentiment', 'Parsing grammar'], 0,
         'Machine translation is one of the classic NLP tasks.'),
        ('What is sentiment analysis?',
         ARRAY['Determining the emotional tone (positive, negative, neutral) of a piece of text', 'Classifying text by topic', 'Extracting named entities', 'Summarising text'], 0,
         'Sentiment analysis is widely used for social media monitoring.'),
        ('What is a transformer model?',
         ARRAY['A neural network architecture based on self‑attention mechanisms', 'A type of RNN', 'A type of CNN', 'A type of autoencoder'], 0,
         'Transformers, introduced in "Attention is All You Need", are the state‑of‑the‑art in NLP.'),
        ('What is BERT?',
         ARRAY['Bidirectional Encoder Representations from Transformers – a pre‑trained language model', 'A type of RNN', 'A word embedding technique', 'A machine translation system'], 0,
         'BERT is a popular pre‑trained model for many NLP tasks.'),
        ('What is a language model?',
         ARRAY['A model that assigns probabilities to sequences of words', 'A model for speech recognition', 'A model for image captioning', 'A model for text classification'], 0,
         'Language models learn the statistical structure of language.'),
        ('What is named entity recognition (NER)?',
         ARRAY['Identifying and classifying named entities (people, organisations, locations) in text', 'Identifying all nouns', 'Identifying verbs', 'Parsing sentence structure'], 0,
         'NER is a key information extraction task.'),
        ('What is the role of attention mechanisms in NLP?',
         ARRAY['To allow the model to focus on relevant parts of the input when producing each output', 'To increase the model size', 'To reduce computational cost', 'To improve speed'], 0,
         'Attention improves long‑range dependencies.'),
        ('What is a stop word?',
         ARRAY['A common word that is often removed from text (e.g., "the", "is")', 'A word with high frequency', 'A word with low frequency', 'A word that is not in the dictionary'], 0,
         'Stop word removal is a common preprocessing step to reduce dimensionality.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_nlp, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 6. ROBOTICS (11 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is robotics?',
         ARRAY['The branch of AI and engineering that deals with the design, construction, and operation of robots', 'The study of human movement', 'The study of artificial organs', 'The study of computer hardware'], 0,
         'Robotics combines AI, mechanical engineering, and electronics.'),
        ('What is a robot defined as?',
         ARRAY['A programmable machine capable of carrying out a complex series of actions automatically', 'A machine that is humanoid', 'A machine with artificial intelligence', 'A machine that moves'], 0,
         'Robots can be autonomous or remotely controlled.'),
        ('What is the "sensor" in robotics?',
         ARRAY['A device that detects changes in the environment and sends that information to a robot''s controller', 'An actuator', 'A motor', 'A power source'], 0,
         'Sensors include cameras, LIDAR, proximity sensors, etc.'),
        ('What is an actuator in robotics?',
         ARRAY['A device that converts energy into motion (e.g., motors, servos)', 'A sensor', 'A controller', 'A power supply'], 0,
         'Actuators are the "muscles" of a robot.'),
        ('What is the main challenge in robot navigation?',
         ARRAY['Simultaneous Localization and Mapping (SLAM)', 'Object detection', 'Speech recognition', 'Natural language understanding'], 0,
         'SLAM allows a robot to build a map of an unknown environment while keeping track of its own location.'),
        ('What is an end‑effector?',
         ARRAY['The device at the end of a robotic arm that interacts with the environment (e.g., gripper, tool)', 'The controller', 'The base of the robot', 'The power source'], 0,
         'End‑effectors are task‑specific.'),
        ('What is kinematic control in robotics?',
         ARRAY['Controlling the motion of a robot without considering forces (geometry of motion)', 'Controlling with force feedback', 'Controlling using machine learning', 'Controlling using vision'], 0,
         'Kinematics deals with position, velocity, acceleration.'),
        ('What is the role of inverse kinematics?',
         ARRAY['Determining the joint angles needed to achieve a desired position of the end‑effector', 'Determining the forward position from joint angles', 'Determining the speed of movement', 'Determining the torque at joints'], 0,
         'Inverse kinematics is essential for path planning.'),
        ('What is a mobile robot?',
         ARRAY['A robot that moves around its environment', 'A robot with a fixed base', 'A robot with manipulators', 'A humanoid robot'], 0,
         'Examples: autonomous vehicles, drones, rovers.'),
        ('What is the use of computer vision in robotics?',
         ARRAY['To perceive and understand the environment, enabling navigation and manipulation', 'To generate graphics', 'To process text', 'To perform sentiment analysis'], 0,
         'Vision is key for many robotic tasks.'),
        ('What is a humanoid robot?',
         ARRAY['A robot with a body shape that resembles that of a human', 'A robot with a human brain', 'A robot that is alive', 'A robot that performs surgery'], 0,
         'Examples: ASIMO, Sophia, Atlas.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_robotics, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 7. EXPERT SYSTEMS (11 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is an expert system?',
         ARRAY['A computer system that emulates the decision‑making ability of a human expert', 'A system that learns from data', 'A system that performs general intelligence', 'A system that processes natural language'], 0,
         'Expert systems are rule‑based and use a knowledge base and inference engine.'),
        ('What is the knowledge base in an expert system?',
         ARRAY['A repository of facts and rules about a specific domain', 'A database of previous cases', 'A set of algorithms', 'A collection of neural networks'], 0,
         'Knowledge is encoded in a formal representation, such as IF‑THEN rules.'),
        ('What is the inference engine?',
         ARRAY['The component of an expert system that applies rules to the knowledge base to derive conclusions', 'The user interface', 'The explanation facility', 'The knowledge acquisition module'], 0,
         'The inference engine uses reasoning techniques like forward or backward chaining.'),
        ('What is forward chaining?',
         ARRAY['A data‑driven reasoning method that starts with facts and applies rules to derive new facts', 'A goal‑driven method', 'A method that works backward from conclusions', 'A method that uses neural networks'], 0,
         'Forward chaining is often used in production systems.'),
        ('What is backward chaining?',
         ARRAY['A goal‑driven reasoning method that starts with a hypothesis and checks if facts support it', 'A data‑driven method', 'A method that applies rules to all facts', 'A method used only in machine learning'], 0,
         'Backward chaining is common in diagnostic systems.'),
        ('What is the purpose of an explanation facility in an expert system?',
         ARRAY['To explain the reasoning behind the system''s conclusions to the user', 'To acquire new rules', 'To interface with databases', 'To visualise the knowledge base'], 0,
         'Transparency is important for trust and debugging.'),
        ('Which programming language was originally used for many expert systems?',
         ARRAY['Lisp and Prolog', 'C++', 'Python', 'Java'], 0,
         'Early expert systems were often built in Lisp or Prolog.'),
        ('What is a rule‑based system?',
         ARRAY['A system that uses a set of IF‑THEN rules to make decisions', 'A system that uses neural networks', 'A system that uses statistical models', 'A system that uses decision trees'], 0,
         'Rule‑based systems are the most common type of expert system.'),
        ('What is a knowledge engineer?',
         ARRAY['A person who designs and builds expert systems by extracting knowledge from human experts', 'A person who designs databases', 'A person who writes algorithms', 'A person who builds robots'], 0,
         'Knowledge engineering involves acquisition, representation, and validation.'),
        ('What is a frame‑based expert system?',
         ARRAY['A system that uses frames (structured objects with slots) to represent knowledge', 'A system that uses only rules', 'A system that uses neural networks', 'A system that uses fuzzy logic'], 0,
         'Frames are a way to organise knowledge into hierarchies.'),
        ('What is a common use case for expert systems?',
         ARRAY['Medical diagnosis (e.g., MYCIN)', 'Image recognition', 'Natural language translation', 'Self‑driving cars'], 0,
         'MYCIN (1970s) diagnosed bacterial infections and recommended antibiotics.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_expert, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 8. REINFORCEMENT LEARNING (11 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is reinforcement learning?',
         ARRAY['A type of machine learning where an agent learns by interacting with an environment and receiving rewards or penalties', 'A type of supervised learning', 'A type of unsupervised learning', 'A type of deep learning without rewards'], 0,
         'RL is about learning from trial and error.'),
        ('What is the agent in reinforcement learning?',
         ARRAY['The learner or decision‑maker that takes actions in the environment', 'The environment itself', 'The reward signal', 'The policy'], 0,
         'The agent observes the state, takes actions, and receives rewards.'),
        ('What is the environment in RL?',
         ARRAY['The external system with which the agent interacts', 'The agent itself', 'The reward function', 'The policy'], 0,
         'The environment defines the dynamics of the problem.'),
        ('What is a policy in RL?',
         ARRAY['A mapping from states to actions (the agent''s strategy)', 'The reward function', 'The value function', 'The model of the environment'], 0,
         'The policy can be deterministic or stochastic.'),
        ('What is the reward signal in RL?',
         ARRAY['A scalar feedback that indicates the immediate benefit of an action', 'The final outcome', 'The value of a state', 'The discount factor'], 0,
         'Rewards guide the agent toward the goal.'),
        ('What is the difference between model‑based and model‑free RL?',
         ARRAY['Model‑based uses a model of the environment to plan; model‑free learns directly from interactions', 'Model‑free uses a model', 'Both are the same', 'Model‑based does not use a model'], 0,
         'Model‑free methods, like Q‑learning, are simpler but may be less sample‑efficient.'),
        ('What is Q‑learning?',
         ARRAY['A model‑free RL algorithm that learns the value of taking an action in a given state', 'A model‑based algorithm', 'A policy gradient method', 'A supervised learning algorithm'], 0,
         'Q‑learning is an off‑policy algorithm using the Bellman equation.'),
        ('What is the exploration‑exploitation dilemma?',
         ARRAY['The tradeoff between trying new actions to discover rewards and using known actions that yield high rewards', 'The tradeoff between model complexity and training time', 'The tradeoff between data and computation', 'The tradeoff between precision and recall'], 0,
         'Exploration is essential to find optimal strategies.'),
        ('What is a Markov Decision Process (MDP)?',
         ARRAY['A mathematical framework for modelling decision‑making in situations with uncertainty', 'A type of neural network', 'A supervised learning model', 'A clustering algorithm'], 0,
         'MDPs consist of states, actions, transition probabilities, rewards, and a discount factor.'),
        ('What is a policy gradient method?',
         ARRAY['A class of RL algorithms that directly optimise the policy by gradient ascent on expected reward', 'A method that learns a value function', 'A method that uses models', 'A method that uses dynamic programming'], 0,
         'Policy gradients are well‑suited for continuous action spaces.'),
        ('What is the role of the discount factor (γ) in RL?',
         ARRAY['To weigh the importance of immediate rewards versus future rewards', 'To discount the learning rate', 'To reduce the number of states', 'To scale the rewards'], 0,
         'A γ close to 0 favours short‑term rewards; near 1 values long‑term rewards.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_rl, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 9. AI ETHICS (11 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is AI ethics concerned with?',
         ARRAY['The moral principles and values that should guide the development and use of AI', 'The technical performance of AI systems', 'The computational cost of AI', 'The hardware required for AI'], 0,
         'AI ethics addresses fairness, accountability, transparency, privacy, and safety.'),
        ('What is algorithmic bias?',
         ARRAY['Systematic and unfair discrimination in AI decisions due to biased data or model design', 'An algorithm that is too slow', 'An algorithm that is too complex', 'An algorithm that is too simple'], 0,
         'Bias can lead to harmful outcomes in hiring, lending, criminal justice, etc.'),
        ('What is the "black box" problem in AI?',
         ARRAY['The difficulty of interpreting how a complex AI model makes decisions', 'The physical enclosure of AI hardware', 'A type of encryption', 'A type of neural network'], 0,
         'Explainability is a key challenge, especially for deep learning.'),
        ('What is fairness in AI?',
         ARRAY['The principle that AI systems should treat all individuals and groups equitably', 'The principle that AI should be fast', 'The principle that AI should be accurate', 'The principle that AI should be cheap'], 0,
         'Fairness metrics include demographic parity, equal opportunity, etc.'),
        ('What is transparency in AI?',
         ARRAY['The degree to which the workings of an AI system are open and understandable', 'The degree to which an AI system is fast', 'The degree to which an AI system is accurate', 'The degree to which an AI system is cheap'], 0,
         'Transparency builds trust and enables accountability.'),
        ('What is data privacy in the context of AI?',
         ARRAY['Protecting individuals'' personal data from misuse or unauthorised access in AI systems', 'Making data public', 'Encrypting all data', 'Deleting data after use'], 0,
         'Regulations like GDPR mandate privacy protection.'),
        ('What is accountable AI?',
         ARRAY['The principle that AI systems should be designed with clear lines of responsibility for their outcomes', 'The principle that AI should be accurate', 'The principle that AI should be fast', 'The principle that AI should be cheap'], 0,
         'Accountability means that someone can be held responsible for AI actions.'),
        ('What is the potential impact of AI on employment?',
         ARRAY['Automation may displace some jobs while creating others', 'AI will eliminate all jobs', 'AI will have no effect', 'AI will increase jobs without displacing any'], 0,
         'The net effect is debated; reskilling is important.'),
        ('What is the "precautionary principle" in AI governance?',
         ARRAY['The idea that AI development should proceed with caution, avoiding potential catastrophic risks', 'The idea that AI should be developed as fast as possible', 'The idea that AI should be used without regulation', 'The idea that AI is always safe'], 0,
         'This principle is invoked for existential risks like AGI.'),
        ('What is the purpose of AI safety research?',
         ARRAY['To ensure that AI systems are reliable, secure, and do not cause unintended harm', 'To make AI faster', 'To make AI cheaper', 'To make AI more complex'], 0,
         'Safety includes robustness, alignment, and error handling.'),
        ('What is the "alignment problem" in AI?',
         ARRAY['The challenge of ensuring that AI systems behave in ways that are consistent with human values and intentions', 'The challenge of aligning neural network weights', 'The challenge of aligning hardware components', 'The challenge of aligning databases'], 0,
         'This is a central concern for advanced AI systems.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_ethics, q_rec.column1, 'single_choice', q_rec.column4)
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