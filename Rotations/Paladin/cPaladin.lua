-- Inherit from: ../cCharacter.lua
-- All Paladin specs inherit from this file
if select(2, UnitClass("player")) == "PALADIN" then
    cPaladin = {}
    -- Creates Paladin with given specialisation
    function cPaladin:new(spec)
        local self = cCharacter:new("Paladin")

        local player = "player" -- if someone forgets ""

    -----------------
    --- VARIABLES ---
    -----------------

        self.profile                    = spec
        self.spell.class                = {}        -- Abilities Available To All Specs in Class
        self.spell.class.abilities      = {
            blessingOfFreedom           = 1044,
            blessingOfProtection        = 1022,
            blindingLight               = 115750,
            contemplation               = 121183,
            crusaderStrike              = 35395,
            divineShield                = 642,
            flashOfLight                = 19750,
            hammerOfJustice             = 853,
            handOfReckoning             = 62124,
            judgment                    = 20271,
            layOnHands                  = 633,
            redemption                  = 7328,
            repentance                  = 20066,
            tyrsDeliverance             = 200654,
        }
        self.spell.class.artifacts      = {        -- Artifact Traits Available To All Specs in Class
            artificialStamina           = 211309,
        }
        self.spell.class.buffs          = {        -- Buffs Available To All Specs in Class

        }
        self.spell.class.debuffs        = {        -- Debuffs Available To All Specs in Class
            judgment                    = 197277,
        }
        self.spell.class.glyphs         = {        -- Glyphs Available To All Specs in Class
            glyphOfFireFromHeavens      = 57954,
            glyphOfPillarOfLight        = 146959,
            glyphOfTheLuminousCharger   = 89401,
            glyphOfTheQueen             = 212642,
        }
        self.spell.class.talents        = {        -- Talents Available To All Specs in Class
            blindingLight               = 115750,
            repentance                  = 20066,
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
            self.getClassToggleModes()
        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getClassToggleModes()

            self.mode.rotation      = br.data["Rotation"]
            self.mode.cooldown      = br.data["Cooldown"]
            self.mode.defensive     = br.data["Defensive"]
            self.mode.interrupt     = br.data["Interrupt"]
        end

        -- Create the toggle defined within rotation files
        function self.createClassToggles()
            GarbageButtons()
            if self.rotations[br.selectedProfile] ~= nil then
                self.rotations[br.selectedProfile].toggles()
            else
                return
            end
        end

    ---------------
    --- OPTIONS ---
    ---------------

        -- Class options
        -- Options which every Rogue should have
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
    end --End function cRogue:new(spec)
end -- End Select 