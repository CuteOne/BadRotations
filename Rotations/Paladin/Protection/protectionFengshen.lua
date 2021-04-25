local rotationName = "Feng"
local StunsBlackList="167876|169861|168318|165824|165919|171799|168942|167612|169893|167536|173044|167731|165137|167538|168886|170572"
local StunSpellList="326450|328177|331718|331743|334708|333145|321807|334748|327130|327240|330532|328400|330423|294171|164737|330586|329224|328429|295001|296355|295001|295985|330471|329753|296748|334542|242391|322169|324609"
local HoJPrioList = "164702|164362|170488|165905|165251|165556"
---------------
--- Toggles ---
---------------
local function createToggles()
	local CreateButton = br["CreateButton"]
	-- Cooldown Button
	br.CooldownModes = {
	[1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.avengingWrath },
	[2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.avengingWrath },
	[3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avengingWrath }
	};
	CreateButton("Cooldown",1,0)
	-- Defensive Button
	br.DefensiveModes = {
	[1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.guardianOfAncientKings },
	[2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.guardianOfAncientKings }
	};
	CreateButton("Defensive",2,0)
	-- Interrupt Button
	br.InterruptModes = {
	[1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.hammerOfJustice },
	[2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.hammerOfJustice }
	};
	CreateButton("Interrupt",3,0)
	-- Boss Encounter Case
	br.BossCaseModes = {
	[1] = { mode = "On", value = 1 , overlay = "BossCase Enabled", tip = "Boss Encounter Case Enabled.", highlight = 1, icon = br.player.spell.blessingOfFreedom },
	[2] = { mode = "Off", value = 2 , overlay = "BossCase Disabled", tip = "Boss Encounter Case Disabled.", highlight = 0, icon = br.player.spell.blessingOfFreedom }
	};
	CreateButton("BossCase",0,1)
	-- Holy Power logic
	br.HolyPowerlogicModes = {
	[1] = { mode = "Attack", value = 1 , overlay = "Attack logic Enabled", tip = "Holy Power logic (Attack)", highlight = 1, icon = br.player.spell.shieldOfTheRighteous },
	[2] = { mode = "Defense", value = 2 , overlay = "Defense logic Enabled", tip = "Holy Power logic (Defense)", highlight = 1, icon = br.player.spell.wordOfGlory }
	};
	CreateButton("HolyPowerlogic",1,1)
	-- Auto cancel
	br.AutocancelModes = {
	[1] = { mode = "On", value = 1 , overlay = "Auto cancel Enabled", tip = "Auto cancel BoP and DS\n(Only In Instance and Raid)", highlight = 1, icon = br.player.spell.blessingOfProtection },
	[2] = { mode = "Off", value = 2 , overlay = "Auto cancel Disabled", tip = "Auto cancel BoP and DS Disabled", highlight = 0, icon = br.player.spell.blessingOfProtection }
	};
	CreateButton("Autocancel",2,1)
	-- Blessed Hammer
	br.BlessedHammerModes = {
	[1] = { mode = "On", value = 1 , overlay = "Blessed Hammer Enabled", tip = "Use Blessed Hammer to get Holy Power when you are free\nEnabled", highlight = 1, icon = br.player.spell.blessedHammer },
	[2] = { mode = "Off", value = 2 , overlay = "Blessed Hammer Disabled", tip = "Use Blessed Hammer to get Holy Power when you are free\nDisabled", highlight = 0, icon = br.player.spell.blessedHammer }
	};
	CreateButton("BlessedHammer",3,1)
