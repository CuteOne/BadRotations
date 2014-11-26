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


	-- get threat situation on player and return the number
	function getThreat()
		return UnitThreatSituation("player")
		-- 0 - Unit has less than 100% raw threat (default UI shows no indicator)
		-- 1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
		-- 2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
		-- 3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
	end


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
			if isChecked("Fade Aggro") and (BadBoy_data['Defensive'] == 2) and getThreat()>=2 then
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
	end -- END SHADOW DEFENSIVES

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

	end -- END SHADOW Cooldowns


	---------
	-- AoE --
	---------
	function ShadowAoE()
		-- Mind Sear
		if castSpell("target",MS,false,true) then return; end
	end


	----------
	-- Burn --
	----------
	function ShadowCoPBurn()
		-- Burn ORBS
		if ORBS>=3 then
			if castSpell("target",DP,false,true) then return; end
		end
		-- SWD
		if castSpell("target",SWD) then return; end
		-- MB
		if castSpell("target",MB,false) then return; end
		-- MF Filler
		if select(1,UnitChannelInfo("player")) == nil then
			if castSpell("target",MF,false,true) then return; end
		end
	end

	function ShadowH2PCoP()
		-----------------
		-- DoT Weaving --
		-----------------

		-- if ORBS==5 --> apply DoTs if targetHP>20
		if ORBS>=4 and getHP("target")>20 and getSpellCD(MB)<2*GCD then
			if not UnitDebuffID("target",SWP,"player") then
				if castSpell("target",SWP,true,true) then return; end
			end
			if not UnitDebuffID("target",VT,"player") and GetTime()-lastVT > 2 then
				if castSpell("target",VT,true,true) then 
					lastVT=GetTime()
					return
				end
			end
		end

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
		if UnitBuffID("player",InsanityBuff) then
			if select(1,UnitChannelInfo("player")) == nil then
				if castSpell("target",MF,false,true) then return; end
			end
		end


		---------------
		-- Fill Orbs --
		---------------
		if ORBS<=4 and not UnitBuffID("player",InsanityBuff) and select(1,UnitChannelInfo("player")) == nil then
			--------------
			-- Standing --
			--------------
			-- if getHP("target")<=20 then
			-- 	-- SWD on CD - No - Cast it
			-- 	if castSpell("target",SWD) then return; end
				
			-- 	-- SWD on CD - Yes - Mind Blast on cd - No - Cast it
			-- 	if castSpell("target",MB,false) then return; end
				
			-- 	-- SWD on CD - Yes - Mind Blast on cd - Yes - Cast Mind Spike
			-- 	if castSpell("target",MSp,false,true) then return; end
			-- end
			
			--if getHP("target")>20 then
				-- Mind Blast on cd - No - Cast it
				if castSpell("target",MB,false) then return; end

				-- Mind Blast on cd - Yes - Cast Mind Spike
				if castSpell("target",MSp,false,true) then return; end
			--end

			------------
			-- Moving --
			------------
			if isMoving("player") then 
				-- Mind Blast on cd - No - Cast it
				if castSpell("target",MB,false) then return; end

				-- Mind Blast on cd - Yes - Power Word Shield on CD - No - Cast it
				--if isChecked("PW: Shield") and getHP("player")<=getValue("PW: Shield") then
				if castSpell("player",PWS) then return; end

			end -- END Moving

		end -- END filling ORBS

	end -- END ShadowH2P()

end -- END FILE