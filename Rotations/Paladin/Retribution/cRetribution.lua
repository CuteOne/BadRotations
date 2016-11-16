--- Assassination Class
-- Inherit from: ../cCharacter.lua and ../cPaladin.lua
cRetribution = {}
cRetribution.rotations = {}

-- Creates Retribution Paladin
function cRetribution:new()
    if GetSpecializationInfo(GetSpecialization()) == 70 then
        local self = cPaladin:new("Retribution")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cRetribution.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            avengingWrath               = 31884,
            bladeOfJustice              = 184575,
            cleanseToxins               = 213644,
            consecration                = 205228,
            crusade                     = 224668,
            divineHammer                = 198034,
            divineStorm                 = 53385,
            executionSentence           = 213757,
            eyeForAnEye                 = 205191,
            greaterBlessingOfKings      = 203538,
            greaterBlessingOfMight      = 203528,
            greaterBlessingOfWisdom     = 203539,
            handOfHinderance            = 183218,
            holyWrath                   = 210220,
            justicarsVengeance          = 215661,
            rebuke                      = 96231,
            sealOfLight                 = 202273,
            shieldOfVengeance           = 184662,
            templarsVerdict             = 85256,
            wakeOfAshes                 = 205273,
            wordOfGlory                 = 210191,
            zeal                        = 217020,
        }
        self.spell.spec.artifacts       = {
            ashbringersLight            = 207604,
            ashesToAshes                = 179546,
            bladeOfLight                = 214081,
            deflection                  = 184778,
            deliverTheJustice           = 186927,
            divineTempest               = 186773,
            echoOfTheHighlord           = 186788,
            embraceTheLight             = 186934,
            endlessResolve              = 185086,
            healingStorm                = 193058,
            highlordsJudgment           = 186941,
            mightOfTheTemplar           = 185368,
            protectorOfTheAshenBlade    = 186944,
            righteousBlade              = 184843,
            sharpenedEdge               = 184759,
            unbreakableWill             = 182234,
            wakeOfAshes                 = 205273,
            wrathOfTheAshbringer        = 186945,
        }
        self.spell.spec.buffs           = {
            divinePurpose               = 223819,
            theFiresOfJustice           = 209785,
            whisperOfTheNathrezim       = 207635,
        }
        self.spell.spec.debuffs         = {

        }
        self.spell.spec.glyphs          = {
            glyphOfWingedVengeance      = 57979,
        }
        self.spell.spec.talents         = {
            bladeOfWrath                = 231832,
            consecration                = 205228,
            crusade                     = 231895,
            divineHammer                = 198034,
            divineIntervention          = 213313,
            executionSentence           = 213757,
            eyeForAnEye                 = 205191,
            finalVerdict                = 198038,
            greaterJudgment             = 218178,
            holyWrath                   = 210220,
            justicarsVengeance          = 215661,
            sealOfLight                 = 202273,
            theFiresOfJustice           = 203316,
            virtuesBlade                = 202271,
            wordOfGlory                 = 210191,
            zeal                        = 217020,
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

        end

        -- Create the toggle defined within rotation files
        function self.createToggles()
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
        
        -- Creates the option/profile window
        function self.createOptions()
            br.ui.window.profile = br.ui:createProfileWindow(self.profile)

            -- Get the names of all profiles and create rotation dropdown
            local names = {}
            for i=1,#self.rotations do
                tinsert(names, self.rotations[i].name)
            end
            br.ui:createRotationDropdown(br.ui.window.profile.parent, names)

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
            if self.rotations[br.selectedProfile] ~= nil then 
                profileTable = self.rotations[br.selectedProfile].options()
            else
                return
            end

            -- Only add profile pages if they are found
            if profileTable then
                insertTableIntoTable(optionTable, profileTable)
            end

            -- Create pages dropdown
            br.ui:createPagesDropdown(br.ui.window.profile, optionTable)
            br:checkProfileWindowStatus()
        end
        
    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cRetribution
end-- select Paladin