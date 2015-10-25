--- Shadow Class
-- Inherit from: ../cCharacter.lua and ../cPriest.lua
-- All Priest specs inherit from cPriest.lua
if select(3, UnitClass("player")) == 5 and GetSpecialization() == 3 then
cShadow = {}

-- Creates Shadow Priest
function cShadow:new()
	local self = cPriest:new("Shadow")

	local player = "player" -- if someone forgets ""

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
	self.AS = {
		flying = 0,
		nextImpactTime = 99,
		nextImpactTwoSeconds = 99,
	}

	--   _____            _ _     
	--  / ____|          | | |    
	-- | (___  _ __   ___| | |___ 
	--  \___ \| '_ \ / _ \ | / __|
	--  ____) | |_) |  __/ | \__ \
	-- |_____/| .__/ \___|_|_|___/
	--        | |                 
	--        |_|                 
	self.shadowSpell = {
		angelic_feather = 121536,
		angelic_feather_buff = 121557,
		cascade = 127632,
		desperate_prayer = 19236,
		devouring_plague = 2944,
		dispel_magic = 523,
		dispersion = 47585,
		divine_star = 122121,
		dominate_mind = 605,
		fade = 586,
		fear_ward = 6346,
		flash_heal = 2061,
		halo = 120644,
		insanity = 132573,
		leap_of_faith = 73325,
		levitate = 1706,
		mass_dispel = 32375,
		mindbender = 123040,
		mind_blast = 8092,
		mind_flay = 15407,
		mind_sear = 48045,
		mind_spike = 73510,
		mind_vision = 2096,
		power_infusion = 10060,
		power_word_fortitude = 21562,
		power_word_shield = 17,
		prayer_of_mending = 33076,
		psychic_horror = 64044,
		resurrection = 2006,
		shackle_undead = 9484,
		shadow_word_death = 32379,
		shadow_word_pain = 589,
		shadowfiend = 34433,
		shadowform = 15473,
		silence = 15487,
		surge_of_darkness = 87160,
		spectral_guise = 112833,
		vampiric_embrace = 15286,
		vampiric_touch = 34914,
		void_entropy = 155361,
		-- T18
		mental_fatigue = 184915,
	}

	-- --   ____        _   _                 
	-- --  / __ \      | | (_)                
	-- -- | |  | |_ __ | |_ _  ___  _ __  ___ 
	-- -- | |  | | '_ \| __| |/ _ \| '_ \/ __|
	-- -- | |__| | |_) | |_| | (_) | | | \__ \
	-- --  \____/| .__/ \__|_|\___/|_| |_|___/
	-- --        | |                          
	-- --        |_|                          
	-- self.options = {
	-- 	offensive = {
	-- 		isBoss 	= 			{enabled=isChecked("isBoss")},
	-- 		power_infusion = 	{enabled=isChecked("Power Infusion")},
	-- 		berserking = 		{enabled=isChecked("Berserking")},
	-- 		shadowfiend = 		{enabled=isChecked("Shadowfiend/Mindbender")},
	-- 		trinket1 = 			{enabled=isChecked("Trinket 1")},
	-- 		trinket2 = 			{enabled=isChecked("Trinket 2")},
	-- 		scanToF = 			{enabled=isChecked("Scan for ToF")},
	-- 	},
	-- 	defensive = {
	-- 		pws = 				{enabled=isChecked("PW: Shield"),value=getValue("PW: Shield"),},
	-- 		healing_tonic = 	{enabled=isChecked("Healing Tonic"),value=getValue("Healing Tonic"),},
	-- 		desperate_prayer = 	{enabled=isChecked("Desperate Prayer"),value=getValue("Desperate Prayer"),},
	-- 		dispersion = 		{enabled=isChecked("Dispersion"),value=getValue("Dispersion"),},
	-- 		fade_glyph = 		{enabled=isChecked("Fade Glyph"),value=getValue("Fade Glyph"),},
	-- 		fade_aggro = 		{enabled=isChecked("Fade Aggro")},
	-- 	},
	-- 	bosshelper = {
	-- 		guise = 			{enabled=isChecked("Auto Guise")},
	-- 		mass_dispel = 		{enabled=isChecked("Auto Mass Dispel")},
	-- 		dispel = 			{enabled=isChecked("Auto Dispel")},
	-- 		silence = 			{enabled=isChecked("Auto Silence")},
	-- 		target = 			{enabled=isChecked("Target Helper")},
	-- 		gorefiendSWP = 		{enabled=isChecked("Gorefiend SWP")},
	-- 	},
	-- 	rotation = {
	-- 		dot_weave = 		{enabled=isChecked("DoTWeave")},
	-- 		swd_ignore = 		{enabled=isChecked("SWD ignore Orbs")},
	-- 		min_health = 		{enabled=isChecked("Min Health"),value=getValue("Min Health")*1000000,},
	-- 		max_targets = 		{enabled=isChecked("Max Targets"),value=getValue("Max Targets"),},
	-- 		dp_on_orbs = 		{enabled=isChecked("DP on Orbs"),value=getValue("DP on Orbs"),},
	-- 		ms_targets = 		{enabled=isChecked("MS Targets"),value=getValue("MS Targets"),},
	-- 		msi_key = 			{enabled=isChecked("MSinsanity Key")},
	-- 		msi_burst = 		{enabled=isChecked("Burst MSi")},
	-- 	},
	-- 	utilities = {
	-- 		pause = 			{enabled=isChecked("Pause Toggle")},
	-- 		pwf = 				{enabled=isChecked("PW: Fortitude")},
	-- 		dps_test = 			{enabled=isChecked("DPS Testing"),value=getValue("DPS Testing"),},
	-- 		dot_farm = 			{enabled=isChecked("Dot Farm")},
	-- 	},
	-- }

	-- Merge all spell tables into self.spell
	self.spell = {}
	self.spell = mergeSpellTables(self.spell, self.characterSpell, self.priestSpell, self.shadowSpell)


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
		--self.getRotation()

		-- shadowform
		self.shadowform = GetShapeshiftForm() == 1

		-- orbs
		self.orbs = UnitPower("player", SPELL_POWER_SHADOW_ORBS)

		-- AS Update
		self.ASUpdate()

		-- Boss detection		
		self.BossDetection()

		if lastVTTime == nil then lastVTTime=GetTime()-10 end
		if lastVTTarget == nil then lastVTTarget="0" end
		
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

		-- -- SWP Farmer
		-- self.castSWPFarm()

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

		-- to do ooc
		if not IsMounted("player") and IsMovingTime(0.2) and self.mode.feather == 2 then 
			self.castAngelicFeatherOnMe() 
		end
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
	function self.getOptions()
		local getValue,isChecked = getValue,isChecked

		self.options.cooldowns 							= {}
		self.options.cooldowns.isBoss 					= isChecked("isBoss")
		self.options.cooldowns.PI 						= isChecked("PI")
		self.options.cooldowns.Mindbender 				= isChecked("MB/SF")
		
		self.options.defensive 							= {}
		self.options.defensive.PWS 						= isChecked("PW:S")
		self.options.defensive.PWSvalue 				= getValue("PW:S")
		self.options.defensive.Desperate_Prayer 		= isChecked("Desperate Prayer")
		self.options.defensive.Desperate_Prayervalue 	= getValue("Desperate Prayer")
		self.options.defensive.Fade 					= isChecked("Fade")
		self.options.defensive.Fadevalue 				= getValue("Fade")
		self.options.defensive.Healing_Tonic 			= isChecked("Healing Tonic")
		self.options.defensive.Healing_Tonicvalue 		= getValue("Healing Tonic")
		self.options.defensive.Dispersion 				= isChecked("Dispersion")
		self.options.defensive.Dispersionvalue 			= getValue("Dispersion")

		-- self.options.bosshelper 						= {}
		-- self.options.bosshelper.Guise					= isChecked("")
		-- self.options.bosshelper.Mass_Dispel				= isChecked("")
		-- self.options.bosshelper.Dispel					= isChecked("")
		-- self.options.bosshelper.Silence 				= isChecked("")
		-- self.options.bosshelper.Target 					= isChecked("")
		-- self.options.bosshelper.Gorefiend				= isChecked("")
		
		self.options.rotation 							= {}
		self.options.rotation.Burst_SI 					= isChecked("Burst SI")
		self.options.rotation.SWD_ignore_orbs			= isChecked("SWD ignore Orbs")
		self.options.rotation.max_Targetsvalue			= getValue("max dot targets")
		self.options.rotation.ttdSWP 					= getValue("ttd swp")
		self.options.rotation.ttdVT 					= getValue("ttd vt")
		self.options.rotation.Auto_Focus 				= isChecked("AutoFocus")
		self.options.rotation.Auto_Burn					= isChecked("AutoBurn")

		self.options.utilities 							= {}
		self.options.utilities.pause 					= isChecked("Pause Toggle")
	end

	--  ____         __  __     
	-- |  _ \       / _|/ _|    
	-- | |_) |_   _| |_| |_ ___ 
	-- |  _ <| | | |  _|  _/ __|
	-- | |_) | |_| | | | | \__ \
	-- |____/ \__,_|_| |_| |___/
	function self.getBuffs()
		local UnitBuffID = UnitBuffID
		self.buff.angelic_feather 		= UnitBuffID("player",self.spell.angelic_feather_buff) ~=nil or false
		self.buff.insanity 				= UnitBuffID("player",self.spell.insanity) ~=nil or false
		self.buff.surge_of_darkness 	= UnitBuffID("player",self.spell.surge_of_darkness) ~=nil or false
		self.buff.mental_instinct 		= UnitBuffID("player",167254) ~=nil or false
		self.buff.premonition 			= UnitBuffID("player",188779) ~=nil or false

		self.getBuffsRemain()
	end

	function self.getBuffsRemain()
		local getBuffRemain = getBuffRemain
		self.buff.remain 					= {}
		self.buff.remain.angelic_feather 	= getBuffRemain("player",self.spell.angelic_feather_buff) or 0
		self.buff.remain.insanity 			= getBuffRemain("player",self.spell.insanity) or 0
		self.buff.remain.surge_of_darkness 	= getBuffRemain("player",self.spell.surge_of_darkness) or 0
		self.buff.remain.mental_instinct 	= getBuffRemain("player",167254) or 0
		self.buff.remain.premonition 		= getBuffRemain("player",188779) or 0
	end

	--   _____            _     _                         
	--  / ____|          | |   | |                        
	-- | |     ___   ___ | | __| | _____      ___ __  ___ 
	-- | |    / _ \ / _ \| |/ _` |/ _ \ \ /\ / / '_ \/ __|
	-- | |___| (_) | (_) | | (_| | (_) \ V  V /| | | \__ \
	--  \_____\___/ \___/|_|\__,_|\___/ \_/\_/ |_| |_|___/
	function self.getCooldowns()
		local getSpellCD = getSpellCD
		self.cd.mind_blast  		= getSpellCD(self.spell.mind_blast)
		self.cd.shadow_word_death 	= getSpellCD(self.spell.shadow_word_death)
		self.cd.mindbender 			= getSpellCD(self.spell.mindbender)
		self.cd.shadowfiend 		= getSpellCD(self.spell.shadowfiend)
		self.cd.cascade 			= getSpellCD(self.spell.cascade)
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
		self.glyph.fade 	= hasGlyph(55684)
		self.glyph.pws 		= hasGlyph(263)
	end

	--  _______    _            _       
	-- |__   __|  | |          | |      
	--    | | __ _| | ___ _ __ | |_ ___ 
	--    | |/ _` | |/ _ \ '_ \| __/ __|
	--    | | (_| | |  __/ | | | |_\__ \
	--    |_|\__,_|_|\___|_| |_|\__|___/
	function self.getTalents()
		local isKnown = isKnown
		self.talent.desperate_prayer 	= getTalent(1,1)
		self.talent.spectral_guise 		= getTalent(1,2)
		self.talent.body_and_soul 		= getTalent(2,1)
		self.talent.angelic_feather 	= getTalent(2,2)
		self.talent.surge_of_darkness 	= getTalent(3,1)
		self.talent.mindbender 			= getTalent(3,2)
		self.talent.insanity 			= getTalent(3,3)
		self.talent.twist_of_fate 		= getTalent(5,1)
		self.talent.power_infusion 		= getTalent(5,2)
		self.talent.shadowy_insight 	= getTalent(5,3)
		self.talent.cascade 			= getTalent(6,1)
		self.talent.divine_star 		= getTalent(6,2)
		self.talent.halo 				= getTalent(6,3)
		self.talent.clarity_of_power 	= getTalent(7,1)
		self.talent.void_entropy 		= getTalent(7,2)
		self.talent.auspicious_spirits 	= getTalent(7,3)
	end

	--   _____      _      _____      _           _           _    _____ _____  
	--  / ____|    | |    / ____|    | |         | |         | |  / ____|  __ \ 
	-- | |  __  ___| |_  | (___   ___| | ___  ___| |_ ___  __| | | |    | |__) |
	-- | | |_ |/ _ \ __|  \___ \ / _ \ |/ _ \/ __| __/ _ \/ _` | | |    |  _  / 
	-- | |__| |  __/ |_   ____) |  __/ |  __/ (__| ||  __/ (_| | | |____| | \ \ 
	--  \_____|\___|\__| |_____/ \___|_|\___|\___|\__\___|\__,_|  \_____|_|  \_\
	function self.getRotation()
		self.rotation = getValue("Rotation")
	end

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

	--                          _      _                    _____       _      _ _       
	--     /\                  (_)    (_)                  / ____|     (_)    (_) |      
	--    /  \  _   _ ___ _ __  _  ___ _  ___  _   _ ___  | (___  _ __  _ _ __ _| |_ ___ 
	--   / /\ \| | | / __| '_ \| |/ __| |/ _ \| | | / __|  \___ \| '_ \| | '__| | __/ __|
	--  / ____ \ |_| \__ \ |_) | | (__| | (_) | |_| \__ \  ____) | |_) | | |  | | |_\__ \
	-- /_/    \_\__,_|___/ .__/|_|\___|_|\___/ \__,_|___/ |_____/| .__/|_|_|  |_|\__|___/
	--                   | |                                     | |                     
	--                   |_|                                     |_|                     
	-- AS: update
	function self.ASUpdate()
		if self.talent.auspicious_spirits then
			if conspicuous_spirits_wa then
				self.AS 						= {}
				self.AS.flying 					= self.AS_flying()
				self.AS.nextImpactTime 			= self.AS_next_impact()
				self.AS.nextImpactRemaining 	= self.AS_next_impact_remaining()
				self.AS.nextImpactTwoSeconds 	= self.AS_next_two_seconds()
			end
		end
	end

	-- AS: impact next to seconds
	function self.AS_next_two_seconds()
		--if conspicuous_spirits_wa.timers then
		local counterTwoSeconds = 0
		if conspicuous_spirits_wa.timers[1] then
			local cspTimers = conspicuous_spirits_wa.timers
			local getTime = GetTime()
			for i=1,#cspTimers do
				if cspTimers[i].impactTime <= getTime + 2 then
					counterTwoSeconds = counterTwoSeconds + 1
				end
			end
		end
		return counterTwoSeconds
		--end
	end

	-- AS: time till next impact
	function self.AS_next_impact_remaining()
		if self.AS_next_impact() > GetTime() then
			return self.AS_next_impact() - GetTime()
		else
			return 99
		end
	end
	
	-- AS: next impact
	function self.AS_next_impact()
		--if conspicuous_spirits_wa.timers then
			if conspicuous_spirits_wa.timers[1] then
				return conspicuous_spirits_wa.timers[1].impactTime
			end
		--end
		return 99
	end

	-- AS: AS flying
	function self.AS_flying()
		--if conspicuous_spirits_wa.timers then
			if conspicuous_spirits_wa.timers[1] then
				return #conspicuous_spirits_wa.timers
			end
		--end
		return 0
	end

	function self.getTimeTillNextOrb()
	end

	--  _    _ _   _ _ _ _   _           
	-- | |  | | | (_) (_) | (_)          
	-- | |  | | |_ _| |_| |_ _  ___  ___ 
	-- | |  | | __| | | | __| |/ _ \/ __|
	-- | |__| | |_| | | | |_| |  __/\__ \
	--  \____/ \__|_|_|_|\__|_|\___||___/
	-- auto target
	function self.autotarget()
		-- static blacklist table
		local exceptionTable = {
		-- HFC: Hellfire Citadel
			91326,		-- Mannoroth: Gul'dan
		}
		if not UnitExists("target") or UnitIsDeadOrGhost("target") then
			for i=1, #enemiesTable do
				local thisUnit = enemiesTable[i].unit
				local thisCheck = true
				-- check for blacklist
				for i=1, #exceptionTable do
					if getUnitID(thisUnit) == exceptionTable[i] then 
						thisCheck = false
					end
				end
				-- get unit from enemiesTable
				if thisCheck then
					if enemiesTable[i].distance < 40 then
						if UnitCanAttack("player",thisUnit) then
							TargetUnit(thisUnit)
							if UnitExists("target") then 
								return 
							end
						end
					end
				end
			end
		end
		return false
	end

	-- auto focus
	function self.autofocus()
		if self.talent.clarity_of_power then
			if self.options.rotation.Auto_Focus then
				-- clear focus
				if UnitExists("focus") and UnitExists("target") then
					if UnitGUID("focus") == UnitGUID("target")
					or getDistance("player","focus") >= 40
					or UnitIsDeadOrGhost("focus") then
						ClearFocus()
					end
				end
				-- get focus
				if not UnitExists("focus") then
					-- if UnitExists("boss2") and UnitCanAttack("player","boss2") then
					-- 	FocusUnit("boss2")
					if getNumEnemies("player",40) > 1 then
						FocusUnit(self.getNextBiggestUnit("target",40))
					end
				end
			end
		end
	end

	-- get next biggest unit in range from enemiesTable with exceptions
	function self.getNextBiggestUnit(exceptionUnit,range)
		if not UnitExists(exceptionUnit) or exceptionsUnit == "player" then
			exceptionUnit = "player"
		end

		-- static blacklist table
		local exceptionTable = {
		-- HFC: Hellfire Citadel
			93288,		-- Gorefiend: Corrupted Players
			91326,		-- Mannoroth: Gul'dan
			95101,		-- Socrethar: Phase1 Voracious Soulstalker
		}

		local exceptionGUID = UnitGUID(exceptionUnit)
		for i=1, #enemiesTable do
			local thisUnit = enemiesTable[i].unit
			local thisGUID = enemiesTable[i].guid
			local thisCheck = true
			-- check for blacklist
			for i=1, #exceptionTable do
				if getUnitID(thisUnit) == exceptionTable[i] then 
					thisCheck = false
				end
			end
			-- get the unit from enemiesTable
			if thisCheck then
				if thisGUID ~= exceptionGUID then
					if enemiesTable[i].distance < range then
						if UnitCanAttack("player",thisUnit) then
							return thisUnit
						end
					end
				end
			end
		end
		return false
	end

	function self.BurnRotation()
		if self.options.rotation.Auto_Burn then
			-- SWD
			if self.castSWD("target") then return true end
			-- DP
			if self.orbs>3 then
				if self.castDP("target") then return true end
			end
			-- SWP
			if getDebuffRemain("target",self.spell.shadow_word_pain,"player")<=0 then
				if self.castSWP("target") then return true end
			end
			-- MB
			if self.castMindBlast("target") then return true end
			-- MF
			if self.castMindFlay("target") then return true end
		end
		return false
	end

	--  _____     _______  
	-- |  __ \   |__   __| 
	-- | |  | | ___ | |___ 
	-- | |  | |/ _ \| / __|
	-- | |__| | (_) | \__ \
	-- |_____/ \___/|_|___/ 
	-- count running dots
		-- swp
		function self.getSWPrunning()
			local counter = 0
			-- iterate units for SWP
			for i=1,#enemiesTable do
				local thisUnit = enemiesTable[i].unit
				-- increase counter for each SWP
				if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,self.spell.shadow_word_pain,"player") then
					counter=counter+1
				end
			end
			-- return counter
			return counter
		end
		-- vt
		function self.getVTrunning()
			local counter = 0
			-- iterate units for SWP
			for i=1,#enemiesTable do
				local thisUnit = enemiesTable[i].unit
				-- increase counter for each SWP
				if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,self.spell.vampiric_touch,"player") then
					counter=counter+1
				end
			end
			-- return counter
			return counter
		end

	-- Blacklist
		-- CoP: offdot
		function self.CoP_offdot_allowed(targetUnit)
			if targetUnit == nil or not UnitExists(targetUnit) then 
				return true 
			end
			
			local thisUnit = targetUnit
			local thisUnitID = getUnitID(thisUnit)
			local Blacklist_UnitID = {
			-- HM: Highmaul

			-- BRF: Blackrock Foundry

			-- HFC: Hellfire Citadel
				91331,		-- Archimonde
			}
			local Blacklist_BuffID = {
			-- blackrock foundry
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
		-- SWP
		function self.SWP_allowed(targetUnit)
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
				--94326,		-- Iron Reaver: Reactive Bomb
				90513,		-- Kilrogg: Fel Blood Globule
				96077,		-- Kilrogg: Fel Blood Globule
				90477,		-- Kilrogg: Blood Globule
				93288,		-- Gorefiend: Corrupted Players
				--95101,		-- Socrethar: Phase1 Voracious Soulstalker
				--92919,		-- Zakuun: Mythic dat orb
				92208,		-- Archimonde: Doomfire Spirit
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
		-- VT
		function self.VT_allowed(targetUnit)
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
				92208,		-- Archimonde: Doomfire Spirit
				93616,		-- Archimonde: Dreadstalker
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

	--  _____       _        _   _                _____ _             _   
	-- |  __ \     | |      | | (_)              / ____| |           | |  
	-- | |__) |___ | |_ __ _| |_ _  ___  _ __   | (___ | |_ __ _ _ __| |_ 
	-- |  _  // _ \| __/ _` | __| |/ _ \| '_ \   \___ \| __/ _` | '__| __|
	-- | | \ \ (_) | || (_| | |_| | (_) | | | |  ____) | || (_| | |  | |_ 
	-- |_|  \_\___/ \__\__,_|\__|_|\___/|_| |_| |_____/ \__\__,_|_|   \__|
	function self.startRotation()
		if self.inCombat then
			if self.rotation == 1 then
				self:shadowRavens()
			-- put different rotations below; dont forget to setup your rota in options
			-- elseif self.rotation == 2 then
			-- 	self:shadowSimC()
			else
				ChatOverlay("ERROR: NO ROTATION", 2000)
			end
		end
	end


	-- --[[ Kick Spell ]]
	-- function self.shadowSimpleKick(datUnit,spellname)
	-- 	local thisUnit

	-- 	if datUnit==nil and UnitExists("target") then thisUnit = "target"
	-- 		elseif datUnit then	thisUnit = datUnit
	-- 		else return
	-- 	end

	-- 	if UnitChannelInfo(thisUnit) == spellname or UnitCastingInfo(thisUnit) == spellname then
	-- 		local notInterruptible
	-- 		-- cast remain
	-- 		if UnitChannelInfo(thisUnit) then 
	-- 			cRem = select(6,UnitChannelInfo(thisUnit)) - GetTime()*1000 
	-- 			interruptible = not select(9,UnitChannelInfo(thisUnit))
	-- 		end
	-- 		if UnitCastingInfo(thisUnit) then 
	-- 			cRem = select(6,UnitCastingInfo(thisUnit)) - GetTime()*1000 
	-- 			interruptible = not select(9,UnitCastingInfo(thisUnit))
	-- 		end
	-- 		-- random number
	-- 		local rndRemaining = math.random(200,500)
	-- 		-- kick
	-- 		if cRem <= rndRemaining and interruptible then
	-- 			-- try to kick in melee range
	-- 			if isKnown(ArcT) then
	-- 				if getSpellCD(ArcT) <= 0 and getDistance("player",thisUnit) < 8 then
	-- 					if castArcaneTorrent then return end
	-- 				end
	-- 			end
	-- 			-- if unit is casting after melee try kick it with silence
	-- 			if UnitChannelInfo(thisUnit) or UnitCastingInfo(thisUnit) then
	-- 				if getSpellCD(Silence) <= 0 then
	-- 					if castSilence(thisUnit) then return end
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end



	--   _____            _ _     
	--  / ____|          | | |    
	-- | (___  _ __   ___| | |___ 
	--  \___ \| '_ \ / _ \ | / __|
	--  ____) | |_) |  __/ | \__ \
	-- |_____/| .__/ \___|_|_|___/
	--        | |                 
	--        |_|                 
		-- angelic_feather
		function self.castAngelicFeatherOnMe()
			--if getGround("player") and getBuffRemain("player",121557)<1 then
			if getFallTime() <= 0.5 and not IsSwimming() then
				if getBuffRemain("player",121557)<1 then
					if castGround("player",121536,30) then
						SpellStopTargeting()
						return true
					end
				end
			end
			return false
		end
		-- arcane_torrent
		function self.castArcaneTorrent()
			return castSpell("player",self.spell.arcane_torrent,true,false) == true or false
		end
		-- cascade
		function self.castCascade()
			if self.cd.cascade <= 0 then
				for i=1,#enemiesTable do
					local thisUnit = getBiggestUnitCluster(40,40)
					if UnitExists(thisUnit) and getLineOfSight(thisUnit) then
						return castSpell(thisUnit,self.spell.cascade,true,false) == true or false
					end
				end
			end
			return false
		end
		function self.castCascadeTarget(thisTarget)
			return castSpell(thisTarget,self.spell.cascade,true,false) == true or false
		end
		-- desperate_prayer
		function self.castDesperatePrayer()
			if self.talent.desperate_prayer then
				return castSpell("player",self.spell.desperate_prayer,true,false) == true or false
			end
			return false
		end
		-- devouring_plague
		function self.castDP(thisTarget)
			if self.talent.clarity_of_power and not self.talent.insanity then
				if UnitExists("focus") and UnitCanAttack("player","focus") then
					return castSpell("focus",self.spell.devouring_plague,true,false) == true or false
				end
			end
			return castSpell(thisTarget,self.spell.devouring_plague,true,false) == true or false
		end
		-- dispel_magic
		function self.castDispellMagic(thisTarget)
			return castSpell(thisTarget,self.spell.dispel_magic,true,false) == true or false
		end
		-- dispersion
		function self.castDispersion()
			return castSpell("player",self.spell.dispersion,true,false) == true or false
		end
		-- divine_star
		function self.castDivineStar()
			return castSpell(thisTarget,self.spell.divine_star,false,false) == true or false
		end
		-- dominate_mind
		function self.castDominateMind(thisTarget)
			return castSpell(thisTarget,self.spell.dominate_mind,true,true) == true or false
		end
		-- fade
		function self.castFade()
			return castSpell("player",self.spell.fade,true,false) == true or false
		end
		-- fear_ward
		function self.castFearWard(thisTarget)
			return castSpell(thisTarget,self.spell.fear_ward,true,false) == true or false
		end
		-- flash_heal
		function self.castFlashHeal(thisTarget)
			return castSpell(thisTarget,self.spell.flash_heal,true,true) == true or false
		end
		-- halo
		function self.castHalo()
			return castSpell("player",self.spell.halo,true,false) == true or false
		end
		-- insanity
		-- leap_of_faith
		function self.castLeapOfFaith(thisTarget)
			return castSpell(thisTarget,self.spell.leap_of_faith,true,false) == true or false
		end
		-- levitate
		function self.castLevitate(thisTarget)
			return castSpell(thisTarget,self.spell.levitate,true,false) == true or false
		end
		-- mass_dispel
		-- mindbender
		function self.castMindbender(thisTarget)
			if self.mode.cooldowns == 2 then
				if self.options.cooldowns.Mindbender then
					return castSpell(thisTarget,self.spell.mindbender,true,false) == true or false
				end
			end
			return false
		end
		-- mind_blast
		function self.castMindBlast(thisTarget)
			if self.talent.clarity_of_power then
				return castSpell(thisTarget,self.spell.mind_blast,false,false) == true or false
			else
				return castSpell(thisTarget,self.spell.mind_blast,false,true) == true or false
			end
		end
		-- mind_flay
		function self.castMindFlay(thisTarget)
			return castSpell(thisTarget,self.spell.mind_flay,false,true) == true or false
		end
		-- mind_sear
		function self.castMindSear(thisTarget)
			return castSpell(thisTarget,self.spell.mind_sear,true,true) == true or false
		end
		-- mind_spike
		function self.castMindSpike(thisTarget)
			if self.buff.surge_of_darkness then
				return castSpell(thisTarget,self.spell.mind_spike,false,false) == true or false
			else
				return castSpell(thisTarget,self.spell.mind_spike,false,true) == true or false
			end
		end
		-- mind_vision
		function self.castMindVision(thisTarget)
			return castSpell(thisTarget,self.spell.mind_vision,true,false) == true or false
		end
		-- power_infusion
		function self.castPowerInfusion()
			return castSpell("player",self.spell.power_infusion,true,false) == true or false
		end
		-- power_word_fortitude
		function self.castPower_Word_Fortitude()
			return castSpell("player",self.spell.power_word_fortitude,true,false) == true or false
		end
		-- power_word_shield
		function self.castPWS(thisTarget)
			return castSpell(thisTarget,self.spell.power_word_shield,true,false) == true or false
		end
		-- psychic_horror
		function self.castPsychicHorror(thisTarget)
			return castSpell(thisTarget,self.spell.psychic_horror,true,false) == true or false
		end
		-- resurrection
		function self.castResurrection(thisTarget)
			return castSpell(thisTarget,self.spell.resurrection,true,true) == true or false
		end
		-- shackle_undead
		-- shadow_word_death
		function self.castSWDAuto(thisTarget)
			if self.cd.shadow_word_death <= 0 then
				if self.orbs < 5 or self.options.rotation.SWD_ignore_orbs then
					if GetObjectExists(thisTarget) then
						local thisUnit = thisTarget
						local range = getDistance("player",thisUnit)
						local hp = getHP(thisUnit)
						if hp < 20 and range < 40 then
							return castSpell(thisUnit,self.spell.shadow_word_death,true,false) == true or false
						end
					end
					for i=1,#enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local range = enemiesTable[i].distance
						local hp = enemiesTable[i].hp
						if hp < 20 and range < 40 then
							return castSpell(thisUnit,self.spell.shadow_word_death,true,false,false,false,false,false,true) == true or false
						end
					end
				end
			end
			return false
		end
		function self.castSWD(thisTarget)
			if getHP(thisTarget)<=20 then
				return castSpell(thisTarget,self.spell.shadow_word_death,true,false) == true or false
			end
			return false
		end
		-- shadow_word_pain
		function self.castSWPAutoApply(maxTargets)
			-- try to apply on target first
			if self.castSWPOnTarget(maxTargets) then return true end
			-- then apply on others
			if self.getSWPrunning() < maxTargets then
				for i=1,#enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local hp = enemiesTable[i].hpabs
					local ttd = enemiesTable[i].ttd
					local distance = enemiesTable[i].distance
					-- infight
					if UnitIsTappedByPlayer(thisUnit) then
						-- blacklists: CC, DoT Blacklist
						if not isCCed(thisUnit) and self.SWP_allowed(thisUnit) then
							-- check for running dot and remaining time
							if getDebuffRemain(thisUnit,self.spell.shadow_word_pain,"player") <= 18*0.3 then
								-- in range?
								if distance < 40 then
									-- TTD or dummy
									if ttd > self.options.rotation.ttdSWP or isDummy(thisUnit) then
										return castSpell(thisUnit,self.spell.shadow_word_pain,true,false) == true or false
									end
								end
							end
						end
					end
				end
			end
			return false
		end
		function self.castSWPOnTarget(maxTargets)
			if self.getSWPrunning() < maxTargets then
				-- infight
				if UnitIsTappedByPlayer("target") then
					-- blacklists: CC, DoT Blacklist
					if not isCCed("target") and self.SWP_allowed("target") then
						-- check for running dot and remaining time
						if getDebuffRemain("target",self.spell.shadow_word_pain,"player") <= 18*0.3 then
							-- in range?
							if getDistance("player","target") < 40 then
								-- TTD or dummy
								if getTTD("target") > self.options.rotation.ttdSWP or isDummy("target") then
									return castSpell("target",self.spell.shadow_word_pain,true,false) == true or false
								end
							end
						end
					end
				end
			end
			return false
		end
		function self.castSWPOnUnit(thisTarget)
			if UnitExists(thisTarget) and UnitCanAttack("player",thisTarget) then
			--if self.getSWPrunning() < maxTargets then
				-- infight
				if UnitIsTappedByPlayer(thisTarget) then
					-- blacklists: CC, DoT Blacklist
					if not isCCed(thisTarget) and self.SWP_allowed(thisTarget) and self.CoP_offdot_allowed(thisTarget) then
						-- check for running dot and remaining time
						if getDebuffRemain(thisTarget,self.spell.shadow_word_pain,"player") <= 18*0.3 then
							-- in range?
							if getDistance("player",thisTarget) < 40 then
								-- TTD or dummy
								if getTTD(GetObjectWithGUID(UnitGUID(thisTarget))) > self.options.rotation.ttdSWP or isDummy(thisTarget) then
									return castSpell(thisTarget,self.spell.shadow_word_pain,true,false) == true or false
								end
							end
						end
					end
				end
			end
			return false
		end
		function self.castSWP(thisTarget)
			return castSpell(thisTarget,self.spell.shadow_word_pain,true,false) == true or false
		end
		-- shadowfiend
		function self.castShadowfiend(thisTarget)
			if self.mode.cooldowns == 2 then
				if self.options.cooldowns.Mindbender then
					return castSpell(thisTarget,self.spell.shadowfiend,true,false) == true or false
				end
			end
			return false
		end
		-- shadowform
		function self.castShadowform()
			return castSpell("player",self.spell.shadowform,true,false) == true or false
		end
		-- silence
		function self.castSilence(thisTarget)
			return castSpell(thisTarget,self.spell.silence,true,false) == true or false
		end
		-- spectral_guise
		function self.castSpectralGuise()
			return castSpell("player",self.spell.spectral_guise,true,false) == true or false
		end
		-- vampiric_embrace
		function self.castVampiricEmbrace()
			return castSpell("player",self.spell.vampiric_embrace,true,false) == true or false
		end
		-- vampiric_touch
		function self.castVTAutoApply(maxTargets)
			-- try to apply on target first
			--if self.castVTOnTarget(maxTargets) then return true end
			-- then apply on others
			if self.getVTrunning() < maxTargets then
				for i=1,#enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local thisUnitGUID = enemiesTable[i].guid
					local hp = enemiesTable[i].hpabs
					local ttd = enemiesTable[i].ttd
					local distance = enemiesTable[i].distance
					local castTime = 0.001*select(4,GetSpellInfo(34914))
					local refreshTime = self.options.rotation.ttdSWP+castTime
					-- infight
					if UnitIsTappedByPlayer(thisUnit) then
						-- last VT check
						if lastVTTarget ~= thisUnitGUID or lastVTTime+5 < GetTime() then
							-- blacklists: CC, DoT Blacklist
							if not isCCed(thisUnit) and self.VT_allowed(thisUnit) then
								-- check for running dot and remaining time
								if getDebuffRemain(thisUnit,self.spell.vampiric_touch,"player") <= 15*0.3+castTime then
									-- in range?
									if distance < 40 then
										-- TTD or dummy
										if ttd > refreshTime or isDummy(thisUnit) then
											if castSpell(thisUnit,self.spell.vampiric_touch,true,true) then
												lastVTTarget = thisUnitGUID
												lastVTTime = GetTime()
												return true
											end
										end
									end
								end
							end
						end
					end
				end
			end
			return false
		end
		function self.castVTOnTarget(maxTargets)
			if self.getVTrunning() < maxTargets then
				local castTime = 0.001*select(4,GetSpellInfo(34914))
				-- infight
				if UnitIsTappedByPlayer("target") then
					-- last VT check
					if lastVTTarget ~= thisUnitGUID and lastVTTime+5 < GetTime() then
						-- blacklists: CC, DoT Blacklist
						if not isCCed("target") and self.VT_allowed("target") then
							-- check for running dot and remaining time
							if getDebuffRemain("target",self.spell.vampiric_touch,"player") <= 15*0.3+castTime then
								-- in range?
								if getDistance("player","target") < 40 then
									-- TTD or dummy
									if getTTD("target") > self.options.rotation.ttdSWP+castTime or isDummy("target") then
										return castSpell("target",self.spell.vampiric_touch,true,true) == true or false
									end
								end
							end
						end
					end
				end
			end
			return false
		end
		function self.castVTOnUnit(thisTarget)
			if UnitExists(thisTarget) and UnitCanAttack("player",thisTarget) then
			--if self.getVTrunning() < maxTargets then
				local castTime = 0.001*select(4,GetSpellInfo(34914))
				-- infight
				if UnitIsTappedByPlayer(thisTarget) then
					-- last VT check
					if lastVTTarget ~= thisUnitGUID and lastVTTime+5 < GetTime() then
						-- blacklists: CC, DoT Blacklist
						if not isCCed(thisTarget) and self.VT_allowed(thisTarget) and self.CoP_offdot_allowed(thisTarget) then
							-- check for running dot and remaining time
							if getDebuffRemain(thisTarget,self.spell.vampiric_touch,"player") <= 15*0.3+castTime then
								-- in range?
								if getDistance("player",thisTarget) < 40 then
									-- TTD or dummy
									if getTTD(GetObjectWithGUID(UnitGUID(thisTarget))) > self.options.rotation.ttdSWP+castTime or isDummy(thisTarget) then
										return castSpell(thisTarget,self.spell.vampiric_touch,true,true) == true or false
									end
								end
							end
						end
					end
				end
			end
			return false
		end
		function self.castVT(thisTarget)
			return castSpell(thisTarget,self.spell.vampiric_touch,true,true) == true or false
		end



	-- Return
	return self

	end
end