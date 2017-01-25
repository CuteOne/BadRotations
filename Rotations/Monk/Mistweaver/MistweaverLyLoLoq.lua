local rotationName = "LyLoLoq"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Dispell
    DispellModes = {
        [1] = { mode = "On", value = 1 , overlay = "Dispell Enabled", tip = "", highlight = 1, icon = br.player.spell.detox },
        [2] = { mode = "Off", value = 2 , overlay = "Dispell Disabled", tip = "", highlight = 0, icon = br.player.spell.detox }
    };
    CreateButton("Dispell",1,0)
    -- Dispell
    FistweavingModes = {
        [1] = { mode = "On", value = 1 , overlay = "Fistweaving Enabled", tip = "", highlight = 1, icon = br.player.spell.risingSunKick },
        [2] = { mode = "Off", value = 2 , overlay = "Fistweaving Disabled", tip = "", highlight = 0, icon = br.player.spell.risingSunKick }
    };
    CreateButton("Fistweaving",2,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.legSweep },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.legSweep }
    };
    CreateButton("Interrupt",3,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        -------------------------
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
        --Effuse
        br.ui:createSpinnerWithout(section, "Effuse", 85, 0, 100, 1, "", "Health Percent to Cast At")
        --Renewing Mist
        br.ui:createSpinnerWithout(section, "Renewing Mist", 98, 0, 100, 1, "", "Health Percent to Cast At")
        --Enveloping Mist
        br.ui:createSpinnerWithout(section, "Enveloping Mist", 60, 0, 100, 1, "", "Health Percent to Cast At")
        --Sheilun's Gift
        br.ui:createSpinnerWithout(section, "Sheilun's Gift", 50, 0, 100, 1, "", "Health Percent to Cast At")
        --Zen Pulse
        br.ui:createSpinnerWithout(section, "Zen Pulse", 80, 0, 100, 1, "", "Health Percent to Cast At")
        br.ui:checkSectionState(section)
        ------------------------------
        ---- SINGLE TARGET BURST------
        ------------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing - BURST", "Quick cast")
        --Thunder Focus + Enveloping Mist
        br.ui:createSpinnerWithout(section, "TF + EM", 40, 0, 100, 1, "", "[Thunder Focus + Enveloping Mist] Health Percent to Cast At")
        --Life Coccon
        br.ui:createSpinnerWithout(section, "Life Coccon", 20, 0, 100, 1, "", "Health Percent to Cast At")
        br.ui:checkSectionState(section)
        ----------------------
        ---- MULTI TARGET ----
        ----------------------
        section = br.ui:createSection(br.ui.window.profile, "Multi Target Healing")
        --Essence Font
        br.ui:createSpinner(section, "Essence Font", 80, 0, 100, 1, "", "[If checked will use] Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Essence Font Targets",  4,  1,  40,  1,  "Number of players with low health to use Essence Font")
        --Vivify
        br.ui:createSpinnerWithout(section, "Vivify", 75, 0, 100, 1, "", "Health Percent to Cast At")
        --Chi Burst
        br.ui:createSpinnerWithout(section, "Chi Burst", 70, 0, 100, 1, "", "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Chi Burst Targets",  2,  1,  40,  1,  "Number of players with low health to use Chi Burst")
        br.ui:checkSectionState(section)
        ------------------------------
        ---- MULTI TARGET BURST ------
        ------------------------------
        section = br.ui:createSection(br.ui.window.profile, "Multi Target Healing - BURST", "Quick cast")
        --Revival
        br.ui:createSpinnerWithout(section, "Revival", 50, 0, 100, 1, "", "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Revival Targets",  2,  1,  40,  1,  "Number of players with low health to use Revival")
        --Invoke Chi-Ji, the Red Crane
        br.ui:createSpinnerWithout(section, "Invoke Chi-Ji", 40, 0, 100, 1, "", "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Invoke Chi-Ji Targets",  2,  1,  40,  1,  "Number of players with low health to use Invoke Chi-Ji")
        br.ui:checkSectionState(section)
        ------------------------
        ---- SELF HEALING ------
        ------------------------
        section = br.ui:createSection(br.ui.window.profile, "Self Healing")
        --Revival
        br.ui:createSpinnerWithout(section, "Healing Elixir", 80, 0, 100, 1, "", "Health Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Paralysis
        br.ui:createCheckbox(section, "Paralysis")
        -- Leg Sweep
        br.ui:createCheckbox(section, "Leg Sweep")
        -- Interrupt Percentage
        br.ui:createSpinnerWithout(section,  "InterruptAt",  50,  0,  100,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ---------------------
        --- EXTRA OPTIONS ---
        ---------------------
        section = br.ui:createSection(br.ui.window.profile, "Extra")
        -- Arcana Torrent
        br.ui:createSpinnerWithout(section,  "Arcane Torrent",  70,  0,  100,  5,  "|cffFFBB00Cast when mana bellow.")
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
local lastSpellCasted = ""
local lastSpellCatedOnPlayer = ""
local function runRotation()
    local player = br.player
    local lowest = br.friend[1]

    --    if br.timer:useTimer("debugMistweaver", player.gcd) then
    if br.timer:useTimer("debugMistweaver", math.random(0.15,0.3)) then


        ---------------
        --- Toggles ---
        ---------------
        UpdateToggle("Dispell",0.25)
        player.mode.dispell = br.data.settings[br.selectedSpec].toggles["Dispell"]
        UpdateToggle("Fistweaving",0.25)
        player.mode.fistweaving = br.data.settings[br.selectedSpec].toggles["Fistweaving"]
        UpdateToggle("Interrupt",0.25)



        ---------------------
        --- SINGLE TARGET ---
        ---------------------
        function singleTargetBurst()
            if lowest.hp <= getOptionValue("Life Coccon") then
                if player.cast.lifeCocoon(lowest.unit) then
                    lastSpellCasted = ""
                    lastSpellCatedOnPlayer = ""
                    return
                end
            end
            if player.talent.focusedThunder  and lowest.hp <= getOptionValue("TF + EM")  and (getBuffRemain(lowest.unit, player.spell.envelopingMist, "player") < 3 or (lastSpellCasted ~= "EM" or lastSpellCatedOnPlayer ~= lowest.unit)) then
                if player.cast.thunderFocusTea() then
                    FaceDirection(GetAnglesBetweenObjects("Player", lowest.unit), true)
                    if player.cast.envelopingMist(lowest.unit) then
                        lastSpellCasted = "EM"
                        lastSpellCatedOnPlayer = lowest.unit
                        return
                    end

                end
            end

        end

        function castRenewingMist()
            if getHP(lowest.unit) >= 55 then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getOptionValue("Renewing Mist") and getBuffRemain(br.friend[i].unit, player.spell.renewingMist, "player") < 3 then
                        if player.cast.renewingMist(br.friend[i].unit) then
                            lastSpellCasted = ""
                            lastSpellCatedOnPlayer = ""
                            return
                        end
                    end
                end
            end
        end

        function extraThunderFocus()
            if player.buff.thunderFocusTea.exists then
                if lowest.hp <= getOptionValue("TF + EM")*1.6 and (getBuffRemain(lowest.unit, player.spell.envelopingMist, "player") < 3 or (lastSpellCasted ~= "EM" or lastSpellCatedOnPlayer ~= lowest.unit))  then
                    if player.cast.envelopingMist(lowest.unit) then
                        FaceDirection(GetAnglesBetweenObjects("Player", lowest.unit), true)
                        lastSpellCasted = "EM"
                        lastSpellCatedOnPlayer = lowest.unit
                        return
                    end
                end
                if br.player.buff.thunderFocusTea.remain < 2 then
                    castRenewingMist()
                end

            end
        end

        function selfHealing()
            if player.talent.healingElixir and player.health <= getOptionValue("Healing Elixir") then
                if player.cast.healingElixir() then
                    lastSpellCasted = ""
                    lastSpellCatedOnPlayer = ""
                    return
                end
            end

        end

        function castDetox()
            if player.mode.dispell == 1 then
                for i = 1, #br.friend do
                    for n = 1,40 do
                        local buff,_,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                        if buff then
                            if bufftype == "Curse" or bufftype == "Magic" or bufftype == "Poison" then
                                if player.cast.detox(br.friend[i].unit) then
                                    lastSpellCasted = ""
                                    lastSpellCatedOnPlayer = ""
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end

        function singleTarget()
            singleTargetBurst()
            extraThunderFocus()
            selfHealing()

            if not isMoving("player") then
                if lowest.hp <= getOptionValue("Sheilun's Gift") and  GetSpellCount(player.spell.sheilunsGift) >= 5 then
                    if player.cast.sheilunsGift(lowest.unit) then
                        lastSpellCasted = ""
                        lastSpellCatedOnPlayer = ""
                        return
                    end
                end
                if lowest.hp <= getOptionValue("Enveloping Mist") and (getBuffRemain(lowest.unit, player.spell.envelopingMist, "player") < 3 or (lastSpellCasted ~= "EM" or lastSpellCatedOnPlayer ~= lowest.unit))  then
                    if player.cast.envelopingMist(lowest.unit) then
                        lastSpellCasted = "EM"
                        lastSpellCatedOnPlayer = lowest.unit
                        return
                    end
                end
                if player.talent.zenPulse and lowest.hp <= getOptionValue("Zen Pulse") and getNumEnemies(lowest.unit, 8) >= 3 then
                    if getBuffRemain(lowest.unit, player.spell.soothingMist, "player") == 0 then
                        if player.cast.zenPulse(lowest.unit) then
                            lastSpellCasted = ""
                            lastSpellCatedOnPlayer = ""
                            return
                        end
                    end
                end
                castRenewingMist()
                if lowest.hp <= getOptionValue("Effuse") and getBuffRemain(lowest.unit, player.spell.soothingMist, "player") == 0 and (lastSpellCasted == "" or lastSpellCatedOnPlayer ~= lowest.unit) then
                    if player.cast.effuse(lowest.unit) then
                        lastSpellCasted = "EF"
                        lastSpellCatedOnPlayer = lowest.unit
                        return
                    end
                end
            end

        end
        --------------------
        --- MULTI TARGET ---
        --------------------
        function multiTargetBurst()
            if getLowAllies(getOptionValue("Revival")) >= getOptionValue("Revival Targets") then
                if  player.cast.revival() then
                    lastSpellCasted = ""
                    lastSpellCatedOnPlayer = ""
                    return
                end
            end
            if getLowAllies(getOptionValue("Invoke Chi-Ji")) >= getOptionValue("Invoke Chi-Ji Targets") then
                if  player.cast.invokeChiJi(lowest.unit) then
                    lastSpellCasted = ""
                    lastSpellCatedOnPlayer = ""
                    return
                end

            end

        end

        function multiTarget()
            multiTargetBurst()
            if not isMoving("player") then
                if player.talent.chiBurst and getLowAllies(getOptionValue("Chi Burst")) >= getOptionValue("Chi Burst Targets") and player.cd.chiBurst == 0 then
                    if castSpell("player",player.spell.chiBurst,false,false,true,true,true,true,true,false) then
                        lastSpellCasted = ""
                        lastSpellCatedOnPlayer = ""
                        FaceDirection(GetAnglesBetweenObjects("Player", lowest.unit), true)
                        return
                    end
                end


                if getLowAllies(getOptionValue("Vivify")) >= 3 then
                    if isCastingSpell(player.spell.vivify) == false then
                        if player.cast.vivify(lowest.unit) then
                            lastSpellCasted = ""
                            lastSpellCatedOnPlayer = ""
                            return
                        end
                    end
                end
                if isChecked("Essence Font") then
                    if getLowAllies(getOptionValue("Essence Font")) >= getOptionValue("Essence Font Targets") then
                        if player.cast.essenceFont() then
                            lastSpellCasted = ""
                            lastSpellCatedOnPlayer = ""
                            return
                        end
                    end
                end
            end
        end
        --------------------
        --- MULTI TARGET ---
        --------------------
        function interrupt()
                for i = 1, #player.enemies.yards20 do
                    local thisUnit = player.enemies.yards20[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                        if distance < 5 then
                            -- Leg Sweep
                            if isChecked("Leg Sweep") then
                                if player.cast.legSweep(thisUnit) then
                                    lastSpellCasted = ""
                                    lastSpellCatedOnPlayer = ""
                                    return
                                end
                            end
                        end
                        -- Paralysis
                        if isChecked("Paralysis") then
                            if player.cast.paralysis(thisUnit) then
                                lastSpellCasted = ""
                                lastSpellCatedOnPlayer = ""
                                return
                            end
                        end
                end
            end -- End Interrupt Check

        end
        -------------------
        --- Fistweaving ---
        -------------------
        function fistweaving()
            if not isCastingSpell(player.spell.soothingMist) then
                    for i = 1, #player.enemies.yards5 do
                        local thisUnit = player.enemies.yards5[i]

                        if #player.enemies.yards5 >= 3 and player.cd.spinningCraneKick < player.gcd  and player.cast.spinningCraneKick() then
                            lastSpellCasted = ""
                            lastSpellCatedOnPlayer = ""
                            return
                        end
                        if player.cd.risingSunKick < player.gcd and player.cast.risingSunKick(thisUnit) then
                            lastSpellCasted = ""
                            lastSpellCatedOnPlayer = ""
                            return
                        end
                        if player.cd.blackoutKick < player.gcd and player.cast.blackoutKick(thisUnit) then
                            lastSpellCasted = ""
                            lastSpellCatedOnPlayer = ""
                            return
                        end
                        if player.cd.tigerPalm < player.gcd and player.cast.tigerPalm(thisUnit) then
                            lastSpellCasted = ""
                            lastSpellCatedOnPlayer = ""
                            return

                        end
                    end
                    for i = 1, #player.enemies.yards40 do
                        if player.cd.cracklingJadeLightning < player.gcd and player.cast.cracklingJadeLightning(player.enemies.yards40[i]) then
                            lastSpellCasted = ""
                            lastSpellCatedOnPlayer = ""
                            return
                        end
                end
            end
        end

        -------------
        --- EXTRA ---
        -------------
        function extra()
            if player.power.mana.percent <= getOptionValue("Arcane Torrent") then
                if castSpell("player",player.getRacial(),false,false,false) then
                    lastSpellCasted = ""
                    lastSpellCatedOnPlayer = ""
                    return
                end
            end

        end
        -----------------
        --- Rotations ---
        -----------------

        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------

        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        if player.inCombat then
            extra()
            if player.mode.dispell == 1 then
                castDetox()
            end
            multiTarget()
            singleTarget()
            if useInterrupts() then
                interrupt()
            end
            if player.mode.fistweaving == 1 then
                fistweaving()
            end




        end
        return
    end -- End Timer
end -- End runRotation

local id = 270

if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})