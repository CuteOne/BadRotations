local _, br = ...
local exports =  {
    updateButton = function() br.ui.toggles.mainButton:Click() end;
}
-- br.exports: public surface for external tools (e.g. toggle the main button)