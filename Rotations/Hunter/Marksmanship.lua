if select(3, UnitClass("player")) == 3 then
-- Rotation
function MarkHunter()
	if Currentconfig ~= "Marksmanship" then
		MarkConfig();
		MarkToggles();
		Currentconfig = "Marksmanship";
	end

	-- Focus Logic.
	local Focus = UnitPower("player")
	local FocusRegen = GetPowerRegen()



	-- Other locals reused often.
	local PetDistance = getDistance("pet","target")
	local HP = getHP("player")

	-- Food/Invis Check
	if not canRun() or UnitInVehicle("Player") then return false; end
	if IsMounted("player") then waitForPetToAppear = nil; return false; end



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

	-------------------------
	-- Pet Management --
	-------------------------
	if isChecked("Auto Call Pet")  and not UnitExists("pet") then
		if waitForPetToAppear ~= nil and waitForPetToAppear < GetTime() - 2 then
			if lastFailedWhistle and lastFailedWhistle > GetTime() - 3 then
				if castSpell("player",RevivePet) then return; end
			else
				local Autocall = BadBoy_data["Drop Auto Call Pet"];

				if Autocall == 1 then
					if castSpell("player",CallPet1) then return; end
				elseif Autocall == 2 then
					if castSpell("player",CallPet2) then return; end
				elseif Autocall == 3 then
					if castSpell("player",CallPet3) then return; end
				elseif Autocall == 4 then
					if castSpell("player",CallPet4) then return; end
				elseif Autocall == 5 then
					if castSpell("player",CallPet5) then return; end
				else
					print("Auto Call Pet Error")
				end
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

	---------------------------
	--- Defensive Abilities ---
	---------------------------
	if not castingUnit("player") and isInCombat("player") then
		if BadBoy_data["Check Deterrence"] == 1 and HP <= BadBoy_data["Box Deterrence"] then
			if castSpell("player",Deterrence) then return; end
		end
		if HP < BadBoy_data["Check Feign Death"] and HP <= BadBoy_data["Box Feign Death"] then
			if castSpell("player",FeignDeath) then return; end
		end
	end



	------------------
	--- Interrupts ---
	------------------
	-- Counter Shot
	if BadBoy_data["Check Interrupts"] == 1 and UnitAffectingCombat("player") then
		if canInterrupt(CounterShot, tonumber(BadBoy_data["Box Interrupts"])) and getDistance("player","target") <= 40 then
			castSpell("target",CounterShot,false);
		end
	end


	-----------------
	--- Cooldowns ---
	-----------------
	-- Rapid Fire
	if BadBoy_data["Cooldowns"] == 3 or (BadBoy_data["Check Rapid Fire"] == 1 and (BadBoy_data["Drop Rapid Fire"] == 3 or BadBoy_data["Drop Rapid Fire"] == 2 and BadBoy_data["Cooldowns"] == 2)) then
		if castSpell("player",RapidFire) then return; end
	end

	-- Stampede
	if BadBoy_data["Cooldowns"] == 3 or (BadBoy_data["Check Stampede"] == 1 and (BadBoy_data["Drop Stampede"] == 3 or BadBoy_data["Drop Stampede"] == 2 and BadBoy_data["Cooldowns"] == 2)) then
		if castSpell("target",Stampede) then return; end
	end



	----------------------------
	--- Damage Rotation ---
	---------------------------

	-- Single Kill Shot
	if getSpellCD(KillShot) == 0
	and getHP("target")<= 20 then
		if castSpell("target",KillShot,false) then return; end
	end

	-- Chimera Shot
	if getSpellCD(ChimeraShot) == 0
	and Focus >= 35 then
		if castSpell("target",ChimeraShot,false) then return; end
	end

	-- Barrage
	if getSpellCD(Barrage) == 0
	and Focus >= 60 then
		if castSpell("target",Barrage,false) then return; end
	end

	-- Glave Toss
	if getSpellCD(GlaiveToss) == 0
	and Focus >= 15 then
		if castSpell("target",GlaiveToss,false) then return; end
	end

	-- Powershot
	if getSpellCD(PowerShot) == 0
	and Focus >= 15 then
		if castSpell("target",PowerShot,false) then return; end
	end

	-- Aimed Shot
	if getSpellCD(AimedShot) == 0
	and Focus + FocusRegen >= 60
	and getSpellCD(Barrage) > 2 then
		if castSpell("target",AimedShot,false) then return; end
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
	if getSpellCD(SteadyShot) == 0
	and Focus < 50 then
		--print("Casting Steady Shot at "..Focus.." Focus.")
		if castSpell("target",SteadyShot,false,false) then return; end
	end





	end
end