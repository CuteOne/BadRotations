if select(3, UnitClass("player")) == 5 then
	function PriestShadow()

		if currentConfig ~= "Shadow ragnar" then
			ShadowConfig();
			ShadowToggles();
			currentConfig = "Shadow ragnar";
		end
		-- Head End

		-- Locals / Globals--
			lastPWF = 0
			GCD = 1.5/(1+UnitSpellHaste("player")/100)
			hasTarget = UnitExists("target")
			hasMouse = UnitExists("mouseover")
			php = getHP("player")
			thp = getHP("target")
			ORBS = UnitPower("player", SPELL_POWER_SHADOW_ORBS)

			MBCD = getSpellCD(MB)
			SWDCD = getSpellCD(SWD)

		-- Set Enemies Table


		-------------
		-- TOGGLES --
		-------------

		-- Pause toggle
		if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == 1 then
			ChatOverlay("|cffFF0000BadBoy Paused", 0);
			return;
		end

		-- Focus Toggle
		if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == 1 then
			RunMacroText("/focus mouseover");
		end

		-- -- Auto Resurrection
		-- if not isInCombat("player") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("player","mouseover") then
		-- 	if castSpell("mouseover",_Resurrection,true,true) then
		-- 		return;
		-- 	end
		-- end

		------------
		-- CHECKS --
		------------

		-- Food/Invis Check
		if canRun() ~= true then return false;
		end

		-- Mounted Check
		if IsMounted("player") then return false;
		end

		-- Do not Interrupt "player" while GCD (61304)
		if getSpellCD(61304) > 0 then return false;
		end

		-------------------
		-- OUT OF COMBAT --
		-------------------

		-- Power Word: Fortitude
		if not isInCombat("player") then
			if isChecked("PW: Fortitude") == true and canCast(PWF,false,false) and (lastPWF == nil or lastPWF <= GetTime() - 5) then
				for i = 1, #nNova do
			  		if isPlayer(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{21562,109773,469,90364}) then
			  			if castSpell("player",PWF,true) then lastPWF = GetTime(); return; end
					end
				end
			end
		end
		-- Out Of Combat END

		---------------------------------------
		-- Shadowform and AutoSpeed Selfbuff --
		---------------------------------------

		-- Shadowform outfight
		if not UnitBuffID("player",Shadowform) and isChecked("Shadowform Outfight") then
			if castSpell("player",Shadowform,true,false) then return; end
		end

		-- Angelic Feather
		if isKnown(AngelicFeather) and isChecked("Angelic Feather") and getGround("player") and IsMovingTime(0.33) and not UnitBuffID("player",AngelicFeatherBuff) then
			if castGround("player",AngelicFeather,30) then
				SpellStopTargeting();
				return;
			end
		end

		-- Body and Soul
		if isKnown(BodyAndSoul) and isChecked("Body And Soul") and getGround("player") and IsMovingTime(0.75) and not UnitBuffID("player",PWS) and not UnitDebuffID("player",PWSDebuff) then
			if castSpell("player",PWS,true,false) then
				return;
			end
		end

		---------------
		-- IN COMBAT --
		---------------
		-- AffectingCombat, Pause, Target, Dead/Ghost Check
		if isInCombat("player") then

			-- Shadowform outfight
			if not UnitBuffID("player",Shadowform) then
				if castSpell("player",Shadowform,true,false) then return; end
			end

			-------------------
			-- Dummy Testing --
			-------------------
			if isChecked("DPS Testing") then
				if UnitExists("target") then
					if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
						StopAttack()
						ClearTarget()
						print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
					end
				end
			end


			----------------
			-- Defensives --
			----------------
			ShadowDefensive();

			
			----------------
			-- Offensives --
			----------------
			ShadowCooldowns();

			
			--------------
			-- Decision --
			--------------
			ShadowDecision();

			

		end -- AffectingCombat, Pause, Target, Dead/Ghost Check
	end
end