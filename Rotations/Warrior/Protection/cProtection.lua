--- Protection Class
-- Inherit from: ../cCharacter.lua and ../cWarrior.lua
cProtection = {}
cProtection.rotations = {}

-- Creates Protection Warrior
function cProtection:new()
    local self = cWarrior:new("Protection")

    local player = "player" -- if someone forgets ""

    -- Mandatory !
    self.rotations = cProtection.rotations
    
-----------------
--- VARIABLES ---
-----------------
    self.spell.spec                 = {} 
    self.spell.spec.abilities       = { 
        defensiveStance             = 71,
        demoralizingShout           = 1160,
        devastate                   = 20243,
        focusedRage                 = 204488,
        ignorePain                  = 190456,
        impendingVictory            = 202168,
        intercept                   = 198304,
        lastStand                   = 12975,
        neltharionsFury             = 203524,
        ravager                     = 228920,
        revenge                     = 6572,
        shieldBlock                 = 2565,
        shieldSlam                  = 23922,        
        shieldWall                  = 871,
        spellReflect                = 23920,
        thunderClap                 = 6343,
        victoryRush                 = 34428,
    }
    self.spell.spec.artifacts       = {
        artificialDamage            = 226829,
        dragonScales                = 203576,
        dragonSkin                  = 203225,
        intolerance                 = 203227,
        leapingGiants               = 203230,
        mightOfTheVrykul            = 188778,
        neltharionsFury             = 203524,
        rageOfTheFallen             = 216272,
        reflectivePlating           = 188672,
        rumblingVoice               = 188651,
        scalesOfTheEarth            = 189059,
        shatterTheBones             = 188639,
        strengthOfTheEarthAspect    = 188647,
        thunderCrash                = 188644,
        toughness                   = 188632,
        unbreakableBulwark          = 214939,
        vrykulShieldTraining        = 188635,
        wallOfSteel                 = 203261,
        willToSurvive               = 188683, 
    }
    self.spell.spec.buffs           = {
        defensiveStance             = 71,
        neltharionsFury             = 203524,
        shieldBlock                 = 132404,
        shieldWall                  = 871,
        ultimatum                   = 122510,
        victorious                  = 32216,
        vengeanceFocusedRage        = 202573,
        vengeanceIgnorePain         = 202574,
    }
    self.spell.spec.debuffs         = {
        demoralizingShout           = 1160,
        thunderClap                 = 6343,
    }
    self.spell.spec.glyphs          = {

    }
    self.spell.spec.talents         = {
        angerManagement             = 152278,
        bestServedCold              = 202560,
        boomingVoice                = 202743,
        cracklingThunder            = 203201,
        heavyRepercussions          = 203177,
        impendingVictory            = 202168,
        indomitable                 = 202095,
        inspiringPresence           = 205484,
        intoTheFray                 = 202603,
        neverSurrender              = 202561,
        ravager                     = 228920,
        renewedFury                 = 202288,
        safeguard                   = 223657,
        ultimatum                   = 122509,
        vengeance                   = 202572,
        warbringer                  = 103828,
        warlordsChallenge           = 223662,        
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
--- TOGGLES --- -- Do Not Edit this Section
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
--- OPTIONS --- -- Do Not Edit this Section
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
end-- select Warrior