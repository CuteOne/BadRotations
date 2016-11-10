--- Demonology Class
-- Inherit from: ../cCharacter.lua and ../cWarlock.lua
cDemonology = {}
cDemonology.rotations = {}

-- Creates Demonology Warlock
function cDemonology:new()
    if GetSpecializationInfo(GetSpecialization()) == 266 then
        local self = cWarlock:new("Demonology")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cDemonology.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
    
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            callDreadstalkers           = 104316,
            commandDemon                = 119898,
            demonbolt                   = 157695,
            demonicEmpowerment          = 193396,
            demonwrath                  = 193440,
            doom                        = 603,
            grimoireFelguard            = 111898,
            handOfGuldan                = 105174,
            implosion                   = 196277,
            shadowbolt                  = 686,
            shadowflame                 = 205181,
            summonDarkglare             = 205180,
            summonFelguard              = 30146,
            thalkielsConsumption        = 211714,
        }
        self.spell.spec.artifacts       = {
            thalkielsConsumption        = 211714,
        }
        self.spell.spec.buffs           = {
            demonicCalling              = 205146,
            demonicEmpowerment          = 193396,
            demonwrath                  = 193440,
        }
        self.spell.spec.debuffs         = {
            doom                        = 603,
            shadowflame                 = 205181,
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            demonbolt                   = 157695,
            grimoireOfSynergy           = 171975,
            handOfDoom                  = 196283,
            implosion                   = 196277,
            shadowflame                 = 205181,
            summonDarkglare             = 205180,
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
            self.getPetInfo()

            -- Start selected rotation
            self:startRotation()
        end

    ----------------
    --- PET INFO ---
    ----------------
        function self.getPetInfo()
            self.petInfo = {}
            for i = 1, ObjectCount() do
                -- define our unit
                --local thisUnit = GetObjectIndex(i)
                local thisUnit = GetObjectWithIndex(i)
                -- check if it a unit first
                if ObjectIsType(thisUnit, ObjectTypes.Unit)  then
                    local unitName      = UnitName(thisUnit)
                    local unitID        = GetObjectID(thisUnit)
                    local unitGUID      = UnitGUID(thisUnit)
                    local unitCreator   = UnitCreator(thisUnit)
                    local player        = GetObjectWithGUID(UnitGUID("player"))
                    if unitCreator == player and (unitID == 55659 or unitID == 98035 or unitID == 103673 or unitID == 11859 or unitID == 89 
                        or unitID == 416 or unitID == 1860 or unitID == 417 or unitID == 1863 or unitID == 17252) 
                    then
                        local demoEmpBuff   = UnitBuffID(thisUnit,self.spell.spec.buffs.demonicEmpowerment) ~= nil
                        local unitCount     = #getEnemies(tostring(thisUnit),10) or 0
                        tinsert(self.petInfo,{name = unitName, guid = unitGUID, id = unitID, creator = unitCreator, deBuff = demoEmpBuff, numEnemies = unitCount})
                    end
                end
            end
        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes()

            self.mode.rotation  = bb.data["Rotation"]
            self.mode.cooldown  = bb.data["Cooldown"]
            self.mode.defensive = bb.data["Defensive"]
            self.mode.interrupt = bb.data["Interrupt"]
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

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cDemonology
end-- select Warlock