if select(3, UnitClass("player")) == 5 and GetSpecialization() == 3 then
	function cShadow:BossHelperT18()

		--[[ Hellfire Citadel - T18 ]]
		if GetRealZoneText()=="Hellfire Citadel" then
			-- Hellfire Assault
				if currentBoss=="Reinforced Hellfire Door" then
					-- auto target
					
					-- cascade
					if getSpellCD(spell.cascade) then
						if active_enemies_40 >= 5 then
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
					if getSpellCD(spell.cascade)<=0 then
						if isUnitThere("Grasping Hand",40) then
							if castCascadeAuto() then return end
						end
					end
				end


			-- Hellfire High Council
				if currentBoss=="Gurtogg Bloodboil" or currentBoss=="Blademaster Jubei'thos" or currentBoss=="Dia Darkwhisper" then
					-- auto target
					
					-- cascade
					if getSpellCD(spell.cascade)<=0 then
						-- cascade Jubei Mirrors
						if isUnitThere(94865,40) then
							if castCascadeAuto() then return end
						end
					end
				end

			-- Kilrogg Deadeye

			-- Gorefiend
				if currentBoss=="Gorefiend" then
				end

			-- Shadow Lord Iskar
				if currentBoss=="Shadow-Lord Iskar" then
					-- auto target
					if options.isChecked.AutoTarget then
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
					if getSpellCD(spell.cascade)<=0 then
						-- sort enemiesTable by distance
						sortByDistance()
						-- cascade farest dog
						if isUnitThere("Corrupted Talonpriest",40) then
							if castCascadeAuto() then return end
						end
					end
				end

			-- Socrethar the Eternal
				if currentBoss=="Soulbound Construct" then
					-- auto target
					
					-- cascade
					if getSpellCD(spell.cascade)<=0 then
						if isUnitThere("Haunting Soul",40) or isUnitThere("Sargerei Shadowcaller",40) then
							if castCascadeAuto() then return end
						end
					end
				end

			-- Feld Lord Zakuun

			-- Xhul'horac
				if currentBoss=="Xhul'horac" then
					-- auto target

					-- cascade
					if getSpellCD(spell.cascade)<=0 then
						if isUnitThere("Wild Pyromaniac",40) or isUnitThere("Unstable Voidfiend",40) then
							if castCascadeAuto() then return end
						end
					end
				end

			-- Tyrant Velhari

			-- Mannoroth

			-- Archimonde

		end
	end
end