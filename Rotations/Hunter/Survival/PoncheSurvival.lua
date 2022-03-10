local rotationName = "Ponche"
br.loadSupport("PetCuteOne")

--Toggles
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.serpentSting },
        [2] = { mode = "Sing", value = 2 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.raptorStrike },
        [3] = { mode = "Off", value = 3 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.exhilaration}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.coordinatedAssault },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.coordinatedAssault },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.coordinatedAssault }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.aspectOfTheTurtle },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.aspectOfTheTurtle }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.muzzle },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.muzzle }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
    -- Harpoon Button
    local HarpoonModes = {
        [1] = { mode = "On", value = 1 , overlay = "Harpoon / Flanking Strike - Enabled", tip = "Will cast Harpoon / Flanking Strike.", highlight = 1, icon = br.player.spell.harpoon },
        [2] = { mode = "Off", value = 2 , overlay = "Harpoon / Flanking Strike - Disabled", tip = "Will NOT cat Harpoon / Flanking Strike.", highlight = 0, icon = br.player.spell.harpoon }
    };
    br.ui:createToggle(HarpoonModes,"Harpoon",5,0)
    -- MD Button
    local MisdirectionModes = {
        [1] = { mode = "On", value = 1 , overlay = "Misdirection Enabled", tip = "Misdirection Enabled", highlight = 1, icon = br.player.spell.misdirection },
        [2] = { mode = "Off", value = 2 , overlay = "Misdirection Disabled", tip = "Misdirection Disabled", highlight = 0, icon = br.player.spell.misdirection }
    };
    br.ui:createToggle(MisdirectionModes,"Misdirection",6,0)
    -- Pet summon
    local PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spell.callPet1 },
        [2] = { mode = "2", value = 2 , overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spell.callPet2 },
        [3] = { mode = "3", value = 3 , overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spell.callPet3 },
        [4] = { mode = "4", value = 4 , overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spell.callPet4 },
        [5] = { mode = "5", value = 5 , overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spell.callPet5 },
        [6] = { mode = "None", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.callPet }
    };
    br.ui:createToggle(PetSummonModes,"PetSummon",7,0)
    -- Aspect of the Eagle
    local aotEModes = {
        [1] = { mode = "On", value = 1 , overlay = "Aspect of the Eagle Enabled", tip = "Aspect of the Eagle Enabled", highlight = 1, icon = br.player.spell.aspectOfTheEagle },
        [2] = { mode = "Off", value = 2 , overlay = "Aspect of the Eagle Disabled", tip = "Aspect of the Eagle Disabled", highlight = 0, icon = br.player.spell.aspectOfTheEagle }
    };
    br.ui:createToggle(aotEModes,"aotE",8,0)
    -- CC
    local CCModes = {
        [1] = { mode = "On", value = 1 , overlay = "CC Enabled", tip = "CC Enabled", highlight = 1, icon = br.player.spell.freezingTrap },
        [2] = { mode = "Off", value = 2 , overlay = "CC Disabled", tip = "CC Disabled", highlight = 0, icon = br.player.spell.freezingTrap }
    };
    br.ui:createToggle(CCModes,"CC",9,0)
end

