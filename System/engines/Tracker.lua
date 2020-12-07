local trackerFrame = CreateFrame("Frame")
local drawInterval = 0.006
DrawTargets = {}
local magicScale = 5/256
trackerFrame:SetScript("OnUpdate", function(...)
	if br.data.settings == nil then return end
	if br.data.settings[br.selectedSpec] == nil then return end
	if br.data.settings[br.selectedSpec].toggles == nil then return end
	if br.data.settings[br.selectedSpec].toggles["Power"] ~= nil and br.data.settings[br.selectedSpec].toggles["Power"] ~= 0 and getOptionValue("Enable Tracker") == 2 then
		if not GetWoWWindow then return end -- a
		local sWidth, sHeight = GetWoWWindow()
		for guid, target in pairs(DrawTargets) do
			local object = target["obj"]
			local text = target["text"]
			local pX,pY,pZ = ObjectPosition("player")
			local oX,oY,oZ = ObjectPosition(object)
			local isNull = false
			if not (oX and oY and oZ and pX and pY and pZ) then
				isNull = true
			end
			if isNull then
				DrawTargets[guid] = nil
			end
			if object ~= nil and not isNull then
				local p2dX, p2dY, _ = WorldToScreenRaw(pX, pY, pZ)
				local o2dX, o2dY, oFront = WorldToScreenRaw(oX, oY, oZ)
				if oFront then
					if isChecked("Draw Lines to Tracked Objects") then
						if not (p2dX > sWidth or p2dX < 0 or p2dY > sHeight or p2dY < 0) then
							SetDrawColor(0, 1, 0, 1)
							Draw2DLine(p2dX * sWidth, p2dY * sHeight, o2dX * sWidth, o2dY * sHeight, 4)
						end
					end
					Draw2DText(o2dX * sWidth - (sWidth * magicScale), o2dY * sHeight - (sHeight * (magicScale * 1/2)), text, 24)
				end
			end
		end
	end
end)

local function trackObject(object,name,objectid,interact)
	local xOb, yOb, zOb = ObjectPosition(object)
	local pX,pY,pZ = ObjectPosition("player")
	local cX, cY, cZ = GetCameraPosition()
	if interact == nil then interact = true end
	local playerDistance = GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb)
	local cameraDistance = GetDistanceBetweenPositions(cX, cY, cZ, xOb, yOb, zOb)
	if playerDistance <= cameraDistance then
		if xOb ~= nil and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) < 200 then
			--LibDraw.Circle(xOb,yOb,zOb, 2)
			if name == "" or name == "Unknown" then name = ObjectName(object) end
			if getOptionValue("Enable Tracker") == 2 then
				local text = name .. " " .. objectid
				DrawTargets[ObjectGUID(object)] = {obj=object, text=text}
			else
				LibDraw.Text(name.." "..objectid,"GameFontNormal",xOb,yOb,zOb+3)
				if isChecked("Draw Lines to Tracked Objects") then
					LibDraw.Line(pX,pY,pZ,xOb,yOb,zOb)
				end
			end
			if isChecked("Auto Interact with Any Tracked Object") and interact and not br.player.inCombat
				and GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <= 7 and not isUnitCasting("player") and not isMoving("player") and br.timer:useTimer("Interact Delay", 1.5)
			then
				ObjectInteract(object)
			end
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
	DrawTargets = {}
	if (br.timer:useTimer("Tracker Lag", 0.07) or (isChecked("Quest Tracker") and br.timer:useTimer("Quest Lag", 0.5))) then
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
						if isChecked("Potions Tracker") and getOptionValue("Potions Tracker") == 1 and (object.type == "note" or br.data.blacklistVisionPotion ~= 0) and blacklistPotion == 0 then
							findBlacklistPotion(object)
						end
						-- Horrific Vision - Chests / Odd Crystals / Bonus NPCs / Potions
						if objVisible and objExists
							and ((isChecked("Chest Tracker") and object.type == "chest")
							or (isChecked("Odd Crystal Tracker") and object.type == "oddCrystal")
							or (isChecked("Bonus NPC Tracker") and object.type == "npc")
							or (isChecked("Mailbox Tracker") and object.type == "mailbox" and ObjectDescriptor(object.object, GetOffset("CGGameObjectData__Flags"), "int") == 32)
							or (isChecked("Potions Tracker") and object.type == "potion" and ((blacklistPotion ~= 0 and object.id ~= blacklistPotion) or getOptionValue("Potions Tracker") == 2)))
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
			if (isChecked("Custom Tracker") and getOptionValue("Custom Tracker") ~= "" and string.len(getOptionValue("Custom Tracker")) >= 3) or isChecked("Rare Tracker") or isChecked("Quest Tracker") then
				for i = 1, GetObjectCountBR() do
					local object = GetObjectWithIndex(i)
					local name = ObjectName(object)
					local objectid = ObjectID(object)
					if isChecked("Rare Tracker") and not UnitIsDeadOrGhost(object) and (UnitClassification(object) == "rare" or UnitClassification(object) == "rareelite") then
						trackObject(object,name,objectid,false)
					end
					if isChecked("Custom Tracker") then
						for k in string.gmatch(tostring(getOptionValue("Custom Tracker")),"([^,]+)") do
							if string.len(string.trim(k)) >= 3 and strmatch(strupper(name),strupper(string.trim(k))) then
								trackObject(object,name,objectid)
							end
						end
					end
					if isChecked("Quest Tracker") and not isInCombat("player") then
						local ignoreList = {
							[159784] = true, -- Wastewander Laborer
							[159804] = true, -- Wastewander Tracker
							[159803] = true, -- Wastewander Warrior
							[162605] = true, -- Aqir Larva
							[156079] = true, -- Blood Font
						}
						if (getOptionValue("Quest Tracker") == 1 or getOptionValue("Quest Tracker") == 3) and ObjectIsUnit(object) and isQuestUnit(object) and (not UnitIsDeadOrGhost(object) or ignoreList[objectid] ~= nil or CanLootUnit(object)) and not UnitIsTapDenied(object) then
							if ignoreList[objectid] ~= nil then
								trackObject(object,name,objectid)
							else
								trackObject(object,name,objectid,false)
							end
						end
						if (getOptionValue("Quest Tracker") == 2 or getOptionValue("Quest Tracker") == 3) and isQuestObject(object) and not ObjectIsUnit(object) then
							trackObject(object,name,objectid)
						end
					end
				end
			end
		end
	end
end
