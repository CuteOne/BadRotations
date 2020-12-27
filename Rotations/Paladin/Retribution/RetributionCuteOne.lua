local rotationName = "CuteOne"
local StunsBlackList="167876|169861|168318|165824|165919|171799|168942|167612|169893"
local StunSpellList="332329|332671|326450|328177|336451|331718|331743|334708|333145|321807|334748|327130|327240|330532|328475|330423|294171|164737"
local HoJPrioList = "164702|164362|170488|165905|165251"
local br = _G["br"]
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.divineStorm },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.divineStorm },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.crusaderStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.flashOfLight }
    }
    CreateButton("Rotation",1,0)
    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.avengingWrath },
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.avengingWrath },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avengingWrath }
    };
    CreateButton("Cooldown",2,0)
    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.flashOfLight },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.flashOfLight }
    };
    CreateButton("Defensive",3,0)
    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.hammerOfJustice },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hammerOfJustice }
    };
    CreateButton("Interrupt",4,0)
    -- Aura
    AuraModes = {
        [1] = { mode = "Con", value = 1 , overlay = "Concentration Aura", tip = "Use Concentration Aura", highlight = 0, icon = br.player.spell.concentrationAura},
        [2] = { mode = "Dev", value = 2 , overlay = "Devotion Aura", tip = "Use Devotion Aura", highlight = 0, icon = br.player.spell.devotionAura},
        [3] = { mode = "Ret", value = 2 , overlay = "Retribution Aura", tip = "Use Retribution Aura", highlight = 0, icon = br.player.spell.retributionAura},
    };
    CreateButton("Aura",5,0)
