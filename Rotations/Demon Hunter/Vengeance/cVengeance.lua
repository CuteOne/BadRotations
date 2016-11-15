--- Vengeance Class
-- Inherit from: ../cCharacter.lua and ../cDemonHunter.lua
cVengeance = {}
cVengeance.rotations = {}

-- Creates Vengeance DemonHunter
function cVengeance:new()
    local self = cDemonHunter:new("Vengeance")

    local player = "player" -- if someone forgets ""

    -- Mandatory !
    self.rotations = cVengeance.rotations
    
-----------------
--- VARIABLES ---
-----------------

    self.spell.spec                 = {}
    self.spell.spec.abilities       = {
        demonSpikes                 = 203720,
        empowerWards                = 218256,
        felDevastation              = 212084,
        felblade                    = 213241,
        fieryBrand                  = 204021,
        fracture                    = 209795,
        immolationAura              = 178740,
        infernalStrike              = 189110,
        metamorphosis               = 187827,
        netherBond                  = 207810,
        shear                       = 203782,
        sigilOfChains               = 202138,
        sigilOfFlame                = 204596,
        sigilOfMisery               = 207684,
        sigilOfSilence              = 202137,
        soulBarrier                 = 227225,
        soulCleave                  = 228477,
        soulCarver                  = 207407,
        spiritBomb                  = 218679,
        throwGlaive                 = 204157,
        torment                     = 185245,
    }
    self.spell.spec.artifacts       = {

    }
    self.spell.spec.buffs           = {
        demonSpikes                 = 203819,
        soulFragments               = 203981,
        metamorphosis               = 187827,
        feastofSouls                = 207693,
    }
    self.spell.spec.debuffs         = {
        fieryBrand                  = 204022,
        frailty                     = 224509,
        sigilOfFlame                = 204598,
    }
    self.spell.spec.glyphs          = {

    }
    self.spell.spec.talents         = {
        abyssalStrike               = 207550,
        agonizingFlames             = 207548,
        razorSpikes                 = 209400,
        feastofSouls                = 207697,
        fallout                     = 227174,
        burningAlive                = 207739,
        flameCrash                  = 227322,
        feedTheDemon                = 218612,
        fracture                    = 209795,
        soulRending                 = 217996,
        consentratedSigils          = 207666,
        sigilOfChains               = 202138,
        quickenedSigils             = 209281,
        felDevastation              = 212084,
        bladeTurning                = 203753,
        spiritBomb                  = 218679,
        lastResort                  = 209258,
        netherBond                  = 207810,
        soulBarrier                 = 227225,
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
        self.mode.mover     = br.data["Mover"]
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

    function useAoE()
        local rotation = self.mode.rotation
        if (rotation == 1 and #enemies.yards8 > 1) or rotation == 2 then
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

    -- Return
    return self
end-- select Demonhunter