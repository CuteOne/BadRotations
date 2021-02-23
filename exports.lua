local _, br = ...
local exports =  {
    updateButton = function() br.mainButton:Click() end;
}
_G.test = exports