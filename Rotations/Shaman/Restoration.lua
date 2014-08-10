if select(3, UnitClass("player")) == 7 then
-- Rotation
function ShamanRestoration()
	if currentConfig ~= "Restoration CodeMyLife" then
		RestorationConfig();
		RestorationToggles();
		currentConfig = "Restoration CodeMyLife";
	end

	-- Food/Invis Check
	if canRun() ~= true or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then waitForPetToAppear = nil; return false; end

	-- Wind Shear
	if isChecked("Wind Shear") and UnitAffectingCombat("player") then
		if canInterrupt(_WindShear, tonumber(BadBoy_data["Box Wind Shear"])) and getDistance("player","target") <= 25 then
			castSpell("target",_WindShear,false);
		end
	end

--[[ 	-- On GCD After here
]]

	if isCasting() then return false; end

	-- Astral Shift if < 30%
	if BadBoy_data["Check Astral Shift"] == 1 and getHP("player") <= BadBoy_data["Box Astral Shift"] then
		if castSpell("player",_AstralShift,true) then return; end
	end
	-- Healing Stream if < 50%
	if BadBoy_data["Check Healing Stream"] == 1 and getHP("player") <= BadBoy_data["Box Healing Stream"] then
		--if castSpell("player",_HealingStream,true) then return; end
	end
	-- Shamanistic Rage if < 80%
	if BadBoy_data["Check Shamanistic Rage"] == 1 and getHP("player") <= BadBoy_data["Box Shamanistic Rage"] then
		if castSpell("player",_ShamanisticRage,true) then return; end
	end

	-- Earthliving Weapon
	if isChecked("Earthliving Weapon") and GetWeaponEnchantInfo() ~= 1 then 
		if castSpell("player",_EarthlivingWeapon,true) then return; end
	end

	-- Water Shield
	if isChecked("Water Shield") and UnitBuffID("player",_WaterShield) == nil then
		if castSpell("player",_WaterShield,true) then return; end
	end



--[[ 	-- Combats Starts Here
]]

	if isInCombat("player") then

		-- stormlash_totem,if=!active&!buff.stormlash.up&(buff.bloodlust.up|time>=60)
		if isSelected("Stormlash Totem") and not isAirTotem(_StormlashTotem) and UnitBuffID("player",120676) == nil then
			if castSpell("player",_StormlashTotem,true) then return; end
		end

		-- fire_elemental_totem,if=!active
		if isSelected("Fire Elemental") and not isFireTotem(_FireElementalTotem) then
			if castSpell("player",_FireElementalTotem,true) then return; end
		end	

		-- Pause when in Ghost Wolf Form
		if UnitBuffID("player",2645) ~= nil then return; end
		
		-- Healing Rain
		if nNova[3] and nNova[3].hp < getValue("Healing Rain") and canCast(_HealingRain) then
			if castHealGround(_HealingRain,18,80,3) then return; end
		end

		-- Mana Tide Totem
		if getMana("player") <= getValue("Mana Tide") then
			if castSpell("player",_ManaTide,true) then return; end
		end
		
		-- Healing Tide Totem
		if nNova[3] and nNova[3].hp <= getValue("Healing Tide") then
			if castSpell("player",_HealingTide,true) then return; end
		end

		-- Spirit Link Totem

		-- Purify Spirit
		for i = 1, #nNova do
			if nNova[i].dispel == true then
				if castSpell(nNova[i].unit, _PurifySpirit,true) then return; end
			end
		end

		-- Totemic Projection
		-- {"108287",{"talent(9)","TotemicProjection.pqikeybind"},"ground"},

		-- Earth Shield
		local earthShield, earthTarget = EarthShield();
		if earthShield == true then
			if castSpell(earthTarget,_EarthShield,true) then return; end
		end


		-- Chain Heal
		local allies30Yards = getAllies(nNova[1].unit,30)
		if #allies30Yards >= 3 then
			local count = 0;
			for i = 1, #allies30Yards do
				if getHP(allies30Yards[i]) < 90 then
					count = count + 1
				end
			end
			if count > 3 then
				if castSpell(nNova[1].unit,_ChainHeal,true) then return; end
			end
		end


		-- Healing Surge
		if nNova[1].hp <= 20 then
			if castSpell(nNova[1].unit,_HealingSurge,true) then return; end
		end

		-- Greater Healing Wave
		if nNova[1].hp <= 60 then
			if castSpell(nNova[1].unit,_GreaterHealing,true) then return; end
		end

		-- Riptide
		for i = 1, #nNova do
			if nNova[i].hp <= 90 and getBuffRemain(nNova[i].unit,_Riptide) < 3 then
				if castSpell(nNova[i].unit,_Riptide,true) then return; end
			end
		end

		-- Healing Stream Totem
		-- {"5394",{"HealingStreamTotem.novaHealing(1)"},nil},
		-- Greater Healing Wave
		-- {"77472",{"77472.stopcasting","GreaterHealingWave.novaHealing(1)"},"nova1"},
		-- Healing Wave
		if nNova[1].hp <= 80 then
			if castSpell(nNova[1].unit,_HealingWave,true) then return; end
		end
		------------------------------------------------Some DPS-------------------------------------------
		-- Searing Totem
		-- {"3599",{"!player.totem(2894)","!player.totem(3599)"}},
		--Lightning Bolt if glyphed
		-- {"403",{"@CML.IsGlyphed(55453,true)","LightningBolt.pqiMana(0)","403.stopcasting","403.multiTarget"}},  -- check glyph ID

		-- Riptide
		-- {"61295",{"!1.novaBuff(61295)","Riptide.novaHealing(1)"},"nova1"},
		
		--Earth Shield
		-- {"974",{"@CML.EarthShield()"}},
		-- {"974",{"focus.buff(974).count < 2","focus.spell(974).range"},"focus"},
		-- Healing Rain
		-- {"73920",{"73920.stopcasting","!player.moving","HealingRain.pqikeybind","@CML.HealingRain()"},"ground"},





		-- lightning_bolt
		if castSpell("target",_LightningBolt,false) then return; end
	end
end
end