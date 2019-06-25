-- macro used to gather caster/spell/buff on our actual target
SLASH_dumpInfo1 = "/dumpinfo"
function SlashCmdList.dumpInfo(msg, editbox)
	-- find unit in our engines
	for k, v in pairs(br.enemy) do
		if br.enemy[k].guid == UnitGUID("target") then
			targetInfo = { }
			targetInfo.name = UnitName("target")
			local thisUnit = br.enemy[k].unit
			targetInfo.unitID = thisUnit.id
			local spellCastersTable = br.im.casters
			for j = 1, #spellCastersTable do
				if spellCastersTable[j].unit == thisUnit.unit then
					if casterName ~= false then
						local thisCaster = spellCastersTable[j]
						targetInfo.spellID = thisCaster.cast
						targetInfo.lenght = thisCaster.castLenght
						targetInfo.castInterruptible = castNotInterruptible == false
						targetInfo.castType = castOrChan
					end
				end
			end
			local buff1 = UnitBuff("target",1)
			local buff2 = UnitBuff("target",2)
			local deBuff1 = UnitBuff("target",1)
			local deBuff2 = UnitBuff("target",2)
			if buff1 then
				targetInfo.buff1 = buff1
			end
			if buff2 then
				targetInfo.buff2 = buff2
			end
			if deBuff1 then
				targetInfo.deBuff1 = deBuff1
			end
			if deBuff2 then
				targetInfo.deBuff2 = deBuff2
			end
			RunMacroText("/dump targetInfo")
			targetInfo = { }
			break
		end
	end
end
-- in order to better handle the spells we will need to read spells beign casted from reader rather than scanning for it
-- we will need to find a way to match casters with units in the enemeiesTable probably trough GUID
-- and add the values live via the handler we will already scan our list of interuptCandidates and only add them to the
-- spellCastersTable once and then profile side we will deploy functions to read the table.

