-- Inherit from: ../cCharacter.lua
-- All Warrior specs inherit from this file
if select(2, UnitClass("player")) == "WARRIOR" then
cWarrior = {}

-- Creates Warrior with given specialization
function cWarrior:new(spec)
	local self = cCharacter:new("Warrior")

	local player = "player" -- if someone forgets ""

	self.profile         	= spec
    self.powerRegen      	= getRegen("player")
    self.powerPercent 		= ((UnitPower("player")/UnitPowerMax("player"))*100)
	self.buff.duration	 	= {}		-- Buff Durations
	self.buff.remain 	 	= {}		-- Buff Time Remaining
	self.debuff.duration 	= {}		-- Debuff Durations
	self.debuff.remain 	 	= {}		-- Debuff Time Remaining
	self.debuff.count 		= {} 		-- Debuff Target Count
	self.warriorSpell 		= {

		-- Ability - Crowd Control
		hamstring 					= 1715,
		intimidatingShout 			= 5246,
		taunt 						= 355,

        -- Ability - Defensive
        commandingShout 			= 469,
        enragedRegeneration 		= 55694,
        intervene 					= 3411,
        massSpellReflection 		= 114028,
        safeguard 					= 114029,
        spellReflection 			= 23920,
        vigilance 					= 114030,

        -- Ability - Forms/Presense/Stance
        battleStance 				= 2457,
        defensiveStance 			= 71,

        -- Ability - Offensive
        avatar 						= 107574,
        battleShout 				= 6673,
        bladestorm					= 46924,
        bloodbath 					= 12292,
        dragonRoar 					= 118000,
        heroicStrike 				= 78,
        heroicThrow 				= 57755,
        impendingVictory 			= 103840,
        ravager 					= 152277,
        shatteringThrow 			= 64382,
        shockwave 					= 46968,
        stormBolt 					= 107570,
        victoryRush 				= 34428,

        -- Ability - Totems

        -- Ability - Utility
        berserkerRage 				= 18499,
        charge 						= 100,
        heroicLeap 					= 6544,
        pummel 						= 6552,
        shieldSlam 					= 156321,

        -- Buff - Defensive
        commandingShoutBuff			= 469,
        enragedRegenerationBuff 	= 55694,
        interveneBuff 				= 3411,
        massSpellReflectionBuff 	= 114028,
        safeguardBuff 				= 114029,
        spellReflectionBuff 		= 23920,
        vigilanceBuff 				= 114030,

        -- Buff - Forms/Presense/Stance
        battleStanceBuff 			= 2457,
        defensiveStanceBuff 		= 71,

        -- Buff - Offensive
        avatarBuff 					= 107574,
        battleShoutBuff 			= 6673,
        bladestormBuff 				= 46924,
        bloodbathBuff 				= 12292,
        ravagerBuff 				= 152277,
        victoryRushBuff 			= 32216,

        -- Buff - Stacks

        -- Buff - Utility
        berserkerRageBuff 			= 18499,

        -- Debuff - Offensive
        deepWoundsDebuff 			= 115767,

        -- Debuff - Defensive
        hamstringDebuff 			= 1715,
        intimidatingShoutDebuff 	= 5246,

        -- Glyphs

        -- Perks

        -- Talents
        avatarTalent 				= 107574,
        bladestormTalent 			= 46924,
        bloodbathTalent 			= 12292,
        doubleTimeTalent 			= 103827,
        dragonRoarTalent 			= 118000,
        impendingVictoryTalent 		= 103840,
        massSpellReflectionTalent 	= 114028,
        ravagerTalent 				= 152277,
        safeguardTalent 			= 114029,
        shockwaveTalent 			= 46968,
        stormBoltTalent 			= 107570,
        suddenDeathTalent 			= 29725,
	}

