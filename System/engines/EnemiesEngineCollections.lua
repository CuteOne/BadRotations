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
interruptWhitelist = { -- List provided by Admire
	-- Shrine of storm start
        268030, -- mending-rapids
	274438, -- tempest
	267818, -- slicing-blast
	268309, -- unending-darkness
	268317, -- rip-mind
	276767, -- consuming-void
	268375, -- detect-thoughts
	267809, -- consume-essence
	267459, -- consume-essence Boss
	-- Shrine of storm end
	
        -- Motherload! start
	268129, -- kajacola-refresher
	268709, -- earth-shield
	268702, -- furious-quake
	263215, -- tectonic-barrier
	263066, -- transfiguration-serum
	262540, -- overcharge
	269090, -- artillery-barrage
	263202, -- rock-lance
	-- Motherload! end
	
	191823, -- Furious Blast
	191848, -- Rampage
	192003, -- Blazing Nova
	192005, -- Arcane Blast
	192135, -- Bellowing Roar
	192288, -- Searing Light
	192563, -- Cleansing Flames
	193069, -- Nightmares
	193585, -- Bound
	194266, -- Void Snap
	194657, -- Soul Siphon
	195046, -- Rejuvenating Waters
	195129, -- Thundering Stomp
	195293, -- Debilitating Shout
	196027, -- Aqua Spout
	196175, -- Armorshell
	196392, -- Overcharge Mana
	196870, -- Storm
	196883, -- Spirit Blast
	197105, -- Polymorph: Fish
	197502, -- Restoration
	198405, -- Bone Chilling Scream
	198495, -- Torrent
	198750, -- Surge
	198931, -- Healing Light
	198934, -- Rune of Healing
	198962, -- Shattered Rune
	199514, -- Torrent of Souls
	199589, -- Whirlpool of Souls
	199726, -- Unruly Yell
	200248, -- Arcane Blitz
	200642, -- Despair
	200658, -- Star Shower
	200905, -- Sap Soul
	201400, -- Dread Inferno
	201488, -- Frightening Shout
	202181, -- Stone Gaze
	202658, -- Drain
	203176, -- Accelerating Blast
	203957, -- Time Lock
	204140, -- Shield of Eyes
	204243, -- Tormenting Eye
	204963, -- Shadow Bolt Volley
	205070, -- Spread Infestation
	205088, -- Blazing Hellfire
	205112, -- Drain Essence
	205121, -- Chaos Bolt
	205298, -- Essence of Corruption
	205300, -- Corruption
	207980, -- Disintegration Beam
	208165, -- Withering Soul
	208697, -- Mind Flay
	209404, -- Seal Magic
	209410, -- Nightfall Orb
	209413, -- Suppress
	209485, -- Drain Magic
	210261, -- Sound Alarm
	210684, -- Siphon Essence
	211007, -- Eye of the Vortex
	211115, -- Phase Breach
	211299, -- Searing Glare
	211368, -- Twisted Touch of Life
	211401, -- Drifting Embers
	211464, -- Fel Detonation
	211470, -- Bewitch
	211632, -- Brand of the Legion
	211757, -- Portal: Argus
	215204, -- Hinder
	216197, -- Surging Waters
	218532, -- Arc Lightning
	221059, -- Wave of Decay
	222939, -- Shadow Volley
	223038, -- Erupting Terror
	223392, -- Dread Wrath Volley
	223423, -- Nightmare Spores
	223565, -- Screech
	223590, -- Darkfall
	224460, -- Venom Nova
	225042, -- Corrupt
	225073, -- Despoiling Roots
	225079, -- Raining Filth
	225100, -- Charging Station
	225573, -- Dark Mending
	226206, -- Arcane Reconstitution
	226269, -- Torment
	226285, -- Demonic Ascension
	227592, -- Frostbite
	227800, -- Holy Shock
	227823, -- Holy Wrath
	230084, -- Stabilize Rift
	207228, -- Warp Nightwell
	213281, -- Pyroblast
	209017, -- Felblast
	209971, -- Albative Pulse
	209568, -- Exothermic Release
	209617, -- Expedite
	208672, -- Carrion wave
	239401, -- Pangs of Guild (Belac)
	233371, -- Watery Splash (Harjatan fight)
	241509, -- Water Blast (Mistress fight)
	200631, -- Unnerving Screech
	225562, -- Blood Metamorphosis
	211875, -- Bladestorm
}
validUnitBypassList = {
	[133492] = "Corruption Corpuscle",
	[135016] = "Plague Amalgam",
	[131009] = "Spirit of Gold", --Atal
	[125828] = "Soulspawn" --Atal
}
