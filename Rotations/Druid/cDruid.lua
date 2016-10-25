-- Inherit from: ../cCharacter.lua
-- All Druid specs inherit from this file
if select(2, UnitClass("player")) == "DRUID" then
	cDruid = {}
	-- Creates Druid with given specialisation
	function cDruid:new(spec)
		local self = cCharacter:new("Druid")

		local player = "player" -- if someone forgets ""

	-----------------
    --- VARIABLES ---
    -----------------

		self.profile         = spec
		self.comboPoints     = getCombo("player")
		self.stealth		 = false
		self.artifact 		 = {}
		self.artifact.rank   = {}
		self.buff.duration	 = {}		-- Buff Durations
		self.buff.remain 	 = {}		-- Buff Time Remaining
		self.cast 		     = {}        -- Cast Spell Functions
		self.cast.debug 	 = {}
		self.debuff.duration = {}		-- Debuff Durations
		self.debuff.remain 	 = {}		-- Debuff Time Remaining
		self.debuff.refresh             = {}       -- Debuff Refreshable
        self.spell.class                = {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      = {
        	bearForm 					= 5487,
			catForm 					= 768,
			dash 						= 1850,
			displacerBeast 				= 102280,
			dreamwalk 					= 193753,
			entanglingRoots 			= 339,
			flightForm 					= 165962,
			growl 						= 6795,
			massEntanglement 			= 102359,
			mightyBash 					= 5211,
			moonfire 					= 8921,
			prowl 						= 5215,
			rebirth 					= 20484,
            regrowth                    = 8936,
			revive 						= 50769,
			shadowmeld                  = 58984,
			stagForm 					= 210053,
			travelForm 					= 783,
			typhoon 					= 132469,
			wildCharge 					= 102401,
        }
        self.spell.class.artifacts      = {        -- Artifact Traits Available To All Specs in Class
            artificialStamina 			= 211309,
        }
        self.spell.class.buffs          = {        -- Buffs Available To All Specs in Class
        	bearForm 	 				= 5487,
			catForm 					= 768,
			dash 						= 1850,
			displacerBeast 				= 137452,
			flightForm 					= 165962,
			prowl 						= 5215,
			shadowmeld                  = 58984,
			stagForm 	 				= 210053,
			travelForm  				= 783,
        }
        self.spell.class.debuffs        = {        -- Debuffs Available To All Specs in Class
        	entanglingRoots 	 		= 339,
			growl 		 				= 6795,
			moonfire 	 				= 8921,
        }
        self.spell.class.glyphs         = {        -- Glyphs Available To All Specs in Class
        	glyphOfTheCheetah 			= 131113,
			glyphOfTheDoe 				= 224122,
			glyphOfTheFeralChameleon 	= 210333,
			glyphOfTheOrca 				= 114333,
			glyphOfTheSentinel 			= 219062,
			glyphOfTheUrsolChameleon 	= 107059, 
        }
        self.spell.class.talents        = {        -- Talents Available To All Specs in Class
        	displacerBeast 				= 102280,
        	massEntanglement 			= 102359,
			mightyBash 					= 5211,
			typhoon 					= 132469,
			wildCharge 					= 102401,
        }

    ------------------
    --- OOC UPDATE ---
    ------------------

		function self.classUpdateOOC()
			-- Call baseUpdateOOC()
			self.baseUpdateOOC()
			self.getClassArtifacts()
			self.getClassArtifactRanks()
			self.getClassGlyphs()
			self.getClassTalents()
			self.getClassPerks()
		end

    --------------
    --- UPDATE ---
    --------------

		function self.classUpdate()
			-- Call baseUpdate()
			self.baseUpdate()
			self.getClassDynamicUnits()
			self.getClassBuffs()
			self.getClassCharges()
			self.getClassCooldowns()
			self.getClassDebuffs()
			self.getClassCastable()

			-- Update Combo Points
			self.comboPoints = UnitPower("player",4)

	        -- Update Energy Regeneration
	        self.powerRegen  = getRegen("player")

			-- Stealth
			if self.race == "Night Elf" then
				self.stealth = UnitBuffID("player",self.spell.prowl) or UnitBuffID("player",self.racial)
			else
				self.stealth = UnitBuffID("player",self.spell.prowl)
			end
		end

	---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getClassDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn15 = dynamicTarget(15,true) -- Typhoon

            -- AoE
            self.units.dyn35AoE = dynamicTarget(35, false) -- Entangling Roots
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

    	function self.getClassArtifacts()
    		local isKnown = isKnown

    		for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact[k] = hasPerk(v) or false
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
            local getCharges = getCharges

            for k,v in pairs(self.spell.class.abilities) do
                self.charges[k]     = getCharges(v)
                self.recharge[k]    = getRecharge(v)
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
	--- TAALENTS ---
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
			
	-------------
	--- PERKS ---
	-------------

		function self.getClassPerks()
			local isKnown = isKnown

		end

	---------------
	--- OPTIONS ---
	---------------

		-- Class options
		-- Options which every Druid should have
		function self.createClassOptions()
            -- Class Wrap
            local section = bb.ui:createSection(bb.ui.window.profile,  "Class Options", "Nothing")
            bb.ui:checkSectionState(section)
		end

	--------------
	--- SPELLS ---
	--------------

		function self.getClassCastable()
			self.cast.debug.bearForm 		= self.cast.bearForm("player",true)
			self.cast.debug.catForm 		= self.cast.catForm("player",true)
			self.cast.debug.dash 			= self.cast.dash("player",true)
			self.cast.debug.displacerBeast 	= self.cast.displacerBeast("player",true)
			self.cast.debug.entanglingRoots = self.cast.entanglingRoots("target",true)
			self.cast.debug.flightForm 		= self.cast.flightForm("player",true)
			self.cast.debug.growl 			= self.cast.growl("target",true)
			self.cast.debug.regrowth 	    = self.cast.regrowth("player",true)
			self.cast.debug.mightyBash 		= self.cast.mightyBash("target",true)
			self.cast.debug.moonfire 		= self.cast.moonfire("target",true)
			self.cast.debug.prowl 			= self.cast.prowl("player",true)
			self.cast.debug.rebirth 		= self.cast.rebirth("target",true)
			self.cast.debug.revive 			= self.cast.revive("target",true)
			self.cast.debug.shadowmeld 		= self.cast.shadowmeld("player",true)
			self.cast.debug.stagForm 		= self.cast.stagForm("player",true)
			self.cast.debug.travelForm 		= self.cast.travelForm("player",true)
			self.cast.debug.typhoon 		= self.cast.typhoon("target",true)
			self.cast.debug.wildCharge 		= self.cast.wildCharge("target",true)
		end

		-- Bear Form
		function self.cast.bearForm(thisUnit,debug)
            local spellCast = self.spell.bearForm
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 8 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Cat Form
		function self.cast.catForm(thisUnit,debug)
            local spellCast = self.spell.catForm
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 1 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Dash
		function self.cast.dash(thisUnit,debug)
            local spellCast = self.spell.dash
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 24 and self.cd.dash == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Displacer Beast
		function self.cast.displacerBeast(thisUnit,debug)
            local spellCast = self.spell.displacerBeast
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.displacerBeast and self.cd.displacerBeast == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Entangling Roots
		function self.cast.entanglingRoots(thisUnit,debug)
            local spellCast = self.spell.entanglingRoots
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn35AoE end
            if debug == nil then debug = false end

            if self.level >= 22 and self.powerPercentMana > 10 and hasThreat(thisUnit) and getDistance(thisUnit) < 35 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Flight Form
		function self.cast.flightForm(thisUnit,debug)
            local spellCast = self.spell.flightForm
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 58 and not self.inCombat then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Growl
		function self.cast.growl(thisUnit,debug)
            local spellCast = self.spell.growl
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30AoE end
            if debug == nil then debug = false end

            if self.level >= 13 and self.cd.growl == 0 and self.buff.bearForm and getDistance(thisUnit) < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Regrowth
		function self.cast.regrowth(thisUnit,debug)
            local spellCast = self.spell.regrowth
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            local validUnit = UnitIsPlayer(thisUnit) and not UnitIsDeadOrGhost(thisUnit) and UnitIsFriend(thisUnit,"player")
            if debug == nil then debug = false end

            if self.level >= 26 and self.powerPercentMana > 9 and validUnit and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Mighty Bash
		function self.cast.mightyBash(thisUnit,debug)
            local spellCast = self.spell.mightyBash
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.talent.mightyBash and self.cd.mightyBash == 0 and hasThreat(thisUnit) and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Moonfire
		function self.cast.moonfire(thisUnit,debug)
            local spellCast = self.spell.moonfire
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40AoE end
            if debug == nil then debug = false end

            if self.level >= 10 and self.powerPercentMana > 6 and hasThreat(thisUnit) and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Prowl
		function self.cast.prowl(thisUnit,debug)
            local spellCast = self.spell.prowl
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 5 and self.cd.prowl == 0 and not self.buff.prowl then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Rebirth
		function self.cast.rebirth(thisUnit,debug)
            local spellCast = self.spell.rebirth
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "mouseover" end
            local isDeadPlayer = UnitIsPlayer(thisUnit) and UnitIsDeadOrGhost(thisUnit) and UnitIsFriend(thisUnit,"player")
            if debug == nil then debug = false end

            if self.level >= 56 and self.cd.rebirth == 0 and self.inCombat and isDeadPlayer and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false,false,true)
                end
            elseif debug then
                return false
            end
        end
		-- Revive
		function self.cast.revive(thisUnit,debug)
            local spellCast = self.spell.revive
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "mouseover" end
            local isDeadPlayer = UnitIsPlayer(thisUnit) and UnitIsDeadOrGhost(thisUnit) and UnitIsFriend(thisUnit,"player")
            if debug == nil then debug = false end

            if self.level >= 14 and self.powerPercentMana > 4 and not self.inCombat and isDeadPlayer and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false,false,true)
                end
            elseif debug then
                return false
            end
        end
        -- Shadowmeld
        function self.cast.shadowmeld(thisUnit,debug)
            local spellCast = self.spell.shadowmeld
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 1 and self.cd.shadowmeld == 0 and not self.buff.stealth and not isMoving("player") then
                if debug then
                    return castSpell("player",spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell("player",spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Stag Form
		function self.cast.stagForm(thisUnit,debug)
            local spellCast = self.spell.stagForm
            local thisUnit = thisUnit
            local indoors = indoors
            if IsIndoors() == nil then indoors = false else indoors = true end
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 40 and not indoors then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Travel Form
		function self.cast.travelForm(thisUnit,debug)
            local spellCast = self.spell.travelForm
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 16 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Typhoon
		function self.cast.typhoon(thisUnit,debug)
            local spellCast = self.spell.typhoon
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn15 end
            if debug == nil then debug = false end

            if self.talent.typhoon and self.cd.typhoon == 0 and hasThreat(thisUnit) and getDistance(thisUnit) < 15 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Wild Charge
		function self.cast.wildCharge(thisUnit,debug)
            local spellCast = self.spell.wildCharge
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.talent.wildCharge and self.cd.wildCharge == 0 and getDistance(thisUnit) >= 8 and (hasThreat(thisUnit) or self.instance == "none") and getDistance(thisUnit) < 25 then
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
	end --End function cDruid:new(spec)
end -- End Select 