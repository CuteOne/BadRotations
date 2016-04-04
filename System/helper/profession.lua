-- Global helper table
bb.helper = {}

-- Contains all possible gathering nodes
-- TODO: event -> +level => re-check if new node is possible to gather
bb.helper.gatherNodes = {}

--- Check for possible gather nodes
--  checks if profession is active and which level to insert the possible nodes
function bb.helper:getPossibleNodes()
    self.gatherNodes = {}
    -- Mining
    bb.helper:getMiningNodes()
    -- Herbs
    bb.helper:getHerbalismNodes()
end

--- Checks global table which contain gatherable node and trys to gather them
--  Check the name of the node => only english locale
function bb.helper:startGathering()
    local nrObjects = GetObjectCount()
    --local deposits = {}

    if not UnitAffectingCombat("player") then

        for i=1, nrObjects do
            -- Locals
            local thisObject = GetObjectWithIndex(i)

            -- Check if object is a GameObject
            if ObjectIsType(thisObject, ObjectTypes.GameObject) then
                -- Locals
                local guid = UnitGUID(thisObject)
                local objectName = ObjectName(thisObject)
                local objectType, _, _, _, _, objectID, _ = strsplit("-", guid)
                objectID = tonumber(objectID)
                -- Check if ObjectID or ObjectName is within the gathering table
                if inTable(self.gatherNodes, objectName) or inTable(self.gatherNodes, objectID) then
                    --tinsert(deposits, thisObject)
                    if UnitCastingInfo("player") == nil and not isMoving("player") and not IsFlying() then
                        if GetDistanceBetweenObjects("player", thisObject) < 6 then
                            ObjectInteract(thisObject)
                            return
                        end
                    end
                end
            end
        end
    end
end