function AcceptQueues()
    if getOptionCheck("Accept Queues") then
        -- Accept Queues
        if randomReady == nil then
            randomReady = math.random(8,15)
        end
        -- add some randomness
        if readyToAccept and readyToAccept <= GetTime() - 5 then
            AcceptProposal(); readyToAccept = nil; randomReady = nil
        end
    end
end

-- Sell Greys Macros
SLASH_Greys1 = "/grey"
SLASH_Greys2 = "/greys"
function SlashCmdList.Greys(msg, editbox)
    SellGreys()
end

function SellGreys()
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local item = GetContainerItemLink(bag,slot)
            if item then
                    -- Is it grey quality item?
                if string.find(item, qualityColors.grey) ~= nil then
                    greyPrice = select(11, GetItemInfo(item)) * select(2, GetContainerItemInfo(bag, slot))
                    if greyPrice > 0 then
                        PickupContainerItem(bag, slot)
                        PickupMerchantItem()
                    end
                end
            end
        end
    end
    RepairAllItems(1)
    RepairAllItems(0)
    ChatOverlay("Sold Greys.")
end

-- Dump Greys Macros
SLASH_DumpGrey1 = "/dumpgreys"
SLASH_DumpGrey2 = "/dg"
function SlashCmdList.DumpGrey(msg, editbox)
    DumpGreys(1);
end
function DumpGreys(Num)
    local greyTable = {}
    for bag = 0, 4 do
      for slot = 1, GetContainerNumSlots(bag) do
          local item = GetContainerItemLink(bag,slot)
          if item then
            -- Is it grey quality item?
            if string.find(item, qualityColors.grey) ~= nil then
                greyPrice = select(11, GetItemInfo(item)) * select(2, GetContainerItemInfo(bag, slot))
                if greyPrice > 0 then
                    tinsert(greyTable, { Bag = bag, Slot = slot, Price = greyPrice, Item = item})
                end
              end
            end
        end
    end
    table.sort(greyTable, function(x,y)
        if x.Price and y.Price then return x.Price < y.Price; end
    end)
    for i = 1, Num do
        if greyTable[i]~= nil then
            PickupContainerItem(greyTable[i].Bag, greyTable[i].Slot)
            DeleteCursorItem()
            print("|cffFF0000Removed Grey Item:"..greyTable[i].Item)
        end
    end
end

-------------------------
-- idTip by Silverwind --
-------------------------
local hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, GetGlyphSocketInfo, tonumber, strfind =
      hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, GetGlyphSocketInfo, tonumber, strfind

local types = {
    spell       = "SpellID:",
    item        = "ItemID:",
    glyph       = "GlyphID:",
    unit        = "NPC ID:",
    quest       = "QuestID:",
    talent      = "TalentID:",
    achievement = "AchievementID:"
}

local function addLine(tooltip, id, type, noEmptyLine)
    local found = false

    -- Check if we already added to this tooltip. Happens on the talent frame
    for i = 1,15 do
        local frame = _G[tooltip:GetName() .. "TextLeft" .. i]
        local text
        if frame then text = frame:GetText() end
        if text and text == type then found = true break end
    end

    if not found then
        if not noEmptyLine then tooltip:AddLine(" ") end
        tooltip:AddDoubleLine(type, "|cffffffff" .. id)
        tooltip:Show()
    end
end

-- All types, primarily for linked tooltips
local function onSetHyperlink(self, link)
    local type, id = string.match(link,"^(%a+):(%d+)")
    if not type or not id then return end
    if type == "spell" or type == "enchant" or type == "trade" then
        addLine(self, id, types.spell)
    elseif type == "glyph" then
        addLine(self, id, types.glyph)
    elseif type == "talent" then
        addLine(self, id, types.talent)
    elseif type == "quest" then
        addLine(self, id, types.quest)
    elseif type == "achievement" then
        addLine(self, id, types.achievement)
    elseif type == "item" then
        addLine(self, id, types.item)
    end
end

hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)

-- Spells
hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, ...)
    local id = select(11, UnitBuff(...))
    if id then addLine(self, id, types.spell) end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
    local id = select(11, UnitDebuff(...))
    if id then addLine(self, id, types.spell) end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
    local id = select(11, UnitAura(...))
    if id then addLine(self, id, types.spell) end
