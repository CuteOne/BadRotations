function ProfessionHelper()
    if isChecked("Profession Helper") then
        if not isInCombat("player") and not (IsMounted() or IsFlying()) then
            local lootDelay = getValue("Profession Helper")

            local function processThatTable(thisTable,spell)
                for i = 1,#thisTable do
                    local thisItem = thisTable[i]
                    if GetItemCount(thisItem,false,false) >= 5 then
                        if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
                            if castSpell("player", spell, true) then
                                UseItemByName(thisTable[i])
                                lootTimer = GetTime()
                                return
                            end
                        end
                    end
                end
            end
            ------------------------------------------------------------------------------------------------------
            -- Milling -------------------------------------------------------------------------------------------
            ------------------------------------------------------------------------------------------------------
            if isChecked("Mill Herbs") and IsSpellKnown(51005) then
                local millMode = getValue("Mill Herbs")
                if millMode == 4 or millMode == 1 then
                    local tableMillWoD = {
                        109124, -- Frostweed
                        109125, -- Fireweed
                        109126,-- Gorgrond Flytrap
                        109127, -- Starflower
                        109128, -- Nagrand Arrowbloom
                        109129 -- Talador Orchid
                    }
                    processThatTable(tableMillWoD,51005)
                end
                if millMode == 4 or millMode == 2 then
                    local tableMillMoP = {
                        72234, -- Green Tea Leaf
                        72237, -- Rain Poppy
                        72235, -- Silkweed
                        79010, -- Snow Lily
                        79011, -- Fool's Cap
                        89639 -- Desecrated Herb
                    }
                    processThatTable(tableMillMoP,51005)
                end
                if millMode == 4 and millMode == 3 then
                    local tableMillCata = {
                        52986, -- Heartblossom
                        52984, -- Stormvine
                        52983, -- Cinderbloom
                        52985, -- Azshara's Veil
                        52987 -- Twilight Jasmine
                    }
                    processThatTable(tableMillCata,51005)
                end
            end
            ------------------------------------------------------------------------------------------------------
            -- Prospecting ---------------------------------------------------------------------------------------
            ------------------------------------------------------------------------------------------------------
            if isChecked("Prospect Ore") and IsSpellKnown(31252) then
                local prospectMode = getValue("Prospect Ore")
                if prospectMode == 4 or prospectMode == 1 then
                    local tableProspectWoD = {
                        109119, -- True Iron Ore
                        109118 -- Blackrock Ore
                    }
                    processThatTable(tableProspectWoD,31252)
                end
                if prospectMode == 4 or prospectMode == 2 then
                    local tableProspectMoP = {
                        72092, -- Ghost Iron Ore
                        72093, -- Kyparite
                        72094, -- Black Trillium Ore
                        72103, -- White Trillium Ore
                    }
                    processThatTable(tableProspectMoP,31252)
                end
                if prospectMode == 4 or prospectMode == 2 then
                    local tableProspectCata = {
                        52183, -- Pyrite Ore
                        52185, -- Elementium Ore
                        53038, -- Obsidium Ore
                    }
                    processThatTable(tableProspectCata,31252)
                end
            end
            ------------------------------------------------------------------------------------------------------
            -- Disenchant ----------------------------------------------------------------------------------------
            ------------------------------------------------------------------------------------------------------
            if isChecked("Disenchant") and IsSpellKnown(13262) then
                -- list of items to me DE
                local tableDisenchant = {
                    90905, -- JC Blue Neck ilvl 415
                    90904, -- JC Blue Ring ilvl 415
                    83794, -- JC Green Neck ilvl 384
                    83793, -- JC Green Ring ilvl 384
                    82434, -- Contender's Satin Cuffs (ilvl 450)
                    82426, -- Contender's Silk Cuffs (ilvl 450)
                    82402 -- Windwool Bracers (ilvl 384)
                }
                processThatTable(tableDisenchant,13262)
            end
            if isChecked("LeatherScraps") then
                -- Raw Beast Hide Scraps
                if GetItemCount(110610,false,false) >= 10 then
                    if lootTimer == nil or lootTimer <= GetTime() - lootDelay then
                        if IsUsableItem(110610) then
                            UseItemByName(110610)
                            lootTimer = GetTime()
                        end
                    end
                end
            end
        end
    end
end