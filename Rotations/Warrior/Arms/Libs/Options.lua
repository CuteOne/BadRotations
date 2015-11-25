if select(3, UnitClass("player")) == 1 then
	function WarriorArmsConfig()
		bb.profile_window = createNewProfileWindow("Arms")
		local section



		-- Wrapper
		section = createNewSection(bb.profile_window, "Rotation")
		-- Heroic Leap Key
		createNewDropdown(section,"Heroic Leap",bb.dropOptions.Toggle2,3,"Heroic Leap to mouse location on toggle press")
		-- Ravager Key
		createNewDropdown(section,"Ravager",bb.dropOptions.Toggle2,3,"Ravager to mouse location on toggle press")
		-- max Rend Targets
		--createNewSpinnerWithout(section,"max rend targets",3,0,10,1,"|cffFFFFFFnumber of running rend in raid")
		checkSectionState(section)


		
		-- Wrapper
		section = createNewSection(bb.profile_window, "Cooldowns")
		-- Recklessness
		createNewCheckbox(section,"Recklessness")
		-- Avatar
		createNewCheckbox(section,"Avatar")
		-- Racial
		--createNewCheckbox(section,"Racial (Orc / Troll)")
		-- Stormbolt
		createNewCheckbox(section,"Storm Bolt")
		-- Trinket
		createNewCheckbox(section,"Use Trinket")
		checkSectionState(section)


		
		-- Wrapper
		section = createNewSection(bb.profile_window, "Defensive")
		-- Die by the Sword
		createNewSpinner(section,"Die by the Sword",40,0,100,2,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDie by the Sword")
		-- Rallying Cry
		createNewSpinner(section,"Rallying Cry",40,0,100,2,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRallying Cry")
		-- Enraged Regeneration
		createNewSpinner(section,"Enraged Regeneration",25,0,100,2,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFEnraged Regeneration")
		-- ImpendingVictory/Victory Rush
		createNewSpinner(section,"Impending Victory",40,0,100,2,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFImpending Victory (Victory Rush)")
		-- Vigilance Focus
		createNewSpinner(section,"Vigilance on Focus",25,0,100,2,"% HP of Focustarget to use Vigilance on Focustarget")
		-- Def Stance
		--createNewSpinner(section,"Defensive Stance",25,0,100,5,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDefensive Stance")
		-- Healing Tonic
		createNewSpinner(section,"Healing Tonic",25,0,100,2,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Tonic")
		checkSectionState(section)

		--[[ Rotation Dropdown ]]--
		createNewRotationDropdown(bb.profile_window.parent, {"ragnar"})
		bb:checkProfileWindowStatus()
	end
end