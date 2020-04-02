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

local blacklistPotion = 0
local function findBlacklistPotion(object)
	if blacklistPotion == 0 and br.data.blacklistVisionPotion ~= 0 then blacklistPotion = br.data.blacklistVisionPotion end
	-- Find Note
	if object.type == "note" and blacklistPotion == 0 then
		local nearestPotion
		local potionRange = 99
		local potionName = ""
		-- Find Nearest Potion To Note
		for _,potion in pairs(br.objects) do
			if potion.type == "potion" then
				local thisDistance = GetDistanceBetweenObjects(object.object,potion.object) or 99
				if thisDistance < potionRange and thisDistance < 5 then
					nearestPotion = ObjectID(potion.object) or 0
					potionRange = thisDistance
					potionName = potion.name
				end
			end
		end
		-- Blacklist Nearest Potion To Note
		if nearestPotion ~= nil and nearestPotion ~= 0 then
			Print("Blacklisted Potion: "..potionName.." - "..nearestPotion)
			blacklistPotion = nearestPotion
			br.data.blacklistVisionPotion = blacklistPotion
		end
	end
end

local function storeChestNotInList(object)
	if object.type == "chest" and br.data.chests ~= nil and br.data.chests[object.object] == nil then
		local chestIDFound = false
		for i = 1, #br.lists.horrificVision.chest do
			if br.lists.horrificVision.chest[i] == object.id then
				chestIDFound = true
				break
			end
		end
		if not chestIDFound then br.data.chests[object.object] = object end
	end
end

function br.objectTracker()
	-- Track Objects
	if br.timer:useTimer("Tracker Lag", 0.07) then
		LibDraw.clearCanvas()
		if isChecked("Enable Tracker") then
			-- Horrific Vision - Objects Managed from OM from br.lists.horrificVisions and placed in br.objects when detected
			local instanceID = IsInInstance() and select(8,GetInstanceInfo()) or 0
			-- Reset Horrific Vision Potion Blacklist out of instance
			if not IsInInstance() and blacklistPotion ~= 0 then blacklistPotion = 0; br.data.blacklistVisionPotion = 0 end
			-- Horrific Vision Trackers
			if instanceID == 2212 -- Orgrimmar
				or instanceID == 2213 -- Stormwind
			then
				if br.objects ~= nil then
					for _, object in pairs(br.objects) do
						local objVisible = ObjectIsVisible(object.object)
						local objExists = ObjectExists(object.object)
						-- Remove Old Objects
						if (not objVisible or not objExists) and br.objects[object.object] ~= nil then
							br.objects[object.object] = nil
							break
						end
						-- Horrific Vision - Notes
						if isChecked("Potions Tracker") and object.type == "note" and blacklistPotion == 0 then
							findBlacklistPotion(object)
						end
						-- Horrific Vision - Chests / Odd Crystals / Bonus NPCs / Potions
						if objVisible and objExists
							and ((isChecked("Chest Tracker") and object.type == "chest")
							or (isChecked("Odd Crystal Tracker") and object.type == "oddCrystal")
							or (isChecked("Bonus NPC Tracker") and object.type == "npc")
							or (isChecked("Mailbox Tracker") and object.type == "mailbox" and ObjectDescriptor(object.object, GetOffset("CGGameObjectData__Flags"), "int") == 32)
							or (isChecked("Potions Tracker") and object.type == "potion" and blacklistPotion ~= 0 and object.id ~= blacklistPotion))
						then
							-- Store Chest ID not Found in List
							storeChestNotInList(object)
							-- Track Objects
							if object.type == "npc" then
								trackObject(object.object,object.name,object.id,false)
							else
								trackObject(object.object,object.name,object.id)
							end
						end
					end
				end
			end
			-- Custom Tracker
			if isChecked("Custom Tracker") and getOptionValue("Custom Tracker") ~= "" and string.len(getOptionValue("Custom Tracker")) >= 3 then
				for i = 1, GetObjectCountBR() do
					local object = GetObjectWithIndex(i)
					local name = ObjectName(object)
					local objectid = ObjectID(object)
					for k in string.gmatch(tostring(getOptionValue("Custom Tracker")),"([^,]+)") do
						if string.len(string.trim(k)) >= 3 and strmatch(strupper(name),strupper(string.trim(k))) then
							trackObject(object,name,objectid)
						end
					end
				end
			end
		end
	end
end