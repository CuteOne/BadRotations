--- Shadow Class
-- Inherit from: ../cCharacter.lua and ../cPriest.lua
-- All Priest specs inherit from cPriest.lua
if select(3, UnitClass("player")) == 5 and GetSpecialization() == 3 then

cShadow = {}

-- Creates Shadow Priest
function cShadow:new()
	local self = cPriest:new("Shadow")

	local player = "player" -- if someone forgets ""

	self.enemies = {
		active_enemies_30,
		active_enemies_40,
	}

	self.shadowSpell = {
		angelic_feather = 121536,
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

	self.options = {
		offensive = {
			isBoss 	= 			{enabled=isChecked("isBoss")},
			power_infusion = 	{enabled=isChecked("Power Infusion")},
			berserking = 		{enabled=isChecked("Berserking")},
			shadowfiend = 		{enabled=isChecked("Shadowfiend/Mindbender")},
			trinket1 = 			{enabled=isChecked("Trinket 1")},
			trinket2 = 			{enabled=isChecked("Trinket 2")},
			scanToF = 			{enabled=isChecked("Scan for ToF")},
		},
		defensive = {
			pws = 				{enabled=isChecked("PW: Shield"),value=getValue("PW: Shield"),},
			healing_tonic = 	{enabled=isChecked("Healing Tonic"),value=getValue("Healing Tonic"),},
			desperate_prayer = 	{enabled=isChecked("Desperate Prayer"),value=getValue("Desperate Prayer"),},
			dispersion = 		{enabled=isChecked("Dispersion"),value=getValue("Dispersion"),},
			fade_glyph = 		{enabled=isChecked("Fade Glyph"),value=getValue("Fade Glyph"),},
			fade_aggro = 		{enabled=isChecked("Fade Aggro")},
		},
		bosshelper = {
			guise = 			{enabled=isChecked("Auto Guise")},
			mass_dispel = 		{enabled=isChecked("Auto Mass Dispel")},
			dispel = 			{enabled=isChecked("Auto Dispel")},
			silence = 			{enabled=isChecked("Auto Silence")},
			target = 			{enabled=isChecked("Target Helper")},
		},
		rotation = {
			dot_weave = 		{enabled=isChecked("DoTWeave")},
			vt_on_target = 		{enabled=isChecked("VT on Target")},
			swd_ignore = 		{enabled=isChecked("SWD ignore Orbs")},
			min_health = 		{enabled=isChecked("Min Health"),value=getValue("Min Health")*1000000,},
			max_targets = 		{enabled=isChecked("Max Targets"),value=getValue("Max Targets"),},
			dp_on_orbs = 		{enabled=isChecked("DP on Orbs"),value=getValue("DP on Orbs"),},
			ms_targets = 		{enabled=isChecked("MS Targets"),value=getValue("MS Targets"),},
			msi_key = 			{enabled=isChecked("MSinsanity Key")},
			msi_burst = 		{enabled=isChecked("Burst MSi")},
		},
		utilities = {
			pause = 			{enabled=isChecked("Pause Toggle")},
			pwf = 				{enabled=isChecked("PW: Fortitude")},
			dps_test = 			{enabled=isChecked("DPS Testing"),value=getValue("DPS Testing"),},
		},
	}

	self.AS = {
		flying = 0,
		nextImpactTime = 99,
		nextImpactTwoSeconds = 99,
	}

	self.set_bonus = {
		tier17_2pc =  false,
		tier17_4pc =  false,
		tier18_2pc =  false,
		tier18_4pc =  false,
		class_trinket = false,
	}

	-- Merge all spell tables into self.spell
	self.spell = {}
	self.spell = mergeSpellTables(self.spell, self.characterSpell, self.priestSpell, self.shadowSpell)

	-- Update 
	function self.update()
		self.classUpdate()
		self.getBuffs()
		self.getCooldowns()
		self.getDynamicUnits()
		self.getEnemies()
		self.getOptions()
		--self.getRotation()

		-- truth = true, right = false
		self.shadowform = GetShapeshiftForm() == 1

		-- orbs
		self.orbs = UnitPower("player", SPELL_POWER_SHADOW_ORBS)

		-- AS Update
		self.ASUpdate()

		
		self.BossDetection()
		-- Casting and GCD check
		
		

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

	-- Update OOC
	function self.updateOOC()
		-- Call classUpdateOOC()
		self.classUpdateOOC()

		self.getGlyphs()
		self.getTalents()
		self.getEquip()

		-- to do ooc
		if not IsMounted("player") then self.castAngelicFeatherOnMe() end
		self.BossDetection()

		-- raid buff
		if self.options.utilities.pwf.enabled then RaidBuff(2,21562) end

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

	-- Boss detection
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

	-- update options
	function self.getOptions()
		self.options.offensive.isBoss.enabled = 			isChecked("isBoss")
		self.options.offensive.power_infusion.enabled = 	isChecked("Power Infusion")
		self.options.offensive.berserking.enabled = 		isChecked("Berserking")
		self.options.offensive.shadowfiend.enabled = 		isChecked("Shadowfiend/Mindbender")
		self.options.offensive.trinket1.enabled = 			isChecked("Trinket 1")
		self.options.offensive.trinket2.enabled = 			isChecked("Trinket 2")
		self.options.offensive.scanToF.enabled = 			isChecked("Scan for ToF")

		self.options.defensive.pws.enabled = 				isChecked("PW: Shield")
		self.options.defensive.pws.value = 					getValue("PW: Shield")
		self.options.defensive.healing_tonic.enabled = 		isChecked("Healing Tonic")
		self.options.defensive.healing_tonic.value = 		getValue("Healing Tonic")
		self.options.defensive.desperate_prayer.enabled = 	isChecked("Desperate Prayer")
		self.options.defensive.desperate_prayer.value = 	getValue("Desperate Prayer")
		self.options.defensive.dispersion.enabled = 		isChecked("Dispersion")
		self.options.defensive.dispersion.value = 			getValue("Dispersion")
		self.options.defensive.fade_glyph.enabled = 		isChecked("Fade Glyph")
		self.options.defensive.fade_glyph.value = 			getValue("Fade Glyph")
		self.options.defensive.fade_aggro.enabled = 		isChecked("Fade Aggro")

		self.options.bosshelper.guise.enabled = 			isChecked("Auto Guise")
		self.options.bosshelper.mass_dispel.enabled = 		isChecked("Auto Mass Dispel")
		self.options.bosshelper.dispel.enabled = 			isChecked("Auto Dispel")
		self.options.bosshelper.silence.enabled = 			isChecked("Auto Silence")
		self.options.bosshelper.target.enabled = 			isChecked("Target Helper")

		self.options.rotation.dot_weave.enabled = 			isChecked("DoTWeave")
		self.options.rotation.vt_on_target.enabled = 		isChecked("VT on Target")
		self.options.rotation.swd_ignore.enabled = 			isChecked("SWD ignore Orbs")
		self.options.rotation.min_health.enabled = 			isChecked("Min Health")
		self.options.rotation.min_health.value = 			getValue("Min Health")*1000000
		self.options.rotation.max_targets.enabled = 		isChecked("Max Targets")
		self.options.rotation.max_targets.value = 			getValue("Max Targets")
		self.options.rotation.dp_on_orbs.enabled = 			isChecked("DP on Orbs")
		self.options.rotation.dp_on_orbs.value = 			getValue("DP on Orbs")
		self.options.rotation.ms_targets.enabled = 			isChecked("MS Targets")
		self.options.rotation.ms_targets.value = 			getValue("MS Targets")
		self.options.rotation.msi_key .enabled = 			isChecked("MSinsanity Key")
		self.options.rotation.msi_burst.enabled = 			isChecked("Burst MSi")

		self.options.utilities.pause.enabled = 				isChecked("Pause Toggle")
		self.options.utilities.pwf.enabled = 				isChecked("PW: Fortitude")
		self.options.utilities.dps_test.enabled = 			isChecked("DPS Testing")
		self.options.utilities.dps_test.value = 			getValue("DPS Testing")
	end

	-- Update special equip
	function self.getEquip()
		local t17 = TierScan("T17")
		local t18 = TierScan("T18")
		-- T17
		if t17 >= 2 then self.set_bonus.tier17_2pc = true else self.set_bonus.tier17_2pc = false end
		if t17 >= 4 then self.set_bonus.tier17_4pc = true else self.set_bonus.tier17_4pc = false end
		-- T18
		if t18 >= 2 then self.set_bonus.tier18_2pc = true else self.set_bonus.tier18_2pc = false end
		if t18 >= 4 then self.set_bonus.tier18_4pc = true else self.set_bonus.tier18_4pc = false end
		-- T18 class trinket
		if GetInventoryItemID("player",13) == 124519 or GetInventoryItemID("player",14) == 124519 then
			self.set_bonus.class_trinket = true
		end

	end

	-- Buff updates
	function self.getBuffs()
		local getBuffRemain = getBuffRemain

		self.buff.insanity = 			getBuffRemain(player,self.spell.insanity)
		self.buff.surge_of_darkness = 	getBuffRemain(player,self.spell.surge_of_darkness)

		-- T17
		self.buff.mental_instinct = 	getBuffRemain(player,167254)
		-- T18
		self.buff.premonition = 		getBuffRemain(player,188779)
	end

	-- Cooldown updates
	function self.getCooldowns()
		local getSpellCD = getSpellCD

		self.cd.mind_blast  = 		getSpellCD(self.spell.mind_blast)
		self.cd.shadow_word_death = getSpellCD(self.spell.shadow_word_death)
		self.cd.shadowfiend =		getSpellCD(self.spell.shadowfiend)
		self.cd.cascade = 			getSpellCD(self.spell.cascade)
		--self.cd.judgment       = getSpellCD(self.spell.judgment)
		--self.cd.crusaderStrike = getSpellCD(self.spell.crusaderStrike)
		--self.cd.seraphim       = getSpellCD(self.spell.seraphim)
	end

	-- Glyph updates
	function self.getGlyphs()
		local hasGlyph = hasGlyph

		--self.glyph.massExorcism   = hasGlyph(122028)
		self.glyph.fade =	hasGlyph(55684)
		self.glyph.pws =	hasGlyph(263)
	end

	-- Talent updates
	function self.getTalents()
		local getTalent = getTalent

		--self.talent.empoweredSeals = isKnown(self.spell.empoweredSeals)
		self.talent.desperate_prayer = 	getTalent(1,1)
		self.talent.spectral_guise = 	getTalent(1,2)
		self.talent.body_and_soul = 	getTalent(2,1)
		self.talent.angelic_feather =	getTalent(2,2)
		self.talent.surge_of_darkness =	getTalent(3,1)
		self.talent.mindbender = 		getTalent(3,2)
		self.talent.insanity = 			getTalent(3,3)
		self.talent.twist_of_fate = 	getTalent(5,1)
		self.talent.power_infusion = 	getTalent(5,2)
		self.talent.shadowy_insight = 	getTalent(5,3)
		self.talent.cascade = 			getTalent(6,1)
		self.talent.divine_star = 		getTalent(6,2)
		self.talent.halo = 				getTalent(6,3)
		self.talent.clarity_of_power = 	getTalent(7,1)
		self.talent.void_entropy = 		getTalent(7,2)
		self.talent.auspicious_spirits = getTalent(7,3)
	end

	-- Rotation selection update
	function self.getRotation()
		self.rotation = getValue("Rotation")
	end

	-- Update Dynamic units
	function self.getDynamicUnits()
		--local dynamicTarget = dynamicTarget

		-- Normal
		--self.units.dyn8 = dynamicTarget(8,true) -- Divine Storm

		-- AoE
		--self.units.dyn8AoE  = dynamicTarget(8,false) -- Divine Storm
		--self.units.dyn12AoE = dynamicTarget(12,false) -- Divine Storm w/ Final Verdict Buff
	end

	-- Update Number of Enemies around player
	function self.getEnemies()
		local getEnemies = getEnemies

		self.enemies.active_enemies_30 = #getEnemies("player",30)
		self.enemies.active_enemies_40 = #getEnemies("player",40)
	end

	-- AS: update
	function self.ASUpdate()
		if conspicuous_spirits_wa then
			self.AS.flying = self.AS_flying()
			self.AS.nextImpactTime = self.AS_next_impact()
			self.AS.nextImpactRemaining = self.AS_next_impact_remaining()
			self.AS.nextImpactTwoSeconds = self.AS_next_two_seconds()
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
				local impactTime = conspicuous_spirits_wa.timers[1].impactTime
				return impactTime
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

	-- Updates Judgment recharge time (cooldown)
	function self.getTimeTillNextOrb()
		-- local GetSpellCooldown = GetSpellCooldown

		-- local cdCheckJudgment = select(2,GetSpellCooldown(self.spell.judgment))
		-- if cdCheckJudgment ~= nil and cdCheckJudgment > 2 then
		-- 	self.recharge.judgment = select(2,GetSpellCooldown(self.spell.judgment))
		-- else
		-- 	self.recharge.judgment = 4.5
		-- end
	end

	-- Starts rotation, uses default if no other specified; starts if inCombat == true
	function self.startRotation()
		if self.inCombat then
			if self.rotation == 1 then
				self:shadowRagnar()
			-- put different rotations below; dont forget to setup your rota in options
			else
				ChatOverlay("ERROR: NO ROTATION", 2000)
			end
		end
	end

	---------------------------------------------------------------
	-------------------- Functions --------------------------------
	---------------------------------------------------------------
	-- SWP counter
	function self.getSWP()
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

	-- VT counter
	function self.getVT()
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

	-- check unit for dot blacklist
	function self.safeDoT(checkUnit)
		local checkUnit = checkUnit
		local unitID = getUnitID(checkUnit)

		local blacklistUnitID = {
		-- highmaul
			79956,		-- Ko'ragh: Volatile Anomaly
			78077,		-- Mar'gok: Volatile Anomaly
		-- blackrock foundry
			77128,		-- Darmac: Pack Beast
			77394,		-- Thogar: Iron Raider (Train Ads)
			77893,		-- Kromog: Grasping Earth (Hands)
			77665,		-- Blackhand: Iron Soldier
		-- HFC
			90114,		-- Hellfire Assault: damn small ads
			94326,		-- Iron Reaver: Reactive Bomb
		-- Hellfire Citadel
		}
		local blacklistBuffID = {
			155176, 	-- BRF: Blast Furnace: Primal Elementalist: http://www.wowhead.com/spell=155176/damage-shield
			176141, 	-- BRF: Blast Furnace: Slag Elemental: http://www.wowhead.com/spell=176141/hardened-slag
		}
		if checkUnit == nil then return false end
		-- check buff
		for i = 1, #blacklistBuffID do
			if getBuffRemain(checkUnit,blacklistBuffID[i]) > 0 or getDebuffRemain(checkUnit,blacklistBuffID[i]) > 0 then return false end
		end
		-- check unitID
		for i = 1, #blacklistUnitID do
			if getUnitID(checkUnit) == blacklistUnitID[i] then return false	end
		end
		-- unit is not in blacklist
		return true
	end

	-- check unit for VT blacklist
	function self.safeVT(checkUnit)
		local checkUnit = checkUnit
		local unitID = getUnitID(checkUnit)

		local blacklistUnitID = {
		-- Blackrock Foundry
			77893,		-- Kromog: Grasping Earth (Hands)
			78981,		-- Thogar: Iron Gunnery Sergeant (canons on trains)
			80654,		-- Blackhand Mythic Siegemakers
			80659,		-- Blackhand Mythic Siegemakers
			80646,		-- Blackhand Mythic Siegemakers
			80660,		-- Blackhand Mythic Siegemakers
		-- Hellfire Citadel
			94865,		-- Hellfire Council: Jubei'thos Mirrors
			94231,		-- Xhul'horac: Wild Pyromaniac
			92208,		-- Archimonde: Doomfire Spirit
			91938,		-- Socrethar: Haunting Soul
			--90409,		-- Hellfire Assault: Gorebound Felcaster
			93717,		-- Iron Reaver: Volatile Firebomb
			91368,		-- Kormrok: Crushing Hand
			93830,		-- Hellfire Assault: Iron Dragoon
			90114,		-- Hellfire Assault: Iron Dragoon
		}
		if checkUnit == nil then return false end
		-- check unitID
		for i = 1, #blacklistUnitID do
			if getUnitID(checkUnit) == blacklistUnitID[i] then return false	end
		end
		-- unit is not in blacklist
		return true
	end

	-- no dotweave, just press damage
	function self.noDoTWeave(datUnit)
		local blacklistUnitID = {
			-- Highmaul
			77878, 		-- Mar'gok: Fortified Arcane Aberration
			77877, 		-- Mar'gok: Replicating Arcane Aberration
			77879, 		-- Mar'gok: Displacing Arcane Aberration
			77809,		-- Mar'gok: Arcane Aberration
			-- Blackrock Foundry
			77893,		-- Kromog: Grasping Earth (Hands)
			78981,		-- Thogar: Iron Gunnery Sergeant (canons on trains)
			-- Hellfire Citadel
			94865,		-- Jubei'thos Mirrors

		}
		if checkUnit == nil then return false end
		-- check unitID
		for i = 1, #blacklistUnitID do
			if getUnitID(checkUnit) == blacklistUnitID[i] then return true end
		end
		-- unit is not in blacklist, we can dotweave -> return false
		return false
	end

	-- sort enemiesTable by absolute hp
	function self.sortByHPabs()
		if enemiesTable then
			if enemiesTableTimer <= GetTime() - 0.5 then
				table.sort(enemiesTable, function(x,y)
					return x.hpabs and y.hpabs and x.hpabs > y.hpabs or false
				end)
			end
		end
	end

	-- sort enemiesTable by distance
	function self.sortByDistance()
		if enemiesTable then
			table.sort(enemiesTable, function(x,y)
				return x.distance and y.distance and x.distance > y.distance or false
			end)
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



	---------------------------------------------------------------
	-------------------- Spell functions --------------------------
	---------------------------------------------------------------
		-- angelic_feather
		function self.castAngelicFeatherOnMe()
			if self.mode.feather == 2 then
				if getGround("player") and IsMovingTime(0.2) and getBuffRemain("player",121557)<1 then
					if castGround("player",121536,30) then
						SpellStopTargeting()
						return
					end
				end
			end
		end
		-- arcane_torrent
		function self.castArcaneTorrent()
			return castSpell("player",self.spell.arcane_torrent,true,false)
		end
		-- cascade
		function self.castCascadeAuto()
			if self.cd.cascade <= 0 then
				for i=1,#enemiesTable do
					self.sortByDistance()
					local thisUnit = enemiesTable[i].unit
					if getDistance("player",thisUnit) < 40 then
						if UnitIsTappedByPlayer(thisUnit) then
							return castSpell(thisUnit,self.spell.cascade,true,false)
						end
					end
				end
			end
		end
		function self.castCascade(thisTarget)
			return castSpell(thisTarget,self.spell.cascade,true,false)
		end
		function self.castCascadeBiggestCluster()
			return castSpell(getBiggestUnitCluster(40,40),self.spell.cascade,true,false)
		end
		-- desperate_prayer
		function self.castDesperatePrayer()
			return castSpell("player",self.spell.desperate_prayer,true,false) == true or false
		end
		-- devouring_plague
		function self.castDP(thisTarget)
			if GetObjectExists(thisTarget) == false then
				return castSpell(enemiesTable[1],self.spell.devouring_plague,true,false)
			else
				return castSpell(thisTarget,self.spell.devouring_plague,true,false)
			end
		end
		-- dispel_magic
		-- dispersion
		function self.castDispersion()
			return castSpell("player",self.spell.dispersion,true,false)
		end
		-- divine_star
		-- dominate_mind
		-- fade
		function self.castFade()
			return castSpell("player",self.spell.fade,true,false)
		end
		-- fear_ward
		-- flash_heal
		-- halo
		function self.castHalo()
			return castSpell("player",self.spell.halo,true,false)
		end
		-- insanity
		function self.castInsanity(thisTarget)
		end
		-- leap_of_faith
		-- levitate
		-- mass_dispel
		-- mindbender
		function self.castMindbender(thisTarget)
			if self.mode.cooldowns == 2 then
				if self.options.offensive.shadowfiend.enabled then
					return castSpell(thisTarget,self.spell.mindbender,true,false)
				end
			end
		end
		-- mind_blast
		function self.castMindBlast(thisTarget)
			if getTalent(7,1) then
				return castSpell(thisTarget,self.spell.mind_blast,false,false)
			else
				return castSpell(thisTarget,self.spell.mind_blast,false,true)
			end
		end
		-- mind_flay
		function self.castMindFlay(thisTarget)
			if select(1,UnitChannelInfo("player")) == nil then
				return castSpell(thisTarget,self.spell.mind_flay,false,true)
			elseif select(1,UnitChannelInfo("player")) == "Insanity" or select(1,UnitChannelInfo("player")) == "MindFlay" then
				local cRem = select(6,UnitChannelInfo("player")) - GetTime()*1000
				local rnd = math.random(10,300)
				-- Clip it
				if cRem < rnd then
					if self.cd.mind_blast > cRem then
						return castSpell(thisTarget,self.spell.mind_flay,false,true)
					end
					return true
				end
				return true
			end
		end
		-- mind_sear
		function self.castMindSear(thisTarget)
			return castSpell(thisTarget,self.spell.mind_sear,true,true) 
		end
		-- mind_spike
		function self.castMindSpike(thisTarget,proc)
			if proc==true or proc=="proc" then
				return castSpell(thisTarget,self.spell.mind_spike,false,false)
			else
				return castSpell(thisTarget,self.spell.mind_spike,false,true)
			end
		end
		-- mind_vision
		-- power_infusion
		function self.castPowerInfusion()
			return castSpell("player",self.spell.power_infusion,true,false) 
		end
		-- power_word_fortitude
		-- power_word_shield
		function self.castPWS(thisTarget)
			return castSpell(thisTarget,self.spell.power_word_shield,true,false) 
		end


		-- prayer_of_mending
		-- psychic_horror
		-- resurrection
		-- shackle_undead
		-- shadow_word_death
		function self.castSWDAuto(thisTarget)
			if self.orbs < 5 or self.options.rotation.swd_ignore.enabled then
				if self.cd.shadow_word_death <= 0 then
					if GetObjectExists(thisTarget) then
						local thisUnit = thisTarget
						local range = getDistance("player",thisUnit)
						local hp = getHP(thisUnit)
						if hp < 20 and range < 40 then
							return castSpell(thisUnit,self.spell.shadow_word_death,true,false) 
						end
					end
					for i=1,#enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local range = enemiesTable[i].distance
						local hp = enemiesTable[i].hp
						if hp < 20 and range < 40 then
							if castSpell(thisUnit,self.spell.shadow_word_death,true,false,false,false,false,false,true) then
								return true
							end
						end
					end
				end
			end
		end


		-- function self.castSWDAuto(thisTarget,ignore)
		-- 	if ignore then
		-- 		print("1 insinde ignore")
		-- 		for i=1,#enemiesTable do
		-- 			local thisUnit = enemiesTable[i].unit
		-- 			local range = enemiesTable[i].distance
		-- 			local hp = enemiesTable[i].hp
		-- 			print("2 check: "..UnitName(thisUnit).." with "..hp)
		-- 			if hp < 20 and range < 40 then
		-- 				print("3 is under 20% and inside 40y")
		-- 				return castSpell(thisUnit,self.spell.shadow_word_death,true,false,false,false,false,false,true) 
		-- 			end
		-- 		end
		-- 	else
		-- 		if self.orbs < 5 then
		-- 			if thisTarget then
		-- 				if getHP(thisTarget)<=20 then
		-- 					return castSpell(thisTarget,self.spell.shadow_word_death,true,false) 
		-- 				end
		-- 			else
		-- 				for i=1,#enemiesTable do
		-- 					local thisUnit = enemiesTable[i].unit
		-- 					local range = enemiesTable[i].distance
		-- 					local hp = enemiesTable[i].hp
		-- 					if hp < 20 and range < 40 then
		-- 						return castSpell(thisUnit,self.spell.shadow_word_death,true,false,false,false,false,false,true) 
		-- 					end
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end
		-- shadow_word_pain
		function self.castSWPAutoApply(maxTargets)
			if self.getSWP() < maxTargets then
				for i=1,#enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local hp = enemiesTable[i].hpabs
					local distance = enemiesTable[i].distance
					if self.safeDoT(thisUnit) and UnitIsTappedByPlayer(thisUnit) then
						if getDebuffRemain(thisUnit,self.spell.shadow_word_pain,"player") <= 18*0.3 then
							if distance < 40 then
								if hp >= self.options.rotation.min_health.value then
									return castSpell(thisUnit,self.spell.shadow_word_pain,true,false)
									-- if castSpell(thisUnit,self.spell.shadow_word_pain,true,false) then
									-- 	return true
									-- end
								end
							end
						end
					end
				end
			end
		end
		function self.castSWP(thisTarget)
			return castSpell(thisTarget,self.spell.shadow_word_pain,true,false)
		end
		-- shadowfiend
		function self.castShadowfiend(thisTarget)
			if self.mode.cooldowns == 2 then
				if self.options.offensive.shadowfiend.enabled then
					return castSpell(thisTarget,self.spell.shadowfiend,true,false) 
				end
			end
		end
		-- shadowform
		function self.castShadowform()
			return castSpell("player",self.spell.shadowform,true,false) 
		end
		-- silence
		function self.castSilence(thisTarget)
			return castSpell(thisTarget,self.spell.silence,true,false)
		end
		-- surge_of_darkness
		-- spectral_guise
		-- vampiric_embrace
		function self.castVE()
			return castSpell("player",self.spell.vampiric_embrace,true,false) 
		end
		-- vampiric_touch
		function self.castVTAutoApply(maxTargets)
			if self.getVT() < maxTargets then
				for i=1,#enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local thisUnitGUID = enemiesTable[i].guid
					local hp = enemiesTable[i].hpabs
					local distance = enemiesTable[i].distance
					local lastVTTarget = lastVTTarget
					local lastVTTime = lastVTTime
					if thisUnitGUID ~= lastVTTarget or lastVTTime+2 < GetTime() then
						if self.safeDoT(thisUnit) and self.safeVT(thisUnit) and UnitIsTappedByPlayer(thisUnit) then
							if getDebuffRemain(thisUnit,self.spell.vampiric_touch,"player") <= 15*0.3+(0.001*select(4,GetSpellInfo(34914))) then
								if distance < 40 then
									if hp >= self.options.rotation.min_health.value then
										return castSpell(thisUnit,self.spell.vampiric_touch,true,true)
										-- if castSpell(thisUnit,self.spell.vampiric_touch,true,true) then
										-- 	return true
										-- end
									end
								end
							end
						end
					end
				end
			end
		end
		function self.castVT(thisTarget)
			if thisUnit ~= lastVTTarget and lastVTTime < GetTime() then
				return castSpell(thisTarget,self.spell.vampiric_touch,true,true)
			else 
				return false 
			end
		end
		-- void_entropy



	-- Return
	return self

	end
end