function PokeAbilities()
  --[[                                       Functions                                             ]]

  if not PetFunctions then
    PetFunctions = true


    function pokeTimers()
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
    end

    -- AbilitySpam(Ability) - Cast this single ability with checks.
    AbilitySpam = nil
    function AbilitySpam(Ability)
      if myPets[myPetSlot].a1 == Ability and C_PetBattles.GetAbilityState(1, myPetSlot, 1) == true then
        C_PetBattles.UseAbility(1);
      end
      if myPets[myPetSlot].a2 == Ability and C_PetBattles.GetAbilityState(1, myPetSlot, 2) == true then
        C_PetBattles.UseAbility(2);
      end
      if myPets[myPetSlot].a3 == Ability and C_PetBattles.GetAbilityState(1, myPetSlot, 3) == true then
        C_PetBattles.UseAbility(3);
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
        and C_PetBattles.GetBreedQuality(2, nmePetSlot) >= getValue("Pet Capture")
        and C_PetJournal.GetNumCollectedInfo(C_PetBattles.GetPetSpeciesID(2,nmePetSlot)) < getValue("Number of Pets")
        and isChecked("Pet Capture") then
        if nmePets[nmePetSlot].health <= 35
          and C_PetBattles.IsTrapAvailable() then
          ChatOverlay("\124cFFFFFFFFTrapping pet")
          C_PetBattles.UseTrap()
        elseif nmePets[nmePetSlot].health <= 65 then
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

    -- Call to see pet strenghts based on IsPetAttack() lists.
    function GetPetStrenght(PetSlot)
      if myPets[PetSlot].health ~= nil then
        local IsPetStrenght = 0

        local petGUID, ability1, ability2, ability3, locked = C_PetJournal.GetPetLoadOutInfo(PetSlot)
        local Abilities = { ability1, ability2, ability3 }
        for i = 1, numOfAbilities do

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
      if nmePets[nmePetSlot].health <= 40 then
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
      local petHealth = 100 * (select(1,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(PetSlot))) / select(2,C_PetJournal.GetPetStats(C_PetJournal.GetPetLoadOutInfo(PetSlot))) )
      if petHealth == nil then
        return 0
      else
        return petHealth
      end
    end

    -- Health from journal by GUID
    function JournalHealthGUID(PetGUID)
      local PetHealth = 100 * (select(1,C_PetJournal.GetPetStats(PetGUID)) / select(2,C_PetJournal.GetPetStats(PetGUID)) )
      if PetHealth == nil then
        return 0
      else
        return PetHealth
      end
    end

    -- PetLevel
    function PetLevel(PetSlot)
      local myPetLevel;
      if inBattle then
        if PetSlot == nil then return 1 end
        myPetLevel = C_PetBattles.GetLevel(1, PetSlot)
        if myPetLevel == nil then myPetLevel = 1 end
      end
      if not inBattle then
        if PetSlot == nil then
          PetSlot = 1
        else
          myPetLevel = select(3, C_PetJournal.GetPetInfoByPetID(C_PetJournal.GetPetLoadOutInfo(PetSlot)))
          if myPetLevel == nil then
            myPetLevel = 1
          end
        end
      end
      return tonumber(myPetLevel)
    end

    -- Switch Pet
    function Switch()
      -- Suicide
      if not (isChecked("Pet Leveling") and myPetSlot == 1) then AbilityCast(SuicideList); end
      -- Make sure we are not rooted.
      if canSwapOut or myPets[myPetSlot].health == 0 then
        if myPetSlot == 1 and myPets[1].health <= br.data.settings[br.selectedSpec].toggles["Box Swap Out Health"] and br.data.settings[br.selectedSpec].toggles["Check Swap in Health"] == 1
          or isChecked("Pet Leveling") and myPetSlot == 1 then
          if myPets[1].health <= br.data.settings[br.selectedSpec].toggles["Box Swap Out Health"] or nmePets[nmePetSlot].health < 100 then
            if GetPetStrenght(2) >= GetPetStrenght(3)
              and myPets[2].health >= br.data.settings[br.selectedSpec].toggles["Box Swap in Health"] then
              C_PetBattles.ChangePet(2);
            else
              C_PetBattles.ChangePet(3);
            end
          end
        elseif myPetSlot == 2 and myPets[2].health < br.data.settings[br.selectedSpec].toggles["Box Swap Out Health"] then
          if GetPetStrenght(1) > GetPetStrenght(3)
            and myPets[1].health >= br.data.settings[br.selectedSpec].toggles["Box Swap in Health"]
            and not ( isChecked("Pet Leveling") and getValue("Pet Leveling Max") > C_PetBattles.GetLevel(1, 1) ) then
            C_PetBattles.ChangePet(1);
          elseif myPets[3].health >= br.data.settings[br.selectedSpec].toggles["Box Swap in Health"] or myPets[2].health == 0 then
            C_PetBattles.ChangePet(3);
          end
        elseif myPetSlot == 3 and myPets[3].health < br.data.settings[br.selectedSpec].toggles["Box Swap Out Health"] then
          if GetPetStrenght(1) > GetPetStrenght(2)
            and myPets[1].health >= br.data.settings[br.selectedSpec].toggles["Box Swap in Health"]
            and not ( isChecked("Pet Leveling") and getValue("Pet Leveling Max") > C_PetBattles.GetLevel(1, 1) ) then
            C_PetBattles.ChangePet(1);
          elseif myPets[3].health == 0 and myPets[2].health > 0 or myPets[2].health >= br.data.settings[br.selectedSpec].toggles["Box Swap in Health"] then
            C_PetBattles.ChangePet(2);
          elseif myPets[3].health == 0 and myPets[2].health == 0 then
            C_PetBattles.ChangePet(1);
          end
        end
      end
    end
  end

  --[[                                       Abilities                                             ]]
  -- Abilities
  if not AttackFunctions then
    AttackFunctions = true

    -- AoE Attacks to be used only while there are 3 Enemies.
    AoEPunch = nil
    function AoEPunch()
      if nmePetSlot == 1 or 2 then
        AbilityCast(AoEPunchList)
      end
    end

    -- Abilities that are stronger if the enemy have more health than us.
    Comeback = nil
    function Comeback()
      if myPets[myPetSlot].health < nmePets[nmePetSlot].health
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
      if nmePets[nmePetSlot].health >= 45
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
      if nmePetSlot == 1 then
        AbilityCast(FifteenTurnList)
      end
    end

    -- Damage in three turn
    DelayThreeTurn = nil
    function DelayThreeTurn()
      if nmePetSlot ~= 3 then
        AbilityCast(ThreeTurnList)
      end
    end

    -- Damage in one turn.
    DelayOneTurn = nil
    function DelayOneTurn()
      if not ( nmePetSlot == 3 and nmePets[nmePetSlot].health <= 30 ) then
        AbilityCast(OneTurnList)
      end
    end

    -- Execute if enemi pet is under 30%.
    Execute = nil
    function Execute()
      if nmePets[nmePetSlot].health <= 60
        and not Immunity() then
        AbilityCast(ExecuteList)
      end
    end

    -- Buffs that heal us.
    HoTBuff = nil
    function HoTBuff()
      if myPets[myPetSlot].health < ( PetHealValue + 10 )
        and not ( myPets[myPetSlot].health < 40 and enemyPetSlot == 3 ) then
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
      if myPets[myPetSlot].health < 20
        and not Immunity() then
        AbilityCast(KamikazeList)
      end
    end

    LastStand = nil
    function LastStand()
      if myPets[myPetSlot].health < 25 then
        AbilityCast(LastStandList)
      end
    end

    LifeExchange = nil
    function LifeExchange()
      if myPets[myPetSlot].health < 35
        and myPets[myPetSlot].health > 70 then
        AbilityCast(LifeExchangeList)
      end
    end

    PassTurn = nil
    function PassTurn()
      if IsMultiBuffed(StunnedDebuffs, 1) then -- if we are stunned
        C_PetBattles.SkipTurn();
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
      if myPets[myPetSlot].health > 15
        and not ( nmePets[nmePetSlot].health <= 40 and nmePetSlot == 3 ) then
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

    -- Direct Healing.
    SimpleHealing = nil
    function SimpleHealing()
      if PetPercent < PetHealValue
        and PetHealCheck then
        AbilityCast(HealingList)
      end
    end

    -- Basic High Damage Attack.
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
      if not ( nmePets[nmePetSlot].health <= 30
        and nmePetSlot == 3 ) then
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
      if nmePets[nmePetSlot].health >= 45
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
      if not ( nmePetSlot == 3
        and nmePets[nmePetSlot].health <= 55 ) then
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
      if myPets[myPetSlot].health < PetHealValue
        and not ( myPets[myPetSlot].health < 40 and enemyPetSlot == 3 ) then
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
      if myPets[myPetSlot].health > 60 then
        AbilityCast(ThreeTurnHighDamageList)
      end
    end

    -- Robot Turrets
    Turrets = nil
    function Turrets(HighDmgCheck)
      if WeatherID ~= 454
        and not ( nmePetSlot == 3
        and nmePets[nmePetSlot].health <= 55 ) then
        AbilityCast(TurretsList, HighDmgCheck)
      end
    end

  end
end

