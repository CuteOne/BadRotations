--- Havoc Class
-- Inherit from: ../cCharacter.lua and ../cDemonHunter.lua
cHavoc = {}
cHavoc.rotations = {}

-- Creates Havoc DemonHunter
function cHavoc:new()
	local self = cDemonHunter:new("Havoc")

	local player = "player" -- if someone forgets ""

    -- Mandatory !
    self.rotations = cHavoc.rotations
	
-----------------
--- VARIABLES ---
-----------------

    self.spell.spec                 = {}
    self.spell.spec.abilities       = {
        annihilation                = 201427,
        bladeDance                  = 188499,
        blur                        = 198589,
        chaosBlades                 = 211048,
        chaosNova                   = 179057,
        chaosStrike                 = 162794,
        darkness                    = 196718,
        deathSweep                  = 210152,  
        demonsBite                  = 162243,
        eyeBeam                     = 198013,
        felBarrage                  = 211053,
        felEruption                 = 211881,
        felRush                     = 195072,
        furyOfTheIllidari           = 201467,
        metamorphosis               = 191427,
        netherwalk                  = 196555,
        nemesis                     = 206491,
        throwGlaive                 = 185123,
        vengefulRetreat             = 198793,
    }
    self.spell.spec.artifacts       = {
        anguishOfTheDeceiver        = 201473,
        demonSpeed                  = 201469,
        furyOfTheIllidari           = 201467,
        warglaivesOfChaos           = 214795,
    }
    self.spell.spec.buffs           = {
        chaosBlades                 = 211797,
        metamorphosis               = 162264,
        momentum                    = 208628,
        prepared                    = 203650,
    }
    self.spell.spec.debuffs         = {
        nemesis                     = 206491,
    }
    self.spell.spec.glyphs          = {

    }
    self.spell.spec.talents         = {
        blindFury                   = 203550,
        bloodlet                    = 206473,
        chaosBlades                 = 211048,
        chaosCleave                 = 206475,
        demonBlades                 = 203555,
        demonic                     = 213410,
        demonicAppetite             = 206478,
        demonReborn                 = 193897,
        desperateInstincts          = 205411,
        felBarrage                  = 211053,
        felMastery                  = 192939,
        firstBlood                  = 206416,
        mastersOfTheGlaive          = 203556,
        momentum                    = 206476,
        nemesis                     = 206491,
        netherwalk                  = 196555,
        prepared                    = 203551,
        soulRending                 = 204909,
        unleashedPower              = 206477,
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

    function worthUsing()
        local demons_bite_per_dance = 35 / 25
        local demons_bite_per_chaos_strike = ( 40 - 20 * (GetCritChance("player")/100) ) / 25
        local mhDamage = ((select(2,UnitDamage("player"))+select(1,UnitDamage("player"))) / 2)
        local ohDamage = ((select(4,UnitDamage("player"))+select(3,UnitDamage("player"))) / 2)
        local totDamage = (mhDamage + UnitAttackPower("player") / 3.5 * 2.4) + (ohDamage + UnitAttackPower("player") / 3.5 * 2.4) 
        local demons_bite_damage = 2.6 * totDamage
        local blade_dance_damage = ((1 * totDamage) + (2 * (0.96 * totDamage)) + (2.88 * totDamage))
        local chaos_strike_damage = 2.75 * totDamage
        if ( blade_dance_damage + demons_bite_per_dance * demons_bite_damage ) / ( 1 + demons_bite_per_dance ) > ( chaos_strike_damage + demons_bite_per_chaos_strike * demons_bite_damage ) / ( 1 + demons_bite_per_chaos_strike ) then
            return true
        else
            return false
        end
    end

    function cancelRushAnimation(thisUnit) -- Thanks G1zStar
        if thisUnit == nil then thisUnit = self.units.dyn5 end
        MoveBackwardStart()
        JumpOrAscendStart()
        castSpell(thisUnit,self.spell.felRush,false,false,false)
        MoveBackwardStop()
        AscendStop()
        return
    end
    function cancelRetreatAnimation() -- Thanks G1zStar
        SetHackEnabled("NoKnockback", true)
        castSpell("player",self.spell.vengefulRetreat,false,false,false)
        SetHackEnabled("NoKnockback", false)            
        return
    end

    -- Return
    return self
end-- select Demonhunter