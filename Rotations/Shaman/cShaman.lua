-- Inherit from: ../cCharacter.lua
-- All Shaman specs inherit from this file
if select(2, UnitClass("player")) == "SHAMAN" then
cShaman = {}

-- Creates Shaman with given specialisation
function cShaman:new(spec)
	local self = cCharacter:new("Shaman")

	local player = "player" -- if someone forgets ""

	-----------------
    --- VARIABLES ---
    -----------------

		self.profile         				= spec
		self.artifact 		 				= {}
		self.artifact.perks  				= {}
		self.buff.duration	 				= {}		-- Buff Durations
		self.buff.remain 	 				= {}		-- Buff Time Remaining
		self.cast 		     				= {}        -- Cast Spell Functions
		self.cast.debug 	 				= {}
		self.debuff.duration 				= {}		-- Debuff Durations
		self.debuff.remain 	 				= {}		-- Debuff Time Remaining
		self.debuff.refresh             	= {}       -- Debuff Refreshable
        self.spell.class                	= {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      	= {
            ancestralSpirit                 = 2008,
            astralShift                     = 108271,
            ghostWolf                       = 2645,
            hex                             = 51514,
            lightningSurgeTotem             = 192058,
            purge                           = 370,
            waterWalking                    = 546,
            windShear                       = 57994,
        }
        self.spell.class.artifacts      	= {        -- Artifact Traits Available To All Specs in Class

        }
        self.spell.class.buffs          	= {        -- Buffs Available To All Specs in Class
            astralShift                     = 108271,
            ghostWolf                       = 2645,
            waterWalking                    = 546,
        }
        self.spell.class.debuffs        	= {        -- Debuffs Available To All Specs in Class
            hex                             = 51514,
        }
        self.spell.class.glyphs         	= {        -- Glyphs Available To All Specs in Class

        }
        self.spell.class.talents        	= {        -- Talents Available To All Specs in Class
            lightningSurgeTotem             = 192058,
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
			self.getClassEnemies()
			self.getClassBuffs()
			self.getClassCharges()
			self.getClassCooldowns()
			self.getClassDebuffs()
			self.getClassCastable()

	        -- Update Energy Regeneration
	        self.powerRegen  = getRegen("player")
		end

	---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getClassDynamicUnits()
            local dynamicTarget = dynamicTarget

            self.units.dyn8 	= dynamicTarget(8, true)
			self.units.dyn8AoE 	= dynamicTarget(8, false)
			self.units.dyn10 	= dynamicTarget(10, true)
            self.units.dyn20	= dynamicTarget(20, false)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getClassEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = getEnemies("player", 5) -- Melee
            self.enemies.yards8 	= getEnemies("player", 8) -- AoE
            self.enemies.yards20    = getEnemies("player", 20) -- Ghost Wolf
            self.enemies.yards30    = getEnemies("player", 30) -- Interrupts
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

    	function self.getClassArtifacts()
    		local isKnown = isKnown

    		for k,v in pairs(self.spell.class.artifacts) do
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
			self.cast.debug.ancestralSpirit     = self.cast.ancestralSpirit("target",true)
            self.cast.debug.astralShift         = self.cast.astralShift("player",true)
            self.cast.debug.ghostWolf           = self.cast.ghostWolf("player",true)
            self.cast.debug.hex                 = self.cast.hex("target",true)
            self.cast.debug.lightningSurgeTotem = self.cast.lightningSurgeTotem("player",true)
            self.cast.debug.purge               = self.cast.purge("target",true)
            self.cast.debug.waterWalking        = self.cast.waterWalking("player",true)
            self.cast.debug.windShear           = self.cast.windShear("target",true)
		end

		-- Ancestral Spirit
		function self.cast.ancestralSpirit(thisUnit,debug)
            local spellCast = self.spell.ancestralSpirit
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40AoE end
            if debug == nil then debug = false end

            if self.level >= 14 and self.powerPercentMana > 4 and not self.inCombat and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false,false,true)
                end
            elseif debug then
                return false
            end
        end
        -- Astral Shift
        function self.cast.astralShift(thisUnit,debug)
            local spellCast = self.spell.astralShift
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 44 and self.cd.astralShift == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Ghost Wolf
        function self.cast.ghostWolf(thisUnit,debug)
            local spellCast = self.spell.ghostWolf
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 16 and not self.buff.ghostWolf then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,true,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Hex
        function self.cast.hex(thisUnit,debug)
            local spellCast = self.spell.hex
            local thisUnit = thisUnit
            local unitType = UnitCreatureType(thisUnit) or "None"
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.level >= 42 and not self.debuff.hex and (unitType == "Humanoid" or unitType == "Beast") and getDistance(thisUnit) >= 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,true,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Lightning Surge Totem
        function self.cast.lightningSurgeTotem(thisUnit,debug)
            local spellCast = self.spell.lightningSurgeTotem
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.lightningSurgeTotem and self.cd.lightningSurgeTotem == 0 and self.powerPercentMana > 10 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,true,false,false,false,true)
                else
                    return castGround(thisUnit,spellCast,35)
                end
            elseif debug then
                return false
            end
        end
        -- Purge
        function self.cast.purge(thisUnit,debug)
            local spellCast = self.spell.purge
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "target" end
            if debug == nil then debug = false end

            if self.level >= 58 and self.powerPercentMana > 20 and getDistance("target") < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,true,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Water Walking
        function self.cast.waterWalking(thisUnit,debug)
            local spellCast = self.spell.waterWalking
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 24 and not self.buff.ghostWolf and not self.buff.waterWalking and IsSwimming() then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,true,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Wind Shear
        function self.cast.windShear(thisUnit,debug)
            local spellCast = self.spell.windShear
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30AoE end
            if debug == nil then debug = false end

            if self.level >= 22 and self.cd.windShear == 0 and getDistance(thisUnit) < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,true,false,false,false,true)
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
            if (rotation == 1 and #enemies.yards8 > 1) or rotation == 2 then
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
	end --End function cShaman:new(spec)
end -- End Select 