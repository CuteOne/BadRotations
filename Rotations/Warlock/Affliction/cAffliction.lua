--- Affliction Class
-- Inherit from: ../cCharacter.lua and ../cWarlock.lua
cAffliction = {}
cAffliction.rotations = {}

-- Creates Affliction Warlock
function cAffliction:new()
    if GetSpecializationInfo(GetSpecialization()) == 265 then
        local self = cWarlock:new("Affliction")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cAffliction.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------
    
        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
        	agony 						= 980,
        	corruption 					= 172,
        	drainSoul 					= 198590,
        	grimoireOfSacrifice 		= 108503,
        	haunt 						= 48181,
        	howlOfTerror 				= 5484,
        	manaTap 					= 196104,
        	phantomSingularity 			= 205179,
        	reapSouls 					= 216698,
        	seedOfCorruption 			= 27243,
            shadowBolt                  = 232670,
        	siphonLife 					= 63106,
        	soulEffigy 					= 205178,
        	unstableAffliction 			= 30108,
        }
        self.spell.spec.artifacts       = {
        	compoundingHorror 			= 199282,
        	crystallineShadows 			= 221862,
        	drainedToAHusk 				= 199120,
        	fatalEchoes 				= 199257,
        	harvesterOfSouls 			= 201424,
        	hideousCorruption 			= 199112,
        	inherentlyUnstable 			= 199152,
        	inimitableAgony 			= 199111,
        	longDarkNightOfTheSoul 		= 199214,
        	perdition 					= 199158,
        	reapSouls 					= 216698,
        	seedsOfDoom 				= 199153,
        	shadowsOfTheFlesh 			= 199212,
        	shadowyIncantations 		= 199163,
        	soulFlame 					= 199471,
        	soulstealer 				= 214934,
        	sweetSouls 					= 199220,
        	wrathOfConsumption 			= 199472,
        }
        self.spell.spec.buffs           = {
        	compoundingHorror 			= 199281,
        	deadwindHarvester 			= 216708,
            demonicPower                = 196099,
        	manaTap 					= 196104,
        	tormentedSouls 				= 216695,
        }
        self.spell.spec.debuffs         = {
        	agony 						= 980,
        	corruption 					= 146739, --172
        	siphonLife 					= 63106,  
            -- unstableAffliction          = 233496, 233490     	
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
        	absoluteCorruption 			= 196103,
        	contagion 					= 196105,
        	drainSoul 					= 198590,
        	grimoireOfSacrifice 		= 108503,
        	haunt 						= 48181,
        	howlOfTerror 				= 5484,
        	manaTap 					= 196104,
        	phantomSingularity 			= 205179,
        	siphonLife 					= 63106,
        	soulConduit 				= 215941,
        	soulEffigy 					= 205178,
        	sowTheSeeds 				= 196226,
        	writheInAgony 				= 196102,
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
                        -- local demoEmpBuff   = UnitBuffID(thisUnit,self.spell.spec.buffs.demonicEmpowerment) ~= nil
                        local unitCount     = #getEnemies(tostring(thisUnit),10) or 0
                        tinsert(self.petInfo,{name = unitName, guid = unitGUID, id = unitID, creator = unitCreator, --[[deBuff = demoEmpBuff,]] numEnemies = unitCount})
                    end
                end
            end
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

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cAffliction
end-- select Warlock