-- Update 
	function self.classUpdate()
		-- Call baseUpdate()
		self.baseUpdate()
		self.getClassOptions()
		self.getClassBuffs()
		self.getClassBuffsDuration()
		self.getClassBuffsRemain()
		self.getClassCharges()
		self.getClassCooldowns()
		self.getClassDynamicUnits()
		self.getClassDebuffs()
		self.getClassDebuffsDuration()
		self.getClassDebuffsRemain()
		self.getClassDebuffsCount()
		self.getClassRecharge()
	end

-- Update OOC
	function self.classUpdateOOC()
		-- Call baseUpdateOOC()
		self.baseUpdateOOC()
		self.getClassGlyphs()
		self.getClassTalents()
	end

-- Dynamic Units updates
	function self.getClassDynamicUnits()
		local dynamicTarget = dynamicTarget

		self.units.dyn8AoE 	= dynamicTarget(8, false)
		self.units.dyn10 	= dynamicTarget(10, true)
	end

-- Buff updates
	function self.getClassBuffs()
		local UnitBuffID = UnitBuffID

		self.buff.avatar 			= UnitBuffID("player",self.spell.avatarBuff)~=nil or false
		self.buff.battleShout 		= UnitBuffID("player",self.spell.battleShoutBuff)~=nil or false
		self.buff.battleStance 		= UnitBuffID("player",self.spell.battleStanceBuff)~=nil or false
		self.buff.bloodbath 		= UnitBuffID("player",self.spell.bloodbathBuff)~=nil or false
		self.buff.defensiveStance 	= UnitBuffID("player",self.spell.defensiveStanceBuff)~=nil or false
		self.buff.victoryRush 		= UnitBuffID("player",self.spell.victoryRushBuff)~=nil or false
	end	

	function self.getClassBuffsDuration()
		local getBuffDuration = getBuffDuration

		self.buff.duration.bloodbath = getBuffDuration("player",self.spell.bloodbathBuff) or 0 
	end

	function self.getClassBuffsRemain()
		local getBuffRemain = getBuffRemain

		self.buff.remain.bloodbath = getBuffRemain("player",self.spell.bloodbathBuff) or 0
	end

	function self.getClassCharges()
		local getBuffStacks = getBuffStacks
		local getCharges = getCharges

		self.charges.charge = getCharges(self.spell.charge) or 0
	end

-- Cooldown updates
	function self.getClassCooldowns()
		local getSpellCD = getSpellCD

		self.cd.avatar 				= getSpellCD(self.spell.avatar)
		self.cd.battleStance 		= getSpellCD(self.spell.battleStance)
		self.cd.berserkerRage 		= getSpellCD(self.spell.berserkerRage)
		self.cd.bladestorm 			= getSpellCD(self.spell.bladestorm)
		self.cd.bloodbath 			= getSpellCD(self.spell.bloodbath)
		self.cd.charge 		 		= getSpellCD(self.spell.charge)
		self.cd.defensiveStance 	= getSpellCD(self.spell.defensiveStance)
		self.cd.dragonRoar 			= getSpellCD(self.spell.dragonRoar)
		self.cd.hamstring 			= getSpellCD(self.spell.hamstring)
		self.cd.heroicLeap   		= getSpellCD(self.spell.heroicLeap)
		self.cd.heroicThrow 		= getSpellCD(self.spell.heroicThrow)
		self.cd.impendingVictory 	= getSpellCD(self.spell.impendingVictory)
		self.cd.intervene 			= getSpellCD(self.spell.intervene)
		self.cd.intimidatingShout 	= getSpellCD(self.spell.intimidatingShout)
		self.cd.recklessness 		= getSpellCD(self.spell.recklessness)
		self.cd.shockwave 			= getSpellCD(self.spell.shockwave)
		self.cd.spellReflection 	= getSpellCD(self.spell.spellReflection)
		self.cd.stormBolt 			= getSpellCD(self.spell.stormBolt)
		self.cd.pummel 				= getSpellCD(self.spell.pummel)
		self.cd.vigilance 			= getSpellCD(self.spell.vigilance)
	end

