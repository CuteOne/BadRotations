if select(3, UnitClass("player")) == 5 and GetSpecialization() == 3 then
	function cShadow:BossHelperT18()

		--[[ Hellfire Citadel - T18 ]]
		if GetRealZoneText()=="Hellfire Citadel" then

			-- Hellfire Assault
				if currentBoss=="Reinforced Hellfire Door" then
					-- auto target
					
					-- cascade
					if getSpellCD(self.spell.cascade)<=0 then
						--if self.enemies.active_enemies_40 > 5 then
							if self.castCascadeBiggestCluster() then return end
						--end
					end
				end

			-- Iron Reaver
				if currentBoss=="Iron Reaver" then
					-- auto target

					-- cascade
					if isUnitThere(93717,40) or isUnitThere(94955,40) or isUnitThere(94312,40) or isUnitThere(94322,40) then
						if self.castCascadeBiggestCluster() then return end
					end
				end

			-- Kormrok
				if currentBoss=="Kormrok" then
					-- auto target
					
					-- cascade
					if getSpellCD(self.spell.cascade)<=0 then
						if isUnitThere("Grasping Hand",40) then
							if self.castCascadeBiggestCluster() then return end
						end
					end
				end


			-- Hellfire High Council
				if currentBoss=="Gurtogg Bloodboil" or currentBoss=="Blademaster Jubei'thos" or currentBoss=="Dia Darkwhisper" then
					-- auto target
					
					-- cascade
					if getSpellCD(self.spell.cascade)<=0 then
						-- cascade Jubei Mirrors
						if isUnitThere(94865,40) then
							if self.castCascadeBiggestCluster() then return end
						end
					end
				end

			-- Kilrogg Deadeye
				if currentBoss=="Kilrogg Deadeye" then
					-- target boss if no target
					if GetObjectExists("target")==false then TargetUnit("Kilrogg Deadeye") end
				end

			-- Gorefiend
				if currentBoss=="Gorefiend" then
					-- cascade
					if getSpellCD(self.spell.cascade)<=0 then
						if self.castCascadeBiggestCluster() then return end
					end
				end

			-- Shadow Lord Iskar
				if currentBoss=="Shadow-Lord Iskar" then
					-- auto target
					if self.options.bosshelper.target.enabled then
						-- target Shadowfel Warden
						if isUnitThere("Shadowfel Warden") then
							TargetUnit("Shadowfel Warden")
							return
						end
						if isUnitThere("Corrupted Priest of Terrok") then
							TargetUnit("Corrupted Priest of Terrok")
							return
						end
					end					
					-- cascade
					if getSpellCD(self.spell.cascade)<=0 then
						if isUnitThere("Corrupted Talonpriest",40) then
							if self.castCascadeBiggestCluster() then return end
						end
					end
				end

			-- Socrethar the Eternal
				if currentBoss=="Soulbound Construct" then
					-- auto target
					
					-- cascade
					if getSpellCD(self.spell.cascade)<=0 then
						if isUnitThere("Haunting Soul",40) or isUnitThere("Sargerei Shadowcaller",40) then
							if self.castCascadeBiggestCluster() then return end
						end
					end
				end

			-- Feld Lord Zakuun

			-- Xhul'horac
				if currentBoss=="Xhul'horac" then
					-- auto target

					-- cascade
					if getSpellCD(self.spell.cascade)<=0 then
						if isUnitThere("Wild Pyromaniac",40) or isUnitThere("Unstable Voidfiend",40) then
							if self.castCascadeBiggestCluster() then return end
						end
					end
				end

			-- Tyrant Velhari
				if currentBoss=="Tyrant Velhari" then
					-- auto target

					-- cascade
					if getSpellCD(self.spell.cascade)<=0 then
						if isUnitThere("Ancient Sovereign",40)
						or isUnitThere("Ancient Enforcer",40)
						or isUnitThere("Ancient Harbinger",40) then
							if self.castCascadeBiggestCluster() then return end
						end
					end
				end

			-- Mannoroth
			if currentBoss=="Fel Iron Summoner" then
				-- auto target
				
				-- cascade
				if getSpellCD(self.spell.cascade)<=0 then
					if isUnitThere("Fel Imp",40) then
						if self.castCascadeBiggestCluster() then return end
					end
				end
			end

			-- Archimonde
			if currentBoss=="Archimonde" then
				-- auto target
				if self.options.bosshelper.target.enabled then
					--if isUnitThere("Doomfire Spirit",40) then TargetUnit("Doomfire Spirit") end
					--if isUnitThere("Hellfire Deathcaller",40) then TargetUnit("Hellfire Deathcaller") end
					--if isUnitThere("Felborne Overfiend",40) then TargetUnit("Felborne Overfiend") end
					--if isUnitThere("Living Shadow",40) then TargetUnit("Living Shadow") end
					if UnitTarget("player")==nil then TargetUnit("Archimonde") end
				end

				-- if GetObjectExists("target")==false then TargetUnit("Archimonde") end
				
				-- cascade
				if getSpellCD(self.spell.cascade)<=0 then
					if getUnitCount(93616,40,true) >= 3 				-- Dreadstalker
					or isUnitThere("Doomfire Spirit",40) 
					or isUnitThere("Infernal Doombringer",40) then
						if self.castCascadeBiggestCluster() then return end
					end
				end
			end
		end
	end
end