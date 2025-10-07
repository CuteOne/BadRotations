local _, br = ...
local LibDraw = br._G.LibStub("LibDraw-BR")
br.engines.tracker = br.engines.tracker or {}
local tracker = br.engines.tracker
local tracking = false
local interactTime


local function getCastTime(unit)
    if br._G.UnitCastingInfo(unit) ~= nil then
        return select(5, br._G.UnitCastingInfo(unit)) / 1000 - br._G.GetTime()
    elseif br._G.UnitChannelInfo(unit) ~= nil then
        return select(5, br._G.UnitChannelInfo(unit)) / 1000 - br._G.GetTime()
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

local function trackObject(object, isUnit, name, objectid, objectguid, interact)
    if not br._G.ObjectExists(object) then return end
    local pX, pY, pZ = br._G.ObjectPosition("player")
    local xOb, yOb, zOb = br._G.ObjectPosition(object)
    if zOb == nil then zOb = pZ end
    if zOb == nil then return end
    if interact == nil then
        interact = true
    end
    -- local playerDistance = br._G.GetDistanceBetweenPositions(pX, pY, pZ, xOb, yOb, zOb)
    local zDifference = math.floor(zOb - pZ)
    if xOb ~= nil then --and playerDistance < 200 then
        if math.abs(zDifference) > 50 then
            LibDraw.SetColor(255, 0, 0, 100)
        else
            LibDraw.SetColor(0, 255, 0, 100)
        end
        local Cr = br._G.UnitCombatReach(object)
        if not Cr or Cr == 0 then Cr = 1.5 end
        LibDraw.Circle(xOb, yOb, zOb, Cr)
        if isUnit then
            LibDraw.Arrow(xOb, yOb, zOb, br._G.UnitFacing(object) --[[+ math.pi * 2]], Cr / 2)
        else
            LibDraw.Arrow(xOb, yOb, zOb, br._G.UnitFacing("player") --[[+ math.pi * 2]], Cr / 2)
        end
        -- if name == "" or name == "Unknown" then
        --     name = isUnit and br._G.UnitName(object) or nil
        -- end
        if br.functions.misc:isChecked("Display Extra Info") then
            name = name .. "  [" .. objectid .. "] " .. "\n" .. objectguid .. "  [ZDiff: " .. zDifference .. "]"
        end
        LibDraw.Text(name, "GameFontNormal", xOb, yOb, zOb + 3)
        if br.functions.misc:isChecked("Draw Lines to Tracked Objects") then
            if math.abs(zDifference) > 50 then
                LibDraw.SetColor(255, 0, 0, 80)
            else
                LibDraw.SetColor(0, 255, 0, 80)
            end
            LibDraw.Line(pX, pY, pZ, xOb, yOb, zOb)
        end
        -- local hasLoot = br._G.CanLootUnit(objectguid)
        -- local interacting = isInteracting("player")
        if br.functions.misc:isChecked("Auto Interact with Any Tracked Object") and interact and not br.player.inCombat
            and --[[playerDistance]] br._G.GetDistanceBetweenPositions(pX, pY, pZ, xOb, yOb, zOb) <= 7 and
            not br.functions.cast:isUnitCasting("player") and not br.functions.misc:isMoving("player")
            and (not isInteracting("player") or br._G.CanLootUnit(objectguid)) --and br.debug.timer:useTimer("Interact Delay", 1.5)
        then
            br._G.ObjectInteract(object)
        end
        tracking = true
    end
end

br._G.string.trim = function(string)
    local from = string:match "^%s*()"
    return from > #string and "" or string:match(".*%S", from)
end

br.engines.tracker.tracking = {}
function tracker:objectTracker()
    if br.functions.misc:isChecked("Enable Tracker") then
        LibDraw:clearCanvas()
        -- Custom Tracker
        if (br.functions.misc:isChecked("Custom Tracker") and br.functions.misc:getOptionValue("Custom Tracker") ~= "" and
            string.len(br.functions.misc:getOptionValue("Custom Tracker")) >= 3) or br.functions.misc:isChecked("Rare Tracker") or
            br.functions.misc:isChecked("Quest Tracker")
        then
            local object
            local objUnit
            local name
            local objectid
            local objectguid
            local interact
            local track
            for i = 1, #br.engines.tracker.tracking do
                object = br.engines.tracker.tracking[i].object
                objUnit = br.engines.tracker.tracking[i].unit
                name = br.engines.tracker.tracking[i].name
                objectid = br.engines.tracker.tracking[i].id
                objectguid = br.engines.tracker.tracking[i].guid
                interact = nil
                track = false
                if object and name and objectid and objectguid then
                    if br.functions.misc:isChecked("Rare Tracker") and not track then
                        if br._G.UnitClassification(object) == "rare" then
                            name = "(r) " .. name
                            track = true
                            interact = false
                        end
                        if br._G.UnitClassification(object) == "rareelite" then
                            name = "(r*) " .. name
                            track = true
                            interact = false
                        end
                    end
                    if br.functions.misc:isChecked("Custom Tracker") and not track then
                        for k in string.gmatch(tostring(br.functions.misc:getOptionValue("Custom Tracker")), "([^,]+)") do
                            if string.len(br._G.string.trim(k)) >= 3 and
                                br._G.strmatch(br._G.strupper(name), br._G.strupper(br._G.string.trim(k)))
                            then
                                track = true
                            end
                        end
                    end
                    if br.functions.misc:isChecked("Quest Tracker") and not br.functions.misc:isInCombat("player") and not br._G.IsInInstance() then
                        local ignoreList = {
                            [36756] = true, -- Dead Soldier (Azshara)
                            [36922] = true, -- Wounded Soldier (Azshara)
                            [159784] = true, -- Wastewander Laborer
                            [159804] = true, -- Wastewander Tracker
                            [159803] = true, -- Wastewander Warrior
                            [162605] = true, -- Aqir Larva
                            [156079] = true -- Blood Font
                        }
                        if (br.functions.misc:getOptionValue("Quest Tracker") == 1 or br.functions.misc:getOptionValue("Quest Tracker") == 3) and
                            object ~= nil and
                            objUnit and br.engines.questTracker:isQuestUnit(object) and not br._G.UnitIsTapDenied(object)
                        then

                            if object and br.functions.unit:GetObjectExists(object) and (ignoreList[objectid] ~= nil or
                                (select(2, br._G.CanLootUnit(br._G.UnitGUID(object))) and br.functions.misc:getItemGlow(object))) then
                                track = true
                            else
                                interact = false
                                track = true
                            end
                        end
                        if (br.functions.misc:getOptionValue("Quest Tracker") == 2 or br.functions.misc:getOptionValue("Quest Tracker") == 3)
                            and not objUnit and br.engines.questTracker:isQuestObject(object)
                        then
                            track = true
                        end
                    end
                    -- Track
                    if track then trackObject(object, objUnit, name, objectid, objectguid, interact) end
                end
            end
        end
    elseif tracking then
        LibDraw:clearCanvas()
        tracking = false
    end
end
