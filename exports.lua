local _, br = ...
local exports =  {
    updateButton = function() br.ui.toggles.mainButton:Click() end;
}
_G.test = exports