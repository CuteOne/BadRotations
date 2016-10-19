-- Inherit from: ../cCharacter.lua
-- All Priest specs inherit from this file
if select(2, UnitClass("player")) == "PRIEST" then
cPriest = {}

-- Creates Priest with given specialisation
function cPriest:new(spec)
	local self = cCharacter:new("Priest")

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
		self.debuff.count             		= {}        -- Debuff count
		self.debuff.duration 				= {}		-- Debuff Durations
		self.debuff.remain 	 				= {}		-- Debuff Time Remaining
		self.debuff.refresh             	= {}        -- Debuff Refreshable
        self.spell.class                	= {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      	= { 		-- List All Active Abilities/Talents Here that are used by All Specs in Class 
        	dispelMagic = 528,
            fade = 526,
            levitate = 1703,
            massDispel = 32375,
            mindBender = 200174,
            shadowMend = 186263,
            shadowWordPain = 589,
            shadowfiend = 34433,
            smite = 585,
            powerInfusion = 10060,
            powerWordShield = 17,
            purifyDisease = 213634,
            resurrection = 2006,
            shackleUndead = 9484
        }
        self.spell.class.artifacts      	= {}
        self.spell.class.buffs          	= {        -- Buffs Available To All Specs in Class
            powerWordShield = 17
        }
        self.spell.class.debuffs        	= {}
        self.spell.class.glyphs         	= {}
        self.spell.class.talents        	= {}

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

        -- Dispel Magic
        function self.cast.dispelMagic(thisUnit,debug)
            local spellCast = self.spell.dispelMagic
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if getDistance(thisUnit) < 40 and self.cd.dispelMagic == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false)
                end
            elseif debug then
                return false
            end
        end

        -- Fade
        function self.cast.fade(thisUnit,debug)
            local spellCast = self.spell.fade
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.cd.fade == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false)
                end
            elseif debug then
                return false
            end
        end  

        -- Levitate
        function self.cast.levitate(thisUnit,debug)
            local spellCast = self.spell.levitate
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if getDistance(thisUnit) < 40 and self.cd.levitate == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false)
                end
            elseif debug then
                return false
            end
        end  

        -- Mind Bender
        function self.cast.mindBender(thisUnit,debug)
            local spellCast = self.spell.mindBender
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if getDistance(thisUnit) < 40 and self.cd.mindBender == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Shadow Mend
        function self.cast.shadowMend(thisUnit,debug)
            local spellCast = self.spell.shadowMend
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if getDistance(thisUnit) < 40 and self.cd.shadowMend == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false)
                end
            elseif debug then
                return false
            end
        end

        -- Shadow Word: Pain
        function self.cast.shadowWordPain(thisUnit,debug)
            local spellCast = self.spell.shadowWordPain
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if getDistance(thisUnit) < 40 and self.cd.shadowWordPain == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false)
                end
            elseif debug then
                return false
            end
        end

        -- Shadowfiend
        function self.cast.shadowfiend(thisUnit,debug)
            local spellCast = self.spell.shadowfiend
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if getDistance(thisUnit) < 40 and self.cd.shadowfiend == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Smite
        function self.cast.smite(thisUnit,debug)
            local spellCast = self.spell.smite
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if getDistance(thisUnit) < 40 and self.cd.smite == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,true,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,true)
                end
            elseif debug then
                return false
            end
        end


        -- Power Infusion
        function self.cast.powerInfusion(thisUnit,debug)
            local spellCast = self.spell.powerInfusion
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.powerInfusion and self.cd.powerInfusion == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false)
                end
            elseif debug then
                return false
            end
        end

        -- Power Word: Shield
        function self.cast.powerWordShield(thisUnit,debug)
            local spellCast = self.spell.powerWordShield
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if getDistance(thisUnit) < 40 and self.cd.powerWordShield == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false)
                end
            elseif debug then
                return false
            end
        end   

        -- Resurrection
        function self.cast.resurrection(thisUnit,debug)
            local spellCast = self.spell.resurrection
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if getDistance(thisUnit) < 40 and self.cd.resurrection == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,true,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,true)
                end
            elseif debug then
                return false
            end
        end

        -- Shackle Undead
        function self.cast.shackleUndead(thisUnit,debug)
            local spellCast = self.spell.shackleUndead
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if getDistance(thisUnit) < 40 and self.cd.shackleUndead == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,true,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,true)
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