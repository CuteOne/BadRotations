if select(3,UnitClass("player")) == 6 then

    function FrostOptions()
        if currentConfig ~= "Frost Chumii" then
            ClearConfig();
            thisConfig = 0;
            -- Title
            CreateNewTitle(thisConfig,"Frost |cffFF0000Chumii");

            -- Wrapper
            CreateNewWrap(thisConfig,"-------- General Rotation --------");

            -- Pause Toggle
            CreateNewCheck(thisConfig,"Pause Toggle");
            CreateNewDrop(thisConfig,"Pause Toggle", 4, "Toggle")
            CreateNewText(thisConfig,"Pause Key");

            -- Death and Decay
            CreateNewCheck(thisConfig,"DnD_Key");
            CreateNewDrop(thisConfig,"DnD_Key", 2, "Toggle2")
            CreateNewText(thisConfig,"Death and Decay Key");

            -- Dummy DPS Test
            CreateNewCheck(thisConfig,"DPS Testing");
            CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1");
            CreateNewText(thisConfig,"DPS Testing");

            -- General Configs
            CreateGeneralsConfig();

            WrapsManager();
        end
    end
end