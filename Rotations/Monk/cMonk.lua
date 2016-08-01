-- Inherit from: ../cCharacter.lua
-- All Monk specs inherit from this file
if select(2, UnitClass("player")) == "MONK" then
cMonk = {}

-- Creates Monk with given specialisation
function cMonk:new(spec)
	local self = cCharacter:new("Monk")

	local player = "player" -- if someone forgets ""

	self.profile         	= spec
    self.powerRegen      	= getRegen("player")
	self.artifact 			= {}		-- Artifacts
	self.buff.duration	 	= {}		-- Buff Durations
	self.buff.remain 	 	= {}		-- Buff Time Remaining
	self.chi 				= {}		-- Chi Information
	self.debuff.duration 	= {}		-- Debuff Durations
	self.debuff.remain 	 	= {}		-- Debuff Time Remaining
	self.monkAbilities		= { 		-- Monk Abilities
		blackoutKick 					= 100784,
		cracklingJadeLightning 			= 117952,
		paralysis 						= 115078,
		provoke 						= 115546,
		resuscitate 					= 115178,
		roll 							= 109132,
		tigerPalm 						= 100780,
	}
	self.monkArtifacts 		= {
		artificialStamina 				= 211309,
	}
	self.monkBuffs 			= {
		comboBreakerBuff 				= 116768,
        dampenHarmBuff					= 122278,
        diffuseMagicBuff 				= 122783,
	}
	self.monkDebuffs 		= {

	}
	self.monkGlyphs 		= {
		glyphOfCracklingCraneLightning 	= 219513,
		glyphOfCracklingOxLightning 	= 219510,
		glyphOfCracklingTigerLightning  = 125931,
		glyphOfFightingPose 			= 125872,
		glyphOfHonor 					= 125732,
		glyphOfYulonsGrace 				= 219557,
	}
	self.monkSpecials 		= {
		effuse 							= 116694,
	}
	self.monkTalents 		= {
		celerity 						= 115173,
		chiBurst 						= 123986,
		chiTorpedo 						= 115008,
		dampenHarm 						= 122278,
		diffuseMagic 					= 122783,
		legSweep 						= 119381,
		ringOfPeace 					= 116844,
		tigersLust 						= 116841,
	}
    -- Merge all spell tables into self.druidSpell
	self.monkSpells = {} 
	self.monkSpells = mergeTables(self.monkSpells,self.monkAbilities)
	self.monkSpells = mergeTables(self.monkSpells,self.monkArtifacts)
	self.monkSpells = mergeTables(self.monkSpells,self.monkBuffs)
	self.monkSpells = mergeTables(self.monkSpells,self.monkDebuffs)
	self.monkSpells = mergeTables(self.monkSpells,self.monkGlyphs)
	self.monkSpells = mergeTables(self.monkSpells,self.monkSpecials)
	self.monkSpells = mergeTables(self.monkSpells,self.monkTalents) 

-- Update OOC
	function self.classUpdateOOC()
		-- Call baseUpdateOOC()
		self.baseUpdateOOC()
		self.getClassGlyphs()
		self.getClassTalents()
	end

-- Update 
	function self.classUpdate()
		-- Call baseUpdate()
		self.baseUpdate()
		self.chi.count 	= getChi("player")
		self.chi.max 	= getChiMax("player")
		self.chi.diff 	= getChiMax("player")-getChi("player")
		self.getClassBuffs()
		self.getClassBuffsDuration()
		self.getClassBuffsRemain()
		self.getClassCharges()
		self.getClassCooldowns()
		self.getClassDynamicUnits()
		self.getClassDebuffs()
		self.getClassDebuffsDuration()
		self.getClassDebuffsRemain()
		self.getClassRecharge()
	end

-- Dynamic Units updates
	function self.getClassDynamicUnits()
		local dynamicTarget = dynamicTarget

		self.units.dyn8AoE = dynamicTarget(8, false) 
		self.units.dyn10 = dynamicTarget(10, true)
		self.units.dyn15 = dynamicTarget(15, true)
	end