--Options
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdAoENever = {"Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never"}
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- Misdirection
            br.ui:createDropdownWithout(section,"Misdirection", {"|cff00FF00Tank","|cffFFFF00Focus","|cffFF0000Pet"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
        br.ui:checkSectionState(section)
        -- Pet Options
        br.rotations.support["PetCuteOne"].options()
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Basic Trinkets Module
            br.player.module.BasicTrinkets(nil,section)
            -- Covenant
            br.ui:createDropdownWithout(section,"Covenant Ability", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use ability.")
            -- A Murder of Crows
            br.ui:createDropdownWithout(section,"A Murder of Crows", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use ability.")
            -- Aspect of the Eagle
            br.ui:createDropdownWithout(section,"Aspect of the Eagle", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use ability.")
            -- Coordinated Assault
            br.ui:createDropdownWithout(section,"Coordinated Assault", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use ability.")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Aspect Of The Turtle
            br.ui:createSpinner(section, "Aspect Of The Turtle",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Exhilaration
            br.ui:createSpinner(section, "Exhilaration",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
            -- Feign Death
            br.ui:createSpinner(section, "Feign Death", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Intimidation
            br.ui:createSpinner(section, "Intimidation", 35, 0, 100, 5,  "|cffFFBB00Health Percentage to use at.")
            -- Tranquilizing Shot
            br.ui:createDropdown(section, "Tranquilizing Shot", {"|cff00FF00Any","|cffFFFF00Target"}, 2,"|cffFFFFFFHow to use Tranquilizing Shot.")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Freezing Trap
            br.ui:createCheckbox(section,"Freezing Trap")
            -- Intimidation
            br.ui:createCheckbox(section,"Intimidation - Int")
            -- Muzzle
            br.ui:createCheckbox(section,"Muzzle")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- CCs Options
        section = br.ui:createSection(br.ui.window.profile, "CCs")
            br.ui:createText(section, "Dungeon boss mechanics")
            cMistcaller = br.ui:createCheckbox(section, "Mists of Tirna Scithe (Mistcaller - Illusionary Vulpin)", "Cast Freezing Trap on Illusionary Vulpin")
            cGlobgrog = br.ui:createCheckbox(section,"Plaguefall (Globgrog - Slimy Smorgasbord)", "Cast Freezing Trap on Slimy Smorgasbord")
            cBlightbone =br.ui:createCheckbox(section,"The Necrotic Wake (Blightbone  - Carrion Worms)", "Cast Binding Shot on Carrion Worms")
            br.ui:createText(section, "Dungeon trash mechanics")
            cGorgon = br.ui:createCheckbox(section,"Halls of Atonement (Vicious Gargon, Loyal Beasts)", "Cast Binding Shot on Vicious Gargon with Loyal Beasts")
            cDefender = br.ui:createCheckbox(section,"Plaguefall (Defender of Many Eyes, Bulwark of Maldraxxus)", "Cast Freezing Trap on Defender of Many Eyes with Bulwark of Maldraxxus")
            cSlimeclaw = br.ui:createCheckbox(section,"Plaguefall (Rotting Slimeclaw)", "Cast Binding Shot on Rotting Slimeclaw with 20% hp")
            cRefuse = br.ui:createCheckbox(section,"Theater of Pain (Disgusting Refuse)", "Cast Binding Shot on Disgusting Refuse to avoid jumping around")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  6)
            -- Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  6)
            -- Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

-- Locals
--local anima
local buff
local cast
local cd
local charges
local debuff
local enemies
local focus
local focusMax
--local focusRegen
--local gcd
--local level
local maps = br.lists.maps
local module
--local opener
local runeforge
local spell
local talent
local ui
local unit
local units
local var

local actionList = {}

--Functions
local function eagleScout()
    if buff.aspectOfTheEagle.exists() then
        return #enemies.yards40
    else
        return #enemies.yards8
    end
end

local function nextBomb(nextBomb)
    local _,_,currentBomb = br._G.GetSpellInfo(spell.wildfireBomb)
    local _,_,shrapnelBomb = br._G.GetSpellInfo(spell.shrapnelBomb)
    local _,_,volatileBomb = br._G.GetSpellInfo(spell.volatileBomb)
    local _,_,pheromoneBomb = br._G.GetSpellInfo(spell.pheromoneBomb)
    if talent.wildfireInfusion and nextBomb ~= nil then
        if currentBomb == shrapnelBomb then return nextBomb == spell.shrapnelBomb end -- spell.volatileBomb
        if currentBomb == volatileBomb then return nextBomb == spell.volatileBomb end -- spell.pheromoneBomb
        if currentBomb == pheromoneBomb then return nextBomb == spell.pheromoneBomb end -- spell.shrapnelBomb
    else
        return nextBomb == spell.wildfireBomb
    end
    return currentBomb == nextBomb
end

local function isFreezingTrapActive()
    for i = 1, #enemies.yards40f do
        local thisUnit = enemies.yards40f[i]
        if debuff.freezingTrap.exists(thisUnit, units.player) then
            return true
        end
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

    for i = 1, #enemies.yards40f do
        local thisUnit = enemies.yards40f[i]
        foundMatch = 0
        if not br.isLongTimeCCed(thisUnit) then
            if id ~= nil then
                if unit.id(thisUnit) == id then
                    foundMatch = foundMatch + 1
                end
            end
            if minHP ~= nil then
                if minHP <= unit.hp(thisUnit) then
                    foundMatch = foundMatch + 1
                end
            end
            if spellID ~= nil then
                if br.getDebuffDuration(thisUnit, spellID,units.player) > 0 then
                    foundMatch = foundMatch + 1
                end
            end
            if foundMatch == arguments then return thisUnit end
        end
    end
end

--Kill Shot
actionList.killShot = function()
    for i = 1, #enemies.yards40 do
        thisUnit = enemies.yards40[i]
        if cast.able.killShot(thisUnit) and unit.hp(thisUnit) < 20 then
            if cast.killShot(thisUnit) then return true end
        end
    end
    return false
end


--CCs
actionList.CCs = function()
    if ui.mode.cC == 2 then
        return false
    end

    if br.getCurrentZoneId() == maps.instanceIDs.Plaguefall then
        if cast.able.freezingTrap() and not isFreezingTrapActive() then
            if cGlobgrog.value then
                if cast.freezingTrap(ccMobFinder(171887), "groundCC") then return true end
            end
            if cDefender.value then
                if cast.freezingTrap(ccMobFinder(163862, _, 336449), "groundCC") then return true end
            end
        end
        if cSlimeclaw.value and talent.bindingShot and cast.able.bindingShot() then
            if cast.bindingShot(ccMobFinder(163892, 25), "groundCC") then return true end
        end
    end
    if br.getCurrentZoneId() == maps.instanceIDs.MistsOfTirnaScithe then
        if cMistcaller.value and cast.able.freezingTrap() then
            if cast.freezingTrap(ccMobFinder(165251), "groundCC") then return true end
        end
    end
    if br.getCurrentZoneId() == maps.instanceIDs.TheNecroticWake then
        if cBlightbone.value and talent.bindingShot and cast.able.bindingShot() then
            if cast.bindingShot(ccMobFinder(164702), "groundCC") then return true end
        end
    end
    if br.getCurrentZoneId() == maps.instanceIDs.TheaterOfPain then
        if cRefuse.value and talent.bindingShot and cast.able.bindingShot() then
            if cast.bindingShot(ccMobFinder(163089), "groundCC") then return true end
        end
    end
    if br.getCurrentZoneId() == maps.instanceIDs.HallsOfAtonement then
        if cGorgon.value and talent.bindingShot and cast.able.bindingShot() then
            if cast.bindingShot(ccMobFinder(164563, _, 326450), "groundCC") then return true end
        end
    end
    return false
end

--Defensive
actionList.Defensive = function()
    if not ui.useDefensive() then
        return false
    end
    -- Basic Healing Module
    module.BasicHealing()
    -- Aspect of the Turtle
    if ui.checked("Aspect Of The Turtle") and cast.able.aspectOfTheTurtle() and unit.hp() <= ui.value("Aspect Of The Turtle") and unit.inCombat() then
        if cast.aspectOfTheTurtle("player") then return true end
    end
    -- Exhilaration
    if ui.checked("Exhilaration") and cast.able.exhilaration() and unit.hp() <= ui.value("Exhilaration") then
        if cast.exhilaration("player") then return true end
    end
    -- Feign Death
    if ui.checked("Feign Death") and cast.able.feignDeath() and unit.hp() <= ui.value("Feign Death") and unit.inCombat() then
        if cast.able.playDead() then
            if cast.playDead() then return true end
        end
        if cast.feignDeath("player") then return true end
    end
    -- Intimidation
    if ui.checked("Intimidation") and cast.able.intimidation() and unit.hp() <= ui.value("Intimidation") then
        if cast.intimidation(units.dyn5p) then return true end
    end
    -- Tranquilizing Shot
    if ui.checked("Tranquilizing Shot") then
        if #enemies.yards40f > 0 then
            for i = 1, #enemies.yards40f do
                local thisUnit = enemies.yards40f[i]
                if ui.value("Tranquilizing Shot") == 1 or (ui.value("Tranquilizing Shot") == 2 and unit.isUnit(thisUnit,"target")) then
                    if unit.valid(thisUnit) and cast.dispel.tranquilizingShot(thisUnit) then
                        if cast.tranquilizingShot(thisUnit) then return true end
                    end
                end
            end
        end
    end
    return false
end

--Interrupt
actionList.Interrupt = function()
    if not ui.useInterrupt() then
        return false
    end
    local thisUnit
    -- Muzzle
    if ui.checked("Muzzle") and cast.able.muzzle() then
        for i=1, #enemies.yards5 do
            thisUnit = enemies.yards5[i]
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                if cast.muzzle(thisUnit) then return true end
            end
        end
    end
    -- Freezing Trap
    if ui.checked("Freezing Trap") and cast.able.freezingTrap() then
        for i = 1, #enemies.yards40 do
            thisUnit = enemies.yards40[i]
            if unit.distance(thisUnit) > 8 and cast.timeRemain(thisUnit) > 3 then
                if cast.freezingTrap(thisUnit,"ground") then return true end
            end
        end
    end
    -- Intimidation
    if ui.checked("Intimidation - Int") and cast.able.intimidation() then
        for i=1, #enemies.yards5 do
            thisUnit = enemies.yards5[i]
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                if cast.intimidation(thisUnit) then return true end
            end
        end
    end
    return false
end

--Cooldowns
actionList.Cooldown = function()
    --actions.cds=harpoon,if=talent.terms_of_engagement.enabled&focus<focus.max
    if ui.mode.harpoon == 1 and cast.able.harpoon("target") and talent.termsOfEngagement and focus < focusMax then
        if cast.harpoon("target") then return true end
    end
    --actions.cds+=/blood_fury,if=buff.coordinated_assault.up
    --actions.cds+=/ancestral_call,if=buff.coordinated_assault.up
    --actions.cds+=/fireblood,if=buff.coordinated_assault.up
    --actions.cds+=/lights_judgment
    --actions.cds+=/bag_of_tricks,if=cooldown.kill_command.full_recharge_time>gcd
    --actions.cds+=/berserking,if=buff.coordinated_assault.up|time_to_die<13
    if ui.checked("Racial") and cast.able.racial() then
        if buff.coordinatedAssault.exists() and (unit.race() == "Orc" or unit.race() == "MagharOrc" or unit.race() == "DarkIronDwarf") then
            if cast.racial("player") then return true end
        end
        if unit.race() == "LightforgedDraenei" then
            if cast.racial("target","ground") then return true end
        end
        if unit.race() == "Vulpera" and charges.killCommand.timeTillFull() > unit.gcd(true) then
            if cast.racial("target") then return true end
        end
        if unit.race() == "Troll" and (buff.coordinatedAssault.exists() or unit.ttd(units.dyn5) < 13) then
            if cast.racial("player") then return true end
        end
    end
    --actions.cds+=/muzzle
    --TODO actions.cds+=/potion,if=target.time_to_die<25|buff.coordinated_assault.up
    --TODO actions.cds+=/fleshcraft,cancel_if=channeling&!soulbind.pustule_eruption,if=(focus<70|cooldown.coordinated_assault.remains<gcd)&(soulbind.pustule_eruption|soulbind.volatile_solvent)
    --TODO actions.cds+=/tar_trap,if=focus+cast_regen<focus.max&runeforge.soulforge_embers.equipped&tar_trap.remains<gcd&cooldown.flare.remains<gcd&(active_enemies>1|active_enemies=1&time_to_die>5*gcd)
    --TODO actions.cds+=/flare,if=focus+cast_regen<focus.max&tar_trap.up&runeforge.soulforge_embers.equipped&time_to_die>4*gcd
    --actions.cds+=/kill_shot,if=active_enemies=1&target.time_to_die<focus%(variable.mb_rs_cost-cast_regen)*gcd
    if cast.able.killShot("target") and unit.hp("target") < 20 and #enemies.yards40 == 1 and unit.ttd(units.dyn40) < focus / (cast.cost.mongooseBite() - cast.regen.killShot()) * unit.gcd(true) then
        if cast.killShot() then return true end
    end
    --actions.cds+=/mongoose_bite,if=active_enemies=1&target.time_to_die<focus%(variable.mb_rs_cost-cast_regen)*gcd
    if talent.mongooseBite and cast.able.mongooseBite() and #var.eagleEnemies == 1 and unit.ttd("target") < focus / (cast.cost.mongooseBite() - cast.regen.mongooseBite()) * unit.gcd(true) then
        if cast.mongooseBite() then return true end
    end
    --actions.cds+=/raptor_strike,if=active_enemies=1&target.time_to_die<focus%(variable.mb_rs_cost-cast_regen)*gcd
    if not talent.mongooseBite and cast.able.raptorStrike() and #var.eagleEnemies == 1 and unit.ttd("target") < focus / (cast.cost.raptorStrike() - cast.regen.raptorStrike()) * unit.gcd(true) then
        if cast.raptorStrike() then return true end
    end
    --actions.cds+=/aspect_of_the_eagle,if=target.distance>=6
    if ui.mode.aotE == 1 and ui.alwaysCdAoENever("Aspect of the Eagle",3,#enemies.yards40) and cast.able.aspectOfTheEagle() and unit.distance("target") >= 6 and unit.standingTime() >= 2 and unit.combatTime() >= 5 then
        if cast.aspectOfTheEagle() then return true end
    end
    return false
end

--Nta
actionList.Nta = function()
    --actions.nta=steel_trap
    if cast.able.steelTrap("player","ground",1,5) then
        if cast.steelTrap("player","ground",1,5) then return true end
    end
    --actions.nta+=/freezing_trap,if=!buff.wild_spirits.remains|buff.wild_spirits.remains&cooldown.kill_command.remains
    --actions.nta+=/tar_trap,if=!buff.wild_spirits.remains|buff.wild_spirits.remains&cooldown.kill_command.remains
    return false
end

--Cleave
actionList.Cleave = function()
    --actions.cleave=serpent_sting,target_if=min:remains,if=talent.hydras_bite.enabled&buff.vipers_venom.remains&buff.vipers_venom.remains<gcd
    if talent.hydrasBite and cast.able.serpentSting(var.lowestSerpentSting) and buff.vipersVenom.exists() and buff.vipersVenom.remains() < unit.gcd(true) then
        if cast.serpentSting(var.lowestSerpentSting) then return true end
    end
    --actions.cleave+=/wild_spirits,if=!raid_event.adds.exists|raid_event.adds.remains>=10|active_enemies>=raid_event.adds.count*2
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.wildSpirits("best",nil,var.spiritUnits,12) then
        if cast.wildSpirits("best",nil,var.spiritUnits,12) then return true end
    end
    --actions.cleave+=/resonating_arrow,if=!raid_event.adds.exists|raid_event.adds.remains>=8|active_enemies>=raid_event.adds.count*2
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.resonatingArrow("best",nil,1,15) then
        if cast.resonatingArrow("best",nil,1,15) then return true end
    end
    --actions.cleave+=/coordinated_assault,if=!raid_event.adds.exists|raid_event.adds.remains>=10|active_enemies>=raid_event.adds.count*2
    if ui.alwaysCdAoENever("Coordinated Assault",3,#var.eagleEnemies) and cast.able.coordinatedAssault() and unit.distance("target") < 5 then
        if cast.coordinatedAssault() then return true end
    end
    --actions.cleave+=/wildfire_bomb,if=full_recharge_time<gcd
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and charges.wildfireBomb.timeTillFull() < unit.gcd(true) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then return true end
    end
    --actions.cleave+=/death_chakram,if=(!raid_event.adds.exists|raid_event.adds.remains>5|active_enemies>=raid_event.adds.count*2)|focus+cast_regen<focus.max&!runeforge.bag_of_munitions.equipped
    if ui.alwaysCdAoENever("Covenany Ability",3,#enemies.yards8t) and cast.able.deathChakram() and focus + cast.regen.deathChakram() < focusMax and not runeforge.bagOfMunitions.equiped then
        if cast.deathChakram() then return true end
    end
    --actions.cleave+=/call_action_list,name=nta,if=runeforge.nessingwarys_trapping_apparatus.equipped&focus<variable.mb_rs_cost
    if runeforge.nesingwarysTrappingApparatus.equiped and focus < cast.cost.mongooseBite() then
        if actionList.Nta() then return true end
    end
    --actions.cleave+=/chakrams
    if ui.alwaysCdAoENever("Covenany Ability",3,#enemies.yards8t) and cast.able.deathChakram() then
        if cast.chakrams() then return true end
    end
    --actions.cleave+=/butchery,if=dot.shrapnel_bomb.ticking&(dot.internal_bleeding.stack<2|dot.shrapnel_bomb.remains<gcd)
    if talent.butchery and cast.able.butchery("player","aoe",1,8) and debuff.shrapnelBomb.exists("target") and (debuff.internalBleeding.stack() < 2 or debuff.shrapnelBomb.remain("target") < unit.gcd(true)) then
        if cast.butchery("player","aoe",1,8) then return true end
    end
    --actions.cleave+=/carve,if=dot.shrapnel_bomb.ticking&!set_bonus.tier28_2pc
    if not talent.butchery and cast.able.carve("player","cone",1,8) and debuff.shrapnelBomb.exists("target") and not var.hasTierBonus then
        if cast.carve("player","cone",1,8) then return true end
    end
    --actions.cleave+=/butchery,if=charges_fractional>2.5&cooldown.wildfire_bomb.full_recharge_time>spell_targets%2
    if talent.butchery and cast.able.butchery("player","aoe",1,8) and charges.butchery.frac() > 2.5 and charges.wildfireBomb.timeTillFull() > #enemies.yards8t / 2 then
        if cast.butchery("player","aoe",1,8) then return true end
    end
    --actions.cleave+=/flanking_strike,if=focus+cast_regen<focus.max
    if ui.mode.harpoon == 1 and talent.flankingStrike and cast.able.flankingStrike() and unit.distance("pet",units.dyn15) < 15 and focus + cast.regen.flankingStrike() < focusMax then
        if cast.flankingStrike() then return true end
    end
    --actions.cleave+=/carve,if=cooldown.wildfire_bomb.full_recharge_time>spell_targets%2
    if not talent.butchery and cast.able.carve("player","cone",1,8) and charges.wildfireBomb.timeTillFull() > #enemies.yards8t / 2 then
        if cast.carve("player","cone",1,8) then return true end
    end
    --actions.cleave+=/wildfire_bomb,if=buff.mad_bombardier.up
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and buff.madBombardier.exists() then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then return true end
    end
    --actions.cleave+=/kill_command,target_if=dot.pheromone_bomb.ticking&set_bonus.tier28_2pc
    if cast.able.killCommand(var.pheromoneUnit) and unit.distance("pet", var.pheromoneUnit) < 50 and debuff.pheromoneBomb.exists(var.pheromoneUnit) and var.hasTierBonus then
        if cast.killCommand(var.pheromoneUnit) then return true end
    end
    --actions.cleave+=/kill_shot,if=buff.flayers_mark.up
    if cast.able.killShot("target") and buff.flayersMark.exists() then
        if cast.killShot("target") then return true end
    end
    --TODO (target_if=max:target.health.pct) actions.cleave+=/flayed_shot,target_if=max:target.health.pct
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards8t) and cast.able.flayedShot() then
        if cast.flayedShot() then return true end
    end
    --actions.cleave+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&full_recharge_time<gcd&(runeforge.nessingwarys_trapping_apparatus.equipped&cooldown.freezing_trap.remains&cooldown.tar_trap.remains|!runeforge.nessingwarys_trapping_apparatus.equipped)
    if  cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet", var.lowestBloodseeker) < 50 and focus + cast.regen.killCommand() < focusMax and charges.killCommand.timeTillFull() < unit.gcd(true) and (runeforge.nesingwarysTrappingApparatus.equiped and cd.freezingTrap.remain() > 0 and cd.tarTrap.remain() > 0 or not runeforge.nesingwarysTrappingApparatus.equiped) then
        if cast.killCommand(var.lowestBloodseeker) then return true end
    end
    --actions.cleave+=/wildfire_bomb,if=!dot.wildfire_bomb.ticking&!set_bonus.tier28_2pc|charges_fractional>1.3
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and (not debuff.wildfireBomb.exists(units.dyn40) and not var.hasTierBonus or charges.wildfireBomb.frac() > 1.3) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then return true end
    end
    --actions.cleave+=/butchery,if=(!next_wi_bomb.shrapnel|!talent.wildfire_infusion.enabled)&cooldown.wildfire_bomb.full_recharge_time>spell_targets%2
    if talent.butchery and cast.able.butchery("player","aoe",1,8) and (not nextBomb(spell.shrapnelBomb) or not talent.wildfireInfusion) and charges.wildfireBomb.timeTillFull() > #enemies.yards8t / 2 then
        if cast.butchery("player","aoe",1,8) then return true end
    end
    --actions.cleave+=/a_murder_of_crows
    if ui.alwaysCdAoENever("A Murder of Crows",3,#var.eagleEnemies) and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then return true end
    end
    --actions.cleave+=/steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap("player","ground",1,5) and focus + cast.regen.steelTrap() < focusMax then
        if cast.steelTrap("player","ground",1,5) then return true end
    end
    --actions.cleave+=/serpent_sting,target_if=min:remains,if=refreshable&talent.hydras_bite.enabled&target.time_to_die>8
    if talent.hydrasBite and cast.able.serpentSting(var.lowestSerpentSting) and debuff.serpentSting.refresh(var.lowestSerpentSting) and unit.ttd(var.lowestSerpentSting) > 8 then
        if cast.serpentSting(var.hydraUnit) then return true end
    end
    --actions.cleave+=/carve
    if not talent.butchery and cast.able.carve("player","cone",1,8) then
        if cast.carve("player","cone",1,8) then return true end
    end
    --actions.cleave+=/kill_shot
    if actionList.killShot() then return true end
    --actions.cleave+=/serpent_sting,target_if=min:remains,if=refreshable&target.time_to_die>8
    if cast.able.serpentSting(var.lowestSerpentSting) and debuff.serpentSting.refresh(var.lowestSerpentSting) and unit.ttd(var.lowestSerpentSting) > 8 then
        if cast.serpentSting(var.lowestSerpentSting) then return true end
    end
    --actions.cleave+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison) then
        if cast.mongooseBite(var.maxLatentPoison) then return true end
    end
    --actions.cleave+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison) then
        if cast.raptorStrike(var.maxLatentPoison) then return true end
    end
    return false
end

--St
actionList.St = function()
    --actions.st=death_chakram,if=focus+cast_regen<focus.max&(!raid_event.adds.exists|!raid_event.adds.up&raid_event.adds.duration+raid_event.adds.in<5)|raid_event.adds.up&raid_event.adds.remains>40
    if ui.alwaysCdAoENever("Covenany Ability",3,#enemies.yards8t) and cast.able.deathChakram() and focus + cast.regen.deathChakram() < focusMax then
        if cast.deathChakram() then return true end
    end
    --actions.st+=/serpent_sting,target_if=min:remains,if=!dot.serpent_sting.ticking&target.time_to_die>7|buff.vipers_venom.up&buff.vipers_venom.remains<gcd
    if cast.able.serpentSting(var.lowestSerpentSting) and (not debuff.serpentSting.exists(var.lowestSerpentSting) and unit.ttd(var.lowestSerpentSting) > 7 or buff.vipersVenom.exists() and buff.vipersVenom.remains() < unit.gcd(true)) then
        if cast.serpentSting(var.lowestSerpentSting) then return true end
    end
    --actions.st+=/flayed_shot
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards8t) and cast.able.flayedShot() then
        if cast.flayedShot() then return true end
    end
    --actions.st+=/resonating_arrow,if=!raid_event.adds.exists|!raid_event.adds.up&(raid_event.adds.duration+raid_event.adds.in<20|raid_event.adds.count=1)|raid_event.adds.up&raid_event.adds.remains>40|time_to_die<10
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.resonatingArrow("best",nil,1,15) then
        if cast.resonatingArrow("best",nil,1,15) then return true end
    end
    --actions.st+=/wild_spirits,if=!raid_event.adds.exists|!raid_event.adds.up&raid_event.adds.duration+raid_event.adds.in<20|raid_event.adds.up&raid_event.adds.remains>20|time_to_die<20
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.wildSpirits("best",nil,var.spiritUnits,12) then
        if cast.wildSpirits("best",nil,var.spiritUnits,12) then return true end
    end
    --actions.st+=/coordinated_assault,if=!raid_event.adds.exists|covenant.night_fae&cooldown.wild_spirits.remains|!covenant.night_fae&(!raid_event.adds.up&raid_event.adds.duration+raid_event.adds.in<30|raid_event.adds.up&raid_event.adds.remains>20|!raid_event.adds.up)|time_to_die<30
    if ui.alwaysCdAoENever("Coordinated Assault",3,#var.eagleEnemies) and cast.able.coordinatedAssault() then
        if cast.coordinatedAssault() then return true end
    end
    --actions.st+=/kill_shot
    if actionList.killShot() then return true end
    --actions.st+=/flanking_strike,if=focus+cast_regen<focus.max
    if ui.mode.harpoon == 1 and talent.flankingStrike and cast.able.flankingStrike() and unit.distance("pet", "target") < 15 and focus + cast.regen.flankingStrike() < focusMax then
        if cast.flankingStrike() then return true end
    end
    --actions.st+=/a_murder_of_crows
    if talent.aMurderOfCrows and ui.alwaysCdAoENever("A Murder of Crows",3,#var.eagleEnemies) and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then return true end
    end
    --actions.st+=/wildfire_bomb,if=full_recharge_time<2*gcd&set_bonus.tier28_2pc|buff.mad_bombardier.up|!set_bonus.tier28_2pc&(full_recharge_time<gcd|focus+cast_regen<focus.max&(next_wi_bomb.volatile&dot.serpent_sting.ticking&dot.serpent_sting.refreshable|next_wi_bomb.pheromone&!buff.mongoose_fury.up&focus+cast_regen<focus.max-action.kill_command.cast_regen*3)|time_to_die<10)
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and (charges.wildfireBomb.timeTillFull() < 2 * unit.gcd(true) and var.hasTierBonus or buff.madBombardier.exists() or not var.hasTierBonus and (charges.wildfireBomb.timeTillFull() < unit.gcd(true) or focus + cast.regen.wildfireBomb() < focusMax and (nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40) and debuff.serpentSting.refresh(units.dyn40) or nextBomb(spell.pheromoneBomb) and not buff.mongooseFury.exists() and focus + cast.regen.wildfireBomb() < focusMax - cast.regen.killCommand() * 3) or unit.ttd(units.dyn40) < 10)) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then return true end
    end
    --actions.st+=/kill_command,target_if=min:bloodseeker.remains,if=set_bonus.tier28_2pc&dot.pheromone_bomb.ticking&!buff.mad_bombardier.up
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet", var.lowestBloodseeker) < 50 and var.hasTierBonus and debuff.pheromoneBomb.exists(var.lowestBloodseeker) and not buff.madBombardier.exists() then
        if cast.killCommand(var.lowestBloodseeker) then return true end
    end
    --actions.st+=/carve,if=active_enemies>1&!runeforge.rylakstalkers_confounding_strikes.equipped
    if not talent.butchery and cast.able.carve("player","cone",1,8) and #enemies.yards8 > 1 and not runeforge.rylakstalkersConfoundingStrikes.equiped then
        if cast.carve("player","cone",1,8) then return true end
    end
    --TODO (Check) actions.st+=/butchery,if=active_enemies>1&!runeforge.rylakstalkers_confounding_strikes.equipped&cooldown.wildfire_bomb.full_recharge_time>spell_targets&(charges_fractional>2.5|dot.shrapnel_bomb.ticking)
    if talent.butchery and cast.able.butchery("player","aoe",1,8) and (#enemies.yards8 > 1 and not runeforge.rylakstalkersConfoundingStrikes.equiped and charges.wildfireBomb.timeTillFull() > #enemies.yards8 and (charges.butchery.frac() > 2.5 or debuff.shrapnelBomb.exists(units.dyn8))) then
        if cast.butchery("player","aoe",1,8) then return true end
    end
    --actions.st+=/steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap("player","ground",1,5) and focus + cast.regen.steelTrap() < focusMax then
        if cast.steelTrap("player","ground",1,5) then return true end
    end
    --actions.st+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=talent.alpha_predator.enabled&(buff.mongoose_fury.up&buff.mongoose_fury.remains<focus%(variable.mb_rs_cost-cast_regen)*gcd&!buff.wild_spirits.remains|buff.mongoose_fury.remains&next_wi_bomb.pheromone)
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison) and (talent.alphaPredator and (buff.mongooseFury.exists() and buff.mongooseFury.remains() < focus / (cast.cost.mongooseBite() - cast.regen.mongooseBite()) * unit.gcd(true) and not buff.wildSpirits.exists() or not buff.mongooseFury.exists() and nextBomb(spell.pheromoneBomb))) then
        if cast.mongooseBite(var.maxLatentPoison) then return true end
    end
    --actions.st+=/kill_command,target_if=min:bloodseeker.remains,if=full_recharge_time<gcd&focus+cast_regen<focus.max
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet", var.lowestBloodseeker) < 50 and charges.killCommand.timeTillFull() < unit.gcd(true) and focus + cast.regen.killCommand() < focusMax then
        if cast.killCommand(var.lowestBloodseeker) then return true end
    end
    --actions.st+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.tip_of_the_spear.stack=3|dot.shrapnel_bomb.ticking
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison) and (buff.tipOfTheSpear.stack() == 3 or debuff.shrapnelBomb.exists(var.maxLatentPoison)) then
        if cast.raptorStrike(var.maxLatentPoison) then return true end
    end
    --actions.st+=/mongoose_bite,if=dot.shrapnel_bomb.ticking
    if talent.mongooseBite and cast.able.mongooseBite() and debuff.shrapnelBomb.exists("target") then
        if cast.mongooseBite() then return true end
    end
    --actions.st+=/serpent_sting,target_if=min:remains,if=refreshable&target.time_to_die>7|buff.vipers_venom.up
    if cast.able.serpentSting(var.lowestSerpentSting) and (debuff.serpentSting.refresh(var.lowestSerpentSting) and unit.ttd(var.lowestSerpentSting) > 7 or buff.vipersVenom.exists()) then
        if cast.serpentSting(var.lowestSerpentSting) then return true end
    end
    --actions.st+=/wildfire_bomb,if=next_wi_bomb.shrapnel&focus>variable.mb_rs_cost*2&dot.serpent_sting.remains>5*gcd
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and nextBomb(spell.shrapnelBomb) and focus > cast.cost.mongooseBite() * 2 and debuff.serpentSting.remains(units.dyn40) > 5 * unit.gcd(true) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then return true end
    end
    --actions.st+=/chakrams
    if ui.alwaysCdAoENever("Covenany Ability",3,#enemies.yards8t) and cast.able.chakrams() then
        if cast.chakrams() then return true end
    end
    --actions.st+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet", var.lowestBloodseeker) < 50 and focus + cast.regen.killCommand() < focusMax then
        if cast.killCommand(var.lowestBloodseeker) then return true end
    end
    --actions.st+=/wildfire_bomb,if=runeforge.rylakstalkers_confounding_strikes.equipped
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and runeforge.rylakstalkersConfoundingStrikes.equiped then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then return true end
    end
    --actions.st+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.mongoose_fury.up|focus+action.kill_command.cast_regen>focus.max-15|dot.shrapnel_bomb.ticking|buff.wild_spirits.remains
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison) and (buff.mongooseFury.exists() or focus + cast.regen.killCommand() > focusMax - 15 or debuff.shrapnelBomb.exists(var.maxLatentPoison) or buff.wildSpirits.exists()) then
        if cast.mongooseBite(var.maxLatentPoison) then return true end
    end
    --actions.st+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison) then
        if cast.raptorStrike(var.maxLatentPoison) then return true end
    end
    --actions.st+=/wildfire_bomb,if=(next_wi_bomb.volatile&dot.serpent_sting.ticking|next_wi_bomb.pheromone|next_wi_bomb.shrapnel&focus>50)&!set_bonus.tier28_2pc
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and ((nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40) or nextBomb(spell.pheromoneBomb) or nextBomb(spell.shrapnelBomb) and focus > 50) and not var.hasTierBonus) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then return true end
    end
    return false
end

--BoP
actionList.BoP = function()
    --actions.bop=serpent_sting,target_if=min:remains,if=buff.vipers_venom.remains&(buff.vipers_venom.remains<gcd|refreshable)
    if cast.able.serpentSting(var.lowestSerpentSting) and buff.vipersVenom.exists() and (buff.vipersVenom.remains() < unit.gcd(true) or debuff.serpentSting.refresh(var.lowestSerpentSting)) then
        if cast.serpentSting(var.lowestSerpentSting) then return true end
    end
    --actions.bop+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&buff.nesingwarys_trapping_apparatus.up|focus+cast_regen<focus.max+10&buff.nesingwarys_trapping_apparatus.up&buff.nesingwarys_trapping_apparatus.remains<gcd
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet", var.lowestBloodseeker) < 50 and focus + cast.regen.killCommand() < focusMax and buff.nesingwarysTrappingApparatus.exists() or focus + cast.regen.killCommand() < focusMax + 10 and buff.nesingwarysTrappingApparatus.exists() and buff.nesingwarysTrappingApparatus.remains() < unit.gcd(true) then
        if cast.killCommand(var.lowestBloodseeker) then return true end
    end
    --actions.bop+=/kill_shot
    if actionList.killShot() then return true end
    --actions.bop+=/wildfire_bomb,if=focus+cast_regen<focus.max&full_recharge_time<gcd|buff.mad_bombardier.up
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and focus + cast.regen.wildfireBomb() < focusMax and charges.wildfireBomb.timeTillFull() < unit.gcd(true) or buff.madBombardier.exists() then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then return true end
    end
    --actions.bop+=/flanking_strike,if=focus+cast_regen<focus.max
    if ui.mode.harpoon == 1 and talent.flankingStrike and cast.able.flankingStrike() and unit.distance("pet",units.dyn15) < 15 and focus + cast.regen.flankingStrike() < focusMax then
        if cast.flankingStrike() then return true end
    end
    --actions.bop+=/flayed_shot
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards8t) and cast.able.flayedShot() then
        if cast.flayedShot() then return true end
    end
    --actions.bop+=/call_action_list,name=nta,if=runeforge.nessingwarys_trapping_apparatus.equipped&focus<variable.mb_rs_cost
    if runeforge.nesingwarysTrappingApparatus.equiped and focus < cast.cost.mongooseBite() then
        if actionList.Nta() then return true end
    end
    --actions.bop+=/death_chakram,if=focus+cast_regen<focus.max
    if ui.alwaysCdAoENever("Covenany Ability",3,#enemies.yards8t) and cast.able.deathChakram() and focus + cast.regen.deathChakram() < focusMax then
        if cast.deathChakram() then return true end
    end
    --actions.bop+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.coordinated_assault.up&buff.coordinated_assault.remains<1.5*gcd
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison) and buff.coordinatedAssault.exists() and buff.coordinatedAssault.remains() < 1.5 * unit.gcd(true) then
        if cast.raptorStrike(var.maxLatentPoison) then return true end
    end
    --actions.bop+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.coordinated_assault.up&buff.coordinated_assault.remains<1.5*gcd
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison) and buff.coordinatedAssault.exists() and buff.coordinatedAssault.remains() < 1.5 * unit.gcd(true) then
        if cast.mongooseBite(var.maxLatentPoison) then return true end
    end
    --actions.bop+=/a_murder_of_crows
    if talent.aMurderOfCrows and ui.alwaysCdAoENever("A Murder of Crows",3,#var.eagleEnemies) and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then return true end
    end
    --actions.bop+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.tip_of_the_spear.stack=3
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison) and buff.tipOfTheSpear.stack() == 3 then
        if cast.raptorStrike(var.maxLatentPoison) then return true end
    end
    --actions.bop+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=talent.alpha_predator.enabled&(buff.mongoose_fury.up&buff.mongoose_fury.remains<focus%(variable.mb_rs_cost-cast_regen)*gcd)
    if talent.mongooseBite and talent.alphaPredator and cast.able.mongooseBite(var.maxLatentPoison) and (buff.mongooseFury.exists() and buff.mongooseFury.remains() < focus / (cast.cost.mongooseBite() - cast.regen.mongooseBite()) * unit.gcd(true)) then
        if cast.mongooseBite(var.maxLatentPoison) then return true end
    end
    --actions.bop+=/wildfire_bomb,if=focus+cast_regen<focus.max&!ticking&(full_recharge_time<gcd|!dot.wildfire_bomb.ticking&buff.mongoose_fury.remains>full_recharge_time-1*gcd|!dot.wildfire_bomb.ticking&!buff.mongoose_fury.remains)|time_to_die<18&!dot.wildfire_bomb.ticking
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and (focus + cast.regen.wildfireBomb() < focusMax and not debuff.wildfireBomb.exists(units.dyn40) and (charges.wildfireBomb.timeTillFull() < unit.gcd(true) or not debuff.wildfireBomb.exists(units.dyn40) and buff.mongooseFury.remains() > charges.wildfireBomb.timeTillFull() - 1 * unit.gcd(true) or not debuff.wildfireBomb.exists(units.dyn40) and not buff.mongooseFury.exists()) or unit.ttd(units.dyn40) < 18 and not debuff.wildfireBomb.exists(units.dyn40)) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then return true end
    end
    --actions.bop+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&(!runeforge.nessingwarys_trapping_apparatus|focus<variable.mb_rs_cost)
    if cast.able.killCommand(var.maxBloodseeker) and focus + cast.regen.killCommand() < focusMax and (not runeforge.nesingwarysTrappingApparatus.equiped or focus < cast.cost.mongooseBite()) then
        if cast.killCommand(var.maxBloodseeker) then return true end
    end
    --actions.bop+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&runeforge.nessingwarys_trapping_apparatus&cooldown.freezing_trap.remains>(focus%(variable.mb_rs_cost-cast_regen)*gcd)&cooldown.tar_trap.remains>(focus%(variable.mb_rs_cost-cast_regen)*gcd)&(!talent.steel_trap|talent.steel_trap&cooldown.steel_trap.remains>(focus%(variable.mb_rs_cost-cast_regen)*gcd))
    if cast.able.killCommand(var.maxBloodseeker) and focus + cast.regen.killCommand() < focusMax and runeforge.nesingwarysTrappingApparatus.equiped and cd.freezingTrap.remain() > (focus / (cast.cost.mongooseBite() - cast.regen.mongooseBite()) * unit.gcd(true)) and cd.tarTrap.remain() > (focus / (cast.cost.mongooseBite() - cast.regen.mongooseBite()) * unit.gcd(true)) and (not talent.steelTrap or talent.steelTrap and cd.steelTrap.remain() > (focus / (cast.cost.mongooseBite() - cast.regen.mongooseBite()) * unit.gcd(true))) then
        if cast.killCommand(var.maxBloodseeker) then return true end
    end
    --actions.bop+=/steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap("player","ground",1,5) and focus + cast.regen.steelTrap() < focusMax then
        if cast.steelTrap("player","ground",1,5) then return true end
    end
    --actions.bop+=/serpent_sting,target_if=min:remains,if=dot.serpent_sting.refreshable&!buff.coordinated_assault.up|talent.alpha_predator&refreshable&!buff.mongoose_fury.up
    if cast.able.serpentSting(var.lowestSerpentSting) and (debuff.serpentSting.refresh(var.lowestSerpentSting) and not buff.coordinatedAssault.exists() or talent.alphaPredator and debuff.serpentSting.refresh(var.lowestSerpentSting) and not buff.mongooseFury.exists()) then
        if cast.serpentSting(var.lowestSerpentSting) then return true end
    end
    --actions.bop+=/resonating_arrow
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.resonatingArrow("best",nil,1,15) then
        if cast.resonatingArrow("best",nil,1,15) then return true end
    end
    --actions.bop+=/wild_spirits
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.wildSpirits("best",nil,var.spiritUnits,12) then
        if cast.wildSpirits("best",nil,var.spiritUnits,12) then return true end
    end
    --actions.bop+=/coordinated_assault,if=!buff.coordinated_assault.up
    if ui.alwaysCdAoENever("Coordinated Assault",3,#var.eagleEnemies) and cast.able.coordinatedAssault() and not buff.coordinatedAssault.exists() and unit.distance("target") < 5 then
        if cast.coordinatedAssault() then return true end
    end
    --actions.bop+=/mongoose_bite,if=buff.mongoose_fury.up|focus+action.kill_command.cast_regen>focus.max|buff.coordinated_assault.up
    if talent.mongooseBite and cast.able.mongooseBite() and (buff.mongooseFury.exists() or focus + cast.regen.killCommand() > focusMax or buff.coordinatedAssault.exists()) then
        if cast.mongooseBite() then return true end
    end
    --actions.bop+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack
    if cast.able.raptorStrike(var.maxLatentPoison) then
        if cast.raptorStrike(var.maxLatentPoison) then return true end
    end
    --actions.bop+=/wildfire_bomb,if=dot.wildfire_bomb.refreshable
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and debuff.wildfireBomb.refresh(units.dyn40) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then return true end
    end
    --actions.bop+=/serpent_sting,target_if=min:remains,if=buff.vipers_venom.up
    if cast.able.serpentSting(var.lowestSerpentSting) and buff.vipersVenom.exists() then
        if cast.serpentSting(var.lowestSerpentSting) then return true end
    end
    return false
end

actionList.Missdirection = function()
    if not ui.mode.misdirection == 1 then
        return false
    end
    local misdirectUnit = nil
    if unit.valid("target") and unit.distance("target") < 40 and not buff.playDead.exists("pet") then
        -- Misdirect to Tank
        if ui.value("Misdirection") == 1 then
            local tankInRange, tankUnit = unit.isTankInRange()
            if tankInRange then misdirectUnit = tankUnit end
        end
        -- Misdirect to Focus
        if ui.value("Misdirection") == 2 and unit.friend("focus","player") then
            misdirectUnit = "focus"
        end
        -- Misdirect to Pet
        if ui.value("Misdirection") == 3 then
            misdirectUnit = "pet"
        end
        -- Failsafe to Pet, if unable to misdirect to Tank or Focus
        if misdirectUnit == nil then misdirectUnit = "pet" end
        if misdirectUnit and cast.able.misdirection() and unit.exists(misdirectUnit) and unit.distance(misdirectUnit) < 40 and not unit.deadOrGhost(misdirectUnit) then
            if cast.misdirection(misdirectUnit) then return true end
        end
    end
    return false
end


-- Run
local function runRotation()
    if actionList.PetManagement == nil then
        actionList.PetManagement = br.rotations.support["PetCuteOne"].run
    end
    --API
    --anima                                         = br.player.anima
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    focus                                         = br.player.power.focus.amount()
    focusMax                                      = br.player.power.focus.max()
    --focusRegen                                    = br.player.power.focus.regen()
    --level                                         = br.player.level
    module                                        = br.player.module
    --opener                                        = br.player.opener
    runeforge                                     = br.player.runeforge
    spell                                         = br.player.spell
    talent                                        = br.player.talent
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    var                                           = br.player.variables
    -- Units
    units.get(5)
    units.get(15)
    units.get(30)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(5,"pet")
    enemies.get(8)
    enemies.get(8,"player",false,true)
    enemies.get(8,"target")
    enemies.get(12)
    enemies.get(12,"target")
    enemies.get(15)
    enemies.get(30)
    enemies.get(40)
    enemies.get(40,"player",false,true)
    enemies.rect.get(10,40,false)
    -- General Locals
    var.hasTierBonus                              = br.TierScan("T28") >= 2
    var.haltProfile                               = unit.mounted() or unit.flying() or ui.pause() or buff.feignDeath.exists() or ui.mode.rotation == 3
    -- Profile Specific Locals
    var.singleTarget                             = ui.mode.rotation == 2
    var.eagleRange                               = buff.aspectOfTheEagle.exists() and 40 or 5
    var.eagleEnemies                             = buff.aspectOfTheEagle.exists() and enemies.yards40 or enemies.yards5
    var.lowestBloodseeker                        = var.singleTarget and "target" or debuff.bloodseeker.lowest(40,"remain") or "target"
    var.lowestSerpentSting                       = var.singleTarget and "target" or debuff.serpentSting.lowest(40,"remain") or "target"
    var.maxLatentPoison                          = var.singleTarget and "target" or debuff.latentPoison.max(var.eagleRange,"stack") or "target"
    var.spiritUnits                              = ui.useCDs() and 1 or 3
    var.pheromoneUnit                            = var.singleTarget and "target" or debuff.pheromoneBomb.max(40,"remain") or "target"

    if var.haltProfile then
        return true
    end

    --Pet
    if actionList.PetManagement() then return true end
    --Defensive
    if actionList.Defensive() then return true end

    if not unit.inCombat() or not unit.exists("target") or not unit.valid("target") then
        return true
    end

    --Missdirection
    if actionList.Missdirection() then return true end
    --CCs
    if actionList.CCs() then return true end
    --Interrupts
    if actionList.Interrupt() then return true end

    --actions=auto_attack
    if cast.able.autoAttack("target") then
        if cast.autoAttack("target") then return true end
    end
    --TODO actions+=/use_item,name=jotungeirr_destinys_call,if=!raid_event.adds.exists&(buff.coordinated_assault.up|!cooldown.coordinated_assault.remains|time_to_die<30)|(raid_event.adds.exists&buff.resonating_arrow.up|buff.coordinated_assault.up)
    --actions+=/use_items
    module.BasicTrinkets()
    --TODO actions+=/newfound_resolve,if=soulbind.newfound_resolve&(buff.resonating_arrow.up|cooldown.resonating_arrow.remains>10|target.time_to_die<16)
    --actions+=/call_action_list,name=cds
    if actionList.Cooldown() then return true end
    --actions+=/call_action_list,name=bop,if=active_enemies<3&talent.birds_of_prey.enabled
    if talent.birdsOfPrey and (ui.mode.rotation == 2 or ui.mode.rotation == 1 and eagleScout() < 3) then
        if actionList.BoP() then return true end
    end
    --actions+=/call_action_list,name=st,if=active_enemies<3&!talent.birds_of_prey.enabled
    if not talent.birdsOfPrey and (ui.mode.rotation == 2 or ui.mode.rotation == 1 and eagleScout() < 3) then
        if actionList.St() then return true end
    end
    --actions+=/call_action_list,name=cleave,if=active_enemies>2
    if ui.mode.rotation == 1 and eagleScout() > 2 then
        if actionList.Cleave() then return true end
    end
    --actions+=/arcane_torrent
    if ui.checked("Racial") and unit.race() == "BloodElf" and cast.able.racial() then
        if cast.racial() then return true end
    end

    return true
end

-- Init
local id = 255
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
