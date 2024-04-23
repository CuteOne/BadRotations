local rotationName = "BrewDestro"
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

local function createToggles()
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.unendingResolve },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.unendingResolve }
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)

    local AOEMode

    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.unendingResolve},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.unendingResolve}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    local PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Imp", tip = "Summon Imp", highlight = 1, icon = br.player.spell.summonImp },
        [2] = { mode = "2", value = 2 ,overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = 1, icon = br.player.spell.summonVoidwalker },
        [3] = { mode = "None", value = 3 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.fear }
    };
    br.ui:createToggle(PetSummonModes,"PetSummon",3,0)
end


local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Corruption
            br.ui:createCheckbox(section, "Use Corruption")
            -- Curse of Weakness
            br.ui:createCheckbox(section, "Use Curse of Weakness")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Drain Life
            br.ui:createSpinner(section, "Drain Life", 40, 0, 100, 5, "|cffFFFFFFPet Health Percent to Cast At")
            -- Health Funnel
            br.ui:createSpinner(section, "Health Funnel", 30, 0, 95, 5, "|cffFFFFFFPet Health Percent to Cast At")
            br.ui:createSpinnerWithout(section, "Player Limit", 70, 0, 100, 5, "|cffFFFFFFHealth Percent to not use below.")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  95,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Unending Resolve
            br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
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


local cast
local cd
local debuff
local has
local mode
local ui
local pet
local spell
local unit
local units
local use
local power
local buff
local var
local equiped
local enemies
local talent
local actionList = {}

local function round(number, digit_position) 
    local precision = math.pow(10, digit_position)
    number = number + (precision / 2); -- this causes value #.5 and up to round up
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
local function boolNumeric(value)
    if value then return 1 end
    return 0
end

actionList.Defensive = function()
    if cast.able.drainLife(units.dyn40) and unit.hp() <= ui.value("Drain Life") and unit.inCombat() then
        if cast.drainLife() then ui.debug("Channeling Drain Life") return true end
    end
    -- Health Funnel
    if cast.able.healthFunnel() and unit.hp("pet") <= ui.value("Health Funnel") and unit.hp("player") > ui.value("Player Limit") then
        if cast.healthFunnel("pet") then ui.debug("Channeling Health Funnel") return true end
    end
    -- Healthstone
    if ui.checked("Healthstone") then
        if use.able.healthstone() and unit.inCombat() and has.healthstone() and unit.hp() <= ui.value("Healthstone") then
            if use.healthstone() then ui.debug("Using Healthstone") return true end
        end
        if cast.able.createHealthstone() and not has.healthstone() and not ui.fullBags() then
            if cast.createHealthstone() then ui.debug("Casting Create Healthstone") return true end
        end
    end
    -- Unending Resolve
    if ui.checked("Unending Resolve") and unit.hp() <= ui.value("Unending Resolve") and unit.inCombat() then
        if cast.unendingResolve() then ui.debug("Casting Unending Resolve") return true end
    end

end -- End Action List - Defensive

