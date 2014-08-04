if select(3, UnitClass("player")) == 11 then

-- canInterrupt(80965,20) or canInterrupt(80965,0) or canInterrupt(80965)
function canInterrupt(spellID,percentint)
    local unit = "target" or "mouseover"
    local castDuration = 0
    local castTimeRemain = 0
    local castPercent = 0
    local interruptable = false
    if UnitExists(unit)
        and UnitCanAttack("player", unit) == 1 
        and not UnitIsDeadOrGhost(unit)
        and getSpellCD(spellID) 
    then
        if select(6,UnitCastingInfo(unit)) ~= nil and select(9,UnitCastingInfo(unit)) ~= nil then
            castStartTime = select(5,UnitCastingInfo(unit))
            castEndTime = select(6,UnitCastingInfo(unit))
            interruptable = true
        elseif select(6,UnitChannelInfo(unit)) ~= nil and select(8,UnitChannelInfo(unit)) == nil then
            castStartTime = select(5,UnitChannelInfo(unit))
            castEndTime = select(6,UnitChannelInfo(unit))
            interruptable = true
        else
            castStartTime = 0
            castEndTime = 0
            interruptable = false
        end
        if castEndTime > 0 and castStartTime > 0 then
            castDuration = (castEndTime - castStartTime)/1000
            castTimeRemain = ((castEndTime/1000) - GetTime())
            if percentint == nil and castPercent == 0 then 
                castPercent = math.random(5, 95)
            elseif percentint == 0 and castPercent == 0 then
                castPercent = math.random(5, 95)
            elseif percentint > 0 then 
                castPercent = percentint 
            end
        else
            castDuration = 0
            castTimeRemain = 0
            castPercent = 0
        end
        if math.ceil((castTimeRemain/castDuration)*100) <= castPercent and interruptable == true then
            return true
        else
            return false
        end
    end
end

--Shred glyph and facing checks
function canShred()
    if ((UnitBuffID("player",106951) or UnitBuffID("player",5217)) and hasGlyph(114234) == true) or getFacing("target","player") == false then
        return true;
    else
        return false;
    end
end

--Potential Mangle Damage
function getMangleDamage() 
    local calc = (1 * 78 + 1.25 * (select(1, UnitDamage("player")) + select(2, UnitDamage("player"))))*(1 - (24835 * (1 - .04 * 0)) / (24835 * (1 - .04*0) + 46257.5));
    if select(4,UnitBuffID("player",145152)) == nil then 
        return calc;
    else
        return calc*1.3;
    end
end

--Potential Ferocious Bite Damage
function getFerociousBiteDamage()
    local calc = (315 + 762 * GetComboPoints("player") + 0.196 * GetComboPoints("player") * UnitAttackPower("player"))
    if select(4,UnitBuffID("player",145152)) == nil then
        return calc;
    else
        return calc*1.3;
    end
end

--Savage Roar Duration Tracking
function getSRR()        
    if hasGlyph(127540) then
        if UnitBuffID("player",127538) and UnitLevel("player") >= 18 then
            return getBuffRemain("player",127538)
        else
            if UnitLevel("player") < 18 then
                return 999
            else
                return 0
            end
        end
    else
        if UnitBuffID("player",52610) and UnitLevel("player") >= 18 then
            return getBuffRemain("player",127538)
        else
            if UnitLevel("player") < 18 then
                return 999
            else
                return 0
            end
        end
    end
end

--Total Savage Roar Time
function getSRT()        
    if (12 + (getCombo("player")*6)) > (getSRR() + 12) then
        return true
    else
        return false
    end
end

--Savage Roar / Rip Duration Difference
function getSrRpDiff()   
    if UnitLevel("player") >= 20 then
        local srrpdiff = (getDebuffRemain("target",rp) - getSRR()) 
        if srrpdiff < 0 then
            return -srrpdiff 
        else
            return srrpdiff 
        end
    else
        return 0
    end
end

--Rune of Reorigination Duration Tracking
function getRoRoRemain()       
    if UnitBuffID("player",139121) then
        return (select(7, UnitBuffID("player",139121)) - GetTime())
    elseif UnitBuffID("player",139117) then
        return (select(7, UnitBuffID("player",139117)) - GetTime())
    elseif UnitBuffID("player",139120) then
        return (select(7, UnitBuffID("player",139120)) - GetTime())
    else
        return 0
    end
end

--Rake Filler
function getRkFill()  
    if getTimeToDie("target") > 3 
        and CRKD()*((getDebuffRemain("target",rk) / 3 ) + 1 ) - RKD()*(getDebuffRemain("target",rk) / 3) > getMangleDamage() 
    then
        return true
    else
        return false
    end
end

