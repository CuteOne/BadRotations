-- Editor types: the keys of Retail Warlock Affliction's spell lists (written by Types/generate.lua)
local buff = buff --[[@as BR.Retail.Warlock.Affliction.buff]]
local cast = cast --[[@as BR.Retail.Warlock.Affliction.cast]]
local cd = cd --[[@as BR.Retail.Warlock.Affliction.cd]]
local charges = charges --[[@as BR.Retail.Warlock.Affliction.charges]]
local debuff = debuff --[[@as BR.Retail.Warlock.Affliction.debuff]]
local equiped = equiped --[[@as BR.Retail.Warlock.Affliction.equiped]]
local glyph = glyph --[[@as BR.Retail.Warlock.Affliction.glyph]]
local has = has --[[@as BR.Retail.Warlock.Affliction.has]]
local heroTree = heroTree --[[@as BR.Retail.Warlock.Affliction.heroTree]]
local imbues = imbues --[[@as BR.Retail.Warlock.Affliction.imbues]]
local spell = spell --[[@as BR.Retail.Warlock.Affliction.spell]]
local talent = talent --[[@as BR.Retail.Warlock.Affliction.talent]]
local totem = totem --[[@as BR.Retail.Warlock.Affliction.totem]]
local use = use --[[@as BR.Retail.Warlock.Affliction.use]]

local rotationName = "BrewAffliction"

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
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "On", icon = "unendingResolve", overlay = "Rotation Enabled", tip = "Enable Rotation" },
        { name = "Off", icon = "unendingResolve", overlay = "Rotation Disabled", tip = "Disable Rotation" },
    } })
    ui.toggle("Defensive", { modes = {
        { name = "On", icon = "unendingResolve", overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns." },
        { name = "Off", icon = "unendingResolve", overlay = "Defensive Disabled", tip = "No Defensives will be used." },
    } })
    ui.toggle("PetSummon", { modes = {
        { name = "1", icon = "summonImp", overlay = "Imp", tip = "Summon Imp" },
        { name = "2", icon = "summonVoidwalker", overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = true },
        { name = "3", icon = "summonFelhunter", overlay = "Felhunter", tip = "Summon Felhunter", highlight = true },
        { name = "4", icon = "summonSuccubus", overlay = "Sayaad", tip = "Summon Sayaad", highlight = true },
        { name = "5", icon = "summonFelguard", overlay = "Felguard", tip = "Summon Felguard", highlight = true },
        { name = "6", icon = "fear", overlay = "None", tip = "Do Not Summon" },
    } })
end

local function PetId()
    if unit.exists("pet") then
        return tonumber(unit.guid("pet"):match("-(%d+)-%x+$",10))
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
    section = ui.section("General")
        -- Corruption
        ui.checkbox(section, "Use Corruption")
        -- Curse of Weakness
        ui.checkbox(section, "Use Curse of Weakness")
    -------------------------
    --- DEFENSIVE OPTIONS ---
    -------------------------
    section = ui.section("Defensive")
        -- Drain Life
        ui.spinner(section, "Drain Life", { value = 40, tip = "Pet Health Percent to Cast At" })
        -- Health Funnel
        ui.spinner(section, "Health Funnel", { value = 30, max = 95, tip = "Pet Health Percent to Cast At" })
        ui.spinner(section, "Player Limit", { value = 70, checkbox = false, tip = "Health Percent to not use below." })
        -- Healthstone
        ui.spinner(section, "Healthstone", { value = 60, max = 95, tip = "Health Percent to Cast At" })
        -- Unending Resolve
        ui.spinner(section, "Unending Resolve", { value = 50, tip = "Health Percent to Cast At" })
end

local mode
local actionList = {}
local activePet


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
        and ui.time() - var.pauseTime > 0.5
        and ui.timer("summonPet", 1) then
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
        if cast.able.agony("target") and not debuff.agony.exists("target") then
            if cast.agony("target") then ui.debug("[PreCombat] Agony") return true end
        end
    end
end

actionList.CoolDown = function()



end

local function runRotation()
    mode                                          = ui.mode
    var.inRaid                                    = unit.instance()=="raid"
    var.inInstance                                = unit.instance()=="party"
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

    var.UnitNeedsAgony = nil
    var.AgonyCount = 0
    for i=1,#enemies.yards40f do
        if not debuff.agony.exists(enemies.yards40f[i]) and unit.inCombat(enemies.yards40f[i]) then
            var.UnitNeedsAgony = enemies.yards40f[i]
        else
            var.AgonyCount = var.AgonyCount + 1
        end
    end
    var.UnitsNeedCorruption = nil
    var.CorruptionCount = 0
    for i=1,#enemies.yards40f do
        if not debuff.corruption.exists(enemies.yards40f[i]) and unit.inCombat(enemies.yards40f[i]) then
            var.UnitsNeedCorruption = enemies.yards40f[i]
        else
            var.CorruptionCount = var.CorruptionCount + 1
        end
    end


    -- Pause Timer
    if var.pauseTime == nil then var.pauseTime = ui.time() end

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

            if cast.able.agony("target") and not debuff.agony.exists("target") then
                if cast.agony("target") then ui.debug("Casting Agony") return true end
            end

            if var.UnitNeedsAgony ~= nil and cast.able.agony(var.UnitNeedsAgony) then
                if cast.agony(var.UnitNeedsAgony) then ui.debug("Casting Agony") return true end
            end

            if cast.able.corruption("target") and not debuff.corruption.exists("target") then
                if cast.corruption("target") then ui.debug("Casting Corruption") return true end
            end
            if var.UnitsNeedCorruption ~= nil and cast.able.corruption(var.UnitsNeedCorruption) then
                if cast.corruption(var.UnitsNeedCorruption) then ui.debug("Casting Corruption") return true end
            end

            if cast.able.maleficRapture() then
                print("Corruption Count: "..var.CorruptionCount)
                print("Agony Count: "..var.AgonyCount)
                print("Enemies in 40 yards: "..#enemies.yards40f)
            end

            if cast.able.maleficRapture() and var.CorruptionCount == #enemies.yards40f and var.AgonyCount == #enemies.yards40f and not cast.last.maleficRapture() then
                if cast.maleficRapture() then ui.debug("Casting Malefic Rapture") return true end
            end



        end
    end
end
registerRotation({
    name      = rotationName,
    specID    = 265, -- Affliction Warlock
    expansion = "Retail",
    author    = "BrewingCoder",
    patch     = "10.2.6",
    coverage  = "50%",
    status    = "Development",
    readiness = "Development",
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
