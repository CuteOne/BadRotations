--+----------------+--
--|Get Current Zone|--
--+----------------+--
myCurrentZone = GetRealZoneText();
--+---------------------+--
--|Am I In Maw of Souls?|--
--+---------------------+--
function inMawOfSouls()
  if myCurrentZone == "Helmouth Cliffs" then
    isBadBoyHelya()
  end
end

function bossManager()
	--+------------+--
--|Where Am I? |--
--|Check Please|--
--+------------+--
AddEventCallback("ZONE_CHANGED_NEW_AREA", function()
print("We are in", GetRealZoneText())
inMawOfSouls()

end)

  inMawOfSouls()
end