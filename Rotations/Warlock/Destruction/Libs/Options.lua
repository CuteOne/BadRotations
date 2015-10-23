if select(3,UnitClass("player")) == 9 then
    function DestructionConfig()
        bb.profile_window = createNewProfileWindow("Destruction")

        self.createClassOptions()

        local section

        if self.rotation == 1 then
            section = createNewSection(bb.profile_window, "NYI", "No options here.")
        end

        --[[ Rotation Dropdown ]]--
        createNewRotationDropdown(bb.profile_window.parent, {"NONE"})
        bb:checkProfileWindowStatus()
    end
end
