if select(3, UnitClass("player")) == 3 then
-- Rotation
function  BeastHunter()
	if Currentconfig ~= "Beastmaster CodeMyLife" then
		BeastConfig();
		HunterBeastToggles();
		Currentconfig = "Beastmaster CodeMyLife";
	end

	-- Focus Logic.
	local Focus = UnitPower("player")
	if focusBuilt ~= nil and focusBuilt >= GetTime() - 1 then Focus = Focus + 14 end
	--if UnitBuffID("player",34471) ~= nil then Focus = Focus*2; end

	-- Other locals reused often.
	local PetDistance = getDistance("pet","target")
	local HP = getHP("player")
	local bestialWrathCD = getSpellCD(BestialWrath);
	local killCommandCD = getSpellCD(KillCommand);

	-- Food/Invis Check
	if not canRun() or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then waitForPetToAppear = nil; return false; end

	-- Counter Shot
	if BadBoy_data["Check Interrupts"] == 1 and UnitAffectingCombat("player") then
		if canInterrupt(CounterShot, tonumber(BadBoy_data["Box Interrupts"])) and getDistance("player","target") <= 40 then
			castSpell("target",CounterShot,false);
		end
	end

	if castingUnit() then return false; end
	-- Aspect of the Cheetah
	if not isInCombat("player") and BadBoy_data["Check Auto-Cheetah"] == 1
	  and not UnitBuffID("player", 5118)
	  and not IsMounted()
	  and IsMovingTime(BadBoy_data["Box Auto-Cheetah"])
	  and not UnitIsDeadOrGhost("player")
	  and GetShapeshiftForm() ~= 2 then
		castSpell("player",AspectOfTheCheetah,true);
	end

	-- Pet Management
	if isChecked("Auto Call Pet") == true and UnitExists("pet") == nil then
		if waitForPetToAppear ~= nil and waitForPetToAppear < GetTime() - 2 then
			if lastFailedWhistle and lastFailedWhistle > GetTime() - 3 then
				if castSpell("player",RevivePet) then return; end
			else
				local Autocall = BadBoy_data["Box Auto Call Pet"];
				if castSpell("player",G["CallPet"..Autocall]) then return; end
			end
		end
		if waitForPetToAppear == nil then
			waitForPetToAppear = GetTime()
		end
	end
	if UnitIsDeadOrGhost("pet") then
		if castSpell("player",RevivePet) then return; end
	end

	-- Mend Pet
	if BadBoy_data["Check Mend Pet"] == 1 and getHP("pet") < BadBoy_data["Box Mend Pet"] and not UnitBuffID("pet",136) then
		if castSpell("pet",MendPet) then return; end
	end
	if isInCombat("player") then
		-- Deterrence
		if BadBoy_data["Check Deterrence"] == 1 and HP <= BadBoy_data["Box Deterrence"] then
			if castSpell("player",Deterrence) then return; end
		end
		if HP < BadBoy_data["Check Feign Death"] and HP <= BadBoy_data["Box Feign Death"] then
			if castSpell("player",FeignDeath) then return; end
		end
		local canBestialWrath = false;
		if isAlive() and isEnnemy() and getLineOfSight("player","target") == true and getFacing("player","target") == true then

			-- Bestial Wrath
			if BadBoy_data["Cooldowns"] == 3 or (BadBoy_data["Check Bestial Wrath"] == 1 and (BadBoy_data["Drop Bestial Wrath"] == 3 or BadBoy_data["Drop Bestial Wrath"] == 2 and BadBoy_data["Cooldowns"] == 2)) then
			  	canBestialWrath = true;
			   	if PetDistance <= 25 and getSpellCD(34026) < 2 then
					if castSpell("player",BestialWrath,true) then bestialWrathCast = GetTime(); return; end
				end
			end

			-- Rapid Fire
			if BadBoy_data["Cooldowns"] == 3 or (BadBoy_data["Check Rapid Fire"] == 1 and (BadBoy_data["Drop Rapid Fire"] == 3 or BadBoy_data["Drop Rapid Fire"] == 2 and BadBoy_data["Cooldowns"] == 2)) then
				if castSpell("player",RapidFire) then return; end
			end

			-- Stampede
			if BadBoy_data["Cooldowns"] == 3 or (BadBoy_data["Check Stampede"] == 1 and (BadBoy_data["Drop Stampede"] == 3 or BadBoy_data["Drop Stampede"] == 2 and BadBoy_data["Cooldowns"] == 2)) then
				if castSpell("target",Stampede) then return; end
			end

