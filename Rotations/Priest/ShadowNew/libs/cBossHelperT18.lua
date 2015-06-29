if select(3, UnitClass("player")) == 5 and GetSpecialization() == 3 then
	function cShadow:BossHelperT18()

		--[[ Hellfire Citadel - T18 ]]
		if GetRealZoneText()=="Hellfire Citadel" then

			-- Hellfire Assault
				if currentBoss=="Reinforced Hellfire Door" then
					-- auto target
					
					-- cascade
					if getSpellCD(self.spell.cascade)<=0 then
						if active_enemies_40 >= 5 then
							if self.castCascadeAuto() then return end
						end
					end
				end

			-- Iron Reaver
				if currentBoss=="Iron Reaver" then
					-- auto target

					-- cascade

				end

			-- Kormrok
				if currentBoss=="Kormrok" then
					-- auto target
					
					-- cascade
					if getSpellCD(self.spell.cascade)<=0 then
						if isUnitThere("Grasping Hand",40) then
							if self.castCascadeAuto() then return end
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
							if self.castCascadeAuto() then return end
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
						if self.castCascadeAuto() then return end
					end
				end

			-- Shadow Lord Iskar
				if currentBoss=="Shadow-Lord Iskar" then
					-- auto target
					if self.options.bosshelper.target then
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
						-- cascade
						if isUnitThere("Corrupted Talonpriest",40) then
							if castCascadeAuto() then return end
						end
					end
				end

			-- Socrethar the Eternal
				if currentBoss=="Soulbound Construct" then
					-- auto target
					
					-- cascade
					if getSpellCD(self.spell.cascade)<=0 then
						if isUnitThere("Haunting Soul",40) or isUnitThere("Sargerei Shadowcaller",40) then
							if self.castCascadeAuto() then return end
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
							if self.castCascadeAuto() then return end
						end
					end
				end

			-- Tyrant Velhari

			-- Mannoroth
			if currentBoss=="Fel Iron Summoner" then
				-- auto target
				
				-- cascade
				if getSpellCD(self.spell.cascade)<=0 then
					if isUnitThere("Fel Imp",40) then
						if self.castCascadeAuto() then return end
					end
				end
			end

			-- Archimonde

		end
	end
end