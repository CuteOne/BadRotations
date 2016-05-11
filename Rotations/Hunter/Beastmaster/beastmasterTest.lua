--- File to show new rotation handling

-- Only load if class is Hunter
if select(3, UnitClass("player")) == 3 then
    -- Name for your rotation
    local rotationName = "myTest"

    -- Function whichs creates rotation toggles
    local function createToggles()
        -- Aoe Button
        AoEModes = {
            [1] = { mode = "Sin",  value = 1 , overlay = "Single Target Enabled", tip = "|cff00FF00Recommended for \n|cffFFDD11Single Target(1-2).", highlight = 0, icon = 35395 },
            [2] = { mode = "AoE",  value = 2 , overlay = "AoE Enabled",           tip = "|cffFF0000Recommended for \n|cffFFDD11AoE(3+).",            highlight = 0, icon = 53595 },
            [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled",      tip = "|cffFFDD11Recommended for \n|cffFFDD11Lazy people.",        highlight = 1, icon = 114158 }
        }
        CreateButton("AoE",0,1)
    end

    -- Function to create your rotation options
    local function createOptions()
        local optionTable

        local function callBuffs()
            bb.ui:createCheckbox(bb.ui.window.profile, rotationName.." Fury")
        end

        optionTable = {
            {
                [1] = "Buffs",
                [2] = callBuffs,
            }
        }

        return optionTable
    end

    -- Function whichs runs your rotation
    -- Start Rotation is handled by cCharacter so dont override self.startRotation() !
    -- you have to handle ooc and incombat rotation like before
    local function runRotation()

        if bb.timer:useTimer("debugHunter", 5) then
            --print("Running: "..rotationName)
        end
    end

    -- This adds your functions to the rotation table
    -- the table and its functions gets automatically processed by the cSPEC file
    -- variable names are set, butr you can name your functions like you want
    tinsert(cBeastmaster.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })

    -- You can even have to rotations in one file like this:
    -- many wow
-------------------------------------------------------------------------------------------------------------
    local rotationName = "myTest-2"

    local function createToggles()
        -- Interrupts Button
        InterruptsModes = {
            [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "|cffFF0000No Interrupts will be used.", highlight = 0, icon = [[INTERFACE\ICONS\INV_Misc_AhnQirajTrinket_03]] },
            [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "|cffFF0000Spells Included: \n|cffFFDD11Rebuke.", highlight = 1, icon = 96231 }
        }
        CreateButton("Interrupts",1,0)
    end

    local function createOptions()
        local optionTable

        local function callBuffs()
            bb.ui:createCheckbox(bb.ui.window.profile, rotationName.." Fury")
        end

        optionTable = {
            {
                [1] = "Buffs",
                [2] = callBuffs,
            }
        }

        return optionTable
    end

    local function runRotation()

        if bb.timer:useTimer("debugHunter2", 5) then
            print("Running: "..rotationName)
        end
    end

    tinsert(cBeastmaster.rotations, {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation,
    })

end

--[[
    Within the Beastmaster.lua you would write:

    if select(3, UnitClass("player")) == 3 then
        function BeastHunter()
          if bb.player == nil or bb.player.profile ~= "Beastmaster" then
              bb.player = cBeastmaster:new("Beastmaster")
              setmetatable(bb.player, {__index = cBeastmaster})

              bb.player:createOptions()
              bb.player:createToggles()
              bb.player:update()
          end

         bb.player:update()
        end
    end
 ]]
