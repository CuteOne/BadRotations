local rotationName = "CuteOne"
br.loadSupport("PetCuteOne")
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.serpentSting },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.carve },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.raptorStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.exhilaration}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.aspectOfTheEagle },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.aspectOfTheEagle },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.aspectOfTheEagle }
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
        [1] = { mode = "On", value = 1 , overlay = "Harpoon Enabled", tip = "Will cast Harpoon.", highlight = 1, icon = br.player.spell.harpoon },
        [2] = { mode = "Off", value = 2 , overlay = "Harpoon Disabled", tip = "Will NOT cat Harpoon.", highlight = 0, icon = br.player.spell.harpoon }
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
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdAoENever = {"Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never"}
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Hunter's Mark
            br.ui:createCheckbox(section,"Hunter's Mark")
            -- Harpoon
            br.ui:createCheckbox(section, "Harpoon - Opener")
            -- Misdirection
            br.ui:createDropdownWithout(section,"Misdirection", {"|cff00FF00Tank","|cffFFFF00Focus","|cffFF0000Pet"}, 1, "|cffFFFFFFWhen to use Artifact Ability.")
            -- Opener
            br.ui:createDropdownWithout(section, "Opener", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use opener.")
            -- Tar Trap
            br.ui:createDropdownWithout(section, "Tar Trap", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use tar trap.")
            -- Flare
            br.ui:createDropdownWithout(section, "Flare", alwaysCdAoENever, 1, "|cffFFFFFFSet when to use flare.")
        br.ui:checkSectionState(section)
        -- Pet Options
        br.rotations.support["PetCuteOne"].options()
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Potion
            br.ui:createCheckbox(section,"Potion")
            -- FlaskUp Module
            br.player.module.FlaskUp("Agility",section)
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

--------------
--- Locals ---
--------------
-- BR API Locals
local anima
local buff
local cast
local cd
local charges
local debuff
local enemies
local focus
local focusMax
local focusRegen
local gcd
local level
local module
local opener
local runeforge
local spell
local talent
local ui
local unit
local units
local var

local actionList = {}

-----------------
--- Functions ---
-----------------

-- Custom Profile Functions
local function focusTimeTill(amount)
    if focus >= amount then return 0.5 end
    return ((amount-focus)/focusRegen)+0.5
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

local function eagleScout()
    if buff.aspectOfTheEagle.exists() then
        return #enemies.yards40
    else
        return #enemies.yards5
    end
end

-- Multi-Dot HP Limit Set
local function canDoT(thisUnit)
    if not unit.isBoss(thisUnit) then ui.debug("") return true end
    local unitHealthMax = unit.healthMax(thisUnit)
    local maxHealth = 0
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]
        local thisMaxHealth = unit.healthMax(thisUnit)
        if thisMaxHealth > maxHealth then
            maxHealth = thisMaxHealth
        end
    end
    return unitHealthMax > maxHealth / 10
end

-- Action List - Extra
actionList.Extra = function()
    -- Hunter's Mark
    if ui.checked("Hunter's Mark") and cast.able.huntersMark("target") and not debuff.huntersMark.exists("target") then
        if cast.huntersMark("target") then ui.debug("Cast Hunter's Mark") return true end
    end
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) and unit.isDummy() then
                unit.stopAttack()
                unit.clearTarget()
                ui.print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end -- End Dummy Test
    -- Misdirection
    if ui.mode.misdirection == 1 then
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
                if cast.misdirection(misdirectUnit) then ui.debug("Casting Misdirection on "..unit.name(misdirectUnit)) return true end
            end
        end
    end
end -- End Action List - Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Aspect of the Turtle
        if ui.checked("Aspect Of The Turtle") and cast.able.aspectOfTheTurtle()
            and unit.hp() <= ui.value("Aspect Of The Turtle") and unit.inCombat()
        then
            if cast.aspectOfTheTurtle("player") then ui.debug("Casting Aspect of the Turtle") return true end
        end
        -- Exhilaration
        if ui.checked("Exhilaration") and cast.able.exhilaration() and unit.hp() <= ui.value("Exhilaration") then
            if cast.exhilaration("player") then ui.debug("Casting Exhiliration") return true end
        end
        -- Feign Death
        if ui.checked("Feign Death") and cast.able.feignDeath()
            and unit.hp() <= ui.value("Feign Death") and unit.inCombat()
        then
            if cast.able.playDead() then
                if cast.playDead() then ui.debug("Casting Play Dead [Pet]") return true end
            end
            if cast.feignDeath("player") then ui.debug("Casting Feign Death") return true end
        end
        -- Intimidation
        if ui.checked("Intimidation") and cast.able.intimidation() and unit.hp() <= ui.value("Intimidation") then
            if cast.intimidation(units.dyn5p) then ui.debug("Casting Intimidation") return true end
        end
        -- Tranquilizing Shot
        if ui.checked("Tranquilizing Shot") then
            if #enemies.yards40f > 0 then
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if ui.value("Tranquilizing Shot") == 1 or (ui.value("Tranquilizing Shot") == 2 and unit.isUnit(thisUnit,"target")) then
                        if unit.valid(thisUnit) and cast.dispel.tranquilizingShot(thisUnit) then
                            if cast.tranquilizingShot(thisUnit) then ui.debug("Casting Tranquilizing Shot") return true end
                        end
                    end
                end
            end
        end
    end -- End Defensive Toggle
end -- End Action List - Defensive

