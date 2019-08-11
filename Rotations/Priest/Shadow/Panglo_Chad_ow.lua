local rotationName = "MonkaGiga" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles() -- Define custom toggles
    -- Rotation Button
    RotationModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Automatic Rotation",
            tip = "Swaps between Single and Multiple based on number of #enemies.yards8 in range.",
            highlight = 1,
            icon = br.player.spell.shadowWordVoid
        },
        [2] = {
            mode = "Sing",
            value = 2,
            overlay = "Single Target Rotation",
            tip = "Single target rotation used.",
            highlight = 0,
            icon = br.player.spell.mindFlay
        },
        [3] = {
            mode = "Off",
            value = 3,
            overlay = "DPS Rotation Disabled",
            tip = "Disable DPS Rotation",
            highlight = 0,
            icon = br.player.spell.psychicHorror
        }
    }
    CreateButton("Rotation", 1, 0)
    -- Cooldown Button
    CooldownModes = {
        [1] = {
            mode = "Auto",
            value = 1,
            overlay = "Cooldowns Automated",
            tip = "Automatic Cooldowns - Boss Detection.",
            highlight = 1,
            icon = br.player.spell.shadowfiend
        },
        [2] = {
            mode = "On",
            value = 2,
            overlay = "Cooldowns Enabled",
            tip = "Cooldowns used regardless of target.",
            highlight = 0,
            icon = br.player.spell.shadowfiend
        },
        [3] = {
            mode = "Off",
            value = 3,
            overlay = "Cooldowns Disabled",
            tip = "No Cooldowns will be used.",
            highlight = 0,
            icon = br.player.spell.shadowform
        }
    }
    CreateButton("Cooldown", 2, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Defensive Enabled",
            tip = "Includes Defensive Cooldowns.",
            highlight = 1,
            icon = br.player.spell.dispersion
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Defensive Disabled",
            tip = "No Defensives will be used.",
            highlight = 0,
            icon = br.player.spell.dispersion
        }
    }
    CreateButton("Defensive", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {
            mode = "On",
            value = 1,
            overlay = "Interrupts Enabled",
            tip = "Includes Basic Interrupts.",
            highlight = 1,
            icon = br.player.spell.silence
        },
        [2] = {
            mode = "Off",
            value = 2,
            overlay = "Interrupts Disabled",
            tip = "No Interrupts will be used.",
            highlight = 0,
            icon = br.player.spell.silence
        }
    }
    CreateButton("Interrupt", 4, 0)
end

local function createOptions()
    local optionTable

    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS --- -- Define General Options
        -----------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createSpinnerWithout(section, "SWP Max Targets", 4, 1, 10, 1, "Limit that SWP will be cast on.")

        br.ui:createSpinnerWithout(section, "VT Max Targets", 4, 1, 10, 1, "Limit that VT will be cast on.")

        br.ui:createSpinnerWithout(section, "Dot HP Limit", 5, 1, 200, 10, "Limit  HP to stop Dotting. x10K")

        br.ui:createCheckbox(section, "Dark Void")
        br.ui:createCheckbox(section, "Use lucid dreams")
        br.ui:createCheckbox(section, "Use Laser Beam")
        br.ui:createSpinnerWithout(section, "Laser Units", 3, 1, 50, 1)
        br.ui:createSpinnerWithout(section, "Lucid - void stacks", 20, 1, 40, 1)
        br.ui:createSpinnerWithout(section, "Lucid - insanity", 55, 1, 100, 5)
        br.ui:createSpinnerWithout(section, "Shadowfiend stacks", 10, 1, 40, 1)
        br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS --- -- Define Cooldown Options
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        br.ui:createCheckbox(section, "Dark Ascension")
        br.ui:createCheckbox(section, "Dispel Magic")
        br.ui:createCheckbox(section, "Shadow Crash")
        br.ui:createCheckbox(section, "Trinkets")
        br.ui:createCheckbox(section, "Racials")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS --- -- Define Defensive Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Dispersion", 10, 5, 100, 5)

        br.ui:createSpinner(section, "Healthstone", 10, 5, 100, 5)

        br.ui:createSpinner(section, "Power Word: Shield", 10, 5, 100, 5)

        br.ui:createCheckbox(section, "Fade")

        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS --- -- Define Interrupt Options
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, "Silence")
        br.ui:createCheckbox(section, "Mindbomb")
        br.ui:createCheckbox(section, "Psychic Horror")
        -- Interrupt Percentage
        br.ui:createSpinner(section, "Interrupt At", 30, 0, 95, 5, "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions
        }
    }
    return optionTable
