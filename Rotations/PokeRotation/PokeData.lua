function PokeData()
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

  -- Register Base Values
  if not PokeEngineStarted then
    outOfBattleTimer = 0
    inBattleTimer = 0
    health1 = 100
    health2 = 100
    health3 = 100
    maxhealth1 = 100
    maxhealth2 = 100
    maxhealth3 = 100
    PetHP = 100
    Pet1HP = 100
    Pet2HP = 100
    Pet3HP = 100
    MoyHPP = 100
    MoyHP = 100
    activePetSlot = 1
    activePetHP =  100
    PetID = 1
    Pet1ID = 1
    Pet2ID = 2
    Pet3ID = 3
    PetPercent = 100
    numAuras = 1
    numNmeAuras = 1
    NmeactivePetSlot = 1
    NmeactivePetHP = 1
    NmePetID = 1
    NmePetPercent = 1
    nmePetHP = 100
    modifier = 1
    myspeed = 100
    nmespeed = 100
    quality = 100
    PetAbilitiesTable = {{ A1 = 1 , A2 = 1 , A3 = 1 }, { A1 = 1 , A2 = 1 , A3 = 1 }, { A1 = 1 , A2 = 1 , A3 = 1 }}
    -- Static Vars --
    --	RarityColorsTable[1]
    RarityColorsTable = {
      { Type = "Useless", 	Color = "999999" },
      { Type = "Common", 		Color = "FFFFFF" },
      { Type = "Uncommon", 	Color = "33FF33" },
      { Type = "Rare", 		Color = "00AAFF" },
    }
    --	TypeWeaknessTable[1].Color
    TypeWeaknessTable = {
      {	Num = 1, 	Type = "Humanoid",	Weak = 8,	Strong = 2, Resist = 5,	Color = "00AAFF"	},
      {	Num = 2, 	Type = "Dragonkin",	Weak = 4,	Strong = 6, Resist = 3,	Color = "33FF33"	},
      {	Num = 3, 	Type = "Flying",	Weak = 2,	Strong = 9, Resist = 8,	Color = "FFFF66"	},
      {	Num = 4, 	Type = "Undead",	Weak = 9,	Strong = 1, Resist = 2,	Color = "663366"	},
      {	Num = 5, 	Type = "Critter",	Weak = 1,	Strong = 4, Resist = 7,	Color = "AA7744"	},
      {	Num = 6, 	Type = "Magic",		Weak = 10,	Strong = 3, Resist = 9,	Color = "CC44DD"	},
      {	Num = 7, 	Type = "Elemental",	Weak = 5,	Strong = 10,Resist = 10,Color = "FF9933"	},
      {	Num = 8, 	Type = "Beast",		Weak = 3,	Strong = 5, Resist = 1,	Color = "DD2200"	},
      {	Num = 9, 	Type = "Aquatic",	Weak = 6,	Strong = 7, Resist = 4,	Color = "33CCFF"	},
      {	Num = 10, 	Type = "Mechanical",Weak = 7,	Strong = 8, Resist = 6,	Color = "999999"	},
    }
    PokeEngineStarted = true
    -- (PQI) OPTIONS --
    ObjectiveCheck				= true
    ObjectiveValue				= 1
    PetLevelingCheck			= true
    PetLevelingValue			= 6
    ReviveBattlePetsCheck 		= true
    ReviveBattlePetsValue		= 1
    PetHealValue				= 65
    PetHealCheck				= true
    CaptureValue				= 4
    CaptureCheck				= true
    NumberOfPetsValue			= 1
    AutoClickerValue			= 1
    AutoClickerCheck			= false
    FollowerDistanceValue		= 25
    FollowerDistanceCheck		= true

    LevelingPriorityValue 		= 3
    LevelingPriorityCheck		= true
    LevelingRarityValue 		= 4
    LevelingRarityCheck			= true
    SwapInHealthValue			= 65
    SwapInHealthCheck			= true
    SwapOutHealthValue			= 35
    SwapOutHealthCheck			= true
    -- PvP Queue
    PvPCheck					= false
    PvPSlotValue				= 1
    -- Pet Swapper
    PetSwapCheck				= true
    PetSwapValue				= 35
    PetSwapMinCheck				= true
    PetSwapMinValue				= 6
    -- Pause
    PauseKey					= false
    PauseKeyCheck				= false

  end
end
