local _, br = ...
if br.api == nil then br.api = {} end
local function setVariable(self,unit,range,checkNoCombat,facing,type,table,count)
    if unit == nil then unit = "player" end
    if range == nil then range = 5 end
    if checkNoCombat == nil then checkNoCombat = false end
    if facing == nil then facing = false end
    if type == nil then type = "" end
    if table == nil then table = {} end
    if count == nil then count = #table end
    -- Build enemies.yards variable
    local insertTable = "yards"..range..type -- Ex: enemies.yards8 (returns all enemies around player in 8yrds), Adds Table Type (r for Rect, c for Cone, blank for Normal)
    if unit ~= "player" then
        -- letter tag on end based on type of unit passed, if target or enemy unit then "t" otherwise first letter of what is passed in: f - "focus", p - "pet", m - "mouseover", etc 
        if br.units[unit] ~= nil then
            insertTable = insertTable.."t" -- Ex: enemies.yards8t (returns all enemies around target in 8yrds)
        else
            insertTable = insertTable..unit:sub(1,1) -- Ex: enemies.yards8f (returns all enemies around "focus" in 8yrds)
        end
    end
    if checkNoCombat then insertTable = insertTable.."nc" end -- Ex: enemies.yards8tnc (returns all units around target in 8yrds)
    if facing then insertTable = insertTable.."f" end-- Ex: enemies.yards8tncf (returns all units the target is facing in 8yrds)
    if self.enemies[insertTable] == nil then self.enemies[insertTable] = {} else br._G.wipe(self.enemies[insertTable]) end
    if count > 0 then br.insertTableIntoTable(self.enemies[insertTable],table) end
end
br.api.enemies = function(self)
    local enemies = self.enemies
    -- Returns all enemies around unit for given range, combat situation, and facing
    enemies.get = function(range,unit,checkNoCombat,facing)
        if unit == nil then unit = "player" end
        if checkNoCombat == nil then checkNoCombat = false end
        if facing == nil then facing = false end
        local enemyTable = br.getEnemies(unit,range,checkNoCombat,facing)
        -- Build enemies.yards variable
        setVariable(self,unit,range,checkNoCombat,facing,"",enemyTable)
        -- Backwards compatability for old way
        return enemyTable, #enemyTable
    end
    -- Returns all enemies in the players frontal cone for given angle, range, and combat situation
    if enemies.cone == nil then enemies.cone = {} end
    enemies.cone.get = function(angle,range,checkNoCombat,showLines)
        local count, table = br.getEnemiesInCone(angle,range,checkNoCombat,showLines)
        -- Build enemies.yards variable
        setVariable(self,"player",range,checkNoCombat,false,"c",table,count)
        -- Backwards compatability for old way
        return table, count
    end
    -- Returns all enemies in a rectangular area from a unit for given range, combat situation, and facing
    if enemies.rect == nil then enemies.rect = {} end
    enemies.rect.get = function(width,range,showLines,checkNoCombat,facing)
        local count, table = br.getEnemiesInRect(width,range,showLines,checkNoCombat)
        -- Build enemies.yards variable
        setVariable(self,"player",range,checkNoCombat,false,"r",table,count)
        -- Backwards compatability for old way
        return table, count
    end
end