function pulseNovaDebug()
	if getOptionCheck("Healing Debug") ~= true then
		if healingDebugStarted and _G["healingDebugFrame"]:IsShown() == true then
			_G["healingDebugFrame"]:Hide()
		end
	else
		if healingDebugStarted and _G["healingDebugFrame"]:IsShown() ~= true then
			_G["healingDebugFrame"]:Show()
		end
		if not healingDebugStarted then
			healingDebugStarted = true
			frameCreation("healingDebug",200,150,"|cffFF001Ebr.friend")
			for i = 1, 5 do
				local thisOption = { name = i, status = 100, statusMin = 0, statusMax = 100, unit = "thisUnit" }
				createNovaStatusBar("healingDebug",thisOption,10,-i*25,180,20,false)
			end
		end
		-- i will gather frames informations via thisDebugRow = br.friendDebug[i]
		local novaUnits = #br.friend
		if novaUnits > 5 then
			novaUnits = 5
		end
		for i = 1, novaUnits do
			local thisUnit = br.friend[i]
			_G[br.friendDebug[i]]:Show()
			thisDebugRow = br.friendDebug[i]
			_G[thisDebugRow]:SetValue(thisUnit.hp)
			_G[thisDebugRow.."Text"]:SetText(math.floor(thisUnit.hp))
			if classColors[thisUnit.class] ~= nil then
				_G[thisDebugRow]:SetStatusBarTexture(classColors[thisUnit.class].R,classColors[thisUnit.class].G,classColors[thisUnit.class].B)
			else
				_G[thisDebugRow]:SetStatusBarTexture(1,1,1)
			end
			if thisUnit.dispel == true then
				_G[thisDebugRow]:SetStatusBarTexture(0.70,0,0)
			end
		end
		-- show up to 5 frames or #br.friend
		if novaUnits < 5 then
			for i = 1, 5 do
				if i > novaUnits then
					_G[br.friendDebug[i]]:Hide()
				end
			end
		end
		_G["healingDebugFrame"]:SetHeight((novaUnits+1)*23)
	end
end