end)

hooksecurefunc("SetItemRef", function(link, ...)
    local id = tonumber(link:match("spell:(%d+)"))
    if id then addLine(ItemRefTooltip, id, types.spell) end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
    local id = select(3, self:GetSpell())
    if id then addLine(self, id, types.spell) end
end)

-- NPCs
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    if C_PetBattles.IsInBattle() then return end
    local unit = select(2, self:GetUnit())
    if unit then
        local guid = UnitGUID(unit) or ""
        local id   = tonumber(guid:match("-(%d+)-%x+$"), 10)
        local type = guid:match("%a+")

        -- ID 970 seems to be used for players
        if id and type ~= "Player" then addLine(GameTooltip, id, types.unit) end
    end
end)

-- Items
local function attachItemTooltip(self)
    local link = select(2, self:GetItem())
    if link then
        local id = select(3, strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+).*"))
        if id then addLine(self, id, types.item) end
    end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)

-- Glyphs
hooksecurefunc(GameTooltip, "SetGlyph", function(self, ...)
    local id = select(4, GetGlyphSocketInfo(...))
    if id then addLine(self, id, types.glyph) end
end)

hooksecurefunc(GameTooltip, "SetGlyphByID", function(self, id)
    if id then addLine(self, id, types.glyph) end
end)

-- Achievement Frame Tooltips
local f = CreateFrame("frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, what)
    if what == "Blizzard_AchievementUI" then
        for i,button in ipairs(AchievementFrameAchievementsContainer.buttons) do
            button:HookScript("OnEnter", function()
                GameTooltip:SetOwner(button, "ANCHOR_NONE")
                GameTooltip:SetPoint("TOPLEFT", button, "TOPRIGHT", 0, 0)
                addLine(GameTooltip, button.id, types.achievement, true)
                GameTooltip:Show()
            end)
            button:HookScript("OnLeave", function()
                GameTooltip:Hide()
            end)
        end
    end
end)

local petAbilityTooltipID = false;
local orig_SharedPetBattleAbilityTooltip_SetAbility = SharedPetBattleAbilityTooltip_SetAbility
function SharedPetBattleAbilityTooltip_SetAbility(self, abilityInfo, additionalText)
  orig_SharedPetBattleAbilityTooltip_SetAbility(self, abilityInfo, additionalText)
  petAbilityTooltipID = abilityInfo:GetAbilityID()
end

PetBattlePrimaryAbilityTooltip:HookScript('OnShow', function(self)
      local name = self.Name:GetText()
      self.Name:SetText(name .. ' (ID: ' .. petAbilityTooltipID .. ')')
end)



--[[

                                                            LibStub


]]


-- $Id: LibStub.lua 76 2007-09-03 01:50:17Z mikk $
-- LibStub is a simple versioning stub meant for use in Libraries.  http://www.wowace.com/wiki/LibStub for more info
-- LibStub is hereby placed in the Public Domain
-- Credits: Kaelten, Cladhaire, ckknight, Mikk, Ammo, Nevcairiel, joshborke
local LIBSTUB_MAJOR, LIBSTUB_MINOR = "LibStub", 2  -- NEVER MAKE THIS AN SVN REVISION! IT NEEDS TO BE USABLE IN ALL REPOS!
local LibStub = _G[LIBSTUB_MAJOR]

