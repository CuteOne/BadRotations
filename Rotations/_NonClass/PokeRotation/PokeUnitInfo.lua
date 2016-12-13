-- Disable all filters in Pet Journal --
if IsSwapping == nil then IsSwapping = GetTime() end

function PetSwapper()
  -- Pet swap table --
  if not inBattle
    and isChecked("Swap in Health")
    and isChecked("Pet Leveling") then
    local priorityValue = getValue("Leveling Priority");
    local swapTable = { }
    local ringnersTable = { }
    -- Pet Leveling Slot 1
    if PetLevel(1) and PetLevel(1) >= getValue("Pet Leveling Max") or PetLevel(1) and PetLevel(1) < getValue("Pet Leveling") or JournalHealth(1) <= getValue("Swap in Health") then

      for i = 1, select(2,C_PetJournal.GetNumPets()) do
        petID, _, _, _, level, favorite, _, _, _, _, _, _, _, isWild, canBattle, _, _, _ = C_PetJournal.GetPetInfoByIndex(i)
        if petID ~= nil then
          if isWild then WildConvert = 1 else WildConvert = 0 end
          if favorite then FavoriteConvert = 1 else FavoriteConvert = 0 end
          if canBattle
            and ( level < PetSwapValue and JournalHealthGUID(petID) >= getValue("Swap in Health") )
            and level >= PetSwapMinValue
            and petID ~= C_PetJournal.GetPetLoadOutInfo(1)
            and petID ~= C_PetJournal.GetPetLoadOutInfo(2)
            and petID ~= C_PetJournal.GetPetLoadOutInfo(3)
            and select(5, C_PetJournal.GetPetStats(select (1,C_PetJournal.GetPetInfoByIndex(i)))) >= LevelingRarityValue then
            table.insert(swapTable,{
              ID = petID,
              Level = level,
              favorite = FavoriteConvert,
              Wild = WildConvert,
            } )
            --Print("Inserted "..petID.." "..level.." "..FavoriteConvert.." "..WildConvert)
          end
        end
      end

      table.sort(swapTable, function(x,y) return x.favorite < y.favorite end)

      -- Level Sorts
      if priorityValue == 1 or 3 then
        table.sort(swapTable, function(x,y) return x.Level < y.Level end)
      end

      if priorityValue == 2 or 4 then
        table.sort(swapTable, function(x,y) return x.Level > y.Level end)
      end

      -- Wild Sorts
      if priorityValue ==  3 or 4	then
        table.sort(swapTable, function(x,y) return x.Wild < y.Wild end)
      end

      C_PetJournal.SetPetLoadOutInfo(1, swapTable[1].ID)

    end


    -- Other pets check health
    for i = 1, 3 do
      if not ( i == 1 and isChecked("Pet Leveling") ) then
        if ( JournalHealth(i) <= getValue("Swap in Health") or PetLevel(i) ~= 25 )then


          for j = 1, select(2,C_PetJournal.GetNumPets()) do
            petID, _, _, _, level, favorite, _, _, _, _, _, _, _, isWild, canBattle, _, _, _ = C_PetJournal.GetPetInfoByIndex(j)
            if petID ~= nil then
              if isWild then WildConvert = 1 else WildConvert = 0 end
              if favorite then FavoriteConvert = 1 else FavoriteConvert = 0 end
              if canBattle
                and JournalHealthGUID(petID) >= getValue("Swap in Health")
                and level >= PetSwapMinValue
                and petID ~= C_PetJournal.GetPetLoadOutInfo(1)
                and petID ~= C_PetJournal.GetPetLoadOutInfo(2)
                and petID ~= C_PetJournal.GetPetLoadOutInfo(3)
                and select(5, C_PetJournal.GetPetStats(select (1,C_PetJournal.GetPetInfoByIndex(j)))) >= 4 then
                table.insert( ringnersTable,{
                  ID = petID,
                  Level = level,
                  favorite = FavoriteConvert,
                  Wild = WildConvert,
                } )
                --Print("Inserted Ringner "..petID.." "..level.." "..FavoriteConvert.." "..WildConvert)
              end
            end
          end

          -- Favorites Sorts
          table.sort(ringnersTable, function(x,y) return x.favorite < y.favorite end)

          -- Level Sorts
          table.sort(ringnersTable, function(x,y) return x.Level > y.Level end)

          -- Switch Pet
          C_PetJournal.SetPetLoadOutInfo(i, ringnersTable[1].ID)
        end
      end
    end
  end
end

function getPets(Radius)
  local petsTable = { };
  for i=1, GetTotalObjects(TYPE_UNIT) do
    local Guid = IGetObjectListEntry(i);
    ISetAsUnitID(Guid,"thisUnit");
    if (tonumber(string.sub(tostring(Guid), 5,5)) == 3 and UnitCreatureType("thisUnit") == "Wild Pet") then
      if getDistance("player","thisUnit") <= Radius then
        tinsert(petsTable,Guid);
      end
    end
  end
  return petsTable;
end
