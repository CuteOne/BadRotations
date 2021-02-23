local _, br = ...
local exports =  {
    updateButton = function() br.mainButton:Click() end;
    CDs = function() if br.player.ui.mode.cooldown == 2 then br._G.RunMacroText("/br toggle Cooldown 3") else br._G.RunMacroText("/br toggle Cooldown 2") end end;


}
_G.test = exports