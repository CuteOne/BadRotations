local rotationName = "Winston"
-- TODO
    -- add twins painful touch logic

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.mindFlay },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.mindFlay },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mindFlay },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.shadowMend}
    };
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.mindBlast },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.mindBlast },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.mindBlast }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dispersion },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dispersion }
    };
    CreateButton("Defensive",3,0)
    -- Void Form Button
    VoidFormModes = {
        [1] = { mode = "On", value = 1 , overlay = "Void Form Enabled", tip = "Bot will shift to Void Form.", highlight = 1, icon = br.player.spell.voidEruption },
        [2] = { mode = "Off", value = 2 , overlay = "Void Form Disabled", tip = "Bot will NOT shift to Void Form.", highlight = 0, icon = br.player.spell.voidEruption }
    };
    CreateButton("VoidForm",4,0)
    -- Interrupt button
    InterruptToggleModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.consumeMagic},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.consumeMagic}
    };
    CreateButton("InterruptToggle",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "Set to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- APL Mode
            br.ui:createDropdownWithout(section,"APL Mode", {"SIMC mode","JR Mode (expiremental)"}, 1, "Choose SimC or JRs Experimental APL mode.")
            -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "Set to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
            -- Body and Soul
            br.ui:createCheckbox(section,"PWS: Body and Soul")
            -- Auto Buff Fortitude
            br.ui:createCheckbox(section,"Power Word: Fortitude", "Check to auto buff Fortitude on party.")
             -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Flask of Endless Fathoms","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}, 1, "Set Elixir to use.")
            -- Mouseover Dotting
            br.ui:createCheckbox(section,"Mouseover Dotting")
            -- Strict simc mode
            -- br.ui:createCheckbox(section,"Strict simc mode", "Use strict simc mode, or use alternate priority which feels more natural")
        br.ui:checkSectionState(section)
        section = br.ui:createSection(br.ui.window.profile, "AoE Options")
            -- Shadow Crash
            br.ui:createCheckbox(section,"Shadow Crash")
            -- SWP Max Targets
            br.ui:createSpinnerWithout(section, "SWP Max Targets",  3,  1,  5,  1, "Unit Count Limit that SWP will be cast on.")
            -- VT Max Targets
            br.ui:createSpinnerWithout(section, "VT Max Targets",  3,  1,  5,  1, "Unit Count Limit that VT will be cast on.")
            -- Mind Sear Targets
            br.ui:createSpinnerWithout(section, "Mind Sear Targets",  3,  1,  3,  1, "Unit Count Limit before Mind Sear is being used.")
            -- Dark Void Targets
            br.ui:createSpinnerWithout(section, "Dark Void Targets",  5,  1,  10,  1, "Unit Count Limit before Dark Void is being used.")
            -- Dark Ascension AoE
            br.ui:createCheckbox(section, "Dark Ascension AoE", "Use Dark Ascension as AoE Damage Burst.")
            -- Dark Ascension Targets
            br.ui:createSpinnerWithout(section, "Dark Ascension Targets",  5,  1,  10,  1, "Unit Count Limit before Dark Ascension is being used.")
        br.ui:checkSectionState(section)
        -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
            -- Int Pot
            br.ui:createCheckbox(section,"Int Pot")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinket 1", "Use Trinket 1 on Cooldown. Overrides individual trinket usage below.")
            br.ui:createCheckbox(section,"Trinket 2", "Use Trinket 2 on Cooldown. Overrides individual trinket usage below.")
            -- Arcane Torrent
            --if (br.player.race == "BloodElf") then
            --    br.ui:createCheckbox(section,"Arcane Torrent")
            --    br.ui:createSpinnerWithout(section, "  Arcane Torrent Drain", 30, 0, 100, 1, "Set to desired Insanity to use at.")
            --end
            if hasEquiped(128318) then
                br.ui:createCheckbox(section,"Touch of the Void")
            end
            if hasEquiped(144259) then
                br.ui:createCheckbox(section,"KJ Burning Wish")
            end
            if hasEquiped(147017) then
                br.ui:createCheckbox(section,"Tarnished Sentinel Medallion")
            end
            if hasEquiped(139326) then
                br.ui:createCheckbox(section,"Wriggling Sinew")
            end
            if hasEquiped(140800) then
                br.ui:createCheckbox(section,"Pharameres Forbidden Grimoire")
            end
            if hasEquiped(142160) then
                br.ui:createCheckbox(section,"Mrrgias Favor")
            end
            if hasEquiped(137541) then
                br.ui:createCheckbox(section,"Moonlit Prism")
                br.ui:createSpinnerWithout(section, "  Prism Stacks", 35, 0, 100, 1, "Set to desired Void Form stacks to use at.")
            end
            if hasEquiped(147019) then
                br.ui:createCheckbox(section,"Tome of Unravelling Sanity")
                br.ui:createSpinnerWithout(section, "  Tome Stacks", 31, 0, 100, 1, "Set to desired Void Form stacks to use at.")
            end
            if hasEquiped(147002) then
                br.ui:createCheckbox(section,"Charm of the Rising Tide")
                br.ui:createSpinnerWithout(section, "  Charm Stacks", 35, 0, 100, 1, "Set to desired Void Form stacks to use at.")
            end
            if hasEquiped(137433) then
                br.ui:createCheckbox(section,"Obelisk of the Void")
                br.ui:createSpinnerWithout(section, "  Obelisk Stacks", 40, 0, 100, 1, "Set to desired Void Form stacks to use at.")
            end
            if hasEquiped(133642) then
                br.ui:createCheckbox(section,"Horn of Valor")
                br.ui:createSpinnerWithout(section, "  Horn Stacks", 35, 0, 100, 1, "Set to desired Void Form stacks to use at.")
            end
            if hasEquiped(150522) then
                br.ui:createCheckbox(section,"Skull of Guldan")
                br.ui:createSpinnerWithout(section, "  Skull Stacks", 35, 0, 100, 1, "Set to desired Void Form stacks to use at.")
            end
            if hasEquiped(137329) then
                br.ui:createCheckbox(section,"Figurehead of the Naglfar")
                br.ui:createSpinnerWithout(section, "  Figurehead Stacks", 40, 0, 100, 1, "Set to desired Void Form stacks to use at.")
            end
            if hasEquiped(161377) then
                br.ui:createCheckbox(section,"Azurethos' Singed Plumage")
                br.ui:createSpinnerWithout(section, "  Plumage Stacks", 5, 0, 100, 1, "Set to desired Void Form stacks to use at.")
            end
            if hasEquiped(161411) then
                br.ui:createCheckbox(section,"T'zane's Barkspines")
                --br.ui:createSpinnerWithout(section, "  Plumage Stacks", 5, 0, 100, 1, "Set to desired Void Form stacks to use at.")
            end
            -- Dark Ascension
            --if hasTalent(darkAscension) then
            br.ui:createCheckbox(section,"Dark Ascension", "Use Dark Ascension as Insanity Boost")
            -- Dark Ascension Burst
            br.ui:createCheckbox(section,"Dark Ascension Burst", "Use Dark Ascension for another Void Form Burst")
            --br.ui:createSpinnerWithout(section, "  Insanity Percentage", 30, 0, 100, 1, "Set to desired Insanity to use at.")
            --br.ui:createSpinnerWithout(section, "  Void Form Stacks", 15, 0, 100, 1, "Set to Stacks of Void Form to use at.")
            --end
            -- Shadowfiend
            br.ui:createCheckbox(section,"Shadowfiend / Mindbender")
            br.ui:createSpinnerWithout(section, "  Shadowfiend Stacks", 0, 0, 100, 1, "Set to desired Void Form stacks to use at. Set to 0 for auto.")
            -- Surrender To Madness
            br.ui:createCheckbox(section,"Surrender To Madness")
            -- Dispersion
            --br.ui:createCheckbox(section, "Dispersion S2M")
            --br.ui:createSpinnerWithout(section, "  Dispersion Stacks", 10, 5, 100, 5, "Set to desired Void Form stacks to use at.")
            -- Void Torrent
            br.ui:createCheckbox(section,"Void Torrent")
            br.ui:createSpinnerWithout(section, "  Void Torrent Stacks", 0, 0, 100, 1, "Set to desired Void Form stacks to use at.")
        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "Health Percentage to use at.")
            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "Health Percent to Cast At")
            end
            if br.player.race == "Dwarf" then
                br.ui:createSpinner(section, "Stoneform",  50,  0,  100,  5,  "Health Percent to Cast At")
            end
            -- Dispel Magic
            br.ui:createCheckbox(section,"Dispel Magic")
            -- Dispersion
            br.ui:createSpinner(section, "Dispersion",  20,  0,  100,  5,  "Health Percentage to use at.")
            -- Fade
            br.ui:createCheckbox(section, "Fade")
            -- Vampiric Embrace
            br.ui:createSpinner(section, "Vampiric Embrace",  25,  0,  100,  5,  "Health Percentage to use at.")
            -- Power Word: Shield
            br.ui:createSpinner(section, "Power Word: Shield",  60,  0,  100,  5,  "Health Percentage to use at.")
            -- Shadow Mend
            br.ui:createSpinner(section, "Shadow Mend",  60,  0,  100,  5,  "Health Percentage to use at.")
            -- Psychic Scream / Mind Bomb
            br.ui:createSpinner(section, "Psychic Scream / Mind Bomb",  40,  0,  100,  5,  "Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Silence
            br.ui:createCheckbox(section, "Silence")
            -- Psychic Horror
            br.ui:createCheckbox(section, "Psychic Horror")
            -- Psychic Scream
            br.ui:createCheckbox(section, "Psychic Scream")
            -- Mind Bomb
            -- br.ui:createCheckbox(section, "Mind Bomb")
            -- Interrupt Target
            br.ui:createDropdownWithout(section,"Interrupt Target", {"Focus","Target","All in Range"}, 2, "Interrupt your focus, your target, or all enemies in range.")
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  10,  0,  95,  5,  "Cast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Void Form
            br.ui:createDropdown(section, "Void Form Mode", br.dropOptions.Toggle,  6)
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

----------------
--- ROTATION ---
----------------
local function runRotation()
---------------
--- Toggles ---
---------------
    UpdateToggle("Rotation",0.25)
    UpdateToggle("Cooldown",0.25)
    UpdateToggle("Defensive",0.25)
    UpdateToggle("VoidForm",0.25)
    UpdateToggle("InterruptToggle",0.25)
    br.player.mode.voidForm = br.data.settings[br.selectedSpec].toggles["VoidForm"]
    br.player.mode.interruptToggle = br.data.settings[br.selectedSpec].toggles["InterruptToggle"]
--------------
--- Locals ---
--------------
    local addsExist                                     = false
    local addsIn                                        = 999
    local artifact                                      = br.player.artifact
    local buff                                          = br.player.buff
    local cast                                          = br.player.cast
    local castable                                      = br.player.cast.debug
    local combatTime                                    = getCombatTime()
    local cd                                            = br.player.cd
    local charges                                       = br.player.charges
    local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
    local debuff                                        = br.player.debuff
    local enemies                                       = br.player.enemies
    local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
    local friendly                                      = friendly or GetUnitIsFriend("target", "player")
    local gcd                                           = br.player.gcd
    local gcdMax                                        = max(0.75, 1.5 / (1 + UnitSpellHaste("player") / 100))
    local healPot                                       = getHealthPot()
    local hasMouse                                      = GetObjectExists("mouseover")
    local inCombat                                      = br.player.inCombat
    local inInstance                                    = br.player.instance=="party"
    local inRaid                                        = br.player.instance=="raid"
    local item                                          = br.player.spell.items
    local level                                         = br.player.level
    local lootDelay                                     = getOptionValue("LootDelay")
    local lowestHP                                      = br.friend[1].unit
    local mode                                          = br.player.mode
    local moveIn                                        = 999
    local moving                                        = (isMoving("player") and not br.player.buff.norgannonsForesight.exists() and not br.player.buff.surrenderToMadness.exists())
    -- local multidot                                      = (useCleave() or br.player.mode.rotation ~= 3)
    local perk                                          = br.player.perk
    local php                                           = br.player.health
    local playerMouse                                   = UnitIsPlayer("mouseover")
    local power, powmax, powgen, powerDeficit           = br.player.power.insanity.amount(), br.player.power.insanity.max(), br.player.power.insanity.regen(), br.player.power.insanity.deficit()
    local pullTimer                                     = br.DBM:getPulltimer()
    local racial                                        = br.player.getRacial()
    local solo                                          = #br.friend < 2
    local spell                                         = br.player.spell
    local t18_2pc                                       = TierScan("T18")>=2
    local t19_2pc                                       = TierScan("T19")>=2
    local t19_4pc                                       = TierScan("T19")>=4
    local t20_4pc                                       = TierScan("T20")>=4
    local t21_4pc                                       = TierScan("T21")>=4
    local talent                                        = br.player.talent
    --local thp                                           = getHP(br.player.units(40))
    local ttd                                           = getTTD
    local ttm                                           = br.player.power.insanity.ttm()
    local units                                         = br.player.units
    local use                                           = br.player.use
 
    local DAmaxTargets                                  = getOptionValue("Dark Ascension Targets")
    local SWPmaxTargets                                 = getOptionValue("SWP Max Targets")
    local VTmaxTargets                                  = getOptionValue("VT Max Targets")
    local mindFlayChannel                               = 3 / (1 + GetHaste()/100)
    local dotsUp                                        = debuff.shadowWordPain.exists(units.dyn40) and debuff.vampiricTouch.exists(units.dyn40)

    local executeHP = 20
    if talent.reaperOfSouls then executeHP = 35 end

    units.get(5)
    units.get(8)
    units.get(40)
    enemies.get(5)
    enemies.get(8)
    enemies.get(30)
    enemies.get(40)

    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end
    -- if HackEnabled("NoKnockback") ~= nil then HackEnabled("NoKnockback", false) end
    if t19_2pc then t19pc2 = 1 else t19pc2 = 0 end
    if t20_4pc then t20pc4 = 1 else t20pc4 = 0 end
    if t21_4pc then t21pc4 = 1 else t21pc4 = 0 end
    if hasBloodLust() then lusting = 1 else lusting = 0 end
    if talent.auspiciousSpirits then auspiciousSpirits = 1 else auspiciousSpirits = 0 end
    if talent.fortressOfTheMind then fortressOfTheMind = 1 else fortressOfTheMind = 0 end
    if talent.legacyOfTheVoid then legacyOfTheVoid = 1 else legacyOfTheVoid = 0 end
    if talent.lingeringInsanity then lingeringInsanity = 1 else lingeringInsanity = 0 end
    if talent.mindbender then mindbender = 1 else mindbender = 0 end
    if talent.reaperOfSouls then reaperOfSouls = 1 else reaperOfSouls = 0 end
    if talent.sanlayn then sanlayn = 1 else sanlayn = 0 end
    if artifact.lashOfInsanity.enabled() then lash = 1 else lash = 0 end
    if artifact.toThePain.enabled() then toThePain = 1 else toThePain = 0 end
    if artifact.massHysteria.enabled() then massHysteria = 1 else massHysteria = 0 end
    if hasEquiped(132864) then mangaMad = 1 else mangaMad = 0 end
    if #enemies.yards40 == 1 then singleEnemy = 1 else singleEnemy = 0 end
    local raidMovementWithin15 = 0   -- trying to come up with a clever way to manage this, maybe a toggle or something. For now, just assume we always have to move soon

    local activeEnemies = #enemies.yards40
    -- searEnemmies represents the number of enemies in mind sear range of the primary target.
    local dAEnemies = getEnemies(units.dyn40, 8, true)
    local dVEnemies = getEnemies(units.dyn40, 8, true)
    local searEnemies = getEnemies(units.dyn40, 8, true)

    if mode.rotation == 3 then
        activeEnemies = 1
        SWPmaxTargets = 1
        VTmaxTargets = 1
    end

    --print(tostring(cast.able.voidBolt()))

    -- Keep track of Drain Stacks
    -- Drain stacks will be equal to Voidform stacks, minus any time spent in diepersion and minus any time spent channeling void torrent
    if buff.voidForm.stack() == 0 then
        nonDrainTicks = 0
        drainStacks = 0
    else
        if inCombat and (buff.dispersion.exists() or buff.voidTorrent.exists()) then
            if br.timer:useTimer("drainStacker", 1) then
                nonDrainTicks = nonDrainTicks + 1
            end
        end
        drainStacks = buff.voidForm.stack() - nonDrainTicks
    end

    -- Insanity Drain
    insanityDrain = 6 + (0.68 * (drainStacks))

    -- Mind Flay Ticks
    if mfTick == nil or not inCombat or not isCastingSpell(spell.mindFlay) then mfTick = 0 end
    if br.timer:useTimer("Mind Flay Ticks", 0.95) and isCastingSpell(spell.mindFlay) then
        mfTick = mfTick + 1
    end

    -- Mind Sear Ticks
    if msTick == nil or not inCombat or not isCastingSpell(spell.mindSear) then msTick = 0 end
    if br.timer:useTimer("Mind Sear Ticks", 0.95) and isCastingSpell(spell.mindSear) then
        msTick = msTick + 1
    end

    -- variable,name=cd_time,op=set,value=(10+(2-2*talent.mindbender.enabled*set_bonus.tier20_4pc)*set_bonus.tier19_2pc+(3-3*talent.mindbender.enabled*set_bonus.tier20_4pc)*equipped.mangazas_madness+(6+5*talent.mindbender.enabled)*set_bonus.tier20_4pc+2*artifact.lash_of_insanity.rank())
    local cd_time = (10 + (2 - 2 * mindbender * t20pc4) * t19pc2 + (3 - 3 * mindbender * t20pc4) * mangaMad + (6 + 5 * mindbender) * t20pc4 + 2 * lash)
    -- variable,name=dot_swp_dpgcd,op=set,value=38*1.2*(1+0.06*artifact.to_the_pain.rank())*(1+0.2+stat.mastery_rating%16000)*0.75
    local dot_swp_dpgcd = 38 * 1.2 * (1 + 0.06 * artifact.toThePain.rank()) * (1 + 0.2 + GetMastery() % 16000) * 0.75
    -- variable,name=dot_vt_dpgcd,op=set,value=71*1.2*(1+0.2*talent.sanlayn.enabled)*(1+0.05*artifact.touch_of_darkness.rank())*(1+0.2+stat.mastery_rating%16000)*0.5
    local dot_vt_dpgcd = 71 * 1.2 * (1 + 0.2 * sanlayn) * (1 + 0.05 * artifact.touchOfDarkness.rank()) * (1 + 0.2 + GetMastery() / 16000) * 0.5
    -- variable,name=sear_dpgcd,op=set,value=80*(1+0.05*artifact.void_corruption.rank())
    local sear_dpgcd = 80 * (1 + 0.05 * artifact.voidCorruption.rank())
    -- variable,name=s2msetup_time,op=set,value=(0.8*(83+(20+20*talent.fortress_of_the_mind.enabled)*set_bonus.tier20_4pc-(5*talent.sanlayn.enabled)+(30+42*(desired_targets>1)+10*talent.lingering_insanity.enabled)*set_bonus.tier21_4pc*talent.auspicious_spirits.enabled+((33-13*set_bonus.tier20_4pc)*talent.reaper_of_souls.enabled)+set_bonus.tier19_2pc*4+8*equipped.mangazas_madness+(raw_haste_pct*10*(1+0.7*set_bonus.tier20_4pc))*(2+(0.8*set_bonus.tier19_2pc)+(1*talent.reaper_of_souls.enabled)+(2*artifact.mass_hysteria.rank())-(1*talent.sanlayn.enabled)))),if=talent.surrender_to_madness.enabled
    if activeEnemies > 1 then multipleEnemies = 1 else multipleEnemies = 0 end
    local s2msetup_time = (0.8 * (83 + (20 + 20 * fortressOfTheMind) * t20pc4 - (5 * sanlayn) + (30 + 42 * multipleEnemies + 10 * lingeringInsanity) * t21pc4 * auspiciousSpirits + ((33 - 13 * t20pc4) * reaperOfSouls) + t19pc2 * 4 + 8 * mangaMad + (UnitSpellHaste("player") * 10 * (1 + 0.7 * t20pc4)) * (2 + (0.8 * t19pc2) + (1 * reaperOfSouls) + (2 * massHysteria) - (1 * sanlayn))))

    -- Void Bolt
    -- void_bolt
    if isValidUnit(units.dyn40) and inCombat and buff.voidForm.exists() and (cd.voidBolt.remain() == 0 or buff.void.exists()) and not isCastingSpell(spell.voidTorrent) then
        --if cast.voidBolt(units.dyn40,"known") then return end
        if cast.voidBolt(units.dyn40) then return end
    end

    -- ChatOverlay(tostring(cd.voidBolt.remain()))

--------------------
--- Action Lists ---
--------------------
    -- Action list - Extras
    function actionList_Extra()
        -- Dispel Magic
        if isChecked("Dispel Magic") and canDispel("target",spell.dispelMagic) and not isBoss() and GetObjectExists("target") then
            if cast.dispelMagic() then return end
        end
    -- Dummy Test
        if isChecked("DPS Testing") then
            if GetObjectExists("target") then
                if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                    StopAttack()
                    ClearTarget()
                    Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                    profileStop = true
                end
            end
        end -- End Dummy Test
    end -- End Action List - Extra
    -- Action List - Defensive
    function actionList_Defensive()
        if mode.defensive == 1 and getHP("player")>0 then
            -- Pot/Stoned
                if isChecked("Healthstone") and php <= getOptionValue("Healthstone") 
                    and inCombat and (hasHealthPot() or hasItem(5512)) 
                then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healPot) then
                        useItem(healPot)
                    end
                end
            -- Gift of the Naaru
            if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race=="Draenei" then
                if castSpell("player",racial,false,false,false) then return end
            end
            -- Psychic Scream / Mind Bomb
            if isChecked("Vampiric Embrace") and inCombat and php <= getOptionValue("Vampiric Embrace") then
                if #enemies.yards40 > 0 then
                    if cast.vampiricEmbrace("player") then return end
                end
            end
            -- Stoneform - Dwarf racial
            if isChecked("Stoneform") and php <= getOptionValue("Stoneform") and php > 0 and br.player.race=="Dwarf" then
                if castSpell("player",racial,false,false,false) then return end
            end
            -- Dispersion
            if isChecked("Dispersion") and php <= getOptionValue("Dispersion") then
                if cast.dispersion("player") then return end
            end
            -- Fade
            if isChecked("Fade") then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not solo and hasThreat(thisUnit) then
                        cast.fade("player")
                    end
                end
            end
            -- Psychic Scream / Mind Bomb
            if isChecked("Psychic Scream / Mind Bomb") and inCombat and php <= getOptionValue("Psychic Scream / Mind Bomb") then
                if not talent.mindBomb and #enemies.yards8 > 0 then
                    if cast.psychicScream("player") then return end
                else
                    if cast.mindBomb(units.dyn30) then return end
                end
            end
            -- Psychic Horror
            --if isChecked("Psychic Horror") and inCombat and php <= getOptionValue("Psychic Horror") then
            --    if talent.psychichHorror and #enemies.yards8 > 0 then
            --        if cast.psychicHorror(units.dyn30) then return end
            --    end
            -- Power Word: Shield
            if isChecked("Power Word: Shield") and php <= getOptionValue("Power Word: Shield") and not buff.powerWordShield.exists() then
                if cast.powerWordShield("player") then return end
            end
            -- Shadow Mend
            if isChecked("Shadow Mend") and php <= getOptionValue("Shadow Mend") then
                if cast.shadowMend("player") then return end
            end
        end -- End Defensive Check
    end -- End Action List - Defensive
    -- Action List - Interrupts
    function actionList_Interrupts()
    -- Silence
        if isChecked("Silence") and mode.interruptToggle == 1 then
            if getOptionValue("Interrupt Target") == 1 and UnitIsEnemy("player","focus") and canInterrupt("focus",getOptionValue("Interrupt At")) then
                if cast.silence("focus") then return end
            elseif getOptionValue("Interrupt Target") == 2 and UnitIsEnemy("player","target") and canInterrupt("target",getOptionValue("Interrupt At")) then
                if cast.silence("target") then return end
            elseif getOptionValue("Interrupt Target") == 3 then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                        if cast.silence(thisUnit) then return end
                    end
                end
            end
        end
    -- Psychic Horror
        if talent.psychicHorror and isChecked("Psychic Horror") and mode.interruptToggle == 1 then
            if getOptionValue("Interrupt Target") == 1 and UnitIsEnemy("player","focus") and canInterrupt("focus",getOptionValue("Interrupt At")) and (cd.silence.exists() or not isChecked("Silence")) then
                if cast.psychicHorror("focus") then return end --Print("pH on focus") return end
            elseif getOptionValue("Interrupt Target") == 2 and UnitIsEnemy("player","target") and canInterrupt("target",getOptionValue("Interrupt At")) and (cd.silence.exists() or not isChecked("Silence")) then
                if cast.psychicHorror("target") then return end --Print("pH on target") return end
            elseif getOptionValue("Interrupt Target") == 3 and (cd.silence.exists() or not isChecked("Silence")) then
                for i=1, #enemies.yards30 do
                    thisUnit = enemies.yards30[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                        if cast.psychicHorror(thisUnit) then return end --Print("pH on any") return end
                    end
                end
            end
        end
    -- Psychic Scream
        if isChecked("Psychic Scream") and mode.interruptToggle == 1 then
            if getOptionValue("Interrupt Target") == 1 and UnitIsEnemy("player","focus") and canInterrupt("focus",getOptionValue("Interrupt At")) then
                if cast.psychicScream("focus") then return end
            elseif getOptionValue("Interrupt Target") == 2 and UnitIsEnemy("player","target") and canInterrupt("target",getOptionValue("Interrupt At")) then
                if cast.psychicScream("target") then return end
            elseif getOptionValue("Interrupt Target") == 3 then
                for i=1, #enemies.yards8 do
                    thisUnit = enemies.yards8[i]
                    if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                        if cast.psychicScream("player") then return end
                    end
                end
            end
        end
    -- Mind Bomb
        -- mind bomb has a 2 second delay before the interrupt happens. not using as an interrupt source for now ...
        -- TODO figure out a useful way to use mind bomb as an interrupt
            -- if getOptionValue("Interrupt Target") == 1 and UnitIsEnemy("player","focus") and canInterrupt("focus",getOptionValue("Interrupt At")) then
            --     if cast.mindBomb("focus") then return end
            -- end
            -- if getOptionValue("Interrupt Target") == 2 and UnitIsEnemy("player","target") and canInterrupt("target",getOptionValue("Interrupt At")) then
            --     if cast.mindBomb("target") then return end
            -- end
            -- if getOptionValue("Interrupt Target") == 3 then
            --     if talent.mindBomb then
            --         for i=1, #enemies.yards30 do
            --             thisUnit = enemies.yards30[i]
            --             if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
            --                 if cast.mindBomb(thisUnit) then return end
            --             end
            --         end
            --     end
            -- end
    end -- End Action List - Interrupts
    -- Action List - Cooldowns
    function actionList_Cooldowns()
        if useCDs() then
            -- Touch of the Void
            if isChecked("Touch of the Void") and getDistance("target") <= 40 then
                if hasEquiped(128318) then
                    if GetItemCooldown(128318)==0 then
                        useItem(128318)
                    end
                end
            end
            -- KJ Burning Wish
            if isChecked("KJ Burning Wish") and getDistance("target") <= 40 then
                if hasEquiped(144259) then
                    if GetItemCooldown(144259)==0 then
                        useItem(144259)
                    end
                end
            end
            -- Tarnished Sentinel Medallion
            if isChecked("Tarnished Sentinel Medallion") and getDistance("target") <= 40 then
                if hasEquiped(147017) then
                    if GetItemCooldown(147017)==0 then
                        useItem(147017)
                    end
                end
            end
            -- Wriggling Sinew
            if isChecked("Wriggling Sinew") and getDistance("target") <= 40 then
                if hasEquiped(139326) then
                    if GetItemCooldown(139326)==0 then
                        useItem(139326)
                    end
                end
            end
            -- Pharameres Forbidden Grimoire
            if isChecked("Pharameres Forbidden Grimoire") and getDistance("target") <= 40 then
                if hasEquiped(140800) then
                    if GetItemCooldown(140800)==0 then
                        useItem(140800)
                    end
                end
            end
            -- Mrrgias Favor
            if isChecked("Mrrgias Favor") and getDistance("target") <= 40 then
                if hasEquiped(142160) then
                    if GetItemCooldown(142160)==0 then
                        useItem(142160)
                    end
                end
            end
            -- Moonlit Prism
            if isChecked("Moonlit Prism")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Prism Stacks") then
                if hasEquiped(137541) then
                    if GetItemCooldown(137541)==0 then
                        useItem(137541)
                    end
                end
            end
            -- Tome of Unravelling Sanity
            if isChecked("Tome of Unravelling Sanity")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Tome Stacks") then
                if hasEquiped(147019) then
                    if GetItemCooldown(147019)==0 then
                        useItem(147019)
                    end
                end
            end
            -- Charm of the Rising Tide
            if isChecked("Charm of the Rising Tide")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Charm Stacks") then
                if hasEquiped(147002) then
                    if GetItemCooldown(147002)==0 then
                        useItem(147002)
                    end
                end
            end
            -- Obelisk of the Void
            if isChecked("Obelisk of the Void")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Obelisk Stacks") then
                if hasEquiped(137433) then
                    if GetItemCooldown(137433)==0 then
                        useItem(137433)
                    end
                end
            end
            -- Horn of Valor
            if isChecked("Horn of Valor")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Horn Stacks") then
                if hasEquiped(133642) then
                    if GetItemCooldown(133642)==0 then
                        useItem(133642)
                    end
                end
            end
            -- Skull of Guldan
            if isChecked("Skull of Guldan")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Skull Stacks") then
                if hasEquiped(150522) then
                    if GetItemCooldown(150522)==0 then
                        useItem(150522)
                    end
                end
            end
            -- Figurehead of the Naglfar
            if isChecked("Figurehead of the Naglfar")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Figurehead Stacks") then
                if hasEquiped(137329) then
                    if GetItemCooldown(137329)==0 then
                        useItem(137329)
                    end
                end
            end
            -- Azurethos' Singed Plumage
            if isChecked("Azurethos' Singed Plumage")  and getDistance("target") <= 40 and buff.voidForm.stack() >= getOptionValue("  Plumage Stacks") then
                if hasEquiped(161377) then
                    if GetItemCooldown(161377)==0 then
                        useItem(161377)
                    end
                end
            end
            -- T'zane's Barkspines
            if isChecked("T'zane's Barkspines")  and getDistance("target") <= 40 and buff.voidForm.exists() then
                if hasEquiped(161411) then
                    if GetItemCooldown(161411)==0 then
                        useItem(161411)
                    end
                end
            end
        -- Trinkets
            --if isChecked("Trinkets") then
            --    if canUse(11) then
            --        useItem(11)
            --    end
            --    if canUse(12) then
            --        useItem(12)
            --    end
            --    if canUse(13) then
            --        useItem(13)
            --    end
            --    if canUse(14) then
            --        useItem(14)
            --    end
            --end
            if isChecked("Trinket 1") and canUse(13) then
                useItem(13)
                return true
            end
            if isChecked("Trinket 2") and canUse(14) then
                useItem(14)
                return true
            end
        -- Potion
            -- potion,name=prolonged_power,if=buff.bloodlust.react|target.time_to_die<=80|(target.health.pct<35&cooldown.power_infusion.remains<30)
            -- TODO
        end
    end -- End Action List - Cooldowns
    -- Action List - Pre-Combat
    function actionList_PreCombat()
    -- Shadow Form
        -- shadowform,if=!buff.shadowform.up
        if not buff.shadowform.exists() then
            cast.shadowform()
        end
    -- comment out Fort so you are not over casting other priests in raids. if you uncomment it will keep applying so its your fort up. easier to just manual cast i think.
    -- Power Word: Fortitude
        --if not buff.powerWordFortitude.exists() then
        --    cast.powerWordFortitude()
        --end
        if isChecked("Power Word: Fortitude") and br.timer:useTimer("PW:F Delay", 2) then
            for i = 1, #br.friend do
                if not buff.powerWordFortitude.exists(br.friend[i].unit,"any") and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                    if cast.powerWordFortitude() then return true end
                end
            end
        end
    -- Flask/Elixir
        -- flask,type=flask_of_the_whispered_pact
          -- Endless Fathoms Flask
        if getOptionValue("Elixir") == 1 and inRaid and not buff.flaskOfEndlessFathoms.exists() and canUse(item.flaskOfEndlessFathoms) then
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.flaskOfEndlessFathoms() then return end
        end
        if getOptionValue("Elixir") == 2 and not buff.felFocus.exists() and canUse(item.repurposedFelFocuser) then
            if buff.flaskOfTheWhisperedPact.exists() then buff.flaskOfTheWhisperedPact.cancel() end
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
            if use.repurposedFelFocuser() then return end
        end
        if getOptionValue("Elixir") == 3 and not buff.whispersOfInsanity.exists() and canUse(item.oraliusWhisperingCrystal) then
            if buff.flaskOfTheWhisperedPact.exists() then buff.flaskOfTheWhisperedPact.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if use.oraliusWhisperingCrystal() then return end
        end
    -- Mind Blast
        -- if isValidUnit("target") then
        --     if not moving and br.timer:useTimer("mbRecast", gcd) then
        --         if cast.mindBlast("target") then return end
        --     -- else
        --     --     if cast.shadowWordPain("target") then return end
        --     end
        -- end
    -- Power Word: Shield Body and Soul
        if isChecked("PWS: Body and Soul") and talent.bodyAndSoul and isMoving("player") and buff.powerWordShield.remain() <= 8.5 and not buff.classHallSpeed.exists() then
            if cast.powerWordShield("player") then return end
        end
    end  -- End Action List - Pre-Combat
    -- Action List - Check
    function actionList_Check()
        -- variable,op=set,name=actors_fight_time_mod,value=0
        actors_fight_time_mod = 0
        -- variable,op=set,name=actors_fight_time_mod,value=-((-(450)+(time+target.time_to_die))%10),if=time+target.time_to_die>450&time+target.time_to_die<600
        if combatTime + ttd(units.dyn40) > 450 and combatTime + ttd(units.dyn40) < 600 then
            actors_fight_time_mod = - (( - (450) + (combatTime + ttd(units.dyn40))) / 10)
        end
        -- variable,op=set,name=actors_fight_time_mod,value=((450-(time+target.time_to_die))%5),if=time+target.time_to_die<=450
        if combatTime + ttd(units.dyn40) <= 450 then
            actors_fight_time_mod = (450 - (combatTime + ttd(units.dyn40))) / 5
        end
        -- TODO - need to consider whether single-target rotation has an effect on s2mcheck time
        -- variable,op=set,name=s2mcheck,value=variable.s2msetup_time-(variable.actors_fight_time_mod*nonexecute_actors_pct)
        s2mCheck = s2msetup_time - (actors_fight_time_mod * getNonExecuteEnemiesPercent(executeHP))
        -- variable,op=min,name=s2mcheck,value=180
        if s2mCheck < 180 then s2mCheck = 180 end
    end

    function recentlyCast(u,s,t)
        local result = false
        if lastCastTrackerUnit == null or lastCastTrackerSpell == null then
            return false
        end
        if lastCastTrackerUnit == u and lastCastTrackerSpell == s and GetTime() - lastCastTrackerTime < t then
            return true
        end
        return false
    end
    -- Action List - Main
    function actionList_Main()
    --Mouseover Dotting
        if isChecked("Mouseover Dotting") and hasMouse and (UnitIsEnemy("player","mouseover") or isDummy("mouseover")) and not moving and not recentlyCast("mouseover", spell.vampiricTouch, 1.1*gcdMax) then
            if getDebuffRemain("mouseover",spell.vampiricTouch,"player") <= 3*gcdMax then
                if cast.vampiricTouch("mouseover") then
                    lastCastTrackerSpell = spell.vampiricTouch
                    lastCastTrackerUnit = "mouseover"
                    lastCastTrackerTime = GetTime()
                    return
                end
            end
        end
        if isChecked("Mouseover Dotting") and hasMouse and (UnitIsEnemy("player","mouseover") or isDummy("mouseover")) and not recentlyCast("mouseover", spell.shadowWordPain, 1.1*gcdMax) then
            if getDebuffRemain("mouseover",spell.shadowWordPain,"player") <= 3*gcdMax then
                if cast.shadowWordPain("mouseover") then
                    lastCastTrackerSpell = spell.shadowWordPain
                    lastCastTrackerUnit = "mouseover"
                    lastCastTrackerTime = GetTime()
                    return
                end
            end
        end
    -- Surrender To Madness
        -- surrender_to_madness,if=talent.surrender_to_madness.enabled&target.time_to_die<=variable.s2mcheck
        if isChecked("Surrender To Madness") and useCDs() then
            if talent.surrenderToMadness and ttd(units.dyn40) <= s2mCheck then
                if cast.surrenderToMadness() then return end
            end
        end
    -- Shadow Word: Pain -- if moving and talent.misery, SW:P on dyn40 + cleaves. refresh if expiring soon
        -- shadow_word_pain,if=talent.misery.enabled&dot.shadow_word_pain.remains<gcd.max,moving=1,cycle_targets=1
        if moving and talent.misery then
            if debuff.shadowWordPain.remain(units.dyn40) < gcdMax and not recentlyCast(units.dyn40, spell.shadowWordPain, 1.1*gcdMax) then
                if cast.shadowWordPain(units.dyn40,"aoe") then
                    -- Print("cast SWP on dyn40 with misery")
                    lastCastTrackerSpell = spell.shadowWordPain
                    lastCastTrackerUnit = units.dyn40
                    lastCastTrackerTime = GetTime()
                    return
                end
            end
            if not mode.rotation == 3 and debuff.shadowWordPain.remainCount(gcdMax) < SWPmaxTargets then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not GetUnitIsUnit(thisUnit, units.dyn40) and debuff.shadowWordPain.remain(thisUnit) < gcdMax and not recentlyCast(thisUnit, spell.shadowWordPain, 1.1*gcdMax)
                    then
                        if cast.shadowWordPain(thisUnit,"aoe") then
                            -- Print("cast SWP on extra with misery")
                            lastCastTrackerSpell = spell.shadowWordPain
                            lastCastTrackerUnit = thisUnit
                            lastCastTrackerTime = GetTime()
                            return
                        end
                    end
                end
            end
        end
    -- Vampiric Touch -- if talent.misery, dot dyn40 + cleave targers with VT+SW:P. refresh if expiring soon
        -- vampiric_touch,if=talent.misery.enabled&(dot.vampiric_touch.remains<3*gcd.max|dot.shadow_word_pain.remains<3*gcd.max),cycle_targets=1
        if talent.misery and not moving and not isCastingSpell(spell.vampiricTouch) then
            if debuff.vampiricTouch.remain(units.dyn40) < 3*gcdMax or debuff.shadowWordPain.remain(units.dyn40) < 3*gcdMax and not recentlyCast(units.dyn40, spell.vampiricTouch, 1.1*gcdMax)
            then
                if cast.vampiricTouch(units.dyn40,"aoe") then
                    -- Print("cast VT on dyn40 with misery")
                    lastCastTrackerSpell = spell.vampiricTouch
                    lastCastTrackerUnit = units.dyn40
                    lastCastTrackerTime = GetTime()
                    return
                end
            end
            if not mode.rotation == 3 and debuff.vampiricTouch.remainCount(3*gcdMax) < VTmaxTargets or debuff.shadowWordPain.remainCount(3*gcdMax) < SWPmaxTargets then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if ((debuff.vampiricTouch.remain(thisUnit) < 3 * gcdMax or debuff.shadowWordPain.remain(thisUnit) < 3 * gcdMax)) and not recentlyCast(thisUnit, spell.vampiricTouch, 1.1*gcdMax)
                    then
                        if cast.vampiricTouch(thisUnit,"aoe") then
                            -- Print("cast VT on extras with misery")
                            lastCastTrackerSpell = spell.vampiricTouch
                            lastCastTrackerUnit = thisUnit
                            lastCastTrackerTime = GetTime()
                            return
                        end
                    end
                end
            end
        end
    -- Vampiric Touch -- cast on dyn40 target. refresh if expiring soon
        -- vampiric_touch,if=!talent.misery.enabled&dot.vampiric_touch.remains<(4+(4%3))*gcd
        if not talent.misery and debuff.vampiricTouch.remain(units.dyn40) < (4 + (4 / 3)) * gcdMax and not isCastingSpell(spell.vampiricTouch) and not moving and not recentlyCast(units.dyn40, spell.vampiricTouch, 1.1*gcdMax) then
            if cast.vampiricTouch(units.dyn40) then
                -- Print("cast VT on dyn40 not misery")
                lastCastTrackerSpell = spell.vampiricTouch
                lastCastTrackerUnit = units.dyn40
                lastCastTrackerTime = GetTime()
                return
            end
        end
    -- Shadow Word: Pain -- cast on dyn40 target. refresh if expiring soon
        -- shadow_word_pain,if=!talent.misery.enabled&dot.shadow_word_pain.remains<(3+(4%3))*gcd
        if not talent.misery and debuff.shadowWordPain.remain(units.dyn40) < (3 + (4 / 3)) * gcdMax and not recentlyCast(units.dyn40, spell.shadowWordPain, 1.1*gcdMax) then
            if cast.shadowWordPain(units.dyn40) then
                -- Print("cast SWP on dyn40 not misery")
                lastCastTrackerSpell = spell.shadowWordPain
                lastCastTrackerUnit = units.dyn40
                lastCastTrackerTime = GetTime()
                return
            end
        end
    -- Dark Ascension
        if isChecked("Dark Ascension") and useCDs() then
            if power <= 40 and not buff.voidForm.exists() then
                if cast.darkAscension() then return end --Print("no VF") return end
            end
        end
    -- Void Eruption
        -- void_eruption
        if mode.voidForm == 1 and not moving then
            if cast.voidEruption() then return end
        end
    -- Dark Void
        if not moving then
            if #dAEnemies >= getOptionValue("Dark Void Targets") and talent.darkVoid then
                if cast.darkVoid() then return end
            end
        end
    -- Shadow Crash
        -- shadow_crash,if=talent.shadow_crash.enabled
        if isChecked("Shadow Crash") and talent.shadowCrash and not isMoving("target") then
            if cast.shadowCrash("best",nil,1,8) then return end
        end
    -- Dark Ascension AoE
        if isChecked("Dark Ascension AoE") then
            if #dAEnemies >= getOptionValue("Dark Ascension Targets") and (talent.darkVoid and cd.darkVoid.remain ~= 30) or debuff.shadowWordPain.count() >= DAmaxTargets - 2 then
                for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                    if not debuff.shadowWordPain.exists(thisUnit) then
                        if cast.darkAscension(thisUnit,"aoe") then return end --Print("DA AoE") return end
                    end
                end
            end
        end
    -- Shadow Word: Death
        -- shadow_word_death,if=(active_enemies<=4|(talent.reaper_of_souls.enabled&active_enemies<=2))&cooldown.shadow_word_death.charges=2&insanity<=(85-15*talent.reaper_of_souls.enabled)
        if (#searEnemies <= 4 or (talent.reaperOfSouls and (activeEnemies <= 2 or mode.rotation == 3)))
            and charges.shadowWordDeath.count() == 2 and (power <= (85 - 15 * reaperOfSouls) or mode.voidForm == 2)
        then
            -- If Zeks Exterminatus (legendary cloak) has procced, SW:D is castable on any target, regardless of HP
            if getHP(units.dyn40) < executeHP  or buff.zeksExterminatus.exists() then
                if cast.shadowWordDeath(units.dyn40) then return end
            end
            if not mode.rotation == 3 then
                -- Look for any targets in execute HP range
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if getHP(thisUnit) < executeHP then
                        if cast.shadowWordDeath(thisUnit) then return end
                    end
                end
            end
        end
    -- Mind Blast
        -- mind_blast,if=active_enemies<=4&talent.legacy_of_the_void.enabled&(insanity<=81|(insanity<=75.2&talent.fortress_of_the_mind.enabled))
        if not moving and talent.legacyOfTheVoid and ((power <= 81 or (power <= 75.2 and talent.fortressOfTheMind)) or mode.voidForm == 2)
            and not recentlyCast(units.dyn40, spell.mindBlast, 0.9*gcdMax)
        then
            if cast.mindBlast(units.dyn40) then
                lastCastTrackerSpell = spell.mindBlast
                lastCastTrackerUnit = units.dyn40
                lastCastTrackerTime = GetTime()
                return
            end
        end
    -- Mind Blast
        -- mind_blast,if=active_enemies<=4&!talent.legacy_of_the_void.enabled|(insanity<=96|(insanity<=95.2&talent.fortress_of_the_mind.enabled))
        if not moving and not talent.legacyOfTheVoid and (power <= 96 or ((power <= 95.2 and talent.fortressOfTheMind)) or mode.voidForm == 2)
            and not recentlyCast(units.dyn40, spell.mindBlast, 0.9*gcdMax)
        then
            if cast.mindBlast(units.dyn40) then
                lastCastTrackerSpell = spell.mindBlast
                lastCastTrackerUnit = units.dyn40
                lastCastTrackerTime = GetTime()
                return
            end
        end
    -- Shadow Word: Pain - on extra dot targets (main target is handled above)
        -- shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&(talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled)),cycle_targets=1
         if not talent.misery and #searEnemies < 5 and not mode.rotation == 3
             and (talent.auspiciousSpirits or talent.shadowyInsight) and debuff.shadowWordPain.count() < SWPmaxTargets
         then
             for i = 1, #enemies.yards40 do
                 local thisUnit = enemies.yards40[i]
                 -- !ticking&target.time_to_die>10
                 if not debuff.shadowWordPain.exists(thisUnit) and ttd(thisUnit) > 10 and not recentlyCast(thisUnit, spell.shadowWordPain, 1.1*gcdMax) then
                     if cast.shadowWordPain(thisUnit,"aoe") then
                         lastCastTrackerSpell = spell.shadowWordPain
                         lastCastTrackerUnit = thisUnit
                         lastCastTrackerTime = GetTime()
                         return
                     end
                 end
             end
         end
    -- Vampiric Touch - on extra dot targets (main target is handled above)
        -- vampiric_touch,if=active_enemies>1&!talent.misery.enabled&!ticking&(variable.dot_vt_dpgcd*target.time_to_die%(gcd.max*(156+variable.sear_dpgcd*(active_enemies-1))))>1,cycle_targets=1
        if activeEnemies > 1 and (mode.rotation == 1 or mode.rotation == 2) and not talent.misery and debuff.vampiricTouch.count() < VTmaxTargets and not moving then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.vampiricTouch.exists(thisUnit) and (dot_vt_dpgcd * ttd(thisUnit) / (gcdMax * (156 + sear_dpgcd * (#searEnemies - 1)))) > 1
                    and not recentlyCast(thisUnit, spell.vampiricTouch, 1.1*gcdMax) then
                    if cast.vampiricTouch(thisUnit,"aoe") then
                        --Print("cast VT on adds")
                        lastCastTrackerSpell = spell.vampiricTouch
                        lastCastTrackerUnit = thisUnit
                        lastCastTrackerTime = GetTime()
                        return
                    end
                end
            end
        end
    -- Shadow Word: Pain  - on extra dot targets (main target is handled above)
        --shadow_word_pain,if=active_enemies>1&!talent.misery.enabled&!ticking&(variable.dot_swp_dpgcd*target.time_to_die%(gcd.max*(118+variable.sear_dpgcd*(active_enemies-1))))>1,cycle_targets=1
        if activeEnemies > 1 and (mode.rotation == 1 or mode.rotation == 2) and not talent.misery and debuff.shadowWordPain.count() < SWPmaxTargets then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.shadowWordPain.exists(thisUnit) and (dot_swp_dpgcd * ttd(thisUnit) / (gcdMax * (118 + sear_dpgcd * (#searEnemies - 1)))) > 1
                    and not recentlyCast(thisUnit, spell.shadowWordPain, 1.1*gcdMax) then
                    if cast.shadowWordPain(thisUnit,"aoe") then
                        --Print("cast SWP on adds")
                        lastCastTrackerSpell = spell.shadowWordPain
                        lastCastTrackerUnit = thisUnit
                        lastCastTrackerTime = GetTime()
                        return
                    end
                end
            end
        end
    -- Shadow Word: Void
        -- shadow_word_void,if=talent.shadow_word_void.enabled&(insanity<=75-10*talent.legacy_of_the_void.enabled)
        --  if talent.shadowWordVoid and ((power <= 75 - 10 * legacyOfTheVoid) or mode.voidForm == 2) then
        --      if cast.shadowWordVoid(units.dyn40) then return end
        --  end
        --  -- shadow_word_void,if=talent.shadow_word_void.enabled&(insanity-(current_insanity_drain*gcd.max)+50)<100
        --  if talent.shadowWordVoid and (power - (insanityDrain * gcd) + 12) < 100 then
        --      if cast.shadowWordVoid() then return end
        --  end
    -- Mind Sear
        -- mind_sear,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
        if not moving then 
            if not isCastingSpell(spell.mindSear) and #searEnemies >= getOptionValue("Mind Sear Targets") and debuff.shadowWordPain.exists("target") then
                if cast.mindSear() then return end
            end
        end    
    -- Mind Flay
        -- mind_flay,interrupt=1,chain=1
        if not moving then
            if not isCastingSpell(spell.mindFlay) and #searEnemies < getOptionValue("Mind Sear Targets") then
                if cast.mindFlay() then return end
            end
        end
    -- Shadow Word: Pain
        -- shadow_word_pain
        if moving then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.shadowWordPain.exists(thisUnit) then
                    if cast.shadowWordPain(thisUnit,"aoe") then
                        -- Print("cast SWP last resort")
                        lastCastTrackerSpell = spell.shadowWordPain
                        lastCastTrackerUnit = thisUnit
                        lastCastTrackerTime = GetTime()
                        return
                    end
                end
            end
        end
    end
    -- Action List - Surrender To Madness
    function actionList_SurrenderToMadness() -- Provided by Cyberking07
     --Try to proc Sephuzs
        -- silence,if=equipped.sephuzs_secret&(target.is_add|target.debuff.casting.react)&cooldown.buff_sephuzs_secret.remains<1&!buff.sephuzs_secret.up,cycle_targets=1
        if buff.sephuz1.exists() and not buff.sephuzCooldown.exists() and not buff.sephuz2.exists() then
            -- Arcane Torrent (blood elf racial)
            if br.player.race == "blood elf" and getSpellCD(racial) == 0 and #enemies.yards8 > 0 then
                for i = 1, #enemies.yards8 do
                    local thisUnit = enemies.yards5[i]
                    if not isBoss(thisUnit) and UnitLevel(thisUnit) < UnitLevel("player") + 3 then
                        if castSpell("player",racial,false,false,false) then return end
                    end
                end
            end
            -- Quaking Palm (panda racial)  getDistance(thisUnit,thisEnemy)
            if br.player.race == "pandaren" and getSpellCD(racial) == 0 and #enemies.yards5 > 0 then
                if not mode.rotation == 3 then
                    for i = 1, #enemies.yards5 do
                        local thisUnit = enemies.yards5[i]
                        if not isBoss(thisUnit) and UnitLevel(thisUnit) < UnitLevel("player") + 3 then
                            if castSpell("player",racial,false,false,false) then return end
                        end
                    end
                end
            end
            -- Silence
            if not isBoss(units.dyn40) then
                if cast.silence(units.dyn40) then return end
            end
            if not mode.rotation == 3 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not isBoss(thisUnit) and UnitLevel(thisUnit) < UnitLevel("player") + 3 then
                        if cast.silence(thisUnit) then return end
                    end
                end
            end
        end
     --Void Bolt
        -- void_bolt,if=buff.insanity_drain_stacks.stack<6&set_bonus.tier19_4pc
        if drainStacks < 6 and t19_4pc then
            --if cast.voidBolt(units.dyn40,"known") then return end
            if cast.voidBolt(units.dyn40) then return end
        end
     -- Mind Bomb - to proc Sephuzs
        -- mind_bomb,if=equipped.sephuzs_secret&target.is_add&cooldown.buff_sephuzs_secret.remains<1&!buff.sephuzs_secret.up,cycle_targets=1
        if buff.sephuz1.exists() and buff.sephuzCooldown.remain() < 1 and not buff.sephuz2.exists() then
            if not isBoss(units.dyn40) and UnitLevel(units.dyn40) < UnitLevel("player") + 3 then
                if cast.mindBomb(units.dyn40) then return end
            end
            if not mode.rotation == 3 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not isBoss(thisUnit) and UnitLevel(thisUnit) < UnitLevel("player") + 3 then
                        if cast.mindBomb(thisUnit) then return end
                    end
                end
            end
        end
     --Shadow Crash
        -- shadow_crash,if=talent.shadow_crash.enabled
        if isChecked("Shadow Crash") and talent.shadowCrash and not isMoving("target") then
            if cast.shadowCrash("best",nil,1,8) then return end
        end
     -- Dark Void
        if not moving then
            if #dVEnemies >= getOptionValue("Dark Void Targets") and talent.darkVoid then
                if cast.darkVoid() then return end
            end
        end
     --Mind Bender
        -- mindbender,if=cooldown.shadow_word_death.charges=0&buff.voidform.stack>(45+25*set_bonus.tier20_4pc)
        if isChecked("Shadowfiend / Mindbender") and talent.mindbender and (not talent.shadowWordDeath or (talent.shadowWordDeath and charges.shadowWordDeath.count() == 0)) then
            if getOptionValue("  Shadowfiend Stacks") > 0 then
                --use configured value
                if buff.voidForm.stack() >= getOptionValue("  Shadowfiend Stacks") then
                    if cast.mindBender() then return end
                end
            else
                if buff.voidForm.stack() > (45 + 25 * t20pc4) then
                    if cast.mindBender() then return end
                end
            end
        end
     --Void Torrent
        -- void_torrent,if=dot.shadow_word_pain.remains>5.5&dot.vampiric_touch.remains>5.5&!buff.power_infusion.up|buff.voidform.stack<5
        if isChecked("Void Torrent") then
            if talent.voidTorrent and debuff.shadowWordPain.remain(units.dyn40) > 5.5 and debuff.vampiricTouch.remain(units.dyn40) > 5.5
                and (not buff.powerInfusion.exists() or buff.voidForm.stack() < 5)
            then
                if cast.voidTorrent() then return end
            end
        end
     --Berserking
        -- berserking,if=buff.voidform.stack>=65
        if br.player.race == "Troll" and getSpellCD(racial) == 0 and buff.voidForm.stack() >= 65 then
            if castSpell("player",racial,false,false,false) then return end
        end
     --Shadow Word Death
        -- shadow_word_death,if=current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+(30+30*talent.reaper_of_souls.enabled)<100)
        if insanityDrain * gcdMax > power and (power - (insanityDrain * gcdMax) + (30 + 30 * reaperOfSouls) < 100) then
            -- If Zeks Exterminatus (legendary cloak) has procced, SW:D is castable on any target, regardless of HP
            if getHP(units.dyn40) < executeHP or buff.zeksExterminatus.exists() then
                if cast.shadowWordDeath(units.dyn40) then return end
            end
            if not mode.rotation == 3 then
                -- Look for any targets in execute HP range
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if getHP(thisUnit) < executeHP then
                        if cast.shadowWordDeath(thisUnit) then return end
                    end
                end
            end
        end
     --Void Bolt
        -- void_bolt
        if cast.voidBolt(units.dyn40) then return end
        --if cast.voidBolt() then return end
     --Shadow Word Death
        -- shadow_word_death,if=(active_enemies<=4|(talent.reaper_of_souls.enabled&active_enemies<=2))&current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+(30+30*talent.reaper_of_souls.enabled))<100
        if (#enemies.yards40 <= 4 or (talent.reaperOfSouls and #enemies <= 2))
            and insanityDrain * gcd > power and (power - (insanityDrain * gcd) + (30 + 30 * reaperOfSouls)) < 100
        then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if getHP(thisUnit) < 20 then
                    if cast.shadowWordDeath(thisUnit) then return end
                end
            end
        end
     --Wait for Void Bolt
        -- wait,sec=action.void_bolt.usable_in,if=action.void_bolt.usable_in<gcd.max*0.28
        if cd.voidBolt.remain() < gcd * 0.28 then
            return true
        end
     --Dispersion
        -- dispersion,if=current_insanity_drain*gcd.max>insanity&!buff.power_infusion.up|(buff.voidform.stack>76&cooldown.shadow_word_death.charges=0&current_insanity_drain*gcd.max>insanity)
        if isChecked("Dispersion S2M") and useCDs() then
            if insanityDrain * gcd > power and (not buff.powerInfusion.exists()
                or (buff.voidForm.stack() >= getOptionValue("  Dispersion Stacks") and charges.shadowWordDeath.count() == 0 and insanityDrain * gcd > power))
            then
                if cast.dispersion("player") then return end
            end
        end
     --Mind Blast
        -- mind_blast,if=active_enemies<=5
        if not moving and ((mode.rotation == 1 and #enemies.yards40 <= 5) or mode.rotation == 3) then
            if cast.mindBlast() then return end
        end
     --Wait for Mind Blast
        -- wait,sec=action.mind_blast.usable_in,if=action.mind_blast.usable_in<gcd.max*0.28&active_enemies<=5
        if ((mode.rotation == 1 and #enemies.yards40 <= 5) or mode.rotation == 3) and cd.mindBlast.remain() < gcd * 0.28 then
            return true
        end
     --Shadow Word Death
        -- shadow_word_death,if=(active_enemies<=4|(talent.reaper_of_souls.enabled&active_enemies<=2))&cooldown.shadow_word_death.charges=2
        if (enemies.yards40 <= 4 or (talent.reaperOfSouls and enemies.yards40 <= 2)) and charges.shadowWordDeath.count() == 2 then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if getHP(thisUnit) < 20 then
                    if cast.shadowWordDeath(thisUnit) then return end
                end
            end
        end
     --Shadow Fiend
        -- shadowfiend,if=!talent.mindbender.enabled,if=buff.voidform.stack>15
        if isChecked("Shadowfiend / Mindbender") and useCDs() then
            if not talent.mindbender and buff.voidForm.stack() >= getOptionValue("  Shadowfiend Stacks") then
                if cast.shadowfiend() then return end
            end
        end
     --Shadow Word Void
        -- shadow_word_void,if=talent.shadow_word_void.enabled&(insanity-(current_insanity_drain*gcd.max)+50)<100
        --if talent.shadowWordVoid and (power - (insanityDrain * gcd) + 50) < 100 then
        --    if cast.shadowWordVoid() then return end
        --end
     --Shadow Word Pain
        -- shadow_word_pain,if=talent.misery.enabled&dot.shadow_word_pain.remains<gcd,moving=1,cycle_targets=1
        if talent.misery and moving and debuff.shadowWordPain.count() < getOptionValue("SWP Max Targets") then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if debuff.shadowWordPain.remain(thisUnit) < gcd then
                    if cast.shadowWordPain(thisUnit,"aoe") then return end
                end
            end
        end
     --Vampiric Touch
        -- vampiric_touch,if=talent.misery.enabled&(dot.vampiric_touch.remains<3*gcd.max|dot.shadow_word_pain.remains<3*gcd.max),cycle_targets=1
        if talent.misery and debuff.vampiricTouch.count() < getOptionValue("VT Max Targets") and not isCastingSpell(spell.vampiricTouch) then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (getHP(thisUnit) > vtHPLimit or IsInInstance()) and (debuff.vampiricTouch.remain(thisUnit) < 3 * gcd or debuff.shadowWordPain.remain(thisUnit) < 3 * gcd) then
                    if cast.vampiricTouch(thisUnit,"aoe") then return end
                end
            end
        end
     --Shadow Word Pain
        -- shadow_word_pain,if=!talent.misery.enabled&!ticking&(active_enemies<5|talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled|artifact.sphere_of_insanity.rank())
        if not talent.misery and not debuff.shadowWordPain.exists()
            and (((mode.rotation == 1 and #enemies.yards40 < 5) or mode.rotation == 3) or talent.auspiciousSpirits or talent.shadowyInsight or artifact.sphereOfInsanity.enabled())

        then
            if cast.shadowWordPain() then return end
        end
     --Vampiric Touch
        -- vampiric_touch,if=!talent.misery.enabled&!ticking&(active_enemies<4|talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank()))
        if not talent.misery and not debuff.vampiricTouch.exists() and not isCastingSpell(spell.vampiricTouch)
            and (((mode.rotation == 1 and #enemies.yards40 < 4) or mode.rotation == 3) or talent.sanlayn or (talent.auspiciousSpirits and artifact.unleashTheShadows.enabled()))
        then
            if cast.vampiricTouch() then return end
        end
     --Shadow Word Pain
        -- shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&(talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled)),cycle_targets=1
        if not talent.misery and (((mode.rotation == 1 and #enemies.yards40 < 5) or mode.rotation == 3)
            and (talent.auspiciousSpirits or talent.shadowyInsight or artifact.sphereOfInsanity.enabled())) and debuff.shadowWordPain.count() < getOptionValue("SWP Max Targets")
        then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.shadowWordPain.exists(thisUnit) and ttd(thisUnit) > 10 then
                    if cast.shadowWordPain(thisUnit,"aoe") then return end
                end
            end
        end
     --Vampiric Touch
        -- vampiric_touch,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<4|talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank())),cycle_targets=1
        if not talent.misery and (((mode.rotation == 1 and #enemies.yards40 < 4) or mode.rotation == 3) or talent.sanlayn or (talent.auspiciousSpirits and artifact.unleashTheShadows.enabled()))
            and debuff.vampiricTouch.count() < getOptionValue("VT Max Targets") and not isCastingSpell(spell.vampiricTouch)
        then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (getHP(thisUnit) > vtHPLimit or IsInInstance()) and not debuff.vampiricTouch.exists(thisUnit) and ttd(thisUnit) > 10 then
                    if cast.vampiricTouch(thisUnit,"aoe") then return end
                end
            end
        end
     --Shadow Word Pain
        -- shadow_word_pain,if=!talent.misery.enabled&!ticking&target.time_to_die>10&(active_enemies<5&artifact.sphere_of_insanity.rank()),cycle_targets=1
        if not talent.misery and (((mode.rotation == 1 and #enemies.yards40 < 5) or mode.rotation == 3)
            and artifact.sphereOfInsanity.enabled()) and debuff.shadowWordPain.count() < getOptionValue("SWP Max Targets")
        then
            for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.shadowWordPain.exists(thisUnit) and ttd(thisUnit) > 10 then
                    if cast.shadowWordPain(thisUnit,"aoe") then return end
                end
            end
        end
     --Mind Flay
        -- mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(action.void_bolt.usable|(current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+30)<100&cooldown.shadow_word_death.charges>=1))
        --if isCastingSpell(spell.mindFlay) and mfTick >= 2 and (cd.voidBolt.remain() == 0 or (insanityDrain * gcdMax > power and (power - (insanityDrain * gcdMax) + 30) < 100 and charges.shadowWordDeath.count() >= 1)) then
        -- mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
        if isCastingSpell(spell.mindFlay) and mfTick >= 2 and (cd.voidBolt.remain() == 0 or cd.mindBlast.remain() == 0) then
            SpellStopCasting()
            return true
        elseif not moving then
            if cast.mindFlay() then return end
        end
    end -- End Action List - Surrender To Madness
-- Action List - VoidForm
    function actionList_VoidForm()
     -- Try to proc Sephuzs
        -- silence,if=equipped.sephuzs_secret&(target.is_add|target.debuff.casting.react)&cooldown.buff_sephuzs_secret.remains<1&!buff.sephuzs_secret.up&buff.insanity_drain_stacks.value>10,cycle_targets=1
        --if buff.sephuz1.exists() and not buff.sephuzCooldown.exists() and not buff.sephuz2.exists() and drainStacks > 10 then
        --    -- Arcane Torrent (blood elf racial)
        --    if br.player.race == "blood elf" and getSpellCD(racial) == 0 and #enemies.yards8 > 0 then
        --        for i = 1, #enemies.yards8 do
        --            local thisUnit = enemies.yards5[i]
        --            if not isBoss(thisUnit) and UnitLevel(thisUnit) < UnitLevel("player") + 3 then
        --                if castSpell("player",racial,false,false,false) then return end
        --            end
        --        end
        --    end
        --    -- Quaking Palm (panda racial)  getDistance(thisUnit,thisEnemy)
        --    if br.player.race == "pandaren" and getSpellCD(racial) == 0 and #enemies.yards5 > 0 then
        --        if not mode.rotation == 3 then
        --            for i = 1, #enemies.yards5 do
        --                local thisUnit = enemies.yards5[i]
        --                if not isBoss(thisUnit) and UnitLevel(thisUnit) < UnitLevel("player") + 3 then
        --                    if castSpell("player",racial,false,false,false) then return end
        --                end
        --            end
        --        end
        --    end
        --    -- Silence
        --    if not isBoss(units.dyn40) then
        --        if cast.silence(units.dyn40) then return end
        --    end
        --    if not mode.rotation == 3 then
        --        for i = 1, #enemies.yards40 do
        --            local thisUnit = enemies.yards40[i]
        --            if not isBoss(thisUnit) and UnitLevel(thisUnit) < UnitLevel("player") + 3 then
        --                if cast.silence(thisUnit) then return end
        --            end
        --        end
        --    end
        --end
    -- Arcane Torrent (blood elf racial)
        --if isChecked("Arcane Torrent") and useCDs() and br.player.race == "blood elf" and getSpellCD(racial) == 0 then
        --    if power <= 30 and buff.voidForm.exists() then
        --        if castSpell("player",racial,false,false,false) then return end
        --    end
        --end
    -- Dark Ascension
        if isChecked("Dark Ascension Burst") and useCDs() then
            --if power <= getOptionValue("  Insanity Percentage") and buff.voidForm.exists() then
            if power <= 32 and buff.voidForm.exists() then
                if cast.darkAscension() then return end --Print("VF") return end
            end
        end
    -- Void Bolt
        -- void_bolt
        --if cd.voidBolt.remain() == 0 or buff.void.exists() then
            --if cast.voidBolt(units.dyn40,"known") then return end
        if #enemies.yards40 < 4 or (isMoving("player") and #enemies.yards40 >= 4) then    
            if cast.voidBolt(units.dyn40) then return end
        end
    -- Mind Bomb - to proc Sephuzs
        -- mind_bomb,if=equipped.sephuzs_secret&target.is_add&cooldown.buff_sephuzs_secret.remains<1&!buff.sephuzs_secret.up&buff.insanity_drain_stacks.value>10,cycle_targets=1
        --if buff.sephuz1.exists() and buff.sephuzCooldown.remain() < 1 and not buff.sephuz2.exists() and drainStacks > 10 then
        --    if canInterrupt(units.dyn40,100) then
        --        if cast.mindBomb(units.dyn40) then return end
        --    end
        --    if not mode.rotation == 3 then
        --        for i = 1, #enemies.yards40 do
        --            local thisUnit = enemies.yards40[i]
        --            if not isInstanceBoss(thisUnit) and UnitLevel(thisUnit) < UnitLevel("player") + 3 then
        --                if cast.mindBomb(thisUnit) then return end
        --            end
        --        end
        --    end
        --end
    -- Higher Priority for DOTS in Void Form (Experimental)
        if getOptionValue("APL Mode") == 2 then
        -- Vampiric Touch
            if not moving and not debuff.vampiricTouch.exists(units.dyn40) and ((1 + 0.02 * buff.voidForm.stack()) * dot_vt_dpgcd * ttd(units.dyn40) / (gcdMax * (156 + sear_dpgcd * (#searEnemies - 1)))) > 1 then
                if cast.vampiricTouch(units.dyn40) then return end
            end
            if debuff.vampiricTouch.count() < VTmaxTargets and not moving and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not debuff.vampiricTouch.exists(thisUnit) and ((1 + 0.02 * buff.voidForm.stack()) * dot_vt_dpgcd * ttd(thisUnit) / (gcdMax * (156 + sear_dpgcd * (#searEnemies - 1)))) > 1 then
                        if cast.vampiricTouch(thisUnit,"aoe") then return end
                    end
                end
            end
        -- Shadow Word - Pain
            if not debuff.shadowWordPain.exists(units.dyn40) and ((1 + 0.02 * buff.voidForm.stack()) * dot_swp_dpgcd * ttd(units.dyn40) / (gcdMax * (118 + sear_dpgcd * (#searEnemies - 1)))) > 1 then
                if cast.shadowWordPain(units.dyn40) then return end
            end
            if debuff.shadowWordPain.count() < SWPmaxTargets then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not debuff.shadowWordPain.exists(thisUnit) and ((1 + 0.02 * buff.voidForm.stack()) * dot_swp_dpgcd * ttd(thisUnit) / (gcdMax * (118 + sear_dpgcd * (#searEnemies - 1)))) > 1 then
                        if cast.shadowWordPain(thisUnit,"aoe") then return end
                    end
                end
            end
        end -- END: Higher Priority for DOTS in Void Form (Experimental)
    -- Shadow Word - Death
        -- shadow_word_death,if=(active_enemies<=4|(talent.reaper_of_souls.enabled&active_enemies<=2))&current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+(15+15*talent.reaper_of_souls.enabled))<100
        --if (#searEnemies <= 4 or (talent.reaperOfSouls and activeEnemies <= 2))
        --    and insanityDrain * gcdMax > power and (power - (insanityDrain * gcdMax) + (15 + 15 * reaperOfSouls)) < 100
        --then
        --    -- If Zeks Exterminatus (legendary cloak) has procced, SW:D is castable on any target, regardless of HP
        --    if getHP(units.dyn40) < executeHP  or buff.zeksExterminatus.exists() then
        --        if cast.shadowWordDeath(units.dyn40) then return end
        --    end
        --    if not mode.rotation == 3 then
        --        -- Look for any targets in execute HP range
        --        for i = 1, #enemies.yards40 do
        --            local thisUnit = enemies.yards40[i]
        --            if getHP(thisUnit) < executeHP then
        --                if cast.shadowWordDeath(thisUnit) then return end
        --            end
        --        end
        --    end
        --end
    -- Surrender to Madness
        -- surrender_to_madness,if=talent.surrender_to_madness.enabled&insanity>=25&(cooldown.void_bolt.up|cooldown.void_torrent.up|cooldown.shadow_word_death.up|buff.shadowy_insight.up)&target.time_to_die<=variable.s2mcheck-(buff.insanity_drain_stacks.value)
        if isChecked("Surrender To Madness") and useCDs() then
            if talent.surrenderToMadness and power >= 25 and (cd.voidBolt.remain() == 0 or cd.voidTorrent.remain() == 0 or cd.shadowWordDeath.remain() == 0 or buff.shadowyInsight.exists())
                and ttd(units.dyn40) <= s2mCheck - drainStacks
            then
                if cast.surrenderToMadness() then return end
            end
        end
    -- Dark Void
        if not moving then
            if #dVEnemies >= getOptionValue("Dark Void Targets") and talent.darkVoid then
                if cast.darkVoid() then return end
            end
        end   
    -- Dark Ascension AoE
        if isChecked("Dark Ascension AoE") then
            if #dAEnemies >= getOptionValue("Dark Ascension Targets") and buff.voidForm.exists() then --and cd.darkVoid.exists() then
                if cast.darkAscension("aoe") then return end --Print("VF DA AoE") return end
            end
        end
    -- Mindbender
        if isChecked("Shadowfiend / Mindbender") and talent.mindbender and useCDs() then
            if getOptionValue("  Shadowfiend Stacks") > 0 then
            -- use configured value
                if buff.voidForm.stack() >= getOptionValue("  Shadowfiend Stacks") then
                    if cast.mindbender() then return end
                end
            else
            -- mindbender,if=buff.insanity_drain_stacks.value>=(variable.cd_time-(3*set_bonus.tier20_4pc*(raid_event.movement.in<15)*((active_enemies-(raid_event.adds.count*(raid_event.adds.remains>0)))=1))+(5-3*set_bonus.tier20_4pc)*buff.bloodlust.up+2*talent.fortress_of_the_mind.enabled*set_bonus.tier20_4pc)&(!talent.surrender_to_madness.enabled|(talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck-buff.insanity_drain_stacks.value))
                if drainStacks >= (cd_time -  (3 * t20pc4 * raidMovementWithin15 * singleEnemy) + (5 - 3*t20pc4)*lusting + 2*fortressOfTheMind*t20pc4)
                    and (not talent.surrenderToMadness or (talent.surrenderToMadness and ttd(units.dyn40) > s2mCheck - drainStacks))
                then
                    if cast.mindbender() then return end
                end
            end
        end
    -- Berserking
        -- berserking,if=buff.voidform.stack>=10&buff.insanity_drain_stacks.stack<=20&(!talent.surrender_to_madness.enabled|(talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck-(buff.insanity_drain_stacks.stack)+60))
        if br.player.race == "Troll" and getSpellCD(racial) == 0 and buff.voidForm.stack() >= 10 and drainStacks <= 20
            and (not talent.surrenderToMadness or (talent.surrenderToMadness and ttd(units.dyn40) > s2mCheck + 60 - drainStacks))
        then
            if castSpell("player",racial,false,false,false) then return end
        end
    -- Shadow Word - Death
        -- shadow_word_death,if=(active_enemies<=4|(talent.reaper_of_souls.enabled&active_enemies<=2))&cooldown.shadow_word_death.charges=2
        -- if (#searEnemies <= 4 or (talent.reaperOfSouls and activeEnemies <= 2)) and charges.shadowWordDeath.count() == 2 then
        --    -- If Zeks Exterminatus (legendary cloak) has procced, SW:D is castable on any target, regardless of HP
        --    if getHP(units.dyn40) < executeHP  or buff.zeksExterminatus.exists() then
        --       if cast.shadowWordDeath(units.dyn40) then return end
        --    end
        --    if not mode.rotation == 3 then
        --        -- Look for any targets in execute HP range
        --        for i = 1, #enemies.yards40 do
        --            local thisUnit = enemies.yards40[i]
        --            if getHP(thisUnit) < executeHP then
        --                if cast.shadowWordDeath(thisUnit) then return end
        --            end
        --        end
        --    end
        --end
    -- Shadow Crash
        -- shadow_crash,if=talent.shadow_crash.enabled
        if isChecked("Shadow Crash") and talent.shadowCrash and not isMoving("target") then
            if cast.shadowCrash("best",nil,1,8) then return end
        end
    -- Wait For Void Bolt
        -- wait,sec=action.void_bolt.usable_in,if=action.void_bolt.usable_in<gcd.max*0.28
        --if cd.voidBolt.remain() < gcdMax * 0.28 then
        --    return true
        --end
    -- Shadow Word - Void
        -- shadow_word_void,if=talent.shadow_word_void.enabled&(insanity-(current_insanity_drain*gcd.max)+25)<100
        --if talent.shadowWordVoid and (power - (insanityDrain * gcdMax) + 25) < 100 then
        --    if cast.shadowWordVoid() then return end
        --end
    -- Wait For Shadow Word - Void
        -- wait,sec=action.mind_blast.usable_in,if=action.mind_blast.usable_in<gcd.max*0.28&active_enemies<=4
        --if cd.shadowWordVoid.remain() < gcdMax * 0.12 then
        --    return true
        --end
    -- Mind Blast
        -- mind_blast,if=active_enemies<=4
        if not moving and ((mode.rotation == 1 and #enemies.yards40 <= 4) or mode.rotation == 3) and dotsUp then
            if cast.mindBlast() then return end
        end
    -- Wait For Mind Blast
        -- wait,sec=action.mind_blast.usable_in,if=action.mind_blast.usable_in<gcd.max*0.28&active_enemies<=4
        --if cd.mindBlast.remain() < gcdMax * 0.28 then
        --    return true
        --end
    -- Void Torrent
        -- void_torrent,if=dot.shadow_word_pain.remains>5.5&dot.vampiric_touch.remains>5.5&(!talent.surrender_to_madness.enabled|(talent.surrender_to_madness.enabled&target.time_to_die>variable.s2mcheck-(buff.insanity_drain_stacks.stack)+60))
        if isChecked("Void Torrent") and talent.voidTorrent and useCDs()
            and debuff.shadowWordPain.remain(units.dyn40) > 5.5 and debuff.vampiricTouch.remain(units.dyn40) > 5.5
            and (not talent.surrenderToMadness or (talent.surrenderToMadness and ttd(units.dyn40) > s2mCheck - drainStacks + 60))
        then
            if cast.voidTorrent() then return end
        end
    -- Shadowfiend
        -- shadowfiend,if=!talent.mindbender.enabled&buff.voidform.stack>15
        if isChecked("Shadowfiend / Mindbender") and not talent.mindbender and useCDs() then
            if getOptionValue("  Shadowfiend Stacks") > 0 then
                if buff.voidForm.stack() >= getOptionValue("  Shadowfiend Stacks") then
                    if cast.shadowfiend() then return end
                end
            else
                if buff.voidForm.stack() > 15 then
                    if cast.shadowfiend() then return end
                end
            end
        end
    -- Mouseover Dotting
        if isChecked("Mouseover Dotting") and hasMouse and (UnitIsEnemy("player","mouseover") or isDummy("mouseover")) and not moving and not recentlyCast("mouseover", spell.vampiricTouch, 1.1*gcdMax) then
            if getDebuffRemain("mouseover",spell.vampiricTouch,"player") <= 3*gcdMax then
                if cast.vampiricTouch("mouseover") then
                    lastCastTrackerSpell = spell.vampiricTouch
                    lastCastTrackerUnit = "mouseover"
                    lastCastTrackerTime = GetTime()
                    return
                end
            end
        end
        if isChecked("Mouseover Dotting") and hasMouse and (UnitIsEnemy("player","mouseover") or isDummy("mouseover")) and not recentlyCast("mouseover", spell.shadowWordPain, 1.1*gcdMax) then
            if getDebuffRemain("mouseover",spell.shadowWordPain,"player") <= 3*gcdMax then
                if cast.shadowWordPain("mouseover") then
                    lastCastTrackerSpell = spell.shadowWordPain
                    lastCastTrackerUnit = "mouseover"
                    lastCastTrackerTime = GetTime()
                    return
                end
            end
        end
    -- Vampiric Touch
        -- vampiric_touch,if=talent.misery.enabled&(dot.vampiric_touch.remains<3*gcd.max|dot.shadow_word_pain.remains<3*gcd.max)&target.time_to_die>5*gcd.max,cycle_targets=1
        if talent.misery and not moving then
            if (debuff.shadowWordPain.remain(units.dyn40) < 3*gcdMax or debuff.vampiricTouch.remain(units.dyn40) < 3*gcdMax) and ttd(units.dyn40) > 5*gcdMax then
                if cast.vampiricTouch(units.dyn40,"aoe") then return end
            end
            if debuff.vampiricTouch.remainCount(gcdMax) < VTmaxTargets then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if (debuff.vampiricTouch.remain(thisUnit) < 3*gcdMax or debuff.shadowWordPain.remain(thisUnit) < 3*gcdMax) and ttd(thisUnit) > 5*gcdMax then
                        if cast.vampiricTouch(thisUnit,"aoe") then return end
                    end
                end
            end
        end
    -- Shadow Word - Pain
        -- shadow_word_pain,if=talent.misery.enabled&dot.shadow_word_pain.remains<gcd,moving=1,cycle_targets=1
        if moving and talent.misery then
            if debuff.shadowWordPain.remain(units.dyn40) < gcdMax then
                if cast.shadowWordPain(units.dyn40,"aoe") then return end
            end
            if debuff.shadowWordPain.remainCount(gcdMax) < SWPmaxTargets then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not GetUnitIsUnit(thisUnit, units.dyn40) and debuff.shadowWordPain.remain(thisUnit) < gcdMax then
                        if cast.shadowWordPain(thisUnit,"aoe") then return end
                    end
                end
            end
        end
    -- Shadow Word - Pain
        -- shadow_word_pain,if=!talent.misery.enabled&!ticking&(active_enemies<5|talent.auspicious_spirits.enabled|talent.shadowy_insight.enabled|artifact.sphere_of_insanity.rank())
        if not talent.misery and not debuff.shadowWordPain.exists()
            and (#searEnemies < 5 or talent.auspiciousSpirits or talent.shadowyInsight or artifact.sphereOfInsanity.enabled())
        then
            if cast.shadowWordPain() then return end
        end
    -- Vampiric Touch
        -- vampiric_touch,if=!talent.misery.enabled&!ticking&(active_enemies<4|talent.sanlayn.enabled|(talent.auspicious_spirits.enabled&artifact.unleash_the_shadows.rank()))
        if not talent.misery and not debuff.vampiricTouch.exists() and not isCastingSpell(spell.vampiricTouch) and not moving
            and (#searEnemies < 4 or talent.sanlayn or (talent.auspiciousSpirits and artifact.unleashTheShadows.enabled()))
        then
            if cast.vampiricTouch() then return end
        end
        -- vampiric_touch,if=active_enemies>1&!talent.misery.enabled&!ticking&((1+0.02*buff.voidform.stack)*variable.dot_vt_dpgcd*target.time_to_die%(gcd.max*(156+variable.sear_dpgcd*(active_enemies-1))))>1,cycle_targets=1
        if activeEnemies > 1 and not talent.misery and not moving then
            if not debuff.vampiricTouch.exists(units.dyn40) and ((1 + 0.02 * buff.voidForm.stack()) * dot_vt_dpgcd * ttd(units.dyn40) / (gcdMax * (156 + sear_dpgcd * (#searEnemies - 1)))) > 1 then
                if cast.vampiricTouch(units.dyn40) then return end
            end
            if debuff.vampiricTouch.count() < VTmaxTargets and not moving and not isCastingSpell(spell.vampiricTouch) then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not debuff.vampiricTouch.exists(thisUnit) and ((1 + 0.02 * buff.voidForm.stack()) * dot_vt_dpgcd * ttd(thisUnit) / (gcdMax * (156 + sear_dpgcd * (#searEnemies - 1)))) > 1 then
                        if cast.vampiricTouch(thisUnit,"aoe") then return end
                    end
                end
            end
        end
    -- Shadow Word - Pain
        -- shadow_word_pain,if=active_enemies>1&!talent.misery.enabled&!ticking&((1+0.02*buff.voidform.stack)*variable.dot_swp_dpgcd*target.time_to_die%(gcd.max*(118+variable.sear_dpgcd*(active_enemies-1))))>1,cycle_targets=1
        if activeEnemies > 1 and not talent.misery then
            if not debuff.shadowWordPain.exists(units.dyn40) and ((1 + 0.02 * buff.voidForm.stack()) * dot_swp_dpgcd * ttd(units.dyn40) / (gcdMax * (118 + sear_dpgcd * (#searEnemies - 1)))) > 1 then
                if cast.shadowWordPain(units.dyn40) then return end
            end
            if debuff.shadowWordPain.count() < SWPmaxTargets then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not debuff.shadowWordPain.exists(thisUnit) and ((1 + 0.02 * buff.voidForm.stack()) * dot_swp_dpgcd * ttd(thisUnit) / (gcdMax * (118 + sear_dpgcd * (#searEnemies - 1)))) > 1 then
                        if cast.shadowWordPain(thisUnit,"aoe") then return end
                    end
                end
            end
        end
    -- Mind Sear
        if isCastingSpell(spell.mindSear) and msTick >= 2 and (cd.voidBolt.remain() == 0 or cd.mindBlast.remain() == 0) then
            SpellStopCasting()
            return true
        elseif not moving and not isCastingSpell(spell.mindSear) and #searEnemies >= getOptionValue("Mind Sear Targets") then
            if cast.mindSear() then return end
        end    
    -- Mind Flay
        -- mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(action.void_bolt.usable|(current_insanity_drain*gcd.max>insanity&(insanity-(current_insanity_drain*gcd.max)+30)<100&cooldown.shadow_word_death.charges>=1))
        --if isCastingSpell(spell.mindFlay) and mfTick >= 2 and (cd.voidBolt.remain() == 0 or (insanityDrain * gcdMax > power and (power - (insanityDrain * gcdMax) + 30) < 100 and charges.shadowWordDeath.count() >= 1)) then
        -- mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
        if isCastingSpell(spell.mindFlay) and mfTick >= 2 and (cd.voidBolt.remain() == 0 or cd.mindBlast.remain() == 0) then
            SpellStopCasting()
            return true
        elseif not moving and not isCastingSpell(spell.mindFlay) and #searEnemies < getOptionValue("Mind Sear Targets") then
            if cast.mindFlay() then return end
        end
    -- Shadow Word - Pain
        -- shadow_word_pain
        cast.shadowWordPain()
    end -- End Action List - VoidForm
---------------------
--- Begin Profile ---
---------------------
-- Profile Stop | Pause
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop==true) or IsMounted() or IsFlying() or (pause(true) and not isCastingSpell(spell.mindFlay)) or mode.rotation==4 or buff.void.exists() then
        return true
    else
-----------------
--- Rotations ---
-----------------
        if actionList_Extra() then return end
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
        if not inCombat then --  and GetObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player")
            if actionList_PreCombat() then return end
        end
-----------------------------
--- In Combat - Rotations ---
-----------------------------
        if inCombat and not IsMounted() and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40 and not isCastingSpell(spell.voidTorrent) and not isCastingSpell(spell.mindBlast) then
        if actionList_Defensive() then return end
        -- Action List - Cooldowns
            actionList_Cooldowns()
        -- Action List - Check
            -- call_action_list,name=check,if=talent.surrender_to_madness.enabled&!buff.surrender_to_madness.up
            if talent.surrenderToMadness and not buff.surrenderToMadness then
                if actionList_Check() then return end
            end
        -- Action List - Interrupts
            --if useInterrupts() then
                if actionList_Interrupts() then return end
            --end
        -- Action List - Surrender To Madness
            -- s2m,if=buff.voidform.up&buff.surrender_to_madness.up
            if buff.voidForm.exists() and buff.surrenderToMadness.exists() then
                if actionList_SurrenderToMadness() then return end
            end
        -- Action List - Void Form
            -- run_action_list,name=vf,if=buff.voidform.up
            if mode.voidForm == 1 and buff.voidForm.exists() then
                if actionList_VoidForm() then return end
            end
        -- Action List - Main
            -- run_action_list,name=main
            if not buff.voidForm.exists() or mode.voidForm == 2 then
                if actionList_Main() then return end
            end
        end -- End Combat Rotation
    end
end -- Run Rotation

--local id = 258
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
