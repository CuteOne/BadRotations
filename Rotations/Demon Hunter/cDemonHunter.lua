-- Inherit from: ../cCharacter.lua
-- All Death Knight specs inherit from this file
if select(2, UnitClass("player")) == "DEMONHUNTER" then
cDemonHunter = {}

-- Creates Death Knight with given specialisation
function cDemonHunter:new(spec)
	local self = cCharacter:new("Demon Hunter")

	local player = "player" -- if someone forgets ""

	-----------------
    --- VARIABLES ---
    -----------------

		self.profile         				= spec
		self.artifact 		 				= {}
		self.artifact.rank   				= {}
		self.buff.duration	 				= {}		-- Buff Durations
		self.buff.remain 	 				= {}		-- Buff Time Remaining
		self.cast 		     				= {}        -- Cast Spell Functions
		self.cast.debug 	 				= {}
		self.debuff.duration 				= {}		-- Debuff Durations
		self.debuff.remain 	 				= {}		-- Debuff Time Remaining
		self.debuff.refresh             	= {}       -- Debuff Refreshable
        self.spell.class                	= {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      	= {
            consumeMagic 					= 183752,
            felblade                        = 232893,
            felEruption                     = 211881,
        	glide 							= 131347,
        	imprison 						= 217832,
        	spectralSight 					= 188501,
        }
        self.spell.class.artifacts      	= {        -- Artifact Traits Available To All Specs in Class
        	artificialStamina 				= 211309,
        }
        self.spell.class.buffs          	= {        -- Buffs Available To All Specs in Class
            glide                           = 131347,
        }
        self.spell.class.debuffs        	= {        -- Debuffs Available To All Specs in Class

        }
        self.spell.class.glyphs         	= {        -- Glyphs Available To All Specs in Class
 			glyphOfCracklingFlames 			= 219831,
 			glyphOfFallowWings 				= 220083,
 			glyphOfFearsomeMetamorphosis 	= 220831,
 			glyphOfFelTouchedSouls 			= 219713,
 			glyphOfFelWings 				= 220228,
 			glyphOfFelEnemies 				= 220240,
 			glyphOfManaTouchedSouls 		= 219744,
 			glyphOfShadowEnemies 			= 220244,
 			glyphOfTatteredWings 			= 220226,
        }
        self.spell.class.talents        	= {        -- Talents Available To All Specs in Class
        	felblade 						= 232893,
        	felEruption 					= 211881,
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
            self.units.dyn15    = dynamicTarget(15, true)
            self.units.dyn20 	= dynamicTarget(20, true)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getClassEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = getEnemies("player", 5) -- Melee
            self.enemies.yards8 	= getEnemies("player", 8) -- AoE
            self.enemies.yards15    = getEnemies("player", 15)
            self.enemies.yards20    = getEnemies("player", 20) -- Interrupts
            self.enemies.yards30 	= getEnemies("player", 30) -- Throw Glaive
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
			
        	self.cast.debug.consumeMagic 		= self.cast.consumeMagic("target",true)
        	self.cast.debug.felblade 			= self.cast.felblade("target",true)
        	self.cast.debug.felEruption 		= self.cast.felEruption("target",true)
            self.cast.debug.glide               = self.cast.glide("player",true)
        	self.cast.debug.imprison 			= self.cast.imprison("target",true)
		end

        -- Consume Magic
		function self.cast.consumeMagic(thisUnit,debug)
            local spellCast = self.spell.consumeMagic
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn20 end
            if debug == nil then debug = false end

            if self.level >= 98 and isKnown(spellCast) and self.cd.consumeMagic == 0 and getDistance(thisUnit) < 20 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Felblade
        function self.cast.felblade(thisUnit,debug)
            local spellCast = self.spell.felblade
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn15 end
            if debug == nil then debug = false end
            if self.talent.felblade and self.cd.felblade == 0 and getDistance(thisUnit) < 15 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Fel Eruption
        function self.cast.felEruption(thisUnit,debug)
            local spellCast = self.spell.felEruption
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn20 end
            if debug == nil then debug = false end

            if self.talent.felEruption and self.cd.felEruption == 0 and ((self.spec == "HAVOC" and self.power > 20) or (self.spec == "VENGEANCE" and self.power > 10)) 
                and getDistance(thisUnit) < 20 
            then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Glide
        function self.cast.glide(thisUnit,debug)
            local spellCast = self.spell.glide
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 98 and isKnown(spellCast) and self.cd.glide == 0 and IsFalling() ~= nil and not self.buff.glide then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Imprison
		function self.cast.imprison(thisUnit,debug)
            local spellCast = self.spell.imprison
            local unitType = UnitCreatureType(thisUnit) or "None"
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn20 end
            if debug == nil then debug = false end

            if self.level >= 100 and isKnown(spellCast) and self.cd.imprison == 0 and unitType == "Demon" then
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

        function useMover()
            if self.mode.mover == 1 or self.mode.mover == 2 then
                return true
            else
                return false
            end
        end

        function eyeBeamCastRemain()
        	if isCastingSpell(self.spell.eyeBeam,"player") then
        		return getCastTimeRemain("player")
        	else
        		return 0
        	end
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------
		-- Return
		return self
	end --End function cDemonhunter:new(spec)
end -- End Select 
