-- Currently not used functions
local _, br = ...
function br.IGetLocation(Unit)
    return br.GetObjectPosition(Unit)
end

-- if canPrepare() then
function br.canPrepare()
    if
        br.UnitBuffID("player", 104934) or -- Eating (Feast)
            br.UnitBuffID("player", 80169) or -- Eating
            br.UnitBuffID("player", 87959) or -- Drinking
            br.UnitBuffID("player", 11392) or -- 18 sec Invis Pot
            br.UnitBuffID("player", 3680) or -- 15 sec Invis pot
            br.UnitBuffID("player", 5384) or -- Feign Death
            br._G.IsMounted()
     then
        return false
    else
        return true
    end
end

function br.getAccDistance(Unit1, Unit2)
    -- If both units are visible
    if
        br.GetObjectExists(Unit1) and br.GetUnitIsVisible(Unit1) == true and
            (Unit2 == nil or (br.GetObjectExists(Unit2) and br.GetUnitIsVisible(Unit2) == true))
     then
        -- If Unit2 is nil we compare player to Unit1
        if Unit2 == nil then
            Unit2 = Unit1
            Unit1 = "player"
        end
        -- if unit1 is player, we can use our lib to get precise range
        if Unit1 == "player" and (br.isDummy(Unit2) or br._G.UnitCanAttack(Unit2, "player") == true) then
            -- 	return rc:GetRange(Unit2) or 1000
            -- 		-- else, we use FH positions
            -- else
            local X1, Y1, Z1 = br.GetObjectPosition(Unit1)
            local X2, Y2, Z2 = br.GetObjectPosition(Unit2)
            return math.sqrt(((X2 - X1) ^ 2) + ((Y2 - Y1) ^ 2) + ((Z2 - Z1) ^ 2)) -
                (math.max(
                    br._G.UnitCombatReach(Unit2) + br._G.UnitCombatReach(Unit1) + 4 / 3 +
                        ((br.isMoving(Unit2) and br.isMoving(Unit1)) and 8 / 3 or 0),
                    5
                )) --(br._G.UnitCombatReach(Unit2)+UnitBoundingRadius(Unit2))
        end
    else
        return 100
    end
end

-- findTarget(10,true,1)   will find closest target in 10 yard front that have more or equal to 1%hp
function br.findTarget(range, facingCheck, minimumHealth)
    if br.enemy ~= nil then
        for k, _ in pairs(br.enemy) do
            if br.enemy[k].distance <= range then
                if facingCheck == false or br.getFacing("player", br.enemy[k].unit) == true then
                    if not minimumHealth or minimumHealth and minimumHealth >= br.enemy[k].hp then
                        br._G.TargetUnit(br.enemy[k].unit)
                    end
                end
            else
                break
            end
        end
    end
end

-- if getVengeance() >= 50000 then
function br.getVengeance()
    local VengeanceID = 0
    if select(3, br._G.UnitClass("player")) == 1 then
        VengeanceID = 93098 -- Warrior
    elseif select(3, br._G.UnitClass("player")) == 2 then
        VengeanceID = 84839 -- Paladin
    elseif select(3, br._G.UnitClass("player")) == 6 then
        VengeanceID = 93099 -- DK
    elseif select(3, br._G.UnitClass("player")) == 10 then
        VengeanceID = 120267 -- Monk
    elseif select(3, br._G.UnitClass("player")) == 11 then
        VengeanceID = 84840 -- Druid
    end
    if br._G.UnitBuff("player", VengeanceID) then
        return select(14, br._G.UnitAura("player", br._G.GetSpellInfo(VengeanceID)))
    end
    return 0
end

function br.getLoot2()
    if br.looted == nil then
        br.looted = 0
    end
    if br.lM:emptySlots() then
        for i = 1, br._G.GetObjectCount() do
            if br.GetObjectExists(i) and br._G.bit.band(br._G.GetObjectType(i), br._G.ObjectType.Unit) == 8 then
                local thisUnit = br._G.GetObjectIndex(i)
                local hasLoot, canLoot = br._G.CanLootUnit(br._G.UnitGUID(thisUnit))
                local inRange = br.getDistance("player", thisUnit) < 2
                if br._G.UnitIsDeadOrGhost(thisUnit) then
                    if
                        hasLoot and canLoot and inRange and
                            (br.canLootTimer == nil or br.canLootTimer <= br._G.GetTime() - 0.5) --[[br.getOptionValue("Auto Loot"))]]
                     then
                        if br._G.GetCVar("autoLootDefault") == "0" then
                            br._G.SetCVar("autoLootDefault", "1")
                            br._G.InteractUnit(thisUnit)
                            if br.isLooting() then
                                return true
                            end
                            br.canLootTimer = br._G.GetTime()
                            br._G.SetCVar("autoLootDefault", "0")
                            br.looted = 1
                            return
                        else
                            br._G.InteractUnit(thisUnit)
                            if br.isLooting() then
                                return true
                            end
                            br.canLootTimer = br._G.GetTime()
                            br.looted = 1
                        end
                    end
                end
            end
        end
        if br.GetUnitExists("target") and br.GetUnitIsDeadOrGhost("target") and br.looted == 1 and not br.isLooting() then
            br._G.ClearTarget()
            br.looted = 0
        end
    else
        br.ChatOverlay("Bags are full, nothing will be looted!")
    end
