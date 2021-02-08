local _, br = ...
local LibDraw = _G["LibDraw"]
local trackerFrame = _G.CreateFrame("Frame")
local drawInterval = 0.006
br.DrawTargets = {}
local magicScale = 5/256
trackerFrame:SetScript("OnUpdate", function(...)
	if br.data.settings == nil then return end
	if br.data.settings[br.selectedSpec] == nil then return end
	if br.data.settings[br.selectedSpec].toggles == nil then return end
	if br.data.settings[br.selectedSpec].toggles["Power"] ~= nil and br.data.settings[br.selectedSpec].toggles["Power"] ~= 0 and br.getOptionValue("Enable Tracker") == 2 then
		if not br._G.GetWoWWindow then return end -- a
		local sWidth, sHeight = br._G.GetWoWWindow()
		for guid, target in pairs(br.DrawTargets) do
			local object = target["obj"]
			local text = target["text"]
			local pX,pY,pZ = br._G.ObjectPosition("player")
			local oX,oY,oZ = br._G.ObjectPosition(object)
			local isNull = false
			if not (oX and oY and oZ and pX and pY and pZ) then
				isNull = true
			end
			if isNull then
				br.DrawTargets[guid] = nil
			end
			if object ~= nil and not isNull then
				local p2dX, p2dY, _ = br._G.WorldToScreenRaw(pX, pY, pZ)
				local o2dX, o2dY, oFront = br._G.WorldToScreenRaw(oX, oY, oZ)
				if oFront then
					if br.isChecked("Draw Lines to Tracked Objects") then
						if not (p2dX > sWidth or p2dX < 0 or p2dY > sHeight or p2dY < 0) then
							if br._G.TraceLine(oX, oY, oZ, pX,pY,pZ, 0x10) == nil then
								_G.SetDrawColor(0, 1, 0, 1)
							else
								_G.SetDrawColor(1,0,0,1)
							end
							br._G.Draw2DLine(p2dX * sWidth, p2dY * sHeight, o2dX * sWidth, o2dY * sHeight, 4)
						end
					end
					br._G.Draw2DText(o2dX * sWidth - (sWidth * magicScale), o2dY * sHeight - (sHeight * (magicScale * 1/2)), text, 24)
				end
			end
		end
	end
end)