-- Action List - Interrrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        local thisUnit
        -- Muzzle
        if ui.checked("Muzzle") and cast.able.muzzle() then
            for i=1, #enemies.yards5 do
                thisUnit = enemies.yards5[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.muzzle(thisUnit) then ui.debug("Casting Muzzle") return true end
                end
            end
        end
        -- Freezing Trap
        if ui.checked("Freezing Trap") and cast.able.freezingTrap() then
            for i = 1, #enemies.yards40 do
                thisUnit = enemies.yards40[i]
                if unit.distance(thisUnit) > 8 and cast.timeRemain(thisUnit) > 3 then
                    if cast.freezingTrap(thisUnit,"ground") then ui.debug("Casting Freezing Trap") return true end
                end
            end
        end
        -- Intimidation
        if ui.checked("Intimidation - Int") and cast.able.intimidation() then
            for i=1, #enemies.yards5 do
                thisUnit = enemies.yards5[i]
                if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                    if cast.intimidation(thisUnit) then ui.debug("Casting Intimidaton [Interrupt]") return true end
                end
            end
        end
    end -- End useInterrupts check
end -- End Action List - Interrupt

-- Action List - Cooldowns
actionList.Cooldown = function()
    if ui.useCDs() and unit.distance(var.eagleUnit) < var.eagleRange then
        -- Harpoon
        -- harpoon,if=talent.terms_of_engagement.enabled&focus<focus.max
        if cast.able.harpoon() and talent.termsOfEngagement and focus < focusMax then
            if cast.harpoon() then ui.debug("Casting Harpoon [CD]") return true end
        end
        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
        if ui.checked("Racial") then
            -- blood_fury,if=cooldown.coordinated_assault.remains>30
            -- ancestral_call,if=cooldown.coordinated_assault.remains>30
            -- fireblood,if=cooldown.coordinated_assault.remains>30
            if (cd.coordinatedAssault.remain() > 30 and (unit.race() == "Orc" or unit.race() == "MagharOrc" or unit.race() == "DarkIronDwarf")) then
                if cast.racial("player") then ui.debug("Casting Racial") return true end
            end
            -- lights_judgment
            if unit.race() == "LightforgedDraenei" then
                if cast.racial("target","ground") then ui.debug("Casting Racial") return true end
            end
            -- bag_of_tricks,if=cooldown.kill_command.full_recharge_time>gcd
            -- berserking,if=cooldown.coordinated_assault.remains>60|time_to_die<13
            if (cd.coordinatedAssault.remain() > 60 or unit.ttd(units.dyn5) < 13) and unit.race() == "Troll" then
                if cast.racial("player") then ui.debug("Casting Racial") return true end
            end
        end
        -- Muzzle
        -- muzzle
        -- Potion
        -- potion,if=target.time_to_die<60|buff.coordinated_assault.up
    end -- End useCooldowns check
    -- Steel Trap
    -- steel_trap,if=runeforge.nessingwarys_trapping_apparatus.equipped&focus+cast_regen<focus.max
    if cast.able.steelTrap("player","ground",1,5) and runeforge.nesingwarysTrappingApparatus.equiped and focus + cast.regen.steelTrap() < focusMax then
        if cast.steelTrap("player","ground",1,5) then ui.debug("Casting Steel Trap [CD]") return true end
    end
    -- Freezing Trap
    -- freezing_trap,if=runeforge.nessingwarys_trapping_apparatus.equipped&focus+cast_regen<focus.max
    if cast.able.freezingTrap("player","ground",1,5) and runeforge.nesingwarysTrappingApparatus.equiped and focus + cast.regen.steelTrap() < focusMax then
        if cast.freezingTrap("player","ground",1,5) then ui.debug("Casting Freezing Trap [CD]") return true end
    end
    -- Tar Trap
    -- tar_trap,if=runeforge.nessingwarys_trapping_apparatus.equipped&focus+cast_regen<focus.max|focus+cast_regen<focus.max&runeforge.soulforge_embers.equipped&tar_trap.remains<gcd&cooldown.flare.remains<gcd&(active_enemies>1|active_enemies=1&time_to_die>5*gcd)
    if cast.able.tarTrap("best",nil,1,8) and (runeforge.nesingwarysTrappingApparatus.equiped and focus + cast.regen.steelTrap() < focusMax
        or focus + cast.regen.steelTrap() < focusMax and (runeforge.soulforgeEmbers.equiped or anima.soulforgeEmbers.exists()) and debuff.tarTrap.remains(units.dyn40) < unit.gcd(true)
        and (#enemies.yards40 > 1 or #enemies.yards40 == 1 and unit.ttd(units.dyn40) > 5 * unit.gcd(true)))
    then
        if cast.tarTrap("best",nil,1,8) then ui.debug("Casting Tar Trap [CD]") var.tarred = true return true end
    end
    -- Flare
    -- flare,if=focus+cast_regen<focus.max&tar_trap.up&runeforge.soulforge_embers.equipped&time_to_die>4*gcd
    if cast.able.flare("groundLocation",br.castPosition.x,br.castPosition.y,8) and var.tarred and focus + cast.regen.flare() < focusMax
        and (runeforge.soulforgeEmbers.equiped or anima.soulforgeEmbers.exists()) --and unit.ttd(units.dyn40) > 4 * unit.gcd(true)
    then
        if cast.flare("groundLocation",br.castPosition.x,br.castPosition.y,8) then ui.debug("Casting Flare [CD]") var.tarred = false return true end
    end
    -- Kill Shot
    -- kill_shot,if=active_enemies=1&target.time_to_die<focus%(action.mongoose_bite.cost-cast_regen)*gcd
    if cast.able.killShot("target") and (unit.hp("target") < 20 or buff.flayersMark.exists()) and #enemies.yards40 == 1
        and unit.ttd(units.dyn40) < focus / (cast.cost.mongooseBite() - cast.regen.killShot()) * unit.gcd(true)
    then
        if cast.killShot("target") then ui.debug("Casting Kill Shot [CD]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=active_enemies=1&target.time_to_die<focus%(action.mongoose_bite.cost-cast_regen)*gcd
    if talent.mongooseBite and cast.able.mongooseBite(var.eagleUnit) and #var.eagleEnemies == 1 and unit.ttd(var.eagleUnit) < focus / (cast.cost.mongooseBite() - cast.regen.mongooseBite()) * unit.gcd(true) then
        if cast.mongooseBite(var.eagleUnit) then ui.debug("Casting Mongoose Bite [CD]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,if=active_enemies=1&target.time_to_die<focus%(action.mongoose_bite.cost-cast_regen)*gcd
    if not talent.mongooseBite and cast.able.raptorStrike(var.eagleUnit) and #var.eagleEnemies == 1 and unit.ttd(var.eagleUnit) < focus / (cast.cost.mongooseBite() - cast.regen.raptorStrike()) * unit.gcd(true) then
        if cast.raptorStrike(var.eagleUnit) then ui.debug("Casting Raptor Strike [CD]") return true end
    end
    -- Aspect of the Eagle
    -- aspect_of_the_eagle,if=target.distance>=6
    if ui.mode.aotE == 1 and ui.alwaysCdAoENever("Aspect of the Eagle",3,#enemies.yards40) and cast.able.aspectOfTheEagle()
        and unit.standingTime() >= 2 and unit.combatTime() >= 5 and (unit.distance("target") >= 6)
    then
        if cast.aspectOfTheEagle() then ui.debug("Casting Aspect of the Eagle") return true end
    end
end -- End Action List - Cooldowns

-- Action List - Alpha Predator / Birds of Prey
actionList.ApBoP = function()
    -- Wild Spirits
    -- wild_spirits
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.wildSpirits("best",nil,var.spiritUnits,12) then
        if cast.wildSpirits("best",nil,var.spiritUnits,12) then ui.debug("Casting Wild Spirits [ApBoP]") return true end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and unit.distance("pet",units.dyn15) < 15 and (focus + cast.regen.flankingStrike() < focusMax) then
        if cast.flankingStrike() then ui.debug("Casting Flanking Strike [ApBoP - Higher Priority]") return true end
    end
    -- Flayed Shot
    -- flayed_shot
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards8t) and cast.able.flayedShot() then
        if cast.flayedShot() then ui.debug("Casting Flayed Shot [ApBop]") return true end
    end
    -- Death Chakrams
    -- death_chakram,if=focus+cast_regen<focus.max
    if ui.alwaysCdAoENever("Covenany Ability",3,#enemies.yards8t) and cast.able.deathChakram() and focus + cast.regen.deathChakram() < focusMax then
        if cast.deathChakram() then ui.debug("Casting Death Chakram [ApBoP]") return true end
    end
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot("target") and (unit.hp("target") < 20 or buff.flayersMark.exists()) then
        if cast.killShot("target") then ui.debug("Casting Kill Shot [ApBoP]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.coordinated_assault.up&buff.coordinated_assault.remains<1.5*gcd
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison)
        and buff.coordinatedAssault.exists() and buff.coordinatedAssault.remains() < 1.5 * unit.gcd(true)
    then
        if cast.mongooseBite(var.maxLatentPoison) then ui.debug("Casting Mongoose Bite [ApBoP - Coordinated Assault]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.coordinated_assault.up&buff.coordinated_assault.remains<1.5*gcd
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison)
        and buff.coordinatedAssault.exists() and buff.coordinatedAssault.remains() < 1.5 * unit.gcd(true)
    then
        if cast.raptorStrike(var.maxLatentPoison) then ui.debug("Casting Raptor Strike [ApBoP - Coordinated Assault]") return true end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and unit.distance("pet",units.dyn15) < 15 and (focus + cast.regen.flankingStrike() < focusMax) then
        if cast.flankingStrike() then ui.debug("Casting Flanking Strike [ApBoP - Lower Priority]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=focus+cast_regen<focus.max&!ticking&(full_recharge_time<gcd|!dot.wildfire_bomb.ticking&buff.mongoose_fury.remains>full_recharge_time-1*gcd|!dot.wildfire_bomb.ticking&!buff.mongoose_fury.remains)|time_to_die<18&!dot.wildfire_bomb.ticking
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and focus + cast.regen.wildfireBomb() < focusMax and ((charges.wildfireBomb.timeTillFull() < unit.gcd(true) or not debuff.wildfireBomb.exists(units.dyn40)
        and buff.mongooseFury.remains() > charges.wildfireBomb.timeTillFull() - 1 * unit.gcd(true) or debuff.wildfireBomb.exists(units.dyn40))
            or (unit.ttd(units.dyn40) < 18 and not debuff.wildfireBomb.exists(units.dyn40)))
    then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [ApBoP - High Focus]") return true end
    end
    -- Steel Trap
    -- steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap("player","ground",1,5) and focus + cast.regen.steelTrap() < focusMax then
        if cast.steelTrap("player","ground",1,5) then ui.debug("Casting Steel Trap [ApBoP]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.mongoose_fury.up&buff.mongoose_fury.remains<focus%(action.mongoose_bite.cost-cast_regen)*gcd
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison) and buff.mongooseFury.exists()
        and buff.mongooseFury.remain() < focus / (cast.cost.mongooseBite() - cast.regen.mongooseBite()) * unit.gcd(true)
    then
        if cast.mongooseBite(var.maxLatentPoison) then ui.debug("Casting Mongoose Bite [ApBoP - Mongoose Fury]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=full_recharge_time<gcd&focus+cast_regen<focus.max&(runeforge.nessingwarys_trapping_apparatus.equipped&cooldown.freezing_trap.remains&cooldown.tar_trap.remains|!runeforge.nessingwarys_trapping_apparatus.equipped)
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet",units.dyn40) < 50 and charges.killCommand.timeTillFull() < unit.gcd(true)
        and focus + cast.regen.killCommand() < focusMax and (runeforge.nesingwarysTrappingApparatus.equiped
        and cd.freezingTrap.exists() and cd.tarTrap.exists() or not runeforge.nesingwarysTrappingApparatus.equiped)
    then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [ApBoP - Full Charges]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=dot.serpent_sting.refreshable&!buff.mongoose_fury.remains
    if cast.able.serpentSting(var.lowestSerpentSting) and debuff.serpentSting.refresh(var.lowestSerpentSting) and not buff.mongooseFury.exists() then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [ApBoP]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&(buff.mongoose_fury.stack<5|focus<action.mongoose_bite.cost)&(runeforge.nessingwarys_trapping_apparatus.equipped&cooldown.freezing_trap.remains&cooldown.tar_trap.remains|!runeforge.nessingwarys_trapping_apparatus.equipped)
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet",units.dyn40) < 50 and focus + cast.regen.killCommand() < focusMax
        and (buff.mongooseFury.stack() < 5 or focus < cast.cost.mongooseBite()) and (runeforge.nesingwarysTrappingApparatus.equiped and cd.freezingTrap.exists()
        and cd.tarTrap.exists() or not runeforge.nesingwarysTrappingApparatus.equiped)
    then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [ApBoP - Low Mongoose Fury / Focus]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if ui.alwaysCdAoENever("A Murder of Crows",3,#var.eagleEnemies) and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [ApBoP]") return true end
    end
    -- Resonating Arrow
    -- resonating_arrow
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.resonatingArrow("best",nil,1,15) then
        if cast.resonatingArrow("best",nil,1,15) then ui.debug("Casting Resonating Arrow [ApBoP]") return true end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if ui.alwaysCdAoENever("Coordinated Assault",3,#var.eagleEnemies) and cast.able.coordinatedAssault() and unit.distance("target") < 5 then
        if cast.coordinatedAssault() then ui.debug("Casting Coordinated Assault [ApBoP]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.mongoose_fury.up|focus+action.kill_command.cast_regen>focus.max|buff.coordinated_assault.up
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison)
        and (buff.mongooseFury.exists() or focus + cast.regen.killCommand() > focusMax or buff.coordinatedAssault.exists())
    then
        if cast.mongooseBite(var.maxLatentPoison) then ui.debug("Casting Mongoose Bite [ApBop]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison_injection.stack
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison) then
        if cast.raptorStrike(var.maxLatentPoison) then ui.debug("Casting Raptor Strike [ApBop]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=!ticking
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and not debuff.wildfireBomb.exists(units.dyn40) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [ApBoP]") return true end
    end
end -- End Action List - Alpha Predator / Birds of Prey

-- Action List - Alpha Predator
actionList.ApSt = function()
    -- Death Chakrams
    -- death_chakram,if=focus+cast_regen<focus.max
    if ui.alwaysCdAoENever("Covenany Ability",3,#enemies.yards8t) and cast.able.deathChakram() and focus + cast.regen.deathChakram() < focusMax then
        if cast.deathChakram() then ui.debug("Casting Death Chakram [ApSt]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=!dot.serpent_sting.ticking&target.time_to_die>7
    if cast.able.serpentSting(var.lowestSerpentSting) and not debuff.serpentSting.exists(var.lowestSerpentSting) and unit.ttd(var.lowestSerpentSting) > 7 then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [ApSt]") return true end
    end
    -- Flayed Shot
    -- flayed_shot
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards8t) and cast.able.flayedShot() then
        if cast.flayedShot() then ui.debug("Casting Flayed Shot [ApSt]") return true end
    end
    -- Resonating Arrow
    -- resonating_arrow
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.resonatingArrow("best",nil,1,15) then
        if cast.resonatingArrow("best",nil,1,15) then ui.debug("Casting Resonating Arrow [ApSt]") return true end
    end
    -- Wild Spirits
    -- wild_spirits
    if ui.alwaysCdAoENever("Covenant Ability") and cast.able.wildSpirits("best",nil,var.spiritUnits,12) then
        if cast.wildSpirits("best",nil,var.spiritUnits,12) then ui.debug("Casting Wild Spirits [ApSt]") return true end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if ui.alwaysCdAoENever("Coordinated Assault",3,#var.eagleEnemies) and cast.able.coordinatedAssault() and unit.distance("target") < 5 then
        if cast.coordinatedAssault() then ui.debug("Casting Coordinated Assault [ApSt]") return true end
    end
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot("target") and (unit.hp("target") < 20 or buff.flayersMark.exists()) then
        if cast.killShot("target") then ui.debug("Casting Kill Shot [ApSt]") return true end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and unit.distance("pet",units.dyn15) < 15 and (focus + cast.regen.flankingStrike() < focusMax) then
        if cast.flankingStrike() then ui.debug("Casting Flanking Strike [ApSt]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if ui.alwaysCdAoENever("A Murder of Crows",3,#var.eagleEnemies) and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [ApSt]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=full_recharge_time<gcd|focus+cast_regen<focus.max&(next_wi_bomb.volatile&dot.serpent_sting.ticking&dot.serpent_sting.refreshable|next_wi_bomb.pheromone&!buff.mongoose_fury.up&focus+cast_regen<focus.max-action.kill_command.cast_regen*3)|time_to_die<10
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and (charges.wildfireBomb.timeTillFull() < unit.gcd(true) or focus + cast.regen.wildfireBomb() < focusMax
        and (nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40) and debuff.serpentSting.refresh(units.dyn40) or nextBomb(spell.pheromoneBomb)
        and not buff.mongooseFury.exists() and focus + cast.regen.wildfireBomb() < focusMax - cast.regen.killCommand() * 3) or unit.ttd(units.dyn40) < 10)
    then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [ApSt - Max Charges]") return true end
    end
    -- Carve
    -- carve,if=active_enemies>1&!runeforge.rylakstalkers_confounding_strikes.equipped
    if not talent.butchery and cast.able.carve("player","cone",1,8) and #enemies.yards8 > 1 and not runeforge.rylakstalkersConfoundingStrikes.equiped then
        if cast.carve("player","cone",1,8) then ui.debug("Casting Carve [ApSt]") return true end
    end
    -- Butchery
    -- butchery,if=active_enemies>1&!runeforge.rylakstalkers_confounding_strikes.equipped&cooldown.wildfire_bomb.full_recharge_time>spell_targets&(charges_fractional>2.5|dot.shrapnel_bomb.ticking)
    if talent.butchery and cast.able.butchery("player","aoe",1,8) and #enemies.yards8 > 1 and not runeforge.rylakstalkersConfoundingStrikes.equiped
        and charges.wildfireBomb.timeTillFull() > #enemies.yards8 and (charges.butchery.frac() > 2.5 or debuff.shrapnelBomb.exists("target"))
    then
        if cast.butchery("player","aoe",1,8) then ui.debug("Casting Butchery [ApSt]") return true end
    end
    -- Steel Trap
    -- steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap("player","ground",1,5) and focus + cast.regen.steelTrap() < focusMax then
        if cast.steelTrap("player","ground",1,5) then ui.debug("Casting Steel Trap [ApSt]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.mongoose_fury.up&buff.mongoose_fury.remains<focus%(action.mongoose_bite.cost-cast_regen)*gcd&!buff.wild_spirits.remains|buff.mongoose_fury.remains&next_wi_bomb.pheromone
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison) and buff.mongooseFury.exists()
        and buff.mongooseFury.remains() < focus / (cast.cost.mongooseBite() - cast.regen.mongooseBite()) * unit.gcd(true)
        and not buff.wildSpirits.exists() or buff.mongooseFury.exists() and nextBomb(spell.pheromoneBomb)
    then
        if cast.mongooseBite(var.maxLatentPoison) then ui.debug("Casting Mongoose Bite [ApSt - Fury End Soon]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=full_recharge_time<gcd&focus+cast_regen<focus.max
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet",units.dyn40) < 50
        and charges.killCommand.timeTillFull() < unit.gcd(true) and focus + cast.regen.killCommand() < focusMax
    then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [ApSt - Max Charges]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.tip_of_the_spear.stack=3|dot.shrapnel_bomb.ticking
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison) and (buff.tipOfTheSpear.stack() == 3 or debuff.shrapnelBomb.exists(var.maxLatentPoison)) then
        if cast.raptorStrike(var.maxLatentPoison) then ui.debug("Casting Raptor Strike [ApSt - Tip of the Spear / Shrapnel Bomb]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=dot.shrapnel_bomb.ticking
    if talent.mongooseBite and cast.able.mongooseBite(var.eagleUnit) and debuff.shrapnelBomb.exists(var.eagleUnit) then
        if cast.mongooseBite(var.eagleUnit) then ui.debug("Casting Mongoose Bite [ApSt - Shrapnel Bomb]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=refreshable&target.time_to_die>7
    if cast.able.serpentSting(var.lowestSerpentSting) and debuff.serpentSting.refresh(var.lowestSerpentSting) and unit.ttd(var.lowestSerpentSting) > 7 then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [ApSt]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.shrapnel&focus>action.mongoose_bite.cost*2&dot.serpent_sting.remains>5*gcd
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and nextBomb(spell.shrapnelBomb) and focus > cast.cost.mongooseBite() * 2 and debuff.serpentSting.remains(units.dyn40) > 5 * unit.gcd(true) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [ApSt - Next Bomb Shrapnel") return true end
    end
    -- Chakrams
    -- chakrams
    if cast.able.chakrams("player","rect",1,40) and #enemies.yards40r > 0 then
        if cast.chakrams("player","rect",1,40) then ui.debug("Casting Chakrams [ApSt]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet",units.dyn40) < 50 and focus + cast.regen.killCommand() < focusMax then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [ApSt - High Focus]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=runeforge.rylakstalkers_confounding_strikes.equipped
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and runeforge.rylakstalkersConfoundingStrikes.equiped then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [ApSt - Rylakstalker's Confounding Strikes]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.mongoose_fury.up|focus+action.kill_command.cast_regen>focus.max-15|dot.shrapnel_bomb.ticking|buff.wild_spirits.remains
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison) and (buff.mongooseFury.exists()
        or focus + cast.regen.killCommand() > focusMax - 15 or debuff.shrapnelBomb.exists(var.maxLatentPoison) or buff.wildSpirits.exists())
    then
        if cast.mongooseBite(var.maxLatentPoison) then ui.debug("Casting Mongoose Bite [ApSt]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison_injection.stack
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison) then
        if cast.raptorStrike(var.maxLatentPoison) then ui.debug("Casting Raptor Strike [ApSt]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.volatile&dot.serpent_sting.ticking|next_wi_bomb.pheromone|next_wi_bomb.shrapnel&focus>50
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and (nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40)
        or nextBomb(spell.pheromoneBomb) or nextBomb(spell.shrapnelBomb) and focus > 50)
    then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [ApSt]") return true end
    end
end -- End Action List - Alpha Predator

-- Action List - Birds of Prey
actionList.BoP = function()
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=buff.vipers_venom.remains&buff.vipers_venom.remains<gcd
    if cast.able.serpentSting(var.lowestSerpentSting) and buff.vipersVenom.exists() and buff.vipersVenom.remains() < unit.gcd(true) then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [BoP - Vipers Venom Expire Soon]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&buff.nesingwarys_trapping_apparatus.up
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet",units.dyn40) < 50
        and focus + cast.regen.killCommand() < focusMax and buff.nesingwarysTrappingApparatus.exists()
    then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [BoP - Nesingwary's Trapping Apparatus]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=focus+cast_regen<focus.max&!ticking&full_recharge_time<gcd
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and focus + cast.regen.wildfireBomb() < focusMax and charges.wildfireBomb.timeTillFull() < unit.gcd(true) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [BoP - Max Charges]") return true end
    end
    -- Wild Spirits
    -- wild_spirits
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.wildSpirits("best",nil,var.spiritUnits,12) then
        if cast.wildSpirits("best",nil,var.spiritUnits,12) then ui.debug("Casting Wild Spirits [BoP]") return true end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and unit.distance("pet",units.dyn15) < 15 and (focus + cast.regen.flankingStrike() < focusMax) then
        if cast.flankingStrike() then ui.debug("Casting Flanking Strike [BoP]") return true end
    end
    -- Flayed Shot
    -- flayed_shot
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards8t) and cast.able.flayedShot() then
        if cast.flayedShot() then ui.debug("Casting Flayed Shot [BoP]") return true end
    end
    -- Death Chakram
    -- death_chakram,if=focus+cast_regen<focus.max
    if ui.alwaysCdAoENever("Covenany Ability",3,#enemies.yards8t) and cast.able.deathChakram() and focus + cast.regen.deathChakram() < focusMax then
        if cast.deathChakram() then ui.debug("Casting Death Chakram [BoP]") return true end
    end
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot("target") and (unit.hp("target") < 20 or buff.flayersMark.exists()) then
        if cast.killShot("target") then ui.debug("Casting Kill Shot [BoP]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.coordinated_assault.up&buff.coordinated_assault.remains<1.5*gcd
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison)
        and buff.coordinatedAssault.exists() and buff.coordinatedAssault.remains() < 1.5 * unit.gcd(true)
    then
        if cast.raptorStrike(var.maxLatentPoison) then ui.debug("Casting Raptor Strike [BoP - Coordinated Assault]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.coordinated_assault.up&buff.coordinated_assault.remains<1.5*gcd
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison)
        and buff.coordinatedAssault.exists() and buff.coordinatedAssault.remains() < 1.5 * unit.gcd(true)
    then
        if cast.mongooseBite(var.maxLatentPoison) then ui.debug("Casting Mongoose Bite [BoP - Coordinated Assault]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if ui.alwaysCdAoENever("A Murder of Crows",3,#var.eagleEnemies) and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [BoP]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.tip_of_the_spear.stack=3
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison) and buff.tipOfTheSpear.stack() == 3 then
        if cast.raptorStrike(var.maxLatentPoison) then ui.debug("Casting Raptor Strike [BoP - Tip of the Spear]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=focus+cast_regen<focus.max&!ticking&(full_recharge_time<gcd|!dot.wildfire_bomb.ticking&buff.mongoose_fury.remains>full_recharge_time-1*gcd|!dot.wildfire_bomb.ticking&!buff.mongoose_fury.remains)|time_to_die<18&!dot.wildfire_bomb.ticking
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and focus + cast.regen.wildfireBomb() < focusMax
        and not debuff.wildfireBomb.exists(units.dyn40) and (charges.wildfireBomb.timeTillFull() < unit.gcd(true)
        or not debuff.wildfireBomb.exists(units.dyn40) and buff.mongooseFury.remains() > charges.wildfireBomb.timeTillFull() - 1 * unit.gcd(true)
        or not debuff.wildfireBomb.exists(units.dyn40) and not buff.mongooseFury.exists()) or unit.ttd(units.dyn40) < 18 and not debuff.wildfireBomb.exists(units.dyn40)
    then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Wildfire Bomb [BoP]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&!runeforge.nessingwarys_trapping_apparatus.equipped|focus+cast_regen<focus.max&((runeforge.nessingwarys_trapping_apparatus.equipped&!talent.steel_trap.enabled&cooldown.freezing_trap.remains&cooldown.tar_trap.remains)|(runeforge.nessingwarys_trapping_apparatus.equipped&talent.steel_trap.enabled&cooldown.freezing_trap.remains&cooldown.tar_trap.remains&cooldown.steel_trap.remains))|focus<action.mongoose_bite.cost
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet",units.dyn40) < 50 and focus + cast.regen.killCommand() < focusMax and not runeforge.nesingwarysTrappingApparatus.equiped
        or focus + cast.regen.killCommand() < focusMax and ((runeforge.nesingwarysTrappingApparatus.equiped and not talent.steelTrap and cd.freezingTrap.exists() and cd.tarTrap.exists())
            or (runeforge.nesingwarysTrappingApparatus.equiped and talent.steelTrap and cd.freezingTrap.exists() and cd.tarTrap.exists() and cd.steelTrap.exists()))
        or focus < cast.cost.mongooseBite()
    then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [BoP]") return true end
    end
    -- Steel Trap
    -- steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap("player","ground",1,5) and focus + cast.regen.steelTrap() < focusMax then
        if cast.steelTrap("player","ground",1,5) then ui.debug("Casting Steel Trap [BoP]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=buff.vipers_venom.up&refreshable|dot.serpent_sting.refreshable&!buff.coordinated_assault.up
    if cast.able.serpentSting(var.lowestSerpentSting) and buff.vipersVenom.exists() and debuff.serpentSting.refresh(var.lowestSerpentSting)
        or debuff.serpentSting.refresh(var.lowestSerpentSting) and not buff.coordinatedAssault.exists()
    then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [BoP - Refresh]") return true end
    end
    -- Resonating Arrow
    -- resonating_arrow
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.resonatingArrow("best",nil,1,15) then
        if cast.resonatingArrow("best",nil,1,15) then ui.debug("Casting Resonating Arrow [BoP]") return true end
    end
    -- Coordinated Assault
    -- coordinated_assault,if=!buff.coordinated_assault.up
    if ui.alwaysCdAoENever("Coordinated Assault",3,#var.eagleEnemies) and cast.able.coordinatedAssault() and unit.distance("target") < 5 then
        if cast.coordinatedAssault() then ui.debug("Casting Coordinated Assault [BoP]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,if=buff.mongoose_fury.up|focus+action.kill_command.cast_regen>focus.max|buff.coordinated_assault.up
    if talent.mongooseBite and cast.able.mongooseBite(var.eagleUnit) and (buff.mongooseFury.exists() or focus + cast.regen.killCommand() > focusMax or buff.coordinatedAssault.exists()) then
        if cast.mongooseBite(var.eagleUnit) then ui.debug("Casting Mongoose Bite [BoP]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison_injection.stack
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison) then
        if cast.raptorStrike(var.maxLatentPoison) then ui.debug("Casting Raptor Strike [BoP]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=dot.wildfire_bomb.refreshable
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and debuff.wildfireBomb.refresh(units.dyn40) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [BoP - Refresh]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=buff.vipers_venom.up
    if cast.able.serpentSting(var.lowestSerpentSting) and buff.vipersVenom.exists() then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [BoP]") return true end
    end
end -- End Action List - Birds of Prey

-- Action List - Cleave
actionList.Cleave = function()
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=talent.hydras_bite.enabled&buff.vipers_venom.remains&buff.vipers_venom.remains<gcd
    if cast.able.serpentSting(var.lowestSerpentSting) and talent.hydrasBite and buff.vipersVenom.exists() and buff.vipersVenom.remains() < unit.gcd(true) then
        if cast.serpentString(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [Cleave - Low Viper's Venom]") return true end
    end
    -- Wild Spirits
    -- wild_spirits
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.wildSpirits("best",nil,var.spiritUnits,12) then
        if cast.wildSpirits("best",nil,var.spiritUnits,12) then ui.debug("Casting Wild Spirits [Cleave]") return true end
    end
    -- Resonating Arrow
    -- resonating_arrow
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.resonatingArrow("best",nil,1,15) then
        if cast.resonatingArrow("best",nil,1,15) then ui.debug("Casting Resonating Arrow [Cleave]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=full_recharge_time<gcd
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and charges.wildfireBomb.timeTillFull() < unit.gcd(true) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [Cleave - Max Charges]") return true end
    end
    -- Chakrams
    -- chakrams
    if cast.able.chakrams("player","rect",1,40) and #enemies.yards40r > 0 then
        if cast.chakrams("player","rect",1,40) then ui.debug("Casting Chakrams [Cleave]") return true end
    end
    -- Butchery
    -- butchery,if=dot.shrapnel_bomb.ticking&(dot.internal_bleeding.stack<2|dot.shrapnel_bomb.remains<gcd)
    if talent.butchery and cast.able.butchery("player","aoe",1,8) and debuff.shrapnelBomb.exists("target")
        and (debuff.internalBleeding.stack() < 2 or debuff.shrapnelBomb.remains("target") < unit.gcd(true))
    then
        if cast.butchery("player","aoe",1,8) then ui.debug("Casting Butchery [Cleave - Shrapnel Bomb]") return true end
    end
    -- Carve
    -- carve,if=dot.shrapnel_bomb.ticking
    if not talent.butchery and cast.able.carve("player","cone",1,8) and debuff.shrapnelBomb.exists("target") then
        if cast.carve("player","cone",1,8) then ui.debug("Casting Carve [Cleave - Shrapnel Bomb]") return true end
    end
    -- Death Chakram
    -- death_chakram,if=focus+cast_regen<focus.max
    if ui.alwaysCdAoENever("Covenany Ability",3,#enemies.yards8t) and cast.able.deathChakram() and focus + cast.regen.deathChakram() < focusMax then
        if cast.deathChakram() then ui.debug("Casting Death Chakram [Cleave]") return true end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if ui.alwaysCdAoENever("Coordinated Assault",3,#var.eagleEnemies) and cast.able.coordinatedAssault() and unit.distance("target") < 5 then
        if cast.coordinatedAssault() then ui.debug("Casting Coordinated Assault [Cleave]") return true end
    end
    -- Butchery
    -- butchery,if=charges_fractional>2.5&cooldown.wildfire_bomb.full_recharge_time>spell_targets%2
    if talent.butchery and cast.able.butchery("player","aoe",1,8) and charges.butchery.frac() > 2.5 and charges.wildfireBomb.timeTillFull() > #enemies.yards8 / 2 then
        if cast.butchery("player","aoe",1,8) then ui.debug("Casting Butchery [Cleave - Max Charges]") return true end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and unit.distance("pet",units.dyn15) < 15 and (focus + cast.regen.flankingStrike() < focusMax) then
        if cast.flankingStrike() then ui.debug("Casting Flanking Strike [Cleave]") return true end
    end
    -- Carve
    -- carve,if=cooldown.wildfire_bomb.full_recharge_time>spell_targets%2&talent.alpha_predator.enabled
    if not talent.butchery and cast.able.carve("player","cone",1,8) and charges.wildfireBomb.timeTillFull() > #enemies.yards8 / 2 and talent.alphaPredator then
        if cast.carve("player","cone",1,8) then ui.debug("Casting Carve [Cleave - Alpha Predator]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&full_recharge_time<gcd&(runeforge.nessingwarys_trapping_apparatus.equipped&cooldown.freezing_trap.remains&cooldown.tar_trap.remains|!runeforge.nessingwarys_trapping_apparatus.equipped)
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet",units.dyn40) < 50 and focus + cast.regen.killCommand() < focusMax and charges.killCommand.timeTillFull() < unit.gcd(true)
        and (runeforge.nesingwarysTrappingApparatus.equiped and cd.freezingTrap.exists() and cd.tarTrap.exists() or not runeforge.nesingwarysTrappingApparatus.equiped)
    then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [Cleave - Max Charges]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=!dot.wildfire_bomb.ticking
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and not debuff.wildfireBomb.exists(units.dyn40) then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [Cleave]") return true end
    end
    -- Butchery
    -- butchery,if=(!next_wi_bomb.shrapnel|!talent.wildfire_infusion.enabled)&cooldown.wildfire_bomb.full_recharge_time>spell_targets%2
    if talent.butchery and cast.able.butchery("player","aoe",1,8) and (not nextBomb(spell.shrapnelBomb) or not talent.wildfireInfusion)
        and charges.wildfireBomb.timeTillFull() > #enemies.yards8 / 2
    then
        if cast.butchery("player","aoe",1,8) then ui.debug("Casting Butchery [Cleave - No Shrapnel Bomb]") return true end
    end
    -- Carve
    -- carve,if=cooldown.wildfire_bomb.full_recharge_time>spell_targets%2
    if not talent.butchery and cast.able.carve("player","cone",1,8) and charges.wildfireBomb.timeTillFull() > #enemies.yards8 / 2 then
        if cast.carve("player","cone",1,8) then ui.debug("Casting Carve [Cleave - No Wildfire Bomb Soon]") return true end
    end
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot("target") and (unit.hp("target") < 20 or buff.flayersMark.exists()) then
        if cast.killShot("target") then ui.debug("Casting Kill Shot [Cleave]") return true end
    end
    -- Flayed Shot
    -- flayed_shot
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards8t) and cast.able.flayedShot() then
        if cast.flayedShot() then ui.debug("Casting Flayed Shot [Cleave]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if ui.alwaysCdAoENever("A Murder of Crows",3,#var.eagleEnemies) and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [Cleave]") return true end
    end
    -- Steel Trap
    -- steel_trap
    if cast.able.steelTrap("player","ground",1,5) then
        if cast.steelTrap("player","ground",1,5) then ui.debug("Casting Steel Trap [Cleave]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=refreshable&talent.hydras_bite.enabled&target.time_to_die>8
    if cast.able.serpentSting(var.lowestSerpentSting) and debuff.serpentSting.refresh(var.lowestSerpentSting) and talent.hydrasBite and unit.ttd(var.lowestSerpentSting) > 8 then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [Cleave - Hydras Bite]") return true end
    end
    -- Carve
    -- carve
    if not talent.butchery and cast.able.carve("player","cone",1,8) then
        if cast.carve("player","cone",1,8) then ui.debug("Casting Carve [Cleave]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=focus+cast_regen<focus.max&(runeforge.nessingwarys_trapping_apparatus.equipped&cooldown.freezing_trap.remains&cooldown.tar_trap.remains|!runeforge.nessingwarys_trapping_apparatus.equipped)
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet",units.dyn40) < 50 and focus + cast.regen.killCommand() < focusMax
        and (runeforge.nesingwarysTrappingApparatus.equiped and cd.freezingTrap.exists() and cd.tarTrap.exists() or not runeforge.nesingwarysTrappingApparatus.equiped)
    then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Command [Cleave]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=refreshable
    if cast.able.serpentSting(var.lowestSerpentSting) and debuff.serpentSting.refresh(var.lowestSerpentSting) then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [Cleave]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison_injection.stack
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison) then
        if cast.mongooseBite(var.maxLatentPoison) then ui.debug("Casting Mongoose Bite [Cleave]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison_injection.stack
    if talent.raptorStrike and cast.able.raptorStrike(var.maxLatentPoison) then
        if cast.raptorStrike(var.maxLatentPoison) then ui.debug("Casting Raptor Strike [Cleave]") return true end
    end
end -- End Action List - Cleave

-- Action List - Single Target
actionList.St = function()
    -- Flayed Shot
    -- flayed_shot
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards8t) and cast.able.flayedShot() then
        if cast.flayedShot() then ui.debug("Casting Flayed Shot [St]") return true end
    end
    -- Wild Spirits
    -- wild_spirits
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.wildSpirits("best",nil,var.spiritUnits,12) then
        if cast.wildSpirits("best",nil,var.spiritUnits,12) then ui.debug("Casting Wild Spirits [St]") return true end
    end
    -- Resonating Arrow
    -- resonating_arrow
    if ui.alwaysCdAoENever("Covenant Ability",3,#enemies.yards12t) and cast.able.resonatingArrow("best",nil,1,15) then
        if cast.resonatingArrow("best",nil,1,15) then ui.debug("Casting Resonating Arrow [St]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=buff.vipers_venom.up&buff.vipers_venom.remains<gcd|!ticking
    if cast.able.serpentSting(var.lowestSerpentSting) and buff.vipersVenom.exists() and buff.vipersVenom.remains() < unit.gcd(true) or not debuff.serpentSting.exists(var.lowestSerpentSting) then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [St - Vipers Venom Expire Soon / No Serpent Sting]") return true end
    end
    -- Death Chakram
    -- death_chakram,if=focus+cast_regen<focus.max
    if ui.alwaysCdAoENever("Covenany Ability",3,#enemies.yards8t) and cast.able.deathChakram() and focus + cast.regen.deathChakram() < focusMax then
        if cast.deathChakram() then ui.debug("Casting Death Chakram [St]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.tip_of_the_spear.stack=3
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison) and buff.tipOfTheSpear.stack() == 3 then
        if cast.raptorStrike(var.maxLatentPoison) then ui.debug("Casting Raptor Strike [St - Tip of the Spear]") return true end
    end
    -- Coordinated Assault
    -- coordinated_assault
    if ui.alwaysCdAoENever("Coordinated Assault",3,#var.eagleEnemies) and cast.able.coordinatedAssault() and unit.distance("target") < 5 then
        if cast.coordinatedAssault() then ui.debug("Casting Coordinated Assault [St]") return true end
    end
    -- Kill Shot
    -- kill_shot
    if cast.able.killShot("target") and (unit.hp("target") < 20 or buff.flayersMark.exists()) then
        if cast.killShot("target") then ui.debug("Casting Kill Shot [St]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=full_recharge_time<gcd&focus+cast_regen<focus.max|(next_wi_bomb.volatile&dot.serpent_sting.ticking&dot.serpent_sting.refreshable|next_wi_bomb.pheromone&focus+cast_regen<focus.max-action.kill_command.cast_regen*3&!buff.mongoose_fury.remains)
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and (charges.wildfireBomb.timeTillFull() < unit.gcd(true) and focus + cast.regen.wildfireBomb() < focusMax or (nextBomb(spell.volatileBomb)
        and debuff.serpentSting.exists(units.dyn40) and debuff.serpentSting.refresh(units.dyn40) or nextBomb(spell.phearomoneBomb)
        and focus + cast.regen.wildfireBomb() < focusMax - cast.regen.killCommand() * 3 and not buff.mongooseFury.exists()))
    then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [St - Max Charges]") return true end
    end
    -- Steel Trap
    -- steel_trap,if=focus+cast_regen<focus.max
    if cast.able.steelTrap("player","ground",1,5) and focus + cast.regen.steelTrap() < focusMax then
        if cast.steelTrap("player","ground",1,5) then ui.debug("Casting Steel Trap [St]") return true end
    end
    -- Flanking Strike
    -- flanking_strike,if=focus+cast_regen<focus.max
    if cast.able.flankingStrike() and unit.distance("pet",units.dyn15) < 15 and (focus + cast.regen.flankingStrike() < focusMax) then
        if cast.flankingStrike() then ui.debug("Casting Flanking Strike [St]") return true end
    end
    -- Kill Command
    -- kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&(runeforge.nessingwarys_trapping_apparatus.equipped&cooldown.freezing_trap.remains&cooldown.tar_trap.remains|!runeforge.nessingwarys_trapping_apparatus.equipped)
    if cast.able.killCommand(var.lowestBloodseeker) and unit.distance("pet",units.dyn40) < 50 and focus + cast.regen.killCommand() < focusMax
        and (runeforge.nesingwarysTrappingApparatus.equiped and cd.freezingTrap.exists() and cd.tarTrap.exists() or not runeforge.nesingwarysTrappingApparatus.equiped)
    then
        if cast.killCommand(var.lowestBloodseeker) then ui.debug("Casting Kill Comamand [St]") return true end
    end
    -- Carve
    -- carve,if=active_enemies>1&!runeforge.rylakstalkers_confounding_strikes.equipped
    if not talent.butchery and cast.able.carve("player","cone",1,8) and #enemies.yards8 > 1 and not runeforge.rylakstalkersConfoundingStrikes.equiped then
        if cast.carve("player","cone",1,8) then ui.debug("Casting Carve [St]") return true end
    end
    -- Butchery
    -- butchery,if=active_enemies>1&!runeforge.rylakstalkers_confounding_strikes.equipped&cooldown.wildfire_bomb.full_recharge_time>spell_targets&(charges_fractional>2.5|dot.shrapnel_bomb.ticking)
    if talent.butchery and cast.able.butchery("player","aoe",1,8) and #enemies.yards8 > 1 and not runeforge.rylakstalkersConfoundingStrikes.equiped
        and charges.wildfireBomb.timeTillFull() > #enemies.yards8 and (charges.butchery.frac() > 2.5 or debuff.shrapnelBomb.exists("target"))
    then
        if cast.butchery("player","aoe",1,8) then ui.debug("Casting Butchery [St]") return true end
    end
    -- A Murder of Crows
    -- a_murder_of_crows
    if ui.alwaysCdAoENever("A Murder of Crows",3,#var.eagleEnemies) and cast.able.aMurderOfCrows() then
        if cast.aMurderOfCrows() then ui.debug("Casting A Murder of Crows [St]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=dot.shrapnel_bomb.ticking|buff.mongoose_fury.stack=5
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison) and (debuff.shrapnelBomb.exists(var.maxLatentPoison) or buff.mongooseFury.stack() == 5) then
        if cast.mongooseBite(var.maxLatentPoison) then ui.debug("Casting Mongoose Bite [St - Shrapnel Bomb / Mongoose Fury 5 Stack]") return true end
    end
    -- Serpent Sting
    -- serpent_sting,target_if=min:remains,if=refreshable|buff.vipers_venom.up
    if cast.able.serpentSting(var.lowestSerpentSting) and (debuff.serpentSting.refresh(var.lowestSerpentSting) or buff.vipersVenom.exists()) then
        if cast.serpentSting(var.lowestSerpentSting) then ui.debug("Casting Serpent Sting [St - Refresh / Viper's Venom]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.shrapnel&dot.serpent_sting.remains>5*gcd|runeforge.rylakstalkers_confounding_strikes.equipped
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and (nextBomb(spell.shrapnelBomb)
        and debuff.serpentSting.remains(units.dyn40) > 5 * unit.gcd(true) or runeforge.rylakstalkersConfoundingStrikes.equiped)
    then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [St - Shrapnel Bomb / Rylakstalker's]") return true end
    end
    -- Chakrams
    -- chakrams
    if cast.able.chakrams("player","rect",1,40) and #enemies.yards40r > 0 then
        if cast.chakrams("player","rect",1,40) then ui.debug("Casting Chakrams [St]") return true end
    end
    -- Mongoose Bite
    -- mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.mongoose_fury.up|focus+action.kill_command.cast_regen>focus.max-15|dot.shrapnel_bomb.ticking
    if talent.mongooseBite and cast.able.mongooseBite(var.maxLatentPoison) and (buff.mongooseFury.exists()
        or focus + cast.regen.killCommand() > focusMax - 15 or debuff.shrapnelBomb.exists(var.maxLatentPoison) or buff.wildSpirits.exists())
    then
        if cast.mongooseBite(var.maxLatentPoison) then ui.debug("Casting Mongoose Bite [St]") return true end
    end
    -- Raptor Strike
    -- raptor_strike,target_if=max:debuff.latent_poison_injection.stack
    if not talent.mongooseBite and cast.able.raptorStrike(var.maxLatentPoison) then
        if cast.raptorStrike(var.maxLatentPoison) then ui.debug("Casting Raptor Strike [St]") return true end
    end
    -- Wildfire Bomb
    -- wildfire_bomb,if=next_wi_bomb.volatile&dot.serpent_sting.ticking|next_wi_bomb.pheromone|next_wi_bomb.shrapnel
    if cast.able.wildfireBomb(units.dyn40,"cone",1,8) and (nextBomb(spell.volatileBomb) and debuff.serpentSting.exists(units.dyn40)
        or nextBomb(spell.pheromoneBomb) or nextBomb(spell.shrapnelBomb))
    then
        if cast.wildfireBomb(units.dyn40,"cone",1,8) then ui.debug("Casting Wildfire Bomb [St]") return true end
    end
end -- End Action List - Single Target

-- Action List - Opener
actionList.Opener = function()
    -- Harpoon
    if ui.checked("Harpoon - Opener") and ui.mode.harpoon == 1 and cast.able.harpoon("target") and unit.valid("target")
        and unit.distance("target") >= 8 and unit.distance("target") < 30
    then
        if cast.harpoon("target") then ui.debug("") return true end
    end
    -- Start Attack
    -- auto_attack
    if (ui.value("Opener") == 1 or (ui.value("Opener") == 2 and ui.useCDs())) and not opener.complete then
        if unit.valid("target") and unit.distance("target") < var.eagleRange
            and unit.facing("player","target") and br.getSpellCD(61304) == 0
        then
            -- Begin
            if not opener.OPN1 then
                ui.print("Starting Opener")
                opener.count = opener.count + 1
                opener.OPN1 = true
                unit.startAttack()
                return
            -- Coordinated Assault
            elseif opener.OPN1 and not opener.CA1 then
                if level < 40 or cd.coordinatedAssault.remain() > gcd then
                    cast.openerFail("coordinatedAssault","CA1",opener.count)
                elseif cast.able.coordinatedAssault() then
                    cast.opener("coordinatedAssault","CA1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Serpent Sting
            elseif opener.CA1 and not opener.SS1 then
                if level < 12 or debuff.serpentSting.exists("target") then
                    cast.openerFail("serpentSting","SS1",opener.count)
                elseif cast.able.serpentSting() then
                    cast.opener("serpentSting","SS1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Wildfire Bomb
            elseif opener.SS1 and not opener.WB1 then
                if level < 20 or charges.wildfireBomb.count() == 0 then
                    cast.openerFail("wildfireBomb","WB1",opener.count)
                elseif cast.able.wildfireBomb(units.dyn40,"aoe") then
                    cast.opener("wildfireBomb","WB1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Raptor Strike
            elseif opener.WB1 and not opener.RS1 then
                if not cast.able.raptorStrike() then
                    cast.openerFail("raptorStrike","RS1",opener.count)
                elseif cast.able.raptorStrike() then
                    cast.opener("raptorStrike","RS1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- Kill Command
            elseif opener.RS1 and not opener.KC1 then
                if cd.killCommand.remain() > gcd then
                    cast.openerFail("killCommand","KC1",opener.count)
                elseif cast.able.killCommand() then
                    cast.opener("killCommand","KC1",opener.count)
                end
                opener.count = opener.count + 1
                return
            -- End
            elseif opener.KC1 and opener.OPN1 then
                ui.print("Opener Complete")
                opener.count = 0
                opener.complete = true
            end
        end
    elseif (unit.exists("target") and (ui.value("Opener") == 2 and not ui.useCDs())) or ui.value("Opener") == 3 then
        opener.complete = true
    end
end -- End Action List - Opener

-- Action List - Pre-Combat
actionList.PreCombat = function()
    -- FlaskUp Module
    module.FlaskUp("Agility")
    -- Init Combat
    if not unit.inCombat() and unit.distance("target") < 40 and unit.valid("target") then --and opener.complete then
        -- Steel Trap
        -- steel_trap
        if cast.able.steelTrap("target") then
            if cast.steelTrap("target") then ui.debug("Casting Steel Trap [Pre-Combat]") return true end
        end
        -- Serpent Sting
        if cast.able.serpentSting("target") and (unit.ttd("target") > 3 or unit.isDummy()) and not debuff.serpentSting.exists("target") then
            if cast.serpentSting("target") then ui.debug("Casting Serpent Sting [Pre-Combat]") return true end
        end
        -- Auto Attack
        -- actions=auto_attack
        if cast.able.autoAttack("target") then
            if cast.autoAttack("target") then ui.debug("Casting Auto Attack [Pre-Combat]") return true end
        end
    end
    -- Call Action List - Opener
    -- if actionList.Opener() then return true end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local function runRotation()
        --------------------------------------
    --- Load Additional Rotation Files ---
    --------------------------------------
    if actionList.PetManagement == nil then
        actionList.PetManagement = br.rotations.support["PetCuteOne"].run
    end
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    anima                                         = br.player.anima
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    focus                                         = br.player.power.focus.amount()
    focusMax                                      = br.player.power.focus.max()
    focusRegen                                    = br.player.power.focus.regen()
    level                                         = br.player.level
    module                                        = br.player.module
    opener                                        = br.player.opener
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
    -- enemies.get(20,"pet")
    enemies.get(30)
    -- enemies.get(30,"pet")
    -- enemies.rect.get(10,30,false)
    enemies.get(40)
    -- enemies.get(40,"player",true)
    enemies.get(40,"player",false,true)
    enemies.rect.get(10,40,false)
    -- Opener Reset
    if (not unit.inCombat() and not unit.exists("target")) or opener.complete == nil then
        opener.count = 0
        opener.OPN1 = false
        opener.CA1 = false
        opener.SS1 = false
        opener.WB1 = false
        opener.RS1 = false
        opener.KC1 = false
        opener.complete = false
    end
    -- General Locals
    var.minCount                                  = ui.useCDs() and 1 or 3
    var.haltProfile                               = (unit.inCombat() and var.profileStop) or unit.mounted() or unit.flying() or ui.pause() or buff.feignDeath.exists() or ui.mode.rotation==4
    -- Profile Specific Locals
    var.eagleUnit                                       = buff.aspectOfTheEagle.exists() and units.dyn40 or units.dyn5
    var.eagleRange                               = buff.aspectOfTheEagle.exists() and 40 or 5
    var.eagleEnemies                                    = buff.aspectOfTheEagle.exists() and enemies.yards40 or enemies.yards5
    var.lowestBloodseeker                         = debuff.bloodseeker.lowest(40,"remain") or var.eagleUnit
    var.lowestSerpentSting                        = debuff.serpentSting.lowest(40,"remain") or var.eagleUnit
    var.maxLatentPoison                           = debuff.latentPoison.max(var.eagleRange,"stack") or var.eagleUnit
    var.spiritUnits                                     = ui.useCDs() and 1 or 3

    if var.tarred == nil or cd.tarTrap.remain() == 0 or not unit.inCombat() then var.tarred = false end

    -- if var.eagleUnit == nil then var.eagleUnit = "target" end
    -- variable,name=carve_cdr,op=setif,value=active_enemies,value_else=5,condition=active_enemies<5
    var.carveCdr = #enemies.yards5 < 5 and #enemies.yards5 or 5

    var.lowestTTDUnit = "target"
    var.lowestTTD = 99
    for i = 1, #var.eagleEnemies do
        local thisUnit = var.eagleEnemies[i]
        if unit.ttd(thisUnit) < var.lowestTTD then
            var.lowestTTD = unit.ttd(thisUnit)
            var.lowestTTDUnit = thisUnit
        end
    end

    -----------------
    --- Pet Logic ---
    -----------------
    if actionList.PetManagement() then return true end
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    -- if not unit.inCombat() and not unit.exists("target") and var.profileStop then
    --     var.profileStop = false
    -- elseif var.haltProfile then
    --     if cast.able.playDead() and cast.last.feignDeath() and not buff.playDead.exists("pet") then
    --         if cast.playDead() then ui.debug("Casting Play Dead [Pet]") return true end
    --     end
    --     -- unit.stopAttack()
    --     --if unit.isDummy() then unit.clearTarget() end
    --     return true
    -- else
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif var.haltProfile then
        return true
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------------
        --- Extras Rotation ---
        -----------------------
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
        if unit.inCombat() and unit.valid("target") --[[and opener.complete]] then
            ------------------------------
            --- In Combat - Interrupts ---
            ------------------------------
            if actionList.Interrupt() then return true end
            -- Auto Attack
            -- actions=auto_attack
            if cast.able.autoAttack("target") then
                if cast.autoAttack("target") then ui.debug("Casting Auto Attack") return true end
            end
            -- -- Tar Trap
            -- if ui.alwaysCdAoENever("Tar Trap",3,#enemies.yards40) and cast.able.tarTrap("best",nil,1,8) then
            --     if cast.tarTrap("best",nil,1,8) then ui.debug("Casting Tar Trap") var.tarred = true return true end
            -- end
            -- -- Flare
            -- if ui.alwaysCdAoENever("Flare",1,#enemies.yards40) and cast.able.flare("groundLocation",br.castPosition.x,br.castPosition.y,8) and var.tarred then--and debuff.tarTrap.exists(units.dyn40) then
            --     if cast.flare("groundLocation",br.castPosition.x,br.castPosition.y,8) then ui.debug("Casting Flare") var.tarred = false return true end
            -- end
            -- Cooldowns
            -- call_action_list,name=CDs
            if actionList.Cooldown() then return true end
            if (ui.mode.rotation == 1 and eagleScout() < 3) or (ui.mode.rotation == 3 and eagleScout() > 0) or level < 23 then
                -- Call Action List - Birds of Prey
                -- call_action_list,name=bop,if=active_enemies<3&!talent.alpha_predator.enabled&!talent.wildfire_infusion.enabled
                if not talent.alphaPredator and not talent.wildfireInfusion then
                    if actionList.BoP() then return true end
                end
                -- Call Action List - Birds of Prey / Alpha Predator
                -- call_action_list,name=apbop,if=active_enemies<3&talent.alpha_predator.enabled&!talent.wildfire_infusion.enabled
                if talent.alphaPredator and not talent.wildfireInfusion then
                    if actionList.ApBoP() then return true end
                end
                -- Call Action List - Alpha Predator / Wildfire Infusion
                -- call_action_list,name=apst,if=active_enemies<3&talent.alpha_predator.enabled&talent.wildfire_infusion.enabled
                if talent.alphaPredator and talent.wildfireInfusion then
                    if actionList.ApSt() then return true end
                end
                -- Call Action List - Single Target
                -- call_action_list,name=st,if=active_enemies<3&!talent.alpha_predator.enabled&!talent.wildfire_infusion.enabled
                if not talent.alphaPredator and not talent.wildfireInfusion then
                    if actionList.St() then return true end
                end
            end
            -- Call Action List - Cleave
            -- call_action_list,name=cleave,if=active_enemies>1&!talent.birds_of_prey.enabled|active_enemies>2
            if ((ui.mode.rotation == 1 and (((eagleScout() > 1 or #enemies.yards8f > 1) and not talent.birdsOfPrey)
                    or (eagleScout() > 2 or #enemies.yards8f > 2)))
                or (ui.mode.rotation == 2 and eagleScout() > 0)) and level >= 23
            then
                if actionList.Cleave() then return true end
            end
            -- Racial - Arcane Torrent
            -- arcane_torrent
            if ui.checked("Racial") and cast.able.racial() and unit.race() == "BloodElf" then
                if cast.racial() then ui.debug("Casting Racial") return true end
            end
        end -- End In Combat Rotation
    end -- Pause
    return true
end -- End runRotation
local id = 255
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
