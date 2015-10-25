if select(3, UnitClass("player")) == 5 and GetSpecialization() == 3 then
	function cShadow:BossHelperT18()

		--[[ Hellfire Citadel - T18 ]]
		if GetRealZoneText()=="Hellfire Citadel" then

			-- -- Hellfire Assault
			-- 	if currentBoss=="Reinforced Hellfire Door" then
			-- 		-- auto target
					
			-- 		-- cascade
			-- 		if getSpellCD(self.spell.cascade) <= 0 then
			-- 			if (isUnitThere(93830,40) or isUnitThere(90114,40)) and (getUnitCount(93830,40,true)>=4 or getUnitCount(90114,40,true)>=4) then
			-- 				if self.castCascade() then return end
			-- 			end
			-- 		end
			-- 	end

			-- -- Iron Reaver
			-- 	if currentBoss=="Iron Reaver" then
			-- 		-- auto target

			-- 		-- cascade
			-- 		if isUnitThere(93717,40) or isUnitThere(94955,40) or isUnitThere(94312,40) or isUnitThere(94322,40) then
			-- 			if self.castCascade() then return end
			-- 		end
			-- 	end

			-- -- Kormrok
			-- 	if currentBoss=="Kormrok" then
			-- 		-- auto target
					
			-- 		-- cascade
			-- 		if getSpellCD(self.spell.cascade) <= 0 then
			-- 			if isUnitThere("Grasping Hand",40) then
			-- 				if self.castCascade() then return end
			-- 			end
			-- 		end
			-- 	end


			-- -- Hellfire High Council
			-- 	if currentBoss=="Gurtogg Bloodboil" or currentBoss=="Blademaster Jubei'thos" or currentBoss=="Dia Darkwhisper" then
			-- 		-- auto target
					
			-- 		-- cascade
			-- 		if getSpellCD(self.spell.cascade) <= 0 then
			-- 			-- cascade Jubei Mirrors
			-- 			if isUnitThere(94865,40) then
			-- 				if self.castCascade() then return end
			-- 			end
			-- 		end
			-- 	end

			-- -- Kilrogg Deadeye
			-- 	if currentBoss=="Kilrogg Deadeye" then
			-- 		-- target boss if no target
			-- 		if not (UnitName("target") == "Fel Blood Globule" or UnitName("target") == "Blood Globule") then
			-- 			if isUnitThere("Fel Blood Globule",40) then TargetUnit("Fel Blood Globule") end
			-- 			if isUnitThere("Blood Globule",40) then TargetUnit("Blood Globule") end
			-- 		end

			-- 		if GetObjectExists("target")==false then TargetUnit("Kilrogg Deadeye") end

			-- 		-- cascade
			-- 		if getSpellCD(self.spell.cascade) <= 0 then
			-- 			if getNumEnemies("player",40) >= 4 then
			-- 				if #getEnemies(getBiggestUnitCluster(40,40),40) >= 4 then
			-- 					if self.castCascade() then return end
			-- 				end
			-- 			end
			-- 		end
			-- 	end

			-- -- Gorefiend
			-- 	if currentBoss=="Gorefiend" then
			-- 		-- Touch of Doom: Auto Speed
			-- 		if getDebuffRemain("player",179977) > 1 then
			-- 			if getDebuffRemain("player",179977) <= 6 then
			-- 				if buff.angelic_feather <= 0 then
			-- 					if self.castAngelicFeatherOnMe() then return end
			-- 				end
			-- 			end
			-- 		end

			-- 		-- SWP every Mirror Image
			-- 		if self.options.bosshelper.gorefiendSWP.enabled then
			-- 			for i=1, #enemiesTable do
			-- 				local thisUnit = enemiesTable[i].unit
			-- 				if UnitCastingInfo(thisUnit) == "Resisting" or UnitBuffID(thisUnit,189131) or UnitDebuffID(thisUnit,189131) then
			-- 					if getDebuffRemain(thisUnit,self.spell.shadow_word_pain,"player") <= 18*0.3 then
			-- 						if getHP(thisUnit) > 20 then
			-- 							if castSpell(thisUnit,self.spell.shadow_word_pain,true,false) then return end
			-- 						end
			-- 					end
			-- 				end
			-- 			end
			-- 		end

			-- 		-- cascade
			-- 		if getSpellCD(self.spell.cascade) <= 0 then
			-- 			if self.castCascade() then return end
			-- 		end
			-- 	end

			-- Shadow Lord Iskar
				if currentBoss=="Shadow-Lord Iskar" then
					-- escape fel chakram: 182200, 182178
					if talent.spectral_guise then
						if UnitDebuffID("player",18220) or UnitDebuffID("player",182178) then
							if self.castSpectralGuise() then return end
						end
					end
					-- auto target
						-- target Shadowfel Warden
						if isUnitThere("Phantasmal Radiance") then
							TargetUnit("Phantasmal Radiance")
							return
						end
					-- 	if isUnitThere("Corrupted Priest of Terrok") then
					-- 		TargetUnit("Corrupted Priest of Terrok")
					-- 		return
					-- 	end
					-- end					
					-- -- cascade
					-- if getSpellCD(self.spell.cascade) <= 0 then
					-- 	if isUnitThere("Corrupted Talonpriest",40) then
					-- 		if self.castCascade() then return end
					-- 	end
				end

			-- -- Socrethar the Eternal
			-- 	if currentBoss=="Soulbound Construct" then
			-- 		-- auto target
					
			-- 		-- cascade
			-- 		-- if getSpellCD(self.spell.cascade) <= 0 then
			-- 		-- 	if isUnitThere("Haunting Soul",40) or isUnitThere("Sargerei Shadowcaller",40) then
			-- 		-- 		if self.castCascadeBiggestCluster() then return end
			-- 		-- 	end
			-- 		-- end
			-- 		if getSpellCD(self.spell.cascade) <= 0 then
			-- 			if isUnitThere("Haunting Soul",40) then
			-- 				if self.castCascadeOn("Haunting Soul") then return end
			-- 			end
			-- 		end
			-- 	end

			-- -- Feld Lord Zakuun

			-- -- Xhul'horac
			-- 	if currentBoss=="Xhul'horac" then
			-- 		-- auto target

			-- 		-- cascade
			-- 		if getSpellCD(self.spell.cascade) <= 0 then
			-- 			if isUnitThere("Wild Pyromaniac",40) or isUnitThere("Unstable Voidfiend",40) then
			-- 				if self.castCascade() then return end
			-- 			end
			-- 		end
			-- 	end

			-- Tyrant Velhari
				if currentBoss=="Tyrant Velhari" then
					-- auto target
					if UnitTarget("player")==nil then TargetUnit("boss1") end

					-- Spectral Guise on ANnihilating Strike (id=180260)
					if self.talent.spectral_guise then
						if UnitName(UnitTarget("boss1"))==UnitName("player") then
							if isCastingSpell(180260,"boss1") then
								if self.castSpectralGuise() then return end
							end
						end
					end

					-- cascade
					if getSpellCD(self.spell.cascade) <= 0 then
						if isUnitThere("Ancient Sovereign",40)
						or isUnitThere("Ancient Enforcer",40)
						or isUnitThere("Ancient Harbinger",40) then
							if self.castCascade() then return end
						end
					end
				end

			-- -- Mannoroth
			-- if currentBoss=="Fel Iron Summoner" then
			-- 	-- auto target
				
			-- 	-- cascade
			-- 	if getSpellCD(self.spell.cascade) <= 0 then
			-- 		if isUnitThere("Fel Imp",40) then
			-- 			if self.castCascade() then return end
			-- 		end
			-- 	end
			-- end

			-- Archimonde
			if currentBoss=="Archimonde" then
				-- auto target
				--if self.options.bosshelper.target.enabled then
					if isUnitThere("Doomfire Spirit",40) then TargetUnit("Doomfire Spirit") end
					--if isUnitThere("Hellfire Deathcaller",40) then TargetUnit("Hellfire Deathcaller") end
					--if isUnitThere("Felborne Overfiend",40) then TargetUnit("Felborne Overfiend") end
					--if isUnitThere("Living Shadow",40) then TargetUnit("Living Shadow") end
					if UnitTarget("player")==nil or UnitIsDeadOrGhost("target") then TargetUnit("Archimonde") end
				--end

				-- Doomfire Spirit
				if getUnitID("target")==92208 then
					if self.BurnRotation() then return end
				end

				-- dot all dogs (Dreadstalker: 93616)
				for i=1, #enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local thisUnitID = enemiesTable[i].id
					if thisUnitID == 93616 then
						if getDebuffRemain(thisUnit,self.spell.shadow_word_pain,"player") <= 18*0.3 then
							if getHP(thisUnit) > 20 then
								if castSpell(thisUnit,self.spell.shadow_word_pain,true,false) then return end
							end
						end
					end
				end


				-- if GetObjectExists("target")==false then TargetUnit("Archimonde") end
				
				-- cascade
				if getSpellCD(self.spell.cascade) <= 0 then
					if isUnitThere("Doomfire Spirit",40) then
						if self.castCascade() then return end
					end
				end
				-- if getSpellCD(self.spell.cascade) <= 0 then
				-- 	if getUnitCount(93616,40,true) >= 3 				-- Dreadstalker
				-- 	or isUnitThere("Doomfire Spirit",40) 
				-- 	or isUnitThere("Infernal Doombringer",40) then
				-- 		if self.castCascade() then return end
				-- 	end
				-- end

				-- Doomfire Spirit burn
				if getUnitID("target")==92208 then
					if self.BurnRotation() then return end
				end
			end
		end
	end
end