end
---------------
--- OPTIONS ---
---------------
local function createOptions()
	local optionTable

	local function rotationOptions()
		-----------------------
		--- GENERAL OPTIONS ---
		-----------------------
		section = br.ui:createSection(br.ui.window.profile,  "General")
		-- Blessing of Freedom
		br.ui:createCheckbox(section, "Blessing of Freedom")
		-- Automatic Aura replacement
		br.ui:createCheckbox(section, "Automatic Aura replacement")
		-- Taunt
		br.ui:createCheckbox(section,"Taunt","|cffFFFFFFAuto Taunt usage.")
		-- Lay On Hands
		br.ui:createSpinner(section, "OOC FoL", 50, 0, 100, 1, "", "|cffFFFFFFout of combat Flash of Light.")
		br.ui:createDropdownWithout(section, "OOC FoL Target", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFFFFFFPlayer and Target"}, 3, "|ccfFFFFFFTarget to Cast On")
		-- infinite Divine Steed
		br.ui:createDropdown(section, "infinite Divine Steed key", br.dropOptions.Toggle, 6)
		br.ui:checkSectionState(section)
		------------------------
		--- COOLDOWN OPTIONS ---
		------------------------
		section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
		-- Racial
		br.ui:createCheckbox(section,"Racial")
		-- Trinkets
		br.ui:createDropdown(section,"Use Trinkets 1", {"|cff00FF00Everything","|cffFFFF00Cooldowns"}, 1, "","|cffFFFFFFWhen to use trinkets.")
		br.ui:createDropdownWithout(section,"Trinkets 1 Mode", {"|cffFFFFFFNormal","|cffFFFFFFGround","|cffFFFFFFAll Health","|cffFFFFFFTanks Health","|cffFFFFFFSelf Health"}, 1, "","|cffFFFFFFSelect Trinkets mode.")
		br.ui:createSpinnerWithout(section, "Trinkets 1",  70,  0,  100,  5,  "Health Percentage to use at")
		br.ui:createDropdown(section,"Use Trinkets 2", {"|cff00FF00Everything","|cffFFFF00Cooldowns"}, 1, "","|cffFFFFFFWhen to use trinkets.")
		br.ui:createDropdownWithout(section,"Trinkets 2 Mode", {"|cffFFFFFFNormal","|cffFFFFFFGround","|cffFFFFFFAll Health","|cffFFFFFFTanks Health","|cffFFFFFFSelf Health"}, 1, "","|cffFFFFFFSelect Trinkets mode.")
		br.ui:createSpinnerWithout(section, "Trinkets 2",  70,  0,  100,  5,  "Health Percentage to use at")
		-- Seraphim
		br.ui:createSpinner(section, "Seraphim",  0,  0,  20,  2,  "|cffFFFFFFEnemy TTD")
		-- Avenging Wrath
		br.ui:createSpinner(section, "Avenging Wrath",  0,  0,  200,  5,  "|cffFFFFFFEnemy TTD")
		-- Holy Avenger
		br.ui:createSpinner(section, "Holy Avenger",  0,  0,  200,  5,  "|cffFFFFFFEnemy TTD")
		br.ui:createCheckbox(section, "Holy Avenger with Wings")
		-- Ashen Hallow
		if br.player.covenant.venthyr.active then
			br.ui:createCheckbox(section,"Ashen Hallow")
		end
		br.ui:checkSectionState(section)
		-------------------------
		--- DEFENSIVE OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Defensive")
		-- Basic Healing Module
		br.player.module.BasicHealing(section)
		-- Phial of Serenity
		br.ui:createSpinner (section, "PoS removes Necrotic", 20, 0, 50, 1, "","|cffFFFFFFNecrotic stacks Phial of Serenity to use at")
		if br.player.race == "BloodElf" then
			br.ui:createSpinner (section, "Arcane Torrent Dispel", 1, 0, 20, 1, "","|cffFFFFFFMinimum Torrent Targets")
			br.ui:createCheckbox(section, "Arcane Torrent HolyPower")
		end
		-- Ardent Defender
		br.ui:createSpinner(section, "Ardent Defender",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Blinding Light
		br.ui:createSpinner(section, "Blinding Light - HP", 50, 0, 100, 5, "|cffFFFFFFHealth Percentage to use at")
		-- Cleanse Toxin
		br.ui:createDropdown(section, "Clease Toxin", {"|cff00FF00Player Only","|cffFFFF00Selected Target","|cffFFFFFFPlayer and Target","|cffFF0000Mouseover Target","|cffFFFFFFAny"}, 3, "|ccfFFFFFFTarget to Cast On")
		-- Divine Shield
		br.ui:createSpinner(section, "Divine Shield",  5,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Flash of Light
		br.ui:createSpinner(section, "Flash of Light",  50,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Guardian of Ancient Kings
		br.ui:createSpinner(section, "Guardian of Ancient Kings",  30,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Hammer of Justice
		br.ui:createSpinner(section, "Hammer of Justice - HP",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at")
		-- Word of Glory
		br.ui:createSpinner(section, "Word of Glory",  50,  0,  100,  5,  "|cffFFBB00Word of Glory to use at.")
		-- Free Word of Glory
		br.ui:createSpinnerWithout(section, "Free Word of Glory",  65,  0,  100,  5,  "|cffFFBB00Word of Glory to use at.")
		-- Hand of the Protector - on others
		br.ui:createSpinner(section, "Word of Glory - Party",  40,  0,  100,  5,  "|cffFFBB00Teammate Word of Glory to use at.")
		br.ui:createDropdownWithout(section, "WoG - Party Target", {"|cffFFFFFFOther tanks", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny"}, 4, "|cffFFFFFFTarget for Word of Glory")
		-- Lay On Hands
		br.ui:createSpinner(section, "Lay On Hands", 15, 0, 100, 5, "","Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Lay on Hands Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 8, "|cffFFFFFFTarget for Lay On Hands")
		-- Blessing of Protection
		br.ui:createSpinner(section, "Blessing of Protection", 30, 0, 100, 5, "","Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Blessing of Protection Target", {"|cffFFFFFFPlayer","|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 7, "|cffFFFFFFTarget for Blessing of Protection")
		-- Blessing Of Sacrifice
		br.ui:createSpinner(section, "Blessing Of Sacrifice", 40, 0, 100, 5, "","Health Percentage to use at")
		br.ui:createDropdownWithout(section, "Blessing Of Sacrifice Target", {"|cffFFFFFFTarget", "|cffFFFFFFMouseover", "|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFHealer/Damage", "|cffFFFFFFAny"}, 6, "|cffFFFFFFTarget for Blessing Of Sacrifice")
		-- Redemption
		br.ui:createDropdown(section, "Redemption", {"|cffFFFF00Selected Target","|cffFF0000Mouseover Target"}, 1, "|ccfFFFFFFTarget to Cast On")
		-- Unstable Temporal Time Shifter
		br.ui:createDropdown(section, "Engineering Revive", {"|cff00FF00Target","|cffFF0000Mouseover","|cffFFBB00Auto"}, 1, "","|cffFFFFFFTarget to use on")
		br.ui:checkSectionState(section)
		-------------------------
		--- INTERRUPT OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Interrupts")
		-- Blinding Light
		br.ui:createSpinner(section,  "Blinding Light - INT",  2,  1,  5,  1,  "|cffFFBB00Units to use Blinding Light.")
		-- Hammer of Justice
		br.ui:createCheckbox(section, "Hammer of Justice - INT")
		-- Rebuke
		br.ui:createCheckbox(section, "Rebuke - INT")
		-- Avenger's Shield
		br.ui:createCheckbox(section, "Avenger's Shield - INT")
		-- Interrupt Percentage
		br.ui:createSpinnerWithout(section, "Interrupt At",  60,  0,  100,  5,  "|cffFFBB00Cast Percentage to use at.")
		br.ui:checkSectionState(section)
		------------------------
		--- ROTATION OPTIONS ---
		------------------------
		section = br.ui:createSection(br.ui.window.profile, "Rotation Options")
		-- Divine Toll
		if br.player.covenant.kyrian.active then
			br.ui:createSpinner(section, "Divine Toll",  3,  1,  5,  1,  "|cffFFBB00Units to use Divine Toll.")
		end
		-- Avenger's Shield
		br.ui:createCheckbox(section,"Avenger's Shield")
		-- Consecration
		br.ui:createCheckbox(section,"Consecration")
		-- Blessed Hammer
		br.ui:createCheckbox(section,"Blessed Hammer")
		-- Hammer of the Righteous
		br.ui:createCheckbox(section,"Hammer of the Righteous")
		-- Judgment
		br.ui:createCheckbox(section,"Judgment")
		-- Shield of the Righteous
		br.ui:createCheckbox(section,"Shield of the Righteous")
		-- Hammer of Wrath
		br.ui:createCheckbox(section,"Hammer of Wrath")
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
----------------
--- ROTATION ---
----------------
local function runRotation()
	-- if br.timer:useTimer("debugProtection", math.random(0.1,0.2)) then
	--Print("Running: "..rotationName)
	--------------
	--- Locals ---
	--------------
	local holyPower     = br.player.power.holyPower.amount()
	local holyPowerMax  = br.player.power.holyPower.max()
	local runeforge     = br.player.runeforge
	local buff          = br.player.buff
	local cast          = br.player.cast
	local cd            = br.player.cd
	local charges       = br.player.charges
	local combatTime    = br.getCombatTime()
	local debuff        = br.player.debuff
	local enemies       = br.player.enemies
	local gcd           = br.player.gcd
	local gcdMax        = br.player.gcdMax
	local hastar        = br.GetObjectExists("target")
	local inCombat      = br.player.inCombat
	local level         = br.player.level
	local inInstance    = br.player.instance=="party"
	local inRaid        = br.player.instance=="raid"
	local lowest        = br.friend[1]
	local moving        = br.isMoving("player")
	local mode          = br.player.ui.mode
	local php           = br.player.health
	local race          = br.player.race
	local racial        = br.player.getRacial()
	local eating        = br.getBuffRemain("player",192002) ~= 0 or br.getBuffRemain("player",167152) ~= 0 or br.getBuffRemain("player",192001) ~= 0 or br.getBuffRemain("player",308433) ~= 0
	local resable       = br._G.UnitIsPlayer("target") and br._G.UnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target","player")
	local spell         = br.player.spell
	local talent        = br.player.talent
	local ttd           = br.getTTD("target")
	local unit          = br.player.unit
	local units         = br.player.units
	local module        = br.player.module
	local use           = br.player.use
	local ui            = br.player.ui
	local actionList    = {}
	local SotR          = true
	local BoF           = true
	local RInterrupts   = true

	units.get(5)
	units.get(10)
	units.get(30)
	enemies.get(5)
	enemies.get(8)
	enemies.get(10)
	enemies.get(30)

	if consecrationRemain == nil then consecrationRemain = 0 end
	if cast.last.consecration() then consecrationRemain = 11.5 end
	if consecrationRemain > 0 and br.timer:useTimer("Consecration Delay",0.5) then
		consecrationRemain = consecrationRemain - 0.5
	end
	local lowestUnit = "player"
	for i = 1, #br.friend do
		local thisUnit = br.friend[i].unit
		if br._G.UnitInRange(thisUnit) and not br._G.UnitIsDeadOrGhost(thisUnit) and br._G.UnitIsVisible(thisUnit) and br.getLineOfSight("player",thisUnit) then
			local thisHP = br.getHP(thisUnit)
			local lowestHP = br.getHP(lowestUnit)
			if thisHP < lowestHP then
				lowestUnit = thisUnit
			end
		end
	end
	local noStunsUnits = {}
	for i in string.gmatch(ui.value("Stuns Black Units"), "%d+") do
		noStunsUnits[tonumber(i)] = true
	end
	local StunSpellsList = {}
	for i in string.gmatch(ui.value("Stun Spells"), "%d+") do
		StunSpellsList[tonumber(i)] = true
	end
	local HoJList = {}
	for i in string.gmatch(ui.value("HoJ Prio Units"), "%d+") do
		HoJList[tonumber(i)] = true
	end

	if ui.checked("Automatic Aura replacement") and not br.castingUnit() then
		if not inInstance and not inRaid then
			if not buff.devotionAura.exists() and (not br._G.IsMounted() or buff.divineSteed.exists()) and cd.devotionAura.ready() then
				if cast.devotionAura("player") then return true end
			elseif not buff.crusaderAura.exists() and br._G.IsMounted() and cd.crusaderAura.ready() then
				if cast.crusaderAura("player") then return true end
			end
		end
		if (inInstance or inRaid) and not inCombat and not buff.devotionAura.exists() and cd.devotionAura.ready() then
			if cast.devotionAura("player") then return true end
		end
	end
	--------------------
	--- Action Lists ---
	--------------------
	-- Action List - Extras
	actionList.Extras = function()
		-- Taunt
		if ui.checked("Taunt") and cd.handOfReckoning.ready() and inInstance then
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if br._G.UnitThreatSituation("player",thisUnit) ~= nil and br._G.UnitThreatSituation("player",thisUnit) <= 2 and br._G.UnitAffectingCombat(thisUnit) and br.GetObjectID(thisUnit) ~= 174773 then
					if cast.handOfReckoning(thisUnit) then return true end
				end
			end
		end
		-- Auto cancel BoP and DS
		if mode.autocancel == 1 then
			if inInstance or inRaid then
				if buff.blessingOfProtection.exists() and cd.handOfReckoning.ready() and #enemies.yards10 == 1 then
					if cast.handOfReckoning("target") then return true end
				end
				if buff.blessingOfProtection.exists() and (debuff.handOfReckoning.remain("target") < 0.2 or br.getDebuffRemain("player",209858) ~= 0) then
					br.CancelUnitBuffID("player",spell.blessingOfProtection)
				end
				if not talent.finalStand and br.GetObjectID("boss1") ~= 162060 and br.GetObjectID("boss1") ~= 164261 then
					if buff.divineShield.exists() and cd.handOfReckoning.ready() and #enemies.yards10 == 1 then
						if cast.handOfReckoning("target") then return true end
					end
					if buff.divineShield.exists() and (debuff.handOfReckoning.remain("target") < 0.2 or br.getDebuffRemain("player",209858) ~= 0) then
						br.CancelUnitBuffID("player",spell.divineShield)
					end
				end
			end
		end
	end -- End Action List - Extras
	-- Action List - Defensives
	actionList.Defensive = function()
		if br.useDefensive() then
			module.BasicHealing()
			if ui.checked("PoS removes Necrotic") and inInstance and br.getDebuffStacks("player", 209858) >= br.getValue("PoS removes Necrotic") and use.able.phialOfSerenity() then
				if use.phialOfSerenity() then return true end
			end
			-- Arcane Torrent
			if race == "BloodElf" and inCombat and br.getSpellCD(155145) == 0 then
				if ui.checked("Arcane Torrent Dispel") then
					local torrentUnit = 0
					for i=1, #enemies.yards8 do
						local thisUnit = enemies.yards8[i]
						if br.canDispel(thisUnit,select(7,br._G.GetSpellInfo(br._G.GetSpellInfo(69179)))) then
							torrentUnit = torrentUnit + 1
							if torrentUnit >= ui.value("Arcane Torrent Dispel") then
								if br._G.CastSpellByName(br._G.GetSpellInfo(155145)) then return true end
								break
							end
						end
					end
				end
				if ui.checked("Arcane Torrent HolyPower") and (buff.avengingWrath.exists() or php <= 30) and holyPower < 3 then
					if br._G.CastSpellByName(br._G.GetSpellInfo(155145)) then return true end
				end
			end
			-- Lay On Hands
			if ui.checked("Lay On Hands") and br.getSpellCD(633) == 0 and inCombat and not buff.ardentDefender.exists() then
				-- Player
				if ui.value("Lay on Hands Target") == 1 then
					if php <= br.getValue("Lay On Hands") and not debuff.forbearance.exists("player") then
						if cast.layOnHands("player") then return true end
					end
					-- Target
				elseif ui.value("Lay on Hands Target") == 2 then
					if br.getHP("target") <= br.getValue("Lay On Hands") and not debuff.forbearance.exists("target") and br._G.UnitIsPlayer("target") and br.GetUnitIsFriend("target","player") then
						if cast.layOnHands("target") then return true end
					end
					-- Mouseover
				elseif ui.value("Lay on Hands Target") == 3 then
					if br.getHP("mouseover") <= br.getValue("Lay On Hands") and not debuff.forbearance.exists("mouseover") and br._G.UnitIsPlayer("mouseover") and br.GetUnitIsFriend("mouseover","player") then
						if cast.layOnHands("mouseover") then return true end
					end
				elseif br.getHP(lowestUnit) <= br.getValue("Lay On Hands") and not debuff.forbearance.exists(lowestUnit) then
					-- Tank
					if ui.value("Lay on Hands Target") == 4 then
						if br._G.UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.layOnHands(lowestUnit) then return true end
						end
						-- Healer
					elseif ui.value("Lay on Hands Target") == 5 then
						if br._G.UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
							if cast.layOnHands(lowestUnit) then return true end
						end
						-- Healer/Tank
					elseif ui.value("Lay on Hands Target") == 6 then
						if br._G.UnitGroupRolesAssigned(lowestUnit) == "HEALER" or br._G.UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.layOnHands(lowestUnit) then return true end
						end
						-- Healer/Damager
					elseif ui.value("Lay on Hands Target") == 7 then
						if br._G.UnitGroupRolesAssigned(lowestUnit) == "HEALER" or br._G.UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
							if cast.layOnHands(lowestUnit) then return true end
						end
						-- Any
					elseif  ui.value("Lay on Hands Target") == 8 then
						if cast.layOnHands(lowestUnit) then return true end
					end
				end
			end
			-- Divine Shield
			if ui.checked("Divine Shield") and cd.divineShield.ready() and not buff.ardentDefender.exists() and not buff.guardianOfAncientKings.exists() and not debuff.forbearance.exists() then
				if php <= ui.value("Divine Shield") and inCombat then
					if cast.divineShield() then return true end
				end
			end
			-- Word of Glory
			if php <= ui.value("Free Word of Glory") and (buff.divinePurpose.exists() or buff.shiningLight.exists() or buff.royalDecree.exists()) then
				SotR = false
				if cast.wordOfGlory("player") then return true end
			end
			if holyPower > 2 or buff.divinePurpose.exists() or buff.shiningLight.exists() or buff.royalDecree.exists() then
				if ui.checked("Word of Glory") and php <= ui.value("Word of Glory") then
					SotR = false
					if cast.wordOfGlory("player") then return true end
				end
				if ui.checked("Word of Glory - Party") then
					if br.getHP(lowestUnit) <= ui.value("Word of Glory - Party") and not br.GetUnitIsUnit(lowestUnit,"player") then
						if ui.value("WoG - Party Target") == 1 then
							if br._G.UnitGroupRolesAssigned(lowestUnit) == "TANK" then
								SotR = false
								if cast.wordOfGlory(lowestUnit) then return true end
							end
						elseif ui.value("WoG - Party Target") == 2 then
							if br._G.UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
								SotR = false
								if cast.wordOfGlory(lowestUnit) then return true end
							end
						elseif ui.value("WoG - Party Target") == 3 then
							if br._G.UnitGroupRolesAssigned(lowestUnit) == "TANK" or br._G.UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
								SotR = false
								if cast.wordOfGlory(lowestUnit) then return true end
							end
						elseif ui.value("WoG - Party Target") == 4 then
							SotR = false
							if cast.wordOfGlory(lowestUnit) then return true end
						end
					end
				end
				if (buff.divinePurpose.exists() and buff.divinePurpose.remain() < gcdMax) or (buff.shiningLight.exists() and buff.shiningLight.remain() < gcdMax) or (buff.royalDecree.exists() and buff.royalDecree.remain() < gcdMax) then
					SotR = false
					if cast.wordOfGlory(lowestUnit) then return true end
				end
			end
			-- Blessing of Protection
			if ui.checked("Blessing of Protection") and br.getSpellCD(1022) == 0 and inCombat and not br.isBoss("boss1") then
				-- Player
				if ui.value("Blessing of Protection Target") == 1 then
					if php <= br.getValue("Blessing of Protection") and not debuff.forbearance.exists("player") then
						if cast.blessingOfProtection("player") then return true end
					end
					-- Target
				elseif ui.value("Blessing of Protection Target") == 2 then
					if br.getHP("target") <= br.getValue("Blessing of Protection") and not debuff.forbearance.exists("target") and br._G.UnitIsPlayer("target") and br.GetUnitIsFriend("target","player") then
						if cast.blessingOfProtection("target") then return true end
					end
					-- Mouseover
				elseif ui.value("Blessing of Protection Target") == 3 then
					if br.getHP("mouseover") <= br.getValue("Blessing of Protection") and not debuff.forbearance.exists("mouseover") and br._G.UnitIsPlayer("mouseover") and br.GetUnitIsFriend("mouseover","player") then
						if cast.blessingOfProtection("mouseover") then return true end
					end
				elseif br.getHP(lowestUnit) <= br.getValue("Blessing of Protection") and not debuff.forbearance.exists(lowestUnit) then
					-- Tank
					if ui.value("Blessing of Protection Target") == 4 then
						if br._G.UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.blessingOfProtection(lowestUnit) then return true end
						end
						-- Healer
					elseif ui.value("Blessing of Protection Target") == 5 then
						if br._G.UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
							if cast.blessingOfProtection(lowestUnit) then return true end
						end
						-- Healer/Tank
					elseif ui.value("Blessing of Protection Target") == 6 then
						if br._G.UnitGroupRolesAssigned(lowestUnit) == "HEALER" or br._G.UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.blessingOfProtection(lowestUnit) then return true end
						end
						-- Healer/Damager
					elseif ui.value("Blessing of Protection Target") == 7 then
						if br._G.UnitGroupRolesAssigned(lowestUnit) == "HEALER" or br._G.UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
							if cast.blessingOfProtection(lowestUnit) then return true end
						end
						-- Any
					elseif  ui.value("Blessing of Protection Target") == 8 then
						if cast.blessingOfProtection(lowestUnit) then return true end
					end
				end
			end
			-- Blessing Of Sacrifice
			if ui.checked("Blessing Of Sacrifice") and cd.blessingOfSacrifice.ready() and php >= 50 and inCombat then
				-- Target
				if ui.value("Blessing Of Sacrifice Target") == 1 then
					if br.getHP("target") <= br.getValue("Blessing Of Sacrifice") and br._G.UnitIsPlayer("target") and br.GetUnitIsFriend("target","player") then
						if cast.blessingOfSacrifice("target") then return true end
					end
					-- Mouseover
				elseif ui.value("Blessing Of Sacrifice Target") == 2 then
					if br.getHP("mouseover") <= br.getValue("Blessing Of Sacrifice") and br._G.UnitIsPlayer("mouseover") and br.GetUnitIsFriend("mouseover","player") then
						if cast.blessingOfSacrifice("mouseover") then return true end
					end
				elseif br.getHP(lowestUnit) <= br.getValue("Blessing Of Sacrifice") and not br.GetUnitIsUnit(lowestUnit,"player") and not cast.last.blessingOfProtection() then
					-- Tank
					if ui.value("Blessing Of Sacrifice Target") == 3 then
						if br._G.UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.blessingOfSacrifice(lowestUnit) then return true end
						end
						-- Healer
					elseif ui.value("Blessing Of Sacrifice Target") == 4 then
						if br._G.UnitGroupRolesAssigned(lowestUnit) == "HEALER" then
							if cast.blessingOfSacrifice(lowestUnit) then return true end
						end
						-- Healer/Tank
					elseif ui.value("Blessing Of Sacrifice Target") == 5 then
						if br._G.UnitGroupRolesAssigned(lowestUnit) == "HEALER" or br._G.UnitGroupRolesAssigned(lowestUnit) == "TANK" then
							if cast.blessingOfSacrifice(lowestUnit) then return true end
						end
						-- Healer/Damager
					elseif ui.value("Blessing Of Sacrifice Target") == 6 then
						if br._G.UnitGroupRolesAssigned(lowestUnit) == "HEALER" or br._G.UnitGroupRolesAssigned(lowestUnit) == "DAMAGER" then
							if cast.blessingOfSacrifice(lowestUnit) then return true end
						end
						-- Any
					elseif  ui.value("Blessing Of Sacrifice Target") == 7 then
						if cast.blessingOfSacrifice(lowestUnit) then return true end
					end
				end
			end
			-- Cleanse Toxins
			if ui.checked("Clease Toxin") and cd.cleanseToxins.ready() and br.GetObjectID("boss1") ~= 164267 then
				if ui.value("Clease Toxin")==1 then
					if br.canDispel("player",spell.cleanseToxins) then
						if cast.cleanseToxins("player") then return true end
					end
				elseif ui.value("Clease Toxin")==2 then
					if br.canDispel("target",spell.cleanseToxins) then
						if cast.cleanseToxins("target") then return true end
					end
				elseif ui.value("Clease Toxin")==3 then
					if br.canDispel("player",spell.cleanseToxins) then
						if cast.cleanseToxins("player") then return true end
					elseif br.canDispel("target",spell.cleanseToxins) then
						if cast.cleanseToxins("target") then return true end
					end
				elseif ui.value("Clease Toxin")==4 then
					if br.canDispel("mouseover",spell.cleanseToxins) then
						if cast.cleanseToxins("mouseover") then return true end
					end
				elseif ui.value("Clease Toxin")==5 then
					for i = 1, #br.friend do
						if br.canDispel(br.friend[i].unit,spell.cleanseToxins) then
							if cast.cleanseToxins(br.friend[i].unit) then return true end
						end
					end
				end
			end
			-- Blinding Light
			if ui.checked("Blinding Light - HP") and cd.blindingLight.ready() and talent.blindingLight and php <= ui.value("Blinding Light - HP") and inCombat and #enemies.yards10 > 0 then
				if cast.blindingLight() then return true end
			end
			if ui.checked("Guardian of Ancient Kings") and cd.guardianOfAncientKings.ready() then
				if php <= ui.value("Guardian of Ancient Kings") and inCombat and not buff.ardentDefender.exists() and not buff.divineShield.exists() then
					if cast.guardianOfAncientKings() then return true end
				end
			end
			-- Ardent Defender
			if ui.checked("Ardent Defender") and cd.ardentDefender.ready() then
				if (php <= ui.value("Ardent Defender") or php <= 10 or buff.holyAvenger.exists()) and inCombat and not buff.guardianOfAncientKings.exists() and not buff.divineShield.exists() then
					if cast.ardentDefender() then return true end
				end
			end
			-- Gift of the Naaru
			if ui.checked("Gift of the Naaru") and php <= ui.value("Gift of the Naaru") and php > 0 and race == "Draenei" then
				if br.castSpell("player",racial,false,false,false) then return true end
			end
			-- Hammer of Justice
			if ui.checked("Hammer of Justice - HP") and cd.hammerOfJustice.ready() and php <= ui.value("Hammer of Justice - HP") and inCombat then
				for i = 1, #enemies.yards10 do
					local thisUnit = enemies.yards10[i]
					if not br.isBoss(thisUnit) and br.getBuffRemain(thisUnit,226510) == 0 and noStunsUnits[br.GetObjectID(thisUnit)] == nil then
						if cast.hammerOfJustice(thisUnit) then return true end
					end
				end
			end
			-- Redemption
			if ui.checked("Redemption") and not inCombat and not moving and not br.castingUnit() then
				if ui.value("Redemption")==1 and resable then
					if cast.redemption("target","dead") then return true end
				end
				if ui.value("Redemption")==2 and resable then
					if cast.redemption("mouseover","dead") then return true end
				end
			end
			-- Blessing of Freedom
			if ui.checked("Blessing of Freedom") and cd.blessingOfFreedom.ready() and br.hasNoControl(spell.blessingOfFreedom) then
				if cast.blessingOfFreedom("player") then return true end
			end
			-- Flash of Light
			if ui.checked("Flash of Light") then
				if (forceHeal or (inCombat and php <= ui.value("Flash of Light") / 2) or (not inCombat and php <= ui.value("Flash of Light"))) and not moving then
					if cast.flashOfLight("player") then return true end
				end
			end
			-- Engineering Revive
			if ui.checked("Engineering Revive") and br.canUseItem(184308) and not moving and inCombat then
				if ui.value("Engineering Revive") == 1 and br._G.UnitIsPlayer("target") and br._G.UnitIsDeadOrGhost("target") and br.GetUnitIsFriend("target","player") and br.getDistance("target") <= 5 then
					br._G.UseItemByName(184308,"target")
				elseif ui.value("Engineering Revive") == 2 and br._G.UnitIsPlayer("mouseover") and br._G.UnitIsDeadOrGhost("mouseover") and br.GetUnitIsFriend("mouseover","player") and br.getDistance("mouseover") <= 5 then
					br._G.UseItemByName(184308,"mouseover")
				elseif ui.value("Engineering Revive") == 3 then
					for i =1, #br.friend do
						if br._G.UnitIsPlayer(br.friend[i].unit) and br._G.UnitIsDeadOrGhost(br.friend[i].unit) and br.GetUnitIsFriend(br.friend[i].unit,"player") and br.getDistance(br.friend[i].unit) <= 5 then
							br._G.UseItemByName(184308,br.friend[i].unit)
						end
					end
				end
			end
		end
	end -- End Action List - Defensive
	-- Action List - BossEncounterCase
	actionList.BossEncounterCase = function()
		if (br.GetObjectID("target") == 165759 or br.GetObjectID("target") == 171577 or br.GetObjectID("target") == 173112) then
			if br.getHP("target") < 100 and (holyPower > 2 or buff.divinePurpose.exists() or buff.shiningLight.exists() or buff.royalDecree.exists()) then
				SotR = false
				if cast.wordOfGlory("target") then return true end
			end
		end
		-- Special interrupt logic
		if inInstance then
			for i = 1, #enemies.yards10 do
				local thisUnit = enemies.yards10[i]
				if (br._G.UnitCastingInfo(thisUnit) == br._G.GetSpellInfo(332329) and br.getCastTimeRemain(thisUnit) ~=0 and br.getCastTimeRemain(thisUnit) < 2 and br.getBuffRemain(thisUnit,343503) == 0) or br._G.UnitChannelInfo(thisUnit) == br._G.GetSpellInfo(336451) then
					if cd.hammerOfJustice.ready() then
						if cast.hammerOfJustice(thisUnit) then return true end
					end
					if cd.blindingLight.ready() and talent.blindingLight then
						if cast.blindingLight() then return true end
					end
				end
			end
		end
		-- Wicked Gash or Dark Stride
		if cd.blessingOfProtection.ready() and not talent.blessingOfSpellwarding then
			for i = 1, #br.friend do
				if br.getDebuffStacks(br.friend[i].unit,331415) > 1 or br.getDebuffStacks(br.friend[i].unit,324154) > 1 then
					if cast.blessingOfProtection(br.friend[i].unit) then return true end
				end
			end
		end
		-- Infectious Rain
		if br._G.UnitChannelInfo("boss1") ~= br._G.GetSpellInfo(331399) and br.getDebuffRemain("player",331399) ~= 0 and cd.cleanseToxins.ready() then
			if cast.cleanseToxins("player") then return true end
		end
		-- Will to
		if race == "Human" and br.getSpellCD(59752) == 0 and (br.getDebuffRemain("player",321893) ~= 0 or br.getDebuffRemain("player",331847) ~= 0 or br.getDebuffRemain("player",319611) ~= 0) then
			if br._G.CastSpellByName(br._G.GetSpellInfo(59752)) then return true end
		end
		-- Gloom Squall
		if br.getBuffRemain("player",324089) ~= 0 then
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if (br.GetObjectID(thisUnit) == 162099 or br.GetObjectID(thisUnit) == 162133) and (br._G.UnitCastingInfo(thisUnit) == br._G.GetSpellInfo(322903) or br._G.UnitCastingInfo(thisUnit) == br._G.GetSpellInfo(324103)) then
					br._G.RunMacroText("/click ExtraActionButton1")
				end
			end
		end
		-- Castigate
		if holyPower > 2 or buff.divinePurpose.exists() or buff.shiningLight.exists() or buff.royalDecree.exists() then
			if br._G.UnitChannelInfo("boss1") == br._G.GetSpellInfo(322554) and br.getHP("boss1target") <= 50 then
				SotR = false
				if cast.wordOfGlory("boss1target") then return true end
			end
		end
		-- Hammer of Justice
		if cd.hammerOfJustice.ready() then
			for i = 1, #enemies.yards10 do
				local thisUnit = enemies.yards10[i]
				if HoJList[br.GetObjectID(thisUnit)] ~= nil and br.getBuffRemain(thisUnit,343503) == 0 then
					if cast.hammerOfJustice(thisUnit) then return true end
				end
				-- Opportunity Strikes
				if br._G.UnitChannelInfo(thisUnit) == br._G.GetSpellInfo(333540) then
					if cast.hammerOfJustice(thisUnit) then return true end
				end
			end
		end
		-- Divine Toll
		if br.player.covenant.kyrian.active and (br.GetObjectID("boss1") == 165946 or br.GetObjectID("boss1") == 164185 or br.GetObjectID("boss1") == 167406 or br.GetObjectID("boss1") == 163157) and cd.divineToll.ready() then
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if br.GetObjectID(thisUnit) == 166524 or br.GetObjectID(thisUnit) == 164363 or br.GetObjectID(thisUnit) == 167999 or br.GetObjectID(thisUnit) == 164414 then
					if cast.divineToll(thisUnit) then return true end
				end
			end
		end
		-- Blessing of Freedom
		if br.getSpellCD(1044) <= gcdMax then
			if br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(320788) or br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(324608) or br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(319941) then
				BoF = false
				if cast.blessingOfFreedom("boss1target") then return true end
			end
			-- Oppressive Banner
			if (br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(317231) or br._G.UnitCastingInfo("boss1") == br._G.GetSpellInfo(320729)) and br.getDebuffRemain("player",331606) ~= 0 then
				if cast.blessingOfFreedom("player") then return true end
			end
			-- Debuff
			local BoFDebuff = {330810,326827,324608,292942,329326,295929,292910,329905}
			for k,v in pairs(BoFDebuff) do
				if br.getDebuffRemain("player",v) ~= 0 then
					if cast.blessingOfFreedom("player") then return true end
				end
			end
			-- Wretched Phlegm
			if select(8,br._G.GetInstanceInfo()) == 2289 then
				for i = 1, #enemies.yards30 do
					local thisUnit = enemies.yards30[i]
					if br._G.UnitCastingInfo(thisUnit) == br._G.GetSpellInfo(334926) then
						if cast.blessingOfFreedom("player") then return true end
					end
				end
			end
			-- Rooted in Anima
			if br.GetObjectID("boss1") == 165521 then
				for i = 1, #br.friend do
					if br.getDebuffRemain(br.friend[i].unit,341746) ~= 0 then
						if cast.blessingOfFreedom(br.friend[i].unit) then return true end
					end
				end
			end
		end
	end -- End Action List - BossEncounterCase
	-- Action List - Cooldowns
	actionList.Cooldowns = function()
		-- Trinkets
		if ui.checked("Use Trinkets 1") and br.canUseItem(13) and ((ui.value("Use Trinkets 1") == 2 and br.useCDs()) or ui.value("Use Trinkets 1") == 1) then
			if ui.value("Trinkets 1 Mode") == 1 then
				if br.useItem(13) then return true end
			elseif ui.value("Trinkets 1 Mode") == 2 then
				if br.useItemGround("target",13,40,0,nil) then return true end
			elseif ui.value("Trinkets 1 Mode") == 3 and lowest.hp <= ui.value("Trinkets 1") then
				if br.useItem(13,lowest.unit) then return true end
			elseif ui.value("Trinkets 1 Mode") == 4 and lowest.hp <= ui.value("Trinkets 1") and br._G.UnitGroupRolesAssigned(lowest.unit) == "TANK" then
				if br.useItem(13,lowest.unit) then return true end
			elseif ui.value("Trinkets 1 Mode") == 5 and php <= ui.value("Trinkets 1") then
				if br.useItem(13,"player") then return true end
			end
		end
		if ui.checked("Use Trinkets 2") and br.canUseItem(14) and ((ui.value("Use Trinkets 2") == 2 and br.useCDs()) or ui.value("Use Trinkets 2") == 1) then
			if ui.value("Trinkets 2 Mode") == 1 then
				if br.useItem(14) then return true end
			elseif ui.value("Trinkets 2 Mode") == 2 then
				if br.useItemGround("target",14,40,0,nil) then return true end
			elseif ui.value("Trinkets 2 Mode") == 3 and lowest.hp <= ui.value("Trinkets 2") then
				if br.useItem(14,lowest.unit) then return true end
			elseif ui.value("Trinkets 2 Mode") == 4 and lowest.hp <= ui.value("Trinkets 2") and br._G.UnitGroupRolesAssigned(lowest.unit) == "TANK" then
				if br.useItem(14,lowest.unit) then return true end
			elseif ui.value("Trinkets 2 Mode") == 5 and php <= ui.value("Trinkets 2") then
				if br.useItem(14,"player") then return true end
			end
		end
		if br.useCDs() or burst then
			-- Racials
			if ui.checked("Racial") then
				if race == "Orc" or race == "Troll" and br.getSpellCD(racial) == 0 then
					if br.castSpell("player",racial,false,false,false) then return true end
				end
			end
			if br.GetUnitExists(units.dyn5) then
				-- Seraphim
				if ui.checked("Seraphim") and talent.seraphim and holyPower > 2 and ui.value("Seraphim") <= ttd and br.getSpellCD(152262) <= gcdMax then
					SotR = false
					if cast.seraphim() then return true end
				end
				-- Avenging Wrath
				if ui.checked("Avenging Wrath") and cd.avengingWrath.ready() and ui.value("Avenging Wrath") <= ttd and not buff.avengingWrath.exists() then
					if cast.avengingWrath() then return true end
				end
				-- Holy Avenger
				if ui.checked("Holy Avenger") and cd.holyAvenger.ready() and talent.holyAvenger and
					((not ui.checked("Holy Avenger with Wings") and ui.value("Holy Avenger") <= ttd ) or (ui.checked("Holy Avenger with Wings") and br.getSpellCD(31884) == 0))then
					if cast.holyAvenger() then return true end
				end
			end
			-- Ashen Hallow
			if ui.checked("Holy Avenger") and br.player.covenant.venthyr.active and cd.ashenHallow.ready() then
				if br._G.CastSpellByName(br._G.GetSpellInfo(spell.ashenHallow), "player") then return true end
			end
		end -- End Cooldown Usage Check
	end -- End Action List - Cooldowns
	-- Action List - Interrupts
	actionList.Interrupts = function()
		if br.useInterrupts() then
			if ui.checked("Avenger's Shield - INT") and cd.avengersShield.ready() then
				for i = 1, #enemies.yards30 do
					local thisUnit = enemies.yards30[i]
					if (select(8,br._G.UnitCastingInfo(thisUnit)) == false or select(7,br._G.UnitChannelInfo(thisUnit)) == false) and br.getFacing("player",thisUnit) then
						RInterrupts = false
						if cast.avengersShield(thisUnit) then return true end
					end
				end
			end
			local BL_Unit = 0
			for i = 1, #enemies.yards10 do
				local thisUnit = enemies.yards10[i]
				local distance = br.getDistance(thisUnit)
				-- Stun Spells
				local interruptID
				if br._G.UnitCastingInfo(thisUnit) then
					interruptID = select(9,br._G.UnitCastingInfo(thisUnit))
				elseif br._G.UnitChannelInfo(thisUnit) then
					interruptID = select(8,br._G.UnitChannelInfo(thisUnit))
				end
				if interruptID ~=nil and StunSpellsList[interruptID] and br.getBuffRemain(thisUnit,343503) == 0 then
					if ui.checked("Hammer of Justice - INT") and cd.hammerOfJustice.ready() and br.getBuffRemain(thisUnit,226510) == 0 then
						if cast.hammerOfJustice(thisUnit) then return true end
					end
					if ui.checked("Blinding Light - INT") and cd.blindingLight.ready() and talent.blindingLight then
						if cast.blindingLight() then return true end
					end
				end
				if br.canInterrupt(thisUnit,ui.value("Interrupt At")) then
					-- Blinding Light
					if ui.checked("Blinding Light - INT") and cd.blindingLight.ready() and talent.blindingLight and br.getBuffRemain(thisUnit,343503) == 0 then
						if not br.isBoss(thisUnit) and noStunsUnits[br.GetObjectID(thisUnit)] == nil then
							BL_Unit = BL_Unit + 1
							if BL_Unit >= ui.value("Blinding Light - INT") then
								RInterrupts = false
								if cast.blindingLight() then return true end
							end
						end
					end
					-- Hammer of Justice
					if ui.checked("Hammer of Justice - INT") and cd.hammerOfJustice.ready() then
						if not br.isBoss(thisUnit) and br.getBuffRemain(thisUnit,226510) == 0 and br.getBuffRemain(thisUnit,343503) == 0 and noStunsUnits[br.GetObjectID(thisUnit)] == nil then
							if cast.hammerOfJustice(thisUnit) then hoj_unit = thisUnit return true end
						end
					end
					-- Rebuke
					if ui.checked("Rebuke - INT") and cd.rebuke.ready() and (distance <= 5 or (br._G.IsFlying(thisUnit) and distance <= 10)) and br.getFacing("player",thisUnit) and not br.GetUnitIsUnit(hoj_unit,thisUnit) then
						if cast.rebuke(thisUnit) then return true end
					end
				end
			end
		end
	end -- End Action List - Interrupts
	-- Action List - Opener
	actionList.Opener = function()
		-- infinite Divine Steed
		if ui.checked("infinite Divine Steed key") and (br.SpecificToggle("infinite Divine Steed key") and not br._G.GetCurrentKeyBoardFocus()) then
			if br.getBuffRemain("player", 254474) <= 0.5 then
				if cast.divineSteed() then return true end
				RemoveTalent(22433)
				RemoveTalent(22433)
				RemoveTalent(22434)
				RemoveTalent(22434)
				RemoveTalent(22435)
				RemoveTalent(22435)
				LearnTalent(22434)
			elseif not talent.unbreakableSpirit and not talent.cavalier and not talent.blessingOfSpellwarding then
				LearnTalent(22434)
			end
		end
		-- Flash of Light
		if ui.checked("OOC FoL") and cd.flashOfLight.ready() and not moving then
			-- Player
			if ui.value("OOC FoL Target") == 1 then
				if php <= br.getValue("OOC FoL") then
					if cast.flashOfLight("player") then return true end
				end
				-- Target
			elseif ui.value("OOC FoL Target") == 2 then
				if br.getHP("target") <= br.getValue("OOC FoL") and br._G.UnitIsPlayer("target") and br.GetUnitIsFriend("target","player") then
					if cast.flashOfLight("target") then return true end
				end
				-- Player and Target
			elseif ui.value("OOC FoL Target") == 3 then
				if php <= br.getValue("OOC FoL") then
					if cast.flashOfLight("player") then return true end
				elseif br.getHP("target") <= br.getValue("OOC FoL") and br._G.UnitIsPlayer("target") and br.GetUnitIsFriend("target","player")then
					if cast.flashOfLight("target") then return true end
				end
			end
		end
		-- Blessed Hammer
		if mode.blessedHammer == 1 then
			if cd.blessedHammer.ready() and talent.blessedHammer and charges.blessedHammer.frac() == 3 and holyPower < 5 then
				if cast.blessedHammer() then return true end
			end
		end
		if br.isValidUnit("target") and br.getFacing("player","target") then
			if ui.checked("Judgment") and br.getDistance("target") <= 30 and cd.judgment.ready() then
				if cast.judgment("target") then return true end
			end
		end
	end -- End Action List - Opener
	-- Action List - Damage
	actionList.Damage = function()
		-- Explosives
		if inInstance then
			for i = 1, #enemies.yards30 do
				local thisUnit = enemies.yards30[i]
				if br.GetObjectID(thisUnit) == 120651 and br.getFacing("player",thisUnit) then
					if br.getDistance(thisUnit) <= 5 then
						br._G.StartAttack(thisUnit)
					end
					if (cd.hammerOfWrath.ready() and buff.avengingWrath.exists()) or (br.player.covenant.venthyr.active and cd.ashenHallow.remain() > 210) then
						if cast.hammerOfWrath(thisUnit) then return true end
					end
					if cd.judgment.ready() then
						if cast.judgment(thisUnit) then return true end
					end
					if cd.avengersShield.ready() then
						if cast.avengersShield(thisUnit) then return true end
					end
				end
			end
		end
		-- Start Attack
		if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and br.isValidUnit(units.dyn5) and br.getFacing("player",units.dyn5) and br.getDistance(units.dyn5) <= 5 then
			br._G.StartAttack(units.dyn5)
		end
		-- Shield of the Righteous
		if ui.checked("Shield of the Righteous") and cd.shieldOfTheRighteous.ready() and SotR == true and (holyPower > 2 or buff.divinePurpose.exists())
			and (mode.holyPowerlogic == 1 and (buff.holyAvenger.exists() or br.getBuffRemain("player",337848) ~= 0 or debuff.judgment.exists(units.dyn10) or holyPower == 5 or buff.shieldOfTheRighteous.remains("player") < 2))
			or (mode.holyPowerlogic == 2 and holyPower == 5 and (br.getSpellCD(275779) <= gcdMax or br.getSpellCD(31935) <= gcdMax or (talent.blessedHammer and br.getSpellCD(204019) <= gcdMax) or (not talent.blessedHammer and br.getSpellCD(53595) <= gcdMax) or ((br.getHP(units.dyn30) <= 20 or buff.avengingWrath.exists()) and br.getSpellCD(24275) <= gcdMax))) then
			if cast.shieldOfTheRighteous(units.dyn5) then return true end
		end
		local mob30 = br.GetUnitExists(units.dyn30) and br.getFacing("player",units.dyn30)
		-- Avenger's Shield
		if ui.checked("Avenger's Shield") and cd.avengersShield.ready() and #enemies.yards10 >= 3 and mob30 then
			if cast.avengersShield(units.dyn30) then return true end
		end
		-- Divine Toll
		if ui.checked("Divine Toll") and br.player.covenant.kyrian.active and cd.divineToll.ready() and br.GetObjectID("boss1") ~= 165946 and br.GetObjectID("boss1") ~= 164185 and br.GetObjectID("boss1") ~= 163157 then
			if (#enemies.yards10 >= br.getValue("Divine Toll") or (br.isBoss(units.dyn30) and br.GetObjectID("boss1") ~= 167406) or (br.isBoss(units.dyn30) and br.GetObjectID("boss1") == 167406 and br.getHP("boss1") <= 70)) then
				if cast.divineToll(units.dyn30) then return true end
			end
		end
		-- Consecration
		if ui.checked("Consecration") and cd.consecration.ready() and br.GetUnitExists(units.dyn5) and not buff.consecration.exists() then
			if cast.consecration() then return true end
		end
		-- Judgment
		if ui.checked("Judgment") and cd.judgment.ready() and ((talent.crusadersJudgment and charges.judgment.frac() >= 1.99) or not talent.crusadersJudgment or not debuff.judgment.exists(units.dyn30)) and mob30 then
			if cast.judgment(units.dyn30) then return true end
		end
		-- Hammer of Wrath
		if ui.checked("Hammer of Wrath") and br.getSpellCD(24275) == 0 and (br.getHP(units.dyn30) <= 20 or (level >= 58 and buff.avengingWrath.exists()) or br.getBuffRemain("player",345693) ~= 0 or (br.player.covenant.venthyr.active and cd.ashenHallow.remain() > 210)) and mob30 then
			if cast.hammerOfWrath(units.dyn30) then return true end
		end
		-- Avenger's Shield
		if ui.checked("Avenger's Shield") and cd.avengersShield.ready() and mob30 then
			if cast.avengersShield(units.dyn30) then return true end
		end
		-- Crusader Strike
		if cd.crusaderStrike.ready() and level < 14 and br.getFacing("player",units.dyn5) and br.GetUnitExists(units.dyn5) then
			if cast.crusaderStrike(units.dyn5) then return true end
		end
		-- Blessed Hammer
		if ui.checked("Blessed Hammer") and cd.blessedHammer.ready() and talent.blessedHammer and (#enemies.yards8 >= 1 or holyPower < 3 or (charges.blessedHammer.frac() == 3 and holyPower < 5)) then
			if cast.blessedHammer() then return true end
		end
		-- Hammer of the Righteous
		if ui.checked("Hammer of the Righteous") and cd.hammerOfTheRighteous.ready() and not talent.blessedHammer and br.getFacing("player",units.dyn5) and br.GetUnitExists(units.dyn5) then
			if cast.hammerOfTheRighteous(units.dyn5) then return true end
		end
		-- Consecration
		if ui.checked("Consecration") and cd.consecration.ready() and br.GetUnitExists(units.dyn5) and consecrationRemain < 5 then
			if cast.consecration() then return true end
		end
	end -- End Action List - Damage
	---------------------
	--- Begin Profile ---
	---------------------
	--Profile Stop | Pause
	if br.pause() or eating or br.hasBuff(250873) or br.hasBuff(115834) or br.hasBuff(58984) or br.hasBuff(185710) or br.isCastingSpell(212056) or (br._G.IsMounted() and not buff.divineSteed.exists()) then
		return true
	else
		if not inCombat then
			if actionList.Opener() then return true end
			if actionList.Defensive() then return true end
		end
		if inCombat then
			if actionList.Extras() then return true end
			if mode.bossCase == 1 then
				if actionList.BossEncounterCase() then return true end
			end
			if actionList.Interrupts() then return true end
			if actionList.Cooldowns() then return true end
			if actionList.Defensive() then return true end
			if BoF == true then
				if actionList.Damage() then return true end
			end
		end
	end -- End In Combat
end -- runRotation
local id = 66
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
name = rotationName,
toggles = createToggles,
options = createOptions,
run = runRotation,
})
