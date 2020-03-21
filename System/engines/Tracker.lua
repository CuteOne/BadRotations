local function trackObject(object,name,objectid,interact)
	local xOb, yOb, zOb = ObjectPosition(object)
	local pX,pY,pZ = ObjectPosition("player")
	if interact == nil then interact = true end
	if xOb ~= nil and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) < 200 then
		--LibDraw.Circle(xOb,yOb,zOb, 2)
		LibDraw.Text(name.." "..objectid,"GameFontNormal",xOb,yOb,zOb+3)
		if isChecked("Draw Lines to Tracked Objects") then
			LibDraw.Line(pX,pY,pZ,xOb,yOb,zOb)
		end
		if isChecked("Auto Interact with Any Tracked Object") and interact and not br.player.inCombat
			and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <= 7 and not isUnitCasting("player")
		then
			ObjectInteract(object)
		end
	end
end

function br.objectTracker()
	if br.timer:useTimer("Tracker Lag", 0.07) then
		LibDraw.clearCanvas()
		if isChecked("Enable Tracker") then
			for i = 1, GetObjectCountBR() do
				local object = GetObjectWithIndex(i)
				local name = ObjectName(object)
				local objectid = ObjectID(object)
				-- Horrific Vision - Chests
				if isChecked("Chest Tracker") then
					if string.match(strupper(name),strupper("cache")) or string.match(strupper(name),strupper("chest")) then
						trackObject(object,name,objectid)
					end
				end
				-- Horrific Vision - Potions
				if isChecked("Potions Tracker") then
					--[[ local badpot = {"Blank","Red","Black","Green","Blue","Purple"} ]]
					if br.lists.visions == nil then Print("Visions doesnt exists") end
					for _,v in pairs(br.lists.visions) do
						if v == objectid then
							trackObject(object,name,objectid)
						end
					end
				end
				-- Horrific Vision - Odd Crystals
				if isChecked("Odd Crystal Tracker") then
					if objectid >= 341367 and objectid < 341377 then
						trackObject(object,name,objectid)
					end
				end
				-- Horrific Vision - Mailboxes
				if isChecked("Mailbox Tracker") then
					if (objectid == 326974 or objectid == 325080 or objectid == 326924 or objectid == 326755 or objectid == 327053) then
						local interactable = ObjectDescriptor(object, GetOffset("CGGameObjectData__Flags"), "int") == 32
						if interactable then
							trackObject(object,name,objectid)
						end
					end
				end
				-- Horrific Visions - Bonus NPCs
				if isChecked("Bonus NPC Tracker") then
					-- Stormwind
					if objectid == 161293 -- Neglected Guild Bank
						or objectid == 157700 -- Agustus Moulaine
						or objectid == 160404 -- Angry Bear Rug Spirit
						or objectid == 161324 -- Experimental Buff Mine
					then
						trackObject(object,name,objectid,false)
					end
					-- Orgrimmar
					if objectid == 158588 -- Gamon (Pool ol' Gamon)
						or objectid == 158565 -- Naros
						or objectid == 161140 -- Bwemba
						or objectid == 161198 -- Warpweaver Dushar
					then
						trackObject(object,name,objectid,false)
					end
				end
				-- Custom Tracker
				if isChecked("Custom Tracker") then
					if getOptionValue("Custom Tracker") ~= "" and string.len(getOptionValue("Custom Tracker")) >= 3 and string.match(strupper(name),strupper(getOptionValue("Custom Tracker"))) then
						trackObject(object,name,objectid)
					end
				end
			end
		end
	end
end