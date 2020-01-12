local rotationName = "Panglo2.0"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
	RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "DPS Enabled", tip = "Enables DPS rotation", highlight = 1, icon = br.player.spell.blackoutStrike },
        [2] = { mode = "Off", value = 2 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.vivify }
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.fortifyingBrew },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.fortifyingBrew },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.fortifyingBrew }
    };
    CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dampenHarm },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dampenHarm }
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spearHandStrike },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spearHandStrike }
    };
    CreateButton("Interrupt",4,0)
    BrewsModes = {
        [1] = { mode = "On", value = 1 , overlay = "Brews Enabled", tip = "Brews will be used.", highlight = 1, icon = br.player.spell.ironskinBrew },
        [2] = { mode = "Off", value = 2 , overlay = "Brews Disabled", tip = "No Brews will be used.", highlight = 0, icon = br.player.spell.legSweep }
    };
    CreateButton("Brews",5,0)
    TauntModes = {
        [1] = { mode = "Dungeon", value = 1 , overlay = "Taunt only in Dungeon", tip = "Taunt will be used in dungeons.", highlight = 0, icon = br.player.spell.provoke },
        [2] = { mode = "All", value = 2 , overlay = "Auto Taunt Enabled", tip = "Taunt will be used everywhere.", highlight = 1, icon = br.player.spell.provoke },
        [3] = { mode = "Dave", value = 3 , overlay = "Taunt the Statue", tip = "Taunt only be used on Dave", highlight = 1, icon = br.player.spell.blackOxStatue },
        [4] = { mode = "Off", value = 4 , overlay = "Auto Taunt Disabled", tip = "Taunt will not be used.", highlight = 0, icon = br.player.spell.legSweep }
    };
    CreateButton("Taunt",6,0)
    DetoxModes = {
        [1] = { mode = "On", value = 1 , overlay = "Detox Enabled", tip = "Detox will be used.", highlight = 1, icon = br.player.spell.detox },
        [2] = { mode = "Off", value = 2 , overlay = "Detox Disabled", tip = "Detox will not be used.", highlight = 0, icon = br.player.spell.ringOfPeace }
    };
    CreateButton("Detox",7,0)
    SuperBrewModes = {
        [1] = { mode = "On", value = 1 , overlay = "Avoid Brew Capping Enabled", tip = "Dont waste the brews brah", highlight = 1, icon = br.player.spell.purifyingBrew },
        [2] = { mode = "Off", value = 2 , overlay = "Allow Brew Capping", tip = "Pour one out for the homies", highlight = 0, icon = br.player.spell.resuscitate }
    };
    CreateButton("SuperBrew",0,1)

end

local function createOptions()
    local optionTable

    local function rotationOptions()
        ------------------------
        --- Blackout OPTIONS ---
        ------------------------
--        section = br.ui:createSection(br.ui.window.profile,  "BoC Priority")
        -- When Using BoC, Select Priority, or leave on Auto
