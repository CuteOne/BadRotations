-- Currently not used functions

function IGetLocation(Unit)
    return GetObjectPosition(Unit)
end

-- if canPrepare() then
function canPrepare()
    if UnitBuffID("player",104934) -- Eating (Feast)
            or UnitBuffID("player",80169) -- Eating
            or UnitBuffID("player",87959) -- Drinking
            or UnitBuffID("player",11392) -- 18 sec Invis Pot
            or UnitBuffID("player",3680) -- 15 sec Invis pot
            or UnitBuffID("player",5384) -- Feign Death
            or IsMounted() then
        return false
    else
        return true
    end
end

function getAccDistance(Unit1,Unit2)
    -- If both units are visible
    if GetObjectExists(Unit1) and GetUnitIsVisible(Unit1) == true and (Unit2 == nil or (GetObjectExists(Unit2) and GetUnitIsVisible(Unit2) == true)) then
        -- If Unit2 is nil we compare player to Unit1
        if Unit2 == nil then
            Unit2 = Unit1
            Unit1 = "player"
        end
        -- if unit1 is player, we can use our lib to get precise range
        if Unit1 == "player" and (isDummy(Unit2) or UnitCanAttack(Unit2,"player") == true) then
            -- 	return rc:GetRange(Unit2) or 1000
            -- 		-- else, we use FH positions
            -- else
            local X1,Y1,Z1 = GetObjectPosition(Unit1)
            local X2,Y2,Z2 = GetObjectPosition(Unit2)
            return math.sqrt(((X2-X1)^2) + ((Y2-Y1)^2) + ((Z2-Z1)^2)) - (math.max(UnitCombatReach(Unit2) + UnitCombatReach(Unit1) + 4 / 3 + ((isMoving(Unit2) and isMoving(Unit1)) and 8 / 3 or 0), 5)) --(UnitCombatReach(Unit2)+UnitBoundingRadius(Unit2))
        end
    else
        return 100
    end
end

-- findTarget(10,true,1)   will find closest target in 10 yard front that have more or equal to 1%hp
function findTarget(range,facingCheck,minimumHealth)
    if br.enemy ~= nil then
        for k, v in pairs(br.enemy) do
            if br.enemy[k].distance <= range then
                if FacingCheck == false or getFacing("player",br.enemy[k].unit) == true then
                    if not minimumHealth or minimumHealth and minimumHealth >= br.enemy[k].hp then
                        TargetUnit(br.enemy[k].unit)
                    end
                end
            else
                break
            end
        end
    end
end

-- if getVengeance() >= 50000 then
function getVengeance()
    local VengeanceID = 0
    if select(3,UnitClass("player")) == 1 then VengeanceID = 93098 -- Warrior
    elseif select(3,UnitClass("player")) == 2 then VengeanceID = 84839 -- Paladin
    elseif select(3,UnitClass("player")) == 6 then VengeanceID = 93099 -- DK
    elseif select(3,UnitClass("player")) == 10 then VengeanceID = 120267 -- Monk
    elseif select(3,UnitClass("player")) == 11 then VengeanceID = 84840 -- Druid
    end
    if UnitBuff("player",VengeanceID) then
        return select(14,UnitAura("player",GetSpellInfo(VengeanceID)))
    end
    return 0
end

function getLoot2()
    if looted == nil then looted = 0 end
    if lM:emptySlots() then
        for i=1,GetObjectCountBR() do
            if GetObjectExists(i) and bit.band(GetObjectType(i), ObjectType.Unit) == 8 then
                local thisUnit = GetObjectIndex(i)
                local hasLoot,canLoot = CanLootUnit(UnitGUID(thisUnit))
                local inRange = getDistance("player",thisUnit) < 2
                if UnitIsDeadOrGhost(thisUnit) then
                    if hasLoot and canLoot and inRange and (canLootTimer == nil or canLootTimer <= GetTime()-0.5)--[[getOptionValue("Auto Loot"))]] then
                        if GetCVar("autoLootDefault") == "0" then
                            SetCVar("autoLootDefault", "1")
                            InteractUnit(thisUnit)
                            if isLooting() then
                                return true
                            end
                            canLootTimer = GetTime()
                            SetCVar("autoLootDefault", "0")
                            looted = 1
                            return
                        else
                            InteractUnit(thisUnit)
                            if isLooting() then
                                return true
                            end
                            canLootTimer = GetTime()
                            looted = 1
                        end
                    end
                end
            end
        end
        if GetUnitExists("target") and UnitIsDeadOrGhost("target") and looted==1 and not isLooting() then
            ClearTarget()
            looted=0
        end
    else
        ChatOverlay("Bags are full, nothing will be looted!")
    end
