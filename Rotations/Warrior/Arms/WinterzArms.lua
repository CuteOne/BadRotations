local rotationName = "WinterzArms"

---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    local RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.cleave },
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.whirlwind },
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.mortalStrike },
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.victoryRush}
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
-- Cooldown Button
local CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.avatar },
        [2] = { mode = "On", value = 2 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.avatar },
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.avatar }
    };
    br.ui:createToggle(CooldownModes,"Cooldown",2,0)
-- Defensive Button
local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.dieByTheSword },
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.dieByTheSword }
    };
    br.ui:createToggle(DefensiveModes,"Defensive",3,0)
-- Interrupt Button
local InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.pummel },
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.pummel }
    };
    br.ui:createToggle(InterruptModes,"Interrupt",4,0)
-- Movement Button
local MoverModes = {
        [1] = { mode = "On", value = 1 , overlay = "Mover Enabled", tip = "Will use Charge/Heroic Leap.", highlight = 1, icon = br.player.spell.charge },
        [2] = { mode = "Off", value = 2 , overlay = "Mover Disabled", tip = "Will NOT use Charge/Heroic Leap.", highlight = 0, icon = br.player.spell.charge }
    };
    br.ui:createToggle(MoverModes,"Mover",5,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable
    local section
    local function rotationOptions()
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General - v 1.0")
            -- Battle Cry
            br.ui:createCheckbox(section, "Battle Shout")
            -- Berserker Rage
            br.ui:createCheckbox(section,"Berserker Rage", "Check to use Berserker Rage")
            br.ui:checkSectionState(section)
        ------------------------
        ---   RAGE SETTINGS  ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Rage Settings")
			br.ui:createText(section, "|cffFF0000GONE FOR NOW THEY ARE BACK LATER!")
            -- Skullsplitter Rage
            br.ui:createSpinnerWithout(section, "Skullsplitter Rage",  60,  1,  100,  1,  "|cffFFBB00Cast SkullSplitter when rage is lower than set value.")
            br.ui:checkSectionState(section)
        ------------------------
        ---   DPS SETTINGS   ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "DPS Settings")
            -- Sweeping Strikes
            br.ui:createSpinner(section,"Sweeping Strikes",  3,  1,  10,  1, "|cffFFBB00Cast Sweeping Strikes when equal or more targets than set value.")
            -- Warbreaker
            br.ui:createSpinner(section,"Warbreaker",  3,  1,  10,  1,  "|cffFFBB00Set to desired targets to use Warbreaker. Min: 1 / Max: 10 / Interval: 1")
            -- Colossus Smash
            br.ui:createSpinner(section,"Colossus Smash",  3,  1,  10,  1,  "|cffFFBB00Set to desired targets to use Colossus Smash. Min: 1 / Max: 10 / Interval: 1")
			-- Condemn
			br.ui:createCheckbox(section, "Use Condemn")
            -- Bladestorm
            br.ui:createSpinner(section, "Bladestorm",  3,  1,  10,  1,  "|cffFFBB00Set to desired targets to use Bladestorm when set to AOE. Min: 1 / Max: 10 / Interval: 1")            
            br.ui:checkSectionState(section)
        ------------------------
        --- COOLDOWN OPTIONS ---
        ------------------------
        section = br.ui:createSection(br.ui.window.profile,  "Cooldowns")
            -- Avatar
            br.ui:createCheckbox(section, "Avatar")
            -- Ravager
            br.ui:createDropdownWithout(section,"Ravager",{"Best","Target","Never"},1,"Desired Target of Ravager")
            -- Racial
            br.ui:createCheckbox(section, "Racial")
            -- Trinkets
            br.ui:createDropdownWithout(section, "Trinkets", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use trinkets.")
            br.ui:createCheckbox(section, "Trinket 1")
            br.ui:createCheckbox(section, "Trinket 2")
            br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Healthstone
            br.ui:createSpinner(section, "Healthstone/Potion",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFBB00Health Percent to Cast At")
            end
            -- Defensive Stance
            br.ui:createSpinner(section, "Defensive Stance",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Die By The Sword
            br.ui:createSpinner(section, "Die By The Sword",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Intimidating Shout
            br.ui:createSpinner(section, "Intimidating Shout",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.")
            -- Rallying Cry
            br.ui:createSpinner(section, "Rallying Cry",  60,  0,  100,  5, "|cffFFBB00Health Percentage to use at.")
            -- Victory Rush
            br.ui:createSpinner(section, "Victory Rush", 60, 0, 100, 5, "|cffFFBB00Health Percentage to use at.")
        br.ui:checkSectionState(section)
        -------------------------
        --- INTERRUPT OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            -- Pummel
            br.ui:createCheckbox(section,"Pummel")
            -- Intimidating Shout
            br.ui:createCheckbox(section,"Intimidating Shout - Int")
            -- Interrupt Percentage
            br.ui:createSpinner(section,  "InterruptAt",  70,  0,  95,  5,  "|cffFFBB00Cast Percentage to use at.")
        br.ui:checkSectionState(section)
    end
    local function toggleOptions()
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Cooldown Key Toggle
            br.ui:createDropdownWithout(section,  "Cooldown Mode", br.dropOptions.Toggle,  3)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdownWithout(section,  "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Mover Toggle
            br.ui:createDropdownWithout(section,  "Mover Mode", br.dropOptions.Toggle,  6)
            -- pause Toggle
            br.ui:createDropdown(section,  "pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "Rotation Options",
            [2] = rotationOptions,
        },
        {
            [1] = "Toggle Keys",
            [2] = toggleOptions,
        }}
    return optionTable
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    if br.timer:useTimer("debugArms", 0) then
        --Print("Running: "..rotationName)

---------------
--- Toggles ---
---------------
        br.UpdateToggle("Rotation",0.25)
        br.UpdateToggle("Cooldown",0.25)
        br.UpdateToggle("Defensive",0.25)
        br.UpdateToggle("Interrupt",0.25)
        br.UpdateToggle("Mover",0.25)
        br.player.ui.mode.mover = br.data.settings[br.selectedSpec].toggles["Mover"]
--------------
--- Locals ---
--------------
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local combatTime                                    = br.getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local debuff                                        = br.player.debuff
        local debug                                         = br.addonDebug
        local enemies                                       = br.player.enemies
        local equiped                                       = br.player.equiped
        local essence                                       = br.player.essence
        local gcd                                           = br.player.gcd
        local gcdMax                                        = br.player.gcdMax
        local hastar                                        = hastar or br.GetObjectExists("target")
        local heirloomNeck                                  = 122667 or 122668
        local inCombat                                      = br.player.inCombat
        local inRaid                                        = br.player.instance == "raid"
        local level                                         = br.player.level
        local mode                                          = br.player.ui.mode
        local opener                                        = br.player.opener
        local php                                           = br.getHP("player")
		local covenant 										= br.player.covenant
        local power                                         = br.player.power.rage.amount()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local rage                                          = br.player.power.rage.amount()
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local traits                                        = br.player.traits
        local units                                         = br.player.units
        local use                                           = br.player.use  
        local ttd                                           = br.getTTD

        units.get(5)
        units.get(8)
        units.get(8,true)
		enemies.get(5)
        enemies.get(8)
        enemies.get(8,"target")
        enemies.get(8,"player",false,true) -- makes enemies.yards8f
        enemies.get(20)
        enemies.yards8r = br.getEnemiesInRect(10,20,false) or 0


        if br.profileStop == nil then br.profileStop = false end

--------------------
--- Action Lists ---
--------------------
    -- Action list - Extras
       local function actionList_Extra()
        -- Battle Shout
        if br.isChecked("Battle Shout") and cast.able.battleShout() then
            for i = 1, #br.friend do
                local thisUnit = br.friend[i].unit
                if not br.GetUnitIsDeadOrGhost(thisUnit) and br.getDistance(thisUnit) < 100 and br.getBuffRemain(thisUnit, spell.battleShout) < 60 then
                    if cast.battleShout() then
                        return
                    end
                end
            end
        end
        -- Berserker Rage
            if br.isChecked("Berserker Rage") and br.hasNoControl(spell.berserkerRage) then
                if cast.berserkerRage() then debug("Casting Berserker Rage") return end
            end
        end -- End Action List - Extra
    -- Action List - Defensive
       local function actionList_Defensive()
            -- Healthstone/Health Potion
                if br.isChecked("Healthstone/Potion") and php <= br.getOptionValue("Healthstone/Potion")
                    and inCombat and (br.hasHealthPot() or br.hasItem(5512))
                then
                    if br.canUseItem(5512) then debug("Using Healthstone")
                        br.useItem(5512)
                    elseif br.canUseItem(br.getHealthPot()) then debug("Using Health Potion")
                        br.useItem(br.getHealthPot())
                    end
            -- Gift of the Naaru
                if br.isChecked("Gift of the Naaru") and cast.able.racial() and php <= br.getOptionValue("Gift of the Naaru") and race=="Draenei" and cd.giftOfTheNaaru.remain() == 0 then
                    if cast.racial() then debug("Casting Gift of the Naaru") return end
                end
            -- Defensive Stance
                if br.isChecked("Defensive Stance") and cast.able.defensiveStance() then
                    if php <= br.getOptionValue("Defensive Stance") and not buff.defensiveStance.exists() then
                        if cast.defensiveStance() then debug("Casting Defensive Stance") return end
                    elseif buff.defensiveStance.exists() and php > br.getOptionValue("Defensive Stance") then
                        if cast.defensiveStance() then debug("Casting Defensive Stance") return end
                    end
                end
            -- Die By The Sword
                if br.isChecked("Die By The Sword") and cast.able.dieByTheSword() and inCombat and php <= br.getOptionValue("Die By The Sword") then
                    if cast.dieByTheSword() then debug("Casting Die By The Sword") return end
                end
            -- Intimidating Shout
                if br.isChecked("Intimidating Shout") and cast.able.intimidatingShout() and inCombat and php <= br.getOptionValue("Intimidating Shout") then
                    if cast.intimidatingShout() then debug("Casting Intimidating Shout") return end
                end
            -- Rallying Cry
                if br.isChecked("Rallying Cry") and cast.able.rallyingCry() and inCombat and php <= br.getOptionValue("Rallying Cry") then
                    if cast.rallyingCry() then debug("Rallying Cry") return end
                end
            -- Victory Rush
                if br.isChecked("Victory Rush") and (cast.able.victoryRush() or cast.able.impendingVictory()) and inCombat and php <= br.getOptionValue("Victory Rush") and buff.victorious.exists() then
                    if talent.impendingVictory then
                        if cast.impendingVictory() then debug("Casting Impending Victory") return end
                    else
                        if cast.victoryRush() then debug("Casting Victory Rush") return end
                    end
                end
            end -- End Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
       local function actionList_Interrupts()
            if br.useInterrupts() then
              --  if br.isChecked("Storm Bolt Logic") then
              --      if cast.able.stormBolt() then
              --          local Storm_list = {
              --              257739
              --          }
              --          for i = 1, #enemies.yards20 do
              --              local thisUnit = enemies.yards20[i]
              --              local distance = br.getDistance(thisUnit)
              --              for k, v in pairs(Storm_list) do
              --                  if (Storm_unitList[br.GetObjectID(thisUnit)] ~= nil or UnitCastingInfo(thisUnit) == GetSpellInfo(v) or UnitChannelInfo(thisUnit) == GetSpellInfo(v)) and br.getBuffRemain(thisUnit, 226510) == 0 and distance <= 20 then
              --                      if cast.stormBolt(thisUnit) then debug("Casting Storm Bolt")
              --                          return 
              --                      end
              --                  end
              --              end
              --          end
              --      end
              --  end
                for i=1, #enemies.yards20 do
                    local thisUnit = enemies.yards20[i]
                    local distance = br.getDistance(thisUnit)
                    if br.canInterrupt(thisUnit,br.getOptionValue("InterruptAt")) then
                    -- Pummel
                        if br.isChecked("Pummel") and cast.able.pummel(thisUnit) and distance < 5 then
                            if cast.pummel(thisUnit) then debug("Casting Pummel") return end
                        end
                    -- Intimidating Shout
                        if br.isChecked("Intimidating Shout - Int") and cast.able.intimidatingShout() and distance < 8 then
                            if cast.intimidatingShout() then debug("Casting Intimidating Shout") return end
                        end
                    end
                end   
            end
        end -- End Action List - Interrupts
    -- Action List - Cooldowns
       local function actionList_Cooldowns()
            if br.getDistance(units.dyn5) < 5 and br.useCDs() then
            -- Racials
                -- actions+=/blood_fury,if=debuff.colossus_smash.up
                -- actions+=/berserking,if=debuff.colossus_smash.up
                -- actions+=/arcane_torrent,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains>1.5&rage<50
                -- actions+=/lights_judgment,if=debuff.colossus_smash.down
                -- actions+=/fireblood,if=debuff.colossus_smash.up
                -- actions+=/ancestral_call,if=debuff.colossus_smash.up
                if br.isChecked("Racial") and cast.able.racial() 
                and (race == "Orc" or race == "Troll" or race == "DarkIronDwarf" or race == "MagharOrc" or race == "Vulpera")
                or ((race == "BloodElf" and cd.mortalStrike.remain() > 1.5 and power < 50) or race == "LightforgedDraenei")
                then
                    if race == "LightforgedDraenei" then
                        if cast.racial("target","ground") then debug("Casting Racial @Target") return true end
                    else
                        if cast.racial("player") then debug("Casting Racial @Player") return true end
                    end
                end
            -- Avatar
                -- avatar,if=cooldown.colossus_smash.remains<8|(talent.warbreaker.enabled&cooldown.warbreaker.remains<8)
                if br.isChecked("Avatar") and cast.able.avatar() then
                    if (talent.warbreaker and cd.warbreaker.remain() < 8) or talent.cleave or talent.collateralDamage then
                        if cast.avatar() then debug("Casting Avatar") return end
                    end
                end
            end
        -- Trinkets
		    -- Trinket 1
            if (br.getOptionValue("Trinkets") == 1 or (br.getOptionValue("Trinkets") == 2 and br.useCDs())) and inCombat then
                if br.isChecked("Trinket 1") and use.able.slot(13)
                 then br.addonDebug("Using Trinket 1")
                        br.useItem(13)
                 end
            -- Trinket 2
                if br.isChecked("Trinket 2") and use.able.slot(14)
                then br.addonDebug("Using Trinket 2")
                    br.useItem(14)
                end
            end
        end -- End Action List - Cooldowns
    -- Action List - Movement
       local function actionList_Movement()
        end -- End Action List - Movement
        -- Action List - Single
       local function actionList_Single()
            -- Warbreaker // actions.single_target+=/warbreaker
                if (mode.rotation ~= 2 and #enemies.yards8 >= 1) then
                    if cast.able.warbreaker() and br.isChecked("Warbreaker") and talent.warbreaker and br.useCDs() then
                        if cast.warbreaker("player","aoe",1,8) then debug("ST Casting Warbreaker") return end
                    end
                -- Colossus Smash // actions.single_target+=/colossus_smash
                    if cast.able.colossusSmash() and br.isChecked("Colossus Smash") and not talent.warbreaker then
                        if cast.colossusSmash("target") then debug("ST Casting ColossusSmash") return end
                    end  
				-- Ravager  //  actions.single_target+=/ravager,if=buff.avatar.remains<18&!dot.ravager.remains
					if cast.able.ravager() and br.useCDs() then
						if cast.ravager("target","ground") then debug("ST Casting Ravager @Target") return end
                    end
				-- actions.single_target+=/overpower,if=charges=2
					if cast.able.overpower() and charges.overpower.frac() == 2 then
						if cast.overpower() then debug("ST Casting Overpower 2stacks") return end
                    end
				-- rend if < 4sec  // actions.single_target+=/rend,if=remains<=duration*0.3
					if cast.able.rend() and (not debuff.rend.exists(units.dyn5) or (debuff.rend.remain(units.dyn5) < 4)) then
						if cast.rend() then debug("Casting Rend")return end
					end
				--  Skullsplitter if < 60 rage, and you're not about to use Bladestorm // actions.single_target+=/skullsplitter,if=rage<60&buff.deadly_calm.down
					if cast.able.skullsplitter() and (rage < br.getOptionValue("Skullsplitter Rage") and (not talent.deadlyCalm or not buff.deadlyCalm.exists())) then
						if cast.skullsplitter() then debug("ST Casting Skullsplitter") return end
					end
				--  Mortal Strike with <4 seconds remaining on Deep Wounds
					if cast.able.mortalStrike() and debuff.deepWounds.remain(units.dyn5) <= 4 then
						if cast.mortalStrike() then debug("ST Casting Mortal Strike DW") return end
					end 
				-- deadly calm
					if cast.able.deadlyCalm() then
						if cast.deadlyCalm() then debug("ST Casting Deadly Calm") return end
                    end
				-- overpower
					if cast.able.overpower() then
						if cast.overpower() then debug("ST Casting Overpower") return end
					end
				-- CondemnMassacre 
					for i = 1, #enemies.yards8 do
						local thisUnit = enemies.yards8[i]
							if br.isChecked("Use Condemn") and (br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player") or (br.getHP(thisUnit) <= 35)) and talent.massacre then
								if cast.condemnMassacre() then debug("ST Casting condemnMassacre") return end
							end
					end
				--  Condemn on Sudden Death proc, target above 80%, or below 20% health (35% with Massacre)
					for i = 1, #enemies.yards8 do
						local thisUnit = enemies.yards8[i]
							if br.isChecked("Use Condemn") and (br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player") or (br.getHP(thisUnit) <= 20)) and not talent.massacre then
								if cast.condemn() then debug("ST Casting condemn") return end
							end
					end
				-- execute
                    if talent.massacre and br.getHP(units.dyn5) <= 35 or not talent.massacre and br.getHP(units.dyn5) <= 20 then
                        if cast.able.execute() and (buff.suddenDeath.exists() or not buff.suddenDeath.exists()) then
                            if cast.execute() then debug("ST Casting Execute @Rage: " .. power) return end
                        end
                    end
				-- mortal strike
					if cast.able.mortalStrike() then
						if cast.mortalStrike() then debug("ST Casting Mortal Strike normal") return end
					end
				--  Bladestorm during Colossus Smash // actions.single_target+=/bladestorm,if=buff.deadly_calm.down&(debuff.colossus_smash.up&rage<30|rage<70)
					if #enemies.yards8 >= br.getOptionValue("Bladestorm") and cast.able.bladestorm() and br.isChecked("Bladestorm") and (not talent.deadlyCalm or not buff.deadlyCalm.exists()) and debuff.colossusSmash.remain(units.dyn5) > 4.5 and not talent.ravager then
						if cast.bladestorm("player","aoe",1,8) then debug("ST Bladestorm @Rage: ".. power) return end
					end
				-- whirlwind // actions.single_target+=/whirlwind,if=talent.fervor_of_battle.enabled
					if cast.able.whirlwind() and talent.fervorOfBattle then
						if cast.whirlwind() then debug("ST casting ww instead of slam") return end
					end
				-- actions.single_target+=/slam,if=!talent.fervor_of_battle.enabled
					if cast.able.slam() and not talent.fervorOfBattle then
						if cast.slam() then debug("ST casting slam instead of ww") return end
					end
            end -- End Action List - Single
		end
        -- Action List - MultiTarget
		local function actionList_Multi()
				-- actions.hac=skullsplitter,if=rage<60&buff.deadly_calm.down
					if cast.able.skullsplitter() and (rage < br.getOptionValue("Skullsplitter Rage") and (not talent.deadlyCalm or not buff.deadlyCalm.exists())) then
						if cast.skullsplitter() then debug("Casting Skullsplitter MT") return end
					end
				-- sweeping strikes // actions+=/sweeping_strikes,if=spell_targets.whirlwind>1&(cooldown.bladestorm.remains>15|talent.ravager.enabled)
					if br.isChecked("Sweeping Strikes") and cast.able.sweepingStrikes() and #enemies.yards8 >= br.getOptionValue("Sweeping Strikes") and (cd.bladestorm.remain() > 15 or talent.ravager) then
						if cast.sweepingStrikes() then debug("MT Casting Sweeping Strikes") return end
					end
					
				--Warbreaker or Cleave to apply Deep Wounds
					if cast.able.warbreaker() and br.isChecked("Warbreaker") and talent.warbreaker and br.useCDs() then
						if cast.warbreaker("player","aoe",1,8) then debug("MT Casting Warbreaker") return end
					end
				--Bladestorm
					if #enemies.yards8 >= br.getOptionValue("Bladestorm") and cast.able.bladestorm() and br.isChecked("Bladestorm") and br.useCDs() and not talent.ravager then
						if cast.bladestorm("player","aoe",1,8) then debug("MT Bladestorm @Rage: ".. power) return end
					end
				-- Ravager
                    if cast.able.ravager() and (br.getOptionValue("Ravager") == 1 or (br.getOptionValue("Ravager") == 2 and br.useCDs())) then
                        -- Best Location
                        if br.getOptionValue("Ravager") == 1 then
                            if cast.ravager("best",nil,1,8) then debug("MT Casting Ravager @Best")return end
                        end
                        -- Target
                        if br.getOptionValue("Ravager") == 2 then
                            if cast.ravager("target","ground") then debug("MT Casting Ravager @Target") return end
                        end
                    end
				-- cleave
                    if talent.cleave and cast.able.cleave() and ((mode.rotation == 1 and #enemies.yards8f > 2) or (mode.rotation == 2 and #enemies.yards8f > 2)) then
                        if cast.cleave(nil,"aoe") then debug("MT Casting Cleave") return end
                    end
				--Colossus Smash on the priority target
                    if cast.able.colossusSmash() and br.isChecked("Colossus Smash") and not talent.warbreaker then
                        if cast.colossusSmash("target") then debug("MT Casting ColossusSmash") return end
                    end  
				-- rend // actions.hac+=/rend,if=remains<=duration*0.3&buff.sweeping_strikes.up
					if cast.able.rend() and (buff.sweepingStrikes.exists() and not debuff.rend.exists(units.dyn5) or (debuff.rend.remain(units.dyn5) < 4)) then
						if cast.rend() then debug("MT Casting Rend")return end
					end
				-- mortal strike to refresh // actions.hac+=/mortal_strike,if=buff.sweeping_strikes.up|dot.deep_wounds.remains<gcd&!talent.cleave.enabled
					if cast.able.mortalStrike() and debuff.deepWounds.remain() <= 4 or buff.sweepingStrikes.exists() then
						if cast.mortalStrike() then debug("MT Casting Mortal Strike Deep Wounds or Sweeping Strikes") return end
					end 
				--Overpower if dreadnaught // actions.hac+=/overpower,if=talent.dreadnaught.enabled
					if cast.able.overpower() and talent.dreadnaught then
						if cast.overpower() then debug("MT Casting Overpower because dreadnaught and aoe") return end
					end
				-- CondemnMassacre 
					for i = 1, #enemies.yards8 do
						local thisUnit = enemies.yards8[i]
							if br.isChecked("Use Condemn") and (br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player") or (br.getHP(thisUnit) <= 35)) and talent.massacre then
								if cast.condemnMassacre() then debug("MT Casting condemnMassacre") return end
							end
					end
				--  Condemn on Sudden Death proc, target above 80%, or below 20% health (35% with Massacre)
					for i = 1, #enemies.yards8 do
						local thisUnit = enemies.yards8[i]
							if br.isChecked("Use Condemn") and (br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player") or (br.getHP(thisUnit) <= 20)) and not talent.massacre then
								if cast.condemn() then debug("MT Casting condemn") return end
							end
					end
				-- execute // actions.hac+=/execute,if=buff.sweeping_strikes.up
					if talent.massacre and br.getHP(units.dyn5) <= 35 or not talent.massacre and br.getHP(units.dyn5) <= 20 then
                        if cast.able.execute() and (buff.suddenDeath.exists() or not buff.suddenDeath.exists()) and buff.sweepingStrikes.exists() then
                            if cast.execute() then debug("MT Casting Execute @Rage: " .. power) return end
                        end
                    end
				-- overpower // actions.hac+=/overpower
					if cast.able.overpower() then
						if cast.overpower() then debug("MT Casting Overpower rest") return end
					end
				--Whirlwind // actions.hac+=/whirlwind
					if cast.able.whirlwind() then
						if cast.whirlwind() then debug("MT casting ww as aoe filler") return end
					end
				--Use Sweeping Strikes on cooldown whenever there are extra targets, and follow the single target Arms Warrior rotation listed above. 
				--Time Rend and Colossus Smash with Sweeping Strikes to spread their debuffs onto a second target when possible. Avoid using Sweeping 
				--Strikes with Bladestorm, since it already hits multiple targets.
				--
		 
			
        end -- End Action List - Multi
		-- Action List - Execute
		local function actionList_Execute()
		--actions.execute=deadly_calm
			if cast.able.deadlyCalm() then
				if cast.deadlyCalm() then debug("EXEQT Casting Deadly Calm") return end
			end
		--actions.execute+=/rend,if=remains<=duration*0.3
			if cast.able.rend() and (not debuff.rend.exists(units.dyn5) or (debuff.rend.remain(units.dyn5) < 4)) then
				if cast.rend() then debug("EXEQT Casting Rend")return end
			end
		--actions.execute+=/skullsplitter,if=rage<60&(!talent.deadly_calm.enabled|buff.deadly_calm.down)
			if cast.able.skullsplitter() and (rage < br.getOptionValue("Skullsplitter Rage") and (not talent.deadlyCalm or not buff.deadlyCalm.exists())) then
				if cast.skullsplitter() then debug("EXEQT Casting Skullsplitter") return end
			end
		--actions.execute+=/ravager,if=buff.avatar.remains<18&!dot.ravager.remains
			if cast.able.ravager() and br.useCDs() then
				if cast.ravager("target","ground") then debug("EXEQT Casting Ravager @Target") return end
			end
		--actions.execute+=/cleave,if=spell_targets.whirlwind>1&dot.deep_wounds.remains<gcd
			if talent.cleave and cast.able.cleave() and ((mode.rotation == 1 and #enemies.yards8f > 2) or (mode.rotation == 2 and #enemies.yards8f > 2)) and debuff.deepWounds.remain(units.dyn5) <= 3 then
				if cast.cleave(nil,"aoe") then debug("EXEQT Casting Cleave for DW") return end
			end
		--actions.execute+=/warbreaker
			if cast.able.warbreaker() and br.isChecked("Warbreaker") and talent.warbreaker and br.useCDs() then
				if cast.warbreaker("player","aoe",1,8) then debug("EXEQT Casting Warbreaker") return end
            end
		--actions.execute+=/colossus_smash
			if cast.able.colossusSmash() and br.isChecked("Colossus Smash") and not talent.warbreaker then
				if cast.colossusSmash("target") then debug("EXEQT Casting ColossusSmash") return end
			end 
		--actions.execute+=/condemn,if=debuff.colossus_smash.up|buff.sudden_death.react|rage>65
		-- CondemnMassacre 
			for i = 1, #enemies.yards8 do
				local thisUnit = enemies.yards8[i]
					if br.isChecked("Use Condemn") and (br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player") or (br.getHP(thisUnit) <= 35)) and talent.massacre and debuff.colossusSmash.exists(units.dyn5) or rage >= 65 then
						if cast.condemnMassacre() then debug("EXEQT Casting condemnMassacre rage65 or colsmash") return end
					end
			end
		--  Condemn on Sudden Death proc, target above 80%, or below 20% health (35% with Massacre)
			for i = 1, #enemies.yards8 do
				local thisUnit = enemies.yards8[i]
					if br.isChecked("Use Condemn") and (br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player") or (br.getHP(thisUnit) <= 20)) and not talent.massacre and debuff.colossusSmash.exists(units.dyn5) or rage >= 65 then
						if cast.condemn() then debug("EXEQT Casting condemn rage65 or colsmash") return end
					end
			end
		--actions.execute+=/overpower,if=charges=2
			if cast.able.overpower() and charges.overpower.frac() == 2 then
				if cast.overpower() then debug("EXEQT Casting Overpower 2stacks") return end
            end
		--actions.execute+=/bladestorm,if=buff.deadly_calm.down&rage<50
			if #enemies.yards8 >= br.getOptionValue("Bladestorm") and cast.able.bladestorm() and br.isChecked("Bladestorm") and (not talent.deadlyCalm or not buff.deadlyCalm.exists()) and rage <= 50 and not talent.ravager then
				if cast.bladestorm("player","aoe",1,8) then debug("EXEQT Bladestorm @Rage: ".. power) return end
			end
		--actions.execute+=/mortal_strike,if=dot.deep_wounds.remains<=gcd
			if cast.able.mortalStrike() and debuff.deepWounds.remain(units.dyn5) <= 4 then
				if cast.mortalStrike() then debug("EXEQT Casting Mortal Strike DW") return end
			end 
		--actions.execute+=/skullsplitter,if=rage<40
			if cast.able.skullsplitter() and rage < 40 then
				if cast.skullsplitter() then debug("EXEQT Casting Skullsplitter rage < 40") return end
			end
		--actions.execute+=/overpower
			if cast.able.overpower() then
				if cast.overpower() then debug("EXEQT Casting Overpower") return end
			end
		--actions.execute+=/condemn
		--  CondemnMassacre 
			for i = 1, #enemies.yards8 do
				local thisUnit = enemies.yards8[i]
					if br.isChecked("Use Condemn") and (br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player") or (br.getHP(thisUnit) <= 35)) and talent.massacre then
						if cast.condemnMassacre() then debug("EXEQT Casting condemnMassacre fallback") return end
					end
			end
		--  Condemn on Sudden Death proc, target above 80%, or below 20% health (35% with Massacre)
			for i = 1, #enemies.yards8 do
				local thisUnit = enemies.yards8[i]
					if br.isChecked("Use Condemn") and (br.getHP(thisUnit) >80 or buff.suddenDeath.exists("player") or (br.getHP(thisUnit) <= 20)) and not talent.massacre then
						if cast.condemn() then debug("EXEQT Casting condemn fallback") return end
					end
			end
		--actions.execute+=/execute
			if talent.massacre and br.getHP(units.dyn5) <= 35 or not talent.massacre and br.getHP(units.dyn5) <= 20 then
               if cast.able.execute() and (buff.suddenDeath.exists() or not buff.suddenDeath.exists()) then
                    if cast.execute() then debug("ST Casting Execute @Rage: " .. power) return end
                end
            end
		end
-----------------
--- Rotations ---
-----------------
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | pause
        if not inCombat and not hastar and br.profileStop==true then
            br.profileStop = false
        elseif (inCombat and br.profileStop==true) or br.pause() or mode.rotation==4 then
            return true
        else
            if actionList_Extra() then return end
            if actionList_Defensive() then return end
            if actionList_Movement() then return end

---------------------------------
--- Out Of Combat - Rotations ---
---------------------------------
            if not inCombat and br.isValidUnit("target") then
                if br.getDistance("target")<5 then
                    if not IsCurrentSpell(6603) then
                        br._G.StartAttack("target")
                    end
                else
            -- Action List - Movement
                    -- run_action_list,name=movement,if=movement.br.getDistance(units.dyn5)>5
                    -- if br.getDistance("target") >= 8 then
                        if actionList_Movement() then return end
                    -- end
                end
            end
-----------------------------
--- In Combat - Rotations ---
-----------------------------
            if inCombat and br.isValidUnit(units.dyn5) then
            -- Auto Attack
            --auto_attack
            -- if IsCurrentSpell(6603) and not br.GetUnitIsUnit(units.dyn5,"target") then
            --     StopAttack()
            -- else
            --     br._G.StartAttack(units.dyn5)
            -- end
            if not IsCurrentSpell(6603) then
                br._G.StartAttack(units.dyn5)
            end
            -- Action List - Movement
            -- run_action_list,name=movement,if=movement.br.getDistance(units.dyn5)>5
            -- if br.getDistance(units.dyn8) > 8 then
            if actionList_Movement() then return end
            -- end
            -- Action List - Interrupts
            if actionList_Interrupts() then return end
            -- Action List - Cooldowns
            if actionList_Cooldowns() then return end
			-- Action List - Execute
				if br.getHP(units.dyn5) <= 35 or not talent.massacre and br.getHP(units.dyn5) <= 20 or (covenant.venthyr.active and br.getHP(units.dyn5) >= 80) then
					if actionList_Execute() then return end
				end
            -- -- Action List - Multi
            --    -- run_action_list Multi
                if ((mode.rotation == 1 and #enemies.yards8 >= 2) or (mode.rotation == 2 and #enemies.yards8 > 0)) then
                    if actionList_Multi() then return end
                end
            -- -- Action List - Single
            --     -- run_action_list,name=single_target
                if ((mode.rotation == 1 and #enemies.yards8 < 2) or (mode.rotation == 3 and #enemies.yards8 > 0)) then
                    if actionList_Single() then return end
                end
        end -- End Combat Rotation
        end -- pause
    end -- End Timer
end -- runRotation
local id = 0
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