end

local function runRotation()
    UpdateToggle("Rotation", 0.25)
    UpdateToggle("Cooldown", 0.25)
    UpdateToggle("Defensive", 0.25)
    UpdateToggle("Interrupt", 0.25)

    local addsExist = false
    local addsIn = 999
    local artifact = br.player.artifact
    local buff = br.player.buff
    local canFlask = canUseItem(br.player.flask.wod.agilityBig)
    local cast = br.player.cast
    local castable = br.player.cast.debug
    local combatTime = getCombatTime()
    local cd = br.player.cd
    local charges = br.player.charges
    local deadMouse = UnitIsDeadOrGhost("mouseover")
    local deadtar, attacktar, hastar, playertar = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local falling, swimming, flying, moving = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
    local flaskBuff = getBuffRemain("player", br.player.flask.wod.buff.agilityBig)
    local friendly = friendly or UnitIsFriend("target", "player")
    local gcd = br.player.gcdMax
    local hasMouse = GetObjectExists("mouseover")
    local healPot = getHealthPot()
    local inCombat = br.player.inCombat
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local level = br.player.level
    local lowestHP = br.friend[1].unit
    local mode = br.player.mode
    local moveIn = 999
    local moving = (isMoving("player") and not br.player.buff.norgannonsForesight.exists())
    local perk = br.player.perk
    local php = br.player.health
    local playerMouse = UnitIsPlayer("mouseover")
    local power, powmax, powgen, powerDeficit = br.player.power.insanity.amount(), br.player.power.insanity.max(), br.player.power.insanity.regen(), br.player.power.insanity.deficit()
    local pullTimer = br.DBM:getPulltimer()
    local racial = br.player.getRacial()
    local solo = #br.friend < 2
    local spell = br.player.spell
    local talent = br.player.talent
    local traits = br.player.traits
    local thp = getHP("target")
    local ttd = getTTD
    local ttm = br.player.power.insanity.ttm()
    local units = br.player.units
    local SWPmaxTargets = getOptionValue("SWP Max Targets")
    local VTmaxTargets = getOptionValue("VT Max Targets")
    local voidForm = buff.voidForm.exists()
    local filler = cd.shadowWordVoid.remain() > gcd * 0.8 and (not voidForm or cd.voidBolt.remain() > gcd * 0.8)

    local dotsUP = debuff.vampiricTouch.exists("target") and debuff.shadowWordPain.exists("target")

    local buffedSear = isCastingSpell(spell.mindSear) and buff.harvestedThoughts.exists()

    if leftCombat == nil then
        leftCombat = GetTime()
    end
    if profileStop == nil then
        profileStop = false
    end

    if vampUnit ~= nil and (vampTime + 1.6) < GetTime() then
        vampUnit = nil
    end

    units.get(5)
    units.get(8)
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)
    enemies.get(20)
    enemies.get(30)
    enemies.get(40)
    enemies.get(8, "target")
    units.get(40)
    enemies.get(8, "target")
    enemies.get(10, "target")
    enemies.get(40)

    local function actionlist_Extra()
        if not buff.shadowform.exists() and not buff.voidForm.exists() then
            if cast.shadowform() then
                return
            end
        end

        for i = 1, #enemies.yards30 do
            thisUnit = enemies.yards30[i]
            if isChecked("Dispel Magic") and canDispel(thisUnit, spell.dispelMagic) and not isBoss() then
                if cast.dispelMagic() then
                    return
                end
            end
        end

        if inCombat and useCDs() and buff.lingeringInsanity.exists("player") and not br.player.mode.cooldown ~= 3 and voidForm and isChecked("Use lucid dreams") and ((power <= getOptionValue("Lucid - insanity")) and (buff.voidForm.stack() >= getOptionValue("Lucid - void stacks"))) then
            if cast.memoryOfLucidDreams("player") then
                return
            end
        end

        if inCombat and not moving and not br.player.mode.cooldown ~= 3 and not voidForm and isChecked("Use Laser Beam") and (getEnemiesInRect(5,30) >= getOptionValue("Laser Units") or useCDs()) then
            if cast.focusedAzeriteBeam("player") then return end
        end
    end -- end Extra

    local function actionlist_Void()

        if cast.voidBolt() then
            return
        end

        if buff.harvestedThoughts.exists() and (cd.voidBolt.remain() > (gcd * 0.2)) and traits.searingDialogue.rank >= 1 then
            if cast.mindSear("best", false, 1, 10) then
                return
            end
        end

        if useCDs() and buff.lingeringInsanity.exists("player") and ttd("target") > 25 and buff.voidForm.stack() >= getOptionValue("Shadowfiend stacks") then
            if cast.shadowfiend() then
                return
            end
        end

        if isChecked("Shadow Crash") and talent.shadowCrash and not isMoving("target") then
            if castGround("target",205385,40,0,8,0) then return end
        end

        if debuff.shadowWordPain.count() < getOptionValue("SWP Max Targets") or not debuff.shadowWordPain.exists("target") then
            for i = 1, #enemies.yards40 do
                local thisUnit 
					if mode.rotation == 1 and debuff.shadowWordPain.exists("target") then
						thisUnit = enemies.yards40[i]
					elseif mode.rotation == 2 or not debuff.shadowWordPain.exists("target") then
						thisUnit = "target"
					end
                if not talent.misery and (debuff.shadowWordPain.remain(thisUnit) < 4.8 or not debuff.shadowWordPain.exists(thisUnit)) and not cast.last.shadowWordPain() and ttd(thisUnit) > 4 and (UnitHealth(thisUnit) > (getOptionValue("VT Dot HP Limit") * 10000)) then
                    if cast.shadowWordPain(thisUnit) then
                        return
                    end
                end
            end
        end

        if debuff.vampiricTouch.count() < getOptionValue("VT Max Targets") or not debuff.vampiricTouch.exists("target") then
            for i = 1, #enemies.yards40 do
                local thisUnit 
					if mode.rotation == 1 and debuff.vampiricTouch.exists("target") then
						thisUnit = enemies.yards40[i]
					elseif mode.rotation == 2 or not debuff.vampiricTouch.exists("target")then
						thisUnit = "target"
					end
                if UnitGUID(thisUnit) ~= vampUnit and (not debuff.vampiricTouch.exists(thisUnit) or debuff.vampiricTouch.remain(thisUnit) < 6.3 or (talent.misery and debuff.shadowWordPain.remain(thisUnit) < 4.8)) and ttd(thisUnit) > 6 and (UnitHealth(thisUnit) > (getOptionValue("VT Dot HP Limit") * 10000)) then
                    if cast.vampiricTouch(thisUnit) then
                        vampUnit = UnitGUID(thisUnit)
                        vampTime = GetTime()
                        return
                    end
                end
            end
        end

        if not (cast.current.mindFlay() or cast.current.mindSear()) and not (cast.last.shadowWordVoid() or cast.last.mindBlast()) then
            if talent.shadowWordVoid then
                if cast.shadowWordVoid() then return end
            elseif cast.mindBlast() then
                return
            end
        end

        if not (cast.current.mindFlay() or cast.current.mindSear()) and cd.voidBolt.remain() >= 0.3 then
            if  #enemies.yards10t < 3 then
                if cast.mindFlay() then
                    return
                end
            else 
                if cast.mindSear("best", false, 1, 10) then return end
            end
        end
    end
    local function actionlist_Single()
        -- print(vampUnit)
        if power > 60 then
            if cast.voidEruption() then
                return
            end
        end

        if not voidForm and power < 30 and ttd("target") > 10 then
            if cast.darkAscension() then
                return
            end
        end

        if buff.harvestedThoughts.exists() and traits.searingDialogue.rank >= 1 then
            if cast.mindSear("best", false, 1, 10) then
                return
            end
        end

        if UnitGUID("target") ~= vampUnit and (not debuff.vampiricTouch.exists("target") or debuff.vampiricTouch.remain("target") < 6.3 or (talent.misery and debuff.shadowWordPain.remain("target") < 4.8)) and ttd("target") > 6 and (UnitHealth("target") > (getOptionValue("VT Dot HP Limit") * 10000)) then
            if cast.vampiricTouch("target") then
                vampUnit = UnitGUID("target")
                vampTime = GetTime()
                return
            end
        end

        if talent.darkVoid and isChecked("Dark Void") then
            if cast.darkVoid() then
                return
            end
        end

        if not talent.misery and (debuff.shadowWordPain.remain("target") < 4.8 or not debuff.shadowWordPain.exists("target")) and not cast.last.shadowWordPain() and ttd("target") > 4 then
            if cast.shadowWordPain() then
                return
            end
        end

        if dotsUP then
            if talent.shadowWordVoid then
                if cast.shadowWordVoid() then return end
            elseif cast.mindBlast() then
                return
            end
        end

        if dotsUP and not cast.current.mindFlay() then
            if cast.mindFlay() then
                return
            end
        end
    end

    local function actionlist_Multi()
        -- print(vampUnit)
        if power > 60 then
            if cast.voidEruption() then
                return
            end
        end

        if power < 30 and ttd("target") > 10 then
            if cast.darkAscension("player") then
                return
            end
        end

        if buff.harvestedThoughts.exists() and traits.searingDialogue.rank >= 1 and not cast.current.mindSear() then
            if cast.mindSear("best", false, 1, 10) then
                return
            end
        end

        if talent.darkVoid and isChecked("Dark Void") then
            if cast.darkVoid("best", false, 1, 8) then
                return
            end
        end

        if (dotsUP and #enemies.yards10t >= 8) and not cast.current.mindSear() then
            if cast.mindSear("best", false, 1, 10) then
                return
            end
        end

        if debuff.shadowWordPain.count() < getOptionValue("SWP Max Targets") or not debuff.shadowWordPain.exists("target") then
            for i = 1, #enemies.yards40 do
                local thisUnit 
                if mode.rotation == 1 and debuff.shadowWordPain.exists("target") then
                    thisUnit = enemies.yards40[i]
                elseif mode.rotation == 2 or not debuff.shadowWordPain.exists("target")then
                    thisUnit = "target"
                end
                if not talent.misery and (debuff.shadowWordPain.remain(thisUnit) < 4.8 or not debuff.shadowWordPain.exists(thisUnit)) and not cast.last.shadowWordPain() and ttd(thisUnit) > 4 and (UnitHealth(thisUnit) > (getOptionValue("VT Dot HP Limit") * 10000)) then
                    if cast.shadowWordPain(thisUnit) then
                        return
                    end
                end
            end
        end

        if debuff.vampiricTouch.count() < getOptionValue("VT Max Targets") or not debuff.vampiricTouch.exists("target") then
            for i = 1, #enemies.yards40 do
                local thisUnit 
                if mode.rotation == 1 and debuff.vampiricTouch.exists("target") then
                    thisUnit = enemies.yards40[i]
                elseif mode.rotation == 2 or not debuff.vampiricTouch.exists("target")then
                    thisUnit = "target"
                end
                if UnitGUID(thisUnit) ~= vampUnit and (not debuff.vampiricTouch.exists(thisUnit) or debuff.vampiricTouch.remain(thisUnit) < 6.3 or (talent.misery and debuff.shadowWordPain.remain(thisUnit) < 4.8)) and ttd(thisUnit) > 6 and (UnitHealth(thisUnit) > (getOptionValue("VT Dot HP Limit") * 10000)) then
                    if cast.vampiricTouch(thisUnit) then
                        vampUnit = UnitGUID(thisUnit)
                        vampTime = GetTime()
                        return
                    end
                end
            end
        end

        if dotsUP and not cast.current.mindSear() and #enemies.yards10t >= 6 then
            if cast.mindSear("best", false, 1, 10) then
                return
            end
        end

        if dotsUP then
            if talent.shadowWordVoid then
                if cast.shadowWordVoid() then return end
            elseif cast.mindBlast() then
                return
            end
        end

        if dotsUP and not cast.current.mindSear() and #enemies.yards10t > 1 and #enemies.yards10t <= 5 then
            if cast.mindSear("best", false, 1, 10) then
                return
            end
        end

        if dotsUP and not cast.current.mindFlay() and #enemies.yards10t == 1 then
            if cast.mindFlay() then
                return
            end
        end
    end

    function actionlist_Defensive()
        if mode.defensive == 1 and getHP("player") > 0 then
            -- Dispersion
            if isChecked("Dispersion") and php <= getOptionValue("Dispersion") then
                if cast.dispersion("player") then
                    return
                end
            end

            -- Fade
            if isChecked("Fade") then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if not solo and hasThreat(thisUnit) then
                        if cast.fade("player") then
                            return
                        end
                    end
                end
            end

            if isChecked("Healthstone") and php <= getOptionValue("Healthstone") and inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                elseif hasItem(166799) and canUseItem(166799) then
                    useItem(166799)
                end
            end

            if (moving and not debuff.weakenedSoul.exists("player") and isChecked("Power Word: Shield")) or (isChecked("Power Word: Shield") and php <= getOptionValue("Power Word: Shield") and not buff.powerWordShield.exists()) then
                if cast.powerWordShield("player") then
                    return
                end
            end
        end
    end

    function actionlist_Interrupts()
        if useInterrupts() then
            for i = 1, #enemies.yards30 do
                local thisUnit = enemies.yards30[i]
                if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                    -- Silence
                    if isChecked("Silence") then
                        if cast.silence(thisUnit) then
                            return
                        end
                    end

                    -- Psychic Horror
                    if isChecked("Psychic Horror") then
                        if cast.psychicHorror(thisUnit) then
                            return
                        end
                    end
                end
            end
        end
    end

    if isCastingSpell(295258) then 
        return true
    end

    if (pause() or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) or mode.rotation == 3) and not cast.current.mindFlay() and not (cast.current.mindSear and not traits.searingDialogue.active) then
        return true
    else
        -- combat check
        if not IsMounted() then
            -- print("int")
            if actionlist_Interrupts() then
                return
            end
            -- print("ext")
            if actionlist_Extra() then
                return
            end
            -- print("def")
            if actionlist_Defensive() then
                return
            end
        end
        if inCombat and profileStop == false and not (IsMounted() or IsFlying()) then

            if voidForm then
                if actionlist_Void() then return end
            else
                if #enemies.yards40 == 1 or br.player.mode.rotation == 2 then
                    if actionlist_Single() then
                        return
                    end
                else
                    if #enemies.yards40 > 1 then
                        if actionlist_Multi() then
                            return
                        end
                    end
                end
            end
        end
    end
end

local id = 258 -- Change to the spec id profile is for.
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(
    br.rotations[id],
    {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation
    }
)