end

-- Dem Bleeds
-- In a run once environment we shall create the Tooltip that we will be reading
-- all of the spell details from
nGTT = CreateFrame( "GameTooltip","MyScanningTooltip",nil,"GameTooltipTemplate" )
nGTT:SetOwner( WorldFrame,"ANCHOR_NONE" )
nGTT:AddFontStrings(nGTT:CreateFontString( "$parentTextLeft1",nil,"GameTooltipText" ),nGTT:CreateFontString( "$parentTextRight1",nil,"GameTooltipText" ) )
function nDbDmg(tar,spellID,player)
    if GetCVar("DotDamage") == nil then
        RegisterCVar("DotDamage",0)
    end
    nGTT:ClearLines()
    for i=1,40 do
        if UnitDebuff(tar,i,player) == GetSpellInfo(spellID) then
            nGTT:SetUnitDebuff(tar,i,player)
            scanText=_G["MyScanningTooltipTextLeft2"]:GetText()
            local DoTDamage = scanText:match("([0-9]+%.?[0-9]*)")
            --if not issecure() then Print(issecure()) end -- function is called inside the profile
            --SetCVar("DotDamage",tonumber(DoTDamage))
            return tonumber(DoTDamage)
            --return tonumber(GetCVar("DotDamage"))
        end
    end
end

-- useItem(12345)
function useItem_old(itemID)
    if GetItemCount(itemID) > 0 then
        if select(2,GetItemCooldown(itemID))==0 then
            local itemName = GetItemInfo(itemID)
            RunMacroText("/use "..itemName)
            return true
        end
    end
    return false
end

--[[Taunts Table!! load once]]
tauntsTable = {
    { spell = 143436,stacks = 1 },--Immerseus/71543               143436 - Corrosive Blast                             == 1x
    { spell = 146124,stacks = 3 },--Norushen/72276                146124 - Self Doubt                                  >= 3x
    { spell = 144358,stacks = 1 },--Sha of Pride/71734            144358 - Wounded Pride                               == 1x
    { spell = 147029,stacks = 3 },--Galakras/72249                147029 - Flames of Galakrond                         == 3x
    { spell = 144467,stacks = 2 },--Iron Juggernaut/71466         144467 - Ignite Armor                                >= 2x
    { spell = 144215,stacks = 6 },--Kor'Kron Dark Shaman/71859    144215 - Froststorm Strike (Earthbreaker Haromm)     >= 6x
    { spell = 143494,stacks = 3 },--General Nazgrim/71515         143494 - Sundering Blow                              >= 3x
    { spell = 142990,stacks = 12 },--Malkorok/71454                142990 - Fatal Strike                                == 12x
    { spell = 143426,stacks = 2 },--Thok the Bloodthirsty/71529   143426 - Fearsome Roar                               == 2x
    { spell = 143780,stacks = 2 },--Thok (Saurok eaten)           143780 - Acid Breath                                 == 2x
    { spell = 143773,stacks = 3 },--Thok (Jinyu eaten)            143773 - Freezing Breath                             == 3x
    { spell = 143767,stacks = 2 },--Thok (Yaungol eaten)          143767 - Scorching Breath                            == 2x
    { spell = 145183,stacks = 3 } --Garrosh/71865                 145183 - Gripping Despair                            >= 3x
}
--[[Taunt function!! load once]]
function ShouldTaunt()
    --[[Normal boss1 taunt method]]
    if not GetUnitIsUnit("player","boss1target") then
        for i = 1,#tauntsTable do
            if not UnitDebuffID("player",tauntsTable[i].spell) and UnitDebuffID("boss1target",tauntsTable[i].spell) and getDebuffStacks("boss1target",tauntsTable[i].spell) >= tauntsTable[i].stacks then
                TargetUnit("boss1")
                return true
            end
        end
    end
    --[[Swap back to Wavebinder Kardris]]
    if getBossID("target") ~= 71858 then
        if UnitDebuffID("player",144215) and getDebuffStacks("player",144215) >= 6 then
            if getBossID("boss1") == 71858 then
                TargetUnit("boss1")
                return true
            else
                TargetUnit("boss2")
                return true
            end
        end
    end
end
