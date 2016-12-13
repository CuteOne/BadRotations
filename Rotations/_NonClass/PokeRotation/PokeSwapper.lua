function PokeSwapper()
  --[[                                       Swap Config                                             ]]
  if not swapperLoaded then
    swapperLoaded = true;
    -- Disable all filters in Pet Journal --
    if IsSwapping == nil then IsSwapping = GetTime() end
    function SuperPetSwapper()
      -- Pet swap table --
      if enoughWait == nil then enoughWait = GetTime() + 2 end
      if enoughWait < GetTime()
        and not inBattle
        and PetSwapCheck
        and PetLevelingCheck
        and not PvPCheck
        and ObjectiveValue == 1 then

        -- Pet Leveling Slot 1
        if PetLevel(1) ~= nil and PetLevel(1) >= PetSwapValue or PetLevel(1) < PetSwapMinValue then -- or JournalHealth(1) <= SwapInHealthValue then

          CML_PetTable = { }

          for i = 1, select(2,C_PetJournal.GetNumPets()) do
            petID, _, _, _, level, favorite, _, _, _, _, _, _, _, isWild, canBattle, _, _, _ = C_PetJournal.GetPetInfoByIndex(i)
            if petID ~= nil then
              if isWild then WildConvert = 1 else WildConvert = 0 end
              if Favorite then FavoriteConvert = 1 else FavoriteConvert = 0 end
              if canBattle
                and ( level < PetSwapValue and JournalHealthGUID(petID) >= SwapInHealthValue )
                and level >= PetSwapMinValue
                and petID ~= C_PetJournal.GetPetLoadOutInfo(1)
                and petID ~= C_PetJournal.GetPetLoadOutInfo(2)
                and petID ~= C_PetJournal.GetPetLoadOutInfo(3)
                and select(5, C_PetJournal.GetPetStats(select (1,C_PetJournal.GetPetInfoByIndex(i)))) >= LevelingRarityValue then
                table.insert( CML_PetTable,{
                  ID = petID,
                  Level = level,
                  Favorite = FavoriteConvert,
                  Wild = WildConvert,
                } )
                -- Print("Inserted "..petID.." "..level.." "..FavoriteConvert.." "..WildConvert)
              end
            end
          end

          table.sort(CML_PetTable, function(x,y) return x.Favorite < y.Favorite end)

          -- Level Sorts
          if LevelingPriorityValue == 1 or  3  then
            table.sort(CML_PetTable, function(x,y) return x.Level < y.Level end)
          end
          if LevelingPriorityValue == 2 or 4 then
            table.sort(CML_PetTable, function(x,y) return x.Level > y.Level end)
          end

          -- Wild Sorts
          if LevelingPriorityValue ==  3 or 4	then
            table.sort(CML_PetTable, function(x,y) return x.Wild < y.Wild end)
          end

          C_PetJournal.SetPetLoadOutInfo(1, CML_PetTable[1].ID)
        end

        -- Other pets check health
        for i = 1, 3 do
          if not ( i == 1 and PetLevelingCheck ) then
            if ( JournalHealth(i) <= SwapInHealthValue or PetLevel(i) ~= 25 )then

              CML_RingnersTable = { }

              for j = 1, select(2,C_PetJournal.GetNumPets()) do
                petID, _, _, _, level, favorite, _, _, _, _, _, _, _, isWild, canBattle, _, _, _ = C_PetJournal.GetPetInfoByIndex(j)
                if petID ~= nil then
                  if isWild then WildConvert = 1 else WildConvert = 0 end
                  if Favorite then FavoriteConvert = 1 else FavoriteConvert = 0 end
                  if canBattle
                    and JournalHealthGUID(petID) >= SwapInHealthValue
                    and level >= PetSwapMinValue
                    and petID ~= C_PetJournal.GetPetLoadOutInfo(1)
                    and petID ~= C_PetJournal.GetPetLoadOutInfo(2)
                    and petID ~= C_PetJournal.GetPetLoadOutInfo(3)
                    and select(5, C_PetJournal.GetPetStats(select (1,C_PetJournal.GetPetInfoByIndex(j)))) >= 4 then
                    table.insert( CML_RingnersTable,{
                      ID = petID,
                      Level = level,
                      Favorite = FavoriteConvert,
                      Wild = WildConvert,
                    } )
                    -- Print("Inserted Ringner "..petID.." "..level.." "..FavoriteConvert.." "..WildConvert)
                  end
                end
              end

              -- Favorites Sorts
              table.sort(CML_RingnersTable, function(x,y) return x.Favorite < y.Favorite end)

              -- Level Sorts
              table.sort(CML_RingnersTable, function(x,y) return x.Level > y.Level end)

              -- Switch Pet
              C_PetJournal.SetPetLoadOutInfo(i, CML_RingnersTable[1].ID)
            end
          end
        end
      end
    end
  end
end
