if select(2, UnitClass("player")) == "PRIEST" then
	local rotationName = "Cpoworks"

---------------
--- Toggles ---
---------------
	local function createToggles()
        -- Rotation Button
        RotationModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = bb.player.spell.mindFlay },
            [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = bb.player.spell.mindSear },
            [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = bb.player.spell.mindFlay },
            [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = bb.player.spell.shadowMend}
        };
        CreateButton("Rotation",1,0)
        -- Cooldown Button
        CooldownModes = {
            [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = bb.player.spell.voidEruption },
            [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = bb.player.spell.voidEruption },
            [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.voidEruption }
        };
       	CreateButton("Cooldown",2,0)
        -- Defensive Button
        DefensiveModes = {
            [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = bb.player.spell.shamanisticRage },
            [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = bb.player.spell.shamanisticRage }
        };
        CreateButton("Defensive",3,0)
    end

---------------
--- OPTIONS ---
---------------
	local function createOptions()
        local optionTable

        local function rotationOptions()
            local section
            -- General Options
            section = bb.ui:createSection(bb.ui.window.profile, "General")
                -- SWP Max Targets
                bb.ui:createSpinner(section, "SWP Max Targets",  3,  1,  10,  1)
                -- VT Max Targets
                bb.ui:createSpinner(section, "VT Max Targets",  3,  1,  10,  1)
            bb.ui:checkSectionState(section)
            -- Cooldown Options
            section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
                -- Int Pot
                bb.ui:createCheckbox(section,"Int Pot")
                -- Legendary Ring
                bb.ui:createCheckbox(section, "Legendary Ring", "Enable or Disable usage of Legendary Ring.")
                -- Flask / Crystal
                bb.ui:createCheckbox(section,"Flask / Crystal")
                -- Trinkets
                bb.ui:createCheckbox(section,"Trinkets")
                -- Touch of the Void
                bb.ui:createCheckbox(section,"Touch of the Void")
                -- Void Eruption
                bb.ui:createCheckbox(section,"Void Eruption")
                -- Shadowfiend
                bb.ui:createCheckbox(section,"Shadowfiend")
            bb.ui:checkSectionState(section)
            -- Defensive Options
            section = bb.ui:createSection(bb.ui.window.profile, "Defensive")
                -- Healthstone
                bb.ui:createSpinner(section, "Healthstone",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Heirloom Neck
                bb.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
                -- Gift of The Naaru
                if bb.player.race == "Draenei" then
                    bb.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
                end
                -- Dispel Magic
                bb.ui:createCheckbox(section,"Dispel Magic")
            bb.ui:checkSectionState(section)
            -- Toggle Key Options
            section = bb.ui:createSection(bb.ui.window.profile, "Toggle Keys")
                -- Single/Multi Toggle
                bb.ui:createDropdown(section, "Rotation Mode", bb.dropOptions.Toggle,  4)
                -- Cooldown Key Toggle
                bb.ui:createDropdown(section, "Cooldown Mode", bb.dropOptions.Toggle,  3)
                -- Pause Toggle
                bb.ui:createDropdown(section, "Pause Mode", bb.dropOptions.Toggle,  6)
            bb.ui:checkSectionState(section)
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
        if bb.timer:useTimer("debugShadow", 0.1) then
            --print("Running: "..rotationName)

    ---------------
    --- Toggles ---
    ---------------
            UpdateToggle("Rotation",0.25)
            UpdateToggle("Cooldown",0.25)
            UpdateToggle("Defensive",0.25)
    --------------
    --- Locals ---
    --------------
            local buff              = bb.player.buff
            local dyn40              = bb.player.units.dyn40
            local canFlask          = canUse(bb.player.flask.wod.agilityBig)
            local cd                = bb.player.cd
            local charges           = bb.player.charges
            local combatTime        = getCombatTime()
            local debuff            = bb.player.debuff
            local distance          = getDistance("target")
            local enemies           = bb.player.enemies
            local flaskBuff         = getBuffRemain("player",bb.player.flask.wod.buff.agilityBig) or 0
            local frac              = bb.player.frac
            local glyph             = bb.player.glyph
            local healthPot         = getHealthPot() or 0
            local inCombat          = bb.player.inCombat
            local inRaid            = select(2,IsInInstance())=="raid"
            local level             = bb.player.level
            local needsHealing      = needsHealing or 0
            local php               = bb.player.health
            local power             = bb.player.power
            local pullTimer         = bb.DBM:getPulltimer()
            local race              = bb.player.race
            local racial            = bb.player.getRacial()
            local recharge          = bb.player.recharge
            local regen             = bb.player.powerRegen
            local solo              = select(2,IsInInstance())=="none"
            local talent            = bb.player.talent
            local thp               = getHP(bb.player.units.dyn40)
            local totem             = bb.player.totem
            local ttd               = getTimeToDie(bb.player.units.dyn40)
            local ttm               = bb.player.timeToMax
            if t18_4pc then t18_4pcBonus = 1 else t18_4pcBonus = 0 end

    --------------------
    --- Action Lists ---
    --------------------
        -- Action list - Extras
            function actionList_Extra()
            -- Dispel Magic
                if isChecked("Dispel Magic") and canDispel("target",bb.player.spell.dispelMagic) and not isBoss() and ObjectExists("target") then
                    if bb.player.castDispelMagic() then return end
                end
            end -- End Action List - Extra
        -- Action List - Defensive
            function actionList_Defensive()
                if useDefensive() and getHP("player")>0 then     
            -- Gift of the Naaru
                    if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and bb.player.race=="Draenei" then
                        if castSpell("player",racial,false,false,false) then return end
                    end
            -- Heirloom Neck
                    if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                        if hasEquiped(122668) then
                            if canUse(122668) then
                                useItem(122668)
                            end
                        end
                    end
                end -- End Defensive Check
            end -- End Action List - Defensive
        -- Action List - Interrupts
            function actionList_Interrupts()
                
            end -- End Action List - Interrupts
        -- Action List - Cooldowns
            function actionList_Cooldowns()
                if getDistance(dyn5)<5 then
            -- Heroism/Bloodlust
                    -- bloodlust,if=target.health.pct<25|time>0.500
                    if useCDs() and isChecked("HeroLust") and not raid and (thp<25 or combatTime>0.500) then
                        if bb.player.castHeroLust() then return end
                    end
            -- Legendary Ring
                    -- use_item,name=maalus_the_blood_drinker
                    if useCDs() and isChecked("Legendary Ring") then
                        if hasEquiped(124636) and canUse(124636) then
                            useItem(124636)
                            return true
                        end
                    end
            -- Racials
                    -- blood_fury
                    -- arcane_torrent
                    -- berserking
                    if useCDs() and (bb.player.race == "Orc" or bb.player.race == "Troll" or bb.player.race == "Blood Elf") then
                        if bb.player.castRacial() then return end
                    end
            -- Touch of the Void
                    if useCDs() and isChecked("Touch of the Void") and getDistance(bb.player.units.dyn5)<5 then
                        if hasEquiped(128318) then
                            if GetItemCooldown(128318)==0 then
                                useItem(128318)
                            end
                        end
                    end
            -- Trinkets
                    if useCDs() and isChecked("Trinkets") then
                        if canUse(13) then
                            useItem(13)
                        end
                        if canUse(14) then
                            useItem(14)
                        end
                    end     
                end
            end -- End Action List - Cooldowns
        -- Action List - Pre-Combat
            function actionList_PreCombat()
            
            end  -- End Action List - Pre-Combat
        -- Action List - Single
            function actionList_Auto()
                print("start")
                -- Shadow Word Death
                if thp < 20
                or (talent.reaperOfSouls and thp < 35) then
                    if bb.player.castSWD(dyn40)then return end
                end
                -- Mind Blast
                if bb.player.castMindBlast(dyn40) then print("MB") return end
                -- Shadow Word: Pain
                if bb.player.castSWPAutoApply(getOptionValue("SWP Max Targets")) then return end
                -- Vampiric Touch
                if bb.player.castVTAutoApply(getOptionValue("VT Max Targets")) then return end
                -- Shadow Word: Void

                -- Mind Shear

                -- Mind Spike

                -- Mind Flay
                if bb.player.castMindFlay(dyn40) then print("mindflay") return end
                print("done")
            end -- End Action List - Single

        -- Action List - VoidForm
            function actionList_VoidForm()
            
            end -- End Action List - VoidForm

    -----------------
    --- Rotations ---
    -----------------
            if actionList_Extra() then return end
            if actionList_Defensive() then return end
    ---------------------------------
    --- Out Of Combat - Rotations ---
    ---------------------------------
            if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if actionList_PreCombat() then return end
            end
    -----------------------------
    --- In Combat - Rotations --- 
    -----------------------------
            if inCombat then
                if actionList_Interrupts() then return end
                if actionList_Cooldowns() then return end
                if actionList_Auto() then return end
                
            end -- End Combat Rotation
        end -- End Timer
    end -- Run Rotation

    tinsert(cShadow.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })
end --End Class Check