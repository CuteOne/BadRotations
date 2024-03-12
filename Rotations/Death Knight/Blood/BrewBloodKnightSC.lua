-------------------------------------------------------
-- Author = BrewingCoder
-- Patch = 10.2.5
-- Coverage = 100%
-- Status = Full
-- Readiness = Raid
-------------------------------------------------------
local rotationName = "BrewBloodKnight-SimC" 

local LastMessageTime = 0


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
    options = {
        onlyUseConsumablesInRaid = "Only Use Consumables in Dungeon or Raid",
        useCDRaiseDead = "Use Raise Dead",
        useCDDancingRuneWeapon = "Use Dancing Rune Weapon",
        useCombatPotWhenCDsActive = "Use CombatPotion When CDs Active",
        onlyUseCombatPotOnBoss = "Use CombatPotion only with Boss",
        AoeLoadAmount = "Number of Units to enter AOE Mode",
        LichborneNoControl = "Cast lichborne on loss of control"
    },
    taunt ={
        onlyTauntInInstances        = colors.orange .. "Only Taunt in Raid/Dungeon",
        UseDarkCommandTaunt         = colors.orange .. "Use Dark Command To Taunt",
        UseDeathGripTaunt           = colors.orange .. "Use Death Grip To Taunt",
        UseDeathsCaressTaunt        = colors.orange .. "Use Death's Caress",
        TauntRange                  = colors.orange .. "Range To Taunt",
    },
    cooldowns = {
        DancingRuneWeapon           = colors.purple .."Dancing Rune Weapon",
        RaiseDead                   = colors.purple .."Raise Dead",
        EmpowerRuneWeapon           = colors.purple .."Empower Rune Weapon",
        useRacial                   = colors.purple .."Use Racial",
        useCombatPotion             = colors.purple .."Use Combat Potion"
    },
}

local function createToggles()
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.", highlight = 1, icon = br.player.spell.darkCommand },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.heartStrike },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.iceboundFortitude },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.bloodTap}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)

    local AutoPullModes = {
        [1] = { mode = "On", value =1, overlay = "Auto Pull/Taunt Enabled", tip = "Auto Pull/Taunt Enemies", highlight = 1, icon = br.player.spell.deathGrip},
        [2] = { mode = "Off", value = 2, overlay = "Auto Pull/Taunt Disabled", tip = "Do Not AutoPull/Taunt Enemies", highlight=0, icon=br.player.spell.deathGrip}
    };
    br.ui:createToggle(AutoPullModes,"Autopull",2,0)
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss/AOE Load Detection.", highlight = 1, icon = br.player.spell.raiseDead },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.raiseDead},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.raiseDead }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",3,0)
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.lichborne },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.lichborne }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",4,0)
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.mindFreeze }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",5,0)
    local DebugModes = {
        [1] = { mode = "ON", value = 1 , overlay = "Debugs On", tip = "Debug Messages On", highlight = 1, icon =200733 },
        [2] = { mode = "OFF", value = 0 , overlay = "Debugs Off", tip = "Debug Messages Off", highlight = 0, icon =200733 },
    }
    br.ui:createToggle(DebugModes,"Debugs",6,0)
end

local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        section = br.ui:createSection(br.ui.window.profile,  "General")
                    br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
                    br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
                    br.ui:createSpinnerWithout(section,text.options.AoeLoadAmount,4,2,40,1,"|cffFFFFFFSet Number of Enemies required to go into AOE Mode (triggers CDs)")                    
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile,  colors.purple .. "Cooldowns")
                    br.ui:createText(section,colors.purple .. "CDs will be used based on CD toggle and AOE settings")
                    br.ui:createText(section,colors.purple .. "Typically you want this on Auto to use CDs only on Boss or if")
                    br.ui:createText(section,colors.purple .. "your # of targets meet or exceed those in the AOE value above")
                    br.ui:createText(section,colors.purple .. "")
                    br.ui:createCheckbox(section,text.cooldowns.DancingRuneWeapon)
                    br.ui:createCheckbox(section,text.cooldowns.RaiseDead)
                    br.ui:createCheckbox(section,text.cooldowns.EmpowerRuneWeapon)
                    br.ui:createCheckbox(section,text.cooldowns.useRacial)
                    br.ui:createCheckbox(section,text.cooldowns.useCombatPotion)
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, colors.orange .. "Keeping Aggro")
                    br.ui:createCheckbox(section,text.taunt.onlyTauntInInstances)
                    br.ui:createSpinnerWithout(section,text.taunt.TauntRange,10,10,30,5,colors.blue .. "Range to Gain Threat")
                    br.ui:createCheckbox(section,text.taunt.UseDarkCommandTaunt)
                    br.ui:createCheckbox(section,text.taunt.UseDeathGripTaunt)
                    br.ui:createCheckbox(section,text.taunt.UseDeathsCaressTaunt)
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            br.ui:createCheckbox(section,text.options.LichborneNoControl)
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile,"Potions,Phials,and Runes")
            br.ui:createCheckbox(section,text.options.onlyUseConsumablesInRaid)
            br.player.module.PhialUp(section)
            br.player.module.ImbueUp(section)
            br.player.module.CombatPotionUp(section)
            br.ui:createCheckbox(section,text.options.onlyUseCombatPotOnBoss)
            br.player.module.BasicHealing(section)
            br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Mind Freeze
            br.ui:createCheckbox(section,"Mind Freeze")
            br.ui:createCheckbox(section,"Use Death Grip as Interrupt")
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
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
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
local use
local var
local debuff
local runes
local runicPower
local runicPowerMax

