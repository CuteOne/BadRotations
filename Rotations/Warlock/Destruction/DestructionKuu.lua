if select(2, UnitClass("player")) == "WARLOCK" then
    function cDestruction:DestructionKuu()
    
       DestructionToggles()
		local inCombat          = self.inCombat        
    --------------------
    --- Action Lists ---
    --------------------
    -- Action List - Extras
        function actionList_Extras()
        -- Dark Intent
            if isChecked("Dark Intent") then
                if self.castDarkIntent() then return end
            end
        -- Dummy Test
            if isChecked("DPS Testing") then
                if ObjectExists("target") then
                    if combatTime >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        StopAttack()
                        ClearTarget()
                        print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                    end
                end
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        function actionList_Defensive()
            if useDefensive() then
        -- Pot/Stoned
                if isChecked("Pot/Stoned") and getHP("player") <= getValue("Pot/Stoned") and inCombat then
                    if canUse(5512) then
                        useItem(5512)
                    elseif canUse(healthPot) then
                        useItem(healthPot)
                    end
                end
        -- Heirloom Neck
                if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
            end -- End Defensive Check
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
            if useInterrupts() then
            end -- End Interrupt Check
        end -- End Action List - Interrupts
    -- Action List - Pre-Combat
        function actionList_PreCombat()
            if not inCombat then
            end -- End No Combat Check
        end --End Action List - Pre-Combat
    -- Action list - Opener
        function actionList_Opener()
        end -- End Action List - Opener
    -- Action List - Single Target
        function actionList_SingleTarget()
        	-- Immolate
        	for i=1, #getEnemies("player",40) do
    	        if not self.debuff.immolate then
    	        	local thisUnit = getEnemies("player",40)[i]
    	        	local hasThreat = hasThreat(thisUnit)
    	        	if hasThreat then
        	        	if self.castImmolate(thisUnit) then return end
        	        end
            	end
	        end
	        -- Chaos Bolt
	        if self.castChaosBolt(self.units.dyn40) then return end
	        -- Incinerate
        	if self.castIncinerate(self.units.dyn40) then return end
        end -- End Action List - Single Target
    
---------------------
--- Begin Profile ---
---------------------
    -- Pause
    --    if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) then
--            return true
  --      else
--------------
--- Extras ---
--------------
    -- Run Action List - Extras
            if actionList_Extras() then return end
-----------------
--- Defensive ---
-----------------
    -- Run Action List - Defensive
                if actionList_Defensive() then return end
------------------
--- Pre-Combat ---
------------------
    -- Run Action List - Pre-Combat
                if not inCombat and ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                    if actionList_PreCombat() then return end
                end
-----------------
--- In Combat ---
-----------------
                if inCombat then
    ------------------
    --- Interrupts ---
    ------------------
    -- Run Action List - Interrupts
                    if actionList_Interrupts() then return end
    ----------------------
    --- Start Rotation ---
    ----------------------
    -- Call Action List - Opener
                  
                    if actionList_Opener() then return end
    -- Call Action List - Single Target
                  
                    if actionList_SingleTarget() then return end
                end -- End Combat Check 
--        end -- End Pause
    end -- End Rotation Function
end -- End Class Check

--[[]
# This default action priority list is automatically created based on your character.
# It is a attempt to provide you with a action list that is both simple and practicable,
# while resulting in a meaningful and good simulation. It may not result in the absolutely highest possible dps.
# Feel free to edit, adapt and improve it to your own needs.
# SimulationCraft is always looking for updates and improvements to the default action lists.

# Executed before combat begins. Accepts non-harmful actions only.

actions.precombat=flask,type=warm_sun
actions.precombat+=/food,type=mogu_fish_stew
actions.precombat+=/dark_intent,if=!aura.spell_power_multiplier.up
actions.precombat+=/summon_pet,if=!talent.demonic_servitude.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.grimoire_of_sacrifice.down)
actions.precombat+=/summon_doomguard,if=talent.demonic_servitude.enabled&active_enemies<9
actions.precombat+=/summon_infernal,if=talent.demonic_servitude.enabled&active_enemies>=9
actions.precombat+=/snapshot_stats
actions.precombat+=/grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled&!talent.demonic_servitude.enabled
actions.precombat+=/potion,name=jade_serpent
actions.precombat+=/incinerate

