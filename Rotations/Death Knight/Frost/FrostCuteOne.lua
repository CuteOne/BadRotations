local rotationName = "CuteOne"
local br = _G["br"]

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.howlingBlast },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.howlingBlast },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.frostStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.deathStrike}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.empowerRuneWeapon },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.empowerRuneWeapon },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.empowerRuneWeapon }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.iceboundFortitude },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.iceboundFortitude }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.mindFreeze },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.mindFreeze }
    };
    CreateButton("Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    local function rotationOptions()
        local section
        local alwaysCdNever = {"|cff00FF00Always","|cffFFFF00Cooldown","|cffFF0000Never"}
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Dark Command
            br.ui:createCheckbox(section,"Dark Command")
            -- Death Grip
            br.ui:createCheckbox(section,"Death Grip")
            -- Glacial Advance
            br.ui:createSpinner(section, "Glacial Advance",  5,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Glacial Advance on. Min: 1 / Max: 10 / Interval: 1")
            -- Path of Frost
            br.ui:createCheckbox(section,"Path of Frost")
            -- Remorseless Winter
            br.ui:createSpinnerWithout(section, "Remorseless Winter",  1,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Remorseless Winter on. Min: 1 / Max: 10 / Interval: 1")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Breath of Sindragosa - Debug
            br.ui:createCheckbox(section, "Breath Of Sindragosa Debug", "|cffFFFFFFShows when BoS is active and time it is active for.")
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Elixir
            br.player.module.FlaskUp("Strength",section)
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.player.module.BasicTrinkets(nil,section)
            -- Covenant Ability
            br.ui:createDropdownWithout(section, "Covenant Ability", alwaysCdNever, 1, "{cffFFFFFFWhen to use Covenant Ability.")
            -- Breath of Sindragosa
            br.ui:createDropdownWithout(section, "Breath of Sindragosa", alwaysCdNever, 2, "|cffFFFFFFWhen to use Breath of Sindragosa Ability.")
            -- Empower Rune Weapon
            br.ui:createDropdownWithout(section, "Empower Rune Weapon", alwaysCdNever, 2, "|cffFFFFFFWhen to use Empower Rune Weapon Ability.")
            -- Frostwyrm's Fury
            br.ui:createDropdownWithout(section, "Frostwyrm's Fury", alwaysCdNever, 2, "|cffFFFFFFWhen to use Frostwyrm's Fury.")
            br.ui:createSpinnerWithout(section, "Frostwyrm's Fury Units",  5,  1,  10,  1,  "|cffFFFFFFSet to desired targets to use Frostwyrm's Fury on. Min: 1 / Max: 10 / Interval: 1")
            -- Horn of Winter
            br.ui:createDropdownWithout(section, "Horn of Winter", alwaysCdNever, 1, "|cffFFFFFFWhen to use Horn of Winter Ability.")
            -- Hypothermic Presence
            br.ui:createDropdownWithout(section, "Hypothermic Presence", alwaysCdNever, 1, "|cffFFFFFFWhen to use Hypothermic Presence Ability.")
            -- Pillar of Frost
            br.ui:createDropdownWithout(section, "Pillar of Frost", alwaysCdNever, 1, "|cffFFFFFFWhen to use Pillar of Frost Ability.")
            -- Raise Dead
            br.ui:createDropdownWithout(section, "Raise Dead", alwaysCdNever, 2, "|cffFFFFFFWhen to use Raise Dead Ability.")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Anti-Magic Shell
            br.ui:createCheckbox(section, "Anti-Magic Shell")
            -- Blinding Sleet
            br.ui:createSpinner(section, "Blinding Sleet",  35,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Death Pact
            br.ui:createSpinner(section, "Death Pact", 40, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Death Strike
            br.ui:createSpinner(section, "Death Strike",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Icebound Fortitude
            br.ui:createSpinner(section, "Icebound Fortitude",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            -- Lichborne
            br.ui:createSpinner(section, "Lichborne", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to use at.")
            -- Raise Ally
            br.ui:createCheckbox(section,"Raise Ally")
            br.ui:createDropdownWithout(section, "Raise Ally - Target", {"|cff00FF00Target","|cffFF0000Mouseover"}, 1, "|cffFFFFFFTarget to cast on")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Asphyxiate
            br.ui:createCheckbox(section, "Asphyxiate")
            -- Death Grip
            br.ui:createCheckbox(section, "Death Grip - Interrupt")
            -- Mind Freeze
            br.ui:createCheckbox(section, "Mind Freeze")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Cleave Toggle
            br.ui:createDropdownWithout(section,  "Cleave Mode", br.dropOptions.Toggle,  6)
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
-- BR API
local buff
local cast
local cd
local conduit
local covenant
local debuff
local enemies
local module
local runeforge
local runicPower
local runicPowerDeficit
local runes
local runesTTM
local spell
local talent
local ui
local unit
local units
local use
local var

local itemLinkRegex = "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?"
--------------------
--- Action Lists ---
--------------------
local actionList = {}
-- Action List - Extras
actionList.Extras = function()
    var.profileDebug = "Extras"
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                var.profileStop = true
                StopAttack()
                ClearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                return true
            end
        end
    end
    -- Chains of Ice
    if ui.checked("Chains of Ice") and cast.able.chainsOfIce() then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if not debuff.chainsOfIce.exists(thisUnit) and not unit.facing(thisUnit,"player") and unit.facing("player",thisUnit)
                and unit.moving(thisUnit) and unit.distance(thisUnit) > 8 and unit.inCombat()
            then
                if cast.chainsOfIce(thisUnit) then ui.debug("Casting Chains of Ice [Anti-Runner]") return true end
            end
        end
    end
    -- Death Grip
    if ui.checked("Death Grip") and cast.able.deathGrip() and unit.inCombat() then
        for i = 1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if unit.distance(thisUnit) > 10 and not unit.isDummy(thisUnit)
                and ((not unit.facing(thisUnit) and unit.moving(thisUnit)) or not unit.moving(thisUnit))                
            then
                if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip [Out of Melee]") return true end
            end
        end
    end
end -- End Action List - Extras

-- Action List - Defensive
actionList.Defensive = function()
    var.profileDebug = "Defensive"
    if ui.useDefensive() and not unit.mounted() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Anti-Magic Shell
        if ui.checked("Anti-Magic Shell") and cast.able.antiMagicShell() then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if unit.isCasting(thisUnit) and unit.isUnit(UnitTarget(thisUnit),"player")
                    and cast.timeRemain(thisUnit) < unit.gcd(true) * 2
                then
                    if cast.antiMagicShell("player") then ui.debug("Casting Anti-Magic Shell") return true end
                end
            end
        end
        -- Blinding Sleet
        if ui.checked("Blinding Sleet") and cast.able.blindingSleet() and unit.hp() < ui.value("Blinding Sleet") and unit.inCombat() then
            if cast.blindingSleet() then ui.debug("Casting Blinding Sleet") return true end
        end
        -- Death Pact
        if ui.checked("Death Pact") and cast.able.deathPact() and unit.hp() < ui.value("Death Pact") then
            if cast.deathPact() then ui.debug("Casting Death Pact") return true end
        end
        -- Death Strike
        if ui.checked("Death Strike") and cast.able.deathStrike() and unit.inCombat()
            and unit.hp() < ui.value("Death Strike") and not var.breathOfSindragosaActive
        then
            if cast.deathStrike() then ui.debug("Casting Death Strike") return true end
        end
        -- Icebound Fortitude
        if ui.checked("Icebound Fortitude") and cast.able.iceboundFortitude() and unit.hp() < ui.value("Icebound Fortitude") and unit.inCombat() then
            if cast.iceboundFortitude() then ui.debug("Casting Icebound Fortitude") return true end
        end
        -- Lichborne
        if ui.checked("Lichborne") and cast.able.lichborne() and unit.hp() < ui.value("Lichborne") then
            if cast.lichborne() then ui.debug("Casting Lichborne") return true end
        end
        -- Raise Ally
        if ui.checked("Raise Ally") then
            if cast.able.raiseAlly("target","dead") and ui.value("Raise Ally - Target")==1
                and unit.player("target") and unit.deadOrGhost("target") and unit.friend("target","player")
            then
                if cast.raiseAlly("target","dead") then ui.debug("Casting Raise Ally on "..unit.name("target")) return true end
            end
            if cast.able.raiseAlly("mouseover","dead") and ui.value("Raise Ally - Target")==2
                and unit.player("mouseover") and unit.deadOrGhost("mouseover") and unit.friend("mouseover","player")
            then
                if cast.raiseAlly("mouseover","dead") then ui.debug("Casting Raise Ally on "..unit.name("mouseover")) return true end
            end
        end
    end -- End Use Defensive Check
end -- End Action List - Defensive

-- Action List - Interrupts
actionList.Interrupts = function()
    var.profileDebug = "Interrupts"
    if ui.useInterrupt() then
        if not buff.antiMagicShell.exists() then
            -- Death Grip
            if ui.checked("Death Grip - Interrupt") and cast.able.deathGrip() then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if unit.distance(thisUnit) > 10 and unit.moving(thisUnit)
                        and unit.interruptable(thisUnit,ui.value("Interrupt At"))
                    then
                        if cast.deathGrip(thisUnit) then ui.debug("Casting Death Grip [Interrupt]") return true end
                    end
                end
            end
            -- Mind Freeze
            if ui.checked("Mind Freeze") and cast.able.mindFreeze() then
                for i=1, #enemies.yards15 do
                    local thisUnit = enemies.yards15[i]
                    if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                        if cast.mindFreeze(thisUnit) then ui.debug("Casting Mind Freeze") return true end
                    end
                end
            end
            --Asphyxiate
            if ui.checked("Asphyxiate") and cast.able.asphyxiate() then
                for i=1, #enemies.yards20 do
                    local thisUnit = enemies.yards20[i]
                    if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                        if cast.asphyxiate(thisUnit) then ui.debug("Casting Asphixiate") return true end
                    end
                end
            end
        end
    end -- End Use Interrupts Check
end -- End Action List - Interrupts

-- Action List - Cold Heart
actionList.ColdHeart = function()
    var.profileDebug = "Cold Heart"
    -- Chains of Ice
    -- chains_of_ice,if=fight_remains<gcd|buff.pillar_of_frost.remains<3&buff.cold_heart.stack=20&!talent.obliteration
    if cast.able.chainsOfIce() and (unit.ttdGroup(30) < unit.gcd(true) or buff.pillarOfFrost.remains() < 3) and buff.coldHeart.stack() == 20 and not talent.obliteration then
        if cast.chainsOfIce() then ui.debug("Casting Chains of Ice [No-Obliteration]") return true end
    end
    -- chains_of_ice,if=talent.obliteration&!buff.pillar_of_frost.up&(buff.cold_heart.stack>=16&buff.unholy_strength.up|buff.cold_heart.stack>=19)
    -- chains_of_ice,if=talent.obliteration&!buff.pillar_of_frost.up&(buff.cold_heart.stack>=16&buff.unholy_strength.up|buff.cold_heart.stack>=19|cooldown.pillar_of_frost.remains<3&buff.cold_heart.stack>=14)
    if cast.able.chainsOfIce() and talent.obliteration and not buff.pillarOfFrost.exists()
        and (buff.coldHeart.stack() >= 16 and buff.unholyStrength.exists() or buff.coldHeart.stack() >= 19
            or (cd.pillarOfFrost.remains() < 3 and buff.coldHeart.stack() >= 14))
    then
        if cast.chainsOfIce() then ui.debug("Casting Chains of Ice [Obliteration]") return true end
    end
end -- End Action List - Cold Heart

-- Action List - Cooldowns
actionList.Cooldowns = function()
    var.profileDebug = "Cooldowns"
    if unit.distance(units.dyn5) < 5 then
        -- Trinkets
        -- use_items,if=cooldown.pillar_of_frost.ready|cooldown.pillar_of_frost.remains>20
        if (cd.pillarOfFrost.remain() == 0 or cd.pillarOfFrost.remain() > 20) then
            module.BasicTrinkets()
        end
        -- Potion
        -- potion,if=buff.pillar_of_frost.up&buff.empower_rune_weapon.up
        if ui.checked("Potion") and ui.useCDs() and unit.instance("raid") then
            if buff.pillarOfFrost.exists() and buff.empowerRuneWeapon.exists() then
                use.potionOfProlongedPower()
            end
        end
        -- Racial: Orc Blood Fury | Troll Berserking
        -- blood_fury,if=buff.pillar_of_frost.up&buff.empower_rune_weapon.up
        -- berserking,if=buff.pillar_of_frost.up
        -- lights_judgment,if=buff.pillar_of_frost.up
        -- ancestral_call,if=buff.pillar_of_frost.up&buff.empower_rune_weapon.up
        -- fireblood,if=buff.pillar_of_frost.remains<=8&buff.empower_rune_weapon.up
        if ui.checked("Racial") and ui.useCDs() and cast.able.racial() then
            if (buff.pillarOfFrost.exists() and ((unit.race() == "Troll" or unit.race() == "LightforgedDraenei")
                or ((unit.race() == "Orc" or unit.race() == "MagharOrc") and buff.empowerRuneWeapon.exists())))
                or (unit.race() == "DarkIronDwarf" and buff.pillarOfFrost.remains() <= 8 and buff.empowerRuneWeapon.exists())
            then
                if cast.racial() then ui.debug("Casting Racial") return true end
            end
        end
        -- Empower Rune Weapon
        if ui.alwaysCdNever("Empower Rune Weapon") and cast.able.empowerRuneWeapon() then
            -- empower_rune_weapon,if=talent.obliteration&(cooldown.pillar_of_frost.ready&rune.time_to_5>gcd&runic_power.deficit>=10|buff.pillar_of_frost.up&rune.time_to_5>gcd)|fight_remains<20
            if talent.obliteration and (not cd.pillarOfFrost.exists() and runesTTM(5) > unit.gcd(true)
                and runicPowerDeficit >= 10 or buff.pillarOfFrost.exists() and runesTTM(5) > unit.gcd(true)) or unit.ttdGroup(5) < 20
            then
                if cast.empowerRuneWeapon() then ui.debug("Casting Empower Rune Weapon [Obliteration]") return true end
            end
            -- empower_rune_weapon,if=talent.breath_of_sindragosa&runic_power.deficit>40&rune.time_to_5>gcd&(buff.breath_of_sindragosa.up|fight_remains<20)
            if talent.breathOfSindragosa and runicPowerDeficit > 40 and runesTTM(5) > unit.gcd(true) and (var.breathOfSindragosaActive or unit.ttdGroup(5) < 20) then
                if cast.empowerRuneWeapon() then ui.debug("Casting Empower Rune Weapon [Breath of Sindragosa]") return true end
            end
            -- empower_rune_weapon,if=talent.icecap&rune<3
            if (talent.icecap or unit.level() < 50) and runes < 3 then
                if cast.empowerRuneWeapon() then ui.debug("Casting Empower Rune Weapon [Icecap]") return true end
            end
        end
        -- Pillar of Frost
        if ui.alwaysCdNever("Pillar of Frost") and cast.able.pillarOfFrost() then
            -- pillar_of_frost,if=talent.breath_of_sindragosa&(cooldown.breath_of_sindragosa.remains|cooldown.breath_of_sindragosa.ready&runic_power.deficit<60)
            if talent.breathOfSindragosa and (cd.breathOfSindragosa.exists() or not var.breathOfSindragosaActive and runicPowerDeficit < 60) then
                if cast.pillarOfFrost() then ui.debug("Casting Pillar of Frost [Breath of Sindragosa]") return true end
            end
            -- pillar_of_frost,if=talent.icecap&!buff.pillar_of_frost.up
            if (talent.icecap or unit.level() < 50) and not buff.pillarOfFrost.exists() then
                if cast.pillarOfFrost() then ui.debug("Casting Pillar of Frost [Icecap]") return true end
            end
            -- pillar_of_frost,if=talent.obliteration&(talent.gathering_storm&buff.remorseless_winter.up|!talent.gathering_storm)
            if talent.obliteration and (talent.gatheringStorm and buff.remorselessWinter.exists() or not talent.gatheringStorm) then
                if cast.pillarOfFrost() then ui.debug("Casting Pillar of Frost [Obliteration]") return true end
            end
        end
        -- Breath of Sindragosa
        -- breath_of_sindragosa,if=buff.pillar_of_frost.up
        if ui.alwaysCdNever("Breath of Sindragosa") and cast.able.breathOfSindragosa() and buff.pillarOfFrost.exists() then
            if cast.breathOfSindragosa(nil,"cone",1,8) then ui.debug("Casting Breath of Sindragosa") return true end
        end
        -- Frostwyrm's Fury
        if ui.alwaysCdNever("Frostwyrm's Fury") and cast.able.frostwyrmsFury() then
            -- frostwyrms_fury,if=buff.pillar_of_frost.remains<gcd&buff.pillar_of_frost.up&!talent.obliteration
            if cast.able.frostwyrmsFury() and (buff.pillarOfFrost.remain() < unit.gcd(true) and buff.pillarOfFrost.exists() and not talent.obliteration) then
                if cast.frostwyrmsFury() then ui.debug("Casting Frostwyrm's Fury") return true end
            end
            -- frostwyrms_fury,if=active_enemies>=2&(buff.pillar_of_frost.up&buff.pillar_of_frost.remains<gcd|raid_event.adds.exists&raid_event.adds.remains<gcd|fight_remains<gcd)
            if cast.able.frostwyrmsFury() and (enemies.yards40r >= ui.value("Frostwyrm's Fury Units")
                and (buff.pillarOfFrost.exists() and buff.pillarOfFrost.remain() < unit.gcd(true) or unit.ttdGroup(5) < unit.gcd(true)))
            then
                if cast.frostwyrmsFury() then ui.debug("Casting Frostwyrm's Fury [AOE]") return true end
            end
            -- frostwyrms_fury,if=talent.obliteration&!buff.pillar_of_frost.up&((buff.unholy_strength.up|!death_knight.runeforge.fallen_crusader)&(debuff.razorice.stack=5|!death_knight.runeforge.razorice))
            if cast.able.frostwyrmsFury() and (talent.obliteration and not buff.pillarOfFrost.exists()
                and ((buff.unholyStrength.exists() or not var.fallenCrusader)
                    and (debuff.razorice.stack() == 5 or not var.razorice)))
            then
                if cast.frostwyrmsFury() then ui.debug("Casting Frostwyrm's Fury [Obliteration]") return true end
            end
        end
        -- Hypothermic Presence
        -- hypothermic_presence,if=talent.breath_of_sindragosa&runic_power.deficit>40&rune>=3&buff.pillar_of_frost.up|!talent.breath_of_sindragosa&runic_power.deficit>=25
        if ui.alwaysCdNever("Hypothermic Presence") and cast.able.hypothermicPresence() and (talent.breathOfSindragosa and runicPowerDeficit > 40
            and runes >= 3 and buff.pillarOfFrost.exists() or not talent.breathOfSindragosa and runicPowerDeficit >= 25)
        then
            if cast.hypothermicPresence() then ui.debug("Casting Hypothermic Presence") return true end
        end
        -- Raise Dead
        -- raise_dead,if=buff.pillar_of_frost.up
        if ui.alwaysCdNever("Raise Dead") and cast.able.raiseDead() and (buff.pillarOfFrost.exists()) then
            if cast.raiseDead() then ui.debug("Casting Raise Dead") return true end
        end
        -- Death and Decay
        -- death_and_decay,if=active_enemies>5|runeforge.phearomones
        if cast.able.deathAndDecay() and (ui.useAOE(8,5) or runeforge.phearomones.equiped) then
            if cast.deathAndDecay("player","aoe",5,8) then ui.debug("Casting Death and Decay") return true end
        end
    end -- End Range Check
end -- End Action List - Cooldowns

-- Action List - Covenants
actionList.Covenants = function()
    -- Death's Due
    -- deaths_due,if=raid_event.adds.in>15|!raid_event.adds.exists|active_enemies>=2
    if cast.able.deathsDue() and (ui.useCDs() or ui.useAOE(8,2)) then
        if cast.deathsDue("best",nil,2,8) then ui.debug("Casting Death's Due") return true end
    end
    -- Swarming Mist
    -- swarming_mist,if=active_enemies=1&runic_power.deficit>3&cooldown.pillar_of_frost.remains<3&!talent.breath_of_sindragosa&(!raid_event.adds.exists|raid_event.adds.in>15)
    if cast.able.swarmingMist() and ui.useST(8,2) and runicPowerDeficit > 3 and cd.pillarOfFrost.remains() < 3 and not talent.breathOfSindragosa then
        if cast.swarmingMist("player","aoe",1,8) then ui.debug("Casting Swarming Mist") return true end
    end
    -- swarming_mist,if=active_enemies>=2&!talent.breath_of_sindragosa
    if cast.able.swarmingMist() and ui.useAOE(8,2) and not talent.breathOfSindragosa then
        if cast.swarmingMist("player","aoe",2,8) then ui.debug("Casting Swarming Mist [AOE]") return true end
    end
    -- swarming_mist,if=talent.breath_of_sindragosa&(buff.breath_of_sindragosa.up&(active_enemies=1&runic_power.deficit>40|active_enemies>=2&runic_power.deficit>60)|!buff.breath_of_sindragosa.up&cooldown.breath_of_sindragosa.remains)
    if cast.able.swarmingMist() and talent.breathOfSindragosa 
        and ((buff.breathOfSindragosa.exists() and ((ui.useST(8,2) and runicPowerDeficit > 40) or (ui.useAOE(8,2) and runicPowerDeficit > 60)))
            or (not buff.breathOfSindragosa.exists() and cd.breathOfSindragosa.exists()))
    then
        if cast.swarmingMist("player","aoe",2,8) then ui.debug("Casting Swarming Mist [Breath of Sindragosa]") return true end
    end
    -- Abomintation Limb
    -- abomination_limb,if=active_enemies=1&cooldown.pillar_of_frost.remains<3&(!raid_event.adds.exists|raid_event.adds.in>15)
    if cast.able.abominationLimb() and ui.useST(20,2) and cd.pillarOfFrost.remains() < 3 then
        if cast.abominationLimb("player","aoe",1,20) then ui.debug("Casting Abomination Limb") return true end
    end
    -- abomination_limb,if=active_enemies>=2
    if cast.able.abominationLimb() and ui.useAOE(20,2) then
        if cast.abominationLimb("player","aoe",2,20) then ui.debug("Casting Abomination Limb [AOE]") return true end
    end
    -- Shackle The Unworthy
    -- shackle_the_unworthy,if=active_enemies=1&cooldown.pillar_of_frost.remains<3&(!raid_event.adds.exists|raid_event.adds.in>15)
    if cast.able.shackleTheUnworthy() and ui.useST(30,2) and cd.pillarOfFrost.remains() < 3 then
        if cast.shackleTheUnworthy() then ui.debug("Casting Shackle the Unworthy") return true end
    end
    -- shackle_the_unworthy,if=active_enemies>=2
    if cast.able.shackleTheUnworthy() and ui.useAOE(30,2) then
        if cast.shackleTheUnworthy() then ui.debug("Casting Shackle the Unworthy [AOE]") return true end
    end
end -- End Action List - Covenants

-- Action List - Breath of Sindragosa Pooling
actionList.BoSPooling = function()
    var.profileDebug = "Breath Of Sindragosa - Pooling"
    -- Howling Blast
    -- howling_blast,if=buff.rime.up
    if cast.able.howlingBlast() and buff.rime.exists() then
        if cast.howlingBlast() then ui.debug("Casting Howling Blast [BoS Pool]") return true end
    end
    -- Remorseless Winter
    -- remorseless_winter,if=active_enemies>=2|rune.time_to_5<=gcd&(talent.gathering_storm|conduit.everfrost|runeforge.biting_cold)
    if cast.able.remorselessWinter() and (ui.useAOE(8,2) or runesTTM(5) <= unit.gcd(true) and (talent.gatheringStorm or conduit.everfrost.enabled or runeforge.bitingCold.equiped)) then
        if cast.remorselessWinter() then ui.debug("Casting Remorseless Winter [BoS Pool]") return true end
    end
    -- Obliterate
    -- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit>=25
    if cast.able.obliterate(var.maxRazorice) and runicPowerDeficit >= 25 then
        if cast.obliterate(var.maxRazorice) then ui.debug("Casting Obliterate [BoS Pool - Power Deficit >= 25]") return true end
    end
    -- Glacial Advance
    -- glacial_advance,if=runic_power.deficit<20&spell_targets.glacial_advance>=2&cooldown.pillar_of_frost.remains>5
    if cast.able.glacialAdvance() and runicPowerDeficit < 20 and enemies.yards20r >= ui.value("Glacial Advance") and cd.pillarOfFrost.remain() > 5 then
        if cast.glacialAdvance(nil,"rect",1,10) then ui.debug("Casting Glacial Advance [BoS Pool - Pillar of Frost CD]") return true end
    end
    -- Frost Strike
    -- frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit<20&cooldown.pillar_of_frost.remains>5
    if cast.able.frostStrike(var.maxRazorice) and runicPowerDeficit < 20 and cd.pillarOfFrost.remain() > 5 then
        if cast.frostStrike(var.maxRazorice) then ui.debug("Casting Frost Strike [BoS Pool - Pillar of Frost CD]") return true end
    end
    -- Frostscythe
    if cast.able.frostscythe() then
        -- frostscythe,if=buff.killing_machine.up&runic_power.deficit>(15+talent.runic_attenuation*3)&spell_targets.frostscythe>=2&(buff.deaths_due.stack=8|!death_and_decay.ticking|!covenant.night_fae)
        if (buff.killingMachine.exists() and runicPowerDeficit > (15 + var.attenuation * 3))
            and (not buff.deathdDue.stack() == 8 or not buff.deathAndDecay.exists() or not covenant.nightFae.active)
            and enemies.yards8f >= 2
        then
            if cast.frostscythe() then ui.debug("Casting Frostscythe [BoS Pool - Killing Machine]") return true end
        end
        -- frostscythe,if=runic_power.deficit>=(35+talent.runic_attenuation*3)&spell_targets.frostscythe>=2&(buff.deaths_due.stack=8|!death_and_decay.ticking|!covenant.night_fae)
        if (runicPowerDeficit > (15 + var.attenuation * 3) and enemies.yards8f >= 2)
            and (not buff.deathdDue.stack() == 8 or not buff.deathAndDecay.exists() or not covenant.nightFae.active)
        then
            if cast.frostscythe() then ui.debug("Casting Frostscythe [BoS Pool]") return true end
        end
    end
    -- Obliterate
    -- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit>=(35+talent.runic_attenuation*3)
    if cast.able.obliterate(var.maxRazorice) and runicPowerDeficit >= (35 + var.attenuation * 3) then
        if cast.obliterate(var.maxRazorice) then ui.debug("Casting Obliterate [BoS Pool]") return true end
    end
    -- Glacial Advance
    -- glacial_advance,if=cooldown.pillar_of_frost.remains>rune.time_to_4&runic_power.deficit<40&spell_targets.glacial_advance>=2
    if cast.able.glacialAdvance() and (cd.pillarOfFrost.remain() > runesTTM(4) and runicPowerDeficit < 40
        and ((ui.mode.rotation == 1 and enemies.yards20r >= ui.value("Glacial Advance")) or (ui.mode.rotation == 2 and enemies.yards20r > 0))) then
        if cast.glacialAdvance(nil,"rect",1,10) then ui.debug("Casting Glacial Advance [BoS Pool]") return true end
    end
    -- Frost Strike
    -- frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=cooldown.pillar_of_frost.remains>rune.time_to_4&runic_power.deficit<40
    if cast.able.frostStrike(var.maxRazorice) and cd.pillarOfFrost.remains() > runesTTM(4) and runicPowerDeficit < 40 then
        if cast.frostStrike(var.maxRazorice) then ui.debug("Casting Frost Strike [BoS Pool]") return true end
    end
end -- End Action List - Breath of Sindragosa Pooling

-- Action List - Breath of Sindragosa Ticking
actionList.BoSTicking = function()
    var.profileDebug = "Breath Of Sindragosa - Ticking"
    -- Obliterate
    -- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power<=40
    if cast.able.obliterate(var.maxRazorice) and (runicPower <= 40) then
        if cast.obliterate(var.maxRazorice) then ui.debug("Casting Obliterate [BoS Active - Power <= 40]") return true end
    end
    -- Remorseless Winter
    -- remorseless_winter,if=talent.gathering_storm|conduit.everfrost|runeforge.biting_cold|active_enemies>=2
    if cast.able.remorselessWinter() and (talent.gatheringStorm or conduit.everfrost or runeforge.bitingCold or #enemies.yards8 >= ui.value("Remorseless Winter")) then
        if cast.remorselessWinter() then ui.debug("Casting Remorseless Winter [BoS Active]") return true end
    end
    -- Howling Blast
    -- howling_blast,if=buff.rime.up
    if cast.able.howlingBlast() and buff.rime.exists() then
        if cast.howlingBlast() then ui.debug("Casting Howling Blast [BoS Active]") return true end
    end
    -- Obliterate
    -- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=rune.time_to_4<gcd|runic_power<=45
    if cast.able.obliterate(var.maxRazorice) and (runesTTM(4) < unit.gcd(true) or runicPower <= 45) then
        if cast.obliterate(var.maxRazorice) then ui.debug("Casting Obliterate [BoS Active - 4 Rune / Power <= 45]") return true end
    end
    -- Frostscythe
    -- frostscythe,if=buff.killing_machine.up&spell_targets.frostscythe>=2&(buff.deaths_due.stack=8|!death_and_decay.ticking|!covenant.night_fae)
    if cast.able.frostscythe() and (buff.killingMachine.exists())
        and (buff.deathsDue.stack() == 8 or not buff.deathAndDecay.exists() or not covenant.nightFae.active)
        and enemies.yards8f >= 2
    then
        if cast.frostscythe() then ui.debug("Casting Frostscythe [BoS Active - Killing Machine]") return true end
    end
    -- Horn of Winter
    -- horn_of_winter,if=runic_power.deficit>=32&rune.time_to_3>gcd
    if ui.alwaysCdNever("Horn of Winter") and cast.able.hornOfWinter() and (runicPowerDeficit >= 32 and runesTTM(3) > unit.gcd(true)) then
        if cast.hornOfWinter() then ui.debug("Casting Horn of Winter [BoS Active]") return true end
    end
    -- Frostscythe
    -- frostscythe,if=spell_targets.frostscythe>=2&(buff.deaths_due.stack=8|!death_and_decay.ticking|!covenant.night_fae)
    if cast.able.frostscythe() and ((ui.mode.rotation == 1 and enemies.yards8f >= 2) or (ui.mode.rotation == 2 and enemies.yards8f > 0))
        and (buff.deathsDue.stack() == 8 or not buff.deathAndDecay.exists() or not covenant.nightFae.active)
    then
        if cast.frostscythe() then ui.debug("Casting Frostscythe [BoS Active]") return true end
    end
    -- Obliterate
    -- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit>25|rune>3
    if cast.able.obliterate(var.maxRazorice) and (runicPowerDeficit > 25 or runes > 3) then
        if cast.obliterate(var.maxRazorice) then ui.debug("Casting Obliterate [BoS Active]") return true end
    end
    -- Racial: Arcane Torrent
    -- arcane_torrent,if=runic_power.deficit>50
    if cast.able.racial() and (runicPowerDeficit > 50 and unit.race() == "BloodElf") then
        if cast.racial() then ui.debug("Casting Arcane Torrent [BoS Active]") return true end
    end
end -- End Action List - Breath of Sindragosa Ticking

-- Action List - Obliteration
actionList.Obliteration = function()
    var.profileDebug = "Obliteration"
    -- Remorseless Winter
    -- remorseless_winter,if=active_enemies>=3&(talent.gathering_storm|conduit.everfrost|runeforge.biting_cold)
    if cast.able.remorselessWinter() and #enemies.yards8 >= ui.value("Remorseless Winter")
        and (talent.gatheringStorm or conduit.everfrost or runeforge.bitingCold)
    then
        if cast.remorselessWinter() then ui.debug("Casting Remorseless Winter [Obliteration]") return true end
    end
    -- Howling Blast
    -- howling_blast,if=!dot.frost_fever.ticking&!buff.killing_machine.up
    if cast.able.howlingBlast() and (not debuff.frostFever.exists(units.dyn5) and not buff.killingMachine.exists()
        and ((not buff.deathAndDecay.exists() and covenant.nightFae.active) or not covenant.nightFae.active))
    then
        if cast.howlingBlast() then ui.debug("Casting Howling Blast [Obliteration]") return true end
    end    
    -- Frostscythe
    -- frostscythe,if=buff.killing_machine.react&spell_targets.frostscythe>=2&(buff.deaths_due.stack=8|!death_and_decay.ticking|!covenant.night_fae)
    if cast.able.frostscythe() and buff.killingMachine.exists() and ((ui.mode.rotation == 1 and enemies.yards8f >= 2) or (ui.mode.rotation == 2 and enemies.yards8f > 0))
        and (buff.deathsDue.stack() == 8 or not buff.deathAndDecay.exists() or not covenant.nightFae.active)
    then
        if cast.frostscythe() then ui.debug("Casting Frostscythe [Obliteration]") return true end
    end
    -- Obliterate
    -- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=buff.killing_machine.react|!buff.rime.up&spell_targets.howling_blast>=3
    if cast.able.obliterate(var.maxRazorice) and (buff.killingMachine.exists() or not buff.rime.exists()
        and ((ui.mode.rotation == 1 and #enemies.yards10t >= 3) or (ui.mode.rotation == 2 and #enemies.yards10t > 0)))
    then
        if cast.obliterate(var.maxRazorice) then ui.debug("Casting Obliterate [Obliteration - Killing Machine / AoE]") return true end
    end
    -- Glacial Advance
    -- glacial_advance,if=spell_targets.glacial_advance>=2&(runic_power.deficit<10|rune.time_to_2>gcd)|(debuff.razorice.stack<5|debuff.razorice.remains<15)
    if cast.able.glacialAdvance() and (((ui.mode.rotation == 1 and enemies.yards20r >= ui.value("Glacial Advance")) or (ui.mode.rotation == 2 and enemies.yards20r > 0))
        and (runicPowerDeficit < 10 or runesTTM(2) > unit.gcd(true)) or (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remains(units.dyn5) < 15))
    then
        if cast.glacialAdvance(nil,"rect",1,10) then ui.debug("Casting Glacial Advance [Obliteration - Low Resource / Razorice]") return true end
    end
    -- Frost Strike
    -- frost_strike,if=conduit.eradicating_blow.enabled&buff.eradicating_blow.stack=2&active_enemies=1
    if cast.able.frostStrike() and conduit.eradicatingBlow.enabled and buff.eradicatingBlow.stack() == 2 and ui.useST(8,2) then
        if cast.frostStrike() then ui.debug("Casting Frost Strike [Obliteration - Eradicating Blow]") return true end
    end
    -- Howling Blast
    -- howling_blast,if=buff.rime.up&spell_targets.howling_blast>=2
    if cast.able.howlingBlast() and (buff.rime.exists() and ((ui.mode.rotation == 1 and #enemies.yards10t >= 2) or (ui.mode.rotation == 2 and #enemies.yards10t > 0))) then
        if cast.howlingBlast() then ui.debug("Casting Howling Blast [Obliteration - Rime AoE]") return true end
    end
    -- Glacial Advance
    -- glacial_advance,if=spell_targets.glacial_advance>=2&(runic_power.deficit<10|rune.time_to_2>gcd)|(debuff.razorice.stack<5|debuff.razorice.remains<15)
    if cast.able.glacialAdvance() and ((ui.mode.rotation == 1 and enemies.yards20r >= ui.value("Glacial Advance")) or (ui.mode.rotation == 2 and enemies.yards20r > 0)) then
        if cast.glacialAdvance(nil,"rect",1,10) then ui.debug("Casting Glacial Advance [Obliteration]") return true end
    end
    -- Frost Strike
    -- frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=!talent.avalanche&!buff.killing_machine.up|talent.avalanche&!buff.rime.up
    if cast.able.frostStrike(var.maxRazorice) and ((not talent.avalanche and not buff.killingMachine.exists()) or (talent.avalanche and not buff.rime.exists())) then
        if cast.frostStrike(var.maxRazorice) then ui.debug("Casting Frost Strike [Obliteration]") return true end
    end
    -- Howling Blast
    -- howling_blast,if=buff.rime.up
    if cast.able.howlingBlast() and buff.rime.exists() then
        if cast.howlingBlast() then ui.debug("Casting Howling Blast [Obliteration - Rime]") return true end
    end
    -- Obliterate
    -- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice
    if cast.able.obliterate(var.maxRazorice) then
        if cast.obliterate(var.maxRazorice) then ui.debug("Casting Obliterate [Obliteration]") return true end
    end
end -- End Action List - Obliteration

-- Action List - Obliteration Pooling
actionList.ObliterationPooling = function()
    -- Remorseless Winter
    -- remorseless_winter,if=talent.gathering_storm|conduit.everfrost|runeforge.biting_cold|active_enemies>=2
    if cast.able.remorselessWinter() and #enemies.yards8 >= ui.value("Remorseless Winter")
        and (talent.gatheringStorm or conduit.everfrost or runeforge.bitingCold)
    then
        if cast.remorselessWinter() then ui.debug("Casting Remorseless Winter [Obliteration Pooling]") return true end
    end
    -- Howling Blast
    -- howling_blast,if=buff.rime.up
    if cast.able.howlingBlast() and buff.rime.exists() then
        if cast.howlingBlast() then ui.debug("Casting Howling Blast [Obliteration Pooling]") return true end
    end
    -- Obliterate
    -- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=buff.killing_machine.react
    if cast.able.obliterate(var.maxRazorice) and buff.killingMachine.exists() then
        if cast.obliterate(var.maxRazorice) then ui.debug("Casting Obliterate [Obliteration Pooling - Killing Machine]") return true end
    end
    -- Glacial Advance
    -- glacial_advance,if=spell_targets.glacial_advance>=2&runic_power.deficit<60
    if cast.able.glacialAdvance() and runicPowerDeficit < 60
        and ((ui.mode.rotation == 1 and enemies.yards20r >= ui.value("Glacial Advance")) or (ui.mode.rotation == 2 and enemies.yards20r > 0))
    then
        if cast.glacialAdvance(nil,"rect",1,10) then ui.debug("Casting Glacial Advance [Obliteration Pooling]") return true end
    end
    -- Frost Strike
    -- frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit<70
    if cast.able.frostStrike(var.maxRazorice) and runicPowerDeficit < 70 then
        if cast.frostStrike(var.maxRazorice) then ui.debug("Cast Frost Strike [Obliteration Pooling]") return true end
    end
    -- Obliterate
    -- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=rune>4
    if cast.able.obliterate(var.maxRazorice) and runes > 4 then
        if cast.obliterate(var.maxRazorice) then ui.debug("Casting Obliterate [Obliteration Pooling]") return true end
    end
    -- Frostscythe
    -- frostscythe,if=active_enemies>=4&(!death_and_decay.ticking&covenant.night_fae|!covenant.night_fae)
    if cast.able.frostscythe() and buff.killingMachine.exists() and ((ui.mode.rotation == 1 and enemies.yards8f >= 4) or (ui.mode.rotation == 2 and enemies.yards8f > 0))
        and (buff.deathsDue.stack() == 8 or not buff.deathAndDecay.exists() or not covenant.nightFae.active)
    then
        if cast.frostscythe() then ui.debug("Casting Frostscythe [Obliteration Pooling]") return true end
    end
end -- End Action List - Obliteration Pooling

-- Action List - Aoe
actionList.Aoe = function()
    -- Remorseless Winter
    -- remorseless_winter
    if cast.able.remorselessWinter() then
        if cast.remorselessWinter() then ui.debug("Casting Remorseless Winter [AoE]") return true end
    end
    -- Glacial Advance
    -- glacial_advance,if=talent.frostscythe
    if cast.able.glacialAdvance() and (talent.frostscythe) and enemies.yards20r >= ui.value("Glacial Advance") then
        if cast.glacialAdvance(nil,"rect",1,10) then ui.debug("Casting Glacial Advance [AoE - Frostscythe]") return true end
    end
    -- Frost Strike
    -- frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=cooldown.remorseless_winter.remains<=2*gcd&talent.gathering_storm
    if cast.able.frostStrike(var.maxRazorice) and (cd.remorselessWinter.remain() <= 2 * unit.gcd(true) and talent.gatheringStorm) then
        if cast.frostStrike(var.maxRazorice) then ui.debug("Casting Frost Strike [AoE - Gathering Storm]") return true end
    end
    -- Howling Blast
    -- howling_blast,if=buff.rime.up
    if cast.able.howlingBlast() and buff.rime.exists() then
        if cast.howlingBlast() then ui.debug("Casting Howling Blast [AoE - Rime]") return true end
    end
    -- Frostscythe
    -- frostscythe,if=buff.killing_machine.up&(!death_and_decay.ticking&covenant.night_fae|!covenant.night_fae)
    if cast.able.frostscythe() and (buff.killingMachine.exists() and ((not buff.deathAndDecay.exists() and covenant.nightFae.active) or not covenant.nightFae.active)) and enemies.yards8f then
        if cast.frostscythe() then ui.debug("Casting Frostscythe [AoE - Killing Machine]") return true end
    end
    -- Glacial Advance
    -- glacial_advance,if=runic_power.deficit<(15+talent.runic_var.attenuation.enabled*3)
    if cast.able.glacialAdvance() and (runicPowerDeficit < (15 + var.attenuation * 3) and enemies.yards20r >= ui.value("Glacial Advance")) then
        if cast.glacialAdvance(nil,"rect",1,10) then ui.debug("Casting Glacial Advance [AoE - Low Power Deficit]") return true end
    end
    -- Frost Strike
    -- frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit<(15+talent.runic_attenuation*3)
    if cast.able.frostStrike(var.maxRazorice) and (runicPowerDeficit < (15 + var.attenuation * 3)) then
        if cast.frostStrike(var.maxRazorice) then ui.debug("Casting Frost Strike [AoE - Low Power Deficit]") return true end
    end
    -- Remorseless Winter
    -- remorseless_winter
    if cast.able.remorselessWinter() and #enemies.yards8 >= ui.value("Remorseless Winter") then
        if cast.remorselessWinter() then ui.debug("Casting Remorseless Winter [AoE]") return true end
    end
    -- Frostscythe
    -- frostscythe&(!death_and_decay.ticking&covenant.night_fae|!covenant.night_fae)
    if cast.able.frostscythe() and ((not buff.deathAndDecay.exists() and covenant.nightFae.active) or not covenant.nightFae.active) and enemies.yards8f > 0 then
        if cast.frostscythe() then ui.debug("Casting Frostscythe [AoE]") return true end
    end
    -- Obliterate
    -- obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit>(25+talent.runic_attenuation*3)
    if cast.able.obliterate(var.maxRazorice) and (runicPowerDeficit > (25 + var.attenuation * 3)) then
        if cast.obliterate(var.maxRazorice) then ui.debug("Casting Obliterate [AoE]") return true end
    end
    -- Glacial Advance
    -- glacial_advance
    if cast.able.glacialAdvance() and enemies.yards20r >= ui.value("Glacial Advance") then
        if cast.glacialAdvance(nil,"rect",1,10) then ui.debug("Casting Glacial Advance [AoE]") return true end
    end
    -- Frost Strike
    -- frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice
    if cast.able.frostStrike(var.maxRazorice) then
        if cast.frostStrike(var.maxRazorice) then ui.debug("Casting Frost Strike [AoE]") return true end
    end
    -- Horn of Winter
    -- horn_of_winter
    if ui.alwaysCdNever("Horn of Winter") and cast.able.hornOfWinter() then
        if cast.hornOfWinter() then ui.debug("Casting Horn of Winter [AoE]") return true end
    end
    -- Racial: Arcane Torrent
    -- arcane_torrent
    if cast.able.racial() and (unit.race() == "BloodElf") then
        if cast.racial() then ui.debug("Casting Arcane Torrent [AoE]") return true end
    end
end -- End Action List - Aoe

-- Action List - Standard
actionList.Standard = function()
    var.profileDebug = "Standard"
    -- Remorseless Winter
    -- remorseless_winter,if=talent.gathering_storm|conduit.everfrost.enabled|runeforge.biting_cold.equipped
    if cast.able.remorselessWinter() and (talent.gatheringStorm or conduit.everfrost.enabled or runeforge.bitingCold.equiped) then
        if cast.remorselessWinter() then ui.debug("Casting Remorseless Winter") return true end
    end
    -- Glacial Advance
    -- glacial_advance,if=!death_knight.runeforge.razorice&(debuff.razorice.stack<5|debuff.razorice.remains<7)
    if cast.able.glacialAdvance() and not var.razorice and (debuff.razorice.stack(units.dyn5) < 5 or debuff.razorice.remains(units.dyn5) < 7) then
        if cast.glacialAdvance(nil,"rect",1,10) then ui.debug("Casting Glacial Advance") return true end
    end
    -- Frost Strike
    if cast.able.frostStrike() then
        -- frost_strike,if=cooldown.remorseless_winter.remains<=2*gcd&talent.gathering_storm
        if (cd.remorselessWinter.remain() <= 2 * unit.gcd(true) and talent.gatheringStorm) then
            if cast.frostStrike() then ui.debug("Casting Frost Strike [Gathering Storm]") return true end
        end
        -- frost_strike,if=conduit.eradicating_blow&buff.eradicating_blow.stack=2|conduit.unleashed_frenzy&buff.unleashed_frenzy.remains<3&buff.unleashed_frenzy.up
        if (conduit.eradicatingBlow and buff.eradicatingBlow.exists()) or (conduit.unleashedFrenzy.enabled and buff.unleashedFrenzy.remains() < 3 and buff.unleashedFury.exists()) then
            if cast.frostStrike() then ui.debug("Casting Frost Strike [Unleashed Frenzy / Eradicating Blow]") return true end
        end
    end
    -- Howling Blast
    -- howling_blast,if=buff.rime.up
    if cast.able.howlingBlast() and buff.rime.exists() and #enemies.yards10t > 0 then
        if cast.howlingBlast() then ui.debug("Casting Howling Blast") return true end
    end
    -- Obliterate
    -- obliterate,if=!buff.frozen_pulse.up&talent.frozen_pulse
    if cast.able.obliterate() and (not buff.frozenPulse.exists() and talent.frozenPulse) then
        if cast.obliterate() then ui.debug("Casting Obliterate [Frozen Pulse]") return true end
    end
    -- Frost Strike
    -- frost_strike,if=runic_power.deficit<(15+talent.runic_attenuation*3)
    if cast.able.frostStrike() and (runicPowerDeficit < (15 + var.attenuation * 3)) then
        if cast.frostStrike() then ui.debug("Casting Frost Strike [Low Power Deficit]") return true end
    end
    -- Obliterate
    -- obliterate,if=runic_power.deficit>(25+talent.runic_attenuation*3)
    if cast.able.obliterate() and (runicPowerDeficit > (25 + var.attenuation * 3)) then
        if cast.obliterate() then ui.debug("Casting Obliterate") return true end
    end
    -- Frost Strike
    -- frost_strike
    if cast.able.frostStrike() then
        if cast.frostStrike() then ui.debug("Casting Frost Strike") return true end
    end
    -- Horn of Winter
    -- horn_of_winter
    if ui.alwaysCdNever("Horn of Winter") and cast.able.hornOfWinter() then
        if cast.hornOfWinter() then ui.debug("Casting Horn of Winter") return true end
    end
    -- Racial: Arcane Torrent
    -- arcane_torrent
    if cast.able.racial() and (unit.race() == "BloodElf") then
        if cast.racial() then ui.debug("Casting Arcane Torrent") return true end
    end
end -- End Action List - Standard

-- Action List - Pre-Combat
actionList.PreCombat = function()
    var.profileDebug = "Pre-Combat"
    -- Flask / Crystal
    -- flask
    module.FlaskUp("Strength")
    -- Food
    -- food
    -- Augmentation
    -- augmentation
    -- Potion
    -- potion
    -- Pre-pull
    if ui.checked("Pre-Pull Timer") and ui.pullTimer() <= ui.value("Pre-Pull Timer") then

    end -- Pre-Pull
    if unit.valid("target") and not unit.inCombat() then
        -- -- Death Grip
        -- if ui.checked("Death Grip") and cast.able.deathGrip("target") and not unit.moving() and #br.friend == 1 then
        --     if cast.deathGrip("target") then ui.debug("Casting Death Grip [Pull]") return true end
        -- end
        -- -- Dark Command
        -- if ui.checked("Dark Command") and cast.able.darkCommand("target") and #br.friend == 1
        --     and not cast.last.deathGrip() and (not ui.checked("Death Grip") or cd.deathGrip.exists("target"))
        -- then
        --     if cast.darkCommand("target") then ui.debug("Casting Dark Command [Pull]") return true end
        -- end
        -- Howling Blast
        if cast.able.howlingBlast("target") then
            if cast.howlingBlast("target") then ui.debug("Casting Howling Blast [Pull]") return true end
        end
        -- Start Attack
        if unit.distance("target") < 5 then
            unit.startAttack("target")
        end
    end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
    buff              = br.player.buff
    cast              = br.player.cast
    cd                = br.player.cd
    conduit           = br.player.conduit
    covenant          = br.player.covenant
    debuff            = br.player.debuff
    enemies           = br.player.enemies
    module            = br.player.module
    runeforge         = br.player.runeforge
    runicPower        = br.player.power.runicPower.amount()
    runicPowerDeficit = br.player.power.runicPower.deficit()
    runes             = br.player.power.runes.amount()
    runesTTM          = br.player.power.runes.ttm
    spell             = br.player.spell
    talent            = br.player.talent
    ui                = br.player.ui
    unit              = br.player.unit
    units             = br.player.units
    use               = br.player.use
    var               = br.player.variables

    -- Dynamic Units
    units.get(5)
    units.get(30)
    units.get(40)

    -- Enemies Tables
    enemies.get(5)
    enemies.get(8)
    enemies.get(10,"target")
    enemies.get(15)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40)

    -- Special Enemy Counts
    enemies.yards8f   = getEnemiesInCone(180,8)
    enemies.yards20r  = getEnemiesInRect(10,20,false) or 0
    enemies.yards40r  = getEnemiesInRect(10,40,false) or 0

    if var.breathOfSindragosaActive == nil then var.breathOfSindragosaActive = false end
    if var.breathOfSindragosaActive and not var.breathTimerSet then var.currentBreathTime = GetTime(); var.breathTimerSet = true end
    if not var.breathOfSindragosaActive then var.breathTimerSet = false end --; var.breathTimer = GetTime() end
    if var.currentBreathTime == nil then var.breathTimer = 0 end
    if var.breathTimerSet then var.breathTimer = round2(GetTime() - var.currentBreathTime,2) end
    if var.profileDebug == nil or not unit.inCombat() then var.profileDebug = "None" end
    if talent.runicattenuation then var.attenuation = 1 else var.attenuation = 0 end
    
    -- Runeforge Detection
    var.fallenCrusader = false
    var.razorice = false
    var.EnchantMH = 0
    if GetInventoryItemLink("player",16) ~= nil then
        var.EnchantMH = (select(6,string.find(GetInventoryItemLink("player",16),itemLinkRegex)))
        var.EnchantMH = tonumber(var.EnchantMH)
        if var.EnchantMH == 3368 or var.EnchantOH == 3368 then var.fallenCrusader = true end
    end
    var.EnchantOH = 0
    if GetInventoryItemLink("player",17) ~= nil then
        var.EnchantOH = (select(6,string.find(GetInventoryItemLink("player",17),itemLinkRegex)))
        var.EnchantOH = tonumber(var.EnchantOH)
    end
    if var.EnchantMH == 3370 or var.EnchantOH == 3370 then var.razorice = true end

    -- Obliterate Target
    -- (debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice
    var.maxRazorice = "target"
    var.razoriceMax = 0
    var.razorMod = var.razorice and 1 or 0
    for i = 1, #enemies.yards5 do
        local thisUnit = enemies.yards5[i]
        local thisValue = (debuff.razorice.stack(thisUnit) + 1) / (debuff.razorice.remains(thisUnit) + 1) * var.razorMod
        if thisValue > var.razoriceMax then
            var.maxRazorice = thisUnit
            var.razoriceMax = thisValue
        end
    end

    -- Breath Debug
    if ui.checked("Breath Of Sindragosa Debug") then
        ui.chatOverlay("Breath Active: "..tostring(var.breathOfSindragosaActive).." | Breath Timer: "..var.breathTimer)
    end

    -- Profile Stop
    if var.profileStop == nil then var.profileStop = false end

    
    -- Path of Frost
    if ui.checked("Path of Frost") and cast.able.pathOfFrost() then
        if not unit.inCombat() and (unit.mounted() or unit.swimming()) and not buff.pathOfFrost.exists() then
            if cast.pathOfFrost() then ui.debug("Casting Path of Frost") return true end
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop==true then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop==true) or unit.flying() or unit.mounted() or ui.pause() or ui.mode.rotation==4 then
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return true end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        -- Combat Start
        if unit.inCombat() and var.profileStop==false and unit.valid(units.dyn5) and unit.exists("target") then
            var.profileDebug = "Combat Rotation"
            -- auto_attack
            if unit.distance(units.dyn5) < 5 then
                unit.startAttack(units.dyn5)
            end
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupts() then return true end
            ---------------------
            --- Main Rotation ---
            ---------------------            
            if not var.breathOfSindragosaActive then
                -- Howling Blast
                -- howling_blast,if=!dot.frost_fever.ticking&(talent.icecap|cooldown.breath_of_sindragosa.remains>15|talent.obliteration&cooldown.pillar_of_frost.remains<dot.frost_fever.remains)
                if cast.able.howlingBlast() and (not debuff.frostFever.exists(units.dyn5) and (talent.icecap
                    or (cd.breathOfSindragosa.remain() > 15 or not talent.breathOfSindragosa or not ui.alwaysCdNever("Breath of Sindragosa"))
                    or talent.obliteration and cd.pillarOfFrost.remain() < debuff.frostFever.exists(units.dyn5)))
                then
                    if cast.howlingBlast() then ui.debug("Casting Howling Blast [No Frost Fever]") return true end
                end
                -- Glacial Advance
                -- glacial_advance,if=buff.icy_talons.remains<=gcd&buff.icy_talons.up&spell_targets.glacial_advance>=2&(!talent.breath_of_sindragosa|cooldown.breath_of_sindragosa.remains>15)
                if cast.able.glacialAdvance() and (buff.icyTalons.remain() <= unit.gcd(true) and buff.icyTalons.exists() 
                    and ((ui.mode.rotation == 1 and enemies.yards20r >= ui.value("Glacial Advance")) or (ui.mode.rotation == 2 and enemies.yards20r > 0))
                    and (not talent.breathOfSindragosa or cd.breathOfSindragosa.remain() > 15 or not ui.alwaysCdNever("Breath of Sindragosa")))
                then
                    if cast.glacialAdvance(nil,"rect",1,10) then ui.debug("Casting Glacial Advance [Icy Talons]") return true end
                end
                -- Frost Strike
                -- frost_strike,if=buff.icy_talons.remains<=gcd&buff.icy_talons.up&(!talent.breath_of_sindragosa|cooldown.breath_of_sindragosa.remains>15)
                if cast.able.frostStrike() and (buff.icyTalons.remain() <= unit.gcd(true) and buff.icyTalons.exists()
                    and (not talent.breathOfSindragosa or cd.breathOfSindragosa.remain() > 15 or not ui.alwaysCdNever("Breath of Sindragosa")))
                then
                    if cast.frostStrike() then ui.debug("Casting Frost Strike [Icy Talons]") return true end
                end
            end
            -- Action List - Covenants
            -- call_action_list,name=covenants
            if ui.alwaysCdNever("Covenant Ability") then
                if actionList.Covenants() then return true end
            end
            -- Action List - Cooldowns
            -- call_action_list,name=cooldowns
            if actionList.Cooldowns() then return true end
            -- Action List - Cold Heart
            -- call_action_list,name=cold_heart,if=talent.cold_heart&(buff.cold_heart.stack>=10&(debuff.razorice.stack=5|!death_knight.runeforge.razorice)|fight_remains<=gcd)
            if talent.coldHeart and (buff.coldHeart.stack() >= 10 and (debuff.razorice.stack() == 5 or not var.razorice) or unit.ttdGroup(5) <= unit.gcd(true)) then
                if actionList.ColdHeart() then return end
            end
            -- Action List - BoS Ticking
            -- run_action_list,name=bos_ticking,if=buff.breath_of_sindragosa.up
            if var.breathOfSindragosaActive then
                if actionList.BoSTicking() then return true end
            end
            -- Action List - BoS Pooling
            -- run_action_list,name=bos_pooling,if=talent.breath_of_sindragosa&(cooldown.breath_of_sindragosa.remains<10)
            if ui.alwaysCdNever("Breath of Sindragosa") and not var.breathOfSindragosaActive
                and talent.breathOfSindragosa and cd.breathOfSindragosa.remain() < 10
            then
                if actionList.BoSPooling() then return true end
            end
            if not var.breathOfSindragosaActive and (not ui.alwaysCdNever("Breath of Sindragosa") or not talent.breathOfSindragosa or cd.breathOfSindragosa.remain() >= 5) then               
                -- Death Strike
                if ui.checked("Death Strike") and cast.able.deathStrike() and unit.inCombat() and buff.darkSuccor.exists() then
                    if cast.deathStrike() then ui.debug("Casting Death Strike [Dark Succor]") return true end
                end
                -- Action List - Obliteration
                -- run_action_list,name=obliteration,if=buff.pillar_of_frost.up&talent.obliteration
                if buff.pillarOfFrost.exists() and talent.obliteration then
                    if actionList.Obliteration() then return true end
                end
                -- Action List - Obliteration Pooling
                -- run_action_list,name=obliteration_pooling,if=talent.obliteration&cooldown.pillar_of_frost.remains<10
                if talent.obliteration and cd.pillarOfFrost.remains() < 10 then
                    if actionList.ObliterationPooling() then return true end
                end
                -- Action List - AoE
                -- run_action_list,name=aoe,if=active_enemies>=2
                if ui.useAOE(8,2) then
                    if actionList.Aoe() then return true end
                end
                -- Action List - Standard
                -- call_action_list,name=standard
                if ui.useST(8,2) then
                    if actionList.Standard() then return true end
                end
                -- Howling Blast
                if cast.able.howlingBlast() and not spell.known.obliterate() then
                    if cast.howlingBlast() then ui.debug("Casting Howling Blast [Low Level]") return true end
                end
            end
        end -- End Combat Check
    end -- End Rotation Pause
end -- runRotation

-- Loader Key
local id = 251
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