actionList.Variable = function()
    --variable,name=tyrant_timings,op=set,value=120+time,if=((buff.nether_portal.up&buff.nether_portal.remains<3&talent.nether_portal)
    --|fight_remains<20|pet.demonic_tyrant.active&fight_remains<100|fight_remains<25|    
    --(pet.demonic_tyrant.active|!talent.summon_demonic_tyrant&buff.dreadstalkers.up))&variable.tyrant_sync<=0
    if (
        (buff.netherPortal.exists() and buff.netherPortal.remain() < 3 and talent.netherPortal) or 
        unit.ttdGroup(40)<20 or var.demonicTyrant or unit.ttdGroup(40)<100 or unit.ttdGroup(40)<25 or
        (var.demonicTyrant or not talent.summonDemonicTyrant and buff.dreadstalkers.exists())) and var.tyrant_sync <= 0 then
            var.tyrant_timings = 120 + unit.combatTime()
    end

    --actions.variables+=/variable,name=tyrant_sync,value=(variable.tyrant_timings-time)
    var.tyrant_sync = var.tyrant_timings - unit.combatTime()

    --actions.variables+=/variable,name=tyrant_cd,op=setif,value=variable.tyrant_sync,
    --value_else=cooldown.summon_demonic_tyrant.remains,
    --condition=((((fight_remains+time)%%120<=85&(fight_remains+time)%%120>=25)|time>=210))&variable.tyrant_sync>0&!talent.grand_warlocks_design
    if (
        ((unit.ttdGroup(40) + unit.combatTime()) % 120 <= 85 and (unit.ttdGroup(40) + unit.combatTime()) % 120 >= 25 or unit.combatTime() >= 210) and 
        var.tyrant_sync > 0 and not talent.grandWarlocksDesign
    ) then
        var.tyrant_cd = var.tyrant_sync
    else
        var.tyrant_cd = cd.summonDemonicTyrant.remains()
    end

    --actions.variables+=/variable,name=pet_expire,op=set,
    --value=(buff.dreadstalkers.remains>?buff.vilefiend.remains)-gcd*0.5,
    --if=buff.vilefiend.up&buff.dreadstalkers.up
    if buff.vilefiend.exists() and buff.dreadstalkers.exists() then
        var.pet_expire = (buff.dreadstalkers.remains() > buff.vilefiend.remain()) - unit.gcd()*0.5
    end

    --actions.variables+=/variable,name=pet_expire,op=set,
    --value=(buff.dreadstalkers.remains>?buff.grimoire_felguard.remains)-gcd*0.5,
    --if=!talent.summon_vilefiend&talent.grimoire_felguard&buff.dreadstalkers.up
    if not talent.summonVilefiend and talent.grimoireFelguard and buff.dreadstalkers.exists() then
        var.pet_expire = (buff.dreadstalkers.remains() > buff.grimoireFelguard.remain()) - unit.gcd()*0.5
    end

    --actions.variables+=/variable,name=pet_expire,op=set,
    --value=(buff.dreadstalkers.remains)-gcd*0.5,
    --if=!talent.summon_vilefiend&(!talent.grimoire_felguard|!set_bonus.tier30_2pc)&buff.dreadstalkers.up
    if not talent.summonVilefiend and (not talent.grimoireFelguard or not equiped.tier(30,2)) and buff.dreadstalkers.exists() then
        var.pet_expire = buff.dreadstalkers.remains() - unit.gcd()*0.5
    end

    --actions.variables+=/variable,name=pet_expire,op=set,value=0,if=!buff.vilefiend.up&talent.summon_vilefiend|!buff.dreadstalkers.up
    if not buff.vilefiend.exists() and talent.summonVilefiend or not buff.dreadstalkers.exists() then
        var.pet_expire = 0
    end

    --actions.variables+=/variable,name=np,op=set,value=(!talent.nether_portal|cooldown.nether_portal.remains>30|buff.nether_portal.up)
    var.np = (not talent.netherPortal or cd.netherPortal.remains() > 30 or buff.netherPortal.exists())

    --actions.variables+=/variable,name=impl,op=set,value=buff.tyrant.down,if=active_enemies>1+(talent.sacrificed_souls.enabled)
    if #enemies.yards40 > 1 + boolNumeric(talent.sacrificedSouls) then
        var.impl = not buff.tyrant.exists()
    end

    --actions.variables+=/variable,name=impl,op=set,value=buff.tyrant.remains<6,
    --if=active_enemies>2+(talent.sacrificed_souls.enabled)&active_enemies<5+(talent.sacrificed_souls.enabled)
    if #enemies.yards40 > 2 + boolNumeric(talent.sacrificedSouls) and #enemies.yards40 < 5 + boolNumeric(talent.sacrificedSouls) then
        var.impl = buff.tyrant.remain() < 6
    end

    --actions.variables+=/variable,name=impl,op=set,value=buff.tyrant.remains<8,if=active_enemies>4+(talent.sacrificed_souls.enabled)
    if #enemies.yards40 > 4 + boolNumeric(talent.sacrificedSouls) then
        var.impl = buff.tyrant.remain() < 8
    end

    --actions.variables+=/variable,name=pool_cores_for_tyrant,op=set,
    --value=cooldown.summon_demonic_tyrant.remains<20&variable.tyrant_cd<20&(buff.demonic_core.stack<=2|!buff.demonic_core.up)
    --&cooldown.summon_vilefiend.remains<gcd.max*5&cooldown.call_dreadstalkers.remains<gcd.max*5
    var.pool_cores_for_tyrant = cd.summonDemonicTyrant.remains() < 20 and var.tyrant_cd < 20 and (buff.demonicCore.stack() <= 2 or not buff.demonicCore.exists()) 
    and cd.summonVilefiend.remains() < unit.gcd(true)*5 and cd.callDreadstalkers.remains() < unit.gcd(true)*5

