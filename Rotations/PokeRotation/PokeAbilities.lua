function PokeAbilities()
	--[[                                       Functions                                             ]]

	if not PetFunctions then
		PetFunctions = true
		
		-- AbilitySpam(Ability) - Cast this single ability with checks.	
		AbilitySpam = nil
		function AbilitySpam(Ability)
			if rotationRun == true then
				if PetAbilitiesTable[activePetSlot].A1 == Ability and C_PetBattles.GetAbilityState(1, activePetSlot, 1) == true then
					--pokeValueFrame.valueText:SetText("1", 1, 1, 1, 0.7);
					BadBoy_data.pokeAttack = 1
					BadBoy_data.wait = 0
					rotationRun = false		   
				end
				if PetAbilitiesTable[activePetSlot].A2 == Ability and C_PetBattles.GetAbilityState(1, activePetSlot, 2) == true then
					--pokeValueFrame.valueText:SetText("2", 1, 1, 1, 0.7);
					BadBoy_data.pokeAttack = 2
					BadBoy_data.wait = 0
					rotationRun = false
				end
				if PetAbilitiesTable[activePetSlot].A3 == Ability and C_PetBattles.GetAbilityState(1, activePetSlot, 3) == true then
					--pokeValueFrame.valueText:SetText("3", 1, 1, 1, 0.7);
					BadBoy_data.pokeAttack = 3
					BadBoy_data.wait = 0
					rotationRun = false
				end
			end
		end	
					
		-- Call to check ability vs enemy pet type.
		function AbilityTest(Poke_Ability)
			if TypeWeaknessTable[select(7,C_PetBattles.GetAbilityInfoByID(Poke_Ability))].Strong == NmePetType then IsStrongAbility = true else IsStrongAbility = false end
			if TypeWeaknessTable[select(7,C_PetBattles.GetAbilityInfoByID(Poke_Ability))].Weak == NmePetType then IsWeakAbility = true else IsWeakAbility = false end
			if IsStrongAbility then return 3 end
			if not IsWeakAbility and not IsStrongAbility then return 2 end
			if IsWeakAbility then return 1 end
		end
			
		-- AbilityCast(CastList, DmgCheck) - Cast this Ability List. DmgCheck - 1 = Strong  2 = Normal  3 = Weak  4 = all
		AbilityCast = nil
		function AbilityCast(CastList, DmgCheck)
			for i = 1, #CastList do
				if DmgCheck == nil then
					Poke_Ability = CastList[i]
					AbilitySpam(Poke_Ability)
				end
				if DmgCheck ~= nil then
					Poke_Ability = CastList[i]
					if TypeWeaknessTable[select(7,C_PetBattles.GetAbilityInfoByID(Poke_Ability))].Strong == NmePetType then IsStrongAbility = true else IsStrongAbility = false end
					if TypeWeaknessTable[select(7,C_PetBattles.GetAbilityInfoByID(Poke_Ability))].Weak == NmePetType then IsWeakAbility = true else IsWeakAbility = false end
					if DmgCheck == 1 
					  and IsStrongAbility then
						AbilitySpam(Poke_Ability)
					end
					if DmgCheck == 2
					  and not IsStrongAbility 
					  and not IsWeakAbility then
						AbilitySpam(Poke_Ability)
					end
					if DmgCheck == 3
					  and IsWeakAbility then
						AbilitySpam(Poke_Ability)
					end
					if DmgCheck == 4 then
						AbilitySpam(Poke_Ability)
					end
				end
			end
		end
		
		-- CapturePet() - Test for targets to trap.
		function CapturePet()
		  	if inBattle 
		  	  and C_PetBattles.GetBreedQuality(2, NmeactivePetSlot) >= CaptureValue 
		  	  and C_PetJournal.GetNumCollectedInfo(C_PetBattles.GetPetSpeciesID(2,NmeactivePetSlot)) < NumberOfPetsValue
		  	  and CaptureCheck then
			  	if NmeactivePetHP <= 35 
			  	  and C_PetBattles.IsTrapAvailable() then
					BadBoy_data.pokeAttack = 8;
					BadBoy_data.wait = 0
					ChatOverlay("\124cFFFFFFFFTrapping pet")
				elseif NmeactivePetHP <= 65 then
					if Stun ~= nil then Stun() end 
					if SimplePunch ~= nil then SimplePunch(3) end 
					if SimplePunch ~= nil then SimplePunch(2) end 
					if SimplePunch ~= nil then SimplePunch(1) end 
				else
					if Stun ~= nil then Stun() end 
					if SimplePunch ~= nil then SimplePunch(1) end 
					if SimplePunch ~= nil then SimplePunch(2) end 
					if SimplePunch ~= nil then SimplePunch(3) end 
				end
			end
		end
		
		-- Return Time in minuts/seconds of the battle.
		function GetBattleTime()
			if inBattleTimer == nil then return 0 end
			if inBattleTimer ~= 0 then
				cTimermin =  floor((GetTime() - inBattleTimer)/60)
				cTimersec =  floor((GetTime() - inBattleTimer)) - (60 * cTimermin)
				return cTimermin, cTimersec 
			else
				return 0 
			end
		end
		
		-- Return the number of abilities the pet have according to his level.
		function GetNumofPetAbilities(PetSlot)
			local 	Petlevel = C_PetBattles.GetLevel(1, PetSlot)
			if Petlevel >= 4 then 
				return 3
			elseif Petlevel >= 2 then
				return 2
			else
				return 1
			end
		end
		
		-- Call to see pet strenghts based on IsPetAttack() lists.
		function GetPetStrenght(PetSlot)
			if PetHPTable[PetSlot] ~= 0 then
				local IsPetStrenght = 0
				
				local petGUID, ability1, ability2, ability3, locked = C_PetJournal.GetPetLoadOutInfo(PetSlot)
				local Abilities = { ability1, ability2, ability3 }
				for i = 1, GetNumofPetAbilities(PetSlot) do
		
					if AbilityTest(Abilities[i]) == 3 
					  and IsPetAttack(Abilities[i]) then
						IsPetStrenght = ( IsPetStrenght + 1 )
					end
					if AbilityTest(Abilities[i]) == 1 
					  and IsPetAttack(Abilities[i]) then
						IsPetStrenght = ( IsPetStrenght - 1 )
					end
				end
				return IsPetStrenght
			else
				return 0
			end
		end
		
		-- Immunity() - Test if the ennemy pet is Immune.	
		function Immunity()
			for i = 1, #ImmunityList do
				local Poke_Ability = ImmunityList[i]
				if IsBuffed(Poke_Ability,2,Poke_Ability) then -- Si Aura = Buff 
					return true     
				end
			end
			if NmePetPercent <= 40 then
				for i = 1, #CantDieList do
					local Poke_Ability = CantDieList[i]
					if IsBuffed(Poke_Ability,2,Poke_Ability) then -- Si Aura = Buff 
						return true     
					end
				end
			end
			return false
		end
		
		-- IsBuffed(Ability, BuffTarget, ForceID) - Test if Ability - 1 is in List. Can test additional IDs.
		function IsBuffed(Ability, BuffTarget, ForceID)
			if inBattle then
				found = false
				for i = 1, C_PetBattles.GetNumAuras(BuffTarget, C_PetBattles.GetActivePet(BuffTarget)) do
					local auraID = C_PetBattles.GetAuraInfo(BuffTarget, C_PetBattles.GetActivePet(BuffTarget), i)
					if Ability ~= nil then
				  		if auraID == ( Ability - 1 ) then     
				 	   		found = true       
				 		end
				 	end
			 		if ForceID ~= nil then
			 			if auraID == ForceID then
			 				found = true
			 			end
			 		end
				end
				if found then 
					return true
				else 
					return false
				end
			end
		end
		
		-- IsBuffed(Ability, BuffTarget, ForceID) - Test if Ability - 1 is in List. Can test additional IDs.
		function IsMultiBuffed(Ability, BuffTarget, ForceID)
			if inBattle then
				if ForceID ~= nil then
					if IsBuffed(ForceID, BuffTarget) then
						return true
					end
				end
				for i = 1, #Ability do
					if IsBuffed(Ability[i], BuffTarget) then
						return true
					end
				end
			end
		end
		
		-- Return true if the attack is in one of these attacks.
		function IsPetAttack(PokeAbility)
			ToQuerryLists = { PunchList, HighDMGList, ThreeTurnHighDamageList }
			for i = 1, #ToQuerryLists do
				ThisList = ToQuerryLists[i]
				for j = 1 , #ThisList do
					if ThisList[j] == PokeAbility then 
						return true
					end
				end
			end
			return false
		end	
		
		-- Health from journal
		function JournalHealth(PetSlot)
			PetHealth = 100 * (select(1,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(PetSlot))) / select(2,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(PetSlot))) )
			if PetHealth == nil then
				return 0
			else
				return PetHealth
			end
		end
		
		-- Health from journal by GUID
		function JournalHealthGUID(PetGUID)
			PetHealth = 100 * (select(1,C_PetJournal.GetPetStats(PetGUID)) / select(2,C_PetJournal.GetPetStats(PetGUID)) )
			if PetHealth == nil then
				return 0
			else
				return PetHealth
			end
		end
		
		-- PetLevel
		function PetLevel(PetSlot)
			if inBattle then
				if PetSlot == nil then return 1 end
				local MyPetLevel = C_PetBattles.GetLevel(1, PetSlot)
				if MyPetLevel == nil then MyPetLevel = 1 end
				return MyPetLevel
			end
			if not inBattle then
				if PetSlot == nil then 
					PetSlot = 1 
				else
					local MyPetLevel = select(3, C_PetJournal.GetPetInfoByPetID(C_PetJournal.GetPetLoadOutInfo(PetSlot)))
					if MyPetLevel == nil then 
						MyPetLevel = 1 
					end
					return tonumber(MyPetLevel)
				end
			end
		end	

		-- Switch Pet
		function Switch()
			AbilityCast(SuicideList)
			-- Make sure we are not rooted.
		  	if CanSwapOut then
				if PetHP <= SwapOutHealthValue 
				  and SwapOutHealthCheck
				  or PetLevelingCheck and activePetSlot == 1 then
					if activePetSlot == 1 
					  and Pet1HP <= SwapOutHealthValue 
					  or NMEPetHP < 100 then
						if GetPetStrenght(2) > GetPetStrenght(3) 
						  and Pet2HP >= SwapInHealthValue then
							--pokeValueFrame.valueText:SetText("Pet 2", 1, 1, 1, 0.7);
							BadBoy_data.pokeAttack = 6
							BadBoy_data.wait = 0
							rotationRun = false;
						elseif Pet3HP >= SwapInHealthValue 
						  or Pet1HP == 0 then
							--pokeValueFrame.valueText:SetText("Pet 3", 1, 1, 1, 0.7);
							BadBoy_data.pokeAttack = 7	
							BadBoy_data.wait = 0
							rotationRun = false;
						end
					elseif activePetSlot == 2 then
						if GetPetStrenght(1) > GetPetStrenght(3)
						  and Pet1HP >= SwapInHealthValue 
						  and not ( PetLevelingCheck and PetLevelingValue > C_PetBattles.GetLevel(1, 1) ) then
							--pokeValueFrame.valueText:SetText("Pet 1", 1, 1, 1, 0.7);
							BadBoy_data.pokeAttack = 5	
							BadBoy_data.wait = 0
							rotationRun = false;
						elseif Pet3HP >= SwapInHealthValue or Pet2HP == 0 then
							--pokeValueFrame.valueText:SetText("Pet 3", 1, 1, 1, 0.7);
							BadBoy_data.pokeAttack = 7	
							BadBoy_data.wait = 0
							rotationRun = false;
						end
					elseif activePetSlot == 3 then
						if GetPetStrenght(1) > GetPetStrenght(2) 
						  and Pet1HP >= SwapInHealthValue 
						  and not ( PetLevelingCheck and PetLevelingValue > C_PetBattles.GetLevel(1, 1) ) then
							--pokeValueFrame.valueText:SetText("Pet 1", 1, 1, 1, 0.7);
							BadBoy_data.pokeAttack = 5	
							BadBoy_data.wait = 0
							rotationRun = false;
						elseif Pet2HP >= SwapInHealthValue or Pet3HP == 0 then
							--pokeValueFrame.valueText:SetText("Pet 2", 1, 1, 1, 0.7);
							BadBoy_data.pokeAttack = 6	
							BadBoy_data.wait = 0
							rotationRun = false;
						elseif Pet2HP == 0 and Pet3HP == 0 then
							--pokeValueFrame.valueText:SetText("Pet 1", 1, 1, 1, 0.7);
							BadBoy_data.pokeAttack = 5	
							BadBoy_data.wait = 0
							rotationRun = false;
						end
					end
				end
			end
		end	
	end

	--[[                                       Abilities                                             ]]
	-- Abilities
	if not AttackFunctions then
		AttackFunctions = true

		-- AoE Attacks to be used only while there are 3 ennemies.
		AoEPunch = nil
		function AoEPunch()
			if nmePetSlot == 1 or 2 then
				AbilityCast(AoEPunchList)
			end
		end
		
		-- Abilities that are stronger if the enemy have more health than us.
		Comeback = nil
		function Comeback()
			if PetHP < NmePetPercent 
			  and not Immunity() then
				AbilityCast(ComebackList)
			end
		end
		
		-- Damage Buffs that we want to cast on us.
		DamageBuff = nil
		function DamageBuff()
			if not IsMultiBuffed(DamageBuffList, 1, 485) then		
				AbilityCast(DamageBuffList)	
			end
		end
		
		-- Debuff to cast on ennemy.
		DeBuff = nil
		function DeBuff()		
			if NmePetPercent >= 45 
			  and not Immunity() then
				for i = 1, #DeBuffList do
					if not IsBuffed(DeBuffList[i], 2) then
						AbilitySpam(DeBuffList[i])
					end
				end
				for i = 1, #SpecialDebuffsList do
					if not IsBuffed(nil, 2, SpecialDebuffsList[i].Debuff) then
						AbilitySpam(SpecialDebuffsList[i].Ability)
					end
				end
			end
		end	
		
		-- HighDamageIfBuffed to cast on ennemy.
		HighDamageIfBuffed = nil
		function HighDamageIfBuffed()
			if not Immunity() then	
				for i = 1, #HighDamageIfBuffedList do
					if IsBuffed(nil, 2, HighDamageIfBuffedList[i].Debuff) then
						AbilitySpam(HighDamageIfBuffedList[i].Ability)
					end
				end
			end
		end
		
		-- Abilities to shield ourself to avoid an ability.
		Deflect = nil
		function Deflect()
			if IsMultiBuffed(ToDeflectList, 2) then		
				AbilityCast(DeflectorList)
			end
		end
		
		-- Apocalypse
		DelayFifteenTurn = nil
		function DelayFifteenTurn()
			if NmeactivePetSlot == 1 then 
				AbilityCast(FifteenTurnList)
			end
		end
		
		-- Damage in three turn
		DelayThreeTurn = nil
		function DelayThreeTurn()
			if NmeactivePetSlot ~= 3 then
				AbilityCast(ThreeTurnList)	
			end
		end
		
		-- Damage in one turn.
		DelayOneTurn = nil
		function DelayOneTurn()
			if not ( NmeactivePetSlot == 3 and NmeactivePetHP <= 30 ) then
				AbilityCast(OneTurnList)
			end
		end
		
		-- Execute if enemi pet is under 30%.
		Execute = nil
		function Execute()
			if NmePetPercent <= 60 
			  and not Immunity() then
				AbilityCast(ExecuteList)
			end
		end
		
		-- Buffs that heal us.
		HoTBuff = nil
		function HoTBuff()
			if PetHP < ( PetHealValue + 10 )
			  and not ( nmePetHP < 40 and enemyPetSlot == 3 ) then
				for i = 1, #HoTList do
					for j = 1, #HoTBuffList do
						local Poke_Ability = HoTBuffList[j]			
						if not IsBuffed(Poke_Ability, 2) then		
							AbilitySpam(Poke_Ability)
						end
					end	
				end
			end
		end
		
		-- Suicide if under 20% Health.
		Kamikaze = nil
		function Kamikaze()
			if PetHP < 20 
			  and not Immunity() then
				AbilityCast(KamikazeList)
			end
		end
		
		LastStand = nil
		function LastStand()
			if PetHP < 25 then
				AbilityCast(LastStandList)
			end
		end
		
		LifeExchange = nil
		function LifeExchange()
			if PetHP < 35
			  and nmePetHP > 70 then
				AbilityCast(LifeExchangeList)	
			end
		end
		
		PassTurn = nil
		function PassTurn()
			if IsMultiBuffed(StunnedDebuffs, 1) then -- if we are stunned
				pokeValueFrame.valueText:SetText("Pass", 1, 1, 1, 0.7); -- skip turn
				BadBoy_data.pokeAttack = 4
				BadBoy_data.wait = 0
				rotationRun = false;
			end
		end
		
		-- Abilities for leveling.
		PetLeveling = nil
		function PetLeveling(HighDmgCheck)
			AbilityCast(PetLevelingList, HighDmgCheck)
		end	
		
		-- Attack that are stronger if we are quicker.
		QuickPunch = nil
		function QuickPunch() 
		  	if myspeed > nmespeed 
		  	  and not Immunity() then
				AbilityCast(QuickList)
			end
		end
		
		-- List of Buffs that we want to cast on us.
		SelfBuff = nil
		function SelfBuff()
			if activePetHP > 15
			  and not ( NmePetPercent <= 40 and NmeactivePetSlot == 3 ) then
				if not IsMultiBuffed(SelfBuffList, 1) then		
					AbilityCast(SelfBuffList)
				end
				for i = 1, #SpecialSelfBuffList do
					if not IsBuffed(nil, 1, SpecialSelfBuffList[i].Buff) then
						AbilitySpam(SpecialSelfBuffList[i].Ability)
					end
				end			
			end
		end
		
		
		-- Direct Healing
		SimpleHealing = nil
		function SimpleHealing()
			if PetPercent < PetHealValue
	  		  and PetHealCheck then
				AbilityCast(HealingList)
			end	
		end
		
		SimpleHighPunch = nil
		function SimpleHighPunch(HighDmgCheck)
			if not Immunity() then
				AbilityCast(HighDMGList, HighDmgCheck)
			end
		end
		
		-- Basic Attacks.
		SimplePunch = nil
		function SimplePunch(HighDmgCheck)
			if HighDmgCheck ~= nil then
				AbilityCast(PunchList, HighDmgCheck)
			else
				AbilityCast(PunchList)
			end
		end	
		
		ShieldBuff = nil
		function ShieldBuff()
			if not ( NmePetPercent <= 30 
			  and NmeactivePetSlot == 3 ) then
			  	if not IsMultiBuffed(ShieldBuffList, 1) then		
					AbilityCast(ShieldBuffList)
				end
			end
		end
		
		SlowPunch = nil
		function SlowPunch()
			if not Immunity() then
				AbilityCast(SlowPunchList)
			end
		end	
		
		SpeedBuff = nil
		function SpeedBuff()
			if myspeed < nmespeed then
				for i = 1, #SpeedBuffList do
					if not IsBuffed(SpeedBuffList[i], 1) then		
						AbilitySpam(SpeedBuffList[i])
					end
				end
			end
		end
		
		SpeedDeBuff = nil
		function SpeedDeBuff()		
			if NmePetPercent >= 45 
			  and myspeed < nmespeed 
			  and myspeed > ( 3 * nmespeed / 4 ) then
				for i = 1, #SpeedDeBuffList do
					if not IsBuffed(SpeedDeBuffList[i], 2) then
						AbilitySpam(SpeedDeBuffList[i])
					end
				end
			end
		end	
		
		Stun = nil
		function Stun()
			if not Immunity() then
				AbilityCast(StunList)
			end
		end	
		
		Soothe = nil
		function Soothe()
			AbilityCast(SootheList)
		end	
		
		TeamDebuff = nil
		function TeamDebuff()
			if not ( NmeactivePetSlot == 3
			  and NmePetPercent <= 55 ) then
				for i = 1, #TeamDebuffList do
					local found = false		
				
			   			for j = 1, ( C_PetBattles.GetNumAuras(2, 0) or 0 ) do
				   			local auraID = C_PetBattles.GetAuraInfo(2, 0, j)
				   			if auraID == ( TeamDebuffList[i] - 1 ) then   
				 	   			found = true     
				   			end
				 		end	
					
					if not found then		
						AbilitySpam(TeamDebuffList[i])
					end
					
					--for i = 1, #SpecialTeamDebuffsList do
					--	if not IsBuffed(nil, 2, SpecialTeamDebuffsList[i].Debuff) then
					--		AbilitySpam(SpecialTeamDebuffsList[i].Ability)
					--	end
					--end
					
				end
			end
		end

		TeamHealBuffs = nil
		function TeamHealBuffs()
			if PetHP < PetHealValue
			  and not ( nmePetHP < 40 and enemyPetSlot == 3 ) then
				for i = 1, #TeamHealBuffsAbilities do
			
					local found = false		
					for j = 1, #TeamHealBuffsList do
						
					
						for k = 1, ( C_PetBattles.GetNumAuras(1,0) or 0 ) do
						
				   			local auraID = C_PetBattles.GetAuraInfo(1, 0, k)
				   			if auraID == TeamHealBuffsList[j] then   
			 	   				found = true       
				   			end
				 		end
					end
		
					if not found then		
						AbilitySpam(TeamHealBuffsAbilities[i])
					end		
				end
			end
		end
		
		-- Abilities that last three turns that does high damage.
		ThreeTurnHighDamage = nil
		function ThreeTurnHighDamage()
			if PetHP > 60 then
				AbilityCast(ThreeTurnHighDamageList)
			end
		end
		
		-- Robot Turrets
		Turrets = nil
		function Turrets(HighDmgCheck)
			if WeatherID ~= 454 
			  and not ( NmeactivePetSlot == 3
		  	  and NmePetPercent <= 55 ) then
				AbilityCast(TurretsList, HighDmgCheck)
			end
		end

	end

	--[[                                       Normal Rotation                                             ]]

	-- Rotation
	
	if inBattle and ObjectiveValue == 1 and BadBoy_data.wait == 1 and BadBoy_data["Check PokeRotation"] == 1 then
		rotationRun = true
		HealingDone = nil
		Switch();
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

