local rotationName = "ForsoothMarksmanship"
br.loadSupport("PetCuteOne")

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enables Rotation", highlight = 1, icon = br.player.spell.steadyShot},
        [2] = { mode = "Off", value = 2 , overlay = "Rotation Disabled", tip = "Disables Rotation", highlight = 0, icon = br.player.spell.steadyShot}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Enables Defensive", highlight = 1, icon = br.player.spell.exhilaration},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "Disables Defensive", highlight = 0, icon = br.player.spell.exhilaration}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
    -- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupt Enabled", tip = "Enables Interrupt", highlight = 1, icon = br.player.spell.freezingTrap},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupt Disabled", tip = "Disables Interrupt", highlight = 0, icon = br.player.spell.freezingTrap}
    };
    br.ui:createToggle(InterruptModes,"Interrupt",3,0)
    -- Pet summon
    local PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Summon Pet 1", tip = "Summon Pet 1", highlight = 1, icon = br.player.spell.callPet1 },
        [2] = { mode = "2", value = 2 , overlay = "Summon Pet 2", tip = "Summon Pet 2", highlight = 1, icon = br.player.spell.callPet2 },
        [3] = { mode = "3", value = 3 , overlay = "Summon Pet 3", tip = "Summon Pet 3", highlight = 1, icon = br.player.spell.callPet3 },
        [4] = { mode = "4", value = 4 , overlay = "Summon Pet 4", tip = "Summon Pet 4", highlight = 1, icon = br.player.spell.callPet4 },
        [5] = { mode = "5", value = 5 , overlay = "Summon Pet 5", tip = "Summon Pet 5", highlight = 1, icon = br.player.spell.callPet5 },
        [6] = { mode = "None", value = 6 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.callPet }
    };
    br.ui:createToggle(PetSummonModes,"PetSummon",4,0)
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
        -------------------
        --- PET OPTIONS ---
        -------------------
        br.rotations.support["PetCuteOne"].options()
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            -- Aspect of the Turtle
            br.ui:createSpinner(section, "Aspect of the Turtle", 25, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Disengage
            br.ui:createCheckbox(section, "Disengage")
            -- Exhilaration
            br.ui:createSpinner(section, "Exhilaration", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Feign Death
            br.ui:createSpinner(section, "Feign Death", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Wing Clip
            br.ui:createCheckbox(section, "Wing Clip")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Freezing Trap
            br.ui:createCheckbox(section, "Freezing Trap")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section,  "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
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
local talent
local cast
local cd
local debuff
local enemies
local equiped
local charges
local focus
local module
local gcd
local ui
local unit
local units
local use
-- Profile Specific Locals
local actionList = {}
local var = {}
var.getFacingDistance = br._G["getFacingDistance"]
var.getItemInfo = br._G["GetItemInfo"]
var.haltProfile = false
var.loadSupport = br._G["loadSupport"]
var.profileStop = false
var.specificToggle = br._G["SpecificToggle"]

--------------------
--- Action Lists ---
--------------------
-- Action List - Extra
actionList.Extra = function()
    -- Hunter's Mark
    if ui.checked("Hunter's Mark") and cast.able.huntersMark() and not debuff.huntersMark.exists(units.dyn40) then
        if cast.huntersMark() then ui.debug("Cast Hunter's Mark") return true end
    end
end -- End Action List- Extra

-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Aspect of the Turtle
        if ui.checked("Aspect of the Turtle") and cast.able.aspectOfTheTurtle()
            and unit.inCombat() and unit.hp() < ui.value("Apect of the Turtle")
        then
            if cast.aspectOfTheTurtle() then ui.debug("Casting Aspect of the Turtle") return true end
        end
        -- Exhilaration
        if ui.checked("Exhilaration") and cast.able.exhilaration() and unit.hp() < ui.value("Exhilaration") then
            if cast.exhilaration() then ui.debug("Casting Exhilaration") return true end
        end
        -- Feign Death
        if ui.checked("Feign Death") and cast.able.feignDeath()
            and unit.inCombat() and unit.hp() < ui.value("Feign Death")
        then
            if cast.feignDeath() then ui.debug("Casting Feign Death - Shh! Maybe they won't notice.") return true end
        end
        -- Wing Clip
        if ui.checked("Wing Clip") and cast.able.wingClip() and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            if cast.wingClip() then ui.debug("Casting Wing Clip") return true end
        end
        -- Disengage
        if ui.checked("Disengage") and cast.able.disengage("player") and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
            if cast.disengage("player") then ui.debug("Casting Disengage") return true end
        end
    end
end -- End Action List - Defensive

-- Action List - Interrupt
actionList.Interrupt = function()
    if ui.useInterrupt() then
        for i=1, #enemies.yards5 do
            local thisUnit = enemies.yards5[i]
            if br.canInterrupt(thisUnit,80) then
                -- Freezing Trap
                if cast.able.freezingTrap() then
                    for i = 1, #enemies.yards40 do
                        thisUnit = enemies.yards40[i]
                        if unit.distance(thisUnit) > 8 and cast.timeRemain(thisUnit) > 3 then
                            if cast.freezingTrap(thisUnit,"ground") then return true end
                        end
                    end
                end
            end
        end
    end -- End Interrupt Check
end -- End Action List - Interrupt

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not unit.mounted() then
        if unit.valid("target") then
            -- Start Attack
            if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                br._G.StartAttack(units.dyn40)
            end
            -- aimed_shot,if=active_enemies<3&(!talent.volley|active_enemies<2)
            if cast.able.aimedShot() and #enemies.yards40 < 3 and (not talent.volley or #enemies.yards40 < 2) then
                cast.aimedShot()
            end
            -- wailing_arrow,if=active_enemies>2|!talent.steady_focus
            if cast.able.wailingArrow() and #enemies.yards40 > 2 or not talent.steadyFocus then
                cast.wailingArrow()
            end
            -- steady_shot,if=active_enemies>2|talent.volley&active_enemies=2
            if cast.able.steadyShot() and #enemies.yards40 > 2 or talent.volley and #enemies.yards40 == 2 then
                cast.steadyShot()
            end
        end
    end
end -- End Action List - PreCombat

actionList.ST = function()
    -- steady_shot,if=talent.steady_focus&(steady_focus_count&buff.steady_focus.remains<5|buff.steady_focus.down&!buff.trueshot.up)
    if cast.able.steadyShot() and talent.steadyFocus and (buff.steadyFocus.remains() < 5 or not buff.steadyFocus.exists() and not buff.trueshot.exists()) then
        cast.steadyShot()
    end
    -- 	aimed_shot,if=buff.trueshot.up&full_recharge_time<gcd+cast_time&talent.legacy_of_the_windrunners&talent.windrunners_guidance
    if cast.able.aimedShot() and buff.trueshot.exists() and charges.aimedShot.timeTillFull() < gcd+cast.time.aimedShot() and talent.legacyOfTheWindrunner and talent.windrunnersGuidance then
        cast.aimedShot()
    end
    -- kill_shot,if=buff.trueshot.down
    if cast.able.killShot() and not buff.trueshot.exists() then
        cast.killShot()
    end
    -- volley,if=buff.salvo.up
    if cast.able.volley() and buff.salvo.exists() then
        cast.volley("best",nil,1,8)
    end
    -- steel_trap,if=buff.trueshot.down
    if cast.able.steelTrap() and not buff.trueshot.exists() then
        cast.steelTrap()
    end
    -- serpent_sting,target_if=min:dot.serpent_sting.remains,if=refreshable&!talent.serpentstalkers_trickery&buff.trueshot.down
    if not talent.serpentStalkersTrickery and not buff.trueshot.exists() and cast.able.serpentSting() then
        local lowestSerpentStingRemaining = 12
        local lowestSerpentStingPlayer = {}
        for i=1, #enemies.yards40 do
            if debuff.serpentSting.exists(enemies.yards40[i]) and debuff.serpentSting.remains(enemies.yards40[i]) < 12 then
                lowestSerpentStingRemaining = debuff.serpentSting.remains(enemies.yards40[i])
                lowestSerpentStingPlayer = enemies.yards40[i]
            end
        end

        if lowestSerpentStingRemaining < 12 then
            cast.serpentSting(lowestSerpentStingPlayer)
        end
    end
    -- explosive_shot
    if cast.able.explosiveShot() then
        cast.explosiveShot()
    end
    -- stampede
    if cast.able.stampede() then
        cast.stampede()
    end
    -- death_chakram
    if cast.able.deathChakram() then
        cast.deathChakram()
    end
    -- wailing_arrow,if=active_enemies>1
    if cast.able.wailingArrow() and #enemies.yards40 > 1 then
        cast.wailingArrow()
    end
    -- 	rapid_fire,if=talent.surging_shots|action.aimed_shot.full_recharge_time>action.aimed_shot.cast_time+cast_time
    if cast.able.rapidFire() and talent.surgingShots or charges.aimedShot.timeTillFull() > cast.time.aimedShot() + cast.time.rapidFire() then
        cast.rapidFire()
    end
    -- 	kill_shot
    if cast.able.killShot() then
        cast.killShot()
    end
    -- trueshot,if=variable.trueshot_ready
    if br.isBoss() and unit.ttd() >= 15 and cast.able.trueshot then
        cast.trueshot()
    end
    --multishot,if=buff.salvo.up&!talent.volley
    if cast.able.multishot() and buff.salvo.exists() and not talent.volley() then
        cast.multishot()
    end
    -- 	aimed_shot,target_if=min:dot.serpent_sting.remains+action.serpent_sting.in_flight_to_target*99,if=talent.serpentstalkers_trickery&(buff.precise_shots.down|(buff.trueshot.up|full_recharge_time<gcd+cast_time)&(!talent.chimaera_shot|active_enemies<2|ca_active)|buff.trick_shots.remains>execute_time&active_enemies>1)
    if not talent.serpentStalkersTrickery and cast.able.aimedShot() and (not buff.preciseShots.exists() or (buff.trueshot.exists() or charges.aimedShot.timeTillFull()<gcd+cast.time.aimedShot()) and (not talent.chimaeraShot or #enemies.yards40 < 2) or buff.trickShots.remains()>cast.time.aimedShot() and #enemies.yards40 > 1) then
        local lowestSerpentStingRemaining = 12
        local lowestSerpentStingPlayer = {}
        for i=1, #enemies.yards40 do
            if debuff.serpentSting.exists(enemies.yards40[i]) and debuff.serpentSting.remains(enemies.yards40[i]) < lowestSerpentStingRemaining then
                lowestSerpentStingRemaining = debuff.serpentSting.remains(enemies.yards40[i])
                lowestSerpentStingPlayer = enemies.yards40[i]
            end
        end

        if lowestSerpentStingRemaining < 12 then
            cast.aimedShot(lowestSerpentStingPlayer)
        end
    end
    -- aimed_shot,target_if=max:debuff.latent_poison.stack,if=buff.precise_shots.down|(buff.trueshot.up|full_recharge_time<gcd+cast_time)&(!talent.chimaera_shot|active_enemies<2|ca_active)|buff.trick_shots.remains>execute_time&active_enemies>1
    if cast.able.aimedShot() and not buff.preciseShots.exists() or (buff.trueshot.exists() or charges.aimedShot.timeTillFull()<gcd+cast.time.aimedShot()) and (not talent.chimaeraShot or #enemies.yards40 < 2) or buff.trickShots.remains() > cast.time.aimedShot() and #enemies.yards40 > 1 then
        local highestPoisonStack = 0
        local highestPoisonStackPlayer = {}
        for i=1, #enemies.yards40 do
            if debuff.latentPoison.exists(enemies.yards40[i]) and debuff.latentPoison.stack() > highestPoisonStack then
                highestPoisonStack = debuff.latentPoison.stack(enemies.yards40[i])
                highestPoisonStackPlayer = enemies.yards40[i]
            end
        end

        if highestPoisonStack > 0 then
            cast.aimedShot(highestPoisonStackPlayer)
        end
    end
    -- volley
    if cast.able.volley() then
        cast.volley("best",nil,1,8)
    end
    -- 	rapid_fire
    if cast.able.rapidFire() then
        cast.rapidFire()
    end
    -- wailing_arrow,if=buff.trueshot.down
    if cast.able.wailingArrow() and not buff.trueshot.exists() then
        cast.wailingArrow()
    end
    -- kill_command,if=buff.trueshot.down
    if cast.able.killCommand() and not buff.trueshot.exists() then
        cast.killCommand()
    end
    -- steel_trap
    if cast.able.steelTrap() then
        cast.steelTrap()
    end
    -- chimaera_shot,if=buff.precise_shots.up|focus>cost+action.aimed_shot.cost
    if cast.able.chimaeraShot() and buff.preciseShots.exists() or focus > cast.cost.chimaeraShot() + cast.cost.aimedShot() then
        cast.chimaeraShot()
    end
    -- arcane_shot,if=buff.precise_shots.up|focus>cost+action.aimed_shot.cost
    if cast.able.arcaneShot() and buff.preciseShots.exists() or focus > cast.cost.arcaneShot() + cast.cost.aimedShot() then
        cast.arcaneShot()
    end
    -- 	bag_of_tricks,if=buff.trueshot.down
    --if cast.able.bagOfTricks() and not buff.trueshot.exists() then
    --    cast.bagOfTricks()
    --end
    -- steady_shot
    if cast.able.steadyShot() then
        cast.steadyShot()
    end
end

actionList.Trickshots = function()
    -- steady_shot,if=talent.steady_focus&steady_focus_count&buff.steady_focus.remains<8
    if cast.able.steadyShot() and talent.steadyFocus and buff.steadyFocus.remains() < 8 then
        cast.steadyShot()
    end
    -- kill_shot,if=buff.razor_fragments.up
    if cast.able.killShot() and buff.razorFragments.exists() then
        cast.killShot()
    end
    -- explosive_shot
    if cast.able.explosiveShot() then
        cast.explosiveShot()
    end
    -- death_chakram
    if cast.able.deathChakram() then
        cast.deathChakram()
    end
    -- stampede
    if cast.able.stampede() then
        cast.stampede()
    end
    -- wailing_arrow
    if cast.able.wailingArrow() then
        cast.wailingArrow()
    end
    -- 	serpent_sting,target_if=min:dot.serpent_sting.remains,if=refreshable&talent.hydras_bite&!talent.serpentstalkers_trickery
    if not talent.serpentStalkersTrickery and talent.hydrasBite and cast.able.serpentSting() then
        local lowestSerpentStingRemaining = 12
        local lowestSerpentStingPlayer = {}
        for i=1, #enemies.yards40 do
            if debuff.serpentSting.exists(enemies.yards40[i]) and debuff.serpentSting.remains(enemies.yards40[i]) < 12 then
                lowestSerpentStingRemaining = debuff.serpentSting.remains(enemies.yards40[i])
                lowestSerpentStingPlayer = enemies.yards40[i]
            end
        end

        if lowestSerpentStingRemaining < 12 then
            cast.serpentSting(lowestSerpentStingPlayer)
        end
    end
    -- 	barrage,if=active_enemies>7
    if cast.able.barrage() and #enemies.yards40 > 7 then
        cast.barrage()
    end
    -- volley
    if cast.able.volley() then
        cast.volley("best",nil,2,8)
    end
    -- trueshot,if=buff.trueshot.down
    if br.isBoss() and unit.ttd() > 15 and cast.able.trueshot() and not buff.trueshot.exists() then
        cast.trueshot()
    end
    -- 	rapid_fire,if=buff.trick_shots.remains>=execute_time&talent.surging_shots
    if cast.able.rapidFire() and buff.trickShots.remains() > cast.time.rapidFire() and talent.surgingShots then
        cast.rapidFire()
    end
    -- aimed_shot,target_if=min:dot.serpent_sting.remains+action.serpent_sting.in_flight_to_target*99,if=talent.serpentstalkers_trickery&(buff.trick_shots.remains>=execute_time&(buff.precise_shots.down|buff.trueshot.up|full_recharge_time<cast_time+gcd))
    if not talent.serpentStalkersTrickery and (buff.trickShots.remains() >= cast.time.aimedShot() and (not buff.preciseShots.exists() or buff.trueshot.exists() or charges.aimedShot.timeTillFull()<cast.time.aimedShot()+gcd))and cast.able.aimedShot() then
        local lowestSerpentStingRemaining = 12
        local lowestSerpentStingPlayer = {}
        for i=1, #enemies.yards40 do
            if debuff.serpentSting.exists(enemies.yards40[i]) and debuff.serpentSting.remains(enemies.yards40[i]) < 12 then
                lowestSerpentStingRemaining = debuff.serpentSting.remains(enemies.yards40[i])
                lowestSerpentStingPlayer = enemies.yards40[i]
            end
        end

        if lowestSerpentStingRemaining < 12 then
            cast.aimedShot(lowestSerpentStingPlayer)
        end
    end
    -- 	aimed_shot,target_if=max:debuff.latent_poison.stack,if=(buff.trick_shots.remains>=execute_time&(buff.precise_shots.down|buff.trueshot.up|full_recharge_time<cast_time+gcd))
    if cast.able.aimedShot() and buff.trickShots.remains() > cast.time.aimedShot() and (not buff.preciseShots.exists() or buff.trueshot.exists() or charges.aimedShot.timeTillFull()<cast.time.aimedShot()+gcd) then
        local highestPoisonStack = 0
        local highestPoisonStackPlayer = {}
        for i=1, #enemies.yards40 do
            if debuff.latentPoison.exists(enemies.yards40[i]) and debuff.latentPoison.stack() > highestPoisonStack then
                highestPoisonStack = debuff.latentPoison.stack(enemies.yards40[i])
                highestPoisonStackPlayer = enemies.yards40[i]
            end
        end

        if highestPoisonStack > 0 then
            cast.aimedShot(highestPoisonStackPlayer)
        end
    end
    -- rapid_fire,if=buff.trick_shots.remains>=execute_time
    if cast.able.rapidFire() and buff.trickShots.remains() >= cast.time.rapidFire() then
        cast.rapidFire()
    end
    -- 	chimaera_shot,if=buff.trick_shots.up&buff.precise_shots.up&focus>cost+action.aimed_shot.cost&active_enemies<4
    if cast.able.chimaeraShot() and buff.trickShots.exists() and buff.preciseShots.exists() and focus > cast.cost.chimaeraShot()+cast.cost.aimedShot() and #enemies.yards40<4 then
        cast.chimaeraShot()
    end
    -- multishot,if=buff.trick_shots.down|(buff.precise_shots.up|buff.bulletstorm.stack=10)&focus>cost+action.aimed_shot.cost
    if cast.able.multishot() and not buff.trickShots.exists() or (buff.preciseShot.exists() or buff.bulletstorm.stack() == 10) and focus > cast.cost.multishot()+cast.cost.aimedShot() then
        cast.multishot()
    end
    -- serpent_sting,target_if=min:dot.serpent_sting.remains,if=refreshable&talent.poison_injection&!talent.serpentstalkers_trickery
    if not talent.serpentStalkersTrickery and talent.poisonInjection and cast.able.serpentSting() then
        local lowestSerpentStingRemaining = 12
        local lowestSerpentStingPlayer = {}
        for i=1, #enemies.yards40 do
            if debuff.serpentSting.exists(enemies.yards40[i]) and debuff.serpentSting.remains(enemies.yards40[i]) < 12 then
                lowestSerpentStingRemaining = debuff.serpentSting.remains(enemies.yards40[i])
                lowestSerpentStingPlayer = enemies.yards40[i]
            end
        end

        if lowestSerpentStingRemaining < 12 then
            cast.serpentSting(lowestSerpentStingPlayer)
        end
    end
    -- 	steel_trap,if=buff.trueshot.down
    if cast.able.steelTrap() and not buff.trueshot.exists() then
        cast.steelTrap()
    end
    -- kill_shot,if=focus>cost+action.aimed_shot.cost
    if cast.able.killShot() and focus > cast.cost.killShot()+cast.cost.aimedShot() then
        cast.killShot()
    end
    -- multishot,if=focus>cost+action.aimed_shot.cost
    if cast.able.multishot() and focus > cast.cost.multishot()+cast.cost.aimedShot() then
        cast.multishot()
    end
    -- 	bag_of_tricks,if=buff.trueshot.down
    --if cast.able.bagOfTricks() and not buff.trueshot.exists() then
    --    cast.bagOfTricks()
    --end
    -- steady_shot
    if cast.able.steadyShot() then
        cast.steadyShot()
    end
end

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
    buff                                            = br.player.buff
    cast                                            = br.player.cast
    cd                                              = br.player.cd
    debuff                                          = br.player.debuff
    enemies                                         = br.player.enemies
    equiped                                         = br.player.equiped
    module                                          = br.player.module
    ui                                              = br.player.ui
    focus = br.player.power.focus.amount()
    unit                                            = br.player.unit
    gcd = br.player.gcd
    units                                           = br.player.units
    talent = br.player.talent
    use                                             = br.player.use
    charges = br.player.charges
    -- General Locals
    var.haltProfile                         = (unit.inCombat() and var.profileStop) or unit.mounted() or br.pause() or buff.feignDeath.exists() or ui.mode.rotation==2
    -- Units
    units.get(5)
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(8)
    enemies.get(40)

    -----------------
    --- Pet Logic ---
    -----------------
    if actionList.PetManagement() then return true end
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
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                -----------------
                --- Interrupt ---
                -----------------
                if actionList.Interrupt() then return true end
                ------------
                --- Main ---
                ------------
                -- Start Attack
                if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                    br._G.StartAttack(units.dyn40)
                end
                -- Trinket - Non-Specific
                if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40  then
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
                -- 	call_action_list,name=st,if=active_enemies<3|!talent.trick_shots
                if #enemies.yards40 < 3 or not talent.trickShots then
                    actionList.ST()
                else
                    actionList.Trickshots()
                end

            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 254
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})