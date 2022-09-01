--Version 1.0.0
local rotationName = "Panglo2.0"

local StunsBlackList = "167876|169861|168318|165824|165919|171799|168942|167612|169893|167536|173044|167731|165137|167538|168886|170572"
local para_unitList = "164702|164362|170488|165905|165251|165556"
local para_list = "326450|328177|336451|331718|331743|334708|333145|321807|334748|327130|327240|330532|328400|330423|294171|164737|330586|329224|328429|295001|296355|295001|295985|330471|329753|296748|334542|242391"
    

---------------
--- Toggles ---
---------------
local function createToggles()
    local CreateButton = br["CreateButton"]
-- Rotation Button
	br.RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "Enables DPS rotation", highlight = 1, icon = br.player.spell.blackoutKick },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.vivify }
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    br.CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.fortifyingBrew },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.fortifyingBrew },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.fortifyingBrew }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    br.DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dampenHarm },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dampenHarm }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    br.InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spearHandStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spearHandStrike }
    };
    CreateButton("Interrupt",4,0)
    br.BrewsModes = {
        [1] = { mode = "On", value = 1 , overlay = "Brews Enabled", tip = "Brews will be used.", highlight = 1, icon = br.player.spell.purifyingBrew },
        [2] = { mode = "Off", value = 2 , overlay = "Brews Disabled", tip = "No Brews will be used.", highlight = 0, icon = br.player.spell.legSweep }
    };
    CreateButton("Brews",5,0)
    br.TauntModes = {
        [1] = { mode = "Dungeon", value = 1 , overlay = "Taunt only in Dungeon", tip = "Taunt will be used in dungeons.", highlight = 0, icon = br.player.spell.provoke },
        [2] = { mode = "All", value = 2 , overlay = "Auto Taunt Enabled", tip = "Taunt will be used everywhere.", highlight = 1, icon = br.player.spell.provoke },
        [3] = { mode = "Dave", value = 3 , overlay = "Taunt the Statue", tip = "Taunt only be used on Dave", highlight = 1, icon = br.player.spell.summonBlackOxStatue },
        [4] = { mode = "Off", value = 4 , overlay = "Auto Taunt Disabled", tip = "Taunt will not be used.", highlight = 0, icon = br.player.spell.legSweep }
    };
    CreateButton("Taunt",6,0)
    br.DetoxModes = {
        [1] = { mode = "On", value = 1 , overlay = "Detox Enabled", tip = "Detox will be used.", highlight = 1, icon = br.player.spell.detox },
        [2] = { mode = "Off", value = 2 , overlay = "Detox Disabled", tip = "Detox will not be used.", highlight = 0, icon = br.player.spell.ringOfPeace }
    };
    CreateButton("Detox",7,0)
    br.SuperbrewModes = {
        [1] = { mode = "On", value = 1 , overlay = "Avoid Brew Capping Enabled", tip = "Dont waste the brews brah", highlight = 1, icon = br.player.spell.purifyingBrew },
        [2] = { mode = "Off", value = 2 , overlay = "Allow Brew Capping", tip = "Pour one out for the homies", highlight = 0, icon = br.player.spell.resuscitate }
    };
    CreateButton("Superbrew",0,1)

end

local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        ------------------------
        --- Blackout OPTIONS ---
        ------------------------
--        section = br.ui:createSection(br.ui.window.profile,  "BoC Priority")
        -- When Using BoC, Select Priority, or leave on Auto
