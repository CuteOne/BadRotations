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
    local enemies   = self.enemies
    local unit      = self.unit
    local use       = self.use
    local var       = {}

    --- Auto Put Keystone into Receptable during mythic+ dungeons. | Kinky BR Module Code example
    -- @function module.autoKeystone
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    module.autoKeystone = function(section)
        if not br.client.isRetail then return end -- Mythic+ keystones are Retail only
        if section ~= nil then
            -- Auto Keystone
            br.ui:checkbox(section, "Auto Mythic+ Keystone", { tip = "Check to Auto click keystones if you're at a Font of Power" })
            -- br.ui:createSpinner(section, "Minimum Keystone to Auto Use", 2, 2, 30, 1, "|cffFFFFFFMinimum keystone number of the key before submitting it. ")
        end
        if section == nil then
            if br.functions.misc:getModuleOption("Auto Mythic+ Keystone", "Check") and var.autoKeystone == nil then
                var.autoKeystone = br.game.CreateFrame("Frame")
                var.autoKeystone:RegisterEvent("ADDON_LOADED")
                var.autoKeystone:SetScript("OnEvent", function(self, event, addon)
                    if (addon == "Blizzard_ChallengesUI") then
                        if br.game["ChallengesKeystoneFrame"] then
                            br.game["ChallengesKeystoneFrame"]:HookScript("OnShow", function()
                                for Bag = 0, br.game["NUM_BAG_SLOTS"] do
                                    for Slot = 1, br.game.C_Container.GetContainerNumSlots(Bag) do
                                        local ID = br.game.C_Container.GetContainerItemID(Bag, Slot)
                                        if (ID and ID == 180653) then return br.game.UseContainerItem(Bag, Slot) end
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
            -- Healthstone / Potion
            br.ui:spinner(section, "Healthstone/Potion", { value = 35, tip = "Health Percent to Cast At" })
            -- Mana Potion (mana users only)
            if br.functions.unit:usesMana() then
                br.ui:spinner(section, "Mana Potion", { value = 20, tip = "Mana Percent to Cast At" })
            end
            -- Heirloom Neck (Retail only)
            if br.client.isRetail then
                br.ui:spinner(section, "Heirloom Neck", { value = 80, tip = "Health Percent to Cast At (out of combat)" })
            end
            -- -- Music of Bastion
            -- br.ui:createCheckbox(section, "Music of Bastion", "|cffFFFFFFCheck to use.")
            -- -- Phial of Serenity
            -- br.ui:createSpinner(section, "Phial of Serenity", 30, 0, 80, 5, "|cffFFFFFFHealth Percent to Cast At")
            -- br.ui:createCheckbox(section, "Auto Summon Steward")
        end

        -- Abilities - Call, module.BasicHealing(), in your rotation to use these
        if section == nil then
            -- Health Potion / Stones
            if ui.checked("Healthstone/Potion") and unit.inCombat() and unit.hp() <= ui.value("Healthstone/Potion") then
                -- Healthstone first: it doesn't share the potion's cooldown, so the potion stays ready for
                -- a second emergency
                if use.able.healthstone() and has.healthstone() then
                    if use.healthstone() then
                        ui.debug("Using Healthstone")
                        return true
                    end
                end
                local healPot = br.functions.item:getBestPotion("Heal")
                if healPot ~= nil and has.item(healPot) and br.functions.item:canUseItem(healPot) then
                    if use.item(healPot) then
                        ui.debug("Using Healing Potion")
                        return true
                    end
                end
            end
            -- Mana Potion
            if ui.checked("Mana Potion") and unit.inCombat() and br.functions.unit:usesMana() then
                local maxMana = br.game.UnitPowerMax("player", 0)
                if maxMana > 0 and br.game.UnitPower("player", 0) / maxMana * 100 <= ui.value("Mana Potion") then
                    local manaPot = br.functions.item:getBestPotion("Mana")
                    if manaPot ~= nil and use.item(manaPot) then
                        ui.debug("Using Mana Potion")
                        return true
                    end
                end
            end
            -- Heirloom Neck
            if br.client.isRetail and ui.checked("Heirloom Neck") and unit.hp() <= ui.value("Heirloom Neck") and not unit.inCombat() then
                if use.able.heirloomNeck() and item.heirloomNeck ~= 0 and item.heirloomNeck ~= item.manariTrainingAmulet then
                    if use.heirloomNeck() then
                        ui.debug("Using Heirloom Neck")
                        return true
                    end
                end
            end
            -- -- Music of Bastion
            -- if br.functions.misc:getModuleOption("Music of Bastion", "Check") and (br.functions.misc:isInArdenweald() or br.functions.misc:isInBastion() or br.functions.misc:isInMaldraxxus() or br.functions.misc:isInRevendreth()) then
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
            -- if br.functions.misc:getModuleOption("Phial of Serenity", "Check") then
            --     if br.functions.misc:getModuleOption("Auto Summon Steward", "Check") and not unit.inCombat() and not has.phialOfSerenity() and cast.able.summonSteward() then
            --         if cast.summonSteward() then
            --             ui.debug("Casting Call Steward")
            --             return true
            --         end
            --     end
            --     if unit.inCombat() and use.able.phialOfSerenity() and unit.hp() < br.functions.misc:getModuleOption("Phial of Serenity", "Value") then
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
            br.ui:dropdown(section, "Trinket 1", { choices = alwaysCdAoENever, value = 2, checkbox = false,
                tip = "When to use Trinket 1 (Slot 13)." })
            br.ui:dropdown(section, "Trinket 2", { choices = alwaysCdAoENever, value = 2, checkbox = false,
                tip = "When to use Trinket 2 (Slot 14)." })
        end
        if section == nil then
            enemies.get(8)
            if slotID ~= nil then
                -- For use in rotation loop - pass slotID
                if slotID == 13 or slotID == 14 then
                    if use.able.slot(slotID) and ui.alwaysCdAoENever("Trinket " .. slotID - 12, 3, #enemies.yards8) then
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
                    if use.able.slot(slotID) and ui.alwaysCdAoENever("Trinket " .. slotID - 12, 3, #enemies.yards8) then
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
        if not br.client.isMOP then return end -- Only Virmen's Bite (Mists of Pandaria) is supported
        local potList = { "Virmen's Bite" }
        if section ~= nil then
            br.ui:dropdown(section, "Use Combat Potion", { choices = potList, value = 1, tip = "Select Combat Potion, uses best quality." })
        end
        if section == nil then
            if not br.functions.misc:getModuleOption("Use Combat Potion", "Check") then return false end
            local opValue = br.functions.misc:getModuleOption("Use Combat Potion", "Value")
            if opValue == 1 and unit.instance("raid") and use.able.virmensBite() and not buff.virmensBite.exists() then
                if use.virmensBite() then
                    ui.debug("Using Virmen's Bite")
                    return true;
                end
            end
            -- if opValue == 2 and use.isOneOfUsable(br.lists.items.elementalPotionOfPowerQualities) then
            --     if use.bestItem(br.lists.items.elementalPotionOfPowerQualities) then
            --         ui.debug("Using Best Pot: Elemental Potion of Power")
            --         return true;
            --     end
            -- end
        end
    end

    --- FlaskUp Module - Attempts to use the flask specified in the Profile Options (Mists of Pandaria).
    -- @function module.FlaskUp
    -- @string buffType The type of flask to use. (e.g. "Agility", "Intellect", "Stamina", "Strength")
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    module.FlaskUp = function(buffType, section)
        if not br.client.isMOP then return end -- Only Flask of Spring Blossoms (Mists of Pandaria) is implemented
        local flaskByStat = {
            Agility = "Flask of Spring Blossoms",
            Intellect = "Greater Flask of Endless Fathoms",
            Stamina = "Greater Flask of the Vast Horizon",
            Strength = "Greater Flask of the Undertow",
        }
        local thisFlask = flaskByStat[buffType] or ""
        if section ~= nil then
            br.ui:dropdown(section, "Flask", { choices = { thisFlask, "None" }, value = 1, checkbox = false, tip = "Set Flask to use in raids." })
            return
        end
        if br.functions.misc:getModuleOption("Flask", "Value") == 1 and unit.instance("raid")
            and thisFlask == "Flask of Spring Blossoms" and use.able.flaskOfSpringBlossoms() and not buff.flaskOfSpringBlossoms.exists()
        then
            if use.flaskOfSpringBlossoms() then
                ui.debug("Using Flask of Spring Blossoms")
                return true
            end
        end
    end

    --- Racial Module - Uses the player's racial abilities based on the options set in the Profile Options.
    -- Uses the race's named racial (e.g. cast.stoneform) when the expansion defines one, otherwise cast.racial.
    -- On Classic-era expansions cast.racial only maps damage racials, so the named key matters there.
    -- Damage racials (Orc, Troll, and Forever's Night Elf / Gnome) use the "Damage Racial" dropdown.
    -- @function module.Racial
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    -- @string[opt] thisUnit Unit to use the racial on (Quaking Palm requires it).
    module.Racial = function(section, thisUnit)
        local race = unit.race()
        if race == "Scourge" then race = "Undead" end -- UnitRace reports Undead as "Scourge"
        local damageName = br.functions.spell:getDamageRacialName(race)

        -- Options
        if section ~= nil then
            if damageName then
                br.ui:dropdown(section, "Damage Racial", { choices = "AlwaysCdAoeNever", value = "CD", checkbox = false,
                    tip = "|cffFFFFFFWhen to use " .. damageName })
            end
            if race == "BloodElf" then
                br.ui:checkbox(section, "Use Racial", { tip = "Auto-use Arcane Torrent to interrupt nearby casts or restore resource" })
                br.ui:spinner(section, "Use Racial Resource", { value = 80, checkbox = false, tip = "Resource Percent to Cast At" })
            elseif race == "Draenei" then
                br.ui:spinner(section, "Use Racial", { value = 50, tip = "Health Percent to cast Gift of the Naaru at" })
            elseif race == "Dwarf" then
                br.ui:spinner(section, "Use Racial", { value = 30, tip = "Health Percent to cast Stoneform at" })
            elseif race == "Gnome" then
                br.ui:checkbox(section, "Use Racial", { tip = "Auto-use Escape Artist when rooted" })
            elseif race == "Goblin" then
                br.ui:checkbox(section, "Use Racial", { tip = "Auto-use Rocket Barrage during combat" })
                br.ui:spinner(section, "Use Racial Enemies", { value = 1, min = 1, max = 10, step = 1, checkbox = false,
                    tip = "Minimum enemies nearby to use" })
            elseif race == "Human" then
                br.ui:checkbox(section, "Use Racial", { tip = "Auto-use Will to Survive when stunned/feared/charmed" })
            elseif race == "NightElf" then
                br.ui:spinner(section, "Use Racial", { value = 30, tip = "Health Percent to cast Shadowmeld at" })
                br.ui:checkbox(section, "Use Racial in Combat", { tip = "Allow Shadowmeld use during combat" })
            elseif race == "Pandaren" then
                br.ui:checkbox(section, "Use Racial", { tip = "Use Quaking Palm when the profile requests it" })
            elseif race == "Tauren" then
                br.ui:spinner(section, "Use Racial", { value = 30, tip = "Health Percent to cast War Stomp at" })
                br.ui:spinner(section, "Use Racial Enemies", { value = 2, min = 1, max = 10, step = 1, checkbox = false,
                    tip = "Or when at least this many enemies are within 8 yards" })
            elseif race == "Undead" then
                br.ui:checkbox(section, "Use Racial", { tip = "Auto-use Will of the Forsaken when feared/charmed" })
            elseif race == "Worgen" then
                br.ui:checkbox(section, "Use Racial", { tip = "Auto-use Darkflight while moving out of combat" })
            end
            return
        end

        -- Damage racial
        if damageName and unit.inCombat() then
            local _, enemyCount = enemies.get(8)
            if ui.alwaysCdAoENever("Damage Racial", 3, enemyCount) and cast.able.racial() then
                if cast.racial() then
                    ui.debug("Casting Racial - " .. damageName)
                    return true
                end
            end
        end

        -- Utility racial: each race decides whether to use it, then one shared cast below
        local key = br.functions.spell:getRacialKey(race)
        if key == nil or not br.functions.misc:getModuleOption("Use Racial", "Check") then return false end
        local optionValue = br.functions.misc:getModuleOption("Use Racial", "Value")
        local shouldUse = false
        local label = key
        if race == "BloodElf" then
            label = "Arcane Torrent"
            if unit.inCombat() then
                local maxPower = br.game.UnitPowerMax("player")
                shouldUse = maxPower > 0
                    and (br.game.UnitPower("player") / maxPower * 100) <= br.functions.misc:getModuleOption("Use Racial Resource", "Value")
                local nearby = enemies.get(8)
                for i = 1, #nearby do
                    if unit.interruptable(nearby[i]) then shouldUse = true break end
                end
            end
        elseif race == "Draenei" then
            label = "Gift of the Naaru"
            shouldUse = unit.hp() <= optionValue
            thisUnit = thisUnit or "player"
        elseif race == "Dwarf" then
            label = "Stoneform"
            shouldUse = unit.inCombat() and unit.hp() <= optionValue
        elseif race == "Gnome" then
            label = "Escape Artist"
            shouldUse = br.functions.unit:hasLossOfControl("rooted")
        elseif race == "Goblin" then
            label = "Rocket Barrage"
            shouldUse = unit.inCombat()
                and #br.engines.enemiesEngineFunctions:getEnemies("player", 30) >= br.functions.misc:getModuleOption("Use Racial Enemies", "Value")
        elseif race == "Human" then
            label = "Will to Survive"
            shouldUse = br.functions.unit:hasLossOfControl("anyCC")
        elseif race == "NightElf" then
            label = "Shadowmeld"
            shouldUse = unit.hp() <= optionValue
                and (not unit.inCombat() or br.functions.misc:getModuleOption("Use Racial in Combat", "Check"))
        elseif race == "Pandaren" then
            label = "Quaking Palm"
            shouldUse = thisUnit ~= nil
        elseif race == "Tauren" then
            label = "War Stomp"
            shouldUse = unit.inCombat() and (unit.hp() <= optionValue
                or #br.engines.enemiesEngineFunctions:getEnemies("player", 8) >= br.functions.misc:getModuleOption("Use Racial Enemies", "Value"))
        elseif race == "Undead" then
            label = "Will of the Forsaken"
            shouldUse = br.functions.unit:hasLossOfControl("fearCharm")
        elseif race == "Worgen" then
            label = "Darkflight"
            shouldUse = unit.moving() and not unit.inCombat()
        end
        if not shouldUse then return false end
        -- Named racial when this expansion defines it, otherwise the generic racial
        local able = cast.able[key] or cast.able.racial
        local castRacial = cast[key] or cast.racial
        if able(thisUnit) and castRacial(thisUnit) then
            ui.debug("Casting Racial - " .. label)
            return true
        end
        return false
    end

    --- Two Forms Module - Return Worgen to Human Form out of combat
    -- @function module.TwoForms
    -- @bool[opt] section If set will generate the options for this module in the Profile Options. Otherwise, will run the module.
    module.TwoForms = function(section)
        if unit.race() ~= "Worgen" then return false end
        if section ~= nil then
            br.ui:checkbox(section, "Two Forms", { tip = "Return to Human Form when out of combat" })
            return
        end
        if section == nil then
            if not br.functions.misc:getModuleOption("Two Forms", "Check") then return false end

            -- When entering combat reset the flag so we can attempt again after combat ends.
            if unit.inCombat() then
                if var.twoFormsDone then
                    ui.debug("Resetting Two Forms flag to false (entered combat)")
                    var.twoFormsDone = false
                end
            else
                -- Out of combat: attempt to return to Human Form once
                if unit.race() == "Worgen" and not unit.mounted() and not var.twoFormsDone
                    and cast.able.twoForms() and unit.gcd() == 0
                then
                    if cast.twoForms() then
                        ui.debug("Casting Two Forms - Returning to Human Form")
                        var.twoFormsDone = true
                        return true
                    end
                end
            end

            return false
        end
    end
end
