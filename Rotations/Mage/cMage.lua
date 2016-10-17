-- Inherit from: ../cCharacter.lua
-- All Mage specs inherit from this file
if select(2, UnitClass("player")) == "MAGE" then
cMage = {}

-- Creates Mage with given specialisation
function cMage:new(spec)
	local self = cCharacter:new("Mage")

	local player = "player" -- if someone forgets ""

	-----------------
    --- VARIABLES ---
    -----------------

		self.profile         				= spec
		self.artifact 		 				= {}
		self.artifact.rank  				= {}
		self.buff.duration	 				= {}		-- Buff Durations
		self.buff.remain 	 				= {}		-- Buff Time Remaining
        self.buff.stack                     = {}        -- Buff Stack Count
		self.cast 		     				= {}        -- Cast Spell Functions
		self.cast.debug 	 				= {}
		self.debuff.duration 				= {}		-- Debuff Durations
		self.debuff.remain 	 				= {}		-- Debuff Time Remaining
		self.debuff.refresh             	= {}       -- Debuff Refreshable
        self.spell.class                	= {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      	= {
            counterspell                    = 2139,
            frostNova                       = 122,
            runeOfPower                     = 116011,
        }
        self.spell.class.artifacts      	= {        -- Artifact Traits Available To All Specs in Class
            
        }
        self.spell.class.buffs          	= {        -- Buffs Available To All Specs in Class
            incantersFlow                   = 1463,
            runeOfPower                     = 116014,
        }
        self.spell.class.debuffs        	= {        -- Debuffs Available To All Specs in Class

        }
        self.spell.class.glyphs         	= {        -- Glyphs Available To All Specs in Class

        }
        self.spell.class.talents        	= {        -- Talents Available To All Specs in Class
            incantersFlow                   = 1463,
            runeOfPower                     = 116011,
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
            self.enemies.yarsd12    = getEnemies("player", 12) -- Frost Nova
            self.enemies.yards20    = getEnemies("player", 20) -- Ghost Wolf
            self.enemies.yards30    = getEnemies("player", 30) -- Interrupts
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

    	function self.getClassArtifacts()
    		local hasPerk = hasPerk

    		for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact[k] = hasPerk(v) or false
            end
    	end

    	function self.getClassArtifactRanks()
            local getPerkRank = getPerkRank
            
            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact.rank[k] = getPerkRank(v) or 0
            end
    	end

    -------------
    --- BUFFS ---
    -------------
	
		function self.getClassBuffs()
            local UnitBuffID = UnitBuffID
            local getBuffDuration = getBuffDuration
            local getBuffRemain = getBuffRemain
            local getBuffStacks = getBuffStacks

            for k,v in pairs(self.spell.class.buffs) do
                self.buff[k]            = UnitBuffID("player",v) ~= nil
                self.buff.duration[k]   = getBuffDuration("player",v) or 0
                self.buff.remain[k]     = getBuffRemain("player",v) or 0
                self.buff.stack[k]      = getBuffStacks("player",v) or 0
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

            self.cast.debug.counterspell    = self.cast.counterspell("target",true)
            self.cast.debug.frostNova       = self.cast.frostNova("player",true)
			self.cast.debug.runeOfPower     = self.cast.runeOfPower("player",true)
		end

		-- Counterspell
        function self.cast.counterspell(thisUnit,debug)
            local spellCast = self.spell.counterspell
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 34 and self.cd.counterspell == 0 and self.powerPercentMana > 2 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Frost Nova
        function self.cast.frostNova(thisUnit,debug)
            local spellCast = self.spell.frostNova
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 3 and self.powerPercentMana > 2 and self.charges.frostNova > 0 and self.cd.frostNova == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Rune of Power
		function self.cast.runeOfPower(thisUnit,debug)
            local spellCast = self.spell.runeOfPower
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.runeOfPower and self.charges.runeOfPower > 0 and self.cd.runeOfPower == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
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
	end --End function cMage:new(spec)
end -- End Select 