end

-- Dem Bleeds
-- In a run once environment we shall create the Tooltip that we will be reading
-- all of the spell details from
br.nGTT = br._G.CreateFrame("GameTooltip", "MyScanningTooltip", nil, "GameTooltipTemplate")
br.nGTT:SetOwner(br._G.WorldFrame, "ANCHOR_NONE")
br.nGTT:AddFontStrings(
    br.nGTT:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"),
    br.nGTT:CreateFontString("$parentTextRight1", nil, "GameTooltipText")
)
function br.nDbDmg(tar, spellID, player)
    if br._G.GetCVar("DotDamage") == nil then
        br._G.RegisterCVar("DotDamage", 0)
    end
    br.nGTT:ClearLines()
    for i = 1, 40 do
        if br._G.UnitDebuff(tar, i, player) == br._G.GetSpellInfo(spellID) then
            br.nGTT:SetUnitDebuff(tar, i, player)
            local scanText = _G["MyScanningTooltipTextLeft2"]:GetText()
            local DoTDamage = scanText:match("([0-9]+%.?[0-9]*)")
            --if not issecure() then Print(issecure()) end -- function is called inside the profile
            --SetCVar("DotDamage",tonumber(DoTDamage))
            return tonumber(DoTDamage)
        --return tonumber(GetCVar("DotDamage"))
        end
    end
end

-- br.useItem(12345)
function br.useItem_old(itemID)
    if br._G.GetItemCount(itemID) > 0 then
        if select(2, br._G.GetItemCooldown(itemID)) == 0 then
            local itemName = br._G.GetItemInfo(itemID)
            br._G.RunMacroText("/use " .. itemName)
            return true
        end
    end
    return false
end

--[[Taunts Table!! load once]]
br.tauntsTable = {
    {spell = 143436, stacks = 1},
    --Immerseus/71543               143436 - Corrosive Blast                             == 1x
    {spell = 146124, stacks = 3},
    --Norushen/72276                146124 - Self Doubt                                  >= 3x
    {spell = 144358, stacks = 1},
    --Sha of Pride/71734            144358 - Wounded Pride                               == 1x
    {spell = 147029, stacks = 3},
    --Galakras/72249                147029 - Flames of Galakrond                         == 3x
    {spell = 144467, stacks = 2},
    --Iron Juggernaut/71466         144467 - Ignite Armor                                >= 2x
    {spell = 144215, stacks = 6},
    --Kor'Kron Dark Shaman/71859    144215 - Froststorm Strike (Earthbreaker Haromm)     >= 6x
    {spell = 143494, stacks = 3},
    --General Nazgrim/71515         143494 - Sundering Blow                              >= 3x
    {spell = 142990, stacks = 12},
    --Malkorok/71454                142990 - Fatal Strike                                == 12x
    {spell = 143426, stacks = 2},
    --Thok the Bloodthirsty/71529   143426 - Fearsome Roar                               == 2x
    {spell = 143780, stacks = 2},
    --Thok (Saurok eaten)           143780 - Acid Breath                                 == 2x
    {spell = 143773, stacks = 3},
    --Thok (Jinyu eaten)            143773 - Freezing Breath                             == 3x
    {spell = 143767, stacks = 2},
    --Thok (Yaungol eaten)          143767 - Scorching Breath                            == 2x
    {spell = 145183, stacks = 3} --Garrosh/71865                 145183 - Gripping Despair                            >= 3x
}
--[[Taunt function!! load once]]
function br.ShouldTaunt()
    --[[Normal boss1 taunt method]]
    if not br.GetUnitIsUnit("player", "boss1target") then
        for i = 1, #br.tauntsTable do
            if
                not br.UnitDebuffID("player", br.tauntsTable[i].spell) and
                    br.UnitDebuffID("boss1target", br.tauntsTable[i].spell) and
                    br.getDebuffStacks("boss1target", br.tauntsTable[i].spell) >= br.tauntsTable[i].stacks
             then
                br._G.TargetUnit("boss1")
                return true
            end
        end
    end
    --[[Swap back to Wavebinder Kardris]]
    if br.getBossID("target") ~= 71858 then
        if br.UnitDebuffID("player", 144215) and br.getDebuffStacks("player", 144215) >= 6 then
            if br.getBossID("boss1") == 71858 then
                br._G.TargetUnit("boss1")
                return true
            else
                br._G.TargetUnit("boss2")
                return true
            end
        end
    end
end
