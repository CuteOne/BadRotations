local br = _G["br"]
local rotationName = "Initial"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enables Rotation", highlight = 1, icon = br.player.spell.crusaderStrike},
        [2] = { mode = "Off", value = 2 , overlay = "Rotation Disabled", tip = "Disables Rotation", highlight = 0, icon = br.player.spell.crusaderStrike}
    };
    CreateButton("Rotation",1,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Enables Defensive", highlight = 1, icon = br.player.spell.flashOfLight},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "Disables Defensive", highlight = 0, icon = br.player.spell.flashOfLight}
    };
    CreateButton("Defensive",2,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupt Enabled", tip = "Enables Interrupt", highlight = 1, icon = br.player.spell.hammerOfJustice},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupt Disabled", tip = "Disables Interrupt", highlight = 0, icon = br.player.spell.hammerOfJustice}
    };
    CreateButton("Interrupt",3,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Trinkets
            br.ui:createDropdownWithout(section,"Trinket 1", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinket 1.")
            br.ui:createDropdownWithout(section,"Trinket 2", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Trinket 2.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Divine Shield
            br.ui:createSpinner(section, "Divine Shield", 20, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Flash of Light
            br.ui:createSpinner(section, "Flash of Light", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Hammer of Justice
            br.ui:createSpinner(section, "Hammer of Justice - Defensive", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Lay on Hands
            br.ui:createSpinner(section, "Lay on Hands", 20, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Word of Glory
            br.ui:createSpinner(section, "Word of Glory", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Hammer of Justice
            br.ui:createCheckbox(section, "Hammer of Justice")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At", 0, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
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

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
local debuff
local enemies
local equiped
local has
local item
local module
local ui
local unit
local units
local use
-- Profile Specific Locals
local actionList        = {}
local var               = {}
var.getFacingDistance   = _G["getFacingDistance"]
var.getItemInfo         = _G["GetItemInfo"]
var.haltProfile         = false
var.loadSupport         = _G["loadSupport"]
var.profileStop         = false
var.range5              = false
var.range30             = false
var.range40             = false
var.specificToggle      = _G["SpecificToggle"]

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()

end -- End Action List- Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Lay on Hands
        if ui.checked("Lay on Hands") and cast.able.layOnHands() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.inCombat(thisUnit) and not debuff.forbearance.exists(thisUnit) and unit.hp(thisUnit) <= ui.value("Lay on Hands") then
                if cast.layOnHands(thisUnit) then ui.debug("Casting Lay on Hands on "..unit.name(thisUnit)) return true end
            end
        end
        -- Divine Shield
        if ui.checked("Divine Shield") and cast.able.divineShield() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.inCombat(thisUnit) and not debuff.forbearance.exists(thisUnit) and unit.hp(thisUnit) <= ui.value("Divine Shield") then
                if cast.divineShield(thisUnit) then ui.debug("Casting Divine Shield on "..unit.name(thisUnit)) return true end
            end
        end
        -- Call Module- Basic Healing
        module.BasicHealing()
        -- -- Pot/Stoned
        -- if ui.checked("Healthstone/Potion") and unit.hp()<= ui.value("Healthstone/Potion") and unit.inCombat() then
        --     -- Lock Candy
        --     if has.healthstone() then
        --         if use.healthstone() then ui.debug("Using Healthstone") return true end
        --     end
        --     -- Health Potion (Grabs the Highest usable from bags)
        --     if has.item(var.getHealPot) then
        --         use.item(var.getHealPot)
        --         ui.debug("Using "..var.getItemInfo(var.getHealPot))
        --         return true
        --     end
        -- end
        -- -- Heirloom Neck
        -- if ui.checked("Heirloom Neck") and unit.hp() <= ui.value("Heirloom Neck") and not unit.inCombat() then
        --     if use.able.heirloomNeck() and item.heirloomNeck ~= 0 and item.heirloomNeck ~= item.manariTrainingAmulet then
        --         if use.heirloomNeck() then ui.debug("Using Heirloom Neck") return true end
        --     end
        -- end
        -- -- Gift of the Naaru
        -- if ui.checked("Gift of the Naaru") and unit.race() == "Draenei"
        --     and unit.inCombat() and unit.hp() < ui.value("Gift of the Naaru")
        -- then
        --     if cast.giftOfTheNaaru() then ui.debug("Casting Gift of the Naaru") return true end
        -- end
        -- Hammer of Justice
        if ui.checked("Hammer of Justice - Defensive") and cast.able.hammerOfJustice()
            and unit.inCombat() and unit.hp() < ui.value("Hammer of Justice - Defensive")
        then
            if cast.hammerOfJustice() then ui.debug("Casting Hammer of Justice [Defensive]") return true end
        end
        -- Word of Glory
        if ui.checked("Word of Glory") and cast.able.wordOfGlory() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if unit.inCombat(thisUnit) and unit.hp(thisUnit) <= ui.value("Word of Glory") then
                if cast.wordOfGlory(thisUnit) then ui.debug("Casting Word of Glory on "..unit.name(thisUnit)) return true end
            end
        end
        -- Flash of Light
        if ui.checked("Flash of Light") and cast.able.flashOfLight() and not unit.moving() then
            local thisUnit = unit.friend("target") and "target" or "player"
            if (unit.inCombat() and unit.hp(thisUnit) <= ui.value("Flash of Light"))
                or (not unit.inCombat() and unit.hp() < 90)
            then
                if cast.flashOfLight(thisUnit) then ui.debug("Casting Flash of Light on "..unit.name(thisUnit)) return true end
            end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        for i=1, #enemies.yards10 do
            local thisUnit = enemies.yards10[i]
            if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                -- Hammer of Justice
                if ui.checked("Hammer of Justice") and cast.able.hammerOfJustice(thisUnit) then
                    if cast.hammerOfJustice(thisUnit) then ui.debug("Casting Hammer of Justice [Interrupt]") return true end
                end
            end
        end
    end -- End Interrupt Check
end -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Judgment
            if cast.able.judgment("target") and unit.exists("target") and unit.distance("target") < 30 then
                if cast.judgment("target") then ui.debug("Casting Judgment [Pull]") return true end
            end
            -- Start Attack
            if not IsAutoRepeatSpell(GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                StartAttack(units.dyn5)
            end
        end
    end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()

    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                            = br.player.buff
    cast                                            = br.player.cast
    cd                                              = br.player.cd
    debuff                                          = br.player.debuff
    enemies                                         = br.player.enemies
    equiped                                         = br.player.equiped
    has                                             = br.player.has
    item                                            = br.player.items
    module                                          = br.player.module
    ui                                              = br.player.ui
    unit                                            = br.player.unit
    units                                           = br.player.units
    use                                             = br.player.use
    -- Units
    units.get(5)
    units.get(30)
    units.get(40)
    -- Enemies
    enemies.get(5)
    -- enemies.get(8)
    enemies.get(10)
    enemies.get(30)
    enemies.get(40)
    -- General Locals
    var.range5                                      = #enemies.yards5 > 0 and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5
    var.range30                                     = #enemies.yards30 > 0 and unit.exists(units.dyn30) and unit.distance(units.dyn30) < 30
    var.range40                                     = #enemies.yards40 > 0 and unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40
    var.getHealPot                                  = _G["getHealthPot"]()
    var.haltProfile                                 = (unit.inCombat() and var.profileStop) or unit.mounted() or pause() or ui.mode.rotation==4


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif var.haltProfile then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -------------
        --- Extra ---
        -------------
        if actionList.Extra() then return true end
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        -- Check for combat
        if unit.valid("target") and cd.global.remain() == 0 then
            if var.range40 then
                -----------------
                --- Interrupt ---
                -----------------
                if actionList.Interrupt() then return true end
                ------------
                --- Main ---
                ------------
                if var.range5 then
                    -- Start Attack
                    if not IsAutoRepeatSpell(GetSpellInfo(6603)) then
                        StartAttack(units.dyn5)
                    end
                    -- Trinket - Non-Specific
                    local thisTrinket
                    for i = 13, 14 do
                        thisTrinket = i == 13 and "Trinket 1" or "Trinket 2"
                        local opValue = ui.value(thisTrinket)
                        if (opValue == 1 or (opValue == 2 and ui.useCDs())) and use.able.slot(i)
                        and (not equiped.touchOfTheVoid(i) or (equiped.touchOfTheVoid(i) and (#enemies.yards8 > 2 or (ui.useCDs() and opValue ~= 3))))
                        then
                            use.slot(i)
                            ui.debug("Using Trinket in Slot "..i)
                            return
                        end
                    end
                    -- Shield of the Righteous
                    if cast.able.shieldOfTheRighteous() then
                        if cast.shieldOfTheRighteous() then ui.debug("Casting Shield of the Righteous") return true end
                    end
                end
                -- Consecration
                if cast.able.consecration() and not buff.consecration.exists() and #enemies.yards10 > 0 and not unit.moving() then
                    if cast.consecration("player","aoe",1,10) then ui.debug("Casting Consecration") return true end
                end
                -- Judgment
                if cast.able.judgment() and var.range30 then
                    if cast.judgment() then ui.debug("Casting Judgment") return true end
                end
                -- Crusader Strike
                if cast.able.crusaderStrike() and var.range5 then
                    if cast.crusaderStrike() then ui.debug("Casting Crusader Strike") return true end
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 1451
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})