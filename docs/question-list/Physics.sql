-- ============================================================================
-- Insert 270 factual questions on Physics.
-- Subtopics: Mechanics, Thermodynamics, Optics, Electricity, Magnetism,
-- Quantum Physics, Nuclear Physics, Relativity, Particle Physics.
-- ============================================================================

DO $$
DECLARE
    cat_id_mechanics       BIGINT;
    cat_id_thermo          BIGINT;
    cat_id_optics          BIGINT;
    cat_id_electricity     BIGINT;
    cat_id_magnetism       BIGINT;
    cat_id_quantum         BIGINT;
    cat_id_nuclear         BIGINT;
    cat_id_relativity      BIGINT;
    cat_id_particle        BIGINT;
    q_id                   BIGINT;
    correct_opt_id         BIGINT;
    opt_texts              TEXT[];
    q_rec                  RECORD;
BEGIN
    -- ------------------------------------------------------------------------
    -- Create categories (hierarchical under physics)
    -- ------------------------------------------------------------------------
    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('physics', 'Physics', 1, 0)
        ON CONFLICT (path) DO NOTHING;

    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('physics.mechanics',          'Mechanics', 1, 1),
        ('physics.thermodynamics',     'Thermodynamics', 1, 2),
        ('physics.optics',             'Optics', 1, 3),
        ('physics.electricity',        'Electricity', 1, 4),
        ('physics.magnetism',          'Magnetism', 1, 5),
        ('physics.quantum_physics',    'Quantum Physics', 1, 6),
        ('physics.nuclear_physics',    'Nuclear Physics', 1, 7),
        ('physics.relativity',         'Relativity', 1, 8),
        ('physics.particle_physics',   'Particle Physics', 1, 9)
        ON CONFLICT (path) DO NOTHING;

    -- Get category IDs
    SELECT id INTO cat_id_mechanics  FROM categories WHERE path = 'physics.mechanics';
    SELECT id INTO cat_id_thermo     FROM categories WHERE path = 'physics.thermodynamics';
    SELECT id INTO cat_id_optics     FROM categories WHERE path = 'physics.optics';
    SELECT id INTO cat_id_electricity FROM categories WHERE path = 'physics.electricity';
    SELECT id INTO cat_id_magnetism  FROM categories WHERE path = 'physics.magnetism';
    SELECT id INTO cat_id_quantum    FROM categories WHERE path = 'physics.quantum_physics';
    SELECT id INTO cat_id_nuclear    FROM categories WHERE path = 'physics.nuclear_physics';
    SELECT id INTO cat_id_relativity FROM categories WHERE path = 'physics.relativity';
    SELECT id INTO cat_id_particle   FROM categories WHERE path = 'physics.particle_physics';

    -- ========================================================================
    -- 1. MECHANICS (30 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is Newton''s First Law also called?',
         ARRAY['Law of Inertia', 'Law of Force', 'Law of Motion', 'Law of Action'], 0,
         'Newton''s First Law states that an object at rest stays at rest and an object in motion stays in motion unless acted upon by an unbalanced force.'),
        ('What is the unit of force in the SI system?',
         ARRAY['Newton (N)', 'Joule (J)', 'Watt (W)', 'Pascal (Pa)'], 0,
         '1 Newton = 1 kg⋅m/s^2.'),
        ('What is the acceleration due to gravity on Earth (approximate)?',
         ARRAY['9.8 m/s^2', '8.9 m/s^2', '10.5 m/s^2', '9.0 m/s^2'], 0,
         'Standard gravity is 9.80665 m/s^2.'),
        ('What is the formula for kinetic energy?',
         ARRAY['1/2mv^2', 'mv^2', 'mgh', '1/2kx^2'], 0,
         'Kinetic energy = 1/2 × mass × velocity^2.'),
        ('What is the formula for gravitational potential energy near Earth''s surface?',
         ARRAY['mgh', '1/2mv^2', 'GMm/r', 'mg'], 0,
         'PE = mass × gravity × height.'),
        ('What is momentum?',
         ARRAY['Mass × Velocity', 'Mass × Acceleration', 'Force × Time', 'Kinetic Energy'], 0,
         'Momentum is a vector quantity p = mv.'),
        ('What is the law of conservation of momentum?',
         ARRAY['Total momentum of a closed system remains constant', 'Momentum is always zero', 'Momentum is always increasing', 'Momentum is always decreasing'], 0,
         'Conservation of momentum applies to isolated systems.'),
        ('What is Newton''s Second Law?',
         ARRAY['F = ma', 'F = mv', 'F = mg', 'F = kx'], 0,
         'Force equals mass times acceleration.'),
        ('What is the work done by a force?',
         ARRAY['Force × Displacement × cosθ', 'Force × Time', 'Mass × Acceleration', 'Force × Velocity'], 0,
         'Work is a scalar quantity, W = Fd cosθ.'),
        ('What is power in physics?',
         ARRAY['Rate of doing work (P = W/t)', 'Force × Velocity', 'Energy × Time', 'Work × Distance'], 0,
         'Power is measured in watts (W).'),
        ('What is a lever?',
         ARRAY['A simple machine consisting of a rigid bar pivoted at a fulcrum', 'A pulley system', 'An inclined plane', 'A wheel and axle'], 0,
         'Levers amplify force or distance.'),
        ('What is the centre of mass?',
         ARRAY['The point where the mass of a system is concentrated', 'The geometrical centre', 'The point of zero gravity', 'The point of maximum density'], 0,
         'For a uniform sphere, the centre of mass is at the centre.'),
        ('What is torque?',
         ARRAY['Force × Distance from pivot (τ = rF sinθ)', 'Force × Time', 'Mass × Acceleration', 'Power × Time'], 0,
         'Torque is the rotational equivalent of force.'),
        ('What is the moment of inertia?',
         ARRAY['A measure of an object''s resistance to rotational acceleration', 'A measure of mass', 'A measure of weight', 'A measure of speed'], 0,
         'Moment of inertia depends on mass distribution (I = Σmr^2).'),
        ('What is angular momentum?',
         ARRAY['Moment of inertia × Angular velocity (L = Iω)', 'Mass × Velocity', 'Force × Time', 'Kinetic Energy'], 0,
         'Angular momentum is conserved in the absence of external torque.'),
        ('What is the difference between speed and velocity?',
         ARRAY['Velocity includes direction; speed is scalar', 'Speed includes direction', 'They are the same', 'Speed is always greater'], 0,
         'Speed is magnitude; velocity is magnitude and direction.'),
        ('What is uniform circular motion?',
         ARRAY['Motion in a circle at constant speed', 'Motion in a circle at constant acceleration', 'Motion in a straight line', 'Motion at constant velocity'], 0,
         'Even with constant speed, there is centripetal acceleration.'),
        ('What is centripetal force?',
         ARRAY['The force directed toward the centre of a circular path', 'The force directed outward', 'The force tangential to the path', 'The force perpendicular to the plane'], 0,
         'Centripetal force causes the change in direction.'),
        ('What is the universal gravitational constant (G)?',
         ARRAY['6.67 × 10⁻¹¹ N·m^2/kg^2', '9.8 m/s^2', '3 × 10⁸ m/s', '6.02 × 10^2^3 mol⁻¹'], 0,
         'G is a fundamental constant in Newton''s law of gravitation.'),
        ('What is Newton''s Third Law?',
         ARRAY['For every action, there is an equal and opposite reaction', 'Force equals mass times acceleration', 'Inertia remains constant', 'Energy is conserved'], 0,
         'The action-reaction law.'),
        ('What is friction?',
         ARRAY['A force that opposes relative motion between two surfaces', 'A force that causes motion', 'A force that increases speed', 'A force that acts at a distance'], 0,
         'Friction can be static or kinetic.'),
        ('What is the coefficient of friction?',
         ARRAY['The ratio of friction force to normal force', 'The ratio of mass to acceleration', 'The ratio of force to time', 'The ratio of work to distance'], 0,
         'μ = F_friction / F_normal.'),
        ('What is Hooke''s Law?',
         ARRAY['F = -kx (force proportional to displacement for springs)', 'F = ma', 'F = mg', 'F = Gm₁m₂/r^2'], 0,
         'Hooke''s Law describes elastic materials.'),
        ('What is the period of a simple pendulum?',
         ARRAY['T = 2π√(L/g)', 'T = 2π√(g/L)', 'T = √(L/g)', 'T = 1/f'], 0,
         'For small oscillations, period depends on length and gravity.'),
        ('What is resonance?',
         ARRAY['When a system is driven at its natural frequency, leading to large amplitude oscillations', 'When a system is driven at any frequency', 'When a system stops oscillating', 'When a system oscillates with zero frequency'], 0,
         'Resonance can be beneficial or destructive.'),
        ('What is the work-energy theorem?',
         ARRAY['Work done on an object equals the change in its kinetic energy', 'Work equals potential energy', 'Work equals power × time', 'Work equals force × distance'], 0,
         'W = ΔKE.'),
        ('What is an elastic collision?',
         ARRAY['A collision where kinetic energy is conserved', 'A collision where kinetic energy is not conserved', 'A collision where momentum is not conserved', 'A collision where objects stick together'], 0,
         'In elastic collisions, both momentum and kinetic energy are conserved.'),
        ('What is an inelastic collision?',
         ARRAY['A collision where kinetic energy is not conserved', 'A collision where kinetic energy is conserved', 'A collision where momentum is not conserved', 'A collision where objects bounce apart'], 0,
         'In inelastic collisions, some kinetic energy is converted to heat, sound, etc.'),
        ('What is a projectile?',
         ARRAY['An object thrown into the air with motion under gravity', 'An object in circular motion', 'An object at rest', 'An object with constant velocity'], 0,
         'Projectile motion is parabolic in a uniform gravitational field.'),
        ('What is the range of a projectile?',
         ARRAY['R = v₀^2 sin(2θ)/g', 'R = v₀^2/g', 'R = 2v₀^2/g', 'R = v₀^2/g sinθ'], 0,
         'Range depends on initial speed and launch angle.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_mechanics, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 2. THERMODYNAMICS (30 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the Zeroth Law of Thermodynamics?',
         ARRAY['If two systems are in thermal equilibrium with a third, they are in equilibrium with each other', 'Energy cannot be created or destroyed', 'Entropy always increases', 'Heat flows from hot to cold'], 0,
         'The Zeroth Law defines temperature.'),
        ('What is the First Law of Thermodynamics?',
         ARRAY['ΔU = Q - W (change in internal energy = heat added − work done)', 'ΔU = Q + W', 'Q = ΔU + W', 'W = ΔU + Q'], 0,
         'This is the law of conservation of energy, including heat.'),
        ('What is the Second Law of Thermodynamics?',
         ARRAY['Entropy of an isolated system never decreases', 'Energy is conserved', 'Heat flows from cold to hot', 'All processes are reversible'], 0,
         'The Second Law defines the direction of natural processes.'),
        ('What is entropy?',
         ARRAY['A measure of disorder or randomness in a system', 'A measure of energy', 'A measure of temperature', 'A measure of pressure'], 0,
         'Entropy (S) is a state function.'),
        ('What is an isothermal process?',
         ARRAY['A process at constant temperature', 'A process at constant pressure', 'A process at constant volume', 'A process with no heat exchange'], 0,
         'For an ideal gas, isothermal means PV = constant.'),
        ('What is an adiabatic process?',
         ARRAY['A process with no heat exchange (Q = 0)', 'A process at constant temperature', 'A process at constant pressure', 'A process with no work'], 0,
         'Adiabatic processes involve changes in internal energy and work.'),
        ('What is an isobaric process?',
         ARRAY['A process at constant pressure', 'A process at constant temperature', 'A process at constant volume', 'A process with no heat exchange'], 0,
         'W = PΔV for isobaric processes.'),
        ('What is an isochoric process?',
         ARRAY['A process at constant volume', 'A process at constant pressure', 'A process at constant temperature', 'A process with no heat exchange'], 0,
         'At constant volume, no work is done (W = 0).'),
        ('What is the ideal gas law?',
         ARRAY['PV = nRT', 'PV = RT', 'PV = NkT', 'Both PV = nRT and PV = NkT'], 3,
         'nRT and NkT are equivalent (N = nN_A, R = N_A k).'),
        ('What is the value of the universal gas constant (R)?',
         ARRAY['8.314 J/(mol·K)', '0.0821 L·atm/(mol·K)', 'Both', 'Neither'], 2,
         'R = 8.314 J/mol·K = 0.0821 L·atm/mol·K.'),
        ('What is absolute zero?',
         ARRAY['0 Kelvin (−273.15°C)', '0°C', '−273.15°F', '0 K, the lowest possible temperature'], 0,
         'At 0 K, particles have minimum thermal motion.'),
        ('What is a heat engine?',
         ARRAY['A device that converts thermal energy into mechanical work', 'A device that converts work into heat', 'A device that stores heat', 'A device that transfers heat without work'], 0,
         'Heat engines operate between a hot and cold reservoir.'),
        ('What is efficiency in thermodynamics?',
         ARRAY['Work output divided by heat input (η = W/Q_h)', 'Heat output divided by work input', 'Heat input divided by work output', 'Temperature ratio'], 0,
         'Efficiency is always less than 1.'),
        ('What is the Carnot efficiency?',
         ARRAY['η = 1 - T_c/T_h', 'η = T_c/T_h', 'η = 1 - T_h/T_c', 'η = T_h/T_c'], 0,
         'Carnot efficiency is the maximum possible efficiency.'),
        ('What is the Third Law of Thermodynamics?',
         ARRAY['Entropy approaches zero as temperature approaches absolute zero', 'Energy is conserved', 'Entropy always increases', 'Heat flows from hot to cold'], 0,
         'The Third Law relates to perfect crystals at 0 K.'),
        ('What is a refrigerator?',
         ARRAY['A device that transfers heat from a cold reservoir to a hot reservoir using work input', 'A device that converts heat to work', 'A device that stores heat', 'A device that removes entropy'], 0,
         'Refrigerators are heat pumps operating in reverse.'),
        ('What is the coefficient of performance (COP) for a refrigerator?',
         ARRAY['COP = Q_c/W', 'COP = W/Q_c', 'COP = Q_h/W', 'COP = W/Q_h'], 0,
         'COP measures the efficiency of a refrigerator.'),
        ('What is thermal expansion?',
         ARRAY['The tendency of matter to change volume in response to temperature change', 'The tendency to change pressure', 'The tendency to change phase', 'The tendency to conduct heat'], 0,
         'Most materials expand upon heating.'),
        ('What is specific heat capacity?',
         ARRAY['The amount of heat required to raise the temperature of 1 kg of a substance by 1°C', 'The amount of heat to melt 1 kg', 'The amount of heat to vaporise 1 kg', 'The amount of heat to change phase'], 0,
         'c = Q/(mΔT).'),
        ('What is latent heat?',
         ARRAY['Heat required to change the state of a substance without changing temperature', 'Heat required to raise temperature', 'Heat required to melt only', 'Heat required to vaporise only'], 0,
         'Latent heat of fusion and vaporisation are common.'),
        ('What is conduction?',
         ARRAY['Heat transfer through direct contact of particles', 'Heat transfer through fluid movement', 'Heat transfer by electromagnetic waves', 'Heat transfer without a medium'], 0,
         'Conduction occurs in solids, liquids, and gases.'),
        ('What is convection?',
         ARRAY['Heat transfer by bulk movement of fluids', 'Heat transfer through contact', 'Heat transfer by radiation', 'Heat transfer without matter'], 0,
         'Convection drives weather patterns and ocean currents.'),
        ('What is radiation in thermodynamics?',
         ARRAY['Heat transfer by electromagnetic waves (thermal radiation)', 'Heat transfer by contact', 'Heat transfer by convection', 'Heat transfer by conduction'], 0,
         'All objects emit thermal radiation.'),
        ('What is the Stefan-Boltzmann law?',
         ARRAY['P = εσAT⁴', 'P = εσAT^2', 'P = εσAT', 'P = σAT⁴'], 0,
         'The Stefan-Boltzmann constant σ = 5.67 × 10⁻⁸ W/m^2K⁴.'),
        ('What is a phase transition?',
         ARRAY['A change from one state of matter to another', 'A change in temperature', 'A change in pressure', 'A change in volume'], 0,
         'Examples: melting, boiling, sublimation.'),
        ('What is the triple point?',
         ARRAY['A unique temperature and pressure where solid, liquid, and gas coexist', 'The point where three phases meet', 'The critical point', 'The boiling point'], 0,
         'The triple point of water is 273.16 K, 611.73 Pa.'),
        ('What is enthalpy?',
         ARRAY['H = U + PV (a measure of total heat content)', 'H = U - PV', 'H = Q + W', 'H = internal energy'], 0,
         'Enthalpy is useful for constant-pressure processes.'),
        ('What is the Joule-Thomson effect?',
         ARRAY['Temperature change of a gas when it expands without doing external work', 'Temperature change at constant volume', 'Temperature change in a vacuum', 'Temperature change due to friction'], 0,
         'This effect is used in refrigeration.'),
        ('What is the mean free path?',
         ARRAY['The average distance a particle travels between collisions', 'The average speed of a particle', 'The average time between collisions', 'The average energy of a particle'], 0,
         'Mean free path depends on pressure and temperature.'),
        ('What is thermal equilibrium?',
         ARRAY['A condition where two objects have the same temperature and no net heat flow', 'A condition where heat flows constantly', 'A condition with no energy', 'A condition with maximum entropy'], 0,
         'Thermal equilibrium is the state of equal temperature.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_thermo, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 3. OPTICS (30 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the speed of light in vacuum?',
         ARRAY['3 × 10⁸ m/s', '3 × 10⁶ m/s', '3 × 10¹⁰ m/s', '3 × 10⁴ m/s'], 0,
         'The speed of light is exactly 299,792,458 m/s.'),
        ('What is reflection of light?',
         ARRAY['The bouncing of light off a surface', 'The bending of light', 'The spreading of light', 'The absorption of light'], 0,
         'The law of reflection: angle of incidence equals angle of reflection.'),
        ('What is refraction of light?',
         ARRAY['The bending of light when it passes from one medium to another', 'The bouncing of light', 'The scattering of light', 'The absorption of light'], 0,
         'Refraction occurs due to change in speed of light.'),
        ('What is Snell''s Law?',
         ARRAY['n₁ sinθ₁ = n₂ sinθ₂', 'n₁ cosθ₁ = n₂ cosθ₂', 'sinθ₁/sinθ₂ = n₂/n₁', 'n₁ sinθ₂ = n₂ sinθ₁'], 0,
         'Snell''s law relates angles and indices of refraction.'),
        ('What is the critical angle?',
         ARRAY['The angle of incidence that produces a 90° angle of refraction', 'The angle of total reflection', 'The angle of maximum refraction', 'The angle of minimum deviation'], 0,
         'Beyond the critical angle, total internal reflection occurs.'),
        ('What is total internal reflection?',
         ARRAY['Complete reflection of light back into the medium when the angle of incidence exceeds the critical angle', 'Partial reflection', 'Reflection without refraction', 'Reflection at 90°'], 0,
         'Used in fibre optics.'),
        ('What is a lens?',
         ARRAY['A transparent object that refracts light to form images', 'A mirror', 'A prism', 'A diaphragm'], 0,
         'Lenses can be converging or diverging.'),
        ('What is the difference between a convex and concave lens?',
         ARRAY['Convex is thicker at the centre (converging); concave is thinner at the centre (diverging)', 'Concave is thicker at the centre', 'Both are converging', 'Both are diverging'], 0,
         'Convex lenses bring light to a focus; concave lenses diverge light.'),
        ('What is the focal length of a lens?',
         ARRAY['The distance from the lens to the focal point', 'The distance from the lens to the object', 'The distance from the lens to the image', 'The radius of curvature'], 0,
         'Focal length determines the lens''s power.'),
        ('What is the lens equation?',
         ARRAY['1/f = 1/do + 1/di', '1/f = 1/do - 1/di', 'f = do + di', 'f = do × di'], 0,
         'The thin lens equation relates object distance, image distance, and focal length.'),
        ('What is magnification?',
         ARRAY['m = hi/ho = -di/do', 'm = di/do', 'm = ho/hi', 'm = do/di'], 0,
         'Magnification is the ratio of image height to object height.'),
        ('What is the human eye''s lens?',
         ARRAY['A convex lens that focuses light onto the retina', 'A concave lens', 'A flat lens', 'A prism'], 0,
         'The eye adjusts focal length by changing lens shape (accommodation).'),
        ('What is colour?',
         ARRAY['The perception of different wavelengths of light', 'The intensity of light', 'The speed of light', 'The temperature of light'], 0,
         'Visible light ranges from about 380 nm (violet) to 750 nm (red).'),
        ('What is the visible spectrum?',
         ARRAY['The range of wavelengths of light visible to the human eye', 'All electromagnetic waves', 'Only infrared', 'Only ultraviolet'], 0,
         'From 380 to 750 nm.'),
        ('What is a prism used for?',
         ARRAY['To disperse white light into a spectrum of colours', 'To reflect light', 'To focus light', 'To polarise light'], 0,
         'Prisms work by refraction and dispersion.'),
        ('What is diffraction?',
         ARRAY['The bending of light around obstacles or through narrow slits', 'The reflection of light', 'The refraction of light', 'The polarisation of light'], 0,
         'Diffraction is evidence of the wave nature of light.'),
        ('What is interference of light?',
         ARRAY['The superposition of two or more waves resulting in constructive or destructive interference', 'The scattering of light', 'The reflection of light', 'The absorption of light'], 0,
         'Interference produces bright and dark bands (e.g., Young''s double-slit).'),
        ('What is Young''s double-slit experiment?',
         ARRAY['An experiment demonstrating the wave nature of light through interference patterns', 'An experiment on reflection', 'An experiment on refraction', 'An experiment on polarisation'], 0,
         'The experiment provided strong evidence for the wave theory of light.'),
        ('What is polarisation of light?',
         ARRAY['The orientation of light waves in a particular direction', 'The scattering of light', 'The bending of light', 'The reflection of light'], 0,
         'Polarisation shows that light is a transverse wave.'),
        ('What is a laser?',
         ARRAY['Light Amplification by Stimulated Emission of Radiation', 'A type of light bulb', 'A type of lens', 'A type of mirror'], 0,
         'Lasers produce coherent, monochromatic, and directional light.'),
        ('What is the main difference between a laser and ordinary light?',
         ARRAY['Laser light is coherent, monochromatic, and directional', 'Laser light is brighter', 'Laser light is hotter', 'Laser light is slower'], 0,
         'Coherence is a key property of laser light.'),
        ('What is the photoelectric effect?',
         ARRAY['The emission of electrons from a metal when light shines on it', 'The absorption of light by a metal', 'The reflection of light by a metal', 'The refraction of light by a metal'], 0,
         'The photoelectric effect supports the particle nature of light (photons).'),
        ('What is Planck''s constant (h)?',
         ARRAY['6.63 × 10⁻^3⁴ J·s', '6.63 × 10⁻^3⁴ eV·s', '6.63 × 10⁻^3⁴ J', '6.63 × 10⁻^3⁴ eV'], 0,
         'Planck''s constant relates energy and frequency: E = hf.'),
        ('What is the work function?',
         ARRAY['The minimum energy needed to remove an electron from a metal surface', 'The energy of a photon', 'The energy to melt a metal', 'The energy to vaporise a metal'], 0,
         'Work function depends on the metal.'),
        ('What is a photon?',
         ARRAY['A particle of light (quantum of electromagnetic radiation)', 'A wave of light', 'A type of atom', 'A type of electron'], 0,
         'Photons have zero rest mass and travel at c.'),
        ('What is the Doppler effect for light?',
         ARRAY['Change in frequency or wavelength of light due to relative motion', 'Change in speed of light', 'Change in intensity of light', 'Change in colour of light'], 0,
         'Redshift and blueshift are examples.'),
        ('What is optical fibre?',
         ARRAY['A thin glass fibre that transmits light by total internal reflection', 'A fibre that conducts electricity', 'A fibre that carries sound', 'A fibre that emits light'], 0,
         'Fibre optics are used in telecommunications.'),
        ('What is the resolution of an optical instrument?',
         ARRAY['The ability to distinguish two closely spaced objects', 'The ability to magnify an object', 'The ability to brighten an image', 'The ability to focus light'], 0,
         'Resolution is limited by diffraction.'),
        ('What is the Rayleigh criterion?',
         ARRAY['θ = 1.22 λ/D (minimum angular resolution)', 'θ = λ/D', 'θ = D/λ', 'θ = 1.22 D/λ'], 0,
         'The Rayleigh criterion gives the limit of resolution.'),
        ('What is a diffraction grating?',
         ARRAY['A device with many closely spaced slits used to disperse light into spectra', 'A single slit', 'A double slit', 'A prism'], 0,
         'Gratings are used to measure wavelengths with high precision.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_optics, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 4. ELECTRICITY (30 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the unit of electric charge?',
         ARRAY['Coulomb (C)', 'Ampere (A)', 'Volt (V)', 'Ohm (Ω)'], 0,
         'The coulomb is the SI unit of charge.'),
        ('What is the elementary charge (charge of a proton)?',
         ARRAY['1.60 × 10⁻¹⁹ C', '1.60 × 10⁻¹⁹ V', '1.60 × 10⁻¹⁹ A', '1.60 × 10⁻¹⁹ Ω'], 0,
         'e = 1.602176634 × 10⁻¹⁹ C.'),
        ('What is Coulomb''s Law?',
         ARRAY['F = k|q₁q₂|/r^2', 'F = kq₁q₂/r', 'F = Gm₁m₂/r^2', 'F = kq/r^2'], 0,
         'k = 8.99 × 10⁹ N·m^2/C^2.'),
        ('What is the unit of electric current?',
         ARRAY['Ampere (A)', 'Coulomb (C)', 'Volt (V)', 'Ohm (Ω)'], 0,
         '1 Ampere = 1 Coulomb/second.'),
        ('What is Ohm''s Law?',
         ARRAY['V = IR', 'V = I/R', 'I = VR', 'R = VI'], 0,
         'Ohm''s Law relates voltage, current, and resistance.'),
        ('What is the unit of resistance?',
         ARRAY['Ohm (Ω)', 'Volt (V)', 'Ampere (A)', 'Watt (W)'], 0,
         '1 ohm = 1 volt/ampere.'),
        ('What is electrical power?',
         ARRAY['P = VI', 'P = I^2R', 'P = V^2/R', 'All of the above'], 3,
         'All three forms are equivalent using Ohm''s Law.'),
        ('What is a resistor?',
         ARRAY['A component that limits or regulates current', 'A component that stores charge', 'A component that generates voltage', 'A component that converts AC to DC'], 0,
         'Resistors dissipate energy as heat.'),
        ('What is the difference between series and parallel circuits?',
         ARRAY['In series, current is the same; in parallel, voltage is the same', 'In series, voltage is the same; in parallel, current is the same', 'No difference', 'Series has more current'], 0,
         'Series circuits have one path for current; parallel circuits have multiple paths.'),
        ('What is the equivalent resistance of resistors in series?',
         ARRAY['R_eq = R₁ + R₂ + ...', '1/R_eq = 1/R₁ + 1/R₂ + ...', 'R_eq = R₁R₂/(R₁+R₂)', 'R_eq = R₁ + R₂/R₁R₂'], 0,
         'Series resistances add directly.'),
        ('What is the equivalent resistance of resistors in parallel?',
         ARRAY['1/R_eq = 1/R₁ + 1/R₂ + ...', 'R_eq = R₁ + R₂ + ...', 'R_eq = R₁R₂/(R₁+R₂)', 'R_eq = 1/R₁ + 1/R₂'], 0,
         'Parallel resistances add reciprocally.'),
        ('What is a capacitor?',
         ARRAY['A component that stores electrical charge and energy', 'A component that resists current', 'A component that generates voltage', 'A component that converts AC to DC'], 0,
         'Capacitance C = Q/V, unit farad (F).'),
        ('What is the unit of capacitance?',
         ARRAY['Farad (F)', 'Ohm (Ω)', 'Volt (V)', 'Ampere (A)'], 0,
         '1 farad = 1 coulomb/volt.'),
        ('What is an inductor?',
         ARRAY['A component that stores energy in a magnetic field', 'A component that stores energy in an electric field', 'A component that resists current', 'A component that generates voltage'], 0,
         'Inductance L = V/(dI/dt), unit henry (H).'),
        ('What is the unit of inductance?',
         ARRAY['Henry (H)', 'Farad (F)', 'Ohm (Ω)', 'Volt (V)'], 0,
         '1 henry = 1 volt·second/ampere.'),
        ('What is Kirchhoff''s Current Law?',
         ARRAY['The sum of currents entering a junction equals the sum leaving', 'The sum of voltages around a loop is zero', 'V = IR', 'P = VI'], 0,
         'This law is based on conservation of charge.'),
        ('What is Kirchhoff''s Voltage Law?',
         ARRAY['The sum of voltages around a closed loop is zero', 'The sum of currents at a junction is zero', 'V = IR', 'P = VI'], 0,
         'This law is based on conservation of energy.'),
        ('What is alternating current (AC)?',
         ARRAY['Current that reverses direction periodically', 'Current that flows in one direction', 'Current that increases steadily', 'Current that is constant'], 0,
         'AC is used in power distribution.'),
        ('What is direct current (DC)?',
         ARRAY['Current that flows in one direction', 'Current that reverses direction', 'Current that is zero', 'Current that changes direction'], 0,
         'DC is produced by batteries and solar cells.'),
        ('What is the frequency of standard AC in many countries?',
         ARRAY['50 Hz or 60 Hz', '100 Hz', '120 Hz', '400 Hz'], 0,
         'Europe: 50 Hz; North America: 60 Hz.'),
        ('What is a transformer?',
         ARRAY['A device that changes voltage using mutual induction', 'A device that changes current', 'A device that changes resistance', 'A device that changes frequency'], 0,
         'Transformers work on AC only.'),
        ('What is the turns ratio in a transformer?',
         ARRAY['V_s/V_p = N_s/N_p', 'V_p/V_s = N_s/N_p', 'V_s/V_p = N_p/N_s', 'V_s/V_p = (N_s/N_p)^2'], 0,
         'Voltage ratio equals turns ratio for ideal transformers.'),
        ('What is resistance?',
         ARRAY['The opposition to current flow', 'The flow of charge', 'The energy per charge', 'The power per current'], 0,
         'Resistance depends on material, geometry, and temperature.'),
        ('What is the resistivity formula?',
         ARRAY['R = ρL/A', 'R = Aρ/L', 'R = L/(ρA)', 'R = ρA/L'], 0,
         'Resistivity ρ is a material property.'),
        ('What is a semiconductor?',
         ARRAY['A material with conductivity between a conductor and an insulator', 'A material that conducts perfectly', 'A material that insulates', 'A material that is magnetic'], 0,
         'Silicon and germanium are common semiconductors.'),
        ('What is a diode?',
         ARRAY['A device that allows current to flow in one direction only', 'A device that amplifies signals', 'A device that stores charge', 'A device that changes resistance'], 0,
         'Diodes are made from p-n junctions.'),
        ('What is a transistor?',
         ARRAY['A semiconductor device used for amplification and switching', 'A device that stores energy', 'A device that generates electricity', 'A device that converts AC to DC'], 0,
         'Transistors are the building blocks of modern electronics.'),
        ('What is electric field?',
         ARRAY['A region where a charge experiences a force', 'A region of magnetic force', 'A region of gravitational force', 'A region of zero force'], 0,
         'Electric field E = F/q, unit V/m.'),
        ('What is electric potential?',
         ARRAY['The work done per unit charge to move a charge', 'The force per unit charge', 'The energy per unit current', 'The power per unit charge'], 0,
         'Voltage is potential difference.'),
        ('What is capacitance of a parallel-plate capacitor?',
         ARRAY['C = ε₀A/d', 'C = ε₀d/A', 'C = A/(ε₀d)', 'C = ε₀Ad'], 0,
         'ε₀ is the permittivity of free space (8.85 × 10⁻¹^2 F/m).')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_electricity, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 5. MAGNETISM (30 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is a magnetic field?',
         ARRAY['A region where a magnetic force acts on moving charges', 'A region of electric force', 'A region of gravitational force', 'A region of zero force'], 0,
         'Magnetic fields are produced by moving charges (currents).'),
        ('What is the unit of magnetic field?',
         ARRAY['Tesla (T)', 'Gauss (G)', 'Both', 'Neither'], 2,
         '1 T = 10,000 G.'),
        ('What is the source of magnetic fields?',
         ARRAY['Moving electric charges (currents) and magnetic dipoles', 'Stationary charges', 'Gravitational fields', 'Electric fields'], 0,
         'Electromagnetism unites electricity and magnetism.'),
        ('What is the law for the force on a moving charge in a magnetic field?',
         ARRAY['F = qv × B (Lorentz force)', 'F = qE', 'F = qvE', 'F = qB'], 0,
         'The Lorentz force includes both electric and magnetic components.'),
        ('What is the direction of the force on a moving charge in a magnetic field?',
         ARRAY['Perpendicular to both velocity and magnetic field', 'In the direction of velocity', 'In the direction of the magnetic field', 'Opposite to the magnetic field'], 0,
         'The force is given by the right-hand rule.'),
        ('What is the Biot-Savart law?',
         ARRAY['Calculates the magnetic field from a current-carrying element', 'Calculates the electric field from a charge', 'Calculates the force between currents', 'Calculates the magnetic force'], 0,
         'dB = (μ₀/4π) Idl × r̂/r^2.'),
        ('What is Ampere''s Law?',
         ARRAY['∮B·dl = μ₀I_enc', '∮E·dl = 0', '∮B·dA = 0', '∮E·dA = Q/ε₀'], 0,
         'Ampere''s Law relates magnetic field to enclosed current.'),
        ('What is a solenoid?',
         ARRAY['A coil of wire that produces a magnetic field when carrying current', 'A type of capacitor', 'A type of resistor', 'A type of diode'], 0,
         'The magnetic field inside a solenoid is nearly uniform.'),
        ('What is the magnetic field inside a solenoid?',
         ARRAY['B = μ₀nI', 'B = μ₀NI', 'B = μ₀I/n', 'B = μ₀n/I'], 0,
         'n is the number of turns per unit length.'),
        ('What is the force between two parallel current-carrying wires?',
         ARRAY['Attractive if currents are in the same direction', 'Repulsive if currents are in the same direction', 'No force', 'Perpendicular force'], 0,
         'The force is attractive for parallel currents.'),
        ('What is the direction of the magnetic field around a straight current-carrying wire?',
         ARRAY['Circular (right-hand rule)', 'Radial', 'Parallel to the wire', 'Perpendicular to the wire'], 0,
         'Use the right-hand rule: thumb in direction of current, fingers curl in direction of field.'),
        ('What is a magnetic dipole?',
         ARRAY['A system of two magnetic poles (north and south)', 'A single magnetic pole', 'An electric dipole', 'A current loop'], 0,
         'Magnetic dipoles produce magnetic fields.'),
        ('What is the Earth''s magnetic field?',
         ARRAY['A magnetic field generated by currents in the Earth''s core', 'A static field from permanent magnets', 'A field from the sun', 'A field from the moon'], 0,
         'The Earth''s field is like a large magnetic dipole.'),
        ('What is the magnetic declination?',
         ARRAY['The angle between true north and magnetic north', 'The angle of dip', 'The angle of inclination', 'The magnetic field strength'], 0,
         'Declination varies with location.'),
        ('What is the Hall effect?',
         ARRAY['The production of a voltage across a current-carrying conductor in a magnetic field', 'The production of current in a magnetic field', 'The production of magnetic field from current', 'The production of electric field from magnetic field'], 0,
         'The Hall effect is used in sensors.'),
        ('What is the magnetic permeability of free space (μ₀)?',
         ARRAY['4π × 10⁻⁷ T·m/A', '4π × 10⁻⁷ N/A^2', '4π × 10⁻⁷ H/m', 'All of the above'], 3,
         'μ₀ = 4π × 10⁻⁷ N/A^2 = 4π × 10⁻⁷ H/m.'),
        ('What is the magnetic moment of a current loop?',
         ARRAY['μ = IA (area × current)', 'μ = NI A', 'μ = I/A', 'μ = A/I'], 0,
         'The magnetic moment is a vector.'),
        ('What is Lenz''s Law?',
         ARRAY['The direction of induced current opposes the change that produced it', 'The direction of induced current supports the change', 'The induced current is zero', 'The induced current is constant'], 0,
         'Lenz''s Law is a consequence of conservation of energy.'),
        ('What is Faraday''s Law of Induction?',
         ARRAY['E = -dΦ/dt', 'E = -dΦ/dB', 'E = -dB/dt', 'E = -dΦ/dA'], 0,
         'An induced EMF is equal to the rate of change of magnetic flux.'),
        ('What is a transformer?',
         ARRAY['A device that changes AC voltage using mutual induction', 'A device that changes DC voltage', 'A device that changes frequency', 'A device that changes current'], 0,
         'Transformers work on AC only.'),
        ('What is the efficiency of an ideal transformer?',
         ARRAY['100% (ideal)', '50%', '75%', '90%'], 0,
         'Ideal transformers have no losses.'),
        ('What is the unit of magnetic flux?',
         ARRAY['Weber (Wb)', 'Tesla (T)', 'Henry (H)', 'Farad (F)'], 0,
         '1 Wb = 1 T·m^2.'),
        ('What is an electromagnet?',
         ARRAY['A magnet that becomes magnetised when current flows through a coil', 'A permanent magnet', 'A magnet that loses magnetism', 'A magnet that attracts only certain metals'], 0,
         'Electromagnets are used in many applications.'),
        ('What is a magnetic circuit?',
         ARRAY['The path of magnetic flux', 'The path of electric current', 'The path of heat flow', 'The path of light'], 0,
         'Magnetic circuits are analogous to electric circuits.'),
        ('What is the magnetic field strength (H)?',
         ARRAY['H = B/μ', 'H = μB', 'H = B - μ', 'H = μ/B'], 0,
         'H is related to B by the permeability.'),
        ('What is the Curie temperature?',
         ARRAY['The temperature above which a ferromagnetic material becomes paramagnetic', 'The temperature below which a material becomes magnetic', 'The temperature of maximum magnetism', 'The temperature of zero magnetism'], 0,
         'Above the Curie temperature, thermal motion destroys ferromagnetic order.'),
        ('What is a magnetic monopole?',
         ARRAY['A hypothetical particle with only one magnetic pole', 'A particle with two poles', 'A particle with no poles', 'A particle with only north pole'], 0,
         'Magnetic monopoles have never been observed.'),
        ('What is the gauss?',
         ARRAY['A unit of magnetic field (1 G = 10⁻⁴ T)', 'A unit of electric field', 'A unit of charge', 'A unit of resistance'], 0,
         'The gauss is still used in some contexts.'),
        ('What is the source of the Earth''s magnetic field?',
         ARRAY['Convection currents in the liquid iron outer core', 'Permanent magnets in the core', 'Solar wind', 'The moon''s gravity'], 0,
         'The geodynamo generates the Earth''s magnetic field.'),
        ('What is the force on a current-carrying wire in a magnetic field?',
         ARRAY['F = IL × B', 'F = qv × B', 'F = ILB', 'F = qE'], 0,
         'The force is perpendicular to both the current and the magnetic field.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_magnetism, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 6. QUANTUM PHYSICS (30 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Who proposed that light is quantised (photons)?',
         ARRAY['Albert Einstein', 'Max Planck', 'Niels Bohr', 'Erwin Schrödinger'], 0,
         'Einstein proposed the photon concept in 1905, building on Planck''s earlier work.'),
        ('What is Planck''s constant?',
         ARRAY['6.626 × 10⁻^3⁴ J·s', '6.626 × 10⁻^3⁴ eV·s', '6.626 × 10⁻^3⁴ J/Hz', 'All of the above'], 3,
         'Planck''s constant is fundamental to quantum mechanics.'),
        ('What is the de Broglie wavelength?',
         ARRAY['λ = h/p (matter waves)', 'λ = h/mv', 'λ = hf', 'λ = c/f'], 0,
         'de Broglie proposed that all matter has wave properties.'),
        ('What is the Heisenberg Uncertainty Principle?',
         ARRAY['Δx Δp >= ħ/2', 'ΔE Δt >= ħ/2', 'Both', 'Neither'], 2,
         'Both position/momentum and energy/time have uncertainty relations.'),
        ('What is the wave function (ψ) in quantum mechanics?',
         ARRAY['A mathematical function describing the quantum state of a particle', 'A wave', 'A particle', 'An energy state'], 0,
         'The wave function contains all information about a quantum system.'),
        ('Who developed the Schrödinger equation?',
         ARRAY['Erwin Schrödinger', 'Werner Heisenberg', 'Paul Dirac', 'Niels Bohr'], 0,
         'Schrödinger formulated the wave equation in 1926.'),
        ('What is the Born rule?',
         ARRAY['The probability density is |ψ|^2', 'The wave function is real', 'The wave function is imaginary', 'The probability is ψ'], 0,
         'Born''s rule connects the wave function to measurement probabilities.'),
        ('What is quantum superposition?',
         ARRAY['A system can be in multiple states simultaneously until measured', 'A system is in one definite state', 'A system has no state', 'A system is always measured'], 0,
         'Superposition is a fundamental feature of quantum mechanics.'),
        ('What is quantum entanglement?',
         ARRAY['When two particles are correlated such that the state of one instantly affects the other', 'When two particles are independent', 'When two particles have the same state', 'When two particles are in superposition'], 0,
         'Entanglement was called "spooky action at a distance" by Einstein.'),
        ('What is the Pauli exclusion principle?',
         ARRAY['No two fermions can occupy the same quantum state simultaneously', 'No two particles can occupy the same state', 'All particles can occupy the same state', 'Only bosons are excluded'], 0,
         'The exclusion principle explains atomic structure.'),
        ('What is a boson?',
         ARRAY['A particle with integer spin (0, 1, 2, ...)', 'A particle with half-integer spin (1/2, 3/2, ...)', 'A particle with spin 0 only', 'A particle with spin 1'], 0,
         'Bosons include photons, gluons, W/Z bosons, and the Higgs boson.'),
        ('What is a fermion?',
         ARRAY['A particle with half-integer spin (1/2, 3/2, ...)', 'A particle with integer spin', 'A particle with spin 0', 'A particle with spin 1'], 0,
         'Fermions include electrons, protons, neutrons, and quarks.'),
        ('What is the quantum harmonic oscillator?',
         ARRAY['A system with quantised energy levels E_n = (n + 1/2)ħω', 'A system with continuous energy levels', 'A system with zero energy', 'A system with no energy levels'], 0,
         'The zero-point energy is 1/2ħω.'),
        ('What is the zero-point energy?',
         ARRAY['The lowest possible energy of a quantum system (not zero)', 'Zero energy', 'Infinite energy', 'Negative energy'], 0,
         'Zero-point energy is a consequence of the uncertainty principle.'),
        ('What is the tunnel effect (quantum tunneling)?',
         ARRAY['A particle can pass through a potential barrier even if it lacks enough energy', 'A particle reflects off a barrier', 'A particle is absorbed by a barrier', 'A particle is emitted from a barrier'], 0,
         'Tunneling is used in scanning tunneling microscopes and nuclear fusion.'),
        ('What is the Bohr model of the atom?',
         ARRAY['Electrons orbit the nucleus in quantised energy levels', 'Electrons are waves', 'Electrons have no orbits', 'Electrons are particles'], 0,
         'The Bohr model successfully explained hydrogen spectra.'),
        ('What is the quantum number n in the Bohr model?',
         ARRAY['The principal quantum number (energy level)', 'The orbital angular momentum', 'The spin', 'The magnetic quantum number'], 0,
         'n = 1, 2, 3, ... .'),
        ('What is spin?',
         ARRAY['An intrinsic angular momentum of particles', 'The rotation of a particle', 'The orbital motion of a particle', 'The charge of a particle'], 0,
         'Spin is a quantum property with no classical analog.'),
        ('What is the spin of an electron?',
         ARRAY['1/2', '1', '0', '3/2'], 0,
         'Electrons are spin-1/2 fermions.'),
        ('What is the Stern-Gerlach experiment?',
         ARRAY['Demonstrated the quantisation of spin', 'Demonstrated the wave nature of electrons', 'Demonstrated the particle nature of light', 'Demonstrated the uncertainty principle'], 0,
         'The experiment showed that spin is quantised.'),
        ('What is a quantum state?',
         ARRAY['A complete description of a quantum system', 'A measurement outcome', 'A wave function', 'An energy level'], 0,
         'The quantum state is represented by the wave function.'),
        ('What is a measurement in quantum mechanics?',
         ARRAY['A process that collapses the wave function to an eigenstate', 'A process that leaves the wave function unchanged', 'A process that creates a superposition', 'A process that destroys the system'], 0,
         'Measurement causes wave function collapse.'),
        ('What is the Copenhagen interpretation?',
         ARRAY['A quantum interpretation where the wave function collapses upon measurement', 'A quantum interpretation with many worlds', 'A quantum interpretation with hidden variables', 'A quantum interpretation with no measurement'], 0,
         'The Copenhagen interpretation is the most widely taught.'),
        ('What is quantum computing?',
         ARRAY['A computer that uses quantum bits (qubits) and quantum principles', 'A computer that uses classical bits', 'A computer that uses binary logic', 'A computer that uses analog signals'], 0,
         'Quantum computers use superposition and entanglement.'),
        ('What is a qubit?',
         ARRAY['A quantum bit that can be in a superposition of 0 and 1', 'A classical bit', 'A bit with only two states', 'A bit with three states'], 0,
         'Qubits are the building blocks of quantum computers.'),
        ('What is the photoelectric effect evidence for?',
         ARRAY['The particle nature of light (photons)', 'The wave nature of light', 'The wave nature of matter', 'The particle nature of matter'], 0,
         'The photoelectric effect supports the quantum nature of light.'),
        ('What is blackbody radiation?',
         ARRAY['Radiation from a perfect absorber and emitter (Planck''s law)', 'Radiation from a perfect reflector', 'Radiation from a transparent object', 'Radiation from a cold object'], 0,
         'Planck''s solution to the blackbody problem led to quantum theory.'),
        ('What is the Compton effect?',
         ARRAY['The scattering of photons by electrons, showing particle properties', 'The scattering of electrons by photons', 'The scattering of light by atoms', 'The scattering of light by molecules'], 0,
         'The Compton effect confirms the particle nature of photons.'),
        ('What is the wave-particle duality?',
         ARRAY['All matter and energy have both wave and particle properties', 'Only light has wave-particle duality', 'Only matter has wave-particle duality', 'Neither wave nor particle'], 0,
         'Wave-particle duality is a central concept in quantum mechanics.'),
        ('What is a quantum well?',
         ARRAY['A potential well that confines particles, leading to quantised energy levels', 'A potential barrier', 'A region of zero potential', 'A region of infinite potential'], 0,
         'Quantum wells are used in semiconductor devices.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_quantum, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 7. NUCLEAR PHYSICS (30 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the nucleus of an atom composed of?',
         ARRAY['Protons and neutrons', 'Protons and electrons', 'Neutrons and electrons', 'Quarks only'], 0,
         'The nucleus contains protons (p) and neutrons (n).'),
        ('What is the charge of a proton?',
         ARRAY['+e (1.60 × 10⁻¹⁹ C)', '−e', '0', '2e'], 0,
         'Protons are positively charged.'),
        ('What is the charge of a neutron?',
         ARRAY['0 (neutral)', '+e', '−e', '2e'], 0,
         'Neutrons have no net charge.'),
        ('What is the atomic number?',
         ARRAY['The number of protons in an atom', 'The number of neutrons', 'The number of electrons', 'The mass number'], 0,
         'The atomic number defines the element.'),
        ('What is the mass number?',
         ARRAY['The number of protons + neutrons', 'The number of protons', 'The number of neutrons', 'The number of electrons'], 0,
         'The mass number is the total number of nucleons.'),
        ('What are isotopes?',
         ARRAY['Atoms of the same element with different numbers of neutrons', 'Atoms with different numbers of protons', 'Atoms with different numbers of electrons', 'Atoms with the same mass number'], 0,
         'Isotopes have the same atomic number but different mass numbers.'),
        ('What is the strong nuclear force?',
         ARRAY['The force that binds protons and neutrons together in the nucleus', 'The force that binds electrons to the nucleus', 'The force between charged particles', 'The force of gravity'], 0,
         'The strong force is the strongest of the four fundamental forces.'),
        ('What is the weak nuclear force?',
         ARRAY['The force responsible for radioactive decay (beta decay)', 'The force that binds the nucleus', 'The force between quarks', 'The electromagnetic force'], 0,
         'The weak force mediates neutrino interactions and beta decay.'),
        ('What is radioactivity?',
         ARRAY['The spontaneous emission of radiation from an unstable nucleus', 'The emission of light from an atom', 'The emission of electrons from a metal', 'The emission of heat from a nucleus'], 0,
         'Radioactivity is a nuclear phenomenon.'),
        ('What are the three main types of radioactive decay?',
         ARRAY['Alpha, beta, and gamma decay', 'Alpha, beta, and neutron decay', 'Alpha, gamma, and positron decay', 'Beta, gamma, and fission'], 0,
         'Alpha (α), beta (β), and gamma (γ) are the primary types.'),
        ('What is alpha decay?',
         ARRAY['Emission of an alpha particle (2 protons + 2 neutrons)', 'Emission of an electron', 'Emission of a positron', 'Emission of gamma rays'], 0,
         'Alpha particles are helium-4 nuclei.'),
        ('What is beta decay?',
         ARRAY['Emission of an electron or positron from the nucleus', 'Emission of an alpha particle', 'Emission of a neutron', 'Emission of a proton'], 0,
         'Beta-minus decay converts a neutron to a proton, emitting an electron.'),
        ('What is gamma decay?',
         ARRAY['Emission of high-energy photons (gamma rays) from an excited nucleus', 'Emission of particles', 'Emission of electrons', 'Emission of positrons'], 0,
         'Gamma rays have the highest energy in the electromagnetic spectrum.'),
        ('What is the decay constant (λ)?',
         ARRAY['The probability of decay per unit time', 'The half-life', 'The mean life', 'The activity'], 0,
         'λ = ln2 / T₁/₂.'),
        ('What is the half-life?',
         ARRAY['The time for half of a radioactive substance to decay', 'The time for all of it to decay', 'The time for a quarter to decay', 'The mean lifetime'], 0,
         'Half-life is a characteristic of each isotope.'),
        ('What is nuclear fission?',
         ARRAY['The splitting of a heavy nucleus into two lighter nuclei', 'The fusion of two light nuclei', 'The emission of particles', 'The absorption of a neutron'], 0,
         'Fission releases energy and is used in nuclear reactors and bombs.'),
        ('What is nuclear fusion?',
         ARRAY['The joining of two light nuclei to form a heavier nucleus', 'The splitting of a nucleus', 'The emission of particles', 'The absorption of neutrons'], 0,
         'Fusion powers stars and is the source of solar energy.'),
        ('What is the binding energy of a nucleus?',
         ARRAY['The energy required to separate a nucleus into its constituent nucleons', 'The energy released in fusion', 'The energy released in fission', 'The energy of the nucleus'], 0,
         'Binding energy = mass defect × c^2.'),
        ('What is the mass defect?',
         ARRAY['The difference between the mass of the nucleus and the sum of its constituent nucleons', 'The mass lost in radioactive decay', 'The mass of the nucleus', 'The mass of the nucleons'], 0,
         'Mass defect is converted into binding energy.'),
        ('What is the most stable nucleus (highest binding energy per nucleon)?',
         ARRAY['Iron (Fe-56) or Nickel (Ni-62)', 'Uranium', 'Hydrogen', 'Helium'], 0,
         'Iron-56 has one of the highest binding energies per nucleon.'),
        ('What is a nuclear chain reaction?',
         ARRAY['A reaction where neutrons released by fission cause further fissions', 'A reaction where fusion causes fission', 'A reaction that stops spontaneously', 'A reaction with no neutrons'], 0,
         'Chain reactions are sustained in nuclear reactors.'),
        ('What is a critical mass?',
         ARRAY['The minimum amount of fissile material needed to sustain a chain reaction', 'The maximum amount of fissile material', 'The mass that is critical to safety', 'The mass that is subcritical'], 0,
         'Critical mass is essential for nuclear weapons and reactors.'),
        ('What is a nuclear reactor?',
         ARRAY['A device that controls a nuclear chain reaction to produce energy', 'A device that produces nuclear weapons', 'A device that accelerates particles', 'A device that stores nuclear waste'], 0,
         'Nuclear reactors use fission to generate heat and electricity.'),
        ('What is the moderator in a nuclear reactor?',
         ARRAY['A material that slows down neutrons', 'A material that absorbs neutrons', 'A material that reflects neutrons', 'A material that produces neutrons'], 0,
         'Moderators (e.g., water, graphite) slow neutrons to thermal energies.'),
        ('What is a control rod?',
         ARRAY['A rod that absorbs neutrons to control the reaction rate', 'A rod that produces neutrons', 'A rod that reflects neutrons', 'A rod that heats up'], 0,
         'Control rods (e.g., boron, cadmium) regulate the chain reaction.'),
        ('What is radiation dose?',
         ARRAY['The amount of ionising radiation absorbed by a material', 'The amount of energy emitted', 'The number of particles emitted', 'The rate of decay'], 0,
         'Dose is measured in grays (Gy) or sieverts (Sv).'),
        ('What is the unit of radioactivity?',
         ARRAY['Becquerel (Bq)', 'Coulomb (C)', 'Volt (V)', 'Ampere (A)'], 0,
         '1 Bq = 1 decay/second.'),
        ('What is the curie (Ci)?',
         ARRAY['An older unit of radioactivity (1 Ci = 3.7 × 10¹⁰ Bq)', 'A unit of radiation dose', 'A unit of energy', 'A unit of half-life'], 0,
         'The curie is named after Marie and Pierre Curie.'),
        ('What is the role of the strong force in the nucleus?',
         ARRAY['It overcomes the electromagnetic repulsion between protons', 'It causes beta decay', 'It binds electrons to the nucleus', 'It causes gamma decay'], 0,
         'The strong force is attractive and acts on nucleons.'),
        ('What are quarks?',
         ARRAY['Elementary particles that make up hadrons (protons, neutrons)', 'A type of lepton', 'A type of boson', 'A type of force carrier'], 0,
         'Quarks are fundamental constituents of matter.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_nuclear, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 8. RELATIVITY (30 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Who developed the theory of relativity?',
         ARRAY['Albert Einstein', 'Isaac Newton', 'Galileo Galilei', 'Niels Bohr'], 0,
         'Einstein published special relativity in 1905 and general relativity in 1915.'),
        ('What is the first postulate of special relativity?',
         ARRAY['The laws of physics are the same in all inertial reference frames', 'The speed of light is constant', 'Energy equals mass times c^2', 'All motion is relative'], 0,
         'This is the principle of relativity.'),
        ('What is the second postulate of special relativity?',
         ARRAY['The speed of light in vacuum is constant for all observers', 'The laws of physics are the same for all observers', 'Energy is conserved', 'Mass is conserved'], 0,
         'The constancy of the speed of light is a fundamental postulate.'),
        ('What is the Lorentz transformation?',
         ARRAY['Equations that relate space and time coordinates between inertial frames', 'Equations for energy', 'Equations for momentum', 'Equations for force'], 0,
         'Lorentz transformations replace Galilean transformations at high speeds.'),
        ('What is time dilation?',
         ARRAY['A moving clock runs slower compared to a stationary clock', 'A moving clock runs faster', 'Time is absolute', 'Time is constant'], 0,
         'Δt = γ Δt₀, where γ = 1/√(1 - v^2/c^2).'),
        ('What is length contraction?',
         ARRAY['A moving object contracts along the direction of motion', 'A moving object expands', 'Length is absolute', 'Length is constant'], 0,
         'L = L₀/γ.'),
        ('What is the relativistic mass increase?',
         ARRAY['Mass increases with speed (m = γm₀)', 'Mass decreases with speed', 'Mass is constant', 'Mass is zero'], 0,
         'Relativistic mass is often replaced by energy.'),
        ('What is the mass-energy equivalence equation?',
         ARRAY['E = mc^2', 'E = mc', 'E = γmc^2', 'E = pc'], 0,
         'This equation shows that mass and energy are interchangeable.'),
        ('What is the twin paradox?',
         ARRAY['A thought experiment showing that the travelling twin ages slower', 'A paradox with no solution', 'A paradox about time travel', 'A paradox about length'], 0,
         'The twin paradox is resolved by the fact that the travelling twin changes inertial frames.'),
        ('What is the velocity addition formula in special relativity?',
         ARRAY['v = (u + v'')/(1 + uv''/c^2)', 'v = u + v''', 'v = u - v''', 'v = uv''/c^2'], 0,
         'The relativistic velocity addition formula prevents exceeding the speed of light.'),
        ('What is a light cone?',
         ARRAY['The region of spacetime connected to an event by light rays', 'A cone of light', 'A physical cone', 'A gravitational lens'], 0,
         'Light cones define causal relationships in spacetime.'),
        ('What is the spacetime interval?',
         ARRAY['Δs^2 = c^2Δt^2 - Δx^2 - Δy^2 - Δz^2', 'Δs^2 = Δx^2 + Δy^2 + Δz^2', 'Δs^2 = c^2Δt^2', 'Δs^2 = Δt^2'], 0,
         'The spacetime interval is invariant under Lorentz transformations.'),
        ('What is General Relativity?',
         ARRAY['Einstein''s theory of gravity as curvature of spacetime', 'Einstein''s theory of electrodynamics', 'Einstein''s theory of quantum mechanics', 'Einstein''s theory of nuclear physics'], 0,
         'General relativity describes gravity as the curvature of spacetime by mass and energy.'),
        ('What is the equivalence principle?',
         ARRAY['In a small region, gravitational acceleration is equivalent to an accelerating frame', 'Gravity and electricity are equivalent', 'Mass and energy are equivalent', 'Time and space are equivalent'], 0,
         'The equivalence principle is the foundation of general relativity.'),
        ('What is a geodesic in general relativity?',
         ARRAY['The path of a free-falling object in curved spacetime', 'A straight line', 'A curved line', 'A circle'], 0,
         'Geodesics are the shortest paths in curved spacetime.'),
        ('What is the Schwarzschild radius?',
         ARRAY['The radius of the event horizon of a non-rotating black hole', 'The radius of a star', 'The radius of a galaxy', 'The radius of the universe'], 0,
         'r_s = 2GM/c^2.'),
        ('What is a black hole?',
         ARRAY['A region of spacetime where gravity is so strong that nothing can escape', 'A star', 'A galaxy', 'A nebula'], 0,
         'Black holes are predicted by general relativity.'),
        ('What is the event horizon?',
         ARRAY['The boundary of a black hole beyond which nothing can escape', 'The centre of a black hole', 'The singularity', 'The accretion disk'], 0,
         'The event horizon is a causal boundary.'),
        ('What is gravitational time dilation?',
         ARRAY['Time runs slower in stronger gravitational fields', 'Time runs faster in stronger fields', 'Time is constant', 'Time is zero'], 0,
         'Clocks closer to a massive body run slower.'),
        ('What is gravitational redshift?',
         ARRAY['Light loses energy (redshift) as it climbs out of a gravitational field', 'Light gains energy (blueshift)', 'Light is unchanged', 'Light is absorbed'], 0,
         'Gravitational redshift is a consequence of general relativity.'),
        ('What is the precession of Mercury?',
         ARRAY['The anomalous precession of Mercury''s orbit explained by general relativity', 'The precession of Earth''s orbit', 'The precession of the moon', 'The precession of Venus'], 0,
         'General relativity explained the 43 arcseconds per century discrepancy.'),
        ('What is the deflection of light by gravity?',
         ARRAY['Light bends in a gravitational field', 'Light travels in straight lines', 'Light is unaffected by gravity', 'Light is absorbed by gravity'], 0,
         'The bending of light by the sun was confirmed during the 1919 solar eclipse.'),
        ('What is gravitational lensing?',
         ARRAY['The bending of light around massive objects, causing distortion and magnification', 'A lens made of gravity', 'A gravitational wave', 'A black hole'], 0,
         'Gravitational lensing is a powerful tool in astronomy.'),
        ('What are gravitational waves?',
         ARRAY['Ripples in spacetime caused by accelerating masses', 'Waves in the ocean', 'Electromagnetic waves', 'Sound waves'], 0,
         'Gravitational waves were first detected by LIGO in 2015.'),
        ('What is the speed of gravitational waves?',
         ARRAY['The speed of light (c)', 'Faster than light', 'Slower than light', 'Infinite'], 0,
         'Gravitational waves propagate at the speed of light.'),
        ('What is a singularity?',
         ARRAY['A point where spacetime curvature becomes infinite', 'A black hole', 'A neutron star', 'A white dwarf'], 0,
         'Singularities are found at the centre of black holes.'),
        ('What is dark energy?',
         ARRAY['A hypothetical form of energy causing the accelerated expansion of the universe', 'Dark matter', 'Black holes', 'Cosmic rays'], 0,
         'Dark energy is one of the greatest mysteries in cosmology.'),
        ('What is the cosmological constant (Λ)?',
         ARRAY['A term in Einstein''s equations representing dark energy', 'A constant for gravity', 'A constant for light', 'A constant for mass'], 0,
         'Einstein introduced the cosmological constant and later called it his "biggest blunder."'),
        ('What is the expanding universe?',
         ARRAY['The observation that galaxies are moving away from each other', 'The universe is contracting', 'The universe is static', 'The universe is oscillating'], 0,
         'Hubble''s law shows the expansion.'),
        ('What is the age of the universe?',
         ARRAY['Approximately 13.8 billion years', '6,000 years', '100 billion years', '1 billion years'], 0,
         'The age of the universe is determined by cosmic microwave background and expansion rate.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_relativity, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 9. PARTICLE PHYSICS (30 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the Standard Model of particle physics?',
         ARRAY['A theory describing the fundamental particles and forces (except gravity)', 'A theory of everything', 'A theory of gravity', 'A theory of quantum mechanics'], 0,
         'The Standard Model is the most successful theory in particle physics.'),
        ('What are the fundamental building blocks of matter?',
         ARRAY['Quarks and leptons', 'Protons and neutrons', 'Atoms and molecules', 'Hadrons and mesons'], 0,
         'Quarks and leptons are the elementary particles.'),
        ('How many types (flavours) of quarks are there?',
         ARRAY['6', '3', '4', '5'], 0,
         'Up, down, strange, charm, bottom, top.'),
        ('How many types of leptons are there?',
         ARRAY['6', '3', '4', '5'], 0,
         'Electron, muon, tau, and their corresponding neutrinos.'),
        ('What is the lightest quark?',
         ARRAY['Up quark', 'Down quark', 'Strange quark', 'Charm quark'], 0,
         'The up quark has a mass of about 2.2 MeV/c^2.'),
        ('What is the heaviest quark?',
         ARRAY['Top quark', 'Bottom quark', 'Charm quark', 'Strange quark'], 0,
         'The top quark has a mass of about 173 GeV/c^2.'),
        ('What is a hadron?',
         ARRAY['A particle made of quarks (e.g., protons, neutrons)', 'A lepton', 'A force carrier', 'A fundamental particle'], 0,
         'Hadrons are composite particles.'),
        ('What is a baryon?',
         ARRAY['A hadron made of three quarks (e.g., proton, neutron)', 'A hadron made of two quarks', 'A lepton', 'A boson'], 0,
         'Protons (uud) and neutrons (udd) are baryons.'),
        ('What is a meson?',
         ARRAY['A hadron made of a quark and an antiquark', 'A hadron made of three quarks', 'A lepton', 'A force carrier'], 0,
         'Pions and kaons are mesons.'),
        ('What is a gluon?',
         ARRAY['The force carrier for the strong nuclear force', 'The force carrier for electromagnetism', 'The force carrier for the weak force', 'The force carrier for gravity'], 0,
         'Gluons mediate the strong interaction between quarks.'),
        ('What is the photon?',
         ARRAY['The force carrier for electromagnetism', 'The force carrier for the strong force', 'The force carrier for the weak force', 'The force carrier for gravity'], 0,
         'Photons are the quanta of electromagnetic radiation.'),
        ('What is the W and Z boson?',
         ARRAY['Force carriers for the weak nuclear force', 'Force carriers for the strong force', 'Force carriers for electromagnetism', 'Force carriers for gravity'], 0,
         'The W± and Z⁰ bosons mediate the weak interaction.'),
        ('What is the Higgs boson?',
         ARRAY['A particle that gives other particles mass via the Higgs mechanism', 'A force carrier', 'A quark', 'A lepton'], 0,
         'The Higgs boson was discovered at the LHC in 2012.'),
        ('What is the Higgs field?',
         ARRAY['A field that gives particles mass through interactions', 'A gravitational field', 'An electromagnetic field', 'A strong field'], 0,
         'The Higgs field is responsible for the mass of elementary particles.'),
        ('What is the difference between a neutrino and an electron?',
         ARRAY['Neutrinos have very small mass and no charge; electrons have mass and charge', 'Neutrinos are heavier', 'Neutrinos are charged', 'Neutrinos are quarks'], 0,
         'Neutrinos are neutral leptons.'),
        ('What is antimatter?',
         ARRAY['Matter composed of antiparticles (e.g., positrons, antiprotons)', 'Dark matter', 'Negative matter', 'Hypothetical matter'], 0,
         'Antiparticles have opposite charge and quantum numbers.'),
        ('What is a positron?',
         ARRAY['The antiparticle of the electron', 'The antiparticle of the proton', 'The antiparticle of the neutron', 'The antiparticle of the neutrino'], 0,
         'Positrons are positively charged electrons.'),
        ('What is the quark composition of a proton?',
         ARRAY['UUD (up, up, down)', 'UDD (up, down, down)', 'UUS', 'DDU'], 0,
         'Proton: two up quarks and one down quark.'),
        ('What is the quark composition of a neutron?',
         ARRAY['UDD (up, down, down)', 'UUD (up, up, down)', 'UDS', 'DDU'], 0,
         'Neutron: one up quark and two down quarks.'),
        ('What is colour charge in quantum chromodynamics (QCD)?',
         ARRAY['A property of quarks and gluons related to the strong force', 'A visual property', 'An electrical charge', 'A gravitational charge'], 0,
         'Colour charge has three types: red, green, blue.'),
        ('What is confinement?',
         ARRAY['Quarks are never found alone; they are confined within hadrons', 'Quarks can be isolated', 'Quarks are free particles', 'Quarks have no colour'], 0,
         'Confinement means quarks are always bound together.'),
        ('What is asymptotic freedom?',
         ARRAY['At high energies, quarks interact weakly (appear free)', 'At low energies, quarks interact weakly', 'Quarks are always strongly interacting', 'Quarks are always free'], 0,
         'Asymptotic freedom explains the behaviour of quarks at high energies.'),
        ('What is the Standard Model''s prediction for the Higgs boson mass?',
         ARRAY['It was not predicted; it was discovered at ~125 GeV', 'It was predicted to be 100 GeV', 'It was predicted to be 200 GeV', 'It was predicted to be 50 GeV'], 0,
         'The Higgs mass was found to be about 125 GeV/c^2.'),
        ('What is supersymmetry (SUSY)?',
         ARRAY['A theory that proposes a symmetry between fermions and bosons', 'A theory of everything', 'A theory of gravity', 'A theory of quantum mechanics'], 0,
         'SUSY is an extension of the Standard Model but has not been confirmed.'),
        ('What is dark matter?',
         ARRAY['A hypothetical form of matter that does not interact electromagnetically', 'Antimatter', 'Black holes', 'Neutrinos'], 0,
         'Dark matter is inferred from gravitational effects.'),
        ('What is the Large Hadron Collider (LHC)?',
         ARRAY['The world''s largest and highest-energy particle accelerator', 'A telescope', 'A microscope', 'A nuclear reactor'], 0,
         'The LHC at CERN discovered the Higgs boson.'),
        ('What is a neutrino oscillation?',
         ARRAY['The change of a neutrino from one flavour to another', 'A neutrino oscillating like a pendulum', 'A neutrino changing speed', 'A neutrino changing mass'], 0,
         'Neutrino oscillations imply that neutrinos have mass.'),
        ('What is the most abundant particle in the universe?',
         ARRAY['Neutrinos (most numerous)', 'Protons', 'Electrons', 'Photons'], 0,
         'Neutrinos are extremely abundant but interact very weakly.'),
        ('What is quantum electrodynamics (QED)?',
         ARRAY['The quantum theory of electromagnetism', 'The quantum theory of the strong force', 'The quantum theory of the weak force', 'The quantum theory of gravity'], 0,
         'QED describes how light and matter interact.'),
        ('What is the strong coupling constant (α_s)?',
         ARRAY['A parameter that determines the strength of the strong force', 'A parameter for electromagnetism', 'A parameter for the weak force', 'A parameter for gravity'], 0,
         'α_s is a running coupling constant that depends on energy.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_particle, q_rec.column1, 'single_choice', q_rec.column4)
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