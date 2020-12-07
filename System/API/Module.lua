local br = _G["br"]
if br.api == nil then br.api = {} end
br.api.module = function(self)
    -- Local reference to actionList
    local buff              = self.buff
    local cast              = self.cast
    local cd                = self.cd
    local module            = self.module
    local has               = self.has
    local item              = self.items
    local ui                = self.ui
    local unit              = self.unit
    local use               = self.use
    local var               = {}
    var.getItemInfo         = _G["GetItemInfo"]
    var.getHealPot          = _G["getHealthPot"]

    -- Basic Healing Module
    module.BasicHealing = function(section)
        -- Options - Call, module.BasicHealing(section), in your options to load these
        if section ~= nil then
            -- Gift of the Naaru
            if unit.race() == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru", 35, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            end
            -- Healthstone / Potion
            br.ui:createSpinner(section, "Healthstone/Potion", 60, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck", 80, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- Kyrian Bell
            br.ui:createCheckbox(section, "Kyrian Bell","|cffFFFFFFCheck to use.")
            -- Phial of Serenity
            br.ui:createSpinner(section, "Phial of Serenity", 30, 0, 80, 5, "|cffFFFFFFHealth Percent to Cast At")
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
                if cast.racial() then ui.debug("Casting Gift of the Naaru") return true end
            end
            -- Kyrian Bell
            if ui.checked("Kyrian Bell") and (isInArdenweald() or isInBastion() or isInMaldraxxus() or isInRevendreth())-- or isInTheMaw())
                and use.able.kyrianBell() and has.kyrianBell()
            then
                if use.kyrianBell() then ui.debug("Using Kyrian Bell") return true end
            end
            -- Phial of Serenity
            if ui.checked("Phial of Serenity") then
                if not unit.inCombat() and not has.phialOfSerenity() and cast.able.summonSteward() then
                    if cast.summonSteward() then ui.debug("Casting Call Steward") return true end
                end
                if unit.inCombat() and use.able.phialOfSerenity() and unit.hp() < ui.value("Phial of Serenity") then
                    if use.phialOfSerenity() then ui.debug("Using Phial of Serenity") return true end
                end
            end
            return true
        end
    end

    -- Basic Trinkets
    module.BasicTrinkets = function(slotID,section)
        if section ~= nil then
            br.ui:createDropdownWithout(section, "Trinket 1", {"|cff0000FFAlways","|cff00FF00CD/AOE","|cffFFFF00CD Only","|cffFF0000Never"}, 2, "|cffFFFFFFWhen to use Trinket 1 (Slot 13).")
            br.ui:createDropdownWithout(section, "Trinket 2", {"|cff0000FFAlways","|cff00FF00CD/AOE","|cffFFFF00CD Only","|cffFF0000Never"}, 2, "|cffFFFFFFWhen to use Trinket 1 (Slot 14).")
        end
        if section == nil then
            if slotID ~= nil then
                local opValue = ui.value("Trinket "..slotID - 12)
                local useTrinket = (opValue == 1 or (opValue == 2 and (ui.useCDs() or ui.useAOE())) or (opValue == 3 and ui.useCDs()))
                -- For use in rotation loop - pass slotID
                if slotID == 13 or slotID == 14 then
                    if use.able.slot(slotID) and useTrinket then
                        if use.slot(slotID) then ui.debug("Using Trinket "..slotID - 12) return true end
                    end
                end
            else
                -- If not used in rotation loop - loop here
                for slotID = 13, 14 do
                    local opValue = ui.value("Trinket "..slotID - 12)
                    local useTrinket = (opValue == 1 or (opValue == 2 and (ui.useCDs() or ui.useAOE())) or (opValue == 3 and ui.useCDs()))
                    if use.able.slot(slotID) and useTrinket then
                        if use.slot(slotID) then ui.debug("Using Trinket "..slotID - 12) return true end
                    end
                end
            end
        end
    end

    -- Flask Module
    module.FlaskUp = function(buffType,section)
        local function getFlaskByType(buffType)
            local thisFlask = ""
            if buffType == "Agility" then thisFlask = "Greater Flask of the Currents" end
            if buffType == "Intellect" then thisFlask = "Greater Flask of Endless Fathoms" end
            if buffType == "Stamina" then thisFlask = "Greater Flask of the Vast Horizon" end
            if buffType == "Strength" then thisFlask = "Greater Flask of the Undertow" end
            return thisFlask
        end
        local flaskList = {}
        local isDH = select(2,UnitClass("player")) == "DEMONHUNTER"
        if isDH then
            flaskList = {getFlaskByType(buffType),"Inquisitor's Menacing Eye","Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}
        else
            flaskList = {getFlaskByType(buffType),"Repurposed Fel Focuser","Oralius' Whispering Crystal","None"}
        end

        -- Options - Call, module.BasicHealing(section), in your options to load these
        if section ~= nil then
            br.ui:createDropdownWithout(section,"Flask", flaskList, 1, "|cffFFFFFFSet Elixir to use.")
        end

        local function hasFlaskBuff()
            if ui.value("Flask") == 2 then -- Greater Flask
                return buff.greaterFlaskOfTheCurrents.exists() or buff.greaterFlaskOfEndlessFathoms.exists() or buff.greaterFlaskOfTheVastHorizon.exists() or buff.greaterFlaskOfTheUndertow.exists()
            end
            if ui.value("Flask") == 3 then
                if isDH then -- Greater FLask or Gaze of the Legion
                    return buff.greaterFlaskOfTheCurrents.exists() or buff.greaterFlaskOfEndlessFathoms.exists() or buff.greaterFlaskOfTheVastHorizon.exists() 
                        or buff.greaterFlaskOfTheUndertow.exists() or buff.gazeOfTheLegion.exists()
                else -- Greater Flask or Fel Focus
                    return buff.greaterFlaskOfTheCurrents.exists() or buff.greaterFlaskOfEndlessFathoms.exists() or buff.greaterFlaskOfTheVastHorizon.exists() 
                        or buff.greaterFlaskOfTheUndertow.exists() or buff.felFocus.exists()
                end
            end
            if ui.value("Flask") == 4 and isDH then -- DH - Greater Flask or Gaze of the Legion or Fel Focus
                return buff.greaterFlaskOfTheCurrents.exists() or buff.greaterFlaskOfEndlessFathoms.exists() or buff.greaterFlaskOfTheVastHorizon.exists() 
                        or buff.greaterFlaskOfTheUndertow.exists() or buff.gazeOfTheLegion.exists() or buff.felFocus.exists()
            end
        end

        local function cancelFlaskBuff()
            if buff.greaterFlaskOfTheCurrents.exists() then buff.greaterFlaskOfTheCurrents.cancel() end
            if buff.greaterFlaskOfEndlessFathoms.exists() then buff.greaterFlaskOfEndlessFathoms.cancel() end
            if buff.greaterFlaskOfTheVastHorizon.exists() then buff.greaterFlaskOfTheVastHorizon.cancel() end
            if buff.greaterFlaskOfTheUndertow.exists() then buff.greaterFlaskOfTheUndertow.cancel() end
            if (isDH and buff.gazeOfTheLegion.exists()) then buff.gazeOfTheLegion.cancel() end
            if buff.felFocus.exists() then buff.felFocus.cancel() end
            if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
        end


        -- Abilities - Call, module.BasicHealing(), in your rotation to use these
        if section == nil then
            -- Flask / Crystal
            -- flask
            local opValue = ui.value("Flask")
            local thisFlask = getFlaskByType(buffType)
            if opValue == 1 and unit.instance("raid") then
                if thisFlask == "Greater Flask of the Currents" and use.able.greaterFlaskOfTheCurrents() and not buff.greaterFlaskOfTheCurrents.exists() then
                    cancelFlaskBuff()
                    if use.greaterFlaskOfTheCurrents() then ui.debug("Using Greater Flask of the Currents") return true end
                end
                if thisFlask == "Greater Flask of Endless Fathoms" and use.able.greaterFlaskOfEndlessFathoms() and not buff.greaterFlaskOfEndlessFathoms.exists() then
                    cancelFlaskBuff()
                    if use.greaterFlaskOfEndlessFathoms() then ui.debug("Using Greater Flask of Endless Fathoms") return true end
                end
                if thisFlask == "Greater Flask of the Vast Horizon" and use.able.greaterFlaskOfTheVastHorizon() and not buff.greaterFlaskOfTheVastHorizon.exists() then
                    cancelFlaskBuff()
                    if use.greaterFlaskOfTheVastHorizon() then ui.debug("Using Greater Flask of the Vast Horizon") return true end
                end
                if thisFlask == "Greater Flask of the Undertow" and use.able.greaterFlaskOfTheUndertow() and not buff.greaterFlaskOfTheUndertow.exists() then
                    cancelFlaskBuff()
                    if use.greaterFlaskOfTheUndertow() then ui.debug("Using Greater Flask of the Undertow") return true end
                end
            end
            if opValue == 2 and (not unit.instance("raid") or (unit.instance("raid") and not hasFlaskBuff())) then
                if isDH and use.able.inquisitorsMenacingEye() and not buff.gazeOfTheLegion.exists() then
                    cancelFlaskBuff()
                    if use.inquisitorsMenacingEye() then ui.debug("Using Inquisitor's Menacing Eye") return true end
                elseif use.able.repurposedFelFocuser() and not buff.felFocus.exists() then
                    cancelFlaskBuff()
                    if use.repurposedFelFocuser() then ui.debug("Using Repurposed Fel Focuser") return true end
                end
            end
            if opValue == 3 and (not unit.instance("raid") or (unit.instance("raid") and not hasFlaskBuff())) then
                if isDH and use.able.repurposedFelFocuser() and not buff.felFocus.exists() then
                    cancelFlaskBuff()
                    if use.repurposedFelFocuser() then ui.debug("Using Repurposed Fel Focuser") return true end
                elseif use.able.oraliusWhisperingCrystal() and not buff.whispersOfInsanity.exists() then
                    cancelFlaskBuff()
                    if use.oraliusWhisperingCrystal() then ui.debug("Using Oralius's Whispering Crystal") return true end
                end
            end
            if opValue == 4 then 
                if isDH and (not unit.instance("raid") or (unit.instance("raid") and not hasFlaskBuff()))
                    and use.able.oraliusWhisperingCrystal() and not buff.whispersOfInsanity.exists()
                then
                    cancelFlaskBuff()
                    if use.oraliusWhisperingCrystal() then ui.debug("Using Oralius's Whispering Crystal") return true end
                end
            end
        end
    end
end