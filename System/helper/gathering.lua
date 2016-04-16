-- Global helper table
bb.helper = {}

-- Contains all possible gathering nodes
-- TODO: event -> +level => re-check if new node is possible to gather
bb.helper.gatherNodes = {}
bb.helper.objectNodes = {}
bb.helper.unitNodes    = {}

-- Locals
local wipe = wipe

--- Check for possible gather nodes
--  checks if profession is active and which level to insert the possible nodes
function bb.helper:getPossibleNodes()
    -- Wiping table to clean them up
    wipe(self.gatherNodes)
    wipe(self.objectNodes)
    wipe(self.unitNodes)
    -- Mining
    bb.helper:getMiningNodes()
    -- Herbs
    bb.helper:getHerbalismNodes()
    -- Objects
    bb.helper:getObjectNodes()
    -- Units
    bb.helper:getUnitNodes()
end

--- Checks global table which contain gatherable node and trys to gather them
--  Check the name of the node => only english locale
function bb.helper:startGathering()
    local nrObjects = GetObjectCount()
    bb.helper.deposits = {}

    if not UnitAffectingCombat("player") and UnitCastingInfo("player") == nil and not isLooting() then

        for i=1, nrObjects do
            -- Locals
            local thisObject = GetObjectWithIndex(i)

            -- Check if object is a GameObject
            if (#self.gatherNodes > 0 or #self.objectNodes > 0) and ObjectIsType(thisObject, ObjectTypes.GameObject) then

                -- Profession gathering, check if can gather
                if not isMoving("player") and not IsFlying() then
                    -- Locals
                    local guid = UnitGUID(thisObject)
                    local objectName = ObjectName(thisObject)
                    local objectType, _, _, _, _, objectID, _ = strsplit("-", guid)
                    objectID = tonumber(objectID)

                    if #self.gatherNodes > 0 then
                        -- Check if ObjectID or ObjectName is within the gathering table
                        if tContains(self.gatherNodes, objectName) or tContains(self.gatherNodes, objectID) then
                            --tinsert(bb.helper.deposits, {guid, objectName})
                            if GetDistanceBetweenObjects("player", thisObject) < 6 then
                                ObjectInteract(thisObject)
                                return
                            end
                        end
                    end
                    -- Object gathering/clicking
                    if #self.objectNodes > 0 then
                        for j=1,#self.objectNodes do
                            if (self.objectNodes[j][1] == objectName) or (self.objectNodes[j][1] == objectID) then
                                --tinsert(bb.helper.deposits, {guid, objectName})
                                if GetDistanceBetweenObjects("player", thisObject) < self.objectNodes[j][2] then
                                    ObjectInteract(thisObject)
                                    return
                                end
                            end
                        end
                    end
                end
            -- Checking for Units as some quests objects etc. are declared as NPC
            elseif #self.unitNodes > 0 and ObjectIsType(thisObject, ObjectTypes.Unit) then
                if not isMoving("player") and not IsFlying() then
                    -- Locals
                    local guid = UnitGUID(thisObject)
                    local objectName = ObjectName(thisObject)
                    local objectType, _, _, _, _, objectID, _ = strsplit("-", guid)
                    objectID = tonumber(objectID)

                    for j=1,#self.unitNodes do
                        if (self.unitNodes[j][1] == objectName) or (self.unitNodes[j][1] == objectID) then
                            --tinsert(bb.helper.deposits, {guid, objectName})
                            if GetDistanceBetweenObjects("player", thisObject) < self.unitNodes[j][2] then
                                ObjectInteract(thisObject)
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end

--- Prints the ObjectID of a given name
--  Helps to identify the objectID of things which have no tooltip
--  name - the name of the object
--  nearestObject - if true, it will sort and displays distance to the nearest given object
--  Use:
--  /run bb.helper:getObjectID(GameTooltipTextLeft1:GetText())
--  to get the GameObject ID of the object the tootlip is displayed, usallly the mouseover
function bb.helper:getObjectID(name, nearestObject)
    local nrObjects = GetObjectCount()
    local nearest = {
        objName,
        objID,
        objDistance = 999,
        objType,
    }
    local tmpDistance

    for i=1, nrObjects do
        -- Locals
        local thisObject = GetObjectWithIndex(i)

        if ObjectIsType(thisObject, ObjectTypes.Unit) or ObjectIsType(thisObject, ObjectTypes.GameObject) then
            -- Locals
            local guid = UnitGUID(thisObject)
            local objectName = ObjectName(thisObject)
            local objectType, _, _, _, _, objectID, _ = strsplit("-", guid)
            objectID = tonumber(objectID)
            if objectType == "Creature" then objectType = "Unit" end

            if objectName == name and not nearestObject then
                print(objectType.." Name: "..objectName.." | ID: "..objectID)
                return
            elseif objectName == name and nearestObject == true then
                -- Sort by nearest found object
                tmpDistance = GetDistanceBetweenObjects("player",thisObject)
                if nearest.objDistance > tmpDistance then
                    nearest.objDistance = tmpDistance
                    nearest.objName = objectName
                    nearest.objID = objectID
                    nearest.objType = objectType
                end
            end
        end
    end
    -- Print nearest object
    if nearestObject == true and nearest.objDistance ~= 999 then
        print(nearest.objType.." Name: "..nearest.objName.." | ID: "..nearest.objID.." | Dist: "..nearest.objDistance)
        print("{"..nearest.objID..", "..tostring(floor(nearest.objDistance)+1).."}, -- "..nearest.objName)
        return
    end


    print(name.." not found.")
end

--[[    TODO: add personal & account Nodes, which user can set themself
 ]]