function br.objectTracker()
	if br.timer:useTimer("Tracker Lag", 0.07) then
		LibDraw.clearCanvas()
		if isChecked("Chest Tracker") or isChecked("Potions Tracker") or isChecked("Custom Tracker") then
			for i = 1, GetObjectCountBR() do
				local object = GetObjectWithIndex(i)
				local name = ObjectName(object)
				local objectid = ObjectID(object)
				if isChecked("Chest Tracker") then
					if string.match(strupper(name),strupper("cache")) or string.match(strupper(name),strupper("chest")) then
						local xOb, yOb, zOb = ObjectPosition(object)
						local pX,pY,pZ = ObjectPosition("player")
						if xOb ~= nil and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) < 300 then
							--LibDraw.Circle(xOb,yOb,zOb, 2)
							LibDraw.Text(name.." "..objectid,"GameFontNormal",xOb,yOb,zOb+3)
							if isChecked("Draw Lines to Tracked Objects") then 
								LibDraw.Line(pX,pY,pZ,xOb,yOb,zOb)
							end
							if isChecked("Auto Interact with Any Tracked Object") and not br.player.inCombat and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <= 7 then
								ObjectInteract(object)
							end
						end
					end
				end


				if isChecked("Potions Tracker") then
					--[[ local badpot = {"Blank","Red","Black","Green","Blue","Purple"} ]]
					if br.lists.visions == nil then Print("Visions doesnt exists") end
					for _,v in pairs(br.lists.visions) do
						if v == objectid then
							local xOb, yOb, zOb = ObjectPosition(object)
							local pX,pY,pZ = ObjectPosition("player")
							if xOb ~= nil and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <200 then
								--LibDraw.Circle(xOb,yOb,zOb, 1)
								LibDraw.Text(name.." "..objectid,"GameFontNormal",xOb,yOb,zOb+3)
								if isChecked("Draw Lines to Tracked Objects") then 
									LibDraw.Line(pX,pY,pZ,xOb,yOb,zOb)
								end
								if isChecked("Auto Interact with Any Tracked Object") and not br.player.inCombat and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <= 7 then
									ObjectInteract(object)
								end
							end
						end
					end
				end

				if isChecked("Custom Tracker") then
					if getOptionValue("Custom Tracker") ~= "" and string.len(getOptionValue("Custom Tracker")) >= 3 and string.match(strupper(name),strupper(getOptionValue("Custom Tracker"))) then
						local xOb, yOb, zOb = ObjectPosition(object)
						local pX,pY,pZ = ObjectPosition("player")
						if xOb ~= nil and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <200 then
							--LibDraw.Circle(xOb,yOb,zOb, 1)
							LibDraw.Text(name.." "..objectid,"GameFontNormal",xOb,yOb,zOb+3)
							if isChecked("Draw Lines to Tracked Objects") then 
								LibDraw.Line(pX,pY,pZ,xOb,yOb,zOb)
							end
							if isChecked("Auto Interact with Any Tracked Object") and not br.player.inCombat and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <= 7 then
								ObjectInteract(object)
							end
						end
					end
				end
			end
		end
	end
end