end
---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        local alwaysCdNever = {"|cff00FF00Always","|cffFFFF00Cooldowns","|cffFF0000Never"}
        local playTarMouseFocLow = {"|cffFFFFFFPlayer", "|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFFocus", "|cffFFFFFFLowest"}
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            -- Blessing of Freedom
		    br.ui:createCheckbox(section, "Blessing of Freedom")
            -- Hand of Hindrance
            br.ui:createCheckbox(section, "Hand of Hindrance")
            -- Divine Storm Units
            br.ui:createSpinnerWithout(section, "Divine Storm Units",  2,  1,  5,  1,  "|cffFFBB00Units to use Divine Storm.")
            br.ui:checkSectionState(section)
			-- OOC FOL
		    br.ui:createSpinner(section, "OOC FoL", 50, 0, 100, 1, "", "|cffFFFFFFout of combat Flash of Light.")
		    br.ui:createDropdownWithout(section, "OOC FoL Target", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFFFFFFPlayer and Target"}, 3, "|ccfFFFFFFTarget to Cast On")
			-- infinite Divine Steed
		    br.ui:createDropdown(section, "infinite Divine Steed key", br.dropOptions.Toggle, 6)
		br.ui:checkSectionState(section)
            ------------------------
            --- COOLDOWN OPTIONS ---
            ------------------------
            section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Potion
            -- br.ui:createCheckbox(section,"Potion")
            -- FlaskUp Module
            br.player.module.FlaskUp("Strength",section)
            -- Racial
            br.ui:createCheckbox(section,"Racial")
            -- Trinkets
            br.player.module.BasicTrinkets(nil,section)
            -- Covenant Ability
            br.ui:createDropdownWithout(section, "Covenant Ability", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
            -- Avenging Wrath
            br.ui:createDropdownWithout(section, "Avenging Wrath", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
            -- Crusade
            br.ui:createDropdownWithout(section, "Crusade", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
            -- Execution Sentence
            br.ui:createDropdownWithout(section, "Execution Sentence", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
            -- Final Reckoning
            br.ui:createDropdownWithout(section, "Final Reckoning", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
            -- Holy Avenger
            br.ui:createDropdownWithout(section, "Holy Avenger", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
            -- Seraphim            
            br.ui:createDropdownWithout(section, "Seraphim", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
            -- Shield of Vengeance
            br.ui:createDropdownWithout(section, "Shield of Vengeance - CD", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
            -- Wake of Ashes
            br.ui:createDropdownWithout(section, "Wake of Ashes", alwaysCdNever, 2, "|cffFFFFFFSet mode to use.")
        br.ui:checkSectionState(section)
       
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
            --Blessing of Protection
		    br.ui:createSpinner(section, "Blessing of Protection", 30, 0, 100, 5, "","Health Percentage to use at")
		    br.ui:createDropdownWithout(section, "Blessing of Protection Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 7, "|cffFFFFFFTarget for Blessing of Protection")
            -- Blessing Of Sacrifice
		    br.ui:createSpinner(section, "Blessing Of Sacrifice", 40, 0, 100, 5, "","Health Percentage to use at")
		    br.ui:createDropdownWithout(section, "Blessing Of Sacrifice Target", {"|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 6, "|cffFFFFFFTarget for Blessing Of Sacrifice")
            -- Blinding Light
            br.ui:createSpinner(section, "Blinding Light", 40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            br.ui:createSpinnerWithout(section, "Blinding Light Units", 3, 1, 5, 1, "|cffFFFFFFUnits to Cast On")
            -- Cleanse Toxin
		    br.ui:createDropdown(section, "Clease Toxin", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFFFFFFPlayer and Target","|cffFF0000Mouseover Target","|cffFFFFFFAny"}, 3, "|ccfFFFFFFTarget to Cast On")
            -- Divine Shield
            br.ui:createSpinner(section, "Divine Shield",  35,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Eye for an Eye
            br.ui:createSpinner(section, "Eye for an Eye", 40, 0 , 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Flash of Light
            br.ui:createSpinner(section, "Flash of Light",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            br.ui:createDropdownWithout(section, "Flash of Light Target", playTarMouseFocLow, 5, "|cffFFFFFFTarget for Flash of Light")
            -- Hammer of Justice
            br.ui:createSpinner(section, "Hammer of Justice - HP",  40,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Justicar's Vengeance
            br.ui:createSpinner(section, "Justicar's Vengeance",  45,  0,  100,  5,  "|cffFFBB00Health Percentage to use at over Templar's Verdict.")
            -- Lay On Hands
            br.ui:createSpinner(section, "Lay On Hands", 20, 0, 100, 5, "","Health Percentage to use at")
            br.ui:createDropdownWithout(section, "Lay on Hands Target", playTarMouseFocLow, 5, "|cffFFFFFFTarget for Lay On Hands")
            -- Redemption
            br.ui:createDropdown(section, "Redemption", {"|cffFFFFFFTarget","|cffFFFFFFMouseover","|cffFFFFFFFocus"}, 1, "|cffFFFFFFTarget to Cast On")
            -- Shield of Vengeance
            br.ui:createSpinner(section,"Shield of Vengeance", 55, 0 , 100, 5, "|cffFFBB00Health Percentage to use at.")
            -- Turn Evil
            br.ui:createCheckbox(section, "Turn Evil")
            -- Word of Glory
            br.ui:createSpinner(section, "Word of Glory", 30, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
			-- Hand of the Protector - on others
		    br.ui:createSpinner(section, "Word of Glory - Party",  40,  0,  100,  5,  "|cffFFBB00Teammate Word of Glory to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Blinding Light 
            br.ui:createCheckbox(section, "Blinding Light - Int")
            -- Hammer of Justice
            br.ui:createCheckbox(section, "Hammer of Justice")
            -- Rebuke
            br.ui:createCheckbox(section, "Rebuke")
            -- Interrupt Percentage
            br.ui:createSpinnerWithout(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Wake of Ashes Key Toggle
            br.ui:createDropdownWithout(section, "Wake Mode", br.dropOptions.Toggle, 6)
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
		     ----------------------
		-------- LISTS -------
		----------------------
		    section = br.ui:createSection(br.ui.window.profile,  "Lists")
		    br.ui:createScrollingEditBoxWithout(section,"Stuns Black Units", StunsBlackList, "List of units to blacklist when Hammer of Justice", 240, 50)
		    br.ui:createScrollingEditBoxWithout(section,"Stun Spells", StunSpellList, "List of spells to stun with auto stun function", 240, 50)
		    br.ui:createScrollingEditBoxWithout(section,"HoJ Prio Units", HoJPrioList, "List of units to prioritize for Hammer of Justice", 240, 50)
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
-- BR API
local buff
local cast
local cd
local charges
local debuff
local enemies
local holyPower
local module
local race
local talent
local ui
local unit
local units
local var

------------------------
--- Custom Functions ---
------------------------


local getHealUnitOption = function(option,checkForbearance)
    local thisTar = ui.value(option)
    local thisUnit
    if thisTar == 1 then thisUnit = "player" end
    if thisTar == 2 then thisUnit = "target" end
    if thisTar == 3 then thisUnit = "mouseover" end
    if thisTar == 4 then thisUnit = "focus" end
    if thisTar == 5 then 
        thisUnit = var.lowestUnit
        -- Get the next lowest unit if lowest unit has Forbearance debuff
        if checkForbearance and #br.friend > 1 and debuff.forbearance.exists(thisUnit) then
            for i = 1, #br.friend do
                local nextUnit = br.friend[i].unit
                if not debuff.forbearance.exists(nextUnit) then
                    thisUnit = nextUnit
                    break
                end
            end
        end
    end
    return thisUnit
end

local findEvil = function()
    for i = 1, #enemies.yards20 do
        local thisUnit = enemies.yards20[i]
        if unit.undead() or unit.aberration() or unit.demon() then
            return thisUnit
        end
    end
end

--------------------
--- Action Lists ---
--------------------
local actionList = {}
-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") and unit.isDummy() then
        if unit.exists("target") then
            if unit.combatTime() >= (tonumber(ui.value("DPS Testing"))*60) then
                StopAttack()
                ClearTarget()
                Print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                var.profileStop = true
            end
        end
    end
    -- Blessing of Freedom
    if ui.checked("Blessing of Freedom") then
        local thisUnit = getHealUnitOption("Blessing of Freedom")
        if cast.able.blessingOfFreedom(thisUnit) and cast.noControl.blessingOfFreedom(thisUnit) and unit.distance(thisUnit) < 40 then
            if cast.blessingOfFreedom(thisUnit) then ui.debug("Casting Blessing of Freedom") return true end
        end
    end
	-- Blessing of Freedom
		if inInstance and cast.able.blessingOfFreedom() then
			if UnitCastingInfo("boss1") == GetSpellInfo(320788) then
				BoF = false
				if cast.blessingOfFreedom("boss1target") then return true end
			end
			if getDebuffRemain("player",330810) ~= 0 or getDebuffRemain("player",326827) ~= 0 or getDebuffRemain("player",324608) ~= 0 or getDebuffRemain("player",334926) ~= 0 then
				if cast.blessingOfFreedom("player") then return true end
			end
			if (UnitCastingInfo("boss1") == GetSpellInfo(317231) or UnitCastingInfo("boss1") == GetSpellInfo(320729)) and getDebuffRemain("player",331606) ~= 0 then
				if cast.blessingOfFreedom("player") then return true end
			end
		end
    -- Hand of Hindrance
    if ui.checked("Hand of Hindrance") and cast.able.handOfHindrance("target") and unit.moving("target")
        and not unit.facing("target","player") and unit.distance("target") > 8 and unit.hp("target") < 25
    then
        if cast.handOfHindrance("target") then ui.debug("Casting Hand of Hindrance on "..unit.name("target")) return true end
    end
end -- End Action List - Extras
-- Action List - Defensives
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
        -- Blessing of Protection
		if isChecked("Blessing of Protection") and cast.able.blessingOfProtection() and inCombat and not isBoss("boss1") then
			-- Player
			if getOptionValue("Blessing of Protection Target") == 1 then
				if php <= getValue("Blessing of Protection") and not debuff.forbearance.exists("player") then
					if cast.blessingOfProtection("player") then return true end
				end
				-- Target
			elseif getOptionValue("Blessing of Protection Target") == 2 then
				if getHP("target") <= getValue("Blessing of Protection") and not debuff.forbearance.exists("target") then
					if cast.blessingOfProtection("target") then return true end
				end
				-- Mouseover
			elseif getOptionValue("Blessing of Protection Target") == 3 then
				if getHP("mouseover") <= getValue("Blessing of Protection") and not debuff.forbearance.exists("mouseover") then
					if cast.blessingOfProtection("mouseover") then return true end
				end
			elseif getHP(lowestUnit) <= getValue("Blessing of Protection") and not debuff.forbearance.exists(lowestUnit) then
				-- Tank
				if getOptionValue("Blessing of Protection Target") == 4 then
					if UnitGroupRolesAssigned(lowestUnit) == "TANK" then
						if cast.blessingOfProtection(lowestUnit) then return true end
					end
					-- Healer
				elseif getOptionValue("Blessing of Protection Target") == 5 then
					if UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
						if cast.blessingOfProtection(lowestUnit) then return true end
					end
					-- Healer/Tank
				elseif getOptionValue("Blessing of Protection Target") == 6 then
					if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "TANK" then
						if cast.blessingOfProtection(lowestUnit) then return true end
					end
					-- Healer/Damager
				elseif getOptionValue("Blessing of Protection Target") == 7 then
					if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
						if cast.blessingOfProtection(lowestUnit) then return true end
					end
					-- Any
				elseif  getOptionValue("Blessing of Protection Target") == 8 then
					if cast.blessingOfProtection(lowestUnit) then return true end
				end
			end
		end
        -- Blessing Of Sacrifice
		if isChecked("Blessing Of Sacrifice") and cast.able.blessingOfSacrifice() and php >= 50 and inCombat then
			-- Target
			if getOptionValue("Blessing Of Sacrifice Target") == 1 then
				if getHP("target") <= getValue("Blessing Of Sacrifice") then
					if cast.blessingOfSacrifice("target") then return true end
				end
				-- Mouseover
			elseif getOptionValue("Blessing Of Sacrifice Target") == 2 then
				if getHP("mouseover") <= getValue("Blessing Of Sacrifice") then
					if cast.blessingOfSacrifice("mouseover") then return true end
				end
			elseif getHP(lowestUnit) <= getValue("Blessing Of Sacrifice") and not GetUnitIsUnit(lowestUnit,"player") and not cast.last.blessingOfProtection() then
				-- Tank
				if getOptionValue("Blessing Of Sacrifice Target") == 3 then
					if UnitGroupRolesAssigned(lowestUnit) == "TANK" then
						if cast.blessingOfSacrifice(lowestUnit) then return true end
					end
					-- Healer
				elseif getOptionValue("Blessing Of Sacrifice Target") == 4 then
					if UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
						if cast.blessingOfSacrifice(lowestUnit) then return true end
					end
					-- Healer/Tank
				elseif getOptionValue("Blessing Of Sacrifice Target") == 5 then
					if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "TANK" then
						if cast.blessingOfSacrifice(lowestUnit) then return true end
					end
					-- Healer/Damager
				elseif getOptionValue("Blessing Of Sacrifice Target") == 6 then
					if UnitGroupRolesAssigned(lowestUnit) == "HEALER" or UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
						if cast.blessingOfSacrifice(lowestUnit) then return true end
					end
					-- Any
				elseif  getOptionValue("Blessing Of Sacrifice Target") == 7 then
					if cast.blessingOfSacrifice(lowestUnit) then return true end
				end
			end
		end
        -- Blinding Light
        if ui.checked("Blinding Light") and unit.inCombat() and #enemies.yards10 >= ui.value("Blinding Light Units") and unit.hp() < ui.value("Blinding Light") then
            if cast.blindingLight() then ui.debug("Casting Blinding Light") return true end
        end
        -- Cleanse Toxins
		if isChecked("Clease Toxin") and cast.able.cleanseToxins() then
			if getOptionValue("Clease Toxin")==1 then
				if canDispel("player",spell.cleanseToxins) then
					if cast.cleanseToxins("player") then return true end
				end
			elseif getOptionValue("Clease Toxin")==2 then
				if canDispel("target",spell.cleanseToxins) then
					if cast.cleanseToxins("target") then return true end
				end
			elseif getOptionValue("Clease Toxin")==3 then
				if canDispel("player",spell.cleanseToxins) then
					if cast.cleanseToxins("player") then return true end
				elseif canDispel("target",spell.cleanseToxins) then
					if cast.cleanseToxins("target") then return true end
				end
			elseif getOptionValue("Clease Toxin")==4 then
				if canDispel("mouseover",spell.cleanseToxins) then
					if cast.cleanseToxins("mouseover") then return true end
				end
			elseif getOptionValue("Clease Toxin")==5 then
				for i = 1, #br.friend do
					if canDispel(br.friend[i].unit,spell.cleanseToxins) then
						if cast.cleanseToxins(br.friend[i].unit) then return true end
					end
				end
			end
		end
        -- Divine Shield
        if ui.checked("Divine Shield") and cast.able.divineShield() and unit.inCombat() then
            if unit.hp() <= ui.value("Divine Shield") and not debuff.forbearance.exists("player") then
                if cast.divineShield() then ui.debug("Casting Divine Shield") return true end
            end
        end
        -- Eye for an Eye
        if ui.checked("Eye for an Eye") and cast.able.eyeForAnEye() and unit.inCombat() then
            if unit.hp() <= ui.value("Eye for an Eye") and #enemies.yards5 > 0 then
                if cast.eyeForAnEye() then ui.debug("Casting Eye For An Eye") return true end
            end
        end
        -- Flash of Light
        if ui.checked("Flash of Light") and not (unit.mounted() or unit.flying()) then
            local thisUnit = getHealUnitOption("Flash of Light Target")
            if cast.able.flashOfLight(thisUnit) and unit.distance(thisUnit) < 40 then
                -- Instant Cast
                if talent.selflessHealer and buff.selflessHealer.stack() == 4 then
                    -- Don't waste instant heal!
                    thisUnit = unit.hp(thisUnit) <= ui.value("Flash of Light") and thisUnit or var.lowestUnit
                    if cast.flashOfLight(thisUnit) then ui.debug("Casting Flash of Light on "..unit.name(thisUnit).." [Instant]") return true end
                end
                -- Long Cast
                --if not unit.moving("player") and (var.forceHeal or (unit.inCombat() and unit.hp(thisUnit) <= ui.value("Flash of Light")) or (not unit.inCombat() and unit.hp(thisUnit) <= 90)) then
                --    if cast.flashOfLight(thisUnit) then ui.debug("Casting Flash of Light on "..unit.name(thisUnit).." [Long]") return true end
                --end
            end
        end
        -- Hammer of Justice
        if ui.checked("Hammer of Justice - HP") and cast.able.hammerOfJustice() and unit.inCombat() then
            if unit.hp() <= ui.value("Hammer of Justice - HP") then
                if cast.hammerOfJustice() then ui.debug("Casting Hammer of Justice [Defensive]") return true end
            end
        end
        -- Justicar's Vengeance
        if ui.checked("Justicar's Vengeance") and cast.able.justicarsVengeance() and unit.inCombat() and holyPower >= 5 then
            if unit.hp() <= ui.value("Justicar's Vengeance") then
                if cast.justicarsVengeance() then ui.debug("Casting Justicar's Vengeance") return true end
            end
        end
        -- Lay On Hands
        if ui.checked("Lay On Hands") then
            local thisUnit = getHealUnitOption("Lay On Hands Target",true)
            if cast.able.layOnHands(thisUnit) and unit.inCombat(thisUnit) and not debuff.forbearance.exists(thisUnit)
                and unit.hp(thisUnit) <= ui.value("Lay On Hands") and unit.distance(thisUnit) < 40
            then
                if cast.layOnHands(thisUnit) then
                    ui.debug("Casting Lay On Hands on "..unit.name(thisUnit).." ["..unit.hp(thisUnit).."% Remaining]")
                    return true
                end
            end
        end
        -- Redemption
        if ui.checked("Redemption") and not unit.moving("player") and var.resable then
            local redemptionTar = ui.value("Redemption")
            local redemptionUnit
            if redemptionTar == 1 then redemptionUnit = "target" end
            if redemptionTar == 2 then redemptionUnit = "mouseover" end
            if redemptionTar == 3 then redemptionUnit = "focus" end
            if cast.able.redemption(redemptionUnit,"dead") then
                if cast.redemption(redemptionUnit,"dead") then ui.debug("Casting Redemption on "..unit.name(redemptionUnit)) return true end
            end
        end
		-- ooc fol
		if isChecked("OOC FoL") and cast.able.flashOfLight() and not inCombat and not isMoving("player") then
				-- Player
			if getOptionValue("OOC FoL Target") == 1 then
				if php <= getValue("OOC FoL") then
					if cast.flashOfLight("player") then return true end
				end
				-- Target
			elseif getOptionValue("OOC FoL Target") == 2 then
				if getHP("target") <= getValue("OOC FoL") then
					if cast.flashOfLight("target") then return true end
				end
				-- Player and Target
			elseif getOptionValue("OOC FoL Target") == 3 then
				if php <= getValue("OOC FoL") then
					if cast.flashOfLight("player") then return true end
				elseif getHP("target") <= getValue("OOC FoL") then
					if cast.flashOfLight("target") then return true end
				end
			end
		end
        -- Shield of Vengeance
        if ui.checked("Shield of Vengeance") and cast.able.shieldOfVengeance() and unit.inCombat() then
            if unit.hp() <= ui.value("Shield of Vengeance") and unit.ttdGroup(8) > 15 then
                if cast.shieldOfVengeance() then ui.debug("Casting Shield of Vengeance") return true end
            end
        end
        -- Turn Evil
        if ui.checked("Turn Evil") and unit.inCombat() then
            local thisUnit = findEvil()
            if cast.able.turnEvil(thisUnit) and unit.hp() < ui.value("Turn Evil") and not debuff.turnEvil.exists(var.turnedEvil) then
                if cast.turnEvil(thisUnit) then ui.debug("Casting Turn Evil") var.turnedEvil = thisUnit return true end
            end
        end
        -- Word of Glory
		if holyPower >= 3 then
			if isChecked("Word of Glory") and unit.hp()<= ui.value("Word of Glory") and unit.inCombat() then
				SotR = false
				if cast.wordOfGlory("player") then return true end
			elseif isChecked("Word of Glory - Party") and unit.hp()<= ui.value("Word of Glory - Party") and unit.inCombat() then
				SotR = false
				if cast.wordOfGlory(lowestUnit) then return true end
			end
		end
    end
end -- End Action List - Defensive
-- Action List - Interrupts
actionList.Interrupts = function()
    if ui.useInterrupt() then
        for i = 1, #enemies.yards20 do
            local thisUnit = enemies.yards20[i]
            local distance = unit.distance(thisUnit)
            if unit.interruptable(thisUnit,ui.value("Interrupt At")) then
                -- Blinding Light
                if ui.checked("Blinding Light - Int") and cast.able.blindingLight(thisUnit) and distance < 10
                    and ((cd.rebuke.remains() > unit.gcd() or distance >= 5) and cd.hammerOfJustice.remains() > unit.gcd())
                then
                    if cast.blindingLight() then ui.debug("Casting Blinding Light [Interrupt]") return true end
                end
                -- Hammer of Justice
                if ui.checked("Hammer of Justice") and cast.able.hammerOfJustice(thisUnit) and distance < 10 and (cd.rebuke.remains() > unit.gcd() or distance >= 5) then
                    if cast.hammerOfJustice(thisUnit) then ui.debug("Casting Hammer of Justice [Interrupt]") return true end
                end
                -- Rebuke
                if ui.checked("Rebuke") and cast.able.rebuke(thisUnit) and distance < 5 then
                    if cast.rebuke(thisUnit) then ui.debug("Casting Rebuke") return true end
                end
            end
        end
    end
end -- End Action List - Interrupts
-- Action List - Cooldowns
actionList.Cooldowns = function()
    -- -- Potion
    -- -- potion,if=(cooldown.guardian_of_azeroth.remains>90|!essence.condensed_lifeforce.major)&(buff.bloodlust.react|buff.avenging_wrath.up&buff.avenging_wrath.remains>18|buff.crusade.up&buff.crusade.remains<25)
    -- if ui.checked("Potion") and use.able.potionOfFocusedResolve() and unit.instance("raid") then
    --     if (cd.guardianOfAzeroth.remain() > 90 or not essence.condensedLifeForce.active)
    --         and (hasBloodlust() or (buff.avengingWrath.exists() and buff.avengingWrath.remain() > 18)
    --             or (buff.crusade.exists() and buff.crusade.remain() < 25))
    --     then
    --         use.potionOfFocusedResolve()
    --         ui.debug("Used Potion of Focused Resolve")
    --     end
    -- end
    -- Racial
    if ui.checked("Racial") and cast.able.racial() then
        -- lights_judgment,if=spell_targets.lights_judgment>=2|(!raid_event.adds.exists|raid_event.adds.in>75)
        if ui.useCDs() and race == "LightforgedDraenei" and unit.health("target") < unit.healthMax("target")
            and unit.ttd("target") > cast.time.racial()
        then
            if cast.racial("target") then ui.debug("Casting Racial: Lightforged Draenei") return true end
        end
        -- fireblood,if=buff.avenging_wrath.up|buff.crusade.up&buff.crusade.stack=10
        if race == "DarkIronDwarf" and (unit.level() < 37 or buff.avengingWrath.exists() or (buff.crusade.exists() and buff.crusade.stack() == 10)
            or ((not ui.alwaysCdNever("Avenging Wrath") and not talent.crusade) or (talent.crusade and not ui.alwaysCdNever("Crusade"))))
        then
            if cast.racial() then ui.debug("Casting Racial: Dark Iron Dwarf") return true end
        end
    end
    -- Shield of Vengenace
    -- shield_of_vengeance
    if ui.alwaysCdNever("Shield of Vengeance - CD") and cast.able.shieldOfVengeance() and unit.ttdGroup(8) > 15 then
        if cast.shieldOfVengeance() then ui.debug("Casting Shield of Vengeance [CD]") return true end
    end
    -- Blessing of the Seasons
    -- blessing_of_the_seasons
    if ui.alwaysCdNever("Covenant Ability") and cast.able.blessingOfTheSeasons() then
        if cast.blessingOfTheSeasons() then ui.debug("Casting Blessing of the Seasons [Night Fae]") return true end
    end
    -- Trinkets
    module.BasicTrinkets()      
    -- Avenging Wrath
    -- avenging_wrath,if=(holy_power>=4&time<5|holy_power>=3&time>5|talent.holy_avenger.enabled&cooldown.holy_avenger.remains=0)&time_to_hpg=0
    if ui.alwaysCdNever("Avenging Wrath") and not talent.crusade and cast.able.avengingWrath()
        and (holyPower >= 4 and unit.combatTime() < 5 or holyPower >= 3 and unit.combatTime() > 5 or talent.holyAvenger and not cd.holyAvenger.exists())
        and var.timeToHPG == 0
    then
        if cast.avengingWrath() then ui.debug("Casting Avenging Wrath") return true end
    end
    -- Crusade
    -- crusade,if=(holy_power>=4&time<5|holy_power>=3&time>5|talent.holy_avenger.enabled&cooldown.holy_avenger.remains=0)&time_to_hpg=0
    if ui.alwaysCdNever("Crusade") and talent.crusade and cast.able.crusade()
        and (holyPower >= 4 and unit.combatTime() < 5 or holyPower >= 3 and unit.combatTime() > 5 or talent.holyAvenger and not cd.holyAvenger.exists())
        and var.timeToHPG == 0
    then
        if cast.crusade() then ui.debug("Casting Crusade") return true end
    end
    -- Ashen Hallow
    -- ashen_hallow
    if ui.alwaysCdNever("Covenant Ability") and cast.able.ashenHallow() then
        if cast.ashenHallow() then ui.debug("Casting Ashen Hallow [Venthyr]") return true end
    end
    -- Holy Avenger
    -- holy_avenger,if=time_to_hpg=0&((buff.avenging_wrath.up|buff.crusade.up)|(buff.avenging_wrath.down&cooldown.avenging_wrath.remains>40|buff.crusade.down&cooldown.crusade.remains>40))
    if ui.alwaysCdNever("Holy Avenger") and var.timeToHPG == 0
        and ((buff.avengingWrath.exists() or buff.crusade.exists())
            or (not buff.avengingWrath.exists() and (cd.avengingWrath.remains() > 40 or not ui.alwaysCdNever("Avenging Wrath"))
                or not buff.crusade.exists() and (buff.crusade.remains() > 40 or not ui.alwaysCdNever("Crusade"))))
    then
        if cast.holyAvenger() then ui.debug("Casting Holy Avenger") return true end
    end
    -- Final Reckoning
    -- final_reckoning,if=holy_power>=3&cooldown.avenging_wrath.remains>gcd&time_to_hpg=0&(!talent.seraphim.enabled|buff.seraphim.up)
    if ui.alwaysCdNever("Final Reckoning") and holyPower >= 3 and (cd.avengingWrath.remains() > unit.gcd(true) or not ui.alwaysCdNever("Avenging Wrath"))
        and var.timeToHPG == 0 and (not talent.seraphim or buff.seraphim.exists() or not ui.alwaysCdNever("Seraphim"))
    then
        if cast.finalReckoning() then ui.debug("Casting Final Reckoning") return true end
    end
end -- End Action List - Cooldowns
-- Action List - Finisher
actionList.Finisher = function()
    -- Seraphim
    -- seraphim,if=((!talent.crusade.enabled&buff.avenging_wrath.up|cooldown.avenging_wrath.remains>25)|(buff.crusade.up|cooldown.crusade.remains>25))&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains<10)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains<10)&time_to_hpg=0
    if ui.alwaysCdNever("Seraphim") and cast.able.seraphim()
        and ((not talent.crusade and (buff.avengingWrath.exists() or cd.avengingWrath.remains() > 25 or not ui.alwaysCdNever("Avenging Wrath")))
            or (buff.crusade.exists() and (cd.crusade.remains() > 25 or not ui.alwaysCdNever("Crusade"))))
        and (not talent.finalReckoning or cd.finalReckoning.remains() < 10)
        and (not talent.executionSentence or cd.executionSentence.remains() < 10)
        and var.timeToHPG == 0
    then
        if cast.seraphim() then ui.debug("Casting Seraphim") return true end
    end
    -- Vanquisher's Hammer
    -- vanquishers_hammer,if=(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*10|debuff.final_reckoning.up)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*10|debuff.execution_sentence.up)|spell_targets.divine_storm>=2
    if ui.alwaysCdNever("Covenant Ability") and cast.able.vanquishersHammer() and (not talent.finalReckoning or cd.finalReckoning.remains() > unit.gcd(true) * 10 or debuff.finalReckoning.exists(units.dyn5))
        and (not talent.executionSentence or cd.executionSentence.remains() > unit.gcd(true) * 10 or debuff.executionSentence.exists(units.dyn5) or not ui.alwaysCdNever("Execution Sentence")) or var.dsUnits
    then
        if cast.vanquishersHammer() then ui.debug("Casting Vanquisher's Hammer [Necrolord]") return true end
    end
    -- Execution Sentence
    -- execution_sentence,if=spell_targets.divine_storm<=3&((!talent.crusade.enabled|buff.crusade.down&cooldown.crusade.remains>10)|buff.crusade.stack>=3|cooldown.avenging_wrath.remains>10|debuff.final_reckoning.up)&time_to_hpg=0
    if ui.alwaysCdNever("Execution Sentence") and cast.able.executionSentence()
        and (not var.dsUnits or unit.level() < 23) and ((not talent.crusade or not buff.crusade.exists() and (cd.crusade.remain() > 10 or not ui.alwaysCdNever("Crusade"))
            or buff.crusade.stack() >= 3) or (cd.avengingWrath.remain() > 10 or not ui.alwaysCdNever("Avenging Wrath")) or debuff.finalReckoning.exists(units.dyn5))
        and var.timeToHPG == 0
    then
        if cast.executionSentence() then ui.debug("Casting Execution Sentence") return true end
    end
    -- Divine Storm
    -- divine_storm,if=variable.ds_castable&!buff.vanquishers_hammer.up&((!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*3|spell_targets.divine_storm>=3)|spell_targets.divine_storm>=2&(talent.holy_avenger.enabled&cooldown.holy_avenger.remains<gcd*3|buff.crusade.up&buff.crusade.stack<10))
    if cast.able.divineStorm() and var.dsCastable --and not buff.vanquishersHammer.exists()
        and ((not talent.crusade or cd.crusade.remains() > unit.gcd(true) * 3 or not ui.alwaysCdNever("Crusade"))
        and (not talent.executionSentence or (cd.executionSentence.remains() > unit.gcd(true) * 3 or not ui.alwaysCdNever("Execution Sentence")) or var.dsUnits)
            or (var.dsUnits and (talent.holyAvenger and cd.holyAvenger.remains() < unit.gcd(true) * 3 or buff.crusade.exists() and buff.crusade.stack() < 10)))
    then
        local theseUnits = (ui.mode.rotation == 2 or buff.empyreanPower.exists()) and 1 or ui.value("Divine Storm Units")
        if cast.divineStorm(nil,"aoe",theseUnits,8) then ui.debug("Casting Divine Storm") return true end
    end
    -- Templar's Verdict
    -- templars_verdict,if=(!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*3&spell_targets.divine_storm<=3)&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*3)&(!covenant.necrolord.enabled|cooldown.vanquishers_hammer.remains>gcd)|talent.holy_avenger.enabled&cooldown.holy_avenger.remains<gcd*3|buff.holy_avenger.up|buff.crusade.up&buff.crusade.stack<10|buff.vanquishers_hammer.up
    if cast.able.templarsVerdict() then
        if ((not talent.crusade or cd.crusade.remains() > unit.gcd(true) * 3 or not ui.alwaysCdNever("Crusade"))
            and (not talent.executionSentence or (cd.executionSentence.remains() > unit.gcd(true) * 3 or not ui.alwaysCdNever("Execution Sentence")) and not var.dsUnits)
            and (not talent.finalReckoning or cd.finalReckoning.remains() > unit.gcd(true) * 3 or not ui.alwaysCdNever("Final Reckoning"))
                or talent.holyAvenger and cd.holyAvenger.remains() < unit.gcd(true) * 3 or buff.holyAvenger.exists()
                and buff.crusade.stack() < 10)
        then
            if cast.templarsVerdict() then ui.debug("Casting Templar's Verdict") return true end
        end
    end
end -- End Action List - Finisher
-- Action List - Generator
actionList.Generator = function()
    -- Call Action List - Finishers
    -- call_action_list,name=finishers,if=holy_power>=5|buff.holy_avenger.up|debuff.final_reckoning.up|debuff.execution_sentence.up|buff.memory_of_lucid_dreams.up|buff.seething_rage.up
    if holyPower >= 5 or buff.holyAvenger.exists() or debuff.finalReckoning.exists(units.dyn5) or debuff.executionSentence.exists(units.dyn5) or buff.memoryOfLucidDreams.exists() then
        if actionList.Finisher() then return true end
    end
    -- Divine Toll
    -- divine_toll,if=!debuff.judgment.up&(!raid_event.adds.exists|raid_event.adds.in>30)&(holy_power<=2|holy_power<=4&(cooldown.blade_of_justice.remains>gcd*2|debuff.execution_sentence.up|debuff.final_reckoning.up))&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*10)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*10)
    if ui.alwaysCdNever("Covenant Ability") and cast.able.divineToll() and not debuff.judgment.exists(units.dyn5) and not var.dsUnits and (holyPower <= 2 or holyPower <= 4
        and (cd.bladeOfJustice.remains() > unit.gcd(true) * 2 or debuff.executionSentence.exists(units.dyn5) or debuff.finalReckoning.exists(units.dyn5)))
        and (not talent.finalReckoning or cd.finalReckoning.remains() > unit.gcd(true) * 10) and (not talent.executionSentence or cd.executionSentence.remains() > unit.gcd(true) * 10)
    then
        if cast.divineToll() then ui.debug("Casting Divine Toll [Kyrian]") return true end
    end
    -- Wake of Ashes
    -- wake_of_ashes,if=(holy_power=0|holy_power<=2&(cooldown.blade_of_justice.remains>gcd*2|debuff.execution_sentence.up|debuff.final_reckoning.up))&(!raid_event.adds.exists|raid_event.adds.in>20)&(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>15)&(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>15)
    if ui.alwaysCdNever("Wake of Ashes") and cast.able.wakeOfAshes()
        and (holyPower <= 0 or holyPower <= 2 and (cd.bladeOfJustice.remain() > unit.gcd(true) or debuff.executionSentence.exists(units.dyn5) or debuff.finalReckoning.exists(units.dyn5)))
        and ui.useST() and (not talent.executionSentence or cd.executionSentence.remains() > 15 or not ui.alwaysCdNever("Execution Sentence"))
        and (not talent.finalReckoning or cd.finalReckoning.remains() > 15 or not ui.alwaysCdNever("Final Reckoning"))
    then
        if cast.wakeOfAshes(units.dyn12,"cone",1,12) then ui.debug("Casting Wake of Ashes") return true end
    end
    -- Blade of Justice
    -- blade_of_justice,if=holy_power<=3
    if cast.able.bladeOfJustice() and holyPower <= 3 then
        if cast.bladeOfJustice() then ui.debug("Casting Blade of Justice") return true end
    end
    -- Hammer of Wrath
    -- hammer_of_wrath,if=holy_power<=4
    if cast.able.hammerOfWrath() and holyPower <= 4 then
        if buff.avengingWrath.exists() or buff.crusade.exists() then
            if cast.hammerOfWrath() then ui.debug("Casting Hammer of Wrath [Avenging Wrath]") return true end
        end
        for i = 1, #enemies.yards30f do
            local thisUnit = enemies.yards30f[i]
            if unit.hp(thisUnit) < 20 then
                if cast.hammerOfWrath(thisUnit) then ui.debug("Casting Hammer of Wrath [Less Than 20 HP]") return true end
            end
        end
    end
    -- Judgment
    -- judgment,if=!debuff.judgment.up&(holy_power<=2|holy_power<=4&cooldown.blade_of_justice.remains>gcd*2)
    if cast.able.judgment() and not debuff.judgment.exists(unit.dyn5) and (holyPower <= 2 or holyPower <= 4 and cd.bladeOfJustice.remain() > unit.gcd(true)* 2) then
        if cast.judgment() then ui.debug("Casting Judgment") return true end
    end
    -- Call Action List: Finishers
    -- call_action_list,name=finishers,if=(target.health.pct<=20|buff.avenging_wrath.up|buff.crusade.up|buff.empyrean_power.up)
    if (unit.hp(units.dyn5) <= 20 or buff.avengingWrath.exists() or buff.crusade.exists() or buff.empyreanPower.exists() or buff.divinePurpose.exists()) then
        if actionList.Finisher() then return end
    end
    -- Crusader Strike
    -- crusader_strike,if=cooldown.crusader_strike.charges_fractional>=1.75&(holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2)
    if cast.able.crusaderStrike() and charges.crusaderStrike.frac() >= 1.75
        and (holyPower <= 2 or holyPower <= 3 and cd.bladeOfJustice.remain() > unit.gcd(true)* 2
            or holyPower == 4 and cd.bladeOfJustice.remain() > unit.gcd(true)* 2 and cd.judgment.remain() > unit.gcd(true)* 2)
    then
        if cast.crusaderStrike() then ui.debug("Casting Crusader Strike [Cap Prevention]") return true end
    end
    -- Call Action List: Finishers
    -- call_action_list,name=finishers
    if actionList.Finisher() then return end
    -- -- Essence: Concentrated Flame
    -- if ui.checked("Use Essence") and cast.able.concentratedFlame() then
    --     if cast.concentratedFlame() then ui.debug("Casting Heart Essence: Concentrated Flame") return true end
    -- end
    -- Crusader Strike
    -- crusader_strike,if=holy_power<=4
    if cast.able.crusaderStrike() and holyPower <= 4 then
        if cast.crusaderStrike() then ui.debug("Casting Crusader Strike") return true end
    end
    -- Arcane Torrent
    -- arcane_torrent,if=holy_power<=4
    if ui.checked("Racial") and cast.able.racial() and race == "BloodElf" and holyPower <= 4 then
        if cast.racial() then ui.debug("Casting Racial: Blood Elf") return true end
    end
    -- Consecration
    -- consecration,if=time_to_hpg>gcd
    if cast.able.consecration() then
        if cast.consecration("player","aoe",1,8) then ui.debug("Casting Consecration") return true end
    end
end -- End Action List - Generator
-- Action List - PreCombat
actionList.PreCombat = function()
    if not unit.inCombat() and not (unit.flying() or unit.mounted()) then
        -- Flask
        -- flask,type=flask_of_the_countless_armies
        module.FlaskUp("Strength")
        -- Food
        -- food,type=azshari_salad
        -- Augmenation
        -- augmentation,type=defiled
        -- Potion
        -- potion,name=old_war
        -- if ui.checked("Potion") and canUseItem(127844) and unit.instance("raid") then
        --     useItem(127844)
        -- end
        if unit.valid("target") then--and opener.complete then
            -- Judgment
            if cast.able.judgment("target") and unit.distance("target") < 30 then
                if cast.judgment("target") then ui.debug("Casting Judgment [Pre-Pull]") return true end
            end
            -- Blade of Justice
            if cast.able.bladeOfJustice("target") and unit.distance("target") < 12 then
                if cast.bladeOfJustice("target") then ui.debug("Casting Blade of Justice [Pre-Pull]") return true end
            end
            -- Crusader Strike
            if cast.able.crusaderStrike("target") and unit.distance("target") < 5 then
                if cast.crusaderStrike("target") then ui.debug("Casting Crusader Strike [Pre-Pull]") return true end
            end
            -- Start Attack
            if unit.distance("target") < 5 then unit.startAttack("target") end
        end
    end
    -- Opener
    -- if actionList.Opener() then return true end
end -- End Action List - PreCombat

----------------
--- ROTATION ---
----------------
local runRotation = function()
    -----------------
    --- Variables ---
    -----------------
    -- BR API
    buff          = br.player.buff
    cast          = br.player.cast
    cd            = br.player.cd
    charges       = br.player.charges
    debuff        = br.player.debuff
    enemies       = br.player.enemies
    holyPower     = br.player.power.holyPower.amount()
    module        = br.player.module
    race          = br.player.race
    talent        = br.player.talent
    ui            = br.player.ui
    unit          = br.player.unit
    units         = br.player.units
    var           = br.player.variables
	holyPower     = br.player.power.holyPower.amount()
	holyPowerMax  = br.player.power.holyPower.max()
	artifact      = br.player.artifact
	buff          = br.player.buff
	cast          = br.player.cast
	cd            = br.player.cd
	charges       = br.player.charges
	combatTime    = getCombatTime()
	debuff        = br.player.debuff
	enemies       = br.player.enemies
	gcd           = br.player.gcd
	gcdMax        = br.player.gcdMax
	hastar        = GetObjectExists("target")
	healPot       = getHealthPot()
	inCombat      = br.player.inCombat
	level         = br.player.level
	inInstance    = br.player.instance=="party"
	inRaid        = br.player.instance=="raid"
	lowest        = br.friend[1]
	mode          = br.player.ui.mode
	php           = br.player.health
	race          = br.player.race
	racial        = br.player.getRacial()
	resable       = UnitIsPlayer("target") and UnitIsDeadOrGhost("target") and GetUnitIsFriend("target","player")
	solo          = GetNumGroupMembers() == 0
	spell         = br.player.spell
	talent        = br.player.talent
	ttd           = getTTD("target")
	units         = br.player.units
	level         = br.player.level
	module        = br.player.module
	use           = br.player.use
	SotR          = true
	BoF           = true
    -- General API
    
    -- Dynamic Units
    units.get(5)
    units.get(8)
    -- Enemies Lists
    enemies.get(5)
    enemies.get(8)
    enemies.get(8,"player",false,true)
    enemies.get(10)
    enemies.get(20)
    enemies.get(30,"player",false,true)
    enemies.get(40)
    
    -- Profile Variables
    -- variable,name=ds_castable,value=spell_targets.divine_storm>=2|buff.empyrean_power.up&debuff.judgment.down&buff.divine_purpose.down|spell_targets.divine_storm>=2&buff.crusade.up&buff.crusade.stack<10
    var.dsUnits = ((ui.mode.rotation == 1 and (#enemies.yards8 >= ui.value("Divine Storm Units"))) or (ui.mode.rotation == 2 and #enemies.yards8 > 0))
    var.dsCastable = (var.dsUnits or (buff.empyreanPower.exists() and not debuff.judgment.exists(units.dyn8) and not buff.divinePurpose.exists()) or (var.dsUnits and buff.crusade.exists() and buff.crusade.stack() < 10))
    var.lowestUnit = br.friend[1].unit
    var.resable   = unit.player("target") and unit.deadOrGhost("target") and unit.friend("target","player")
    var.timeToHPG = cd.crusaderStrike.remain()
    if unit.level() >= 46 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.bladeOfJustice.remain(), cd.judgment.remain(), cd.hammerOfWrath.remain(), cd.wakeOfAshes.remain())
    end
    if unit.level() >= 39 then
        var.timeToHPG =math.min(cd.crusaderStrike.remain(), cd.bladeOfJustice.remain(), cd.judgment.remain(), cd.wakeOfAshes.remain())
    end
    if unit.level() >= 19 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.bladeOfJustice.remain(), cd.judgment.remain())
    end
    if unit.level() >= 16 then
        var.timeToHPG = math.min(cd.crusaderStrike.remain(), cd.judgment.remain())
    end
    var.turnedEvil = var.turnedEvil or "player"
    if var.profileStop == nil then var.profileStop = false end
    
    -- Crusader Aura
    if unit.mounted() and cast.able.crusaderAura() and not buff.crusaderAura.exists() then
        if cast.crusaderAura("player") then ui.debug("Casting Crusader Aura") return true end
    end
    -- Concentration Aura
    if ui.mode.aura == 1 and not unit.mounted() and cast.able.concentrationAura() and not buff.concentrationAura.exists() then
        if cast.concentrationAura("player") then ui.debug("Casting Concentration Aura") return true end
    end
    -- Devotion Aura
    if ui.mode.aura == 2 and not unit.mounted() and cast.able.devotionAura() and not buff.devotionAura.exists() then
        if cast.devotionAura("player") then ui.debug("Casting Devotion Aura") return true end
    end
    -- Retribution Aura
    if ui.mode.aura == 3 and not unit.mounted() and cast.able.retributionAura() and not buff.retributionAura.exists() then
        if cast.retributionAura("player") then ui.debug("Casting Retribution Aura") return true end
    end
    --stun
	local noStunsUnits = {}
	for i in string.gmatch(getOptionValue("Stuns Black Units"), "%d+") do
		noStunsUnits[tonumber(i)] = true
	end
	local StunSpellsList = {}
	for i in string.gmatch(getOptionValue("Stun Spells"), "%d+") do
		StunSpellsList[tonumber(i)] = true
	end
	local HoJList = {}
	for i in string.gmatch(getOptionValue("HoJ Prio Units"), "%d+") do
		HoJList[tonumber(i)] = true
	end
	-- infinite Divine Steed
	if isChecked("infinite Divine Steed key") and (SpecificToggle("infinite Divine Steed key") and not GetCurrentKeyBoardFocus()) then
		if getBuffRemain("player", 254474) <= 0.5 and not UnitAffectingCombat("player") then
			RemoveTalent(22433)
			RemoveTalent(22433)
			RemoveTalent(22434)
			RemoveTalent(22434)
			RemoveTalent(22435)
			RemoveTalent(22435)
			LearnTalent(22434)
			if cast.divineSteed() then return true end
		elseif not talent.unbreakableSpirit and not talent.cavalier and not talent.blessingOfSpellwarding then
			LearnTalent(22434)
		end
	end
    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not unit.inCombat() and not unit.exists("target") and var.profileStop then
        var.profileStop = false
    elseif (unit.inCombat() and var.profileStop) or ui.pause() or ui.mode.rotation==4 then
        return true
    else
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList.PreCombat() then return end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if unit.inCombat() and unit.valid("target") then --and opener.complete then
            ----------------------------------
            --- In Combat - Begin Rotation ---
            ----------------------------------
            local startTime = debugprofilestop()
            -- Start Attack
            -- auto_attack
            if unit.distance(units.dyn5) < 5 then unit.startAttack(units.dyn5) end
            -- Action List - Interrupts
            -- rebuke
            if actionList.Interrupts() then return end
            -- Light's Judgment - Lightforged Draenei Racial
            if ui.checked("Racial") and race == "LightforgedDraenei" then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if #enemies.get(8,thisUnit) > 2 and unit.health(thisUnit) < unit.healthMax(thisUnit)
                        and unit.ttd(thisUnit) > cast.time.racial()
                    then
                        if cast.racial(thisUnit) then ui.debug("Casting Racial: Lightforged Draenei [AOE]") return true end
                    end
                end
            end
            -- Action List - Cooldowns
            -- call_action_list,name=cooldowns
            if actionList.Cooldowns() then return end
            -- Divine Storm
            -- if cast.able.divineStorm() and buff.empyreanPower.exists() then
            --     if cast.divineStorm(nil,"aoe",1,8) then ui.debug("Casting Divine Storm [Empyrean Power]") return true end
            -- end
            -- Call Action List - Generator
            -- call_action_list,name=generators
            if actionList.Generator() then return end
            br.debug.cpu.rotation.inCombat = debugprofilestop()-startTime
        end -- End In Combat
    end -- End Profile
end -- runRotation
local id = 70
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})