-- Buff updates
	function self.getClassBuffs()
		local UnitBuffID = UnitBuffID

		self.buff.comboBreaker 	= UnitBuffID("player",self.spell.comboBreakerBuff)~=nil or false
		self.buff.dampenHarm 	= UnitBuffID("player",self.spell.dampenHarmBuff)~=nil or false
		self.buff.diffuseMagic 	= UnitBuffID("player",self.spell.diffuseMagicBuff)~=nil or false
	end	
		
	function self.getClassBuffsDuration()
		local getBuffDuration = getBuffDuration

		self.buff.duration.dampenHarm 	= getBuffDuration("player",self.spell.dampenHarmBuff) or 0
		self.buff.duration.diffuseMagic = getBuffDuration("player",self.spell.diffuseMagicBuff) or 0
	end
		
	function self.getClassBuffsRemain()
		local getBuffRemain = getBuffRemain

		self.buff.remain.dampenHarm  	= getBuffRemain("player",self.spell.dampenHarmBuff) or 0
		self.buff.remain.diffuseMagic 	= getBuffRemain("player",self.spell.diffuseMagicBuff) or 0
	end
		
	function self.getClassCharges()
		local getBuffStacks = getBuffStacks
		local getCharges = getCharges

		self.charges.chiTorpedo = getCharges(self.spell.chiTorpedo)
		self.charges.roll 		= getCharges(self.spell.roll)
	end

-- Cooldown updates
	function self.getClassCooldowns()
		local getSpellCD = getSpellCD

		self.cd.chiBurst 		= getSpellCD(self.spell.chiBurst)
		self.cd.chiTorpedo 		= getSpellCD(self.spell.chiTorpedo)
		self.cd.dampenHarm 		= getSpellCD(self.spell.dampenHarm)
		self.cd.diffuseMagic 	= getSpellCD(self.spell.diffuseMagic)
		self.cd.paralysis 		= getSpellCD(self.spell.paralysis)
		self.cd.legSweep 		= getSpellCD(self.spell.legSweep)
		self.cd.provoke 		= getSpellCD(self.spell.provoke)
		self.cd.tigersLust 		= getSpellCD(self.spell.tigersLust)
	end
		
-- Debuff updates
	function self.getClassDebuffs()
		local UnitDebuffID = UnitDebuffID

		-- 	self.debuff.risingSunKick = UnitDebuffID(self.units.dyn5,self.spell.risingSunKickDebuff,"player")~=nil or false
	end
		
	function self.getClassDebuffsDuration()
		local getDebuffDuration = getDebuffDuration

		-- 	self.debuff.duration.risingSunKick = getDebuffDuration(self.units.dyn5,self.spell.risingSunKickDebuff,"player") or 0
	end
		
	function self.getClassDebuffsRemain()
		local getDebuffRemain = getDebuffRemain

		-- 	self.debuff.remain.risingSunKick = getDebuffRemain(self.units.dyn5,self.spell.risingSunKickDebuff,"player") or 0
	end
		
-- Recharge updates
	function self.getClassRecharge()
		local getRecharge = getRecharge

		self.recharge.chiTorpedo 	= getRecharge(self.spell.chiTorpedo)
		self.recharge.roll 			= getRecharge(self.spell.roll)
	end

-- Glyph updates
	function self.getClassGlyphs()
		local hasGlyph = hasGlyph

		-- self.glyph.touchOfDeath 	= hasGlyph(self.spell.touchOfDeathGlyph)
	end
		
-- Talent updates
	function self.getClassTalents()
		local getTalent = getTalent

		self.talent.chiBurst 		= getTalent(1,1)
		self.talent.chiTorpedo 		= getTalent(2,1)
		self.talent.tigersLust 		= getTalent(2,2)
		self.talent.celerity 		= getTalent(2,3)
		self.talent.ringOfPeace 	= getTalent(4,1)
		self.talent.legSweep 		= getTalent(4,3)
		self.talent.diffuseMagic 	= getTalent(5,2)
		self.talent.dampenHarm 		= getTalent(5,3)
	end

-- Get Class option modes
	function self.getClassOptions()
		--self.poisonTimer = getValue("Poison remain")
	end

---------------
--- OPTIONS ---
---------------

	-- Class options
	-- Options which every Monk should have
	function self.createClassOptions()

        -- Class Wrap
        local section = bb.ui:createSection(bb.ui.window.profile,  "Class Options", "Nothing")
        bb.ui:checkSectionState(section)
	end

