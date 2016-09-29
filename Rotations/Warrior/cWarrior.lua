-- Inherit from: ../cCharacter.lua
-- All Warrior specs inherit from this file
if select(2, UnitClass("player")) == "WARRIOR" then
cWarrior = {}

-- Creates Warrior with given specialisation
function cWarrior:new(spec)
	local self = cCharacter:new("Warrior")

	local player = "player" -- if someone forgets ""

	-----------------
    --- VARIABLES ---
    -----------------

		self.profile         				= spec
		self.artifact 		 				= {} 		-- Artifact Traits
		self.artifact.rank  				= {} 		-- Artifact Trait Rank
		self.buff.duration	 				= {}		-- Buff Durations
		self.buff.remain 	 				= {}		-- Buff Time Remaining
        self.buff.stack                     = {}        -- Buff Stack Count
		self.cast 		     				= {}        -- Cast Spell Functions
		self.cast.debug 	 				= {} 		-- Debug Base Level Spell Casts
		self.debuff.duration 				= {}		-- Debuff Durations
		self.debuff.remain 	 				= {}		-- Debuff Time Remaining
		self.debuff.refresh             	= {}        -- Debuff Refreshable
        self.spell.class                	= {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      	= { 		-- List All Active Abilities/Talents Here that are used by All Specs in Class 
        	--sampleAbility 				= 123456,

        }
        self.spell.class.artifacts      	= {        -- Artifact Traits Available To All Specs in Class
        	--campleArtifact 				= 234561,
        }
        self.spell.class.buffs          	= {        -- Buffs Available To All Specs in Class
        	--sampleBuff 					= 345612.
        }
        self.spell.class.debuffs        	= {        -- Debuffs Available To All Specs in Class
        	--sampleDebuff 					= 456123,
        }
        self.spell.class.glyphs         	= {        -- Glyphs Available To All Specs in Class (not really a major thing anyore)

        }
        self.spell.class.talents        	= {        -- Talents Available To All Specs in Class
        	--sampleTalent 					= 561234,
        }

    ------------------
    --- OOC UPDATE ---
    ------------------

		function self.classUpdateOOC() -- Should not need to edit anything here
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

		function self.classUpdate() -- Should not need to edit anything here
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

        function self.getClassDynamicUnits() -- If you need to target unit(s) within a certain range then define here, 5yrd, 30yrd, and 40yrd have already been defined in cCharacter.lua
            local dynamicTarget = dynamicTarget

            --self.units.dyn8 	= dynamicTarget(8, true)
			--self.units.dyn8AoE 	= dynamicTarget(8, false)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getClassEnemies()
            local getEnemies = getEnemies -- If you need to cycle though a list of enemies or get a count of enemies in a certain yard radius then define here

            self.enemies.yards5     = getEnemies("player", 5) -- Melee
            self.enemies.yards8 	= getEnemies("player", 8) -- AoE
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

    	function self.getClassArtifacts() -- This builds a list of known Artifact Weapon Perks based on the spell ids provided above in the Artifacts list
    		local hasPerk = hasPerk

    		for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact[k] = hasPerk(v) or false
            end
    	end

    	function self.getClassArtifactRanks() -- This builds a list of known Artifact Weapon Perk Ranks based on the spell ids provided above in the Artifacts list
            local getPerkRank = getPerkRank
            
            for k,v in pairs(self.spell.spec.artifacts) do
                self.artifact.rank[k] = getPerkRank(v) or 0
            end
    	end

    -------------
    --- BUFFS ---
    -------------
	
		function self.getClassBuffs() -- This builds a list of known Buffs based on the spell ids provided above in the Buff list
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

		function self.getClassCharges() -- This builds a list of known Spell Charges/Recharge based on the spell ids provided above in the Abilities list
            local getCharges = getCharges

            for k,v in pairs(self.spell.class.abilities) do
                self.charges[k]     = getCharges(v)
                self.recharge[k]    = getRecharge(v)
            end
        end

	-----------------
	--- COOLDOWNS ---
	-----------------

		function self.getClassCooldowns() -- This builds a list of known Cooldowns based on the spell ids provided above in the Abilities list
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

		function self.getClassDebuffs() -- This builds a list of known Debuffs based on the spell ids provided above in the Debuff list
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

		function self.getClassGlyphs() -- See told you it wasnt really important
			local hasGlyph = hasGlyph

		end

	----------------
	--- TAALENTS ---
	----------------

		function self.getClassTalents() -- This builds a list of known Talents based on the spell ids provided above in the Talent list
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

		function self.getClassPerks() -- No longer used but kept just in case 
			local isKnown = isKnown

		end

	---------------
	--- OPTIONS ---
	---------------

		-- Class options
		-- Options which every Druid should have
		function self.createClassOptions() -- No need to edit
            -- Class Wrap
            local section = bb.ui:createSection(bb.ui.window.profile,  "Class Options", "Nothing")
            bb.ui:checkSectionState(section)
		end

	--------------
	--- SPELLS ---
	--------------

		function self.getClassCastable() -- Cast functions with debug option set to provide true/false returns on cast functions for debugging purposes
			--self.cast.debug.sampleSpell = self.cast.sampleSpell("target",true)
		end

		-- Sample Spell
		function self.cast.sampleSpell(thisUnit,debug)
            local spellCast = self.spell.sampleAbility -- (listed in ability list above)
            local thisUnit = thisUnit 
            if thisUnit == nil then thisUnit = self.units.dyn40AoE end -- (if thisUnit is not provided in the cast function then use the default defined here)
            if debug == nil then debug = false end

            if baseCastCondition1 and baseCastCondition2 then -- (What are the minimal requirements to cast this spell? IE: Minimal Power, Minimal Alternate Power, Minimal Level, etc
                if debug then -- Don't actually cast if debug option set to true
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false,false,true)
                end
            elseif debug then
                return false
            end
        end        

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

    	-- Any custom functions made can be listed here, some are already provided that assist with the toggle bar.

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
    	-- Do not edit this

		-- Return
		return self
	end --End function cWarrior:new(spec)
end -- End Select 