-- Debuff updates
	function self.getClassDebuffs()
		local UnitDebuffID = UnitDebuffID

		-- self.debuff.exhaustion = UnitDebuffID("player",self.spell.exhaustionDebuff)~=nil or false
	end

	function self.getClassDebuffsDuration()
		local getDebuffDuration = getDebuffDuration

		-- self.debuff.duration.exhaustion = getDebuffDuration("player",self.spell.exhaustionDebuff) or 0
	end

	function self.getClassDebuffsRemain()
		local getDebuffRemain = getDebuffRemain

		-- self.debuff.remain.exhaustion = getDebuffRemain("player",self.spell.exhaustionDebuff) or 0
	end

	function self.getClassDebuffsCount()
		local UnitDebuffID = UnitDebuffID

		-- self.debuff.count.flameShock = flameShockCount or 0
	end

-- Recharge updates
	function self.getClassRecharge()
		local getRecharge = getRecharge

		-- self.recharge.chiBrew 	 = getRecharge(self.spell.chiBrew)
	end

-- Glyph updates
	function self.getClassGlyphs()
		local hasGlyph = hasGlyph

		-- self.glyph.chainLightning 	= hasGlyph(self.spell.chainLightningGlyph)
	end

-- Talent updates
	function self.getClassTalents()
		local getTalent = getTalent

		self.talent.impendingVictory 	= getTalent(2,3)
		self.talent.stormBolt 			= getTalent(4,1)
		self.talent.shockwave 			= getTalent(4,2)
		self.talent.dragonRoar 			= getTalent(4,3)
		self.talent.vigilance 			= getTalent(5,3)
		self.talent.avatar 				= getTalent(6,1)
		self.talent.bloodbath 			= getTalent(6,2)
		self.talent.bladestorm 			= getTalent(6,3)
		self.talent.angerManagement 	= getTalent(7,1)
		self.talent.ravager 			= getTalent(7,2)
	end

-- Get Class option modes
	function self.getClassOptions()
		--self.poisonTimer = getValue("Poison remain")
	end

---------------
--- OPTIONS ---
---------------

	-- Class options
	-- Options which every Shaman should have
	function self.createClassOptions()
		-- Create Base Options
		self.createBaseOptions()

		-- Class Wrap
        local section = createNewSection(bb.profile_window,  "Class Options")
        checkSectionState(section)
	end

------------------------------
--- SPELLS - CROWD CONTROL --- 
------------------------------
	function self.castHamstring(thisUnit)
		if self.level>=36 and self.cd.hamstring==0 and getDebuffRemain(thisUnit,self.spell.hamstringDebuff,"player")==0 and getDistance(thisUnit)<5 then
			if castSpell(thisUnit,self.spell.hamstring,false,false,false) then return end
		end
	end

--------------------------
--- SPELLS - DEFENSIVE ---
--------------------------
	function self.castPummel(thisUnit)
		if self.level>=24 and self.cd.pummel==0 and getDistance(thisUnit)<5 then
			if castSpell(thisUnit,self.spell.pummel,false,false,false) then return end
		end
	end
	function self.castIntimidatingShout()
		if self.level>=52 and self.cd.intimidatingShout==0 and getDistance("target")<8 then
			if castSpell("player",self.spell.intimidatingShout,false,false,false) then return end
		end
	end
	function self.castSpellReflection()
		if self.level>=66 and self.cd.spellReflection==0 then
			if castSpell("player",self.spell.spellReflection,false,false,false) then return end
		end
	end
	function self.castVigilance(thisUnit)
		if self.talent.vigilance and self.cd.vigilance==0 and getDistance(thisUnit)<40 then
			if castSpell(thisUnit,self.spell.vigilance,false,false,false) then return end
		end
	end

