if br.api == nil then br.api = {} end
br.api.module = function(self)
    -- Local reference to actionList
    local cast              = self.cast
    local module            = self.module
    local has               = self.has
    local item              = self.items
    local ui                = self.ui
    local unit              = self.unit
    local use               = self.use
    local var               = {}
    var.getItemInfo         = _G["GetItemInfo"]
    var.getHealPot          = _G["getHealthPot"]

    -- Basic Healing Module - When Calling in profile will run through logic as if it was coded directly in your profile, provided you have the options defined.
    module.BasicHealing = function(section)
        -- Options - Call, module.BasicHealing(section), in your options to load these
        if section ~= nil then
            -- Gift of the Naaru
            br.ui:createSpinner(section, "Gift of the Naaru", 35, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Healthstone / Potion
            br.ui:createSpinner(section, "Healthstone/Potion", 60, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        end

        -- Abilities - Call, module.BasicHealing(), in your rotation to use these
        if section == nil then
            -- Health Potion / Stones
            if ui.checked("Healthstone/Potion") and unit.inCombat() and unit.hp() <= ui.value("Healthstone/Potion") then
                -- Lock Candy
                if use.able.healthstone() and has.healthstone() then
                    if use.healthstone() then ui.debug("Using Healthstone") return true end
                end
                --Legion Healthstone
                if use.able.legionHealthstone() and has.legionHealthstone() then
                    if use.legionHealthstone() then ui.debug("Using Legion Healthstone") return true end
                end
                -- Health Potion (Grabs the Highest usable from bags)
                local healPot = var.getHealPot()
                if use.able.item(healPot) and has.item(healPot) then
                    use.item(healPot)
                    ui.debug("Using "..var.getItemInfo(healPot))
                    return true
                end
            end
            -- Heirloom Neck
            if ui.checked("Heirloom Neck") and unit.hp() <= ui.value("Heirloom Neck") and not unit.inCombat() then
                if use.able.heirloomNeck() and item.heirloomNeck ~= 0 and item.heirloomNeck ~= item.manariTrainingAmulet then
                    if use.heirloomNeck() then ui.debug("Using Heirloom Neck") return true end
                end
            end
            -- Gift of the Naaru
            if ui.checked("Gift of the Naaru") and unit.race() == "Draenei"
                and unit.inCombat() and unit.hp() <= ui.value("Gift of the Naaru")
            then
                if cast.giftOfTheNaaru() then ui.debug("Casting Gift of the Naaru") return true end
            end
        end
    end
end