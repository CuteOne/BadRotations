--- br.drawer - Module to draw with the help of LibDraw cycles, lines, etc into WoW

br.drawer = {}
-- Contains the objects/units to draw
br.drawer.objects = {
    -- ID, Shape, Parameter
    236683
}
br.drawer.units   = {}

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
        local drawTable = {}
        -- local objectCount = GetObjectCount() or 0
        for i=1,GetObjectCount() do
            -- Locals
            local thisObject = GetObjectWithIndex(i)
            if ObjectIsType(thisObject, ObjectTypes.GameObject) then
                -- Locals
                local guid = UnitGUID(thisObject)
                local objectName = ObjectName(thisObject)
                local objectType, _, _, _, _, objectID, _ = strsplit("-", guid)
                objectID = tonumber(objectID)

                -- Check if object is in global table
                for j=1, #br.drawer.objects do
                    if objectID == br.drawer.objects[j] then
                        tinsert(drawTable, thisObject)
                    end
                end
            end
        end

       local playerX, playerY, playerZ = ObjectPosition("player")
       local rotation = ObjectFacing("player")
       LibDraw.Arc(playerX, playerY, playerZ, 10, 70, rotation)


        -- Dont draw if nothing is in table
        if drawTable == nil then return end

        -- Start drawing object/unit specific things
        for i=1, #drawTable do

            local targetX, targetY, targetZ = ObjectPosition(drawTable[i])
            LibDraw.Line(playerX, playerY, playerZ, targetX, targetY, targetZ)
        end
    end
end)


-- Starts the drawing
br.drawer.drawTicker = LibDraw.Enable(0.01)


--[[
LibDraw.Texture(texture, targetX, targetY, targetZ + 3)
local targetX, targetY, targetZ = ObjectPosition("target")

LibDraw.Line(playerX, playerY, playerZ, targetX, targetY, targetZ)

LibDraw.Circle(playerX, playerY, playerZ, 10)

LibDraw.Box(playerX, playerY, playerZ, 5, 5)
--LibDraw.Box(playerX, playerY, playerZ, 5, 5, rotation)
--LibDraw.Box(playerX, playerY, playerZ, 5, 15, rotation, 0, 7.5)
local name = ObjectName("target")
LibDraw.Text(name, "GameFontNormal", targetX, targetY, targetZ)

LibDraw.Array(cubeShape, playerX, playerY, playerZ + 3)
 ]]