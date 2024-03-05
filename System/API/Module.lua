---
-- These functions helpful functions for commonly used features in all profiles.
-- Module functions are stored in br.player.module and can be utilized by `local module = br.player.module` in your profile.
-- Additionally module functions also have custom options you can add to your Profile Options by calling the function in the Profile Options and passing the section param.
-- @module br.player.module
local _, br = ...
if br.api == nil then br.api = {} end
br.api.module = function(self)
    -- Local reference to actionList
    local buff              = self.buff
    local cast              = self.cast
    local module            = self.module
    local has               = self.has
    local item              = self.items
    local ui                = self.ui
    local unit              = self.unit
    local use               = self.use
    local var               = {}
    var.getItemInfo         = br._G["GetItemInfo"]
    var.getHealPot          = br.getHealthPot

    --- Auto Put Keystone into Receptable during mythic+ dungeons. | Kinky BR Module Code example
    -- @function module.autoKeystone
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    module.autoKeystone = function(section)
        if section ~= nil then
            -- Auto Keystone
            br.ui:createCheckbox(section, "Auto Mythic+ Keystone","|cffFFFFFFCheck to Auto click keystones if you're at a Font of Power")
           -- br.ui:createSpinner(section, "Minimum Keystone to Auto Use", 2, 2, 30, 1, "|cffFFFFFFMinimum keystone number of the key before submitting it. ")
        end
        if section == nil then
            if ui.checked("Auto Mythic+ Keystone") then
               var.autoKeystone = br._G.CreateFrame("Frame")
               var.autoKeystone:RegisterEvent("ADDON_LOADED")
               var.autoKeystone:SetScript("OnEvent", function(self, event, addon)
	               if (addon == "Blizzard_ChallengesUI") then
		               if br._G["ChallengesKeystoneFrame"] then br._G["ChallengesKeystoneFrame"]:HookScript("OnShow", function()
				            for Bag = 0, br._G["NUM_BAG_SLOTS"] do
				    	        for Slot = 1, C_Container.GetContainerNumSlots(Bag) do
					    	        local ID = C_Container.GetContainerItemID(Bag, Slot)
						            if (ID and ID == 180653) then return br._G.UseContainerItem(Bag, Slot) end
					           end
				            end
			            end)
			                self:UnregisterEvent(event)
		                end
	                 end
                end)
            end
        end
    end

    --- Basic Healing Module - Uses healthstones, potions, and racial healing abilities.
    -- @function module.BasicHealing
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
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
            -- Music of Bastion
            br.ui:createCheckbox(section, "Music of Bastion","|cffFFFFFFCheck to use.")
            -- Phial of Serenity
            br.ui:createSpinner(section, "Phial of Serenity", 30, 0, 80, 5, "|cffFFFFFFHealth Percent to Cast At")
            br.ui:createCheckbox(section, "Auto Summon Steward")
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
            -- Music of Bastion
            if ui.checked("Music of Bastion") and (br.isInArdenweald() or br.isInBastion() or br.isInMaldraxxus() or br.isInRevendreth()) then
                if use.able.ascendedFlute() and has.ascendedFlute() then
                    if use.ascendedFlute() then ui.debug("Using Ascended Flute") return true end
                end
                if use.able.benevolentGong() and has.benevolentGong() then
                    if use.benevolentGong() then ui.debug("Using Benevolent Gong") return true end
                end
                if use.able.heavenlyDrum() and has.heavenlyDrum() then
                    if use.heavenlyDrum() then ui.debug("Using Heavenly Drum") return true end
                end
                if use.able.kyrianBell() and has.kyrianBell() then
                    if use.kyrianBell() then ui.debug("Using Kyrian Bell") return true end
                end
                if use.able.unearthlyChime() and has.unearthlyChime() then
                    if use.unearthlyChime() then ui.debug("Using Unearthly Chime") return true end
                end
            end
            -- Phial of Serenity
            if ui.checked("Phial of Serenity") then
                if ui.checked("Auto Summon Steward") and not unit.inCombat() and not has.phialOfSerenity() and cast.able.summonSteward() then
                    if cast.summonSteward() then ui.debug("Casting Call Steward") return true end
                end
                if unit.inCombat() and use.able.phialOfSerenity() and unit.hp() < ui.value("Phial of Serenity") then
                    if use.phialOfSerenity() then ui.debug("Using Phial of Serenity") return true end
                end
            end
        end
    end

    --- Basic Trinkets - Uses trinkets based on options set in the Profile Options.
    -- @function module.BasicTrinkets
    -- @number[opt] slotID If set will use the trinket in the specified slot. Otherwise, will loop through all trinkets.
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    module.BasicTrinkets = function(slotID,section)
        local alwaysCdAoENever = {"Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never"}
        if section ~= nil then
            br.ui:createDropdownWithout(section, "Trinket 1", alwaysCdAoENever, 2, "|cffFFFFFFWhen to use Trinket 1 (Slot 13).")
            br.ui:createDropdownWithout(section, "Trinket 2", alwaysCdAoENever, 2, "|cffFFFFFFWhen to use Trinket 1 (Slot 14).")
        end
        if section == nil then
            if slotID ~= nil then
                -- For use in rotation loop - pass slotID
                if slotID == 13 or slotID == 14 then
                    if use.able.slot(slotID) and ui.alwaysCdAoENever("Trinket "..slotID - 12) then
                        if use.slot(slotID) then ui.debug("Using Trinket "..slotID - 12) return true end
                    end
                end
            else
                -- If not used in rotation loop - loop here
                for slotID = 13, 14 do
                    -- local useTrinket = (opValue == 1 or (opValue == 2 and (ui.useCDs() or ui.useAOE())) or (opValue == 3 and ui.useCDs()))
                    if use.able.slot(slotID) and ui.alwaysCdAoENever("Trinket "..slotID - 12) then
                        if use.slot(slotID) then ui.debug("Using Trinket "..slotID - 12) return true end
                    end
                end
            end
        end
    end

    --- Flask Module - Attempts to use the flask specified in the Profile Options.
    -- @function module.Flask
    -- @string buffType The type of flask to use. (e.g. "Agility", "Intellect", "Stamina", "Strength")
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    module.CombatPotionUp = function(section)
        local potList = {"Elem Pot of Ultimate Power","Elem Pot of Power"}
        if section ~= nil then
            br.ui:createDropdownWithout(section,"Combat Potion",potList,1,"|cffFFFFFFSelect Combat Potion, uses best quality.")
        end

        local function cancelBuffs()
            if buff.elementalPotionOfUltimatePower.exists() then buff.elementalPotionOfUltimatePower.cancel() end
            if buff.elementalPotionOfPower.exists() then buff.elementalPotionOfPower.cancel() end
        end

        if section == nil then
            local opValue = ui.value("Use Best Qual Potion")
            if opValue == 1 and not buff.elementalPotionOfUltimatePower.exists() and use.isOneOfUsable(br.lists.items.elementalPotionOfUltimatePowerQualities) then
                    cancelBuffs()
                    if use.bestItem(br.lists.items.elementalPotionOfUltimatePowerQualities) then ui.debug("Using Best Pot: Elemental Potion of Ultimate Power") return true; end
            end
            if opValue == 2 and not buff.elementalPotionOfPower.exists() and use.isOneOfUsable(br.lists.items.elementalPotionOfPowerQualities) then
                    cancelBuffs()
                    if use.bestItem(br.lists.items.elementalPotionOfPowerQualities) then ui.debug("Using Best Pot: Elemental Potion of Power") return true; end
            end
        end
    end
    module.PhialUp = function(section)
        local phialList = {"Iced Phial of Corrupting Rage","Phial of Glacial Fury","Phial of Tepid Versatility"}
        if section ~= nil then
            br.ui:createDropdown(section,"Use DF Phial",phialList,1,"|cffFFFFFFSet DF Phial To Use, Selects Best Quality.")
        end
        local function cancelBuffs()
            if buff.icedPhialOfCorruptingRage.exists() then buff.icedPhialOfCorruptingRage.cancel() end;
            if buff.phialOfGlacialFury.exists() then buff.phialOfGlacialFury.cancel() end;
            if buff.phialOfTepidVersatility.exists() then buff.phialOfTepidVersatility.cancel() end;
        end
        if section == nil then
            local opValue = ui.value("Use DF Phial")
            if opValue == 1 and not buff.icedPhialOfCorruptingRage.exists() and use.isOneOfUsable(br.lists.items.icedPhialOfCorruptingRageQualities) then
                    cancelBuffs()
                    if use.bestItem(br.lists.items.icedPhialOfCorruptingRageQualities) then ui.debug("Using Best Phial: Iced Phial of Corrupting Rage") return true; end

            end
            if opValue == 2 and not buff.phialOfGlacialFury.exists() and use.isOneOfUsable(br.lists.items.phialOfGlacialFuryQualities) then
                    cancelBuffs()
                    if use.bestItem(br.lists.items.phialOfGlacialFuryQualities) then ui.debug("Using Best Phial: Phial of Glacial Fury") return true; end
            end
            if opValue == 3 then 
                if not buff.phialOfTepidVersatility.exists() then 
                    if use.isOneOfUsable(br.lists.items.phialOfTepidVersatilityQualities) then
                        cancelBuffs()
                        if use.bestItem(br.lists.items.phialOfTepidVersatilityQualities) then ui.debug("Using Best Phial: Phial of Tepid Versatility") return true; end;
                    end
                end
            end
        end
    end
    module.ImbueUp = function(section)
        local runeList = {"Buzzing Rune","Chirping Rune","Howling Rune","Hissing Rune"}
        if section ~= nil then
            br.ui:createDropdown(section,"Weapon Imbuement",runeList,1,"Imbuement Rune to use, selects best grade available")
        else
            if ui.checked("Weapon Imbuement") then
                local selValue = ui.value("Weapon Imbuement")
                local auras = {}
                if selValue == 1 then auras = br.lists.spells.Shared.Shared.itemEnchantments.buzzingRune end
                if selValue == 2 then auras = br.lists.spells.Shared.Shared.itemEnchantments.chirpingRune end
                if selValue == 3 then auras = br.lists.spells.Shared.Shared.itemEnchantments.howlingRune end
                if selValue == 4 then auras = br.lists.spells.Shared.Shared.itemEnchantments.hissingRune end
                if not unit.weaponImbue.exists(auras) then
                    if selValue == 1 then return use.bestItem(br.lists.items.buzzingRuneQualities) end
                    if selValue == 2 then return use.bestItem(br.lists.items.chirpingRuneQualities) end
                    if selValue == 3 then return use.bestItem(br.lists.items.howlingRuneQualities) end
                    if selValue == 4 then return use.bestItem(br.lists.items.hissingRuneQualities) end
                end
            end
        end
    end

    module.FlaskUp = function(buffType,section)
        local function getFlaskByType(buff)
            local thisFlask = ""
            if buff == "Agility" then thisFlask = "Greater Flask of the Currents" end
            if buff == "Intellect" then thisFlask = "Greater Flask of Endless Fathoms" end
            if buff == "Stamina" then thisFlask = "Greater Flask of the Vast Horizon" end
            if buff == "Strength" then thisFlask = "Greater Flask of the Undertow" end
            return thisFlask
        end
        local flaskList
        local isDH = select(2,br._G.UnitClass("player")) == "DEMONHUNTER"
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