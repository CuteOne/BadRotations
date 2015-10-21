if select(3, UnitClass("player")) == 3 then

    -- Config Panel
    function MarkConfig()
        bb.profile_window = createNewProfileWindow("Marksmanship")
        local section

        -- Wrapper
        section = createNewSection(bb.profile_window, "Cooldowns")
        -- Trinkets
        createNewCheckbox(section, "Trinkets","Check if you want to use Trinkets automatically")

        -- Potions
        createNewCheckbox(section, "Potions","Check if you want to use Potions automatically")

        -- Racials
        createNewCheckbox(section, "Racials","Check if you want to use Bloodfury/Berserking/Arcane Torrent automatically")

        -- Rapid Fire
        createNewCheckbox(section, "Rapid Fire","Check if you want to use Rapid Fire automatically")

        -- Dire Beast
        createNewCheckbox(section, "Dire Beast","Check if you want to use Dire Beast automatically")

        -- A Murder of Crows
        createNewCheckbox(section, "A Murder of Crows","Check if you want to use A Murder of Crows automatically")

        -- Stampede
        createNewCheckbox(section, "Stampede","Check if you want to use Stampede automatically")

        -- Glaive Toss
        createNewCheckbox(section, "Glaive Toss","Check if you want to use Glaive Toss automatically")

        -- Power Shot
        createNewCheckbox(section, "Power Shot","Check if you want to use Power Shot automatically")

        -- Barrage
        createNewCheckbox(section, "Barrage","Check if you want to use Barrage automatically")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "Defensive")
        -- Healthstone
        createNewSpinner(section, "Healthstone/Potion", 20, 0, 100  , 5, "|cffFFDD11At what %HP to use |cffFFFFFFHealthstone" )

        -- Misdirection
        createNewDropdown(section, "Misdirection", {"|cffFFDD11Pet", "|cffFFFF00Focus"}, 2, "|cffFFDD11Sets target for |cffFFFFFFMisdirection |cffFFDD11on Aggro")

        -- Feign Death
        createNewSpinner(section, "Feign Death", 20, 0, 100  , 5, "|cffFFDD11At what %HP to use |cffFFFFFFFeign Death")

        -- Deterrence
        createNewSpinner(section, "Deterrence", 20, 0, 100  , 5, "|cffFFDD11At what %HP to use |cffFFFFFFDeterrence")

        -- Disengage
        createNewSpinner(section, "Disengage", 20, 0, 100  , 5, "|cffFFDD11Auto use |cffFFFFFFDisengage |cffFFDD11at set range")
        checkSectionState(section)


        -- Wrapper
        section = createNewSection(bb.profile_window, "Pet")
        -- Auto Call Pet Toggle
        createNewDropdown(section, "Auto Summon", {"|cffFFDD11Pet 1","|cffFFDD11Pet 2","|cffFFDD11Pet 3","|cffFFDD11Pet 4","|cffFFDD11Pet 5"}, 1, "|cffFFDD11Set to desired |cffFFFFFFPet to Whistle.")

        -- Mend Pet
        createNewSpinner(section, "Mend Pet", 75, 0, 100, 5, "|cffFFDD11Under what Pet %HP to use |cffFFFFFFMend Pet")

        -- Intimidation
        createNewDropdown(section,"Intimidation",{"|cffFF0000Aggro", "|cff00FF00Interrupt", "|cffFFDD11Both"},2,"|cffFFDD11Sets how you want |cffFFFFFFIntimidation |cffFFDD11to react.")
        checkSectionState(section)



        -- Wrapper
        section = createNewSection(bb.profile_window, "Other")
        -- Kill Shot
        CreateNewCheck(thisConfig,"Stop for Kill Shot","Check if you want to stop casting to use Kill Shot");
        CreateNewText(thisConfig,"Stop for Kill Shot");

        -- Trap Launcher
        CreateNewCheck(thisConfig,"Trap Launcher","Check if you want to use Trap Launcher");
        CreateNewText(thisConfig,"Trap Launcher");

        -- Explosive Trap
        CreateNewCheck(thisConfig,"Explosive Trap","Check if you want to use Explosive Trap in rotation");
        CreateNewText(thisConfig,"Explosive Trap");

        -- Exotic Munitions
        CreateNewCheck(thisConfig,"Exotic Munitions");
        CreateNewDrop(thisConfig, "Exotic Munitions", 1, "|cffFFDD11Set which ammo to use", "|cffFFDD11Incendiary", "|cffFFDD11Poison", "|cffFFDD11Frozen");
        CreateNewText(thisConfig,"Exotic Munitions");

        -- Auto-Aspect Toggle
        CreateNewCheck(thisConfig,"Auto-Cheetah");
        CreateNewText(thisConfig,"Auto-Cheetah");

        -- Standard Interrupt
        CreateNewCheck(thisConfig,"Counter Shot");
        CreateNewBox(thisConfig, "Counter Shot", 0, 100  , 5, 35 , "|cffFFDD11What % of cast remaining to |cffFFFFFFCounter Shot.");
        CreateNewText(thisConfig,"Counter Shot");
        checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window, {"Mavmins"})
        bb:checkProfileWindowStatus()
    end

end
