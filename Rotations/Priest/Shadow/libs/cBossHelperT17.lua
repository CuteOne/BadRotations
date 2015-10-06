if select(3, UnitClass("player")) == 5 and GetSpecialization() == 3 then
	function cShadow:BossHelperT17()
		--[[ Blackrock Foundry - T17 ]]
		if GetRealZoneText()=="Blackrock Foundry" then

			--[[ Hans & Franz ]]
				if currentBoss=="Hans'gar" or currentBoss=="Franzok" then
					-- Auto Target Franz if in range, else target Hans
					if options.isChecked.AutoTarget then
						if GetObjectExists("target")==false then 
							if LFU("Hans'gar") then return true end
						end
						if GetObjectExists("target")==false then 
							if LFU("Franzok") then return true end
						end
					end
					-- Auto cascade
					if getDistance("boss1","boss2")>20 then
						if castSpell("boss1",spell.cascade,true,false) then return end
					end
				end

			--[[ Beastlord Darmac ]]
				if currentBoss=="Beastlord Darmac" or currentBoss=="Cruelfang" or currentBoss=="Dreadwing" or currentBoss=="Ironcrusher" or currentBoss=="Faultine" then
					-- Pack Beast - cascade
					if getTalent(6,1) then
						if getSpellCD(cascade)<=0 then
							for i=1,#enemiesTable do
								local thisUnit = enemiesTable[i].unit
								if UnitName(thisUnit) == "Pack Beast" then
									if getDistance("player",thisUnit)<40 then
										if castSpell(thisUnit,spell.cascade,true,false) then return end
									end
								end
							end
						end
					end
					-- Target Helper
					if options.isChecked.AutoTarget then
						-- target Beastlord Darmac
						if GetObjectExists("target")==false then 
							if LFU("Beastlord Darmac") then return end
						end
						-- target Cruelfang
						if GetObjectExists("target")==false then 
							if LFU("Cruelfang") then return end
						end
						-- target Dreadwing
						if GetObjectExists("target")==false then 
							if LFU("Dreadwing") then return end
						end
						-- target Ironcrusher
						if GetObjectExists("target")==false then 
							if LFU("Ironcrusher") then return end
						end
						-- target Faultine
						if GetObjectExists("target")==false then 
							if LFU("Faultine") then return end
						end
					end
				end

			--[[ Gruul ]]
				-- Target Helper
				if options.isChecked.AutoTarget then
					if currentBoss=="Gruul" and GetObjectExists("target")==false then
						if LFU("Gruul") then return end
					end
				end

			--[[ Flamebender Ka'graz ]]
				if currentBoss=="Flamebender Ka'graz" then
					-- cascade Dogs
					if getTalent(6,1) then
						if getSpellCD(cascade)<=0 then
							-- sort enemiesTable by distance
							sortByDistance()
							-- cascade farest dog
							for i=1,#enemiesTable do
								local thisUnit = enemiesTable[i].unit
								if getDistance("player",thisUnit)<40 then
									if UnitName(thisUnit) == "Cinder Wolf" then
										if castSpell(thisUnit,spell.cascade,true,false) then return end
									end
								end
							end
						end
					end
				end

			--[[ Operator Thogar ]]
				if currentBoss=="Operator Thogar" then
					-- Auto Mass Dispel
					if options.isChecked.AutoMassDispel then
						for i=1,#enemiesTable do
							local thisUnit = enemiesTable[i].unit
							if getSpellCD(spell.mass_dispel)<=0 then
								if getBuffRemain(thisUnit,160140)>0 then
									if castGround(thisUnit,spell.mass_dispel,30) then
									SpellStopTargeting()
									return
									end
								end
							end
						end
					end
					-- Halo/cascade Reinforcements
					if (getSpellCD(spell.halo) and talent.halo) or (getSpellCD(spell.cascade) and talent.cascade) then
						-- sort enemiesTable by distance
						self.sortByDistance()
						for i=1,#enemiesTable do
							local thisUnit = enemiesTable[i].unit
							if getDistance("player",thisUnit)<40 then
								if UnitName("Iron Raider") or UnitName("Iron Crack-Shot") then
									if getTalent(6,1) then
										if castSpell(thisUnit,spell.cascade,true,false) then return end
									end
									if getTalent(6,3) then
										if castSpell(thisUnit,spell.halo,true,false) then return end
									end
								end
							end
						end
					end
					-- Auto Silence
					if options.isChecked.AutoSilence then
						-- Grom'kar Firemender: Cauterizing Bolt
						for i=1,#enemiesTable do
							local thisUnit = enemiesTable[i].unit
							if UnitCastingInfo(thisUnit) == "Cauterizing Bolt" then
								ShadowSimpleKick(thisUnit)
								-- local cRem = select(6,UnitCastingInfo(thisUnit)) - GetTime()*1000
								-- if cRem <= 1000 then
								-- 	if getSpellCD(Silence)<=0 then
								-- 		if castSpell(thisUnit,Silence,true,false) then return end
								-- 	end
								-- 	if isKnown(ArcT) then
								-- 		if getSpellCD(ArcT)<=0 and getDistance("player",thisUnit)<=8 then
								-- 			if castSpell(thisUnit,ArcT,true,false) then return end
								-- 		end
								-- 	end
								-- end
							end
						end
					end
					-- Auto Target
					if options.isChecked.AutoTarget then
						-- target Grom'kar Man-at-Arms
						if UnitName("target")~="Grom'kar Man-at-Arms" and isAlive("Grom'kar Man-at-Arms") and getDistance("Grom'kar Man-at-Arms")<=40 then
							if LFU("Grom'kar Man-at-Arms") then return end
						end
						-- target Iron Gunnery Sergeant / SWD, DP, MB
						if UnitName("target")~="Iron Gunnery Sergeant" and isAlive("Iron Gunnery Sergeant") and getDistance("Iron Gunnery Sergeant")<=40 then
							if LFU("Grom'kar Man-at-Arms") then return end
						end
					end
				end

			--[[ The Blast Furnace ]]
				if currentBoss=="Heart of the Mountain" then
					-- Burn Elementalist (http://www.wowhead.com/spell=158345/shields-down)
					for i=1,#enemiesTable do
						local thisUnit = enemiesTable[i].unit
						if UnitName(thisUnit) == "Primal Elementalist" then
							if getBuffRemain(thisUnit,158345)>0 then
								TargetUnit(thisUnit)
							end
						end
					end
					-- cascade
					if getTalent(6,1) then
						-- cascade farest enemy in LoS
						for i=1,#enemiesTable do
							local thisUnit = enemiesTable[i].unit
							if getLineOfSight(thisUnit) then
								if getDistance("player",thisUnit)<40 then
									if castSpell(thisUnit,spell.cascade,true,false) then return end
								end
							end
						end
					end
					-- Auto Dispel
					if options.isChecked.AutoDispel then
						-- Reactive Earth Shield
						for i=1,#enemiesTable do
							local thisUnit = enemiesTable[i].unit
							if getBuffRemain(thisUnit,155173)>0 then
								if castSpell(thisUnit,DispM,true,false) then return end
							end
						end
					end
					-- Auto Silence
					if options.isChecked.AutoSilence then
						-- Furnace Engineer: Repair
						for i=1,#enemiesTable do
							local thisUnit = enemiesTable[i].unit
							if UnitCastingInfo(thisUnit) == "Repair" 
							and UnitName(thisUnit) == "Furnace Engineer" then
								ShadowSimpleKick(thisUnit)
								-- local cRem = select(6,UnitCastingInfo(thisUnit)) - GetTime()*1000
								-- if cRem <= 250 then
								-- 	if getSpellCD(Silence)<=0 then
								-- 		if castSpell(thisUnit,Silence,true,false) then return; end
								-- 	end
								-- 	if isKnown(ArcT) then
								-- 		if getSpellCD(ArcT)<=0 and getDistance("player",thisUnit)<=8 then
								-- 			if castSpell(thisUnit,ArcT,true,false) then return end
								-- 		end
								-- 	end
								-- end
							end
						end
						-- Firecaller: Cauterize Wounds
						for i=1,#enemiesTable do
							local thisUnit = enemiesTable[i].unit
							if UnitCastingInfo(thisUnit) == "Cauterize Wounds" 
							and UnitName(thisUnit) == "Firecaller" then
								ShadowSimpleKick(thisUnit)
								-- local cRem = select(6,UnitCastingInfo(thisUnit)) - GetTime()*1000
								-- if cRem <= 1000 then
								-- 	if getSpellCD(Silence)<=0 then
								-- 		if castSpell(thisUnit,Silence,true,false) then return; end
								-- 	end
								-- 	if isKnown(ArcT) then
								-- 		if getSpellCD(ArcT)<=0 and getDistance("player",thisUnit)<=8 then
								-- 			if castSpell(thisUnit,ArcT,true,false) then return end
								-- 		end
								-- 	end
								-- end
							end
						end
					end
				end

			--[[ Kromog ]]
				if currentBoss=="Kromog" then
					-- cascade farest possible hand
					if getSpellCD(cascade)<=0 then
						-- sort enemiesTable by distance
						sortByDistance()
						-- cascade farest dog
						for i=1,#enemiesTable do
							local thisUnit = enemiesTable[i].unit
							if getDistance("player",thisUnit)<40 then
								if UnitName(thisUnit) == "Grasping Earth" then
									if castSpell(thisUnit,spell.cascade,true,false) then return end
								end
							end
						end
					end
				end

			--[[ The Iron Maidens ]]
				if currentBoss=="Marak the Blooded" or currentBoss=="Enforcer Sorka" or currentBoss=="Admiral Gar'an" then
					-- Auto Target
					if options.isChecked.AutoTarget then
						-- Dominator Turret
						if UnitName("target")~="Dominator Turret" then
							if LFU("Dominator Turret") then return end
						end
					end
					-- cascade
					if getTalent(6,1) then
						-- cascade farest enemy in LoS
						for i=1,#enemiesTable do
							local thisUnit = enemiesTable[i].unit
							if getLineOfSight(thisUnit) then
								if getDistance("player",thisUnit)<40 and getDistance("player",thisUnit)>25 then
									if castSpell(thisUnit,spell.cascade,true,false) then return end
								end
							end
						end
					end
					-- Auto Guise
					if options.isChecked.AutoGuise then
						if getDebuffRemain("player",PenetratingShot)<=4 then
							if castSpell("player",spell.spectral_guise,true,false) then return end
						end
					end
				end

			--[[ Blackhand ]]
				if currentBoss=="Blackhand" then
					-- Auto Mass Dispel
					if options.isChecked.AutoMassDispel then
						-- Burning Cinders (162498)
						for i=1,#nNova do
							local thisUnit = nNova[i].unit
							if getDebuffRemain(thisUnit,162498)>0 then
								if castGround(thisUnit,MD,30) then
									SpellStopTargeting()
									return
								end
							end
						end
					end
				end
		end
	end
end