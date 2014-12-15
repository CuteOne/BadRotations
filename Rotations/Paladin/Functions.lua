if select(3,UnitClass("player")) == 2 then
	-- here we will store the functions that we want to have on multiple specs/profiles

	-- Common blessing selector(all specs)
	function Blessings()
		if UnitBuffID("player",144051) ~= nil then
			return false
		end
		local BlessingCount = 0
		for i = 1, #nNova do
			local _, MemberClass = select(2,UnitClass(nNova[i].unit))
			if UnitExists(nNova[i].unit) then
				if MemberClass ~= nil then
					if MemberClass == "DRUID" then BlessingCount = BlessingCount + 1 end
					if MemberClass == "MONK" then BlessingCount = BlessingCount + 1 end
					if MemberClass == "PALADIN" then BlessingCount = BlessingCount + 50 end
					if MemberClass == "SHAMAN" then BlessingCount = BlessingCount + 1000 end
				end
			end
		end
		if BlessingCount > 50 and BlessingCount < 1000 then
			MyBlessing = _BlessingOfMight
		else
			MyBlessing = _BlessingOfKings
		end
		if ActiveBlessingsValue == 2 then
			MyBlessing = _BlessingOfKings
		elseif ActiveBlessingsValue == 3 then
			MyBlessing = _BlessingOfMight
		end
		if MyBlessing == _BlessingOfMight and not Spells[_BlessingOfMight].known then MyBlessing = _BlessingOfKings end
		if MyBlessing == _BlessingOfKings and not Spells[_BlessingOfKings].known then BuffTimer = GetTime() + 600 return false end
		if BuffTimer == nil or BuffTimer < GetTime() then
			for i=1, #nNova do
				if not UnitBuffID(nNova[i].unit,MyBlessing) then
					BuffTimer = GetTime() + random(15,30)
					if castSpell("player",MyBlessing,true,false) then return end
				end
			end
		end
	end
end

