--- Destruction Class
-- Inherit from: ../cCharacter.lua and ../cWarlock.lua
cDestruction = {}
cDestruction.rotations = {}

-- Creates Destruction Warlock
function cDestruction:new()
    local self = cWarlock:new("Destruction")

    local player = "player" -- if someone forgets ""

    -- Mandatory !
    self.rotations = cDestruction.rotations
    
-----------------
--- VARIABLES ---
-----------------

    self.spell.spec                 = {}
    self.spell.spec.abilities       = {
        cataclysm                   = 152108,
        channelDemonfire            = 196447,
        chaosBolt                   = 116858,
        conflagrate                 = 17962,
        dimensionalRift             = 196586,
        drainLife                   = 234153,
        grimoireOfSacrifice         = 108503,
        havoc                       = 80240,
        immolate                    = 348,
        incinerate                  = 29722,
        manaTap                     = 196104,
        rainOfFire                  = 5740,
        shadowBolt                  = 686,
        shadowburn                  = 17877,
        shadowfury                  = 30283,
    }
    self.spell.spec.artifacts       = {
        artificialStamina           = 211309,
        burningHunger               = 196432,
        chaoticIstability           = 196217,
        conflagrationOfChaos        = 219195,
        demonicDurability           = 215223,
        devourerOfLife              = 196301,
        dimensionRipper             = 219415,
        dimensionalRift             = 196586,
        eternalStruggle             = 196305,
        fireAndTheFlames            = 196222,
        fireFromTheSky              = 196258,
        flamesOfThePit              = 215183,
        impishIncineration          = 215273,
        lordOfFlames                = 224103,
        masterOfDisaster            = 196211,
        planeswalker                = 196675,
        residualFlames              = 196227,
        soulsnatcher                = 196236,
        stolenPower                 = 214936,
    }
    self.spell.spec.buffs           = {
        backdraft                   = 117828, --196406,
        conflagrationOfChaos        = 196546,
        lordOfFlames                = 224103,
        manaTap                     = 196104,
    }
    self.spell.spec.debuffs         = {
        immolate                    = 157736,
        havoc                       = 80240,
        roaringBlaze                = 205184,
    }
    self.spell.spec.glyphs          = {

    }
    self.spell.spec.talents         = {
        backdraft                   = 196406,
        cataclysm                   = 152108,
        channelDemonfire            = 196447,
        eradication                 = 196412,
        fireAndBrimstone            = 196408,
        grimoireOfSacrifice         = 108503,
        manaTap                     = 196104,
        reverseEntropy              = 205148,
        roaringBlaze                = 205184,
        shadowburn                  = 17877,
        shadowfury                  = 30283,
        wreakHavoc                  = 196410,   
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
end-- select Warlock