-- Check to see is this version of the stub is obsolete
if not LibStub or LibStub.minor < LIBSTUB_MINOR then
    LibStub = LibStub or {libs = {}, minors = {} }
    _G[LIBSTUB_MAJOR] = LibStub
    LibStub.minor = LIBSTUB_MINOR

    -- LibStub:NewLibrary(major, minor)
    -- major (string) - the major version of the library
    -- minor (string or number ) - the minor version of the library
    --
    -- returns nil if a newer or same version of the lib is already present
    -- returns empty library object or old library object if upgrade is needed
    function LibStub:NewLibrary(major, minor)
        assert(type(major) == "string", "Bad argument #2 to `NewLibrary' (string expected)")
        minor = assert(tonumber(strmatch(minor, "%d+")), "Minor version must either be a number or contain a number.")

        local oldminor = self.minors[major]
        if oldminor and oldminor >= minor then return nil end
        self.minors[major], self.libs[major] = minor, self.libs[major] or {}
        return self.libs[major], oldminor
    end

    -- LibStub:GetLibrary(major, [silent])
    -- major (string) - the major version of the library
    -- silent (boolean) - if true, library is optional, silently return nil if its not found
    --
    -- throws an error if the library can not be found (except silent is set)
    -- returns the library object if found
    function LibStub:GetLibrary(major, silent)
        if not self.libs[major] and not silent then
            error(("Cannot find a library instance of %q."):format(tostring(major)), 2)
        end
        return self.libs[major], self.minors[major]
    end

    -- LibStub:IterateLibraries()
    --
    -- Returns an iterator for the currently registered libraries
    function LibStub:IterateLibraries()
        return pairs(self.libs)
    end

    setmetatable(LibStub, { __call = LibStub.GetLibrary })
end


------------------
-- Loot Manager --
------------------

local lootManager = { }
lM = lootManager

-- Debug
function lootManager:debug(message)
    if lM.showDebug then
        print("<lootManager> "..(math.floor(GetTime()*1000)/1000) .. " "..message)
    end
end

-- Check if availables bag slots, return true if at least 1 free bag space
function lootManager:emptySlots()
    local openCount = 0
    for i = 1, NUM_BAG_SLOTS do
        openCount = openCount + select(1,GetContainerNumFreeSlots(i))
    end
    --lM:debug("Counts of "..openCount.." empty slots.")
    if openCount > 0 then
        return true
    else
        return false
    end
end

-- pulses always
function lootManager:pulse()
    -- if we should find a loot
    if lM.shouldLoot == true then
        lM:getLoot()
    end
    -- it we seen a loot in reader
    if lM.lootedTimer and lM.lootedTimer < GetTime() - 0.5 then
        ClearTarget()
        lM.lootedTimer = nil
        lM.shouldLoot = false
        lM:debug("Clear Target")
    end
end

function lootManager:getLoot()
    if lM:emptySlots() then
        if UnitCastingInfo("player") == nil and UnitChannelInfo("player") == nil then
            -- find an unit to loot
            if lM.canLootUnit == nil then
                lM:debug("Find Unit")
                for i = 1,ObjectCount() do
                    if bit.band(ObjectType(ObjectWithIndex(i)), ObjectTypes.Unit) == 8 then
                        local thisUnit = ObjectWithIndex(i)
                        local hasLoot,canLoot = CanLootUnit(UnitGUID(thisUnit))
                        local inRange = getRealDistance("player",thisUnit) < 2
                        -- if we can loot thisUnit we set it as unit to be looted
                        if hasLoot and canLoot and inRange then
                            lM.canLootTimer = GetTime()
                            lM.canLootUnit = thisUnit
                            lM:debug("Should loot "..UnitName(thisUnit))
                            break
                        end
                    end
                end
            end
            -- if we have a unit to loot, check if its time to
            if lM.canLootUnit and lM.canLootTimer and lM.canLootTimer <= GetTime() - getOptionValue("Auto Loot") then
                if ObjectExists(lM.canLootUnit) then
                    -- make sure the user have the auto loot selected, if its not ,we will enable it when we need it
                    if GetCVar("autoLootDefault") == "0" then
                        SetCVar("autoLootDefault", "1")
                        InteractUnit(lM.canLootUnit)
                        lM:debug("Interact with "..lM.canLootUnit)
                        SetCVar("autoLootDefault", "0")
                        return
                    else
                        InteractUnit(lM.canLootUnit)
                        lM:debug("Interact with "..lM.canLootUnit)
                    end
                end
                -- no matter what happened, we clear all values
                lM.canLootTimer = nil
                lM.canLootUnit = nil
                lM:debug("Clear Loot Timer and Unit")
            end
        else
            -- if we were casting, we reset the delay
            lM.canLootTimer = GetTime()
        end
    else
        ChatOverlay("Bags are full, nothing will be looted!")
    end
end