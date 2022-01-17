local rotationName = "SnewyHoly"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Cooldown
    local CooldownModes = {
        [1] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Includes Cooldowns.", highlight = 1, icon = br.player.spell.divineStar},
        [2] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.divineStar}
    };
    br.ui:createToggle(CooldownModes, "Cooldown", 1, 0)
    
    -- Defensive
    local DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensives.", highlight = 1, icon = br.player.spell.powerWordShield},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.powerWordShield}
    };
    br.ui:createToggle(DefensiveModes, "Defensive", 2, 0)
    
    -- Dispel
    local DispelModes = {
        [1] = {mode = "On", value = 1, overlay = "Dispels Enabled", tip = "Includes Dispels.", highlight = 1, icon = br.player.spell.purify},
        [2] = {mode = "Off", value = 2, overlay = "Dispels Disabled", tip = "No Dispels will be used.", highlight = 0, icon = br.player.spell.purify}
    }
    br.ui:createToggle(DispelModes, "Dispel", 3, 0)
    
    -- Interrupt
    local InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.psychicScream},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.psychicScream}
    };
    br.ui:createToggle(InterruptModes, "Interrupt", 4, 0)
end -- End createToggles

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    
    local function generalOptions()
        local section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createSpinner(section, "Pre-Pull Timer", 2, 1, 10, 1, "Desired time to start Pre-Pull.")
        br.ui:createSpinner(section, "Heal Out of Combat", 90, 1, 100, 1, "Health Percentage to heal Out of Combat.")
        br.ui:createCheckbox(section, "Power Word: Fortitude", "Use Power Word: Fortitude on party.")
        br.ui:createSpinner(section, "Power Word: Shield (Body and Soul)", 1, 0, 100, 1, "Use Power Word: Shield (Body and Soul) after past seconds of moving.")
        br.ui:createSpinner(section, "Angelic Feather", 1, 0, 100, 1, "Use Angelic Feather after past seconds of moving.")
        br.ui:createSpinner(section, "Fade", 100, 0, 100, 1, "Health Percentage to use Fade when we have aggro.")
        br.ui:createDropdown(section, "Dispel Magic", {"Target", "Auto"}, 1, "Use Dispel Magic on current or dynamic Target.")
        br.ui:createDropdown(section, "Purify", {"Target", "Auto"}, 1, "Use Purify on current or dynamic Target.")
        br.ui:checkSectionState(section)
        -- Interrupts
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, "Psychic Scream", "Use Psychic Scream to interrupt.")
        if br.player.race == "Pandaren" then br.ui:createCheckbox(section, "Quaking Palm", "Use Quaking Palm to interrupt.") end
        br.ui:createSpinner(section, "Interrupt At", 85, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
    end -- End generalOptions
    
    local function healingOptions()
        local section = br.ui:createSection(br.ui.window.profile, "Healing")
        br.ui:createSpinner(section, "Binding Heal", 70, 0, 100, 1, "Health Percentage to use Binding Heal at.")
        br.ui:createSpinner(section, "Circle of Healing", 75, 0, 100, 1, "Health Percentage to use Circle of Healing at.")
        br.ui:createSpinner(section, "Circle of Healing Targets", 3, 0, 40, 1, "Minimum Circle of Healing Units to use at.")
        br.ui:createSpinner(section, "Divine Star", 80, 0, 100, 1, "Health Percentage to use Divine Star at.")
        br.ui:createSpinner(section, "Fae Guardians", 80, 0, 100, 1, "Health Percentage to use Fae Guardians at.")
        br.ui:createSpinner(section, "Fae Guardians Mana", 80, 0, 100, 1, "Mana Percentage to use Fae Guardians at.")
        br.ui:createCheckbox(section, "Flash Concentration", "Use Flash Heal at to maintain Flash Concentration.")
        br.ui:createCheckbox(section, "Flash Concentration OoC", "Maintain Flash Concentration out of combat.")
        br.ui:createSpinner(section, "Flash Heal", 60, 0, 100, 1, "Health Percentage to use Flash Heal at.")
        br.ui:createSpinner(section, "Guardian Spirit Tank", 30, 0, 100, 1, "Tank Health Percentage to use Guardian Spirit at.")
        br.ui:createSpinner(section, "Guardian Spirit", 30, 0, 100, 1, "Health Percentage to use Guardian Spirit at.")
        br.ui:createSpinner(section, "Halo", 70, 0, 100, 1, "Health Percentage to use Halo at.")
        br.ui:createSpinner(section, "Halo Targets", 3, 0, 40, 1, "Minimum Halo Units to use at.")
        br.ui:createSpinner(section, "Heal", 70, 0, 100, 1, "Health Percentage to use Heal at.")
        br.ui:createSpinner(section, "Holy Word: Sanctify", 80, 0, 100, 1, "Health Percentage to use Holy Word: Sanctify at.")
        br.ui:createSpinner(section, "Holy Word: Sanctify Targets", 3, 0, 40, 1, "Minimum Holy Word: Sanctify Units to use at.")
        br.ui:createSpinner(section, "Holy Word: Serenity", 50, 0, 100, 1, "Health Percentage to use Holy Word: Serenity at.")
        br.ui:createSpinner(section, "Prayer of Mending", 100, 0, 100, 1, "Health Percentage to use Prayer of Mending at.")
        br.ui:createSpinner(section, "Renew", 85, 0, 100, 1, "Health Percentage to use Renew at.")
        br.ui:createSpinner(section, "Maximum Renew", 3, 0, 40, 1, "Maximum Renew Targets to use at.")
        br.ui:createSpinner(section, "Renew Tank", 90, 0, 100, 1, "Health Percentage to use Renew at.")
        br.ui:checkSectionState(section)
    end -- End healingOptions
    
    local function damageOptions()
        local section = br.ui:createSection(br.ui.window.profile, "Damage")
        br.ui:createSpinner(section, "Shadow Word: Pain Targets", 3, 0, 20, 1, "Maximum Shadow Word: Pain Targets to use at.")
        br.ui:createCheckbox(section, "Explosive Rotation", "Use Shadow Word: Pain at explosives.")
        br.ui:createCheckbox(section, "Divine Star Damage", "Use Divine Star.")
        br.ui:createCheckbox(section, "Holy Fire", "Use Holy Fire")
        br.ui:createSpinner(section, "Holy Nova", 3, 1, 50, 1, "Minimum Holy Nova Units to use at.")
        br.ui:createCheckbox(section, "Holy Word: Chastise", "Use Holy Word: Chastise.")
        br.ui:createCheckbox(section, "Mindgames", "Use Mindgames.")
        br.ui:createCheckbox(section, "Unholy Nova", "Use Unholy Nova.")
        br.ui:createCheckbox(section, "Shadow Word: Death", "Use Shadow Word: Death.")
        br.ui:createCheckbox(section, "Smite", "Use Smite.")
        br.ui:checkSectionState(section)
    end -- End damageOptions
    
    local function cooldownOptions()
        local section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createSpinner(section, "Apotheosis", 50, 0, 100, 1, "Health Percentage to use Apotheosis at.")
        br.ui:createSpinner(section, "Apotheosis Targets", 3, 0, 40, 1, "Minimum Apotheosis Units to use at.")
        br.ui:createSpinner(section, "Divine Hymn", 50, 0, 100, 1, "Health Percentage to use Divine Hymn at.")
        br.ui:createSpinner(section, "Divine Hymn Targets", 3, 0, 40, 1, "Minimum Divine Hymn Units to use at.")
        br.ui:createSpinner(section, "Holy Word: Salvation", 60, 0, 100, 1, "Health Percentage to use Holy Word: Salvation at.")
        br.ui:createSpinner(section, "Holy Word: Salvation Targets", 3, 0, 40, 1, "Minimum Holy Word: Salvation Units to use at.")
        br.ui:createCheckbox(section, "Racial", "Use Racial.")
        br.ui:createSpinner(section, "Trinket 1", 70, 0, 100, 1, "Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, "Trinket 1 Targets", 3, 1, 40, 1, "Minimum Trinket 1 Targets to use at.")
        br.ui:createDropdown(section, "Trinket 1 Mode", {"Enemy", "Friend"}, 1, "Use Trinket 1 on enemy or on friend.")
        br.ui:createSpinner(section, "Trinket 2", 70, 0, 100, 1, "Health Percentage to use at.")
        br.ui:createSpinnerWithout(section, "Trinket 2 Targets", 3, 1, 40, 1, "Minimum Trinket 2 Targets to use at.")
        br.ui:createDropdown(section, "Trinket 2 Mode", {"Enemy", "Friend"}, 1, "Use Trinket 2 on enemy or on friend.")
        br.ui:checkSectionState(section)
    end -- End cooldownOptions
    
    local function defensiveOptions()
        local section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Desperate Prayer", 40, 0, 100, 1, "Health Percentage to use at.")
        br.ui:createSpinner(section, "Healthstone", 35, 0, 100, 1, "Health Percentage to use at.")
        if br.player.race == "Draenei" then br.ui:createSpinner(section, "Gift of the Naaru", 50, 0, 100, 1, "Health Percentage to use at.") end
        br.ui:checkSectionState(section)
    end -- End defensiveOptions
    
    optionTable = {
        {
            [1] = "General",
            [2] = generalOptions,
        },
        {
            [1] = "Healing",
            [2] = healingOptions
        },
        {
            [1] = "Damage",
            [2] = damageOptions
        },
        {
            [1] = "Cooldowns",
            [2] = cooldownOptions
        },
        {
            [1] = "Defensive",
            [2] = defensiveOptions
        }
    }
    return optionTable
end -- End createOptions

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local covenant
local cd
local debuff
local enemies
local friends
local gcdMax
local inCombat
local mode
local moving
local race
local runeforge
local spell
local talent
local ui
local unit
local units
local var
-- Other Locals
local bindingHealUnits
local hp
local lowestUnit
local mp
local renewCount
local sanctifyUnits
local shadowWordPainCount
local thisUnit

-----------------
--- Functions ---
-----------------
local function ttd(u)
    local ttdSec = unit.ttd(u)
    if ttdSec == nil or ttdSec < 0 then
        return 999
    end
    return ttdSec
end

--------------------
--- Action Lists ---
--------------------
local actionList = {}

-- Action List - PreCombat
actionList.PreCombat = function()
    if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then
        if unit.valid("target") then
            if ui.checked("Holy Fire") and not moving and ui.pullTimer() <= cast.time.holyFire() then
                if cast.holyFire("target") then return true end
            elseif ui.checked("Smite") and not moving and ui.pullTimer() <= cast.time.smite() then
                if cast.smite("target") then return true end
            end
        end
    end
end -- End Action List - PreCombat

-- Action List - Extra
actionList.Extra = function()
    if ui.checked("Power Word: Fortitude") then
        for i = 1, #friends do
            thisUnit = friends[i].unit
            if not buff.powerWordFortitude.exists(thisUnit, "any") and unit.distance(thisUnit) < 40 and not unit.deadOrGhost(thisUnit) then
                if cast.powerWordFortitude() then return true end
            end
        end
    end
    if br.IsMovingTime(ui.value("Power Word: Shield (Body and Soul)")) then
        if ui.checked("Power Word: Shield (Body and Soul)") and talent.bodyAndSoul and not debuff.weakenedSoul.exists("player") and not buff.soulshape.exists() then
            if cast.powerWordShield("player") then return true end
        end
    end
    if br.IsMovingTime(ui.value("Angelic Feather")) then
        if ui.checked("Angelic Feather") and talent.angelicFeather and not buff.angelicFeather.exists("player") and not buff.soulshape.exists() then
            if cast.angelicFeather("player") then return true end
        end
    end
end -- End Action List Extra

-- Action List - Dispel
actionList.Dispel = function()
    if mode.dispel == 1 then
        if ui.checked("Dispel Magic") then
            if ui.value("Dispel Magic") == 1 then
                if unit.valid("target") and br.canDispel("target", spell.dispelMagic) then
                    if cast.dispelMagic("target") then return true end
                end
            elseif ui.value("Dispel Magic") == 2 then
                for i = 1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if br.canDispel(thisUnit, spell.dispelMagic) then
                        if cast.dispelMagic(thisUnit) then return true end
                    end
                end
            end
        end
        if ui.checked("Purify") then
            if ui.value("Purify") == 1 then
                if unit.exists("target") and br.canDispel("target", spell.purify) then
                    if cast.purify("target") then return true end
                end
            elseif ui.value("Purify") == 2 then
                for i = 1, #friends do
                    thisUnit = friends[i].unit
                    if br.canDispel(thisUnit, spell.purify) then
                        if cast.purify(thisUnit) then return true end
                    end
                end
            end
        end
    end
end -- End Action List - Dispel

-- Action List - Interrrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards40 do
            thisUnit = enemies.yards40[i]
            if unit.interruptable(thisUnit, ui.value("Interrupt At")) then
                if ui.checked("Psychic Scream") and unit.distance(thisUnit) < 8 then
                    if cast.psychicScream() then return true end
                end
                if ui.checked("Quaking Palm") and unit.distance(thisUnit) < 5 then
                    if cast.quakingPalm(thisUnit) then return true end
                end
            end
        end
    end
end -- End Action List - Interrupt

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        if ui.checked("Fade") and hp <= ui.value("Fade") then
            for i = 1, #enemies.yards30 do
                thisUnit = enemies.yards30[i]
                if unit.isTanking(thisUnit) and unit.inCombat(thisUnit) then
                    cast.fade()
                end
            end
        end
        if ui.checked("Healthstone") and hp <= ui.value("Healthstone") and inCombat and (br.hasItem(5512) and br.canUseItem(5512)) then
            br.useItem(5512)
        end
        if ui.checked("Gift of the Naaru") and hp <= ui.value("Gift of the Naaru") and inCombat and race == "Draenei" then
            if cast.giftOfTheNaaru() then return true end
        end
        if ui.checked("Desperate Prayer") and hp <= ui.value("Desperate Prayer") then
            if cast.desperatePrayer() then return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Cooldown
actionList.Cooldown = function()
    if ui.checked("Guardian Spirit Tank") then
        for i = 1, #br.friend do
            if br.friend[i].hp <= ui.value("Guardian Spirit Tank") then
                if br.friend[i].role == "TANK" then
                    if cast.guardianSpirit(br.friend[i].unit) then return true end
                end
            end
        end
    end
    if ui.checked("Guardian Spirit") then
        for i = 1, #br.friend do
            if br.friend[i].hp <= ui.value("Guardian Spirit") then
                if cast.guardianSpirit(br.friend[i].unit) then return true end
            end
        end
    end
    if ui.useCDs() then
        if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") or (mp < 70 and race == "BloodElf") then
            if race == "LightforgedDraenei" then
                if cast.racial("target", "ground") then return true end
            else
                if cast.racial("player") then return true end
            end
        end
        if ui.checked("Trinket 1") and br.canTrinket(13) then
            if ui.value("Trinket 1 Mode") == 1 and #enemies.yards40 >= ui.value("Trinket 1 Targets") then
                br.useItem(13)
            elseif ui.value("Trinket 1 Mode") == 2 and br.getLowAllies(ui.value("Trinket 1")) >= ui.value("Trinket 1 Targets") then
                if unit.hp(lowestUnit) <= ui.value("Trinket 1") then
                    br.useItem(13, lowestUnit)
                end
            end
        end
        if ui.checked("Trinket 2") and br.canTrinket(14) then
            if ui.value("Trinket 2 Mode") == 1 and #enemies.yards40 >= ui.value("Trinket 1 Targets") then
                br.useItem(14)
            elseif ui.value("Trinket 2 Mode") == 2 and br.getLowAllies(ui.value("Trinket 2")) >= ui.value("Trinket 2 Targets") then
                if unit.hp(lowestUnit) <= ui.value("Trinket 2") then
                    br.useItem(14, lowestUnit)
                end
            end
        end
        if ui.checked("Holy Word: Salvation") and not moving then
            if br.getLowAllies(ui.value("Holy Word: Salvation")) >= ui.value("Holy Word: Salvation Targets") then
                if cast.holyWordSalvation() then return true end
            end
        end
        if ui.checked("Divine Hymn") and not moving then
            if br.getLowAllies(ui.value("Divine Hymn")) >= ui.value("Divine Hymn Targets") then
                if cast.divineHymn() then return true end
            end
        end
        if ui.checked("Apotheosis") and not moving then
            if br.getLowAllies(ui.value("Apotheosis")) >= ui.value("Apotheosis Targets") then
                if cast.divineHymn() then return true end
            end
        end
    end
end -- End Action List - Cooldown

-- Action List - Healing
actionList.Healing = function()
    if ui.checked("Flash Concentration") and runeforge.flashConcentration.equiped then
        if buff.flashConcentration.exists() and buff.flashConcentration.remains() <= 5 and (not moving or buff.surgeOfLight.exists()) and (inCombat or ui.checked("Flash Concentration OoC")) then
            if cast.flashHeal(lowestUnit) then return true end
        end
    end
    if ui.checked("Holy Word: Sanctify") then
        if cd.holyWordSanctify.ready() and #sanctifyUnits >= ui.value("Holy Word: Sanctify Targets") then
            local loc
            if #sanctifyUnits < 12 then
                loc = br.getBestGroundCircleLocation(sanctifyUnits, ui.value("Holy Word: Sanctify Targets"), 6, 10)
            else
                if br.castWiseAoEHeal(br.friend, spell.holyWordSanctify, 10, ui.value("Holy Word: Sanctify"), ui.value("Holy Word: Sanctify Targets"), 6, false, false) then return true end
            end
            if loc ~= nil then
                if br.castGroundAtLocation(loc, spell.holyWordSanctify) then return true end
            end
        end
    end
    if ui.checked("Holy Word: Serenity") then
        if unit.hp(lowestUnit) <= ui.value("Holy Word: Serenity") then
            if cast.holyWordSerenity(lowestUnit) then return true end
        end
    end
    if ui.checked("Prayer of Mending") and inCombat then
        for i = 1, #br.friend do
            if br.friend[i].hp <= ui.value("Prayer of Mending") and not buff.prayerOfMending.exists(br.friend[i].unit) then
                if cast.prayerOfMending(br.friend[i].unit) then return true end
            end
        end
    end
    if ui.checked("Renew Tank") then
        for i = 1, #br.friend do
            if br.friend[i].hp <= ui.value("Renew Tank") and not buff.renew.exists(br.friend[i].unit) and br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                if cast.renew(br.friend[i].unit) then return true end
            end
        end
    end
    if ui.checked("Circle of Healing") then
        if br.getLowAllies(ui.value("Circle of Healing")) >= ui.value("Circle of Healing Targets") then
            if cast.circleOfHealing(lowestUnit) then return true end
        end
    end
    if ui.checked("Halo") and talent.halo and not moving then
        if br.getLowAllies(ui.value("Halo")) >= ui.value("Halo Targets") then
            if cast.halo() then return true end
        end
    end
    if ui.checked("Prayer of Healing") and not moving then
        if br.castWiseAoEHeal(br.friend, spell.prayerOfHealing, 40, ui.value("Prayer of Healing"), ui.value("Prayer of Healing Targets"), 5, false, true) then return true end
    end
    if ui.checked("Divine Star") and talent.divineStar then
        if unit.hp(lowestUnit) <= ui.value("Divine Star") and unit.facing(lowestUnit) and br.getUnitsInRect(5, 24, false, ui.value("Divine Star")) >= 1 then
            if cast.divineStar() then return true end
        end
    end
    if ui.checked("Binding Heal") and talent.bindingHeal and not moving and #bindingHealUnits >= 2 then
        if unit.hp(lowestUnit) <= ui.value("Binding Heal") then
            if cast.bindingHeal(lowestUnit) then return true end
        end
    end
    if ui.checked("Renew") then
        for i = 1, #br.friend do
            if br.friend[i].hp <= br.getValue("Renew") and not buff.renew.exists(br.friend[i].unit) and renewCount < ui.value("Maximum Renew") then
                if cast.renew(br.friend[i].unit) then return true end
            end
        end
    end
    if ui.checked("Fae Guardians") and covenant.nightFae.active then
        for i = 1, #br.friend do
            if br.friend[i].hp <= br.getValue("Fae Guardians") then
                if cast.faeGuardians() then return true end
            end
        end
    end
    if ui.checked("Fae Guardians Mana") and covenant.nightFae.active and mp < ui.value("Fae Guardians Mana") then
        if cast.faeGuardians() then return true end
    end
    if ui.checked("Flash Heal") and not moving then
        if unit.hp(lowestUnit) <= ui.value("Flash Heal") then
            if cast.flashHeal(lowestUnit) then return true end
        end
    end
    if ui.checked("Heal") and not moving then
        if unit.hp(lowestUnit) <= ui.value("Heal") then
            if cast.heal(lowestUnit) then return true end
        end
    end
end -- End Action List - Healing

-- Action List - Damage
actionList.Damage = function()
    if ui.checked("Explosive Rotation") and unit.isExplosive(units.dyn40) then
        if cast.shadowWordPain(units.dyn40) then return true end
    end
    if ui.checked("Shadow Word: Death") then
        for i = 1, #enemies.yards40 do
            thisUnit = enemies.yards40[i]
            if unit.hp(thisUnit) <= 20 then
                if cast.shadowWordDeath(thisUnit) then return true end
            end
        end
    end
    if ui.checked("Holy Word: Chastise") then
        if cast.holyWordChastise(units.dyn30) then return true end
    end
    if ui.checked("Holy Fire") and not moving then
        if cast.holyFire(units.dyn40) then return true end
    end
    if ui.checked("Mindgames") and covenant.venthyr.active and not moving then
        if ttd(units.dyn40) > 9 and not unit.isExplosive(units.dyn40) then
            if cast.mindgames(units.dyn40) then return true end
        end
    end
    if ui.checked("Unholy Nova") and covenant.necrolord.active then
        if ttd(units.dyn40) > 9 and not unit.moving(units.dyn40) and not unit.isExplosive(units.dyn40) then
            if cast.unholyNova(units.dyn40) then return true end
        end
    end
    if ui.checked("Divine Star Damage") then
        if ttd(units.dyn40) > 3 and unit.facing(units.dyn40) and br.getEnemiesInRect(5, 24) >= 1  and not unit.isExplosive(units.dyn40) then
            if cast.divineStar() then return true end
        end
    end
    if ui.checked("Holy Nova") and #enemies.yards12 >= ui.value("Holy Nova") then
        if cast.holyNova() then return true end
    end
    if ui.checked("Shadow Word: Pain Targets") and shadowWordPainCount < ui.value("Shadow Word: Pain Targets") then
        if unit.valid("target") and not debuff.shadowWordPain.exists("target") and ttd() > 6 then
            if cast.shadowWordPain("target") then return true end
        end
        for i = 1, #enemies.yards40 do
            thisUnit = enemies.yards40[i]
            if debuff.shadowWordPain.remain(thisUnit) < 4.8 and ttd(thisUnit) > 6 and not br._G.UnitIsOtherPlayersPet(thisUnit) then
                if cast.shadowWordPain(thisUnit) then return true end
            end
        end
    end
    if ui.checked("Smite") and not moving then
        if cast.smite(units.dyn40) then return true end
    end
    if ui.checked("Shadow Word: Pain Targets") and cd.holyFire.remain() > gcdMax then
        if unit.valid("target") and not debuff.shadowWordPain.exists("target") then
            if cast.shadowWordPain("target") then return true end
        end
        for i = 1, #enemies.yards40 do
            thisUnit = enemies.yards40[i]
            if not br._G.UnitIsOtherPlayersPet(thisUnit) then
                if cast.shadowWordPain(thisUnit) then return true end
            end
        end
    end
end -- End Action List - Damage

----------------
--- ROTATION ---
----------------
local function runRotation()
    -- BR API Locals
    buff = br.player.buff
    cast = br.player.cast
    covenant = br.player.covenant
    cd = br.player.cd
    debuff = br.player.debuff
    enemies = br.player.enemies
    friends = br.friend
    gcdMax = br.player.gcdMax
    inCombat = br.player.inCombat
    mode = br.player.ui.mode
    moving = br.player.moving
    race = br.player.race
    runeforge = br.player.runeforge
    spell = br.player.spell
    talent = br.player.talent
    ui = br.player.ui
    unit = br.player.unit
    units = br.player.units
    var = br.player.variables
    
    -- Custom Variables
    units.get(30)
    units.get(40)
    enemies.get(30)
    enemies.get(40)
    enemies.get(12)
    friends.yards40 = br.getAllies("player",40)

    -- Other Locals
    bindingHealUnits = {}
    hp = unit.hp("player")
    lowestUnit = friends[1].unit
    mp = br.player.power.mana.percent()
    renewCount = buff.renew.count()
    sanctifyUnits = {}
    shadowWordPainCount = debuff.shadowWordPain.count()
    thisUnit = nil

    if cd.holyWordSanctify.ready() then
        for i = 1, #friends.yards40 do
            if friends.yards40[i].hp < ui.value("Holy Word: Sanctify") then
                br._G.tinsert(sanctifyUnits, friends.yards40[i])
            end
        end
    end
    if ui.checked("Binding Heal") and talent.bindingHeal then
        for i = 1, #friends.yards40 do
            if friends.yards40[i].hp < ui.value("Binding Heal") then
                br._G.tinsert(bindingHealUnits, friends.yards40[i])
            end
        end
    end
    
    -- Begin Profile
    if var.profileStop == nil then var.profileStop = false end
    if not inCombat and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (inCombat and var.profileStop) or ui.pause() or unit.mounted() or unit.flying() or unit.taxi() or ui.mode.rotation == 4 then
        return true
    else
        if actionList.Dispel() then return true end
        if actionList.Extra() then return true end
        if not inCombat then
            if actionList.PreCombat() then return true end
            if ui.checked("Heal Out of Combat") then
                if actionList.Healing() then return true end
            end
        else
            if actionList.Defensive() then return true end
            if actionList.Interrupt() then return true end
            if actionList.Cooldown() then return true end
            if actionList.Healing() then return true end
            if actionList.Damage() then return true end
        end
    end
end -- End runRotation

local id = 257
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id], {
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
