if select(3,UnitClass("player")) == 10 then

  function BrewmasterMonk()

    if currentConfig ~= "Brewmaster Chumii" then
        MonkBrewConfig();
        currentConfig = "Brewmaster Chumii";
    end
    MonkBrewToggles()
    GroupInfo();
    ------------------------------------------------------------------------------------------------------
    -- Locals --------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
	local chi = UnitPower("player", SPELL_POWER_CHI)
	local chiMax = UnitPowerMax("player", SPELL_POWER_CHI)
	local chiDif = chiMax-chi; --chi.max-chi
	local energy = getPower("player")
    local energytomax = getTimeToMax("player")
    local energyreg = getRegen("player")
	local myHP = getHP("player")
    local GCD = 1.5/(1+UnitSpellHaste("player")/100)
	local ElusiveStacks = getBuffStacks("player",_ElusiveBrewStacks)
    local dyn5 = dynamicTarget(5,true) -- Melee
    local dyn40 = dynamicTarget(40,false) -- Chi wave
    -- if myEnemiesTableTimer == nil or myEnemiesTableTimer <= GetTime() - 1 then
    --   makeEnemiesTable(10)
    --   myEnemiesTableTimer = GetTime()
    -- end
  ------------------------------------------------------------------------------------------------------
  -- Food/Invis Check ----------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if canRun() ~= true or UnitInVehicle("Player") then
        return false
    end
    if IsMounted("player") then
        return false
    end
  ------------------------------------------------------------------------------------------------------
  -- Pause ---------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
        ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
    end
  ------------------------------------------------------------------------------------------------------
  -- Spell Queue ---------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if _Queues == nil then
        _Queues = {
            [_TigersLust]      = false,
            [_LegSweep]        = false,
            [_ChargingOxWave]  = false,
            [_RingOfPeace]     = false,
        }
    end
  ------------------------------------------------------------------------------------------------------
  -- Input / Keys --------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
  	if isChecked("Dizzying Haze Key") and SpecificToggle("Dizzying Haze Key") == true then
        if not IsMouselooking() then
            CastSpellByName(GetSpellInfo(115180))
            if SpellIsTargeting() then
                CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
                SpellStopTargeting()
                return true
            end
        end
  	end
  	if isChecked("Black Ox Statue Key") and SpecificToggle("Black Ox Statue Key") == true then
        if not IsMouselooking() then
            CastSpellByName(GetSpellInfo(115315))
            if SpellIsTargeting() then
                CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
                return true
            end
        end
  	end
  ------------------------------------------------------------------------------------------------------
  -- Ress/Dispell --------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if isValidTarget("mouseover")
      and UnitIsPlayer("mouseover")
      and not UnitBuffID("player", 80169) -- Food
      and not UnitBuffID("player", 87959) -- Drink
      and UnitCastingInfo("player") == nil
      and UnitChannelInfo("player") == nil
      and not UnitIsDeadOrGhost("player")
      and not IsMounted()
      and not IsFlying() then
        -- Detox
        if isChecked("Detox") == true and canDispel("player",_Detox) then
            if castSpell("player",_Detox,true) then
                return
            end
        end
        if isChecked("Detox") == true and canDispel("mouseover",_Detox) and not UnitIsDeadOrGhost("mouseover") then
            if castSpell("mouseover",_Detox,true) then
                return
            end
        end
        -- Resuscitate
        if isChecked("Resuscitate") == true and not isInCombat("player") and UnitIsDeadOrGhost("mouseover") then
            if castSpell("mouseover",_Resuscitate,true) then
                return
            end
        end
    end
  ------------------------------------------------------------------------------------------------------
  -- Out of Combat -------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if not isInCombat("player") then
   --  	-- Legacy of the White Tiger
			-- if isChecked("Legacy of the White Tiger") == true and canCast(116781,false,false) and (lastLotWT == nil or lastLotWT <= GetTime() - 5) then
			-- 	for i = 1, #nNova do
			--   		if isPlayer(nNova[i].unit) == true and not UnitBuffID(nNova[i].unit,{115921,116781,20217,1126,90363,160017,159988,160077}) and UnitInRange(nNova[i].unit) then
			--   			if castSpell("player",116781,true) then lastLotWT = GetTime(); return; end
			-- 		end
			-- 	end
			-- end
    end -- Out of Combat end
    ------------------------------------------------------------------------------------------------------
    -- In Combat -----------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if isInCombat("player") then
    ------------------------------------------------------------------------------------------------------
    -- Dummy Test ----------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    if isChecked("DPS Testing") then
        if UnitExists(dyn5) then
            if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                StopAttack()
                ClearTarget()
                print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
            end
        end
    end
  ------------------------------------------------------------------------------------------------------
  -- Queued Spells -------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
      if _Queues[_TigersLust] == true then
        if castSpell("player",_TigersLust,false,false) then
            return
        end
    end
    if _Queues[_LegSweep] == true then
        if castSpell("player",_LegSweep,false,false) then
            return
        end
    end
    if _Queues[_ChargingOxWave] == true then
        if castSpell("player",_ChargingOxWave,false,false) then
            return
        end
    end
    if _Queues[_RingOfPeace] == true then
        if castSpell("player",_RingOfPeace,false,false) then
            return
        end
    end
    -- Zen Medidation Pause ------------------------------------------------------------------------------
    if select(1,UnitChannelInfo("player")) == "Zen Meditation" then
        return false
    end
  ------------------------------------------------------------------------------------------------------
  -- Defensive Cooldowns -------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if useDefCDsBrM() == true then
      	--Expel Harm
      	if isChecked("Expel Harm") then
      		if getHP("player") <= getValue("Expel Harm") then
      			if castSpell("player",_ExpelHarm,true,false) then
      				return
      			end
      		end
      	end
      	--Fortifying Brew
      	if isChecked("Fortifying Brew") then
      		if getHP("player") <= getValue("Fortifying Brew") then
      			if castSpell("player",_FortifyingBrew,true,false) then
      				return
      			end
      		end
      	end
      	--Healthstone
      	if isChecked("Healthstone") then
      		if getHP("player") <= getValue("Healthstone") then
      			if canUse(5512) then
                    UseItemByName(tostring(select(1,GetItemInfo(5512))))
                end
      		end
      	end
        --Diffuse Magic
        if isChecked("Diffuse Magic") then
            if getHP("player") <= getValue("Diffuse Magic") then
                if castSpell("player",_DiffuseMagic,true,false) then
                    return
                end
            end
        end
        --Dampen Harm
        if isChecked("Dampen Harm") then
            if getHP("player") <= getValue("Dampen Harm") then
                if castSpell("player",_DampenHarm,true,false) then
                    return
                end
            end
        end
    end -- isChecked("Defensive Mode") end
  ------------------------------------------------------------------------------------------------------
  -- Offensive Cooldowns -------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if useCDsBrM() == true then
      	--Xuen
      	if isChecked("Invoke Xuen") then
    		if castSpell(dyn5,_InvokeXuen,false,false) then
    			return
    		end
      	end
    end -- useCDs() end
    ------------------------------------------------------------------------------------------------------
    -- Do everytime --------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------
    --Purifying Brew
    if DrinkStagger() then
        if castSpell("player",_PurifyingBrew,true,false) then
            return
        end
    end
    -- Nimble Brew
    if hasNoControl() then
        if castSpell("player",_NimbleBrew,true,false) then
            return
        elseif castSpell("player",_TigersLust,true,false) then
            return
        end
    end
    -- actions+=/chi_brew,if=talent.chi_brew.enabled&chi.max-chi>=2&buff.elusive_brew_stacks.stack<=10
    if isKnown(_ChiBrew) then
        if chiDif >= 2 and ElusiveStacks <= 10 then
            if castSpell("player",_ChiBrew,true,false) then
                return
            end
        end
    end
    -- actions+=/elusive_brew,if=buff.elusive_brew_stacks.react>=9&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down
    --and (not UnitBuffID("player",_DampenHarm) or not UnitBuffID("player",_DiffuseMagic))
    if ElusiveStacks >= 9 and not UnitBuff("player",115308) then
        if castSpell("player",_ElusiveBrew,true,false) then
          return
        end
      end
      -- actions+=/serenity,if=talent.serenity.enabled&energy<=40
      if isKnown(_Serenity) then
        if energy <= 40 then
          if castSpell("player",_Serenity,true) then
            return
          end
        end
      end
  ------------------------------------------------------------------------------------------------------
  -- Interrupts ----------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
      -- if #enemiesTable >= 3 then
      --   print(#enemiesTable)
      -- end
  ------------------------------------------------------------------------------------------------------
  -- Rotation ------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
      if not useAoEBrM() then
        -- actions.st=blackout_kick,if=buff.shuffle.down
        if not UnitBuffID("player",_Shuffle) then
          if castSpell(dyn5,_BlackoutKick,false,false) then
            return
          end
        end
        -- actions.st+=/purifying_brew,if=!talent.chi_explosion.enabled&stagger.heavy
        -- actions.st+=/purifying_brew,if=buff.serenity.up
        if UnitBuffID("player",_Serenity)
        and UnitBuffID("player",_StaggerLight)
        or UnitBuffID("player",_StaggerModerate)
        or UnitBuffID("player",_StaggerHeavy) then
          if castSpell("player",_PurifyingBrew,true) then
            return
          end
        end
        -- actions.st+=/guard
        if useDefCDsBrM() == true then
          if isChecked("Guard on CD") and not UnitBuffID("player",_Guard) then
            if castSpell("player",_Guard,true) then
              return
            end
          end
        end
        -- actions.st+=/keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
        --if chiDif >= 2 and not UnitBuffID("player",_Serenity) then
        if not UnitBuffID("player",_Serenity) then
          if castSpell(dyn5,_KegSmash,false,false) then
            return
          end
        end
        -- actions.st+=/chi_burst,if=talent.chi_burst.enabled&energy.time_to_max>3
        if isKnown(_ChiBurst) then
          if energytomax > 3 then
            if castSpell("player",_ChiBurst,true) then
              return
            end
          end
        end
        -- actions.st+=/chi_wave,if=talent.chi_wave.enabled&energy.time_to_max>3
        if isKnown(_ChiWave) then
          if energytomax > 3 then
            if castSpell("player",_ChiWave,true) then
              return
            end
          end
        end
        -- actions.st+=/zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&!dot.zen_sphere.ticking
        if isKnown(_ZenSphere) then
          if not UnitBuffID("player",_ZenSphere) then
            if castSpell("player",_ZenSphere,true) then
              return
            end
          end
          if not UnitBuffID("focus",_ZenSphere) then
            if castSpell("focus",_ZenSphere,true) then
              return
            end
          end
        end
        -- chi explosion
        -- actions.st+=/chi_explosion,if=chi>=3
        if chi >= 3 then
          if castSpell(dyn5,_ChiExplosion,false,false) then
            print("Chi Explosion at 3 Chi")
            return
          end
        end
        -- actions.st+=/blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
        if getBuffRemain("player",_Shuffle) <= 3 then
          if castSpell(dyn5,_BlackoutKick,false,false) then
            return
          end
        end
        -- actions.st+=/blackout_kick,if=buff.serenity.up
        if UnitBuffID("player",_Serenity) then
          if castSpell(dyn5,_BlackoutKick,false,false) then
            return
          end
        end
        -- actions.st+=/blackout_kick,if=chi>=4
        if chi >= 4 then
          if castSpell(dyn5,_BlackoutKick,false,false) then
            return
          end
        end
        -- actions.st+=/expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd
        -- if chiDif >= 1 and getSpellCD(_KegSmash) >= GCD then
        --   if castSpell("player",_ExpelHarm,true) then
        --     return
        --   end
        -- end
        -- actions.st+=/jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd
        if chiDif >= 1 then
          if castSpell(dyn5,_Jab,false,false) then
            return
          end
        end
        -- actions.st+=/purifying_brew,if=!talent.chi_explosion.enabled&stagger.moderate&buff.shuffle.remains>=6

        -- actions.st+=/tiger_palm,if=(energy+(energy.regen*(cooldown.keg_smash.remains)))>=40
        --if (energy+(energyreg*getSpellCD(_KegSmash))) >= 40 then
          if castSpell(dyn5,_TigerPalm,false,false) then
            return
          end
        --end
        -- actions.st+=/tiger_palm,if=cooldown.keg_smash.remains>=gcd
        -- if getSpellCD(_KegSmash) >= GCD then
        --   if castSpell(dyn5,_TigerPalm,false,false) then
        --     return
        --   end
        -- end
      end --single end
  -- AoE -----------------------------------------------------------------------------------------------
      if useAoEBrM() then
        -- actions.aoe=guard
        if useDefCDsBrM() == true then
          if isChecked("Guard") and not UnitBuffID("player",_Guard) then
            if castSpell("player",_Guard,true) then
              return
            end
          end
        end
        -- actions.aoe+=/breath_of_fire,if=chi>=3&buff.shuffle.remains>=6&dot.breath_of_fire.remains<=gcd
        if chi >= 3 and getBuffRemain("player",_Shuffle) >= 6 and getDebuffRemain(dyn5,_BreathOfFire) <= 1.5 then
          if castSpell(dyn5,_BreathOfFire,false,false) then
            return
          end
        end
        -- actions.aoe+=/chi_explosion,if=chi>=4
        if chi >= 4 then
          if castSpell(dyn5,_ChiExplosion,false,false) then
            print("Chi Explosion at 4 Chi")
            return
          end
        end
        -- actions.aoe+=/rushing_jade_wind,if=chi.max-chi>=1&talent.rushing_jade_wind.enabled
        if isKnown(_RushingJadeWind) then
          if chiDif >= 1 then
            if castSpell("player",_RushingJadeWind,true) then
              return
            end
          end
        end
        -- actions.aoe+=/purifying_brew,if=!talent.chi_explosion.enabled&stagger.heavy
        -- actions.aoe+=/guard
        if useDefCDsBrM() == true then
          if isChecked("Guard") and not UnitBuffID("player",_Guard) then
            if castSpell("player",_Guard,true) then
              return
            end
          end
        end
        -- actions.aoe+=/keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
        --if chiDif >= 2 and not UnitBuffID("player",_Serenity) then
        if not UnitBuffID("player",_Serenity) then
          if castSpell(dyn5,_KegSmash,false,false) then
            return
          end
        end
        -- actions.aoe+=/chi_burst,if=talent.chi_burst.enabled&energy.time_to_max>3
        if isKnown(_ChiBurst) then
          if energytomax > 3 then
            if castSpell("player",_ChiBurst,true) then
              return
            end
          end
        end
        -- actions.aoe+=/chi_wave,if=talent.chi_wave.enabled&energy.time_to_max>3
        if isKnown(_ChiWave) then
          if energytomax > 3 then
            if castSpell("player",_ChiWave,true) then
              return
            end
          end
        end
        -- actions.aoe+=/zen_sphere,cycle_targets=1,if=talent.zen_sphere.enabled&!dot.zen_sphere.ticking
        if isKnown(_ZenSphere) then
          if not UnitBuffID("player",_ZenSphere) then
            if castSpell("player",_ZenSphere,true) then
              return
            end
          end
          if not UnitBuffID("focus",_ZenSphere) then
            if castSpell("focus",_ZenSphere,true) then
              return
            end
          end
        end
        -- actions.aoe+=/blackout_kick,if=talent.rushing_jade_wind.enabled&buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
        if isKnown(_RushingJadeWind) then
          if getBuffRemain("player",_Shuffle) <= 3 then
            if castSpell(dyn5,_BlackoutKick,false,false) then
              return
            end
          end
        end
        -- actions.aoe+=/blackout_kick,if=talent.rushing_jade_wind.enabled&buff.serenity.up
        if isKnown(_RushingJadeWind) then
          if UnitBuffID("player",_Serenity) then
            if castSpell(dyn5,_BlackoutKick,false,false) then
              return
            end
          end
        end
        -- actions.aoe+=/blackout_kick,if=talent.rushing_jade_wind.enabled&chi>=4
        if isKnown(_RushingJadeWind) then
          if chi >= 4 then
            if castSpell(dyn5,_BlackoutKick,false,false) then
              return
            end
          end
        end
        -- actions.aoe+=/expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=40
        -- if chiDif >= 1 and getSpellCD(_KegSmash) >= 2 then
        --   if castSpell("player",_ExpelHarm,true) then
        --     return
        --   end
        -- end
        -- actions.aoe+=/spinning_crane_kick,if=chi.max-chi>=1&!talent.rushing_jade_wind.enabled
        if not isKnown(_RushingJadeWind) then
          if chiDif >= 1 then
            if castSpell(dyn5,_RushingCraneKick,false,false) then
              return
            end
          end
        end
        -- actions.aoe+=/jab,if=talent.rushing_jade_wind.enabled&chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd
        if isKnown(_RushingJadeWind) then
          if chiDif >= 1 then
            if castSpell(dyn5,_Jab,false,false) then
              return
            end
          end
        end
        -- actions.aoe+=/tiger_palm,if=talent.rushing_jade_wind.enabled&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=40
        if isKnown(_RushingJadeWind) then
          --if (energy+(energyreg*getSpellCD(_KegSmash))) >= 40 then
            if castSpell(dyn5,_TigerPalm,false,false) then
              return
            end
          --end
        end
        -- actions.aoe+=/tiger_palm,if=talent.rushing_jade_wind.enabled&cooldown.keg_smash.remains>=gcd
        -- if isKnown(_RushingJadeWind) then
        --   if getSpellCD(_KegSmash) >= GCD then
        --     if castSpell(dyn5,_TigerPalm,false,false) then
        --       return
        --     end
        --   end
        -- end
      end --aoe end
    end -- In Combat end
  end -- Spec end
end -- Class Check end