--Rake Override
function getRkOver()   
    if getTimeToDie("target") - getDebuffRemain("target",rk) > 3 
        and (RKP() > 108 or (getDebuffRemain("target",rk) < 3 and getRakeDamage() >= 75))
    then
        return true
    else 
        return false
    end
end

--Garrosh Mind Controlled
function isGarrMCd() 
    if UnitExists("target") 
        and (UnitDebuffID("target",145832)
            or UnitDebuffID("target",145171)
            or UnitDebuffID("target",145065)
            or UnitDebuffID("target",145071))
    then 
        return true
    else 
        return false 
    end
end

--Symbiosis Priority Cast
function classPrio(t)
    local class = select(3,UnitClass(t))
   
    if class == 1 then --Warrior
            return 1
    elseif class == 2 then --Paladin
            return 5
    elseif class == 3 then --Hunter
            return 8
    elseif class == 4 then --Rogue
            return 4
    elseif class == 5 then --Priest
            return 6
    elseif class == 6 then --Deathknight
            return 7
    elseif class == 7 then --Shaman
            return 2
    elseif class == 8 then --Mage
            return 9
    elseif class == 9 then --Warlock
            return 3
    elseif class == 10 then --Monk
            return 10
    elseif class == 11 then --Druid
            return 11
    end
end
 
local symIDs = {
 110478, --DK
 110479, --Hunter
 110482, --Made
 110483, --Monk
 110484, --Paladin
 110485, --Priest
 110486, --Rogue
 110488, --Shaman
 110490, --Warlock
 110491 --Warrior
}
 
function HasSymb( t )
    for i=1, #symIDs do
        local hasSym = select(15,UnitBuffID(t,symIDs[i]))
        local class = select(3,UnitClass( t ))
 
        if hasSym or class == 11 then
                return true
        else
                return false
        end
    end
end
 
function SymMem()
--  symmem, symgroup = { { Unit = "player", Prio = classPrio("Player"), Class = select(2, UnitClass("Player")),ClassID = select(3,UnitClass("Player")) } }, { low = 0, tanks = { } }
    symmem, symgroup = { {Prio = 12 } }, { low = 0, tanks = { } }
    symgroup.type = IsInRaid() and "raid" or "party"
    symgroup.number = GetNumGroupMembers()
    if symgroup.number > 0 then   
        for i=1,symgroup.number do
            if CanHeal(symgroup.type..i) and not HasSymb(symgroup.type..i) then
                local unit, prio, class, classID = symgroup.type..i, classPrio(symgroup.type..i), select(2, UnitClass(symgroup.type..i)), select(3,UnitClass(symgroup.type..i))
                table.insert( symmem,{ Unit = unit, Prio = prio, Class = class, ClassID = classID } )
 
                if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(symgroup.tanks,unit) end
            end
        end
   
        if symgroup.type == "Raid" and #members > 1 then table.remove(symmem,1) end
        table.sort(symmem, function(x,y) return x.Prio < y.Prio end)
  --  local customtarget = CanHeal("target") and "target" -- or CanHeal("mouseover") and GetMouseFocus() ~= WorldFrame and "mouseover"
  --  if customtarget then table.sort(symmem, function(x) return UnitIsUnit(customtarget,x.Unit) end) end
    end
end

function GroupInfo()
    members, group = { { Unit = "player" } }, { low = 0, tanks = { } }      
    group.type = IsInRaid() and "raid" or "party" 
    group.number = GetNumGroupMembers()
    if group.number > 0 then
        for i=1,group.number do 
            local unit = group.type..i
            table.insert( members,{ Unit = unit } ) 
        end 
        if group.type == "raid" and #members > 1 then table.remove(members,1) end    
    end
end

-- Dummy Check
function isDummy()
    dummies = {
        31146, --Raider's Training Dummy - Lvl ??
        67127, --Training Dummy - Lvl 90
        46647, --Training Dummy - Lvl 85
        32546, --Ebon Knight's Training Dummy - Lvl 80
        31144, --Training Dummy - Lvl 80
        32667, --Training Dummy - Lvl 70
        32542, --Disciple's Training Dummy - Lvl 65
        32666, --Training Dummy - Lvl 60
        32545, --Initiate's Training Dummy - Lvl 55 
        32541, --Initiate's Training Dummy - Lvl 55 (Scarlet Enclave) 
    }
    for i=1, #dummies do
        if UnitExists("target") then
            dummyID = tonumber(UnitGUID("target"):sub(-13, -9), 16)
        else
            dummyID = 0
        end
        if dummyID == dummies[i] then
            return true
        end 
    end
end


