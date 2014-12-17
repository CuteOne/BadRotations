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
			if isChecked("Fade Aggro") and BadBoy_data['Defensive']==2 and getThreat()>=3 then
			--if isChecked("Fade Aggro") and BadBoy_data['Defensive'] == 2 then
				if castSpell("player",Fade) then return; end
			end
		end
		
		-- Healthstone
		if isChecked("Healthstone") and (BadBoy_data['Defensive'] == 2) and php <= getValue("Healthstone") then
			if canUse(109223) ~= false then UseItemByName(toString(select(1,GetItemInfo(109223)))); end
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

		-- MB on CD
				if castSpell("target",MB,false,false) then return; end


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

		-- Berserking (Troll Racial)
		if isKnown(Berserking) and BadBoy_data['Cooldowns'] == 2 and isChecked("Berserking") then
			if castSpell("player",Berserking) then return; end
		end

		-- Halo
		if isKnown(Halo) and BadBoy_data['Halo'] == 2 then
			if getDistance("player","target")<=30 and getDistance("player","target")>=17 then
				if castSpell("player",Halo) then return; end
			end
		end

		-- Trinket 1
		if isChecked("Trinket 1") and BadBoy_data['Cooldowns'] == 2 and canTrinket(13) then
			RunMacroText("/use 13")
		end

		-- Trinket 2
		if isChecked("Trinket 2") and BadBoy_data['Cooldowns'] == 2 and canTrinket(14) then
			RunMacroText("/use 14")
		end
	end
	--[[                    ]] -- Cooldowns end


	--[[                    ]] -- Execute start
	function Execute()
		if getHP("target")<=20 then
			-- ORBS>=3 -> DP
			if ORBS>=3 and getDebuffRemain("target",DP,"player")==0 then
				if castSpell("target",DP,true,false) then return; end
			end

			-- SWD
			if castSpell("target",SWD,true,false) then return; end

			-- MB
			if castSpell("target",MB,false,false) then return; end

			-- MF Filler
			if select(1,UnitChannelInfo("player")) == nil and getSpellCD(MB)>GCD then
				if castSpell("target",MF,false,true) then return; end
			end
		end
	end
	--[[                    ]] -- Execute end


	--[[                    ]] -- LF Orbs start
	function LFOrbs()
		if isChecked("Scan for Orbs") then
			if getSpellCD(SWD)<=0 and ORBS<5 then
				for i=1,#enemiesTable do
					local thisUnit = enemiesTable[i].unit
					if enemiesTable[i].hp<20 then
						if castSpell(thisUnit,SWD,true,false) then return; end
					end
				end
			end
		end
	end
	--[[                    ]] -- LF Orbs end


	--[[                    ]] -- IcySingle DotWeave start
	function IcySingleWeave()
		-----------------
		-- DoT Weaving --
		-----------------
			-- if ORBS==5 --> apply DoTs if targetHP>20
			--if isChecked("DoTWeave") and getTalent(3,3) then
			if getTalent(3,3) then
				-- function DoTWeaveBreak()
				-- 	local counter=0
				-- 	local factor=getValue("Weave Comp")/10
				-- 	if isChecked("SWP") then counter=counter+1 end
				-- 	if isChecked("VT") then counter=counter+1 end
				-- 	return counter*GCD*factor
				-- end
				-- local Break=DoTWeaveBreak()
				-- if ORBS>=4 and getHP("target")>20 and getSpellCD(MB)<Break then
				if ORBS>=4 and MBCD<2*GCD then
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
			--if isStanding(0.3) then
				if ORBS==5 then
					if castSpell("target",DP,false,true) then
						lastDP=GetTime()
						return
					end
				end
			--end

			-- DP if ORBS>=3 and lastDP<DPTIME and InsanityBuff<DPTICK
			if ORBS>=3 and GetTime()-lastDP<=DPTIME+2 then
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
			if not UnitDebuffID("player",InsanityBuff) then
				-- MB on CD
				if castSpell("target",MB,false,false) then return; end

				-- Mind Spike
				if ORBS<5 then 
					if castSpell("target",MSp,false,true) then return; end
				end

				-- SWD glyphed
				if not getTalent(3,3) then
					if hasGlyph(GlyphOfSWD) and isChecked("SWD glyphed") and getHP("target")>=20 then
						if castSpell("target",SWDG,true,false) then return; end
					end
				end
			end
	end
	--[[                    ]] -- IcySingle DotWeave end


	--[[                    ]] -- IcySingle start
	function IcySingle()
		-- DP
		if ORBS>=5 then
			if UnitDebuffID("target",SWP,"player") and getDebuffRemain("target",SWP,"player")>DPTIME and UnitDebuffID("target",VT,"player") and getDebuffRemain("target",VT,"player")>DPTIME then
				if ORBS==5 then
					if castSpell("target",DP,false,true) then
						lastDP=GetTime()
						return
					end
				end
			end
		end

		-- Burn Down ORBS (options)
		-- if (ORBS>=3 and not isChecked("DP5")) and GetTime()-lastDP<=DPTIME then
		-- 	if castSpell("target",DP,false,true) then return; end
		-- end

		-- Burn Down ORBS (Toggle)
		if ORBS>=3 and BadBoy_data['Burn'] == 2 and getDebuffRemain("target",DP,"player")==0 then
			if castSpell("target",DP,false,true) then return; end
		end

		-- Ko'ragh barroier bug (he is "under20% life" while barrier is under 20%)
		if GetUnitName("target")=="Ko'ragh" then
			if castSpell("target",SWD,true,false) then return; end
		end

		-- MB
		if castSpell("target",MB,false,false) then return; end

		-- Insanity
		if getTalent(3,3) then
			if UnitBuffID("player",InsanityBuff) then
				if select(1,UnitChannelInfo("player")) == nil or select(1,UnitChannelInfo("player")) == "Mind Flay" then
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

		-- Dot only if not burning
		if BadBoy_data['Burn'] == 1  and not UnitBuffID("player",InsanityBuff) then
			if getDebuffRemain("player",InsanityBuff)<=0 then
				-- SWP
				if getDebuffRemain("target",SWP,"player")<=5.4 then
					if castSpell("target",SWP,true,false) then return; end
				end	

				-- VT
				if lastVT==nil or GetTime()-lastVT > 2 then
					if getDebuffRemain("target",VT,"player")<=4.5 then
						if castSpell("target",VT,true,true) then 
							lastVT=GetTime()
							return
						end
					end
				end
			end
		end

		-- MF Filler
		if ORBS<5 then
			if getSpellCD(MB)>0.2*GCD then
				if select(1,UnitChannelInfo("player")) == nil then
					if castSpell("target",MF,false,true) then return; end
				end
			end
		end
	end
	--[[                    ]] -- IcySingle end


	--[[                    ]] -- Dual Target start
	function IcyDualTarget()
		-----------------
		-- DoT Weaving --
		-----------------
			-- if ORBS==5 --> apply DoTs if targetHP>20
			if isChecked("DoTWeave") and getTalent(3,3) then
				-- function DoTWeaveBreak()
				-- 	local counter=0
				-- 	local factor=getValue("Weave Comp")/10
				-- 	if isChecked("SWP") then counter=counter+1 end
				-- 	if isChecked("VT") then counter=counter+1 end
				-- 	return counter*GCD*factor
				-- end
				-- local Break=DoTWeaveBreak()
				-- if ORBS>=4 and getHP("target")>20 and getSpellCD(MB)<Break then
				if ORBS>=4 and getHP("target")>20 and MBCD<2*GCD then
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
			--if isStanding(0.3) then
				if ORBS==5 then
					if castSpell("target",DP,false,true) then
						lastDP=GetTime()
						return
					end
				end
			--end

			-- DP if ORBS>=3 and lastDP<DPTIME and InsanityBuff<DPTICK
			if ORBS>=3 and GetTime()-lastDP<=DPTIME+2 then
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
			if not UnitDebuffID("player",InsanityBuff) then
				-- MB on CD
				if castSpell("target",MB,false,false) then return; end

				-- Dot the bosses
				-- SWP on all bosses except target
				if isChecked("Boss SWP") then
					for i = 1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local ttd = getTimeToDie(thisUnit)
						local swpRem = getDebuffRemain(thisUnit,SWP,"player")
						if isBoss(thisUnit) and swpRem<getValue("Refresh Time") and not UnitIsUnit("target",thisUnit) then
							if castSpell(thisUnit,SWP,true,false) then return; end
						end
					end
				end
				-- VT on all bosses except target
				if isChecked("Boss VT") then
					for i = 1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local ttd = getTimeToDie(thisUnit)
						local vtRem = getDebuffRemain(thisUnit,VT,"player")
						if isBoss(thisUnit) and vtRem<getValue("Refresh Time") and GetTime()-lastVT>2*GCD and not UnitIsUnit("target",thisUnit) then
							if castSpell(thisUnit,VT,true,true) then 
								lastVT=GetTime()
								return
							end
						end
					end
				end

				-- Mind Spike
				if ORBS<5 then 
					if castSpell("target",MSp,false,true) then return; end
				end

				-- SWD glyphed
				if not getTalent(3,3) then
					if hasGlyph(GlyphOfSWD) and isChecked("SWD glyphed") and getHP("target")>=20 then
						if castSpell("target",SWDG,true,false) then return; end
					end
				end
			end
	end
	--[[                    ]] -- Dual Target end


	--[[                    ]] -- IcyMultiTarget start
	function IcyMultiTarget()
		--makeEnemiesTable(40)
		-- DP
		if ORBS>=5 then
			--if (getDebuffRemain("target",SWP,"player")>DPTIME or not isChecked("Multi SWP")) and (getDebuffRemain("target",VT,"player")>DPTIME or not isChecked("Multi VT")) then
				if castSpell("target",DP,false,true) then return; end
			--end
		end

		-- Burn Down ORBS (Toggle)
		if ORBS>=3 and BadBoy_data['Burn'] == 2 and getDebuffRemain("target",DP,"player")==0 then
			if castSpell("target",DP,false,true) then return; end
		end

		-- MB
		if ORBS<5 then
			if castSpell("target",MB,false,false) then return; end
		end

		-- Insanity with 2 targets
		if getTalent(3,3) then
			if #enemiesTable<=2 then
				if UnitBuffID("player",InsanityBuff) then
					if select(1,UnitChannelInfo("player")) == nil or select(1,UnitChannelInfo("player")) == "Mind Flay" then
						if castSpell("target",MF,false,true) then return; end
					end
				end
			end
		end
		if select(1,UnitChannelInfo("player")) == "Insanity" then return; end

		-- SWD on Unit in range and hp<20
		if getSpellCD(SWD)==0 and ORBS<5 then
			for i=1,#enemiesTable do
				local thisUnit = enemiesTable[i].unit
				if enemiesTable[i].hp<20 then
					if castSpell(thisUnit,SWD,true,false) then return; end
				end
			end
		end

		-- SWP on max targets (options)
		if getSWP()<=getValue("Max Targets") then
			-- apply on current target before iterating
			if getDebuffRemain("target",SWP,"player")<getValue("Refresh Time") then
				if castSpell("target",SWP,true,false) then return; end
			end
			-- iterate the table if multiSWP
			if isChecked("Multi SWP") then
				for i = 1, #enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local ttd = getTimeToDie(thisUnit)
					local swpRem = getDebuffRemain(thisUnit,SWP,"player")
					if (not isLongTimeCCed(thisUnit)) and swpRem<getValue("Refresh Time") then
						if castSpell(thisUnit,SWP,true,false) then return; end
					end
				end
			end
		end

		-- VT on Unit in range
		if getVT()<=getValue("Max Targets") then
			-- apply on current target before iterating
			if getDebuffRemain("target",VT,"player")<getValue("Refresh Time") and GetTime()-lastVT>2*GCD then
				if castSpell("target",VT,true,true) then 
					lastVT=GetTime()
					return
				end
			end
			-- iterate the table if multiVT
			if isChecked("Multi VT") then
				for i = 1, #enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local ttd = getTimeToDie(thisUnit)
					local vtRem = getDebuffRemain(thisUnit,VT,"player")
					if (not isLongTimeCCed(thisUnit)) and vtRem<getValue("Refresh Time") and GetTime()-lastVT>2*GCD then
						if castSpell(thisUnit,VT,true,true) then 
							lastVT=GetTime()
							return
						end
					end
				end
			end
		end

		-- Mind Sear Filler
		--if #getEnemies("player",40)>=3 then
		if BadBoy_data['Single']==2 then
			if select(1,UnitChannelInfo("player")) == nil or select(1,UnitChannelInfo("player")) == "Mind Flay" then
				if castSpell("target",MS,false,true) then return; end
			end
		end

		-- MF Filler
		--if getDebuffRemain("target",SWP,"player")<getValue("Refresh Time") then
			if (ORBS<=5 or (ORBS<=3 and BadBoy_data['Burn'] == 2)) and select(1,UnitChannelInfo("player")) == nil then
				if castSpell("target",MF,false,true) then return; end
			end	
		--end
	end
	--[[                    ]] -- IcyMultiTarget end
end


-- TTD with DoTs
-- minHP for dotting
-- weave rota burn!

-- farm mode -> dot all with swp in range. option for it