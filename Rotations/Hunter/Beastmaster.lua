if select(3, UnitClass("player")) == 3 then
-- Rotation
function BeastHunter()
	if Currentconfig ~= "Beastmaster CodeMyLife" then
		BeastConfig();
		HunterBeastToggles();
		Currentconfig = "Beastmaster CodeMyLife";
	end

	-- Focus Logic.
	local _Focus = UnitPower("player")
	if focusBuilt ~= nil and focusBuilt >= GetTime() - 1 then _Focus = _Focus + 14 end
	if UnitBuffID("player",34471) ~= nil then _Focus = _Focus*2; end

	-- Other locals reused often.
	local _PetDistance = getDistance("pet","target")
	local _HP = getHP("player")
	local bestialWrathCD = getSpellCD(_BestialWrath);
	local killCommandCD = getSpellCD(_KillCommand);

	-- Food/Invis Check
	if not canRun() or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then waitForPetToAppear = nil; return false; end

	-- Counter Shot
	if BadBoy_data["Check Interrupts"] == 1 and UnitAffectingCombat("player") then
		if canInterrupt(_CounterShot, tonumber(BadBoy_data["Box Interrupts"])) and getDistance("player","target") <= 40 then
			castSpell("target",_CounterShot,false);
		end
	end

	if isCasting() then return false; end

	-- Aspect of the Cheetah
	if not isInCombat("player") and BadBoy_data["Check Auto-Cheetah"] == 1
	  and not UnitBuffID("player", 5118)
	  and not IsMounted()
	  and IsMovingTime(BadBoy_data["Box Auto-Cheetah"])
	  and not UnitIsDeadOrGhost("player")
	  and GetShapeshiftForm() ~= 2 then
		castSpell("player",_AspectOfTheCheetah,true);
	end
	
	-- Aspect of the Hawk
	if UnitAffectingCombat("player")
	  and not UnitBuffID("player", 13165)
	  and GetShapeshiftForm() ~= 1 then
		castSpell("player",_AspectOfTheHawk,true);
	end

	-- Pet Management
	if isChecked("Auto Call Pet") == true and UnitExists("pet") == nil then
		if waitForPetToAppear ~= nil and waitForPetToAppear < GetTime() - 2 then
			if lastFailedWhistle and lastFailedWhistle > GetTime() - 3 then
				if castSpell("player",_RevivePet) then return; end
			else
				local Autocall = BadBoy_data["Box Auto Call Pet"];
				if castSpell("player",_G["_CallPet"..Autocall]) then return; end
			end
		end
		if waitForPetToAppear == nil then
			waitForPetToAppear = GetTime()
		end
	end
	if UnitIsDeadOrGhost("pet") then
		if castSpell("player",_RevivePet) then return; end
	end

	-- Mend Pet
	if BadBoy_data["Check Mend Pet"] == 1 and getHP("pet") < BadBoy_data["Box Mend Pet"] and not UnitBuffID("pet",136) then
		if castSpell("pet",_MendPet) then return; end
	end

	if isInCombat("player") then
		-- Deterrence
		if BadBoy_data["Check Deterrence"] == 1 and _HP <= BadBoy_data["Box Deterrence"] then
			if castSpell("player",_Deterrence) then return; end
		end
		if _HP < BadBoy_data["Check Feign Death"] and _HP <= BadBoy_data["Box Feign Death"] then
			if castSpell("player",_FeignDeath) then return; end
		end			
		local canBestialWrath = false;
		if isAlive() and isEnnemy() and getLineOfSight("player","target") == true and getFacing("player","target") == true then
			-- Bestial Wrath
			if BadBoy_data["Cooldowns"] == 3 or (BadBoy_data["Check Bestial Wrath"] == 1 and (BadBoy_data["Drop Bestial Wrath"] == 3 or BadBoy_data["Drop Bestial Wrath"] == 2 and BadBoy_data["Cooldowns"] == 2)) then
			  	canBestialWrath = true;
			   	if _PetDistance <= 25 and getSpellCD(34026) < 2 then
					if castSpell("player",_BestialWrath,true) then bestialWrathCast = GetTime(); return; end
				end
			end

			-- Rapid Fire
			if BadBoy_data["Cooldowns"] == 3 or (BadBoy_data["Check Rapid Fire"] == 1 and (BadBoy_data["Drop Rapid Fire"] == 3 or BadBoy_data["Drop Rapid Fire"] == 2 and BadBoy_data["Cooldowns"] == 2)) then
				if castSpell("player",_RapidFire) then return; end
			end

			-- Stampede
			if BadBoy_data["Cooldowns"] == 3 or (BadBoy_data["Check Stampede"] == 1 and (BadBoy_data["Drop Stampede"] == 3 or BadBoy_data["Drop Stampede"] == 2 and BadBoy_data["Cooldowns"] == 2)) then
				if castSpell("target",_Stampede) then return; end
			end			

