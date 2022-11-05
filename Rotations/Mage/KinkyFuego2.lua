local rotationName = "KinkyFuego 2"
local rotationVersion = "1.4.2"
local colorRed = "|cffFF0000"
local colorWhite = "|cffffffff"

--local AddonName, KMR = ...
--local L = KMR.L
local mainFrameStrata = "HIGH"
local canvasDrawLayer = "BORDER"
local InterruptCast = false 
local var = {}

-- Load 
if not var.kinky_tracker then 
    var.kinky_tracker = {} 
end
if not var.intBuffs then intBufs = 0; end 
if not var.hasteBuffs then hasteBuffs = 0; end

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.flamestrike},
        [2] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.iceBlock}
    };
    br.ui:createToggle(RotationModes, "Rotation", 1, 0)
-- Combustion Button
    local CombustionModes = {
        [1] = {mode = "SimC", value = 1, overlay = "SimC Combustion Enabled", tip = "Will use Combustion as per SimC.", highlight = 1, icon = br.player.spell.combustion},
        [2] = {mode = "CDs", value = 2, overlay = "CDs Combustion Enabled", tip = "Will use Combustion during ", highlight = 1, icon = br.player.spell.combustion},
        [3] = { mode = "TTD", value = 3 , overlay = "TTD Combustion Enabled", tip = "No Cooldowns will be used.", highlight = 1, icon = br.player.spell.combustion},
        [4] = { mode = "Hotkey", value = 4 , overlay = "Combustion Disabled (Hotkey Only)", tip = "Auto Combustion.", highlight = 1, icon = br.player.spell.combustion}
    };
    br.ui:createToggle(CombustionModes,"Combustion",0,1)
-- Cooldown Button
    local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.timeWarp},
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.timeWarp},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.timeWarp}
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
-- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.blazingBarrier},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.blazingBarrier}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
-- Interrupt Button
    local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.counterspell},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.counterspell}
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
-- Dragonbreath Button
    local DragonsBreathModes = {
       [1] = { mode = "On", value = 1 , overlay = "Dragonbreath Enabled", tip = "Always use Dragonbreath.", highlight = 1, icon = br.player.spell.dragonsBreath},
       [2] = { mode = "Off", value = 2 , overlay = "Dragonbreath Disabled", tip = "Don't use Dragonbreath.", highlight = 0, icon = br.player.spell.dragonsBreath}
    };
    br.ui:createToggle(DragonsBreathModes,"DragonsBreath",5,0)
-- Save FB Button
    local SaveFBModes = {
       [1] = { mode = "On", value = 1 , overlay = "Using Fireblasts", tip = "Use Fireblast Charges.", highlight = 1, icon = br.player.spell.fireBlast},
       [2] = { mode = "Off", value = 2 , overlay = "Saving Fireblasts", tip = "Save Fireblast Charges.", highlight = 0, icon = br.player.spell.fireBlast}
    };
    br.ui:createToggle(SaveFBModes,"SaveFB",1,1)
