--- Guardian Class
-- Inherit from: ../cCharacter.lua and ../cDruid.lua
cGuardian = {}
cGuardian.rotations = {}

-- Creates Guardian Druid
function cGuardian:new()
    if GetSpecializationInfo(GetSpecialization()) == 104 then
        local self = cDruid:new("Guardian")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cGuardian.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------

        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            barkskin                    = 22812,
            bristlingFur                = 155835,
            frenziedRegeneration        = 22842,
            incapacitatingRoar          = 99,
            incarnationGuardianOfUrsoc  = 102558,
            ironfur                     = 192081,
            lunarBeam                   = 204066,
            mangle                      = 33917,
            markOfUrsol                 = 192083,
            maul                        = 6807,
            pulverize                   = 80313,
            rageOfTheSleeper            = 200851,
            removeCorruption            = 2782,
            skullBash                   = 106839,
            stampedingRoar              = 106898,
            survivalInstincts           = 61336,
            swipe                       = 213771, --106785, 
            thrash                      = 77758, -- 106830, 
        }
        self.spell.spec.artifacts       = {
            rageOfTheSleeper            = 200851,
        }
        self.spell.spec.buffs           = {
            frenziedRegeneration        = 22842,
            galacticGuardian            = 213708,
            ironfur                     = 192081,
            markOfUrsol                 = 192083,
            pulverize                   = 158792,
            survivalInstincts           = 61336,
        }
        self.spell.spec.debuffs         = {
            moonfireGuardian            = 164812,
            thrash                      = 192090,
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            balanceAffinity             = 197488,
            bloodFrenzy                 = 203962,
            brambles                    = 203953,
            bristlingFur                = 155835,
            earthwarden                 = 203974,
            feralAffinity               = 202155,
            galacticGuardian            = 203964,
            guardianOfElune             = 155578,
            gutteralRoars               = 204012,
            incarnationGuardianOfUrsoc  = 102558,
            lunarBeam                   = 204066,
            pulverize                   = 80313,
            rendAndTear                 = 204053,
            restorationAffinity         = 197492,
            soulOfTheForest             = 158477,
            survivalOfTheFittest        = 203965,
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

            self.mode.rotation  = br.data["Rotation"]
            self.mode.cooldown  = br.data["Cooldown"]
            self.mode.defensive = br.data["Defensive"]
            self.mode.interrupt = br.data["Interrupt"]
            self.mode.cleave    = br.data["Cleave"]
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
        --Target HP
        function thp(unit)
            return getHP(unit)
        end

        --Target Time to Die
        function ttd(unit)
            return getTimeToDie(unit)
        end

        --Target Distance
        function tarDist(unit)
            return getDistance(unit)
        end

        function useCleave()
            if self.mode.cleave == 1 and self.mode.rotation < 3 then
                return true
            else
                return false
            end
        end

        function useProwl()
            if self.mode.prowl==1 then
                return true
            else
                return false
            end
        end

        function outOfWater()
            if swimTime == nil then swimTime = 0 end
            if outTime == nil then outTime = 0 end
            if IsSwimming() then
                swimTime = GetTime()
                outTime = 0
            end
            if not IsSwimming() then
                outTime = swimTime
                swimTime = 0
            end
            if outTime ~= 0 and swimTime == 0 then
                return true
            end
            if outTime ~= 0 and IsFlying() then
                outTime = 0
                return false
            end
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cGuardian
end-- select Druid