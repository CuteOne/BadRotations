-------------------------------------------------------
-- Author = BrewingCoder
-- Patch = 10.2.5
-- Coverage = 90%
-- Status = Limited,Hardcoded Vals
-- Readiness = Development
-------------------------------------------------------
local rotationName = "BrewBrewMaster" -- Change to name of profile listed in options drop down
local colors = {
    blue    = "|cff4285F4",
    red     = "|cffDB4437",
    yellow  = "|cffF4B400",
    green   = "|cff0F9D58",
    white   = "|cffFFFFFF",
    purple  = "|cff9B30FF",
    aqua    = "|cff89E2C7",
    blue2   = "|cffb8d0ff",
    green2  = "|cff469a81",
    blue3   = "|cff6c84ef",
    orange  = "|cffff8000"
}
local text = {
    preCombat = {
        options                 = colors.aqua.."NORM Pre-Combat Options",
        rollToEngage            = colors.aqua.."NORM Roll to Engage Target",
        chiTorpedoToEngage      = colors.aqua.."NORM Chi Torpedo to Engage",
        trancedenceSwapOnBoss   = colors.aqua.."NORMTrancedence Swap on Boss"
    },
    selfDefense = {
        healingElixir           = colors.orange.."Healing Elixir"
    },
    interrupts = {
        options                 = colors.purple.."Interrupt Settings",
        spearHandStrike         = colors.purple.."Spear Hand Strike",
        legSweep                = colors.purple.."Leg Sweep",
        ringOfPeace             = colors.purple.."ringOfPeace",
    },
    options = {
        consumeOnlyInDungeon    = colors.green.."Use Consumables only in Dungeon/Raid",

    }
}
local text2 = {
    preCombat2 = {
        options2                 = colors.aqua.."Pre-Combat Options",
        rollToEngage2            = colors.aqua.."Roll to Engage Target",
        chiTorpedoToEngage2      = colors.aqua.."Chi Torpedo to Engage",
        trancedenceSwapOnBoss2   = colors.aqua.."Trancedence Swap on Boss"
    },
    selfDefense2 = {
        healingElixir2           = colors.orange.."Healing Elixir"

    }
}


local function createToggles()
    local Content = {
        [1] = { mode = "Norm", value = 1 , overlay = "Normal Dungeon", tip = "Swaps between Modes", highlight = 1, icon = br.player.spells.weaponsOfOrder },
        [2] = { mode = "Hero", value = 2 , overlay = "Raid/Heroic Dungeon", tip = "Heroic Dungeon or Raid Settings", highlight = 1, icon = br.player.spells.breathOfFire },
        [3] = { mode = "OFF", value = 2 , overlay = "OFF", tip = "Mode Settings", highlight = 0, icon = br.player.spells.weaponsOfOrder },
    };
    br.ui:createToggle(Content,"Rotation",1,0)
   local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spells.recklessness },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spells.recklessness },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spells.recklessness }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spells.spearHandStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spells.spearHandStrike }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",3,0)
    local DebugModes = {
        [1] = { mode = "On", value = 1 , overlay = "Debug Enabled", tip = "Show Rotation Debug", highlight = 1, icon = br.player.spells.paralysis },
        [2] = { mode = "Off", value = 2 , overlay = "Debug Disabled", tip = "Do Not Show Rotation Debug", highlight = 0, icon = br.player.spells.paralysis }
    }
    br.ui:createToggle(DebugModes,"DebugMode",4,0)
end

