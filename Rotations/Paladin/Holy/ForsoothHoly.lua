local rotationName = "ForsoothHoly"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enables Rotation", highlight = 1, icon = br.player.spell.crusaderStrike},
        [2] = { mode = "Off", value = 2 , overlay = "Rotation Disabled", tip = "Disables Rotation", highlight = 0, icon = br.player.spell.crusaderStrike}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Enables Defensive", highlight = 1, icon = br.player.spell.flashOfLight},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "Disables Defensive", highlight = 0, icon = br.player.spell.flashOfLight}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupt Enabled", tip = "Enables Interrupt", highlight = 1, icon = br.player.spell.hammerOfJustice},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupt Disabled", tip = "Disables Interrupt", highlight = 0, icon = br.player.spell.hammerOfJustice}
    };
    br.ui:createToggle(InterruptModes,"Interrupt",3,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Enables Cooldowns", highlight = 1, icon = br.player.spell.avengingWrath},
        [2] = { mode = "Off", value = 2 , overlay = "Cooldowns Disabled", tip = "Disables Cooldowns", highlight = 0, icon = br.player.spell.avengingWrath}
    };
    br.ui:createToggle(CooldownModes,"Cooldowns",4,0)
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
            br.ui:createCheckbox(section, "Rebuke")
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
local charges
local debuff
local enemies
local equiped
local module
local spell
local ui
local unit
local units
local use
-- Profile Specific Locals
local actionList        = {}
local var               = {}
local holyPower
local lowest
local alliesInRange
var.getFacingDistance   = br._G["getFacingDistance"]
var.getItemInfo         = br._G["GetItemInfo"]
var.haltProfile         = false
var.loadSupport         = br._G["loadSupport"]
var.profileStop         = false
var.range5              = false
var.range30             = false
var.range40             = false
var.specificToggle      = br._G["SpecificToggle"]

local tanks

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()

end -- End Action List- Extra

-- Action List - Defensive
actionList.Defensive = function()
    if not br.player.inCombat then
        lowest = {}
        lowest.unit = "player"
        lowest.hp = 100
        for i = 1, #br.friend do
            if br.friend[i].hp < lowest.hp then
                lowest = br.friend[i]
            end
        end
        
        -- Spend holy power at cap
        if holyPower >= 5 and cast.able.wordOfGlory() and lowest.hp <= 90 then
            cast.wordOfGlory(lowest.unit)
        end
        -- Cast Holy Shock as heal
        if cast.able.holyShock() and lowest.hp < 100 then
            cast.holyShock(lowest.unit)
        end
        -- Cast Holy Light as heal
        if cast.able.holyLight() and not br.isMoving("player") and lowest.hp < 100 then
            cast.holyLight(lowest.unit)
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    for i=1, #enemies.yards10 do
        local thisUnit = enemies.yards10[i]
        
        if cast.able.rebuke() and unit.interruptable(thisUnit,70) then
            if cast.rebuke() then ui.debug("Casting Rebuke [Interrupt]") return true end
        end
        -- Hammer of Justice
        if cast.able.hammerOfJustice(thisUnit) and unit.interruptable(thisUnit,70) then
            if cast.hammerOfJustice(thisUnit) then ui.debug("Casting Hammer of Justice [Interrupt]") return true end
        end
    end
end -- End Action List - Interrupt

-- AFFIX
actionList.affix = function()
    if #units > 0 then
        for i=1, #units do
            if br.GetObjectID(units[i]) == 204773 then
                --https://www.wowhead.com/npc=204773/afflicted-soul
                ui.debug("Found "..units[i].name)
                if cast.dispel.cleanse() then
                    cast.cleanse(units[i])
                end
            end
        end
    end
end

