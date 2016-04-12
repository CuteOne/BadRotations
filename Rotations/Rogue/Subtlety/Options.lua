if select(3, UnitClass("player")) == 4 then
    function SubOptions()
        bb.ui.window.profile = bb.ui:createProfileWindow("Subtlety")
        local section

        section = bb.ui:createSection(bb.ui.window.profile, "NOTHING", "No options defined")
        bb.ui:checkSectionState(section)

        --[[ Rotation Dropdown ]]--
        bb.ui:createRotationDropdown(bb.ui.window.profile.parent, {"CoRe"})
        bb:checkProfileWindowStatus()
    end
end