local function round(number, digit_position) 
    local precision = math.pow(10, digit_position)
    number = number + (precision / 2); -- this causes value #.5 and up to round up
                                       -- and #.4 and lower to round down.
  
    return math.floor(number / precision) * precision
  end

local function printStats(message)  
    local drwString
    local empowerString
    local ghoulString
    local RuneString
    local RPString
    local RPDString

     drwString = colors.white .. "[" .. (buff.dancingRuneWeapon.exists() and colors.green or colors.red) .."DRW" ..colors.white .. "]"
     empowerString =colors.white .. "[" .. (buff.empowerRuneWeapon.exists() and colors.green or colors.red) .. "ERW" ..colors.white .. "]"
     ghoulString =""
    if var.hasGhoul then
        ghoulString =colors.white .. "[" .. colors.green .. "Ghoul:" ..math.floor(var.ghoulTTL) .. colors.white .. "]" .. colors.white
    else
        ghoulString =colors.white .. "[" .. colors.red .. "Ghoul" .. colors.white .. "]" .. colors.white
    end
     RuneString = colors.white .. "[R:" .. runes .. "]".. colors.white
     RPString = colors.white .. "[RP:" .. runicPower .. "]".. colors.white
     RPDString = colors.white .. "[RPD:" .. var.runicPowerDeficit .. "]".. colors.white
     local lastTime = ui.time() - var.lastCast 
    print(colors.red.. date("%T") ..colors.aqua .."[+" .. round(lastTime,-2) .. "]" ..colors.white .. drwString .. empowerString .. ghoulString ..colors.white.. RuneString ..RPString..RPDString..colors.white .. " : ".. message)
end

local debugMessage = function(message)
    if ui.mode.Debug == 1 then printStats(message) end
    var.lastCast = ui.time()
end

