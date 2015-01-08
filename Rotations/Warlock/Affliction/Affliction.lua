if select(3, UnitClass("player")) == 9 then
	function WarlockAffliction()
        if currentConfig ~= "Demonology CodeMyLife" then
            DemonologyFunctions()
            DemonologyConfig()
            DemonologyToggles()
            currentConfig = "Demonology CodeMyLife"
        end

        -- localising core functions stuff
        local buff,cd,mode,talent,glyph = core.buff,core.cd,core.mode,core.talent,core.glyph
        if UnitAffectingCombat("player") then
            core:update()
        else
            core:ooc()
        end

        -- Prevent pulse while mounted/eating etc
        if not canRun() then
            return
        end

        -- Pause toggle
        if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") then
            ChatOverlay("|cffFF0000BadBoy Paused", 0)
            return
        end
        -- Focus Toggle
        if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") then
            RunMacroText("/focus mouseover")
        end

        if castingUnit() then
            return false
        end

        -- Health Stone
        core:useHealthStone()

        -- Combat Check
        if UnitAffectingCombat("player") == true then

            -- actions+=/call_action_list,name=single_target,if=active_enemies=1
            if core.mode.aoe == 1 or (core.mode.aoe == 3 and core.activeEnemies == 1) then
                -- Single Rotation
            else
                -- Aoe Rotation



            end
        end
	end
end