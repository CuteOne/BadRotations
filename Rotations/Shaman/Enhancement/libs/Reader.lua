if select(3, UnitClass("player")) == 7 then

  local init
  if init == nil then
    init = false
  end

  function EnhanceReader()
    if init == false then
      init = true
    end
  end

  -- Create our frame and bind combat log events
  if not CpoworksFrame then
    CpoworksFrame = CreateFrame("FRAME")
  end
  CpoworksFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")


  function EventHandler(self, event, ...)

    if not init then return end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
      local timestamp 	= select(1,...)
      local param 		= select(2,...)
      local sourceGUID 		= select(4,...)
      local sourceName	= select(5,...)
      local destinationGUID 	= select(8,...)
      local destinationName 	= select(9,...)
      local spell 		= select(12,...)
      local playerGUID    = UnitGUID("player")
      local playerClass   = select(3, UnitClass("player"))

      if param == "SPELL_CAST_SUCCESS" then

      --if spell == _FlameShock then
      --	print(...)
      --end

      end

      if param == "SPELL_AURA_APPLIED" then
        local AlreadyTabled = false

        if spell == _FlameShock
          and sourceGUID == playerGUID then
          for j=1, #FlameShockTargets do
            if destinationGUID == FlameShockTargets[j].unitGuid then
              AlreadyTabled = true
              break
            end
          end
          if not AlreadyTabled then
            table.insert(FlameShockTargets, { unit=destinationName, unitGuid=destinationGUID, time=GetTime() } )
            --print("Adding "..destinationName.." to the Flame Shock Table")
          end
        end

      end

      if param == "SPELL_AURA_REMOVED" then

        if spell == _FlameShock
          and sourceGUID == playerGUID then
          for j=1, #FlameShockTargets do
            if destinationGUID == FlameShockTargets[j].unitGuid then
              table.remove(FlameShockTargets, j)
              --print("Removing "..destinationName.." from the Flame Shock Table")
              break
            end
          end
        end


      end

      if param == "SPELL_AURA_REFRESH" then
        if spell == _FlameShock
          and sourceGUID == playerGUID then
          for j=1, #FlameShockTargets do
            if destinationGUID == FlameShockTargets[j].unitGuid then
              FlameShockTargets[j].time = GetTime()
              --print("Refreashing "..destinationName.." to the Flame Shock Table")
              break
            end
          end
        end

      end

    end
  end

  CpoworksFrame:SetScript("OnEvent", EventHandler)

end
