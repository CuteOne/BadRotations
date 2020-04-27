if br.lists == nil then
	br.lists = {}
end
-- Interrupt Whitelist - A list of spells we know for sure we want to interrupt (Typically in Dungeons and Raids)
br.lists.interruptWhitelist = {
	-- Horrific visions start
	[309648] = true, -- Tainted Polymorph
	[308375] = true, -- Psychic Scream
	[297315] = true, -- Void Buffet
	[308366] = true, -- Agonizing Torment
	[308575] = true, -- Shadow Shift
	[304251] = true, -- Void Quills
	[298033] = true, -- Touch of the Abyss
	[288915] = true, -- Horrifying
	-- Horrific visions end
	-- Atal'Dazar start
	[255824] = true, -- fanatic rage
	[253583] = true, -- Fiery Enchant
	[253544] = true, -- bwonsamdismantle
	[253517] = true, -- mending word
	[256849] = true, -- dinomight
    [259572] = true, -- noxious-stench
    [250096] = true, -- wracking-pain
    [255041] = true, -- terrifying-screech
    [279118] = true, -- unstable-hex
	-- Atal'Dazar end
	-- Shrine of Storm start
	[268030] = true, -- mending-rapids
	[274438] = true, -- tempest
	-- [267818] = true, -- slicing-blast
	[268309] = true, -- unending-darkness
	[268317] = true, -- rip-mind
	[276767] = true, -- consuming-void
	[268375] = true, -- detect-thoughts
	[267809] = true, -- consume-essence
	[268322] = true, -- drowned kick
	[267977] = true, -- tidal surge
	[267969] = true, -- water blast
	-- Shrine of Storm end
	-- Motherload! start
	[268129] = true, -- kajacola-refresher
	[268709] = true, -- earth-shield
	[268702] = true, -- furious-quake
	[263215] = true, -- tectonic-barrier
	[262540] = true, -- overcharge
	[269090] = true, -- artillery-barrage
	[263103] = true, -- Blowtorch
	[263066] = true, -- TransSyrum
	[268797] = true, -- EnemyToGoo
	[262092] = true, -- InhaleVapors
	[280604] = true, -- ice-spritzer
	-- Motherload! end
	-- Underrot start
	[265089] = true, -- dark-reconstitution
	[278755] = true, -- harrowing-despair
	[260879] = true, -- blood-bolt
	[278961] = true, -- decaying-mind
	[266201] = true, -- bone-shield
	[272183] = true, -- raise-dead
	[265433] = true, -- withering-curse
	[272180] = true, -- death-bolt
	[266106] = true, -- sonic screech
	[265523] = true, -- spiritdraintotem
	[265091] = true, -- gift of ghuun
	-- Underrot end
	-- Freehold start
	[257397] = true, -- healing-balm
	[258777] = true, -- sea-spout
	[257732] = true, -- shattering-bellow
	[257736] = true, -- thundering-squall
	[256060] = true, -- revitalizing-brew
	[257784] = true, -- Frostblast
	-- Freehold end
	-- Waycrest Manor start
	[265368] = true, -- spirited-defense
	[263891] = true, -- grasping-thorns
	[266035] = true, -- bone-splinter
	[266036] = true, -- drain-essence
	[278551] = true, -- soul-fetish
	[278474] = true, -- effigy-reconstruction
	[264050] = true, -- infected-thorn
	[264520] = true, -- severing-serpent
	[263943] = true, -- etch
	[265407] = true, -- dinner-bell
	[265876] = true, -- ruinous-volley
	[264105] = true, -- runic-mark
	[263959] = true, -- soul-volley
	[268278] = true, -- wracking-chord
	[266225] = true, -- darkened-lightning
	-- Waycrest Manor end
	-- Temple of Sethraliss start
	[265968] = true, -- healing-surge
	[263318] = true, -- jolt
	[261635] = true, -- stoneshield-potion
	[261624] = true, -- greater-healing-potion
	[265912] = true, -- accumulate-charge
	[272820] = true, -- shock
	[268061] = true, -- chain-lightning
	-- Temple of Sethraliss end
	-- Kings Rest start
	[270901] = true, -- induce-regeneration
	[267763] = true, -- wretched-discharge
	[270492] = true, -- hex
	[267273] = true, -- poison-nova
	[269972] = true, -- shadow-bolt-volley
	[270923] = true, -- shadow-bolt
	[269973] = true, -- deathlychill
	-- Kings Rest end
	-- Tol Dagor start
	[258128] = true, -- debilitating-shout
	[258153] = true, -- watery-dome
	[257791] = true, -- howling-fear
	[258313] = true, -- handcuff
	[258634] = true, -- fuselighter
	[258935] = true, -- inner-flames
	-- Tol Dagor end
	-- Siege of Boralus start
	[274569] = true, -- revitalizing-mist
	[272571] = true, -- choking-waters
	[256957] = true, -- watertight-shell
	-- Siege of Boralus end
	-- Battle of Dazarlor start
	[283628] = true, -- Heal of the forces of the crusade, champion of the light encounter
	[282243] = true, -- Apetagonize, Grong encounter
	[289596] = true, -- For the King, 7th Legion Cavalier
	[286379] = true, -- Pyroblast, Jade Masters encounter
	[286563] = true, -- Tidal Empowerment, Brother Joseph , Stormwall Blockade encounter
	[287887] = true, -- Storm's Empowerment, Sister Katherine , Stormwall Blockade encounter
	[289861] = true, -- Howling Winds, Lady Jaina Proudmoore
	[287419] = true, -- Angelic Renewal, Disciples Boss-Heal on Mythic Champions of Light.
	-- Battle of Dazarlor end
	-- Mechagon Start
	[300650] = true, -- Suffocating Smog, Toxic Lurkers
	[300414] = true, -- Enrage, Scrapbone Grinders
	[300171] = true, -- Repair Protocol, Heavy Scrapbot
	[299588] = true, -- Overclock, Pistonhead Mechanic
	[300087] = true, -- Repair, Pistonhead Mechanic
	[298669] = true, -- Taze, Trixie Tazer
	[300514] = true, -- Stoneskin, Scrapbone Shamans
	[300436] = true, -- Grasping Hex, Scrapbone Shamans
	[301629] = true, -- Enlarge, Mechagon Renormalizer
	[284219] = true, -- Shrink, Mechagon Renormalizer
	[301689] = true, -- Charged Coil, Anodized Coilbearer
	[301088] = true, -- Detonate, Bomb Tonk
	[293930] = true, -- Overclock, Mechagon Mechanic
	[293729] = true, -- Tune Up, Mechagon Mechanic
	-- Mechagon End
	-- Eternal Palace Start
	[296673] = true, -- Chain Lightning, Stormling
	[295822] = true, -- Conductive Pulse, Azsh'ari Witch
	[297972] = true, -- Chain Lightning, Aethanel, Tidemistress
	[300491] = true, -- Drain Ancient Ward, Tidemistress
	[300490] = true, -- Energize Ward of Power, Tidemistress
	-- Eternal Palace End
	-- Ny'alotha, the Waking City Start
	[316211] = true, -- Terror Wave, Awakened Terror
	[307177] = true, -- Void Bolt, Spellbound Ritualist
	[313652] = true, -- Mind-Numbing Nova, Hivemind
	[310552] = true, -- Mind Flay, Appendages Adds
	[310788] = true, -- Pumping Blood, Organ of Corruption
	[313364] = true, -- Mental Decay, Servant of N'Zoth
	[313400] = true, -- Corrupted Mind, Corruptor Tentacle
	[316711] = true, -- Mindwrack, Psychus
	-- Ny'alotha, the Waking City End
	-- Old Content start
	[191823] = true, -- Furious Blast
	[191848] = true, -- Rampage
	[192003] = true, -- Blazing Nova
	[192005] = true, -- Arcane Blast
	[192135] = true, -- Bellowing Roar
	[192288] = true, -- Searing Light
	[192563] = true, -- Cleansing Flames
	[193069] = true, -- Nightmares
	[193585] = true, -- Bound
	[194266] = true, -- Void Snap
	[194657] = true, -- Soul Siphon
	[195046] = true, -- Rejuvenating Waters
	[195129] = true, -- Thundering Stomp
	[195293] = true, -- Debilitating Shout
	[196027] = true, -- Aqua Spout
	[196175] = true, -- Armorshell
	[196392] = true, -- Overcharge Mana
	[196870] = true, -- Storm
	[196883] = true, -- Spirit Blast
	[197105] = true, -- Polymorph: Fish
	[197502] = true, -- Restoration
	[198405] = true, -- Bone Chilling Scream
	[198495] = true, -- Torrent
	[198750] = true, -- Surge
	[198931] = true, -- Healing Light
	[198934] = true, -- Rune of Healing
	[198962] = true, -- Shattered Rune
	[199514] = true, -- Torrent of Souls
	[199589] = true, -- Whirlpool of Souls
	[199726] = true, -- Unruly Yell
	[200248] = true, -- Arcane Blitz
	[200642] = true, -- Despair
	[200658] = true, -- Star Shower
	[200905] = true, -- Sap Soul
	[201400] = true, -- Dread Inferno
	[201488] = true, -- Frightening Shout
	[202181] = true, -- Stone Gaze
	[202658] = true, -- Drain
	[203176] = true, -- Accelerating Blast
	[203957] = true, -- Time Lock
	[204140] = true, -- Shield of Eyes
	[204243] = true, -- Tormenting Eye
	[204963] = true, -- Shadow Bolt Volley
	[205070] = true, -- Spread Infestation
	[205088] = true, -- Blazing Hellfire
	[205112] = true, -- Drain Essence
	[205121] = true, -- Chaos Bolt
	[205298] = true, -- Essence of Corruption
	[205300] = true, -- Corruption
	[207980] = true, -- Disintegration Beam
	[208165] = true, -- Withering Soul
	[208697] = true, -- Mind Flay
	[209404] = true, -- Seal Magic
	[209410] = true, -- Nightfall Orb
	[209413] = true, -- Suppress
	[209485] = true, -- Drain Magic
	[210261] = true, -- Sound Alarm
	[210684] = true, -- Siphon Essence
	[211007] = true, -- Eye of the Vortex
	[211115] = true, -- Phase Breach
	[211299] = true, -- Searing Glare
	[211368] = true, -- Twisted Touch of Life
	[211401] = true, -- Drifting Embers
	[211464] = true, -- Fel Detonation
	[211470] = true, -- Bewitch
	[211632] = true, -- Brand of the Legion
	[211757] = true, -- Portal: Argus
	[215204] = true, -- Hinder
	[216197] = true, -- Surging Waters
	[218532] = true, -- Arc Lightning
	[221059] = true, -- Wave of Decay
	[222939] = true, -- Shadow Volley
	[223038] = true, -- Erupting Terror
	[223392] = true, -- Dread Wrath Volley
	[223423] = true, -- Nightmare Spores
	[223565] = true, -- Screech
	[223590] = true, -- Darkfall
	[224460] = true, -- Venom Nova
	[225042] = true, -- Corrupt
	[225073] = true, -- Despoiling Roots
	[225079] = true, -- Raining Filth
	[225100] = true, -- Charging Station
	[225573] = true, -- Dark Mending
	[226206] = true, -- Arcane Reconstitution
	[226269] = true, -- Torment
	[226285] = true, -- Demonic Ascension
	[227592] = true, -- Frostbite
	[227800] = true, -- Holy Shock
	[227823] = true, -- Holy Wrath
	[230084] = true, -- Stabilize Rift
	[207228] = true, -- Warp Nightwell
	[213281] = true, -- Pyroblast
	[209017] = true, -- Felblast
	[209971] = true, -- Albative Pulse
	[209568] = true, -- Exothermic Release
	[209617] = true, -- Expedite
	[208672] = true, -- Carrion wave
	[239401] = true, -- Pangs of Guild (Belac)
	[233371] = true, -- Watery Splash (Harjatan fight)
	[241509] = true, -- Water Blast (Mistress fight)
	[200631] = true, -- Unnerving Screech
	[225562] = true, -- Blood Metamorphosis
    [211875] = true, -- Bladestorm
    [152964] = true, -- Void Spawn casting Void Pulse, trash mobs
    [156776] = true, -- Shadowmoon Enslavers channeling Rending Voidlash
    [156717] = true, -- Monstrous Corpse Spider casting Death Venom
    [154527] = true, -- Bend Will, MC a friendly.
    [154623] = true, -- Void Mending
    [157794] = true, -- Arcane Bomb
    [154415] = true, -- Mind Spike
    [154218] = true, -- Arbiters Hammer
    [154235] = true, -- Arcane Bolt
    [154221] = true, -- Fel Blast
    [156854] = true, -- Drain Life
    [156854] = true, -- Drain Life, Terengor
    [156857] = true, -- Rain Of Fire
    [164846] = true, -- Chaos Bolt
    [156963] = true, -- Incenerate
    [166335] = true, -- Storm Shield
    [155504] = true, -- Debiliting Ray
    [161199] = true, -- Debiliting Fixation from Kyrak
    [167259] = true, -- Intimidating shout
    [169151] = true, -- Summon Black Iron Veteran
    [142238] = true, -- Illusionary Mystic (Heal)
	-- Old Content end
}