-- Units with spells that should be interrupted if possible. Good to have units so we can save interrupting spells when targeting them.
interruptCandidates = {
	-- Shadowmoon Burial Grounds
	{ unitID = 75652, spell = 152964 }, -- Void Spawn casting Void Pulse, trash mobs
	{ unitID = 76446, spell = 156776 }, -- Shadowmoon Enslavers channeling Rending Voidlash
	{ unitID = 76104, spell = 156717 }, -- Monstrous Corpse Spider casting Death Venom
	--Auchindon
	{ unitID = 77812, spell = 154527 }, -- Bend Will, MC a friendly.
	{ unitID = 77131, spell = 154623 }, -- Void Mending
	{ unitID = 76263, spell = 157794 }, -- Arcane Bomb
	{ unitID = 86218, spell = 154415 }, -- Mind Spike
	{ unitID = 76284, spell = 154218 }, -- Arbiters Hammer
	{ unitID = 76296, spell = 154235 }, -- Arcane Bolt
	{ unitID = 79510, spell = 154221 }, -- Fel Blast
	{ unitID = 78437, spell = 156854 }, -- Drain Life
	{ unitID = 86330, spell = 156854 }, -- Drain Life, Terengor
	{ unitID = 86330, spell = 156857 }, -- Rain Of Fire
	{ unitID = 86330, spell = 164846 }, -- Chaos Bolt
	{ unitID = 86330, spell = 156963 }, -- Incenerate
	--Grimral Depot
	{ unitID = 82579, spell = 166335 }, -- Storm Shield
	-- UBRS
	{ unitID = 76101, spell = 155504 }, -- Debiliting Ray
	{ unitID = 76021, spell = 161199 }, -- Debiliting Fixation from Kyrak
	{ unitID = 77037, spell = 167259 }, -- Intimidating shout
	{ unitID = 77036, spell = 169151 }, -- Summon Black Iron Veteran
	-- proving ground DPS
	{ unitID = 0, spell = 142238 }, -- Illusionary Mystic (Heal)
--{ unitID = 0, spell= 142190} -- Amber Sphere
}
-- List of units that are hitting hard, ie when its good to use defensive CDs
dangerousUnits  = {
	-- Shadowmoon Burial Grounds
	{ unitID = 86234, buff = 162696, spell = 162696 }, -- Sadana buffed with deathspikes
	{ unitID = 75829, buff = 152792, spell = 152792 }, -- Nhallish casting Void Blast or buffed
	-- Grimrail Depot
	{ unitID = 86226, buff = 161092, spell = 1      }, -- Borkas unmanged Agression
	{ unitID = 86226, buff = 178412, spell = 178412 }, -- Borkas unmanged Agression
--{ unitID = 86226, buff = 1,    spell = 161089 }, -- Borkas Mad Dash, small CD Todo: We should add minor major values to this so we can determine if its a big CD or small to be used
}
dispellOffensiveBuffs = {
	--[164257] = "Enrage", -- ogres gorgrond
	-- Auchindon
	[160312] = "Magic",-- Void Shell
	-- UBRS
	[153909] = "Enrage",-- Frenzy
	[161203] = "Magic",-- Rejuvenating Serum
	[81173] = "Enrage",-- Frenzy
	--61574,-- Banner of the horde (dummy buff just to test)
	-- lib dispel
	[8599] = "Enrage",[12880] = "Enrage",[15061] = "Enrage",[15716] = "Enrage",[18499] = "Enrage",
	[18501] = "Enrage",[19451] = "Enrage",[19812] = "Enrage",[22428] = "Enrage",[23128] = "Enrage",
	[23257] = "Enrage",[23342] = "Enrage",[24689] = "Enrage",[26041] = "Enrage",[26051] = "Enrage",
	[28371] = "Enrage",[30485] = "Enrage",[31540] = "Enrage",[31915] = "Enrage",[32714] = "Enrage",
	[33958] = "Enrage",[34670] = "Enrage",[37605] = "Enrage",[37648] = "Enrage",[37975] = "Enrage",
	[38046] = "Enrage",[38166] = "Enrage",[38664] = "Enrage",[39031] = "Enrage",[39575] = "Enrage",
	[40076] = "Enrage",[41254] = "Enrage",[41447] = "Enrage",[42705] = "Enrage",[42745] = "Enrage",
	[43139] = "Enrage",[47399] = "Enrage",[48138] = "Enrage",[48142] = "Enrage",[48193] = "Enrage",
	[50420] = "Enrage",[51513] = "Enrage",[52262] = "Enrage",[52470] = "Enrage",[54427] = "Enrage",
	[55285] = "Enrage",[56646] = "Enrage",[57733] = "Enrage",[58942] = "Enrage",[59465] = "Enrage",
	[59697] = "Enrage",[59707] = "Enrage",[59828] = "Enrage",[60075] = "Enrage",[61369] = "Enrage",
	[63227] = "Enrage",[66092] = "Enrage",[68541] = "Enrage",[70371] = "Enrage",[72143] = "Enrage",
	[75998] = "Enrage",[76100] = "Enrage",[76862] = "Enrage",[77238] = "Enrage",[78722] = "Enrage",
	[78943] = "Enrage",[80084] = "Enrage",[80467] = "Enrage",[86736] = "Enrage",[102134] = "Enrage",
	[102989] = "Enrage",[106925] = "Enrage",[108169] = "Enrage",[109889] = "Enrage",[111220] = "Enrage",
	[115430] = "Enrage",[117837] = "Enrage",[119629] = "Enrage",[123936] = "Enrage",[124019] = "Enrage",
	[124309] = "Enrage",[126370] = "Enrage",[127823] = "Enrage",[127955] = "Enrage",[128231] = "Enrage",
	[129016] = "Enrage",[129874] = "Enrage",[130196] = "Enrage",[130202] = "Enrage",[131150] = "Enrage",
	[135524] = "Enrage",[135548] = "Enrage",[142760] = "Enrage",[148295] = "Enrage",[151553] = "Enrage",
	[154017] = "Enrage",[155620] = "Enrage",[164324] = "Enrage",[164835] = "Enrage",[175743] = "Enrage",
	[144351] = "Magic"
}
interruptWhitelist = {
	-- Atal'Dazar start
	[255824] = true, -- fanatic rage
	[253583] = true, -- Fiery Enchant
	[253544] = true, -- bwonsamdismantle
	[253517] = true, -- mending word
	[256849] = true, -- dinomight
    [250368] = true, -- noxious-stench
    [250096] = true, -- wracking-pain
    [255041] = true, -- terrifying-screech
    [279118] = true, -- unstable-hex
	-- Atal'Dazar end
	-- Shrine of Storm start
	[268030] = true, -- mending-rapids
	[274438] = true, -- tempest
	[267818] = true, -- slicing-blast
	[268309] = true, -- unending-darkness
	[268317] = true, -- rip-mind
	[276767] = true, -- consuming-void
	[268375] = true, -- detect-thoughts
	[267809] = true, -- consume-essence
	[268322] = true, -- drowned kick
	[267977] = true, -- tidal surge
	-- Shrine of Storm end
	-- Motherload! start
	[268129] = true, -- kajacola-refresher
	[268709] = true, -- earth-shield
	[268702] = true, -- furious-quake
	[263215] = true, -- tectonic-barrier
	[263066] = true, -- transfiguration-serum
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
	-- Old Content end
}
validUnitBypassList = {
	[133492] = "Corruption Corpuscle",
	[135016] = "Plague Amalgam",
	[131009] = "Spirit of Gold", --Atal
	[125828] = "Soulspawn", --Atal
    [134691] = "Static Charged Dervish", --Temple
    [147218] = "Spirit of Gold", --Opulence
    [148436] = "Barrier", --Jadefire Masters
	[148415] = "Barrier", --Jadefire Masters
	[147377] = "Barrier", --Jadefire Masters
	[147376] = "Barrier", --Jadefire Masters
    [147374] = "Barrier", --Jadefire Masters
    [147375] = "Barrier", --Jadefire Masters
	[146756] = "Energized Storm", --Jadefire Masters
	[146107] = "Living Bomb", -- Jadefire Masters
	[148522] = "Ice Block", --Jaina
	[148907] = "Prismatic Image", --Jaina
    [148716] = "Risen Soul", --M+ Reaping
    [148893] = "Tormented Soul", --M+ Reaping
	[148894] = "Lost Soul", --M+ Reaping
	[120651] = "Explosive", -- Explosive
	[136330] = "Soul Thorns", -- Soul Thorns Waycrest Manor
	[134388] = "A Knot of Snakes" -- A Knot of Snakes ToS
}

-- rangeOrMelee = {
-- 	[250] = "melee",
-- 	[251] = "melee",
-- 	[252] = "melee",
-- 	[577] = "melee",
-- 	[581] = "melee",
-- 	[102] = "ranged",
-- 	[103] = "melee",
-- 	[104] = "melee",
-- 	[105] = "ranged",
-- 	[253] = "ranged",
-- 	[254] = "ranged",
-- 	[255] = "melee",
-- 	[62] = "ranged",
-- 	[63] = "ranged",
-- 	[64] = "ranged",
-- 	[268] = "melee",
-- 	[269] = "melee",
-- 	[270] = "ranged",
-- 	[65] = "ranged",
-- 	[66] = "melee",
-- 	[70] = "melee",
-- 	[256] = "ranged",
-- 	[257] = "ranged",
-- 	[258] = "ranged",
-- 	[259] = "melee",
-- 	[260] = "melee",
-- 	[261] = "melee",
-- 	[262] = "ranged",
-- 	[263] = "melee",
-- 	[264] = "ranged",
-- 	[265] = "ranged",
-- 	[266] = "ranged",
-- 	[267] = "ranged",
-- 	[71] = "melee",
-- 	[72] = "melee",
-- 	[73] = "melee",
-- }
