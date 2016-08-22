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
        	annihilation 					= 201427,
        	bladeDance 						= 188499,
        	blur 							= 198589,
        	chaosNova 						= 179057,
        	chaosStrike 					= 162794,
        	consumeMagic 					= 183752,
        	darkness 						= 196718,
        	deathSweep 						= 210152,
        	demonsBite 						= 162243,
        	eyeBeam 						= 198013,
        	felblade 						= 213241, 
        	felEruption 					= 211881,
        	felRush 						= 195072,
        	furyOfTheIllidari 				= 201628,
        	glide 							= 131347,
        	imprison 						= 217832,
        	metamorphosis 					= 191427,
        	soulCarver 						= 214743,
        	spectralSight 					= 188501,
        	throwGlaive 					= 185123,
        	vengefulRetreat 				= 198793,
        }
        self.spell.class.artifacts      	= {        -- Artifact Traits Available To All Specs in Class
        	artificialStamina 				= 211309,
        }
        self.spell.class.buffs          	= {        -- Buffs Available To All Specs in Class
        	metamorphosis 					= 162264,
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
        	felblade 						= 213241, 
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
            self.units.dyn20 	= dynamicTarget(20, true)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getClassEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = getEnemies("player", 5) -- Melee
            self.enemies.yards8 	= getEnemies("player", 8) -- AoE
            self.enemies.yards20    = getEnemies("player", 20) -- Interrupts
            self.enemies.yards30 	= getEnemies("player", 30) -- Throw Glaive
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
			self.cast.debug.annihilation 		= self.cast.annihilation("target",true)
			self.cast.debug.bladeDance 			= self.cast.bladeDance("player",true)
			self.cast.debug.blur 				= self.cast.blur("player",true)
        	self.cast.debug.chaosNova 			= self.cast.chaosNova("player",true)
        	self.cast.debug.chaosStrike 		= self.cast.chaosStrike("target",true)
        	self.cast.debug.consumeMagic 		= self.cast.consumeMagic("target",true)
        	self.cast.debug.darkness 			= self.cast.darkness("player",true)
        	self.cast.debug.deathSweep 			= self.cast.deathSweep("player",true)
        	self.cast.debug.demonsBite 			= self.cast.demonsBite("target",true)
        	self.cast.debug.eyeBeam 			= self.cast.eyeBeam("player",true)
   --      	self.cast.debug.felblade 			= self.cast.felblade
   --      	self.cast.debug.felEruption 		= self.cast.felEruption
        	self.cast.debug.felRush 			= self.cast.felRush("player",true)
   --      	self.cast.debug.furyOfTheIllidari 	= self.cast.furyOfTheIllidari
        	self.cast.debug.imprison 			= self.cast.imprison("target",true)
        	self.cast.debug.metamorphosis 		= self.cast.metamorphosis("player",true)
   --      	self.cast.debug.soulCarver 			= self.cast.soulCarver 
        	self.cast.debug.throwGlaive 		= self.cast.throwGlaive("target",true)
        	self.cast.debug.vengefulRetreat 	= self.cast.vengefulRetreat("player",true)
		end

		-- Annihilation
		function self.cast.annihilation(thisUnit,debug)
            local spellCast = self.spell.annihilation
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 98 and self.power > 40 and self.cd.annihilation == 0 and self.buff.metamorphosis and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,true,false,false,true,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false,true,false,false,true)
                end
            elseif debug then
                return false
            end
        end
		-- Blade Dance
		function self.cast.bladeDance(thisUnit,debug)
            local spellCast = self.spell.bladeDance
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 98 and self.power > 40 and self.cd.bladeDance == 0 and not self.buff.metamorphosis and getDistance(self.units.dyn5) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Blur
		function self.cast.blur(thisUnit,debug)
            local spellCast = self.spell.blur
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end
            if self.buff.metamorphosis then spellCast = self.spell.deathSweep end

            if self.level >= 100 and isKnown(spellCast) and self.cd.blur == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Chaos Nova
		function self.cast.chaosNova(thisUnit,debug)
            local spellCast = self.spell.chaosNova
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 100 and isKnown(spellCast) and self.power > 30 and self.cd.chaosNova == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
		-- Chaos Strike
		function self.cast.chaosStrike(thisUnit,debug)
            local spellCast = self.spell.chaosStrike
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if self.level >= 98 and self.power > 40 and self.cd.chaosStrike == 0 and not self.buff.metamorphosis and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
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
        -- Darkness
		function self.cast.darkness(thisUnit,debug)
            local spellCast = self.spell.darkness
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 100 and isKnown(spellCast) and self.cd.darkness == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
       	-- Death Sweep
		function self.cast.deathSweep(thisUnit,debug)
            local spellCast = self.spell.deathSweep
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 98 and self.power > 40 and self.cd.deathSweep == 0 and self.buff.metamorphosis and getDistance(self.units.dyn5) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,true,false,false,true,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false,true,false,false,true)
                end
            elseif debug then
                return false
            end
        end
        -- Demon's Bite
		function self.cast.demonsBite(thisUnit,debug)
            local spellCast = self.spell.demonsBite
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn5 end
            if debug == nil then debug = false end

            if not self.talent.demonBlades and self.level >= 98 and self.power <= 70 and getDistance(thisUnit) < 5 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Eye Beam
		function self.cast.eyeBeam(thisUnit,debug)
            local spellCast = self.spell.eyeBeam
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 98 and isKnown(spellCast) and self.cd.eyeBeam == 0 and self.power > 50 and getDistance(self.units.dyn8) < 8 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Fel Rush
		function self.cast.felRush(thisUnit,debug)
            local spellCast = self.spell.felRush
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 98 and self.charges.felRush > 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,false,false,false)
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
        -- Metamorphosis
		function self.cast.metamorphosis(thisUnit,debug)
            local spellCast = self.spell.metamorphosis
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn8AoE end
            if debug == nil then debug = false end

            if self.level >= 99 and self.cd.metamorphosis == 0 then
                if debug then
                    return castSpell(thisUnit,spellCast,false,false,false,false,false,false,false,true)
                else
                    return castGround(thisUnit,spellCast,8)
                end
            elseif debug then
                return false
            end
        end
        -- Throw Glaive
		function self.cast.throwGlaive(thisUnit,debug)
            local spellCast = self.spell.throwGlaive
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = self.units.dyn30 end
            if debug == nil then debug = false end

            if self.level >= 99 and isKnown(spellCast) and self.charges.throwGlaive > 0 and hasThreat(thisUnit) and getDistance(thisUnit) < 30 then
                if debug then
                    return castSpell(thisUnit,spellCast,true,false,false,false,false,false,false,true)
                else
                    return castSpell(thisUnit,spellCast,true,false,false)
                end
            elseif debug then
                return false
            end
        end
        -- Vengeful Retreat
		function self.cast.vengefulRetreat(thisUnit,debug)
            local spellCast = self.spell.vengefulRetreat
            local thisUnit = thisUnit
            if thisUnit == nil then thisUnit = "player" end
            if debug == nil then debug = false end

            if self.level >= 100 and isKnown(spellCast) and self.cd.vengefulRetreat == 0 then
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
            if self.mode.mover == 1 then
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