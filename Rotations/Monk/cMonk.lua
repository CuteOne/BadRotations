-- Inherit from: ../cCharacter.lua
-- All Monk specs inherit from this file
if select(2, UnitClass("player")) == "MONK" then
	cMonk = {}

	function cMonk:new(spec)
		local self = cCharacter:new("Monk")

		local player = "player" -- if someone forgets ""

	-----------------
    --- VARIABLES ---
    -----------------

		self.profile         		= spec
	    self.powerRegen      		= getRegen("player")
		self.artifact 				= {}		-- Artifacts
		self.buff.duration	 		= {}		-- Buff Durations
		self.buff.remain 	 		= {}		-- Buff Time Remaining
		self.cast 					= {}		-- Cast Spell Functions
        self.cast.debug         	= {}        -- Cast Spell Functions Debug
        self.charges 				= {}
		self.chi 					= {}		-- Chi Information
		self.debuff.duration 		= {}		-- Debuff Durations
		self.debuff.refresh 		= {}
		self.debuff.remain 	 		= {}		-- Debuff Time Remaining
		self.recharge 				= {}
		self.spell.class        	= {}        
        self.spell.class.abilities 	= {		-- Abilities Available To All in Class
        	blackoutKick 					= 100784,
			chiBurst 						= 123986,
			chiTorpedo 						= 115008,
			cracklingJadeLightning 			= 117952,
			dampenHarm 						= 122278,
			diffuseMagic 					= 122783,
			effuse 							= 116694,
			legSweep 						= 119381,
			paralysis 						= 115078,
			provoke 						= 115546,
			resuscitate 					= 115178,
			ringOfPeace 					= 116844,
			roll 							= 109132,
			tigerPalm 						= 100780,
        }
        self.spell.class.artifacts  = {        -- Artifact Traits Available To All Rogues
            artificialStamina           	= 211309,
        }
        self.spell.class.buffs      = {        -- Buffs Available To All Rogues
        	comboBreaker 	 				= 116768,
        	dampenHarm 						= 122278,
        	diffuseMagic 	 				= 122783,
        }
        self.spell.class.debuffs    = {        -- Debuffs Available To All Rogues

        }
        self.spell.class.glyphs     = {        -- Glyphs Available To All Rogues
        	glyphOfCracklingCraneLightning 	= 219513,
			glyphOfCracklingOxLightning 	= 219510,
			glyphOfCracklingTigerLightning  = 125931,
			glyphOfFightingPose 			= 125872,
			glyphOfHonor 					= 125732,
			glyphOfYulonsGrace 				= 219557,
        }
        self.spell.class.talents    = {        -- Talents Available To All Rogues
        	celerity 						= 115173,
			chiBurst 						= 123986,
			chiTorpedo 						= 115008,
			dampenHarm 						= 122278,
			diffuseMagic 					= 122783,
			legSweep 						= 119381,
			ringOfPeace 					= 116844,
			tigersLust 						= 116841,
        }

	------------------
    --- OOC UPDATE ---
    ------------------
		function self.classUpdateOOC()
			-- Call baseUpdateOOC()
			self.baseUpdateOOC()
			self.getClassGlyphs()
			self.getClassTalents()
		end

	--------------
    --- UPDATE ---
    --------------
		function self.classUpdate()
			-- Call baseUpdate()
			self.baseUpdate()
			self.chi.count 	= getChi("player")
			self.chi.max 	= getChiMax("player")
			self.chi.diff 	= getChiMax("player")-getChi("player")
			self.getClassBuffs()
			self.getClassCharges()
			self.getClassCooldowns()
			self.getClassDynamicUnits()
			self.getClassDebuffs()
			self.getClassToggleModes()
			self.getClassCastable()
		end

	---------------------
    --- DYNAMIC UNITS ---
    ---------------------
		function self.getClassDynamicUnits()
			local dynamicTarget = dynamicTarget

			self.units.dyn8AoE = dynamicTarget(8, false) 
			self.units.dyn10 = dynamicTarget(10, true)
			self.units.dyn15 = dynamicTarget(15, true)
		end

	-----------------
    --- ARTIFACTS ---
    -----------------

        function self.getClassArtifacts()
            local isKnown = isKnown

            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact[k] = isKnown(v) or false
            end
        end

        function self.getClassArtifactRanks()

        end

	-------------
    --- BUFFS ---
    -------------
    
        function self.getClassBuffs()
            local UnitBuffID = UnitBuffID
            local getBuffDuration = getBuffDuration
            local getBuffRemain = getBuffRemain

            for k,v in pairs(self.spell.class.buffs) do
                self.buff[k]            = UnitBuffID("player",v) ~= nil
                self.buff.duration[k]   = getBuffDuration("player",v) or 0
                self.buff.remain[k]     = getBuffRemain("player",v) or 0
            end
        end
	
	---------------
    --- CHARGES ---
    ---------------

		function self.getClassCharges()
			local getBuffStacks = getBuffStacks
			local getCharges = getCharges
			local getRecharge = getRecharge

			for k,v in pairs(self.spell.class.abilities) do
				self.charges[k] 	= getCharges(v)
				self.recharge[k] 	= getRecharge(v)
			end
		end

	-----------------
    --- COOLDOWNS ---
    -----------------

        function self.getClassCooldowns()
            local getSpellCD = getSpellCD

            for k,v in pairs(self.spell.class.abilities) do
                if getSpellCD(v) ~= nil then
                    self.cd[k] = getSpellCD(v)
                end
            end
        end
		
	---------------
    --- DEBUFFS ---
    ---------------

        function self.getClassDebuffs()
            local UnitDebuffID = UnitDebuffID
            local getDebuffDuration = getDebuffDuration
            local getDebuffRemain = getDebuffRemain

            for k,v in pairs(self.spell.class.debuffs) do
                self.debuff[k]          = UnitDebuffID(self.units.dyn5,v,"player") ~= nil
                self.debuff.duration[k] = getDebuffDuration(self.units.dyn5,v,"player") or 0
                self.debuff.remain[k]   = getDebuffRemain(self.units.dyn5,v,"player") or 0
            end
        end

	--------------
    --- GLYPHS ---
    --------------

        function self.getClassGlyphs()
            local hasGlyph = hasGlyph

        end
		
	----------------
    --- TALENTS ---
    ----------------

        function self.getClassTalents()
            local getTalent = getTalent

            for r = 1, 7 do --search each talent row
                for c = 1, 3 do -- search each talent column
                    local talentID = select(6,GetTalentInfo(r,c,GetActiveSpecGroup())) -- ID of Talent at current Row and Column
                    for k,v in pairs(self.spell.class.talents) do
                        if v == talentID then
                            self.talent[k] = getTalent(r,c)
                        end
                    end
                end
            end
        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getClassToggleModes()

            self.mode.rotation      = bb.data["Rotation"]
            self.mode.cooldown      = bb.data["Cooldown"]
            self.mode.defensive     = bb.data["Defensive"]
            self.mode.interrupt     = bb.data["Interrupt"]
        end

        -- Create the toggle defined within rotation files
        function self.createClassToggles()
            GarbageButtons()
            if self.rotations[bb.selectedProfile] ~= nil then
                self.rotations[bb.selectedProfile].toggles()
            else
                return
            end
        end

    ---------------
    --- OPTIONS ---
    ---------------

        -- Class options
        -- Options which every Rogue should have
        function self.createClassOptions()
            -- Class Wrap
            local section = bb.ui:createSection(bb.ui.window.profile,  "Class Options", "Nothing")
            bb.ui:checkSectionState(section)
        end

    --------------
    --- SPELLS ---
    --------------

        function self.getClassCastable()
            self.cast.debug.blackoutKick     		= self.cast.blackoutKick("target",true)
            self.cast.debug.chiBurst				= self.cast.chiBurst("target",true)
            self.cast.debug.chiTorpedo 				= self.cast.chiTorpedo("player",true)
            self.cast.debug.cracklingJadeLightning 	= self.cast.cracklingJadeLightning("target",true)
            self.cast.debug.dampenHarm 				= self.cast.dampenHarm("player",true)
            self.cast.debug.diffuseMagic 			= self.cast.diffuseMagic("player",true)
            self.cast.debug.effuse 					= self.cast.effuse("player",true)
            self.cast.debug.legSweep 				= self.cast.legSweep("target",true)
            self.cast.debug.paralysis 				= self.cast.paralysis("target",true)
            self.cast.debug.provoke 				= self.cast.provoke("target",true)
            self.cast.debug.quakingPalm 			= self.cast.quakingPalm("target",true)
            self.cast.debug.resuscitate 			= self.cast.resuscitate("mouseover",true)
            self.cast.debug.roll 					= self.cast.roll("target",true)
            self.cast.debug.tigersLust 				= self.cast.tigersLust("player",true)
            self.cast.debug.tigerPalm 				= self.cast.tigerPalm("target",true)
        end

        -- Blackout Kick
        function self.cast.blackoutKick(thisUnit,debug)
            local spellCast = self.spell.blackoutKick
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 3 and (self.chi.count >= 1 or self.buff.comboBreaker) and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Chi Burst
		function self.cast.chiBurst(thisUnit,debug)
            local spellCast = self.spell.chiBurst
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40AoE end
            if debug == nil then debug = false end

            if self.talent.chiBurst and self.cd.chiBurst == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Chi Torpedo
		function self.cast.chiTorpedo(thisUnit,debug)
            local spellCast = self.spell.chiTorpedo
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.chiTorpedo and self.cd.chiTorpedo == 0 and self.charges.chiTorpedo >= 1 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Crackling Jade Lightning
		function self.cast.cracklingJadeLightning(thisUnit,debug)
            local spellCast = self.spell.cracklingJadeLightning
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.level >= 36 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Dampen Harm
		function self.cast.dampenHarm(thisUnit,debug)
            local spellCast = self.spell.dampenHarm
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.dampenHarm and self.cd.dampenHarm == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Diffuse Magic
		function self.cast.diffuseMagic(thisUnit,debug)
            local spellCast = self.spell.diffuseMagic
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.diffuseMagic and self.cd.diffuseMagic == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Effuse
		function self.cast.effuse(thisUnit,debug)
            local spellCast = self.spell.effuse
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 8 and self.power > 30 and not isMoving(thisUnit) then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Leg Sweep
		function self.cast.legSweep(thisUnit,debug)
            local spellCast = self.spell.legSweep
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5AoE end
            if debug == nil then debug = false end

            if self.talent.legSweep and self.cd.legSweep == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Paralysis
		function self.cast.paralysis(thisUnit,debug)
            local spellCast = self.spell.paralysis
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn20AoE end
            if debug == nil then debug = false end

            if self.level >= 48 and self.cd.paralysis == 0 and self.power > 20 and getDistance(thisUnit) < 20 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Provoke
		function self.cast.provoke(thisUnit,debug)
            local spellCast = self.spell.provoke
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.level >= 13 and self.cd.provoke == 0 and getDistance(thisUnit) < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Quaking Palm - Racial
		function self.cast.quakingPalm(thisUnit,debug)
            local spellCast = self.spell.quakingPalm
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.race == "Pandaren" and getSpellCD(self.racial) == 0 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Resuscitate
		function self.cast.resuscitate(thisUnit,debug)
            local spellCast = self.spell.resuscitate
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "mouseover" end
            if debug == nil then debug = false end

            if self.level >= 14 and not self.inCombat and UnitIsPlayer(thisUnit) and UnitIsDeadOrGhost(thisUnit) and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false,false,true)
                end
            elseif debug then
                return false
            end
        end
		-- Roll
		function self.cast.roll(thisUnit,debug)
            local spellCast = self.spell.roll
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 5 and self.charges.roll >= 1 and (solo or hasThreat("target")) then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Tiger's Lust
		function self.cast.tigersLust(thisUnit,debug)
            local spellCast = self.spell.tigersLust
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.tigersLust and self.cd.tigersLust == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Tiger Palm
		function self.cast.tigerPalm(thisUnit,debug)
            local spellCast = self.spell.tigerPalm
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 1 and self.power > 50 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

    	function useAoE()
            local rotation = self.mode.rotation
            if (rotation == 1 and #getEnemies("player",8) >= 3) or rotation == 2 then
                return true
            else
                return false
            end
        end

        function useCDs()
            local cooldown = self.mode.cooldown
            if (cooldown == 1 and isBoss()) or cooldown == 2 then
                return true
            else
                return false
            end
        end

        function useDefensive()
            if self.mode.defensive == 1 then
                return true
            else
                return false
            end
        end

        function useInterrupts()
            if self.mode.interrupt == 1 then
                return true
            else
                return false
            end
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------
		-- Return
		return self
	end
end -- End Select 