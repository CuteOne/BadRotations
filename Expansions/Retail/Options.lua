-- Retail-only Bot Options (Mythic+ affixes, dungeon and raid mechanics).
-- System/UI/Windows/Config.lua calls br.api.botOptions[<page>](section) at the end of that page; the
-- options go in the page's own section, so their saved values stay where they were.
local _, br = ...

if not br.isRetail then return end

br.api.botOptions = br.api.botOptions or {}

br.api.botOptions["Enemies Engine"] = function(section)
    br.ui:spinner(section, "Bursting Stack Limit", { value = 2, min = 1, max = 10, step = 1, checkbox = false,
        tip = "**Requires Safe Damage Check** - Set to desired limit, will still dps targets but not kill until below limit." })
end

br.api.botOptions["Healing Options"] = function(section)
    br.ui:spinner(section, "Bwonsamdi's Wrath HP", { value = 30, min = 1, checkbox = false,
        tip = "Set HP to decurse Bwonsamdi's Wrath (Mythic Conclave)" })
    br.ui:spinner(section, "Reaping", { value = 20, min = 1, checkbox = false, tip = "Set how many stacks of reaping needed to dispel." })
    br.ui:spinner(section, "Promise of Power", { value = 8, min = 1, max = 10, step = 1, checkbox = false,
        tip = "Set how many stacks of promise of power needed to dispel." })
    br.ui:spinner(section, "Toxic Brand", { value = 10, min = 1, max = 20, step = 1,
        tip = "Set how many stacks of toxic brand to stop healing party members at." })
    br.ui:checkbox(section, "Arcane Burst", { tip = "Will dispel Arcane Burst if checked." })
    br.ui:spinner(section, "Necrotic Rot", { value = 40, min = 1, tip = "Set how many stacks of necrotic rot to stop healing party members at." })
    br.ui:spinner(section, "Decaying Strike Timer", { value = 5, min = 1, max = 20, step = 1, checkbox = false,
        tip = "Set how long to stop healing tank before Decaying Strike is cast." })
end

br.api.botOptions["Other Features"] = function(_, window)
    local section = br.ui:section("Dungeon Helpers", { window = window })
    br.ui:checkbox(section, "Quaking Helper", { tip = "Auto cancel channeling and block casts during mythic+ affix quaking" })
end
