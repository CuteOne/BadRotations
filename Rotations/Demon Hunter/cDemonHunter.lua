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
		end

    --------------
    --- UPDATE ---
    --------------

		function self.classUpdate()
			-- Call baseUpdate()
			self.baseUpdate()
            cFileBuild("class",self)
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
