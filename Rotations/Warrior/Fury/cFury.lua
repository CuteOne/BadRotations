--- Fury Class
-- Inherit from: ../cCharacter.lua and ../cWarrior.lua
cFury = {}
cFury.rotations = {}

-- Creates Fury Warrior
function cFury:new()
    if GetSpecializationInfo(GetSpecialization()) == 72 then
        local self = cWarrior:new("Fury")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cFury.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------

        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            bladestorm                  = 46924,
            bloodbath                   = 12292,
            bloodthirst                 = 23881,
            commandingShout             = 97462,
            dragonRoar                  = 118000,
            enragedRegeneration         = 184364,
            execute                     = 5308,
            furiousSlash                = 100130,
            heroicLeap                  = 6544,
            intimidatingShout           = 5246,
            odynsFury                   = 205545,
            piercingHowl                = 12323,
            ragingBlow                  = 85288,
            rampage                     = 184367,
            taunt                       = 355,
            whirlwind                   = 190411, 
        }
        self.spell.spec.artifacts       = {
            juggernaut                  = 200875,
            odynsFury                   = 205545,
        }
        self.spell.spec.buffs           = {
            bladestorm                  = 46924,
            bloodbath                   = 12292,
            dragonRoar                  = 118000,
            enrage                      = 184362,
            enragedRegeneration         = 184364,
            frenzy                      = 202539,
            frothingBerserker           = 215572,
            fujiedasFury                = 207775,
            intimidatingShout           = 5246,
            juggernaut                  = 201009,
            massacre                    = 206316,
            meatCleaver                 = 85739,
            stoneHeart                  = 225947,
            tasteForBlood               = 206333,
            wreckingBall                = 215570,
        }
        self.spell.spec.debuffs         = {

        }
        self.spell.spec.debuffs.bleeds  = {

        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            bladestorm                  = 46924,
            bloodbath                   = 12292,
            dragonRoar                  = 118000,
            frenzy                      = 206313,
            frothingBerserker           = 215571,
            innerRage                   = 215573,
            massacre                    = 206315,
            outburst                    = 206320,
        }
        -- Merge all spell ability tables into self.spell
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.spell.class.abilities, self.spell.spec.abilities)
        
    ------------------
    --- OOC UPDATE ---
    ------------------

        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()
        end

    --------------
    --- UPDATE ---
    --------------

        function self.update()

            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            cFileBuild("spec",self)
            self.getToggleModes()
            
            -- Start selected rotation
            self:startRotation()
        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes()

            self.mode.rotation  = bb.data["Rotation"]
            self.mode.cooldown  = bb.data["Cooldown"]
            self.mode.defensive = bb.data["Defensive"]
            self.mode.interrupt = bb.data["Interrupt"]
            self.mode.mover     = bb.data["Mover"]
        end

        -- Create the toggle defined within rotation files
        function self.createToggles()
            GarbageButtons()
            if self.rotations[bb.selectedProfile] ~= nil then
                self.rotations[bb.selectedProfile].toggles()
            else
                return
            end
        end

    ---------------
    --- OPTIONS ---
    ---------------
        
        -- Creates the option/profile window
        function self.createOptions()
            bb.ui.window.profile = bb.ui:createProfileWindow(self.profile)

            -- Get the names of all profiles and create rotation dropdown
            local names = {}
            for i=1,#self.rotations do
                tinsert(names, self.rotations[i].name)
            end
            bb.ui:createRotationDropdown(bb.ui.window.profile.parent, names)

            -- Create Base and Class option table
            local optionTable = {
                {
                    [1] = "Base Options",
                    [2] = self.createBaseOptions,
                },
                {
                    [1] = "Class Options",
                    [2] = self.createClassOptions,
                },
            }

            -- Get profile defined options
            local profileTable = profileTable
            if self.rotations[bb.selectedProfile] ~= nil then
                profileTable = self.rotations[bb.selectedProfile].options()
            else
                return
            end

            -- Only add profile pages if they are found
            if profileTable then
                insertTableIntoTable(optionTable, profileTable)
            end

            -- Create pages dropdown
            bb.ui:createPagesDropdown(bb.ui.window.profile, optionTable)
            bb:checkProfileWindowStatus()
        end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------


    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cFury
end-- select Warrior