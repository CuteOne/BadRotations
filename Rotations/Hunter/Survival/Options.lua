if select(3, UnitClass("player")) == 3 then

-- Config Panel
function SurvConfig()
    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,"Survival Avery");

	-- Wrapper
	CreateNewWrap(thisConfig,"Pet");

	-- Auto Call Pet Toggle
    CreateNewCheck(thisConfig,"Auto Call Pet");
    CreateNewDrop(thisConfig, "Auto Call Pet", 1, "Set to desired Pet to Whistle.", "Pet 1", "Pet 2", "Pet 3", "Pet 4", "Pet 5");
    CreateNewText(thisConfig,"Auto Call Pet");

    -- Mend Pet
    CreateNewCheck(thisConfig,"Mend Pet");
    CreateNewBox(thisConfig, "Mend Pet", 0, 100  , 5, 75, "Under what Pet %HP to use Mend Pet");
    CreateNewText(thisConfig,"Mend Pet");

	-- Wrapper
	CreateNewWrap(thisConfig,"AoE");

	--automatic aoe
	CreateNewCheck(thisConfig,"AutoAoE","Check if you want to use automatic AoE, tarplus/minus wont do anything until you toggle this off");
	CreateNewText(thisConfig,"Auto AoE");

	-- tar+
	CreateNewCheck(thisConfig,"Rotation Up","Switch through Rotation Modes (1 target/2 targets/3 targets/4+targets)");
	CreateNewDrop(thisConfig,"Rotation Up", 1, "Toggle")
	CreateNewText(thisConfig,"Tar Plus");

	-- tar-
	CreateNewCheck(thisConfig,"Rotation Down","Switch through Rotation Modes (1 target/2 targets/3 targets/4+targets)");
	CreateNewDrop(thisConfig,"Rotation Down", 2, "Toggle")
	CreateNewText(thisConfig,"Tar Minus");

    -- General Configs
    CreateGeneralsConfig();
    WrapsManager();
end

end