local rotationName = "BrewDemon"

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

local function toggles()
    br.ui:toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "unendingResolve", overlay = "Rotation Enabled", tip = "Enable Rotation" },
        { name = "Off", icon = "unendingResolve", overlay = "Rotation Disabled", tip = "Disable Rotation" },
    } })
    br.ui:toggle("Defensive", { modes = {
        { name = "On", icon = "unendingResolve", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "unendingResolve", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    br.ui:toggle("PetSummon", { modes = {
        { name = "1", icon = "summonImp", overlay = "Imp", tip = "Summon Imp" },
        { name = "2", icon = "summonVoidwalker", overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = true },
        { name = "3", icon = "summonFelhunter", overlay = "Felhunter", tip = "Summon Felhunter", highlight = true },
        { name = "4", icon = "summonSuccubus", overlay = "Sayaad", tip = "Summon Sayaad", highlight = true },
        { name = "5", icon = "summonFelguard", overlay = "Felguard", tip = "Summon Felguard", highlight = true },
        { name = "6", icon = "fear", overlay = "None", tip = "Do Not Summon" },
    } })
end

local function PetId()
    if br._G.UnitExists("pet") then
        return tonumber(br._G.UnitGUID("pet"):match("-(%d+)-%x+$",10))
    else
        return nil
    end
end

local pets = {
    imp = 416,
    voidwalker = 1860,
    felhunter = 417,
    succubus = 1863,
    felguard = 17252
}


local function options()
    local section
    -----------------------
    --- GENERAL OPTIONS ---
    -----------------------
    section = br.ui:section("General")
        -- Corruption
        br.ui:checkbox(section, "Use Corruption")
        -- Curse of Weakness
        br.ui:checkbox(section, "Use Curse of Weakness")
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = br.ui:section("Defensive")
        -- Drain Life
        br.ui:spinner(section, "Drain Life", { value = 40, tip = "Pet Health Percent to Cast At" })
        -- Health Funnel
        br.ui:spinner(section, "Health Funnel", { value = 30, max = 95, tip = "Pet Health Percent to Cast At" })
        br.ui:spinner(section, "Player Limit", { value = 70, checkbox = false, tip = "Health Percent to not use below." })
        -- Healthstone
        br.ui:spinner(section, "Healthstone", { value = 60, max = 95, tip = "Health Percent to Cast At" })
        -- Unending Resolve
        br.ui:spinner(section, "Unending Resolve", { value = 50, tip = "Health Percent to Cast At" })
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
local activePet
local dynamic


local function round(number, digit_position)
    local precision = math.pow(10, digit_position)
    number = number + (precision / 2); -- this causes value #.5 and up to round up
    return math.floor(number / precision) * precision
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
    if not unit.moving() and unit.level() >= 3
        and br._G.GetTime() - br.pauseTime > 0.5
        and br.debug.timer:useTimer("summonPet", 1) then
        if mode.petSummon == 1 and activePet ~= pets.imp and cast.able.summonImp() and not cast.last.summonImp() then
            if cast.summonImp("player") then return true end
        end
        if mode.petSummon == 2 and activePet ~= pets.voidwalker and cast.able.summonVoidwalker() and not cast.last.summonVoidwalker(1) then
            if cast.summonVoidwalker("player") then return true end
        end
        if mode.petSummon == 3 and activePet ~= pets.felhunter and cast.able.summonFelhunter() and not cast.last.summonFelguard(1) then
            if cast.summonFelhunter("player") then return true end
        end
        if mode.petSummon == 4 and activePet ~= pets.succubus and cast.able.summonSuccubus() and not cast.last.summonSuccubus(1) then
            if cast.summonSuccubus("player") then return true end
        end
        if mode.petSummon == 5 and activePet ~= pets.felguard and cast.able.summonFelguard() and not cast.last.summonFelguard(1) then
            if cast.summonFelguard("player") then return true end
        end
    end

    -- if unit.inCombat() and unit.valid("target") and not var.profileStop then
    if not unit.inCombat() and  unit.valid("target") and unit.distance("target") <= 40 then
        if cast.able.curseOfExhaustion("target") and not debuff.curseOfExhaustion.exists("target") then
            if cast.curseOfExhaustion("target") then ui.debug("Casting Curse of Exhaustion") return true end
        end
    end
end

actionList.CoolDown = function()
    if  cast.able.callDreadstalkers() then
        if cast.callDreadstalkers("target") then ui.debug("Casting Call Dreadstalkers") return true end
    end
    if power == 5 and cast.able.handOfGuldan() then
        if cast.handOfGuldan("target") then ui.debug("Casting Hand of Guldan") return true end
    end

    if activePet == pets.felguard and cast.able.demonicStrength() then
        if cast.demonicStrength("pet") then ui.debug("Casting Demonic Strength") return true end
    end

    if cast.able.powerSiphon("target") then
        if cast.powerSiphon("target") then ui.debug("Casting Power Siphon") return true end
    end

    if cast.able.grimoireFelguard() then
        if cast.grimoireFelguard() then ui.debug("Casting Grimoire Felguard") return true end
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
    spell                                         = br.player.spells
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    power                                         = br.player.power.soulShards()
    var                                           = br.player.variables
    equiped                                       = br.player.equiped
    enemies                                       = br.player.enemies
    var.inRaid                                    = br.player.unit.instance()=="raid"
    var.inInstance                                = br.player.unit.instance()=="party"
    activePet                                     = PetId()

    var.demonicTyrant = false
    var.demonicTyrantRemains = 0

    -- Units
    units.get(5)
    units.get(40)
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemies.get(15)
    enemies.get(20)
    enemies.get(25)
    enemies.get(30)
    enemies.get(35)
    enemies.get(40)
    enemies.get(5,"player",false,true)
    enemies.get(10,"player",false, true)
    enemies.get(20,"player",false,true)
    enemies.get(30,"player",false,true)
    enemies.get(40,"player",false,true)

    dynamic       = {
        range5          = br.player.units.get(5),
        range40         = br.player.units.get(40)
    }

    var.UnitNeedsCurse = nil
    for i=1,#enemies.yards40f do
        if not debuff.curseOfExhaustion.exists(enemies.yards40f[i]) and br._G.UnitAffectingCombat(enemies.yards40f[i]) then
            var.UnitNeedsCurse = enemies.yards40f[i]
        end
    end

    var.impCount = 0
    var.wildImpCount = 0
    var.BossImpCount = 0
    for i=1,br._G.GetObjectCount() do
        local objFound = br._G.GetObjectWithIndex(i)
        if objFound ~= nil then
        local creator = br._G.UnitCreator(objFound)
        local objType = br._G.ObjectType(objFound)
        local objName = br._G.ObjectName(objFound)
            if objName == "Wild Imp" then
                var.impCount = var.impCount + 1
                var.wildImpCount = var.wildImpCount + 1
            end
            if objName =="Imp Gang Boss" then
                var.ImpCount = var.ImpCount + 1
                var.BossImpCount = var.BossImpCount + 1
            end
        end
    end

    --Simulationcraft Variables
    --actions.precombat+=/variable,name=tyrant_prep_start,op=set,value=12
    var.tyrant_prep_start = 12
    --actions.precombat+=/variable,name=next_tyrant,op=set,value=14+talent.grimoire_felguard+talent.summon_vilefiend
    var.next_tyrant = 14 + boolNumeric(talent.grimoireFelguard) + boolNumeric(talent.summonVilefiend)
    --actions.precombat+=/variable,name=shadow_timings,default=0,op=reset
    var.shadow_timings = 0
    --actions.precombat+=/variable,name=tyrant_timings,value=0
    var.tyrant_timings = 0
    --actions.precombat+=/variable,name=shadow_timings,op=set,value=0,if=cooldown.invoke_power_infusion_0.duration!=120
    if cd.invokePowerInfusion.duration ~= 120 then
        var.shadow_timings = 0
    end



    -- Pause Timer
    if br.pauseTime == nil then br.pauseTime = br._G.GetTime() end

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

            --Exhaustion
            if var.UnitNeedsCurse ~= nil and cast.able.curseOfExhaustion(var.UnitNeedsCurse) then
                if cast.curseOfExhaustion(var.UnitNeedsCurse) then ui.debug("Casting Curse of Exhaustion") return true end
            end
            if cast.able.curseOfExhaustion("target") and (not debuff.curseOfExhaustion.exists("target") or debuff.curseOfExhaustion.remains("target") < 2) then
                if cast.curseOfExhaustion("target") then ui.debug("Casting Curse of Exhaustion") return true end
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
br.loader.registerRotation({
    name      = rotationName,
    specID    = 266, -- Demonology Warlock
    expansion = "MOP",
    author    = "BrewingCoder",
    patch     = "10.2.6",
    coverage  = "50%",
    status    = "Development",
    readiness = "Development",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
