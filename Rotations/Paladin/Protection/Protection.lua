if select(3, UnitClass("player")) == 2 then
  function PaladinProtection()
    -- Init if this is the first time we are running.
    if br.player == nil or br.player.profile ~= "Protection" then
      br.player = cProtection:new("Protection")
      setmetatable(br.player, {__index = cProtection})

      br.player:createToggles()
      br.player:update()
    end

    -- Manual Input
    --if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
    --  return true
    --end
    --if IsLeftControlKeyDown() then -- Pause the script, keybind in wow ctrl+1 etc for manual cast
    --  return true
    --end
    --if IsLeftAltKeyDown() then
    --  return true
    --end

    br.player:update()

  end
end