--[[

]]
			-- Single Kill Shot
			if getHP("target") <= 20 then
				if castSpell("target",KillShot,false) then return; end
			end

			-- Kill Command
			if  UnitExists("pet") and Focus >= 40 and PetDistance <= 25 and getLineOfSight("pet","target") then
				--GetTime() - bestialWrathCast <=1
				if castSpell("target",KillCommand,false) then return; end
			end

			-- Focus Fire
			if BadBoy_data["Cooldowns"] == 3
			  or (BadBoy_data["Check Focus Fire"] == 1 and BadBoy_data["Drop Focus Fire"] == 3)
			  or (BadBoy_data["Check Focus Fire"] == 1 and (BadBoy_data["Drop Focus Fire"] == 2 and BadBoy_data["Cooldowns"] == 2)) then
				if (canBestialWrath == false or getSpellCD(BestialWrath) > 19) and select(4,UnitBuffID("player",19615)) == 5 and not UnitBuffID("player",19574) then
					if castSpell("player",FocusFire) then return; end
				end
			end

			-- Glaive Toss
			if castSpell("target",GlaiveToss,false) then return; end

			-- Misdirection function
			--Misdirection();

			-- Dire Beast
			if Focus <= BadBoy_data["Box Dire Beast"] then
				if castSpell("target",DireBeast,false) then return; end
			end

			-- Serpent Sting
			if BadBoy_data["Check Serpent Sting"] == 1 and Focus >= 40 and getDebuffRemain("target",SerpentSting) < 3 and (isDummy("target") or UnitHealth("target") >= 100*UnitHealthMax("player")/100*(GetNumGroupMembers()+1)) then
				if LastSerpentTarget ~= UnitName("target") or (LastSerpent == nil or LastSerpent <= GetTime() - 2) then
					if castSpell("target",SerpentSting,false) then return; end
				end
			end

			if enemiesTimer == nil or enemiesTimer <= GetTime() - 1 then
				enemiesTimer = GetTime();
				numEnemies = getNumEnemies("target",10);
			end
			-- Focus Dump
			if numEnemies >= 3 then				-- Multi-Shot
				if Focus > 79 and not UnitBuffID("pet",118455) or Focus > 99 then
					if castSpell("target",MultiShot,false) then return; end
				end
			else
				-- Arcane Shot
				if Focus >= 69 then
					if castSpell("target",ArcaneShot,false) then return; end
				end
			end

			-- Explosive Trap
			if canCast(TrapLauncherExplosive) and BadBoy_data["Check Explosive Trap"] == 1
				and (BadBoy_data["Drop Explosive Trap"] == 3 or (BadBoy_data["Drop Explosive Trap"] == 2 and numEnemies >= 3))
				and getGround("target") == true
				and isMoving("target") ~= true
				and (isDummy("target") or (getDistance("target","targettarget") <= 5 and UnitHealth("target")*numEnemies >= 150*UnitHealthMax("player")/100)) then
				if castGround("target",TrapLauncherExplosive,40) then return; end
			end

			-- Steady Shot
			--if Focus > 40 and killCommandCD < 0.4 then return; end
			if castSpell("target",SteadyShot,false,false) then return; end
			if castSpell("target",CobraShot,false,false) then return; end
		end
	end
end
end