------------------------------
--- SPELLS - CROWD CONTROL --- 
------------------------------
	-- Leg Sweep
	function self.castLegSweep(thisUnit)
		if self.talent.legSweep and self.cd.legSweep == 0 and getDistance(thisUnit) < 5 then
			if castSpell(thisUnit,self.spell.legSweep,false,false,false) then return end
		end
	end
	-- Paralysis
	function self.castParalysis(thisUnit)
		if self.level >= 48 and self.cd.paralysis == 0 and self.power > 20 and getDistance(thisUnit) < 20 then
			if castSpell(thisUnit,self.spell.paralysis,false,false,false) then return end
		end
	end
	-- Quaking Palm - Racial
	function self.castQuakingPalm(thisUnit)
		if self.race == "Pandaren" and getSpellCD(self.racial) == 0 and getDistance(thisUnit) < 5 then
			if castSpell(thisUnit,self.racial,false,false,false) then return end
		end		
	end

--------------------------
--- SPELLS - DEFENSIVE ---
--------------------------
	-- Dampen Harm
	function self.castDampenHarm()
		if self.talent.dampenHarm and self.cd.dampenHarm == 0 then
			if castSpell("player",self.spell.dampenHarm,false,false,false) then return end
		end
	end
	-- Diffuse Magic
	function self.castDiffuseMagic()
		if self.talent.diffuseMagic and self.cd.diffuseMagic == 0 then
			if castSpell("player",self.spell.diffuseMagic,false,false,false) then return end
		end
	end
	-- Effuse
	function self.castEffuse()
		if self.level >= 8 and self.power > 30 and not isMoving("player") then
			if castSpell("player",self.spell.effuse,false,false,false) then return end
		end
	end
--------------------------
--- SPELLS - OFFENSIVE ---
--------------------------
	-- Blackout Kick
	function self.castBlackoutKick(thisUnit)
		if thisUnit == nil then thisUnit = self.units.dyn5 end
		if self.level >= 3 and (self.chi.count >= 1 or self.buff.comboBreaker) and getDistance(thisUnit) < 5 then
			if castSpell(thisUnit,self.spell.blackoutKick,false,false,false) then return end
		end
	end
	-- Chi Burst
	function self.castChiBurst()
		if self.talent.chiBurst and self.cd.chiBurst == 0 and getDistance(self.units.dyn40AoE) < 40 then
			if castSpell("player",self.spell.chiBurst,false,false,false) then return end
		end
	end
	-- Chi Torpedo
	function self.castChiTorpedo()
		if self.talent.chiTorpedo and self.cd.chiTorpedo == 0 and self.charges.chiTorpedo >= 1 then
			if castSpell("player",self.spell.chiTorpedo,false,false,false) then return end
		end
	end

	-- Crackling Jade Lightning
	function self.castCracklingJadeLightning()
		if self.level >= 36 and getDistance("target") < 40 then
			if castSpell("target",self.spell.cracklingJadeLightning,false,false,false) then return end
		end
	end
	-- Tiger Palm
	function self.castTigerPalm(thisUnit)
		if thisUnit == nil then thisUnit = self.units.dyn5 end
		if self.level >= 1 and self.power > 50 and getDistance(thisUnit) < 5 then
			if castSpell(thisUnit,self.spell.tigerPalm,false,false,false) then return end
		end
	end

------------------------
--- SPELLS - UTILITY ---
------------------------

	-- Provoke
	function self.castProvoke()
		if self.level >= 13 and self.cd.provoke == 0 and getDistance("target") < 30 then
			if castSpell("target",self.spell.provoke,false,false,false) then return end
		end
	end
	-- Resuscitate
	function self.castResuscitate()
		if self.level >= 14 and not self.inCombat and UnitIsPlayer("mouseover") and UnitIsDeadOrGhost("mouseover") and getDistance("mouseover") < 40 then
			if castSpell("mouseover",self.spell.resuscitate,false,false,false,false,true) then return end
		end
	end
	-- Roll
	function self.castRoll()
		if self.level >= 5 and self.charges.roll >= 1 and (solo or hasThreat("target")) then
			if castSpell("player",self.spell.roll,false,false,false) then return end
		end
	end
	-- Tiger's Lust
	function self.castTigersLust()
		if self.talent.tigersLust and self.cd.tigersLust == 0 then
			if castSpell("player",self.spell.tigersLust,false,false,false) then return end
		end
	end

-- Return
	return self
end

end -- End Select 