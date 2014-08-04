function PokeEngine()
	if BadBoy_data["Check PokeRotation"] ~= 1 then return false; end
	-- pulsed
	if not PokeRotationStarted then
		PokeData();
		PokeCollections();
		PokeAbilities();
		PokeUI();
	end

	if BadBoy_data.wait == 3 then
		local abilityNumber = BadBoy_data.pokeAttack
        if abilityNumber == 1 then
    		C_PetBattles.UseAbility(1); return;
    	elseif abilityNumber == 2 then
      		C_PetBattles.UseAbility(2); return;
    	elseif abilityNumber == 3 then
        	C_PetBattles.UseAbility(3); return;
        elseif abilityNumber == 4 then
        	C_PetBattles.SkipTurn(); return;
        elseif abilityNumber == 5 then
        	C_PetBattles.ChangePet(1); return;
        elseif abilityNumber == 6 then
        	C_PetBattles.ChangePet(2); return;
        elseif abilityNumber == 7 then
        	C_PetBattles.ChangePet(3); return;
        elseif abilityNumber == 8 then
        	C_PetBattles.UseTrap(); return;
    	end
    end

	-- In Battle timer
	if inBattle then
		if inBattleTimer == 0 then 
			inBattleTimer = GetTime()
		end
	elseif inBattleTimer ~= 0 then
		ChatOverlay("\124cFF9999FFBattle Ended "..GetBattleTime().." Min. "..select(2,GetBattleTime()).." Secs.")
		inBattleTimer = 0
	end
	-- Out of Battle timer
	if not inBattle then
		if outOfBattleTimer == 0 then 
			outOfBattleTimer = GetTime()
		end
	elseif outOfBattleTimer ~= 0 then
		outOfBattleTimer = 0
	end
	--------------------------
	-- Battle States & Vars --
	--------------------------
	inBattle = C_PetBattles.IsInBattle()
	inWildBattle = C_PetBattles.IsWildBattle()
	inPvPBattle = C_PetBattles.GetTurnTimeInfo()
	--if inBattle ~= true then pokeValueFrame:Hide(); else pokeValueFrame:Show(); end
	if inBattle then
		activePetSlot = C_PetBattles.GetActivePet(1)
		CanSwapOut = C_PetBattles.CanActivePetSwapOut()
		-- Number of Abilities the actual pet is using.
		ActivePetlevel = C_PetBattles.GetLevel(1, activePetSlot)
		if ActivePetlevel >= 4 then 
			numofAbilities = 3
		elseif ActivePetlevel >= 2 then
			numofAbilities = 2
		else
			numofAbilities = 3
		end
		-- PetAbilitiesTable[1].A1
		PetAbilitiesTable = {
			-- Pet 1
			{
				A1 = C_PetBattles.GetAbilityInfo(1, 1, 1),
				A2 = C_PetBattles.GetAbilityInfo(1, 1, 2),
				A3 = C_PetBattles.GetAbilityInfo(1, 1, 3),
			},
			-- Pet 2
			{
				A1 = C_PetBattles.GetAbilityInfo(1, 2, 1),
				A2 = C_PetBattles.GetAbilityInfo(1, 2, 2),
				A3 = C_PetBattles.GetAbilityInfo(1, 2, 3),
			},
			-- Pet 3
			{
				A1 = C_PetBattles.GetAbilityInfo(1, 3, 1),
				A2 = C_PetBattles.GetAbilityInfo(1, 3, 2),
				A3 = C_PetBattles.GetAbilityInfo(1, 3, 3),
			}
		}
		AvailableAbilities = { 	PetAbilitiesTable[activePetSlot].A1, PetAbilitiesTable[activePetSlot].A2 ,PetAbilitiesTable[activePetSlot].A3 	}

		-- MY HP	
		activePetHP = (100 * C_PetBattles.GetHealth(1, activePetSlot) / C_PetBattles.GetMaxHealth(1, activePetSlot))
		
		health1 = C_PetBattles.GetHealth(1, 1)
		maxhealth1 = C_PetBattles.GetMaxHealth(1, 1)
		
		health2 = C_PetBattles.GetHealth(1, 2)
		maxhealth2 = C_PetBattles.GetMaxHealth(1, 2)
		
		health3 = C_PetBattles.GetHealth(1, 3)
		maxhealth3 = C_PetBattles.GetMaxHealth(1, 3)
		
		PetID = C_PetBattles.GetDisplayID(1, activePetSlot)
		Pet1ID = C_PetBattles.GetDisplayID(1, 1)
		Pet2ID = C_PetBattles.GetDisplayID(1, 2)
		Pet3ID = C_PetBattles.GetDisplayID(1, 3)
		ActivepetGUID, ability1, ability2, ability3, locked = C_PetJournal.GetPetLoadOutInfo(activePetSlot)
		PetPercent = floor(activePetHP)
		-- Nme HP
		NmeactivePetSlot = C_PetBattles.GetActivePet(2)
		NmeactivePetHP = (100 * C_PetBattles.GetHealth(2, NmeactivePetSlot) / C_PetBattles.GetMaxHealth(2, NmeactivePetSlot))
		NmePetID = C_PetBattles.GetDisplayID(1, NmeactivePetSlot)
		NmePetPercent = floor(NmeactivePetHP)
		-- Other vars
		usabletrap = C_PetBattles.IsTrapAvailable()
		-- My HP
		PetHP = (100 * C_PetBattles.GetHealth(1, activePetSlot) / C_PetBattles.GetMaxHealth(1, activePetSlot))
		PetExactHP = C_PetBattles.GetHealth(1, activePetSlot)
		Pet1ExactHP = C_PetBattles.GetHealth(1, 1)
		Pet2ExactHP = C_PetBattles.GetHealth(1, 2)
		Pet3ExactHP = C_PetBattles.GetHealth(1, 3)
		Pet1HP = floor((100 * health1 / maxhealth1))
		Pet2HP = floor((100 * health2 / maxhealth2))
		Pet3HP = floor((100 * health3 / maxhealth3))
		PetHPTable = { Pet1HP, Pet2HP, Pet3HP }
			
		MoyHPP = ((Pet1HP + Pet2HP + Pet3HP) / 3)
		MoyHP = floor(MoyHPP)

		-- Types
		PetType = C_PetBattles.GetPetType(1, activePetSlot)
		Pet1Type = C_PetBattles.GetPetType(1, 1)
		Pet2Type = C_PetBattles.GetPetType(1, 2)
		Pet3Type = C_PetBattles.GetPetType(1, 3)
		NmePetType = C_PetBattles.GetPetType(2, NmeactivePetSlot)	
		NmePet1Type = C_PetBattles.GetPetType(2, 1)
		NmePet2Type = C_PetBattles.GetPetType(2, 2)
		NmePet3Type = C_PetBattles.GetPetType(2, 3)
		
		-- Buffs
		numAuras = C_PetBattles.GetNumAuras(1, activePetSlot)
		numNmeAuras = C_PetBattles.GetNumAuras(2, NmeactivePetSlot)
		
		WeatherID = C_PetBattles.GetAuraInfo(0, 0, 1)
		
		-- NME HP
		NMEPetHP = (100 * C_PetBattles.GetHealth(2, enemyPetSlot) / C_PetBattles.GetMaxHealth(2, enemyPetSlot))
		
		-- Active Ennemi Pet Check
		enemyPetSlot = C_PetBattles.GetActivePet(2)
		nmePetHP = (100 * C_PetBattles.GetHealth(2, enemyPetSlot) / C_PetBattles.GetMaxHealth(2, enemyPetSlot))

		-- Modifier Check
		mypetType = C_PetBattles.GetPetType(1, activePetSlot)
		nmepetType = C_PetBattles.GetPetType(2, nmePetSlot)
	--	modifier = C_PetBattles.GetAttackModifier(mypetType, nmepetType)

		-- Speed Check
		myspeed = C_PetBattles.GetSpeed(1, activePetSlot)
		nmespeed = C_PetBattles.GetSpeed(2, NmeactivePetSlot)
		
		-- Player active pet GUID
		ActivepetGUID, ability1, ability2, ability3, locked = C_PetJournal.GetPetLoadOutInfo(activePetSlot)

	--	PQR_Event("PQR_Text" , "Pet: "..PetID.." HP: "..PetPercent.."% NmeHP:"..NmePetPercent.."%"  , nil, "0698FF")

		-----------------
		-- Revive Pets --
		-----------------

		if not inBattle and ReviveBattlePetsCheck and not HealingDone then
			local Start ,CD = GetSpellCooldown(125439)
			HealCD = floor(Start + CD - GetTime())
			HealMinuts = floor(HealCD/60)
			HealSeconds = (HealCD - (HealMinuts * 60))
			
			if MoyHP ~= nil then
				if floor(Start + CD - GetTime()) == 0 then
		  			Pet1HP = 100
					Pet2HP = 100
					Pet3HP = 100
					MoyHP = 100
					if castSpell("player",125439,true) then return; end
				end
		--		PQR_Event("PQR_Text" , "PokeRotation - "..MoyHP.."% // Heal "..HealMinuts.."m "..HealSeconds.."s" , nil, "0698FF")	
			end	
			PokeSwapper();
		end


		--[[                                       Normal Rotation                                             ]]

	--print("pulse")
		-- Rotation

		if inBattle and ObjectiveValue == 1 and BadBoy_data["Check PokeRotation"] == 1 then
			startWaiting = nil;
			rotationRun = true;
			HealingDone = nil;
			Switch();
			SimpleHealing();
			CapturePet();
			if BadBoy_data.pokeAttack == 8 then return; end
			PassTurn();
			Deflect();
			Execute();
			Kamikaze();
			LastStand();
			ShieldBuff();
			LifeExchange();
			DelayFifteenTurn();
			DelayThreeTurn();
			DelayOneTurn();
			TeamHealBuffs();
			HoTBuff();
			HighDamageIfBuffed();
			SelfBuff();
			DamageBuff();
			SpeedDeBuff();
			AoEPunch();
			ThreeTurnHighDamage();
			Turrets(1);
			SimpleHighPunch(1);
			SimplePunch(1);
			SimpleHighPunch(2);
			DeBuff();
			Soothe();
			Stun();
			TeamDebuff();
			Turrets(2);
			SpeedBuff();
			QuickPunch();
			Comeback();
			SimplePunch(2);
			Turrets(3);
			SimpleHighPunch(3);
			SimplePunch(3);
			rotationRun = false;
		end
	end

	if not inBattle then
		if startWaiting == nil then startWaiting = GetTime(); end
		if startWaiting ~= nil and startWaiting <= GetTime() - 2 then

			for i = 1, #MopList do
				if UnitExists("target") == nil then
					RunMacroText("/target "..MopList[i]);
				end
			end
			if UnitExists("target") == 1 and (spamPrevention == nil or spamPrevention <= GetTime() - 2) then spamPrevention = GetTime(); InteractUnit("target"); end
		end
	end

end