-- CLEANSE
actionList.cleanse = function()
    
    if cd.cleanse.ready() and not cast.last.cleanse() then
        for i = 1, #br.friend do
            if br.canDispel(br.friend[i].unit, spell.cleanse) and not br.UnitDebuffID(br.friend[i].unit,389179) then
                if (br.player.race == "DarkIronDwarf" or br.player.race == "Dwarf") and cast.able.racial() and br.friend[i].unit == "player" then
                    if cast.racial("player") then
                        return true
                    end
                end
                if cast.cleanse(br.friend[i].unit) then
                    return true
                end
            end
        end    
    end
end

-- OUT OF COMBAT FUNCTIONS
actionList.ooc = function()

    if #tanks > 0 then
            if not buff.beaconOfLight.exists(tanks[1].unit) and not buff.beaconOfFaith.exists(tanks[1].unit) and br._G.UnitInRange(tanks[1].unit) then
                if cast.beaconOfLight(tanks[1].unit) then
                    return true
                end
            end
         if buff.beaconOfLight.exists(tanks[1].unit) and not buff.beaconOfFaith.exists("Player") then
            if cast.beaconOfFaith("Player") then
                return true
            end
        end
        elseif #tanks == 0 and not buff.beaconOfLight.exists("Player") then
            if cast.beaconOfLight("Player") then
                return true
            end
        end
    
    --AUTO DRINK (NEED ADD FOOD\DRINK ID)
    if ui.checked("Auto Drink") and br.getMana("player") <= br.getOptionValue("Auto Drink") and not moving and br.getDebuffStacks("player", 240443) == 0 and br.getDebuffStacks("player", 226510) == 0 then
        --240443 == bursting
        -- 226510 == sanguine
        --drink list
        --[[
        item=65499/conjured getMana("player") cookies - TW food
        item=159867/rockskip-mineral-wate (alliance bfa)
        item=163784/seafoam-coconut-water  (horde bfa)
        item=113509/conjured-mana-bun
        item=126936/sugar-crusted-fish-feast ff
        ]]
    end

    -- HL TO HEAL IF NOTHING TO DO
    local standingTime = 0
    if br.DontMoveStartTime then
        standingTime = br._G.GetTime() - br.DontMoveStartTime
    end
    if not br.isMoving("Player") and standingTime > ui.value("OOC Holy Heal - Time") and not drinking and br.getMana("player") >= ui.value("OOC Holy Heal - Mana") and br.getHP(lowest.unit) < ui.value("OOC Holy Heal - Health") then
        if cast.holyLight(lowest.unit) then
            br.addonDebug("[HEAL] OOC HL")
            return true
        end
    end
end

-- Action List - Cooldowns
actionList.Cooldown = function()
    local injuredAllies = 0
        -- Avenging Wrath
        if br.isBoss(thisUnit) and cast.able.avengingWrath() then
           if cast.avengingWrath() then ui.debug("Casting Avenging Wrath") return true end
        end
        --- Aura Mastery
        injuredAllies = br.getLowAllies(80)
        if cast.able.auraMastery() and injuredAllies >= 3 then
            cast.auraMastery()
        end
        -- Daybreak
        injuredAllies = br.getLowAllies(95)
        if cast.able.daybreak() and injuredAllies >= 3 then
            cast.daybreak()
        end
        --- Divine Toll
        injuredAllies = br.getLowAllies(100)
        if cast.able.divineToll() and injuredAllies >= 3 then
            cast.divineToll()
        end
        -- Cast Blessings
        if cast.able.blessingOfSummer() and br._G.UnitIsPlayer("target") then
            cast.blessingOfSummer("target")
        end
        if cast.able.blessingOfAutumn() then
            cast.blessingOfAutumn()
        end
        if cast.able.blessingOfWinter() then
            cast.blessingOfWinter()
        end
        if cast.able.blessingOfSpring() then
            cast.blessingOfSpring()
        end
        -- Tyr's Deliverance
        injuredAllies = br.getLowAllies(85)
        
        if cast.able.tyrsDeliverance() and injuredAllies >= 3 then
            cast.tyrsDeliverance()
        end

        -- blessing of sacrifice
        if #tanks > 0 and cast.able.blessingOfSacrifice() then
            cast.blessingOfSacrifice(tanks[1].unit)
        end