end
---------------
--- OPTIONS ---
---------------
local function createOptions()
        local optionsTable        
    local GeneralOptions = function()
    -- General Options
         section = br.ui:createSection(br.ui.window.profile, 
         colorRed .. "Fire" .. 
         colorWhite .. " .:|:. " .. 
         colorRed .. "General ".. 
         colorWhite.."Ver: " ..
         colorRed .. rotationVersion .. 
         colorWhite.." .:|:. ")
        -- Casting Interrupt Delay
            br.ui:createSpinner(section, "Casting Interrupt Delay", 0.1, 0, 1, 0.1, "|cffFFBB00Activate to delay interrupting own casts to use procs.")

            -- Auto target
		    br.ui:createCheckbox(section, "Auto Target", "|cffb28cc7Will auto change to a new target, if current target is dead")
            -- Out of Combat Attack
            br.ui:createCheckbox(section,"Auto Engage", "|cffb28cc7Check to Engage the Target out of Combat.")

            -- Auto Faccia
            br.ui:createCheckbox(section, "Auto Faccia", "|cffFFFFFFToggle Auto Faccia")
            --Auto Faccia Delay
            br.ui:createSpinnerWithout(section, "Auto Faccia Delay", 4.5, 0, 15, 0.1, "|cffFFBB00Time in seconds before Auto Faccia - Default: 4.5 / Min: 0 / Max: 15")

            -- Auto Keystone Module
            br.player.module.autoKeystone(section)
            
            -- Scorch Mafugger
            br.ui:createCheckbox(section,"Scorch Sniper","|cffFFBB00Will snipe mobs <= 30 hp% when using searing touch.")
            br.ui:createSpinner(section, "Scorch Standing Time", 1, 0, 10, 0.1, "|cffFFBB00Minimum standing time before casting scorch.")

        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  1,  1,  60,  1,  "|cffFFFFFFSet to desired time for test in minuts. Min: 1 / Max: 60 / Interval: 5")
        -- Conjure Refreshments
            br.ui:createCheckbox(section,"Conjure Refreshments")

        br.ui:checkSectionState(section)
    -- Pre-Combat Options
        section = br.ui:createSection(br.ui.window.profile, "Pre-Combat")

        -- Pig Catcher
           -- br.ui:createCheckbox(section, "Pig Catcher")

        -- Auto Buff Arcane Intellect
            br.ui:createCheckbox(section,"Arcane Intellect", "Check to auto buff Arcane Intellect on party.")

        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        br.ui:checkSectionState(section)
    end

    local AoEOptions = function()
    -- AoE Options
        section = br.ui:createSection(br.ui.window.profile, colorWhite .. "AoE " .. colorRed .. ".:|:. " .. colorWhite .. " Area of Effect")
        -- Predict movement
            br.ui:createCheckbox(section, "Predict Movement", "|cffFFFFFF Predict movement of units for Meteor/Flamestrike Units (works best in solo/dungeons)")
        -- AoE Meteor
        -- Meteor Target
            br.ui:createDropdownWithout(section, "Meteor Target", {"Target", "Best"}, 1, "|cffFFFFFFMeteor target")
            br.ui:createSpinner(section,"Meteor Targets",  3,  1,  15,  1, "Min AoE Units")
            br.ui:createCheckbox(section, "Ignore Meteor Targets during CDs", "|cffFFFFFFToggle Use Meteor during CDs regardless of unit count.")
            br.ui:createCheckbox(section, "Use Meteor outside ROP", "If Unchecked, will only use Meteor if ROP buff is up")

        -- AoE Flamestrike 
        -- Flamestrike Target
            br.ui:createDropdownWithout(section, "Flamestrike Target", {"Target", "Best"}, 1, "|cffFFFFFFFlamestrike target")
            --br.ui:createSpinnerWithout(section,"FS Targets (Firestorm)",  3,  1,  10,  1, "Min AoE Units")
            --br.ui:createSpinnerWithout(section,"FS Targets (Hot Streak)",  3,  1,  10,  1, "Min AoE Units")
            --br.ui:createSpinnerWithout(section,"FS Targets (Flame Patch)",  3,  1,  10,  1, "Min AoE Units")

        -- Rune of Power
            br.ui:createSpinnerWithout(section,"RoP Targets",  3,  1,  10,  1, "Min AoE Units")

        -- Combustion (Firestarter)
            br.ui:createSpinnerWithout(section,"Combustion Targets",  3,  1,  10,  1, "Min AoE Units to use Combustion with Firestarter Talent")
        br.ui:checkSectionState(section)
    end 

    local CooldownsOptions = function()
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, colorWhite .. "CDs " .. colorRed .. ".:|:. " .. colorWhite .. " Cooldowns")
        -- Cooldowns Time to Die limit
            br.ui:createSpinnerWithout(section, "Cooldowns Time to Die Limit", 15, 0, 300, 0.5, "|cffFFBB00Min. calculated time to die to use CDs.")
                       
         section = br.ui:createSection(br.ui.window.profile, 
         colorRed .. "Fire" .. 
         colorWhite .. " .:|:. " .. 
         colorRed .. "Combust/Covenant ".. 
         colorWhite.."Ver: " ..
         colorRed .. rotationVersion .. 
         colorWhite.." .:|:. ")

            -- Combustion Standing Time/TTD
            br.ui:createSpinner(section, "Combustion Standing Time", 0.1, 0, 10, 0.1, "|cffFFBB00Minimum standing time before casting combustion.")
            br.ui:createSpinnerWithout(section,"Combustion TTD",  15,  1,  50,  1, "|cffFFBB00Min TTD of unit before considering casting Combustion. ")
            
            -- Shifting Power during combustion toggle. 
            br.ui:createCheckbox(section,"Shifting Power (Combustion)", "|cffFFBB00Toggles the use of shifting power during combust/AoE.")
            -- Shifting Power
            br.ui:createDropdownWithout(section, "Shifting Power (Combustion)", {"AoE", "AoE/CD(s)", ""}, 1, "|cffFFFFFFMeteor target")
            -- Covenant TTD
            br.ui:createSpinnerWithout(section, "Covenant TTD", 8, 1, 15, 1, "The TTD before casting your covenant ability default:8)")
            br.ui:createSpinnerWithout(section,"Covenant Standing Time",  1.5,  1,  10,  0.1, "Min Standing Time before casting Combustion. default:1.5)")

        -- Elixir
            br.ui:createDropdownWithout(section,"Elixir", {"Greater Flask of Endless Fathoms","Flask of Endless Fathoms","None"}, 1, "|cffFFFFFFSet Elixir to use.")

        -- Trinkets
            br.player.module.BasicTrinkets(nil,section)

        -- FlaskUp Module
            br.player.module.FlaskUp("Intellect",section)

        -- Potion
            br.ui:createCheckbox(section,"Potion")

        -- Mirror Image
            br.ui:createCheckbox(section,"Mirror Image")

        -- Racial 
            br.ui:createCheckbox(section,"Racial")

        -- Augment
            br.ui:createCheckbox(section,"Augment")
        br.ui:checkSectionState(section)
    end

    local DefensiveOptions = function()
    -- Defensive Option
        section = br.ui:createSection(br.ui.window.profile, colorWhite .. "DEF" .. colorRed .. ".:|:. " .. colorWhite .. " Defensives")
        -- Basic Healing Module
            br.player.module.BasicHealing(section)

        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end

        -- Blast Wave
            br.ui:createSpinner(section, "Blast Wave",  30,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")

        -- Blazing Barrier
            br.ui:createSpinner(section,"Blazing Barrier", 93, 0, 100, 5,   "|cffFFBB00Health Percentage to use at.")
            br.ui:createCheckbox(section, "Blazing Barrier OOC")
        -- Frost Nova
            br.ui:createSpinner(section, "Frost Nova",  53,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
        -- Ice Block
            br.ui:createSpinner(section, "Ice Block", 14, 0, 100, 0.1, "|cffFFBB00Health Percent to Cast At")
        -- Spellsteal
            br.ui:createDropdown(section,"Spellsteal", {"|cffFFFF00Selected Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")
        br.ui:checkSectionState(section)
    end 

    local InterruptOptions = function()
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        -- Couterspell
            br.ui:createCheckbox(section, "Counterspell")
        -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        -- Don't interrupt
        br.ui:createCheckbox(section, "Do Not Cancel Cast", "|cffFFBB00Will not interrupt own spellcasting to cast Counterspell or interrupt casts for Max dps")
        br.ui:checkSectionState(section)

    end 

    local HotkeysOptions = function()
        -------------------------
		---- HOTKEYS OPTIONS ----
		-------------------------
		section = br.ui:createSection(br.ui.window.profile, colorWhite .."Fire .:|:."..colorRed.."Hotkeys")
            -- Combustion Key
            br.ui:createDropdown(section, "Combustion", br.dropOptions.Toggle, 6, "|cffFFBB00Hold to cast Combustion (when available)")

            -- Spellsteal Key
            br.ui:createDropdown(section, "Spellsteal", br.dropOptions.Toggle, 6, "|cffFFBB00Hold to cast Spellsteal.")

            -- Counterspell Teleport Key
            br.ui:createDropdown(section, "Counterspell", br.dropOptions.Toggle, 6, "|cffFFBB00Hold to cast Counterspell.")

            -- Polymorph Key
            br.ui:createDropdown(section, "Polymorph", br.dropOptions.Toggle, 6, "|cffFFBB00Hold to cast Polymorph.")

            -- Ice Block Key
            br.ui:createDropdown(section, "Ice Block",  br.dropOptions.Toggle, 6, "|cffFFBB00Hold to cast Ice Block.")

            -- Time Warp Key
            br.ui:createDropdown(section, "Time Warp", br.dropOptions.Toggle, 6, "|cffFFBB00Hold to cast Time warp. ")
           
            -- Shadowfury Target
            --br.ui:createDropdownWithout(section, "Shadowfury Target", {"|cffFFBB00Best", "|cffFFBB00Target", "|cffFFBB00Cursor"}, 1, "|cffFFBB00Shadowfury target")
        br.ui:checkSectionState(section)
    end

    local ToggleOptions = function()
    -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
        -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
        -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
        -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
        -- Couterspell
            br.ui:createCheckbox(section, "Dev Debug")
        br.ui:checkSectionState(section)
    end
  

	optionTable = {{
		[1] = "General",
        [2] = GeneralOptions,
    },
    {
        [1] = "Area of Effect",
        [2] = AoEOptions,
	},
    {
        [1] = "Cooldowns",
        [2] = CooldownsOptions,
    },
    {
        [1] = "Defensives",
        [2] = DefensiveOptions,
    },
    {
        [1] = "Interrupts",
        [2] = InterruptOptions,
    },
    {
        [1] = "Hotkeys",
        [2] = HotkeysOptions,
    },
    {
        [1] = "Toggles",
        [2] = ToggleOptions,
    }
}
	return optionTable
end


----------------
--- ROTATION ---
----------------
local function runRotation()
    br.UpdateToggle("Rotation",0.25)
    br.UpdateToggle("Cooldown",0.25)
    br.UpdateToggle("Defensive",0.25)
    br.UpdateToggle("Interrupt",0.25)
    br.UpdateToggle("Combustion",0.25)
    br.player.ui.mode.cb = br.data.settings[br.selectedSpec].toggles["Combustion"]
--------------
--- Locals ---
--------------
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = br.getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = br.GetUnitIsDeadOrGhost("mouseover")
        local hasMouse                                      = br.GetObjectExists("mouseover")
        local hastar                                        = br.GetObjectExists("target")
        local debuff                                        = br.player.debuff
        local debug                                         = br.addonDebug
        local enemies                                       = br.player.enemies
        local equiped                                       = br.player.equiped
        local conduit                                       = br.player.conduit
        local covenant                                      = br.player.covenant
        local falling, swimming, flying, moving             = br.getFallTime(), IsSwimming(), IsFlying(), br._G.GetUnitSpeed("player")>0
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local hasMouse                                      = br.GetObjectExists("mouseover")
        local healPot                                       = br.getHealthPot()
        local lootDelay                                     = br.getOptionValue("LootDelay")
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local item                                          = br.player.items
        local manaPercent                                   = br.player.power.mana.percent()
        local mode                                          = br.player.ui.mode
        local module                                        = br.player.module
        local moving                                        = br.isMoving("player")     
        local php                                           = br.player.health
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local racial                                        = br.player.getRacial()
        local runeforge                                     = br.player.runeforge
        local solo                                          = #br.friend == 1
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local traits                                        = br.player.traits
        local thp                                           = br.getHP("target")
        local ttd                                           = br.getTTD
        local units                                         = br.player.units
        local use                                           = br.player.use
        local spellHaste                                    = (1 + (GetHaste()/100))
        local crit                                          = GetSpellCritChance(3)
        local playerMouse                                   = br._G.UnitIsPlayer("mouseover")
        local playerCasting                                 = br._G.UnitCastingInfo("player")
        local ui                                            = br.player.ui
        local cl                                            = br.read
        local travelTime                                    = br.getDistance("target") / 50 --Ice lance

        --cooldown.combustion.remains<action.fire_blast.full_recharge_time+cooldown.fire_blast.duration*azerite.blaster_master.enabled
        --if traits.blasterMaster then bMasterFBCRG = charges.fireBlast.timeTillFull() + fblastCDduration else bMasterFBCRG = 0 end

       var.disciplinary_command_arcane = 0;
       var.disciplinary_command_frost = 0;
       var.disciplinary_command_fire = 0;
     --[[
        var.intBuffs = 0;
        var.hasteBuffs = 0;
        var.masteryBuffs = 0;
        var.versiBuffs = 0;
        var.healthBuffs = 0;

        var.int_buffs = {
            ----------------------------------------------------------------------------------------------------------------------
            178386, -- Gladiator's Insignia of Alacrity  -- Intellect 
            175921, -- Gladiator's Badge of Ferocity -- Intellect 
            345539, -- Empyreal Ordnance | Intellect
            ----------------------------------------------------------------------------------------------------------------------
       },
       var.haste_buffs = {
           ----------------------------------------------------------------------------------------------------------------------
           181457, -- Wakener's Frond | Haste
           184024, -- Macabre Sheet Music -- Haste
           330368, -- Inscrutable Quantum Device | Haste
           ----------------------------------------------------------------------------------------------------------------------
       },
       var.mastery_bffs = {
           ----------------------------------------------------------------------------------------------------------------------
           330380, -- Inscrutable Quantum Device | Mastery 
           ----------------------------------------------------------------------------------------------------------------------
       },
       var.versi_buffs = {
           ----------------------------------------------------------------------------------------------------------------------
           181501, -- Flame of Battle | Versitility
           330367, -- Inscrutable Quantum Device | Versitility
           ----------------------------------------------------------------------------------------------------------------------
       },
       var.health_buffs = {
           ----------------------------------------------------------------------------------------------------------------------
           
-

           ----------------------------------------------------------------------------------------------------------------------

       }]]
    -- Removed Aura Events
	--	if param == "SPELL_AURA_REMOVED" then	
				-- Bye felicia buffs. 
              --  				for i=1,#intellectProcs do
		--			if spellID == intellectProcs[i] then intBuffs = intBuffs - 1 end
			--	end
			--	for i=1,#hasteProcs do
			--		if spellID == var.mastery_buffs[i] then var.masteryBuffs = var.masteryBuffs - 1 end
			--	end

         --   end 

        units.get(6)
        units.get(8)
        units.get(10)
        units.get(12)
        units.get(16)
        units.get(25)
        units.get(30)
        units.get(40)
        enemies.get(6)
        enemies.get(8)
        enemies.get(10)
        enemies.get(10, "player", true)
        enemies.get(12)
        enemies.get(16)
        enemies.get(18) -- Shifting Power
        enemies.get(25)
        enemies.get(30)
        enemies.get(40)
        enemies.get(6,"target")
        enemies.get(8,"target")
        enemies.get(10,"target")
        enemies.get(12,"target")
        enemies.get(16,"target")
        enemies.get(18,"target") -- Shifting Power Target
        enemies.get(25,"target")
        enemies.get(30,"target")
        enemies.get(40,"target")

        local dispelDelay = 1.5
        if br.isChecked("Dispel delay") then
            dispelDelay = br.getValue("Dispel delay")
        end

        if #enemies.yards6t > 0 then fSEnemies = #enemies.yards6t else fSEnemies = #enemies.yards40 end
        local dBEnemies = br.getEnemies(units.dyn12, 6, true)
        local firestarterActive = talent.firestarter and thp > 90
        local firestarterInactive = thp < 90 or br.isDummy()

        local function firestarterRemain(unit, pct)
            if not br.GetObjectExists(unit) then return -1 end
            if not string.find(unit,"0x") then unit = br._G.ObjectPointer(unit) end
            if br.getOptionCheck("Enhanced Time to Die") and br.getHP(unit) > pct and br.unitSetup.cache[unit] ~= nil then
                return br.unitSetup.cache[unit]:unitTtd(pct)
            end
            return -1
        end

        local pyroReady = cast.time.pyroblast() == 0
        local fsReady = cast.time.flamestrike() == 0
        local combustionROPcutoff = 60
        local firestarterremain = firestarterRemain("target", 90)
        local cdMeteorDuration = 45 --select(2,GetSpellCooldown(spell.meteor))
        local fblastCDduration = select(2,GetSpellCooldown(spell.fireBlast))
        local pblastcasttime = cast.time.pyroblast()

        if traits.blasterMaster.active then bMasterFBCD = cd.fireBlast.remain() + fblastCDduration else bMasterFBCD = 0 end

        -- Interrupt Cast
        local function interruptCast(spellID)
            local getspellID = select(9, br._G.UnitCastingInfo("player"))
            if spellID == nil then spellID = getspellID end

            local castingInfo = {br._G.UnitCastingInfo("player")}
            if castingInfo[9] and castingInfo[9] == spellID then
                if br.isChecked("Casting Interrupt Delay") then
                    if (GetTime()-(castingInfo[4]/1000)) >= br.getOptionValue("Casting Interrupt Delay") then
                        debug("-Interrupted " .. GetSpellInfo(spellID) .. " -")
                        return true
                    end
                else
                    return true
                end
            end
            return false
        end

        --Player cast remain
        var.execute_remains = 0
        if br._G.UnitCastingInfo("player") then
            var.execute_remains = (select(5, br._G.UnitCastingInfo("player")) / 1000) - GetTime()
        end

        var.num = function(val)
            if val then return 1 -- Return yes, that's pretty true, yeah true, that's pretty true 
            else 
                return 0 -- Return not a gahtdahwm thing duuuuuuuuuud
            end
            return 0
        end
        var.bool = function(val) 
            --if val == nil then val = 0; end
            return val ~= 0
        end

function cl:Mage(...)
    if GetSpecialization() == 2 then
        local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()

            -- Declare our Tracker variables. 
            if var.fireball_crit == nil then var.fireball_crit = 0; end 
            if var.fb_crits == nil then var.fb_crit_count = 0; end
            
            if var.pyroblast_crit == nil then var.pyroblast_crit = 0; end
            if var.pb_crit_count == nil then var.pb_crit_count = 0; end

            if var.disciplinary_command_fire == nil then var.disciplinary_command_fire = 0; end
            if var.disciplinary_command_arcane == nil then var.disciplinary_comand_arcane = 0; end 
            if var.disciplinary_command_frost == nil then var.disciplinary_command_frost = 0; end 

           --[[ if GetSpecialization() == 2 and br.player ~= nil then
                 if isInCombat("player") and br.GetUnitIsUnit(sourceName, "player") then 

                 end
            end ]]

			-- A unit has died, is it in our tracker?

            -- Set our variables back to default. 
            if param == "PLAYER_REGEN_ENABLED" and source == br.guid  then 
                var.hot_streak_flamestrike = 2*var.num(talent.flamePatch)+3*var.num(not talent.flamePatch);
                var.hard_cast_flamestrike = 2*var.num(talent.flamePatch)+3*var.num(not talent.flamePatch);
                var.kindling_reduction = 0;
                var.on_use_cutoff = 0;
                var.comustion_shifting_power = 0;
                var.combustion_cast_remains  = 0;
                var.time_to_combustion = 0;
                var.empyreal_ordnance_delay = 0;
                var.Phoenix_pooling = 0; 
                var.fire_blast_pooling = 0; 
                var.fireball_crit = 0;
                var.pyroblast_crit = 0; 
                var.disciplinary_command_arcane = 0;
                var.disciplinary_command_frost = 0;
                var.disciplinary_command_fire = 0;
                var.expiryTime = 0;
            end -- End PLAYER REGEN ENABLED - Event

            ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
            -- Cast Tracker .:|:.-----.:|:.-----.:|:.-----
            ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
          --[[  if param == "SPELL_CAST_SUCCESS"
            and source == br.guid 
            then
                local spellId, spellName, spellSchool = select(12, ...)
                ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
                -- Disciplinary Command : Arcane ---.:|:.-----
                ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
                if (spellSchool == 64) then 
                    var.expiryTime = GetTime() + 10
                    var.disciplinary_command_arcane = var.expiryTime
                ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
                -- Disciplinary Command : Frost ----.:|:.-----
                ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
                elseif (spellSchool == 16) then
                    var.expiryTime = GetTime() + 10
                    var.disciplinary_command_frost = var.expiryTime
                ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
                -- Disciplinary Command : Fire -----.:|:.-----
                ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
                elseif (spellSchool == 4) then
                    var.expiryTime = GetTime() + 10
                    var.disciplinary_command_fire = var.expiryTime
                end
                
                var.gettime = GetTime()
                if (
                    var.gettime - var.disciplinary_command_arcane < 10
                    and var.gettime - var.disciplinary_command_frost < 10
                    and gettime - var.disciplinary_command_fire < 10 
                ) then 
                    var.disciplinary_comand_arcane = 0;
                    var.disciplinary_command_frost = 0;
                    var.disciplinary_command_fire = 0;
                end
            end]]
            

            if param == "COMBAT_LOG_EVENT_UNFILTERED" then
	     	    local subParam		= select(2, ...)
		        local source		= select(5, ...)
		        local destGUID		= select(8, ...)
		        local destination	= select(9, ...)
		        local spellID		= select(12, ...)
		        local spell			= select(13, ...)
		        local damage		= select(15, ...)
		        local critical		= select(21, ...)

	     	    -- Unit Death events
		 	    if subParam == "UNIT_DIED" then
			 	    -- A unit has died, is it in our tracker?
			 	    if #kinky_tracker > 0 then
				 	    for i=1,#kinky_tracker do
					 	    if kinky_tracker[i].guid == destGUID then tremove(kinky_tracker, i) return true end
				 	    end
			     	end
		     	end
            end


            ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
            -- Proc Tracker .:|:.-----.:|:.-----.:|:.-----
            ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
            if param == "SPELL_DAMAGE" 
            and source == br.guid 
            then
                ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
                -- Fireball Critical Tracker -------.:|:.-----
                ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
                if spell == br.player.spell.fireball and destination == br._G.UnitGUID("target") then 
                    if critical ~= 0 then var.fireball_crit = 1;  -- Fireball crit, let's set the value as 1.
                    else var.fireball_crit = 0; end -- Fireball didn't crit, it's a 0.
                    -- Add to total count of crits this combat session. 
                    var.fb_crit_count = var.fb_crit_count + 1
                    br.addonDebug("Fireball Crit | " .. "Total Crit(s): " .. var.fb_crit_count)
                end
                ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
                -- Pyroblast Critical Tracker ------.:|:.-----
                ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
                if spell == br.player.spell.pyroblast and destination == br._G.UnitGUID("target") then
                    if critical ~= 0 then var.pyroblast_crit = 1; 
                    else var.pyroblast_crit = 0; end -- Fireball didn't crit, set to 0.
                    -- Add to total count of crits this combat session. 
                    var.pb_crit_count = var.pb_crit_count + 1
                    br.addonDebug("Pyroblast Crit" ..  " | " .. "Total Crit(s): " .. var.pb_crit_count) -- Fireball did crit. 
                end
            end -- End SPELL_DAMAGE - Event


            
            var.igniteCount = 0;
		    -- Periodic Damage Events
		    if param == "SPELL_PERIODIC_DAMAGE" then
            end
		    -- Ignite spotted...
			if UnitName("player") == source and destination == UnitName("target") then
				if spell == 12654 then IgniteDamage = damage end
			end
            --if param == "SPELL_AURA_REMOVED" 
           -- and source == br.guid 
           -- then
           --end
        end
end

        var.overpool_fire_blasts = 0;
        var.expected_fire_blasts = 0;
        var.needed_fire_blasts = 0;
        var.soul_ignition_count                                                                 = br.player.buff.soulIgnition.count();
        var.in_flight_remains                                                                   = br.getDistance("target") / 16;
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # If set to a non-zero value, the Combustion action and cooldowns that are constrained to only be used when Combustion is up will not be used during the simulation.                    ~-~.::|:..:|:.-~-Kinky-~vibes~-~-~-~.:|~-~.:|:..:
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=disable_combustion,op=reset
        var.disable_combustion                                                                  = mode.combustion ~= 4 or not br.useCDs();
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # APL Variable Option: This variable specifies whether Combustion should be used during Firestarter.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=firestarter_combustion,default=-1,value=1*!talent.pyroclasm,if=variable.firestarter_combustion<0
       -- if var.firestarter_combustion < 0 then 
        --    var.firestarter_combustion                                                          = 1 * var.num(not talent.pyroclasm) end;
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # This variable specifies the number of targets at which Hot Streak Flamestrikes outside of Combustion should be used..~.:|:..:|:..:|:.-~~-~-~.:|:..:|:..-~~-~-~.:|:..:|:..:|:.~~-~-~.:|:..:|:..-~~-~-~.:|:..:|:..:|:.~~-~-~.:|:..:|:..-~
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=hot_streak_flamestrike,op=set,if=variable.hot_streak_flamestrike=0,value=2*talent.flame_patch+3*!talent.flame_patch  
        var.hot_streak_flamestrike                                                              = 2*var.num(talent.flamePatch)+3*var.num(not talent.flamePatch);     
         -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # This variable specifies the number of targets at which Hard Cast Flamestrikes outside of Combustion should be used as filler..~.:|:..:|:..:|:.-~~-~-~.:|:..:|:..-~~-~-~.:|:..:|:..:|:.~~-~-~.:|:..:|:..-~~-~-~.:|:..:|:..:|:.~~-~-~.:|:
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=hard_cast_flamestrike,op=set,if=variable.hard_cast_flamestrike=0,value=2*talent.flame_patch+3*!talent.flame_patch   
        var.hard_cast_flamestrike                                                               = 2*var.num(talent.flamePatch)+3*var.num(not talent.flamePatch); 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # This variable specifies the number of targets at which Hot Streak Flamestrikes are used during Combustion.~.:|:..:|:..:|:.-~~-~-~.:|:..:|:..-~~-~-~.:|:..:|:..:|:.~~-~-~.:|:..:|:..-~~-~-~.:|:..:|:..:|:.~~-~-~.:|:..:|:..-~~-~-~.:|:.~
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=combustion_flamestrike,op=set,if=variable.combustion_flamestrike=0,value=3*talent.flame_patch+6*!talent.flame_patch
        var.combustion_flamestrike                                                              = 3*var.num(talent.flamePatch)+6*var.num(not talent.flamePatch);
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # This variable specifies the number of targets at which Arcane Explosion outside of Combustion should be used .~.:|:..:|:..:|:.-~~-~-~.:|:..:|:..-~~-~-~.:|:..:|:..:|:.~~-~-~.:|:..:|:..-~~-~-~.:|:..:|:..:|:.~~-~-~.:|:..:|:..-~~-~-~.:
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=arcane_explosion,op=set,if=variable.arcane_explosion=0,value=99*talent.flame_patch+2*!talent.flame_patch
        var.arcane_explosion                                                                    = 99*var.num(talent.flamePatch)+2*var.num(not talent.flamePatch);
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # This variable specifies the percentage of mana below which Arcane Explosion will not be used..~.:|:..:|:..:|:.-~~-~-~.:|:..:|:..-~~-~-~.:|:..:|:..:|:.~~-~-~.:|:..:|:..-~~-~-~.:|:..:|:..:|:.~~-~-~.:|:..:|:..-~~-~-~.:|:..~.:|:..:|:..
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=arcane_explosion_mana,default=40,op=reset
        var.arcane_explosion_mana                                                               = 40;
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # With Kindling, Combustion's cooldown will be reduced by a random amount, but the number of crits starts very high after activating Combustion and slows down towards the end of Combustion's cooldown. 
        -- When making decisions in the APL, Combustion's remaining cooldown is reduced by this fraction to account for Kindling..~.:|:..:|:..:|:.-~~-~-~.:|:..:|:..-~~-~-~.:|:..:|:..:|:.~~-~-~.:|:..:|:..-~~-~-~.:|:..:|:..:|:.~~-~-~.:|:..:|:..-~
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=kindling_reduction,default=0.4,op=reset
        var.kindling_reduction                                                                  = 0.4;
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # The duration of a Sun King's Blessing Combustion.                                                                                                                                                                               
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- ctions.precombat+=/variable,name=skb_duration,op=set,value=dbc.effect.828420.base_value
        var.skb_duration                                                                        = 5; -- .:|:. hey kink, ya past you....you're gonna need to do better on this one bud, it ain't it at all chief...
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Check if we have any of these items in the designerGear table, and see if the homie is dripped down to his socks or not by keeping count of just how FUGGGGINNNN SEXY HE IS 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=combustion_on_use,op=set,value=equipped.gladiators_badge|equipped.macabre_sheet_music|equipped.inscrutable_quantum_device|equipped.sunblood_amethyst|equipped.empyreal_ordnance|equipped.flame_of_battle|equipped.wakeners_frond|equipped.instructors_divine_bell
        var.combustion_on_use = false; 
        var.onUseTrinkets = {
        178386, -- Gladiator's Insignia of Alacrity -- Intellect
        -----------------------------------------------------------------------------------------------------------------------
        175921, -- Gladiator's Badge of Ferocity -- Intellect 
        -----------------------------------------------------------------------------------------------------------------------
        184024, -- Macabre Sheet Music -- Haste
        -----------------------------------------------------------------------------------------------------------------------
        179350, -- Inscrutable Quantum Device 
        -----------------------------------------------------------------------------------------------------------------------
        178826, -- Sunblood Amethyst | Intellect
        -----------------------------------------------------------------------------------------------------------------------
        180117, -- Empyreal Ordnance | Intellect
        -----------------------------------------------------------------------------------------------------------------------
        181501, -- Flame of Battle | Versitility
        -----------------------------------------------------------------------------------------------------------------------
        181457, -- Wakener's Frond | Haste
        -----------------------------------------------------------------------------------------------------------------------
        184842, -- Instructor's Divine Bell | Mastery
        -----------------------------------------------------------------------------------------------------------------------
        181501, -- Flame of Battle
        -----------------------------------------------------------------------------------------------------------------------
        184030, -- Dreadfire Vessel
        -----------------------------------------------------------------------------------------------------------------------
        178809, -- Soulletting Ruby
        -----------------------------------------------------------------------------------------------------------------------
        184021, -- Glyph of Assimilation | Mastery
        -----------------------------------------------------------------------------------------------------------------------
        184020, -- Tuft of Smoldering Plumage
        -----------------------------------------------------------------------------------------------------------------------
        173069, -- Darkmoon Deck: Putrescence
        -----------------------------------------------------------------------------------------------------------------------
        178810, -- Vial of Spectral  
        -----------------------------------------------------------------------------------------------------------------------
        182452, -- Everchill Brambles
        -----------------------------------------------------------------------------------------------------------------------
        184019 -- Soul Ignitor
        }
        local function on_use_trinkets(tbl)
	        for i=1,#var.onUseTrinkets do
                var.big_dick_energy = tbl[i];
		        if IsEquippedItem(tbl[i]) then var.big_dick_energy = var.big_dick_energy + 1 end
	        end
	        return var.big_dick_energy or 0 
        end
        -- Determine how many on use trinkets we have equipped. 
        if var.big_dick_energy == nil and on_use_trinkets(var.onUseTrinkets) > 0 then
            -- Set BDE's variable's count to 0, 1 or 2. 
            var.big_dick_energy = on_use_trinkets(var.onUseTrinkets);
        elseif on_use_trinkets(var.onUseTrinkets) > 1 then 
            var.big_dick_energy = on_use_trinkets(var.onUseTrinkets);
        end
        var.mythicDeathCount = C_ChallengeMode.GetDeathCount() or 0

        var.trinket1                                                                            = GetInventoryItemID("player", 13);
        var.trinket2                                                                            = GetInventoryItemID("player", 14);

        var.combustion_on_use                                                                   = on_use_trinkets(var.onUseTrinkets);
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # How long before Combustion should Empyreal Ordnance be used?
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=empyreal_ordnance_delay,default=18,op=reset
        var.empyreal_ordnance_delay                                                             = 18;
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # How long before Combustion should trinkets that trigger a shared category cooldown on other trinkets not be used?
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=on_use_cutoff,op=set,value=20,if=variable.combustion_on_use
        var.on_use_cutoff                                                                       = 20;
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=on_use_cutoff,op=set,value=25,if=equipped.macabre_sheet_music
        if IsEquippedItem(184024) then var.on_use_cutoff                                        = 25; end 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=on_use_cutoff,op=set,value=20+variable.empyreal_ordnance_delay,if=equipped.empyreal_ordnance
        if IsEquippedItem(180117) then var.on_use_cutoff                                        = 20+var.empyreal_ordnance_delay; end 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # The number of targets Shifting Power should be used on during Combustion.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=combustion_shifting_power,default=2,op=reset
        var.combustion_shifting_power                                                            = 2;
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # The time remaining on a cast when Combustion can be used in seconds.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.precombat+=/variable,name=combustion_cast_remains,default=0.7,op=reset
        var.combustion_cast_remains                                                             = 0.7;
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Variable that controls when Combustion is used. This line sets Combustion to be used after Firestarter and applies the kindling_reduction variable to the remaining cooldown of Combustion. Additionally, 
        -- if Combustion is disabled this just sets the variable to a time past the end of the simulation.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/variable,name=time_to_combustion,op=set,value=talent.firestarter*firestarter.remains+(cooldown.combustion.remains*(1-variable.kindling_reduction*talent.kindling))*!cooldown.combustion.ready*buff.combustion.down+fight_remains*2*(variable.disable_combustion!=0)
        var.time_to_combustion                                                                  = var.num(talent.firestarter)*firestarterRemain("target", 90)*(1-var.kindling_reduction*var.num(talent.kindling)*var.num(not cd.combustion.ready())*var.num(not buff.combustion.react())+var.in_flight_remains*2)
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Make sure Combustion is delayed if needed based on the empyreal_ordnance_delay variable.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/variable,name=time_to_combustion,op=max,value=variable.empyreal_ordnance_delay-(cooldown.empyreal_ordnance.duration-cooldown.empyreal_ordnance.remains)*!cooldown.empyreal_ordnance.ready,if=equipped.empyreal_ordnance
        if IsEquippedItem(180117) then var.time_to_combustion                                   = var.empyreal_ordnance_delay; end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Delay Combustion for Gladiator's Bad--------------------------------------------
        -- actions+=/variable,name=time_to_combustion,op=max,value=cooldown.gladiators_badge.remains,if=equipped.gladiators_badge
        if IsEquippedItem(180117) then var.on_use_cutoff                                        = 20+var.empyreal_ordnance_delay; end 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Delay Combustion until RoP expires if it's up.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/variable,name=time_to_combustion,op=max,value=buff.rune_of_power.remains,if=talent.rune_of_power&buff.combustion.down
        if talent.runeOfPower and not buff.combustion.react() then var.time_to_combustion      = buff.runeOfPower.remains(); end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Delay Combustion for an extra Rune of Power if the Rune of Power would come off cooldown at least 5 seconds before Combustion would.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/variable,name=time_to_combustion,op=max,value=cooldown.rune_of_power.remains+buff.rune_of_power.duration,if=talent.rune_of_power&buff.combustion.down&cooldown.rune_of_power.remains+5<variable.time_to_combustion
        if talent.runeOfPower 
        and buff.combustion.react() 
        and cd.runeOfPower.remains()+5<var.time_to_combustion then var.time_to_combustion       = cd.runeOfPower.remains()+12; end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Delay Combustion if Disciplinary Command would not be ready for it yet.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/variable,name=time_to_combustion,op=max,value=cooldown.buff_disciplinary_command.remains,if=runeforge.disciplinary_command&buff.disciplinary_command.down
        if runeforge.disciplinaryCommand.equiped 
        and not buff.disciplinaryCommand.react() then var.time_to_combustion                   = cd.disciplinaryCommand.remains(); end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Variable that estimates whether Shifting Power will be used before Combustion is ready.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/variable,name=shifting_power_before_combustion,op=set,value=(active_enemies<variable.combustion_shifting_power|active_enemies<variable.combustion_flamestrike|variable.time_to_combustion-action.shifting_power.full_reduction>cooldown.shifting_power.duration)&variable.time_to_combustion-cooldown.shifting_power.remains>action.shifting_power.full_reduction&(cooldown.rune_of_power.remains-cooldown.shifting_power.remains>5|!talent.rune_of_power)
        -- actions+=/shifting_power,if=buff.combustion.down&!(buff.infernal_cascade.up&buff.hot_streak.react)&variable.shifting_power_before_combustion
        if var.shifting_power_before_combustion   == nil 
        then var.shifting_power_before_combustion                                               = 0; end
        if covenant.nightFae.active and not buff.combustion.react()
        and (not buff.infernalCascade.react() 
        and buff.hotStreak.react() and var.bool(var.shifting_power_before_combustion))
        then 
        var.shifting_power_before_combustion                                                    = (#enemies.yards18t>=var.num(var.combustion_shifting_power) or #enemies.yards18t < var.combustion_flamestrike or var.time_to_combustion-4>60) and var.time_to_combustion-cd.shiftingPower.remains() > 4 and (cd.runeOfPower.remains()-cd.shiftingPower.remains() > 5 or not talent.runeOfPower); end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Variable that controls Fire Blast usage to ensure its charges pooled for Combustion.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/variable,use_off_gcd=1,use_while_casting=1,name=fire_blast_pooling,op=set,value=variable.time_to_combustion-3<action.fire_blast.full_recharge_time-action.shifting_power.full_reduction*variable.shifting_power_before_combustion&variable.time_to_combustion<fight_remains
        var.fire_blast_pooling                                                                  = var.time_to_combustion-3<charges.fireBlast.timeTillFull()-4*var.num(var.shifting_power_before_combustion) and var.time_to_combustion<ttd("target");
         --variable,name=fire_blast_pooling,value=talent.rune_of_power.enabled&cooldown.rune_of_power.remains<cooldown.fire_blast.full_recharge_time&(cooldown.combustion.remains>variable.combustion_rop_cutoff|firestarter.active)&(cooldown.rune_of_power.remains<target.time_to_die|action.rune_of_power.charges>0)|cooldown.combustion.remains<action.fire_blast.full_recharge_time+cooldown.fire_blast.duration*azerite.blaster_master.enabled&!firestarter.active&cooldown.combustion.remains<target.time_to_die|talent.firestarter.enabled&firestarter.active&firestarter.remains<cooldown.fire_blast.full_recharge_time+cooldown.fire_blast.duration*azerite.blaster_master.enabled
        --fireBlastPool = talent.runeOfPower and cd.runeOfPower.remain() < cd.fireBlast.remain() and (cd.combustion.remain() > combustionROPcutoff or firestarterActive) and (cd.runeOfPower.remain() < ttd("target") or charges.runeOfPower.count() > 0) or cd.combustion.remain() < bMasterFBCD and not firestarterActive and cd.combustion.remain() < ttd("target") or talent.firestarter and firestarterActive and firestarterremain < bMasterFBCD then
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Variable that controls Phoenix Flames usage to ensure its charges are pooled for Combustion.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/variable,name=phoenix_pooling,op=set,value=variable.time_to_combustion<action.phoenix_flames.full_recharge_time-action.shifting_power.full_reduction*variable.shifting_power_before_combustion&variable.time_to_combustion<fight_remains|runeforge.sun_kings_blessing|time<5
        var.phoenix_pooling                                                                     = var.time_to_combustion < charges.phoenixFlames.timeTillFull()-4*var.num(var.shifting_power_before_combustion) and var.time_to_combustion < ttd("target") or combatTime < 5;
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Adjust the variable that controls Fire Blast usage to ensure its charges are also pooled for Rune of Power.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/variable,use_off_gcd=1,use_while_casting=1,name=fire_blast_pooling,op=set,value=cooldown.rune_of_power.remains<action.fire_blast.full_recharge_time-action.shifting_power.full_reduction*(variable.shifting_power_before_combustion&cooldown.shifting_power.remains<cooldown.rune_of_power.remains)&cooldown.rune_of_power.remains<fight_remains,
        -- if=!variable.fire_blast_pooling&talent.rune_of_power&buff.rune_of_power.down
        if not var.fire_blast_pooling --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        and talent.runeOfPower and not buff.runeOfPower.react() then 
        var.on_use_cutoff                                                                       = buff.runeOfPower.exists() and cd.runeOfPower.remains() < charges.fireBlast.timeTillFull()-3.4*(var.num(var.shifting_power_before_combustion) and cd.shiftingPower.remains() < cd.runeOfPower.remains() and cd.runeOfPower.remains() < ttd("target")); end                  
        ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- spellqueue ready
        local function spellQueueReady()
            --Check if we can queue cast
            local castingInfo = {br._G.UnitCastingInfo("player")}
            if castingInfo[5] then
                if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow")))/1000)) < 0 then
                    return false
                end
            end
            return true
        end


    --Spell steal
    local doNotSteal = {
        [273432] = "Bound By Shadow(Uldir)",
        [269935] = "Bound By Shadow(KR)"
    }
    local function spellstealCheck(unit)
        local i = 1
        local buffName, _, _, _, duration, expirationTime, _, isStealable, _, spellId = br._G.UnitBuff(unit, i)
        while buffName do
            if doNotSteal[spellId] then
                return false
            elseif isStealable and (GetTime() - (expirationTime - duration)) > dispelDelay then
                return true
            end
            i = i + 1
            buffName, _, _, _, duration, expirationTime, _, isStealable, _, spellId = br._G.UnitBuff(unit, i)            
        end
        return false
    end

    -- Blacklist enemies
    local function isTotem(unit)
        local eliteTotems = {
            -- totems we can dot
            [125977] = "Reanimate Totem",
            [127315] = "Reanimate Totem",
            [146731] = "Zombie Dust Totem"
        }
        local creatureType = br._G.UnitCreatureType(unit)
        local objectID = br.GetObjectID(unit)
        if creatureType ~= nil and eliteTotems[objectID] == nil then
            if creatureType == "Totem" or creatureType == "Tótem" or creatureType == "Totém" or creatureType == "Тотем" or creatureType == "토템" or creatureType == "图腾" or creatureType == "圖騰" then
                return true
            end
        end
        return false
    end

    local noDotUnits = {
        [135824] = true, -- Nerubian Voidweaver
        [139057] = true, -- Nazmani Bloodhexer
        [129359] = true, -- Sawtooth Shark
        [129448] = true, -- Hammer Shark
        [134503] = true, -- Silithid Warrior
        [137458] = true, -- Rotting Spore
        [139185] = true, -- Minion of Zul
        [120651] = true -- Explosive
    }

    local function noDotCheck(unit)
        if br.isChecked("Dot Blacklist") and (noDotUnits[br.GetObjectID(unit)] or br._G.UnitIsCharmed(unit)) then
            return true
        end
        if isTotem(unit) then
            return true
        end
        local unitCreator = br._G.UnitCreator(unit)
        if unitCreator ~= nil and br._G.UnitIsPlayer(unitCreator) ~= nil and br._G.UnitIsPlayer(unitCreator) == true then
            return true
        end
        if br.GetObjectID(unit) == 137119 and br.getBuffRemain(unit, 271965) > 0 then
            return true
        end
        return false
    end

    
          --calc damge
    local function calcDamage(spellID, unit)
        local spellPower = GetSpellBonusDamage(5)
        local spMod
        local dmg = 0

        return dmg * (1 + ((GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100))
    end
    local function calcHP(unit)
        local thisUnit = unit.unit
        local hp = br._G.UnitHealth(thisUnit)
        if br.unlocked then
            local castID, _, castTarget = br._G.UnitCastID("player")
            if castID and castTarget and br.GetUnitIsUnit(unit, castTarget) and playerCasting then
                hp = hp - calcDamage(castID, unit)
            end
            for k, v in pairs(spell.abilities) do
                if br.InFlight.Check(v, thisUnit) then
                    hp = hp - calcDamage(v, unit)
                end
            end
            -- if UnitIsVisible("pet") then
            --     castID, _, castTarget = br._G.UnitCastID("pet")
            --     if castID and castTarget and UnitIsUnit(unit, castTarget) and br._G.UnitCastingInfo("pet") then
            --         local castRemain = (select(5, br._G.UnitCastingInfo("pet")) / 1000) - GetTime()
            --         if castRemain < 0.5 then
            --             hp = hp - calcDamage(castID, unit)
            --         end
            --     end
            -- end
        end
        return hp
    end

    local standingTime = 0
    if DontMoveStartTime then
        standingTime = GetTime() - DontMoveStartTime
    end

    --wipe timers table
    if timersTable then
        wipe(timersTable)
    end

    --local enemies table with extra data
    local facingUnits = 0
    local enemyTable40 = {}
    if #enemies.yards40 > 0 then
        local highestHP
        local lowestHP
        local distance20Max
        local distance20Min
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if (not noDotCheck(thisUnit) or br.GetUnitIsUnit(thisUnit, "target")) and not br._G.UnitIsDeadOrGhost(thisUnit) and (mode.rotation ~= 2 or br.GetUnitIsUnit(thisUnit, "target")) then
                local enemyUnit = {}
                enemyUnit.unit = thisUnit
                enemyUnit.ttd = ttd(thisUnit)
                enemyUnit.distance = br.getDistance(thisUnit)
                enemyUnit.distance20 = math.abs(enemyUnit.distance - 20)
                enemyUnit.hpabs = br._G.UnitHealth(thisUnit)
                enemyUnit.facing = br.getFacing("player", thisUnit)
                if br.getOptionValue("APL Mode") == 2 then
                    enemyUnit.frozen = isFrozen(thisUnit)
                end
                enemyUnit.calcHP = calcHP(enemyUnit)
                tinsert(enemyTable40, enemyUnit)
                if enemyUnit.facing then
                    facingUnits = facingUnits + 1
                end
                if highestHP == nil or highestHP < enemyUnit.hpabs then
                    highestHP = enemyUnit.hpabs
                end
                if lowestHP == nil or lowestHP > enemyUnit.hpabs then
                    lowestHP = enemyUnit.hpabs
                end
                if distance20Max == nil or distance20Max < enemyUnit.distance20 then
                    distance20Max = enemyUnit.distance20
                end
                if distance20Min == nil or distance20Min > enemyUnit.distance20 then
                    distance20Min = enemyUnit.distance20
                end
            end
        end
        if #enemyTable40 > 1 then
            for i = 1, #enemyTable40 do
                local hpNorm = (5 - 1) / (highestHP - lowestHP) * (enemyTable40[i].hpabs - highestHP) + 5 -- normalization of HP value, high is good
                if hpNorm ~= hpNorm or tostring(hpNorm) == tostring(0 / 0) then
                    hpNorm = 0
                end -- NaN check
                local distance20Norm = (3 - 1) / (distance20Max - distance20Min) * (enemyTable40[i].distance20 - distance20Min) + 1 -- normalization of distance 20, low is good
                if distance20Norm ~= distance20Norm or tostring(distance20Norm) == tostring(0 / 0) then
                    distance20Norm = 0
                end -- NaN check
                local enemyScore = hpNorm + distance20Norm
                if enemyTable40[i].facing then
                    enemyScore = enemyScore + 10
                end
                if enemyTable40[i].ttd > 1.5 then
                    enemyScore = enemyScore + 10
                end
                enemyTable40[i].enemyScore = enemyScore
            end
            table.sort(
                enemyTable40,
                function(x, y)
                    return x.enemyScore > y.enemyScore
                end
            )
        end
        -- Auto target if we have no target in combat. 
        if br.isChecked("Auto Target") and (inCombat or not inCombat and solo ) and #enemyTable40 > 0 
        and ((br.GetUnitExists("target") 
        and br.GetUnitIsDeadOrGhost("target") 
        and not br.GetUnitIsUnit(enemyTable40[1].unit, "target")) 
        or not br.GetUnitExists("target")) 
        then
            br._G.TargetUnit(enemyTable40[1].unit)
        end
        
    -- Declare Auto Faccia's glory into existence. 
    var.kinkyModule_AutoFaccia = function(delay) 
        if delay == nil then delay = ui.value("Auto Faccia Delay") end;
        if bool == nil then bool = true end;

        -- Auto Faccia and solo and are not facing this unit mafukkaaaaa 
        if br.isChecked("Auto Faccia") and (inCombat or not inCombat and solo ) and #enemyTable40 > 0 
        and (br.GetUnitExists("target") and br._G.UnitCanAttack("target", "player") 
        and not br.GetUnitIsDeadOrGhost("target") and br.isValidTarget("target")) and br.getDistance("target") < 30
        and not br.getFacing("player", "target") 
        and br.timer:useTimer("Fauccia Delay1", math.random(5))
        then
            br._G.FaceDirection("target",true);
            -- Persistence is key, young padawan. 
            if not br.getFacing("player", "target") and br.timer:useTimer("Fauccia Delay15", math.random(5)) then br._G.FaceDirection("target",true) end;
        end
    end
        -- It's a 15 year old game and I'm a caster, would you just fuck off. 

        var.kinkyModule_AutoFaccia(ui.value("Auto Faccia Delay") + math.random())
    end

function cl:Mage(...)
    if GetSpecialization() == 2 then
        local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination, destName, destFlags, destRaidFlags, spell, spellName, _, spellType = CombatLogGetCurrentEventInfo()
        var.sourcePointer = nil
		var.destPointer = nil

        -- Scan enemy table for our pointers. 
        for i = 1, #enemyTable40 do
            var.thisUnit = enemyTable40[i].unit
            var.guid = br._G.UnitGUID(var.thisUnit)
			if destGUID == guid then var.destPointer = var.thisUnit; end
			if sourceGUID == guid then var.sourcePointer = var.thisUnit; end
		end
        -- Scan friendly table for our pointers. 
		for i = 1, #br.friend do
            var.thisFriend = br.friend[i].unit
            var.guid = br._G.UnitGUID(var.thisFriend)
            if destGUID == guid then var.destPointer = var.thisFriend; end
			if sourceGUID == guid then var.sourcePointer = var.thisFriend;end
           
        end
        -- Declare pointers if they're nil. 
		if not var.sourcePointer and sourceGUID then 
            var.sourcePointerr = br.ObjectPosition(sourceGUID); 
        end
		if not var.destPointer and destGUID then 
            var.destPointer = br.ObjectPosition(destGUID); 
        end

		var.time = GetTime()

        -- Detect stealthy assholes. 
		--[[if subEvent == "SPELL_CAST_SUCCESS" and sourcePointer then
			local stealthTable = {
				[115191] = 115191,		-- Rogue Stealth
				[1856] = 11327,			-- Rogue Vanish
				[5215] = 5215, 			-- Druid Prowl	
				[66] = 32612,			-- Mage Invis
			}
			if stealthTable[spellID] and br._G.UnitCanAttack("player", sourcePointer) then
				local x,y,z = ObjectPosition(sourcePointer)
				local info = {
					speed = GetUnitSpeed(sourcePointer),
					direction = GetMovingDirection(sourcePointer),
					x = x,
					y = y,
					z = z,
					time = GetTime(),
					pointer = sourcePointer,
					id = stealth_ids[spellID],
					name = spellName,
				}
				table.insert(stealth_tracker,info)
			end 
        end]]
    end 
end

local GetDistanceBetweenPositions = function(X1, Y1, Z1, X2, Y2, Z2) return math.sqrt(math.pow(X2 - X1, 2) + math.pow(Y2 - Y1, 2) + math.pow(Z2 - Z1, 2)) end

var.kinkyModule_TrumpSaidBlinkMeToAShitHoleCountry = function()
	local px, py, pz = GetPlayerPosition()
	local points = {}

	for i=0,math.pi*2,.1256 do
		local bx, by, bz = GroundZ ( px + 20 * math.cos(i), py + 20 * math.sin(i), pz )
		if bx and by and bz and not TraceLine( px, py, pz + 1.2, bx, by, bz + 1.2, collisionflags ) then
			local zdif = pz - bz
			--max z dif of 1 yd
			if zdif < 1.25 and zdif > -1.25 then
				--make negative zdif positive for proper sorting (don't want climbing angle too high or too low)
				if zdif < 0 then zdif = -zdif end
				local _,_,avg_dist = Enemies_Around_Point(bx,by,bz,50)
				if avg_dist then
					table.insert(points,{x=bx,y=by,z=bz,dist=avg_dist,zdif=math.floor(zdif)})
				end
			end
		end
	end
    
	table.sort(points,function(x,y) return x.dist > y.dist end)

	if #points > 0 then
		if #points == 1 then
			return points[1].x,points[1].y,points[1].z
		else
			local index = math.ceil(#points/8)
			local a,b,c = points[index].x,points[index].y,points[index].z
			return a,b,c,points[index].dist
		end
	end
end

local blinkDBPoint = function(unit)
	if not UnitIsVisible(unit) then return false end
	local x,y,z = br.ObjectPosition(unit)
	local px,py,pz = br.GetPlayerPosition()

	-- local step = (math.pi*2) / 8
	-- for n=3,8 do
	-- 	for i=0,math.pi*2,step do
	-- 		if not TraceLine(x - n * math.cos(i), y - n * math.sin(i), z+2, px, py, pz+2, 0x100111) then

	local maxdist = 10.5

	local points = {}

	local step = (math.pi*2) / 12
	local direction
	for i=0,math.pi*2,step do
		local bx, by, bz = GroundZ ( px + 20 * math.cos(i), py + 20 * math.sin(i), pz )
		if bx and by and bz and not br.TraceLine(px, py, pz+1.2, bx, by, bz+1.2, collisionflags) then
			local zdif = pz - bz
			if zdif < 1.5 and zdif > -1.5 then
				if zdif < 0 then zdif = -zdif end
				if not TraceLine( bx, by, bz + 1.7, x, y, z + 1.7, losflags ) then
					local dist = br.GetDistanceBetweenPositions(x,y,z,bx,by,bz)
					if dist < maxdist then
						table.insert(points,{x=bx,y=by,z=bz,dist=dist,zdif=math.floor(zdif)})
					end
				end
			end
		end
	end

	table.sort(points,function(x,y) return x.zdif < y.zdif or ( x.zdif == y.zdif and x.dist < y.dist ) end)

	if #points > 0 then
		if #points == 1 then
			local a,b,c = points[1].x,points[1].y,points[1].z
			return a,b,c,points[1].dist
		else
			-- local a,b,c = GroundZ(points[1].x,points[1].y,points[1].z)
			-- return a,b,c,points[1].dist
			local index = math.ceil(#points/4)
			local a,b,c = points[index].x,points[index].y,points[index].z
			return a,b,c,points[index].dist
		end
	end
end

local function blink_db(unit)

	local time = GetTime()

	if not Squid_DB then return false end

	if _spellCooldown(31661) > .1 then return false end

	if not UnitIsVisible(unit) then return false end

	local px,py,pz = GetPlayerPosition()

	local x,y,z = blink_db_point(unit)

	if _distance(unit) > 12.5 then
		if x and y and z and _spellCooldown(212653) == 0 and (not player_blink or time - player_blink > squid_avg_latency + .5) then
			local dir = GetAnglesBetweenPositions(px,py,pz,x,y,z)
			FaceDirection(dir,true)
			local c = ObjectFacing("player") 
			if abs( c - dir ) < .1 then
				SQ_CastSpellByID(1953)
				player_blink = time
				return true
			end
		end
	else 
		x,y,z = PredictUnitPosition(unit,.08)
		if GetDistanceBetweenPositions(x,y,z,px,py,pz) < 9.25 and not TraceLine(x,y,z+1.6,px,py,pz+1.6,losflags) then
			if unit_casting_info("player") ~= "Greater Pyroblast" then
				SpellStopCasting()
			end
			return Squid_DB(unit)
		end
	end

end

Enemies_Around_Point = function(x,y,z,dist,unit)
    ObjectPosition = wmbapi.ObjectPosition
	local avgdist=0
	local totalcount=0
	local totaldist=0.00001 -- sometimes will end up dividing by zero if this started at zero
	local count=0
	local bcc=0
	for i=1,#Enemies do --(br.GetUnitIsUnit(thisUnit, "target")
		if not unit or not br.GetUnitIsUnit(Enemies[i],unit) then
			local ex,ey,ez = br.ObjectPosition(Enemies[i])
			local distance_from_pos = GetDistanceBetweenPositions(x,y,z,ex,ey,ez)
			if distance_from_pos <= dist then
				count=count+1;
				if _breakableCC(Enemies[i]) then
					bcc=bcc+1
					--prio bcc units in avg dist
					if distance_from_pos < dist*1.75 then
						totaldist = totaldist + distance_from_pos
					end
				end
			end
			--units within 2x the given dist
			if distance_from_pos < dist*1.75 then

				totalcount=totalcount+1

				totaldist=totaldist+distance_from_pos

			end
		end
	end
	avgdist = totaldist/totalcount
	return count,bcc,avgdist
end

local EnemiesAttacking = function(friend,role)
	local count=0
	local melee=0
	local range=0
	local cds=0
	for i=1,#Enemies do
		local e = Enemies[i]
		if (not arena or unit_is_player(e)) and _CCremains(e) < .25 and not _isHealer(e) then
			local r = arena and _isRangedDps(e) or UnitCastingInfo(e)
			local m = arena and _isMeleeDps(e) or not r

			local inrange
			if unit_is_unit(friend,"player") then
				if m then inrange = _distance(e) < 6 end
				if r then inrange = _distance(e) < 40 and _LoS(e) end
			else
				if m then inrange = _distance(friend,e) < 6 end
				if r then inrange = _distance(friend,e) < 40 and _LoS(friend,e) end
			end
			if inrange then
				if not role or (role == 1 and m) or (role == 2 and r) then
					local cd_up = _CDcheck(e)
					local enemytarget=UnitTarget(e)
					if unit_is_unit(friend,enemytarget) then
						count = count + 1
						melee = melee + (m and 1 or 0)
						range = range + (r and 1 or 0)
						cds = cds + (cd_up and 1 or 0)
					end
				end
			end
		end
	end
	return count,melee,range,cds
end

local UnitEnemiesAttacking = function(unit,role)
	local count=0
	local melee=0
	local range=0
	local cds=0
	-- if not unit then error("No unit specified (UnitEnemiesAttacking") return 0,0,0,0 end
	if unit_can_attack("player",unit) then
		for i=1,#Friends do if not unit_is_unit(Friends[i],"player") then
			local e = Friends[i]
			if (not arena or unit_is_player(e)) and not _isHealer(e) then
				local friend_target = UnitTarget(e)
				if unit_is_unit(unit,friend_target) then

					local m = _isMeleeDps(e)
					local r = _isRangedDps(e)

					local inrange = true
					-- if m then inrange = _distance(unit,e) < 6.5 end
					-- if r then inrange = _distance(unit,e) < 40 end

					if inrange and (_CCremains(e) < .5 or ccdoesntmatter) then
						if not role or (role == 1 and m) or (role == 2 and r) then
							local cd_up = _CDcheck(e)
							count = count + 1
							melee = melee + (m and 1 or 0)
							range = range + (r and 1 or 0)
							cds = cds + (cd_up and 1 or 0)
						end
					end
				end
			end
		end end
	elseif UnitIsFriend("player",unit) then
		return EnemiesAttacking(unit,role)
	end
	return count,melee,range,cds
end

getMovingDirection = 0;
local getMovingDirection = function(unit)
	
	local R = ObjectFacing(unit);
	
	local mod = 0;

	local flags = UnitMovementFlags(unit)

	if not flags then return false 
	else flags = bit.band(flags, 0xF) end

	if flags == 0x2 then
		mod = math.pi;
	elseif flags == 0x4 then
		mod = math.pi * 0.5;
	elseif flags == 0x8 then
		mod = math.pi * 1.5;
	elseif flags == bit.bor(0x1, 0x4) then
		mod = math.pi * (1 / 8) * 2;
	elseif flags == bit.bor(0x1, 0x8) then
		mod = math.pi * (7 / 8) * 2;
	elseif flags == bit.bor(0x2, 0x4) then
		mod = math.pi * (3 / 8) * 2;
	elseif flags == bit.bor(0x2, 0x8) then
		mod = math.pi * (5 / 8) * 2;
	end

	return (R + mod) % (math.pi * 2);
end
getMovingDirection = getMovingDirection
moving_towards_table = {}

local movingTowards = function(unit,amount,otherUnit,general,nostrafe)
	if not unit then return false end
	if not otherUnit then otherUnit="player" end
	local amount = amount or .102
	local X,Y,Z = ObjectPosition(unit);
	local pX,pY,pZ = ObjectPosition(otherUnit);
	local direction = _getMovingDirection(otherUnit);
	local distance = GetUnitSpeed(otherUnit)*amount
	if UnitIsVisible(unit) then
		local yes = _distanceToCoord(pX + distance * math.cos(direction), pY + distance * math.sin(direction), pZ, X, Y, Z)+(GetUnitSpeed(otherUnit)/10) < _distanceToCoord(pX,pY,pZ,X,Y,Z);
		local flags = {
		1,
		5,
		9,
		8,
		4,
		}
		local playerflags = UnitMovementFlags("player") 
		if yes and (not nostrafe or playerflags == 1 or playerflags == 5 or playerflags == 9) and (general or tContains(flags,playerflags)) then
			for i=1,#moving_towards_table do
				local m = moving_towards_table[i]
				if m then
					if m.unit == unit and m.amount == amount and m.otherUnit == otherUnit and m.general == general then
						return true
					end
				end
			end
			table.insert(moving_towards_table,{unit=unit,amount=amount,otherUnit=otherUnit,general=general,time=GetTime()})
			return true
		else
			for i=1,#moving_towards_table do
				local m = moving_towards_table[i]
				if m then
					if m.unit == unit and m.amount == amount and m.otherUnit == otherUnit and m.general == general then
						table.remove(moving_towards_table,i)
					end
				end
			end
		end
	end
end
-- Moving Towards Unit Duration Function
local movingTowardsUnitDuration = function(unit,amount,otherUnit,general,directly,nostrafe)
	if not otherUnit then otherUnit="player" end
	local amount = amount or .102
	for i=1,#moving_towards_table do
		local m = moving_towards_table[i]
		if m.unit == unit and m.amount == amount and m.otherUnit == otherUnit and m.general == general then
			return GetTime()-m.time
		end
	end
	return 0
end
-- Moving Away Function
local movingAwayFrom = function(unit,amount,otherUnit,general,nostrafe)
	if not otherUnit then otherUnit="player" end
	local amount = amount or .102
	local X,Y,Z = ObjectPosition(unit);
	local pX,pY,pZ = ObjectPosition(otherUnit);
	local direction = _getMovingDirection(otherUnit);
	local distance = GetUnitSpeed(otherUnit)*amount
	local yes = _distanceToCoord(pX + distance * math.cos(direction), pY + distance * math.sin(direction), pZ, X, Y, Z) > _distanceToCoord(pX,pY,pZ,X,Y,Z);
	local flags = {
	1,
	5,
	9
	}
	local playerflags = UnitMovementFlags(otherUnit) 
	if yes and (not nostrafe or playerflags == 1) and (general or tContains(flags,playerflags)) then
		return true
	end
end
-- Moving Away Function
var.predictDistanceFromUnit = function(unit,time)
	if not time then time = 1 end
	local px,py,pz = PredictUnitPosition("player",time)
	local x,y,z = PredictUnitPosition(unit,time)
	if px and py and pz and x and y and z then
		local d = GetDistanceBetweenPositions(px,py,pz,x,y,z)
		return d
	else
		return -1
	end
end
-- Moving Away From Function 
local movingAwayFrom = function(unit,extra)
	extra = extra or 0
	local d = _realDistance(unit)
	if d < 5.5 and _amIfacing(unit) then return false end
	if predict_distance_from_unit(unit) > d + extra then return true end
end
los_cache = {}
local RealTravelTime = function(unit)
	local dist = (GetUnitSpeed(unit)*apl.trapTravelTime(unit))*.9
	return dist < 5 and dist or 5
end
local PlayerZDiff = function()
	local x,y,z = GetPlayerPosition()
	local _,_,gz = GroundZ(x,y,z)
	return z - gz
end

local AnyKeyPressed = function()
	if GetKeyState(0x01)
	or GetKeyState(0x02)
	or GetKeyState(0x04)
	or GetKeyState(0x05)
	or GetKeyState(0x06)
	or GetKeyState(0x09)
	or GetKeyState(0x10)
	or GetKeyState(0x11)
	or GetKeyState(0x12)
	or GetKeyState(0x31)
	or GetKeyState(0x32)
	or GetKeyState(0x33)
	or GetKeyState(0x34)
	or GetKeyState(0x35)
	or GetKeyState(0x36)
	or GetKeyState(0x37)
	or GetKeyState(0x38)
	or GetKeyState(0x39)
	or GetKeyState(0x41)
	or GetKeyState(0x42)
	or GetKeyState(0x43)
	or GetKeyState(0x44)
	or GetKeyState(0x45)
	or GetKeyState(0x46)
	or GetKeyState(0x47)
	or GetKeyState(0x48)
	or GetKeyState(0x49)
	or GetKeyState(0x51)
	or GetKeyState(0x52)
	or GetKeyState(0x53)
	or GetKeyState(0x54)
	or GetKeyState(0x56)
	or GetKeyState(0x57)
	or GetKeyState(0x58)
	or GetKeyState(0x5A)
	or GetKeyState(0x60)
	or GetKeyState(0x61)
	or GetKeyState(0x62)
	or GetKeyState(0x63)
	or GetKeyState(0x64)
	or GetKeyState(0x65)
	or GetKeyState(0x66)
	or GetKeyState(0x67)
	or GetKeyState(0x68)
	or GetKeyState(0x69) then
		return true
	end
end

local point_between_points = function(points)
	local valid_points = {}
	for i=1,#points do
		local point = points[i]
		local x,y = point[1],point[2]
		table.insert(valid_points,{x=x,y=y})
	end
	local total_x = 0
	local total_y = 0
	for i=1,#valid_points do
		total_x = total_x + valid_points[i].x
		total_y = total_y + valid_points[i].y
	end
	local x = total_x / #valid_points
	local y = total_y / #valid_points

	return TraceLine(x,y,-10000,x,y,10000,collisionflags)
end

local point_between_units = function(units)
	local points = {}
	for i=1,#units do
		local x,y,z = ObjectPosition(units[i])
		table.insert(points,{x,y,z})
	end
	return point_between_points(points)
end

--param unit, unit to check
--param elapsed, time of moving to predict position after
--returns x,y,z, the grounded position of the unit after the given time
local PredictUnitPosition = function(unit,elapsed)
	if not unit then return false end
	if not elapsed then elapsed = 1 end
	local x,y,z

	if unit_is_unit(unit,"player") then
		x,y,z = GetPlayerPosition()
	else
		x,y,z = ObjectPosition(unit)
	end

	if x and y and z then
		local direction = GetMovingDirection(unit)
		local distance = GetUnitSpeed(unit) * elapsed

		local px=x + distance * math.cos(direction);
		local py=y + distance * math.sin(direction);
		local pz=z;

		local tx,ty,tz = TraceLine(x,y,z+2,px,py,pz+2,collisionflags)

		if not tx then
			return GroundZ(px,py,pz)
		else
			return GroundZ(tx,ty,tz)

		end
	end

end

local anglesBetweenObjects = function(unit1,unit2)
	return GetAnglesBetweenObjects (unit1,unit2)
end

local findCorner = function(fx,fy,fz,diameter,flags,dist)
	if not fz then
		fx,fy,fz = ObjectPosition(fx);
		diameter = fy;
	end
	local sx,sy,sz = GetPlayerPosition()
	local radius = diameter/2 or 0
	local diameter = diameter or 0
	if not dist then dist=10000 end

	if not TraceLine(sx,sy,sz+2,fx,fy,fz+2,0x10) then
		return fx,fy,fz
	end

	if TraceLine(sx,sy,sz,fx,fy,fz,0x10) then
		for i=0,radius,2 do
			if not TraceLine(sx,sy,sz+2,fx+i,fy,fz+2,0x10) and not TraceLine(fx+i,fy,fz+4,fx,fy,fz+4,0x10) then
				return fx+i,fy,fz
			end
			
			if not TraceLine(sx,sy,sz+2,fx,fy+i,fz+2,0x10) and not TraceLine(fx,fy+i,fz+4,fx,fy,fz+4,0x10) then
				return fx,fy+i,fz
			end
			
			if not TraceLine(sx,sy,sz+2,fx-i,fy,fz+2,0x10) and not TraceLine(fx-i,fy,fz+4,fx,fy,fz+4,0x10) then
				return fx-i,fy,fz
			end
			
			if not TraceLine(sx,sy,sz+2,fx,fy-i,fz+2,0x10) and not TraceLine(fx,fy-i,fz+4,fx,fy,fz+4,0x10) then
				return fx,fy-i,fz
			end
			
			if not TraceLine(sx,sy,sz+2,fx-i,fy-i,fz+2,0x10) and not TraceLine(fx,fy-i,fz+4,fx,fy,fz+4,0x10) then
				return fx-i,fy-i,fz
			end
			
			if not TraceLine(sx,sy,sz+2,fx+i,fy+i,fz+2,0x10) and not TraceLine(fx,fy-i,fz+4,fx,fy,fz+4,0x10) then
				return fx+i,fy+i,fz
			end
		end
	end
	return fx,fy,fz
end

local position_after_blink = function(direction)
	local px,py,pz = GetPlayerPosition()
	--ideal blink position (no obstacles)
	local bx,by,bz = GroundZ(px + 20 * math.cos(direction), py + 20 * math.sin(direction), pz)
	local x,y,z = px,py,pz
	
	if bx and by and bz then
		for i=1,20,.5 do
			local nx,ny,nz = GetPositionBetweenPositions(px,py,pz,bx,by,bz,i)
			nx,ny,nz = GroundZ(nx,ny,nz)
			local zdif = nz - z
			if zdif > .5 or zdif < -.5 then
				local lx,ly,lz = x,y,z--GetPositionBetweenPositions(x,y,z,px,py,pz,min(2,i))
				return lx,ly,lz
			else
				x,y,z = nx,ny,nz
			end
		end
	end
	return x,y,z
end

local get_future_position = function(unit, castTime)
    local distance = min ( 5, GetUnitSpeed(unit) ) * castTime
    if distance > 0 then
        local x,y,z = ObjectPosition(unit)
        local angle = _getMovingDirection(unit)--ObjectFacing(unit)
        --If Unit have a target, let's make sure they don't collide
        local unitTarget = UnitTarget(unit)
        local unitTargetDist = 0
        if unitTarget ~= nil then
            local tX, tY, tZ = ObjectPosition(unitTarget)
            --Lets get predicted position of unit target aswell
            if GetUnitSpeed(unitTarget) > 0 then
                local tDistance = ( GetUnitSpeed(unitTarget) * castTime ) / 1.7
                local tAngle = GetAnglesBetweenObjects(unit,unitTarget) -- _getMovingDirection(unitTarget)
                tX = tX + cos(tAngle) * tDistance
                tY = tY + sin(tAngle) * tDistance
                unitTargetDist = sqrt(((tX-x)^2) + ((tY-y)^2) + ((tZ-z)^2)) - ((UnitCombatReach(unit) or 0) + (UnitCombatReach(unitTarget) or 0))
                if unitTargetDist < distance then distance = unitTargetDist end
            else
                unitTargetDist = _distance(unitTarget, unit)
                if unitTargetDist < distance then distance = unitTargetDist end
            end
            -- calculate angle based on target position/future position
            angle = rad(atan2(tY - y, tX - x))
            if angle < 0 then
                angle = rad(360 + atan2(tY - y, tX - x))
            end
        end
        x = x + cos(angle) * distance
        y = y + sin(angle) * distance
        return x, y, z
    end
    return ObjectPosition(unit)
end
--check if unit is inside of a circle
local unitInCircle = function(unit, cx, cy, radius, castTime)
    local uX, uY = 0, 0
    if castTime == nil or castTime == 0 then
          uX, uY = ObjectPosition(unit)
    else
          uX, uY = get_future_position(unit, castTime)
    end
    local rUnit = UnitBoundingRadius(unit)
    return math.abs((uX - cx) * (uX - cx) + (uY - cy) * (uY - cy)) <= (rUnit + radius) * (rUnit + radius);
end


        --Clear last cast table ooc to avoid strange casts
        if not inCombat and #br.lastCastTable.tracker > 0 then
            wipe(br.lastCastTable.tracker)
        end
        -- spell usable check
        local function spellUsable(spellID)
            if br.isKnown(spellID) and not select(2, IsUsableSpell(spellID)) and br.getSpellCD(spellID) == 0 then
                return true
            end
            return false
        end
        ---Target move timer
        if lastTargetX == nil then lastTargetX, lastTargetY, lastTargetZ = 0,0,0 end
            targetMoveCheck = targetMoveCheck or false
            if br.timer:useTimer("targetMove", math.random(0.2,0.8)) or combatTime < 0.2 then
                if br.GetObjectExists("target") then
                local currentX, currentY, currentZ = br.GetObjectPosition("target")
                local targetMoveDistance = math.sqrt(((currentX-lastTargetX)^2)+((currentY-lastTargetY)^2)+((currentZ-lastTargetZ)^2))
                lastTargetX, lastTargetY, lastTargetZ = br.GetObjectPosition("target")
                if targetMoveDistance < 3 then targetMoveCheck = true else targetMoveCheck = false end
            end
        end

        --Tank/Healer move check for aoe
        local tankMoving = false
        local healerMoving = false
        if inInstance then
            for i = 1, #br.friend do
                if (br.friend[i].role == "TANK" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") and br.isMoving(br.friend[i].unit) then
                    tankMoving = true
                elseif (br.friend[i].role == "HEALER" or br._G.UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER") and br.isMoving(br.friend[i].unit) then
                    healerMoving = true
                end
            end
        end
        local function meteor(unit)
            local combatRange = max(5, br._G.UnitCombatReach("player") + br._G.UnitCombatReach(unit))
            local px, py, pz = br.GetObjectPosition("player")
            local x, y, z = br._G.GetPositionBetweenObjects(unit, "player", combatRange - 2)
            z = select(3, br._G.TraceLine(x, y, z + 5, x, y, z - 5, 0x110)) -- Raytrace correct z, Terrain and WMO hit
            if z ~= nil and br._G.TraceLine(px, py, pz + 2, x, y, z + 1, 0x100010) == nil and br._G.TraceLine(x, y, z + 4, x, y, z, 0x1) == nil then -- Check z and LoS, ignore terrain and m2 colissions and check no m2 on hook location
                br._G.CastSpellByName(GetSpellInfo(spell.meteor))
                br.addonDebug("Casting Meteor")
                br._G.ClickPosition(x, y, z)
                if wasMouseLooking then
                    MouselookStart()
                end
            end
        end

        local fbTracker = 0
        for i = 1, 3 do
            local cast = br.lastCastTable.tracker[i]
            if cast == 108853 then
                fbTracker = fbTracker + 1
            end
        end

        local instantPyro = br.getCastTime(spell.pyroblast) == 0 or false

        var.kinkyModule_blinkToLife = function() 
            
        end

        
        var.blinkTo = function (x,y,z)
    	local px,py,pz = GetPlayerPosition()
    	if x and y and z and _spellCooldown(212653) == 0 then


		local dir = GetAnglesBetweenPositions(px,py,pz,x,y,z)
		FaceDirection(dir,true)
		SQ_CastSpellByID(1953)
		player_blink = GetTime()
		return true
	end
end

var.kinkyModule_dragonsBrooth = function() 
    var.objFacing = br.ObjectFacing("player")
    

    for i = 1, #Enemies.yards10 do 
        if br.getDistance("target") <= 8.5 and interruptCast() then 
        
        end
    end
end

var.kinkyModule_scorchSniper = function()
    if not talent.searingTouch then return false; end

    if standingTime >= 1 then
        for i = 1, #enemies.yards40f do
        local thisUnit = enemies.yards40f[i]
            if br.getHP(thisUnit) <= 30 then
                scorchTarget = thisUnit
            end
        end
    end
    if br.isChecked("Scorch Sniper") and scorchTarget ~= nil
    and standingTime >= ui.value("Scorch Standing Time") 
    and not br.isBoss("target") and not br.isExplosive("target") 
    and br.getFacing("player","target") or ui.checked("Auto Faccia")
    then
        if cast.scorch(scorchTarget) then debug("[Scorch Sniper] Scorch Snipe mafukkkakakaka!")
            return true
        end
    end    
end -- End Drain Soul Sniper APL

--------------------
--- Action Lists ---
--------------------
    -- Action List - Extras
        local function actionList_Extras()
        -- Dummy Test
            if br.isChecked("DPS Testing") then
                if br.GetObjectExists("target") then
                    if combatTime >= (tonumber(br.getOptionValue("DPS Testing"))*60) and br.isDummy() then
                        br._G.StopAttack()
                        br._G.ClearTarget()
                        br._G.print(tonumber(br.getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                        br.profileStop = true
                    end
                end
            end -- End Dummy Test
            -- Arcane Intellect
            if br.isChecked("Arcane Intellect") and br.timer:useTimer("AI Delay", math.random(15, 30)) then
                for i = 1, #br.friend do
                    if not buff.arcaneIntellect.exists(br.friend[i].unit,"any") and br.getDistance("player", br.friend[i].unit) < 40 and not br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br._G.UnitIsPlayer(br.friend[i].unit) then
                        if cast.arcaneIntellect() then return true end
                    end
                end
            end
        end -- End Action List - Extras

    -- Action List - Defensive
        local function actionList_Defensive()
            if br.useDefensive() then
        -- Basic Healing Module
                module.BasicHealing()
        -- Pot/Stoned
                if br.isChecked("Pot/Stoned") and php <= br.getOptionValue("Pot/Stoned") 
                    and inCombat and (br.hasHealthPot() or br.hasItem(5512)) 
                then
                    if br.canUseItem(5512) then
                        br.useItem(5512)
                    elseif br.canUseItem(healPot) then
                        br.useItem(healPot)
                    end
                end

        -- Heirloom Neck
                if br.isChecked("Heirloom Neck") and php <= br.getOptionValue("Heirloom Neck") then
                    if br.hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            br.useItem(122668)
                        end
                    end
                end

        -- Gift of the Naaru
                if br.isChecked("Gift of the Naaru") and php <= br.getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                    if br.castSpell("player",racial,false,false,false) then return true end
                end

        -- Frost Nova
                if br.isChecked("Frost Nova") and php <= br.getOptionValue("Frost Nova") and #enemies.yards10 > 0 and br.getDistance("target") <= 12 then
                    if cast.frostNova("target") then return true end --Print("fs") return end
                end

        -- Blast Wave
                if talent.blastWave and br.isChecked("Blast Wave") and php <= br.getOptionValue("Blast Wave") then
                    for i = 1, #enemies.yards10 do
                        local thisUnit = enemies.yards10[i]
                        if #enemies.yards10 > 1 and br.hasThreat(thisUnit) then
                            if cast.blastWave("player","aoe",1,10) then return true end
                        end
                    end
                end

        -- Blazing Barrier
                if not IsResting() and br.isChecked("Blazing Barrier") and ((php <= br.getOptionValue("Blazing Barrier") and inCombat) or (br.isChecked("Blazing Barrier OOC") and not inCombat)) and not buff.blazingBarrier.react() and not br.isCastingSpell(spell.fireball) and not buff.hotStreak.react() and not buff.heatingUp.react() then
                    if cast.blazingBarrier("player") then return true end
                end

        -- Iceblock
                if br.isChecked("Ice Block") and php <= br.getOptionValue("Ice Block") and cd.iceBlock.remains() <= gcd and not solo then
                    if br._G.UnitCastingInfo("player") then
                        br._G.RunMacroText('/stopcasting')
                    end
                    if cast.iceBlock("player") then
                        return true
                    end
                end

        -- Spell Steal
        if br.isChecked("Spellsteal") then
            if br.getOptionValue("Spellsteal") == 1 then
                if spellstealCheck("target") and br.GetObjectExists("target") then
                    if cast.spellsteal("target") then br.addonDebug("Casting Spellsteal") return true end
                end
            elseif br.getOptionValue("Spellsteal") == 2 then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if spellstealCheck(thisUnit) then
                        if cast.spellsteal(thisUnit) then br.addonDebug("Casting Spellsteal") return true end
                    end
                end
            end
        end

         --Remove Curse, Yoinked from Aura balance
            if br.isChecked("Remove Curse") then
                if br.getOptionValue("Remove Curse") == 1 then
                    if br.canDispel("player",spell.removeCurse) then
                        if cast.removeCurse("player") then return true end
                    end
                elseif br.getOptionValue("Remove Curse") == 2 then
                    if br.canDispel("target",spell.removeCurse) then
                        if cast.removeCurse("target") then return true end
                    end
                elseif br.getOptionValue("Remove Curse") == 3 then
                    if br.canDispel("player",spell.removeCurse) then
                        if cast.removeCurse("player") then return true end
                    elseif br.canDispel("target",spell.removeCurse) then
                        if cast.removeCurse("target") then return true end
                    end
                elseif br.getOptionValue("Remove Curse") == 4 then
                    if br.canDispel("mouseover",spell.removeCurse) then
                        if cast.removeCurse("mouseover") then return true end
                    end
                elseif br.getOptionValue("Remove Curse") == 5 then
                    for i = 1, #br.friend do
                        if br.canDispel(br.friend[i].unit,spell.removeCurse) then
                            if cast.removeCurse(br.friend[i].unit) then return true end
                        end
                    end
                end
            end
            end -- End Defensive Toggle
        end -- End Action List - Defensive
        

    local function actionList_Interrupts()
        if br.useInterrupts() and cd.counterspell.remain() == 0 then

            if not br.isChecked("Do Not Cancel Cast") or not playerCasting then
                for i = 1, #enemyTable40 do
                    local thisUnit = enemyTable40[i].unit
                    if br.canInterrupt(thisUnit, br.getOptionValue("Interrupt At")) then
                        if cast.counterspell(thisUnit) then
                            return
                        end
                    end
                end
            end
        end
    end

    -- Action List - Cooldowns
        local function actionList_Cooldowns()
            if br.useCDs() and br.getDistance("target") < 40 then
        -- Potion
            if br.isChecked("Potion") and not buff.potionOfUnbridledFury.react() and br.canUseItem(item.potionOfUnbridledFury) and buff.combustion.exists("player") then
                if use.potionOfUnbridledFury() then br.addonDebug("Using Potion of Unbridled Fury") return end
            end

        -- Racial: Orc Blood Fury | Troll Berserking | Blood Elf Arcane Torrent
                -- blood_fury | berserking | arcane_torrent
                if br.isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "Blood Elf") and buff.combustion.exists("player") then
                    if br.castSpell("player",racial,false,false,false) then return end
                end

                -- Trinkets
                local mainHand = GetInventorySlotInfo("MAINHANDSLOT")
                if br.canUseItem(mainHand) and equiped.neuralSynapseEnhancer(mainHand) and ((talent.runeOfPower and buff.runeOfPower.exists("player")) or not talent.runeOfPower) then
                    use.slot(mainHand)
                    br.addonDebug("Using Neural SynapseEnhancer")
                end

                if buff.combustion.exists("player") then 
                    if (br.getOptionValue("Trinkets") == 1 or br.getOptionValue("Trinkets") == 3) and br.canUseItem(13) then
                        if br._G.UnitCastingInfo("player") then
                            br._G.SpellStopCasting()
                        end
                        br.useItem(13)
                        br.addonDebug("Using Trinket 1")
                        return
                    end

                    if (br.getOptionValue("Trinkets") == 2 or br.getOptionValue("Trinkets") == 3) and br.canUseItem(14) then
                        if br._G.UnitCastingInfo("player") then
                            br._G.SpellStopCasting()
                        end
                        br.useItem(14)
                        br.addonDebug("Using Trinket 2")
                        return
                    end
                end
            end -- End br.useCDs check
        end -- End Action List - Cooldowns

    -- Action List - PreCombat
        local function actionList_PreCombat()
            var.mapID = C_ChallengeMode.GetActiveChallengeMapID();
            if not inCombat and not (IsFlying() or IsMounted()) and not solo then
                if var.activeMythicMapID then
                    module.autoKeystone()
                end
            end
            if not inCombat and not (IsFlying() or IsMounted()) then
                if br.isChecked("Pig Catcher") then
                    br.bossHelper()
                end
            -- Conjure Refreshments
            if solo and not moving and not inCombat and ui.checked("Conjure Refreshments") then
                if GetItemCount(113509) < 1 and br.timer:useTimer("CR", math.random(3.2,4.5)) then
                     if br._G.CastSpellByName(GetSpellInfo(190336)) then br.addonDebug("Casting Conjure Refreshments") return true end
                end
            end

                if br.isChecked("Pre-Pull") then
                    -- Flask / Crystal
                    if ((pullTimer <= br.getValue("Pre-Pull") and pullTimer > 4 and pullTimer <= 20 and pullTimer > 8)) then
                        if br.getOptionValue("Elixir") == 1 and inRaid and not buff.greaterFlaskOfEndlessFathoms.react() and br.canUseItem(item.greaterFlaskOfEndlessFathoms) then
                            if use.greaterFlaskOfEndlessFathoms() then br.addonDebug("Using Greater Flask of Endless Fathoms") return end
                        elseif br.getOptionValue("Elixir") == 2 and inRaid and not buff.flaskOfEndlessFathoms.react() and br.canUseItem(item.flaskOfEndlessFathoms) then
                            if use.flaskOfEndlessFathoms() then br.addonDebug("Using Flask of Endless Fathoms") return end
                        end
                        -- augment
                        if br.isChecked("Augment") and not buff.battleScarredAugmentRune.react() and br.canUseItem(item.battleScarredAugmentRune) then
                            if use.battleScarredAugmentRune() then br.addonDebug("Using Battle-Scarred Augment Rune") return end
                        end
                        -- potion
                        if br.isChecked("Potion") and not buff.potionOfUnbridledFury.react() and br.canUseItem(item.potionOfUnbridledFury) then
                            if use.potionOfUnbridledFury() then br.addonDebug("Using Potion of Unbridled Fury") return end
                        end
                        -- Mirror Image
                        if br.isChecked("Mirror Image") and br.timer:useTimer("MI Delay", math.random(0.65,2)) then
                            if cast.mirrorImage() then br.addonDebug("Casting Mirror Image") return end
                        end
                    elseif pullTimer <= 4 and br.timer:useTimer("PB Delay",5) then
                        br._G.CastSpellByName(GetSpellInfo(spell.pyroblast)) br.addonDebug("Casting Pyroblast") return
                    end

                    
                end -- End Pre-Pull        
            end -- End No Combat
        end -- End Action List - PreCombat

    local function actionList_Combustion_Cooldown()
        -- actions.combustion_cooldowns=potion
        if br.isChecked("Potion") and use.able.battlePotionOfIntellect() and not buff.battlePotionOfIntellect.exists() or ttd("target") < 30 and inInstance then
            use.battlePotionOfIntellect()
            return true
        end
        -- actions.combustion_cooldowns+=/blood_fury
        -- actions.combustion_cooldowns+=/berserking,if=buff.combustion.up
        -- actions.combustion_cooldowns+=/fireblood
        if br.isChecked("Racial") and (br.player.race == "Orc" or br.player.race == "Troll" or br.player.race == "DarkIronDwarf") then
            if br.castSpell("player",racial,false,false,false) then return end
        end
        -- actions.combustion_cooldowns+=/ancestral_call
        -- actions.combustion_cooldowns+=/time_warp,if=runeforge.temporal_warp&buff.exhaustion.up
        -- actions.combustion_cooldowns+=/use_item,effect_name=gladiators_badge
        if use.able.gladiatorsBadge() then 
            use.gladiatorsBadge()
        end
        if use.able.gladiatorsBadgeAlacrity() then 
            use.gladiatorsBadgeAlacrity() 
        end
        -- actions.combustion_cooldowns+=/use_item,name=inscrutable_quantum_device
        if use.able.inscrutableQuantumDevice() then 
            use.inscrutableQuantumDevice()
        end
        -- actions.combustion_cooldowns+=/use_item,name=flame_of_battle
        if use.able.flameOfBattle() then
            use.flameOfbattle()
        end
        -- actions.combustion_cooldowns+=/use_item,name=wakeners_frond
        if use.able.wakenersFrond() then
            use.wakenersFrond()
        end
        -- actions.combustion_cooldowns+=/use_item,name=instructors_divine_bell
        if use.able.instructorsDivineBell() then
            use.instructorsDivineBell()
        end
        -- actions.combustion_cooldowns+=/use_item,name=sunblood_amethyst
        module.BasicTrinkets()
    end -- End Action List - Combustion Cooldowns 
    
    local function actionList_ActiveTalents()
        -- actions.active_talents=living_bomb,if=active_enemies>1&buff.combustion.down&(variable.time_to_combustion>cooldown.living_bomb.duration|variable.time_to_combustion<=0)
        if #enemies.yards10t > 1 and not buff.combustion.react() 
        and (var.time_to_combustion > cd.livingBomb.duration() or var.time_to_combustion <= 0)
        then
            if cast.livingBomb("target") then debug("[Action:Talents] Living Bomb") return true end
        end
        -- actions.active_talents+=/meteor,if=variable.time_to_combustion<=0|(cooldown.meteor.duration<variable.time_to_combustion&!talent.rune_of_power)|talent.rune_of_power&buff.rune_of_power.up&variable.time_to_combustion>action.meteor.cooldown|fight_remains<variable.time_to_combustion
        if var.time_to_combustion <= 0 
        or (cd.meteor.duration() < var.time_to_combustion and not talent.RuneOfPower) 
        or talent.runeOfPower and buff.runeOfpower.react() 
        and var.time_to_combustion > cd.meteor.remains() or ttd("target") < var.time_to_combustion
        then
            if ui.value("Meteor Target") == 1 then -- We have "Target" selected.
                if ui.checked("Predict Movement") then -- We have "Best" selected.
                    if br.createCastFunction("best", false, 1, 8, spell.meteor, nil, false, 0) and br._G.TargetLastEnemy() then 
                        teorLast = true debug("[Action:Talents] Meteor") return true 
                    end
                elseif not moving or targetMovingCheck then
                    if br.createCastFunction("best", false, 1, 8, spell.meteor, nil, false, 0) and br._G.TargetLastEnemy() then 
                        teorLast = true debug("[Action:Talents] Meteor") return true 
                    end
                end
            elseif ui.value("Meteor Target") == 2 then
                if br.useCDs() and ui.checked("Ignore Cataclysm units when using CDs") then
                    if ui.checked("Predict Movement") then
                        if cast.meteor("best",false,1,8,true) then
                            teorLast = true debug("[Action:Talents] Meteor") return true 
                        end
                    else
                        if cast.meteor("best",false,1,8) then
                            teorLast = true debug("[Action:Talents] Meteor") return true 
                        end 
                    end
                else 
                    if ui.checked("Predict Movement") then
                        if cast.meteor("best",false,1,8,true) then
                            teorLast = true debug("[Action:Talents] Meteor") return true 
                        end
                    else
                        if cast.meteor("best",false,1,8) then
                            teorLast = true debug("[Action:Talents] Meteor") return true 
                        end 
                    end
                end 
            end
        end -- End SimC Meteor APL
        -- actions.active_talents+=/dragons_breath,if=talent.alexstraszas_fury&(buff.combustion.down&!buff.hot_streak.react)
        if talent.alexstraszasFury and (not buff.combustion.react() and not buff.hotStreak.react()) and br.getDistance("target") <= 8 then
            if cast.dragonsBreath("player") then debug("[Action:Talents] Dragon's Breath") return true end
        end
    end -- End Action List - Active Talents

    local function actionList_CombustionPhase()

        -- actions.combustion_phase=lights_judgment,if=buff.combustion.down
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Estimate how long Combustion will last thanks to Sun King's Blessing to determine how Fire Blasts should be used.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/variable,use_off_gcd=1,use_while_casting=1,name=extended_combustion_remains,op=set,value=buff.combustion.remains+buff.combustion.duration*(cooldown.combustion.remains<buff.combustion.remains),if=conduit.infernal_cascade
        if conduit.infernalCascade and cast.current.scorch() then 
            var.extended_combustion_remains = buff.combustion.remains() + buff.combustion.duration() * var.num(var.bool(cd.combustion.remains() < var.num(buff.combustion.remains())));
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Adds the duration of the Sun King's Blessing Combustion to the end of the current Combustion if the cast would complete during this Combustion.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/variable,use_off_gcd=1,use_while_casting=1,name=extended_combustion_remains,op=add,value=variable.skb_duration,if=conduit.infernal_cascade&(buff.sun_kings_blessing_ready.up|variable.extended_combustion_remains>1.5*gcd.max*(buff.sun_kings_blessing.max_stack-buff.sun_kings_blessing.stack))
        if conduit.infernalCascade 
        and (buff.sunKingsBlessings.react() 
        or var.num(var.extended_combustion_remains)) > 1.5*gcdMax*(11-var.num(buff.sunKingsBlessings.stack()))
        and cast.current.scorch()
        then  
            var.extended_combustion_remains = var.skb_duration; 
        end
        -- actions.combustion_phase+=/bag_of_tricks,if=buff.combustion.down
        -- actions.combustion_phase+=/living_bomb,if=active_enemies>1&buff.combustion.down
        if talent.livingBomb and #enemies.yards6t > 1 and buff.combustion.react() then 
            if cast.livingBomb("target") then debug("[Action:Combust Phase] Living Bomb (Combust,Enemies>1) (1)") return true end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Without Infernal Cascade, just use Fire Blasts when they won't munch crits and when Firestorm is down.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/fire_blast,use_off_gcd=1,use_while_casting=1,if=!conduit.infernal_cascade&charges>=1&buff.combustion.up&!buff.firestorm.react&!buff.hot_streak.react&hot_streak_spells_in_flight+buff.heating_up.react<2
        if not conduit.infernalCascade and charges >= 1 and buff.combustion.react() 
        and not buff.firestorm.react() and not buff.hotStreak.react() 
        and var.hot_streak_spells_in_flight+var.num(buff.heatingUp.react()
        and var.num(buff.heatingUp.remains() < 2))
        and cast.current.scorch()
        then
            if cast.fireBlast("target") then debug("[Action:Combust Phase] Fire Blast (Interrupt) (2)") return true end
        end 
       -- end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # With Infernal Cascade, Fire Blast use should be additionally constrained so that it is not be used unless Infernal Cascade is about to expire or there are more than enough Fire Blasts to extend Infernal Cascade to the end of Combustion.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        if conduit.infernalCascade and cast.current.scorch() then
            -- actions.combustion_phase+=/variable,use_off_gcd=1,use_while_casting=1,name=expected_fire_blasts,op=set,value=action.fire_blast.charges_fractional+(variable.extended_combustion_remains-buff.infernal_cascade.duration)%cooldown.fire_blast.duration,if=conduit.infernal_cascade
            var.expected_fire_blasts = charges.fireBlast.frac() + (var.extended_combustion_remains-var.num(buff.infernalCascade.duration() + var.num(cd.fireBlast.duration())))
            -- actions.combustion_phase+=/variable,use_off_gcd=1,use_while_casting=1,name=needed_fire_blasts,op=set,value=ceil(variable.extended_combustion_remains%(buff.infernal_cascade.duration-gcd.max)),if=conduit.infernal_cascade
            if conduit.infernalCascade and cast.current.scorch() then
                var.needed_fire_blasts = math.ceil(var.extended_combustion_remains and (var.num(buff.infernalCascade.duration()-gcdMax)));
            end
        end -- End infernalCascade Check
        
        -- actions.combustion_phase+=/fire_blast,use_off_gcd=1,use_while_casting=1,if=conduit.infernal_cascade&charges>=1&(variable.expected_fire_blasts>=variable.needed_fire_blasts|variable.extended_combustion_remains<=buff.infernal_cascade.duration|buff.infernal_cascade.stack<2|buff.infernal_cascade.remains<gcd.max|cooldown.shifting_power.ready&active_enemies>=variable.combustion_shifting_power&covenant.night_fae)&buff.combustion.up&(!buff.firestorm.react|buff.infernal_cascade.remains<0.5)&!buff.hot_streak.react&hot_streak_spells_in_flight+buff.heating_up.react<2
        if not conduit.infernalCascade and charges.fireBlast.count() >= 1 
        and buff.combustion.react() and not buff.firestorm.react() 
        and not buff.hotStreak.react() 
        and var.num(hot_streak_spells_in_flight) + var.num(buff.heatingUp.react()) < 2 
        and cast.current.scorch()
        then
            if cast.fireBlast("target") then debug("[Action:Combust Phase] Fire Blast (Interrupt) (3)") return true end
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Prepare Disciplinary Command for Combustion. Note that the Rune of Power from Combustion counts as an Arcane spell, so Arcane spells are only necessary if that talent is not used.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/counterspell,if=runeforge.disciplinary_command&buff.disciplinary_command.down&buff.disciplinary_command_arcane.down&cooldown.buff_disciplinary_command.ready&!talent.rune_of_power
        -- actions.combustion_phase+=/arcane_explosion,if=runeforge.disciplinary_command&buff.disciplinary_command.down&buff.disciplinary_command_arcane.down&cooldown.buff_disciplinary_command.ready&!talent.rune_of_power
        -- actions.combustion_phase+=/frostbolt,if=runeforge.disciplinary_command&buff.disciplinary_command.down&buff.disciplinary_command_frost.down
        -- actions.combustion_phase+=/frost_nova,if=runeforge.grisly_icicle&buff.combustion.down
        if runeforge.grislyIcicle.equiped and not buff.combustion.react() and not moving then
            if cast.frostNova("target") then return true end 
        end
        -- actions.combustion_phase+=/call_action_list,name=active_talents
        if actionList_ActiveTalents() then return end 
        ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
        -- Combustion --.:|:.-----.:|:.-----.:|:.-----
        ------.:|:.-----.:|:.-----.:|:.-----.:|:.-----
        -- actions.combustion_phase+=/combustion,use_off_gcd=1,use_while_casting=1,if=buff.combustion.down&(!runeforge.disciplinary_command|buff.disciplinary_command.up|buff.disciplinary_command_frost.up&talent.rune_of_power&cooldown.buff_disciplinary_command.ready)&(!runeforge.grisly_icicle|debuff.grisly_icicle.up)&(action.meteor.in_flight&action.meteor.in_flight_remains<=variable.combustion_cast_remains|action.scorch.executing&action.scorch.execute_remains<variable.combustion_cast_remains|action.fireball.executing&action.fireball.execute_remains<variable.combustion_cast_remains|action.pyroblast.executing&action.pyroblast.execute_remains<variable.combustion_cast_remains|action.flamestrike.executing&action.flamestrike.execute_remains<variable.combustion_cast_remains)
        if not moving and mode.cb == 1 then -- Combustion Mode - SimC
            if br.useCDs or ttd("target") > 40 and ttd("target") > ui.value("Combustion TTD") and standingTIme > ui.value("Combustion Standing Time") then 
                if not buff.combustion.react() and cast.last.meteor() 
                and var.execute_remains <= var.combustion_cast_remains 
                or cast.current.scorch() and var.execute_remains < var.combustion_cast_remains 
                or cast.current.fireball() and var.execute_remains < var.combustion_cast_remains
                or cast.current.pyroblast() and var.execute_remains < var.combustion_cast_remains 
                or cast.current.flamestrike() and var.execute_remains < var.combustion_cast_remains 
                then
                    if cast.combustion("player") then debug("[Action:Combust Phase] Combustion (SimC) (4)") return true end 
                end
            end
        elseif not moving and mode.cb == 2 then -- Combustion Mode - CDs
            if br.useCDs or ttd("target") > 40 and ttd("target") > ui.value("Combustion TTD") and standingTIme > ui.value("Combustion Standing Time") then
                if cast.combustion("player") then debug("[Action:Combust Phase] Combustion (CDs) (5)") return true end
            end
        elseif not moving and mode.cb == 3 then -- Combustion Mode - TTD
            if ttd("target") > ui.value("Combustion TTD") and cd.combustion.remains() > ttd("target") and standingTIme > ui.value("Combustion Standing Time") then
                if cast.combustion("player") then debug("[Action:Combust Phase] Combustion (TTD) (6)") return true end
            end
        end
        if br.isChecked("Combustion") and br.SpecificToggle("Combustion") and not GetCurrentKeyBoardFocus() then
            if cast.combustion("player") then br.addonDebug("[Action:Combust Phase] Combustion (Hotkey)") return true end
        end 
        -- actions.combustion_phase+=/living_bomb,if=buff.combustion.remains<gcd.max&active_enemies>1
        if talent.livingBomb and buff.combustion.remains() < gcdMax and #enemies.yards10t > 1 then
            if cast.livingBomb("target") then debug("[Action:Combust Phase] Living Bomb") return true end
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Estimate how long Combustion will last thanks to Sun King's Blessing to determine how Fire Blasts should be used.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/variable,use_off_gcd=1,use_while_casting=1,name=extended_combustion_remains,op=set,value=buff.combustion.remains+buff.combustion.duration*(cooldown.combustion.remains<buff.combustion.remains),if=conduit.infernal_cascade
        if conduit.infernalCascade and cast.current.scorch() then var.extended_combustion_remains = buff.combustion.remains() + buff.combustion.duration() * var.num(var.bool(cd.combustion.remains() < var.num(buff.combustion.remains()))) end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Adds the duration of the Sun King's Blessing Combustion to the end of the current Combustion if the cast would complete during this Combustion.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/variable,use_off_gcd=1,use_while_casting=1,name=extended_combustion_remains,op=add,value=variable.skb_duration,if=conduit.infernal_cascade&(buff.sun_kings_blessing_ready.up|variable.extended_combustion_remains>1.5*gcd.max*(buff.sun_kings_blessing.max_stack-buff.sun_kings_blessing.stack))
        if conduit.infernalCascade and cast.current.scorch() and (buff.sunKingsBlessings.react() or var.extended_combustion_remains > 1.5*gcdMax*(12-buff.sunKingsBlessings.stack())) then var.extended_combustion_remains = var.skb_duration end
        -- actions.combustion_phase+=/bag_of_tricks,if=buff.combustion.down
        -- actions.combustion_phase+=/living_bomb,if=active_enemies>1&buff.combustion.down
        if talent.livingBomb and #enemies.yards10t > 1 and not buff.combustion.react() then
            if cast.livingBomb("target") then debug("[Action:Combust Phase] Living Bomb (Combust Down,Enemies>1) ()") return true end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Without Infernal Cascade, just use Fire Blasts when they won't munch crits and when Firestorm is down.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/fire_blast,use_off_gcd=1,use_while_casting=1,if=!conduit.infernal_cascade&charges>=1&buff.combustion.up&!buff.firestorm.react&!buff.hot_streak.react&hot_streak_spells_in_flight+buff.heating_up.react<2
        if not conduit.infernalCascade and charges.fireBlast.count() >= 1 
        and buff.combustion.react() and not buff.firestorm.react() 
        and not buff.hotStreak.react() 
        and var.hot_streak_spells_in_flight + buff.heatingUp.remains() < 2 
        and cast.current.scorch()
        then 
            if cast.fireBlast("target") then return true end 
        end
         --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # With Infernal Cascade, Fire Blast use should be additionally constrained so that it is not be used unless Infernal Cascade is about to expire or there are more than enough Fire Blasts to extend Infernal Cascade to the end of Combustion.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/variable,use_off_gcd=1,use_while_casting=1,name=expected_fire_blasts,op=set,value=action.fire_blast.charges_fractional+(variable.extended_combustion_remains-buff.infernal_cascade.duration)%cooldown.fire_blast.duration,if=conduit.infernal_cascade
        if conduit.infernalCascade and cast.current.scorch() then 
            var.expected_fire_blasts = charges.fireBlast.frac()+(var.extended_combustion_remains-buff.infernalCascade.duration()) + cd.fireBlast.duration() 
        end
        -- actions.combustion_phase+=/variable,use_off_gcd=1,use_while_casting=1,name=needed_fire_blasts,op=set,value=ceil(variable.extended_combustion_remains%(buff.infernal_cascade.duration-gcd.max)),if=conduit.infernal_cascade
        if conduit.infernalCascade and cast.current.scorch() then
            var.needed_fire_blasts = math.ceil(var.extended_combustion_remains and (var.num(buff.infernalCascade.duration()-gcdMax)));
        end
        -- actions.combustion_phase+=/fire_blast,use_off_gcd=1,use_while_casting=1,if=conduit.infernal_cascade&charges>=1&(variable.expected_fire_blasts>=variable.needed_fire_blasts|variable.extended_combustion_remains<=buff.infernal_cascade.duration|buff.infernal_cascade.stack<2|buff.infernal_cascade.remains<gcd.max|cooldown.shifting_power.ready&active_enemies>=variable.combustion_shifting_power&covenant.night_fae)&buff.combustion.up&(!buff.firestorm.react|buff.infernal_cascade.remains<0.5)&!buff.hot_streak.react&hot_streak_spells_in_flight+buff.heating_up.react<2
        if conduit.infernalCascade and charges.fireBlast.count() >= 1 
        and (var.expected_fire_blasts >= var.needed_fire_blasts or var.extended_combustion_remains <= buff.infernalCascade.duration() or buff.infernalCascade.stack() < 2 
        or buff.infernalCascade < gcdMax or cd.shiftingPower.ready() and covenant.nightFae.active) 
        and buff.combustion.react() and (not buff.firestorm.react or buff.infernalCascade.remains() < 0.5) 
        and not buff.hotStreak.react() and var.num(var.hot_streak_spells_in_flight) + var.num(buff.heatingUp.react()) < 2 
        and cast.current.scorch()
        then
            if cast.fireBlast("target") then debug("[Action:Combust Phase] Flamestrike (Hot streak, or firestorm) (3)") return true end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Prepare Disciplinary Command for Combustion. Note that the Rune of Power from Combustion counts as an Arcane spell, so Arcane spells are only necessary if that talent is not used.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/counterspell,if=runeforge.disciplinary_command&buff.disciplinary_command.down&buff.disciplinary_command_arcane.down&cooldown.buff_disciplinary_command.ready&!talent.rune_of_power
        -- actions.combustion_phase+=/arcane_explosion,if=runeforge.disciplinary_command&buff.disciplinary_command.down&buff.disciplinary_command_arcane.down&cooldown.buff_disciplinary_command.ready&!talent.rune_of_power
        -- actions.combustion_phase+=/frostbolt,if=runeforge.disciplinary_command&buff.disciplinary_command.down&buff.disciplinary_command_frost.down
        -- actions.combustion_phase+=/frost_nova,if=runeforge.grisly_icicle&buff.combustion.down
        -- actions.combustion_phase+=/call_action_list,name=active_talents
        if actionList_ActiveTalents() then return end
        -- actions.combustion_phase+=/combustion,use_off_gcd=1,use_while_casting=1,if=buff.combustion.down&(!runeforge.disciplinary_command|buff.disciplinary_command.up|buff.disciplinary_command_frost.up&talent.rune_of_power&cooldown.buff_disciplinary_command.ready)&(!runeforge.grisly_icicle|debuff.grisly_icicle.up)&(action.meteor.in_flight&action.meteor.in_flight_remains<=variable.combustion_cast_remains|action.scorch.executing&action.scorch.execute_remains<variable.combustion_cast_remains|action.fireball.executing&action.fireball.execute_remains<variable.combustion_cast_remains|action.pyroblast.executing&action.pyroblast.execute_remains<variable.combustion_cast_remains|action.flamestrike.executing&action.flamestrike.execute_remains<variable.combustion_cast_remains)
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Other cooldowns that should be used with Combustion should only be used with an actual Combustion cast and not with a Sun King's Blessing proc.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/call_action_list,name=combustion_cooldowns,if=buff.combustion.remains>8|cooldown.combustion.remains<5
        if buff.combustion.remains() > 8 or cd.combustion.remains() < 5 then
            if actionList_Combustion_Cooldown() then return end 
        end
        -- actions.combustion_phase+=/flamestrike,if=(buff.hot_streak.react&active_enemies>=variable.combustion_flamestrike)|(buff.firestorm.react&active_enemies>=variable.combustion_flamestrike-runeforge.firestorm)
        if (buff.hotStreak.react() 
        --and #enemies.yards10t >= ui.value("FS Targets (Hot Streak)")) 
       -- or (buff.firestorm.react() 
        and #enemies.yards6t >= var.combustion_flamestrike)
        then
             if ui.value("Flamestrike Target") == 1 then -- We have "Target" selected.
                if ui.checked("Predict Movement") then -- We have "Best" selected.
                    if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then
                        br._G.SpellStopTargeting() 
                        debug("[Action:Combust Phase] Flamestrike (Hot streak, or firestorm) (12)") 
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then 
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike (Hot streak, or firestorm) (12)") 
                        return true 
                    end
                end
            elseif ui.value("Flamestrike Target") == 2 then
                if ui.checked("Predict Movement") then
                    if cast.flamestrike("best",false,1,8,true) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike (Hot streak, or firestorm) (12)") 
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if cast.flamestrike("best",false,1,8) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike (Hot streak, or firestorm) (12)") 
                        return true 
                    end 
                end
                if ui.checked("Predict Movement") then
                    if cast.flamestrike("best",false,1,8,true) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike (Hot streak, or firestorm) (12)") 
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if cast.flamestrike("best",false,1,8) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike (Hot streak, or firestorm) (12)") 
                        return true 
                    end 
                end
            end 
        end
        -- actions.combustion_phase+=/pyroblast,if=buff.sun_kings_blessing_ready.up&buff.sun_kings_blessing_ready.remains>cast_time
        if runeforge.sunKingsBlessings.equiped and buff.sunKingsBlessings.react() and buff.sunKingsBlessings.remains() > cast.time.pyroblast() then
            if cast.pyroblast("target") then debug("[Action:Combust Phase] Pyroblast (Sun Kings Blessing) (12)") return true end
        end
        -- actions.combustion_phase+=/pyroblast,if=buff.firestorm.react
        if runeforge.firestorm.equiped and buff.firestorm.react() and not moving then
            if cast.pyroblast("target") then debug("[Action:Combust Phase] Pyroblast (Firestorm) (12)") return true end
        end
        -- actions.combustion_phase+=/pyroblast,if=buff.pyroclasm.react&buff.pyroclasm.remains>cast_time&(buff.combustion.remains>cast_time|buff.combustion.down)&active_enemies<variable.combustion_flamestrike
        if buff.pyroclasm.react() and buff.pyroclasm.remains() > cast.time.pyroblast() 
        and (buff.combustion.remains() > cast.time.pyroblast() 
        or not buff.combustion.react()) 
        and #enemies.yards6t < var.combustion_flamestrike
        then
            if cast.pyroblast("target") then debug("[Action:Combust Phase] Pyroblast (pyroclasm) (12)") return true end
        end
        -- actions.combustion_phase+=/pyroblast,if=buff.hot_streak.react&buff.combustion.up
        if buff.hotStreak.react() and buff.combustion.react() then
            if cast.pyroblast("target") then debug("[Action:Combust Phase] Pyroblast (Hot Streak) (12)") return true end
        end

        -- actions.combustion_phase+=/pyroblast,if=prev_gcd.1.scorch&buff.heating_up.react&active_enemies<variable.combustion_flamestrike
        if cast.last.scorch() and buff.heatingUp.react() and #enemies.yards10t < var.combustion_flamestrike and buff.combustion.react() then
            if cast.pyroblast("target") then debug("[Action:Combust Phase] Pyroblast (heating up) (12)") return true end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Using Shifting Power during Combustion to restore Fire Blast and Phoenix Flame charges can be beneficial, but usually only on AoE.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/shifting_power,if=buff.combustion.up&!action.fire_blast.charges&active_enemies>=variable.combustion_shifting_power&action.phoenix_flames.full_recharge_time>full_reduction,interrupt_if=action.fire_blast.charges=action.fire_blast.max_charges
        if ui.value("Shifting Power (Combustion)")
        and buff.combustion.react() and charges.fireBlast.count() < 1 
        and #enemies.yards8t >= var.num(var.combustion_shifting_power)
        and charges.fireBlast.timeTillFull() > 4 and var.num(charges.fireBlast.count()) > 1 
        and standingTime >= ui.value("Covenant Standing Time")
        and br.getDistance("target") <= 15
        then
            if cast.shiftingPower() then debug("[Action:Combust Phase] Shifting Power (Fire Blast timing, combust up, SP Bust Toggled On) (12)") return true end 
        end
        -- actions.combustion_phase+=/phoenix_flames,if=buff.combustion.up&travel_time<buff.combustion.remains&((action.fire_blast.charges<1&talent.pyroclasm&active_enemies=1)|!talent.pyroclasm|active_enemies>1)&buff.heating_up.react+hot_streak_spells_in_flight<2
        --[[if buff.combustion.react() and travelTime < buff.combustion.remains() 
        and ((charges.fireBlast.count() < 1 and talent.pyroclasm and #enemies.yards10t == 1) 
        or not talent.pyroclasm or #enemies.yards10t > 1) 
        and var.num(buff.heatingUp.react())+var.num(hot_streak_spells_in_flight) < 2
        then
            if cast.phoenixFlames("target") then debug("[Action:Combust Phase] Phoenix Flames (St/AOE) (12)") return true end 
        end]]
        -- actions.combustion_phase+=/phoenix_flames,if=buff.combustion.up&travel_time<buff.combustion.remains&((action.fire_blast.charges<1&talent.pyroclasm&active_enemies=1)|!talent.pyroclasm|active_enemies>1)&buff.heating_up.react+hot_streak_spells_in_flight<2
        if buff.combustion.react() and var.in_flight_remains < buff.combustion.remains() 
        and ((charges.fireBlast.count() < 1 and talent.pyroclasm and #enemies.yards10t == 1) 
        or not talent.pyroclasm or #enemies.yards10t > 1) 
        and var.num(buff.heatingUp.react()) + var.num(var.hot_streak_spells_in_flight) < 2 
        and cast.current.scorch()
        then
            if cast.phoenixFlames("target") then debug("[Action:Combust Phase] Phoenix Flames (15)") return true end
        end
        -- actions.combustion_phase+=/flamestrike,if=buff.combustion.down&cooldown.combustion.remains<cast_time&active_enemies>=variable.combustion_flamestrike
        if not buff.combustion.react() and not moving 
        and cd.combustion.remains() < cast.time.flamestrike()
        and #enemies.yards6t >= var.combustion_flamestrike 
        then
            if ui.value("Flamestrike Target") == 1 then -- We have "Target" selected.
                if ui.checked("Predict Movement") then -- We have "Best" selected.
                    if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then 
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike (Combust down, cd < cast time & enemies >= combust flamestrike, aoe) (12)") 
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then 
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike (Combust down, cd < cast time & enemies >= combust flamestrike, aoe) (12)") 
                        return true 
                    end
                end
            elseif ui.value("Flamestrike Target") == 2 then
                if ui.checked("Predict Movement") then
                    if cast.flamestrike("best",false,1,8,true) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike (Combust down, cd < cast time & enemies >= combust flamestrike, aoe) (12)") 
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if cast.flamestrike("best",false,1,8) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike (Combust down, cd < cast time & enemies >= combust flamestrike, aoe) (12)") 
                        return true 
                    end 
                end
                if ui.checked("Predict Movement") then
                    if cast.flamestrike("best",false,1,8,true) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike (Combust down, cd < cast time & enemies >= combust flamestrike, aoe) (12)") 
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if cast.flamestrike("best",false,1,8) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike (Combust down, cd < cast time & enemies >= combust flamestrike, aoe) (12)") 
                        return true 
                    end 
                end
            end
        end
        -- actions.combustion_phase+=/fireball,if=buff.combustion.down&cooldown.combustion.remains<cast_time&!conduit.flame_accretion
        if not buff.combustion.react() and cd.combustion.remains() < cast.time.fireball() and not conduit.flameAccretion and not moving and br.getLineOfSight("player","target") then
            if cast.fireball() then return true end 
        end
        -- actions.combustion_phase+=/scorch,if=buff.combustion.remains>cast_time&buff.combustion.up|buff.combustion.down&cooldown.combustion.remains<cast_time
        if buff.combustion.remains() > cast.time.scorch() and buff.combustion.react() 
        or not buff.combustion.react() and cd.combustion.remains() < cast.time.scorch() 
        and talent.searingTouch 
        and br.getLineOfSight("player","target")
        then
             if cast.scorch("target") then debug("[Action:Combust Phase] Scorch (Combust or cd < cast time, aoe) (12)") return true end 
        end
        -- actions.combustion_phase+=/living_bomb,if=buff.combustion.remains<gcd.max&active_enemies>1
        if buff.combustion.remains() < gcdMax and #enemies.yards10t > 1 then
            if cast.livingBomb("target") then debug("[Action:Combust Phase] Living Bomb (Enemies>1, combust, aoe) (12)") return true end 
        end
        -- actions.combustion_phase+=/dragons_breath,if=buff.combustion.remains<gcd.max&buff.combustion.up
        if buff.combustion.react() and buff.combustion.remains() < gcdMax and br.getDistance("target") <= 8.5 then
            if cast.dragonsBreath("player") then debug("[Action:Combust Phase] Dragon's Breath (Combustion) (20)") return true end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Estimate how long Combustion will last thanks to Sun King's Blessing to determine how Fire Blasts should be used.
        -- actions.combustion_phase+=/variable,use_off_gcd=1,use_while_casting=1,name=extended_combustion_remains,op=set,value=buff.combustion.remains+buff.combustion.duration*(cooldown.combustion.remains<buff.combustion.remains),if=conduit.infernal_cascade
        if conduit.infernalCascade then var.extended_combustion_remains = buff.combustion.remains() + buff.combustion.duration() * var.num(var.bool(cd.combustion.remains() < var.num(buff.combustion.remains()))) end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Adds the duration of the Sun King's Blessing Combustion to the end of the current Combustion if the cast would complete during this Combustion.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/variable,use_off_gcd=1,use_while_casting=1,name=extended_combustion_remains,op=add,value=variable.skb_duration,if=conduit.infernal_cascade&(buff.sun_kings_blessing_ready.up|variable.extended_combustion_remains>1.5*gcd.max*(buff.sun_kings_blessing.max_stack-buff.sun_kings_blessing.stack))
      --  if conduit.infernalCascade and (buff.sunKingsBlessings.react() or var.bool(var.extended_combustion_remains > 1.5 * gcdMax * var.bool(buff.sun)))    --  then 
       --  extended_combustion_remains = var.skb_duration end 
        
        -- actions.combustion_phase+=/bag_of_tricks,if=buff.combustion.down

        -- actions.combustion_phase+=/living_bomb,if=active_enemies>1&buff.combustion.down
        if #enemies.yards6t > 1 and not buff.combustion.react() then
            if cast.livingBomb("target") then debug("[Action:Combust Phase] Living Bomb (enemies > 1, no combust)") return true end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Without Infernal Cascade, just use Fire Blasts when they won't munch crits and when Firestorm is down.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/fire_blast,use_off_gcd=1,use_while_casting=1,if=!conduit.infernal_cascade&charges>=1&buff.combustion.up&!buff.firestorm.react&!buff.hot_streak.react&hot_streak_spells_in_flight+buff.heating_up.react<2
        if not conduit.infernalCascade and charges.fireBlast.count() >= 1 
        and buff.combustion.react() 
        and (runeforge.firestorm.equiped and not buff.firestorm.react() or not runeforge.firestorm.equiped) 
        and not buff.hotStreak.react() 
        and var.num(hot_streak_spells_in_flight) + var.num(buff.heatingUp.remains()) < 2 
        and cast.current.scorch()
        then 
            if cast.fireBlast("target") then debug("[Action:Combust Phase] Fire Blast (No Infernal Cascade) (12)") return true end  
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # With Infernal Cascade, Fire Blast use should be additionally constrained so that it is not be used unless Infernal Cascade is about to expire or there are more than enough Fire Blasts to extend Infernal Cascade to the end of Combustion.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/variable,use_off_gcd=1,use_while_casting=1,name=expected_fire_blasts,op=set,value=action.fire_blast.charges_fractional+(variable.extended_combustion_remains-buff.infernal_cascade.duration)%cooldown.fire_blast.duration,if=conduit.infernal_cascade
        --fblastCDduration
        if conduit.infernalCascade and cast.current.scorch() then
            var.expected_fire_blasts = charges.fireBlast.frac()+(var.extended_combustion_remains-var.num(buff.infernalCascade.duration()) and var.num(cd.fireBlast.duration()));
        end
        -- actions.combustion_phase+=/variable,use_off_gcd=1,use_while_casting=1,name=needed_fire_blasts,op=set,value=ceil(variable.extended_combustion_remains%(buff.infernal_cascade.duration-gcd.max)),if=conduit.infernal_cascade
        if conduit.infernalCascade and cast.current.scorch() then
            var.needed_fire_blasts = math.ceil(var.extended_combustion_remains and (var.num(buff.infernalCascade.duration()-gcdMax)));
        end
        -- actions.combustion_phase+=/fire_blast,use_off_gcd=1,use_while_casting=1,if=conduit.infernal_cascade&charges>=1&(variable.expected_fire_blasts>=variable.needed_fire_blasts|variable.extended_combustion_remains<=buff.infernal_cascade.duration|buff.infernal_cascade.stack<2|buff.infernal_cascade.remains<gcd.max|cooldown.shifting_power.ready
        --&active_enemies>=variable.combustion_shifting_power&covenant.night_fae)&buff.combustion.up&(!buff.firestorm.react|buff.infernal_cascade.remains<0.5)&!buff.hot_streak.react&hot_streak_spells_in_flight+buff.heating_up.react<2
        if conduit.infernalCascade and charges.fireBlast.count() >= 1 
        and (var.num(var.expected_fire_blasts) >= var.num(var.needed_fire_blasts) 
        or var.bool(var.extended_combustion_remains) <= var.num(buff.infernalCascade.duration() 
        or buff.infernalCascade.remains() < gcdMax or cd.shiftingPower.ready() 
        and #enemies.yards8t >= var.bool(var.combustion_shifting_power)
        and covenant.nightFae.active) and buff.combustion.react() and runeforge.firestorm.equiped and not buff.firestorm.react() or not runeforge.firestorm.equiped 
        or var.num(buff.infernalCascade.remains()) < 0.5) and not buff.hotStreak.react() and var.num(var.hot_streak_spells_in_flight) + var.num(buff.heatingUp.remains() < 2) 
        and cast.current.scorch()
        then
            if cast.fireBlast("target") then debug("Combust phase, infernal cascade bullshit") return true end  
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Prepare Disciplinary Command for Combustion. Note that the Rune of Power from Combustion counts as an Arcane spell, so Arcane spells are only necessary if that talent is not used.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/counterspell,if=runeforge.disciplinary_command&buff.disciplinary_command.down&buff.disciplinary_command_arcane.down&cooldown.buff_disciplinary_command.ready&!talent.rune_of_power

        -- actions.combustion_phase+=/arcane_explosion,if=runeforge.disciplinary_command&buff.disciplinary_command.down&buff.disciplinary_command_arcane.down&cooldown.buff_disciplinary_command.ready&!talent.rune_of_power
       -- if runeforge.disciplinaryCommand.equiped and not buff.disciplinaryCommand.react() and not var.bool(disciplinary_command_arcane) and not talent.runeOfPower and br.getDistance("target") <= 8 then

       -- end

        -- actions.combustion_phase+=/frostbolt,if=runeforge.disciplinary_command&buff.disciplinary_command.down&buff.disciplinary_command_frost.down
        if runeforge.disciplinaryCommand.equiped 
        and not buff.disciplinaryCommand.react() 
        and not var.bool(var.disciplinary_command_frost) 
        and not moving 
        then
            if cast.frostbolt("target") then debug("[Action:Combust Phase] Frostbolt [Disciplinary Command down, Frost down] (1)") return true end 
        end
        -- actions.combustion_phase+=/frost_nova,if=runeforge.grisly_icicle&buff.combustion.down
        if runeforge.grislyIcicle.equiped and buff.combustion.react() and br.getDistance("target") < 12 then 
            if cast.frostNova("target") then debug("[Action:Combust Phase] Frost Nova [Grisly Icicle, combust down] (1)") return true end 
        end
        -- actions.combustion_phase+=/call_action_list,name=active_talents
        if actionList_ActiveTalents() then return end 

        -- actions.combustion_phase+=/combustion,use_off_gcd=1,use_while_casting=1,if=buff.combustion.down&(!runeforge.disciplinary_command|buff.disciplinary_command.up|buff.disciplinary_command_frost.up&talent.rune_of_power
        --&cooldown.buff_disciplinary_command.ready)&(!runeforge.grisly_icicle|debuff.grisly_icicle.up)&(action.meteor.in_flight&action.meteor.in_flight_remains<=variable.combustion_cast_remains|action.scorch.executing
        --&action.scorch.execute_remains<variable.combustion_cast_remains|action.fireball.executing&action.fireball.execute_remains<variable.combustion_cast_remains|action.pyroblast.executing
        --&action.pyroblast.execute_remains<variable.combustion_cast_remains|action.flamestrike.executing&action.flamestrike.execute_remains<variable.combustion_cast_remains)
        
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Other cooldowns that should be used with Combustion should only be used with an actual Combustion cast and not with a Sun King's Blessing proc.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/call_action_list,name=combustion_cooldowns,if=buff.combustion.remains>8|cooldown.combustion.remains<5
        if cd.combustion.remains() > 8 or cd.combustion.remains() < 5 then 
            if actionList_Combustion_Cooldown() then return end 
        end 

   -- if not moving then
       -- actions.combustion_phase+=/pyroblast,if=buff.sun_kings_blessing_ready.up&buff.sun_kings_blessing_ready.remains>cast_time
        if runeforge.sunKingsBlessings.equiped and buff.sunKingsBlessings.react() and buff.sunKingsBlessings.remains() > cast.time.pyroblast() then
            if cast.pyroblast("target") then debug("[Action:RoP Phase] Pyroblast (Sun Kings Blessing) (2)") return true end 
        end
        -- actions.combustion_phase+=/pyroblast,if=buff.firestorm.react
        if (runeforge.firestorm.equiped and buff.firestorm.react()) then
            if cast.pyroblast("target") then debug("[Action:RoP Phase] Pyroblast (Firestorm) (2)") return true end 
        end
        -- Possibly not worth it. 
        -- actions.combustion_phase+=/pyroblast,if=buff.pyroclasm.react&buff.pyroclasm.remains>cast_time&(buff.combustion.remains>cast_time|buff.combustion.down)&active_enemies<variable.combustion_flamestrike
        if buff.pyroclasm.react() and buff.pyroclasm.remains() > cast.time.pyroblast() 
        and (buff.combustion.react() and buff.combustion.remains() > cast.time.pyroblast 
        or not buff.combustion.react()) 
        and #enemies.yards6t < var.combustion_flamestrike 
        then
            if cast.pyroblast("target") then debug("[Action:RoP Phase] Pyroblast (Pyroclasm and combust, or no bust and enemies <combustFS ) (2)") return true end
        end
        -- actions.combustion_phase+=/pyroblast,if=buff.hot_streak.react&buff.combustion.up
        if buff.hotStreak.react() and buff.combustion.remains() then
            if cast.pyroblast("target") then debug("[Action:RoP Phase] Pyroblast (Hot Streak, Combust Up) (2)") return true end 
        end
        -- actions.combustion_phase+=/pyroblast,if=prev_gcd.1.scorch&buff.heating_up.react&active_enemies<variable.combustion_flamestrike
        if cast.last.scorch() and heatsUp and #enemies.yards6t < var.combustion_flamestrike then
            if cast.pyroblast("target") then debug("[Action:RoP Phase] Pyroblast (Heating Up, enemies<combust FS) (2)") return true end 
        end
   -- end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Using Shifting Power during Combustion to restore Fire Blast and Phoenix Flame charges can be beneficial, but usually only on AoE.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.combustion_phase+=/shifting_power,if=buff.combustion.up&!action.fire_blast.charges&active_enemies>=variable.combustion_shifting_power&action.phoenix_flames.full_recharge_time>full_reduction,interrupt_if=action.fire_blast.charges=action.fire_blast.max_charges
        if buff.combustion.react() and charges.fireBlast.count() < 1 and #enemies.yards8t >= var.num(var.shifting_power_before_combustion) and charges.phoenixFlames.timeTillFull() > 3.4 then
            -- =action.fire_blast.charges=action.fire_blast.max_charges
            if charges.fireBlast.max() and br.getDistance("target") <= 16 and not moving then
                if cast.shiftingPower("target") then debug("[Action:Combust Phase] Shifting Power ()") return true end 
            end
        end
        -- actions.combustion_phase+=/phoenix_flames,if=buff.combustion.up&travel_time<buff.combustion.remains&((action.fire_blast.charges<1&talent.pyroclasm&active_enemies=1)|!talent.pyroclasm|active_enemies>1)&buff.heating_up.react+hot_streak_spells_in_flight<2
        if buff.combustion.react() and travelTime < buff.combustion.remains() 
        and ((charges.fireBlast.count() < 1 and talent.pyroclasm and #enemies.yards10 == 1) 
        or not talent.pyroclasm or #enemies.yards10 > 1) 
        and buff.heatingUp.react() 
        and var.num(var.hot_streak_spells_in_flight) < 2
        then
            if br.isChecked("Auto Faccia") and not br.getLineOfSight("player","target") then
                var.Module_KinkySex(spell.phoenixFlames,"target")
                debug("[Action:RoP Phase] Pyroblast (Heating Up, enemies<combust FS) (2)") 
                return true 
            else 
                if cast.phoenixFlames("target") then debug("[Action:Combust Phase] Phoenix Flames ()") return true end 
            end  
        end
        -- actions.combustion_phase+=/flamestrike,if=buff.combustion.down&cooldown.combustion.remains<cast_time&active_enemies>=variable.combustion_flamestrike
        --debug("[Action:Combust Phase] Scorch ()")
        if not buff.combustion.react() and cd.combustion.remains() < cast.time.flamestrike() 
        and #enemies.yards6t >= var.combustion_flamestrike 
        and not moving 
        and br.getLineOfSight("player","target")
        then 
            --[[if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then
                br._G.SpellStopTargeting()
                debug("[Action:Combust Phase] Flamestrike [Enemies>=var combust flamestrike] (1)")
                return true
            end]]
            if ui.value("Flamestrike Target") == 1 then -- We have "Target" selected.
                if ui.checked("Predict Movement") then -- We have "Best" selected.
                    if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then 
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike [Enemies>=var combust flamestrike] (1)") 
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then 
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike [Enemies>=var combust flamestrike] (1)") 
                        return true 
                    end
                end
            elseif ui.value("Flamestrike Target") == 2 then
                if ui.checked("Predict Movement") then
                    if cast.flamestrike("best",false,1,8,true) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike [Enemies>=var combust flamestrike] (1)") 
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if cast.flamestrike("best",false,1,8) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike [Enemies>=var combust flamestrike] (1)") 
                        return true 
                    end 
                end
                if ui.checked("Predict Movement") then
                    if cast.flamestrike("best",false,1,8,true) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike [Enemies>=var combust flamestrike] (1)")
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if cast.flamestrike("best",false,1,8) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Combust Phase] Flamestrike [Enemies>=var combust flamestrike] (1)")
                        return true 
                    end 
                end
            end
        end
        -- actions.combustion_phase+=/fireball,if=buff.combustion.down&cooldown.combustion.remains<cast_time&!conduit.flame_accretion
        if not buff.combustion.react() 
        and cd.combustion.remains() < cast.time.fireball() 
        and not conduit.flameAccretion 
        and not moving 
        and br.getLineOfSight("player","target")
        then
            if cast.fireball("target") then debug("[Action:Combust Phase] Fireball ()") return true end 
        end
        -- actions.combustion_phase+=/scorch,if=buff.combustion.remains>cast_time&buff.combustion.up|buff.combustion.down&cooldown.combustion.remains<cast_time
        --[[if buff.combustion.remains() > cast.time.scorch() 
        and buff.combustion.react() or not buff.combustion.react() 
        and cd.combustion.remains() < cast.time.scorch() 
        then
            if cast.scorch("target") then debug("[Action:Combust Phase] Scorch (combustion)") return true end
        end]]
        -- actions.combustion_phase+=/living_bomb,if=buff.combustion.remains<gcd.max&active_enemies>1
        if #enemies.yards8t > 1 and buff.combustion.remains() < gcdMax then
            if cast.livingBomb("target") then debug("[Action:Combust Phase] Living Bomb ()") return true end
        end
        -- actions.combustion_phase+=/dragons_breath,if=buff.combustion.remains<gcd.max&buff.combustion.up
        if buff.combustion.react() and buff.combustion.remains() < gcdMax and br.getDistance("target") <= 8 then
            if br.isChecked("Auto Faccia") and not br.getLineOfSight("player","target") then
                var.Module_KinkySex(spell.dragonsBreath,"target")
                debug("[Action:Combust Phase] Dragons Breath (COMBUUUST) (11)")
                return true 
            else 
                if cast.dragonsBreath("target") then debug("[Action:Combust Phase] Dragons Breath (COMBUUUST) (11)") return true end
            end  
        end
        -- actions.combustion_phase+=/scorch,if=target.health.pct<=30&talent.searing_touch
        if thp <= 30 and talent.searingTouch and br.getLineOfSight("player","target") then
            if cast.scorch("target") then debug("[Action:Combust Phase] Scorch (Target HP <= 30%, Searing Touch) (12)") return true end 
        end
    end

    local function actionList_RopPhase()
    if spellQueueReady() then
        -- actions.rop_phase=flamestrike,if=active_enemies>=variable.hot_streak_flamestrike&(buff.hot_streak.react|buff.firestorm.react)
        if #enemies.yards6t >= var.hard_cast_flamestrike and (buff.hotStreak.react() or runeforge.firestorm.equiped and buff.firestorm.react()) and not moving and br.getDistance("target") < 40 then     
            if ui.value("Flamestrike Target") == 1 then -- We have "Target" selected.
                if ui.checked("Predict Movement") then -- We have "Best" selected.
                    if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then 
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Enemies>=Hot Streak Flamestrike] (1)") return true 
                    end
                elseif not moving or targetMovingCheck then
                    if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then 
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Enemies>=Hot Streak Flamestrike] (1)") return true 
                    end
                end
            elseif ui.value("Flamestrike Target") == 2 then
                if ui.checked("Predict Movement") then
                    if cast.flamestrike("best",false,1,8,true) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Enemies>=Hot Streak Flamestrike] (1)") return true end
                elseif not moving or targetMovingCheck then
                    if cast.flamestrike("best",false,1,8) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Enemies>=Hot Streak Flamestrike] (1)") 
                        return true 
                    end 
                end
                if ui.checked("Predict Movement") then
                    if cast.flamestrike("best",false,1,8,true) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Enemies>=Hot Streak Flamestrike] (1)") 
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if cast.flamestrike("best",false,1,8) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Enemies>=Hot Streak Flamestrike] (1)") 
                        return true 
                    end 
                end
            end 
        end
        end
        -- actions.rop_phase+=/pyroblast,if=buff.sun_kings_blessing_ready.up&buff.sun_kings_blessing_ready.remains>cast_time
        if runeforge.sunKingsBlessings.equiped and buff.sunKingsBlessings.react() and buff.sunKingsBlessings.remains() > cast.time.pyroblast() then
            if cast.pyroblast("target") then debug("[Action:RoP Phase] Pyroblast (Sun Kings Blessing) (2)") return true end 
        end
        -- actions.rop_phase+=/pyroblast,if=buff.firestorm.react
        if runeforge.firestorm.equiped and buff.firestorm.react() then
            if cast.pyroblast("target") then debug("[Action:RoP Phase] Pyroblast (firestorm) (3)") return true end        
        end
        -- actions.rop_phase+=/pyroblast,if=buff.hot_streak.react
        if buff.hotStreak.react()
        -- and interruptCast() 
        then
            if cast.pyroblast("target") then debug("[Action:RoP Phase] Pyroblast (Hot Streak) (3.5)") return true end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Use one Fire Blast early in RoP if you don't have either Heating Up or Hot Streak yet and either: (a) have more than two already, (b) have Alexstrasza's Fury ready to use, or (c) Searing Touch is active. Don't do this while hard casting Flamestrikes or when Sun King's Blessing is ready.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.rop_phase+=/fire_blast,use_off_gcd=1,use_while_casting=1,if=!variable.fire_blast_pooling&buff.sun_kings_blessing_ready.down&active_enemies<variable.hard_cast_flamestrike&!firestarter.active&(!buff.heating_up.react&!buff.hot_streak.react&!prev_off_gcd.fire_blast&(action.fire_blast.charges>=2|(talent.alexstraszas_fury&cooldown.dragons_breath.ready)|(talent.searing_touch&target.health.pct<=30)))
        if not var.fire_blast_pooling and not buff.sunKingsBlessings.react() 
        and #enemies.yards10t < var.hard_cast_flamestrike and firestarterInactive 
        and (not buff.heatingUp.react() and not buff.hotStreak.react() and not cast.last.fireBlast() 
        and (charges.fireBlast.count() >= 2 or (talent.alexstraszasFury 
        and cd.dragonsBreath.ready()) or (talent.searchingTouch))) 
        then
            if cast.fireBlast("target") then debug("[Action:RoP Phase] Fire Blast (4)") return true end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Use Fire Blast either during a Fireball/Pyroblast cast when Heating Up is active or during execute with Searing Touch.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.rop_phase+=/fire_blast,use_off_gcd=1,use_while_casting=1,if=!variable.fire_blast_pooling&!firestarter.active&(((action.fireball.executing&(action.fireball.execute_remains<0.5|!runeforge.firestorm)|action.pyroblast.executing&(action.pyroblast.execute_remains<0.5|!runeforge.firestorm))
        -- &buff.heating_up.react)|(talent.searing_touch&target.health.pct<=30&(buff.heating_up.react&!action.scorch.executing|!buff.hot_streak.react&!buff.heating_up.react&action.scorch.executing&!hot_streak_spells_in_flight)))
        if not var.fire_blast_pooling and firestarterInactive 
        and (((cast.current.fireball() 
        and (cast.timeRemain() < 0.5 or not runeforge.firestorm.equiped) or cast.current.pyroblast() 
        and (cast.timeRemain() < 0.5 or not runeforge.firestorm.equiped)) and buff.heatingUp.react()) or (talent.searingTouch
        and (buff.heatingUp.react() 
        and not cast.current.scorch() or not buff.hotStreak.react() 
        and not buff.heatingUp.react() and cast.current.scorch() and not var.hot_streak_spells_in_flight)))
      --  and interruptCast()
        then
        --    if br._G.UnitCastingInfo("player") then
          --     br._G.SpellStopCasting()
          --  end
            if cast.fireBlast("target") then debug("[Action:RoP Phase] Fire Blast (5)") return true end 
        end 
        -- actions.rop_phase+=/call_action_list,name=active_talents
        if actionList_ActiveTalents() then return end 
        -- actions.rop_phase+=/pyroblast,if=buff.pyroclasm.react&cast_time<buff.pyroclasm.remains&cast_time<buff.rune_of_power.remains
        if buff.pyroclasm.react() and cast.time.pyroblast() < buff.pyroclasm.remains() and cast.time.pyroblast() < buff.runeOfPower.remains() then
             if cast.pyroblast("target") then debug("[Action:RoP Phase] Pyroblast (6)") return true end 
        end
        -- actions.rop_phase+=/pyroblast,if=prev_gcd.1.scorch&buff.heating_up.react&talent.searing_touch&target.health.pct<=30&active_enemies<variable.hot_streak_flamestrike
        if cast.last.scorch() and buff.heatingUp.react() 
        and talent.searingTouch and thp <= 30 
        and #enemies.yards10t < var.hot_streak_flamestrike 
      --  and interruptCast()
        then
          --  if br._G.UnitCastingInfo("player") then
          --     br._G.SpellStopCasting()
          --  end
            if cast.pyroblast("target") then debug("[Action:RoP Phase] Pyroblast (7)") return true end 
        end
        -- actions.rop_phase+=/phoenix_flames,if=!variable.phoenix_pooling&buff.heating_up.react&!buff.hot_streak.react&(active_dot.ignite<2|active_enemies>=variable.hard_cast_flamestrike|active_enemies>=variable.hot_streak_flamestrike)
        if not var.phoenix_pooling 
        and buff.heatingUp.react() and not buff.hotStreak.react() and (var.soul_ignition_count < 2 or #enemies.yards10t >= var.hard_cast_flamestrike or #enemies.yards10 >= var.hot_streak_flamestrike) 
        --and interruptCast()
        then
          --  if br._G.UnitCastingInfo("player") then
          --     br._G.SpellStopCasting()
          --  end
            if cast.phoenixFlames("target") then debug("[Action:RoP Phase] Phoenix Flames (8)") return true end 
        end
        -- actions.rop_phase+=/scorch,if=target.health.pct<=30&talent.searing_touch
        if thp <= 30 and talent.searingTouch and br.getLineOfSight("player","target") then
            if cast.scorch("target") then debug("[Action:RoP Phase] Scorch (Target HP <= 30%, Searing Touch) (9)") return true end 
        end
        -- actions.rop_phase+=/dragons_breath,if=active_enemies>2
        if br.getDistance("target") <= 8 and #enemies.yards10 > 2 then
            if cast.dragonsBreath("player") then return true end 
        end
        -- actions.rop_phase+=/arcane_explosion,if=active_enemies>=variable.arcane_explosion&mana.pct>=variable.arcane_explosion_mana
        if not br.isTotem("target") and #enemies.yards10 >= var.arcane_explosion and br.getDistance("target") <= 10 and manaPercent >= var.arcane_explosion_mana then
            if cast.arcaneExplosion("player","aoe", 3, 10) then debug("[Action:Standard] Arcane Explosion (10)") return true end 
        end
       --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
       -- # With enough targets, it is a gain to cast Flamestrike as filler instead of Fireball.
       --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
       -- actions.rop_phase+=/flamestrike,if=active_enemies>=variable.hard_cast_flamestrike
        if #enemies.yards8t >= var.hard_cast_flamestrike and not moving then 
            --[[if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, true) then
                br._G.SpellStopTargeting()
                debug("[Action:Standard] Flamestrike [Hardcast] (11)")
                return true
            end]]
            if ui.value("Flamestrike Target") == 1 then -- We have "Target" selected.
                if ui.checked("Predict Movement") then -- We have "Best" selected.
                    if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then 
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Hardcast] (11)")
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then 
                        br._G.SpellStopTargeting()
                       debug("[Action:Standard] Flamestrike [Hardcast] (11)")
                        return true 
                    end
                end
            elseif ui.value("Flamestrike Target") == 2 then
                if ui.checked("Predict Movement") then
                    if cast.flamestrike("best",false,1,8,true) then
                        br._G.SpellStopTargeting()
                       debug("[Action:Standard] Flamestrike [Hardcast] (11)")
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if cast.flamestrike("best",false,1,8) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Hardcast] (11)") 
                        return true 
                    end 
                end
                if ui.checked("Predict Movement") then
                    if cast.flamestrike("best",false,1,8,true) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Hardcast] (11)")
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if cast.flamestrike("best",false,1,8) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Hardcast] (11)")
                        return true 
                    end 
                end
            end
        end
        -- actions.rop_phase+=/fireball
        if not buff.combustion.react() and not moving and br.getLineOfSight("player","target") then 
           if cast.fireball("target") then debug("[Action:RoP Phase] Fireball (12)") return true end
        end
    end -- End Action List - RoP Phase

    local function actionList_Standard_Rotation()
    if spellQueueReady() then
        -- actions.standard_rotation=flamestrike,if=active_enemies>=variable.hot_streak_flamestrike&(buff.hot_streak.react|buff.firestorm.react)
        if #enemies.yards10 >= var.hot_streak_flamestrike and (buff.hotStreak.react() or runeforge.firestorm.equiped and buff.firestorm.react()) then
            if cast.pyroblast("target") then debug("[Action:Standard] Fire Blast (1)") return true end 
        end
        -- actions.standard_rotation+=/pyroblast,if=buff.firestorm.react
        if runeforge.firestorm.equiped and buff.firestorm.react() then 
            if cast.pyroblast("target") then return true end 
        end
        -- actions.standard_rotation+=/pyroblast,if=buff.hot_streak.react&buff.hot_streak.remains<action.fireball.execute_time
        if buff.hotStreak.react() and buff.hotStreak.remains() < cast.time.fireball() 
        or buff.hotStreak.exists() and cast.current.scorch() 
        and thp > 30
        then
            if cast.pyroblast("target") then debug("[Action:Standard] Fire Blast (2)") return true end 
        end
        -- actions.standard_rotation+=/pyroblast,if=buff.hot_streak.react&(prev_gcd.1.fireball|firestarter.active|action.pyroblast.in_flight)
        if buff.hotStreak.react() and not buff.combustion.react()
        and (cast.last.fireball() or firestarterActive or cast.inFlight.pyroblast()) 
        then
            if cast.pyroblast("target") then debug("[Action:Standard] Fire Blast (4)") return true end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Try to get SKB procs inside RoP phases or Combustion phases when possible.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.standard_rotation+=/pyroblast,if=buff.sun_kings_blessing_ready.up&(cooldown.rune_of_power.remains+action.rune_of_power.execute_time+cast_time>buff.sun_kings_blessing_ready.remains|!talent.rune_of_power)&variable.time_to_combustion+cast_time>buff.sun_kings_blessing_ready.remains
        if runeforge.sunKingsBlessings.equiped and buff.sunKingsBlessings.react() 
        and (cd.runeOfPower.remains()+cast.time.runeOfPower()+cast.time.pyroblast() > buff.sunKingsBlessings.remains() 
        or not talent.runeOfPower) 
        and var.time_to_combustion+cast.time.pyroblast() > buff.sunKingsBlessings.remains() 
        then
            if cast.pyroblast("target") then debug("[Action:Standard] Fire Blast (5)") return true end  
        end
        -- actions.standard_rotation+=/pyroblast,if=buff.hot_streak.react&target.health.pct<=30&talent.searing_touch
        if buff.hotStreak.react() and talent.searingTouch then
            if cast.pyroblast("target") then debug("[Action:Standard] Fire Blast (6)") return true end 
        end
        -- actions.standard_rotation+=/pyroblast,if=buff.pyroclasm.react&cast_time<buff.pyroclasm.remains
        if talent.pyroclasm and buff.pyroclasm.react() and cast.time.pyroblast() < buff.pyroclasm.remains() then
            if cast.pyroblast("target") then debug("[Action:Standard] Fire Blast (7)") return true end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # During the standard rotation, only use Fire Blasts when they are not being pooled for RoP or Combustion. Use Fire Blast either during a Fireball/Pyroblast cast when Heating Up is active or during execute with Searing Touch.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.standard_rotation+=/fire_blast,use_off_gcd=1,use_while_casting=1,if=!firestarter.active&!variable.fire_blast_pooling&(((action.fireball.executing&(action.fireball.execute_remains<0.5|!runeforge.firestorm)|action.pyroblast.executing&(action.pyroblast.execute_remains<0.5|!runeforge.firestorm))&buff.heating_up.react)|(talent.searing_touch&target.health.pct<=30&(buff.heating_up.react&!action.scorch.executing|!buff.hot_streak.react&!buff.heating_up.react&action.scorch.executing&!hot_streak_spells_in_flight)))
        if firestarterInactive and not var.fire_blast_pooling 
        and(((cast.current.fireball() and (cast.timeRemain() < 0.5 
        or not runeforge.firestorm.equiped) or cast.current.pyroblast 
        and (cast.timeRemain() or not runeforge.firestorm.equiped)) 
        and buff.heatingUp.react()) or (talent.searingTouch and thp <= 30
        and (buff.heatingUp.react() and not cast.current.scorch() or not buff.hotStreak.react() 
        and not buff.heatingUo.react() and cast.current.scorch() 
        and not var.hot_streak_spells_in_flight))) 
        then 
            if cast.fireBlast("target") then debug("[Action:Standard] Fire Blast (8)") return true end 
        end
        -- actions.standard_rotation+=/pyroblast,if=prev_gcd.1.scorch&buff.heating_up.react&talent.searing_touch&target.health.pct<=30&active_enemies<variable.hot_streak_flamestrike
        if cast.last.scorch() and buff.heatingUp.react() 
        and talent.searingTouch and thp <= 30 and cast.current.scorch()
        and #enemies.yards10 < var.hot_streak_flamestrike 
        then
            if cast.pyroblast("target") then debug("[Action:Standard] Pyroblast (9)") return true end 
        end
        -- actions.standard_rotation+=/phoenix_flames,if=!variable.phoenix_pooling&(!talent.from_the_ashes|active_enemies>1)&(active_dot.ignite<2|active_enemies>=variable.hard_cast_flamestrike|active_enemies>=variable.hot_streak_flamestrike)
        if not var.phoenix_pooling 
        and (not talent.fromTheAshes or #enemies.yards10 > 1) 
        and (var.soul_ignition_count < 2 or #enemies.yards10 >= var.hard_cast_flamestrike 
        or #enemies.yards10 >= var.hot_streak_flamestrike)
        then
            if cast.phoenixsFlames("target") then debug("[Action:Standard] Phoenix Flames (10)") return true end 
        end
        -- actions.standard_rotation+=/call_action_list,name=active_talents
        if actionList_ActiveTalents() then return end 
        -- actions.standard_rotation+=/dragons_breath,if=active_enemies>1
        if (br.getDistance("target") <= 8) and #enemies.yards10 > 1 then
            if cast.dragonsBreath("player") then debug("[Action:Standard] Dragons Breath (Enemies > 1) (11)") return true end --dPrint("db3") return end
        end
        -- actions.standard_rotation+=/scorch,if=target.health.pct<=30&talent.searing_touch
        if talent.searingTouch and thp <= 30 and br.getLineOfSight("player","target") then
            if cast.scorch("target") then debug("[Action:Standard] Scorch (Target HP <= 30%, Searing Touch) (12)") return true end 
        end
        -- actions.standard_rotation+=/arcane_explosion,if=active_enemies>=variable.arcane_explosion&mana.pct>=variable.arcane_explosion_mana
        if not br.isTotem("target") and #enemies.yards10 >= var.arcane_explosion and br.getDistance("target") <= 10 and manaPercent >= var.arcane_explosion_mana then
            if cast.arcaneExplosion("player","aoe", 3, 10) then debug("[Action:Standard] Arcane Explosion (13)") return true end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # With enough targets, it is a gain to cast Flamestrike as filler instead of Fireball.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions.standard_rotation+=/flamestrike,if=active_enemies>=variable.hard_cast_flamestrike
        if #enemies.yards6t >= var.hard_cast_flamestrike 
        and not moving and br.getDistance("target") < 40 then 
            if ui.value("Flamestrike Target") == 1 then -- We have "Target" selected.
                if ui.checked("Predict Movement") then -- We have "Best" selected.
                    if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then 
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Hardcast] (14)")
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if br.createCastFunction("best", false, 1, 8, spell.flamestrike, nil, false, 0) then 
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Hardcast] (14)")
                        return true 
                    end
                end
            elseif ui.value("Flamestrike Target") == 2 then
                if ui.checked("Predict Movement") then
                    if cast.flamestrike("best",false,1,8,true) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Hardcast] (14)")
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if cast.flamestrike("best",false,1,8) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Hardcast] (14)")
                        return true 
                    end 
                end
                if ui.checked("Predict Movement") then
                    if cast.flamestrike("best",false,1,8,true) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Hardcast] (14)")
                        return true 
                    end
                elseif not moving or targetMovingCheck then
                    if cast.flamestrike("best",false,1,8) then
                        br._G.SpellStopTargeting()
                        debug("[Action:Standard] Flamestrike [Hardcast] (14)")
                        return true 
                    end 
                end
            end
        end
        -- actions.standard_rotation+=/fireball
        if not buff.combustion.react() and not moving and br.getLineOfSight("player","target") then
            if cast.fireball("target") then debug("[Action:Standard] Fireball (15)") return true end 
        end
      end -- End SpellQueueReady
    end -- End Action List - Standard

    local function actionList_Rotation()
    if spellQueueReady() then 
        -- actions+=/shifting_power,if=buff.combustion.down&!(buff.infernal_cascade.up&buff.hot_streak.react)&variable.shifting_power_before_combustion
        if covenant.nightFae.active and not buff.shiftingPower.react() 
        and (not buff.infernalCascade.react() and buff.hotStreak.react()) 
        and var.bool(var.shifting_power_before_combustion) 
        and br.getDistance("target") <= 16 and not moving
        then
            if cast.shiftingPower("target") then debug("[Action:Rotation] Shifting Power (1)") return true end
        end
        -- actions+=/radiant_spark,if=(buff.combustion.down&buff.rune_of_power.down&(variable.time_to_combustion<execute_time|variable.time_to_combustion>cooldown.radiant_spark.duration))|(buff.rune_of_power.up&variable.time_to_combustion>30)
        if covenant.kyrian.active
        and (not buff.combustion.react() and not buff.runeOfPower.react() 
        and (var.time_to_combustion < cast.time.shiftingPower() or var.time_to_combustion > cd.radiantSpark.duration())) 
        or (buff.runeOfPower.react() and var.time_to_combustion > 30) 
        then 
            if cast.radiantSpark("target") then debug("[Action:Rotation] Radiant Spark (2)") return true end 
        end
        -- actions+=/deathborne,if=buff.combustion.down&buff.rune_of_power.down&variable.time_to_combustion<execute_time
        if covenant.necrolord.active 
        and not buff.combustion.react() 
        and buff.runeOfPower.react() and var.time_to_combustion < cast.time.deathborne() 
        then
            if cast.deathborne("target") then debug("[Action:Rotation] Deathborne (3)") return true end 
        end
        -- actions+=/mirrors_of_torment,if=variable.time_to_combustion<=3&buff.combustion.down
        if covenant.venthyr.active 
        and var.time_to_combustion <= 3 and not buff.combustion.react() 
        then
            if cast.mirrorsOfTorment("target") then debug("[Action:Rotation] Mirrors Of Torment (4)") return true end
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # For Venthyr, use a Fire Blast charge during Mirrors of Torment cast to avoid capping charges.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/fire_blast,use_while_casting=1,if=action.mirrors_of_torment.executing&full_recharge_time-action.mirrors_of_torment.execute_remains<4&!hot_streak_spells_in_flight&!buff.hot_streak.react
        if covenant.venthyr.active 
        and cast.current.mirrorsOfTorment()
        and charges.fireBlast.timeTillFull()-var.execute_remains < 4 
        and not cast.inFlight.fireBlast() and buff.hotStreak.react()
        then 
            if cast.fireBlast("target") then debug("[Action:Rotation] Fire Blast (5)") return true end
        end
        -- actions+=/use_item,effect_name=gladiators_badge,if=variable.time_to_combustion>cooldown-5
        if use.able.gladiatorsBadge() and var.time_to_combustion > 60-5 then use.gladiatorsBadge(); end 
        if use.able.gladiatorsBadgeAlacrity() and var.time_to_combustion > 60-5 then use.gladiatorsBadgeAlacrity(); end
        
        if use.able.empyrealOrdnance() then
            -- actions+=/use_item,name=empyreal_ordnance,if=variable.time_to_combustion<=variable.empyreal_ordnance_delay&variable.time_to_combustion>variable.empyreal_ordnance_delay-5
            if var.time_to_combustion <= var.empyreal_ordnance_delay and var.time_to_combustion > var.empyreal_ordnance_delay-5 then use.empyrealOrdnance(); end
            -- actions+=/use_item,name=empyreal_ordnance,if=variable.time_to_combustion<=variable.empyreal_ordnance_delay
            if var.time_to_combustion <= var.empyreal_ordnance_delay then use.empyrealOrdnance(); end
        end
        -- actions+=/use_item,name=glyph_of_assimilation,if=variable.time_to_combustion>=variable.on_use_cutoff
        if use.able.glyphOfAssimilation() and var.time_to_combustion >= var.on_use_cutoff then use.glyphOfAssimilation(); end
        -- actions+=/use_item,name=macabre_sheet_music,if=variable.time_to_combustion<=5
        if use.able.macabreSheetMusic and var.time_to_combustion <= 5 then use.macabreSheetMusic(); end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # If using a steroid on-use item, always use Dreadfire Vessel outside of Combustion. Otherwise, prioritize using Dreadfire Vessel with Combustion only if Infernal Cascade is enabled and a usage won't be lost over the duration of the fight.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/use_item,name=dreadfire_vessel,if=variable.time_to_combustion>=variable.on_use_cutoff&(buff.infernal_cascade.stack=buff.infernal_cascade.max_stack|!conduit.infernal_cascade|variable.combustion_on_use|variable.time_to_combustion+5>fight_remains%%cooldown)
        if var.time_to_combustion >= var.num(var.on_use_cutoff) 
        and (buff.infernalCascade.stack() > 1 
        or not conduit.infernalCascade 
        or var.combustion_on_use > 0 
        or var.time_to_combustion+5 > ttd("target")) 
        then 
            if use.dreadfireVessel() then 
                debug("[Action:Rotation] Dreadfire Vessel  (SimC)")
                return true 
            end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Soul Igniter should be used in a way that doesn't interfere with other on-use trinkets. Other trinkets do not trigger a shared ICD on it, so it can be used right after any other on-use trinket.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/use_item,name=soul_igniter,if=(variable.time_to_combustion>=30*(variable.on_use_cutoff>0)|cooldown.item_cd_1141.remains)&(!equipped.dreadfire_vessel|cooldown.dreadfire_vessel_344732.remains>5)
        if use.able.soulIgnitor()
        and (var.time_to_combustion >= 30*(var.bool(var.on_use_cutoff) > 0) 
        or cd.soulIgnitor.remains()) 
        and (not use.able.dreadfireVessel() 
        or cd.dreadfireVessel.remains() > 5) 
        then
            use.soulIgnitor()
            debug("[Action:Rotation] Soul Ignitor (SimC)")
            return true 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Trigger Soul Igniter early with Infernal Cascade or when it was precast.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/cancel_buff,name=soul_ignition,if=!conduit.infernal_cascade&time<5|buff.infernal_cascade.stack=buff.infernal_cascade.max_stack
        if not conduit.infernalCascade and combatTime < 5 or buff.infernalCascade.stack() > 1 then 
            debug("[Action:Rotation] Infernal Cascade (6)")
            br._G.RunMacroText("/cancelaura Soul Ignition")
            return true
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Items that do not benefit Combustion should just be used outside of Combustion at some point.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/use_item,name=inscrutable_quantum_device,if=equipped.gladiators_badge&variable.time_to_combustion>=variable.on_use_cutoff
        if use.able.inscrutableQuantumDevice() and (use.able.gladiatorsBadge() or use.able.gladiatorsBadgeAlacrity()) and var.time_to_combustion >= var.on_use_cutoff then 
            use.inscrutableQuantumDevice()
        end
        -- actions+=/use_item,name=flame_of_battle,if=equipped.gladiators_badge&variable.time_to_combustion>=variable.on_use_cutoff


        -- actions+=/use_item,name=wakeners_frond,if=equipped.gladiators_badge&variable.time_to_combustion>=variable.on_use_cutoff
        -- actions+=/use_item,name=instructors_divine_bell,if=equipped.gladiators_badge&variable.time_to_combustion>=variable.on_use_cutoff
        -- actions+=/use_item,name=sunblood_amethyst,if=equipped.gladiators_badge&variable.time_to_combustion>=variable.on_use_cutoff
        -- actions+=/use_items,if=variable.time_to_combustion>=variable.on_use_cutof
        --if var.time_to_combustion >= var.on_use_cutoff then
        --    if actionList_Use_Items() then return end 
       -- end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Get the Disciplinary Command buff up, unless combustion is soon.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/counterspell,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_arcane.down&!buff.disciplinary_command.up&variable.time_to_combustion>25
        -- actions+=/arcane_explosion,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_arcane.down&!buff.disciplinary_command.up&variable.time_to_combustion>25
        -- actions+=/frostbolt,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_frost.down&!buff.disciplinary_command.up&variable.time_to_combustion>25

        -- actions+=/call_action_list,name=combustion_phase,if=variable.time_to_combustion<=0
        if var.time_to_combustion <= 0 and (br.useCDs() or ttd("target") > ui.value("Cooldowns Time to Die Limit") or ui.value("Combustion TTD")) then
            if actionList_CombustionPhase() then return end
        end
        -- actions+=/rune_of_power,if=buff.rune_of_power.down&!buff.firestorm.react&(variable.time_to_combustion>=buff.rune_of_power.duration&variable.time_to_combustion>action.fire_blast.full_recharge_time|variable.time_to_combustion>fight_remains)
        if not buff.runeOfPower.react() and not buff.firestorm.react() 
        and not buff.combustion.react()
        and cd.combustion.remains() > 20
        and (var.time_to_combustion >= buff.runeOfPower.duration() 
        and var.time_to_combustion > charges.fireBlast.timeTillFull() 
        or var.time_to_combustion > ttd("target")) 
        and not moving 
        then
            if cast.runeOfPower("target") then debug("[Action:Rotation] Rune Of Power (7)") return true end 
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Pool as many Fire Blasts as possible for Combustion. Subtract out of the fractional component of the number of Fire Blasts that will naturally recharge during the Combustion phase because pooling anything past that will not grant an extra Fire Blast during Combustion.
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/variable,use_off_gcd=1,use_while_casting=1,name=fire_blast_pooling,value=action.fire_blast.charges_fractional+(variable.time_to_combustion+action.shifting_power.full_reduction*variable.shifting_power_before_combustion)%cooldown.fire_blast.duration-1<cooldown.fire_blast.max_charges+variable.overpool_fire_blasts%cooldown.fire_blast.duration-(buff.combustion.duration%cooldown.fire_blast.duration)%%1&variable.time_to_combustion<fight_remains
        -- var.fire_blast_pooling = charges.fireBlast.frac() + (var.time_to_combustion+4*var.num(var.shifting_power_before_combustion)) and var.num(cd.fireBlast.duration())-1<2+var.overpool_fire_blasts and var.num(cd.fireBlast.duration())-(var.num(buff.combustion.duration()) and var.num(cd.fireBlast.duration()) and var.time_to_combustion < ttd("Target"))
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Variable that controls Phoenix Flames usage to ensure its charges are pooled for Combustion. Only use Phoenix Flames outside of Combustion when full charges can be obtained during the next Combustion.
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/variable,name=phoenix_pooling,if=active_enemies<variable.combustion_flamestrike,value=variable.time_to_combustion+buff.combustion.duration-5<action.phoenix_flames.full_recharge_time+cooldown.phoenix_flames.duration-action.shifting_power.full_reduction*variable.shifting_power_before_combustion&variable.time_to_combustion<fight_remains|runeforge.sun_kings_blessing|time<5
        if #enemies.yards6t < var.combustion_flamestrike then
            var.phoenix_pooling = var.time_to_combustion+buff.combustion.duration()-5<charges.phoenixFlames.timeTillFull()+cd.phoenixFlames.duration()-4*var.num(var.combustion_shifting_power) and var.time_to_combustion < ttd("target") or combatTime < 5
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # When using Flamestrike in Combustion, save as many charges as possible for Combustion without capping.
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/variable,name=phoenix_pooling,if=active_enemies>=variable.combustion_flamestrike,value=variable.time_to_combustion<action.phoenix_flames.full_recharge_time-action.shifting_power.full_reduction*variable.shifting_power_before_combustion&variable.time_to_combustion<fight_remains|runeforge.sun_kings_blessing|time<5
        if #enemies.yards6t >= var.combustion_flamestrike then
            var.phoenix_pooling = var.time_to_combustion < charges.phoenixFlames.timeTillFull()-4*var.num(var.shifting_power_before_combustion) and var.time_to_combustion < ttd("target") or combatTime < 5
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # When Hardcasting Flame Strike, Fire Blasts should be used to generate Hot Streaks and to extend Blaster Master.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/fire_blast,use_off_gcd=1,use_while_casting=1,if=!variable.fire_blast_pooling&variable.time_to_combustion>0
        --&active_enemies>=variable.hard_cast_flamestrike&!firestarter.active&!buff.hot_streak.react&(buff.heating_up.react&action.flamestrike.execute_remains<0.5|charges_fractional>=2)
        if not var.fire_blast_pooling 
        and var.time_to_combustion > 0 and #enemies.yards10t >= var.hard_cast_flamestrike 
        and not talent.firestarter and not buff.hotStreak.react() 
        and (buff.heatingUp.react() and cast.current.flamestrike() and var.execute_remains or charges.fireBlast.frac() >= 2) 
        then
            if cast.fireBlast("target") then debug("[Action:Rotation] Fire Blast (Interrupt Flamestrike, extend Blaster Master)(8)") return true end 
        end 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # During Firestarter, Fire Blasts are used similarly to during Combustion. Generally, they are used to generate Hot Streaks when crits will not be wasted and with Blaster Master, they should be spread out to maintain the Blaster Master buff.
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/fire_blast,use_off_gcd=1,use_while_casting=1,if=firestarter.active&charges>=1
        -- &!variable.fire_blast_pooling&(!action.fireball.executing&!action.pyroblast.in_flight&buff.heating_up.react|action.fireball.executing&!buff.hot_streak.react|action.pyroblast.in_flight&buff.heating_up.react&!buff.hot_streak.react)
        if firestarterActive and charges.fireBlast.count() >= 1 
        and not var.fire_blast_pooling 
        and (not cast.current.fireball() and not cast.inFlight.pyroblast() and buff.heatingUp.react() 
        or cast.current.fireball() and not buff.hotStreak.react() 
        or cast.inFlight.pyroblast() and buff.heatingUp.react() and not buff.hotStreak.react()) 
        then
            if cast.fireBlast("target") then debug("[Action:Rotation] Fire Blast (Interrupt Fireball) ()") return true end 
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- # Avoid capping Fire Blast charges while channeling Shifting Power
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        -- actions+=/fire_blast,use_while_casting=1,if=action.shifting_power.executing&full_recharge_time<action.shifting_power.tick_reduction&buff.hot_streak.down&time>10
        if cast.current.shiftingPower() and charges.fireBlast.timeTillFull() < 4 and not buff.hotStreak.react() and combatTime > 10 then
            if cast.fireBlast("target") then debug("[Action:Rotation] Fire Blast (Dont Cap FB charges During SP) ()") return true end 
        end
        -- actions+=/scorch
        if talent.searingTouch and thp < 30 and br.getLineOfSight("player","target") then 
            if cast.scorch("target") then debug("[Action:Rotation] Scorch Filler (11)") return true end 
        end

        if (not buff.combustion.exists() and not cast.last.combustion()) 
        and (not buff.runeOfPower.exists() 
        and not cast.last.runeOfPower()) 
        and not moving 
        and br.getLineOfSight("player","target")
        --and (talent.searingTouch and thp > 30)
        then --and not cast.current.fireball() then ----[[and not buff.heatingUp.exists()--]] and not buff.hotStreak.exists() then --]]
            if cast.fireball("target") then fballLast = true debug("[Action:Rotation] Fireball Filler (12)") return true end
        end
        -- actions+=/call_action_list,name=combustion_phase,if=variable.time_to_combustion<=0
        if (mode.combustion ~= 4 and var.time_to_combustion <= 0) then
            if actionList_CombustionPhase() then return end 
        end
        -- actions+=/call_action_list,name=rop_phase,if=buff.rune_of_power.up&variable.time_to_combustion>0
        if talent.runeOfPower and buff.runeOfPower.react() 
        and (var.time_to_combustion > 0 or mode.combustion ~= 4) 
        then 
            if actionList_RopPhase() then return end 
        end
        -- actions+=/call_action_list,name=standard_rotation,if=variable.time_to_combustion>0&buff.rune_of_power.down
        if var.time_to_combustion > 0 and not buff.runeOfPower.react() 
        then
            if actionList_Standard_Rotation() then return end end
        end
        -- Scorch movement
        if talent.searingTouch and moving or talent.searingTouch and thp < 30 and br.getLineOfSight("player","target") then if cast.scorch("target") then return true end end 

        if not moving and not buff.combustion and combustion.cd.remains() > 5 then if cast.fireball("target") then return true end end
    end

    local actionList_CancelCast = function()
    -- Interrupt Hard casted pyroblasts.
        if inCombat and not buff.hotStreak.exists() and not buff.pyroclasm.exists() and not buff.heatingUp.exists() and not pyroReady then
            if cast.current.pyroblast() then
                if br.timer:useTimer("hc stop Delay", 0.32 / (1 + GetHaste() / 100)) then
                    --CancelPendingSpell()
                    br._G.SpellStopCasting()
                    br.ChatOverlay("no hardcast allowed!")
                  --  return false 
                end 
            end 
        end
    -- Interrupt Fireball during combust/aoe w/ procs. 
        if inCombat and (buff.combustion.react() and  buff.hotStreak.exists() or buff.heatingUp.exists() and pyroReady)
        --or (buff.runeOfPower.react() and buff.heatingUp.exists() or buff.hotStreak.exists() and pyroReady)
        or (buff.hotStreak.exists() and #enemies.yards6t > 2 and fsReady)
     --   and interruptCast()
        then
            if cast.current.fireball() then
                if br.timer:useTimer("fb stop delay2", br.getOptionValue("Cast Interrupting Delay") / (1 + GetHaste() / 100)) then 
                    br._G.SpellStopCasting()
                    debug("no fireball during combust/aoe and having procs!")
                end
            end
        end
    -- Interrupt Scorch w/ procs. 
        if inCombat and buff.hotStreak.exists() or buff.heatingUp.exists() and pyroReady 
        --or (buff.hotStreak.exists() and #enemies.yards6t > 2 and fsReady)
        --and interruptCast()
        then 
            if cast.current.fireball() then
                if br.timer:useTimer("fb stop delay2", br.getOptionValue("Cast Interrupting Delay") / (1 + GetHaste() / 100)) then 
                    br._G.SpellStopCasting()
                    debug("no fireball during combust/aoe and having procs!")
                end
            end
        end
    -- Interrupt Cast for Phoenix Flames, Combust. 
        if buff.combustion.react() and travelTime < buff.combustion.remains() 
        and ((charges.fireBlast.count() < 1 and talent.pyroclasm and #enemies.yards8t == 1) or talent.pyroclasm or #enemies.yards8t > 1) 
        and var.num(buff.heatingUp.react()) + var.num(var.hot_streak_spells_in_flight) 
     --   and interruptCast()
        then
            if cast.current.fireball() then
                if br.timer:useTimer("fb stop delay2", br.getOptionValue("Cast Interrupting Delay") / (1 + GetHaste() / 100)) then 
                    br._G.SpellStopCasting()
                    debug("no fireball during combust/aoe and having procs!")
                end
            end
        end
    -- Interrupt Scorch w/ phoenix Flames, Combust
        if buff.combustion.react() and travelTime < buff.combustion.remains() 
        and ((charges.fireBlast.count() < 1 and talent.pyroclasm and #enemies.yards8t == 1) or talent.pyroclasm or #enemies.yards8t > 1) 
        and var.num(buff.heatingUp.react()) + var.num(var.hot_streak_spells_in_flight) 
        and cast.current.scorch()
        then
            if cast.current.scorch() then
                if br.timer:useTimer("fb stop delay2", br.getOptionValue("Cast Interrupting Delay") / (1 + GetHaste() / 100)) then 
                    br._G.SpellStopCasting()
                    debug("no fireball during combust/aoe and having procs!")
                end
            end
        end
    -- Interrupt fireball w/ Phoenix Flames, Combust
        if buff.combustion.react() and var.in_flight_remains < buff.combustion.remains() 
        and ((charges.fireBlast.count() < 1 and talent.pyroclasm and #enemies.yards10t == 1) 
        or not talent.pyroclasm or #enemies.yards10t > 1) 
        and var.num(buff.heatingUp.react()) + var.num(var.hot_streak_spells_in_flight) < 2 
   --     and interruptCast()
        then
            if cast.current.fireball() then
                if br.timer:useTimer("fb stop delay2", br.getOptionValue("Cast Interrupting Delay") / (1 + GetHaste() / 100)) then 
                    br._G.SpellStopCasting()
                    debug("no fireball during combust/aoe and having procs!")
                end
            end
        end

        -- Cancel Ice Block. 
        if buff.iceBlock.exists("player") and php >= 75 then
            br.cancelBuff(spell.iceBlock)
            br.addonDebug("Cancelling Iceblock")
        end
        -- Cancel AoE targeting. 
        if buff.hotStreak.exists("player") and br._G.IsAoEPending() then
            br._G.SpellStopTargeting()
            br.addonDebug(colorRed.."Aoe Not Cast. Canceling Spell",true)
        end     
    end
---------------------
--- Begin Profile ---
---------------------
 -- Arcane Intellect
        if br.isChecked("Arcane Intellect") and br.timer:useTimer("AI Delay", math.random(15, 30)) then
            for i = 1, #br.friend do
                if not buff.arcaneIntellect.exists(br.friend[i].unit,"any") and br.getDistance("player", br.friend[i].unit) < 40 and not br.GetUnitIsDeadOrGhost(br.friend[i].unit) and br._G.UnitIsPlayer(br.friend[i].unit) then
                    if cast.arcaneIntellect(br.friend[i].unit) then return true end
                end
            end
        end
    -- Profile Stop | Pause
        if not inCombat and not hastar and br.profileStop==true then
            br.profileStop = false
        elseif inCombat and br._G.IsAoEPending() then
            br._G.SpellStopTargeting()
            br.addonDebug("Canceling Spell")
            return false
        elseif (inCombat and br.profileStop == true) or UnitIsAFK("player") or IsMounted() or IsFlying() or br.pause(true) or mode.rotation ==4 or br._G.UnitChannelInfo("player") == GetSpellInfo(spell.shiftingPower) then
            return true
        else
            if br.isChecked("Auto Engage") and solo and not inCombat then 
                if not moving and hastar and br._G.UnitCanAttack("target", "player") and not br.GetUnitIsDeadOrGhost("target") and br.getLineOfSight("player","target") then
                    if br.timer:useTimer("target", math.random(0.2,1.5)) then
                        if cast.fireball("target") then br.addonDebug("Casting Fireball (Pull Spell)") return end
                    end
                elseif moving and hastar and br._G.UnitCanAttack("target", "player") and not br.GetUnitIsDeadOrGhost("target") and talent.searingTouch and br.getLineOfSight("player","target") then
                    if br.timer:useTimer("Scorch Delay", math.random(0.2,1.5)) then
                        if cast.scorch("target") then br.addonDebug("Casting Scorch (Pull Spell)") return end
                    end
                end
            end
-----------------------
--- Extras Rotation ---
-----------------------
            if actionList_Extras() then return end
--------------------------
--- Defensive Rotation ---
--------------------------
            if actionList_Defensive() then return end
            
------------------------------
--- Out of Combat Rotation ---
------------------------------
            if actionList_PreCombat() then return end
            if actionList_CancelCast() then return end
--------------------------
--- In Combat Rotation ---
-------------------------- 
            if inCombat or spellQueueReady() and br.profileStop == false and br.isValidUnit("target") and br.getDistance("target") < 40 then
                           
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end

                if actionList_Cooldowns() then return end
        ------------------------------
        -- MIRROR IMAGE --------------
        ------------------------------
                -- mirror_image,if=buff.combustion.down
                if br.useCDs() and br.isChecked("Mirror Image") and not buff.combustion.react() and cd.combustion.remains() > gcd then
                    if br.timer:useTimer("MI Delay", 1.5) then
                        if cast.mirrorImage("player") then br.addonDebug("Casting Mirror Image") return end
                    end
                end
        ------------------------------
        -- RUNE OF POWER -------------
        ------------------------------
                if (br.useCDs() or (#enemies.yards8t >= br.getValue("RoP Targets") and charges.runeOfPower.count() == 2)) and not moving and talent.runeOfPower and not buff.runeOfPower.exists("player") and not buff.combustion.react()  and ttd("target") > ui.value("Cooldowns Time to Die Limit")  then
                    if talent.firestarter then
                        if (cd.combustion.remains() <= gcd and br.getHP("target") < 90) or (charges.runeOfPower.count() == 2  and (cd.combustion.remains() > 20 or br.getHP("target") >= 90)) then
                            if cast.runeOfPower("player") then br.addonDebug("Casting Rune of Power")
                                return 
                            end
                        end
                    elseif not talent.firestarter then
                        if cd.combustion.remains() <= gcd or (charges.runeOfPower.count()== 2 or charges.runeOfPower.timeTillFull() < 2) and cd.combustion.remains() > 20 and not buff.combustion.react() and ttd("target") > ui.value("Cooldowns Time to Die Limit") then
                            if cast.runeOfPower("player") then br.addonDebug("Casting Rune of Power")
                                return
                            end
                        end
                    end
                end

                if actionList_Rotation() then return end 
            end

        end --End Rotation Logic
end -- End runRotation
local id = 63
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
