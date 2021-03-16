local _, br = ...
if br.lists == nil then
	br.lists = {}
end
-- tankBuster = List of spells that should be mitigated. Thanks Rebecca!
br.lists.tankBuster = {
    --*Castle Nathria
    --Shriekwing
    [328857] = {Type = "Physical", CanMitigate = true },-- Exsanguniating Bite
    --Huntsman Altimort
    [334971] = {Type = "Physical", CanMitigate = true },-- Jagged Claws
    --Sludgefist
    [335297] = {Type = "Physical", CanMitigate = true },-- Giant Fist
    --Stone Legion Gentrals
    [342425] = {Type = "Physical", CanMitigate = true },-- Stone Fist
    [334929] = {Type = "Physical", CanMitigate = true },-- Serrated Swipe
    --*Dungeons
    --ToP
    [320069] = {Type = "Physical", CanMitigate = true },-- Mortal Strike
    [331316] = {Type = "Physical", CanMitigate = true },-- Savage Flurry - Channeled
    [323515] = {Type = "Physical", CanMitigate = true }, --Hateful Strike
    [320644] = {Type = "Physical", CanMitigate = true },-- Brutal Combo
    [324079] = {Type = "Physical", CanMitigate = true },-- Reaping Scythe
    --DoS
    [331288] = {Type = "Physical", CanMitigate = true }, -- Colossus Smash
    [322736] = {Type = "Physical", CanMitigate = true },-- Piercing Barb
    [327646] = {Type = "Physical", CanMitigate = true },-- Soul Crusher
    [340016] = {Type = "Physical", CanMitigate = true },-- Talon Rake
    [331548] = {Type = "Physical", CanMitigate = true },-- Metallic Jaws
    --Mists
    [340289] = {Type = "Physical", CanMitigate = true },-- Triple Bite
    [340288] = {Type = "Physical", CanMitigate = true },-- Triple Bite
    [340208] = {Type = "Physical", CanMitigate = true },-- Shred Armor
    --HoA
    [322936] = {Type = "Physical", CanMitigate = true },-- Crumbling Slam
    --Pl,aguefall
    [325552] = {Type = "Physical", CanMitigate = true },-- Cytotoxic Slash
    --Sanguine
    [319650] = {Type = "Physical", CanMitigate = true },-- Vicious Headbutt
    [325254] = {Type = "Physical", CanMitigate = true },-- Iron Spikes
    [322429] = {Type = "Physical", CanMitigate = true },-- Severing Slice
    --SoA
    [320966] = {Type = "Physical", CanMitigate = true },-- Overhead Slash
    [324608] = {Type = "Magical", CanReflect = false},-- Charged Stomp
    --NW
    [320655] = {Type = "Physical", CanMitigate = true },-- Crunch
    [320376] = {Type = "Physical", CanMitigate = true },-- Mutilate
    }