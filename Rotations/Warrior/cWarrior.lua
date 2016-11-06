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

        self.profile                    = spec
        self.spell.class                = {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      = {
            avatar                      = 107574,
            battleCry                   = 1719,
            berserkerRage               = 18499,
            charge                      = 100,
            giftOfTheNaaru              = 28880,
            heroicLeap                  = 6544,
            heroicThrow                 = 57755,
            pummel                      = 6552,
            shockwave                   = 46968,
            stormBolt                   = 107570,
        }
        self.spell.class.artifacts      = {        -- Artifact Traits Available To All Specs in Class
            artificialStamina           = 211309,
        }
        self.spell.class.buffs          = {        -- Buffs Available To All Specs in Class
            avatar                      = 107574,
            battleCry                   = 1719,
            berserkerRage               = 18499,
        }
        self.spell.class.debuffs        = {        -- Debuffs Available To All Specs in Class

        }
        self.spell.class.glyphs         = {        -- Glyphs Available To All Specs in Class

        }
        self.spell.class.talents        = {        -- Talents Available To All Specs in Class
            avatar                      = 107574,
            shockwave                   = 46968,
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

            -- Update Energy Regeneration
            self.powerRegen  = getRegen("player")
        end

    ---------------
    --- OPTIONS ---
    ---------------

        -- Class options
        -- Options which every Warrior should have
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

        function useMover()
            if self.mode.mover == 1 then
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
    end --End function cWarrior:new(spec)
end -- End Select 