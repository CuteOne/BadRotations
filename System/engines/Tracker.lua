local _, br = ...
local LibDraw = br._G.LibStub("LibDraw-BR")
local tracking = false
local interactTime


local function getCastTime(unit)
	if br._G.UnitCastingInfo(unit) ~= nil then
		return select(5,br._G.UnitCastingInfo(unit))/1000 - br._G.GetTime()
	elseif br._G.UnitChannelInfo(unit) ~= nil then
		return select(5,br._G.UnitChannelInfo(unit))/1000 - br._G.GetTime()
	else
		return 0
	end
end
local function isInteracting(unit)
    local time = br._G.GetTime()
    if interactTime == nil then interactTime = 0 end
    local castTime = getCastTime(unit)
    if castTime > 0 and interactTime == 0 then
        interactTime = time + castTime + 1
    end
    if castTime == 0 and interactTime < time then interactTime = 0 end
    return interactTime > time
end

local function trackObject(object, name, objectid, objectguid, interact)
    local xOb, yOb, zOb = br._G.ObjectPosition(object)
    local pX, pY, pZ = br._G.ObjectPosition("player")
    if interact == nil then
        interact = true
    end
    local playerDistance = br._G.GetDistanceBetweenPositions(pX, pY, pZ, xOb, yOb, zOb)
    local zDifference = math.floor(zOb - pZ)
    if xOb ~= nil and playerDistance < 200 then
        if math.abs(zDifference) > 50 then
            LibDraw.SetColor(255, 0, 0, 100)
        else
            LibDraw.SetColor(0, 255, 0, 100)
        end
        LibDraw.Circle(xOb, yOb, zOb, 2)
        if br._G.ObjectIsUnit(object) then
            LibDraw.Arrow(xOb, yOb, zOb, br._G.UnitFacing(object) + math.pi * 2)
        else
            LibDraw.Arrow(xOb, yOb, zOb, br._G.UnitFacing("player") + math.pi * 2)
        end
        if name == "" or name == "Unknown" then
            name = br._G.ObjectIsUnit(object) and br._G.UnitName(object) or nil
        end
		if br.isChecked("Display Extra Info") then
			name = name .. "  [" .. objectid .. "] " .. "\n" .. objectguid .. "  [ZDiff: " .. zDifference.."]"
		end
		LibDraw.Text(name, "GameFontNormal", xOb, yOb, zOb + 3)
        if br.isChecked("Draw Lines to Tracked Objects") then
			if math.abs(zDifference) > 50 then
				LibDraw.SetColor(255, 0, 0, 80)
			else
				LibDraw.SetColor(0, 255, 0, 80)
			end
            LibDraw.Line(pX, pY, pZ, xOb, yOb, zOb)
        end
        -- local hasLoot = br._G.CanLootUnit(objectguid)
        -- local interacting = isInteracting("player")
        if br.isChecked("Auto Interact with Any Tracked Object") and interact and not br.player.inCombat
            and playerDistance <= 7 and not br.isUnitCasting("player") and not br.isMoving("player")
            and (not isInteracting("player") or br._G.CanLootUnit(objectguid))--and br.timer:useTimer("Interact Delay", 1.5)
        then
            br._G.ObjectInteract(object)
        end
        tracking = true
    end
end

_G.string.trim = function(string)
    local from = string:match"^%s*()"
   return from > #string and "" or string:match(".*%S", from)
end

function br.objectTracker()
    if br.isChecked("Enable Tracker") then
        LibDraw:clearCanvas()
        -- Custom Tracker
        if (br.isChecked("Custom Tracker") and br.getOptionValue("Custom Tracker") ~= "" and
            string.len(br.getOptionValue("Custom Tracker")) >= 3) or br.isChecked("Rare Tracker") or
            br.isChecked("Quest Tracker")
        then
            local objUnit
            local name
            local objectid
            local objectguid
            for i = 1, br._G.GetObjectCount() do
                local object = br._G.GetObjectWithIndex(i)
                if object ~= nil and br._G.ObjectExists(object)
                    and ((br._G.ObjectIsUnit(object) and br._G.UnitIsVisible(object) and not br.GetUnitIsDeadOrGhost(object)) or not br._G.ObjectIsUnit(object))
                then
                    objUnit = br._G.ObjectIsUnit(object)
                    name = objUnit and br._G.UnitName(object) or br._G.ObjectName(object)
                    objectid = br._G.ObjectID(object)
                    objectguid = br._G.UnitGUID(object)
                    if object and name and objectid and objectguid then
                        if br.isChecked("Rare Tracker") then
                            if br._G.UnitClassification(object) == "rare" then
                                trackObject(object, "(r) "..name, objectid, objectguid, false)
                            end
                            if br._G.UnitClassification(object) == "rareelite" then
                                trackObject(object, "(r*) "..name, objectid, objectguid, false)
                            end
                        end
                        if br.isChecked("Custom Tracker") then
                            for k in string.gmatch(tostring(br.getOptionValue("Custom Tracker")), "([^,]+)") do
                                if string.len(_G.string.trim(k)) >= 3 and
                                    br._G.strmatch(br._G.strupper(name), br._G.strupper(_G.string.trim(k)))
                                then
                                    trackObject(object, name, objectid, objectguid)
                                end
                            end
                        end
                        if br.isChecked("Quest Tracker") and not br.isInCombat("player") and not br._G.IsInInstance() then
                            local ignoreList = {
                                [36756] = true, -- Dead Soldier (Azshara)
                                [36922] = true, -- Wounded Soldier (Azshara)
                                [159784] = true, -- Wastewander Laborer
                                [159804] = true, -- Wastewander Tracker
                                [159803] = true, -- Wastewander Warrior
                                [162605] = true, -- Aqir Larva
                                [156079] = true -- Blood Font
                            }
                            if (br.getOptionValue("Quest Tracker") == 1 or br.getOptionValue("Quest Tracker") == 3) and
                                objUnit and br.isQuestUnit(object) and not br._G.UnitIsTapDenied(object)
                            then
                                if ignoreList[objectid] ~= nil or (select(2, br._G.CanLootUnit(object)) and br.getItemGlow(object)) then
                                    trackObject(object, name, objectid, objectguid)
                                else
                                    trackObject(object, name, objectid, objectguid, false)
                                end
                            end
                            if (br.getOptionValue("Quest Tracker") == 2 or br.getOptionValue("Quest Tracker") == 3)
                                and not objUnit and br.isQuestObject(object)
                            then
                                trackObject(object, name, objectid, objectguid)
                            end
                        end
                    end
                end
            end
        end
    elseif tracking then
        LibDraw:clearCanvas()
        tracking = false
    end
end