--            br.ui:createDropdownWithout(section, "Select Priority", {"|cff1ED761Auto Mode","|cff20FF00Tiger Palm","|cffFFCC00Keg Smash","|cffFF0000Breath of Fire"},1, "Select the BoC Priority, Recommended Auto")
--        br.ui:checkSectionState(section)
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "|cff5AC18EGeneral - Version 1.000")
		-- Let Rotation Deal with Purifying (SIMC)
			br.ui:createCheckbox(section, "High Stagger Debuff")
        -- Stagger dmg % to purify
            br.ui:createSpinner(section, "Stagger dmg % to purify",  100,  0,  300,  5,  "Stagger dmg % to purify")
        -- Trinkets
            br.ui:createCheckbox(section, "Trinket 1")
            br.ui:createCheckbox(section, "Trinket 2")
        -- Racial
            br.ui:createCheckbox(section, "Racial")
        -- BoB usage
            br.ui:createCheckbox(section, "Black Ox Brew")
        -- Small Dave  
            br.ui:createCheckbox(section, "Summon Dave - The Statue")
            br.ui:createSpinnerWithout(section, "Spinning Crane Cutoff", 1, 0, 2, 0.1, "How many Purifying Brews needed before SCK in AoE")
            br.ui:createDropdown(section, "Ring of Peace", br.dropOptions.Toggle, 6, "Hold this key to cast Ring of Peace at Mouseover")
		br.ui:checkSectionState(section)
        -------------------------
		---  COOLDOWN OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "|cff5AC18ECooldowns")
            br.ui:createDropdown(section,"Weapons of Order",{"Always", "CD Only", "AoE Only"}, 1)
            br.ui:createSpinnerWithout(section,"WoO Aoe Count", 3, 1, 10, 1)
		--Invoke Niuzao
            br.ui:createCheckbox(section, "Invoke Niuzao")
            br.ui:createCheckbox(section, "Touch of Death")
        br.ui:checkSectionState(section)
        -------------------------
		--- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "|cff5AC18EDefensive")
            br.player.module.BasicHealing(section)
        -- Healing Elixir
            br.ui:createSpinner(section, "Healing Elixir", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Fortifying Brew
            br.ui:createSpinner(section, "Fortifying Brew",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Celestial Brew
            br.ui:createSpinner(section, "Celestial Brew", 50,  0,  100,  5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Celestial Purify Stacks", 4, 0, 10, 1, "Purifying damage adds 1 stack to the buff")
        -- Dampen Harm
            br.ui:createSpinner(section, "Dampen Harm",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Detox
            br.ui:createCheckbox(section, "Detox Me")
        -- Detox
            br.ui:createCheckbox(section, "Detox Mouseover")
        -- Expel Harm
            br.ui:createSpinner(section, "Expel Harm",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
		-- Expel Harm Orbs
            br.ui:createSpinnerWithout(section, "Expel Harm Orbs",  3,  0,  15,  1,  "|cffFFFFFFMin amount of Gift of the Ox Orbs to cast.")
        -- Vivify
            br.ui:createSpinner(section, "Vivify",  50,  0,  100,  5,  "|cffFFFFFFCast Vivify")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "|cff5AC18EInterrupts")
        -- Spear Hand Strike
            br.ui:createCheckbox(section, "Spear Hand Strike")
        -- Paralysis
            br.ui:createCheckbox(section, "Incap Logic","Utilizes logic to incap priority targets")
        -- Leg Sweep
            br.ui:createCheckbox(section, "Leg Sweep")
        -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  100,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "|cff5AC18EIncap/Stuns")
            br.ui:createScrollingEditBoxWithout(section,"Stuns Black Units", StunsBlackList, "List of units to blacklist when Hammer of Justice", 240, 50)
            br.ui:createScrollingEditBoxWithout(section,"Stun Spells", para_list, "List of spells to stun with auto stun function", 240, 50)
            br.ui:createScrollingEditBoxWithout(section,"Para Prio Units", para_unitList, "List of units to prioritize for Paralysis", 240, 50)
        br.ui:checkSectionState(section)
        ----------------------
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

----------------
--- ROTATION ---
----------------
local setwindow = false
local function runRotation() 

    if setwindow == false then
        br._G.RunMacroText("/console SpellQueueWindow 0")
        br.player.ui.print("Set SQW")
        setwindow = true
    end
    --Print("Running: "..rotationName)

    --------------
    --- Locals ---
    --------------
    local buff              = br.player.buff
    local cast              = br.player.cast
    local cd                = br.player.cd
    local charges           = br.player.charges
    local debuff            = br.player.debuff
    local enemies           = br.player.enemies
    local equiped           = br.player.equiped
    local flaskBuff         = br.getBuffRemain("player",br.player.flask.wod.buff.agilityBig) or 0
    local gcd               = br.player.gcdMax
    local hasPet            = br._G.IsPetActive()
    local glyph             = br.player.glyph
    local inRaid            = select(2,br._G.IsInInstance())=="raid"
    local inInstance        = br.player.instance=="party"
    local lastSpell         = lastSpellCast
    local level             = br.player.level
    local mode              = br.player.ui.mode
    local module            = br.player.module
    local pet               = br.player.pet.list
    local php               = br.player.health
    local power             = br.player.power.energy.amount()
    local powgen            = br.player.power.energy.regen()
    local powerDeficit		= br.player.power.energy.deficit()
    local powerMax          = br.player.power.energy.max()
    local pullTimer         = br.DBM:getPulltimer()
    local queue             = br.player.queue
    local race              = br.player.race
    local racial            = br.player.getRacial()
    local regen             = br.player.power.energy.regen()
    local solo              = select(2,br._G.IsInInstance())=="none"
    local spell             = br.player.spell
    local talent            = br.player.talent
    local thp               = br.getHP("target")
    local trinketProc       = false --br.player.hasTrinketProc()
    local ttd               = br.getTTD
    local ttm               = br.player.power.energy.ttm()
    local ui                = br.player.ui
    local unit              = br.player.unit
    local units             = br.player.units
    local staggerPct        = (br._G.UnitStagger("player") / br._G.UnitHealthMax("player")*100)
    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end

    --Laks edits - for essence
    local lowest = br.friend[1]
    local essence = br.player.essence

    units.get(5)
    units.get(8)
    enemies.get(5)
    enemies.get(8)
    enemies.get(8,"target")
    enemies.get(20)
    enemies.get(30)

    local noStunsUnits = {}
	for i in string.gmatch(br.getOptionValue("Stuns Black Units"), "%d+") do
		noStunsUnits[tonumber(i)] = true
	end
	local StunSpellsList = {}
	for i in string.gmatch(br.getOptionValue("Stun Spells"), "%d+") do
		StunSpellsList[tonumber(i)] = true
	end
	local ParaList = {}
	for i in string.gmatch(br.getOptionValue("Para Prio Units"), "%d+") do
		ParaList[tonumber(i)] = true
	end                    

    if br.timersTable then
        br._G.wipe(br.timersTable)
    end

    --------------------
    --- Action Lists ---
    --------------------

    local function key()
        if (br.SpecificToggle("Ring of Peace") and not br._G.GetCurrentKeyBoardFocus()) and ui.checked("Ring of Peace") then
            if cast.able.ringOfPeace() then
                if br._G.CastSpellByName(br._G.GetSpellInfo(spell.ringOfPeace),"cursor") then return true end
            end
        end
    end
    -- Action List - Extras
    local function actionList_Extras()
        -- Taunt
        if (mode.taunt == 1 or (mode.taunt == 3)) and inInstance then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if br._G.UnitThreatSituation("player", thisUnit) ~= nil and br._G.UnitThreatSituation("player", thisUnit) <= 2 and br._G.UnitAffectingCombat(thisUnit) then
                    if cast.provoke(thisUnit) then return end
                end
            end
        end -- End Taunt
        if (mode.taunt == 2 or (mode.taunt == 3)) then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if br._G.UnitThreatSituation("player", thisUnit) ~= nil and br._G.UnitThreatSituation("player", thisUnit) <= 2 and br._G.UnitAffectingCombat(thisUnit) then
                    if cast.provoke(thisUnit) then return end
                end
            end
        end -- End Taunt
        if ui.checked("Summon Dave - The Statue") then
            local castOx
            --local bX,bY,bZ
            for i = 1, 5 do
                if select(2,br._G.GetTotemInfo(i)) == "Black Ox Statue" or br._G.GetTotemInfo(i) == nil then
                    castOx = false
                    break
                else
                    castOx = true
                end
            end

            if castOx or (bX ~= nil and br.getDistanceToObject("player",bX,bY,bZ) >= 20) then
                if cast.summonBlackOxStatue("target") then 
                    --ui.print("Trying to cast ox")
                    bX, bY, bZ = br.ObjectPosition("target")
                    return 
                end
            end
            if mode.taunt == 3 then
                if br.unlocked then --EWT ~= nil then
                    for i = 1, #br.omUnits do
                        local object = br.omUnits[i]
                        local ID = br._G.ObjectID(object)
                        if ID == 61146 then
                                for j = 1, #enemies.yards30 do
                                local thisUnit = enemies.yards30[i]
                                if br._G.UnitThreatSituation("player", thisUnit) ~= nil and br._G.UnitThreatSituation("player", thisUnit) <= 2 and br._G.UnitAffectingCombat(thisUnit) then
                                    if cast.provoke(object) then
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end -- End Action List - Extras
    -- Action List - Defensive
    local function actionList_Defensive()
        if br.useDefensive() then
            -- Vivify
            if ui.checked("Vivify") and (not unit.inCombat() and php <= ui.value("Vivify")) then
                if cast.vivify("player") then 
                    return 
                end
            end
                --Expel Harm
            if ui.checked("Expel Harm") and php <= ui.value("Expel Harm") and unit.inCombat() and GetSpellCount(322101) >= ui.value("Expel Harm Orbs") then
                if cast.expelHarm() then return end
            end

            module.BasicHealing()
            -- Dampen Harm
            if ui.checked("Dampen Harm") and php <= ui.value("Dampen Harm") and unit.inCombat() then
                if cast.dampenHarm() then return end
            end
            -- Detox
            if ui.checked("Detox Me") and mode.detox == 1 then
                if br.canDispel("player",spell.detox) then
                    if cast.detox("player") then return end
                end
            end
            -- Detox Mouseover
            if ui.checked("Detox Mouseover") and mode.detox == 1 then
                if br._G.UnitIsPlayer("mouseover") and not unit.deadOrGhost("mouseover") then
                    if br.canDispel("mouseover",spell.detox) then
                        if cast.detox("mouseover") then 
                            return 
                        end
                    end
                end
            end
            -- Healing Elixir
            if ui.checked("Healing Elixir") and php <= ui.value("Healing Elixir") and charges.healingElixir.count() > 1 then
                if cast.healingElixir() then return end
            end
            -- Fortifying Brew
            if ui.checked("Fortifying Brew") and php <= ui.value("Fortifying Brew") and unit.inCombat() then
                if cast.fortifyingBrew() then return end
            end

            if ui.checked("Celestial Brew") and php <= ui.value("Celestial Brew") and unit.inCombat() and buff.purifiedChi.stack() >= ui.value("Celestial Purify Stacks") then
                if cast.celestialBrew("player") then return end
            end
        end
    end
    -- Action List - Cooldowns
    local function actionList_Cooldowns()
        if ui.checked("Weapons of Order") and cd.kegSmash.exists() and not cd.weaponsOfOrder.exists() and (ui.value("Weapons of Order") == 1 or (ui.value("Weapons of Order") == 2 and br.useCDs()) or (ui.value("Weapons of Order") == 3 and #enemies.yards20 >= ui.value("WoO Aoe Count")))then
            if cast.weaponsOfOrder("player") then
                return true
            end
        end
        if br.useCDs() then
            if ui.checked("Invoke Niuzao") then
                if cast.invokeNiuzao() then return end
            end
            if ui.checked("Touch of Death") then
                for i = 1, #enemies.yards8 do
                    local thisUnit = enemies.yards8[i]
                    if br._G.UnitHealthMax("player") > br._G.UnitHealth(thisUnit) then
                        if cast.touchOfDeath(thisUnit) then
                            return
                        end
                    end
                end
            end
        end
        -- Trinkets
        if ui.checked("Trinket 1") then
                br.useItem(13)
        end
        if ui.checked("Trinket 2") then
                br.useItem(14)
        end
    end
    -- Action List - Interrupts
    local function actionList_Interrupts()
        if br.useInterrupts() then
            for i=1, #enemies.yards20 do
                thisUnit = enemies.yards20[i]
                distance = br.getDistance(thisUnit)
                if br.canInterrupt(thisUnit,ui.value("InterruptAt")) then
                    if distance <= 5 then
                        -- Spear Hand Strike
                        if ui.checked("Spear Hand Strike") then
                            if cast.spearHandStrike(thisUnit) then return end
                        end
                        -- Leg Sweep
                        if ui.checked("Leg Sweep") and noStunsUnits[br._G.ObjectID(thisUnit)] == nil and not br.isBoss(thisUnit) then
                            if cast.legSweep(thisUnit) then return end
                        end
                    end
                end
            end
            -- Paralysis
            if ui.checked("Incap Logic") then
                if cast.able.paralysis() then
                    for i = 1, #enemies.yards20 do
                        local thisUnit = enemies.yards20[i]
                        local interruptID

                        if ParaList[br._G.ObjectID(thisUnit)] ~= nil then
                            if cast.paralysis(thisUnit) then return true end
                        end

                        if br._G.UnitCastingInfo(thisUnit) then
                            interruptID = select(9,br._G.UnitCastingInfo(thisUnit))
                        elseif br._G.UnitChannelInfo(thisUnit) then
                            interruptID = select(8,br._G.UnitChannelInfo(thisUnit))
                        end
                        
                        if interruptID ~=nil and StunSpellsList[interruptID] and br.getBuffRemain(thisUnit,343503) == 0 then
                            if unit.distance(thisUnit) <= 5 then
                                if cast.quakingPalm(thisUnit) then 
                                    return true 
                                end
                            end
                            if unit.distance(thisUnit) > 5 or cd.quakingPalm.exists() then 
                                if cast.paralysis(thisUnit) then 
                                    return true 
                                end
                            end
                        end
                    end
                end
            end
        end
    end -- End Action List - Interrupts
    -- Action List - Pre-Combat
    local function actionList_PreCombat()
        -- auto_attack
        if unit.valid("target") and unit.distance("target") < 5 then
            br._G.StartAttack()
        end
    end --End Action List - Pre-Combat

    ---------------------
    --- Rotations Code---
    ---------------------

    -- Single Target Rotation
    local function actionList_Single()
        -- Print("Single")
        -- Keg Smash
        if cast.kegSmash(units.dyn5) then return end
        -- Black Out Strike
        if cast.blackoutKick(units.dyn5) then return end
        -- Breath of Fire
        if debuff.kegSmash.exists(units.dyn5) then
            if cast.breathOfFire(units.dyn5) then return end
        end
        -- High Energy TP
        if (power > 55) and (not talent.rushingJadeWind or buff.rushingJadeWind.exists()) and not (cd.blackoutKick.remain() < gcd or cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
            if cast.tigerPalm(units.dyn5) then return end
        end
        -- Rushing Jade Wind
        if not buff.rushingJadeWind.exists() or (buff.rushingJadeWind.remain() < 2 and not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd)) then
            if cast.rushingJadeWind(units.dyn5) then return end
        end
        -- Chi Wave
        if not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
            if cast.chiWave(units.dyn5) then return end
        end
        -- Chi Burst
        if not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
            if cast.chiBurst(units.dyn5) then return end
        end
    end -- End Single Target

    -- Multi Target Rotation
    local function actionList_Multi()
        -- Print("Multi")
        -- Keg Smash
        if cast.kegSmash(units.dyn5) then return end
        -- Breath of Fire
        if debuff.kegSmash.exists(units.dyn5) then
            if cast.breathOfFire() then return end
        end
        -- Rushing Jade Wind
        if not buff.rushingJadeWind.exists() or (buff.rushingJadeWind.remain() < 2 and not (cd.blackoutKick.remain() < gcd or cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd)) then
            if cast.rushingJadeWind("player") then return end
        end
        -- Chi Burst
        if not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
            if cast.chiBurst(units.dyn5) then return end
        end
        -- Black Out Strike
        if cast.blackoutKick(units.dyn5) then return end
         -- Chi Wave
        if not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
            if cast.chiWave(units.dyn5) then return end
        end
        if power > 55 and (charges.purifyingBrew.frac() >= ui.value("Spinning Crane Cutoff")) and (not talent.rushingJadeWind or buff.rushingJadeWind.exists()) and (not talent.eyeOfTheTiger or buff.eyeOfTheTiger.exists()) and not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
            if cast.spinningCraneKick("player") then
                return
            end
        end
        -- Tiger Palm
        if power > 55 and (not talent.rushingJadeWind or buff.rushingJadeWind.exists()) and not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
            if cast.tigerPalm(units.dyn5) then return end
        end
    end

    -- Blackout Combo Rotation
    local function actionList_AutoBlackout()
        if buff.blackoutCombo.exists() then
            if cast.kegSmash(units.dyn5) then return end
            if cd.kegSmash.remain() > gcd then
                if cast.tigerPalm(units.dyn5) then return end
            end
        else
            if cast.blackoutKick(units.dyn5) then return end
            if (not talent.rushingJadeWind or buff.rushingJadeWind.exists()) and not (cd.blackoutKick.remain() < gcd or cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) and power > 45 then
                if cast.tigerPalm(units.dyn5) then return end
            end
            if cd.kegSmash.remain() > gcd and debuff.kegSmash.exists(units.dyn5) then
                if cast.breathOfFire(units.dyn5) then return end
            end
            if not buff.rushingJadeWind.exists() or (buff.rushingJadeWind.remain() < 2 and not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd)) then
                if cast.rushingJadeWind("player") then return end
            end
        end
    end

    -- Brews Rotations
    local function actionList_Brews()
        --Black Ox Brew
        if ui.checked("Black Ox Brew") and talent.blackoxBrew then
            if (charges.purifyingBrew.frac() < 0.7) or
                (charges.purifyingBrew.count() == 0 and (staggerPct >= ui.value("Stagger dmg % to purify"))) then
                if cast.blackoxBrew("player") then return end
            end
        end
        -- Auto Purify
        if ui.checked("High Stagger Debuff") then
            if debuff.heavyStagger.exists("player") and charges.purifyingBrew.frac() > 0.8 then
                if cast.purifyingBrew("player") then return end
            end
        end
        -- Percentage Purify
        if ui.checked("Stagger dmg % to purify") then
            if (staggerPct >= ui.value("Stagger dmg % to purify") and charges.purifyingBrew.frac() > 0.5) then
                if cast.purifyingBrew("player") then return end
            end
        end
        --Brew Capper
        if mode.superbrew == 1 and br._G.UnitStagger("player") > 1 then
            if charges.purifyingBrew.frac() == charges.purifyingBrew.max() and unit.inCombat() then
                if debuff.heavyStagger.exists("player") then
                    if cast.purifyingBrew("player") then return end
                elseif staggerPct > (ui.value("Stagger dmg % to purify")/2) then
                    if cast.purifyingBrew("player") then return end 
                elseif buff.purifiedChi.remains("player") <= 3 and charges.purifyingBrew.frac() > 1.8 then
                    if cast.purifyingBrew("player") then return end 
                end
            end
        end
    end

    if br.isCastingSpell(115176) or buff.zenMeditation.exists("player") then
        return true
    end

    ----------------------
    --- Begin Rotation ---
    ----------------------
    -- Profile Stop | Pause
    if not br._G.IsMounted() then
        -- Brews
        if mode.brews == 1 then
            if actionList_Brews() then return end
        end
        if br.pause() or br.isLooting() then
            return true
        else
            if not unit.inCombat() then
                if key() then return end
                -- Extras
                if actionList_Extras() then return end
                -- Defensives
                if actionList_Defensive() then return end
                
                if actionList_Interrupts() then return end
                -- Precombat
                if actionList_PreCombat() then return end
            end
            if unit.inCombat() then
                if br.getDistance(units.dyn5) < 5 then
                    br._G.StartAttack()
                end

                if key() then return end

                if actionList_Extras() then return end

                if actionList_Defensive() then return end
                
                if actionList_Interrupts() then return end

                if actionList_Cooldowns() then return end

                if talent.blackoutCombo then
                    if actionList_AutoBlackout() then return end
                end

                -- Multi Target Rotations
                if #enemies.yards8 >= 3 and not talent.blackoutCombo then
                    if actionList_Multi() then return end
                end
                -- Single target Rotations
                if #enemies.yards8 <3 and not talent.blackoutCombo then
                    if actionList_Single() then return end
                end
            end -- end combat check
        end -- Pause
    end
end -- End runRotation 

local id = 268
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
