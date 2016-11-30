-- Inherit from: ../cCharacter.lua
-- All Hunter specs inherit from this file
if select(2, UnitClass("player")) == "HUNTER" then
    cHunter = {}
    -- Creates Hunter with given specialisation
    function cHunter:new(spec)
            local self = cCharacter:new("Hunter")

            local player = "player" -- if someone forgets ""

    -----------------
    --- VARIABLES ---
    -----------------

        self.profile                    = spec
        self.stealth                        = false
        self.spell.class                = {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      = {}
        self.spell.class.artifacts      = {}        -- Artifact Traits Available To All Specs in Class
        
        self.spell.class.buffs          = {}        -- Buffs Available To All Specs in Class
        self.spell.class.debuffs        = {}       -- Debuffs Available To All Specs in Class
        self.spell.class.glyphs         = {}        -- Glyphs Available To All Specs in Class
        self.spell.class.talents        = {}        -- Talents Available To All Specs in Class
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
    end --End function cHunter:new(spec)
end -- End Select 