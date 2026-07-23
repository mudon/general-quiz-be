-- ============================================================================
-- Insert 240 factual questions on Defense & Security.
-- Subtopics: Military Branches, Weapons, Tanks, Aircraft, Ships, Submarines,
-- Missiles, Drones, Cyber Defense, Intelligence Agencies, Peacekeeping, Counterterrorism.
-- No sensitive/classified material — only unclassified, public-domain knowledge.
-- ============================================================================

DO $$
DECLARE
    cat_id_branches       BIGINT;
    cat_id_weapons        BIGINT;
    cat_id_tanks          BIGINT;
    cat_id_aircraft       BIGINT;
    cat_id_ships          BIGINT;
    cat_id_subs           BIGINT;
    cat_id_missiles       BIGINT;
    cat_id_drones         BIGINT;
    cat_id_cyber          BIGINT;
    cat_id_intel          BIGINT;
    cat_id_peace          BIGINT;
    cat_id_ct             BIGINT;
    q_id                  BIGINT;
    correct_opt_id        BIGINT;
    opt_texts             TEXT[];
    q_rec                 RECORD;
BEGIN
    -- ------------------------------------------------------------------------
    -- Create categories (hierarchical under defense_security)
    -- ------------------------------------------------------------------------
    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('defense_security', 'Defense & Security', 3, 0)
        ON CONFLICT (path) DO NOTHING;

    INSERT INTO categories (path, name, tier, sort_order) VALUES
        ('defense_security.military_branches',  'Military Branches', 3, 1),
        ('defense_security.weapons',            'Weapons', 3, 2),
        ('defense_security.tanks',              'Tanks', 3, 3),
        ('defense_security.aircraft',           'Aircraft', 0, 4),
        ('defense_security.ships',              'Ships', 3, 5),
        ('defense_security.submarines',         'Submarines', 3, 6),
        ('defense_security.missiles',           'Missiles', 3, 7),
        ('defense_security.drones',             'Drones', 0, 8),
        ('defense_security.cyber_defense',      'Cyber Defense', 3, 9),
        ('defense_security.intelligence_agencies', 'Intelligence Agencies', 3, 10),
        ('defense_security.peacekeeping',       'Peacekeeping', 3, 11),
        ('defense_security.counterterrorism',   'Counterterrorism', 3, 12)
        ON CONFLICT (path) DO NOTHING;

    -- Get category IDs
    SELECT id INTO cat_id_branches FROM categories WHERE path = 'defense_security.military_branches';
    SELECT id INTO cat_id_weapons  FROM categories WHERE path = 'defense_security.weapons';
    SELECT id INTO cat_id_tanks    FROM categories WHERE path = 'defense_security.tanks';
    SELECT id INTO cat_id_aircraft FROM categories WHERE path = 'defense_security.aircraft';
    SELECT id INTO cat_id_ships    FROM categories WHERE path = 'defense_security.ships';
    SELECT id INTO cat_id_subs     FROM categories WHERE path = 'defense_security.submarines';
    SELECT id INTO cat_id_missiles FROM categories WHERE path = 'defense_security.missiles';
    SELECT id INTO cat_id_drones   FROM categories WHERE path = 'defense_security.drones';
    SELECT id INTO cat_id_cyber    FROM categories WHERE path = 'defense_security.cyber_defense';
    SELECT id INTO cat_id_intel    FROM categories WHERE path = 'defense_security.intelligence_agencies';
    SELECT id INTO cat_id_peace    FROM categories WHERE path = 'defense_security.peacekeeping';
    SELECT id INTO cat_id_ct       FROM categories WHERE path = 'defense_security.counterterrorism';

    -- ========================================================================
    -- 1. MILITARY BRANCHES (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Which US military branch was established in 1775, making it the oldest?',
         ARRAY['Army', 'Navy', 'Marine Corps', 'Coast Guard'], 0,
         'The Continental Army was established on 14 June 1775.'),
        ('What is the primary role of the United States Navy?',
         ARRAY['Sea control and power projection', 'Ground combat', 'Strategic bombing', 'Cyber warfare'], 0,
         'The Navy maintains freedom of the seas and projects power ashore.'),
        ('Which branch operates the B-2 Spirit stealth bomber?',
         ARRAY['US Air Force', 'US Navy', 'US Army', 'US Marine Corps'], 0,
         'The B-2 Spirit is an Air Force heavy strategic bomber.'),
        ('The US Space Force was established in which year?',
         ARRAY['2019', '2001', '2015', '2020'], 0,
         'The Space Force was established on 20 December 2019.'),
        ('Which branch has the motto "Semper Fidelis" (Always Faithful)?',
         ARRAY['Marine Corps', 'Army', 'Navy', 'Coast Guard'], 0,
         'Semper Fidelis has been the Marine Corps motto since 1883.'),
        ('What is the primary role of the US Coast Guard?',
         ARRAY['Maritime security, search and rescue, law enforcement', 'Deep‑sea warfare', 'Strategic nuclear deterrence', 'Air defense'], 0,
         'The Coast Guard protects US waters and maritime infrastructure.'),
        ('Which country has the largest active‑duty military personnel as of 2025?',
         ARRAY['China', 'United States', 'Russia', 'India'], 0,
         'China''s People''s Liberation Army is the largest active force.'),
        ('What is the name of the UK''s naval infantry force?',
         ARRAY['Royal Marines', 'British Army', 'Royal Navy', 'RAF Regiment'], 0,
         'The Royal Marines are the UK''s amphibious light infantry.'),
        ('Which US military branch has the aircraft carrier fleet?',
         ARRAY['Navy', 'Air Force', 'Marine Corps', 'Coast Guard'], 0,
         'Carriers are operated exclusively by the US Navy.'),
        ('What is the "National Guard" primarily?',
         ARRAY['A reserve component of the US military', 'A branch of intelligence', 'A federal police force', 'A naval reserve'], 0,
         'The National Guard serves as a reserve force under state and federal command.'),
        ('In France, what is the "Gendarmerie" known for?',
         ARRAY['Military force with law enforcement duties', 'Strategic bombing', 'Naval operations', 'Cyber defense'], 0,
         'The Gendarmerie is a military police force responsible for law enforcement.'),
        ('Which branch operates the majority of the US nuclear triad?',
         ARRAY['Air Force and Navy', 'Army only', 'Marine Corps only', 'Coast Guard'], 0,
         'The Air Force operates land‑based ICBMs and bombers; the Navy operates SLBMs.'),
        ('What is the motto of the US Army?',
         ARRAY['This We''ll Defend', 'Semper Fidelis', 'Above All', 'Always Ready'], 0,
         '"This We''ll Defend" was adopted in 1962.'),
        ('What is the "Bundeswehr"?',
         ARRAY['The armed forces of Germany', 'The French foreign legion', 'The UK defence staff', 'The Russian defence ministry'], 0,
         'Bundeswehr is the unified armed forces of Germany.'),
        ('Which branch is responsible for amphibious assault operations?',
         ARRAY['US Marine Corps', 'US Army', 'US Navy', 'US Air Force'], 0,
         'The Marine Corps specialises in expeditionary and amphibious warfare.'),
        ('The "People''s Liberation Army" belongs to which country?',
         ARRAY['China', 'North Korea', 'Vietnam', 'Cuba'], 0,
         'The PLA is the armed forces of the People''s Republic of China.'),
        ('Which UK service is known as the "Senior Service"?',
         ARRAY['Royal Navy', 'British Army', 'Royal Air Force', 'Royal Marines'], 0,
         'The Royal Navy is the oldest of the UK armed services, hence the "Senior Service".'),
        ('What is the main role of the Air National Guard?',
         ARRAY['Reserve component of the US Air Force, supports state and federal missions', 'Primary strategic bomber force', 'Cyber operations', 'Special operations'], 0,
         'The Air National Guard is a reserve component that can be mobilised for both state and federal missions.'),
        ('Which country has mandatory military service for both men and women?',
         ARRAY['Israel', 'United States', 'United Kingdom', 'Australia'], 0,
         'Israel has mandatory conscription for both men and women.'),
        ('The US Army Corps of Engineers is primarily responsible for:',
         ARRAY['Civil works and military construction', 'Combat engineering only', 'Nuclear weapons', 'Intelligence analysis'], 0,
         'The Corps handles infrastructure, flood control, and construction projects.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_branches, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 2. WEAPONS (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the standard service rifle of the US military?',
         ARRAY['M16 series / M4 carbine', 'AK‑47', 'L85', 'FAMAS'], 0,
         'The M16 and M4 are the primary US military rifles.'),
        ('What caliber is the AK‑47?',
         ARRAY['7.62×39mm', '5.56×45mm', '7.62×51mm', '9×19mm'], 0,
         'The AK‑47 fires the 7.62×39mm intermediate cartridge.'),
        ('What is the current standard sidearm of the US military?',
         ARRAY['M17 / M18 (Sig Sauer)', 'M9 (Beretta)', 'Colt 1911', 'Glock 19'], 0,
         'The M17 and M18 were adopted in 2017 as the new standard sidearm.'),
        ('Which weapon is a .50 caliber heavy machine gun?',
         ARRAY['Browning M2', 'M249 SAW', 'M240', 'M60'], 0,
         'The Browning M2 .50 cal is a heavy machine gun in use since WWII.'),
        ('What is the M203?',
         ARRAY['A grenade launcher attachment', 'A sniper rifle', 'A light machine gun', 'A carbine'], 0,
         'The M203 is a single‑shot under‑barrel 40mm grenade launcher.'),
        ('What is the FGM‑148 Javelin?',
         ARRAY['Anti‑tank missile', 'Air‑to‑air missile', 'Cruise missile', 'Surface‑to‑air missile'], 0,
         'The Javelin is a fire‑and‑forget anti‑tank guided missile.'),
        ('What is the FIM‑92 Stinger?',
         ARRAY['Man‑portable air‑defense system (MANPADS)', 'Anti‑tank rocket', 'Machine gun', 'Grenade launcher'], 0,
         'The Stinger is a shoulder‑fired surface‑to‑air missile.'),
        ('What caliber is the .50 BMG?',
         ARRAY['12.7×99mm NATO', '14.5×114mm', '7.62×51mm', '10×25mm'], 0,
         '.50 Browning Machine Gun is 12.7×99mm, a heavy machine gun cartridge.'),
        ('What does SAW stand for in M249 SAW?',
         ARRAY['Squad Automatic Weapon', 'Special Assault Weapon', 'Submachine Automatic Weapon', 'Standard Anti‑armour Weapon'], 0,
         'The M249 is a light machine gun used as a squad automatic weapon.'),
        ('Which weapon is the M240?',
         ARRAY['Medium machine gun', 'Submachine gun', 'Sniper rifle', 'Anti‑material rifle'], 0,
         'The M240 is a 7.62×51mm medium machine gun.'),
        ('What is a "carbine"?',
         ARRAY['A shorter, lighter rifle', 'A heavy machine gun', 'A shotgun', 'A grenade launcher'], 0,
         'Carbines are compact rifles, often used by support troops.'),
        ('What is the M67?',
         ARRAY['Fragmentation grenade', 'Smoke grenade', 'Flashbang', 'Incendiary grenade'], 0,
         'The M67 is a standard fragmentation grenade used by US forces.'),
        ('What is the Carl Gustaf?',
         ARRAY['Recoilless rifle', 'Handgun', 'Assault rifle', 'Anti‑tank mine'], 0,
         'The Carl Gustaf is an 84mm portable recoilless rifle, often used as a multi‑role weapon.'),
        ('What is the M320?',
         ARRAY['Standalone grenade launcher', 'Handgun', 'Sniper rifle', 'Light mortar'], 0,
         'The M320 is a 40mm grenade launcher that can be used as an attachment or standalone.'),
        ('Which weapon is the M110?',
         ARRAY['Semi‑automatic sniper rifle', 'Assault rifle', 'Machine gun', 'Submachine gun'], 0,
         'The M110 is a 7.62×51mm semi‑automatic sniper weapon system.'),
        ('What is the M4A1?',
         ARRAY['Carbine variant of the M16', 'Light machine gun', 'Sniper rifle', 'Shotgun'], 0,
         'The M4A1 is a selective‑fire carbine, a compact derivative of the M16.'),
        ('What is the Barrett M82 known for?',
         ARRAY['Anti‑material / sniper rifle', 'Assault rifle', 'Submachine gun', 'Light machine gun'], 0,
         'The Barrett M82 is a .50 BMG semi‑automatic anti‑material rifle.'),
        ('What is the MP5?',
         ARRAY['Submachine gun', 'Assault rifle', 'Machine gun', 'Pistol'], 0,
         'The MP5 is a German‑designed 9mm submachine gun.'),
        ('Which weapon is the M60?',
         ARRAY['General‑purpose machine gun', 'Assault rifle', 'Grenade launcher', 'Anti‑tank missile'], 0,
         'The M60 is a 7.62×51mm GPMG, used extensively during the Vietnam War.'),
        ('What is the M9 bayonet?',
         ARRAY['A knife that attaches to the M16/M4', 'A hand grenade', 'A cartridge', 'A scope'], 0,
         'The M9 bayonet is designed to fit the M16 and M4 rifles.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_weapons, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 3. TANKS (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the main battle tank of the US Army?',
         ARRAY['M1 Abrams', 'M60 Patton', 'M1A2', 'Sherman'], 0,
         'The M1 Abrams entered service in 1980 and remains the US main battle tank.'),
        ('What is the main battle tank of the Russian Ground Forces?',
         ARRAY['T‑90', 'T‑72', 'T‑80', 'T‑14 Armata'], 0,
         'The T‑90 is the current Russian main battle tank, though T‑14 is newer.'),
        ('Which tank was the first to be used in battle?',
         ARRAY['British Mark I', 'French Renault FT', 'German A7V', 'American M1'], 0,
         'The British Mark I was used in September 1916 at the Somme.'),
        ('What is the main battle tank of Germany?',
         ARRAY['Leopard 2', 'Leopard 1', 'Tiger', 'Panther'], 0,
         'The Leopard 2 has been the German main battle tank since 1979.'),
        ('What is the main battle tank of the British Army?',
         ARRAY['Challenger 2', 'Challenger 1', 'Centurion', 'Chieftain'], 0,
         'The Challenger 2 is the British Army''s current main battle tank.'),
        ('What is the main battle tank of Israel?',
         ARRAY['Merkava', 'Centurion', 'M60', 'T‑72'], 0,
         'The Merkava has been the main battle tank of the IDF since 1979.'),
        ('What is the main battle tank of France?',
         ARRAY['Leclerc', 'AMX‑30', 'Leopard 2', 'M1 Abrams'], 0,
         'The Leclerc is the French main battle tank, in service since 1992.'),
        ('What is the main battle tank of China?',
         ARRAY['Type 99', 'Type 96', 'T‑54', 'Type 59'], 0,
         'The Type 99 is the main battle tank of the People''s Liberation Army.'),
        ('What is the main battle tank of India?',
         ARRAY['Arjun', 'T‑90', 'Vijayanta', 'T‑72'], 0,
         'The Arjun is the Indian main battle tank, developed domestically.'),
        ('What type of armour is used on the M1 Abrams?',
         ARRAY['Chobham (composite)', 'RHA', 'Spaced armour', 'Explosive reactive'], 0,
         'The Abrams uses a composite armour developed at the British Chobham facility.'),
        ('What is the T‑72?',
         ARRAY['A Soviet‑era main battle tank', 'A US tank destroyer', 'A British light tank', 'A German heavy tank'], 0,
         'The T‑72 was a widely exported Soviet main battle tank from the 1970s.'),
        ('What is the M60 Patton?',
         ARRAY['A US Cold War‑era main battle tank', 'A WWII heavy tank', 'A modern light tank', 'A tank destroyer'], 0,
         'The M60 Patton was the US main battle tank from 1960 to the 1990s.'),
        ('What is the German "Panzer" generally known as?',
         ARRAY['German tanks from WWII', 'Modern German infantry fighting vehicles', 'Artillery pieces', 'Anti‑aircraft guns'], 0,
         '"Panzer" refers to German armoured fighting vehicles, especially from WWII.'),
        ('What is the M4 Sherman?',
         ARRAY['A US WWII medium tank', 'A US WWII heavy tank', 'A British infantry tank', 'A Soviet light tank'], 0,
         'The M4 Sherman was the most widely used US tank in WWII.'),
        ('What is a "tank destroyer"?',
         ARRAY['A vehicle specialised in destroying enemy tanks', 'A tank that destroys buildings', 'An anti‑aircraft vehicle', 'A command tank'], 0,
         'Tank destroyers are designed specifically to engage and destroy enemy armour.'),
        ('What is the T‑34?',
         ARRAY['A Soviet WWII medium tank', 'A US heavy tank', 'A German Panther', 'A British cruiser tank'], 0,
         'The T‑34 was a highly influential Soviet medium tank of WWII.'),
        ('What is the PT‑76?',
         ARRAY['A Soviet amphibious light tank', 'A US amphibious assault vehicle', 'A German amphibious car', 'A British scout car'], 0,
         'The PT‑76 is a Soviet amphibious light tank, in service since 1951.'),
        ('What is the Stridsvagn 103 (S‑tank)?',
         ARRAY['A Swedish turretless tank', 'A US heavy tank', 'A German tank destroyer', 'A British main battle tank'], 0,
         'The Stridsvagn 103 is a unique Swedish turretless design.'),
        ('What is the M1A2 SEP?',
         ARRAY['The latest upgrade of the M1 Abrams tank', 'An older variant of the M1', 'A towed artillery piece', 'An armoured personnel carrier'], 0,
         'SEP stands for System Enhancement Package, the newest Abrams variant.'),
        ('What is the Leopard 2A7?',
         ARRAY['The latest Leopard 2 variant', 'An older Leopard 1 variant', 'A British tank', 'A French tank'], 0,
         'The Leopard 2A7 is the newest version of the German Leopard 2.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_tanks, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 4. AIRCRAFT (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the primary multirole fighter of the US Air Force?',
         ARRAY['F‑16 Fighting Falcon', 'F‑35 Lightning II', 'F‑15 Eagle', 'A‑10 Thunderbolt'], 0,
         'The F‑16 is the most numerous US Air Force multirole fighter.'),
        ('What is the B‑52 Stratofortress?',
         ARRAY['A long‑range strategic bomber', 'A heavy transport aircraft', 'An aerial refuelling tanker', 'An electronic warfare aircraft'], 0,
         'The B‑52 has been in service since 1955 and is a strategic bomber.'),
        ('Which aircraft is a stealth air‑superiority fighter?',
         ARRAY['F‑22 Raptor', 'F‑35', 'Su‑57', 'Eurofighter Typhoon'], 0,
         'The F‑22 is the US''s stealth air‑superiority fighter, designed for air dominance.'),
        ('What is the C‑130 Hercules?',
         ARRAY['A tactical transport aircraft', 'A strategic bomber', 'An attack helicopter', 'A training jet'], 0,
         'The C‑130 is a rugged, versatile tactical airlifter.'),
        ('What is the AH‑64 Apache?',
         ARRAY['An attack helicopter', 'A transport helicopter', 'A reconnaissance drone', 'An assault plane'], 0,
         'The AH‑64 Apache is an American twin‑turboshaft attack helicopter.'),
        ('What is the UH‑60 Black Hawk?',
         ARRAY['A utility helicopter', 'An attack helicopter', 'A heavy transport helicopter', 'An aerial refuelling tanker'], 0,
         'The UH‑60 is a four‑bladed, twin‑engine utility helicopter.'),
        ('What is the CH‑47 Chinook?',
         ARRAY['A heavy‑lift transport helicopter', 'An attack helicopter', 'A reconnaissance aircraft', 'A cargo drone'], 0,
         'The CH‑47 is a tandem‑rotor heavy‑lift helicopter used for troop and cargo transport.'),
        ('What is the E‑3 Sentry?',
         ARRAY['An airborne early warning and control (AWACS) aircraft', 'A fighter jet', 'A strategic bomber', 'A tanker aircraft'], 0,
         'The E‑3 Sentry provides all‑weather surveillance, command, and control.'),
        ('What is the KC‑135 Stratotanker?',
         ARRAY['An aerial refuelling tanker', 'A cargo aircraft', 'A bomber', 'A reconnaissance aircraft'], 0,
         'The KC‑135 is a military aerial refuelling tanker.'),
        ('What is the C‑17 Globemaster III?',
         ARRAY['A large strategic transport aircraft', 'A fighter jet', 'A bomber', 'A tanker'], 0,
         'The C‑17 is used for rapid strategic and tactical airlift.'),
        ('What is the F/A‑18 Hornet?',
         ARRAY['A carrier‑capable multirole fighter', 'A land‑based bomber', 'An attack helicopter', 'A transport plane'], 0,
         'The F/A‑18 is a carrier‑capable fighter/attack aircraft used by the US Navy.'),
        ('What is the Eurofighter Typhoon?',
         ARRAY['A European multirole fighter', 'A US bomber', 'A Russian fighter', 'A Chinese fighter'], 0,
         'The Typhoon is a European twin‑engine, canard‑delta multirole fighter.'),
        ('What is the Dassault Rafale?',
         ARRAY['A French multirole fighter', 'An Italian fighter', 'A German bomber', 'A British interceptor'], 0,
         'The Rafale is a French twin‑engine, canard‑delta multirole fighter.'),
        ('What is the MiG‑29?',
         ARRAY['A Russian twin‑engine fighter', 'A US bomber', 'A European transport', 'A Chinese attack aircraft'], 0,
         'The MiG‑29 is a Russian twin‑engine air‑superiority fighter.'),
        ('What is the Su‑27 Flanker?',
         ARRAY['A Russian air‑superiority fighter', 'A US navy fighter', 'A European training jet', 'A Chinese bomber'], 0,
         'The Su‑27 is a Russian heavy air‑superiority fighter.'),
        ('What is the A‑10 Thunderbolt II?',
         ARRAY['A close‑air support aircraft', 'A strategic bomber', 'A fighter jet', 'A reconnaissance plane'], 0,
         'The A‑10, nicknamed "Warthog", is designed for close air support of ground troops.'),
        ('What is the B‑2 Spirit?',
         ARRAY['A strategic stealth bomber', 'A fighter jet', 'A transport aircraft', 'A helicopter'], 0,
         'The B‑2 is a flying‑wing stealth bomber capable of penetrating dense air defenses.'),
        ('What is the V‑22 Osprey?',
         ARRAY['A tiltrotor aircraft', 'A traditional helicopter', 'A fixed‑wing transport', 'A drone'], 0,
         'The V‑22 combines the vertical takeoff of a helicopter with the speed of a turboprop.'),
        ('What is the P‑8 Poseidon?',
         ARRAY['A maritime patrol aircraft', 'A fighter jet', 'A bomber', 'A tanker'], 0,
         'The P‑8 is a submarine‑hunter and maritime surveillance aircraft.'),
        ('What is the B‑1 Lancer?',
         ARRAY['A supersonic strategic bomber', 'A heavy transport', 'A fighter bomber', 'An aerial tanker'], 0,
         'The B‑1 is a supersonic, variable‑sweep wing heavy bomber.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_aircraft, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 5. SHIPS (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('Which class is the largest aircraft carrier ever built?',
         ARRAY['Nimitz class', 'Gerald R. Ford class', 'Queen Elizabeth class', 'Kuznetsov class'], 0,
         'The Gerald R. Ford class is the largest carrier, displacing over 100,000 tons.'),
        ('What is the main role of a destroyer?',
         ARRAY['Multi‑mission escort and anti‑air / anti‑surface warfare', 'Amphibious assault', 'Mine warfare', 'Submarine patrol'], 0,
         'Destroyers are versatile escorts that protect carrier strike groups.'),
        ('What is a frigate?',
         ARRAY['A smaller, multi‑mission escort vessel', 'A large amphibious assault ship', 'A nuclear‑powered cruiser', 'A patrol boat'], 0,
         'Frigates are usually smaller than destroyers, focused on anti‑submarine warfare.'),
        ('What is a corvette?',
         ARRAY['A small, lightly armed warship', 'A heavy cruiser', 'An aircraft carrier', 'A submarine tender'], 0,
         'Corvettes are the smallest class of warships, often used for coastal patrol.'),
        ('What is the Arleigh Burke class?',
         ARRAY['A US guided‑missile destroyer', 'A US aircraft carrier', 'A US submarine', 'A US frigate'], 0,
         'The Arleigh Burke class is the backbone of the US Navy destroyer fleet.'),
        ('What is the Ticonderoga class?',
         ARRAY['A US guided‑missile cruiser', 'A US destroyer', 'A US frigate', 'A US amphibious assault ship'], 0,
         'The Ticonderoga class is a class of Aegis‑equipped cruisers.'),
        ('What is an amphibious assault ship?',
         ARRAY['A ship that carries Marines and landing craft', 'A ship that carries aircraft for defense', 'A supply ship', 'A hospital ship'], 0,
         'Amphibious assault ships support Marine Corps operations ashore.'),
        ('What is a littoral combat ship (LCS)?',
         ARRAY['A ship designed for near‑shore operations', 'A blue‑water cruiser', 'A submarine', 'A mine sweeper'], 0,
         'LCS are fast, agile ships for operations in coastal waters.'),
        ('What is a carrier strike group?',
         ARRAY['An aircraft carrier with escort ships', 'A group of submarines', 'A naval aviation squadron', 'A fleet of destroyers'], 0,
         'A CSG is a powerful naval task force built around an aircraft carrier.'),
        ('What was the USS Iowa class?',
         ARRAY['Battleships', 'Aircraft carriers', 'Cruisers', 'Destroyers'], 0,
         'The Iowa class were the last battleships built by the US.'),
        ('What is the Zumwalt class?',
         ARRAY['Stealth destroyers', 'Nuclear submarines', 'Aircraft carriers', 'Amphibious assault ships'], 0,
         'The Zumwalt class is a class of US Navy guided‑missile destroyers with stealth features.'),
        ('What is the Queen Elizabeth class?',
         ARRAY['UK aircraft carriers', 'US aircraft carriers', 'French destroyers', 'Russian cruisers'], 0,
         'The Queen Elizabeth class are the largest warships ever built for the Royal Navy.'),
        ('What is the Charles de Gaulle?',
         ARRAY['A French nuclear‑powered aircraft carrier', 'A UK destroyer', 'A US cruiser', 'A Russian submarine'], 0,
         'Charles de Gaulle is the flagship of the French Navy, a nuclear‑powered carrier.'),
        ('What is a minesweeper?',
         ARRAY['A ship designed to detect and remove naval mines', 'A ship that lays mines', 'A ship that sweeps the sea for submarines', 'A patrol boat'], 0,
         'Minesweepers are specialised for clearing sea mines.'),
        ('What is a patrol boat?',
         ARRAY['A small, fast vessel for coastal surveillance', 'A large destroyer', 'An amphibious assault ship', 'A submarine'], 0,
         'Patrol boats are used for inshore and littoral operations.'),
        ('What is the Nimitz class?',
         ARRAY['US supercarriers', 'US destroyers', 'US submarines', 'US cruisers'], 0,
         'The Nimitz class is a class of ten nuclear‑powered aircraft carriers.'),
        ('What is a landing ship dock (LSD)?',
         ARRAY['An amphibious warfare ship that transports landing craft', 'A cargo ship', 'A destroyer', 'A mine countermeasure ship'], 0,
         'LSDs support amphibious operations by launching landing craft and vehicles.'),
        ('What is the Kirov class?',
         ARRAY['Russian nuclear‑powered battlecruisers', 'US cruisers', 'UK destroyers', 'Chinese frigates'], 0,
         'The Kirov class are large Russian nuclear‑powered guided‑missile cruisers.'),
        ('What is an auxiliary ship?',
         ARRAY['A support vessel, such as a fleet oiler', 'A combat warship', 'An amphibious ship', 'A submarine'], 0,
         'Auxiliaries provide fuel, ammunition, and supply support to the fleet.'),
        ('What is the Independence class?',
         ARRAY['A US Littoral Combat Ship design (trimaran hull)', 'A US destroyer', 'A US aircraft carrier', 'A US submarine'], 0,
         'The Independence class is a trimaran LCS variant.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_ships, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 6. SUBMARINES (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the primary role of an attack submarine (SSN)?',
         ARRAY['Anti‑submarine and anti‑surface warfare', 'Strategic nuclear deterrence', 'Mine laying', 'Amphibious assault'], 0,
         'Attack submarines are hunter‑killers, designed to find and destroy other submarines and surface ships.'),
        ('What is a ballistic missile submarine (SSBN) designed for?',
         ARRAY['Strategic nuclear deterrence', 'Anti‑ship warfare', 'Intelligence gathering', 'Special forces insertion'], 0,
         'SSBNs carry submarine‑launched ballistic missiles as part of the nuclear triad.'),
        ('What is the Ohio class?',
         ARRAY['US ballistic missile submarine (SSBN)', 'US attack submarine (SSN)', 'UK SSBN', 'Russian SSBN'], 0,
         'The Ohio class are US Navy SSBNs, each carrying up to 24 Trident missiles.'),
        ('What is the Virginia class?',
         ARRAY['US attack submarine (SSN)', 'US SSBN', 'UK SSN', 'Russian attack sub'], 0,
         'The Virginia class is the latest US Navy attack submarine, designed for littoral and deep‑water missions.'),
        ('What is the Seawolf class?',
         ARRAY['US attack submarine (SSN)', 'US SSBN', 'UK submarine', 'Russian submarine'], 0,
         'The Seawolf class is a US SSN, designed for Cold War anti‑submarine warfare.'),
        ('What is the Astute class?',
         ARRAY['UK attack submarine (SSN)', 'UK SSBN', 'US SSN', 'French SSN'], 0,
         'The Astute class is the Royal Navy''s latest attack submarine.'),
        ('What is the Typhoon class?',
         ARRAY['Russian SSBN, the largest submarine ever built', 'US SSBN', 'UK SSBN', 'Chinese SSBN'], 0,
         'The Soviet/Russian Typhoon class are the largest submarines ever constructed.'),
        ('What is the Borei class?',
         ARRAY['Russian SSBN', 'Russian SSN', 'US SSBN', 'UK SSBN'], 0,
         'The Borei class is the current Russian nuclear‑powered ballistic missile submarine.'),
        ('What is the Triomphant class?',
         ARRAY['French SSBN', 'French SSN', 'US SSBN', 'UK SSBN'], 0,
         'The Triomphant class is the French Navy''s nuclear‑powered ballistic missile submarine.'),
        ('What is a diesel‑electric submarine?',
         ARRAY['A submarine with conventional engines, not nuclear', 'A submarine with nuclear power', 'A submarine with fuel cells', 'A submarine with Stirling engines'], 0,
         'Diesel‑electric submarines use diesel engines to charge batteries for submerged operation.'),
        ('What is the Kilo class?',
         ARRAY['Russian diesel‑electric submarine', 'US nuclear submarine', 'UK nuclear submarine', 'Chinese nuclear submarine'], 0,
         'The Kilo class is a Soviet/Russian diesel‑electric attack submarine, widely exported.'),
        ('What is AIP (Air‑Independent Propulsion)?',
         ARRAY['A system allowing non‑nuclear subs to stay submerged longer', 'A nuclear reactor', 'A new type of propeller', 'A sonar system'], 0,
         'AIP (e.g., fuel cells, Stirling engines) reduces the need to snorkel.'),
        ('What is a deep submergence rescue vehicle (DSRV)?',
         ARRAY['A submersible designed to rescue crews from sunken submarines', 'A military attack sub', 'A deep‑sea research vessel', 'An underwater drone'], 0,
         'DSRVs can attach to a disabled submarine to evacuate personnel.'),
        ('What was the X‑craft?',
         ARRAY['British WWII midget submarines', 'US deep‑sea rescue vehicles', 'German U‑boats', 'Japanese mini‑subs'], 0,
         'X‑craft were used in WWII for covert operations, including the attack on the Tirpitz.'),
        ('What is a submarine snorkel?',
         ARRAY['A device that allows a submarine to run diesel engines while submerged', 'A periscope', 'A communications antenna', 'A torpedo tube'], 0,
         'The snorkel allows air intake and exhaust while the sub is at periscope depth.'),
        ('What is the Los Angeles class?',
         ARRAY['US attack submarine (SSN)', 'US SSBN', 'Russian SSN', 'UK SSN'], 0,
         'The Los Angeles class were the workhorse US attack submarines for decades.'),
        ('What is Project 955 (Borei)?',
         ARRAY['Russian SSBN programme', 'US submarine programme', 'UK submarine programme', 'Chinese submarine programme'], 0,
         'Project 955 is the Russian Borei class SSBN.'),
        ('What is a U‑boat?',
         ARRAY['German submarines from WWI and WWII', 'US submarines', 'British submarines', 'Japanese submarines'], 0,
         'U‑boat (Unterseeboot) refers to German submarines.'),
        ('What is the Type 212?',
         ARRAY['German/Italian AIP submarine', 'US nuclear submarine', 'Russian diesel submarine', 'UK nuclear submarine'], 0,
         'The Type 212 is a modern diesel‑electric AIP submarine jointly designed for the German and Italian navies.'),
        ('What is the Gotland class?',
         ARRAY['Swedish AIP submarine', 'Norwegian submarine', 'Danish submarine', 'Finnish submarine'], 0,
         'The Gotland class are Swedish submarines with Stirling AIP.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_subs, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 7. MISSILES (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What does ICBM stand for?',
         ARRAY['Intercontinental Ballistic Missile', 'Intermediate Cruise Ballistic Missile', 'Intercontinental Bomber Missile', 'International Ballistic Missile'], 0,
         'ICBMs have a range of over 5,500 km.'),
        ('What is a cruise missile?',
         ARRAY['A guided missile that flies at low altitude to avoid radar', 'A ballistic missile', 'A surface‑to‑air missile', 'An anti‑tank missile'], 0,
         'Cruise missiles are jet‑powered and fly a terrain‑following flight path.'),
        ('What is the Tomahawk?',
         ARRAY['A US subsonic cruise missile', 'A US ballistic missile', 'A Russian cruise missile', 'A French anti‑ship missile'], 0,
         'The Tomahawk is a US long‑range, subsonic cruise missile.'),
        ('What is the Minuteman III?',
         ARRAY['A US ICBM', 'A US cruise missile', 'A Russian ICBM', 'A Chinese ICBM'], 0,
         'The Minuteman III is the only land‑based ICBM in US service.'),
        ('What is the Trident D‑5?',
         ARRAY['A US submarine‑launched ballistic missile (SLBM)', 'A US cruise missile', 'A Russian SLBM', 'A French SLBM'], 0,
         'The Trident D‑5 is the current US Navy SLBM.'),
        ('What is a SAM?',
         ARRAY['Surface‑to‑Air Missile', 'Ship‑to‑Air Missile', 'Submarine‑to‑Air Missile', 'Smart Anti‑Munition'], 0,
         'SAMs are used to shoot down aircraft and missiles.'),
        ('What is the Patriot missile system?',
         ARRAY['A US surface‑to‑air missile defence system', 'A US anti‑ship missile', 'A Russian SAM', 'A Chinese SAM'], 0,
         'The Patriot is a US mobile air‑defence system, known for countering ballistic missiles.'),
        ('What is the S‑400?',
         ARRAY['A Russian surface‑to‑air missile system', 'A US SAM', 'A Chinese SAM', 'A European SAM'], 0,
         'The S‑400 is a Russian long‑range SAM system.'),
        ('What is a hypersonic glide vehicle (HGV)?',
         ARRAY['A weapon that glides at speeds over Mach 5 after launch', 'A standard ballistic missile', 'A cruise missile', 'A short‑range rocket'], 0,
         'HGVs are manoeuvrable, high‑speed weapons that can evade defences.'),
        ('What is the AGM‑114 Hellfire?',
         ARRAY['An air‑to‑ground missile', 'An air‑to‑air missile', 'A surface‑to‑air missile', 'An anti‑ship missile'], 0,
         'The Hellfire is primarily used for precision strikes against ground targets.'),
        ('What is the AIM‑120 AMRAAM?',
         ARRAY['An air‑to‑air missile (beyond visual range)', 'A surface‑to‑air missile', 'An anti‑tank missile', 'A cruise missile'], 0,
         'AMRAAM is a US active radar‑guided air‑to‑air missile.'),
        ('What is the AIM‑9 Sidewinder?',
         ARRAY['A short‑range air‑to‑air missile', 'A long‑range air‑to‑air missile', 'An air‑to‑ground missile', 'An anti‑ship missile'], 0,
         'The AIM‑9 is a heat‑seeking short‑range air‑to‑air missile.'),
        ('What is an ATGM?',
         ARRAY['Anti‑Tank Guided Missile', 'Air‑To‑Ground Missile', 'Anti‑Torpedo Guided Munition', 'Advanced Tactical Guided Munition'], 0,
         'ATGMs are precision weapons designed to defeat armoured vehicles.'),
        ('What is rocket artillery?',
         ARRAY['A system that fires unguided or guided rockets, like MLRS', 'A tube‑based artillery howitzer', 'An anti‑aircraft gun', 'A naval gun'], 0,
         'Rocket artillery provides area suppression and is often used with cluster munitions.'),
        ('What is the JASSM (Joint Air‑to‑Surface Standoff Missile)?',
         ARRAY['A US stealthy cruise missile', 'A US anti‑ship missile', 'A US air‑to‑air missile', 'A US ballistic missile'], 0,
         'JASSM is a long‑range, precision‑guided air‑to‑ground missile.'),
        ('What is the Topol‑M?',
         ARRAY['A Russian ICBM', 'A US ICBM', 'A Chinese ICBM', 'A Russian cruise missile'], 0,
         'The Topol‑M is a Russian road‑mobile ICBM.'),
        ('What is a MANPADS?',
         ARRAY['Man‑Portable Air‑Defence System', 'Medium‑Altitude Air Defence System', 'Multi‑role Anti‑Personnel System', 'Mobile Anti‑Missile System'], 0,
         'MANPADS are shoulder‑fired surface‑to‑air missiles.'),
        ('What is the Harpoon?',
         ARRAY['A US anti‑ship missile', 'A US cruise missile', 'A US air‑to‑air missile', 'A US anti‑tank missile'], 0,
         'The Harpoon is a US subsonic anti‑ship missile.'),
        ('What is the Exocet?',
         ARRAY['A French anti‑ship missile', 'A French air‑to‑air missile', 'A French surface‑to‑air missile', 'A French cruise missile'], 0,
         'The Exocet is a French anti‑ship missile, famously used in the Falklands War.'),
        ('What is the AGM‑88 HARM?',
         ARRAY['An anti‑radiation missile (suppresses enemy radar)', 'An air‑to‑air missile', 'An anti‑ship missile', 'A cruise missile'], 0,
         'HARM is a US anti‑radiation missile used for SEAD (Suppression of Enemy Air Defences).')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_missiles, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 8. DRONES (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the MQ‑1 Predator?',
         ARRAY['A US reconnaissance/strike drone', 'A US cargo drone', 'A US training drone', 'A US naval drone'], 0,
         'The Predator was one of the first armed UAVs, used for surveillance and strikes.'),
        ('What is the MQ‑9 Reaper?',
         ARRAY['A US strike drone', 'A US reconnaissance drone', 'A US cargo drone', 'A US aerial refuelling drone'], 0,
         'The Reaper is a larger, more heavily armed successor to the Predator.'),
        ('What is the RQ‑4 Global Hawk?',
         ARRAY['A high‑altitude long‑endurance reconnaissance drone', 'A strike drone', 'A cargo drone', 'A combat drone'], 0,
         'The Global Hawk provides high‑resolution intelligence, surveillance, and reconnaissance.'),
        ('What is a quadcopter?',
         ARRAY['A drone with four rotors', 'A drone with two rotors', 'A drone with six rotors', 'A drone with one rotor'], 0,
         'Quadcopters are popular for commercial and military short‑range operations.'),
        ('What is the Bayraktar TB2?',
         ARRAY['A Turkish medium‑altitude drone', 'A US drone', 'A Chinese drone', 'A Russian drone'], 0,
         'The TB2 is a Turkish strike and reconnaissance drone.'),
        ('What is the Heron?',
         ARRAY['An Israeli reconnaissance drone', 'A US strike drone', 'A Chinese cargo drone', 'A European combat drone'], 0,
         'The Heron is a family of Israeli unmanned aerial vehicles for reconnaissance.'),
        ('What is a loitering munition?',
         ARRAY['A drone that can circle an area and then strike a target', 'A cruise missile', 'A reconnaissance drone', 'A cargo drone'], 0,
         'Loitering munitions are often called "kamikaze drones" as they strike by impact.'),
        ('What is the Switchblade?',
         ARRAY['A US loitering munition', 'A US reconnaissance drone', 'A US cargo drone', 'A US training drone'], 0,
         'The Switchblade is a US loitering munition that can be back‑packed.'),
        ('What is the Shahed‑136?',
         ARRAY['An Iranian loitering munition', 'A Russian drone', 'A Turkish drone', 'A Chinese drone'], 0,
         'The Shahed‑136 is an Iranian‑designed loitering munition, used in various conflicts.'),
        ('What is the RQ‑11 Raven?',
         ARRAY['A small hand‑launched reconnaissance UAV', 'A large strike drone', 'A cargo drone', 'A naval drone'], 0,
         'The Raven is a small, lightweight UAV used by US troops for reconnaissance.'),
        ('What is the MQ‑8 Fire Scout?',
         ARRAY['An unmanned helicopter', 'A fixed‑wing strike drone', 'A quadcopter', 'A loitering munition'], 0,
         'The Fire Scout is a vertical takeoff and landing (VTOL) unmanned helicopter.'),
        ('What is a "drone swarm"?',
         ARRAY['Many drones operating collaboratively', 'A single large drone', 'A drone with many engines', 'A drone that carries a heavy payload'], 0,
         'Swarming involves multiple drones coordinating for complex missions.'),
        ('What is the X‑47B?',
         ARRAY['A US Navy stealth drone demonstrator', 'A US Air Force strike drone', 'A US Army cargo drone', 'A US Marine Corps trainer'], 0,
         'The X‑47B was a naval unmanned combat air vehicle (UCAS) demonstrator.'),
        ('What is the Taranis?',
         ARRAY['A UK stealth drone demonstrator', 'A US drone', 'A French drone', 'A German drone'], 0,
         'Taranis is a British unmanned combat air vehicle concept.'),
        ('What is the nEUROn?',
         ARRAY['A European stealth drone demonstrator', 'A US drone', 'A Russian drone', 'A Chinese drone'], 0,
         'The nEUROn is a European UCAS demonstrator led by Dassault.'),
        ('What is the RQ‑170 Sentinel?',
         ARRAY['A US stealth UAV', 'A US cargo drone', 'A US training drone', 'A US loitering munition'], 0,
         'The RQ‑170 is a stealthy reconnaissance UAV, also known as the "Beast of Kandahar".'),
        ('What is the Mantis?',
         ARRAY['A US ground‑based surveillance drone', 'A US strike drone', 'A US cargo drone', 'A US naval drone'], 0,
         'The Mantis is a US Army surveillance UAV, though the project has evolved.'),
        ('What is the Kargu?',
         ARRAY['A Turkish loitering munition', 'A US drone', 'A Chinese drone', 'A Russian drone'], 0,
         'Kargu is a Turkish loitering munition designed for anti‑personnel and anti‑tank roles.'),
        ('What is the Orion?',
         ARRAY['A Russian reconnaissance/strike drone', 'A US drone', 'A European drone', 'A Chinese drone'], 0,
         'The Orion is a Russian medium‑altitude long‑endurance drone.'),
        ('What is the MQ‑25 Stingray?',
         ARRAY['A US Navy carrier‑based aerial refuelling drone', 'A strike drone', 'A reconnaissance drone', 'A cargo drone'], 0,
         'The MQ‑25 is designed to provide refuelling support to carrier aircraft.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_drones, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 9. CYBER DEFENSE (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is cybersecurity?',
         ARRAY['Protecting computer systems from theft, damage, or disruption', 'Building physical walls', 'Encrypting all data', 'Monitoring employees'], 0,
         'Cybersecurity encompasses the technologies and practices to safeguard networks and data.'),
        ('What is a firewall?',
         ARRAY['A network security device that monitors and controls traffic', 'A physical wall against fire', 'A software to delete malware', 'A password manager'], 0,
         'Firewalls filter incoming and outgoing network traffic based on security rules.'),
        ('What is encryption?',
         ARRAY['The process of converting data into a code to prevent unauthorised access', 'Deleting data', 'Copying data', 'Compressing data'], 0,
         'Encryption scrambles data so it can only be read by authorised parties.'),
        ('What is phishing?',
         ARRAY['A fraudulent attempt to obtain sensitive information via email or messages', 'A type of malware', 'A network attack', 'A hardware failure'], 0,
         'Phishing uses deceptive messages to trick users into revealing credentials.'),
        ('What is malware?',
         ARRAY['Malicious software designed to damage or disrupt systems', 'A type of hardware', 'A network protocol', 'An encryption standard'], 0,
         'Malware includes viruses, worms, trojans, and ransomware.'),
        ('What is ransomware?',
         ARRAY['Malware that encrypts files and demands payment for decryption', 'A type of spyware', 'A type of antivirus', 'A hardware key'], 0,
         'Ransomware attacks have become a major threat to organisations worldwide.'),
        ('What is a computer virus?',
         ARRAY['A self‑replicating program that attaches to other files', 'A hardware bug', 'A network error', 'A human error'], 0,
         'Viruses spread by inserting their code into other programs.'),
        ('What is a DDoS attack?',
         ARRAY['Distributed Denial of Service – overwhelming a server with traffic', 'A direct database access attack', 'A data deletion attack', 'A physical attack on servers'], 0,
         'DDoS attacks use multiple compromised devices to flood a target with traffic.'),
        ('What is multi‑factor authentication (MFA)?',
         ARRAY['Using two or more verification factors to log in', 'Using one password', 'Using biometrics only', 'Using security questions only'], 0,
         'MFA adds layers of security, e.g., password + one‑time code.'),
        ('What is a penetration test?',
         ARRAY['An authorised simulated cyberattack to find vulnerabilities', 'Installing a physical firewall', 'Encrypting all data', 'Monitoring network traffic'], 0,
         'Pen tests are ethical hacking exercises to identify weaknesses.'),
        ('What is an Intrusion Detection System (IDS)?',
         ARRAY['A system that monitors network traffic for suspicious activity', 'A system that blocks attacks', 'An encryption system', 'A password management system'], 0,
         'IDS alerts administrators to potential security breaches.'),
        ('What is social engineering?',
         ARRAY['Manipulating people into divulging confidential information', 'A type of malware', 'A network attack', 'An encryption method'], 0,
         'Social engineering exploits human psychology rather than technical flaws.'),
        ('What is a zero‑day vulnerability?',
         ARRAY['A software flaw unknown to the vendor and unpatched', 'A vulnerability that is zero days old', 'A hardware issue', 'A network issue'], 0,
         'Zero‑day vulnerabilities are highly valuable and dangerous.'),
        ('What is antivirus software?',
         ARRAY['A program that detects and removes malware', 'A program that encrypts files', 'A firewall', 'A VPN'], 0,
         'Antivirus software uses signatures and heuristics to identify malware.'),
        ('What is a VPN (Virtual Private Network)?',
         ARRAY['A technology that creates a secure, encrypted connection over a less secure network', 'A type of firewall', 'An antivirus program', 'A password manager'], 0,
         'VPNs are used to ensure privacy and security on public networks.'),
        ('What is a computer worm?',
         ARRAY['A self‑replicating malware that spreads without user action', 'A type of virus that attaches to files', 'A type of trojan', 'A type of ransomware'], 0,
         'Worms spread across networks using vulnerabilities, independent of host files.'),
        ('What is a Trojan (Trojan horse)?',
         ARRAY['Malware disguised as legitimate software', 'A type of virus that replicates', 'A type of worm', 'A type of firewall'], 0,
         'Trojans rely on users to execute them, often via social engineering.'),
        ('What is a botnet?',
         ARRAY['A network of infected devices controlled by an attacker', 'A network of firewalls', 'A network of routers', 'A network of servers'], 0,
         'Botnets are used to launch DDoS attacks and send spam.'),
        ('What is cyber hygiene?',
         ARRAY['Best practices to maintain system security and protect data', 'Cleaning hardware', 'Deleting files', 'Updating physical locks'], 0,
         'Cyber hygiene includes regular updates, strong passwords, and backups.'),
        ('What is the NIST Cybersecurity Framework?',
         ARRAY['A US voluntary framework of standards and guidelines', 'A mandatory international law', 'A commercial product', 'A hardware standard'], 0,
         'NIST CSF is widely adopted for managing cybersecurity risk.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_cyber, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 10. INTELLIGENCE AGENCIES (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What does CIA stand for?',
         ARRAY['Central Intelligence Agency', 'Central Investigation Agency', 'Criminal Intelligence Agency', 'Civil Information Agency'], 0,
         'The CIA is the US foreign intelligence service.'),
        ('What is MI6 known as?',
         ARRAY['Secret Intelligence Service (SIS)', 'Military Intelligence Section 6', 'Secret Intelligence Bureau', 'Foreign Intelligence Service'], 0,
         'MI6 is the UK''s foreign intelligence service, officially the SIS.'),
        ('What is the FBI?',
         ARRAY['Federal Bureau of Investigation – US domestic intelligence and law enforcement', 'Foreign Bureau of Intelligence', 'Federal Border Intelligence', 'Financial Bureau of Investigation'], 0,
         'The FBI is the primary US federal investigative agency, with both intelligence and law enforcement roles.'),
        ('What does NSA stand for?',
         ARRAY['National Security Agency', 'National Signals Agency', 'Naval Security Agency', 'National Surveillance Agency'], 0,
         'The NSA is the US signals intelligence and cybersecurity agency.'),
        ('What is the GRU?',
         ARRAY['Russian military intelligence', 'Russian foreign intelligence', 'Russian domestic intelligence', 'Russian counter‑intelligence'], 0,
         'GRU is the Main Directorate of the General Staff of the Russian Armed Forces.'),
        ('What is Mossad?',
         ARRAY['Israeli national intelligence agency', 'Israeli military intelligence', 'Israeli domestic security', 'Israeli police intelligence'], 0,
         'Mossad is the Israeli intelligence agency responsible for foreign intelligence.'),
        ('What is the BND?',
         ARRAY['German federal intelligence service', 'British intelligence', 'French intelligence', 'Italian intelligence'], 0,
         'BND is the Bundesnachrichtendienst, the foreign intelligence service of Germany.'),
        ('What is the DGSE?',
         ARRAY['French external intelligence agency', 'French domestic intelligence', 'French military intelligence', 'French police'], 0,
         'DGSE (Direction Générale de la Sécurité Extérieure) is France''s foreign intelligence agency.'),
        ('What is the ISI?',
         ARRAY['Inter‑Services Intelligence – Pakistan''s primary intelligence agency', 'Indian intelligence', 'Bangladeshi intelligence', 'Afghan intelligence'], 0,
         'ISI is Pakistan''s premier intelligence and security agency.'),
        ('What is RAW?',
         ARRAY['Research and Analysis Wing – India''s foreign intelligence agency', 'Indian domestic intelligence', 'Indian military intelligence', 'Indian police'], 0,
         'RAW is India''s external intelligence agency, established in 1968.'),
        ('What is the FSB?',
         ARRAY['Federal Security Service – Russia''s domestic and counter‑intelligence agency', 'Russian foreign intelligence', 'Russian military intelligence', 'Russian cyber agency'], 0,
         'FSB is the successor to the KGB in domestic security roles.'),
        ('What was the OSS?',
         ARRAY['Office of Strategic Services – WWII US intelligence, precursor to CIA', 'US domestic intelligence', 'US signals intelligence', 'US military intelligence'], 0,
         'The OSS was established in 1942 and dissolved in 1945.'),
        ('What was the KGB?',
         ARRAY['Soviet intelligence agency (defunct)', 'Russian current intelligence', 'East German intelligence', 'Polish intelligence'], 0,
         'The KGB was the main Soviet security and intelligence agency, dissolved in 1991.'),
        ('What is the MSS?',
         ARRAY['Ministry of State Security – China''s domestic intelligence and security', 'China''s foreign intelligence', 'China''s military intelligence', 'China''s cyber agency'], 0,
         'MSS is the primary civilian intelligence agency of China.'),
        ('What is GCHQ?',
         ARRAY['Government Communications Headquarters – UK signals intelligence', 'UK foreign intelligence', 'UK domestic intelligence', 'UK military intelligence'], 0,
         'GCHQ is the UK''s equivalent of the NSA, focused on signals intelligence.'),
        ('What is CSIS?',
         ARRAY['Canadian Security Intelligence Service', 'Canadian foreign intelligence', 'Canadian military intelligence', 'Canadian police'], 0,
         'CSIS is Canada''s domestic intelligence agency.'),
        ('What is ASIS?',
         ARRAY['Australian Secret Intelligence Service', 'Australian domestic intelligence', 'Australian military intelligence', 'Australian signals agency'], 0,
         'ASIS is Australia''s foreign intelligence collection agency.'),
        ('What is SIS?',
         ARRAY['Secret Intelligence Service – commonly MI6', 'Security Intelligence Service', 'State Intelligence Service', 'Strategic Intelligence Service'], 0,
         'SIS is the official name of the UK''s foreign intelligence agency, MI6.'),
        ('What is the DIA?',
         ARRAY['Defense Intelligence Agency – US military intelligence', 'Department of International Affairs', 'Domestic Intelligence Agency', 'Digital Intelligence Agency'], 0,
         'The DIA provides intelligence to US military leaders and the Secretary of Defense.'),
        ('What is the NRO?',
         ARRAY['National Reconnaissance Office – US satellite intelligence', 'National Research Office', 'Naval Reconnaissance Office', 'Nuclear Regulatory Office'], 0,
         'The NRO designs, builds, and operates US reconnaissance satellites.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_intel, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 11. PEACEKEEPING (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the UN Department of Peace Operations called?',
         ARRAY['DPO', 'UNPKO', 'UNDPO', 'UN Peacekeeping Department'], 0,
         'DPO (Department of Peace Operations) was established in 2019, replacing DPKO.'),
        ('When was the first UN peacekeeping mission deployed?',
         ARRAY['1948 (UNTSO)', '1956 (UNEF I)', '1960 (ONUC)', '1945'], 0,
         'UNTSO (UN Truce Supervision Organization) was deployed in the Middle East in 1948.'),
        ('What are "Blue Helmets" known for?',
         ARRAY['UN peacekeepers', 'NATO troops', 'EU police', 'African Union monitors'], 0,
         'Blue Helmets are UN peacekeepers, named for their distinctive blue headgear.'),
        ('What is the principle of "consent of the parties" in peacekeeping?',
         ARRAY['The host state must agree to the mission', 'All parties must sign a peace treaty', 'The UN Security Council must approve', 'The local population must consent'], 0,
         'Consent ensures the mission has a basis in international law and cooperation.'),
        ('What is the principle of "impartiality" in peacekeeping?',
         ARRAY['Not favouring any party in the conflict', 'Using force against all parties', 'Supporting the government', 'Supporting the rebels'], 0,
         'Peacekeepers must carry out their mandate without taking sides.'),
        ('What is the principle of "non‑use of force except in self‑defense"?',
         ARRAY['A core tenet of traditional peacekeeping', 'An obsolete principle', 'A rule for military observers only', 'A guideline for police'], 0,
         'Use of force is restricted to self‑defense, though modern missions may have broader mandates.'),
        ('What is a "Chapter VI" operation?',
         ARRAY['Peacekeeping (not enforcement)', 'Peace enforcement', 'Counter‑terrorism', 'Humanitarian aid'], 0,
         'Chapter VI refers to the pacific settlement of disputes, hence traditional peacekeeping.'),
        ('What is a "Chapter VII" operation?',
         ARRAY['Peace enforcement (allowing the use of force)', 'Peacekeeping', 'Humanitarian assistance', 'Disarmament'], 0,
         'Chapter VII mandates can include the use of force to restore international peace and security.'),
        ('Which was the largest UN peacekeeping mission (by personnel) in the 2010s?',
         ARRAY['MINUSMA (Mali) / MONUSCO (DRC)', 'UNMISS (South Sudan)', 'UNAMID (Darfur)', 'UNIFIL (Lebanon)'], 0,
         'MONUSCO and MINUSMA have had over 10,000 troops at their peaks.'),
        ('Which country contributes the most troops to UN peacekeeping?',
         ARRAY['Bangladesh', 'India', 'Ethiopia', 'Rwanda'], 0,
         'Bangladesh has been the largest contributor for many years.'),
        ('What was the first UN peacekeeping mission?',
         ARRAY['UNTSO (UN Truce Supervision Organization)', 'UNEF I', 'ONUC', 'UNMOGIP'], 0,
         'UNTSO was established in 1948 to monitor the Arab‑Israeli ceasefire.'),
        ('What is "multidimensional peacekeeping"?',
         ARRAY['Missions that include military, civilian, and political components', 'Missions with a single military component', 'Missions focused on elections', 'Missions without a military component'], 0,
         'Modern peacekeeping integrates police, rule of law, and human rights.'),
        ('What is the role of UN Police (UNPOL)?',
         ARRAY['To assist in maintaining public order and rebuilding police services', 'To lead combat operations', 'To conduct intelligence gathering', 'To provide medical support'], 0,
         'UNPOL helps restore and reform host‑state policing.'),
        ('What is "peacebuilding" in the UN context?',
         ARRAY['Post‑conflict reconstruction and reconciliation', 'Pre‑conflict prevention', 'Peace enforcement', 'Military intervention'], 0,
         'Peacebuilding aims to prevent relapse into conflict by strengthening institutions.'),
        ('What is the "Rule of Law" in peacekeeping?',
         ARRAY['Re‑establishing judicial and legal systems', 'Enforcing military law', 'Implementing UN resolutions', 'Providing legal aid'], 0,
         'This includes justice and correction services in post‑conflict settings.'),
        ('What is the "Protection of Civilians" (PoC) mandate?',
         ARRAY['Protecting civilians from physical violence', 'Protecting refugees only', 'Protecting UN personnel', 'Protecting government officials'], 0,
         'PoC is a key priority for many UN peacekeeping missions.'),
        ('Which peacekeeping mission is associated with the Srebrenica massacre?',
         ARRAY['UNPROFOR (Bosnia)', 'UNAMIR (Rwanda)', 'ONUMOZ (Mozambique)', 'UNOSOM (Somalia)'], 0,
         'UNPROFOR failed to prevent the Srebrenica genocide in 1995.'),
        ('What role does the African Union play in peacekeeping?',
         ARRAY['It deploys regional missions, often in coordination with the UN', 'It is the only peacekeeper in Africa', 'It does not engage in peacekeeping', 'It only provides funding'], 0,
         'The AU has its own missions, such as AMISOM in Somalia.'),
        ('What is the EU''s role in peacekeeping?',
         ARRAY['It conducts crisis‑management and peacekeeping missions under CSDP', 'It only provides funding', 'It has no peacekeeping capacity', 'It replaces the UN in Europe'], 0,
         'The EU has launched numerous civilian and military missions.'),
        ('What is a "ceasefire monitoring" mission?',
         ARRAY['Observing compliance with a ceasefire agreement', 'Enforcing a ceasefire with force', 'Negotiating a ceasefire', 'Documenting war crimes'], 0,
         'These missions are often unarmed or lightly armed, relying on observation.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_peace, q_rec.column1, 'single_choice', q_rec.column4)
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
    -- 12. COUNTERTERRORISM (20 questions)
    -- ========================================================================
    FOR q_rec IN (
        VALUES
        ('What is the basic definition of terrorism?',
         ARRAY['Violence or threat of violence for political/ideological goals', 'A military attack on a state', 'A cyberattack on critical infrastructure', 'A crime committed by a gang'], 0,
         'Terrorism is a tactic to create fear and coerce governments or societies.'),
        ('What event prompted the US "Global War on Terror"?',
         ARRAY['11 September 2001 attacks', '1998 US embassy bombings', '2002 Bali bombings', '2003 Iraq invasion'], 0,
         'The 9/11 attacks led to the US declaration of the Global War on Terror.'),
        ('What is the FBI''s role in counterterrorism?',
         ARRAY['Domestic investigations and prevention', 'Foreign covert operations', 'Signals intelligence', 'Paramilitary operations'], 0,
         'The FBI leads US counterterrorism efforts on US soil.'),
        ('What is the CIA''s role in counterterrorism?',
         ARRAY['Foreign intelligence collection and covert actions', 'Domestic law enforcement', 'Cybersecurity', 'Border patrol'], 0,
         'The CIA gathers foreign intelligence and conducts covert counterterrorism operations.'),
        ('What is a Counterterrorism Center (CTC)?',
         ARRAY['A joint task force for counterterrorism intelligence', 'A prison for terrorists', 'A legal court', 'A military base'], 0,
         'CTCs, like the US National Counterterrorism Center, coordinate intelligence.'),
        ('What is "targeted killing"?',
         ARRAY['Precision strikes against known terrorist leaders', 'Mass killing of civilians', 'Bombing of military bases', 'Economic sanctions'], 0,
         'Targeted killing aims to remove specific high‑value individuals.'),
        ('What is "intelligence‑led policing" in counterterrorism?',
         ARRAY['Using intelligence to prevent attacks', 'Reacting to attacks after they occur', 'Arresting all suspects', 'Surveillance of all citizens'], 0,
         'This proactive approach relies on analysis to disrupt plots.'),
        ('What is "de‑radicalization"?',
         ARRAY['Programs to rehabilitate and reintegrate violent extremists', 'Killing extremists', 'Imprisoning extremists', 'Monitoring extremists'], 0,
         'De‑radicalisation programmes are used in many countries, including Saudi Arabia and the UK.'),
        ('What is the UN Security Council Counter‑Terrorism Committee (CTC)?',
         ARRAY['A committee to monitor and assist states in implementing counter‑terrorism resolutions', 'A military committee', 'A human rights committee', 'A sanctions committee'], 0,
         'The CTC was established by Resolution 1373 after 9/11.'),
        ('What is the FATF (Financial Action Task Force)?',
         ARRAY['An intergovernmental body to combat money laundering and terrorist financing', 'A counter‑terrorism military alliance', 'A UN peacekeeping force', 'A cyber defense agency'], 0,
         'FATF sets standards to prevent the financing of terrorism.'),
        ('What is ISIL/ISIS?',
         ARRAY['An extremist terrorist group that operated in Iraq and Syria', 'A legitimate political party', 'A state government', 'A military alliance'], 0,
         'ISIL (Islamic State of Iraq and the Levant) is a Salafi‑jihadist terrorist organisation.'),
        ('What is Al‑Qaeda?',
         ARRAY['A global terrorist network responsible for 9/11', 'A political movement', 'A religious organisation', 'A state sponsor of terror'], 0,
         'Al‑Qaeda is a Salafi‑jihadist organisation founded by Osama bin Laden.'),
        ('What is "homegrown violent extremism"?',
         ARRAY['Terrorism committed by citizens within their own country', 'Terrorism by foreign fighters', 'Terrorism directed at home soil by foreigners', 'Terrorism against the government'], 0,
         'Homegrown extremism refers to radicalisation and action by residents or citizens.'),
        ('What is "cyberterrorism"?',
         ARRAY['The use of cyberspace to carry out terrorist attacks', 'Spreading propaganda online', 'Hacking for money', 'Denial‑of‑service attacks by activists'], 0,
         'Cyberterrorism involves attacks on critical infrastructure or information systems.'),
        ('What is the Joint Terrorism Task Force (JTTF)?',
         ARRAY['A FBI‑led multi‑agency task force', 'A UN task force', 'A military task force', 'A local police task force'], 0,
         'JTTFs are US interagency teams for counterterrorism investigations.'),
        ('What is "community resilience" in counterterrorism?',
         ARRAY['Building community capacity to resist and prevent radicalisation', 'Building physical barriers around communities', 'Surveillance of communities', 'Military intervention in communities'], 0,
         'Community resilience involves local engagement and education to counter extremist narratives.'),
        ('What is a "no‑fly list"?',
         ARRAY['A list of persons banned from boarding flights due to terrorism links', 'A list of grounded aircraft', 'A list of closed airports', 'A list of cancelled flights'], 0,
         'The no‑fly list is a US government counterterrorism measure.'),
        ('What is "interrogation" in a counterterrorism context?',
         ARRAY['Questioning suspects to gather intelligence', 'Torture (which is illegal)', 'Trial by court', 'Sentencing'], 0,
         'Legal interrogation aims to gain actionable information, while coercive techniques are prohibited.'),
        ('What is "intelligence sharing"?',
         ARRAY['Exchanging information between allied countries or agencies', 'Publicly releasing all intelligence', 'Withholding information from allies', 'Selling intelligence'], 0,
         'Intelligence sharing is critical for international counterterrorism cooperation.'),
        ('What is the US National Counterterrorism Center (NCTC)?',
         ARRAY['A US agency that analyses and integrates all counterterrorism intelligence', 'A military command', 'A domestic police force', 'A cyber agency'], 0,
         'The NCTC serves as the primary US organisation for counterterrorism analysis.')
    ) LOOP
        INSERT INTO questions (category_id, question_text, question_type, explanation)
        VALUES (cat_id_ct, q_rec.column1, 'single_choice', q_rec.column4)
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