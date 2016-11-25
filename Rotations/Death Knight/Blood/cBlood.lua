--- Blood Class
-- Inherit from: ../cCharacter.lua and ../cDeathKnight.lua
cBlood = {}
cBlood.rotations = {}

-- Creates Blood DeathKnight
function cBlood:new()
    local self = cDeathKnight:new("Blood")

    local player = "player" -- if someone forgets ""

    -- Mandatory !
    self.rotations = cBlood.rotations
    
-----------------
--- VARIABLES ---
-----------------

    self.spell.spec                 = {}
    self.spell.spec.abilities       = {
        asphyxiate                  = 221562,
        bloodBoil                   = 50842,
        bloodMirror                 = 206977,
        bloodTap                    = 221699,
        blooddrinker                = 206931,
        bonestorm                   = 194844,
        consumption                 = 205223,
        dancingRuneWeapon           = 49028,
        deathAndDecay               = 43265,
        deathsCaress                = 195292,
        gorefiendsGrasp             = 108199,
        heartStrike                 = 206930,
        markOfBlood                 = 206940,
        marrowrend                  = 195182,
        runeTap                     = 194679,
        soulgorge                   = 212744,
        tighteningGrasp             = 206970,
        tombstone                   = 219809,
        vampiricBlood               = 55233,
        iceboundFortitude           = 48792,
    }
    self.spell.spec.artifacts       = {
        allConsumingRot             = 192464,
        artificialDamage            = 226829,
        bloodFeast                  = 192548,
        bonebreaker                 = 192538,
        coagulopathy                = 192460,
        consumption                 = 205223,
        danceOfDarkness             = 192514,
        grimPerseverance            = 192447,
        ironHeart                   = 192450,
        meatShield                  = 192453,
        mouthOfHell                 = 192570,
        rattlingBones               = 192557,
        sanguinaryAffinity          = 221775,
        skeletalShattering          = 192558,
        theHungeringMaw             = 214903,
        umbilicusEternus            = 193213,
        unendingThirst              = 192567,
        veinrender                  = 192457,
    }
    self.spell.spec.buffs           = {
        boneShield                  = 195181,
        crimsonScourge              = 81136,
        dancingRuneWeapon           = 81256,
        tombstone                   = 219809,
        vampiricBlood               = 55233,
    }
    self.spell.spec.debuffs         = {
        asphyxiate                  = 221562,
        bloodMirror                 = 206977,
        blooddrinker                = 206931,
        heartStrike                 = 206930,
        markOfBlood                 = 206940,
    }
    self.spell.spec.glyphs          = {

    }
    self.spell.spec.talents         = {
        antimagicBarrier            = 205727,
        bloodMirror                 = 206977,
        bloodTap                    = 221699,
        blooddrinker                = 206931,
        bloodworms                  = 195679,
        bonestorm                   = 194844,
        foulBulwark                 = 206974,
        marchOfTheDamned            = 219779,
        markOfBlood                 = 206940,
        ossuary                     = 219786,
        purgatory                   = 114556,
        rapidDecomposition          = 194662,
        redThirst                   = 205723,
        runeTap                     = 194679,
        soulgorge                   = 212744,
        spectralDeflection          = 211078,
        tighteningGrasp             = 206970,
        tombstone                   = 219809,
        trembleBeforeMe             = 206960,
        willOfTheNecropolis         = 206967,
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
end-- select DeathKnight
