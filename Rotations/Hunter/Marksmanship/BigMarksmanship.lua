local rotationName = "Bigsie"
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.aimedShot },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.multishot },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.arcaneShot }
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterShot },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterShot }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",2,0)
    -- MD Button
    local MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    br.ui:createToggle(MisdirectionModes,"Misdirection",0,1)
    -- Volley Button
    local VolleyModes = {
        [1] = { mode = "On", value = 1 , overlay = "Volley Enabled", tip = "Volley Enabled", highlight = 1, icon = br.player.spell.volley },
        [2] = { mode = "Off", value = 2 , overlay = "Volley Disabled", tip = "Volley Disabled", highlight = 0, icon = br.player.spell.volley }
    };
    br.ui:createToggle(VolleyModes,"Volley",1,1)
    -- CC Button
    local CCModes = {
        [1] = { mode = "On", value = 1 , overlay = "CC Enabled", tip = "CC Enabled", highlight = 1, icon = br.player.spell.freezingTrap },
        [2] = { mode = "Off", value = 2 , overlay = "CC Disabled", tip = "CC Disabled", highlight = 0, icon = br.player.spell.freezingTrap }
    };
    br.ui:createToggle(CCModes,"CC",2,1)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- c = checkbox, d = dropdown, e = editbox, s = spinner
        section = br.ui:createSection(br.ui.window.profile, "General")
            sDummy, cDummy = br.ui:createSpinner(section, "Dummy DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            cOOC = br.ui:createCheckbox(section, "Do not engage OOC", "OOC=Out of combat")
            cPrePull = br.ui:createCheckbox(section, "Prepull logic", "Works as opener")
            br.ui:createText(section, "Toggle options")
            dRotationMode = br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  6)
            dInterruptMode = br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            dMisdirectionMode = br.ui:createDropdownWithout(section, "Misdirection Mode", br.dropOptions.Toggle,  6)
            dVolleyMode = br.ui:createDropdownWithout(section, "Volley Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Ability options")
            dMisdirection = br.ui:createDropdownWithout(section,"Misdirection", {"|cff00FF00Tank","|cffFFFF00Focus","|cffFF0000Pet"},
                                        1, "|cffFFFFFFWho to use Misdirection on")
            sVolley, cVolley = br.ui:createSpinner(section,"Volley Units", 3, 1, 5, 1, "|cffFFFFFFSet minimal number of units.units to cast Volley on")
            dHuntersMark, cHuntersMark = br.ui:createDropdown(section,"Hunter's Mark", {"|cff00FF00Target","|cffFFFF00Boss"})
            dKillShot = br.ui:createDropdownWithout(section, "Kill Shot Target", {"|cff00FF00Any","|cffFFFF00Target"}, 2,"|cffFFFFFFHow to use Kill Shot." )
            dTranq, cTranq = br.ui:createDropdown(section, "Tranquilizing Shot", {"|cff00FF00Any","|cffFFFF00Target"}, 2,"|cffFFFFFFHow to use Tranquilizing Shot." )
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            cTrinkets = br.ui:createCheckbox(section,"Trinkets Logic", "|cffFFFFFFUse trinkets according to simc logic in raids, in other content use best trinket with trueshot")
            dTrueshot = br.ui:createDropdownWithout(section,"Trueshot", {"Always", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            dCovenant = br.ui:createDropdownWithout(section,"Covenant Ability", {"Always", "Trueshot Sync", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            dDoubleTap = br.ui:createDropdownWithout(section,"Double Tap", {"Always", "Trueshot Sync", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            dExplosiveShot = br.ui:createDropdownWithout(section,"Explosive Shot", {"Always", "Never"}, 1, "|cffFFFFFFSet when to use ability.")
            cPotion = br.ui:createCheckbox(section, "Potion of Spectral Agility", "Use potion in raids with other cooldowns")
            cFlask = br.ui:createCheckbox(section, "Spectral Flask of Power", "Use flask")
            cRacial = br.ui:createCheckbox(section,"Racial")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            br.player.module.BasicHealing(section)
            sTurtle, cTurtle = br.ui:createSpinner(section, "Aspect Of The Turtle",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            sExhilaration, cExhilaration = br.ui:createSpinner(section, "Exhilaration",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        if br.player ~= nil and br.player.spell ~= nil and br.player.spell.interrupts ~= nil then
            for _, v in pairs(br.player.spell.interrupts) do
                local spellName = GetSpellInfo(v)
                if v ~= 61304 and spellName ~= nil then
                    br.ui:createCheckbox(section, "Interrupt with " .. spellName, "Interrupt with " .. spellName .. " (ID: " .. v .. ")")
                end
            end
        end
        sInterruptsAt = br.ui:createSpinnerWithout(section, "Interrupts At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        cInterruptAll = br.ui:createCheckbox(section,"Interrupt All", "Interrupt All mobs")
        cInterruptBr = br.ui:createCheckbox(section,"Interrupt BR Whitelisted", "Interrupt BadRotations whitelisted mobs")
        eInterruptPersonal = br.ui:createScrollingEditBoxWithout(section,"Interrupt Personally Whitelisted", nil, "Type spellID to interrupt. Seperate items with comma (123,321)", 300, 40)
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "CCs")
        br.ui:createText(section, "Dungeon boss mechanics")
        cHuntsman = br.ui:createCheckbox(section,"Castle Nathria (Huntsman - Shade of Bargast)", "Cast Freezing Trap on Shade of Bargast")
        cMistcaller = br.ui:createCheckbox(section,"Mists of Tirna Scithe (Mistcaller - Illusionary Vulpin)", "Cast Freezing Trap on Illusionary Vulpin")
        cGlobgrog = br.ui:createCheckbox(section,"Plaguefall (Globgrog - Slimy Smorgasbord)", "Cast Freezing Trap on Slimy Smorgasbord")
        cBlightbone =br.ui:createCheckbox(section,"The Necrotic Wake (Blightbone  - Carrion Worms)", "Cast Binding Shot on Carrion Worms")
        br.ui:createText(section, "Dungeon trash mechanics")
        cGorgon = br.ui:createCheckbox(section,"Halls of Atonement (Vicious Gargon, Loyal Beasts)", "Cast Binding Shot on Vicious Gargon with Loyal Beasts")
        cDefender = br.ui:createCheckbox(section,"Plaguefall (Defender of Many Eyes, Bulwark of Maldraxxus)", "Cast Freezing Trap on Defender of Many Eyes with Bulwark of Maldraxxus")
        cSlimeclaw = br.ui:createCheckbox(section,"Plaguefall (Rotting Slimeclaw)", "Cast Binding Shot on Rotting Slimeclaw with 20% hp")
        cRefuse = br.ui:createCheckbox(section,"Theater of Pain (Disgusting Refuse)", "Cast Binding Shot on Disgusting Refuse to avoid jumping around")
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
local buff
local cast
local cd
local charges
local covenant
local debuff
local equiped
local maps = br.lists.maps
local module
local power
local runeforge
local talent
local items
local ui
local use
local var
local actionList = {}
local _ = nil

-- ENUMS --
local castLocations ={
    ground = "ground",
    groundCC = "groundCC"
}
local units = {
    player = "player",
    target = "target",
    unit,
    units,
    enemies,
    best = "best"
}
local instanceTypes = {
    none = "none", -- when outside an instance
    pvp = "pvp", -- when in a battleground
    arena = "arena", -- when in an arena
    party = "party", -- when in a 5-man instance
    raid = "raid", -- when in a raid instance
    scenario = "scenario" -- when in a scenario
}
local races = {
    lightforgedDraenei = "LightforgedDraenei",
    troll = "Troll",
    orc = "Orc",
    magharOrc = "MagharOrc",
    DarkIronDwarf = "DarkIronDwarf",
    vulpera = "Vulpera"
}
-----------------------
--- Local Functions ---
-----------------------

local function isFreezingTrapActive()
    for _,v in pairs(units.enemies.get(40, units.player, true)) do if debuff.freezingTrap.exists(v, units.player) then return true end end
    return false
end

local function isBlacklistedTrinket(slot)
    local trinketBlacklist = {
        bottledFlayedWingToxin = 178742
    }
    for _,v in pairs(trinketBlacklist) do
        if v == _G.GetInventoryItemID(units.player, slot) then return true end
    end
    return false
end

local function ccMobFinder(id, minHP, spellID)
    local argumentsTable = {id, minHP, spellID}
    local arguments = 0
    local foundMatch

    for _,v in pairs(argumentsTable) do
        if v ~= nil then arguments = arguments + 1 end
    end

    for _,v in pairs(units.enemies.get(40,nil,true)) do
        foundMatch = 0
        if not br.isLongTimeCCed(v) then
            if id ~= nil then
                if unit.id(v) == id then
                    foundMatch = foundMatch + 1
                end
            end
            if minHP ~= nil then
                if minHP <= unit.hp(v) then
                    foundMatch = foundMatch + 1
                end
            end
            if spellID ~= nil then
                if br.getDebuffDuration(v,spellID,units.player) > 0 then
                    foundMatch = foundMatch + 1
                end
            end
            if foundMatch == arguments then return v end
        end
    end
end

local function checkForUpdates()
    if cInterruptBr.value ~= oldvalueBr or eInterruptPersonal.value ~= oldValuePersonal then
        br.player.interrupts.listUpdated = false
    end
end

local function getTimeToLastInterrupt()
	if not br.isTableEmpty(br.lastCastTable.tracker) then
		for _, v in ipairs(br.lastCastTable.tracker) do
			for _,value in pairs(br.player.spell.interrupts) do
				if tonumber(value) == tonumber(v) then
					return GetTime() - br.lastCastTable.castTime[v]
				end
			end
		end
	end
	return 0
end

local function getItemCooldownDuration(itemId)
    local _, itemSpell = GetItemSpell(itemId)
    if itemSpell  ~= nil then
        return GetSpellBaseCooldown(itemSpell) / 1000
    else
        return 0
    end
end

local function getItemSpellCd(itemId)
    local retVal = GetItemCooldown(itemId) + getItemCooldownDuration(itemId) - GetTime()
    if retVal > 0 then
        return retVal
    else
        return 0
    end
end

function getItemCooldownExists(itemId)
    return getItemSpellCd(itemId) > 0
end

local inventory = {
    ammo                            = _G.GetInventoryItemID(units.player, 0),
    head                            = _G.GetInventoryItemID(units.player, 1),
    neck                            = _G.GetInventoryItemID(units.player, 2),
    shoulder                        = _G.GetInventoryItemID(units.player, 3),
    shirt                           = _G.GetInventoryItemID(units.player, 4),
    chest                           = _G.GetInventoryItemID(units.player, 5),
    waist                           = _G.GetInventoryItemID(units.player, 6),
    legs                            = _G.GetInventoryItemID(units.player, 7),
    feet                            = _G.GetInventoryItemID(units.player, 8),
    wrist                           = _G.GetInventoryItemID(units.player, 9),
    hands                           = _G.GetInventoryItemID(units.player, 10),
    finger1                         = _G.GetInventoryItemID(units.player, 11),
    finger2                         = _G.GetInventoryItemID(units.player, 12),
    trinket1                        = _G.GetInventoryItemID(units.player, 13),
    trinket2                        = _G.GetInventoryItemID(units.player, 14),
    back                            = _G.GetInventoryItemID(units.player, 15),
    mainHand                        = _G.GetInventoryItemID(units.player, 16),
    offHand                         = _G.GetInventoryItemID(units.player, 17),
    ranged                          = _G.GetInventoryItemID(units.player, 18),
    tabard                          = _G.GetInventoryItemID(units.player, 19),
    firstBag                        = _G.GetInventoryItemID(units.player, 20),
    secondBag                       = _G.GetInventoryItemID(units.player, 21),
    thirdBag                        = _G.GetInventoryItemID(units.player, 22),
    fourthBag                       = _G.GetInventoryItemID(units.player, 23),
}
--------------------
--- Action Lists ---
--------------------
-- Action List - pc
actionList.pc = function()

    if not buff.feignDeath.exists() and not unit.inCombat() then
        -- actions.precombat=flask
        if cFlask.value and not buff.spectralFlaskOfPower.exists() then
            return use.spectralFlaskOfPower()
        end

        --TODO!
        --actions.precombat+=/augmentation
        if ui.pullTimer() <= 15 and cPrePull.value or (not cOOC.value and unit.valid(units.target) and unit.distance(units.target) < 40) then
            -- actions.precombat+=/tar_trap,if=runeforge.soulforge_embers
            if cast.able.tarTrap() and runeforge.soulforgeEmbers.equiped then
                return cast.tarTrap(units.units.dyn40,castLocations.ground)
            end
            --actions.precombat+=/double_tap,precast_time=10,if=active_enemies>1
            if cast.able.doubleTap() and ui.pullTimer() <= math.random(7,10) then
                return cast.doubleTap()
            end
            -- mdpc, doesnt affect dps
            if ui.pullTimer() <= math.random(3,7) and cast.able.misdirection() then
                return actionList.md(true)
            end
            --actions.precombat+=/aimed_shot,if=active_enemies<3&(!covenant.kyrian&!talent.volley|active_enemies<2)
            if (ui.pullTimer() <= 2 or not cOOC.value) and cast.able.aimedShot() and not unit.moving(units.player) and #units.enemies.yards8tnc < 3 and (#units.enemies.yards8tnc < 2 or (not covenant.kyrian.active and not talent.volley)) then
                return cast.aimedShot(units.target)
            end
            --actions.precombat+=/steady_shot,if=active_enemies>2|(covenant.kyrian|talent.volley)&active_enemies=2
            if cast.able.steadyShot() and (#units.enemies.yards8tnc > 2 or ((covenant.kyrian.active or talent.volley) and #units.enemies.yards8tnc == 2)) then
                return cast.steadyShot(units.target)
            end
            if not cOOC.value then unit.startAttack(units.target) end
        end
    end
end -- End Action List - pc

-- Action List - aa
actionList.aa = function()
    --actions=auto_shot
    unit.startAttack(units.target)

    if cTrinkets.value then

        --actions+=/use_item,name=dreadfire_vessel,if=trinket.1.has_cooldown...
        if equiped.dreadfireVessel()
            and getItemCooldownExists(inventory.trinket1) or getItemCooldownExists(inventory.trinket2)
            or getItemSpellCd(inventory.trinket1) + getItemSpellCd(inventory.trinket2) > 0
            or getItemCooldownDuration(inventory.trinket1) + getItemCooldownDuration(inventory.trinket2) <= cd.dreadfireVessel.remain() * 2
        then
            if use.able.dreadfireVessel() then return use.dreadfireVessel() end
        end

        --actions+=/use_items,slots=trinket1,if=buff.trueshot.up...
        if buff.trueshot.exists()
            and (getItemCooldownDuration(inventory.trinket1) >= getItemCooldownDuration(inventory.trinket2) or getItemCooldownExists(inventory.trinket2))
            or (unit.instance(instanceTypes.raid) and unit.isBoss(units.target) -- do all this shit only in raid @ boss
            and not buff.trueshot.exists()
            and cd.trueshot.remain() > 20
            and getItemCooldownDuration(inventory.trinket2) >= getItemCooldownDuration(inventory.trinket1)
            and getItemSpellCd(inventory.trinket2) - 5 < cd.trueshot.remain()
            and inventory.trinket2 ~= items.dreadfireVessel
            or (getItemCooldownDuration(inventory.trinket1) -5 < cd.trueshot.remain()
            and (getItemCooldownDuration(inventory.trinket1) >= getItemCooldownDuration(inventory.trinket2) or getItemCooldownExists(inventory.trinket2)))
            or unit.ttd(units.target) < cd.trueshot.remain())
        then
            if br.canUseItem(inventory.trinket1) and not isBlacklistedTrinket(13) then return br.useItem(inventory.trinket1) end
        end

        --actions+=/use_items,slots=trinket1,if=buff.trueshot.up...
        if buff.trueshot.exists()
            and (getItemCooldownDuration(inventory.trinket2) >= getItemCooldownDuration(inventory.trinket1) or getItemCooldownExists(inventory.trinket1))
            or (unit.instance(instanceTypes.raid) and unit.isBoss(units.target) -- do all this shit only in raid @ boss
            and not buff.trueshot.exists()
            and cd.trueshot.remain() > 20
            and getItemCooldownDuration(inventory.trinket1) >= getItemCooldownDuration(inventory.trinket2)
            and getItemSpellCd(inventory.trinket1) - 5 < cd.trueshot.remain()
            and inventory.trinket2 ~= items.dreadfireVessel
            or (getItemCooldownDuration(inventory.trinket2) -5 < cd.trueshot.remain()
            and (getItemCooldownDuration(inventory.trinket2) >= getItemCooldownDuration(inventory.trinket1) or getItemCooldownExists(inventory.trinket1)))
            or unit.ttd(units.target) < cd.trueshot.remain())
        then
            if br.canUseItem(inventory.trinket2) and not isBlacklistedTrinket(14) then return br.useItem(inventory.trinket2) end
        end
    end
end

-- Action List - cds
actionList.cds = function()
    -- racial
    if cRacial.value then
        if buff.trueshot.exists() and not unit.race() == races.lightforgedDraenei
            or (unit.race() == races.troll and unit.ttd() < 13)
            or ((unit.race() == races.orc or unit.race() == races.magharOrc) and unit.ttd() < 16)
            or (unit.race() == races.DarkIronDwarf and unit.ttd() < 9)
        then
            return cast.racial()
        end

        if not buff.trueshot.exists() then
            --/lights_judgment,if=buff.trueshot.down
            if unit.race() == races.lightforgedDraenei then
                return cast.racial(units.target,castLocations.ground)
            end
            --/bag_of_tricks,if=buff.trueshot.down
            if unit.race() == races.vulpera then
                return cast.racial()
            end
        end
    end
    -- potion,if=buff.trueshot.up&buff.bloodlust.up|buff.trueshot.up&target.health.pct<20|target.time_to_die<26
    if cPotion.value and use.able.potionOfSpectralAgility() and unit.instance(instanceTypes.raid) and unit.isBoss(units.target) then
        if buff.trueshot.exists() and (buff.bloodLust.exists() or buff.trueshot.exists or (unit.ttd(units.units.dyn40) < 25)) then
           return use.potionOfSpectralAgility()
        end
    end
end -- End Action List - cds

-- Action List - st
actionList.st = function()
    -- steady_shot,if=talent.steady_focus&(prev_gcd.1.steady_shot&buff.steady_focus.remains<5|buff.steady_focus.down)
    if cast.able.steadyShot() and talent.steadyFocus and ( cd.steadyShot.prevgcd() and buff.steadyFocus.remain() < 5 or not buff.steadyFocus.exists()) then
        return cast.steadyShot()
    end
    -- kill_shot
    for i=1, #units.enemies.get(40,_,_,true) do
        local thisUnit = units.enemies.get(40,_,_,true)[i]
        if dKillShot.value == 1 or (dKillShot.value == 2 and unit.isUnit(thisUnit,units.target)) then
            if cast.able.killShot(thisUnit) and unit.hp(thisUnit) < 20 then
                return cast.killShot(thisUnit)
            end
        end
    end
    --------------------------------------------------------------------------------- TODO AFTER THIS ---------------------------------------------------------------------------------
    --------------------------------------------------------------------------------- TODO AFTER THIS ---------------------------------------------------------------------------------
    --------------------------------------------------------------------------------- TODO AFTER THIS ---------------------------------------------------------------------------------
    --------------------------------------------------------------------------------- TODO AFTER THIS ---------------------------------------------------------------------------------
    --------------------------------------------------------------------------------- TODO AFTER THIS ---------------------------------------------------------------------------------
    -- Double Tap
    -- double_tap,if=covenant.kyrian&cooldown.resonating_arrow.remains<gcd|!covenant.kyrian&!covenant.night_fae|covenant.night_fae&(cooldown.wild_spirits.remains<gcd|cooldown.trueshot.remains>55)|target.time_to_die<15
    if (dDoubleTap.value == 1 or (dDoubleTap.value == 2 and buff.trueshot.exists())) and cast.able.doubleTap() and talent.doubleTap and (not cast.last.steadyShot() or buff.steadyFocus.exists() or not talent.steadyFocus)
        and ((((covenant.kyrian.active and (cd.resonatingArrow.remains() < unit.gcd(true) or not dCovenant.value==1)) or not covenant.kyrian.active)
        and (not covenant.nightFae.active or (covenant.nightFae.active and ((cd.wildSpirits.remains() < unit.gcd(true) or not dCovenant.value==1) or cd.trueshot.remains() > 55))))
        or (unit.isBoss(units.target) or unit.ttd(units.target) < 15))
    then
        return cast.doubleTap()
    end
    -- Flare
    -- flare,if=tar_trap.up&runeforge.soulforge_embers
    if cast.able.flare() and debuff.tarTrap.exists(units.units.dyn40) and runeforge.soulforgeEmbers.equiped then
        return cast.flare(units.units.dyn40)
    end
    -- Tar Trap
    -- tar_trap,if=runeforge.soulforge_embers&tar_trap.remains<gcd&cooldown.flare.remains<gcd
    if cast.able.tarTrap() and runeforge.soulforgeEmbers.equiped
        and debuff.tarTrap.remains(units.units.dyn40) < unit.gcd(true) and cd.flare.remains() < unit.gcd(true)
    then
        return cast.tarTrap(units.units.dyn40,castLocations.ground)
    end
    -- Explosive Shot
    -- explosive_shot
    if dExplosiveShot.value==1 and cast.able.explosiveShot() and talent.explosiveShot and unit.ttd("target") > 5 then
        return cast.explosiveShot()
    end
    -- Wild Spirits
    -- wild_spirits
    if (dCovenant.value == 1 or (dCovenant.value == 2 and buff.trueshot.exists())) and cast.able.wildSpirits() then
        return cast.wildSpirits()
    end
    -- Flayed Shot
    -- flayed_shot
    if (dCovenant.value == 1 or (dCovenant.value == 2 and buff.trueshot.exists())) and cast.able.flayedShot() then
        return cast.flayedShot()
    end
    -- Death Chakram
    -- death_chakram,if=focus+cast_regen<focus.max
    if (dCovenant.value == 1 or (dCovenant.value == 2 and buff.trueshot.exists())) and cast.able.deathChakram() and power.focus.amount() + cast.regen.deathChakram() < power.focus.max() then
        return cast.deathChakram()
    end
    -- Resonating Arrow
    -- resonating_arrow
    if (dCovenant.value == 1 or (dCovenant.value == 2 and buff.trueshot.exists())) and cast.able.resonatingArrow() then
        return cast.resonatingArrow()
    end
    -- Volley
    -- volley,if=buff.precise_shots.down|!talent.chimaera_shot|active_enemies<2
    if cast.able.volley() and ui.mode.volley == 1 and cVolley.value and (not buff.preciseShots.exists() or not talent.chimaeraShot or #units.enemies.yards8t < 2) and (#units.enemies.yards8t >= sVolley.value) then
        return cast.volley(units.best,nil,sVolley.value,8)
    end
    -- Trueshot
    -- trueshot,if=buff.precise_shots.down|buff.resonating_arrow.up|buff.wild_spirits.up|buff.volley.up&active_enemies>1
    if dTrueshot.value == 1 and cast.able.trueshot() and (not buff.preciseShots.exists() or debuff.resonatingArrow.exists(units.units.dyn40)
        or debuff.wildMark.exists(units.units.dyn40) or buff.volley.exists() and #units.enemies.yards8t > 1)
    then
        return cast.trueshot(units.player)
    end
    -- Aimed Shot
    -- aimed_shot,target_if=min:dot.serpent_sting.remains+action.serpent_sting.in_flight_to_target*99,if=buff.precise_shots.down|(buff.trueshot.up|full_recharge_time<gcd+cast_time)&(!talent.chimaera_shot|active_enemies<2)|buff.trick_shots.remains>execute_time&active_enemies>1
    if cast.able.aimedShot() and not unit.moving(units.player) and (not buff.preciseShots.exists()
        or ((buff.trueshot.exists() or charges.aimedShot.timeTillFull() < unit.gcd(true) + cast.time.aimedShot())
        and (not talent.chimaeraShot or #units.enemies.yards8t < 2)) or buff.trickShots.remain() > cast.time.aimedShot() and #units.enemies.yards8t > 1)
    then
        return cast.aimedShot()
    end
    -- Rapid Fire
    -- rapid_fire,if=focus+cast_regen<focus.max&(buff.trueshot.down|!runeforge.eagletalons_true_focus)&(buff.double_tap.down|talent.streamline)
    if cast.able.rapidFire() and (power.focus.amount() + power.focus.regen() < power.focus.max()
        and (not buff.trueshot.exists() or not runeforge.eagletalonsTrueFocus.equiped)
        and (not buff.doubleTap.exists() or talent.streamline))
		and unit.ttd(units.units.dyn40) > cast.time.rapidFire()
    then
        return cast.rapidFire()
    end
    -- Chimaera Shot
    -- chimaera_shot,if=buff.precise_shots.up|focus>cost+action.aimed_shot.cost
    if cast.able.chimaeraShot() and (buff.preciseShots.exists()
        or power.focus.amount() > cast.cost.chimaeraShot() + cast.cost.aimedShot())
    then
        return cast.chimaeraShot()
    end
    -- Arcane Shot
    -- arcane_shot,if=buff.precise_shots.up|focus>cost+action.aimed_shot.cost
    if cast.able.arcaneShot() and (buff.preciseShots.exists()
        or power.focus.amount() > cast.cost.arcaneShot() + cast.cost.aimedShot())
    then
        return cast.arcaneShot()
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=refreshable&target.time_to_die>duration
    if cast.able.serpentSting(var.lowestSerpentSting) and debuff.serpentSting.refresh(var.lowestSerpentSting)
        and unit.ttd(var.lowestSerpentSting) > debuff.serpentSting.duration(var.lowestSerpentSting)
    then
        return cast.serpentSting(var.lowestSerpentSting)
    end
    -- Rapid Fire
    -- rapid_fire,if=focus+cast_regen<focus.max&(buff.double_tap.down|talent.streamline)
    if cast.able.rapidFire()
        and (power.focus.amount() + power.focus.regen() < power.focus.max()
        and (not buff.doubleTap.exists() or talent.streamline))
		and unit.ttd(units.units.dyn40) > cast.time.rapidFire()
    then
        return cast.rapidFire()
    end
    -- Steady Shot
    -- steady_shot
    if cast.able.steadyShot() and unit.ttd(units.units.dyn40) > cast.time.steadyShot() and power.focus.amount() <= cast.cost.arcaneShot() + cast.cost.aimedShot() then
        return cast.steadyShot()
    end
end -- End Action List - st

-- Action List - aoe
actionList.aoe = function()
    -- Steady Shot
    -- steady_shot,if=talent.steady_focus&in_flight&buff.steady_focus.remains<5
    if cast.able.steadyShot() and talent.steadyFocus and cast.inFlight.steadyShot() and buff.steadyFocus.remains() < 5 then
        return cast.steadyShot()
    end
    -- Double Tap
    -- double_tap,if=covenant.kyrian&cooldown.resonating_arrow.remains<gcd|!covenant.kyrian&!covenant.night_fae|covenant.night_fae&(cooldown.wild_spirits.remains<gcd|cooldown.trueshot.remains>55)|target.time_to_die<10
    if (dDoubleTap.value == 1 or (dDoubleTap.value == 2 and buff.trueshot.exists())) and cast.able.doubleTap() and talent.doubleTap
        and ((((covenant.kyrian.active and (cd.resonatingArrow.remains() < unit.gcd(true) or not dCovenant.value==1)) or not covenant.kyrian.active)
        and (not covenant.nightFae.active or (covenant.nightFae.active and ((cd.wildSpirits.remain() < unit.gcd(true) or not dCovenant.value==1) or cd.trueshot.remains() > 55))))
        or (unit.isBoss(units.target) and unit.ttd(units.target) < 10))
    then
        return cast.doubleTap()
    end
    -- Tar Trap
    -- tar_trap,if=runeforge.soulforge_embers&tar_trap.remains<gcd&cooldown.flare.remains<gcd
    if cast.able.tarTrap() and runeforge.soulforgeEmbers.equiped and debuff.tarTrap.remains(units.units.dyn40) < unit.gcd(true) and cd.flare.remains() < unit.gcd(true) then
        return cast.tarTrap(units.units.dyn40,castLocations.ground)
    end
    -- Flare
    -- flare,if=tar_trap.up&runeforge.soulforge_embers
    if cast.able.flare() and debuff.tarTrap.exists(units.units.dyn40) and runeforge.soulforgeEmbers.equiped then
        return cast.flare(units.units.dyn40)
    end
    -- Explosive Shot
    -- explosive_shot
    if dExplosiveShot.value==1 and cast.able.explosiveShot() and talent.explosiveShot and unit.ttd(units.units.dyn40) > 5 then
        return cast.explosiveShot()
    end
    -- Wild Spirits
    -- wild_spirits
    if (dCovenant.value == 1 or (dCovenant.value == 2 and buff.trueshot.exists())) and cast.able.wildSpirits() then
        return cast.wildSpirits()
    end
    -- Resonating Arrow
    -- resonating_arrow
    if (dCovenant.value == 1 or (dCovenant.value == 2 and buff.trueshot.exists())) and cast.able.resonatingArrow() then
        return cast.resonatingArrow()
    end
    -- Volley
    -- volley
    if cast.able.volley() and ui.mode.volley == 1 and cVolley.value and #units.enemies.yards8t >= sVolley.value then
        return cast.volley(units.best,nil,sVolley.value,8)
    end
    -- Trueshot
    -- trueshot
    if dTrueshot.value == 1 and cast.able.trueshot() then
        return cast.trueshot(units.player)
    end
    -- Rapid Fire
    -- rapid_fire,if=buff.trick_shots.remains>=execute_time&runeforge.surging_shots&buff.double_tap.down
    if cast.able.rapidFire() and buff.trickShots.remains() > cast.time.rapidFire()
        and runeforge.surgingShots.equiped and not buff.doubleTap.exists() and unit.ttd(units.units.dyn40) > cast.time.rapidFire()
    then
        return cast.rapidFire()
    end
    -- Aimed Shot
    -- aimed_shot,target_if=min:dot.serpent_sting.remains+action.serpent_sting.in_flight_to_target*99,if=buff.trick_shots.remains>=execute_time&(buff.precise_shots.down|full_recharge_time<cast_time+gcd|buff.trueshot.up)
    if cast.able.aimedShot(var.lowestAimedSerpentSting) and not unit.moving(units.player) and unit.ttd(units.units.dyn40) > cast.time.aimedShot() and buff.trickShots.remains() >= cast.time.aimedShot()
        and (not buff.preciseShots.exists() or charges.aimedShot.timeTillFull() < cast.time.aimedShot() + unit.gcd(true) or buff.trueshot.exists())
    then
        return cast.aimedShot(var.lowestAimedSerpentSting)
    end
    -- Death Chakram
    -- death_chakram,if=focus+cast_regen<focus.max
    if dCovenant.value == 1 or (dCovenant.value == 2 and buff.trueshot.exists()) and cast.able.deathChakram() and power.focus.amount() + cast.regen.deathChakram() < power.focus.max() then
        return cast.deathChakram()
    end
    -- Rapid Fire
    -- rapid_fire,if=buff.trick_shots.remains>=execute_time
    if cast.able.rapidFire() and buff.trickShots.remains() >= cast.time.rapidFire() and unit.ttd(units.units.dyn40) > cast.time.rapidFire() then
        return cast.rapidFire()
    end
    -- Multishot
    -- multishot,if=buff.trick_shots.down|buff.precise_shots.up&focus>cost+action.aimed_shot.cost&(!talent.chimaera_shot|active_enemies>3)
    if cast.able.multishot() and (not buff.trickShots.exists() or buff.preciseShots.exists()
        and power.focus.amount() > cast.cost.multishot() + cast.cost.aimedShot() and (not talent.chimaeraShot or #units.enemies.yards8t > 3))
        and #units.enemies.yards8t > 0
    then
        return cast.multishot()
    end
    -- Chimaera Shot
    -- chimaera_shot,if=buff.precise_shots.up&focus>cost+action.aimed_shot.cost&active_enemies<4
    if cast.able.chimaeraShot() and buff.preciseShots.exists() and power.focus.amount() > cast.cost.chimaeraShot() + cast.cost.aimedShot() and #units.enemies.yards8t < 4 then
        return cast.chimaeraShot()
    end
    -- kill_shot,if=buff.dead_eye.down
    for i=1, #units.enemies.get(40,_,_,false,true) do
        local thisUnit = units.enemies.get(40,_,_,true)[i]
        if dKillShot.value == 1 or (dKillShot.value == 2 and unit.isUnit(thisUnit,units.target)) then
            if cast.able.killShot(thisUnit) and unit.hp(thisUnit) < 20 and buff.deadEye.exists() then
                return cast.killShot(thisUnit)
            end
        end
    end
    -- Flayed Shot
    -- flayed_shot
    if (dCovenant.value == 1 or (dCovenant.value == 2 and buff.trueshot.exists())) and cast.able.flayedShot() then
        return cast.flayedShot()
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:dot.serpent_sting.remains,if=refreshable
    if cast.able.serpentSting(var.lowestSerpentSting) and talent.serpentSting and debuff.serpentSting.refresh(var.lowestSerpentSting) then
        return cast.serpentSting(var.lowestSerpentSting)
    end
    -- Multishot
    -- multishot,if=focus>cost+action.aimed_shot.cost
    if cast.able.multishot() and power.focus.amount() > cast.cost.multishot() + cast.cost.aimedShot() and #units.enemies.yards8t > 0 then
        return cast.multishot()
    end
    -- Steady Shot
    -- steady_shot
    if cast.able.steadyShot() and unit.ttd(units.units.dyn40) > cast.time.steadyShot() and power.focus.amount() <= cast.cost.arcaneShot() + cast.cost.aimedShot() then
        return cast.steadyShot()
    end
end -- End Action List - aoe

-- Action List - Extras
actionList.extra = function()
    -- Feign Death
    if buff.feignDeath.exists() then
        br._G.StopAttack()
        br._G.ClearTarget()
    end
    -- Hunter's Mark
    if cHuntersMark.value and cast.able.huntersMark() and not debuff.huntersMark.exists(units.units.dyn40) then
        if dHuntersMark == 1 or (dHuntersMark == 2 and unit.isBoss(units.target)) then
            return cast.huntersMark()
        end
    end
    --  FlayedWignToxin
    if use.able.bottledFlayedWingToxin() and not buff.flayedWingToxin.exists(units.player) then
        use.bottledFlayedWingToxin()
    end
    --Dummy Test
    if cDummy.value then
        if unit.exists(units.target) then
            if br.getCombatTime() >= (tonumber(sDummy.value)*60) and unit.isDummy() then
                br._G.StopAttack()
                br._G.ClearTarget()
                br._G.PetStopAttack()
                br._G.PetFollow()
                br._G.print(tonumber(sDummy.value) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Healing thingies
    module.BasicHealing()
    if cTurtle.value and unit.hp() <= sTurtle.value then
        return cast.aspectOfTheTurtle(units.player)
    end
    if cExhilaration.value and unit.hp() <= sExhilaration.value then
        return cast.exhilaration(units.player)
    end
    -- Tranq
    if cTranq.value then
        for i=1, #units.enemies.get(40,_,_,true) do
            local thisUnit = units.enemies.get(40,_,_,true)[i]
            if dTranq.value == 1 or (dTranq.value == 2 and unit.isUnit(thisUnit,units.target)) then
                if unit.valid(thisUnit) and cast.dispel.tranquilizingShot(thisUnit) then
                    return cast.tranquilizingShot(thisUnit)
                end
            end
        end
    end
end -- End Action List - Extras

-- Action List - CCs
actionList.CCs = function()
    if ui.mode.cC == 1 then
        if br.getCurrentZoneId() == maps.instanceIDs.CastleNathria then
            if cHuntsman.value then
                if not isFreezingTrapActive() then
                    return cast.freezingTrap(ccMobFinder(171557),castLocations.groundCC)
                end
            end
        end
        if br.getCurrentZoneId() == maps.instanceIDs.Plaguefall then
            if cGlobgrog.value then
                if not isFreezingTrapActive() then
                    return cast.freezingTrap(ccMobFinder(171887),castLocations.groundCC)
                end
            end
            if cDefender.value then
                if not isFreezingTrapActive() then
                    return cast.freezingTrap(ccMobFinder(163862,_,336449),castLocations.groundCC)
                end
            end
            if cSlimeclaw.value then
                return cast.bindingShot(ccMobFinder(163892,25),castLocations.groundCC)
            end
        end
        if br.getCurrentZoneId() == maps.instanceIDs.MistsOfTirnaScithe then
            if cMistcaller.value then
                if not isFreezingTrapActive() then
                    return cast.freezingTrap(ccMobFinder(165251),castLocations.groundCC)
                end
            end
        end
        if br.getCurrentZoneId() == maps.instanceIDs.TheNecroticWake then
            if cBlightbone.value then
                return cast.bindingShot(ccMobFinder(164702),castLocations.groundCC)
            end
        end
        if br.getCurrentZoneId() == maps.instanceIDs.TheaterOfPain then
            if cRefuse.value then
                return cast.bindingShot(ccMobFinder(163089),castLocations.groundCC)
            end
        end
        if br.getCurrentZoneId() == maps.instanceIDs.HallsOfAtonement then
            if cGorgon.value then
                return cast.bindingShot(ccMobFinder(164563,_,326450),castLocations.groundCC)
            end
        end
    end
end -- End Action List - CCs

-- Action List - Interrupts
actionList.kick = function()
    if br.player.interrupts == nil then br.player.interrupts = {} end
	if br.useInterrupts() then
        br.player.interrupts.enabled = true
    else
        br.player.interrupts.enabled = false
    end
	if not br.player.interrupts.enabled then return end
	if br.player.interrupts.activeList == nil then br.player.interrupts.activeList = {} end
    br.player.interrupts.listUpdated = true

    -- Form activeList for interrupting
    checkForUpdates()
    if not br.player.interrupts.listUpdated then
		if cInterruptBr.value then
            for spellID,v in pairs(br.lists.interruptWhitelist) do
                table.insert(br.player.interrupts.activeList, spellID, v)
			end
		else
			for spellID,_ in pairs(br.lists.interruptWhitelist) do
				if not br.isTableEmpty(br.player.interrupts.activeList) then
					br.player.interrupts.activeList[spellID] = false
				end
			end
		end
        if eInterruptPersonal.value ~= nil then
            for spellID in string.gmatch(tostring(eInterruptPersonal.value),"([^,]+)") do
                if string.len(string.trim(spellID)) >= 3 then
                    table.insert(br.player.interrupts.activeList, tonumber(spellID), true)
                end
            end
		else
			for spellID in string.gmatch(tostring(eInterruptPersonal.value),"([^,]+)") do
				if not br.isTableEmpty(br.player.interrupts.activeList) and tonumber(spellID) then
					br.player.interrupts.activeList[tonumber(spellID)] = false
				end
			end
		end
        oldvalueBr = cInterruptBr.value
        oldValuePersonal = eInterruptPersonal.value
        br.player.interrupts.listUpdated = true
    end

    -- Do the actual interrupting
	if br.player.spell.interrupts == nil then return end -- If no interruptspells are given, get the hell outta here
	local interruptAt = 100 - sInterruptsAt.value

	for _,v in pairs(br.player.spell.interrupts) do
		if br.canCast(v)then
			if br.getOptionCheck("Interrupt with " .. GetSpellInfo(v)) then
				br.player.interrupts.currentSpell = v
				break
			else
				return
			end
		end
    end


    for i=1, #units.enemies.yards40f do
        local theUnit = units.enemies.yards40f[i]
        if cInterruptAll.value then
            if br.castingUnit(theUnit) and br.canInterrupt(theUnit, interruptAt) then
                if br.castingUnit(units.player) then br._G.RunMacroText("/stopcasting") end
                local castSuccess = br.createCastFunction(theUnit, _, _, _, br.player.interrupts.currentSpell)
                if castSuccess then
                    lastUnit = theUnit
                    return true
                end
            end
        end
        for id, active in pairs(br.player.interrupts.activeList) do
            if active and br.isCastingSpell(id, theUnit) and br.canInterrupt(theUnit) then
                br.player.interrupts.currentUnit = theUnit
                br.player.interrupts.unitSpell = id
            end
        end
    end

	if br.isInCombat(units.player) and br.player.interrupts.currentUnit ~= nil and br.player.interrupts.unitSpell ~= nil and br.player.interrupts.currentSpell ~= nil then
		if br.isCastingSpell(br.player.interrupts.unitSpell, br.player.interrupts.currentUnit) and br.canInterrupt(br.player.interrupts.currentUnit, interruptAt) then
			if (getTimeToLastInterrupt() >= 1 and br.GetObjectID(lastUnit) == br.GetObjectID(br.player.interrupts.currentUnit)) or
		      (getTimeToLastInterrupt() < 1 and br.GetObjectID(lastUnit) ~= br.GetObjectID(br.player.interrupts.currentUnit)) then
                if br.castingUnit(units.player) then br._G.RunMacroText("/stopcasting") end
				if br.createCastFunction(br.player.interrupts.currentUnit, _, _, _, br.player.interrupts.currentSpell) then
					br.addonDebug("Casting ", tostring(GetSpellInfo(br.player.interrupts.currentSpell)))
					lastUnit = br.player.interrupts.currentUnit
				end

			end
		end
	end
end  -- End Action List - Interrupts

-- Action List - Misdirection
actionList.md = function(skipModecheck)
    if ui.mode.misdirection == 1 or skipModecheck then
        local misdirectUnit = nil
        if unit.distance(units.target) < 40 and not unit.isCasting(units.player) then
            -- Misdirect to Tank
            if dMisdirection.value == 1 then
                local tankInRange, tankUnit = br.isTankInRange()
                if tankInRange then misdirectUnit = tankUnit end
            end
            -- Misdirect to Focus
            if dMisdirection.value == 2 and unit.friend("focus",units.player) then
                misdirectUnit = "focus"
            end
            -- Misdirect to Pet
            if dMisdirection.value == 3 then
                misdirectUnit = "pet"
            end
            -- Failsafe to Pet, if unable to misdirect to Tank or Focus
            if misdirectUnit == nil then misdirectUnit = "pet" end
            if misdirectUnit and cast.able.misdirection() and unit.exists(misdirectUnit) and unit.distance(misdirectUnit) < 40 and not unit.deadOrGhost(misdirectUnit) then
                return cast.misdirection(misdirectUnit)
            end
        end
    end
end -- End Action List - Misdireciton

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------
    --- Defines ---
    ---------------
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    covenant                                      = br.player.covenant
    debuff                                        = br.player.debuff
    units.enemies                                 = br.player.enemies
    equiped                                       = br.player.equiped
    module                                        = br.player.module
    power                                         = br.player.power
    runeforge                                     = br.player.runeforge
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    items                                         = br.player.items
    ui                                            = br.player.ui
    unit                                    = br.player.unit
    units.units                                   = br.player.units
    use                                           = br.player.use
    var                                           = br.player.variables
    inventory = inventory --update inventory ;)

    -- Get required units.enemies table
    units.units.get(40)
    units.enemies.get(8,units.target)
    units.enemies.get(8,units.target,_,true)
    units.enemies.get(8,units.target,true)
    units.enemies.get(40,nil,false,true)

    -- Variables
    if var.profileStop == nil then var.profileStop = false end
    var.haltProfile = (unit.inCombat() and var.profileStop) or (unit.mounted() or unit.flying()) or ui.pause() or buff.feignDeath.exists() or ui.mode.rotation==4

    -- Aimed Shots Serpent Sting spread
    var.lowestSerpentSting = debuff.serpentSting.lowest(40,"remain") or units.target
    var.serpentInFlight = cast.inFlight.serpentSting() and 1 or 0
    var.lowestAimedSerpentSting = units.target
    var.lowestAimedRemain = 99
    var.lowestHPUnit = units.target
    var.lowestHP = 100
    for i = 1, #units.enemies.yards8tf do
        local thisUnit = units.enemies.yards8tf[i]
        local thisHP = unit.hp(thisUnit)
        local serpentStingRemain = debuff.serpentSting.remain(thisUnit) + var.serpentInFlight * 99
        if ui.mode.rotation < 3 and serpentStingRemain < var.lowestAimedRemain then
            var.lowestAimedRemain = serpentStingRemain
            var.lowestAimedSerpentSting = thisUnit
        end
        if thisHP < var.lowestHP then
            var.lowestHP = thisHP
            var.lowestHPUnit = thisUnit
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists(units.target) and var.profileStop then
        var.profileStop = false
    elseif var.haltProfile and (not unit.isCasting() or ui.pause(true)) then
        br._G.StopAttack()
        return true
    else
        if actionList.extra() then return true end
        if actionList.pc() then return true end
        -- IN COMBAT
        if unit.inCombat() and var.profileStop == false and unit.valid(units.units.dyn40) and unit.distance(units.units.dyn40) < 40
            and not cast.current.barrage() and not cast.current.rapidFire() and not cast.current.aimedShot() and not cast.current.steadyShot()
        then
            if actionList.CCs() then return true end
            if actionList.kick() then return true end
            if actionList.md(false) then return true end
            if actionList.aa() then return true end
            if actionList.cds() then return true end
            if ui.useST(8,nil,units.target) then
                return actionList.st()
            end
            if ui.useAOE(8,3,units.target) then
                return actionList.aoe()
            end
        end --End In Combat
    end --End Rotation Logic
end -- End runRotation
local id = 254
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})