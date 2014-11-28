if select(3, UnitClass("player")) == 5 then

	--[[         ]]		--[[           ]]	--[[           ]]	--[[           ]]
	--[[          ]]		  --[[]]		--[[           ]]	--[[           ]]
	--[[]]	   --[[]]		  --[[]]		--[[]]	   			--[[]]
	--[[]]	   --[[]]		  --[[]]		--[[           ]]	--[[]]
	--[[]]	   --[[]]		  --[[]]				   --[[]]	--[[]]
	--[[          ]]		  --[[]]		--[[           ]]	--[[           ]]
	--[[         ]] 	--[[           ]]	--[[           ]]	--[[           ]]

	--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
	--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
	--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
	--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
	--[[           ]]	--[[]]	   --[[]]	--[[]]					 --[[]]
	--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]
	--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]

	--[[           ]]	--[[]]	   --[[]]		  --[[]]		--[[         ]]		--[[           ]]	--[[]] 	   --[[]]
	--[[           ]]	--[[]]	   --[[]]	     --[[  ]]		--[[          ]]	--[[           ]]	--[[]] 	   --[[]]
	--[[]]				--[[]]	   --[[]]	    --[[    ]] 		--[[]]	   --[[]]	--[[]]	   --[[]]	--[[ ]]   --[[ ]]
	--[[           ]]	--[[           ]]	   --[[      ]] 	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]
			   --[[]] 	--[[]]	   --[[]] 	  --[[        ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]
	--[[           ]]	--[[]]	   --[[]]	 --[[]]    --[[]]	--[[          ]]	--[[           ]]	--[[ ]]   --[[ ]]
	--[[           ]]	--[[]]	   --[[]]	--[[]]      --[[]]	--[[         ]]		--[[           ]]	 --[[]]   --[[]]

	--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]
	--[[           ]]	--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[  ]]   --[[]]
	--[[]]				--[[]]	   --[[]]	--[[    ]] --[[]]   --[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[    ]] --[[]]
	--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[           ]]
	--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[   		   ]]
	--[[]]	   			--[[           ]]	--[[]]	 --[[  ]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	 --[[  ]]
	--[[]]	   			--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]

	--[[                    ]] -- General Functions start

	-- get threat situation on player and return the number
	function getThreat()
		return UnitThreatSituation("player")
		-- 0 - Unit has less than 100% raw threat (default UI shows no indicator)
		-- 1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
		-- 2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
		-- 3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
	end

	-- Break MF cast for MB
	function breakMF()
		if getSpellCD(MB)<getSpellCD(61304) and (select(1,UnitChannelInfo("player")) == "Mind Flay" or select(1,UnitChannelInfo("player"))) == "Insanity" then
			--print("--- BREAK MF ---")
			RunMacroText("/stopcasting")
		end
	end
	
	-- Check if SWP is on 3 units or if #enemiesTable is <3 then on #enemiesTable
	function getSWP()
		local counter = 0
		-- iterate units for SWP
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			-- increase counter for each SWP
			if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,SWP,"player") then
				counter=counter+1
			end
		end
		-- return counter
		return counter
	end

	-- Check if VT is on 3 units or if #enemiesTable is <3 then on #enemiesTable
	function getVT()
		local counter = 0
		-- iterate units for SWP
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			-- increase counter for each SWP
			if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,VT,"player") then
				counter=counter+1
			end
		end
		-- return counter
		return counter
	end

	--[[                    ]] -- General Functions end




	--[[                    ]] -- Defensives
	function ShadowDefensive()

		-- Shield
		if isChecked("PW: Shield") and (BadBoy_data['Defensive'] == 2) and php <= getValue("PW: Shield") then
			if castSpell("player",PWS) then return; end
		end

		-- Fade (Glyphed)
		if hasGlyph(GlyphOfFade) then
			if isChecked("Fade Glyph") and (BadBoy_data['Defensive'] == 2) and php <= getValue("Fade Glyph") then
				if castSpell("player",Fade) then return; end
			end
		end

		-- Fade (Aggro)
		if IsInRaid() ~= false then
			--if isChecked("Fade Aggro") and BadBoy_data['Defensive']==2 and UnitThreatSituation("player")>=2 then
			if isChecked("Fade Aggro") and BadBoy_data['Defensive'] == 2 then
				if castSpell("player",Fade) then return; end
			end
		end
		
		-- Healthstone
		if isChecked("Healthstone") and (BadBoy_data['Defensive'] == 2) and php <= getValue("Healthstone") then
			if canUse(5512) ~= false then UseItemByName(tostring(select(1,GetItemInfo(5512))));	end
		end

		-- Dispersion
		if isChecked("Dispersion") and (BadBoy_data['Defensive'] == 2) and php <= getValue("Dispersion") then
			if castSpell("player",Fade) then return; end
		end

		-- Desperate Prayer
		if isKnown(DesperatePrayer) then
			if isChecked("Desperate Prayer") and (BadBoy_data['Defensive'] == 2) and php <= getValue("Desperate Prayer") then
				if castSpell("player",DesperatePrayer) then return; end
			end
		end
	end
	--[[                    ]] -- Defensives end


	--[[                    ]] -- Cooldowns
	function ShadowCooldowns()
		-- Mindbender
		if isKnown(Mindbender) and BadBoy_data['Cooldowns'] == 2 and isChecked("Mindbender") then
			if castSpell("target",Mindbender) then return; end
		end
		-- Shadowfiend
		if isKnown(SF) and BadBoy_data['Cooldowns'] == 2 and isChecked("Shadowfiend") then
			if castSpell("target",SF) then return; end
		end

		-- Power Infusion
		if isKnown(PI) and BadBoy_data['Cooldowns'] == 2 and isChecked("Power Infusion") then
			if castSpell("player",PI) then return; end
		end

		-- Halo
		if isKnown(Halo) and BadBoy_data['Halo'] == 2 then
			if getDistance("player","target")<=30 and getDistance("player","target")>=17 then
				if castSpell("player",Halo) then return; end
			end
		end
	end
	--[[                    ]] -- Cooldowns end


	--[[                    ]] -- IcySingle DotWeave start
	function IcySingleWeave()
		-----------------
		-- DoT Weaving --
		-----------------
			-- if ORBS==5 --> apply DoTs if targetHP>20
			if isChecked("DoTWeave") and getTalent(3,3) then
				function DoTWeaveBreak()
					local counter=0
					local factor=getValue("Weave Comp")/10
					if isChecked("SWP") then counter=counter+1 end
					if isChecked("VT") then counter=counter+1 end
					return counter*GCD*factor
				end
				local Break=DoTWeaveBreak()
				-- if ORBS>=4 and getHP("target")>20 and getSpellCD(MB)<Break then
				if ORBS>=4 and getHP("target")>20 then
					if isChecked("SWP") then
						if not UnitDebuffID("target",SWP,"player") then
							if castSpell("target",SWP,true,false) then return; end
						end
					end
					if isChecked("VT") then
						if not UnitDebuffID("target",VT,"player") and GetTime()-lastVT > 2 then
							if castSpell("target",VT,true,true) then 
								lastVT=GetTime()
								return
							end
						end
					end
				end
			end
		----------------
		-- spend orbs --
		----------------
			--DP if ORBS == 5
			if isStanding(0.3) then
				if ORBS==5 then
					if castSpell("target",DP,false,true) then 
						lastDP=GetTime()
						return
					end
				end
			end

			-- DP if ORBS>=3 and lastDP<DPTIME and InsanityBuff<DPTICK
			if ORBS>=3 and GetTime()-lastDP<=10 then
				if castSpell("target",DP,false,true) then return; end
			end

			-- Insanity if noChanneling
			if getTalent(3,3) then
				if UnitBuffID("player",InsanityBuff) and getBuffRemain("player",InsanityBuff)>0.7*GCD then
					--if select(1,UnitChannelInfo("player")) == nil then
						if castSpell("target",MF,false,true) then return; end
					--end
				end
			end
		--------------
		-- get orbs --
		--------------
			--if ORBS<=4 and not UnitBuffID("player",InsanityBuff) and select(1,UnitChannelInfo("player")) == nil then
			if ORBS<=4 and not UnitBuffID("player",InsanityBuff) then
				--------------
				-- Standing --
				--------------
				--if getHP("target")>20 then
					-- Mind Blast on cd - No - Cast it
					if castSpell("target",MB,false,false) then return; end

					-- Mind Spike
					if ORBS<=4 or (ORBS==4 and (getDebuffRemain("target",SWP,"player") or getDebuffRemain("target",VT,"player")) then
						if not UnitDebuffID("target",DP,"player") then 
							if castSpell("target",MSp,false,true) then return; end
						end
					end

					-- SWD glyphed
					if not getTalent(3,3) then
						if hasGlyph(GlyphOfSWD) and isChecked("SWD glyphed") and getHP("target")>=20 then
							if castSpell("target",SWDG,true,false) then return; end
						end
					end

					-- MF Filler
					if select(1,UnitChannelInfo("player")) == nil and getSpellCD(MB)<GCD then
						if castSpell("target",MF,false,true) then return; end
					end

				--end

				------------
				-- Moving --
				------------
				-- if isMoving("player") then 
				-- 	-- Mind Blast on cd - No - Cast it
				-- 	if castSpell("target",MB,false,false) then return; end

				-- 	-- Mind Blast on cd - Yes - Power Word Shield on CD - No - Cast it
				-- 	--if isChecked("PW: Shield") and getHP("player")<=getValue("PW: Shield") then
				-- 	if castSpell("player",PWS) then return; end

				-- end -- END Moving

			end -- fill orbs
	end
	--[[                    ]] -- IcySingle DotWeave end


	--[[                    ]] -- IcySingle start
	function IcySingle()
		-- DP
		if ORBS>=3 then
			if UnitDebuffID("target",SWP,"player") and getDebuffRemain("target",SWP,"player")>DPTIME and UnitDebuffID("target",VT,"player") and getDebuffRemain("target",VT,"player")>DPTIME then
				if castSpell("target",DP,false,true) then return; end
			end
		end

		-- MB
		if castSpell("target",MB,false,false) then return; end

		-- SWD
		if castSpell("target",SWD,true,false) then return; end

		-- Insanity
		if getTalent(3,3) then
			if UnitBuffID("player",InsanityBuff) then
				if select(1,UnitChannelInfo("player")) == nil then
					if castSpell("target",MF,false,true) then return; end
				end
			end
		end

		-- MSp if SoD proc
		if getTalent(3,1) then
			if UnitBuffID("player",SoDProc) then
				if castSpell("target",MSp,false,true) then return; end
			end
		end

		-- SWP
		if not UnitDebuffID("target",SWP,"player") or (UnitDebuffID("target",SWP,"player") and getDebuffRemain("target",SWP)<=5.4) then
			if castSpell("target",SWP,true,false) then return; end
		end

		-- VT
		if lastVT==nil or GetTime()-lastVT > 2 then
			if not UnitDebuffID("target",VT,"player") or (UnitDebuffID("target",VT,"player") and getDebuffRemain("target",VT)<=4.5) then
				if castSpell("target",VT,true,true) then 
					lastVT=GetTime()
					return
				end
			end
		end

		-- MF Filler
		if getSpellCD(MB)>GCD and getSpellCD(MB)~=0 then
			if select(1,UnitChannelInfo("player")) == nil then
				if castSpell("target",MF,false,true) then return; end
			end
		end
	end
	--[[                    ]] -- IcySingle end


	--[[                    ]] -- Icy 2-3 Targets start
	function Icy23Targets()
		makeEnemiesTable(40)
		-- DP
		if ORBS>=3 then
			-- if (getDebuffRemain("target",SWP,"player")>DPTIME or not isChecked("Multi SWP")) and (getDebuffRemain("target",VT,"player")>DPTIME or not isChecked("Multi VT")) then
				if castSpell("target",DP,false,true) then return; end
			-- end
		end

		-- MB
		--breakMF()
		if ORBS<5 then
			if castSpell("target",MB,false,false) then return; end
		end

		-- SWD on Unit in range and hp<20
		if getSpellCD(SWD)==0 and ORBS<5 then
			for i=1,#enemiesTable do
				local thisUnit = enemiesTable[i].unit
				if UnitAffectingCombat(thisUnit) and enemiesTable[i].hp<20 then
					if castSpell(thisUnit,SWD,true,false) then return; end
				end
			end
		end

		-- SWP on max 3 targets
		if getSWP()<getValue("Max Targets") then
			if isChecked("Multi SWP") then
				for i = 1, #enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local ttd = getTimeToDie(thisUnit)
					local swpRem = getDebuffRemain(thisUnit,SWP,"player")
					if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and getDebuffRemain(thisUnit,SWP,"player") < 5.4 then
						if castSpell(thisUnit,SWP,true,false) then return; end
					end
				end
			end
		end

		-- VT on Unit in range
		if getVT()<getValue("Max Targets") then
			if isChecked("Multi VT") then
				for i = 1, #enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local ttd = getTimeToDie(thisUnit)
					local vtRem = getDebuffRemain(thisUnit,VT,"player")
					if UnitAffectingCombat(thisUnit) and getDebuffRemain(thisUnit,VT,"player") < 4.5 and GetTime()-lastVT>2 then
						if castSpell(thisUnit,VT,true,true) then 
							lastVT=GetTime()
							return
						end
					end
				end
			end
		end

		-- MF Filler
		if ORBS<3 and select(1,UnitChannelInfo("player")) == nil then
			if castSpell("target",MF,false,true) then return; end
		end
	end
	--[[                    ]] -- Icy 2-3 Targets end


	--[[                    ]] -- Icy 4+ Targets start
	function Icy4AndMore()
		-- DP
		if ORBS>=3 then
			if UnitDebuffID("target",SWP,"player") and getDebuffRemain("target",SWP,"player")>DPTIME and UnitDebuffID("target",VT,"player") and getDebuffRemain("target",VT,"player")>DPTIME then
				if castSpell("target",DP,false,true) then return; end
			end
		end

		-- MB
		--breakMF()
		if ORBS<5 then
			if castSpell("target",MB,false,false) then return; end
		end

		-- SWD on Unit in Range and hp<20
		if getSpellCD(SWD) ~= 0 and ORBS<5 then
			for i=1,#enemiesTable do
				local thisUnit = enemiesTable[i].unit
				if UnitAffectingCombat(thisUnit) and enemiesTable[i].hp<20 then
					if castSpell(thisUnit,SWD,true,false) then return; end
				end
			end
		end

		-- Halo
		if isKnown(Halo) and BadBoy_data['Halo'] == 2 then
			if castSpell("player",Halo) then return; end
		end

		-- SWP on max 3 targets
		if isChecked("Multi SWP") then
			for i = 1, #enemiesTable do
				local countSWP=0
				local thisUnit = enemiesTable[i].unit
				if UnitAffectingCombat(thisUnit) and getDebuffRemain(thisUnit,SWP,"player") < 5.4 then
					if castSpell(thisUnit,SWP,true,false) then return; end
				end
			end
		end

		-- VT on Unit in range
		if isChecked("Multi VT") then
			for i = 1, #enemiesTable do
				local thisUnit = enemiesTable[i].unit
				if UnitAffectingCombat(thisUnit) and getDebuffRemain(thisUnit,VT,"player") < 4.5 then
					if castSpell(thisUnit,VT,true,true) then return; end
				end
			end
		end

		-- Mind Sear
		if select(1,UnitChannelInfo("player")) == nil then
			if castSpell("target",MS,false,true) then return; end
		end
	end
	--[[                    ]] -- Icy 4+ Targets end
end