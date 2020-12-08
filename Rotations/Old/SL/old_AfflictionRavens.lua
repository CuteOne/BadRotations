local rotationName = "|cffC942FDAfflictionRavens" -- Change to name of profile listed in options drop down

---------------
--- Toggles ---
---------------
local function createToggles () -- Define custom toggles
-- Rotation Button
	RotationModes = {
		[1] = { mode = "Auto", value = 1 , overlay = "DPS Rotation Enabled", tip = "DPS Rotation Enabled", highlight = 1, icon = br.player.spell.agony },
		[2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.agony },
		[3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.shadowBolt },
		[4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "DPS Rotation Disabled", highlight = 0, icon = br.player.spell.drainLife }
	};
	CreateButton("Rotation",1,0)
-- Cooldown Button
	CooldownModes = {
		[1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.summonDarkglare },
		[2] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.summonDarkglare }
	};
	CreateButton("Cooldown",2,0)
-- Defensive Button
	DefensiveModes = {
		[1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Use Defensive Abilities.", highlight = 1, icon = br.player.spell.unendingResolve },
		[2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "Don't use Defensive Abilities.", highlight = 0, icon = br.player.spell.unendingResolve }
	};
	CreateButton("Defensive",3,0)
-- Interrupt Button
	InterruptModes = {
		[1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.spellLock },
		[2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.spellLock }
	};
	CreateButton("Interrupt",4,0)
-- Phantom Singularity Button
    PSModes = {
        [1] = { mode = "On", value = 1 , overlay = "Phantom Singularity enabled", tip = "Rotation will use Phantom Singularity.", highlight = 1, icon = br.player.spell.phantomSingularity},
        [2] = { mode = "Off", value = 2 , overlay = "Phantom Singularity diabled", tip = "Phantom Singularity diabled.", highlight = 0, icon = br.player.spell.phantomSingularity}
    };
    CreateButton("PS",5,0)
-- Seed of Corruption Button
    SeedModes = {
        [1] = { mode = "On", value = 1 , overlay = "Seed of Corruption enabled", tip = "Rotation will use Seed of Corruption.", highlight = 1, icon = br.player.spell.seedOfCorruption},
        [2] = { mode = "Off", value = 2 , overlay = "Seed of Corruption diabled", tip = "Seed of Corruption diabled.", highlight = 0, icon = br.player.spell.seedOfCorruption}
    };
    CreateButton("Seed",6,0)
end

-- Colors
local cPurple   = "|cffC942FD"
local cBlue     = "|cff00CCFF"
local cGreen    = "|cff00FF00"
local cRed      = "|cffFF0000"
local cWhite    = "|cffFFFFFF"
local cGold     = "|cffFFDD11"
local cLegendary= "|cffff8000"


-- Always				Will use the ability even if CDs are disabled.
-- Always Boss			Will use the ability even if CDs are disabled as long as the current target is a Boss.
-- OnCooldown			Will only use the ability if the Cooldown Toggle is Enabled.
-- OnCooldown Boss		Will only use the ability if the Cooldown Toggle is Enabled and Target is a Boss.

--createDropdown(parent, text, itemlist, default, tooltip, tooltipDrop, hideCheckbox)
function br.ui:createCDOption(parent, text, tooltip, hideCheckbox)
	local cooldownModes = {"Always", "Always Boss", "OnCooldown", "OnCooldown Boss"}
	local tooltipDrop = cPurple.."Always"..cWhite..": Will only use the ability even if the Cooldown Toggle is "..cRed.."Disabled"..cWhite..[[. 
]]..cPurple.."Always Boss"..cWhite..": Will only use the ability even if the Cooldown Toggle is "..cRed.."Disabled"..cWhite.." as long as the current target is a Boss"..[[. 
]]..cPurple.."OnCooldown"..cWhite..": Will only use the ability if the Cooldown Toggle is "..cGreen.."Enabled"..cWhite..[[. 
]]..cPurple.."OnCooldown Boss"..cWhite..": Will only use the ability if the Cooldown Toggle is "..cGreen.."Enabled"..cWhite.." and Target is a Boss."
	br.ui:createDropdown(parent, text, cooldownModes, 3, tooltip, tooltipDrop, hideCheckbox)
end

---------------
--- OPTIONS ---
---------------
local function createOptions ()
	local optionTable

	local function rotationOptions ()
		-----------------------
		--- GENERAL OPTIONS ---
		-----------------------
		section = br.ui:createSection(br.ui.window.profile,  "General")
			-- Opener
			br.ui:createCheckbox(section, "Opener", "Perform the opener.", true)
			-- Pre-Pull Timer
			br.ui:createSpinner(section, "Pre-Pull Timer", 2, 0, 10, 0.1, "Set desired time offset to opener (DBM Required). Min: 0 / Max: 10 / Interval: 0.1", nil, true)
		br.ui:checkSectionState(section)
		-------------------------
        --- OFFENSIVE OPTIONS ---
        -------------------------
		section = br.ui:createSection(br.ui.window.profile,  "Offensive")
			-- Agi Pot
			br.ui:createCheckbox(section, "Intellect-Potion", "Use Battle Potion of Intellect while Bloodlust is up")
            -- Racial
			br.ui:createCDOption(section, "Racial", "Use Racial")
			-- Trinkets
			br.ui:createCDOption(section, "Trinket 1", "Use of Trinket 1")
			br.ui:createCDOption(section, "Trinket 2", "Use of Trinket 2")
			-- Darkglare
			br.ui:createCDOption(section, "Darkglare", "Use of Darkglare")
			-- Dark Soul
			br.ui:createCDOption(section, "Dark Soul", "Use Dark Soul: Misery")
			-- Drain Life Trait
			br.ui:createCheckbox(section, "Drain Life Trait", "Use Drain Life automatically if enough stacks")
			-- Spread agony on single target
			br.ui:createSpinner(section, "Spread Agony on ST", 3, 1, 15, 1, "Check to spread Agony when running in single target", "The amont of additionally running Agony. Standard is 3")
			-- Seed of Corruption
			br.ui:createDropdown(section, "Seed Target", {"Target", "Best"},  1, "Seed of Corruption Target", "Seed of Corruption Target", true)
			br.ui:createCheckbox(section, "Seed on ST", "Check to use Seed of Corruption when running in single target")
			-- No Dot units
			br.ui:createCheckbox(section, "Dot Blacklist", "Ignore certain units for dots")
			-- UA Shards
			br.ui:createSpinner(section, "UA Shards", 5, 1, 5, 1, nil, "Use UA on Shards", true)
			-- Max Dots
			br.ui:createSpinner(section, "Agony Count", 8, 1, 15, 1, nil, "The maximum amount of running Agony. Standard is 8", true)
			br.ui:createSpinner(section, "Corruption Count", 8, 1, 15, 1, nil, "The maximum amount of running Corruption. Standard is 8", true)
			br.ui:createSpinner(section, "Siphon Life Count", 8, 1, 15, 1, nil, "The maximum amount of running Siphon Life. Standard is 8", true)
        br.ui:checkSectionState(section)
		-------------------------
		--- DEFENSIVE OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Defensive")
			-- Healing Potion
			br.ui:createSpinner(section, "Healing Potion", 25, 0, 100, 5, "Health Percentage to use at.")
			-- Healthstone
			br.ui:createSpinner(section, "Healthstone", 50, 0, 100, 5, "Health Percentage to use at.")
			-- Dark Pact
			br.ui:createSpinner(section, "Dark Pact", 50, 0, 100, 5, "Health Percent to Cast At")
			-- Unending Resolve
            br.ui:createSpinner(section, "Unending Resolve", 25, 0, 100, 5, "Health Percent to Cast At")
		br.ui:checkSectionState(section)
		-------------------------
		--- INTERRUPT OPTIONS ---
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, "Interrupts")
			-- Interrupt Percentage
			br.ui:createSpinner(section, "InterruptAt", 0, 0, 90, 10, "Cast Percentage to use at.")	
		br.ui:checkSectionState(section)
		----------------------
		--- TOGGLE OPTIONS ---
		----------------------
		section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
			-- Single/Multi Toggle
			br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
			--Cooldown Key Toggle
			br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
			--Defensive Key Toggle
			br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
			-- Interrupts Key Toggle
			br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
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
local function runRotation ()
	if br.timer:useTimer("debugAffliction", 0.1) then --change "debugFury" to "debugSpec" (IE: debugFire)
		--Print("Running: "..rotationName)

		---------------
		--- Toggles --- -- List toggles here in order to update when pressed
		---------------
		UpdateToggle("Rotation",0.25)
		UpdateToggle("Cooldown",0.25)
		UpdateToggle("Defensive",0.25)
		UpdateToggle("Interrupt",0.25)
		br.player.ui.mode.ps = br.data.settings[br.selectedSpec].toggles["PS"]
		br.player.ui.mode.seed = br.data.settings[br.selectedSpec].toggles["Seed"]
		
		--------------
		--- Locals ---
        --------------
		local agonyCount                                        = br.player.debuff.agony.count()
		local agonyTick											= hasEquiped(132394) and 2 * 0.9 or 2 / (1 + (GetHaste()/100))
		local buff												= br.player.buff
		local canAttackTarget									= UnitCanAttack("target","player")
		local cast												= br.player.cast
		local combatTime										= getCombatTime()
		local corruptionCount									= br.player.debuff.corruption.count()
		local corruptionTick 									= 2 / (1 + (GetHaste()/100))
		local cd												= br.player.cd
		local charges											= br.player.charges
		local debuff											= br.player.debuff
		local drainLifeTime										= (5 / (1 + (GetHaste()/100)))
		local enemies											= br.player.enemies
		local falling, swimming, flying, moving					= getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
		local gcd												= br.player.gcd
		local healPot											= getHealthPot()
		local inCombat											= UnitAffectingCombat("player")
		local inInstance										= br.player.instance=="party"
		local inRaid											= br.player.instance=="raid"
        local lastCast                                          = br.lastCast.tracker
        local level												= br.player.level
        local mode												= br.player.ui.mode
		local moving                                            = isMoving("player") ~= false or br.player.moving
		local padding													= padding or gcd
		local perk												= br.player.perk		
		local php												= br.player.health
		local energy, energyDeficit, energyRegen               	= br.player.power.energy.amount(), br.player.power.energy.deficit(), br.player.power.energy.regen()
		local pullTimer                                     	= PullTimerRemain()
		local race												= br.player.race
        local racial											= br.player.getRacial()
		--if not shards then shards = UnitPower("player", Enum.PowerType.SoulShards) end
		local shards											= shards or UnitPower("player", Enum.PowerType.SoulShards)
		local siphonLifeCount                                   = br.player.debuff.siphonLife.count()
		local siphonLifeTick 									= 3 / (1 + (GetHaste()/100))
		local spell												= br.player.spell
		local spell_haste 										= 1 / (1 + (GetHaste()/100))
		local talent											= br.player.talent
		local time_to_shard										= time_to_shard or 10000
		local traits                                        	= br.player.traits
		local ttd                                           	= getTTD
		local units												= br.player.units
		local use_seed											= use_seed or false
        local validTarget                                   	= isValidUnit("target")
        
        local agonyDuration                                     = 18
        local corruptionDuration                                = 14
        local siphonLifeDuration                                = 15
		
		if vanishTime == nil then vanishTime = GetTime() end
		if leftCombat == nil then leftCombat = GetTime() end
		if profileStop == nil then profileStop = false end


		--local enemies8											= enemies.get(8)
		--local enemies8num 										= #enemies8
		
		--units.get(5)
		--units.get(8)
		--units.get(30)
        --enemies.get(5)
        --enemies.get(8)
        --enemies.get(10, "player", true) -- nocombat
		--enemies.get(20)
		--enemies.get(20, "player", true) -- nocombat
		--enemies.get(30)
		enemyTable40 = enemies.get(40)
		enemies40num										= #enemyTable40


		-- actions+=/variable,name=padding,op=reset,value=gcd,if=azerite.cascading_calamity.enabled&(talent.drain_soul.enabled|talent.deathbolt.enabled&cooldown.deathbolt.remains<=gcd)
		if traits.cascadingCalamity.active and (talent.drainSoul or talent.deathbolt and cd.deathbolt.remain() <= gcd) then
			padding = gcd
		end
		-- actions+=/variable,name=padding,op=set,value=action.shadow_bolt.execute_time*azerite.cascading_calamity.enabled
		padding = cast.time.shadowBolt() * (traits.cascadingCalamity.active and 1 or 0)



		------------------------------
		--- Raven Shared Functions ---
		------------------------------

        --- line_cd can be used to force a length of time, in seconds, to pass after executing an action before it can be executed again. In the example below, the second line can execute even while the first line is being delayed because of line_cd.
		-- @return false if spell was cast within the given period
		local function Line_cd (spellid, seconds)
			if br.lastCast.line_cd then
				if br.lastCast.line_cd[spellid] then
					if br.lastCast.line_cd[spellid] + seconds >= GetTime() then
						return false
					end
				end
			end
			return true
		end

		--- See if the current unit is really a boss
		-- @return Wether the boss is a boss1-2-3-4-5
		local function isTargetUnitEqualBossFrameUnit_local (thisUnit)
			if isDummy() then return true end
			return UnitIsUnit(thisUnit, "Boss1") or UnitIsUnit(thisUnit, "Boss2") or UnitIsUnit(thisUnit, "Boss3") or UnitIsUnit(thisUnit, "Boss4") or UnitIsUnit(thisUnit, "Boss5")
		end

		--- Get whether the unit is a boss.
		local function isBoss_local (thisUnit)
			if thisUnit == nil then thisUnit = "target" end
			if isValidUnit(thisUnit) then
				-- Check if the target is boss1 - boss5
				if isTargetUnitEqualBossFrameUnit_local(thisUnit) then return true end
				-- check classic isBoss()
				if isBoss(thisUnit) then return true end
			end
			return false
		end
		
		-- Future use for exception on several boss phases/debuffs/etc
		function CooldownsAllowed ()
			return isBoss_local()
		end

		--- Check Cooldown toggle value and if unit is a boss
		local function useCDs_local ()
			local cooldown = mode.cooldown
			if cooldown == 1 and isDummy() then return true end
			-- 1 = auto, 2 = on, 3 = off
			return (cooldown == 1 and isBoss_local("target")) or (cooldown == 2 and hasBloodLust())
		end
		
		function CDOptionEnabled (OptionName)
			local OptionValue = getOptionValue(OptionName)
			-- Always				Will use the ability even if CDs are disabled.
			-- Always Boss			Will use the ability even if CDs are disabled as long as the current target is a Boss.
			-- OnCooldown			Will only use the ability if the Cooldown Toggle is Enabled.
			-- OnCooldown Boss		Will only use the ability if the Cooldown Toggle is Enabled and Target is a Boss.
			if isChecked(OptionName) then
				if OptionValue == 1 then
					return true
				end
				if OptionValue == 2 then
					return isBoss_local()
				end
				if OptionValue == 3 then
					return mode.cooldown == 1
				end
				if OptionValue == 4 then
					return mode.cooldown == 1 and isBoss_local()
				end
			end
		end
			
			
		-------------------------
		--- Profile Functions ---
		-------------------------

		if debuff.unstableAffliction == nil then debuff.unstableAffliction = {} end

		function debuff.unstableAffliction.stack(unit)
			local uaStack = 0
			if unit == nil then
				if GetUnitExists("target") then unit = "target"
				else unit = units.dyn40
				end
			end
			for i=1,40 do
				local _,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitDebuff(unit,i)
				if (buffSpellID == 233490 or buffSpellID == 233496 or buffSpellID == 233497 or
				buffSpellID == 233498 or buffSpellID == 233499) and GetUnitIsUnit(buffCaster, "player") then uaStack = uaStack + 1 end
			end
			return uaStack
		end

		function debuff.unstableAffliction.remain(unit)
			local remain = 0
			if unit == nil then
				if GetUnitExists("target") then unit = "target"
				else unit = units.dyn40
				end
			end
			for i=1,40 do
				local _,_,_,_,_,buffExpire,buffCaster,_,_,buffSpellID = UnitDebuff(unit,i)
				if (buffSpellID == 233490 or buffSpellID == 233496 or buffSpellID == 233497 or
				buffSpellID == 233498 or buffSpellID == 233499) and GetUnitIsUnit(buffCaster, "player") then
					if (buffExpire - GetTime()) > remain then remain = (buffExpire - GetTime()) end
				end
			end
			return remain
		end
		
		time_to_shard = agonyCount == 0 and 10000 or (1 / (0.16 / math.sqrt(agonyCount) * (agonyCount == 1 and 1.15 or 1) * agonyCount / agonyTick))


		function SeedTravelTime(thisUnit)
			return getDistance(thisUnit) / 30
		end
        
        seedTarget = seedTarget or "target"
        -- local dsTarget
        local seedHit = 0
        local seedCorruptionExist = 0
        seedTargetCorruptionExist = 0
        seedTargetsHit = 1
        -- local lowestShadowEmbrace = lowestShadowEmbrace or "target"
    
		local inBossFight = false
		
		if getOptionValue("Seed Target") == 1 then 
			seedTarget = "target"
			if mode.rotation<=2 or mode.rotation==3 and isChecked("Seed on ST") then
				if mode.seed == 1 and getFacing("player",seedTarget,180) and ttd(seedTarget) > 8 then
					seedTargetsHit = #getEnemies(seedTarget, 9, true)
				end
			end
		end
		
		
		if getOptionValue("Seed Target") == 2 then 
			for i = 1, #enemies.yards40 do
				local thisUnit = enemies.yards40[i]
				if isBoss(thisUnit) then
					inBossFight = true
				end
				-- if talent.shadowEmbrace and debuff.shadowEmbrace.exists(thisUnit) then
				--     if debuff.shadowEmbrace.exists(lowestShadowEmbrace) then
				--         shadowEmbraceRemaining = debuff.shadowEmbrace.remain(lowestShadowEmbrace)
				--     else
				--         shadowEmbraceRemaining = 40
				--     end
				--     if debuff.shadowEmbrace.remain(thisUnit) < shadowEmbraceRemaining then
				--         lowestShadowEmbrace = thisUnit
				--     end
				-- end
				local unitAroundUnit = getEnemies(thisUnit, 9, true)
				if mode.rotation<=2 or mode.rotation==3 and isChecked("Seed on ST") then
					if mode.seed == 1 and getFacing("player",thisUnit,180) and #unitAroundUnit > seedTargetsHit and ttd(thisUnit) > 8 then
						seedHit = 0
						seedCorruptionExist = 0
						for q = 1, #unitAroundUnit do
							local seedAoEUnit = unitAroundUnit[q]
							if ttd(seedAoEUnit) > cast.time.seedOfCorruption()+3 then seedHit = seedHit + 1 end
							if debuff.corruption.exists(seedAoEUnit) then seedCorruptionExist = seedCorruptionExist + 1 end
						end
						if seedHit > seedTargetsHit or (GetUnitIsUnit(thisUnit, "target") and seedHit >= seedTargetsHit) then
							seedTarget = thisUnit
							seedTargetsHit = seedHit
							seedTargetCorruptionExist = seedCorruptionExist
						end
					end
				end
				-- if getFacing("player",thisUnit) and ttd(thisUnit) <= gcd and getHP(thisUnit) < 80 then
				--     dsTarget = thisUnit
				-- end
			end
		end
		
		use_seed = (talent.sowTheSeeds and seedTargetsHit >= 3 or talent.siphonLife and seedTargetsHit >= 5 or seedTargetsHit >= 8) and true or false


        local function isTotem(unit)
            local eliteTotems = { -- totems we can dot
                [125977] = "Reanimate Totem",
                [127315] = "Reanimate Totem",
                [146731] = "Zombie Dust Totem"
            }
            local creatureType = UnitCreatureType(unit)
            local objectID = GetObjectID(unit)
            if creatureType ~= nil and eliteTotems[objectID] == nil then
                if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then return true end
            end
            return false
        end

        -- Blacklist dots
		local noDotUnits = {
			[135824]=true, -- Nerubian Voidweaver
			[139057]=true, -- Nazmani Bloodhexer
			[129359]=true, -- Sawtooth Shark
			[129448]=true, -- Hammer Shark
			[134503]=true, -- Silithid Warrior
			[137458]=true, -- Rotting Spore
			[139185]=true, -- Minion of Zul
			[120651]=true, -- Explosive
		}
		local function noDotCheck(unit)
			if isChecked("Dot Blacklist") and (noDotUnits[GetObjectID(unit)] or UnitIsCharmed(unit)) then return true end
			if isTotem(unit) then return true end
			unitCreator = UnitCreator(unit)
			if unitCreator ~= nil and UnitIsPlayer(unitCreator) ~= nil and UnitIsPlayer(unitCreator) == true then return true end
			--if GetObjectID(unit) == 137119 and getBuffRemain(unit, 271965) > 0 then return true end
			return false
		end





		--------------------
		--- Action Lists ---
		--------------------

		local function actionList_cooldowns ()
			-- actions.cooldowns=potion,if=(talent.dark_soul_misery.enabled&cooldown.summon_darkglare.up&cooldown.dark_soul.up)|cooldown.summon_darkglare.up|target.time_to_die<30
			-- actions.cooldowns+=/use_items,if=!cooldown.summon_darkglare.up,if=cooldown.summon_darkglare.remains>70|time_to_die<20|((buff.active_uas.stack=5|soul_shard=0)&(!talent.phantom_singularity.enabled|cooldown.phantom_singularity.remains)&(!talent.deathbolt.enabled|cooldown.deathbolt.remains<=gcd|!cooldown.deathbolt.remains)&!cooldown.summon_darkglare.remains)
			if cd.summonDarkglare.remain() > 0 then
				if canUseItem(13) and CDOptionEnabled("Trinket 1") and not hasEquiped(165572, 13) then
					if useItem(13) then return true end
				end
				if canUseItem(14) and CDOptionEnabled("Trinket 2") and not hasEquiped(165572, 14) then
					if useItem(14) then return true end
				end
			end
            -- actions.cooldowns+=/fireblood,if=!cooldown.summon_darkglare.up
            -- actions.cooldowns+=/blood_fury,if=!cooldown.summon_darkglare.up
		end

		local function actionList_Defensive ()
			if useDefensive() then
				-- Healthstone
				if isChecked("Healthstone") and php <= getOptionValue("Healthstone") and inCombat and hasItem(5512) then
					if canUseItem(5512) then useItem(5512) return true end
				end
				-- Health Pot
				if isChecked("Healing Potion") and php <= getOptionValue("Healing Potion") and inCombat and hasHealthPot() then
					if canUseItem(healPot) then useItem(healPot) return true end
				end

				-- Dark Pact
				if isChecked("Dark Pact") and php <= getOptionValue("Dark Pact") then
					if cast.darkPact() then return true end
				end
				-- Unending gResolve
				if isChecked("Unending Resolve") and php <= getOptionValue("Unending Resolve") and inCombat then
					if cast.unendingResolve() then return true end
				end
			end
		end -- End Action List - Defensive

		local function actionList_db_refresh ()
			-- actions.db_refresh=siphon_life,line_cd=15,if=(dot.siphon_life.remains%dot.siphon_life.duration)<=(dot.agony.remains%dot.agony.duration)&(dot.siphon_life.remains%dot.siphon_life.duration)<=(dot.corruption.remains%dot.corruption.duration)&dot.siphon_life.remains<dot.siphon_life.duration*1.3
			if Line_cd(spell.siphonLife,15) and not noDotCheck("target") then
				if (debuff.siphonLife.remain() / 15) <= (debuff.agony.remain() / 18) and (debuff.siphonLife.remain() / 15) <= (debuff.corruption.remain() / 14) and debuff.siphonLife.remain() < 19.5 then
					if cast.able.siphonLife() then
						if cast.siphonLife() then return true end
					end
				end
			end
			-- actions.db_refresh+=/agony,line_cd=15,if=(dot.agony.remains%dot.agony.duration)<=(dot.corruption.remains%dot.corruption.duration)&(dot.agony.remains%dot.agony.duration)<=(dot.siphon_life.remains%dot.siphon_life.duration)&dot.agony.remains<dot.agony.duration*1.3
			if Line_cd(spell.agony, 15) and not noDotCheck("target") then
				if (debuff.agony.remain() / 18) <= (debuff.corruption.remain() / 14) and (debuff.agony.remain() / 18) <= (debuff.siphonLife.remain() / 15) and debuff.agony.remain() < 23.4 then
					if cast.able.agony() then
						if cast.agony() then return true end
					end
				end
			end
			-- actions.db_refresh+=/corruption,line_cd=15,if=(dot.corruption.remains%dot.corruption.duration)<=(dot.agony.remains%dot.agony.duration)&(dot.corruption.remains%dot.corruption.duration)<=(dot.siphon_life.remains%dot.siphon_life.duration)&dot.corruption.remains<dot.corruption.duration*1.3
			if Line_cd(spell.corruption, 15) and not noDotCheck("target") then
				if (debuff.corruption.remain() / 14) <= (debuff.agony.remain() / 18) and (debuff.corruption.remain() / 14) <= (debuff.siphonLife.remain() / 15) and debuff.corruption.remain() < 18.2 then
					if cast.able.corruption() then
						if cast.corruption() then return true end
					end
				end
			end
		end

		local function actionList_dots ()
			-- actions.dots=seed_of_corruption,if=dot.corruption.remains<=action.seed_of_corruption.cast_time+time_to_shard+4.2*(1-talent.creeping_death.enabled*0.15)&spell_targets.seed_of_corruption_aoe>=3+raid_event.invulnerable.up+talent.writhe_in_agony.enabled&!dot.seed_of_corruption.remains&!action.seed_of_corruption.in_flight
			if (debuff.corruption.remain() <= cast.time.seedOfCorruption() + SeedTravelTime(thisUnit) + (debuff.agony.stack(seedTarget) > 7 and 2*gcd or 4.2))
				and seedTargetsHit >= 3 --[[ + raid_event.invulnerable.up ]] + (talent.writheInAgony and 1 or 0) 
				and debuff.seedOfCorruption.count() == 0 
				and not cast.last.seedOfCorruption() then
				if cast.able.seedOfCorruption() then
					if cast.seedOfCorruption(seedTarget) then return true end
				end
			end
			-- actions.dots+=/agony,target_if=min:remains,if=talent.creeping_death.enabled&active_dot.agony<6&target.time_to_die>10&(remains<=gcd|cooldown.summon_darkglare.remains>10&(remains<5|!azerite.pandemic_invocation.rank&refreshable))
			if talent.creepingDeath and agonyCount < getOptionValue("Agony Count") then
				-- target
				if not noDotCheck("target") and ttd("target") > 10 and (debuff.agony.remain("target") <= gcd or cd.summonDarkglare.remain() > 10 and (debuff.agony.remain("target") < 5 or not traits.pandemicInvocation.active and debuff.agony.remain("target") <= 5.4)) then
					if cast.able.agony() then
						if cast.agony("target") then return true end
					end
				end
				-- maintain
				if mode.rotation==1
					or mode.rotation==2
					or mode.rotation==3 and isChecked("Spread Agony on ST") and agonyCount <= 1+getOptionValue("Spread Agony on ST") then
					for i = 1, #enemyTable40 do
						local thisUnit = enemyTable40[i]
						local agonyRemain = debuff.agony.remain(thisUnit)
						if agonyRemain > 0 and not noDotCheck(thisUnit) and (ttd(thisUnit) > 10 and (--[[ agonyRemain <= gcd or ]] cd.summonDarkglare.remain() > 10 and (agonyRemain < 5 or not traits.pandemicInvocation.active and agonyRemain <= 5.4))) then
							-- if not noDotCheck(thisUnit) then
								if cast.able.agony() then
									if cast.agony(thisUnit) then return true end
								end
							-- end
						end
					end
				end
				-- cycle
				-- 1 = Auto, 2 = Mult, 3 = Sing, 4 = Off
				if mode.rotation==1
					or mode.rotation==2
					or mode.rotation==3 and isChecked("Spread Agony on ST") and agonyCount < 1+getOptionValue("Spread Agony on ST") then
					for i = 1, #enemyTable40 do
						local thisUnit = enemyTable40[i]
						local agonyRemain = debuff.agony.remain(thisUnit)
						if ttd(thisUnit) > 10 and not noDotCheck(thisUnit) and (--[[ agonyRemain <= gcd or ]] cd.summonDarkglare.remain() > 10 and (agonyRemain < 5 or not traits.pandemicInvocation.active and agonyRemain <= 5.4)) then
							-- if not noDotCheck(thisUnit) then
								if cast.able.agony() then
									if cast.agony(thisUnit) then return true end
								end
							-- end
						end
					end
				end
			end
			-- actions.dots+=/agony,target_if=min:remains,if=!talent.creeping_death.enabled&active_dot.agony<8&target.time_to_die>10&(remains<=gcd|cooldown.summon_darkglare.remains>10&(remains<5|!azerite.pandemic_invocation.rank&refreshable))
			if not talent.creepingDeath and agonyCount <= getOptionValue("Agony Count") then
				-- target
				if ttd(thisUnit) > 10 and not noDotCheck("target") and (debuff.agony.remain("target") <= gcd or (cd.summonDarkglare.remain() > 10 or not CDOptionEnabled("Darkglare")) and (debuff.agony.remain("target") <= 5.4 or not traits.pandemicInvocation.active and debuff.agony.remain("target") <= 5.4)) then
					if cast.able.agony() then
						if cast.agony("target") then return true end
					end
				end
				-- maintain
				if mode.rotation==1
					or mode.rotation==2
					or mode.rotation==3 and isChecked("Spread Agony on ST") and agonyCount <= 1+getOptionValue("Spread Agony on ST") then
					for i = 1, #enemyTable40 do
						local thisUnit = enemyTable40[i]
						local agonyRemain = debuff.agony.remain(thisUnit)
						if agonyRemain > 0 and not noDotCheck(thisUnit) and (--[[ agonyRemain <= gcd or ]] (cd.summonDarkglare.remain() > 10 or not CDOptionEnabled("Darkglare")) and (agonyRemain <= 5.4 or not traits.pandemicInvocation.active and agonyRemain <= 5.4)) then
							-- if not noDotCheck(thisUnit) then
								if cast.able.agony() then
									if cast.agony(thisUnit) then return true end
								end
							-- end
						end
					end
				end
				-- cycle
				if mode.rotation==1
					or mode.rotation==2
					or mode.rotation==3 and isChecked("Spread Agony on ST") and agonyCount < 1+getOptionValue("Spread Agony on ST") then
					for i = 1, #enemyTable40 do
						local thisUnit = enemyTable40[i]
						local agonyRemain = debuff.agony.remain(thisUnit)
						if ttd(thisUnit) > 10 and not noDotCheck(thisUnit) and (--[[ agonyRemain <= gcd or ]] (cd.summonDarkglare.remain() > 10 or not CDOptionEnabled("Darkglare")) and (agonyRemain <= 5.4 or not traits.pandemicInvocation.active and agonyRemain <= 5.4)) then
							-- if not noDotCheck(thisUnit) then
								if cast.able.agony() then
									if cast.agony(thisUnit) then return true end
								end
							-- end
						end
					end
				end
			end
			-- actions.dots+=/siphon_life,target_if=min:remains,if=(active_dot.siphon_life<8-talent.creeping_death.enabled-spell_targets.sow_the_seeds_aoe)&target.time_to_die>10&refreshable&(!remains&spell_targets.seed_of_corruption_aoe=1|cooldown.summon_darkglare.remains>soul_shard*action.unstable_affliction.execute_time)
			if (siphonLifeCount < getOptionValue("Siphon Life Count") - (talent.creepingDeath and 1 or 0) - seedTargetsHit) then
				-- target
				if ttd("target") > 10 and not noDotCheck("target") and debuff.siphonLife.remain("target") <= 4.5 and (not debuff.siphonLife.exists("target") and seedTargetsHit==1 or ((cd.summonDarkglare.remain() > shards * cast.time.unstableAffliction()) or not CDOptionEnabled("Darkglare"))) then
					if cast.able.siphonLife() then
						if cast.siphonLife("target") then return true end
					end
				end
			end
			if (siphonLifeCount <= getOptionValue("Siphon Life Count") - (talent.creepingDeath and 1 or 0) - seedTargetsHit) then
				-- maintain
				if mode.rotation==1 or mode.rotation==2 then
					for i = 1, #enemyTable40 do
						local thisUnit = enemyTable40[i]
						local siphonLifeRemain = debuff.siphonLife.remain(thisUnit)
						if siphonLifeRemain > 0 and not noDotCheck(thisUnit) and (ttd(thisUnit) > 10 and siphonLifeRemain <= 4.5 and (not debuff.siphonLife.exists(thisUnit) and seedTargetsHit==1 or ((cd.summonDarkglare.remain() > shards * cast.time.unstableAffliction()) or not CDOptionEnabled("Darkglare")))) then
							-- if not noDotCheck(thisUnit) then
								if cast.able.siphonLife() then
									if cast.siphonLife(thisUnit) then return true end
								end
							-- end
						end
					end
				end
			end
			if (siphonLifeCount < getOptionValue("Siphon Life Count") - (talent.creepingDeath and 1 or 0) - seedTargetsHit) then
				-- cycle
				if mode.rotation==1 or mode.rotation==2 then
					for i = 1, #enemyTable40 do
						local thisUnit = enemyTable40[i]
						local siphonLifeRemain = debuff.siphonLife.remain(thisUnit)
						if ttd(thisUnit) > 10 and not noDotCheck(thisUnit) and siphonLifeRemain <= 4.5 and (not debuff.siphonLife.exists(thisUnit) and seedTargetsHit==1 or ((cd.summonDarkglare.remain() > shards * cast.time.unstableAffliction()) or not CDOptionEnabled("Darkglare"))) then
							-- if not noDotCheck(thisUnit) then
								if cast.able.siphonLife() then
									if cast.siphonLife(thisUnit) then return true end
								end
							-- end
						end
					end
				end
			end
			-- actions.dots+=/corruption,cycle_targets=1,if=spell_targets.seed_of_corruption_aoe<3+raid_event.invulnerable.up+talent.writhe_in_agony.enabled&(remains<=gcd|cooldown.summon_darkglare.remains>10&refreshable)&target.time_to_die>10
			-- target
			if seedTargetsHit < 3 --[[ + raid_event.invulnerable.up ]] + (talent.writheInAgony and 1 or 0) then
				if not noDotCheck("target") and (debuff.corruption.remain("target") <= gcd or (cd.summonDarkglare.remain() > 10 or not CDOptionEnabled("Darkglare")) and debuff.corruption.remain("target") <= 4.2) and ttd("target") > 10 then
					if cast.able.corruption() then
						if cast.corruption("target") then return true end
					end
				end
			end
			-- maintain
			if mode.rotation==1 or mode.rotation==2 then
				if corruptionCount <= getOptionValue("Corruption Count") then
					if seedTargetsHit < 3 --[[ + raid_event.invulnerable.up ]] + (talent.writheInAgony and 1 or 0) then
						for i = 1, #enemyTable40 do
							local thisUnit = enemyTable40[i]
							local corruptionRemain = debuff.corruption.remain(thisUnit)
							if corruptionRemain > 0 and not noDotCheck(thisUnit) and ((--[[ corruptionRemain <= gcd or ]] (cd.summonDarkglare.remain() > 10 or not CDOptionEnabled("Darkglare")) and corruptionRemain <= 4.2) and ttd(thisUnit) > 10) then
								-- if not noDotCheck(thisUnit) then
									if cast.able.corruption() then
										if cast.corruption(thisUnit) then return true end
									end
								-- end
							end
						end
					end
				end
			end
			-- cycle
			if mode.rotation==1 or mode.rotation==2 then
				if corruptionCount < getOptionValue("Corruption Count") then
					if seedTargetsHit < 3 --[[ + raid_event.invulnerable.up ]] + (talent.writheInAgony and 1 or 0) then
						for i = 1, #enemyTable40 do
							local thisUnit = enemyTable40[i]
							local corruptionRemain = debuff.corruption.remain(thisUnit)
							if not noDotCheck(thisUnit) and (--[[ corruptionRemain <= gcd or ]] (cd.summonDarkglare.remain() > 10 or not CDOptionEnabled("Darkglare")) and corruptionRemain <= 4.2) and ttd(thisUnit) > 10 then
								-- if not noDotCheck(thisUnit) then
									if cast.able.corruption() then
										if cast.corruption(thisUnit) then return true end
									end
								-- end
							end
						end
					end
				end
			end
        end
        
        local function actionList_fillers ()
			-- actions.fillers=unstable_affliction,line_cd=15,if=cooldown.deathbolt.remains<=gcd*2&spell_targets.seed_of_corruption_aoe=1+raid_event.invulnerable.up&cooldown.summon_darkglare.remains>20
			if Line_cd(spell.unstableAffliction,15) and cd.deathbolt.remain() <= gcd * 2 and seedTargetsHit > 1 and cd.summonDarkglare.remain() > 20 then
				if cast.able.unstableAffliction() then
					if cast.unstableAffliction() then return true end
				end
			end
			-- actions.fillers+=/call_action_list,name=db_refresh,if=talent.deathbolt.enabled&spell_targets.seed_of_corruption_aoe=1+raid_event.invulnerable.up&(dot.agony.remains<dot.agony.duration*0.75|dot.corruption.remains<dot.corruption.duration*0.75|dot.siphon_life.remains<dot.siphon_life.duration*0.75)&cooldown.deathbolt.remains<=action.agony.gcd*4&cooldown.summon_darkglare.remains>20
			if talent.deathbolt and seedTargetsHit == 1 and (debuff.agony.remain() < agonyDuration * 0.75 or debuff.corruption.remain() < corruptionDuration * 0.75 or debuff.siphonLife.remain() < siphonLifeDuration * 0.75) and cd.deathbolt.remain() <= gcd * 4 and cd.summonDarkglare.remain() > 20 then
				if actionList_db_refresh() then return true end
			end
			-- actions.fillers+=/call_action_list,name=db_refresh,if=talent.deathbolt.enabled&spell_targets.seed_of_corruption_aoe=1+raid_event.invulnerable.up&cooldown.summon_darkglare.remains<=soul_shard*action.agony.gcd+action.agony.gcd*3&(dot.agony.remains<dot.agony.duration*1|dot.corruption.remains<dot.corruption.duration*1|dot.siphon_life.remains<dot.siphon_life.duration*1)
			if talent.deathbolt and seedTargetsHit == 1 and cd.summonDarkglare.remain() <= shards * gcd + gcd * 3 and (debuff.agony.remain() < agonyDuration * 1 or debuff.corruption.remain() < corruptionDuration * 1 or debuff.siphonLife.remain() < siphonLifeDuration * 1) then
				if actionList_db_refresh() then return true end
			end
			-- actions.fillers+=/deathbolt,if=cooldown.summon_darkglare.remains>=30+gcd|cooldown.summon_darkglare.remains>140
			if talent.deathbolt then 
				if (cd.summonDarkglare.remain() >= 30 + gcd) or (cd.summonDarkglare.remain() > 140) then
					if cast.able.deathbolt() then
						if cast.deathbolt() then return true end
					end
				end
			end
			-- actions.fillers+=/shadow_bolt,if=buff.movement.up&buff.nightfall.remains
			if talent.nightfall and moving and buff.nightfall.exists() then
				if cast.able.shadowBolt() then
					if cast.shadowBolt() then return true end
				end
			end
			-- actions.fillers+=/agony,if=buff.movement.up&!(talent.siphon_life.enabled&(prev_gcd.1.agony&prev_gcd.2.agony&prev_gcd.3.agony)|prev_gcd.1.agony)
			if moving and not noDotCheck("target") and (not ((talent.siphonLife and (cast.last.agony(1) or cast.last.agony(2) or cast.last.agony(3))) or not talent.siphonLife and cast.last.agony(1)) or talent.absoluteCorruption) then
				if cast.able.agony() then
					if cast.agony() then return true end
				end
			end
			-- actions.fillers+=/siphon_life,if=buff.movement.up&!(prev_gcd.1.siphon_life&prev_gcd.2.siphon_life&prev_gcd.3.siphon_life)
			if moving and not noDotCheck("target") and not (cast.last.siphonLife()) then
				if cast.able.siphonLife() then
					if cast.siphonLife() then return true end
				end
			end
			-- actions.fillers+=/corruption,if=buff.movement.up&!prev_gcd.1.corruption&!talent.absolute_corruption.enabled
			if moving and not noDotCheck("target") and not cast.last.corruption() and (not talent.absoluteCorruption or not debuff.corruption.exists()) then
				if cast.able.corruption() then
					if cast.corruption() then return true end
				end
			end
			-- actions.fillers+=/drain_life,if=(buff.inevitable_demise.stack>=40-(spell_targets.seed_of_corruption_aoe-raid_event.invulnerable.up>2)*20&(cooldown.deathbolt.remains>execute_time|!talent.deathbolt.enabled)&(cooldown.phantom_singularity.remains>execute_time|!talent.phantom_singularity.enabled)&(cooldown.dark_soul.remains>execute_time|!talent.dark_soul_misery.enabled)&(cooldown.vile_taint.remains>execute_time|!talent.vile_taint.enabled)&cooldown.summon_darkglare.remains>execute_time+10|buff.inevitable_demise.stack>10&target.time_to_die<=10)
			if isChecked("Drain Life Trait") and not cast.last.drainLife(1) and not isCastingSpell(234153) then
				if (buff.inevitableDemise.stack() >= (40 - (seedTargetsHit > 2 and 1 or 0) * 20)
					and ((cd.deathbolt.remain() > drainLifeTime or not talent.deathbolt) or not CDOptionEnabled("Darkglare"))
					and (cd.phantomSingularity.remain() > drainLifeTime or not talent.phantomSingularity) 
					and ((cd.darkSoul.remain() > drainLifeTime or not talent.darkSoul) or not CDOptionEnabled("Darkglare")) 
					and (cd.vileTaint.remain() > drainLifeTime or not talent.vileTaint) 
					and (cd.summonDarkglare.remain() > drainLifeTime + 10 or not CDOptionEnabled("Darkglare"))
					or buff.inevitableDemise.stack() > 10 and ttd("target") <= 10) then
					if cast.able.drainLife() then
						if cast.drainLife() then return true end
					end
				end
			end
			-- actions.fillers+=/haunt
			if talent.haunt then
				if cast.able.haunt() then
					if cast.haunt() then return true end
				end
			end
			-- actions.fillers+=/drain_soul,interrupt_global=1,chain=1,interrupt=1,cycle_targets=1,if=target.time_to_die<=gcd
			-- actions.fillers+=/drain_soul,target_if=min:debuff.shadow_embrace.remains,chain=1,interrupt_if=ticks_remain<5,interrupt_global=1,if=talent.shadow_embrace.enabled&variable.maintain_se&!debuff.shadow_embrace.remains
			-- actions.fillers+=/drain_soul,target_if=min:debuff.shadow_embrace.remains,chain=1,interrupt_if=ticks_remain<5,interrupt_global=1,if=talent.shadow_embrace.enabled&variable.maintain_se
			-- actions.fillers+=/drain_soul,interrupt_global=1,chain=1,interrupt=1
			-- actions.fillers+=/shadow_bolt,cycle_targets=1,if=talent.shadow_embrace.enabled&variable.maintain_se&!debuff.shadow_embrace.remains&!action.shadow_bolt.in_flight
			-- actions.fillers+=/shadow_bolt,target_if=min:debuff.shadow_embrace.remains,if=talent.shadow_embrace.enabled&variable.maintain_se
			-- actions.fillers+=/shadow_bolt
			if cast.able.shadowBolt() then
				if cast.shadowBolt() then return true end
			end
        end

		local function actionList_spenders ()
			-- actions.spenders=unstable_affliction,if=cooldown.summon_darkglare.remains<=soul_shard*execute_time&(!talent.deathbolt.enabled|cooldown.deathbolt.remains<=soul_shard*execute_time)
			if CDOptionEnabled("Darkglare") then
				if cd.summonDarkglare.remain() <= shards * cast.time.unstableAffliction() and (not talent.deathbolt or cd.deathbolt.remain() <= shards * cast.time.unstableAffliction()) then
					if cast.able.unstableAffliction() then
						if cast.unstableAffliction() then return true end
					end
				end
			end
			-- actions.spenders+=/call_action_list,name=fillers,if=(cooldown.summon_darkglare.remains<time_to_shard*(6-soul_shard)|cooldown.summon_darkglare.up)&time_to_die>cooldown.summon_darkglare.remains
			if CDOptionEnabled("Dargklare") then
				if (cd.summonDarkglare.remain() < time_to_shard * (6 - shards) or cd.summonDarkglare.remain() == 0) and ttd("target") > cd.summonDarkglare.remain() then
					if actionList_fillers() then return true end
				end
			end
			-- actions.spenders+=/seed_of_corruption,if=variable.use_seed
			if use_seed then
				if cast.able.seedOfCorruption() then
					if cast.seedOfCorruption(seedTarget) then return true end
				end
			end
			-- actions.spenders+=/unstable_affliction,if=!variable.use_seed&!prev_gcd.1.summon_darkglare&(talent.deathbolt.enabled&cooldown.deathbolt.remains<=execute_time&!azerite.cascading_calamity.enabled|(soul_shard>=5&spell_targets.seed_of_corruption_aoe<2|soul_shard>=2&spell_targets.seed_of_corruption_aoe>=2)&target.time_to_die>4+execute_time&spell_targets.seed_of_corruption_aoe=1|target.time_to_die<=8+execute_time*soul_shard)
			if not use_seed and not cast.last.summonDarkglare(1) and (talent.deathbolt and cd.deathbolt.remain() <= cast.time.unstableAffliction() and not traits.cascadingCalamity.active or (shards >= 5 and seedTargetsHit < 2 or shards >= 2 and seedTargetsHit >= 2) and ttd("target") > 4 + cast.time.unstableAffliction() and seedTargetsHit==1 or ttd("target") <= 8 + cast.time.unstableAffliction() * shards) then
				if cast.able.seedOfCorruption() then
					if cast.unstableAffliction() then return true end
				end
			end
			-- actions.spenders+=/unstable_affliction,if=!variable.use_seed&contagion<=cast_time+variable.padding
			if shards > 0 and not use_seed and debuff.unstableAffliction.remain() <= cast.time.unstableAffliction() + padding then
				if cast.able.unstableAffliction() then
					if cast.unstableAffliction() then return true end
				end
			end
			-- actions.spenders+=/unstable_affliction,cycle_targets=1,if=!variable.use_seed&(!talent.deathbolt.enabled|cooldown.deathbolt.remains>time_to_shard|soul_shard>1)&(!talent.vile_taint.enabled|soul_shard>1)&contagion<=cast_time+variable.padding&(!azerite.cascading_calamity.enabled|buff.cascading_calamity.remains>time_to_shard)
			if mode.rotation==1 or mode.rotation==2 then
				if not use_seed and (not talent.deathbolt or cd.deathbolt.remain() > time_to_shard or shards > 1) and (not talent.vileTaint or shards > 1) and (not traits.cascadingCalamity.active or buff.cascadingCalamity.remain() > time_to_shard) then
					for i = 1, #enemyTable40 do
						local thisUnit = enemyTable40[i]
						if not noDotCheck(thisUnit) and debuff.unstableAffliction.remain(thisUnit) <= cast.time.unstableAffliction() + padding then
							if cast.able.unstableAffliction() then
								if cast.unstableAffliction(thisUnit) then return true end
							end
						end
					end
				end
			end
        end

		local function actionList_PreCombat ()
			if not inCombat 
				and not (IsFlying() or IsMounted()) 
				and isValidUnit("target") 
				and getDistance("target") < 40 then
				-- actions.precombat=flask
				-- actions.precombat+=/food
				-- actions.precombat+=/augmentation
				-- actions.precombat+=/summon_pet
				-- actions.precombat+=/grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
				-- actions.precombat+=/snapshot_stats
				-- actions.precombat+=/potion
				-- pet
				if isChecked("Pet Management") and GetUnitExists("target") and not UnitAffectingCombat("pet") then
					PetAssistMode()
					PetAttack("target")
				end
				-- actions.precombat+=/seed_of_corruption,if=spell_targets.seed_of_corruption_aoe>=3
				if seedTargetsHit >= 3 then
					if cast.able.seedOfCorruption() then
						if cast.seedOfCorruption("target") then return true end
					end
				end
				-- actions.precombat+=/haunt
				if cast.able.haunt() then
					if cast.haunt("target") then return true end
				end
				-- actions.precombat+=/shadow_bolt,if=!talent.haunt.enabled&spell_targets.seed_of_corruption_aoe<3
				if not talent.haunt and seedTargetsHit < 3 then
					if cast.able.shadowBolt() then
						if cast.shadowBolt() then return true end
					end
				end
				opener = true
			end
		end

		-- local function actionList_stealth ()
		-- 	-- # Stealth
		-- 	-- actions.stealth=ambush
		-- 	if cast.able.ambush() then
		-- 		if cast.ambush() then return end
		-- 	end
		-- end

		function actionList_Extras ()
		end


		---------------------
		--- Begin Profile ---
		---------------------
		-- Profile Stop | Pause
		if not inCombat and not hastar and profileStop==true then
			profileStop = false
		elseif (inCombat and profileStop==true) or IsMounted() or IsFlying() or (pause(true) and not cast.current.drainSoul()) or mode.rotation==4 then
			if not pause() and IsPetAttackActive() and isChecked("Pet Management") then
				PetStopAttack()
				PetFollow()
			end
			return true
		else

			

			-----------------------
			--- Extras Rotation ---
			-----------------------
			if actionList_Extras() then return true end
			
			--------------------------
			--- Defensive Rotation ---
			--------------------------
			if actionList_Defensive() then return true end
			
			---------------------------
			--- Pre-Combat Rotation ---
			---------------------------
			if actionList_PreCombat() then return true end
			
			----------------------------------
			--- AUTO ENGANGE COMBAT TOGGLE ---
			----------------------------------
			--if not inCombat and not isChecked("Auto Engange") then return end
			-----------------------
			--- Opener Rotation ---
			-----------------------
			if opener == false --[[ and isChecked("Opener") ]] and isBoss("target") then
				if actionList_Opener() then return true end
			end
			
			--------------------------
			--- In Combat Rotation ---
			--------------------------
			if inCombat and profileStop==false and #enemyTable40 > 0
            	and (opener == true or not isChecked("Opener") or not isBoss("target")) and (not cast.current.drainLife() or (cast.current.drainLife() and php > 80)) then
				------------------------------
				--- In Combat - Interrupts ---
				------------------------------
				-- if actionList_Interrupts() then return end
				-----------------------------
				--- In Combat - Cooldowns ---
				-----------------------------

				---------------------------------------
				--- In Combat - "actionList_Main()" ---
				---------------------------------------
				-- -- Auto Attack
				-- if inCombat and isValidUnit(meleeUnit) then
				-- 	if not IsCurrentSpell(6603) then
				-- 		StartAttack(meleeUnit)
				-- 	end
				-- end
				if --[[ getOptionValue("APL Mode") == 1 and ]] not pause() then
					

					-- Pet Attack
					if isChecked("Pet Management") and not GetUnitIsUnit("pettarget","target") and isValidUnit("target") then
						PetAttack()
					end
					-- # Executed every time the actor is available.
					-- actions=variable,name=use_seed,value=talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption_aoe>=3+raid_event.invulnerable.up|talent.siphon_life.enabled&spell_targets.seed_of_corruption>=5+raid_event.invulnerable.up|spell_targets.seed_of_corruption>=8+raid_event.invulnerable.up
					-- actions+=/variable,name=padding,op=set,value=action.shadow_bolt.execute_time*azerite.cascading_calamity.enabled
					-- actions+=/variable,name=padding,op=reset,value=gcd,if=azerite.cascading_calamity.enabled&(talent.drain_soul.enabled|talent.deathbolt.enabled&cooldown.deathbolt.remains<=gcd)
					-- actions+=/variable,name=maintain_se,value=spell_targets.seed_of_corruption_aoe<=1+talent.writhe_in_agony.enabled+talent.absolute_corruption.enabled*2+(talent.writhe_in_agony.enabled&talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption_aoe>2)+(talent.siphon_life.enabled&!talent.creeping_death.enabled&!talent.drain_soul.enabled)+raid_event.invulnerable.up
					-- actions+=/call_action_list,name=cooldowns
					if actionList_cooldowns() then return true end

					-- actions+=/drain_soul,interrupt_global=1,chain=1,cycle_targets=1,if=target.time_to_die<=gcd&soul_shard<5
					-- actions+=/haunt,if=spell_targets.seed_of_corruption_aoe<=2+raid_event.invulnerable.up
					if seedTargetsHit <= 2 then
						if cast.able.haunt() then
							if cast.haunt() then return true end
						end
					end
					-- actions+=/summon_darkglare,if=dot.agony.ticking&dot.corruption.ticking&(buff.active_uas.stack=5|soul_shard=0)&(!talent.phantom_singularity.enabled|dot.phantom_singularity.remains)&(!talent.deathbolt.enabled|cooldown.deathbolt.remains<=gcd|!cooldown.deathbolt.remains|spell_targets.seed_of_corruption_aoe>1+raid_event.invulnerable.up)
					if CDOptionEnabled("Darkglare") then
						if debuff.agony.exists() 
							and debuff.corruption.exists() 
							and (debuff.unstableAffliction.stack() >= 5 or shards == 0) 
							and (not talent.phantomSingularity or debuff.phantomSingularity.exists()) 
							and (not talent.deathbolt or cd.deathbolt.remain() <= gcd or cd.deathbolt.remain() <= 0 or seedTargetsHit > 1) then
							if cast.able.summonDarkglare() then
								CastSpellByName(GetSpellInfo(spell.summonDarkglare))
								--if cast.summonDarkglare() then return true end
								return true
							end
						end
					end
					-- actions+=/deathbolt,if=cooldown.summon_darkglare.remains&spell_targets.seed_of_corruption_aoe=1+raid_event.invulnerable.up
					if talent.deathbolt and not moving then
						if cast.last.deathbolt(1) then
							if cd.summonDarkglare.remain() > 0 --[[ and seedTargetsHit == 1 ]] then
								if cast.able.deathbolt(1) then
									if cast.deathbolt() then return true end
								end
							end
						end
					end
					-- actions+=/agony,target_if=min:dot.agony.remains,if=remains<=gcd+action.shadow_bolt.execute_time&target.time_to_die>8
					if not noDotCheck("target") and  debuff.agony.remain() <= gcd + cast.time.shadowBolt() and ttd("target") > 8 then
						if cast.able.agony() then
							if cast.agony() then return true end
						end
					end
					-- actions+=/unstable_affliction,target_if=!contagion&target.time_to_die<=8
					
					-- actions+=/drain_soul,target_if=min:debuff.shadow_embrace.remains,cancel_if=ticks_remain<5,if=talent.shadow_embrace.enabled&variable.maintain_se&debuff.shadow_embrace.remains&debuff.shadow_embrace.remains<=gcd*2
					-- actions+=/shadow_bolt,target_if=min:debuff.shadow_embrace.remains,if=talent.shadow_embrace.enabled&variable.maintain_se&debuff.shadow_embrace.remains&debuff.shadow_embrace.remains<=execute_time*2+travel_time&!action.shadow_bolt.in_flight
					-- actions+=/phantom_singularity,target_if=max:target.time_to_die,if=time>35&target.time_to_die>16*spell_haste
					if combatTime > 35 and not noDotCheck("target") and ttd("target") > 16 * spell_haste and mode.ps == 1 then
						if cast.able.phantomSingularity() then
							if cast.phantomSingularity() then return true end
						end
					end
					-- actions+=/vile_taint,target_if=max:target.time_to_die,if=time>15&target.time_to_die>=10
					-- actions+=/unstable_affliction,target_if=min:contagion,if=!variable.use_seed&soul_shard=5
					if not use_seed and shards >= getOptionValue("UA Shards") then
						if cast.able.unstableAffliction() then
							if cast.unstableAffliction() then return true end
						end
					end
					-- actions+=/seed_of_corruption,if=variable.use_seed&soul_shard=5
					if use_seed and shards >= 5 then
						if cast.able.seedOfCorruption() then
							if cast.seedOfCorruption(seedTarget) then return true end
						end
					end
					
					
					-- actions+=/call_action_list,name=dots
					if actionList_dots() then return true end


					-- actions+=/phantom_singularity,if=time<=35
					if combatTime <= 35 and not noDotCheck("target") and mode.ps == 1 then
						if cast.able.phantomSingularity() then
							if cast.phantomSingularity() then return true end
						end
					end
					-- actions+=/vile_taint,if=time<15
					-- actions+=/dark_soul,if=cooldown.summon_darkglare.remains<10&dot.phantom_singularity.remains|target.time_to_die<20+gcd|spell_targets.seed_of_corruption_aoe>1+raid_event.invulnerable.up
					if talent.darkSoul and CDOptionEnabled("Dark Soul") and not moving then
						if cd.summonDarkglare.remain() < 10 and debuff.phantomSingularity.exists() --[[ or ttd("target") < 20 + gcd or seedTargetsHit > 1 ]] then
							if cast.able.darkSoul() then
								if cast.darkSoul() then return true end
							end
						end
					end
					-- actions+=/berserking
					if CDOptionEnabled("Racial") and not moving and (race == "Orc" or race == "Troll" or race == "DarkIronDwarf" or race=="MagharOrc" or (race == "BloodElf" and energyDeficit > 15 + energyRegen)) then
						if castSpell("player",racial,false,false,false) then return true end
					end
					
					
					-- actions+=/call_action_list,name=spenders
					if actionList_spenders() then return true end
					
					
					
					-- actions+=/call_action_list,name=fillers
					if actionList_fillers() then return true end						
				end
			end
		end -- Pause
	end -- End Timer
end -- End runRotation
local id = 0 -- Change to the spec id profile is for.
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
	name = rotationName,
	toggles = createToggles,
	options = createOptions,
	run = runRotation,
})