if select(3, UnitClass("player")) == 11 then
	local rotationName = "AveryKey"

	local function createToggles()
		-- Cooldown Button
		CooldownModes = {
		[1] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = bb.player.spell.incarnationTreeOfLife },
		[2] = { mode = "Off", value = 2 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = bb.player.spell.incarnationTreeOfLife }
		};
		CreateButton("Cooldown",1,0)   
	end

	local function createOptions()
		local optionTable
		local function rotationOptions()
			local section			
			section = bb.ui:createSection(bb.ui.window.profile, "Buff/Dispel/Harmony")
				--Mark of the Wild
					bb.ui:createCheckbox(section,"Mark of the Wild","Enable Mark of the Wild")
				--Natures Cure
				--Swiftmend Harmony
					bb.ui:createSpinner(section, "Swiftmend Harmony",  50,  0,  100,  5,  "Health Percent to Cast At")
				--Healing Touch Harmony
					bb.ui:createSpinner(section, "Healing Touch Harmony",  100,  0,  100,  5,  "Health Percent to Cast At")
				--Lifebloom Refresh
					bb.ui:createCheckbox(section,"Lifebloom Refresh","Enable Refreshing of Lifebloom")
				bb.ui:checkSectionState(section)
			section = bb.ui:createSection(bb.ui.window.profile, "Aoe Healing")
				--Wild Growth
					bb.ui:createSpinner(section, "Wild Growth",  85,  0,  100,  5,  "Health Percent to Cast At")
				--Wild Growth Count
					bb.ui:createSpinnerWithout(section, "Wild Growth Count",  3,  0,  10,  1,  "Number of Units to cast Wild Growth")
				--Wild Mushrooms
					bb.ui:createSpinner(section, "Wild Mushrooms",  85,  0,  100,  5,  "Health Percent to Cast At")
				--Wild Mushrooms Target
					bb.ui:createDropdownWithout(section, "Wild Mushrooms Target", {"Tank", "Focus", "# Units"}, 1, "Tank:Always on the tank. \n Focus:Always on the Focus. \n# Units:Will always try to cast on set number of units.")
				--Wild Mushrooms Count
					bb.ui:createSpinnerWithout(section, "Wild Mushrooms Count",  3,  0,  10,  1,  "Number of Units to cast Wild Mushrooms")
				--Rejuvenation All
					bb.ui:createCheckbox(section,"Rejuvenation All","Enable Rejuvenation All")
				--Rejuvenation & Germination All
					bb.ui:createCheckbox(section,"Germination All","Enable Germination All")
				--Rejuvenation Filler
					bb.ui:createCheckbox(section,"Rejuvenation Filler","Enable Rejuvenation Filler")
				--Rejuvenation Filler Count
					bb.ui:createSpinnerWithout(section, "Rejuvenation Filler Count",  3,  0,  10,  1,  "Number of Rejuvenations to keep up")
				bb.ui:checkSectionState(section)
			section = bb.ui:createSection(bb.ui.window.profile, "Focus Healing")
				--Healing Touch Natures Swiftness
					bb.ui:createSpinner(section, "Healing Touch NS Focus",  60,  0,  100,  5,  "Health Percent to Cast At")
				--Swiftmend
					bb.ui:createSpinner(section, "Swiftmend Focus",  50,  0,  100,  5,  "Health Percent to Cast At")
				--Lifebloom
            		bb.ui:createSpinner(section, "Lifebloom Focus",  100,  0,  100,  5,  "Health Percent to Cast At")
				--Rejuvenation
            		bb.ui:createSpinner(section, "Rejuvenation Focus",  100,  0,  100,  5,  "Health Percent to Cast At")
            	--Germination
            		bb.ui:createSpinner(section, "Germination Focus",  100,  0,  100,  5,  "Health Percent to Cast At")
				--Regrowth Clearcasting
					bb.ui:createSpinner(section, "Regrowth CC Focus",  60,  0,  100,  5,  "Health Percent to Cast At")
				--Regrowth
					bb.ui:createSpinner(section, "Regrowth Focus",  45,  0,  100,  5,  "Health Percent to Cast At")
				--Healing Touch
					bb.ui:createSpinner(section, "Healing Touch Focus",  65,  0,  100,  5,  "Health Percent to Cast At")
				bb.ui:checkSectionState(section)
			section = bb.ui:createSection(bb.ui.window.profile, "Tank Healing")
				--Healing Touch Natures Swiftness
					bb.ui:createSpinner(section, "Healing Touch NS Tank",  60,  0,  100,  5,  "Health Percent to Cast At")
				--Swiftmend
					bb.ui:createSpinner(section, "Swiftmend Tank",  50,  0,  100,  5,  "Health Percent to Cast At")
				--Rejuvenation
            		bb.ui:createSpinner(section, "Rejuvenation Tank",  100,  0,  100,  5,  "Health Percent to Cast At")
            	--Germination
            		bb.ui:createSpinner(section, "Germination Tank",  100,  0,  100,  5,  "Health Percent to Cast At")
				--Regrowth Clearcasting
					bb.ui:createSpinner(section, "Regrowth CC Tank",  60,  0,  100,  5,  "Health Percent to Cast At")
				--Regrowth
					bb.ui:createSpinner(section, "Regrowth Tank",  45,  0,  100,  5,  "Health Percent to Cast At")
				--Healing Touch
					bb.ui:createSpinner(section, "Healing Touch Tank",  65,  0,  100,  5,  "Health Percent to Cast At")
				bb.ui:checkSectionState(section)
			section = bb.ui:createSection(bb.ui.window.profile, "Single Target Healing")
				--Healing Touch Natures Swiftness
					bb.ui:createSpinner(section, "Healing Touch NS STH",  60,  0,  100,  5,  "Health Percent to Cast At")
				--Swiftmend
					bb.ui:createSpinner(section, "Swiftmend STH",  50,  0,  100,  5,  "Health Percent to Cast At")
				--Rejuvenation
            		bb.ui:createSpinner(section, "Rejuvenation STH",  85,  0,  100,  5,  "Health Percent to Cast At")
            	--Germination
            		bb.ui:createSpinner(section, "Germination STH",  75,  0,  100,  5,  "Health Percent to Cast At")
				--Regrowth Clearcasting
					bb.ui:createSpinner(section, "Regrowth CC STH",  60,  0,  100,  5,  "Health Percent to Cast At")
				--Regrowth
					bb.ui:createSpinner(section, "Regrowth STH",  45,  0,  100,  5,  "Health Percent to Cast At")
				--Healing Touch
					bb.ui:createSpinner(section, "Healing Touch STH",  65,  0,  100,  5,  "Health Percent to Cast At")
				bb.ui:checkSectionState(section)
			section = bb.ui:createSection(bb.ui.window.profile, "Cooldowns")
				--Incarnation TOL
					bb.ui:createSpinner(section, "Incarnation TOL",  50,  0,  100,  5,  "Health Percent to Cast At")
				--Incarnation TOL Count
					bb.ui:createSpinnerWithout(section, "Incarnation TOL Count",  5,  0,  10,  1,  "Number of Units to cast Incarnation TOL")
				--Natures Vigil 
					bb.ui:createSpinner(section, "Natures Vigil",  75,  0,  100,  5,  "Health Percent to Cast At")
				--Natures Vigil Count
					bb.ui:createSpinnerWithout(section, "Natures Vigil Count",  5,  0,  10,  1,  "Number of Units to cast Natures Vigil")
				--Ironbark
					bb.ui:createSpinner(section, "Ironbark",  80,  0,  100,  5,  "Health Percent to Cast At")
				--Ironbark Target
					bb.ui:createDropdownWithout(section, "Ironbark Target", {"Tank", "Focus"}, 1, "Tank:Always on the tank. \n Focus:Always on the Focus.")
				--Barkskin
					bb.ui:createSpinner(section, "Barkskin",  60,  0,  100,  5,  "Health Percent to Cast At")
				bb.ui:checkSectionState(section)
			section = bb.ui:createSection(bb.ui.window.profile, "Other")
				--Debug
					bb.ui:createCheckbox(section,"Debug","Enable Debug")
				bb.ui:checkSectionState(section)
		end
		optionTable = {{
		[1] = "Rotation Options",
		[2] = rotationOptions,
		}}
		return optionTable
	end

	local function runRotation()
		--toggles
			UpdateToggle("Cooldown",0.25)

		--locals
			local MarkOfTheWildID = 1126
			local NaturesCureID = 88423
			local RejuvenationID = 774
			local GerminationID = 155777
			local SwiftmendID = 18562
			local LifebloomID = 33763
			local RegrowthID = 8936
			local HealingTouchID = 5185
			local NaturesVigilID = 124974
			local BarkskinID = 22812
			local IronbarkID = 102342
			local ClearCastingID = 16870
			local ClearCastingBuff = buffRemain("player", ClearCastingID) > 0 
			local NaturesSwiftnessID = 132158
			local NaturesSwiftnessBuff = UnitBuffID("player",NaturesSwiftnessID) 
			local NaturesSwiftnessCD = getSpellCD(NaturesSwiftnessID)
			local IncarnationTOLID = 33891
			local IncarnationTOLBuffID = 117679
			local IncarnationTOLBuff = buffRemain("player", IncarnationTOLBuffID) > 0 

			--fix hangup when live player/dead enemy is selected
			if UnitExists("target") and (isPlayer("target") and not UnitIsDeadOrGhost("target")) 
				or ((isPlayer("target") == nil or UnitIsEnemy("player","target")) and UnitIsDeadOrGhost("target")) then
				ClearTarget()
			end

		--Buff/Dispel
			--Mark of the Wild
			--Natures Cure
		--Aoe Healing
			--Wild Growth
			--Wild Mushrooms
			--Rejuvenation All
			--Rejuvenation & Germination All
			--Rejuvenation Filler
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Focus Healing----Focus Healing----Focus Healing----Focus Healing----Focus Healing----Focus Healing----Focus Healing----Focus Healing----Focus Healing----Focus Healing----Focus Healing--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			if UnitExists("focus") then
			--Healing Touch Natures Swiftness
				if isChecked("Healing Touch NS Focus") then								
					if unitHP("focus") <= getValue("Healing Touch NS Focus") then						
						if canCast("focus", 40, false, false) then	
							if NaturesSwiftnessBuff == nil and NaturesSwiftnessCD == 0 then CastSpellByName(GetSpellInfo(NaturesSwiftnessID)) end
							if NaturesSwiftnessBuff ~= nil then			
								CastSpellByName(GetSpellInfo(HealingTouchID),"focus")		
							end
						end						
					end
				end
			--Swiftmend
				if isChecked("Swiftmend Focus") then							
					if unitHP("focus") <= getValue("Swiftmend Focus") then						
						if canCast("focus", 40, false, false) then							
							CastSpellByName(GetSpellInfo(SwiftmendID),"focus")		
						end						
					end
				end
			--Lifebloom
				if isChecked("Lifebloom Focus") then					
					if unitHP("focus") <= getValue("Lifebloom Focus") then						
						if canCast("focus", 40, false, false) then									
							if (isChecked("Lifebloom Refresh") == false and UnitBuffID("focus",LifebloomID,"player") == nil) 
							or (isChecked("Lifebloom Refresh") == true and buffRemain("focus", LifebloomID, "player") < 5) then				
								CastSpellByName(GetSpellInfo(LifebloomID),"focus")
							end				
						end	
					end					
				end
			--Rejuvenation
				if isChecked("Rejuvenation Focus") then						
					if unitHP("focus") <= getValue("Rejuvenation Focus") then						
						if canCast("focus", 40, false, false) then
							if buffRemain("focus", RejuvenationID, "player") < 6 then									
								CastSpellByName(GetSpellInfo(RejuvenationID),"focus")
							end				
						end						
					end
				end
			--Germination
				if isChecked("Germination Focus") then							
					if unitHP("focus") <= getValue("Germination Focus") then						
						if canCast("focus", 40, false, false) then
							if buffRemain("focus", RejuvenationID, "player") >= 6 then	
								if buffRemain("focus", GerminationID, "player") < 6 then								
									CastSpellByName(GetSpellInfo(RejuvenationID),"focus")
								end
							end				
						end						
					end
				end
			--Regrowth Clearcasting
				if isChecked("Regrowth CC Focus") then							
					if unitHP("focus") <= getValue("Regrowth CC Focus") then						
						if (canCast("focus", 40, false, false) and IncarnationTOLBuff ~= nil) or canCast("focus", 40, false, true, true) then		
							if ClearCastingBuff ~= nil then					
								CastSpellByName(GetSpellInfo(RegrowthID),"focus")		
							end
						end						
					end
				end
			--Regrowth
				if isChecked("Regrowth Focus") then							
					if unitHP("focus") <= getValue("Regrowth Focus") then						
						if (canCast("focus", 40, false, false) and IncarnationTOLBuff ~= nil) or canCast("focus", 40, false, true, true) then						
							CastSpellByName(GetSpellInfo(RegrowthID),"focus")		
						end						
					end
				end
			--Healing Touch
				if isChecked("Healing Touch Focus") then							
					if unitHP("focus") > getValue("Regrowth CC Focus") and unitHP("focus") > getValue("Regrowth Focus") 
						and unitHP("focus") <= getValue("Healing Touch Focus") then						
						if canCast("focus", 40, false, true, true) then				
							CastSpellByName(GetSpellInfo(HealingTouchID),"focus")		
						end						
					end
				end
			end-- end focus check
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Tank Healing----Tank Healing----Tank Healing----Tank Healing----Tank Healing----Tank Healing----Tank Healing----Tank Healing----Tank Healing----Tank Healing----Tank Healing--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			--Healing Touch Natures Swiftness
				if isChecked("Healing Touch NS Tank") then
					for i = 1, #nNova do		
						if nNova[i].role == "TANK" or UnitGroupRolesAssigned(nNova[i].unit) == "TANK" then						
							if unitHP(nNova[i].unit) <= getValue("Healing Touch NS Tank") then						
								if canCast(nNova[i].unit, 40, false, false) then	
									if NaturesSwiftnessBuff == nil and NaturesSwiftnessCD == 0 then CastSpellByName(GetSpellInfo(NaturesSwiftnessID)) end
									if NaturesSwiftnessBuff ~= nil then			
										CastSpellByName(GetSpellInfo(HealingTouchID),nNova[i].unit)		
									end
								end						
							end
						end
					end
				end
			--Swiftmend
				if isChecked("Swiftmend Tank") then
					for i = 1, #nNova do								
						if nNova[i].role == "TANK" or UnitGroupRolesAssigned(nNova[i].unit) == "TANK" then
							if unitHP(nNova[i].unit) <= getValue("Swiftmend Tank") then						
								if canCast(nNova[i].unit, 40, false, false) then							
									CastSpellByName(GetSpellInfo(SwiftmendID),nNova[i].unit)		
								end						
							end
						end
					end
				end
			--Rejuvenation
				if isChecked("Rejuvenation Tank") then
					for i = 1, #nNova do		
						if nNova[i].role == "TANK" or UnitGroupRolesAssigned(nNova[i].unit) == "TANK" then						
							if unitHP(nNova[i].unit) <= getValue("Rejuvenation Tank") then						
								if canCast(nNova[i].unit, 40, false, false) then
									if buffRemain(nNova[i].unit, RejuvenationID, "player") < 6 then									
										CastSpellByName(GetSpellInfo(RejuvenationID),nNova[i].unit)
									end				
								end		
							end				
						end
					end
				end
			--Germination
				if isChecked("Germination Tank") then
					for i = 1, #nNova do				
						if nNova[i].role == "TANK" or UnitGroupRolesAssigned(nNova[i].unit) == "TANK" then				
							if unitHP(nNova[i].unit) <= getValue("Germination Tank") then						
								if canCast(nNova[i].unit, 40, false, false) then
									if buffRemain(nNova[i].unit, RejuvenationID, "player") >= 6 then	
										if buffRemain(nNova[i].unit, GerminationID, "player") < 6 then							
											CastSpellByName(GetSpellInfo(RejuvenationID),nNova[i].unit)
										end
									end				
								end				
							end		
						end
					end
				end
			--Regrowth Clearcasting
				if isChecked("Regrowth CC Tank") then
					for i = 1, #nNova do			
						if nNova[i].role == "TANK" or UnitGroupRolesAssigned(nNova[i].unit) == "TANK" then					
							if unitHP(nNova[i].unit) <= getValue("Regrowth CC Tank") then						
								if (canCast(nNova[i].unit, 40, false, false) and IncarnationTOLBuff ~= nil) or canCast(nNova[i].unit, 40, false, true, true) then		
									if ClearCastingBuff ~= nil then					
										CastSpellByName(GetSpellInfo(RegrowthID),nNova[i].unit)		
									end
								end		
							end				
						end
					end
				end
			--Regrowth
				if isChecked("Regrowth Tank") then
					for i = 1, #nNova do		
						if nNova[i].role == "TANK" or UnitGroupRolesAssigned(nNova[i].unit) == "TANK" then						
							if unitHP(nNova[i].unit) <= getValue("Regrowth Tank") then						
								if (canCast(nNova[i].unit, 40, false, false) and IncarnationTOLBuff ~= nil) or canCast(nNova[i].unit, 40, false, true, true) then						
									CastSpellByName(GetSpellInfo(RegrowthID),nNova[i].unit)		
								end						
							end
						end
					end
				end
			--Healing Touch
				if isChecked("Healing Touch Tank") then
					for i = 1, #nNova do					
						if nNova[i].role == "TANK" or UnitGroupRolesAssigned(nNova[i].unit) == "TANK" then			
							if (unitHP(nNova[i].unit) > getValue("Regrowth CC Tank") and
								unitHP(nNova[i].unit) > getValue("Regrowth Tank")) and unitHP(nNova[i].unit) <= getValue("Healing Touch Tank") then						
								if canCast(nNova[i].unit, 40, false, true, true) then				
									CastSpellByName(GetSpellInfo(HealingTouchID),nNova[i].unit)		
								end						
							end
						end
					end
				end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing----Single Target Healing--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			--Healing Touch Natures Swiftness
				if isChecked("Healing Touch NS STH") then
					for i = 1, #nNova do								
						if unitHP(nNova[i].unit) <= getValue("Healing Touch NS STH") then						
							if canCast(nNova[i].unit, 40, false, false) then	
								if NaturesSwiftnessBuff == nil and NaturesSwiftnessCD == 0 then CastSpellByName(GetSpellInfo(NaturesSwiftnessID)) end
								if NaturesSwiftnessBuff ~= nil then			
									CastSpellByName(GetSpellInfo(HealingTouchID),nNova[i].unit)		
								end
							end						
						end
					end
				end
			--Swiftmend
				if isChecked("Swiftmend STH") then
					for i = 1, #nNova do								
						if unitHP(nNova[i].unit) <= getValue("Swiftmend STH") then						
							if canCast(nNova[i].unit, 40, false, false) then							
								CastSpellByName(GetSpellInfo(SwiftmendID),nNova[i].unit)		
							end						
						end
					end
				end
			--Rejuvenation
				if isChecked("Rejuvenation STH") then
					for i = 1, #nNova do								
						if unitHP(nNova[i].unit) <= getValue("Rejuvenation STH") then						
							if canCast(nNova[i].unit, 40, false, false) then
								if buffRemain(nNova[i].unit, RejuvenationID, "player") < 6 then									
									CastSpellByName(GetSpellInfo(RejuvenationID),nNova[i].unit)
								end				
							end						
						end
					end
				end
			--Germination
				if isChecked("Germination STH") then
					for i = 1, #nNova do								
						if unitHP(nNova[i].unit) <= getValue("Germination STH") then						
							if canCast(nNova[i].unit, 40, false, false) then
								if buffRemain(nNova[i].unit, RejuvenationID, "player") >= 6 then	
									if buffRemain(nNova[i].unit, GerminationID, "player") < 6 then								
										CastSpellByName(GetSpellInfo(RejuvenationID),nNova[i].unit)
									end
								end				
							end						
						end
					end
				end
			--Regrowth Clearcasting
				if isChecked("Regrowth CC STH") then
					for i = 1, #nNova do								
						if unitHP(nNova[i].unit) <= getValue("Regrowth CC STH") then						
							if (canCast(nNova[i].unit, 40, false, false) and IncarnationTOLBuff ~= nil) or canCast(nNova[i].unit, 40, false, true, true) then		
								if ClearCastingBuff ~= nil then					
									CastSpellByName(GetSpellInfo(RegrowthID),nNova[i].unit)		
								end
							end						
						end
					end
				end
			--Regrowth
				if isChecked("Regrowth STH") then
					for i = 1, #nNova do								
						if unitHP(nNova[i].unit) <= getValue("Regrowth STH") then						
							if (canCast(nNova[i].unit, 40, false, false) and IncarnationTOLBuff ~= nil) or canCast(nNova[i].unit, 40, false, true, true) then						
								CastSpellByName(GetSpellInfo(RegrowthID),nNova[i].unit)		
							end						
						end
					end
				end
			--Healing Touch
				if isChecked("Healing Touch STH") then
					for i = 1, #nNova do								
						if (unitHP(nNova[i].unit) > getValue("Regrowth CC STH") and
							unitHP(nNova[i].unit) > getValue("Regrowth STH")) and unitHP(nNova[i].unit) <= getValue("Healing Touch STH") then						
							if canCast(nNova[i].unit, 40, false, true, true) then				
								CastSpellByName(GetSpellInfo(HealingTouchID),nNova[i].unit)		
							end						
						end
					end
				end
		--Harmony
			--Swiftmend
			--Healing Touch
		--CDS
			--Incarnation TOL
			--Natures Vigil
			--Ironbark
			--Barkskin

	end -- end run rotation

	tinsert(cResto.rotations, {
		name = rotationName,
		toggles = createToggles,
		options = createOptions,
		run = runRotation,
	})
end -- end class check



