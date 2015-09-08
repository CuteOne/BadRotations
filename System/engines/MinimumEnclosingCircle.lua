-- ===========================
-- Minimum enclosing circle algorithm
-- modified by Weee for FPB
-- ---------------------------
-- Much of this code was inspired from the ruby implementation at:
-- [http://www.dseifert.net/code/mec/source.html]
-- ===========================

-- ===========================
-- Copy the array portion of the table.
-- ===========================
function CopyArray(t)
        local ret = {}
        for i,v in ipairs(t) do
                ret[i] = v
        end
        return ret
end

-- ===========================
-- Create a new array, minus the element at the specified index
-- ===========================
function DeleteAt(t, index)
        local ret = {}
        for i,v in ipairs(t) do
                if i ~= index then
                        table.insert(ret, v)
                end
        end
        return ret
end

-- ===========================
-- Joins arrays t1 and t2 and outputs only the unique elements.
-- ===========================
function JoinUniqueArrayElements(t1, t2)
        local ret = {}
        local unique = {}
        -- Place the elements of t1 and t2 into the unique dictionary
        for i,p in ipairs(t1) do
                unique["x" .. p.x .. "z" .. p.z] = p 
        end
        for i,p in ipairs(t2) do
                unique["x" .. p.x .. "z" .. p.z] = p
        end
        -- Insert each element of unique into the return array.
        for k,p in pairs(unique) do
                table.insert(ret, p)
        end
        return ret
end

-- ===========================
-- Minimum Enclosing Circle object and algorithm
-- ===========================
MEC = {
        -- ===========================
        -- Create a new MEC table
        -- ===========================
        New = function(self, points)
                local mec = {}
                mec = setmetatable({}, {__index = self})
                mec.circle = nil
                mec.points = {} -- a table of x,z coordinates
                
                if points then
                        mec:SetPoints(points)
                end
                
                return mec
        end,
        
        -- ===========================
        -- Set the points used to compute the MEC.
        -- points is an array, starting at 1.
        -- ===========================
        SetPoints = function(self, points)
                local Vector = {}
                local New = self.New
                -- Set the points
                self.points = points
                for i, p in ipairs(self.points) do
                        p = Vector:New(p)
                end
        end,
        
        -- ===========================
        -- Computes the half hull of a set of points
        -- ===========================
        HalfHull = function(left, right, pointTable, factor)
                local input = CopyArray(pointTable)
                table.insert(input, right)
                local half = {}
                table.insert(half, left)
                for i,p in ipairs(input) do
                        table.insert(half, p)
                        while #half >= 3 do
                                local dir = factor * Vector.Direction(half[(#half+1)-3], half[(#half+1)-1], half[(#half+1)-2])
                                if dir <= 0 then
                                        half = DeleteAt(half, #half-1)
                                else
                                        break
                                end
                        end
                end
                return half
        end,
        
        -- ===========================
        -- Computes the set of points that represent the
        -- convex hull of the set of points
        -- ===========================
        ConvexHull = function(self)
                local a = self.points
                local left = a[1]
                local right = a[#a]
                local upper = {}
                local lower = {}
                
                -- Partition remaining points into upper and lower buckets.
                for i = 2, #a-1 do
                        local dir = Vector.Direction(left, right, a[i])
                        if dir < 0 then
                                table.insert(upper, a[i])
                        else
                                table.insert(lower, a[i])
                        end
                end
                
                local upperHull = self.HalfHull(left, right, upper, -1)
                local lowerHull = self.HalfHull(left, right, lower, 1)
                
                return JoinUniqueArrayElements(upperHull, lowerHull)
        end,
        
        -- ===========================
        -- Compute the MEC.
        -- ===========================
        Compute = function(self)
                self.circle = self.circle or Circle:New()
                
                -- Make sure there are some points.
                if #self.points == 0 then return self.circle end
                
                -- Handle degenerate cases first
                if #self.points == 1 then
                        self.circle.center = self.points[1]
                        self.circle.radius = 0
                        self.circle.radiusPoint = self.points[1]
                elseif #self.points == 2 then
                        local a = self.points
                        self.circle.center = a[1]:Center(a[2])
                        self.circle.radius = a[1]:Distance(self.circle.center)
                        self.circle.radiusPoint = a[1]
                else
                        local a = self:ConvexHull()
                        local point_a = a[1]
                        local point_b = nil
                        local point_c = a[2]
                        
                        if not point_c then
                                self.circle.center = point_a
                                self.circle.radius = 0
                                self.circle.radiusPoint = point_a
                                return self.circle
                        end
                        
                        -- Loop until we get appropriate values for point_a and point_c
                        while true do
                                point_b = nil
                                local best_theta = 180.0
                                -- Search for the point "b" which subtends the smallest angle a-b-c. 
                                for i,point in ipairs(self.points) do
                                        if (not point:Equals(point_a)) and (not point:Equals(point_c)) then
                                                local theta_abc = point:AngleBetween(point_a, point_c)
                                                if theta_abc < best_theta then
                                                        point_b = point
                                                        best_theta = theta_abc
                                                end                             
                                        end
                                end
                                -- If the angle is obtuse, then line a-c is the diameter of the circle,
                                -- so we can return.
                                if best_theta >= 90.0 or (not point_b) then
                                        self.circle.center = point_a:Center(point_c)
                                        self.circle.radius = point_a:Distance(self.circle.center)
                                        self.circle.radiusPoint = point_a
                                        return self.circle
                                end
                                local ang_bca = point_c:AngleBetween(point_b, point_a)
                                local ang_cab = point_a:AngleBetween(point_c, point_b)
                                if ang_bca > 90.0 then
                                        point_c = point_b
                                elseif ang_cab <= 90.0 then
                                        break
                                else
                                        point_a = point_b
                                end
                        end
                        local ch1 = (point_b - point_a):Scale(0.5)
                        local ch2 = (point_c - point_a):Scale(0.5)
                        local n1 = ch1:NormalLeft()
                        local n2 = ch2:NormalLeft()
                        ch1 = point_a + ch1
                        ch2 = point_a + ch2
                        self.circle.center = Vector.InfLineIntersection (ch1, n1, ch2, n2)
                        self.circle.radius = self.circle.center:Distance(point_a)
                        self.circle.radiusPoint = point_a
                end
                return self.circle
        end,
}

function __check_if_target(obj,range,R)
   return obj ~= nil and obj.team == TEAM_ENEMY and not obj.dead and obj.visible and player:GetDistanceTo(obj) <= (range + R)
   --return obj ~= nil
end

function __check_if_near_target(obj,target,range,R)
   return obj ~= nil and obj.team == target.team and not obj.dead and obj.visible and obj:GetDistanceTo(target) <= R*2
end

function FindGroupCenterNearTarget(target,R,range)
    local playerCount = GetPlayerCount()
    local points = {}
    for i = 1, playerCount, 1 do
        local object = GetPlayer(i)
        if __check_if_near_target(object,target,range,R) or object == target then   -- finding enemies near our target. grouping them in points table.
            table.insert(points, Vector:New(object.x,object.z))
        end
    end
    return CalcSpellPosForGroup(R,range,points)
end

function FindGroupCenterFromNearestEnemies(R,range)
    local playerCount = GetPlayerCount()
    local points = {}
    for i = 1, playerCount, 1 do
        local object = GetPlayer(i)
        if __check_if_target(object,range,R) then   -- finding enemies in our range (spell range + AoE radius) and grouping them in points table.
            table.insert(points, Vector:New(object.x,object.z))
        end
    end
    return CalcSpellPosForGroup(R,range,points)
end


-- ============================================================
-- Weee's additional stuff:
-- ============================================================

-- =======================
-- CalcCombosFromString is used to fill table "comboTableToFill[]" with unique
-- combinations (with size of comboSize) generated from table "targetsTable[]".
-- =======================
function CalcCombosFromString(comboString,index_number,comboSize,targetsTable,comboTableToFill)
    if string.len(comboString) == comboSize then
        local b = {}
        for i=1,string.len(comboString),1 do
            local ai = tonumber(string.sub(comboString,i,i))
            table.insert(b,targetsTable[ai])
        end
        return table.insert(comboTableToFill,b)
    end
    for i = index_number, #targetsTable, 1 do
        CalcCombosFromString(comboString..i,i+1,comboSize,targetsTable,comboTableToFill)
    end
end

-- =======================
-- CalcSpellPosForGroup is used to get optimal position for your AoE circle spell (annie ult, brand W, etc).
-- It will always return MEC with position, where spell will hit most players and where players will be staying closer to each other.
-- =======================
function CalcSpellPosForGroup(spellRadius,spellRange,enemyTable)
    if #enemyTable == 1 then
        --PrintChat("Casting shit on player (inside MEC lib)")
        return { center = { x = enemyTable[1].x, z = enemyTable[1].z } }
    end
    local combos = {
        [5] = {}, -- 5-player combos
        [4] = {}, -- 4-player combos
        [3] = {}, -- 3-player combos
        [2] = {}, -- 2-player combos
    }
    mec = MEC:New()
    for j = #enemyTable,2,-1 do
        CalcCombosFromString("",1,j,enemyTable,combos[j])
        --for i,v in ipairs(combos[j]) do
            --printTable(v)
        --end
        --print(j.."-player combinations: "..#combos[j].."\n")
        --PrintChat(j.."-player combinations: "..#combos[j])
        local spellPos = nil
        for i,v in ipairs(combos[j]) do
            mec:SetPoints(v)
            local c = mec:Compute()
            if c.radius <= spellRadius and (spellPos == nil or c.radius < spellPos.radius) then
                spellPos = Circle:New()
                spellPos.center = c.center
                spellPos.radius = c.radius
                --print("MEC for combo #"..i.." of "..#combos[j]..": "..spellPos:ToString())
                --PrintChat("MEC for combo #"..i.." of "..#combos[j]..": "..spellPos:ToString())
                --PrintChat("true")
                --print()
            end
        end
        if spellPos ~= nil then return spellPos end
    end
end
