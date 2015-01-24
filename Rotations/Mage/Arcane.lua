-- Todo : How will we implement Ice Floes? 3 Charges, 20 sec recharge. If we are moving then cast if we should have critical spell
		--if isKnown(IceFloes) then
		--		if isMoving("player") then
		--			if castSpell("player",IceFloes,true,false) then
		--				return true
		--			end
		--		end
		--	end
-- Todo : Fix the spellname in UNIT_SPELL_SENT

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
		
		-------------------
		-- Rune Of Power --
		-------------------
		if BadBoy_data["Rune"] == 1 and getOptionCheck("Start/Stop BadBoy") then
			--[[ begin Rune Stuff ]]					-- add rune of power toggle!!!!!!!!!!!!!!!!!!!!!!!!!!!!

			--AoESpell, AoESpellTarget= nil, nil;
			if AoESpell == RuneOfPower then
				AoESpellTarget = "player"
			else
				AoESpellTarget = nil
			end
			if IsAoEPending() and AoESpellTarget ~= nil then
				local X, Y, Z = ObjectPosition("player")
				CastAtPosition(X,Y,Z)
				SpellStopTargeting()
				return true
			end


			--[[rune_of_power,if=talent.rune_of_power.enabled&(buff.rune_of_power.remains<cast_time&buff.alter_time.down)]]
			if isKnown(RuneOfPower) then
				if not UnitBuffID("player",RuneOfPower) and isStanding(0.5) then
					if runeTimer == nil or runeTimer <= GetTime() - 3 then
						AoESpell = RuneOfPower
						runeTimer = GetTime()
						CastSpellByName(GetSpellInfo(RuneOfPower),nil)
						return true
					end
				end
			end

			--[[ end Rune Stuff ]]
		end


		------------
		-- Checks --
		------------

		-- Food/Invis Check
		if canRun() ~= true then
			return false
		end

		-- Pause
		if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
			ChatOverlay("|cffFF0000BadBoy Paused", 0)
			return true
		end

		-- Do not Interrupt "player" while GCD (61304)k
		if getSpellCD(61304) > 0 then
			return false
		end

		---- Arcane Brilliance
		--if isChecked("Arcane Brilliance") then
		--	if not UnitExists("mouseover") then
			-- if isChecked("Arcane Brilliance") == true and not UnitExists("mouseover") then
		--		GroupInfo()
		--		for i = 1, #members do --members
		--			if not isBuffed(members[i].Unit,{1459}) and (#nNova==select(5,GetInstanceInfo()) or select(2,IsInInstance())=="none") then
		--				if castSpell("player",ArcaneBrilliance,false,false) then
		--					return;
		--				end
		--			end
		--		end
		--	end
		--end

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

			
	--		if BadBoy_data['Defensive'] == 2 then
	--			ArcaneMageDefensives()
	--		end


	--		if BadBoy_data['Cooldowns'] == 2 then
	--			ArcaneMageCooldowns()
	--		end

			-- actions+=/call_action_list,name=aoe,if=active_enemies>=5
			-- AoE
	--		if BadBoy_data['AoE'] == 2 then
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
			if getNumEnemies("player",10) > 4 then -- This is only checking for melee
				if BadBoy_data['AoE'] == 2 or BadBoy_data['AoE'] == 3 then -- We need to sort out the auto aoe, ie == 3 
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