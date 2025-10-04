---
-- These functions helpful functions for commonly used features in all profiles.
-- Module functions are stored in br.player.module and can be utilized by `local module = br.player.module` in your profile.
-- Additionally module functions also have custom options you can add to your Profile Options by calling the function in the Profile Options and passing the section param.
-- @module br.player.module
local _, br = ...
if br.api == nil then br.api = {} end
br.api.module = function(self)
    -- Local reference to actionList
    local buff      = self.buff
    local cast      = self.cast
    local module    = self.module
    local has       = self.has
    local item      = self.items
    local ui        = self.ui
    local unit      = self.unit
    local use       = self.use
    local var       = {}
    var.getItemInfo = br._G["GetItemInfo"]
    var.getHealPot  = br.getHealthPot

    --- Get perform the correct check for the provided option and option type checking for "Rotation Option" option before defaulting to "Base Options"
    -- @function getOption
    -- @string option Name of the option to check.
    -- @string["Check"|"Value"] optionType Type of option check to perform
    local function getOption(option, optionType)
        if br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["Rotation Options"] == nil then
            if optionType == "Check" then return ui.checked(option, "Base Options") end
            if optionType == "Value" then return ui.value(option, "Base Options") end
        else
            if optionType == "Check" then return ui.checked(option, "Rotation Options") end
            if optionType == "Value" then return ui.value(option, "Rotation Options") end
        end
        -- if optionType == "Check" then
        --     return br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["Rotation Options"][option] ~= nil and
        --         ui.checked(option, "Rotation Options") or
        --         ui.checked(option, "Base Options")
        -- end
        -- if optionType == "Value" then
        --     return br.data.settings[br.loader.selectedSpec][br.loader.selectedProfile]["Rotation Options"][option] ~= nil and
        --         ui.value(option, "Rotation Options") or
        --         ui.value(option, "Base Options")
        -- end
        -- if optionType == "Check" then return false end
        -- if optionType == "Value" then return 0 end
    end

    --- Auto Put Keystone into Receptable during mythic+ dungeons. | Kinky BR Module Code example
    -- @function module.autoKeystone
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    module.autoKeystone = function(section)
        if section ~= nil then
            -- Auto Keystone
            br.ui:createCheckbox(section, "Auto Mythic+ Keystone",
                "|cffFFFFFFCheck to Auto click keystones if you're at a Font of Power")
            -- br.ui:createSpinner(section, "Minimum Keystone to Auto Use", 2, 2, 30, 1, "|cffFFFFFFMinimum keystone number of the key before submitting it. ")
        end
        if section == nil then
            if getOption("Auto Mythic+ Keystone", "Check") then
                var.autoKeystone = br._G.CreateFrame("Frame")
                var.autoKeystone:RegisterEvent("ADDON_LOADED")
                var.autoKeystone:SetScript("OnEvent", function(self, event, addon)
                    if (addon == "Blizzard_ChallengesUI") then
                        if br._G["ChallengesKeystoneFrame"] then
                            br._G["ChallengesKeystoneFrame"]:HookScript("OnShow", function()
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
        local function BestHealingPotion()
            local Consumables = {}
            for i = 0, 4 do
                local numBagSlots = C_Container.GetContainerNumSlots(i)
                if numBagSlots > 0 then
                    for x = 1, numBagSlots do
                        local itemInfo = C_Container.GetContainerItemInfo(i, x)
                        if itemInfo ~= nil then
                            local spellName, spellID = C_Item.GetItemSpell(itemInfo.itemID)
                            local itemCount = C_Item.GetItemCount(itemInfo.itemID)

                            if spellName ~= nil then
                                local itemName, _, _, itemLevel, itemMinLevel, itemType, itemSubType, _, _, _, _, _, _, _, _, _, _ =
                                    C_Item.GetItemInfo(itemInfo.itemID)
                                if itemType == "Consumable" and itemSubType == "Potions" then
                                    if string.find(itemName, "Heal", 0, true) then
                                        table.insert(Consumables, #Consumables + 1, {
                                            itemID = itemInfo.itemID,
                                            spellId = spellID,
                                            itemName = itemInfo.itemName,
                                            itemLevel = itemLevel,
                                            itemMinLevel = itemMinLevel,
                                            itemCount = itemCount
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
            table.sort(Consumables, function(v1, v2) return v1.itemLevel > v2.itemLevel end)
            for i = 1, #Consumables do
                if br.functions.item:canUseItem(Consumables[i].itemID) then return Consumables[i].itemID end
            end
            return nil
        end

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
            -- -- Music of Bastion
            -- br.ui:createCheckbox(section, "Music of Bastion", "|cffFFFFFFCheck to use.")
            -- -- Phial of Serenity
            -- br.ui:createSpinner(section, "Phial of Serenity", 30, 0, 80, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- br.ui:createCheckbox(section, "Auto Summon Steward")
        end

        -- Abilities - Call, module.BasicHealing(), in your rotation to use these
        if section == nil then
            -- Health Potion / Stones
            if getOption("Healthstone/Potion", "Check") and unit.inCombat() and unit.hp() <= getOption("Healthstone/Potion", "Value") then
                --Health Pot should be first since it's the greatest heal; healthstones second
                local healPot = BestHealingPotion()
                if healPot ~= nil and has.item(healPot) and br.functions.item:canUseItem(healPot) then
                    if use.item(healPot) then
                        ui.debug("using Healing Potion")
                        return true
                    end
                end
                -- Lock Candy
                if use.able.healthstone() and has.healthstone() then
                    if use.healthstone() then
                        ui.debug("Using Healthstone")
                        return true
                    end
                end
                --Legion Healthstone
                -- if use.able.legionHealthstone() and has.legionHealthstone() then
                --     if use.legionHealthstone() then
                --         ui.debug("Using Legion Healthstone")
                --         return true
                --     end
                -- end
            end
            -- Heirloom Neck
            if getOption("Heirloom Neck", "Check") and unit.hp() <= getOption("Heirloom Neck", "Value") and not unit.inCombat() then
                if use.able.heirloomNeck() and item.heirloomNeck ~= 0 and item.heirloomNeck ~= item.manariTrainingAmulet then
                    if use.heirloomNeck() then
                        ui.debug("Using Heirloom Neck")
                        return true
                    end
                end
            end
            -- Gift of the Naaru
            if getOption("Gift of the Naaru", "Check") and unit.race() == "Draenei"
                and unit.inCombat() and unit.hp() <= getOption("Gift of the Naaru", "Value")
            then
                if cast.racial() then
                    ui.debug("Casting Gift of the Naaru")
                    return true
                end
            end
            -- -- Music of Bastion
            -- if getOption("Music of Bastion", "Check") and (br.functions.misc:isInArdenweald() or br.functions.misc:isInBastion() or br.functions.misc:isInMaldraxxus() or br.functions.misc:isInRevendreth()) then
            --     if use.able.ascendedFlute() and has.ascendedFlute() then
            --         if use.ascendedFlute() then
            --             ui.debug("Using Ascended Flute")
            --             return true
            --         end
            --     end
            --     if use.able.benevolentGong() and has.benevolentGong() then
            --         if use.benevolentGong() then
            --             ui.debug("Using Benevolent Gong")
            --             return true
            --         end
            --     end
            --     if use.able.heavenlyDrum() and has.heavenlyDrum() then
            --         if use.heavenlyDrum() then
            --             ui.debug("Using Heavenly Drum")
            --             return true
            --         end
            --     end
            --     if use.able.kyrianBell() and has.kyrianBell() then
            --         if use.kyrianBell() then
            --             ui.debug("Using Kyrian Bell")
            --             return true
            --         end
            --     end
            --     if use.able.unearthlyChime() and has.unearthlyChime() then
            --         if use.unearthlyChime() then
            --             ui.debug("Using Unearthly Chime")
            --             return true
            --         end
            --     end
            -- end
            -- -- Phial of Serenity
            -- if getOption("Phial of Serenity", "Check") then
            --     if getOption("Auto Summon Steward", "Check") and not unit.inCombat() and not has.phialOfSerenity() and cast.able.summonSteward() then
            --         if cast.summonSteward() then
            --             ui.debug("Casting Call Steward")
            --             return true
            --         end
            --     end
            --     if unit.inCombat() and use.able.phialOfSerenity() and unit.hp() < getOption("Phial of Serenity", "Value") then
            --         if use.phialOfSerenity() then
            --             ui.debug("Using Phial of Serenity")
            --             return true
            --         end
            --     end
            -- end
        end
    end

    --- Basic Trinkets - Uses trinkets based on options set in the Profile Options.
    -- @function module.BasicTrinkets
    -- @number[opt] slotID If set will use the trinket in the specified slot. Otherwise, will loop through all trinkets.
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    module.BasicTrinkets = function(slotID, section)
        local alwaysCdAoENever = { "Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never" }
        if section ~= nil then
            br.ui:createDropdownWithout(section, "Trinket 1", alwaysCdAoENever, 2,
                "|cffFFFFFFWhen to use Trinket 1 (Slot 13).")
            br.ui:createDropdownWithout(section, "Trinket 2", alwaysCdAoENever, 2,
                "|cffFFFFFFWhen to use Trinket 1 (Slot 14).")
        end
        if section == nil then
            if slotID ~= nil then
                -- For use in rotation loop - pass slotID
                if slotID == 13 or slotID == 14 then
                    if use.able.slot(slotID) and ui.alwaysCdAoENever("Trinket " .. slotID - 12, 3, #br.engines.enemiesEngineFunctions:getEnemies("player", 8)) then
                        if use.slot(slotID) then
                            ui.debug("Using Trinket " .. slotID - 12)
                            return true
                        end
                    end
                end
            else
                -- If not used in rotation loop - loop here
                for slotID = 13, 14 do
                    -- local useTrinket = (opValue == 1 or (opValue == 2 and (ui.useCDs() or ui.useAOE())) or (opValue == 3 and ui.useCDs()))
                    if use.able.slot(slotID) and ui.alwaysCdAoENever("Trinket " .. slotID - 12, 3, #br.engines.enemiesEngineFunctions:getEnemies("player", 8)) then
                        if use.slot(slotID) then
                            ui.debug("Using Trinket " .. slotID - 12)
                            return true
                        end
                    end
                end
            end
        end
    end

    --- CombatPotionUp Module - Attempts to use the combat potion specified in the Profile Options.
    -- @function module.CombatPotionUp
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    module.CombatPotionUp = function(section)
        local potList = { "Pot Ultimate Power", "Pot of Power" }
        if section ~= nil then
            br.ui:createDropdown(section, "Use Combat Potion", potList, 1,
                "|cffFFFFFFSelect Combat Potion, uses best quality.")
        end
        if section == nil then
            if not getOption("Use Combat Potion", "Check") then return false end
            local opValue = getOption("Use Combat Potion", "Value")
            if opValue == 1 and use.isOneOfUsable(br.lists.items.elementalPotionOfUltimatePowerQualities) then
                if use.bestItem(br.lists.items.elementalPotionOfUltimatePowerQualities) then
                    ui.debug("Using Best Pot: Elemental Potion of Ultimate Power")
                    return true;
                end
            end
            if opValue == 2 and use.isOneOfUsable(br.lists.items.elementalPotionOfPowerQualities) then
                if use.bestItem(br.lists.items.elementalPotionOfPowerQualities) then
                    ui.debug("Using Best Pot: Elemental Potion of Power")
                    return true;
                end
            end
        end
    end

    --- PhialUp Module - Attmpts to use the phial specified in the Profile Options
    -- @function module.PhailUp
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    module.PhialUp = function(section)
        local phialList = { "Iced Phial of Corrupting Rage", "Phial of Glacial Fury", "Phial of Tepid Versatility" }
        if section ~= nil then
            br.ui:createDropdown(section, "Use DF Phial", phialList, 1,
                "|cffFFFFFFSet DF Phial To Use, Selects Best Quality.")
        end
        local function cancelBuffs()
            if buff.icedPhialOfCorruptingRage.exists() then buff.icedPhialOfCorruptingRage.cancel() end;
            if buff.phialOfGlacialFury.exists() then buff.phialOfGlacialFury.cancel() end;
            if buff.phialOfTepidVersatility.exists() then buff.phialOfTepidVersatility.cancel() end;
        end
        if section == nil then
            -- local opValue = getOption("Use DF Phial", "Value")
            -- if opValue == 1 and not buff.icedPhialOfCorruptingRage.exists() and use.isOneOfUsable(br.lists.items.icedPhialOfCorruptingRageQualities) then
            --     cancelBuffs()
            --     if use.bestItem(br.lists.items.icedPhialOfCorruptingRageQualities) then
            --         ui.debug("Using Best Phial: Iced Phial of Corrupting Rage")
            --         return true;
            --     end
            -- end
            -- if opValue == 2 and not buff.phialOfGlacialFury.exists() and use.isOneOfUsable(br.lists.items.phialOfGlacialFuryQualities) then
            --     cancelBuffs()
            --     if use.bestItem(br.lists.items.phialOfGlacialFuryQualities) then
            --         ui.debug("Using Best Phial: Phial of Glacial Fury")
            --         return true;
            --     end
            -- end
            -- if opValue == 3 then
            --     if not buff.phialOfTepidVersatility.exists() then
            --         if use.isOneOfUsable(br.lists.items.phialOfTepidVersatilityQualities) then
            --             cancelBuffs()
            --             if use.bestItem(br.lists.items.phialOfTepidVersatilityQualities) then
            --                 ui.debug("Using Best Phial: Phial of Tepid Versatility")
            --                 return true;
            --             end;
            --         end
            --     end
            -- end
        end
    end

    --- Racial Module - Attempts to use the racial ability based on the options set in the Profile Options.
    --- @function module.Racial
    --- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    --- @unit[opt] thisUnit If set will use the racial on the specified unit. Otherwise, will use on player or appropriate target.
    module.Racial = function(section,thisUnit)
        local race = unit.race()
        local alwaysCdAoENever = { "Always", "|cff008000AOE", "|cffffff00AOE/CD", "|cff0000ffCD", "|cffff0000Never" }
        -- local racialNames = {
        --     Draenei     = "Gift of the Naaru", -- Heal
        --     Human       = "Will To Survive", -- Loss of Control Break
        --     Dwarf       = "Stoneform", -- Decurse (Poison, Disease, Bleed) / Damage Reduction
        --     NightElf    = "Shadowmeld", -- Stealth
        --     Gnome       = "Escape Artist", -- Snare Removal
        --     Orc         = "Blood Fury", -- Damage Increase
        --     Troll       = "Berserking", -- Attack Speed Increase
        --     BloodElf    = "Arcane Torrent", -- Silence
        --     Tauren      = "War Stomp", -- AoE Stun
        --     Undead      = "Will of the Forsaken", -- Fear Break
        --     Goblin      = "Rocket Barrage", -- AoE Damage
        --     Pandaren    = "Quaking", -- AoE Stun
        --     Worgen      = "Darkflight" -- Movement Speed Increase
        -- }

        -- Blood Elf Racial (Silence + Resource)
        if race == "BloodElf" then
            if section ~= nil then
                br.ui:createCheckbox(section, "Use Racial", "|cffFFFFFFAuto-use Arcane Torrent for interrupt/resource")
                br.ui:createSpinner(section, "Use Racial Resource", 80, 0, 100, 5, "|cffFFFFFFResource Percent to Cast At")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                local needsResource = unit.power("player") <= getOption("Use Racial Resource", "Value")
                local canInterrupt = unit.casting() or unit.channeling()

                if (needsResource or canInterrupt) and cast.able.racial() then
                    if cast.racial() then
                        ui.debug("Casting Racial - Arcane Torrent")
                        return true
                    end
                end
                return false
            end
        end

        -- Draenei Racial (Healing)
        if race == "Draenei" then
            if section ~= nil then
                br.ui:createSpinner(section, "Use Racial", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                if unit.hp() > getOption("Use Racial", "Value") then return false end
                if cast.able.racial() then
                    if cast.racial() then
                        ui.debug("Casting Racial - Gift of the Naaru")
                        return true
                    end
                end
                return false
            end
        end

        -- Dwarf Racial (Decurse + Damage Reduction)
        if race == "Dwarf" then
            if section ~= nil then
                br.ui:createSpinner(section, "Use Racial for Defense", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
                br.ui:createCheckbox(section, "Use Racial for Decurse", "|cffFFFFFFAuto-use Stoneform to remove poison/disease/bleed")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                local useForHealth = unit.hp() <= getOption("Use Racial", "Value")
                --local useForDebuffs = getOption("Use Racial for Decurse", "Check")
                --    and (unit.hasDebuffType("poison") or unit.hasDebuffType("disease") or unit.hasDebuffType("bleed"))

                if useForHealth--[[ (useForHealth or useForDebuffs)]] and cast.able.racial() then
                    if cast.racial() then
                        ui.debug("Casting Racial - Stoneform")
                        return true
                    end
                end
                return false
            end
        end

        -- Gnome Racial (Snare Removal)
        if race == "Gnome" then
            if section ~= nil then
                br.ui:createCheckbox(section, "Use Racial", "|cffFFFFFFAuto-use Escape Artist when slowed/rooted")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                if --[[unit.isSlowed("player") and ]]cast.able.racial() then
                    if cast.racial() then
                        ui.debug("Casting Racial - Escape Artist")
                        return true
                    end
                end
                return false
            end
        end

        -- Goblin Racial (AoE Damage)
        if race == "Goblin" then
            if section ~= nil then
                br.ui:createCheckbox(section, "Use Racial", "|cffFFFFFFAuto-use Rocket Barrage during combat")
                br.ui:createSpinner(section, "Use Racial Enemies", 1, 1, 10, 1, "|cffFFFFFFMinimum enemies nearby to use")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                local enemyCount = #br.engines.enemiesEngineFunctions:getEnemies("player", 30) >= getOption("Use Racial Enemies", "Value")

                if unit.inCombat() and enemyCount and cast.able.racial() then
                    if cast.racial() then
                        ui.debug("Casting Racial - Rocket Barrage")
                        return true
                    end
                end
                return false
            end
        end

        -- Human Racial (Loss of Control Break)
        if race == "Human" then
            if section ~= nil then
                br.ui:createCheckbox(section, "Use Racial", "|cffFFFFFFAuto-use Will to Survive when feared/charmed/incapacitated")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                if --[[unit.isCC("player") and ]]cast.able.racial() then
                    if cast.racial() then
                        ui.debug("Casting Racial - Will to Survive")
                        return true
                    end
                end
                return false
            end
        end

        -- Night Elf Racial (Stealth)
        if race == "NightElf" then
            if section ~= nil then
                br.ui:createSpinner(section, "Use Racial", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
                br.ui:createCheckbox(section, "Use Racial in Combat", "|cffFFFFFFAllow Shadowmeld use during combat")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                local lowHealth = unit.hp() <= getOption("Use Racial", "Value")
                local allowInCombat = getOption("Use Racial in Combat", "Check")

                if lowHealth and (not unit.inCombat() or allowInCombat) and cast.able.racial() then
                    if cast.racial() then
                        ui.debug("Casting Racial - Shadowmeld")
                        return true
                    end
                end
                return false
            end
        end

        -- Orc Racial (Damage Increase)
        if race == "Orc" then
            if section ~= nil then
                br.ui:createDropdownWithout(section, "Use Racial", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Racial")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                if unit.inCombat() and cast.able.racial() then
                    if cast.racial() then
                        ui.debug("Casting Racial - Blood Fury")
                        return true
                    end
                end
                return false
            end
        end

        -- Pandaren Racial (AoE Stun)
        if race == "Pandaren" then
            if section ~= nil then
                br.ui:createCheckbox(section, "Use Racial")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                if cast.able.racial(thisUnit) then
                    if cast.racial(thisUnit) then
                        ui.debug("Casting Racial on "..unit.name(thisUnit).." - Quaking Palm [Interrupt]")
                        return true
                    end
                end
                return false
            end
        end

        -- Tauren Racial (AoE Stun)
        if race == "Tauren" then
            if section ~= nil then
                br.ui:createSpinner(section, "Use Racial", 30, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
                br.ui:createSpinner(section, "Use Racial Enemies", 2, 1, 10, 1, "|cffFFFFFFMinimum enemies nearby to use")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                local lowHealth = unit.hp() <= getOption("Use Racial", "Value")
                local enemyCount = #br.engines.enemiesEngineFunctions:getEnemies("player", 8) >= getOption("Use Racial Enemies", "Value")

                if (lowHealth or enemyCount) and cast.able.racial() then
                    if cast.racial() then
                        ui.debug("Casting Racial - War Stomp")
                        return true
                    end
                end
                return false
            end
        end

        -- Troll Racial (Attack Speed Increase)
        if race == "Troll" then
            if section ~= nil then
                br.ui:createDropdownWithout(section, "Use Racial", alwaysCdAoENever, 3, "|cffFFFFFFWhen to use Racial")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                if unit.inCombat() and cast.able.racial() then
                    if cast.racial() then
                        ui.debug("Casting Racial - Berserking")
                        return true
                    end
                end
                return false
            end
        end

        -- Undead Racial (Fear Break)
        if race == "Undead" then
            if section ~= nil then
                br.ui:createCheckbox(section, "Use Racial", "|cffFFFFFFAuto-use Will of the Forsaken when feared/charmed")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                if --[[(unit.hasDebuffType("fear") or unit.hasDebuffType("charm")) and]] cast.able.racial() then
                    if cast.racial() then
                        ui.debug("Casting Racial - Will of the Forsaken")
                        return true
                    end
                end
                return false
            end
        end

        -- Worgen Racial (Movement Speed)
        if race == "Worgen" then
            if section ~= nil then
                br.ui:createCheckbox(section, "Use Racial", "|cffFFFFFFAuto-use Darkflight for movement")
                return
            end
            if section == nil then
                if not getOption("Use Racial", "Check") then return false end
                if unit.moving() --[[and not unit.hasMovementBuff() ]]and cast.able.racial() then
                    if cast.racial() then
                        ui.debug("Casting Racial - Darkflight")
                        return true
                    end
                end
                return false
            end
        end

        return false
    end

    --- ImbueUp Module - Attmpts to use the weapon imbuement specified in the Profile Options
    -- @function module.ImbueUp
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    module.ImbueUp = function(section)
        local runeList = { "Buzzing Rune", "Chirping Rune", "Howling Rune", "Hissing Rune" }
        if section ~= nil then
            br.ui:createDropdown(section, "Weapon Imbuement", runeList, 1,
                "Imbuement Rune to use, selects best grade available")
        else
            if getOption("Weapon Imbuement", "Check") then
                local selValue = getOption("Weapon Imbuement", "Value")
                local auras = {}
                -- if selValue == 1 then auras = br.lists.spells.Shared.Shared.itemEnchantments.buzzingRune end
                -- if selValue == 2 then auras = br.lists.spells.Shared.Shared.itemEnchantments.chirpingRune end
                -- if selValue == 3 then auras = br.lists.spells.Shared.Shared.itemEnchantments.howlingRune end
                -- if selValue == 4 then auras = br.lists.spells.Shared.Shared.itemEnchantments.hissingRune end
                -- if not unit.weaponImbue.exists(auras) then
                --     if selValue == 1 then return use.bestItem(br.lists.items.buzzingRuneQualities) end
                --     if selValue == 2 then return use.bestItem(br.lists.items.chirpingRuneQualities) end
                --     if selValue == 3 then return use.bestItem(br.lists.items.howlingRuneQualities) end
                --     if selValue == 4 then return use.bestItem(br.lists.items.hissingRuneQualities) end
                -- end
            end
        end
    end

    --- FlaskUp Module - Attempts to use the flask specified in the Profile Options.
    -- @function module.FlaskUp
    -- @string buffType The type of flask to use. (e.g. "Agility", "Intellect", "Stamina", "Strength")
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    module.FlaskUp = function(buffType, section)
        local function getFlaskByType(buff)
            local thisFlask = ""
            if buff == "Agility" then thisFlask = "Greater Flask of the Currents" end
            if buff == "Intellect" then thisFlask = "Greater Flask of Endless Fathoms" end
            if buff == "Stamina" then thisFlask = "Greater Flask of the Vast Horizon" end
            if buff == "Strength" then thisFlask = "Greater Flask of the Undertow" end
            return thisFlask
        end
        local flaskList
        local isDH = select(2, br._G.UnitClass("player")) == "DEMONHUNTER"
        if isDH then
            flaskList = { getFlaskByType(buffType), "Inquisitor's Menacing Eye", "Repurposed Fel Focuser",
                "Oralius' Whispering Crystal", "None" }
        else
            flaskList = { getFlaskByType(buffType), "Repurposed Fel Focuser", "Oralius' Whispering Crystal", "None" }
        end

        -- Options - Call, module.BasicHealing(section), in your options to load these
        if section ~= nil then
            br.ui:createDropdownWithout(section, "Flask", flaskList, 1, "|cffFFFFFFSet Elixir to use.")
        end

        local function hasFlaskBuff()
            local flask = getOption("Flask", "Value")
            -- if flask == 2 then -- Greater Flask
            --     return buff.greaterFlaskOfTheCurrents.exists() or buff.greaterFlaskOfEndlessFathoms.exists() or
            --         buff.greaterFlaskOfTheVastHorizon.exists() or buff.greaterFlaskOfTheUndertow.exists()
            -- end
            -- if flask == 3 then
            --     if isDH then -- Greater FLask or Gaze of the Legion
            --         return buff.greaterFlaskOfTheCurrents.exists() or buff.greaterFlaskOfEndlessFathoms.exists() or
            --             buff.greaterFlaskOfTheVastHorizon.exists()
            --             or buff.greaterFlaskOfTheUndertow.exists() or buff.gazeOfTheLegion.exists()
            --     else -- Greater Flask or Fel Focus
            --         return buff.greaterFlaskOfTheCurrents.exists() or buff.greaterFlaskOfEndlessFathoms.exists() or
            --             buff.greaterFlaskOfTheVastHorizon.exists()
            --             or buff.greaterFlaskOfTheUndertow.exists() or buff.felFocus.exists()
            --     end
            -- end
            -- if flask == 4 and isDH then -- DH - Greater Flask or Gaze of the Legion or Fel Focus
            --     return buff.greaterFlaskOfTheCurrents.exists() or buff.greaterFlaskOfEndlessFathoms.exists() or
            --         buff.greaterFlaskOfTheVastHorizon.exists()
            --         or buff.greaterFlaskOfTheUndertow.exists() or buff.gazeOfTheLegion.exists() or buff.felFocus.exists()
            -- end
        end

        local function cancelFlaskBuff()
            -- if buff.greaterFlaskOfTheCurrents.exists() then buff.greaterFlaskOfTheCurrents.cancel() end
            -- if buff.greaterFlaskOfEndlessFathoms.exists() then buff.greaterFlaskOfEndlessFathoms.cancel() end
            -- if buff.greaterFlaskOfTheVastHorizon.exists() then buff.greaterFlaskOfTheVastHorizon.cancel() end
            -- if buff.greaterFlaskOfTheUndertow.exists() then buff.greaterFlaskOfTheUndertow.cancel() end
            -- if (isDH and buff.gazeOfTheLegion.exists()) then buff.gazeOfTheLegion.cancel() end
            -- if buff.felFocus.exists() then buff.felFocus.cancel() end
            -- if buff.whispersOfInsanity.exists() then buff.whispersOfInsanity.cancel() end
        end


        -- Abilities - Call, module.BasicHealing(), in your rotation to use these
        if section == nil then
            -- Flask / Crystal
            -- flask
            local opValue = getOption("Flask", "Value")
            local thisFlask = getFlaskByType(buffType)
            if opValue == 1 and unit.instance("raid") then
                -- if thisFlask == "Greater Flask of the Currents" and use.able.greaterFlaskOfTheCurrents() and not buff.greaterFlaskOfTheCurrents.exists() then
                --     cancelFlaskBuff()
                --     if use.greaterFlaskOfTheCurrents() then
                --         ui.debug("Using Greater Flask of the Currents")
                --         return true
                --     end
                -- end
                -- if thisFlask == "Greater Flask of Endless Fathoms" and use.able.greaterFlaskOfEndlessFathoms() and not buff.greaterFlaskOfEndlessFathoms.exists() then
                --     cancelFlaskBuff()
                --     if use.greaterFlaskOfEndlessFathoms() then
                --         ui.debug("Using Greater Flask of Endless Fathoms")
                --         return true
                --     end
                -- end
                -- if thisFlask == "Greater Flask of the Vast Horizon" and use.able.greaterFlaskOfTheVastHorizon() and not buff.greaterFlaskOfTheVastHorizon.exists() then
                --     cancelFlaskBuff()
                --     if use.greaterFlaskOfTheVastHorizon() then
                --         ui.debug("Using Greater Flask of the Vast Horizon")
                --         return true
                --     end
                -- end
                -- if thisFlask == "Greater Flask of the Undertow" and use.able.greaterFlaskOfTheUndertow() and not buff.greaterFlaskOfTheUndertow.exists() then
                --     cancelFlaskBuff()
                --     if use.greaterFlaskOfTheUndertow() then
                --         ui.debug("Using Greater Flask of the Undertow")
                --         return true
                --     end
                -- end
            end
            if opValue == 2 and (not unit.instance("raid") or (unit.instance("raid") and not hasFlaskBuff())) then
                -- if isDH and use.able.inquisitorsMenacingEye() and not buff.gazeOfTheLegion.exists() then
                --     cancelFlaskBuff()
                --     if use.inquisitorsMenacingEye() then
                --         ui.debug("Using Inquisitor's Menacing Eye")
                --         return true
                --     end
                -- elseif use.able.repurposedFelFocuser() and not buff.felFocus.exists() then
                --     cancelFlaskBuff()
                --     if use.repurposedFelFocuser() then
                --         ui.debug("Using Repurposed Fel Focuser")
                --         return true
                --     end
                -- end
            end
            if opValue == 3 and (not unit.instance("raid") or (unit.instance("raid") and not hasFlaskBuff())) then
                -- if isDH and use.able.repurposedFelFocuser() and not buff.felFocus.exists() then
                --     cancelFlaskBuff()
                --     if use.repurposedFelFocuser() then
                --         ui.debug("Using Repurposed Fel Focuser")
                --         return true
                --     end
                -- elseif use.able.oraliusWhisperingCrystal() and not buff.whispersOfInsanity.exists() then
                --     cancelFlaskBuff()
                --     if use.oraliusWhisperingCrystal() then
                --         ui.debug("Using Oralius's Whispering Crystal")
                --         return true
                --     end
                -- end
            end
            if opValue == 4 then
                -- if isDH and (not unit.instance("raid") or (unit.instance("raid") and not hasFlaskBuff()))
                --     and use.able.oraliusWhisperingCrystal() and not buff.whispersOfInsanity.exists()
                -- then
                --     cancelFlaskBuff()
                --     if use.oraliusWhisperingCrystal() then
                --         ui.debug("Using Oralius's Whispering Crystal")
                --         return true
                --     end
                -- end
            end
        end
    end
end