-- Bleed Calculations
function getStatsMult()
    local CritDamageMult = 2 -- adjust for crit damage meta
    local APBase, APPos, APNeg = UnitAttackPower("player")
    local AP = APBase + APPos + APNeg
    local DamageMult = select(7, UnitDamage("player"))
    local Mastery = 1 + GetMasteryEffect() / 100
    
    local PlayerLevel, TargetLevel = UnitLevel("player"), UnitLevel("target")
    local CritChance
    if TargetLevel == -1 then
        CritChance = (GetCritChance()-3)/100
    else
        CritChance = (GetCritChance()-max(TargetLevel-PlayerLevel,0))/100
    end
    local CritEffMult =  1 + (CritDamageMult-1)*CritChance
    
    local CP = GetComboPoints("player", "target")
    if CP == 0 then CP = 5 end
    
    local DoCSID = select(11, UnitAura("player", "Dream of Cenarius"))
    if DoCSID == 145152 then
        DamageMult = DamageMult * 1.3
    end

    local StatsMultiplier = Mastery*DamageMult--*CritEffMult
    return StatsMultiplier
end

--Calculated Rake Dot Damage
function CRKD()
    local APBase, APPos, APNeg = UnitAttackPower("player")
    local AP = APBase + APPos + APNeg
    local calcRake = round2((99+0.3*AP)*getStatsMult(),0)
    return calcRake
end

--Applied Rake Dot Damage 
function RKD()
    local rakeDot = 1
    if Rake_sDamage[UnitGUID("target")] ~= nil then rakeDot = Rake_sDamage[UnitGUID("target")]; end
    return rakeDot
end

function OldRKD()
    local OldrakeDot = 1
    OldrakeDot = getDotDamage("target",rk)
    return OldrakeDot
end  

--Rake Dot Damage Percent
function RKP()
    local RatioPercent = (CRKD() / RKD()) * 100
    return RatioPercent
end

--Calculated Rip Dot Damage
function CRPD()
    local APBase, APPos, APNeg = UnitAttackPower("player")
    local AP = APBase + APPos + APNeg
    local calcRip = (113+5*(320+0.0484*AP))*getStatsMult()     
    return calcRip
end

--Applied Rake Dot Damage
function RPD()
    local ripDot = 1
    if Rip_sDamage[UnitGUID("target")] ~= nil then ripDot = Rip_sDamage[UnitGUID("target")]; end
    return ripDot
end

--Rip Dot Damage Percent
function RPP()
    local RatioPercent = (CRPD() /RPD()) * 100
    return RatioPercent
end

------Boss Check------
for x=1,5 do
    if UnitExists("boss1") then
        boss1 = tonumber(UnitGUID("boss1"):sub(6,10), 16)
    else
        boss1 = 0
    end
    if UnitExists("boss2") then
        boss2 = tonumber(UnitGUID("boss2"):sub(6,10), 16)
    else
        boss2 = 0
    end
    if UnitExists("boss3") then
        boss3 = tonumber(UnitGUID("boss3"):sub(6,10), 16)
    else
        boss3 = 0
    end
    if UnitExists("boss4") then
        boss4 = tonumber(UnitGUID("boss4"):sub(6,10), 16)
    else
        boss4 = 0
    end
    if UnitExists("boss5") then
        boss5 = tonumber(UnitGUID("boss5"):sub(6,10), 16)
    else
        boss5 = 0
    end