local function createOptions()
    local optionTable
    local function welcome()
        local section = br.ui:createSection(br.ui.window.profile, "Welcome")
        br.ui:createText(section, colors.green    .. "NORM".. colors.blue .." Normal level Dungeoning ")
        br.ui:createText(section, colors.green    .. "HERO".. colors.blue .." Heroic Level Dungeoning ")
        br.ui:createText(section, "")
        br.ui:createText(section, colors.blue     .. "Written by BrewingCoder")
        br.ui:createText(section, colors.blue     .. "Updated for Retail 10.2.5")
        br.ui:createText(section, colors.blue     .. "Setup to easily switch between Dungeon and Raid levels")
        br.ui:createText(section, "")
        br.ui:createText(section, colors.blue     .. "I love to tank it up. ")
        br.ui:createText(section, colors.blue     .. "Please let me know how I can make this better! - BrewingCoder")
        br.ui:checkSectionState(section)
    end
    local function consumables()
        local section = br.ui:createSection(br.ui.window.profile,"Consumables")
            br.ui:createCheckbox(section, text.options.consumeOnlyInDungeon)
            br.player.module.ImbueUp(section)
            br.player.module.PhialUp(section)
        br.ui:checkSectionState(section)
    end
    local function normalDungeonSettings()
        local section = br.ui:createSection(br.ui.window.profile,text.preCombat.options)
            br.ui:createText(section,"Normal | Pre-Combat")
            br.ui:createCheckbox(section,text.preCombat.rollToEngage,"Enable Rolling to Engage target if Facing")
            br.ui:createCheckbox(section,text.preCombat.chiTorpedoToEngage,"Enable chiTorpedo to Engage if Facing")
            br.ui:createCheckbox(section,text.preCombat.trancedenceSwapOnBoss,"Use Transcendence to engage, then return to original location")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile,text.interrupts.options)
            br.ui:createText(section,"Normal | Interrupts")
            br.ui:createSpinner(section,text.interrupts.spearHandStrike,0,0,95,5,"Use Spear Hand Strike")
            br.ui:createSpinner(section,text.interrupts.legSweep,0,0,95,5,"Use Leg Sweep")
            br.ui:createSpinner(section,text.interrupts.ringOfPeace,0,0,95,5,"Use Ring of Peace")
        br.ui:checkSectionState(section)
    end
    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")

        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")

        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")

        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS --- -- Degine Toggle Options
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdown(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdown(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Welcome",
        [2] = welcome,
    },
    {   [1] = "Consumables",
        [2] = consumables
    },
    {
        [1] = "Normal Dungeon",
        [2] = normalDungeonSettings
    }}
    return optionTable
end

local debugMessage = function(message)
    print(colors.red.. date() .. colors.white .. ": ".. message)
end
local function boolNumeric(value)
    return value and 1 or 0
end


local buff
local cast
local cd
local charges
local enemies
local module
local power
local talent
local ui
local unit
local units
local var
local debuff


local actionList = {}
actionList.Interrupt = function()
    if ui.checked(text.interrupts.spearHandStrike) and ui.delay("Interrupts",unit.gcd(true)) then
        local thisUnit
            for i=1, #enemies.yards5 do
                thisUnit = enemies.yards5[i]
                if unit.interruptable(thisUnit,ui.value(text.interrupts.spearHandStrike))  and cast.able.spearHandStrike(thisUnit) then
                    if cast.spearHandStrike(thisUnit) then ui.debug("Interrupt: SpearHandStrike "..unit.name(thisUnit)) return true end
                end
            end

        if ui.checked(text.interrupts.legSweep) and  cast.able.legSweep("target") then
            for i=1, #enemies.yards5 do
                thisUnit = enemies.yards5[i]
                if unit.interruptable(thisUnit,ui.value(text.interrupts.legSweep)) then
                    if cast.legSweep(thisUnit) then ui.debug("Interrupt:Leg Sweep "..unit.name(thisUnit)) return true end
                end
            end
        end
    end
end
actionList.Extra = function()
    if (
        ui.checked(text.options.consumeOnlyInDungeon) and
        (br.player.instance=="raid" or br.player.instance=="party")) or
        not ui.checked(text.options.consumeOnlyInDungeon) then
            module.ImbueUp()
    end
    if (
        ui.checked(text.options.consumeOnlyInDungeon) and
        (br.player.instance=="raid" or br.player.instance=="party")) or
        not ui.checked(text.options.consumeOnlyInDungeon) then
            module.PhialUp()
    end