--[[

]]
			-- Single Kill Shot
			if getHP("target") <= 20 then
				if castSpell("target",_KillShot,false) then return; end
			end

			-- Kill Command
			if  UnitExists("pet") and _Focus >= 40 and _PetDistance <= 25 and getLineOfSight("pet","target") then
				--GetTime() - bestialWrathCast <=1
				if castSpell("target",_KillCommand,false) then return; end
			end

			-- Focus Fire
			if BadBoy_data["Cooldowns"] == 3 
			  or (BadBoy_data["Check Focus Fire"] == 1 and BadBoy_data["Drop Focus Fire"] == 3)
			  or (BadBoy_data["Check Focus Fire"] == 1 and (BadBoy_data["Drop Focus Fire"] == 2 and BadBoy_data["Cooldowns"] == 2)) then	
				if (canBestialWrath == false or getSpellCD(_BestialWrath) > 19) and select(4,UnitBuffID("player",19615)) == 5 and not UnitBuffID("player",34471) then
					if castSpell("player",_FocusFire) then return; end
				end
			end

			-- Glaive Toss
			if castSpell("target",_GlaiveToss,false) then return; end

			-- Misdirection function
			Misdirection();

			-- Dire Beast
			if _Focus <= BadBoy_data["Box Dire Beast"] and not UnitBuffID("player",34471) then
				if castSpell("target",_DireBeast,false) then return; end
			end

			-- Serpent Sting
			if BadBoy_data["Check Serpent Sting"] == 1 and _Focus >= 40 and getDebuffRemain("target",_SerpentSting) < 3 and (isDummy("target") or UnitHealth("target") >= 100*UnitHealthMax("player")/100*(GetNumGroupMembers()+1)) then
				if LastSerpentTarget ~= UnitName("target") or (LastSerpent == nil or LastSerpent <= GetTime() - 2) then
					if castSpell("target",_SerpentSting,false) then return; end
				end
			end

			local numEnnemies = getNumEnnemies("target",10)
			-- Focus Dump
			if numEnnemies >= 2 then				-- Multi-Shot
				if _Focus > 79 and not UnitBuffID("pet",118455) or _Focus > 99 then
					if castSpell("target",_MultiShot,false) then return; end
				end		
			else
				-- Arcane Shot
				if _Focus >= 69 then
					if castSpell("target",_ArcaneShot,false) then return; end
				end
			end		

			-- Explosive Trap
			if canCast(_TrapLauncherExplosive) and BadBoy_data["Check Explosive Trap"] == 1 
				and (BadBoy_data["Drop Explosive Trap"] == 3 or (BadBoy_data["Drop Explosive Trap"] == 2 and numEnnemies >= 3)) 
				and getGround("target") == true 
				and isMoving("target") == false
				and (isDummy("target") or (getDistance("target","targettarget") <= 5 and UnitHealth("target")*numEnnemies >= 150*UnitHealthMax("player")/100)) then
				if castGround("target",_TrapLauncherExplosive,40) then return; end
			end

			-- Steady Shot
			--if _Focus > 40 and killCommandCD < 0.4 then return; end
			if castSpell("target",_SteadyShot,false,false) then return; end
			if castSpell("target",_CobraShot,false,false) then return; end
		end
	end
end
end