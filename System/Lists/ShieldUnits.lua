local _, br = ...
if br.lists == nil then
	br.lists = {}
end
-- Shield Units: "soft shields" that REDUCE incoming damage.
-- These should DEPRIORITIZE targets (via coefficient penalty) when "Avoid Shields" is enabled.
-- Do NOT use this list for invulnerability/phase/reflect mechanics that should hard-block targeting.
-- Hard "do not attack" mechanics belong in NoTouchUnits.lua (and are enforced by isSafeToAttack()).
br.lists.shieldUnits = {
	--[[===========================]]
	--[[  CLASSIC / VANILLA (60)   ]]
	--[[===========================]]

	-- Stratholme
	[10811] = {coef = -75, buff = 17086}, -- Archimondethe Dreadlord Carrion Swarm - 75% reduction

	-- Scholomance (Vanilla)
	[10506] = {coef = -50, buff = 16799}, -- Kirtonos Shield - 50% reduction

	-- Blackrock Depths
	[9019] = {coef = -90, buff = 13704}, -- Emperor Dagran Avatar of Flame - 90% reduction

	-- Upper Blackrock Spire
	[10363] = {coef = -75, buff = 15732}, -- General Drakkisath Conflagration Shield - 75% reduction
	[10814] = {coef = -50, buff = 15816}, -- Chromatic Elite Guard Shield - 50% reduction

	-- Sunken Temple
	[5721] = {coef = -50, buff = 12533}, -- Dreamscythe Dream Fog - 50% reduction

	-- Maraudon
	[13282] = {coef = -60, buff = 21909}, -- Noxxion Toxic Volley - 60% reduction

	-- Molten Core
	[12018] = {coef = -50, buff = 19595}, -- Majordomo Shield of Flame - 50% reduction

	-- Blackwing Lair
	[11583] = {coef = -75, buff = 23414}, -- Nefarian Shadow Flame - 75% reduction

	--[[===========================]]
	--[[  BURNING CRUSADE (70)     ]]
	--[[===========================]]

	-- Shadow Labyrinth
	[18667] = {coef = -75, buff = 33676}, -- Blackheart Incite Chaos - 75% reduction when charmed

	-- Shattered Halls
	[20923] = {coef = -90, buff = 31901}, -- Blood Guard Porung Shield Wall - 90% reduction

	-- Mana-Tombs
	[18341] = {coef = -50, buff = 32361}, -- Pandemonius Void Shield - 50% reduction

	-- Auchenai Crypts
	[18373] = {coef = -99, buff = 32424}, -- Exarch Maladaar Avatar Shield - 99% reduction

	-- Sethekk Halls
	[18473] = {coef = -50, buff = 32690}, -- Talon King Ikiss Shield - 50% reduction

	-- Black Morass
	[17879] = {coef = -75, buff = 31473}, -- Chrono Lord Time Shield - 75% reduction

	-- Mechanar
	[19219] = {coef = -100, buff = 35159}, -- Mechano-Lord Reflective Shield - 100% damage reflect

	-- Blood Furnace
	[17381] = {coef = -60, buff = 30923}, -- The Maker Domination - 60% reduction when controlling

	-- Botanica
	[17976] = {coef = -75, buff = 34670}, -- Commander Sarannis Arcane Resonance - 75% reduction

	-- Slave Pens
	[17941] = {coef = -50, buff = 31946}, -- Mennu Corrupted Nova - 50% reduction

	-- Steamvault
	[17797] = {coef = -60, buff = 33234}, -- Hydromancer Water Shield - 60% reduction

	--[[===========================]]
	--[[  WRATH OF THE LICH KING (80) ]]
	--[[===========================]]

	-- Violet Hold
	[31134] = {coef = -75, buff = 58040}, -- Cyanigosa Arcane Shield - 75% reduction

	-- Halls of Lightning
	[28586] = {coef = -90, buff = 52770}, -- General Bjarngrim Defensive Stance - 90% reduction

	-- Culling of Stratholme
	[26532] = {coef = -75, buff = 52552}, -- Chrono-Lord Epoch Time Shield - 75% reduction

	-- Pit of Saron
	[36494] = {coef = -80, buff = 70326}, -- Forgemaster Garfrost Permafrost - 80% reduction

	-- Halls of Reflection
	[38112] = {coef = -99, buff = 72198}, -- Lich King Remorseless Winter - 99% reduction

	-- Gundrak
	[29305] = {coef = -50, buff = 55081}, -- Slad'ran Snake Wrap - 50% reduction

	-- Drak'Tharon Keep
	[26630] = {coef = -60, buff = 49405}, -- Trollgore Consume - 60% reduction

	-- Utgarde Pinnacle
	[26687] = {coef = -50, buff = 48894}, -- Gortok Palehoof Impale - 50% reduction frontal

	-- Oculus
	[27447] = {coef = -75, buff = 50240}, -- Mage-Lord Urom Time Bomb Shield - 75% reduction

	-- Icecrown Citadel
	[37890] = {coef = -100, buff = 70842}, -- Cult Adherent Dark Martyrdom - 100% absorption

	--[[===========================]]
	--[[  CATACLYSM (85)           ]]
	--[[===========================]]

	-- Throne of the Tides
	[40586] = {coef = -80, buff = 76047}, -- Lady Naz'jar Water Shield - 80% reduction
	[40765] = {coef = -60, buff = 76815}, -- Commander Ulthok Dark Fissure - 60% reduction

	-- Vortex Pinnacle
	[43878] = {coef = -90, buff = 87761}, -- Grand Vizier Ertan Cyclone Shield - 90% reduction
	[43875] = {coef = -75, buff = 88282}, -- Asaad Supremacy Shield - 75% reduction

	-- Stonecore
	[43438] = {coef = -80, buff = 92633}, -- High Priestess Azil Gravity Well - 80% reduction
	[43214] = {coef = -70, buff = 86855}, -- Slabhide Lava Fissure - 70% reduction

	-- Blackrock Caverns
	[39679] = {coef = -75, buff = 75608}, -- Corla Dark Command - 75% reduction
	[39625] = {coef = -60, buff = 74837}, -- General Umbriss Bleeding Wound - 60% reduction

	-- Grim Batol
	[40177] = {coef = -90, buff = 76634}, -- Forgemaster Throngus Disorienting Roar - 90% reduction
	[40319] = {coef = -75, buff = 75889}, -- Drahga Burning Shadowbolt Shield - 75% reduction

	-- Lost City of Tol'vir
	[44577] = {coef = -50, buff = 83445}, -- General Husam Shockwave Shield - 50% reduction

	-- Halls of Origination
	[39428] = {coef = -99, buff = 75323}, -- Temple Guardian Shield - 99% reduction during phase
	[39731] = {coef = -75, buff = 89878}, -- Rajh Sun Strike Shield - 75% reduction

	-- Deadmines (Heroic)
	[47162] = {coef = -60, buff = 88009}, -- Glubtok Frost Shield - 60% reduction

	-- Shadowfang Keep (Heroic)
	[46962] = {coef = -50, buff = 93468}, -- Baron Ashbury Pain and Suffering - 50% reduction

	-- Zul'Aman (Heroic)
	[23574] = {coef = -75, buff = 43648}, -- Akil'zon Electrical Storm - 75% reduction
	[24239] = {coef = -90, buff = 43590}, -- Hex Lord Spirit Bolts Shield - 90% reduction

	-- Zul'Gurub (Heroic)
	[52258] = {coef = -80, buff = 96776}, -- Gri'lek Pursuit Shield - 80% reduction

	-- End Time
	[54431] = {coef = -75, buff = 101927}, -- Echo of Baine Pulverize Shield - 75% reduction

	-- Well of Eternity
	[54853] = {coef = -99, buff = 104600}, -- Peroth'arn Endless Frenzy - 99% reduction

	-- Hour of Twilight
	[54590] = {coef = -80, buff = 102582}, -- Arcurion Icy Tomb - 80% reduction
	[54432] = {coef = -90, buff = 103780}, -- Archbishop Benedictus Twilight Shear Shield - 90% reduction

	-- Firelands
	[52530] = {coef = -99, buff = 99516}, -- Alysrazor Blazing Power - 99% reduction

	--[[===========================]]
	--[[  MISTS OF PANDARIA CLASSIC ]]
	--[[===========================]]

	-- Stormstout Brewery
	[59479] = {coef = -90, buff = 115003}, -- Yan-Zhu Wall of Suds - 90% damage reduction

	-- Scarlet Halls
	[59303] = {coef = -50, buff = 113395}, -- Armsmaster Harlan Blade Storm - 50% damage reduction

	-- Scholomance
	[58791] = {coef = -75, buff = 111606}, -- Rattlegore Rusting - 75% damage reduction

	-- Mogu'shan Palace
	[61398] = {coef = -50, buff = 119946}, -- Gekkan Reckless Inspiration - 50% damage reduction

	-- Siege of Niuzao Temple
	[62205] = {coef = -70, buff = 119073}, -- Wing Leader Ner'onok Gusting Winds - 70% damage reduction

	-- Throne of Thunder (Raid)
	[68476] = {coef = -90, buff = 136413}, -- Horridon Dinomancy Shield - 90% damage reduction
	[69427] = {coef = -95, buff = 137654}, -- Tortos Spinning Shell - 95% damage reduction
	[68397] = {coef = -99, buff = 134691}, -- Council of Elders Blessed Loa Spirit - 99% damage reduction

	-- Siege of Orgrimmar (Raid)
	[71479] = {coef = -99, buff = 143480}, -- Malkorok Ancient Barrier - 99% damage reduction
	[71543] = {coef = -75, buff = 143502}, -- Siegecrafter Blackfuse Protective Frenzy - 75% damage reduction
	[71152] = {coef = -90, buff = 145071}, -- Paragons Genetic Alteration - 90% damage reduction

	--[[===========================]]
	--[[  LATER EXPANSIONS (KEEP)  ]]
	--[[===========================]]

	-- Proving Grounds
	[71072] = {coef = -90, buff = 142427}, -- Proving ground Sha shielded (will unshield later so better wait)
	[71064] = {coef = -100, buff = 142174, frontal = true}, -- when shielded and we are in front of unit, dont attack
	[71079] = {coef = -100, buff = 142174, frontal = true}, -- when shielded and we are in front of unit, dont attack
	-- Agatha Challenge Skin
	[115638] = {coef = -200, buff = 243027}, -- Shadow Shield
	-- BFA dungeons
	[134158] = {coef = -100, spell = 269928, frontal = true},
	-- Timewalking
	[29309] = {coef = -100, buff = 56153}, -- Elder Nadox: Ahn'kahet The Old Kingdom (Invulnerable buff from Ahn'kahar Guardian)
	[30178] = {coef = -100, buff = 56153}, -- Ahn'kahar Swarmer: Ahn'kahet The Old Kingdom (Invulnerable buff from Ahn'kahar Guardian)
	-- Castle Nathria
	[165318] = {coef = -100, buff = 329636}, -- Stone Legion Generals (Kaal) - Takes 95% reduced damage during Hardened Stone Forms
	[170323] = {coef = -100, buff = 329636}, -- Stone Legion Generals (Grashaal) - Takes 95% reduced damage during Hardened Stone Forms
}
