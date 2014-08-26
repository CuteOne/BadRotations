function PokeEngine()
	if BadBoy_data["Check PokeRotation"] ~= 1 then return false; end
	-- pulsed
	if not PokeRotationStarted then
		PokeData();
		PokeCollections();
		PokeAbilities();
		PokeUI();
		PokeRotationStarted = true;
	end

	--------------------------
	-- Battle States & Vars --
	--------------------------
	inBattle = C_PetBattles.IsInBattle()
	inWildBattle = C_PetBattles.IsWildBattle()
	inPvPBattle = C_PetBattles.GetTurnTimeInfo()
	pokeTimers();

	-----------------
	-- Revive Pets --
	-----------------
	if not inBattle then
		PetSwapper();
		if startWaiting == nil then startWaiting = GetTime(); end
		if startWaiting ~= nil and startWaiting <= GetTime() - 2 then
			for i = 1, #MopList do
				if UnitExists("target") == nil then
					RunMacroText("/target "..MopList[i]);
				end
			end
			if UnitExists("target") == 1 and (spamPrevention == nil or spamPrevention <= GetTime() - 2) then spamPrevention = GetTime(); InteractUnit("target"); end
		end
		if isChecked("Revive Battle Pets") then
			if getSpellCD(125439) == 0 then
				if castSpell("player",125439,true) then return; end
			end
			ChatOverlay("Healed pets ")
		end
	end

	if inBattle then
		startWaiting = nil;
		--[[Pets Tables]]
		myPets = {
			{
				petID = C_PetBattles.GetDisplayID(1, 1),
				petType = C_PetBattles.GetPetType(1, 1),
				health = math.floor((100 * C_PetBattles.GetHealth(1, 1) / C_PetBattles.GetMaxHealth(1, 1))),
				hp = C_PetBattles.GetHealth(1, 1),
				maxhp = C_PetBattles.GetMaxHealth(1, 1),
				a1 = C_PetBattles.GetAbilityInfo(1, 1, 1),
				a2 = C_PetBattles.GetAbilityInfo(1, 1, 2),
				a3 = C_PetBattles.GetAbilityInfo(1, 1, 3),
			},
			{
				petID = C_PetBattles.GetDisplayID(1, 2) or 0,
				petType = C_PetBattles.GetPetType(1, 2) or 0,
				health = math.floor((100 * C_PetBattles.GetHealth(1, 2) / C_PetBattles.GetMaxHealth(1, 2))) or 0,
				hp = C_PetBattles.GetHealth(1, 2) or 0,
				maxhp = C_PetBattles.GetMaxHealth(1, 2) or 0,
				a1 = C_PetBattles.GetAbilityInfo(1, 2, 1) or 0,
				a2 = C_PetBattles.GetAbilityInfo(1, 2, 2) or 0,
				a3 = C_PetBattles.GetAbilityInfo(1, 2, 3) or 0,
			},
			{
				petID = C_PetBattles.GetDisplayID(1, 3) or 0,
				petType = C_PetBattles.GetPetType(1, 3) or 0,
				health = math.floor((100 * C_PetBattles.GetHealth(1, 3) / C_PetBattles.GetMaxHealth(1, 3))) or 0,
				hp = C_PetBattles.GetHealth(1, 3) or 0,
				maxhp = C_PetBattles.GetMaxHealth(1, 3) or 0,
				a1 = C_PetBattles.GetAbilityInfo(1, 3, 1) or 0,
				a2 = C_PetBattles.GetAbilityInfo(1, 3, 2) or 0,
				a3 = C_PetBattles.GetAbilityInfo(1, 3, 3) or 0,
			}
		};
		nmePets = {
			{
				petID = C_PetBattles.GetDisplayID(2, 1),
				petType = C_PetBattles.GetPetType(2, 1),
				health = math.floor((100 * C_PetBattles.GetHealth(2, 1) / C_PetBattles.GetMaxHealth(2, 1))),
				hp = C_PetBattles.GetHealth(2, 1),
				maxhp = C_PetBattles.GetMaxHealth(2, 1),
				a1 = C_PetBattles.GetAbilityInfo(2, 1, 1),
				a2 = C_PetBattles.GetAbilityInfo(2, 1, 2),
				a3 = C_PetBattles.GetAbilityInfo(2, 1, 3),
			},
			{
				petID = C_PetBattles.GetDisplayID(2, 2) or 0,
				petType = C_PetBattles.GetPetType(2, 2) or 0,
				health = math.floor((100 * C_PetBattles.GetHealth(2, 2) / C_PetBattles.GetMaxHealth(2, 2))) or 0,
				hp = C_PetBattles.GetHealth(2, 2) or 0,
				maxhp = C_PetBattles.GetMaxHealth(2, 2) or 0,
				a1 = C_PetBattles.GetAbilityInfo(2, 2, 1) or 0,
				a2 = C_PetBattles.GetAbilityInfo(2, 2, 2) or 0,
				a3 = C_PetBattles.GetAbilityInfo(2, 2, 3) or 0,
			},
			{
				petID = C_PetBattles.GetDisplayID(2, 3) or 0,
				petType = C_PetBattles.GetPetType(2, 3) or 0,
				health = math.floor((100 * C_PetBattles.GetHealth(2, 3) / C_PetBattles.GetMaxHealth(2, 3))) or 0,
				hp = C_PetBattles.GetHealth(1, 3) or 0,
				maxhp = C_PetBattles.GetMaxHealth(2, 3) or 0,
				a1 = C_PetBattles.GetAbilityInfo(2, 3, 1) or 0,
				a2 = C_PetBattles.GetAbilityInfo(2, 3, 2) or 0,
				a3 = C_PetBattles.GetAbilityInfo(2, 3, 3) or 0,
			}
		};

		--[[Active Pet Slots]]
		myPetSlot = C_PetBattles.GetActivePet(1);
		nmePetSlot = C_PetBattles.GetActivePet(2);

		--[[Can]]
		canSwapOut = C_PetBattles.CanActivePetSwapOut();
		canTrap = C_PetBattles.IsTrapAvailable();

		--[[Get]]
		petGUID, ability1, ability2, ability3, locked = C_PetJournal.GetPetLoadOutInfo(myPetSlot);
		getAverageHP = (myPets[1].health + myPets[2].health + myPets[3].health) / 3;		-- Buffs
		getAuras = C_PetBattles.GetNumAuras(1, myPetSlot);
		getNmeAuras = C_PetBattles.GetNumAuras(2, nmePetSlot);
		getWeather = C_PetBattles.GetAuraInfo(0, 0, 1);
		getSpeed = C_PetBattles.GetSpeed(1, myPetSlot);
		getNmeSpeed = C_PetBattles.GetSpeed(2, nmePetSlot);

		--[[Number of Abilities the actual pet is using.]]
		myPetLevel = C_PetBattles.GetLevel(1, myPetSlot)
		if myPetLevel >= 4 then numOfAbilities = 3 elseif myPetLevel >= 2 then numOfAbilities = 2 else numOfAbilities = 1 end


		PetSwapper();

		--[[                                       Normal Rotation                                             ]]

		if inBattle and BadBoy_data["Check PokeRotation"] == 1 then
			
			Switch();
			PassTurn();
			SimpleHealing();
			CapturePet();
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
end
