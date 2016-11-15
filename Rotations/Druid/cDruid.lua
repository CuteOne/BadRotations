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

		self.profile                    = spec
		self.stealth		                = false
        self.spell.class                = {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      = {
            bearForm 					          = 5487,
            catForm 					          = 768,
            dash 						            = 1850,
            displacerBeast 				      = 102280,
            dreamwalk 					        = 193753,
            entanglingRoots 			      = 339,
            flightForm 					        = 165962,
            growl 						          = 6795,
            massEntanglement 			      = 102359,
            mightyBash 					        = 5211,
            moonfire 					          = 8921,
            prowl 						          = 5215,
            rebirth 					          = 20484,
            regrowth                    = 8936,
            revive 						          = 50769,
            shadowmeld                  = 58984,
            stagForm 					          = 210053,
            travelForm 					        = 783,
            typhoon 					          = 132469,
            wildCharge 					        = 102401,
        }
        self.spell.class.artifacts      = {        -- Artifact Traits Available To All Specs in Class
            artificialStamina 			    = 211309,
        }
        self.spell.class.buffs          = {        -- Buffs Available To All Specs in Class
            bearForm 	 				          = 5487,
            catForm 					          = 768,
            dash 						            = 1850,
            displacerBeast 				      = 137452,
            flightForm 					        = 165962,
            prowl 						          = 5215,
            shadowmeld                  = 58984,
            stagForm 	 				          = 210053,
            travelForm  				        = 783,
        }
        self.spell.class.debuffs        = {        -- Debuffs Available To All Specs in Class
            entanglingRoots 	 		      = 339,
            growl 		 				          = 6795,
            moonfire 	 				          = 8921,
        }
        self.spell.class.glyphs         = {        -- Glyphs Available To All Specs in Class
            glyphOfTheCheetah 			    = 131113,
            glyphOfTheDoe 				      = 224122,
            glyphOfTheFeralChameleon 	  = 210333,
            glyphOfTheOrca 				      = 114333,
            glyphOfTheSentinel 			    = 219062,
            glyphOfTheUrsolChameleon 	  = 107059, 
        }
        self.spell.class.talents        = {        -- Talents Available To All Specs in Class
            displacerBeast 				      = 102280,
            massEntanglement 			      = 102359,
            mightyBash 					        = 5211,
            typhoon 					          = 132469,
            wildCharge 					        = 102401,
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
        -- Options which every Warrior should have
        function self.createClassOptions()
            -- Class Wrap
            local section = br.ui:createSection(br.ui.window.profile,  "Class Options", "Nothing")
            br.ui:checkSectionState(section)
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