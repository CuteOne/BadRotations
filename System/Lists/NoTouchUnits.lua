if br.lists == nil then
    br.lists = {}
end
-- No Touch Units = List of units that we should not attack for any reason
br.lists.noTouchUnits = {
    -- Jade Temple
    {unitID = 56448, buff = 106062}, -- Wise Mari with Bubble
    --Shadopan Monastery
    {unitID = 56747, buff = 110945}, -- Gu Cloudstrike with Charging Soul
    -- Iron Docks
    {unitID = 87451, buff = 164504, spell = 164426}, --Fleshrender Nok'gar, do not attack during defensive stance buff, Todo: Should stop when he cast 164504
    {unitID = 1, buff = 163689}, -- Never attack Sanguine Sphere
    {unitID = 105906, buff = 209915}, -- Don't attack The Eye of Il'gynoth when it has Stuff of Nightmares buff
    {unitID = 95887, buff = 194323}, -- Don't attack Glazer when he casts Focusing
    {unitID = 95888, buff = 205004}, -- Don't attack Cordana Felsong when she casts Vengeance
    {unitID = 95888, buff = 197422}, -- Don't attack Cordana Felsong when she casts Creeping Doom
    {unitID = 112956, buff = 225840}, -- Don't attack Shimmering Manaspine
    {unitID = 104154, buff = 206516}, -- Don't attack Gul'dan when he is in The Eye of Aman'Thul cage
    -- Nighthold: Mythic Spellblade - Fel Soul
    {unitID = 115905},
    -- Tomb of Sargeras
    {unitID = 116689, buff = 233441}, -- Don't attack Atrigan while Bonesaw
    {unitID = 116691, buff = 235230}, -- Don't attack Belac while Fel Squall
    {unitID = 117264, buff = -241008}, -- Don't attack Maiden of Valor unless Buff is Present *** negative buff value denotes not present ***
    -- BfA
    -- Uldir
    {unitID = 137119, buff = 271965}, -- Don't attack Taloc while Powered Down
    {unitID = 131227, buff = 260189}, -- Motherlode last boss flight
    {unitID = 136383, buff = 274230}, -- Mythrax immunity
    -- Battle of Dazar'alor
    {unitID = 144683, buff = 284436}, -- Champion of the Light (A), Ra'wani Kanae, Seal of Reckoning
    {unitID = 144680, buff = 284436}, -- Champion of the Light (H), Frida Ironbellows, Seal of Reckoning
    {unitID = 144942, buff = 289644}, -- Spark Bot,High Tinker Mekkatorque, Mythic 
    {unitID = 145644, buff = 284377}, -- Bwonsamdi with Unliving buff
    -- The Motherlode!
    {unitID = 129232, buff = 260189}, -- Mogul Razdunk with Configuration: Drill buff
    -- Underrot
    {unitID = 137458}, -- Rotting Spore
    -- Siege of Boralus
    {unitID = 128652}, -- Viq'Goth
    -- Atal'Dazar
    {unitID = 129399 , buff =250192}, -- Vol'kaal with Bad Voodoo buff
    -- Temple of Sethraliss
    {unitID = 133379, buff = 263246}, -- Adderis with Lightning Shield
    {unitID = 133944, buff = 263246}, -- Aspix with Lightning Shield
    -- Mechagon
    {unitID = 152703}, -- Walkie Shockie X1
    -- Eternal Palace
    {unitID = 152364, buff = 295916}, -- Radiance of Azshara
    {unitID = 155434, buff = 302415}, -- Emissary of Tides Teleporting Home
    {unitID = 155432, buff = 302415}, -- Enchanted Emissary Teleporting Home
    {unitID = 155433, buff = 302415}, -- Void Touched Emissary Teleporting Home
}