end
actionList.Cooldown = function()
end
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Logic based on pull timers (IE: DBM/BigWigs)
        end -- End Pre-Pull

        if unit.valid("target") and unit.facing("target") and ui.checked(text.preCombat.rollToEngage) then
            if unit.distance("target") > 5 and cast.able.roll() then debugMessage(text.preCombat.rollToEngage) return true; end;
        end
        if unit.valid("target") and unit.facing("target") and ui.checked(text.preCombat.chiTorpedoToEngage) then
            if unit.distance("target") > 5 and cast.able.chiTorpedo() then debugMessage(text.preCombat.chiTorpedoToEngage) return true; end;
        end
        if unit.valid("target") then -- Abilities below this only used when target is valid
            -- Start Attack
            if unit.distance("target") < 5 then -- Starts attacking if enemy is within 5yrds
                if cast.able.autoAttack("target") then
                    if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                end
            end
        end
    end -- End No Combat
end
actionList.RotationBoc = function ()
    --purifying_brew,if=(buff.blackout_combo.down&(buff.recent_purifies.down|cooldown.purifying_brew.charges_fractional>(1+talent.improved_purifying_brew.enabled-0.1)))
    --&talent.improved_invoke_niuzao_the_black_ox.enabled&(cooldown.weapons_of_order.remains>40|cooldown.weapons_of_order.remains<5)

    if (buff.blackoutCombo.down() and (charges.purifyingBrew.frac() > (1 + boolNumeric(talent.improvedPurifyingBrew)-0.1))) and
        talent.improvedInvokeNiuzaoTheBlackOx and (cd.weaponsOfOrder.remains() > 40 or cd.weaponsOfOrder.remains() <5) then
            if cast.able.purifyingBrew() then
                if cast.purifyingBrew() then ui.debug("01.BOC: Purifying Brew") return true end;
            end
    end
    --weapons_of_order,if=(buff.recent_purifies.up)&talent.improved_invoke_niuzao_the_black_ox.enabled
    if (var.recent_purifies) and talent.improvedInvokeNiuzaoTheBlackOx then
        if cast.able.weaponsOfOrder() then
            if cast.weaponsOfOrder() then ui.debug("02.BOC: Weapons of Order") return true end;
        end
    end

    --/invoke_niuzao_the_black_ox,if=(buff.invoke_niuzao_the_black_ox.down&buff.recent_purifies.up&buff.weapons_of_order.remains<14)
    --&talent.improved_invoke_niuzao_the_black_ox.enabled
    if (buff.invokeNiuzaoTheBlackOx.down() and var.recent_purifies and buff.weaponsOfOrder.remains() < 14) and talent.improvedInvokeNiuzaoTheBlackOx then
        if cast.able.invokeNiuzaoTheBlackOx() then
            if cast.invokeNiuzaoTheBlackOx() then ui.debug("03.BOC: Niuzao The Black Ox") return true; end
        end
    end

    --invoke_niuzao_the_black_ox,if=(debuff.weapons_of_order_debuff.stack>3)&!talent.improved_invoke_niuzao_the_black_ox.enabled
    if debuff.weaponsOfOrder.stack("target") > 3 and not talent.improvedInvokeNiuzaoTheBlackOx then
        if cast.able.invokeNiuzaoTheBlackOx() then
            if cast.invokeNiuzaoTheBlackOx() then ui.debug("04.BOC: Niuzao The Black Ox") return true; end
        end
    end

    --/invoke_niuzao_the_black_ox,if=(!talent.weapons_of_order.enabled)
    if not talent.weaponsOfOrder and cast.able.invokeNiuzaoTheBlackOx() then
        if cast.invokeNiuzaoTheBlackOx() then ui.debug("05.BOC: Invoke Niuzao The Black Ox") return true; end
    end

    --/weapons_of_order,if=(talent.weapons_of_order.enabled)&!talent.improved_invoke_niuzao_the_black_ox.enabled
    if(talent.weaponsOfOrder) and not talent.improvedInvokeNiuzaoTheBlackOx and cast.able.weaponsOfOrder() then
        if cast.weaponsOfOrder() then ui.debug("06.BOC: Weapons of Order") return true; end
    end

    --/keg_smash,if=(time-action.weapons_of_order.last_used<2)
    if cast.last.weaponsOfOrder(2) and cast.able.kegSmash("target") then
        if cast.kegSmash("target") then ui.debug("07.BOC: Keg Smash") return true; end;
    end

    --/keg_smash,if=(buff.weapons_of_order.remains<gcd*2&buff.weapons_of_order.up)&!talent.improved_invoke_niuzao_the_black_ox.enabled
    if (buff.weaponsOfOrder.remains() < unit.gcd()*2 and buff.weaponsOfOrder.exists()) and not talent.improvedInvokeNiuzaoTheBlackOx then
        if cast.able.kegSmash("target") then ui.debug("08.BOC: Keg Smash") return true; end;
    end

    --/keg_smash,if=(buff.weapons_of_order.remains<gcd*2)&talent.improved_invoke_niuzao_the_black_ox.enabled
    if (buff.weaponsOfOrder.remains() < unit.gcd()*2) and talent.improvedInvokeNiuzaoTheBlackOx then
        if cast.able.kegSmash("target") then ui.debug("09. BOC:Keg Smash") return true; end;
    end

    --/purifying_brew,if=(!buff.blackout_combo.up)&!talent.improved_invoke_niuzao_the_black_ox.enabled
    if (not buff.blackoutCombo.exists()) and not talent.improvedInvokeNiuzaoTheBlackOx then
        if cast.able.purifyingBrew() then
            if cast.purifyingBrew() then ui.debug("10.BOC: Purifying Brew") return true; end;
        end
    end

    if cast.able.risingSunKick() then
        if cast.risingSunKick() then ui.debug("11.BOC: Rising Sun Kick") return true; end;
    end

    if (br.player.power.energy() + br.player.power.energy.regen()) <= 40 then
         if cast.able.blackOxBrew() then ui.debug("12.BOC: Black Ox Brew") return true; end;
    end

    --tiger_palm,if=(buff.blackout_combo.up&active_enemies=1)
    if buff.blackoutCombo.exists() and enemies.yards5f == 1 then
        if cast.able.tigerPalm("target")  then
            if cast.tigerPalm("target") then ui.debug("13.BOC: Tiger Palm") return true; end;
        end
    end

    --/breath_of_fire,if=(buff.charred_passions.remains<cooldown.blackout_kick.remains)
    if (buff.charredPassions.remains() < cd.blackoutKick.remains()) then
        if cast.able.breathOfFire("target") then
            if cast.breathOfFire("target") then ui.debug("14.BOC: Breath of Fire") return true; end
        end
    end

    --=/keg_smash,if=(buff.weapons_of_order.up&debuff.weapons_of_order_debuff.stack<=3)
    if (buff.weaponsOfOrder.exists() and debuff.weaponsOfOrder.stack("target") <= 3) then
        if cast.able.kegSmash("target") then
            if cast.kegSmash("target") then ui.debug("15.BOC: Keg Smash") return true; end
        end
    end

    --/summon_white_tiger_statue,if=(debuff.weapons_of_order_debuff.stack>3)
    if (debuff.weaponsOfOrder.stack("target") > 3) then
        if cast.able.summonWhiteTigerStatue("target") then
            if cast.summonWhiteTigerStatue("target") then ui.debug("16.BOC: White Tiger Statue") return true; end;
        end
    end

    --/summon_white_tiger_statue,if=(!talent.weapons_of_order.enabled)
    if not talent.weaponsOfOrder and cast.able.summonWhiteTigerStatue("target") then
        if cast.summonWhiteTigerStatue("target") then ui.debug("17.BOC: White Tiger Statue") return true; end;
    end

    --/bonedust_brew,if=(time<10&debuff.weapons_of_order_debuff.stack>3)|(time>10&talent.weapons_of_order.enabled)
    --TODO figure out what the "time" variable means.
    if (debuff.weaponsOfOrder.stack("target") > 3 and unit.combatTime("player") < 10) or  (unit.combatTime("player") > 10 and talent.weaponsOfOrder) then
        if cast.able.bonedustBrew("target") then
            if cast.bonedustBrew("target") then ui.debug("18.BOC: Bone Dust Brew") return true; end
        end
    end

    --/bonedust_brew,if=(!talent.weapons_of_order.enabled)
    if not talent.weaponsOfOrder and cast.able.bonedustBrew("target") then
        if cast.bonedustBrew("target") then ui.debug("19.BOC: Bonedustd Brew") return true; end
    end

    --/exploding_keg,if=(buff.bonedust_brew.up)
    if buff.bonedustBrew.exists() then
        if cast.able.explodingKeg("target") then
            if cast.explodingKeg("target") then ui.debug("20.BOC: Exploding Keg") return true; end
        end
    end

    --/exploding_keg,if=(cooldown.bonedust_brew.remains>=20)
    if cd.bonedustBrew.remains() >= 20 or not talent.bonedustBrew then
        if cast.able.explodingKeg("target") then
            if cast.explodingKeg("target") then ui.debug("21.BOC: Exploding Keg") return true; end
        end
    end

    if cast.able.kegSmash("target") then
        if cast.kegSmash("target") then ui.debug("22.BOC: Keg Smash") return true; end;
    end

    if talent.rushingJadeWind and cast.able.rushingJadeWind() then
        if cast.rushingJadeWind() then ui.debug("23.BOC:  Rushing Jade Wind") return true; end
    end
    if cast.able.breathOfFire("target") then
        if cast.breathOfFire("target") then ui.debug("24.BOC: Breath of Fire") return true; end
    end

    --/tiger_palm,if=active_enemies=1&!talent.blackout_combo.enabled
    if #enemies.yards5 == 1 and not talent.blackoutCombo then
        if cast.able.tigerPalm("target") then
            if cast.tigerPalm("target") then ui.debug("25.BOC: Tiger Palm") return true; end
        end
    end

    if #enemies.yards5 > 1 and cast.able.spinningCraneKick() then
        if cast.spinningCraneKick() then ui.debug("26.BOC: Spinning Crane Kick") return true; end;
    end

    if cast.able.expelHarm() then
        if cast.expelHarm() then ui.debug("27.BOC: Expel Harm") return true; end;
    end

    if cast.able.chiWave("target") then
        if cast.chiWave("target") then ui.debug("28.BOC: Chi Wave") return true; end;
    end

    if cast.able.chiBurst("target") then
        if cast.chiBurst("Target") then ui.debug("29.BOC: Chi Burst") return true; end;
    end
