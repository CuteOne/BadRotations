if select(3,UnitClass("player")) == 2 then
--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[  ]]   --[[]]
--[[]]				--[[]]	   --[[]]	--[[    ]] --[[]]   --[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[    ]] --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[           ]]
--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[   		   ]]
--[[]]	   			--[[           ]]	--[[]]	 --[[  ]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	 --[[  ]]
--[[]]	   			--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]

_ArdentDefender             =   31850
_AvengersShield             =   31935
_AvengingWrath              =   31884
_BeaconOfLight              =   53563
_Berserking                 =   26297  
_BlessingOfKings            =   20217
_BlessingOfMight            =   19740
_BlindingLight              =   115750
_BloodFury                  =   20572 
_Cleanse                    =   4987
_Consecration               =   26573
_CrusaderStrike             =   35395
_Denounce                   =   2812
_DevotionAura               =   31821
_DivineFavor                =   31842
_DivineLight                =   82326
_DivinePlea                 =   54428
_DivineProtection           =   498
_DivineShield               =   642
_DivineStorm                =   53385
_EternalFlame               =   114163
_ExecutionSentence          =   114157
_Exorcism                   =   879
_FistOfJustice              =   105593
_FlashOfLight               =   19750
_HandOfFreedom              =   1044
_HandOfProtection           =   1022
_HandOfPurity               =   114039
_HandOfSacrifice            =   6940
_HandOfSalvation            =   1038
_HammerOfJustice            =   853
_HammerOfTheRighteous       =   53595
_HammerOfWrath              =   24275
_HolyAvenger                =   105809
_HolyLight                  =   635
_HolyPrism                  =   114165
_HolyRadiance               =   82327
_HolyShock                  =   20473
_HolyWrath                  =   119072
_GiftOfTheNaaru             =   59542
_GuardianOfAncientKings     =   86659
_GuardianOfAncientKingsHoly =   86669
_GuardianOfAncientKingsRet  =   86698
_Inquisition                =   84963
_Judgment                  =   20271
_LayOnHands                 =   633
_LightOfDawn                =   85222
_LightsHammer               =   114158
_MassExorcism               =   122032
_MassResurection            =   83968
_Rebuke                     =   96231
_Reckoning                  =   62124
_Redemption                 =   7328
_RighteousFury              =   25780           
_Repentance                 =   20066
_SanctifiedWrath            =   53376
_SacredShield               =   20925
_SealOfInsight              =   20165
_SealOfRighteousness        =   20154
_SealOfThruth               =   31801
_SelflessHealer             =   85804
_ShieldOfTheRighteous       =   53600
_SpeedOfLight               =   85499
_TemplarsVerdict            =   85256
_TurnEvil                   =   10326       
_WordOfGlory                =   85673

function Blessings()
    if UnitBuffID("player",144051) ~= nil then return false end
    local BlessingCount = 0
    for i = 1, #nNova do
        local _, MemberClass = select(2,UnitClass(nNova[i].unit))
        if UnitExists(nNova[i].unit) then 
            if MemberClass ~= nil then
                if MemberClass == "DRUID" then BlessingCount = BlessingCount + 1 end                
                if MemberClass == "MONK" then BlessingCount = BlessingCount + 1 end                 
                if MemberClass == "PALADIN" then BlessingCount = BlessingCount + 50 end 
                if MemberClass == "SHAMAN" then BlessingCount = BlessingCount + 1000 end
            end     
        end 
    end 
    if BlessingCount > 50 and BlessingCount < 1000 then
        MyBlessing = _BlessingOfMight
    else
        MyBlessing = _BlessingOfKings
    end
    if ActiveBlessingsValue == 2 then
        MyBlessing = _BlessingOfKings
    elseif ActiveBlessingsValue == 3 then
        MyBlessing = _BlessingOfMight
    end 
    if MyBlessing == _BlessingOfMight and not Spells[_BlessingOfMight].known then MyBlessing = _BlessingOfKings end
    if MyBlessing == _BlessingOfKings and not Spells[_BlessingOfKings].known then BuffTimer = GetTime() + 600 return false end  
    if BuffTimer == nil or BuffTimer < GetTime() then
        for i=1, #nNova do
            if not UnitBuffID(nNova[i].unit,MyBlessing) then
                BuffTimer = GetTime() + random(15,30);
                if castSpell("player",MyBlessing) then return; end
            end
        end 
    end
end

--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[]]				--[[]]	  --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]	   
--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
--[[           ]]	--[[]]	   --[[]]	--[[]]					 --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]
 

    function PaladinHolyFunctions()


        function GetHolyGen()
            local Delay = 0.3;
            if UnitPower("player", 9) <= 4 and getSpellCD(_CrusaderStrike) < Delay or getSpellCD(_Judgment) < Delay or UnitBuffID("player", 85416) then 
                return true;
            else
                return false;
            end
        end
        
    end


--[[           ]]	--[[         ]]		--[[           ]] 	
--[[           ]]	--[[          ]]	--[[           ]] 	
--[[]]				--[[]]	   --[[]]	--[[]]				
--[[]]				--[[]]	   --[[]]	--[[           ]] 	
--[[]]				--[[]]	   --[[]]		   	   --[[]]	
--[[   		   ]]	--[[          ]]	--[[           ]] 	
--[[   		   ]]	--[[         ]] 	--[[           ]] 	

--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]
--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]		 --[[ ]]
--[[         ]]		--[[         ]]	    --[[]]	   --[[]]		 --[[ ]]
--[[       ]]		--[[        ]]		--[[]]	   --[[]]		 --[[ ]]
--[[]]				--[[]]	  --[[]]	--[[           ]]	 	 --[[ ]]		
--[[]] 				--[[]]	   --[[]]	--[[           ]]		 --[[ ]]

    function PaladinProtFunctions()

        function SacredShield()
            local SacredShieldCheck = BadBoy_data["Check Sacred Shield"];
            local SacredShield = BadBoy_data["Box Sacred Shield"];
            if UnitBuffID("player",20925) then SacredShieldTimer = select(7, UnitBuffID("player",20925)) - GetTime() else SacredShieldTimer = 0 end
            if SacredShieldCheck and getHP("player") <= SacredShield then
                if ((isMoving("player") or UnitAffectingCombat("player")) and not UnitBuffID("player",20925)) or (LastVengeance ~= nil and (GetVengeance() > (BadBoy_data["Box Sacred Vengeance"] + LastVengeance))) then
                    LastVengeance = GetVengeance()
                    return true;
                end
                if SacredShieldTimer <= 3 then
                    return true;
                end
            end 
            return false;
        end

        function GetHolyGen()
            local Delay = 0.3;
            if UnitPower("player", 9) <= 4 and getSpellCD(_CrusaderStrike) < Delay or getSpellCD(_Judgment) < Delay or UnitBuffID("player", 85416) then 
                return true;
            else
                return false;
            end
        end

    end

--[[           ]]	--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]]
--[[]]	   --[[]]	--[[]]					 --[[ ]]
--[[         ]]		--[[           ]]	  	 --[[ ]]
--[[        ]]		--[[]]				  	 --[[ ]]
--[[]]	  --[[]]	--[[           ]]	 	 --[[ ]]		
--[[]]	   --[[]] 	--[[           ]]		 --[[ ]]


    function PaladinRetFunctions()


        function GetHolyGen()
            local Delay = 0.3;
            if UnitPower("player", 9) <= 4 and getSpellCD(_CrusaderStrike) < Delay or getSpellCD(_Judgment) < Delay or UnitBuffID("player", 85416) then 
                return true;
            else
                return false;
            end
        end

    end









end