if select(3, UnitClass("player")) == 5 and GetSpecialization()==3 then

	--[[ Execute CoP ]]
	function ExecuteCoP(options)
		if getHP("target")<=20 then
			-- ORBS>=3 -> DP
			if options.player.ORBS>=3 then
				if castSpell("target",DP,true,false) then return end
			end

			-- MB
			if castSpell("target",MB,false,false) then return end

			-- SWD
			if castSpell("target",SWD,true,false) then return end

			-- SoD Proc
			if getBuffStacks("player",SoDProc)>=1 then
				if castSpell("target",MSp,false,false) then return end
			end

			-- MF Filler
			if select(1,UnitChannelInfo("player")) == nil and options.player.ORBS<3 then
				if castSpell("target",MF,false,true) then return end
			end
		end
	end -- Execute CoP
	
	--[[ Execute AS ]]
	function ExecuteAS(options)
		if getHP("target")<=20 then

			-- Shadowfiend/Mindbender etc.
			ShadowCooldownsSmall(options)

			-- DP on 3+ Orbs
			if options.player.ORBS>=3 then
				if castSpell("target",DP,true,false) then return end
			end

			-- MB
			if castSpell("target",MB,false,true) then return end

			-- SoD Proc
			if getBuffStacks("player",SoDProc)>=1 then
				if castSpell("target",MSp,false,false) then return end
			end

			-- SWD
			if castSpell("target",SWD,true,false) then return end

			-- Insanity if noChannel
			if getBuffRemain("player",InsanityBuff)>0 then
				-- Check for current channel and cast Insanity
				if select(1,UnitChannelInfo("player")) == nil then
					if castSpell("target",MF,false,true) then return end
				end
			end

			-- SWP / VT
			if getTimeToDie("target")>25 then
				-- SWP
				if getDebuffRemain("target",SWP,"player")<options.values.SWPRefresh then
					if castSpell("target",SWP,true,false) then return end
				end
				-- VT
				if getDebuffRemain("target",VT,"player")<=options.values.VTRefresh and GetTime()-lastVT > 2*options.player.GCD then
					if castSpell("target",VT,true,true) then 
						lastVT=GetTime()
						return
					end
				end
			end

			-- MF Filler
			if select(1,UnitChannelInfo("player")) == nil then
				if castSpell("target",MF,false,true) then return end
			end
		end
	end -- Execute AS

	--[[ LF ToF ]]
	function LFToF(options)
		if options.isChecked.ScanToF then
			if getBuffRemain("player",ToF)<options.player.GCD then
				for i=1,#enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local range = enemiesTable[i].distance
					local hp = enemiesTable[i].hp
					if hp<35 and range < 40 then
						if getSpellCD(MB)>0 then
							if castSpell(thisUnit,SWP,true,false) then return end
						end
					end
				end
			end
		end
	end -- LF ToF

	--[[ LF Orbs ]]
	function LFOrbs(options)
		if options.isChecked.ScanOrbs then
			if getSpellCD(SWD)<=0 then
				if options.player.ORBS<5 then
					if getHP("target")<=20 then
						if castSpell("target",SWD,true,false) then return end
					else
						for i=1,#enemiesTable do
							local thisUnit = enemiesTable[i].unit
							local range = enemiesTable[i].distance
							local hp = enemiesTable[i].hp
							if hp<20 and range < 40 then
								if castSpell(thisUnit,SWD,true,false,false,false,false,false,true) then return end
							end
						end
					end
				end
			end
		end
	end --LF Orbs

end