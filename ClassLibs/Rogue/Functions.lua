if select(3, UnitClass("player")) == 4 then
  -- this module intend to provide the developer with a constant value with the fewest interactions to backend code
  -- it provides a value reachable trought bb.combo that is permanently updated everytime a combo point update is required

  -- combo points update
  local function refreshCombo()
    local thisUnit = nil
    -- make sure we are in combat
    if UnitAffectingCombat("player") then
      -- if we have a valid target
      if UnitExists("target") then
        bb.combo = GetComboPoints("player","target")
        -- if we have a valid enemi
      elseif GetObjectExists(enemiesTable[1].unit) then
        bb.combo = GetComboPoints("player",enemiesTable[1].unit)
      end
    else
      -- if we are not in combat, it can only be a -1
      bb.combo = bb.combo - 1
    end
  end
  -- define bb.combo once to make sure its not nil
  bb.combo = GetComboPoints("player")
  -- Define a self sufficient frame to do all the checks only when combo changes
  local Frame = CreateFrame('Frame')
  Frame:RegisterEvent("UNIT_COMBO_POINTS")
  -- add our local function to it
  Frame:SetScript("OnEvent",refreshCombo)

end
