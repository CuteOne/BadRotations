local _, br = ...
local LibDraw = LibStub("LibDraw-BR")

local function trackObject(object, name, objectid, interact)
    local xOb, yOb, zOb = br._G.ObjectPosition(object)
    local pX, pY, pZ = br._G.ObjectPosition("player")
    if interact == nil then
        interact = true
    end
    local playerDistance = br._G.GetDistanceBetweenPositions(pX, pY, pZ, xOb, yOb, zOb)
    local zDifference = math.floor(zOb - pZ)
    if xOb ~= nil and playerDistance < 200 then
        --LibDraw.Circle(xOb, yOb, zOb, 2)
        if br._G.ObjectIsUnit(object) then
            LibDraw.Arrow(xOb, yOb, zOb, br._G.UnitFacing(object) + math.pi * 2)
        else
            LibDraw.Arrow(xOb, yOb, zOb, br._G.UnitFacing("player") + math.pi * 2)
        end
        if name == "" or name == "Unknown" then
            name = br._G.ObjectIsUnit(object) and br._G.UnitName(object) or nil
        end
        if math.abs(zDifference) > 50 then
            LibDraw.SetColor(255, 0, 0, 100)
        else
            LibDraw.SetColor(0, 255, 0, 100)
        end
        LibDraw.Text(name .. " " .. objectid .. " ZDiff: " .. zDifference, "GameFontNormal", xOb, yOb, zOb + 3)
        if br.isChecked("Draw Lines to Tracked Objects") then
            LibDraw.Line(pX, pY, pZ, xOb, yOb, zOb)
        end
        if br.isChecked("Auto Interact with Any Tracked Object") and interact and not br.player.inCombat and
            playerDistance <= 7 and not br.isUnitCasting("player") and not br.isMoving("player") and
            br.timer:useTimer("Interact Delay", 1.5) then
            br._G.ObjectInteract(object)
        end
    end
end

function br.objectTracker()
    -- Track Objects
    if --(br.timer:useTimer("Tracker Lag", 0.07) or
        (br.isChecked("Quest Tracker") --[[and br.timer:useTimer("Quest Lag", 0.5))]]) then
        LibDraw.clearCanvas()
        if br.isChecked("Enable Tracker") then
            -- Custom Tracker
            if (br.isChecked("Custom Tracker") and br.getOptionValue("Custom Tracker") ~= "" and
                string.len(br.getOptionValue("Custom Tracker")) >= 3) or br.isChecked("Rare Tracker") or
                br.isChecked("Quest Tracker")
            then
                for i = 1, br._G.GetObjectCount() do
                    local object = br._G.GetObjectWithIndex(i)
                    if object ~= nil then
                        local name =  br._G.ObjectIsUnit(object) and br._G.UnitName(object) or br._G.ObjectName(object)
                        local objectid = br._G.ObjectID(object)
                        if object and name and objectid then
                            if br.isChecked("Rare Tracker") and not br.GetUnitIsDeadOrGhost(object) and
                                (br._G.UnitClassification(object) == "rare" or br._G.UnitClassification(object) == "rareelite")
                            then
                                trackObject(object, name, objectid, false)
                            end
                            if br.isChecked("Custom Tracker") then
                                for k in string.gmatch(tostring(br.getOptionValue("Custom Tracker")), "([^,]+)") do
                                    if string.len(_G.string.trim(k)) >= 3 and
                                        _G.strmatch(_G.strupper(name), _G.strupper(_G.string.trim(k)))
                                    then
                                        trackObject(object, name, objectid)
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
                                    [156079] = true -- Blood Font
                                }
                                if (br.getOptionValue("Quest Tracker") == 1 or br.getOptionValue("Quest Tracker") == 3) and
                                    br._G.ObjectIsUnit(object) and br.isQuestUnit(object) and
                                    not br._G.UnitIsTapDenied(object)
                                then
                                    if ignoreList[objectid] ~= nil then
                                        trackObject(object, name, objectid)
                                    else
                                        trackObject(object, name, objectid, false)
                                    end
                                end
                                if (br.getOptionValue("Quest Tracker") == 2 or br.getOptionValue("Quest Tracker") == 3) and
                                    not br._G.ObjectIsUnit(object) and br.isQuestObject(object)
                                then
                                    trackObject(object, name, objectid)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
