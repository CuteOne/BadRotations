-------------------------------------------------------
-- Author = BrewingCoder
-- Patch = 10.2.6
-- Coverage = 50%
-- Status = Development
-- Readiness = Development
-------------------------------------------------------
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
        [3] = { mode = "3", value = 3 , overlay = "Felhunter", tip = "Summon Felhunter", highlight = 1, icon = br.player.spell.summonFelhunter },
        [4] = { mode = "4", value = 4 , overlay = "Sayaad", tip = "Summon Sayaad", highlight = 1, icon = br.player.spell.summonSuccubus },
        [5] = { mode = "5", value = 5 , overlay = "Felguard", tip = "Summon Felguard", highlight = 1, icon = br.player.spell.summonFelguard},
        [6] = { mode = "6", value = 6 , overlay = "None", tip = "Do Not Summon", highlight = 0, icon = br.player.spell.fear}
    }
    br.ui:createToggle(PetSummonModes,"PetSummon",3,0)
end

local function PetId()
    if br._G.UnitExists("pet") then
        return tonumber(br._G.UnitGUID("pet"):match("-(%d+)-%x+$",10))
    else
        return nil
    end


local pets = {
    imp = 416,
    voidwalker = 1860,
    felhunter = 417,
    succubus = 1863,
    felguard = 17252    
}


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
        and br._G.GetTime() - br.pauseTime > 0.5 
        and br.timer:useTimer("summonPet", 1) then
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
        br._G.PetAttack()
    end
end

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