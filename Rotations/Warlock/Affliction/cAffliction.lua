--- Affliction Class
-- Inherit from: ../cCharacter.lua and ../cWarlock.lua
-- All Warlock specs inherit from cWarlock.lua
if select(3, UnitClass("player")) == 9 and GetSpecialization() == 1 then
cAffliction = {}

-- Creates Shadow Priest
function cAffliction:new()
	local self = cWarlock:new("Affliction")

	local player = "player" -- if someone forgets ""

    self.rotations = {
        "ragnar",
        "leveling",
    }
	-- __      __                              _   _______    _     _           
	-- \ \    / /                             | | |__   __|  | |   | |          
	--  \ \  / /_ _ _ __ ___    __ _ _ __   __| |    | | __ _| |__ | | ___  ___ 
	--   \ \/ / _` | '__/ __|  / _` | '_ \ / _` |    | |/ _` | '_ \| |/ _ \/ __|
	--    \  / (_| | |  \__ \ | (_| | | | | (_| |    | | (_| | |_) | |  __/\__ \
	--     \/ \__,_|_|  |___/  \__,_|_| |_|\__,_|    |_|\__,_|_.__/|_|\___||___/
	self.enemies = {
		active_enemies_30,
		active_enemies_40,
	}

	--   _____            _ _     
	--  / ____|          | | |    
	-- | (___  _ __   ___| | |___ 
	--  \___ \| '_ \ / _ \ | / __|
	--  ____) | |_) |  __/ | \__ \
	-- |_____/| .__/ \___|_|_|___/
	--        | |                 
	--        |_|                 
	self.afflictionSpell = {
		agony = 980,
		archimondes_darkness = 108505,
		banish = 710,
		blood_horror = 111397,
		burning_rush = 111400,
		cataclysm = 152108,
		command_demon = 119898,
		corruption = 172,
		corruption_debuff = 146739,
		create_healthstone = 6201,
		create_soulwell = 29893,
		dark_bargain = 110913,
		dark_intent = 109773,
		dark_regeneration = 108359,
		dark_soul_misery = 113860,
		demonic_circle_summon = 48018,
		demonic_circle_teleport = 48020,
		demonic_gateway = 111771,
		demonic_servitude = 152107,
		drain_life = 689,
		drain_soul = 103103,
		enslave_demon = 1098,
		eye_of_kilrogg = 126,
		fear = 5782,
		grimoire_of_sacrifice = 108503,
		grimoire_of_supremacy = 108499,
		grimoire_imp = 111859,
		grimoire_voidwalker = 111895,
		grimoire_succubus = 111896,
		grimoire_felhunter = 111897,
		grimoire_doomguard = 157906,
		grimoire_infernal = 157907,
		haunt = 48181,
		health_funnel = 755,
		howl_of_terror = 5484,
		kiljaedens_cunning = 137587,
		life_tap = 1454,
		mannoroths_fury = 108508,
		mortal_coil = 6789,
		ritual_of_summoning = 698,
		sacrificial_pact = 108416,
		seed_of_corruption = 27243,
		shadofury = 30283,
		soul_swap = 86121,
		soulburn = 74434,
		soulburn_haunt = 152109,
		soulburn_seed_of_corruption = 114790,
		soulshatter = 29858,
		soulstone = 20707,
		summon_imp = 688,
		summon_voidwalker = 697,
		summon_felhunter = 691,
		summon_succubus = 712,
		summon_doomguard = 18540,
		summon_infernal = 1122,
		unbound_will = 108482,
		unending_breath = 5697,
		unending_resolve = 104773,
		unstable_affliction = 30108,
	}

	-- --   ____        _   _                 
	-- --  / __ \      | | (_)                
	-- -- | |  | |_ __ | |_ _  ___  _ __  ___ 
	-- -- | |  | | '_ \| __| |/ _ \| '_ \/ __|
	-- -- | |__| | |_) | |_| | (_) | | | \__ \
	-- --  \____/| .__/ \__|_|\___/|_| |_|___/
	-- --        | |                          
	-- --        |_|                          

	-- Merge all spell tables into self.spell
	self.spell = {}
	self.spell = mergeSpellTables(self.spell, self.characterSpell, self.warlockSpell, self.afflictionSpell)


	--  _    _           _       _       
	-- | |  | |         | |     | |      
	-- | |  | |_ __   __| | __ _| |_ ___ 
	-- | |  | | '_ \ / _` |/ _` | __/ _ \
	-- | |__| | |_) | (_| | (_| | ||  __/
	--  \____/| .__/ \__,_|\__,_|\__\___|
	--        | |                        
	--        |_|                        
	function self.update()
		self.classUpdate()
		self.getBuffs()
		self.getCooldowns()
		self.getDynamicUnits()
		self.getEnemies()
		self.getOptions()
		self.getRotation()

		-- orbs
		self.shards = UnitPower("player", SPELL_POWER_SOUL_SHARDS)

		-- Boss detection		
		self.BossDetection()

		if lastHauntTime == nil then lastHauntTime=GetTime()-10 end
		if lastHauntTarget == nil then lastHauntTarget="0" end
		
		-- if not (select(1,UnitChannelInfo("player")) ~= "Insanity" and select(1,UnitChannelInfo("player")) ~= "Mind Flay") then
		-- 	if select(2,GetSpellCooldown(61304))>0 then
		-- 		print("pause")
		-- 		return
		-- 	end
		-- end

		if select(2,GetSpellCooldown(61304))>0 then
			return false
		end

		--if select(2,GetSpellCooldown(61304))>0 then return end

		-- Start selected rotation
		self:startRotation()
	end


	--   ____   ____   _____   _    _           _       _       
	--  / __ \ / __ \ / ____| | |  | |         | |     | |      
	-- | |  | | |  | | |      | |  | |_ __   __| | __ _| |_ ___ 
	-- | |  | | |  | | |      | |  | | '_ \ / _` |/ _` | __/ _ \
	-- | |__| | |__| | |____  | |__| | |_) | (_| | (_| | ||  __/
	--  \____/ \____/ \_____|  \____/| .__/ \__,_|\__,_|\__\___|
	--                               | |                        
	--                               |_|                        
	function self.updateOOC()
		-- Call classUpdateOOC()
		self.classUpdateOOC()

		self.getGlyphs()
		self.getTalents()

		self.BossDetection()


		-- Setup Queues
		if _Queues == nil or #_Queues <= 0 then
			--if _Queues[120644] == nil then
				_Queues = {
					[120644]  = false,		-- Halo
					[127632] = 	false,		-- Cascade
					[2944] = 	false,		-- Devouring Plague
					[34433] = 	false,		-- Shadowfiend
					[123040] = 	false,		-- Mindbender
					[47585] = 	false, 		-- Dispersion
				}
			--end
		end
	end

	--[[                                                                                                                                            ]]

	--  ____                      _      _            _   _             
	-- |  _ \                    | |    | |          | | (_)            
	-- | |_) | ___  ___ ___    __| | ___| |_ ___  ___| |_ _  ___  _ __  
	-- |  _ < / _ \/ __/ __|  / _` |/ _ \ __/ _ \/ __| __| |/ _ \| '_ \ 
	-- | |_) | (_) \__ \__ \ | (_| |  __/ ||  __/ (__| |_| | (_) | | | |
	-- |____/ \___/|___/___/  \__,_|\___|\__\___|\___|\__|_|\___/|_| |_|
	function self.BossDetection()
		-- not infight: reset current boss
		if UnitAffectingCombat("player")==false then
			currentBoss = "noBoss"
		end
		-- infight: detect boss
		if UnitAffectingCombat("player") then
			if currentBoss=="noBoss" or currentBoss==nil then
				if UnitName("boss1")==nil then 
					currentBoss="noBoss"
				else currentBoss=UnitName("boss1") 
				end
			end
		end
	end

	--   ____        _   _                   _        _     _      
	--  / __ \      | | (_)                 | |      | |   | |     
	-- | |  | |_ __ | |_ _  ___  _ __  ___  | |_ __ _| |__ | | ___ 
	-- | |  | | '_ \| __| |/ _ \| '_ \/ __| | __/ _` | '_ \| |/ _ \
	-- | |__| | |_) | |_| | (_) | | | \__ \ | || (_| | |_) | |  __/
	--  \____/| .__/ \__|_|\___/|_| |_|___/  \__\__,_|_.__/|_|\___|
	--        | |                                                  
	--        |_|
    function self.createToggles()
    end

    function self.createOptions()
        bb.profile_window = createNewProfileWindow("Affliction")

        self.createClassOptions()

        local section

        if self.rotation == 1 then
            section = createNewSection(bb.profile_window, "NYI", "No options here.")
        elseif self.rotation == 2 then
            section = createNewSection(bb.profile_window, "NYI", "No options here.")
        end

        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, self.rotations)
        bb:checkProfileWindowStatus()
    end

	function self.getOptions()
		local getValue,isChecked = getValue,isChecked

		-- self.options.cooldowns 							= {}
		-- self.options.cooldowns.isBoss 					= isChecked("isBoss")
		-- self.options.cooldowns.PI 						= isChecked("PI")
		-- self.options.cooldowns.Mindbender 				= isChecked("MB/SF")
		
		-- self.options.defensive 							= {}
		-- self.options.defensive.PWS 						= isChecked("PW:S")
		-- self.options.defensive.PWSvalue 				= getValue("PW:S")
		-- self.options.defensive.Desperate_Prayer 		= isChecked("Desperate Prayer")
		-- self.options.defensive.Desperate_Prayervalue 	= getValue("Desperate Prayer")
		-- self.options.defensive.Fade 					= isChecked("Fade")
		-- self.options.defensive.Fadevalue 				= getValue("Fade")
		-- self.options.defensive.Healing_Tonic 			= isChecked("Healing Tonic")
		-- self.options.defensive.Healing_Tonicvalue 		= getValue("Healing Tonic")
		-- self.options.defensive.Dispersion 				= isChecked("Dispersion")
		-- self.options.defensive.Dispersionvalue 			= getValue("Dispersion")
		
		-- self.options.rotation 							= {}
		-- self.options.rotation.Burst_SI 					= isChecked("Burst SI")
		-- self.options.rotation.SWD_ignore_orbs			= isChecked("SWD ignore Orbs")
		-- self.options.rotation.max_Targetsvalue			= getValue("max dot targets")

		-- self.options.utilities 							= {}
		-- self.options.utilities.pause 					= isChecked("Pause Toggle")
	end

	--  ____         __  __     
	-- |  _ \       / _|/ _|    
	-- | |_) |_   _| |_| |_ ___ 
	-- |  _ <| | | |  _|  _/ __|
	-- | |_) | |_| | | | | \__ \
	-- |____/ \__,_|_| |_| |___/
	function self.getBuffs()
		local UnitBuffID = UnitBuffID
		-- self.buff.angelic_feather 		= UnitBuffID("player",self.spell.angelic_feather_buff) ~=nil or false
		-- self.buff.insanity 				= UnitBuffID("player",self.spell.insanity) ~=nil or false
		-- self.buff.surge_of_darkness 	= UnitBuffID("player",self.spell.surge_of_darkness) ~=nil or false
		-- self.buff.mental_instinct 		= UnitBuffID("player",167254) ~=nil or false
		-- self.buff.premonition 			= UnitBuffID("player",188779) ~=nil or false

		self.getBuffsRemain()
	end

	function self.getBuffsRemain()
		local getBuffRemain = getBuffRemain
		self.buff.remain 					= {}
		-- self.buff.remain.angelic_feather 	= getBuffRemain("player",self.spell.angelic_feather_buff) or 0
		-- self.buff.remain.insanity 			= getBuffRemain("player",self.spell.insanity) or 0
		-- self.buff.remain.surge_of_darkness 	= getBuffRemain("player",self.spell.surge_of_darkness) or 0
		-- self.buff.remain.mental_instinct 	= getBuffRemain("player",167254) or 0
		-- self.buff.remain.premonition 		= getBuffRemain("player",188779) or 0
	end

	--   _____            _     _                         
	--  / ____|          | |   | |                        
	-- | |     ___   ___ | | __| | _____      ___ __  ___ 
	-- | |    / _ \ / _ \| |/ _` |/ _ \ \ /\ / / '_ \/ __|
	-- | |___| (_) | (_) | | (_| | (_) \ V  V /| | | \__ \
	--  \_____\___/ \___/|_|\__,_|\___/ \_/\_/ |_| |_|___/
	function self.getCooldowns()
		local getSpellCD = getSpellCD
		-- self.cd.mind_blast  		= getSpellCD(self.spell.mind_blast)
		-- self.cd.shadow_word_death 	= getSpellCD(self.spell.shadow_word_death)
		-- self.cd.mindbender 			= getSpellCD(self.spell.mindbender)
		-- self.cd.shadowfiend 		= getSpellCD(self.spell.shadowfiend)
		-- self.cd.cascade 			= getSpellCD(self.spell.cascade)
	end

	--   _____ _             _         
	--  / ____| |           | |        
	-- | |  __| |_   _ _ __ | |__  ___ 
	-- | | |_ | | | | | '_ \| '_ \/ __|
	-- | |__| | | |_| | |_) | | | \__ \
	--  \_____|_|\__, | .__/|_| |_|___/
	--            __/ | |              
	--           |___/|_|              
	function self.getGlyphs()
		local hasGlyph = hasGlyph
		-- self.glyph.fade 	= hasGlyph(55684)
		-- self.glyph.pws 		= hasGlyph(263)
	end

	--  _______    _            _       
	-- |__   __|  | |          | |      
	--    | | __ _| | ___ _ __ | |_ ___ 
	--    | |/ _` | |/ _ \ '_ \| __/ __|
	--    | | (_| | |  __/ | | | |_\__ \
	--    |_|\__,_|_|\___|_| |_|\__|___/
	function self.getTalents()
		local isKnown = isKnown
		-- self.talent.desperate_prayer 	= getTalent(1,1)
		-- self.talent.spectral_guise 		= getTalent(1,2)
		-- self.talent.body_and_soul 		= getTalent(2,1)
		-- self.talent.angelic_feather 	= getTalent(2,2)
		-- self.talent.surge_of_darkness 	= getTalent(3,1)
		-- self.talent.mindbender 			= getTalent(3,2)
		-- self.talent.insanity 			= getTalent(3,3)
		-- self.talent.twist_of_fate 		= getTalent(5,1)
		-- self.talent.power_infusion 		= getTalent(5,2)
		-- self.talent.shadowy_insight 	= getTalent(5,3)
		-- self.talent.cascade 			= getTalent(6,1)
		-- self.talent.divine_star 		= getTalent(6,2)
		-- self.talent.halo 				= getTalent(6,3)
		-- self.talent.clarity_of_power 	= getTalent(7,1)
		-- self.talent.void_entropy 		= getTalent(7,2)
		-- self.talent.auspicious_spirits 	= getTalent(7,3)
	end

	--   _____      _      _____      _           _           _    _____ _____  
	--  / ____|    | |    / ____|    | |         | |         | |  / ____|  __ \ 
	-- | |  __  ___| |_  | (___   ___| | ___  ___| |_ ___  __| | | |    | |__) |
	-- | | |_ |/ _ \ __|  \___ \ / _ \ |/ _ \/ __| __/ _ \/ _` | | |    |  _  / 
	-- | |__| |  __/ |_   ____) |  __/ |  __/ (__| ||  __/ (_| | | |____| | \ \ 
	--  \_____|\___|\__| |_____/ \___|_|\___|\___|\__\___|\__,_|  \_____|_|  \_\
	--function self.getRotation()
	--	self.rotation = getValue("Rotation")
	--end

	--  _____                              _        _    _       _ _       
	-- |  __ \                            (_)      | |  | |     (_) |      
	-- | |  | |_   _ _ __   __ _ _ __ ___  _  ___  | |  | |_ __  _| |_ ___ 
	-- | |  | | | | | '_ \ / _` | '_ ` _ \| |/ __| | |  | | '_ \| | __/ __|
	-- | |__| | |_| | | | | (_| | | | | | | | (__  | |__| | | | | | |_\__ \
	-- |_____/ \__, |_| |_|\__,_|_| |_| |_|_|\___|  \____/|_| |_|_|\__|___/
	--          __/ |                                                      
	--         |___/                                                       
	function self.getDynamicUnits()
	end

	--  ______                      _           
	-- |  ____|                    (_)          
	-- | |__   _ __   ___ _ __ ___  _  ___  ___ 
	-- |  __| | '_ \ / _ \ '_ ` _ \| |/ _ \/ __|
	-- | |____| | | |  __/ | | | | | |  __/\__ \
	-- |______|_| |_|\___|_| |_| |_|_|\___||___/
	function self.getEnemies()
		local getEnemies = getEnemies

		self.enemies.active_enemies_30 = #getEnemies("player",30)
		self.enemies.active_enemies_40 = #getEnemies("player",40)
	end

	--  _____     _______  
	-- |  __ \   |__   __| 
	-- | |  | | ___ | |___ 
	-- | |  | |/ _ \| / __|
	-- | |__| | (_) | \__ \
	-- |_____/ \___/|_|___/ 
	-- count running dots
		-- agony
		function self.getAgonyRunning()
			local counter = 0
			-- iterate units for Agony
			for i=1,#enemiesTable do
				local thisUnit = enemiesTable[i].unit
				-- increase counter for each Agony
				if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,self.spell.shadow_word_pain,"player") then
					counter=counter+1
				end
			end
			-- return counter
			return counter
		end
		-- corruption
		function self.getCorruptionRunning()
			local counter = 0
			-- iterate units for Corruption
			for i=1,#enemiesTable do
				local thisUnit = enemiesTable[i].unit
				-- increase counter for each Corruption
				if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,self.spell.vampiric_touch,"player") then
					counter=counter+1
				end
			end
			-- return counter
			return counter
		end
		-- unstable affliction
		function self.getUnstableAfflictionRunning()
			local counter = 0
			-- iterate units for UnstableAffliction
			for i=1,#enemiesTable do
				local thisUnit = enemiesTable[i].unit
				-- increase counter for each UnstableAffliction
				if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,self.spell.vampiric_touch,"player") then
					counter=counter+1
				end
			end
			-- return counter
			return counter
		end

	-- Blacklist
		-- Agony
		function self.Agony_allowed(targetUnit)
			if targetUnit == nil or not UnitExists(targetUnit) then 
				return true 
			end
			
			local thisUnit = targetUnit
			local thisUnitID = getUnitID(thisUnit)
			local Blacklist_UnitID = {
			-- HM: Highmaul
				79956,		-- Ko'ragh: Volatile Anomaly
				78077,		-- Mar'gok: Volatile Anomaly
			-- BRF: Blackrock Foundry
				77128,		-- Darmac: Pack Beast
				77394,		-- Thogar: Iron Raider (Train Ads)
				77893,		-- Kromog: Grasping Earth (Hands)
				77665,		-- Blackhand: Iron Soldier
			-- HFC: Hellfire Citadel
				90114,		-- Hellfire Assault: damn small ads
				94326,		-- Iron Reaver: Reactive Bomb
				90513,		-- Kilrogg: Fel Blood Globule
				96077,		-- Kilrogg: Fel Blood Globule
				90477,		-- Kilrogg: Blood Globule
				93288,		-- Gorefiend: Corrupted Players
				95101,		-- Socrethar: Phase1 Voracious Soulstalker
				--92919,		-- Zakuun: Mythic dat orb
			}
			local Blacklist_BuffID = {
			-- blackrock foundry
				155176, 	-- Blast Furnace: Primal Elementalist: http://www.wowhead.com/spell=155176/damage-shield
				176141, 	-- Blast Furnace: Slag Elemental: http://www.wowhead.com/spell=176141/hardened-slag
			}

			-- check for buffs
			for i = 1, #Blacklist_BuffID do
				if getBuffRemain(thisUnit,Blacklist_BuffID[i]) > 0 or getDebuffRemain(thisUnit,Blacklist_BuffID[i]) > 0 then return false end
			end
			-- check for unit id
			for i = 1, #Blacklist_UnitID do
				if thisUnitID == Blacklist_UnitID[i] then return false end
			end
			return true
		end

		-- Corruption
		function self.Corruption_allowed(targetUnit)
			if targetUnit == nil or not UnitExists(targetUnit) then 
				return true 
			end

			local thisUnit = targetUnit
			local thisUnitID = getUnitID(thisUnit)
			local Blacklist_UnitID = {
			-- BRF: Blackrock Foundry
				77893,		-- Kromog: Grasping Earth (Hands)
				78981,		-- Thogar: Iron Gunnery Sergeant (canons on trains)
				80654,		-- Blackhand Mythic Siegemakers
				80659,		-- Blackhand Mythic Siegemakers
				80646,		-- Blackhand Mythic Siegemakers
				80660,		-- Blackhand Mythic Siegemakers
			-- HFC: Hellfire Citadel
				--94865,		-- Hellfire Council: Jubei'thos Mirrors
				94231,		-- Xhul'horac: Wild Pyromaniac
				--92208,		-- Archimonde: Doomfire Spirit
				--91938,		-- Socrethar: Haunting Soul
				--90409,		-- Hellfire Assault: Gorebound Felcaster
				93717,		-- Iron Reaver: Volatile Firebomb
				91368,		-- Kormrok: Crushing Hand
				93830,		-- Hellfire Assault: Iron Dragoon
				90114,		-- Hellfire Assault: Iron Dragoon
				93369,		-- Kilrogg: Salivating Bloodthirster
				90521,		-- Kilrogg: Salivating Bloodthirster
				--90388,		-- Gorefiend: Digest Mobs
				93288,		-- Gorefiend: Corrupted Players
				95101,		-- Socrethar: Phase1 Voracious Soulstalker
				91259,		-- Mannoroth: Fel Imp
			}

			local Blacklist_BuffID = {
			}

			-- check for buffs
			for i = 1, #Blacklist_BuffID do
				if getBuffRemain(thisUnit,Blacklist_BuffID[i]) > 0 or getDebuffRemain(thisUnit,Blacklist_BuffID[i]) > 0 then return false end
			end
			-- check for unit id
			for i = 1, #Blacklist_UnitID do
				if thisUnitID == Blacklist_UnitID[i] then return false end
			end
			return true
		end
		-- Unstable Affliction
		function self.Unstable_Affliction_allowed(targetUnit)
			if targetUnit == nil or not UnitExists(targetUnit) then 
				return true 
			end

			local thisUnit = targetUnit
			local thisUnitID = getUnitID(thisUnit)
			local Blacklist_UnitID = {
			-- BRF: Blackrock Foundry
				77893,		-- Kromog: Grasping Earth (Hands)
				78981,		-- Thogar: Iron Gunnery Sergeant (canons on trains)
				80654,		-- Blackhand Mythic Siegemakers
				80659,		-- Blackhand Mythic Siegemakers
				80646,		-- Blackhand Mythic Siegemakers
				80660,		-- Blackhand Mythic Siegemakers
			-- HFC: Hellfire Citadel
				--94865,		-- Hellfire Council: Jubei'thos Mirrors
				94231,		-- Xhul'horac: Wild Pyromaniac
				--92208,		-- Archimonde: Doomfire Spirit
				--91938,		-- Socrethar: Haunting Soul
				--90409,		-- Hellfire Assault: Gorebound Felcaster
				93717,		-- Iron Reaver: Volatile Firebomb
				91368,		-- Kormrok: Crushing Hand
				93830,		-- Hellfire Assault: Iron Dragoon
				90114,		-- Hellfire Assault: Iron Dragoon
				93369,		-- Kilrogg: Salivating Bloodthirster
				90521,		-- Kilrogg: Salivating Bloodthirster
				--90388,		-- Gorefiend: Digest Mobs
				93288,		-- Gorefiend: Corrupted Players
				95101,		-- Socrethar: Phase1 Voracious Soulstalker
				91259,		-- Mannoroth: Fel Imp
			}

			local Blacklist_BuffID = {
			}

			-- check for buffs
			for i = 1, #Blacklist_BuffID do
				if getBuffRemain(thisUnit,Blacklist_BuffID[i]) > 0 or getDebuffRemain(thisUnit,Blacklist_BuffID[i]) > 0 then return false end
			end
			-- check for unit id
			for i = 1, #Blacklist_UnitID do
				if thisUnitID == Blacklist_UnitID[i] then return false end
			end
			return true
		end

		--   _____ _                 _______   _       _        _   
		--  / ____| |               |__   __| (_)     | |      | |  
		-- | |    | | __ _ ___ ___     | |_ __ _ _ __ | | _____| |_ 
		-- | |    | |/ _` / __/ __|    | | '__| | '_ \| |/ / _ \ __|
		-- | |____| | (_| \__ \__ \    | | |  | | | | |   <  __/ |_ 
		--  \_____|_|\__,_|___/___/    |_|_|  |_|_| |_|_|\_\___|\__|
		-- get Class Tinket Version
		function self.getClassTrinket()
			if select(1,GetItemInfo(GetInventoryItemID("player",13))) == "Fragment of the Dark Star" then
				return select(4,GetItemInfo(GetInventoryItemID("player",13)))
			elseif select(1,GetItemInfo(GetInventoryItemID("player",14))) == "Fragment of the Dark Star" then
				return select(4,GetItemInfo(GetInventoryItemID("player",13)))
			else
				return 0
			end
		end
		function self.getDotRuntime(dotNumber)
			if dotNumber < 1 or dotNumber > 3 then return 99 end
			local ilvl = self.getClassTrinket()
			local dot = dotNumber
			local modifier = {
				[705] = 21.41,
				[711] = 22.62,
				[720] = 24.63,
				[726] = 26.03,
				[735] = 28.31,
				[741] = 29.92,
			}
			if dot == 1 then
				return .24*(100-modifier[ilvl])
			elseif dot == 2 then
				return .18*(100-modifier[ilvl])
			elseif dot == 3 then
				return .14*(100-modifier[ilvl])
			end
		end


	--  _____       _        _   _                _____ _             _   
	-- |  __ \     | |      | | (_)              / ____| |           | |  
	-- | |__) |___ | |_ __ _| |_ _  ___  _ __   | (___ | |_ __ _ _ __| |_ 
	-- |  _  // _ \| __/ _` | __| |/ _ \| '_ \   \___ \| __/ _` | '__| __|
	-- | | \ \ (_) | || (_| | |_| | (_) | | | |  ____) | || (_| | |  | |_ 
	-- |_|  \_\___/ \__\__,_|\__|_|\___/|_| |_| |_____/ \__\__,_|_|   \__|
	function self.startRotation()
		if self.inCombat then
			if self.rotation == 1 then
				self:orbituary()
            elseif self.rotation == 2 then
                self:levelingWL()
			else
				ChatOverlay("ERROR: NO ROTATION", 2000)
			end
		end
	end


	--   _____            _ _     
	--  / ____|          | | |    
	-- | (___  _ __   ___| | |___ 
	--  \___ \| '_ \ / _ \ | / __|
	--  ____) | |_) |  __/ | \__ \
	-- |_____/| .__/ \___|_|_|___/
	--        | |                 
	--        |_|                 
		-- agony
		function self.castAgonyAutoApply(maxTargets)
			-- try to apply on target first
			if self.castAgonyOnTarget(maxTargets) then return true end
			-- then apply on others
			if self.getAgonyRunning() < maxTargets then
				for i=1,#enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local hp = enemiesTable[i].hpabs
					local ttd = enemiesTable[i].ttd
					local distance = enemiesTable[i].distance
					local refreshTime = 0.3*getDotRuntime(1)
					-- infight
					if UnitIsTappedByPlayer(thisUnit) then
						-- blacklists: CC, DoT Blacklist
						if not isCCed(thisUnit) and self.Agony_allowed(thisUnit) then
							-- check for running dot and remaining time
							if getDebuffRemain(thisUnit,self.spell.agony,"player") <= refreshTime then
								-- in range?
								if distance < 40 then
									-- TTD or dummy
									if ttd > 16 or isDummy(thisUnit) then
										return castSpell(thisUnit,self.spell.agony,true,false) == true or false
									end
								end
							end
						end
					end
				end
			end
			return false
		end
		function self.castAgonyOnTarget(maxTargets)
			if self.getSWPrunning() < maxTargets then
				local refreshTime = 0.3*getDotRuntime(1)
				-- infight
				if UnitIsTappedByPlayer("target") then
					-- blacklists: CC, DoT Blacklist
					if not isCCed("target") and self.Agony_allowed("target") then
						-- check for running dot and remaining time
						if getDebuffRemain("target",self.spell.agony,"player") <= refreshTime then
							-- in range?
							if getDistance("player","target") < 40 then
								-- TTD or dummy
								if getTTD("target") > 16 or isDummy("target") then
									return castSpell("target",self.spell.agony,true,false) == true or false
								end
							end
						end
					end
				end
			end
			return false
		end
		function self.castAgony(thisTarget)
			return castSpell(thisTarget,self.spell.agony,true,false) == true or false
		end
		-- banish
		-- blood_horror
		function self.castBloodHorror()
			return castSpell("player",self.spell.blood_horror,true,false) == true or false
		end
		-- burning_rush
		function self.castBurningRush(status)
			if status ~= "on" or status ~= "off" then return false end
			if status == "on" then
				if UnitBuffID("player",self.spell.burning_rush) then
					return castSpell("player",self.spell.burning_rush,true,false) == true or false
				end
				return false
			elseif status == "off" then
				if not UnitBuffID("player",self.spell.burning_rush) then
					return castSpell("player",self.spell.burning_rush,true,false) == true or false
				end
				return false
			end
		end
		-- cataclysm
		-- command_demon
		-- corruption
		function self.castCorruptionAutoApply(maxTargets)
			-- try to apply on target first
			if self.castCorruptionOnTarget(maxTargets) then return true end
			-- then apply on others
			if self.getCorruptionRunning() < maxTargets then
				for i=1,#enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local hp = enemiesTable[i].hpabs
					local ttd = enemiesTable[i].ttd
					local distance = enemiesTable[i].distance
					local refreshTime = 0.3*getDotRuntime(2)
					-- infight
					if UnitIsTappedByPlayer(thisUnit) then
						-- blacklists: CC, DoT Blacklist
						if not isCCed(thisUnit) and self.Corruption_allowed(thisUnit) then
							-- check for running dot and remaining time
							if getDebuffRemain(thisUnit,self.spell.corruption,"player") <= refreshTime then
								-- in range?
								if distance < 40 then
									-- TTD or dummy
									if ttd > 12 or isDummy(thisUnit) then
										return castSpell(thisUnit,self.spell.corruption,true,false) == true or false
									end
								end
							end
						end
					end
				end
			end
			return false
		end
		function self.castCorruptionOnTarget(maxTargets)
			if self.getSWPrunning() < maxTargets then
				local refreshTime = 0.3*getDotRuntime(2)
				-- infight
				if UnitIsTappedByPlayer("target") then
					-- blacklists: CC, DoT Blacklist
					if not isCCed("target") and self.Corruption_allowed("target") then
						-- check for running dot and remaining time
						if getDebuffRemain("target",self.spell.corruption,"player") <= refreshTime then
							-- in range?
							if getDistance("player","target") < 40 then
								-- TTD or dummy
								if getTTD("target") > 12 or isDummy("target") then
									return castSpell("target",self.spell.corruption,true,false) == true or false
								end
							end
						end
					end
				end
			end
			return false
		end
		function self.castCorruption(thisTarget)
			return castSpell(thisTarget,self.spell.corruption,true,false) == true or false
		end
		-- create_healthstone
		-- create_soulwell
		-- dark_bargain
		-- dark_intent
		-- dark_regeneration
		-- dark_soul_misery
		-- demonic_circle_summon
		-- demonic_circle_teleport
		-- demonic_gateway
		-- demonic_servitude
		-- drain_life
		-- drain_soul
		-- enslave_demon
		-- eye_of_kilrogg
		-- fear
		-- grimoire_of_sacrifice
		-- grimoire_of_supremacy
		-- grimoire_imp
		-- grimoire_voidwalker
		-- grimoire_succubus
		-- grimoire_felhunter
		-- grimoire_doomguard
		-- grimoire_infernal
		-- haunt
		function self.castHaunt(thisTarget)
			return castSpell(thisTarget,self.spell.haunt,false,true) == true or false
		end
		-- health_funnel
		-- howl_of_terror
		-- kiljaedens_cunning
		-- life_tap
		-- mannoroths_fury
		-- mortal_coil
		-- ritual_of_summoning
		-- sacrificial_pact
		-- seed_of_corruption
		-- shadofury
		-- soul_swap
		-- soulburn
		-- soulburn_haunt
		-- soulshatter
		-- soulstone
		-- summon_imp
		-- summon_voidwalker
		-- summon_felhunter
		-- summon_succubus
		-- summon_doomguard
		-- summon_infernal
		-- unbound_will
		-- unending_breath
		-- unending_resolve
		-- unstable_affliction
		function self.castUnstableAfflictionAutoApply(maxTargets)
			-- try to apply on target first
			if self.castUnstableAfflictionOnTarget(maxTargets) then return true end
			-- then apply on others
			if self.getUnstableAfflictionRunning() < maxTargets then
				for i=1,#enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local hp = enemiesTable[i].hpabs
					local ttd = enemiesTable[i].ttd
					local distance = enemiesTable[i].distance
					local refreshTime = 0.3*getDotRuntime(3)
					-- infight
					if UnitIsTappedByPlayer(thisUnit) then
						-- blacklists: CC, DoT Blacklist
						if not isCCed(thisUnit) and self.UnstableAffliction_allowed(thisUnit) then
							-- check for running dot and remaining time
							if getDebuffRemain(thisUnit,self.spell.unstable_affliction,"player") <= refreshTime then
								-- in range?
								if distance < 40 then
									-- TTD or dummy
									if ttd > 10 or isDummy(thisUnit) then
										return castSpell(thisUnit,self.spell.unstable_affliction,true,true) == true or false
									end
								end
							end
						end
					end
				end
			end
			return false
		end
		function self.castUnstableAfflictionOnTarget(maxTargets)
			if self.getSWPrunning() < maxTargets then
				local refreshTime = 0.3*getDotRuntime(3)
				-- infight
				if UnitIsTappedByPlayer("target") then
					-- blacklists: CC, DoT Blacklist
					if not isCCed("target") and self.UnstableAffliction_allowed("target") then
						-- check for running dot and remaining time
						if getDebuffRemain("target",self.spell.unstable_affliction,"player") <= refreshTime then
							-- in range?
							if getDistance("player","target") < 40 then
								-- TTD or dummy
								if getTTD("target") > 10 or isDummy("target") then
									return castSpell("target",self.spell.unstable_affliction,true,true) == true or false
								end
							end
						end
					end
				end
			end
			return false
		end
		function self.castUnstableAffliction(thisTarget)
			return castSpell(thisTarget,self.spell.unstable_affliction,true,true) == true or false
		end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

    self.createOptions()
    self.createToggles()

	-- Return
	return self

	end
end