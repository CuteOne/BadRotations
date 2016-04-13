if select(3, UnitClass("player")) == 3 then

    -- Config Panel
    function SurvConfig()
        bb.ui.window.profile = bb.ui:createProfileWindow("Survival")
        local section

        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "<-Cooldowns->")
        -- Trinkets
        bb.ui:createCheckbox(section,"Trinkets","Check if you want to use Trinkets automatically");

        -- Potions
        -- bb.ui:createCheckbox(section,"Potions","Check if you want to use Potions automatically");

        -- Racials
        bb.ui:createCheckbox(section,"Racials","Check if you want to use Bloodfury/Berserking/Arcane Torrent automatically");

        -- Dire Beast
        bb.ui:createCheckbox(section,"Dire Beast","Check if you want to use Dire Beast automatically");

        -- A Murder of Crows
        bb.ui:createCheckbox(section,"A Murder of Crows","Check if you want to use A Murder of Crows automatically");

        -- Stampede
        bb.ui:createCheckbox(section,"Stampede","Check if you want to use Stampede automatically");

        -- Glaive Toss
        bb.ui:createCheckbox(section,"Glaive Toss","Check if you want to use Glaive Toss automatically");

        -- Power Shot
        bb.ui:createCheckbox(section,"Power Shot","Check if you want to use Power Shot automatically");

        -- Barrage
        bb.ui:createCheckbox(section,"Barrage","Check if you want to use Barrage automatically");
        bb.ui:checkSectionState(section)



        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "<-Defensive->")
        -- Healthstone
        bb.ui:createSpinner(section,  "Healthstone/Potion",  20,  0,  100  ,  5,  "|cffFFDD11At what %HP to use |cffFFFFFFHealthstone");

        -- Misdirection
        bb.ui:createDropdown(section, "Misdirection", { "|cffFFDD11Pet", "|cffFFFF00Focus"},  2, "|cffFFDD11Sets target for |cffFFFFFFMisdirection |cffFFDD11on Aggro")

        -- Feign Death
        bb.ui:createSpinner(section,  "Feign Death",  20,  0,  100  ,  5,  "|cffFFDD11At what %HP to use |cffFFFFFFFeign Death");

        -- Deterrence
        bb.ui:createSpinner(section,  "Deterrence",  20,  0,  100  ,  5,  "|cffFFDD11At what %HP to use |cffFFFFFFDeterrence");

        -- Disengage
        bb.ui:createSpinner(section,  "Disengage",  20,  0,  100  ,  5,  "|cffFFDD11Auto use |cffFFFFFFDeterrence |cffFFDD11at set range");
        
        bb.ui:checkSectionState(section)



        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "<-Pet->")
        -- Auto Call Pet Toggle
        bb.ui:createDropdown(section,  "Auto Summon", { "|cffFFDD11Pet 1", "|cffFFDD11Pet 2", "|cffFFDD11Pet 3", "|cffFFDD11Pet 4", "|cffFFDD11Pet 5"},  1,  "|cffFFDD11Set to desired |cffFFFFFFPet to Whistle.");

        -- Mend Pet
        bb.ui:createSpinner(section,  "Mend Pet",  75,  0,  100  ,  5,  "|cffFFDD11Under what Pet %HP to use |cffFFFFFFMend Pet");

        -- Intimidation
        bb.ui:createDropdown(section, "Intimidation", { "|cffFF0000Aggro", "|cff00FF00Interrupt", "|cffFFDD11Both"},  2, "|cffFFDD11Sets how you want |cffFFFFFFIntimidation |cffFFDD11to react.")
        bb.ui:checkSectionState(section)



        -- Wrapper
        section = bb.ui:createSection(bb.ui.window.profile, "<-Other->")
        bb.ui:createCheckbox(section,"Oralius Crystal","Check if you want to use Flask / Crystal");

        bb.ui:createCheckbox(section,"Trap Launcher","Check if you want to use Trap Launcher");

        -- Explosive Trap
        bb.ui:createCheckbox(section,"Explosive Trap","Check if you want to use Explosive Trap in rotation");

        -- Exotic Munitions
        bb.ui:createDropdown(section,  "Exotic Munitions", { "|cffFFDD11Incendiary", "|cffFFDD11Poison", "|cffFFDD11Frozen"},  1,  "|cffFFDD11Set which ammo to use");

        -- Auto-Aspect Toggle
        bb.ui:createCheckbox(section,"Auto-Cheetah");

        -- Standard Interrupt
        bb.ui:createSpinner(section,  "Counter Shot",  35 ,  0,  100  ,  5,  "|cffFFDD11What % of cast remaining to |cffFFFFFFCounter Shot.");

        -- Tranquilizing Shot Toggle
        bb.ui:createDropdown(section, "Tranq Shot-Magic", { "|cffFF0000All", "|cff00FF00Preset"},  2, "|cffFFDD11Sets what you want |cffFFFFFFTranq Shot |cffFFDD11to dispel on TARGET.")

        bb.ui:createCheckbox(section,"Tranq Shot-Enrage");
        bb.ui:checkSectionState(section)



        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"Mavmins"})
        bb:checkProfileWindowStatus()
    end

end
