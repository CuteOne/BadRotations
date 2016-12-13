--+----------------+--
--|Get Current Zone|--
--+----------------+--
myCurrentZone = GetRealZoneText();
--+---------------------+--
--|Am I In Maw of Souls?|--
--+---------------------+--
function inMawOfSouls()
  if myCurrentZone == "Helmouth Cliffs" then
    isBadRotationsHelya()
  end
end

function bossManager()
	--+------------+--
--|Where Am I? |--
--|Check Please|--
--+------------+--
AddEventCallback("ZONE_CHANGED_NEW_AREA", function()
Print("We are in", GetRealZoneText())
inMawOfSouls()

end)

  inMawOfSouls()
end