end

actionList.Extra = function()
    if cast.able.createHealthstone() and not has.healthstone() and not ui.fullBags() then
        if cast.createHealthstone() then ui.debug("Casting Create Healthstone") return true end
    end    
end

actionList.Interrupt = function()
    -- if cast.able.fear("target") and unit.interrupt(40, "target", false) then
    --     if cast.fear("target") then ui.debug("Casting Fear") return true end
    -- end
end





actionList.PreCombat = function()
    if not unit.moving() and unit.level() >= 3 and GetTime() - br.pauseTime > 0.5
        and br.timer:useTimer("summonPet", 1)
    then
        if (mode.petSummon == 1 or (mode.petSummon == 2 and not spell.known.summonVoidwalker())) and not UnitExists("pet") then
            if cast.summonImp("player") then return true end
        end
        if mode.petSummon == 2 and spell.known.summonVoidwalker() and not UnitExists("pet") then
            if cast.summonVoidwalker("player") then return true end
        end
        if mode.petSummon == 3 and (UnitExists("pet")) then
            PetDismiss()
        end
    end
    -- if unit.inCombat() and unit.valid("target") and not var.profileStop then 
    if not unit.inCombat() and  unit.valid("target") and unit.distance("target") <= 40 then
        br._G.PetAttack()
    end
end -- End Action List - PreCombat

actionList.CoolDown = function()
    if  cast.able.callDreadstalkers() then
        if cast.callDreadstalkers("target") then ui.debug("Casting Call Dreadstalkers") return true end
    end
    if power == 5 and cast.able.handOfGuldan() then
        if cast.handOfGuldan("target") then ui.debug("Casting Hand of Guldan") return true end
    end    
end

local function runRotation()
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    debuff                                        = br.player.debuff
    buff                                          = br.player.buff
    has                                           = br.player.has
    mode                                          = br.player.ui.mode
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    pet                                           = br.player.pet
    spell                                         = br.player.spell
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    power                                         = br.player.power.soulShards()
    var                                           = br.player.variables
    equiped                                       = br.player.equiped
    enemies                                       = br.player.enemies
    var.inRaid                                    = br.player.instance=="raid"
    var.inInstance                                = br.player.instance=="party"

    var.demonicTyrant = false
    var.demonicTyrantRemains = 0

    -- Units
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

    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = GetTime() end

    if not unit.inCombat() and not unit.exists("target") and var.profileStop then 
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or ui.mode.rotation == 4 then 
        return true
    else 
        if actionList.Extra() then return true end
        if actionList.Defensive() then return true end
        if actionList.PreCombat() then return true end
        if unit.inCombat() and unit.valid("target") and not var.profileStop then
            if actionList.Interrupt() then return true end
            if actionList.CoolDown() then return true end
            



                
                -- if cast.able.corruption() and not debuff.corruption.exists("target") and not cast.last.corruption() then
                --     if cast.corruption("target") then ui.debug("Corruption") return true end
                -- end
                -- if cast.able.curseOfWeakness() and not debuff.curseOfWeakness.exists("target") and not cast.last.curseOfWeakness() then
                --     if cast.curseOfWeakness() then ui.debug("Casting Curse of Weakness") return true end
                -- end
                if power<5 and cast.able.soulStrike("target") then
                    if cast.soulStrike("target") then ui.debug("Casting Soul Strike") return true end
                end
                if cast.able.demonbolt() and buff.demonicCore.exists() then
                    if cast.demonbolt("target") then ui.debug("Casting Demonbolt") return true end
                end
                if cast.able.shadowBolt() and not unit.moving() then
                    if cast.shadowBolt() then ui.debug("Casting Shadow Bolt") return true end
                end
                if cast.able.implosion("target") and #enemies.yards40 >= 3 then
                    if cast.implosion("target") then ui.debug("Casting Implosion") return true end
                end
        end
    end
end 
local id = 266  -- Demonology Warlock
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})