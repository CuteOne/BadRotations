if select(3, UnitClass("player")) == 4 then
    function SubOptions()
        bb.profile_window = createNewProfileWindow("Subtlety")
        local section

        section = createNewSection(bb.profile_window, "NOTHING", "No options defined")
        checkSectionState(section)

        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"CoRe"})
        bb:checkProfileWindowStatus()
    end
end