# Executed every time the actor is available.

actions=summon_doomguard,if=!talent.demonic_servitude.enabled&spell_targets.infernal_awakening<9
actions+=/summon_infernal,if=!talent.demonic_servitude.enabled&spell_targets.infernal_awakening>=9
actions+=/berserking
actions+=/blood_fury
actions+=/arcane_torrent
actions+=/mannoroths_fury
actions+=/service_pet,if=talent.grimoire_of_service.enabled&(target.time_to_die>120|target.time_to_die<=25|(buff.dark_soul.remains&target.health.pct<20))
actions+=/dark_soul,if=!talent.archimondes_darkness.enabled|(talent.archimondes_darkness.enabled&(charges=2|target.time_to_die<40|trinket.proc.any.react|trinket.stacking_proc.any.react))
actions+=/run_action_list,name=single_target,if=spell_targets.fire_and_brimstone<6&(!talent.charred_remains.enabled|spell_targets.rain_of_fire<4)
actions+=/run_action_list,name=aoe,if=spell_targets.fire_and_brimstone>=6|(talent.charred_remains.enabled&spell_targets.rain_of_fire>=4)

actions.single_target=havoc,if=raid_event.adds.exists
actions.single_target+=/havoc,target=2,if=!raid_event.adds.exists
actions.single_target+=/shadowburn,cycle_targets=1,if=raid_event.adds.exists&sim.target!=target&talent.charred_remains.enabled&target.time_to_die<10
actions.single_target+=/shadowburn,if=talent.charred_remains.enabled&target.time_to_die<10
actions.single_target+=/kiljaedens_cunning,if=(talent.cataclysm.enabled&!cooldown.cataclysm.remains)
actions.single_target+=/kiljaedens_cunning,moving=1,if=!talent.cataclysm.enabled
actions.single_target+=/cataclysm,if=spell_targets.cataclysm>1
actions.single_target+=/fire_and_brimstone,if=buff.fire_and_brimstone.down&dot.immolate.remains<=action.immolate.cast_time&(cooldown.cataclysm.remains>action.immolate.cast_time|!talent.cataclysm.enabled)&spell_targets.fire_and_brimstone>4
actions.single_target+=/immolate,cycle_targets=1,if=(sim.target=target|!buff.havoc.remains|!raid_event.adds.exists)&remains<=cast_time&(cooldown.cataclysm.remains>cast_time|!talent.cataclysm.enabled)
actions.single_target+=/cancel_buff,name=fire_and_brimstone,if=buff.fire_and_brimstone.up&dot.immolate.remains-action.immolate.cast_time>(dot.immolate.duration*0.3)
actions.single_target+=/shadowburn,cycle_targets=1,if=raid_event.adds.exists&sim.target!=target&buff.havoc.remains
actions.single_target+=/chaos_bolt,cycle_targets=1,if=raid_event.adds.exists&sim.target!=target&buff.havoc.remains>cast_time&buff.havoc.stack>=3&target.time_to_die>=12
actions.single_target+=/shadowburn,if=!raid_event.adds.exists&buff.havoc.remains
actions.single_target+=/chaos_bolt,if=!raid_event.adds.exists&buff.havoc.remains>cast_time&buff.havoc.stack>=3
actions.single_target+=/conflagrate,cycle_targets=1,if=raid_event.adds.exists&sim.target!=target&buff.havoc.remains<=gcd*3&charges=2
actions.single_target+=/conflagrate,if=charges=2
actions.single_target+=/cataclysm
actions.single_target+=/rain_of_fire,if=remains<=tick_time&(spell_targets.rain_of_fire>4|(buff.mannoroths_fury.up&spell_targets.rain_of_fire>2))
actions.single_target+=/chaos_bolt,if=talent.charred_remains.enabled&spell_targets.fire_and_brimstone>1&target.health.pct>20
actions.single_target+=/chaos_bolt,if=talent.charred_remains.enabled&buff.backdraft.stack<3&burning_ember>=2.5
actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&(burning_ember>=3.5|buff.dark_soul.up|target.time_to_die<20)
actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&set_bonus.tier17_2pc=1&burning_ember>=2.5
actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&buff.archmages_greater_incandescence_int.react&buff.archmages_greater_incandescence_int.remains>cast_time
actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&trinket.proc.intellect.react&trinket.proc.intellect.remains>cast_time
actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&trinket.proc.crit.react&trinket.proc.crit.remains>cast_time
actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&trinket.stacking_proc.multistrike.react>=8&trinket.stacking_proc.multistrike.remains>=cast_time
actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&trinket.proc.multistrike.react&trinket.proc.multistrike.remains>cast_time
actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&trinket.proc.versatility.react&trinket.proc.versatility.remains>cast_time
actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&trinket.proc.mastery.react&trinket.proc.mastery.remains>cast_time
actions.single_target+=/fire_and_brimstone,if=buff.fire_and_brimstone.down&dot.immolate.remains-action.immolate.cast_time<=(dot.immolate.duration*0.3)&spell_targets.fire_and_brimstone>4
actions.single_target+=/immolate,cycle_targets=1,if=(sim.target=target|!buff.havoc.remains|!raid_event.adds.exists)&remains-cast_time<=(duration*0.3)
actions.single_target+=/conflagrate,cycle_targets=1,if=raid_event.adds.exists&sim.target!=target&buff.havoc.remains<=gcd*3&buff.backdraft.stack=0
actions.single_target+=/conflagrate,if=buff.backdraft.stack=0
actions.single_target+=/incinerate,cycle_targets=1,if=raid_event.adds.exists&sim.target!=target&buff.havoc.remains<=action.incinerate.cast_time*3
actions.single_target+=/incinerate

