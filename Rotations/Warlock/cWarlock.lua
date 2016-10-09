-- Inherit from: ../cCharacter.lua
-- All Warlock specs inherit from this file
if select(2, UnitClass("player")) == "WARLOCK" then
cWarlock = {}

-- Creates Warlock with given specialisation
function cWarlock:new(spec)
	local self = cCharacter:new("Warlock")

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
        self.buff.pet                       = {}        -- Buffs on Pets
		self.cast 		     				= {}        -- Cast Spell Functions
		self.cast.debug 	 				= {}
		self.debuff.duration 				= {}		-- Debuff Durations
		self.debuff.remain 	 				= {}		-- Debuff Time Remaining
		self.debuff.refresh             	= {}        -- Debuff Refreshable
        self.debuff.stack                   = {}        -- Debuff Stacks 
        self.shards                         = getPowerAlt("player")
        self.spell.class                	= {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      	= {
            darkPack                        = 108416,
            drainLife                       = 689,
            fear                            = 5782,
            grimoireFelhunter               = 111897,
            grimoireImp                     = 111859,
            grimoireSuccubus                = 111896,
            grimoireVoidwalker              = 111895,
            lifeTap                         = 1454,
            soulHarvest                     = 196098,
            summonDoomguard                 = 18540,
            summonFelhunter                 = 691,
            summonImp                       = 688,
            summonInfernal                  = 1122,
            summonSuccubus                  = 712,
            summonVoidwalker                = 697,
            unendingResolve                 = 104773,
        }
        self.spell.class.artifacts      	= {        -- Artifact Traits Available To All Specs in Class
            
        }
        self.spell.class.buffs          	= {        -- Buffs Available To All Specs in Class
            demonicSynergy                  = 171982,
            soulHarvest                     = 196098,
        }
        self.spell.class.debuffs        	= {        -- Debuffs Available To All Specs in Class

        }
        self.spell.class.glyphs         	= {        -- Glyphs Available To All Specs in Class

        }
        self.spell.class.talents        	= {        -- Talents Available To All Specs in Class
            darkPact                        = 108416,
            grimoireOfService               = 108501,
            grimoireOfSupremacy             = 152107,
            soulHarvest                     = 196098,
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

            self.enemies.yards5     = getEnemies("player", 5)
            self.enemies.yards8 	= getEnemies("player", 8)
            self.enemies.yards20    = getEnemies("player", 20)
            self.enemies.yards30    = getEnemies("player", 30)
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

            self.cast.debug.darkPact           = self.cast.darkPact("player",true)
            self.cast.debug.drainLife          = self.cast.drainLife("target",true)
            self.cast.debug.grimoireFelhunter  = self.cast.grimoireFelhunter("player",true)
            self.cast.debug.grimoireImp        = self.cast.grimoireImp("player",true)
            self.cast.debug.grimoireSuccubus   = self.cast.grimoireSuccubus("player",true)
            self.cast.debug.grimoireVoidwalker = self.cast.grimoireVoidwalker("player",true)
            self.cast.debug.lifeTap            = self.cast.lifeTap("player",true)
            self.cast.debug.summonDoomguard    = self.cast.summonDoomguard("player",true)
            self.cast.debug.summonFelhunter    = self.cast.summonFelhunter("player",true)
            self.cast.debug.summonImp          = self.cast.summonImp("player",true)
            self.cast.debug.summonInfernal     = self.cast.summonInfernal("player",true)
            self.cast.debug.summonSuccubus     = self.cast.summonSuccubus("player",true)
            self.cast.debug.summonVoidwalker   = self.cast.summonVoidwalker("player",true)
		end

		-- Dark Pact
        function self.cast.darkPact(thisUnit,debug)
            local spellCast = self.spell.darkPact
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.darkPact and self.cd.darkPact == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Drain Life
        function self.cast.drainLife(thisUnit,debug)
            local spellCast = self.spell.drainLife
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 1 and self.powerPercentMana > 3 and self.cd.drainLife == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Grimoire: Felhunter
        function self.cast.grimoireFelhunter(thisUnit,debug)
            local spellCast = self.spell.grimoireFelhunter
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.grimoireOfService and self.shards > 0 and self.cd.grimoireFelhunter == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Grimoire: Imp
        function self.cast.grimoireImp(thisUnit,debug)
            local spellCast = self.spell.grimoireImp
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.grimoireOfService and self.shards > 0 and self.cd.grimoireImp == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Grimoire: Succubus
        function self.cast.grimoireSuccubus(thisUnit,debug)
            local spellCast = self.spell.grimoireSuccubus
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.grimoireOfService and self.shards > 0 and self.cd.grimoireSuccubus == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Grimoire: Voidwalker
        function self.cast.grimoireVoidwalker(thisUnit,debug)
            local spellCast = self.spell.grimoireVoidwalker
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.talent.grimoireOfService and self.shards > 0 and self.cd.grimoireVoidwalker == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Life Tap
        function self.cast.lifeTap(thisUnit,debug)
            local spellCast = self.spell.lifeTap
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 34 and self.health > 10 and self.cd.lifeTap == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Soul Harvest
        function self.cast.soulHarvest(thisUnit,debug)
            local spellCast = self.spell.soulHarvest
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.talent.soulHarvest and self.cd.soulHarvest == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Summon Doomguard
        function self.cast.summonDoomguard(thisUnit,debug)
            local spellCast = self.spell.summonDoomguard
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn40 end
            if debug == nil then debug = false end

            if self.level >= 58 and self.shards > 0 and self.cd.summonDoomguard == 0 and getDistance(thisUnit) < 40 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Summon Felhunter
        function self.cast.summonFelhunter(thisUnit,debug)
            local spellCast = self.spell.summonFelhunter
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 35 and self.shards > 0 and self.cd.summonFelhunter == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Summon Imp
        function self.cast.summonImp(thisUnit,debug)
            local spellCast = self.spell.summonImp
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 1 and self.shards > 0 and self.cd.summonImp == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Summon Infernal
		function self.cast.summonInfernal(thisUnit,debug)
            local spellCast = self.spell.summonInfernal
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 50 and self.shards > 0 and self.cd.summonInfernal == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castGround(thisUnit,spellCast,30)
                end
            elseif debug then
                return false
            end
        end
        -- Summon Succubus
        function self.cast.summonSuccubus(thisUnit,debug)
            local spellCast = self.spell.summonSuccubus
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 28 and self.shards > 0 and self.cd.summonSuccubus == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,true,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Summon Doomguard
        function self.cast.summonVoidwalker(thisUnit,debug)
            local spellCast = self.spell.summonVoidwalker
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 8 and self.shards > 0 and self.cd.summonVoidwalker == 0 then
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
	end --End function cWarlock:new(spec)
end -- End Select 