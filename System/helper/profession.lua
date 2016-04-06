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
    --bb.helper.deposits = {}

    if not UnitAffectingCombat("player") and UnitCastingInfo("player") == nil then

        for i=1, nrObjects do
            -- Locals
            local thisObject = GetObjectWithIndex(i)

            -- Check if object is a GameObject
            if ObjectIsType(thisObject, ObjectTypes.GameObject) then

                -- Profession gathering, check if can gather
                if not isMoving("player") and not IsFlying() and #self.gatherNodes > 0 and #self.objectNodes > 0 then
                    -- Locals
                    local guid = UnitGUID(thisObject)
                    local objectName = ObjectName(thisObject)
                    local objectType, _, _, _, _, objectID, _ = strsplit("-", guid)
                    objectID = tonumber(objectID)

                    -- Check if ObjectID or ObjectName is within the gathering table
                    if inTable(self.gatherNodes, objectName) or inTable(self.gatherNodes, objectID) then
                        --tinsert(bb.helper.deposits, {guid, objectName})
                        if GetDistanceBetweenObjects("player", thisObject) < 6 then
                            ObjectInteract(thisObject)
                            return
                        end
                    end
                    -- Object gathering/clicking
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
            -- Checking for Units as some quests objects etc. are declared as NPC
            elseif ObjectIsType(thisObject, ObjectTypes.Unit) then
                if not isMoving("player") and not IsFlying() and #self.unitNodes > 0 then
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