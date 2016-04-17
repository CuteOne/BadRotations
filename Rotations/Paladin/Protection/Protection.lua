if select(3, UnitClass("player")) == 2 then
  function PaladinProtection()
    -- Init if this is the first time we are running.
    if bb.player == nil or bb.player.profile ~= "Protection" then
      bb.player = cProtection:new("Protection")
      setmetatable(bb.player, {__index = cProtection})

      bb.player:createToggles()
      bb.player:update()
    end

    -- Manual Input
    if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
      return true
    end
    --if IsLeftControlKeyDown() then -- Pause the script, keybind in wow ctrl+1 etc for manual cast
    --  return true
    --end
    if IsLeftAltKeyDown() then
      return true
    end

    bb.player:update()

  end
end
