if select(3, UnitClass("player")) == 4 then
  function CombatRogue()
    if rogueCombat == nil then
      rogueCombat = cCombat:new()
      setmetatable(rogueCombat, {__index = cCombat})
      CombatToggles()
      rogueCombat:update()
    end
    -- ToDo add pause toggle
    -- Manual Input
    if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
      return true
    end
    if IsLeftControlKeyDown() then -- Pause the script, keybind in wow ctrl+1 etc for manual cast
      return true
    end
    if IsLeftAltKeyDown() then
      return true
    end
    
    rogueCombat:update()
  end --Rogue Function End
end --Class Check End
