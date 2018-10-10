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
function bossHelper()
	-- Automatic catch the pig
	if EWT~=nil then
		if GetMinimapZoneText() == "Ring of Booty" then
			for i = 1, ObjectCount() do
				local ID = ObjectID(ObjectWithIndex(i))
				local object = ObjectWithIndex(i)
				if ID == 130099 and ObjectExists(object) and getDistance(object) < 10 then
					InteractUnit(object)
				end
			end
		end
	end	
end