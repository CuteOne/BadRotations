if select(3, UnitClass("player")) == 8 then

-- All
	MirrorImage 	= 55342;
	ArcaneBrilliance= 1459;

-- Frost
	CometStorm		= 153595;
	Frostbolt		= 116;
	FrostfireBolt	= 44614;
	FrozenOrb		= 84714;
	FrozenOrbDebuff = 84721;
	IceLance		= 30455;
	IcyVeins		= 12472;
-- Pet
	SummonPet		= 31687;
	WaterJet		= 135029;
-- FrTalents
	FrostBomb 		= 112948;
	IceNova			= 157997;
	ThermalVoid		= 155149;

-- Fire
	BlastWave		= 157981;
	Combustion		= 11129;
	Fireball		= 133;
	Ignite			= 12654; --12846 (mastery: ignite)
	InfernoBlast	= 108853;
	Pyroblast		= 11366;
-- FiTalents

-- Arcane
	ArcaneBarrage	= 44425
	ArcaneBlast		= 30451
	ArcaneExplosion	= 1449
	ArcaneMissiles	= 5143
	ArcaneMissilesP	= 79683
	UnstableExplo	= 157976
	PresenceOfMind  = 12043
	Evocation		= 12051 --Standard
	EvocationImp	= 157614 -- improved versions
-- ArTalents
	Supernova 		= 175980;
	ArcaneOrb		= 153626;
	Overpowered		= 155147;
	NetherTempest	= 114923;
	Evanesce		= 157913;

-- Talents
	ColdSnap		= 11958;
	IceFloes		= 108839;
	PrismaticCrystal = 155152;


-- Shared


-- Utility
	T17_4P_Frost	= 165469;
	T17_4P_Arcane	= 166872;  -- Arcane Instability

-- Buffs
	-- frost
	BrainFreeze		= 57761;
	EnhancedFB		= 157646;
	FingersOfFrost	= 44544;
	IceShard		= 166869;

	-- fire
	EnhancedPyro	= 157644
	HeatingUp		= 48107;
	PyroblastP		= 48108;
	Pyromaniac		= 166868;

	-- arcane
	ArcaneAffinity	= 166871;
	ArcaneCharge	= 36032;
	ArcanePower		= 12042;

	-- all
	Archmage		= 177176;
	Instability		= 177051;  -- trinket 113948
	MoltenMetal		= 177081;  -- trinket 113984
	RuneOfPower		= 116011;
	HowlingSoul		= 177046;  -- trinket 119194
	MarkOfTheT		= 159234;


-- Debuffs


-- Trinkets


-- Glyphs
	GlyphConeOfCold	= 115705;

-- Racial
	Berserkering 	= 26297;	-- Troll Racial

	ArcaneSpellBook = {
	    [ArcaneBlast] = { isKnown = isKnown(ArcaneBlast), cd = 0, lastStart = 0, lastSent = 0, lastSucceeded = 0, lastStop = 0, lastFailed = 0 }, 
	}


	function insertSpellCastStart(spellID, time)
		ArcaneSpellBook[spellID].LastStart = time
	end
	function insertSpellCastSent(spellID, time)
		ArcaneSpellBook[spellID].LastSent = time
	end
	function insertSpellCastSucceeded(spellID, time)
		ArcaneSpellBook[spellID].lastSucceeded = time
	end
	function insertSpellCastStop(spellID, time)
		ArcaneSpellBook[spellID].LastStop = time
	end
	function insertSpellCastInterrupted(spellID, time)
		ArcaneSpellBook[spellID].Interrupted = time
	end
	function insertSpellCastFailed(spellID, time)
		ArcaneSpellBook[spellID].LastFailed = time
	end

	-- Todo : Here we should look into what the best value for clipping, 50 atm, why 50? Is it related to latency or custom lag tolerance?
	-- Further testing is needed.
	function isItOkToClipp()
		local  name, _, _, _, _, endTime = UnitChannelInfo("player")
		if name then
			if (endTime - (GetTime()*1000)) > 50 then
				return false
			end
			return true		
		end
		local name, _, _, _, _, endTime = UnitCastingInfo("player")
		if name then
			if (endTime - (GetTime()*1000)) > 50 then
				return false
			end
			return true
		end
		return true
	end

	function cancelEvocation() 
		local  name, _, _, _, _, endTime = UnitChannelInfo("player")
		if name and name == "Evocation" then
			print("Evoing")
			if playerMana > 92 then
				print("Cancel")
				return true
			end
		end
		return false
	end

	function castArcaneBlast(target)
		if castSpell(target,ArcaneBlast,false,true) then
			return true
		end
	end

end
