local Nn = ...
print("test TP 1")
-- if --[[(...).name ~= "Nn" or]] Nn == nil then return end
-- local read   = Nn.Utils.Storage.read
-- local write  = Nn.Utils.Storage.write
-- local JSON   = Nn.Utils.JSON
-- local AceGUI = Nn.Utils.AceGUI

--Only load BR if in retail 10.2.7 (UI Update); Classic/Cata Not Supported.
-- if select(4,GetBuildInfo()) < 100207 then return end

local toc = ""
local tocPath = '/scripts/BadRotations/BadRotations.toc'
if not FileExists(tocPath) then print(tocPath, 'does not exist') return end
if FileExists(tocPath) then
    toc = ReadFile(tocPath)
else
    print('TOC file does not exist:', tocPath)
end

local br = {}
br.files = {}

-- Resource Files (Image/Font)
br.files[#br.files+1] = {file = 'BadRotations/Libs/!LibDraw/Media/LineTemplate.tga', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/calibrib.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/DejaVuSansMono-Bold.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/DejaVuSansMono.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/DiesalButtonIcons32x128x512.tga', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/DiesalGUIcons16x256x128.tga', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/DiesalGUIcons32x256x256.tga', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/DiesalGUIcons64x256x256.tga', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/FFF Intelligent Thin Condensed.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/FiraMono-Bold.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/FiraMono-Medium.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/FiraMono-Regular.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/FiraSans-Regular.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/Hack-Bold.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/Hack-Regular.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/Inconsolata-Bold.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/Inconsolata-Regular.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/LUCON-.TTF', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/monof55.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/monof56.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/OfficeCodeProp-Bold.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/OfficeCodeProp-Medium.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/OfficeCodeProp-Regular.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/RobotoMono-Bold.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/RobotoMono-Medium.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/RobotoMono-Regular.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/shadow.tga', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/shadowNoDist.tga', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/SourceCodePro-Black.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/SourceCodePro-Bold.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/SourceCodePro-Medium.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/SourceCodePro-Regular.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/SourceCodePro-Semibold.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/Standard0755.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/UbuntuMono-B.ttf', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalStyle-1.0/Media/UbuntuMono-R.ttf', load = true}

LoadFilesFromTOC(toc)

-- Add Lua Files from .toc
function LoadFilesFromTOC(tocFile)
    for line in tocFile:gmatch("([^\n]*)\n?") do
        local thisLine = line:trim()
        if thisLine:find('#') == nil and thisLine:len() > 0
            and thisLine:find('.lua') ~= nil
        then
            thisLine = thisLine:gsub("\\","/")
            thisLine = thisLine:gsub(" ","")
            thisLine = thisLine:gsub(".lua","")
            thisLine = 'BadRotations/'..thisLine
            br.files[#br.files+1] = {
                file = thisLine,
                load = true
            }
            -- Lua Files loaded via XML Files
            if thisLine == "BadRotations/Libs/DiesalStyle-1.0/DiesalStyle-1.0" then
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/DiesalGUI-1.0', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Window', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/ScrollFrame', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/ScrollingEditBox', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/ScrollingMessageFrame', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/CheckBox', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Button', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Spinner', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Input', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Dropdown', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/DropdownItem', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/ComboBox', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/ComboBoxItem', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Accordian', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/AccordianSection', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Tree', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Branch', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalGUI-1.0/Objects/Bar', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalMenu-1.0/DiesalMenu-1.0', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalMenu-1.0/Objects/MenuItem', load = true}
                br.files[#br.files+1] = {file = 'BadRotations/Libs/DiesalMenu-1.0/Objects/Menu', load = true}
            end
        end
    end
end

-- Unlocker Lua Files
br.files[#br.files+1] = {file = 'BadRotations/Unlockers/tinkr', load = false}
br.files[#br.files+1] = {file = 'BadRotations/Unlockers/nn', load = true}
br.files[#br.files+1] = {file = 'BadRotations/Unlockers/daemonic', load = false}

-- Load Files into WoW
for i = 1, #br.files do
    local file = br.files[i].file
    local load = br.files[i].load
	if load then
        Nn:Require('/scripts/'..file, br)
	end
end

-- Call BR Load Function
if UnitExists('player') then
    print "[Nn] Loading BR"
    br.load()
end
print("test TP 2")