--------------------------
--- SPELLS - OFFENSIVE ---
--------------------------
	function self.castAvatar()
		if self.talent.avatar and self.cd.avatar==0 and getDistance(self.units.dyn5)<5 and getTimeToDie(self.units.dyn5)>5 then
			if castSpell("player",self.spell.avatar,false,false,false) then return end
		end
	end
	function self.castBattleShout()
		if self.level>=42 then
	        if self.instance=="none" and not isBuffed("player",{self.spell.battleShout,19506,57330}) then
	        	if castSpell("player",self.spell.battleShout,false,false,false) then return end
	        else
		        local totalCount = GetNumGroupMembers()
		        local currentCount = currentCount or 0
		        local needsBuff = needsBuff or 0
		        for i=1,#nNova do
		            local thisUnit = nNova[i].unit
		            local distance = getDistance(thisUnit)
		            local dead = UnitIsDeadOrGhost(thisUnit)
		            if distance<30 then
		                currentCount = currentCount+1
		            end
		            if not isBuffed(thisUnit,{self.spell.battleShout,19506,57330}) and not dead and UnitIsPlayer(thisUnit) and not UnitInVehicle(thisUnit) then
		            	needsBuff = needsBuff+1
		            end
		        end
		        if currentCount>=totalCount and needsBuff>0 then
		            if castSpell("player",self.spell.battleShout,false,false,false) then return end
		        end
		    end
	    end
	end
	function self.castBladestorm()
		if self.talent.bladestorm and self.cd.bladestorm==0 and getDistance(self.units.dyn8AoE)<8 and getTimeToDie(self.units.dyn8AoE)>3 then
			if castSpell("player",self.spell.bladestorm,false,false,false) then return end
		end
	end
	function self.castBloodbath()
		if self.talent.bloodbath and self.cd.bloodbath==0 and getDistance(self.units.dyn5)<5 and getTimeToDie(self.units.dyn5)>6 then
			if castSpell("player",self.spell.bloodbath,false,false,false) then return end
		end
	end
	function self.castCommandingShout()
		if self.level>=42 then
	        if self.instance=="none" and isBuffed("player",{self.spell.battleShout,19506,57330}) and select(8,UnitBuffID("player",self.spell.battleShout))~="player" 
	        	and not isBuffed("player",{self.spell.commandingShout,21562,109773,160014,90364,160003,111922})
	        then
	        	if castSpell("player",self.spell.commandingShout,false,false,false) then return end
	        else
		        local totalCount = GetNumGroupMembers()
		        local currentCount = currentCount or 0
		        local needsBuff = needsBuff or 0
		        for i=1,#nNova do
		            local thisUnit = nNova[i].unit
		            local distance = getDistance(thisUnit)
		            local dead = UnitIsDeadOrGhost(thisUnit)
		            if distance<30 then
		                currentCount = currentCount+1
		            end
		            if not isBuffed(thisUnit,{self.spell.commandingShout,19506,57330}) and not dead and UnitIsPlayer(thisUnit) and not UnitInVehicle(thisUnit) then
		            	needsBuff = needsBuff+1
		            end
		        end
		        if currentCount>=totalCount and needsBuff>0 and select(8,UnitBuffID("player",self.spell.battleShout))~="player" 
		        	and not isBuffed("player",{self.spell.commandingShout,21562,109773,160014,90364,160003,111922}) 
		        then
		            if castSpell("player",self.spell.commandingShout,false,false,false) then return end
		        end
		    end
	    end
	end
	function self.castDragonRoar()
		if self.talent.dragonRoar and self.cd.dragonRoar==0 and getDistance(self.units.dyn8AoE)<8 and (getTimeToDie(self.units.dyn8AoE)>5 or #getEnemies("player",8)>1) then
			if castSpell(self.units.dyn8AoE,self.spell.dragonRoar,false,false,false) then return end
		end
	end
	function self.castHeroicThrow()
		local hasThreat = hasThreat("target")
		if self.level>=22 and self.cd.heroicThrow==0 and (hasThreat or select(2,IsInInstance())=="none") and getDistance("target")>5 then
			if (self.charges.charge==0 and getDistance("target")<30) or getDistance("target")<25 then
				if castSpell("target",self.spell.heroicThrow,false,false,false) then return end
			end
		end
	end
	function self.castImpendingVictory()
		if self.talent.impendingVictory and self.cd.impendingVictory and getDistance(self.units.dyn5)<5 then
			if castSpell(self.units.dyn5,self.spell.impendingVictory,false,false,false) then return end
		end
	end
	function self.castRavager()
		if self.talent.ravager and self.cd.ravager==0 and getDistance(self.units.dyn40)<40 and getTimeToDie(self.units.dyn40)>5 then
			if castGoundAtBestLocation(self.spell.ravager,6,1,40) then return end
			-- if castSpell(self.units.dyn40,self.spell.ravager,false,false,false) then return end
		end
	end
	function self.castShockwave()
		if self.talent.shockwave and self.cd.shockwave==0 and power>10 and getDistance(self.units,dyn10)<10 and getTimeToDie(self.units.dyn10)>5 then
			if castSpell(self.units.dyn10,self.spell.shockwave,false,false,false) then return end
		end
	end
	function self.castStormBolt()
		if self.talent.stormBolt and self.cd.stormBolt==0 and getDistance("target")<30 then
			if castSpell("target",self.spell.stormBolt,false,false,false) then return end
		end
	end
	function self.castVictoryRush()
		if not self.talent.impendingVictory and self.level>=5 and self.buff.victoryRush and getDistance(self.units.dyn5)<5 then
			if castSpell(self.units.dyn5,self.spell.victoryRush,false,false,false) then return end
		end
	end

-----------------------
--- SPELLS - STANCE ---
-----------------------
	function self.castBattleStance()
		if not self.buff.battleStance and self.cd.battleStance==0 then
			if castSpell("player",self.spell.battleStance,false,false,false) then return end
		end
	end
	function self.castDefensiveStance()
		if self.level>=9 and not self.buff.defensiveStance and self.cd.defensiveStance==0 then
			if castSpell("player",self.spell.defensiveStance,false,false,false) then return end
		end
	end

------------------------
--- SPELLS - UTILITY ---
------------------------
 	function self.castBeserkerRage()
 		if self.level>=54 and self.cd.berserkerRage==0 and (hasNoControl(self.spell.berserkerRage) or GetSpecialization()==2) then
 			if castSpell("player",self.spell.berserkerRage,false,false,false) then return end
 		end
 	end
	function self.castCharge()
		local hasThreat = hasThreat("target")
		if self.level>=3 and self.cd.charge==0 and (hasThreat or select(2,IsInInstance())=="none") and getDistance("target")>5 and getDistance("target")<25 then
			if castSpell("target",self.spell.charge,false,false,false) then return end
		end
	end
	function self.castHeroicLeap()
		local hasThreat = hasThreat("target")
		if self.level>=85 and self.cd.heroicLeap==0 and (hasThreat or select(2,IsInInstance())=="none") and getDistance("target")>5 and getDistance("target")<40 then
			if castGoundAtBestLocation(self.spell.heroicLeap,8,1,40,8) then return end
			--if castGround("target",self.spell.heroicLeap,40) then return end
		end
	end
	function self.castIntervene(thisUnit)
		if thisUnit == nil then thisUnit = "target" end
		if self.level>=72 and self.cd.intervene==0 and UnitIsPlayer(thisUnit) and UnitIsFriend(thisUnit,"player") and getDistance(thisUnit)>5 and getDistance(thisUnit)<25 then
			if castSpell(thisUnit,self.spell.intervene,false,false,false) then return end
		end
	end

-- Return
	return self
end

end -- End Select 