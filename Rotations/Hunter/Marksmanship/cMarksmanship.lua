--- Marksmanship Class
-- Inherit from: ../cCharacter.lua and ../cHunter.lua
cMarksmanship = {}
cMarksmanship.rotations = {}

-- Creates Marksmanship Hunter
function cMarksmanship:new()
    if GetSpecializationInfo(GetSpecialization()) == 254 then
        local self = cHunter:new("Marksmanship")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cMarksmanship.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
        self.debuffcount                = {}
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            aMurderOfCrows = 131894,
            aimedShot = 19434,
            arcaneShot = 185358,
            aspectOfTheCheetah = 186257,
            aspectOfTheTurtle = 186265,
            barrage = 120360,
            bindingShot = 109248,
            blackArrow = 194599,
            burstingShot = 186387,
            concussiveShot = 5116,
            counterShot = 147362,
            disengage = 781,
            eagleEye = 6197,
            exhilaration = 109304,
            explosiveShot = 212431,
            feignDeath = 5384,
            flare = 1543,
            markedShot = 185901,
            misdirection = 34477,
            multiShot = 2643,
            piercingShot = 198670,
            sidewinders = 214579,
            trueshot = 193526,
            windburst = 204147,
            volley = 194386
        }
        self.spell.spec.artifacts       = {}
        self.spell.spec.buffs           = {
            lockAndLoad =194594,
            markingTargets = 223138,
            trueshot = 193526
        }
        self.spell.spec.debuffs         = {
            huntersMark = 185365,
            vulnerable = 187131
        }
        self.spell.spec.glyphs          = {}
        self.spell.spec.talents         = {
            loneWolf = 155228,
            steadyFocus = 193533,
            carfulAim = 53238,
            lockAndLoad =194595,
            blackArrow = 194599,
            trueAim = 199527,
            explosiveShot = 212431,
            sentinel = 206817,
            patientSniper = 213423,
            aMurderOfCrows = 131894,
            barrage = 120360,
            volley = 194386,
            sidewinders = 214579,
            piercingShot = 198670,
            trickShot = 199544
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
            self.getDebuffsCount()
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

        function self.getDebuffsCount()
            local UnitDebuffID = UnitDebuffID
            local huntersMarkCount = 0
            local vulnerableCount = 0

            if huntersMarkCount>0 and not inCombat then huntersMarkCount = 0 end
            if vulnerableCount>0 and not inCombat then vulnerableCount = 0 end

            for i=1,#getEnemies("player", 40) do
                local thisUnit = getEnemies("player", 40)[i]
                if UnitDebuffID(thisUnit,185365,"player") then
                    huntersMarkCount = huntersMarkCount+1
                end
                if UnitDebuffID(thisUnit,187131,"player") then
                    vulnerableCount = vulnerableCount+1
                end
            end
            self.debuffcount.huntersMark     = huntersMarkCount or 0
            self.debuffcount.vulnerable    = vulnerableCount or 0
        end  
        

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cMarksmanship
end-- select Hunter