local function trackObject(object,name,objectid,interact)
	local xOb, yOb, zOb = br._G.ObjectPosition(object)
	local pX,pY,pZ = br._G.ObjectPosition("player")
	local cX, cY, cZ = br._G.GetCameraPosition()
	if interact == nil then interact = true end
	local playerDistance = br._G.GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb)
	local cameraDistance = br._G.GetDistanceBetweenPositions(cX, cY, cZ, xOb, yOb, zOb)
	local zDifference = math.floor(zOb - pZ)
	if xOb ~= nil and br._G.GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) < 200 then
		--LibDraw.Circle(xOb,yOb,zOb, 2)
		if name == "" or name == "Unknown" then name = br._G.ObjectName(object) end
		if br.getOptionValue("Enable Tracker") == 2 then
			if playerDistance <= cameraDistance then
				local text = name .. " " .. objectid.. " ZDiff: "..zDifference
				br.DrawTargets[br._G.ObjectGUID(object)] = {obj=object, text=text}
			end
		else
			if math.abs(zDifference) > 50 then
				LibDraw.SetColor(255,0,0,100)
			else
			   LibDraw.SetColor(0,255,0,100)
			end
			LibDraw.Text(name .. " " .. objectid.. " ZDiff: "..zDifference,"GameFontNormal",xOb,yOb,zOb+3)
			if br.isChecked("Draw Lines to Tracked Objects") then
				LibDraw.Line(pX,pY,pZ,xOb,yOb,zOb)
			end
		end
		if br.isChecked("Auto Interact with Any Tracked Object") and interact and not br.player.inCombat
			and br._G.GetDistanceBetweenPositions(pX,pY,pZ,xOb,yOb,zOb) <= 7 and not br.isUnitCasting("player") and not br.isMoving("player") and br.timer:useTimer("Interact Delay", 1.5)
		then
			br._G.ObjectInteract(object)
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
				local thisDistance = br._G.GetDistanceBetweenObjects(object.object,potion.object) or 99
				if thisDistance < potionRange and thisDistance < 5 then
					nearestPotion = br._G.ObjectID(potion.object) or 0
					potionRange = thisDistance
					potionName = potion.name
				end
			end
		end
		-- Blacklist Nearest Potion To Note
		if nearestPotion ~= nil and nearestPotion ~= 0 then
			br._G.print("Blacklisted Potion: "..potionName.." - "..nearestPotion)
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
	br.DrawTargets = {}
	if (br.timer:useTimer("Tracker Lag", 0.07) or (br.isChecked("Quest Tracker") and br.timer:useTimer("Quest Lag", 0.5))) then
		LibDraw.clearCanvas()
		if br.isChecked("Enable Tracker") then
			for i = 1, #br.om do
				if br._G.UnitCanAttack( "player",br.om[i].unit) then
					local pX,pY,pZ = br._G.ObjectPosition("player")
					local oX,oY,oZ = br._G.ObjectPosition(br.om[i].unit)
					local isNull = false
					if not (oX and oY and oZ and pX and pY and pZ) then
						isNull = true
					end
					if not isNull then
						-- if br.isChecked("Draw Lines to Tracked Objects") then
							-- if not (p2dX > sWidth or p2dX < 0 or p2dY > sHeight or p2dY < 0) then
							-- 	if TraceLine(xOb, yOb, zOb, pX,pY,pZ, 0x10) == nil then
							-- 		SetDrawColor(0, 1, 0, 1)
							-- 	else
							LibDraw.SetColor(0,255,0,100)
								-- end
								LibDraw.Line(pX,pY,pZ,oX,oY,oZ)
							-- end
						-- end
						-- Draw2DText(o2dX * sWidth - (sWidth * magicScale), o2dY * sHeight - (sHeight * (magicScale * 1/2)), text, 24)
					end
				end
			end
			-- Horrific Vision - Objects Managed from OM from br.lists.horrificVisions and placed in br.objects when detected
			local instanceID = _G.IsInInstance() and select(8,_G.GetInstanceInfo()) or 0
			-- Reset Horrific Vision Potion Blacklist out of instance
			if not _G.IsInInstance() and blacklistPotion ~= 0 then blacklistPotion = 0; br.data.blacklistVisionPotion = 0 end
			-- Horrific Vision Trackers
			if instanceID == 2212 -- Orgrimmar
				or instanceID == 2213 -- Stormwind
			then
				if br.objects ~= nil then
					for _, object in pairs(br.objects) do
						local objVisible = br._G.ObjectIsVisible(object.object)
						local objExists = br.GetObjectExists(object.object)
						-- Remove Old Objects
						if (not objVisible or not objExists) and br.objects[object.object] ~= nil then
							br.objects[object.object] = nil
							break
						end
						-- Horrific Vision - Notes
						if br.isChecked("Potions Tracker") and br.getOptionValue("Potions Tracker") == 1 and (object.type == "note" or br.data.blacklistVisionPotion ~= 0) and blacklistPotion == 0 then
							findBlacklistPotion(object)
						end
						-- Horrific Vision - Chests / Odd Crystals / Bonus NPCs / Potions
						if objVisible and objExists
							and ((br.isChecked("Chest Tracker") and object.type == "chest")
							or (br.isChecked("Odd Crystal Tracker") and object.type == "oddCrystal")
							or (br.isChecked("Bonus NPC Tracker") and object.type == "npc")
							or (br.isChecked("Mailbox Tracker") and object.type == "mailbox" and br._G.ObjectDescriptor(object.object, br._G.GetOffset("CGGameObjectData__Flags"), "int") == 32)
							or (br.isChecked("Potions Tracker") and object.type == "potion" and ((blacklistPotion ~= 0 and object.id ~= blacklistPotion) or br.getOptionValue("Potions Tracker") == 2)))
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
			if (br.isChecked("Custom Tracker") and br.getOptionValue("Custom Tracker") ~= "" and string.len(br.getOptionValue("Custom Tracker")) >= 3) or br.isChecked("Rare Tracker") or br.isChecked("Quest Tracker") then
				for i = 1, br._G.GetObjectCount() do
					local object = br._G.GetObjectWithIndex(i)
					local name = br._G.ObjectName(object)
					local objectid = br._G.ObjectID(object)
					if br.isChecked("Rare Tracker") and not br.GetUnitIsDeadOrGhost(object) and (br._G.UnitClassification(object) == "rare" or br._G.UnitClassification(object) == "rareelite") then
						trackObject(object,name,objectid,false)
					end
					if br.isChecked("Custom Tracker") then
						for k in string.gmatch(tostring(br.getOptionValue("Custom Tracker")),"([^,]+)") do
							if string.len(_G.string.trim(k)) >= 3 and _G.strmatch(_G.strupper(name),_G.strupper(_G.string.trim(k))) then
								trackObject(object,name,objectid)
							end
						end
					end
					if br.isChecked("Quest Tracker") and not br.isInCombat("player") and not _G.IsInInstance() then
						local ignoreList = {
							[36756] = true, -- Dead Soldier (Azshara)
							[36922] = true, -- Wounded Soldier (Azshara)
							[159784] = true, -- Wastewander Laborer
							[159804] = true, -- Wastewander Tracker
							[159803] = true, -- Wastewander Warrior
							[162605] = true, -- Aqir Larva
							[156079] = true, -- Blood Font
						}
						if (br.getOptionValue("Quest Tracker") == 1 or br.getOptionValue("Quest Tracker") == 3) and br._G.ObjectIsUnit(object) and br.isQuestUnit(object) and  not br._G.UnitIsTapDenied(object) then
							if ignoreList[objectid] ~= nil then
								trackObject(object,name,objectid)
							else
								trackObject(object,name,objectid,false)
							end
						end
						if (br.getOptionValue("Quest Tracker") == 2 or br.getOptionValue("Quest Tracker") == 3) and br.isQuestObject(object) and not br._G.ObjectIsUnit(object) then
							trackObject(object,name,objectid)
						end
					end
				end
			end
		end
	end
end
