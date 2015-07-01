if select(3, UnitClass("player")) == 5 
and GetSpecialization() == 3 then

	
	-- angelic_feather = 121536,
	function castAngelicFeather()
	end
	-- cascade = 127632,
	function castCascadeAuto()
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			if getDistance("player",thisUnit)<40 then
				if castSpell(thisUnit,127632,true,false)
			end
		end
	end
	-- desperate_prayer = 19236,
	function castDesperatePrayer()
		return castSpell("player",19236,true,false)
	end
	-- devouring_plague = 2944,
	function castDevouringPlague(target)
		return castSpell(target,2944,true,false)
	end
	-- dispel_magic = 523,
	function castDispelMagic(target)
		return castSpell(target,523,true,false)
	end
	-- dispersion = 47585,
	function castDispersion()
		return castSpell("player",47585,true,false)
	end
	-- divine_star = 122121,
	function castDivineStar()
		return castSpell("player",122121,false,false)
	end
	-- dominate_mind = 605,
	function castDominateMind(target)
		return castSpell(target,605,true,true)
	end
	-- fade = 586,
	function castFade()
		return castSpell("player",586,true,false)
	end
	-- fear_ward = 6346,
	function castFearWard(target)
		return castSpell(target,6346,true,false)
	end
	-- flash_heal = 2061,
	function castFlashHeal()
	end
	-- halo = 120644,
	function castHalo()
		return castSpell("player",120644,true,false)
	end
	-- leap_of_faith = 73325,
	function castLeapOfFaith(target)
	end
	-- levitate = 1706,
	function castLevitate(target)
	end
	-- mass_dispel = 32375,
	function castMassDispel(target)
		if castGround(target,32375,30) then
			SpellStopTargeting()
			return true
		end
	end
	-- mindbender = 123040,
	function castMindbender(target)
		return castSpell(target,123040,true,false)
	end
	-- mind_blast = 8092,
	function castMindBlast(target)
		if getTalent(7,1) then
			return castSpell(target,8092,false,false)
		else
			return castSpell(target,8092,false,true)
		end
	end
	-- mind_flay = 15407,
	function castMindFlay(target)
		return castSpell(target,15407,false,true)
	end
	-- mind_sear = 48045,
	function castMindSear(target)
		return castSpell(target,48045,true,true)
	end
	-- mind_spike = 73510,
	function castMindSpike(target,proc)
		if proc==true then
			return castSpell(target,73510,false,false)
		else
			return castSpell(target,73510,false,true)
		end
	end
	-- mind_vision = 2096,
	function castMindVision()
	end
	-- power_infusion = 10060,
	function castPowerInfusion()
		return castSpell("player",10060,true,false)
	end
	-- power_word_fortitude = 21562,
	function castPWF()
		return castSpell("player",21562,true,false)
	end
	-- power_word_shield = 17,
	function castPWS(target)
		return castSpell(target,17,true,false)
	end
	-- prayer_of_mending = 33076,
	function castPoM(target)
	end
	-- psychic_horror = 64044,
	function castPsychicHorror()
	end
	-- resurrection = 2006,
	function castResurrection(target)
	end
	-- shackle_undead = 9484,
	function castShackleUndead(target)
	end
	-- shadow_word_death = 32379,
	function castShadowWordDeath(target)
		if getHP(target) <= 20 then
			return castSpell(target,32379,true,false,false,false,false,false,true)
		end
	end
	-- shadow_word_pain = 589,
	function castSWP()
	end
	-- shadowfiend = 34433,
	function castShadowfiend(target)
		return castSpell(target,34433,true,false)
	end
	-- shadowform = 15473,
	function castShadowform()
		return castSpell("player",15473,true,false)
	end
	-- silence = 15487,
	function castSilence(target)
		return castSpell(target,15487,true,false)
	end
	-- surge_of_darkness = 87160,
	
	-- spectral_guise = 112833,
	
	-- vampiric_embrace = 15286,
	function castVE()
		return castSpell("player",15286,true,false)
	end
	-- vampiric_touch = 34914,
	function castVT()
	end
	-- void_entropy = 155361,
	function castVoidEntropy(target)
	end