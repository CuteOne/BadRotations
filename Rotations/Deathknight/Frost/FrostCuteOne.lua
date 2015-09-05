if select(2, UnitClass("player")) == "DEATHKNIGHT" then
    function cFrost:FrostCuteOne()
        ChatOverlay("UNDER CONSTRUCTION - Use OLD Rotation")
------------------------
--- Global Functions ---
------------------------
        KeyToggles()
        GroupInfo()
--------------
--- Locals ---
--------------
        local attacktar = UnitCanAttack("target", "player")
        local buff      = self.buff
        local deadtar   = UnitIsDeadOrGhost("target") 
        local inCombat  = self.inCombat
        local party     = select(2,IsInInstance())=="party"
        local php       = self.health
        local solo      = select(2,IsInInstance())=="none"
--------------------
--- Action Lists ---
--------------------
        function actionList_PreCombat()
            -- flask,type=greater_draenic_strength_flask
            -- food,type=buttered_sturgeon
            -- Horn of Winter
            if isChecked("Horn of Winter") and not (IsFlying() or IsMounted()) and not inCombat then
                for i = 1, #members do
                    if not isBuffed(members[i].Unit,{57330,19506,6673}) and (#nNova==select(5,GetInstanceInfo()) or solo or (party and not UnitInParty("player")))
                    then
                        if self.castHornOfWinter() then return end
                    end
                end
            end
            -- Frost Presence
            if not buff.frostPresense and php > getOptionValue("Blood Presence") and (getDistance("target")<=20 and attacktar and not deadtar) then
                if self.castFrostPresense() then return end
            end
            -- army_of_the_dead
        end -- End Action List - PreCombat
---------------------
--- Out Of Combat ---
---------------------
        if actionList_PreCombat() then return end
    end -- End cFrost:FrostCuteOne()
end -- End Class Select
