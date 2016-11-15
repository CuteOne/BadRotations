-- Todo : Fix the spellname in UNIT_SPELL_SENT
-- Todo : Handle Mana Burst toggle

if select(3, UnitClass("player")) == 8 then

  function ArcaneMage()

    if currentConfig ~= "Arcane ragnar" then
      ArcaneMageConfig()
      ArcaneMageToggles()
      currentConfig = "Arcane ragnar"
    end

    -- Manual Input
    if IsLeftShiftKeyDown() or IsLeftAltKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
      return true

    end



    ------------
    -- Checks --
    ------------

    -- Food/Invis Check
    if canRun() ~= true then
      return false
    end

    -- Do not Interrupt "player" while GCD (61304)k
    --if getSpellCD(61304) > 0 then
    --		return false
    --	end
    ------------
    -- COMBAT --
    ------------

    -- AffectingCombat, Pause, Target, Dead/Ghost Check
    if UnitAffectingCombat("player") or not UnitAffectingCombat("player") and IsLeftControlKeyDown() then

      ------------
      -- Stats --
      ------------

      isPlayerMoving 						= isMoving("player")
      arcaneCharge 						= Charge()
      isKnownPrismaticCrystal 			= isKnown(PrismaticCrystal)
      isKnownOverPowered					= isKnown(Overpowered)
      isKnownArcaneOrb					= isKnown(ArcaneOrb)
      isKnownSupernova					= isKnown(Supernova)

      cdPristmaticCrystal 				= getSpellCD(PrismaticCrystal)
      cdArcanePower						= getSpellCD(ArcanePower)
      cdEvocation							= getSpellCD(Evocation)

      playerMana							= getMana("player")
      playerBuffArcanePower				= UnitBuffID("player",ArcanePower)
      playerBuffArcanePowerTimeLeft		= getBuffRemain("player",ArcanePower)
      playerHaste							= GetHaste()
      playerBuffArcaneMissile				= UnitBuffID("player",ArcaneMissilesP)

      targetDebuffNetherTempest 			= UnitDebuffID("target",NetherTempest, "player")
      targetDebuffNetherTempestTimeLeft	= getDebuffRemain("target",NetherTempest, "player")

      stacksArcaneMisslesP				= getBuffStacks("player",ArcaneMissilesP)



      chargesSuperNova					= GetSpellCharges(Supernova)
      reChargeSuperNova					= getRecharge(Supernova)

      castTimeArcaneBlast					 = select(4,GetSpellInfo(ArcaneBlast))/1000

      if cancelEvocation() then
        RunMacroText("/stopcasting")
      end

      if not isItOkToClipp() then
        return true
      end

      if isPlayerMoving and not UnitBuffID("player", IceFloes) then
        castIceFloes()
      end



      if br.data['Defensive'] == 2 then
        ArcaneMageDefensives()
      end


      if br.data['Cooldowns'] == 2 then
        ArcaneMageCooldowns()
      end


      -- actions+=/call_action_list,name=aoe,if=active_enemies>=5
      -- AoE
      --		if br.data['AoE'] == 2 then
      --			ArcaneMageAoESimcraft()
      --		end
      -- AutoAoE


      --# Executed every time the actor is available.
      -- Todo : Add InterruptHandler actions=counterspell,if=target.debuff.casting.react, lockjaw as well
      -- Todo : Defensive CDs actions+=/cold_snap,if=health.pct<30
      -- Todo : Implement icefloes for movement actions+=/ice_floes,if=buff.ice_floes.down&(raid_event.movement.distance>0|raid_event.movement.in<action.arcane_missiles.cast_time)
      -- Todo : Rune of Power actions+=/rune_of_power,if=buff.rune_of_power.remains<cast_time
      -- Todo : actions+=/mirror_image
      -- Todo : actions+=/cold_snap,if=buff.presence_of_mind.down&cooldown.presence_of_mind.remains>75
      -- Todo : actions+=/call_action_list,name=init_crystal,if=talent.prismatic_crystal.enabled&cooldown.prismatic_crystal.up
      -- Todo : actions+=/call_action_list,name=crystal_sequence,if=talent.prismatic_crystal.enabled&pet.prismatic_crystal.active
      --actions+=/call_action_list,name=aoe,if=active_enemies>=4

      --runeOfPower()

      if getNumEnemies("player",10) > 5 then -- This is only checking for melee
        if br.data['AoE'] == 2 or br.data['AoE'] == 3 then -- We need to sort out the auto aoe, ie == 3
          ArcaneMageAoESimcraft()
      end
      end

      --actions+=/call_action_list,name=conserve
      --print("CD Evo "  ..cdEvocation)
      --print("First : " ..(playerMana-30)*0.3*(10/playerHaste))

      if isChecked("Burn Phase") then
        -- actions+=/call_action_list,name=burn,if=time_to_die<mana.pct*0.35*spell_haste|cooldown.evocation.remains<=(mana.pct-30)*0.3*spell_haste|(buff.arcane_power.up&cooldown.evocation.remains<=(mana.pct-30)*0.4*spell_haste)
        --if (getTimeToDie("target") < playerMana*0.35*(1/playerHaste)) or (cdEvocation <= (playerMana-30)*0.3*(1/playerHaste)) or (playerBuffArcanePower and cdEvocation <= (playerMana-30)*0.4*(1/playerHaste)) then --
        if cdEvocation < 20 then
          if ArcaneMageSingleTargetSimcraftBurn() then
            --		if GabbzBurn() then
            return true
          end
        end
      end
      if ArcaneMageSingleTargetSimcraftConserve() then
        --if GabbzConserve() then
        return true
      end
    end
  end
end