end     
BossUnits = {
    -- Cataclysm Dungeons --
    -- Abyssal Maw: Throne of the Tides
    40586,      -- Lady Naz'jar
    40765,      -- Commander Ulthok
    40825,      -- Erunak Stonespeaker
    40788,      -- Mindbender Ghur'sha
    42172,      -- Ozumat
    -- Blackrock Caverns
    39665,      -- Rom'ogg Bonecrusher
    39679,      -- Corla, Herald of Twilight
    39698,      -- Karsh Steelbender
    39700,      -- Beauty
    39705,      -- Ascendant Lord Obsidius
    -- The Stonecore
    43438,      -- Corborus
    43214,      -- Slabhide
    42188,      -- Ozruk
    42333,      -- High Priestess Azil
    -- The Vortex Pinnacle
    43878,      -- Grand Vizier Ertan
    43873,      -- Altairus
    43875,      -- Asaad
    -- Grim Batol
    39625,      -- General Umbriss
    40177,      -- Forgemaster Throngus
    40319,      -- Drahga Shadowburner
    40484,      -- Erudax
    -- Halls of Origination
    39425,      -- Temple Guardian Anhuur
    39428,      -- Earthrager Ptah
    39788,      -- Anraphet
    39587,      -- Isiset
    39731,      -- Ammunae
    39732,      -- Setesh
    39378,      -- Rajh
    -- Lost City of the Tol'vir
    44577,      -- General Husam
    43612,      -- High Prophet Barim
    43614,      -- Lockmaw
    49045,      -- Augh
    44819,      -- Siamat
    -- Zul'Aman
    23574,      -- Akil'zon
    23576,      -- Nalorakk
    23578,      -- Jan'alai
    23577,      -- Halazzi
    24239,      -- Hex Lord Malacrass
    23863,      -- Daakara
    -- Zul'Gurub
    52155,      -- High Priest Venoxis
    52151,      -- Bloodlord Mandokir
    52271,      -- Edge of Madness
    52059,      -- High Priestess Kilnara
    52053,      -- Zanzil
    52148,      -- Jin'do the Godbreaker
    -- End Time
    54431,      -- Echo of Baine
    54445,      -- Echo of Jaina
    54123,      -- Echo of Sylvanas
    54544,      -- Echo of Tyrande
    54432,      -- Murozond
    -- Hour of Twilight
    54590,      -- Arcurion
    54968,      -- Asira Dawnslayer
    54938,      -- Archbishop Benedictus
    -- Well of Eternity
    55085,      -- Peroth'arn
    54853,      -- Queen Azshara
    54969,      -- Mannoroth
    55419,      -- Captain Varo'then
    
    -- Mists of Pandaria Dungeons --
    -- Scarlet Halls
    59303,      -- Houndmaster Braun
    58632,      -- Armsmaster Harlan
    59150,      -- Flameweaver Koegler
    -- Scarlet Monastery
    59789,      -- Thalnos the Soulrender
    59223,      -- Brother Korloff
    3977,       -- High Inquisitor Whitemane
    60040,      -- Commander Durand
    -- Scholomance
    58633,      -- Instructor Chillheart
    59184,      -- Jandice Barov
    59153,      -- Rattlegore
    58722,      -- Lilian Voss
    58791,      -- Lilian's Soul
    59080,      -- Darkmaster Gandling
    -- Stormstout Brewery
    56637,      -- Ook-Ook
    56717,      -- Hoptallus
    59479,      -- Yan-Zhu the Uncasked
    -- Tempe of the Jade Serpent
    56448,      -- Wise Mari
    56843,      -- Lorewalker Stonestep
    59051,      -- Strife
    59726,      -- Peril
    58826,      -- Zao Sunseeker
    56732,      -- Liu Flameheart
    56762,      -- Yu'lon
    56439,      -- Sha of Doubt
    -- Mogu'shan Palace
    61444,      -- Ming the Cunning
    61442,      -- Kuai the Brute
    61445,      -- Haiyan the Unstoppable
    61243,      -- Gekkan
    61398,      -- Xin the Weaponmaster
    -- Shado-Pan Monastery
    56747,      -- Gu Cloudstrike
    56541,      -- Master Snowdrift
    56719,      -- Sha of Violence
    56884,      -- Taran Zhu
    -- Gate of the Setting Sun
    56906,      -- Saboteur Kip'tilak
    56589,      -- Striker Ga'dok
    56636,      -- Commander Ri'mok
    56877,      -- Raigonn
    -- Siege of Niuzao Temple
    61567,      -- Vizier Jin'bak
    61634,      -- Commander Vo'jak
    61485,      -- General Pa'valak
    62205,      -- Wing Leader Ner'onok

    -- Training Dummies --
    46647,      -- Level 85 Training Dummy
    67127,      -- Level 90 Training Dummy
    
    -- Instance Bosses --
    boss1,  --Boss 1
    boss2,  --Boss 2    
    boss3,  --Boss 3
    boss4,  --Boss 4
    boss5,  --Boss 5
}

-- isBoss()
function isBoss()
    local BossUnits = BossUnits
    
    if UnitExists("target") then
        local npcID = tonumber(UnitGUID("target"):sub(6,10), 16)
        
        if (UnitClassification("target") == "rare" or UnitClassification("target") == "rareelite" or UnitClassification("target") == "worldboss" or (UnitClassification("target") == "elite" and UnitLevel("target") >= UnitLevel("player")+3) or UnitLevel("target") < 0) 
            --and select(2,IsInInstance())=="none" 
            and not UnitIsTrivial("target")
        then 
            return true 
        else
            for i=1,#BossUnits do
                if BossUnits[i] == npcID then 
                    return true 
                end
            end
            return false
        end
    else 
        return false 
    end
end

function useCDs()
    if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
        return true
    else
        return false
    end
end

function useAoE()
    if (BadBoy_data['AoE'] == 1 and getNumEnnemies("player",10) >= 3) or BadBoy_data['AoE'] == 2 then
        return true
    else
        return false
    end
end

function outOfWater()
    if swimTime == nil then swimTime = 0 end
    if outTime == nil then outTime = 0 end
    if IsSwimming() then
        swimTime = GetTime()
        outTime = 0
    end
    if not IsSwimming() then
        outTime = swimTime
        swimTime = 0
    end
    if outTime ~= 0 and swimTime == 0 then
        return true
    end
    if outTime ~= 0 and IsFlying() then
        outTime = 0
        return false
    end
end         


end