--            br.ui:createDropdownWithout(section, "Select Priority", {"|cff1ED761Auto Mode","|cff20FF00Tiger Palm","|cffFFCC00Keg Smash","|cffFF0000Breath of Fire"},1, "Select the BoC Priority, Recommended Auto")
--        br.ui:checkSectionState(section)
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "|cff5AC18EGeneral")
		-- Let Rotation Deal with Purifying (SIMC)
			br.ui:createCheckbox(section, "High Stagger Debuff")
        -- Stagger dmg % to purify
            br.ui:createSpinner(section, "Stagger dmg % to purify",  100,  0,  300,  5,  "Stagger dmg % to purify")
        -- Refresh the brews
            br.ui:createSpinnerWithout(section, "Refresh ISB (Seconds)", 7, 1, 14, 0.5)
        -- Trinkets
            br.ui:createCheckbox(section, "Trinket 1")
            br.ui:createCheckbox(section, "Trinket 2")
        -- Racial
            br.ui:createCheckbox(section, "Racial")
        -- BoB usage
            br.ui:createCheckbox(section, "Black Ox Brew")
        -- Small Dave  
            br.ui:createCheckbox(section, "Summon Dave - The Statue")
            br.ui:createCheckbox(section, "Pig Catcher")
            br.ui:createDropdown(section, "Ring of Peace", br.dropOptions.Toggle, 6, "Hold this key to cast Ring of Peace at Mouseover")
		br.ui:checkSectionState(section)
        -------------------------
		---  COOLDOWN OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "|cff5AC18ECooldowns")
		--Invoke Niuzao
			br.ui:createCheckbox(section, "Invoke Niuzao")
        br.ui:checkSectionState(section)
        -------------------------
		---- ESSENCE OPTIONS ----
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "|cff5AC18EEssences")
            br.ui:createSpinner(section, "ConcentratedFlame - Heal", 50, 0, 100, 5, "", "health to heal at")
            br.ui:createCheckbox(section, "ConcentratedFlame - DPS")
            br.ui:createSpinner(section, "Anima of Death", 75, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
		--- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "|cff5AC18EDefensive")
        -- Healthstone
            br.ui:createSpinner(section, "Healthstone/Potion",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Healing Elixir
            br.ui:createSpinner(section, "Healing Elixir", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Fortifying Brew
            br.ui:createSpinner(section, "Fortifying Brew",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Dampen Harm
            br.ui:createSpinner(section, "Dampen Harm",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Detox
            br.ui:createCheckbox(section, "Detox Me")
        -- Detox
            br.ui:createCheckbox(section, "Detox Mouseover")
        -- Expel Harm
            br.ui:createSpinner(section, "Expel Harm",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
		-- Guard
			br.ui:createCheckbox(section, "Use Guard")
		-- Expel Harm Orbs
            br.ui:createSpinnerWithout(section, "Expel Harm Orbs",  3,  0,  15,  1,  "|cffFFFFFFMin amount of Gift of the Ox Orbs to cast.")
        -- Vivify
            br.ui:createSpinner(section, "Vivify",  50,  0,  100,  5,  "|cffFFFFFFCast Vivify")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "|cff5AC18EInterrupts")
        -- Spear Hand Strike
            br.ui:createCheckbox(section, "Spear Hand Strike")
        -- Paralysis
            br.ui:createCheckbox(section, "Incap Logic","Utilizes logic to incap priority targets")
        -- Leg Sweep
            br.ui:createCheckbox(section, "Leg Sweep")
        -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  0,  0,  100,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
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
    if br.timer:useTimer("debugBrewmaster", math.random(0.15,0.3)) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
		UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)
        UpdateToggle("Brews",0.25)
        UpdateToggle("Taunt",0.25)
        UpdateToggle("Detox",0.25)
        br.player.mode.brews = br.data.settings[br.selectedSpec].toggles["Brews"]
        br.player.mode.taunt = br.data.settings[br.selectedSpec].toggles["Taunt"]
        br.player.mode.detox = br.data.settings[br.selectedSpec].toggles["Detox"]
        br.player.mode.superbrew = br.data.settings[br.selectedSpec].toggles["SuperBrew"]

--------------
--- Locals ---
--------------
        local agility           = UnitStat("player", 2)
        local artifact          = br.player.artifact
        local baseAgility       = 0
        local baseMultistrike   = 0
        local buff              = br.player.buff
        local canFlask          = canUseItem(br.player.flask.wod.agilityBig)
        local cast              = br.player.cast
        local castable          = br.player.cast.debug
        local cd                = br.player.cd
        local charges           = br.player.charges
        local combatTime        = getCombatTime()
        local debuff            = br.player.debuff
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local enemies           = br.player.enemies
        local equiped           = br.player.equiped
        local flaskBuff         = getBuffRemain("player",br.player.flask.wod.buff.agilityBig) or 0
        local gcd               = br.player.gcd
        local hasPet            = IsPetActive()
        local glyph             = br.player.glyph
        local healthPot         = getHealthPot() or 0
        local healPot           = getHealthPot()
        local inCombat          = br.player.inCombat
        local inRaid            = select(2,IsInInstance())=="raid"
        local inInstance        = br.player.instance=="party"
        local lastSpell         = lastSpellCast
        local level             = br.player.level
        local mode              = br.player.mode
        local pet               = br.player.pet.list
        local php               = br.player.health
        local power             = br.player.power.energy.amount()
        local powgen            = br.player.power.energy.regen()
        local powerDeficit		= br.player.power.energy.deficit()
		local powerMax          = br.player.power.energy.max()
        local pullTimer         = br.DBM:getPulltimer()
        local queue             = br.player.queue
        local race              = br.player.race
        local racial            = br.player.getRacial()
        local regen             = br.player.power.energy.regen()
        local solo              = select(2,IsInInstance())=="none"
        local spell             = br.player.spell
        local talent            = br.player.talent
        local thp               = getHP("target")
        local trinketProc       = false --br.player.hasTrinketProc()
        local ttd               = getTTD
        local ttm               = br.player.power.energy.ttm()
        local units             = br.player.units
        local staggerPct        = (UnitStagger("player") / UnitHealthMax("player")*100)
        if leftCombat == nil then leftCombat = GetTime() end
        if profileStop == nil then profileStop = false end

        --Laks edits - for essence
        local lowest = br.friend[1]
        local essence = br.player.essence

        units.get(5)
        units.get(8)
        enemies.get(5)
        enemies.get(8)
        enemies.get(8,"target")
        enemies.get(20)
        enemies.get(30)

        local StunsBlackList = {
            -- Atal'Dazar
            [87318] = "Dazar'ai Colossus",
            [122984] = "Dazar'ai Colossus",
            [128455] = "T'lonja",
            [129553] = "Dinomancer Kish'o",
            [129552] = "Monzumi",
            -- Freehold
            [129602] = "Irontide Enforcer",
            [130400] = "Irontide Crusher",
            -- King's Rest
            [133935] = "Animated Guardian",
            [134174] = "Shadow-Borne Witch Doctor",
            [134158] = "Shadow-Borne Champion",
            [137474] = "King Timalji",
            [137478] = "Queen Wasi",
            [137486] = "Queen Patlaa",
            [137487] = "Skeletal Hunting Raptor",
            [134251] = "Seneschal M'bara",
            [134331] = "King Rahu'ai",
            [137484] = "King A'akul",
            [134739] = "Purification Construct",
            [137969] = "Interment Construct",
            [135231] = "Spectral Brute",
            [138489] = "Shadow of Zul",
            -- Shrine of the Storm
            [134144] = "Living Current",
            [136214] = "Windspeaker Heldis",
            [134150] = "Runecarver Sorn",
            [136249] = "Guardian Elemental",
            [134417] = "Deepsea Ritualist",
            [136353] = "Colossal Tentacle",
            [136295] = "Sunken Denizen",
            [136297] = "Forgotten Denizen",
            -- Siege of Boralus
            [129369] = "Irontide Raider",
            [129373] = "Dockhound Packmaster",
            [128969] = "Ashvane Commander",
            [138255] = "Ashvane Spotter",
            [138465] = "Ashvane Cannoneer",
            [135245] = "Bilge Rat Demolisher",
            -- Temple of Sethraliss
            [134991] = "Sandfury Stonefist",
            [139422] = "Scaled Krolusk Tamer",
            [136076] = "Agitated Nimbus",
            [134691] = "Static-charged Dervish",
            [139110] = "Spark Channeler",
            [136250] = "Hoodoo Hexer",
            [139946] = "Heart Guardian",
            -- MOTHERLODE!!
            [130485] = "Mechanized Peacekeeper",
            [136139] = "Mechanized Peacekeeper",
            [136643] = "Azerite Extractor",
            [134012] = "Taskmaster Askari",
            [133430] = "Venture Co. Mastermind",
            [133463] = "Venture Co. War Machine",
            [133436] = "Venture Co. Skyscorcher",
            [133482] = "Crawler Mine",
            -- Underrot
            [131436] = "Chosen Blood Matron",
            [133912] = "Bloodsworn Defiler",
            [138281] = "Faceless Corruptor",
            -- Tol Dagor
            [130025] = "Irontide Thug",
            -- Waycrest Manor
            [131677] = "Heartsbane Runeweaver",
            [135329] = "Matron Bryndle",
            [131812] = "Heartsbane Soulcharmer",
            [131670] = "Heartsbane Vinetwister",
            [135365] = "Matron Alma"
        }
        local para_unitList={
			[131009] = "Spirit of Gold",
			[134388] = "A Knot of Snakes",
            [129758] = "Irontide Grenadier",
            [133361] = "Wasting Servant",
        }

        if timersTable then
            wipe(timersTable)
        end

--------------------
--- Action Lists ---
--------------------

    local function key()
        if (SpecificToggle("Ring of Peace") and not GetCurrentKeyBoardFocus()) and isChecked("Ring of Peace") then
            if cast.able.ringOfPeace() then
                if CastSpellByName(GetSpellInfo(spell.ringOfPeace),"cursor") then return true end
            end
        end
    end
	-- Action List - Extras
	local function actionList_Extras()
		-- Taunt
        if (br.player.mode.taunt == 1 or (br.player.mode.taunt == 3 and not talent.blackOxStatue)) and inInstance then
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
					if cast.provoke(thisUnit) then return end
				end
			end
        end -- End Taunt
        if (br.player.mode.taunt == 2 or (br.player.mode.taunt == 3 and not talent.blackOxStatue)) then
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if UnitThreatSituation("player", thisUnit) ~= nil and UnitThreatSituation("player", thisUnit) <= 2 and UnitAffectingCombat(thisUnit) then
					if cast.provoke(thisUnit) then return end
				end
			end
        end -- End Taunt
        if isChecked("Summon Dave - The Statue") then
            if pet ~= nil then
                if cast.blackOxStatue("target") then return end
                    if br.player.mode.taunt == 3 then
                        for k, v in pairs(pet) do
                            local thisUnit = pet[k] or 0
                            if thisUnit.id == 61146 then
                                --print("found it")
                                if cast.provoke(thisUnit.unit) then return end
                            end
                        end
                    end
            end
        end
	end -- End Action List - Extras
	-- Action List - Defensive
    local function actionList_Defensive()
        if useDefensive() then
        -- Vivify
                if isChecked("Vivify") and (not inCombat and php <= getOptionValue("Vivify")) then
                    if cast.vivify() then return end
                end
        -- Guard
                if talent.guard and isChecked("Use Guard") and debuff.heavyStagger.exists("player") then
                    if cast.guard() then return end
                end
        --Expel Harm
                if isChecked("Expel Harm") and php <= getValue("Expel Harm") and inCombat and GetSpellCount(115072) >= getOptionValue("Expel Harm Orbs") then
                    if cast.expelHarm() then return end
                end
        -- Pot/Stoned
                if isChecked("Healthstone/Potion") and php <= getOptionValue("Healthstone/Potion") and inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                    if canUseItem(5512) then
                        useItem(5512)
                    elseif canUseItem(healPot) then
                        useItem(healPot)
                    elseif hasItem(166799) and canUseItem(166799) then
                        useItem(166799)
                    end
                end
            if isChecked("Anima of Death") and cd.animaOfDeath.remain() <= gcd and inCombat and (#enemies.yards8 >= 3 or isBoss()) and php <= getOptionValue("Anima of Death") then
                if cast.animaOfDeath("player") then return end
            end
        -- Dampen Harm
                if isChecked("Dampen Harm") and php <= getValue("Dampen Harm") and inCombat then
                    if cast.dampenHarm() then return end
                end
        -- Detox
                if isChecked("Detox Me") and br.player.mode.detox == 1 then
                    if canDispel("player",spell.detox) then
                       if cast.detox("player") then return end
                    end
                end
        -- Detox Mouseover
                if isChecked("Detox Mouseover") and br.player.mode.detox == 1 then
                    if UnitIsPlayer("mouseover") and not UnitIsDeadOrGhost("mouseover") then
                         if canDispel("mouseover",spell.detox) then
                            if cast.detox("mouseover") then return end
                        end
                    end
                end
        -- Healing Elixir
                if isChecked("Healing Elixir") and php <= getValue("Healing Elixir") and charges.healingElixir.count() > 1 then
                    if cast.healingElixir() then return end
                end
        -- Fortifying Brew
                if isChecked("Fortifying Brew") and php <= getValue("Fortifying Brew") and inCombat then
                    if cast.fortifyingBrew() then return end
                end
            end
		end
	-- Action List - Cooldowns
        local function actionList_Cooldowns()
            if useCDs() then
    			if isChecked("Invoke Niuzao") then
	    			if cast.invokeNiuzao() then return end
                end
            end

        -- Concentrated Flame Heal
            if getSpellCD(295373) <= gcd then
                if isChecked("ConcentratedFlame - Heal") and lowest.hp <= getValue("ConcentratedFlame - Heal") and getLineOfSight(lowest.unit) and getDistance(lowest.unit) <= 40 then
                    if cast.concentratedFlame(lowest.unit) then
                        return
                    end
                end
                if isChecked("ConcentratedFlame - DPS") and getTTD("target") > 3 and getLineOfSight("target") and getDistance("target") <= 40 then
                    if cast.concentratedFlame("target") then
                        return
                    end
                end
            end

            -- Trinkets
			if isChecked("Trinket 1") then
                    useItem(13)
            end
            if isChecked("Trinket 2") then
                    useItem(14)
            end
--[[             for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
                if hasEquiped(169311, 13) then
                    if not debuff.razorCoral.exists(thisUnit) or (equiped.dribblingInkpod() and (debuff.conductiveInk.exists("target") and (getHP("target") < 31)) or ttd("target") < 20) then
                        useItem(13)
                        return
                    end
                end
            end ]]
        end
	-- Action List - Interrupts
        local function actionList_Interrupts()
            if useInterrupts() then
                for i=1, #enemies.yards20 do
                    thisUnit = enemies.yards20[i]
                    distance = getDistance(thisUnit)
                    if canInterrupt(thisUnit,getOptionValue("InterruptAt")) then
                        if distance <= 5 then
        -- Spear Hand Strike
                            if isChecked("Spear Hand Strike") then
                                if cast.spearHandStrike(thisUnit) then return end
                            end
        -- Leg Sweep
                            if isChecked("Leg Sweep") and StunsBlackList[GetObjectID(thisUnit)] == nil and not isBoss(thisUnit) then
                                if cast.legSweep(thisUnit) then return end
                            end
                        end
                    end
                end
        -- Paralysis
                if isChecked("Incap Logic") then
                    local paraCase = nil
                    for i = 1, #br.friend do
                            if UnitIsCharmed(br.friend[i].unit) and getDebuffRemain(br.friend[i].unit,272407) == 0 and getDistance(br.friend[i].unit) <= 20 then
                                paraCase = br.friend[i].unit
                            end
                    end
                    if cast.able.paralysis() then
                        local para_list={
                        274400,274383,257756,276292,268273,256897,272542,272888,269266,258317,258864,259711,258917,264038,253239,269931,270084,270482,270506,270507,
                        267354,268702,268846,268865,258908,264574,272659,272655,267237,265568,277567,265540,268202,258058,257739,
                        }
                        for i = 1, #enemies.yards20 do
                            local thisUnit = enemies.yards20[i]
                            local distance = getDistance(thisUnit)
                            for k,v in pairs(para_list) do
                                if (para_unitList[GetObjectID(thisUnit)]~=nil or UnitCastingInfo(thisUnit) == GetSpellInfo(v) or UnitChannelInfo(thisUnit) == GetSpellInfo(v)) and getBuffRemain(thisUnit,226510) == 0 and distance <= 20 then
                                    if getDistance(thisUnit) <= 5 and cd.quakingPalm.remain() == 0 then 
                                        if cast.quakingPalm(thisUnit) then return end
                                    elseif cd.quakingPalm.remain() > 0 or getDistance(thisUnit) > 5 then
                                        if cast.paralysis(thisUnit) then return end
                                    end
                                end
                            end
                        end
                        if paraCase ~= nil then
                            if cast.paralysis(paraCase) then return end
                        end
                    end
                end
            end
        end -- End Action List - Interrupts
    -- Action List - Pre-Combat
        local function actionList_PreCombat()
               -- auto_attack
                if isValidUnit("target") and getDistance("target") < 5 then
                    StartAttack()
                end
            end --End Action List - Pre-Combat

---------------------
--- Rotations Code---
---------------------

	-- Single Target Rotation
    local function actionList_Single()
       -- Print("Single")
        -- Black Out Strike
            if cast.blackoutStrike() then return end
       -- Keg Smash
            if cast.kegSmash() then return end
		-- Breath of Fire
			if debuff.kegSmash.exists() then
				if cast.breathOfFire() then return end
			end
		-- High Energy TP
			if (power > 55) and (not talent.rushingJadeWind or buff.rushingJadeWind.exists()) and not (cd.blackoutStrike.remain() < gcd or cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
				if cast.tigerPalm() then return end
			end
		-- Rushing Jade Wind
			if not buff.rushingJadeWind.exists() or (buff.rushingJadeWind.remain() < 2 and not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd)) then
				if cast.rushingJadeWind() then return end
			end
		-- Chi Wave
			if not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
				if cast.chiWave() then return end
			end
		-- Chi Burst
			if not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
				if cast.chiBurst() then return end
			end
	end -- End Single Target

	-- Multi Target Rotation
    local function actionList_Multi()
       -- Print("Multi")
		-- Keg Smash
			if cast.kegSmash() then return end
		-- Breath of Fire
			if debuff.kegSmash.exists(units.dyn8) then
				if cast.breathOfFire() then return end
			end
		-- Rushing Jade Wind
			if not buff.rushingJadeWind.exists() or (buff.rushingJadeWind.remain() < 2 and not (cd.blackoutStrike.remain() < gcd or cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd)) then
				if cast.rushingJadeWind() then return end
			end
		-- Chi Burst
			if not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
				if cast.chiBurst() then return end
			end
		-- Black Out Strike
			if cast.blackoutStrike() then return end
		-- Chi Wave
			if not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
				if cast.chiWave() then return end
			end
		-- Tiger Palm
			if power > 55 and (not talent.rushingJadeWind or buff.rushingJadeWind.exists()) and not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
				if cast.tigerPalm() then return end
			end
	end

	-- Blackout Combo Rotation
    local function actionList_AutoBlackout()
        if buff.blackoutCombo.exists() then
            if cast.kegSmash() then return end
            if not cd.kegSmash.remain() < gcd then
                if cast.tigerPalm() then return end
            end
        else
            if cast.blackoutStrike() then return end
            if (not talent.rushingJadeWind or buff.rushingJadeWind.exists()) and not (cd.blackoutStrike.remain() < gcd or cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) and power > 45 then
                if cast.tigerPalm() then return end
            end
            if not cd.kegSmash.remain() < gcd and debuff.kegSmash.exists() then
                if cast.breathOfFire() then return end
            end
            if not buff.rushingJadeWind.exists() or (buff.rushingJadeWind.remain() < 2 and not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd)) then
				if cast.rushingJadeWind() then return end
            end
        end


        --Print("BoC")
		-- Keg Smash
--			if buff.blackoutCombo.exists() then
--				if cast.kegSmash() then return end
--			end
		-- Black out Strike
--			if cast.blackoutStrike() then return end
		-- Tiger Palm
--			if not cd.kegSmash.remain() < gcd and (power > 55) then
--				if cast.tigerPalm() then return end
--			end
		-- Breath of Fire
--			if not cd.kegSmash.remain() < gcd and debuff.kegSmash.exists() then
--				if cast.breathOfFire() then return end
--			end
		-- Rushing Jade Wind
--			if not buff.rushingJadeWind.exists() or (buff.rushingJadeWind.remain() < 2 and not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd)) then
--				if cast.rushingJadeWind() then return end
--			end
		-- Chi Wave
--			if not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
--				if cast.chiWave() then return end
--			end
		-- Chi Burst
--			if not (cd.kegSmash.remain() < gcd or cd.breathOfFire.remain() < gcd) then
--				if cast.chiBurst() then return end
--			end
	end

	-- Brews Rotations
	local function actionList_Brews()
        --Black Ox Brew
            if isChecked("Black Ox Brew") and talent.blackoxBrew then
                if (charges.purifyingBrew.frac() < 0.7) or
                    (charges.purifyingBrew.count() == 0 and (staggerPct >= getValue("Stagger dmg % to purify"))) then
                    if cast.blackoxBrew() then return end
                end
            end
        -- Auto Purify
			if isChecked("High Stagger Debuff") then
                if debuff.heavyStagger.exists("player") and buff.ironskinBrew.exists("player") and charges.purifyingBrew.frac() > 0.8 then
                    if cast.purifyingBrew() then return end
				end
            end
		-- Percentage Purify
			if isChecked("Stagger dmg % to purify") then
                if (staggerPct >= getValue("Stagger dmg % to purify") and charges.purifyingBrew.frac() > 0.5) and buff.ironskinBrew.exists("player") then
                    if cast.purifyingBrew() then return end
                end
            end
		-- Iron Skin Brew
            if not buff.blackoutCombo.exists() and (not buff.ironskinBrew.exists() or buff.ironskinBrew.remain() <= getValue("Refresh ISB (Seconds)")) then
                if cast.ironskinBrew() then return end
            end
        --Brew Capper
            if mode.superbrew == 1 then
                if charges.purifyingBrew.frac() == charges.purifyingBrew.max() and inCombat then
                    if buff.ironskinBrew.remain() <= 5 then
                        if cast.ironskinBrew() then return end
                    elseif debuff.heavyStagger.exists("player") then
                        if cast.purifyingBrew() then return end
                    elseif buff.ironskinBrew.remain() <= 14 then
                        if cast.ironskinBrew() then return end
                    elseif staggerPct > 0 then
                        if cast.purifyingBrew() then return end 
                    end
                end
            end
    	end

    if isCastingSpell(115176) or buff.zenMeditation.exists("player") then
        return true
    end

----------------------
--- Begin Rotation ---
----------------------
    -- Profile Stop | Pause
    if not inCombat and not hastar and profileStop==true then
        profileStop = false
    elseif (inCombat and profileStop==true) or pause() or buff.zenMeditation.exists() or (IsMounted() or IsFlying() or UnitOnTaxi("player") or UnitInVehicle("player")) and getBuffRemain("player", 192002 ) < 10 or mode.rotation==2 then
        return
    else
---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if key() then return end
			-- Extras
			if actionList_Extras() then return end
			-- Defensives
            if actionList_Defensive() then return end
            
            if actionList_Interrupts() then return end
			-- Precombat
            if actionList_PreCombat() then return end
            
            if isChecked("Pig Catcher") then
                bossHelper()
            end
-----------------------------
--- In Combat - Rotations ---
-----------------------------
  if inCombat and profileStop==false and not (IsMounted() or IsFlying()) and #enemies.yards8 >=1 then
    if getDistance(units.dyn5) < 5 then
        StartAttack()
    end
            -- Brews
			if br.player.mode.brews == 1 then
				if actionList_Brews() then return end
			end
			-- Cooldowns
			if actionList_Cooldowns() then return end

			-- Blackout Combo
			if talent.blackoutCombo then
				if actionList_AutoBlackout() then return end
			end
			-- Multi Target Rotations
			if #enemies.yards8 >= 3 and not talent.blackoutCombo then
				if actionList_Multi() then return end
			end
			-- Single target Rotations
            if #enemies.yards8 <3 and not talent.blackoutCombo then
                if actionList_Single() then return end
            end
		end -- end combat check
	  end -- Pause
   end -- End Timer
end -- End runRotation 

local id = 268
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