local function checkTiming(message)
    if ui.mode.Debug == 1 then
        if (ui.time() - var.lastCast > 2 and #enemies.yards5f >= 1) or var.DoTiming ~= nil then
            printStats("TIMING:" .. message)
        end
    end        
end

local function runeTimeUntil(rCount)
    if rCount <= var.runeCount then return 0 end
        local delta = rCount - var.runeCount
        local maxTime = 0
        for i=1,delta do
            maxTime = math.max(maxTime,var.runeCooldowns[i])
        end
        return maxTime
end


--------------------
--- Action Lists --- -- All Action List functions from SimC (or other rotation logic) here, some common ones provided
--------------------
local actionList = {
     healing = {
        CDs = function()
        end
    }
} 

actionList.Aggro = function()
    if ui.mode.AutoPull ~=1 then return false end
    if (ui.checked(text.taunt.onlyTauntInInstances) and (var.inInstance or var.inRaid)) or not ui.checked(text.taunt.onlyTauntInInstances) then
        local theseUnits = enemies.yards8
        if ui.value(text.taunt.TauntRange) == 10 then theseUnits = enemies.yards10 end
        if ui.value(text.taunt.TauntRange) == 15 then theseUnits = enemies.yards15 end
        if ui.value(text.taunt.TauntRange) == 20 then theseUnits = enemies.yards20 end
        if ui.value(text.taunt.TauntRange) == 25 then theseUnits = enemies.yards25 end
        if ui.value(text.taunt.TauntRange) == 30 then theseUnits = enemies.yards30 end
        for i=1,#theseUnits do
            local UnitName =  br._G.UnitName(theseUnits[i])
            if not unit.isTanking(theseUnits[i]) and not (br.getCreatureType(theseUnits[i]) == "totem") and not(string.find(UnitName,"Totem",0,true)) then
                if ui.checked(text.taunt.UseDarkCommandTaunt) and cast.able.darkCommand(theseUnits[i]) then
                    if cast.darkCommand(theseUnits[i]) then debugMessage(colors.orange .. "Dark Command on " ..colors.red .. UnitName) return true; end
                end
                if ui.checked(text.taunt.UseDeathGripTaunt) and cast.able.deathGrip(theseUnits[i]) and unit.distance(theseUnits[i]) > 8 then
                    if cast.deathGrip(theseUnits[i]) then debugMessage(colors.orange .. "Death Grip on " .. colors.red .. UnitName) return true; end
                end
                if ui.checked(text.taunt.UseDeathsCaressTaunt) and cast.able.deathsCaress(theseUnits[i]) then
                    if cast.deathsCaress(theseUnits[i]) then debugMessage(colors.orange .. "Death's Caress on " .. colors.red .. UnitName) return true; end
                end
            end
        end
        return false
    end
end

actionList.Extra = function()

        --if ui.checked("Only Taunt in Instance or Raid") and not (var.inRaid or var.inInstance) then return false end
        --local enemiesList = enemies.yards20
        --if ui.value("Taunt Range") == 30 then enemiesList = enemies.yards30 end
        --if ui.value("Taunt Range") == 20 then enemiesList = enemies.yards20 end
        --if ui.value("Taunt Range") == 10 then enemiesList = enemies.yards10 end
        -- if enemiesList ~= nil then
        --     for i=1,#enemiesList do
        --         local thisUnit = enemiesList[i]
        --         if not unit.isTanking(thisUnit) and unit.threat(thisUnit) and not unit.isExplosive(thisUnit) and cast.able.darkCommand(thisUnit) then
        --             if cast.darkCommand(thisUnit) then debugMessage("Casting Dark Command [Not Tanking]") return true end
        --         end
        --     end
        -- end
        -- enemiesList = enemies.yards20
        -- if enemiesList ~= nil then
        --     for i=1,#enemiesList do
        --         local thisUnit = enemiesList[i]
        --         if not unit.isTanking(thisUnit) and unit.threat(thisUnit) and not unit.isExplosive(thisUnit) and cast.able.deathGrip(thisUnit) then
        --             if cast.deathGrip(thisUnit) then debugMessage("Casting Death Grip [Not Tanking]") return true end
        --         end
        --     end
        -- end
 
end 

actionList.InstanceActions = function()

    local function reactDeathsAdvance()
        if cast.able.deathsAdvance() then
            if cast.deathsAdvance() then debugMessage(colors.yellow .. "BOSS REACTION: " .. colors.green2 .. "Death's Advance") return true; end
        end
    end
    local function reactLichborne()
        if cast.able.lichborne() then
            if cast.lichborne() then debugMessage(colors.yellow .. "BOSS REACTION: " .. colors.green2 .. "Lichborne") return true; end
        end
    end
    local function reactAntiMagicShell()
        if cast.able.antiMagicShell() then
            if cast.antiMagicShell() then debugMessage(colors.yellow .. "BOSS REACTION: " .. colors.green2 .. "Anti Magic Shell") return true; end
        end
    end
    local function reactIceboundFortitude()
        if cast.able.iceboundFortitude() then
            if cast.iceboundFortitude() then debugMessage(colors.yellow .. "BOSS REACTION: " .. colors.green2 .. "Icebound Fortitude") return true; end
        end
    end

    local instanceID = br.getCurrentZoneId()
    --2516	The Nokhud Offensive
    if instanceID == 2516 then
        --Granyth 
        if br.DBM:getTimer(388283) < 3 then return reactIceboundFortitude()  end --Eruption
        if br.DBM:getTimer(385916) < 3 then return reactDeathsAdvance() end 
        --Tempest 
        if br.DBM:getTimer(384316) < 3 then return reactAntiMagicShell() end
        --Maruuk
        if br.DBM:getTimer(386063) < 3 then return reactLichborne() end    --386063 Frightful roar, pop Lichborne
        if br.DBM:getTimer(382836) < 3 then return reactIceboundFortitude() end 
        --Teera
        if br.DBM:getTimer(386547) < 3 or br.DBM:getTimer(384808) < 3 then return reactDeathsAdvance() end
        --Balakar
        -- Iron Spear knocks back, try deathsAdvance
        if (br.DBM:getTimer(376634) < 3 or br.DBM:getTimer(376683) < 3 or br.DBM:getTimer(375943) < 3 ) then return reactDeathsAdvance() end
    --2451	Uldaman: Legacy of Tyr
    elseif instanceID == 2451 then
        --Dwarves, not much we can do as they really only have physical attacks
        --heavy arrow has a knockback, so hitup DA
        if br.DBM:getTimer(369573) < 3 then return reactDeathsAdvance() end
        --Bromach Thundering Smal
        if br.DBM:getTimer(369703) < 3 then return reactAntiMagicShell() end
        --Talondras Crushing Stomp
        if br.DBM:getTimer(372701) < 3 then return reactDeathsAdvance() end
        --Talondras: Resonating Orb, do we need to call this?
        if br.DBM.getTimer(372623) < 3 then return reactAntiMagicShell() end
        --Emberon Searing Clap
        if br.DBM.getTimer(369061) < 3 then return reactAntiMagicShell() end
        --Deios Wing Buffet
        if br.DBM.getTimer(376049) < 3 then return reactDeathsAdvance() end
        --Sand Breath
        if br.DBM.getTimer(375727) < 3 then return reactAntiMagicShell() end
        







    end
end

actionList.Defensive = function()
end 

actionList.Interrupt = function()
    if ui.useInterrupt() and ui.delay("Interrupts",unit.gcd()) then
        local thisUnit
        for i=1, #enemies.yards15 do
            thisUnit = enemies.yards15[i]
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                if ui.checked("Mind Freeze") and cast.able.mindFreeze(thisUnit) then
                    if cast.mindFreeze(thisUnit) then debugMessage("Casting Mind Freeze on "..unit.name(thisUnit)) return true end
                end
                if ui.checked("Use Death Grip as Interrupt") and cast.able.deathGrip(thisUnit) then
                    if cast.deathGrip(thisUnit) then debugMessage("Casting Death Grip Interrupt on "..unit.name(thisUnit)) return true end
                end
            end
        end
    end
    if ui.checked(text.options.LichborneNoControl) and br.isIncapacitated(br.player.spell.lichborne)  and cast.able.lichborne() then
        if cast.lichborne() then debugMessage("Lichborne to regain control") return true end
    end
end 

actionList.Cooldown = function()
    if 
        (ui.mode.CoolDowns == 1 and unit.isBoss("target")) or 
        (ui.mode.Rotation == 1 and #enemies.yards8 > ui.value(text.options.AoeLoadAmount)) or
        ui.mode.CoolDowns == 2 then
            if ui.checked(text.cooldowns.RaiseDead) and cast.able.raiseDead() then
                if cast.raiseDead() then debugMessage( colors.purple .. "CD: Raise Dead") return true; end;
            end
            
            --dancing_rune_weapon,if=!buff.dancing_rune_weapon.up
            if ui.checked(text.cooldowns.DancingRuneWeapon) then
                if not buff.dancingRuneWeapon.exists() and cast.able.dancingRuneWeapon() then
                    if cast.dancingRuneWeapon() then debugMessage(colors.purple .. "CD:Dancing Rune Weapon") return true; end;
                end
            end

            --empower_rune_weapon,if=rune<6&runic_power.deficit>5
            if ui.checked(text.cooldowns.EmpowerRuneWeapon) then
                if runes < 6 and (runicPowerMax - runicPower) > 5 and cast.able.empowerRuneWeapon() then
                    if cast.empowerRuneWeapon() then debugMessage(colors.purple .. "CD:Empower Rune Weapon") return true; end;
                end
            end

            if ui.checked(text.cooldowns.useCombatPotion) and 
                ( (ui.checked(text.options.onlyUseCombatPotOnBoss) and unit.isBoss("target")) or not ui.checked(text.options.onlyUseCombatPotOnBoss)) then
                if buff.dancingRuneWeapon.exists() and var.hasGhoul and unit.ttdGroup(10) > 30 then
                    if(ui.checked(text.options.onlyUseConsumablesInRaid) and (var.inInstance or var.inRaid)) or not ui.checked(text.options.onlyUseConsumablesInRaid) then
                        if module.CombatPotionUp() then debugMessage(colors.purple .. "CD: Using Combat Potion") return true; end    
                    end
                end
            end

            if ui.checked(text.cooldowns.useRacial) then
                if cast.able.racial() then
                    if cast.racial() then debugMessage(colors.purple .. "CD: Racial") return true; end;
                end
            end
    end
    return false
end 

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted() or unit.taxi()) then -- Only run when not in combat and not flying/mounted/taxi
        if (ui.checked(text.options.onlyUseConsumablesInRaid) and (var.inRaid or var.inInstance)) or not(ui.checked(text.options.onlyUseConsumablesInRaid)) then
            module.ImbueUp()
            module.PhialUp()
        end
        if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
            -- Logic based on pull timers (IE: DBM/BigWigs)
        end -- End Pre-Pull
    end -- End No Combat
end -- End Action List - PreCombat

actionList.DRWActive = function()
        
                --blood_boil,if=!dot.blood_plague.ticking
                if not debuff.bloodPlague.exists("target") and cast.able.bloodBoil() then
                    if cast.bloodBoil("target") then debugMessage("DRW:blood boil") return true; end;
                end
                --tombstone,if=buff.bone_shield.stack>5&rune>=2&runic_power.deficit>=30&!talent.shattering_bone|(talent.shattering_bone.enabled&death_and_decay.ticking)
                if buff.boneShield.stack("player") > 5 and 
                    runes >= 2 and 
                    var.runicPowerDeficit >= 30
                    and not talent.shatteringBone or (talent.shatteringBone and buff.deathAndDecay.exists()) and
                    cast.able.tombstone() then
                        if cast.tombstone() then debugMessage("DRW:N:tombstone") return true; end;
                end

                --death_strike,if=buff.coagulopathy.remains<=gcd|buff.icy_talons.remains<=gcd
                if cast.able.deathStrike("target") and (buff.coagulopathy.remains() <= unit.gcd() or buff.icyTalons.remains() <= unit.gcd()) then
                    if cast.deathStrike("target") then debugMessage("DRW:Death Strike") return true; end;
                end

                --marrowrend,if=(buff.bone_shield.remains<=4|buff.bone_shield.stack<variable.bone_shield_refresh_value)&runic_power.deficit>20
                if cast.able.marrowrend("target") and 
                (buff.boneShield.remains() <=4 or buff.boneShield.stack() < var.boneShieldRefreshValue) and 
                var.runicPowerDeficit > 20 then
                    if cast.marrowrend("target") then debugMessage("DRW:O:Marrowrend") return true; end;
                end

                --soul_reaper,if=active_enemies=1&target.time_to_pct_35<5&target.time_to_die>(dot.soul_reaper.remains+5)
                if cast.able.soulReaper("target") and #enemies.yards5==1 and unit.ttd("target",35)<5 and
                    unit.ttd("target") > (debuff.soulReaper.remains("target")+5)
                 then
                    if cast.soulReaper("target") then debugMessage("DRW:P:Soul Reaper") return true; end;
                end

                --soul_reaper,target_if=min:dot.soul_reaper.remains,if=target.time_to_pct_35<5&active_enemies>=2&target.time_to_die>(dot.soul_reaper.remains+5)
                --TODO Needs Help
                if cast.able.soulReaper() then
                    for i=1, #enemies.yards5f do
                        if br.getHP(enemies.yards5f[i]) <= 35 then
                            if cast.soulReaper(enemies.yards5f[i]) then debugMessage("DRW:Soul Repear") return true; end;
                        end
                    end
                end

                --death_and_decay,if=!death_and_decay.ticking&(talent.sanguine_ground|talent.unholy_ground)
                if cast.able.deathAndDecay("playerGround") and not buff.deathAndDecay.exists() and (talent.sanguineGround or talent.unholyGround) and not unit.moving("player") then
                    if cast.deathAndDecay("playerGround") then debugMessage("DRW:Death and Decay") return true; end;
                end

                --blood_boil,if=spell_targets.blood_boil>2&charges_fractional>=1.1
                --TODO Fractional Charges
                if cast.able.bloodBoil() and (
                    #enemies.yards10 > 2 and
                    charges.bloodBoil.frac() >= 1.1   
                ) then
                    if cast.bloodBoil() then debugMessage("DRW:Blood Boil") return true; end;
                end

                --death_strike,if=runic_power.deficit<=variable.heart_strike_rp_drw|runic_power>=variable.death_strike_dump_amount
                if cast.able.deathStrike("target") and (var.runicPowerDeficit <= var.heartStrikeRpDrw or runicPower >= var.deathStrikeDumpAmount) then
                    if cast.deathStrike("target") then debugMessage("DRW:Q:death strike") return true; end;
                end

                if cast.able.consumption("target") then 
                    if cast.consumption("target") then debugMessage("DRW:Consumption") return true; end;
                end

                --blood_boil,if=charges_fractional>=1.1&buff.hemostasis.stack<5
                --TODO fractional charges
                if cast.able.bloodBoil() and (
                    charges.bloodBoil.frac() >= 1.1 and
                    buff.hemostasis.stack() < 5) then
                    if cast.bloodBoil() then debugMessage("DRW:R:Blood boil") return true; end;
                end

                --heart_strike,if=rune.time_to_2<gcd|runic_power.deficit>=variable.heart_strike_rp_drw
                --debugMessage("Heart Strike Check: TT2:" .. runeTimeUntil(2) .. " GCD:" .. unit.gcd() .. " Power Def:" .. var.runicPowerDeficit .. "HeartStrikeRP:" .. var.heartStrikeRp)
                if cast.able.heartStrike("target") and (runeTimeUntil(2) < unit.gcd() or var.runicPowerDeficit >= var.heartStrikeRpDrw) then
                    if cast.heartStrike("target") then debugMessage("DRW:S:Heart Strike") return true; end;
                end
                return false
end





local function runRotation() 

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
    use                                           = br.player.use
    var                                           = br.player.variables
    debuff                                        = br.player.debuff
    runes                                         = br.player.power.runes()
    runicPower                                    = br.player.power.runicPower()
    runicPowerMax                                 = UnitPowerMax("player",6)
    var.inRaid                                    = br.player.instance=="raid"
    var.inInstance                                = br.player.instance=="party"

    if var.lastCast == nil then var.lastCast=ui.time() end

    ui.mode.AutoPull        = br.data.settings[br.selectedSpec].toggles["Autopull"]
    ui.mode.CoolDowns       = br.data.settings[br.selectedSpec].toggles["Cooldown"]
    ui.mode.Rotation        = br.data.settings[br.selectedSpec].toggles["Rotation"]
    ui.mode.Debug           = br.data.settings[br.selectedSpec].toggles["Debugs"]

    units.get(5) 
    units.get(40) -- Makes a variable called, units.dyn40
    enemies.get(5) -- Makes a varaible called, enemies.yards5
    enemies.get(8)
    enemies.get(10)
    enemies.get(15)
    enemies.get(20)
    enemies.get(25)
    enemies.get(30)
    enemies.get(35)
    enemies.get(40) -- Makes a varaible called, enemies.yards40
    enemies.get(5,"player",false,true) -- makes enemies.yards5f
    enemies.get(10,"player",false, true)
    enemies.get(20,"player",false,true)
    enemies.get(30,"player",false,true)
    enemies.get(40,"player",false,true)

    ------------------------
    --- Custom Variables ---
    ------------------------

    --variable,name=bone_shield_refresh_value,value=4,op=setif,condition=!talent.deaths_caress.enabled|talent.consumption.enabled|talent.blooddrinker.enabled,value_else=5
    if not talent.deathsCaress or talent.consumption or talent.blooddrinker then
        var.boneShieldRefreshValue = 4
    else
        var.boneShieldRefreshValue = 5        
    end

     --variable,name=heart_strike_rp_drw,value=(25+spell_targets.heart_strike*talent.heartbreaker.enabled*2)
     var.heartStrikeRpDrw = (35 + (#enemies.yards5f * talent.rank.heartbreaker))
    
     ----variable,name=heart_strike_rp,value=(10+spell_targets.heart_strike*talent.heartbreaker.enabled*2)
     var.heartStrikeRp = (20 + (#enemies.yards5f * talent.rank.heartbreaker))
     var.runicPowerDeficit = runicPowerMax - runicPower
     var.deathStrikeDumpAmount = 65

    var.minTTD=99999
    var.minTTDUnit="target"
    for i=1,#enemies.yards5 do
        local thisUnit=enemies.yards5[i]
        local thisCondition=unit.ttd(thisUnit)
        if not unit.isBoss(thisUnit) and thisCondition<var.minTTD then
            var.minTTD=thisCondition
            var.minTTDUnit=thisUnit
        end
    end

    --Ghoul Totem
    local haveTotem, totemName, startTime, duration, icon = GetTotemInfo(1)
    var.hasGhoul = haveTotem
    var.ghoulTTL = 0
    if haveTotem and totemName ~= nil then
        var.ghoulTTL = startTime + duration - ui.time() + 1.2
    end

    --rune cooldown timing, why they gotta number them in reverse? i.e. rune[6] is the leftmost. rune[1] rightmost.  
    var.runeCount = 0
    var.runeCountCoolDown = 0
    var.runeCooldowns = {}
    
    for i=1,6 do
        local rStart, rDuration, rRuneReady = _G.GetRuneCooldown(i)
        if rRuneReady then 
            var.runeCount = var.runeCount + 1
        else
            var.runeCountCoolDown = var.runeCountCoolDown + 1
            table.insert(var.runeCooldowns,(rStart + rDuration) - ui.time())
        end
    end
    table.sort(var.runeCooldowns)
 
    -- Any other local varaible from above would also need to be defined here to be use.
    if var.profileStop == nil then var.profileStop = false end -- Trigger variable to help when needing to stop a profile.

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then -- Reset profile stop once stopped
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then -- If profile triggered to stop go here until it has.
        return true
    else -- Profile is free to perform actions
        --------------
        --- Extras ---
        --------------
        if actionList.Extra() then return true end -- This runs the Extra Action List and anything in it will run in or out of combat, this generally contains utility functions.
        if actionList.Defensive() then return true end -- This runs the Defensive Action List and anything in it will run in or out of combat, this generally contains defensive functions.
        if actionList.PreCombat() then return true end  -- This runs the Pre-Combat Action List and anything in it will run in or out of combat, this generally includes functions that prepare for or start combat.
         if unit.inCombat() and unit.valid("target") and not var.profileStop then -- Everything below this line only run if you are in combat and the selected target is validated and not triggered to stop.
            if actionList.Interrupt() then return true end
            if actionList.InstanceActions() then return true end
            if actionList.Aggro() then return true end
            if actionList.Cooldown() then return true end
 

            

            --icebound_fortitude,if=!(buff.dancing_rune_weapon.up|buff.vampiric_blood.up)
            --&(target.cooldown.pause_action.remains>=8|target.cooldown.pause_action.duration>0)

            if cast.able.iceboundFortitude() and (
                not (buff.dancingRuneWeapon.exists() or buff.vampiricBlood.exists()) 
            ) then
                if cast.iceboundFortitude() then debugMessage("C:Icebound fortitude") return true; end;
            end

            --vampiric_blood,if=!buff.vampiric_blood.up&!buff.vampiric_strength.up

            if cast.able.vampiricBlood() and (not buff.vampiricBlood.exists() and not buff.vampiricStrength.exists()) then
                if cast.vampiricBlood() then debugMessage("D:Vampiric Blood") return true; end;
            end
            --=/vampiric_blood,if=!(buff.dancing_rune_weapon.up|buff.icebound_fortitude.up|buff.vampiric_blood.up|buff.vampiric_strength.up)&(target.cooldown.pause_action.remains>=13|target.cooldown.pause_action.duration>0)
            if cast.able.vampiricBlood() and (
                not(buff.dancingRuneWeapon.exists() or buff.iceboundFortitude.exists(0 or buff.vampiricBlood.exists() or buff.vampiricStrength.exists()))
            ) then
                if cast.vampiricBlood() then debugMessage("D1:Vampiric Blood") return true; end;
            end

            --deaths_caress,if=!buff.bone_shield.up

            if not buff.boneShield.exists() and cast.able.deathsCaress("target") then
                if cast.deathsCaress("target") then debugMessage("E:Deaths Caress") return true; end;
            end

            --death_and_decay,if=!death_and_decay.ticking&(talent.unholy_ground|talent.sanguine_ground|spell_targets.death_and_decay>3|buff.crimson_scourge.up)
 
            if not buff.deathAndDecay.exists("player") and not unit.moving("player") and 
                 cast.able.deathAndDecay("playerGround") then
                    if cast.deathAndDecay("playerGround") then debugMessage("F:Death and Decay") return true; end;
            end

            --death_strike,if=buff.coagulopathy.remains<=gcd|buff.icy_talons.remains<=gcd
            --|runic_power>=variable.death_strike_dump_amount|runic_power.deficit<=variable.heart_strike_rp|target.time_to_die<10

            if cast.able.deathStrike("target") and
                (
                    buff.coagulopathy.remains() <= unit.gcd() or
                    buff.icyTalons.remains() <= unit.gcd() or
                    runicPower >= var.deathStrikeDumpAmount or
                    var.runicPowerDeficit <= var.heartStrikeRp or
                    unit.ttd("target") < 10
                ) then
                    if cast.deathStrike("target") then debugMessage("G:Death Strike") return true; end;
            end

            --	blooddrinker,if=!buff.dancing_rune_weapon.up
     
            if not buff.dancingRuneWeapon.exists() and cast.able.blooddrinker("target") then
                if cast.blooddrinker("target") then debugMessage("Blooddrinker channel") return true; end
            end
         
            --sacrificial_pact,if=!buff.dancing_rune_weapon.up&(pet.ghoul.remains<2|target.time_to_die<gcd)
           
            if talent.sacrificialPact and 
                not buff.dancingRuneWeapon.exists("player")  and 
                (var.hasGhoul and var.ghoulTTL < 2 or unit.ttd("target") < unit.gcd() ) and 
                cast.able.sacrificialPact()  then
                    if cast.sacrificialPact() then debugMessage("Sacrificial Pact") return true; end;
            end

          
            --blood_tap,if=(rune<=2&rune.time_to_4>gcd&charges_fractional>=1.8)|rune.time_to_3>gcd
            if (runes <= 2 and runeTimeUntil(4) > unit.gcd() and charges.bloodTap.frac() >= 1.8 ) or runeTimeUntil(3) > unit.gcd() then
                if cast.able.bloodTap() then
                    if cast.bloodTap() then debugMessage("I:Blood Tap") return true; end;
                end
            end

           
            --gorefiends_grasp,if=talent.tightening_grasp.enabled
            if talent.tighteningGrasp and cast.able.gorefiendsGrasp("target") then
                if cast.gorefiendsGrasp("target") then debugMessage("GoreFiends Grasp") return true; end;
            end

          
            if cast.able.abominationLimb() then
                if cast.abominationLimb() then debugMessage("Abomination Limb") return true; end;
            end

             --DRW sub Routine
            if buff.dancingRuneWeapon.exists() then
                if actionList.DRWActive() then return true end
            end
  

            --Add Death Strike to build RP 
            if cast.able.heartStrike("target") and runes > 4 and var.runicPowerDeficit >= var.heartStrikeRp then
                if cast.heartStrike("target") then debugMessage("Special Heart Strike") return true end
            end

            --tombstone,if=buff.bone_shield.stack>5&rune>=2&runic_power.deficit>=30&!talent.shattering_bone|(talent.shattering_bone.enabled&death_and_decay.ticking)
            --&cooldown.dancing_rune_weapon.remains>=25
        
            if cast.able.tombstone() and (
                buff.boneShield.stack() > 5 and runes >= 2 and var.runicPowerDeficit >= 30 and 
                (not talent.shatteringBone or (talent.shatteringBone and buff.deathAndDecay.exists())) and
                cd.dancingRuneWeapon.remains() >= 25) then
                    if cast.tombstone() then debugMessage("Tombstone") return true; end;
            end
            
            --death_strike,if=buff.coagulopathy.remains<=gcd|buff.icy_talons.remains<=gcd|runic_power>=variable.death_strike_dump_amount|runic_power.deficit<=variable.heart_strike_rp|target.time_to_die<10
          
            if cast.able.deathStrike("target") and (
                buff.coagulopathy.remains() <= unit.gcd() or
                buff.icyTalons.remains() <= unit.gcd() or
                runicPower >= var.deathStrikeDumpAmount or
                var.runicPowerDeficit <= var.heartStrikeRp or
                unit.ttd("target") < 10
            ) then
                if cast.deathStrike("target") then debugMessage("Death Strike") return true; end;
            end

            --deaths_caress,if=(buff.bone_shield.remains<=4|(buff.bone_shield.stack<variable.bone_shield_refresh_value+1))&runic_power.deficit>10&
            --!(talent.insatiable_blade&cooldown.dancing_rune_weapon.remains<buff.bone_shield.remains)&
            --!talent.consumption.enabled&!talent.blooddrinker.enabled&rune.time_to_3>gcd
           
            if cast.able.deathsCaress("target") and (
                (buff.boneShield.remains() <= 4 or (buff.boneShield.stack() < var.boneShieldRefreshValue+1)) and 
                var.runicPowerDeficit > 10 and
                not (talent.insatiableBlade and cd.dancingRuneWeapon.remains() < buff.boneShield.remains()) and
                not talent.cosumption and not talent.blooddrinker and runeTimeUntil(3) > unit.gcd()
                ) then
                    if cast.deathsCaress("target") then debugMessage("T:deaths Caress") return true; end;
            end

            --marrowrend,if=(buff.bone_shield.remains<=4|buff.bone_shield.stack<variable.bone_shield_refresh_value)&
            --runic_power.deficit>20&!(talent.insatiable_blade&cooldown.dancing_rune_weapon.remains<buff.bone_shield.remains)
            
            if cast.able.marrowrend("target") and (
                (buff.boneShield.remains() <= 4 or buff.boneShield.stack() < var.boneShieldRefreshValue) and
                var.runicPowerDeficit >20 and 
                not (talent.insatiableBlade and cd.dancingRuneWeapon.remains() < buff.boneShield.remains()) 
            ) then
                if cast.marrowrend("target") then debugMessage("U: Marrowrend") return true; end;
            end

            --consumption
            if cast.able.consumption() then
                if cast.consumption() then debugMessage("Consumption") return true; end;
            end

            --soul_reaper,if=active_enemies=1&target.time_to_pct_35<5&target.time_to_die>(dot.soul_reaper.remains+5)
            --soul_reaper,target_if=min:dot.soul_reaper.remains,if=target.time_to_pct_35<5&active_enemies>=2&target.time_to_die>(dot.soul_reaper.remains+5)
            -- Look for target to hit with soul reaper
            
            for i=1,#enemies.yards5f do
                local thisUnit = enemies.yards5f[i]
                if unit.ttd(thisUnit,35) < 5 and unit.ttd(thisUnit) > (debuff.soulReaper.remains()+5) then
                    if cast.able.soulReaper(thisUnit) then
                        if cast.soulReaper(thisUnit) then debugMessage("V: SoulReaper") return true; end;
                    end
                end
            end

            --bonestorm,if=runic_power>=100
            
            if cast.able.bonestorm() and runicPower >= 100 then
                if cast.bonestorm() then debugMessage("bonestorm") return true; end;
            end

            --blood_boil,if=charges_fractional>=1.8&(buff.hemostasis.stack<=(5-spell_targets.blood_boil)|spell_targets.blood_boil>2)
            
            if cast.able.bloodBoil() and (
                charges.bloodBoil.frac() > 1.8 and (buff.hemostasis.stack() <= (5-#enemies.yards10) or #enemies.yards10 > 2)
            ) then
                if cast.bloodBoil() then debugMessage("W:Blood Boil") return true; end;
            end

            --heart_strike,if=rune.time_to_4<gcd
            
            if cast.able.heartStrike("target") and runeTimeUntil(4) < unit.gcd() then
                if cast.heartStrike("target") then debugMessage("X: Heart Strike") return true; end;
            end

            --blood_boil,if=charges_fractional>=1.1
            
            if cast.able.bloodBoil() then
                if cast.bloodBoil() then 
                    var.doTiming = true;
                    debugMessage("Y: Blood Boil") 
                    return true; end;
            end

            --heart_strike,if=(rune>1&(rune.time_to_3<gcd|buff.bone_shield.stack>7))
            
            if cast.able.heartStrike("target") and (
                runes > 1 --and (runeTimeUntil(3) < unit.gcd() or buff.boneShield.stack() > 7)
            ) then
                if cast.heartStrike("target") then debugMessage("Z: Heart Strike") return true; end
            end
            if cast.able.autoAttack("target") then
                if cast.autoAttack("target") then debugMessage("8: Auto Attack") return true end
            end
            checkTiming("EOR")
            -- if var.lastCast -ui.time() >= 2 then
            --         debugMessage(colors.red "No viable Action, Waiting")
            -- end                
        end -- End In Combat Rotation
    end -- Pause
end -- End runRotation
local id = 250 
-- DO NOT EDIT ANYTHING BELOW THIS LINE, WILL BREAK PROFILE --
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})