end -- End Action List - Cooldowns

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        tanks = br.getTanksTable()
        -- Beacons
        if #tanks > 0 and not buff.beaconOfLight.exists(tanks[1].unit) and unit.distance(tanks[1]) < 60 then
            cast.beaconOfLight(tanks[1].unit)
            if buff.beaconOfLight.exists(tanks[1].unit) and not buff.beaconOfFaith.exists("Player") then
                if cast.beaconOfFaith("Player") then
                    return true
                end
            end
            elseif #tanks == 0 and not buff.beaconOfLight.exists("Player") then
                if cast.beaconOfLight("Player") then
                    return true
                end
            end
        end
        if unit.valid("target") then
            -- Judgment
            if cast.able.judgment("target") and unit.exists("target") and unit.distance("target") < 30 then
                if cast.judgment("target") then ui.debug("Casting Judgment [Pull]") return true end
            end
            -- Start Attack
            if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                br._G.StartAttack(units.dyn5)
            end
        end
    end
 -- End Action List - PreCombat

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
    charges                                         = br.player.charges
    debuff                                          = br.player.debuff
    enemies                                         = br.player.enemies
    equiped                                         = br.player.equiped
    module                                          = br.player.module
    spell                                           = br.player.spell
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
    enemies.get(8)
    enemies.get(10)
    enemies.get(30)
    enemies.get(40)
    -- General Locals
    var.range5                                      = #enemies.yards5 > 0 and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5
    var.range30                                     = #enemies.yards30 > 0 and unit.exists(units.dyn30) and unit.distance(units.dyn30) < 30
    var.range40                                     = #enemies.yards40 > 0 and unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40
    var.getHealPot                                  = br["getHealthPot"]()
    var.haltProfile                                 = (unit.inCombat() and var.profileStop) or unit.mounted() or br.pause() or ui.mode.rotation==4
    holyPower = br.player.power.holyPower.amount()
    tanks = br.getTanksTable()
    lowest = {}
    lowest.unit = "player"
    lowest.hp = 100
    for i = 1, #br.friend do
        if br.friend[i].hp < lowest.hp then
            lowest = br.friend[i]
        end
    end


    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.mounted() then
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -------------
        --- Extra ---
        -------------
        if actionList.Extra() then return true end
        -----------------
        ------ OOC -----
        -----------------
        if actionList.ooc() then return true end
        -----------------
        --- Cleanse ----
        -----------------
        if actionList.cleanse() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        -- Check for combat
        if cd.global.remain() == 0 then
                -----------------
                --- Defensive ---
                -----------------
                if actionList.Defensive() then return true end
                -----------------
                --- Cooldowns ---
                -----------------
                if actionList.Cooldown() then
                    return true
                end
                -----------------
                --- Interrupt ---
                -----------------
                if actionList.Interrupt() then return true end
                --- AFFIX ---
                if actionList.affix() then return true end
                ------------
                --- Main ---
                ------------
                if actionList.cleanse() then return true end
                if var.range5 then
                    -- Start Attack
                    if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) then
                        br._G.StartAttack(units.dyn5)
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
                end
                -- Emergency Lay on Hands
                if cast.able.layOnHands and lowest.hp <= 20 then
                    cast.layOnHands(lowest.unit)
                end
                if br.player.health < 60 and cast.able.divineShield() then
                    cast.divineShield()
                end
                if cast.able.holyShock() and lowest.hp < 35 then
                    cast.holyShock(lowest.unit)
                end
                if cast.able.flashOfLight() and lowest.hp < 35 then
                    cast.flashOfLight(lowest.unit)
                end
                if br.getOptionValue("Raise Ally - Target") == 2 and br._G.UnitIsPlayer("mouseover") and br.GetUnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover", "player") then
                    if cast.raiseAlly("mouseover", "dead") then
                        return
                    end
                end
                -- Spend holy power at cap
                if holyPower >= 5 and cast.able.wordOfGlory() and lowest.hp <= 90 then
                    cast.wordOfGlory(lowest.unit)
                end
                -- Cast Light's Hammer
                if cast.able.lightsHammer() and #enemies.yards10 > 0 then
                    cast.lightsHammer()
                end
                -- Cast Holy Prism
                if cast.able.holyPrism() and #enemies.yards40 > 0 then
                    cast.holyPrism(enemies.yards40[1])
                end
                if cast.able.holyPrism() and lowest.hp <= 85 then
                    cast.holyPrism(lowest.unit)
                end
                -- Cast 1st charge of Holy Shock as heal
                if charges.holyShock.count() >= 2 and cast.able.holyShock() and lowest.hp < 100 then
                    cast.holyShock(lowest.unit)
                end
                -- Cast 1st charge of Holy Shock
                if charges.holyShock.count() >= 2 and cast.able.holyShock() and #enemies.yards40 > 0 then
                    cast.holyShock(enemies.yards40[1])
                end
                -- Cast Hand of Divinity
                if lowest.hp <= 50 and cast.able.handofDivinity() then
                    cast.handofDivinity()
                end
                -- Cast Emergency Holy Light if Hand of Divinity
                if lowest.hp <= 50 and buff.handofDivinity.exists() and cast.able.holyLight(lowest.unit) then
                    cast.holyLight(lowest.unit)
                end
                -- Consecration
                if cast.able.consecration() and not buff.consecration.exists() and #enemies.yards5 > 0 and not unit.moving() then
                    if cast.consecration() then ui.debug("Casting Consecration") return true end
                end
                -- Judgment with Infusion of Light
                if cast.able.judgment() and buff.infusionOfLight.exists() and #enemies.yards30 > 0 then
                    if cast.judgment() then ui.debug("Casting Judgment while Infusion of Light is up") return true end
                end
                -- Hammer of Wrath
                if cast.able.hammerOfWrath() and #enemies.yards30 > 0 then
                    if cast.hammerOfWrath() then ui.debug("Casting Hammer of Wrath") return true end
                end
                -- Cast Holy Shock as heal
                if cast.able.holyShock() and lowest.hp < 100 then
                    cast.holyShock(lowest.unit)
                end
                -- Cast Holy Shock
                if cast.able.holyShock() and #enemies.yards40 > 0 then
                    cast.holyShock(enemies.yards40[1])
                end
                -- Spend holy power at 3-4
                if holyPower >= 3 and holyPower <= 4 and cast.able.wordOfGlory() and lowest.hp <= 80 and unit.distance(lowest) <= 40 then
                    cast.wordOfGlory(lowest.unit)
                end
                -- Judgment
                if cast.able.judgment() and #enemies.yards30 > 0 then
                    if cast.judgment() then ui.debug("Casting Judgment") return true end
                end
                -- Arcane Torrent
                if cast.able.racial() and (unit.race() == "BloodElf") and #enemies.yards8 > 0 then
                    cast.racial()
                end
                -- Crusader Strike
                if cast.able.crusaderStrike() and #enemies.yards5 > 0 then
                    if cast.crusaderStrike() then ui.debug("Casting Crusader Strike") return true end
                end
                -- Flash of Light
                if cast.able.flashOfLight() and lowest.hp <= 80 then
                    cast.flashOfLight(lowest.unit)
                end
                -- Damage Priority
                -- Shield of Righteousness
                if holyPower >= 5 and cast.able.shieldOfTheRighteous() and #enemies.yards5 > 0 then
                    cast.shieldOfTheRighteous()
                end
                -- Divine Toll
                if holyPower <= 1 and cast.able.divineToll() and #enemies.yards5 > 0 then
                    cast.divineToll()
                end
                -- Shield of Righteousness 3 or 4
                if cast.able.shieldOfTheRighteous() and #enemies.yards5 > 0 then
                    cast.shieldOfTheRighteous()
                end

            end -- End In Combat Rotation
    end -- Paus
end -- End runRotation
local id = 65
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})