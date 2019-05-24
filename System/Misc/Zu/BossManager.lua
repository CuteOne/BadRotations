function bossHelper()
	-- Automatic catch the pig
	if EWT~=nil then
		if GetMinimapZoneText() == "Ring of Booty" then
			for i = 1, GetObjectCount() do
				local ID = ObjectID(GetObjectWithIndex(i))
				local object = GetObjectWithIndex(i)
				if ID == 130099 and getDistance(object) < 10 then
					InteractUnit(object)
				end
			end
		end
	end	
end
