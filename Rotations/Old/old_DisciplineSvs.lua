local rotationName = "Svs"

---------------
--- Toggles ---
---------------
local function createToggles()

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
            --Purify
            br.ui:createCheckbox(section, "Purify")
            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
            --Pain Suppression
            br.ui:createSpinner(section, "Pain Suppression",  30,  0,  100,  5,  "Health Percent to Cast At")
            --Power Word Shield
            br.ui:createSpinner(section, "Power Word Shield",  99,  0,  100,  1,  "Health Percent to Cast At")
            --Plea
            br.ui:createSpinner(section, "Plea",  90,  0,  100,  5,  "Health Percent to Cast At")
            --Shadow Mend
            br.ui:createSpinner(section, "Shadow Mend",  60,  0,  100,  5,  "Health Percent to Cast At")
        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
        	--Rapture
            br.ui:createSpinner(section, "Rapture",  80,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "Rapture Targets",  3,  0,  40,  1,  "Minimum Rapture Targets")
            --Power Word Radiance
            br.ui:createSpinner(section, "Power Word Radiance",  75,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "PWR Targets",  3,  0,  40,  1,  "Minimum PWR Targets")
            --Halo
            br.ui:createSpinner(section, "Halo",  80,  0,  100,  5,  "Health Percent to Cast At")
            br.ui:createSpinner(section, "Halo Targets",  3,  0,  40,  1,  "Minimum Halo Targets")
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
    if br.timer:useTimer("debugDiscipline", 0.1) then
        --Print("Running: "..rotationName)

---------------
--- Toggles --- -- List toggles here in order to update when pressed
---------------

--------------
--- Locals ---
--------------
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local healPot                                       = getHealthPot()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lowestHP                                      = br.friend[1].unit
        local mode                                          = br.player.mode
        local perk                                          = br.player.perk
        local php                                           = br.player.health
        local power, powmax, powgen                         = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local racial                                        = br.player.getRacial()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units

        local lowest                                        = {}    --Lowest Unit
        lowest.hp                                           = br.friend[1].hp
        lowest.role                                         = br.friend[1].role
        lowest.unit                                         = br.friend[1].unit
        lowest.range                                        = br.friend[1].range
        lowest.guid                                         = br.friend[1].guid
        local tank                                          = {}    --Tank
        local averageHealth                                 = 0

        units.get(40)

		for i = 1, #br.friend do
			if UnitIsDeadOrGhost(br.friend[i].unit) or getDistance(br.friend[i].unit) > 40 then
				br.friend[i].hp = 100
			end
			averageHealth = averageHealth + br.friend[i].hp
		end
		averageHealth = averageHealth/#br.friend

        -- Atonement Count
        atonementCount = 0
        for i=1, #br.friend do
            local atonementRemain = getBuffRemain(br.friend[i].unit,spell.buffs.atonement,"player") or 0 -- 194384
            if atonementRemain > 0 then
                atonementCount = atonementCount + 1
            end
        end

        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

--------------------
--- Action Lists ---
--------------------
        -- Action List - Pre-Combat
        function actionList_PreCombat()
            -- Power Word: Shield Body and Soul
            if isMoving("player") then -- talent.bodyandSoul and
                if cast.powerWordShield("player") then return end
            end
        end  -- End Action List - Pre-Combat
        --Spread Atonement
        function actionList_SpreadAtonement()

        end
        --AOE Healing
        function actionList_AOEHealing()
            --Rapture
            if isChecked("Rapture") then
                if getLowAllies(getValue("Rapture")) >= getValue("Rapture Targets") then
                    if cast.rapture() then return end
                end
            end
          	--Power Word Radiance
            if isChecked("Power Word Radiance") then
                if getLowAllies(getValue("Power Word Radiance")) >= getValue("PWR Targets") and lastSpell ~= spell.powerWordRadiance then
                    if cast.powerWordRadiance(lowest.unit) then return end
                end
            end
            --Halo
            if isChecked("Halo") then
                if getLowAllies(getValue("Halo")) >= getValue("Halo Targets") then
                    if cast.halo(lowest.unit) then return end
                end
            end
        end
        -- Single Target
        function actionList_SingleTarget()
            -- Trinkets
                if isChecked("Trinkets") then
                    if canUseItem(11) then
                        useItem(11)
                    end
                    if canUseItem(12) then
                        useItem(12)
                    end
                    if canUseItem(13) then
                        useItem(13)
                    end
                    if canUseItem(14) then
                        useItem(14)
                    end
                end
        	-- Pain Suppression
            if isChecked("Pain Suppression") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Pain Suppression") and getBuffRemain(br.friend[i].unit, spell.painSuppression, "player") < 1 then
                        if cast.painSuppression(br.friend[i].unit) then return end
                    end
                end
            end
            --Purify
            if isChecked("Purify") then
            for i = 1, #br.friend do
                for n = 1,40 do
                        local buff,_,count,bufftype,duration = UnitDebuff(br.friend[i].unit, n)
                        if buff then
                            if bufftype == "Curse" or bufftype == "Magic" then
                                if cast.purify(br.friend[i].unit) then return end
                            end
                        end
                    end
                end
            end
            --Power Word Shield
            if isChecked("Power Word Shield") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Power Word Shield")
                    and getBuffRemain(br.friend[i].unit, spell.powerWordShield, "player") < 1 then
                        if cast.powerWordShield(br.friend[i].unit) then return end
                    end
                end
            end
            --Shadow Mend
            if isChecked("Shadow Mend") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Shadow Mend") and lastSpell ~= spell.shadowMend then -- and atonementCount >= 5
                        if cast.shadowMend(br.friend[i].unit) then return end
                    end
                end
            end
            --Plea
            if isChecked("Plea") then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Plea") and getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") < 1 and lastSpell ~= spell.plea and atonementCount < 6 then
                    	--Print("Atonement Count: "..atonementCount)
                        if cast.plea(br.friend[i].unit) then return end
                    end
                end
            end
        end
        -- Damage
        function actionList_Damage()
            --LightsWrath
            if cast.lightsWrath() then return end
            --PowerWordSolace
            if cast.powerWordSolace() then return end
            --MindbBender/Shadowfiend
            if isChecked("Rapture") then
                if getLowAllies(getValue("Rapture")) >= getValue("Rapture Targets") then
                    if cast.shadowfiend() then return end
                end
            end
            --Purge The Wicked
            if getDebuffRemain(units.dyn40,204213,"player") <= 4 then
                if cast.purgeTheWicked(units.dyn40) then return end
            end
            --Shadow Word: Pain
            if getDebuffRemain(units.dyn40,spell.shadowWordPain,"player") <= 4 then
                if cast.shadowWordPain(units.dyn40) then return end
            end
            --Penance
            if cast.penance() then return end
            --Schism
            if power > 20 then
                if cast.schism() then return end
            end
            --Smite
            if power > 20 then
                if cast.smite() then return end
            end
        end
-----------------
--- Rotations ---
-----------------
        -- Pause
        if pause() or mode.rotation == 4 then
            return true
        else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and not IsMounted() then
            	actionList_PreCombat()
            end -- End Out of Combat Rotation
-----------------------------
--- In Combat - Rotations ---
-----------------------------
            if inCombat and not IsMounted() then
            	actionList_AOEHealing()
            	actionList_SingleTarget()
                actionList_SpreadAtonement()
                actionList_Damage()

            end -- End In Combat Rotation
        end -- Pause
    end -- End Timer
end -- End runRotation
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
