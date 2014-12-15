if select(3,UnitClass("player")) == 2 then

	-- Adds Lay On Hands Selectors in options
	function generalPaladinOptions()
		-- Lay on Hands
		CreateNewCheck(thisConfig,"Lay On Hands")
		CreateNewBox(thisConfig,"Lay On Hands",0,100,1,12,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLay On Hands")
		CreateNewText(thisConfig,"Lay On Hands")

		-- Lay on Hands Targets 1- me only 2- me prio 3- tank and heal 4- all
		CreateNewCheck(thisConfig,"LoH Targets")
		CreateNewDrop(thisConfig,"LoH Targets",1,"|cffFF0000Wich Targets\n|cffFFBB00We want to use \n|cffFFFFFFLay On Hands","|cffFF0000Me.Only","|cffFFDD11Me.Prio","|cff00FBEETank/Heal","|cff00FF00All")
		CreateNewText(thisConfig,"LoH Targets")
	end


end