end

actionList.Defensive = function()
    if unit.hp() <= 90 and cast.able.expelHarm("player") then
        if cast.expelHarm("player") then ui.debug("DEF: ExpelHarm") return true;end;
    end
    if (debuff.moderateStagger.exists("player") or debuff.heavyStagger.exists("player")) and cast.able.purifyingBrew("player") then
        if cast.purifyingBrew("player") then ui.debug("DEF: Purifying Brew") return true; end;
    end
    if unit.hp() <= 80 and cast.able.healingElixir("player") then
        if cast.healingElixir("player") then ui.debug("DEF: Healing Elixir") return true; end;
    end
    if unit.hp() <= 70 and cast.able.invokeNiuzao() then
        if cast.invokeNiuzao() then ui.debug("DEF: Invoking Niuzao") return true; end;
    end
    if unit.hp() <= 50 and cast.able.dampenHarm("player") then
        if cast.dampenHarm("player") then ui.debug("DEF: Dampen Harm") return true; end;
    end
    if unit.hp() <= 40 and cast.able.fortifyingBrew("player") then
        if cast.fortifyingBrew("player") then ui.debug("DEF: Fortifying Brew") return true; end;
    end
end -- End Action List - Defensive

----------------
--- ROTATION ---
----------------
local function runRotation() -- This is the main profile loop, any below this point is ran every cycle, everything above is ran only once during initialization.
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals - These are the same as the locals above just defined for use.
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    enemies                                       = br.player.enemies
    module                                        = br.player.module
    power                                         = br.player.power
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    var                                           = br.player.variables
    debuff                                        = br.player.debuff

    ui.mode.debug = br.data.settings[br.selectedSpec].toggles["DebugMode"]

    --TODO this needs to be replaced with some sort of real calculation, in the mean time we're just looking for having cast Purifying Brew in the last 10 seconds
    var.recent_purifies = cast.last.purifyingBrew(10)

    -- Explanations on the Units and Enemies functions can be found in System/API/Units.lua and System/API/Enemies.lua
    -------------
    --- Units ---
    -------------
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40) -- Makes a variable called, units.dyn40

    ---------------
    --- Enemies ---
    ---------------
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(8)
    enemies.get(10)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40) -- Makes a varaible called, enemies.yards40
    enemies.get(5,"player",false,true) -- makes enemies.yards5f
    enemies.get(10,"player",false, true)
    enemies.get(20,"player",false,true)
    enemies.get(30,"player",false,true)
    enemies.get(40,"player",false,true)

    var.MistBallsInWorld = 0
    for i=1,br._G.GetObjectCount() do
        local name = br._G.ObjectName(br._G.GetObjectWithIndex(i))
        local creator = br._G.UnitCreator(br._G.GetObjectWithIndex(i))
        if creator == br._G.UnitGUID("player") and br._G.ObjectType(br._G.GetObjectWithIndex(i)) ==11 then
            var.MistBallsInWorld = var.MistBallsInWorld +1
        -- elseif creator == br._G.UnitGUID("player") then
        --     print("Unknown obj type: " .. br._G.ObjectType(br._G.GetObjectWithIndex(i)))
        end
    end

    if ui.mode.debug==1 then
        local n,r,i,ct,mr,mxr = GetSpellInfo("Recent Purifies")

        for i=1,40 do
            local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellIdbuff = UnitBuff("player", i);
            if name then
                if name=="Recent Purifies" then
                    print(name,spellIdbuff)
                    print("---------------------------------------------")
                end
            end
        end

    end
    ------------------------
    --- Custom Variables ---
    ------------------------
    -- Any other local varaible from above would also need to be defined here to be use.
    if var.profileStop == nil then var.profileStop = false end

    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then -- Reset profile stop once stopped
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then -- If profile triggered to stop go here until it has.
        return true
    else

        if actionList.Extra() then return true end

        if unit.inCombat() and unit.valid("target") and not var.profileStop then
            if actionList.Interrupt() then return true; end
            if actionList.Defensive() then return true; end
            if not talent.pressTheAdvantage then
                if actionList.RotationBoc() then return true; end
            end
        end


        -- --- Defensive ---
        -- -----------------
        -- if actionList.Defensive() then  return true end -- This runs the Defensive Action List and anything in it will run in or out of combat, this generally contains defensive functions.
        -- ------------------
        -- --- Pre-Combat ---
        -- ------------------
        -- if actionList.PreCombat() then return true end  -- This runs the Pre-Combat Action List and anything in it will run in or out of combat, this generally includes functions that prepare for or start combat.
        -- -----------------
        -- --- In Combat ---
        -- -----------------
        -- if unit.inCombat() and unit.valid("target") and not var.profileStop then -- Everything below this line only run if you are in combat and the selected target is validated and not triggered to stop.
        --     ------------------
        --     --- Interrupts ---
        --     ------------------
        --     if actionList.Interrupt() then return true end -- This runs the Interrupt Action List, this generally contains interrupt functions.
        --     ------------
        --     --- Main ---
        --     ------------
        --     --Always Maintain Buffs
        --     if not buff.rushingJadeWind.exists("player") and cast.able.rushingJadeWind() then
        --         if cast.rushingJadeWind() then ui.debug("Rushing Jade Wind") return true;end;
        --     end

        --     if cast.able.chiWave("target") and unit.distance("target") >= 8 then
        --         if cast.chiWave("target") then ui.debug("Chi Wave") return true; end;
        --     end

        --     --Melee Range Attacks
        --     if unit.distance("target") <= 5 then
        --         if buff.hitScheme.exists() and buff.hitScheme.stack("player") >= 3 and cast.able.kegSmash("target") then
        --             if cast.kegSmash("target") then ui.debug("Proc Hit Scheme: Keg Smash") return true; end;
        --         end
        --         if cast.able.celestialBrew() and not buff.celestialBrew.exists("player") then
        --             if cast.celestialBrew("player") then ui.debug("Celestial Brew") return true; end;
        --         end

        --         --Make sure shuffle is being maintained
        --         -- +5 sec for Keg Smash, 3 sec for Blackout kick, max 15 sec.
        --         if (not buff.shuffle.exists() or (buff.shuffle.remains() <= 3)) then
        --             if cast.able.kegSmash("target") then
        --                 if cast.kegSmash("target") then ui.debug("SHUFFLE +5: Keg Smash") return true; end;
        --             elseif cast.able.blackoutKick("target") then
        --                 if cast.blackoutKick("target") then ui.debug("SHUFFLE +3: Blackout Kick") return true; end;
        --             else
        --                 if cast.able.spinningCraneKick() then
        --                     if cast.spinningCraneKick() then ui.debug("SHUFFLE PUSH: Spinning Crane Kick") return true; end;
        --                 end
        --             end
        --         end

        --         if cast.able.breathOfFire("target") then
        --             if cast.breathOfFire("target") then ui.debug("Breath of Fire") return true; end;
        --         end
        --         if cast.able.weaponsOfOrder("target") then
        --             if cast.weaponsOfOrder("target") then ui.debug("WOE") return true; end;
        --         end
        --         if cast.able.risingSunKick("target") then
        --             if cast.risingSunKick("target") then ui.debug("Rising Sun Kick") return true; end;
        --         end
        --         if cast.able.touchOfDeath("target") then
        --             if cast.touchOfDeath("target") then ui.debug("Touch of Death") return true; end;
        --         end
        --         if cast.able.summonWhiteTigerStatue("target") then
        --             if cast.summonWhiteTigerStatue("target") then ui.debug("White Target Statue") return true; end;
        --         end
        --         if cast.able.bonedustBrew("playerGround") then
        --             if cast.bonedustBrew("playerGround") then ui.debug("Bone Dust Brew") return true; end;
        --         end
        --         if buff.rushingJadeWind.exists("player") and cast.able.explodingKeg("target") then
        --             if cast.explodingKeg("target") then ui.debug("Exploding Keg") return true; end;
        --         end
                -- We need to ocassionally cast a damage spell; but the tigerPalm vs Spinning Crane kick options
                -- Would depend on # of enemies as well as if we need to collect globes.  Not sure we can get the
                -- # of globes on the ground nearby.
                -- if (ui.mode.rotation == 1 or ui.mode.rotation==2) and
                --         #enemies.yards8 >= 3 and
                --         buff.counterStrike.exists() and
                --         cast.able.spinningCraneKick() then
                --     if cast.spinningCraneKick() then ui.debug("PROC: Spinning Crane Kick") return true; end;
                -- elseif ui.mode.rotation == 3 and buff.counterStrike.exists() and cast.able.tigerPalm("target") then
                --     if cast.tigerPalm("target") then ui.debug("PROC: Tiger Palm") return true; end;
                -- end
                -- if buff.counterStrike.exists() and cast.able.tigerPalm("target") and not cast.last.tigerPalm(2)  then
                --     if cast.tigerPalm("target") then ui.debug("Proc Counterstrike, Tiger Palm") return true; end;
                -- end
                -- if buff.counterStrike.exists() and cast.able.spinningCraneKick() then
                --     if cast.spinningCraneKick() then ui.debug("Spinning Crane Kick") return true; end;
                -- end
                -- if cast.able.tigerPalm("target") then
                --     if cast.tigerPalm("target") then ui.debug("tiger Palm") return true; end;
                -- end
                -- if cast.able.tigersLust("player") then
                --     if cast.tigersLust("player") then ui.debug("tiger's Lust") return true; end;
                -- end

                -- if cast.able.autoAttack("target") then
                --     if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
                -- end
            --end
        --end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 268 -- Change to the spec id profile is for. Spec ID can be found at: https://wowpedia.fandom.com/wiki/SpecializationID
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})