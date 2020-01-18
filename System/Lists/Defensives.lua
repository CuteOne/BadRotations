if br.lists == nil then
	br.lists = {}
end
-- Crowd Control Units = list of units to stun, either always or udner certain condition such as having a buff or wirldwinding etc
br.lists.defensives = {
    {267899, "Hindering Cleave"}, -- Shrine of the Storm
    {272457, "Shockwave"}, -- Underrot
    {260508, "Crush"}, -- Waycrest Manor
    {249919, "Skewer"}, -- Atal'Dazar
    {265910, "Tail Thrash"}, -- King's Rest
    {268586, "Blade Combo"}, -- King's Rest
    {262277, "Terrible Thrash"}, -- Fetid Devourer
    {265248, "Shatter"}, -- Zek'voz
    {273316, "Bloody Cleave"}, -- Zul, Reborn
    {273282, "Essence Shear"}, -- Mythrax the Unraveler
    {300877, "System Shock"}, -- Queen Azshara
    {296566, "Tide Fist"}, -- Radiance of Azshara
    {297585, "Obey or Suffer"}, -- The Queens Court
}