actions.aoe=rain_of_fire,if=!talent.charred_remains.enabled&remains<=tick_time
actions.aoe+=/havoc,target=2,if=!talent.charred_remains.enabled&buff.fire_and_brimstone.down
actions.aoe+=/shadowburn,if=!talent.charred_remains.enabled&buff.havoc.remains
actions.aoe+=/chaos_bolt,if=!talent.charred_remains.enabled&buff.havoc.remains>cast_time&buff.havoc.stack>=3
actions.aoe+=/kiljaedens_cunning,if=(talent.cataclysm.enabled&!cooldown.cataclysm.remains)
actions.aoe+=/kiljaedens_cunning,moving=1,if=!talent.cataclysm.enabled
actions.aoe+=/cataclysm
actions.aoe+=/fire_and_brimstone,if=buff.fire_and_brimstone.down
actions.aoe+=/immolate,if=buff.fire_and_brimstone.up&!dot.immolate.ticking&(burning_ember>=2|!talent.charred_remains.enabled)
actions.aoe+=/conflagrate,if=buff.fire_and_brimstone.up&charges=2&(burning_ember>=2|!talent.charred_remains.enabled)
actions.aoe+=/immolate,if=buff.fire_and_brimstone.up&dot.immolate.remains-action.immolate.cast_time<=(dot.immolate.duration*0.3)&(burning_ember>=2|!talent.charred_remains.enabled)
actions.aoe+=/chaos_bolt,if=talent.charred_remains.enabled&buff.fire_and_brimstone.up&burning_ember>=3
actions.aoe+=/incinerate

default_pet=felhunter
--]]

