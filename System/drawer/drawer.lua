--- bb.drawer - Module to draw with the help of LibDraw cycles, lines, etc into WoW

bb.drawer = {}

local LibDraw = LibStub("LibDraw-1.0")

local s = 0.5
local cubeShape = {
    -- This looks confusing but its really not too bad
    -- This image helps it make sense: http://i.imgur.com/yBbUQSA.png
    -- It's just 2 sets of points per row, drawing a line between them
    {-s,  s,  s, -s, -s,  s}, -- v1 to v2
    { s,  s,  s,  s, -s,  s}, -- v4 to v3
    {-s,  s, -s, -s, -s, -s}, -- v5 to v8
    { s,  s, -s,  s, -s, -s}, -- v6 to v7
    {-s,  s,  s,  s,  s,  s}, -- v1 to v4
    {-s, -s,  s,  s, -s,  s}, -- v2 to v3
    {-s,  s, -s,  s,  s, -s}, -- v5 to v6
    {-s, -s, -s,  s, -s, -s}, -- v8 to v7
    {-s,  s,  s, -s,  s, -s}, -- v1 to v5
    { s,  s,  s,  s,  s, -s}, -- v4 to v6
    {-s, -s,  s, -s ,-s, -s}, -- v2 to v8
    { s, -s,  s,  s, -s, -s}, -- v3 to v7
}

LibDraw.Sync(function()
    if FireHack and isChecked("Use Drawer") == true then
        local drawTbl = {}

        for i=1, GetObjectCount() do
            -- Locals
            local thisObject = GetObjectWithIndex(i)
            if ObjectIsType(thisObject, ObjectTypes.GameObject) then
                -- Locals
                local guid = UnitGUID(thisObject)
                local objectName = ObjectName(thisObject)
                local objectType, _, _, _, _, objectID, _ = strsplit("-", guid)
                objectID = tonumber(objectID)

                if objectID == 236683 then
                    tinsert(drawTbl, thisObject)
                    break
                end
            end
        end

       local playerX, playerY, playerZ = ObjectPosition("player")

        if drawTbl == nil then return end
        for i=1, #drawTbl do
            local targetX, targetY, targetZ = ObjectPosition(drawTbl[i])
            LibDraw.Line(playerX, playerY, playerZ, targetX, targetY, targetZ)
        end


       --local targetX, targetY, targetZ = ObjectPosition("target")

       --LibDraw.Line(playerX, playerY, playerZ, targetX, targetY, targetZ)

       --LibDraw.Circle(playerX, playerY, playerZ, 10)

       --LibDraw.Box(playerX, playerY, playerZ, 5, 5)
       ----LibDraw.Box(playerX, playerY, playerZ, 5, 5, rotation)
       ----LibDraw.Box(playerX, playerY, playerZ, 5, 15, rotation, 0, 7.5)

       local rotation = ObjectFacing("player")
       LibDraw.Arc(playerX, playerY, playerZ, 10, 70, rotation)

       --LibDraw.Texture(texture, targetX, targetY, targetZ + 3)

       --local name = ObjectName("target")
       --LibDraw.Text(name, "GameFontNormal", targetX, targetY, targetZ)

       --LibDraw.Array(cubeShape, playerX, playerY, playerZ + 3)

    end
end)

-- Starts the drawing
bb.drawer.drawTicker = LibDraw.Enable(0.01)