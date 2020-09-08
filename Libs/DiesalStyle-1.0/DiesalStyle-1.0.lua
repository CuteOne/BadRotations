-- $Id: DiesalStyle-1.0.lua 61 2017-03-28 23:13:41Z diesal2010 $
local MAJOR, MINOR = "DiesalStyle-1.0", "$Rev: 61 $"
local DiesalStyle, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not DiesalStyle then return end -- No Upgrade needed.
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools = LibStub("DiesalTools-1.0")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")

-- ~~| Lib Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local GetIconCoords, HSL = DiesalTools.GetIconCoords, DiesalTools.HSL
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, select, pairs, tonumber = type, select, pairs, tonumber
local next = next
local format, sub = string.format, string.sub
local min, max = math.min, math.max
-- ~~| WoW Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local errorhandler = geterrorhandler()
-- ~~| DiesalStyle Values |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DiesalStyle.Media = DiesalStyle.Media or {}
DiesalStyle.ReleasedTextures = DiesalStyle.ReleasedTextures or {}
DiesalStyle.TextureFrame = DiesalStyle.TextureFrame or CreateFrame("Frame"); DiesalStyle.TextureFrame:Hide();
DiesalStyle.Colors = DiesalStyle.Colors or {}
DiesalStyle.Formatters = DiesalStyle.Formatters or {}
-- ~~| DiesalStyle UpValues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local AddonName = ...
local ReleasedTextures = DiesalStyle.ReleasedTextures
local TextureFrame = DiesalStyle.TextureFrame
local Media = DiesalStyle.Media
local Colors = DiesalStyle.Colors
local Formatters = DiesalStyle.Formatters
-- ~~| Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local OUTLINES = {'_LEFT','_RIGHT','_TOP','_BOTTOM'}
local MEDIA_PATH = AddonName == 'DiesalLibs' and string.format("Interface\\AddOns\\%s\\%s\\Media\\",AddonName,MAJOR) or string.format("Interface\\AddOns\\%s\\Libs\\%s\\Media\\",AddonName,MAJOR)
local DEFAULT_COLOR = 'FFFFFF'
local DEFAULT_GRADIENT_ORIENTATION = 'horizontal'
local DEFAULT_LAYER = 'ARTWORK'
-- ~~| Local Methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function addMedia(mediaType,name,mediaFile)
  Media[mediaType] = Media[mediaType] or {}
  -- update or create new media entry
  Media[mediaType][name] = MEDIA_PATH..mediaFile
end
local function getMedia(mediaType,name)
  if not Media[mediaType] then error('media type: '..mediaType..' does not exist',2) return end
  if not Media[mediaType][name] then error('media: "'..name..'" does not exist',2) return end
  return Media[mediaType][name]
end
local function newTexture()
  local newTexture = next(ReleasedTextures)
  if not newTexture then
    newTexture = TextureFrame:CreateTexture()
  else
    newTexture:Show()
    ReleasedTextures[newTexture] = nil
  end
  return newTexture
end
local function releaseTexture(texture)
  -- reset texture
  texture:ClearAllPoints()
  texture:SetDrawLayer("ARTWORK", 0)
  -- texture:SetTexCoord(0,1,0,1)
  -- specific order based on testing! for a close as possible full texture reset
  -- texture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)
  -- texture:SetColorTexture(0,0,0,0)
  -- texture:SetTexture()
  -- texture:SetVertexColor(1,1,1,1)

  texture:SetParent(TextureFrame)
  texture:Hide()
  texture.style = nil

  if ReleasedTextures[texture] then error("Attempt to Release a texture that is already released", 2) end
  ReleasedTextures[texture] = true
end
local function round(number, base)
   base = base or 1
   return floor((number + base/2)/base) * base
end
local function GetBlizzColorValues(value)
	if not value then return end

	if type(value) == 'table' and #value >= 3 then
		return value[1]/255, value[2]/255, value[3]/255
	elseif type(value) == 'string' then
		return tonumber(sub(value,1,2),16)/255, tonumber(sub(value,3,4),16)/255, tonumber(sub(value,5,6),16)/255
	end
end
local function formatCoords(coords)
  if type(coords) ~= 'table' then return end

  if #coords == 5 then
    return {GetIconCoords(coords[1],coords[2],coords[3],coords[4],coords[5])}
  else
    return coords
  end
end
local function formatFile(file)
  if type(file) ~= 'string' and type(file) ~= 'number' then return end

  return Media.texture[file] or file
end
local function formatPosition(position)
  if type(position) ~= 'table' and type(position) ~= 'number' then return end

  return type(position) == 'number' and {position,position,position,position} or position
end
local function formatOrientation(orientation)
  if type(orientation) ~= 'string' then return end

  return orientation:upper()
end
local function formatAlpha(alpha)
  if type(alpha) ~= 'table' and type(alpha) ~= 'number' then return end

  return type(alpha) == 'number' and {alpha,alpha} or alpha
end

-- error handling
local function setColor(texture, r, g, b, a)
  local status, err = pcall( texture.SetColorTexture, texture, r, g, b, a )
  if not status then errorhandler('error in "'..(texture.style.name or 'texture')..'" '..texture.style.mode..' or alpha setting',r, g, b, a) end
end
local function setGradient(texture, orientation, r1, g1, b1, a1, r2, g2, b2, a2)
  local status, err = pcall( texture.SetGradientAlpha, texture, orientation, r1, g1, b1, a1, r2, g2, b2, a2 )
  if not status then errorhandler('error in "'..(texture.style.name or 'texture')..'" '..texture.style.mode..' or alpha setting.') end
end
-- ~~| Media |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
do -- | Set Colors |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  do -- google material colors
    Colors.red_50 = 'fde0dc'
    Colors.red_100 = 'f9bdbb'
    Colors.red_200 = 'f69988'
    Colors.red_300 = 'f36c60'
    Colors.red_400 = 'e84e40'
    Colors.red_500 = 'e51c23'
    Colors.red_600 = 'dd191d'
    Colors.red_700 = 'd01716'
    Colors.red_800 = 'c41411'
    Colors.red_900 = 'b0120a'
    Colors.red_A100 = 'FF8A80'
    Colors.red_A200 = 'FF5252'
    Colors.red_A400 = 'FF1744'
    Colors.red_A700 = 'D50000'
    Colors.pink_50 = 'fce4ec'
    Colors.pink_100 = 'f8bbd0'
    Colors.pink_200 = 'f48fb1'
    Colors.pink_300 = 'f06292'
    Colors.pink_400 = 'ec407a'
    Colors.pink_500 = 'e91e63'
    Colors.pink_600 = 'd81b60'
    Colors.pink_700 = 'c2185b'
    Colors.pink_800 = 'ad1457'
    Colors.pink_900 = '880e4f'
    Colors.pink_A100 = 'FF80AB'
    Colors.pink_A200 = 'FF4081'
    Colors.pink_A400 = 'F50057'
    Colors.pink_A700 = 'C51162'
    Colors.purple_50 = 'f3e5f5'
    Colors.purple_100 = 'e1bee7'
    Colors.purple_200 = 'ce93d8'
    Colors.purple_300 = 'ba68c8'
    Colors.purple_400 = 'ab47bc'
    Colors.purple_500 = '9c27b0'
    Colors.purple_600 = '8e24aa'
    Colors.purple_700 = '7b1fa2'
    Colors.purple_800 = '6a1b9a'
    Colors.purple_900 = '4a148c'
    Colors.purple_A100 = 'EA80FC'
    Colors.purple_A200 = 'E040FB'
    Colors.purple_A400 = 'D500F9'
    Colors.purple_A700 = 'AA00FF'
    Colors.dark_purple_50 = 'ede7f6'
    Colors.dark_purple_100 = 'd1c4e9'
    Colors.dark_purple_200 = 'b39ddb'
    Colors.dark_purple_300 = '9575cd'
    Colors.dark_purple_400 = '7e57c2'
    Colors.dark_purple_500 = '673ab7'
    Colors.dark_purple_600 = '5e35b1'
    Colors.dark_purple_700 = '512da8'
    Colors.dark_purple_800 = '4527a0'
    Colors.dark_purple_900 = '311b92'
    Colors.dark_purple_A100 = 'B388FF'
    Colors.dark_purple_A200 = '7C4DFF'
    Colors.dark_purple_A400 = '651FFF'
    Colors.dark_purple_A700 = '6200EA'
    Colors.indigo_50 = 'e8eaf6'
    Colors.indigo_100 = 'c5cae9'
    Colors.indigo_200 = '9fa8da'
    Colors.indigo_300 = '7986cb'
    Colors.indigo_400 = '5c6bc0'
    Colors.indigo_500 = '3f51b5'
    Colors.indigo_600 = '3949ab'
    Colors.indigo_700 = '303f9f'
    Colors.indigo_800 = '283593'
    Colors.indigo_900 = '1a237e'
    Colors.indigo_A100 = '8C9EFF'
    Colors.indigo_A200 = '536DFE'
    Colors.indigo_A400 = '3D5AFE'
    Colors.indigo_A700 = '304FFE'
    Colors.blue_50 = 'e7e9fd'
    Colors.blue_100 = 'd0d9ff'
    Colors.blue_200 = 'afbfff'
    Colors.blue_300 = '91a7ff'
    Colors.blue_400 = '738ffe'
    Colors.blue_500 = '5677fc'
    Colors.blue_600 = '4e6cef'
    Colors.blue_700 = '455ede'
    Colors.blue_800 = '3b50ce'
    Colors.blue_900 = '2a36b1'
    Colors.blue_A100 = '82B1FF'
    Colors.blue_A200 = '448AFF'
    Colors.blue_A400 = '2979FF'
    Colors.blue_A700 = '2962FF'
    Colors.light_blue_50 = 'e1f5fe'
    Colors.light_blue_100 = 'b3e5fc'
    Colors.light_blue_200 = '81d4fa'
    Colors.light_blue_300 = '4fc3f7'
    Colors.light_blue_400 = '29b6f6'
    Colors.light_blue_500 = '03a9f4'
    Colors.light_blue_600 = '039be5'
    Colors.light_blue_700 = '0288d1'
    Colors.light_blue_800 = '0277bd'
    Colors.light_blue_900 = '01579b'
    Colors.light_blue_A100 = '80D8FF'
    Colors.light_blue_A200 = '40C4FF'
    Colors.light_blue_A400 = '00B0FF'
    Colors.light_blue_A700 = '0091EA'
    Colors.cyan_50 = 'e0f7fa'
    Colors.cyan_100 = 'b2ebf2'
    Colors.cyan_200 = '80deea'
    Colors.cyan_300 = '4dd0e1'
    Colors.cyan_400 = '26c6da'
    Colors.cyan_500 = '00bcd4'
    Colors.cyan_600 = '00acc1'
    Colors.cyan_700 = '0097a7'
    Colors.cyan_800 = '00838f'
    Colors.cyan_900 = '006064'
    Colors.cyan_A100 = '84FFFF'
    Colors.cyan_A200 = '18FFFF'
    Colors.cyan_A400 = '00E5FF'
    Colors.cyan_A700 = '00B8D4'
    Colors.teal_50 = 'e0f2f1'
    Colors.teal_100 = 'b2dfdb'
    Colors.teal_200 = '80cbc4'
    Colors.teal_300 = '4db6ac'
    Colors.teal_400 = '26a69a'
    Colors.teal_500 = '009688'
    Colors.teal_600 = '00897b'
    Colors.teal_700 = '00796b'
    Colors.teal_800 = '00695c'
    Colors.teal_900 = '004d40'
    Colors.teal_A100 = 'A7FFEB'
    Colors.teal_A200 = '64FFDA'
    Colors.teal_A400 = '1DE9B6'
    Colors.teal_A700 = '00BFA5'
    Colors.green_50 = 'd0f8ce'
    Colors.green_100 = 'a3e9a4'
    Colors.green_200 = '72d572'
    Colors.green_300 = '42bd41'
    Colors.green_400 = '2baf2b'
    Colors.green_500 = '4CAF50'
    Colors.green_600 = '0a8f08'
    Colors.green_700 = '0a7e07'
    Colors.green_800 = '056f00'
    Colors.green_900 = '0d5302'
    Colors.green_A100 = 'B9F6CA'
    Colors.green_A200 = '69F0AE'
    Colors.green_A400 = '00E676'
    Colors.green_A700 = '00C853'
    Colors.light_green_50 = 'f1f8e9'
    Colors.light_green_100 = 'dcedc8'
    Colors.light_green_200 = 'c5e1a5'
    Colors.light_green_300 = 'aed581'
    Colors.light_green_400 = '9ccc65'
    Colors.light_green_500 = '8bc34a'
    Colors.light_green_600 = '7cb342'
    Colors.light_green_700 = '689f38'
    Colors.light_green_800 = '558b2f'
    Colors.light_green_900 = '33691e'
    Colors.light_green_A100 = 'CCFF90'
    Colors.light_green_A200 = 'B2FF59'
    Colors.light_green_A400 = '76FF03'
    Colors.light_green_A700 = '64DD17'
    Colors.lime_50 = 'f9fbe7'
    Colors.lime_100 = 'f0f4c3'
    Colors.lime_200 = 'e6ee9c'
    Colors.lime_300 = 'dce775'
    Colors.lime_400 = 'd4e157'
    Colors.lime_500 = 'cddc39'
    Colors.lime_600 = 'c0ca33'
    Colors.lime_700 = 'afb42b'
    Colors.lime_800 = '9e9d24'
    Colors.lime_900 = '827717'
    Colors.lime_A100 = 'F4FF81'
    Colors.lime_A200 = 'EEFF41'
    Colors.lime_A400 = 'C6FF00'
    Colors.lime_A700 = 'AEEA00'
    Colors.yellow_50 = 'fffde7'
    Colors.yellow_100 = 'fff9c4'
    Colors.yellow_200 = 'fff59d'
    Colors.yellow_300 = 'fff176'
    Colors.yellow_400 = 'ffee58'
    Colors.yellow_500 = 'ffeb3b'
    Colors.yellow_600 = 'fdd835'
    Colors.yellow_700 = 'fbc02d'
    Colors.yellow_800 = 'f9a825'
    Colors.yellow_900 = 'f57f17'
    Colors.yellow_A100 = 'FFFF8D'
    Colors.yellow_A200 = 'FFFF00'
    Colors.yellow_A400 = 'FFEA00'
    Colors.yellow_A700 = 'FFD600'
    Colors.amber_50 = 'fff8e1'
    Colors.amber_100 = 'ffecb3'
    Colors.amber_200 = 'ffe082'
    Colors.amber_300 = 'ffd54f'
    Colors.amber_400 = 'ffca28'
    Colors.amber_500 = 'ffc107'
    Colors.amber_600 = 'ffb300'
    Colors.amber_700 = 'ffa000'
    Colors.amber_800 = 'ff8f00'
    Colors.amber_900 = 'ff6f00'
    Colors.amber_A100 = 'FFE57F'
    Colors.amber_A200 = 'FFD740'
    Colors.amber_A400 = 'FFC400'
    Colors.amber_A700 = 'FFAB00'
    Colors.orange_50 = 'fff3e0'
    Colors.orange_100 = 'ffe0b2'
    Colors.orange_200 = 'ffcc80'
    Colors.orange_300 = 'ffb74d'
    Colors.orange_400 = 'ffa726'
    Colors.orange_500 = 'ff9800'
    Colors.orange_600 = 'fb8c00'
    Colors.orange_700 = 'f57c00'
    Colors.orange_800 = 'ef6c00'
    Colors.orange_900 = 'e65100'
    Colors.orange_A100 = 'FFD180'
    Colors.orange_A200 = 'FFAB40'
    Colors.orange_A400 = 'FF9100'
    Colors.orange_A700 = 'FF6D00'
    Colors.deep_orange_50 = 'fbe9e7'
    Colors.deep_orange_100 = 'ffccbc'
    Colors.deep_orange_200 = 'ffab91'
    Colors.deep_orange_300 = 'ff8a65'
    Colors.deep_orange_400 = 'ff7043'
    Colors.deep_orange_500 = 'ff5722'
    Colors.deep_orange_600 = 'f4511e'
    Colors.deep_orange_700 = 'e64a19'
    Colors.deep_orange_800 = 'd84315'
    Colors.deep_orange_900 = 'bf360c'
    Colors.deep_orange_A100 = 'FF9E80'
    Colors.deep_orange_A200 = 'FF6E40'
    Colors.deep_orange_A400 = 'FF3D00'
    Colors.deep_orange_A700 = 'DD2C00'
    Colors.brown_50 = 'efebe9'
    Colors.brown_100 = 'd7ccc8'
    Colors.brown_200 = 'bcaaa4'
    Colors.brown_300 = 'a1887f'
    Colors.brown_400 = '8d6e63'
    Colors.brown_500 = '795548'
    Colors.brown_600 = '6d4c41'
    Colors.brown_700 = '5d4037'
    Colors.brown_800 = '4e342e'
    Colors.brown_900 = '3e2723'
    Colors.gray_50 = 'fafafa'
    Colors.gray_100 = 'f5f5f5'
    Colors.gray_200 = 'eee'
    Colors.gray_300 = 'e0e0e0'
    Colors.gray_400 = 'bdbdbd'
    Colors.gray_500 = '9e9e9e'
    Colors.gray_600 = '757575'
    Colors.gray_700 = '616161'
    Colors.gray_800 = '424242'
    Colors.gray_900 = '212121'
    Colors.blue_gray_50 = 'eceff1'
    Colors.blue_gray_100 = 'cfd8dc'
    Colors.blue_gray_200 = 'b0bec5'
    Colors.blue_gray_300 = '90a4ae'
    Colors.blue_gray_400 = '78909c'
    Colors.blue_gray_500 = '607d8b'
    Colors.blue_gray_600 = '546e7a'
    Colors.blue_gray_700 = '455a64'
    Colors.blue_gray_800 = '37474f'
    Colors.blue_gray_900 = '263238'
  end
  do -- Base UI Colors

    Colors.UI_Hue = 210
    Colors.UI_Saturation = .24

    Colors.UI_TEXT      = HSL(Colors.UI_Hue,Colors.UI_Saturation,.9)


    -- level 1
    Colors.UI_100       = HSL(Colors.UI_Hue,Colors.UI_Saturation,.03) -- BG
    Colors.UI_150       = HSL(Colors.UI_Hue,Colors.UI_Saturation,.05)
    -- level 2
    Colors.UI_200       = HSL(Colors.UI_Hue,Colors.UI_Saturation,.07)
    -- level 3
    Colors.UI_300       = HSL(Colors.UI_Hue,Colors.UI_Saturation,.12)
    Colors.UI_300_GR    = {HSL(Colors.UI_Hue,Colors.UI_Saturation,.12),HSL(Colors.UI_Hue,Colors.UI_Saturation,.11)}
    Colors.UI_350       = HSL(Colors.UI_Hue,Colors.UI_Saturation,.15)
    Colors.UI_350_GR    = {HSL(Colors.UI_Hue,Colors.UI_Saturation,.17),HSL(Colors.UI_Hue,Colors.UI_Saturation,.14)}
    -- level 4
    Colors.UI_400       = HSL(Colors.UI_Hue,Colors.UI_Saturation,.20)
    Colors.UI_400_GR    = {HSL(Colors.UI_Hue,Colors.UI_Saturation,.20),HSL(Colors.UI_Hue,Colors.UI_Saturation,.17)}
    Colors.UI_450_GR    = {HSL(Colors.UI_Hue,Colors.UI_Saturation,.24),HSL(Colors.UI_Hue,Colors.UI_Saturation,.20)}
    -- level 5
    Colors.UI_500       = HSL(Colors.UI_Hue,Colors.UI_Saturation,.29)
    Colors.UI_500_GR    = {HSL(Colors.UI_Hue,Colors.UI_Saturation,.29),HSL(Colors.UI_Hue,Colors.UI_Saturation,.26)}

    Colors.UI_600_GR    = {HSL(Colors.UI_Hue,Colors.UI_Saturation,.35),HSL(Colors.UI_Hue,Colors.UI_Saturation,.32)}

    -- font Colors -35
    Colors.UI_F450      = HSL(Colors.UI_Hue,Colors.UI_Saturation,.75)
    Colors.UI_F350      = HSL(Colors.UI_Hue,Colors.UI_Saturation,.60)

    Colors.UI_1000      = HSL(Colors.UI_Hue,Colors.UI_Saturation,1)

    Colors.UI_A900      = HSL(Colors.UI_Hue,1,.7)
    Colors.UI_A800      = HSL(Colors.UI_Hue,1,.65)
    Colors.UI_A700      = HSL(Colors.UI_Hue,1,.6)
    Colors.UI_A600      = HSL(Colors.UI_Hue,1,.55)
    Colors.UI_A500      = HSL(Colors.UI_Hue,1,.5)
    Colors.UI_A400      = HSL(Colors.UI_Hue,1,.45)
    Colors.UI_A300      = HSL(Colors.UI_Hue,1,.4)
    Colors.UI_A200      = HSL(Colors.UI_Hue,1,.35)
    Colors.UI_A100      = HSL(Colors.UI_Hue,1,.3)
  end
end
do -- | Text Formatters |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Formatters.tooltip = '|cff'..Colors.gray_50..'%s\n|cff'..Colors.yellow_500..'%s'

end
do -- | Set Media |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  addMedia('font','calibrib','calibrib.ttf')
  -- monospaced
  addMedia('font','DejaVuSansMono','DejaVuSansMono.ttf')
  addMedia('font','DejaVuSansMonoBold','DejaVuSansMono-Bold.ttf')

  addMedia('font','FiraMonoMedium','FiraMono-Medium.ttf')
  addMedia('font','FiraMonoRegular','FiraMono-Regular.ttf')
  addMedia('font','FiraMonoBold','FiraMono-Bold.ttf')

  addMedia('font','HackRegular','Hack-Regular.ttf')
  addMedia('font','HackBold','Hack-Bold.ttf')

  addMedia('font','InconsolataRegular','Inconsolata-Regular.ttf')
  addMedia('font','InconsolataBold','Inconsolata-Bold.ttf')

  addMedia('font','LucidiaMono','LUCON.ttf')

  addMedia('font','MonoFur','monof55.ttf')
  addMedia('font','MonoFurItalic','monof56.ttf')

  addMedia('font','OfficeCodeProRegular','OfficeCodePro-Regular.ttf')
  addMedia('font','OfficeCodeProMedium','OfficeCodePro-Medium.ttf')
  addMedia('font','OfficeCodeProBold','OfficeCodePro-Bold.ttf')

  addMedia('font','RobotoMonoRegular','RobotoMono-Regular.ttf')
  addMedia('font','RobotoMonoMedium','RobotoMono-Medium.ttf')
  addMedia('font','RobotoMonoBold','RobotoMono-Bold.ttf')

  addMedia('font','SourceCodeProRegular','SourceCodePro-Regular.ttf')
  addMedia('font','SourceCodeProMedium','SourceCodePro-Medium.ttf')
  addMedia('font','SourceCodeProSemibold','SourceCodePro-Semibold.ttf')
  addMedia('font','SourceCodeProBold','SourceCodePro-Bold.ttf')
  addMedia('font','SourceCodeProBlack','SourceCodePro-Black.ttf')

  addMedia('font','UbuntuMonoBold','UbuntuMono-B.ttf')
  addMedia('font','UbuntuMonoRegular','UbuntuMono-R.ttf')

  -- pixel fonts
  addMedia('font','FiraSans','FiraSans-Regular.ttf')
  addMedia('font','Standard0755','Standard0755.ttf')
  addMedia('font','FFF Intelligent Thin Condensed','FFF Intelligent Thin Condensed.ttf')
  addMedia('texture','DiesalGUIcons','DiesalGUIcons16x256x128.tga')
  addMedia('texture','DiesalGUIcons64','DiesalGUIcons64x256x256.tga')
  addMedia('texture','DiesalGUIcons32','DiesalGUIcons32x256x256.tga')
  addMedia('texture','DiesalButtonIcons32','DiesalButtonIcons32x128x512.tga')
  addMedia('border','shadow','shadow.tga')
  addMedia('border','shadowNoDist','shadowNoDist.tga')
end
do -- | Add LibSharedMedia |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  LibSharedMedia:Register("font","Calibri Bold",getMedia('font','calibrib'))
  LibSharedMedia:Register("font","Fira Sans",getMedia('font','FiraSans'))
  -- monospaced
  -- LibSharedMedia:Register("font","DejaVuSansMono",getMedia('font','DejaVuSansMono'))
  -- LibSharedMedia:Register("font","Hack",getMedia('font','Hack'))
  -- LibSharedMedia:Register("font","Inconsolata",getMedia('font','Inconsolata'))
  -- LibSharedMedia:Register("font","Fira Sans",getMedia('font','FiraSans'))
  -- LibSharedMedia:Register("font","Source Code Pro",getMedia('font','SourceCodePro'))
  -- pixel fonts
  LibSharedMedia:Register("font","Standard0755",getMedia('font','Standard0755'))
  LibSharedMedia:Register("font","FFF Intelligent",getMedia('font','FFF Intelligent Thin Condensed'))
end
do -- | Set Fonts |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  CreateFont("DiesalFontNormal")
  DiesalFontNormal:SetFont( getMedia('font','calibrib'),11 )
  CreateFont("DiesalFontPixel")
  DiesalFontPixel:SetFont( getMedia('font','Standard0755'), 8 )
  CreateFont("DiesalFontPixelOutLine")
  DiesalFontPixelOutLine:SetFont( getMedia('font','Standard0755'), 8, "OUTLINE, MONOCHROME" )
  DiesalFontPixelOutLine:SetSpacing(2)
  CreateFont("DiesalFontPixel2")
  DiesalFontPixel2:SetFont( getMedia('font','FFF Intelligent Thin Condensed'), 8, "OUTLINE, MONOCHROME" )
end
-- ~~| DiesalStyle API |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--[[ Texture style table format
style.layer BACKGROUND | BORDER | ARTWORK | OVERLAY | HIGHLIGHT (texture in this layer is automatically shown when the mouse is over the containing Frame)
**FontStrings always appear on top of all textures in a given draw layer. avoid using sublayer
-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
style.alpha alpha [0 - 1]
style.alphaEnd alpha [0 - 1]
style.color hexColor | {Red, Green, Blue} [0-255]
style.colorEnd hexColor | {Red, Green, Blue} [0-255]
style.gradient VERTICAL | HORIZONTAL
-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
style.texFile texture fileName
style.texTile true | false
style.texCoord {left, right, top, bottom} [0-1] | {column,row,size,textureWidth,TextureHeight}
style.texColor hexColor | {Red,Green,Blue} [0-255]
style.texColorAlpha alpha [0 - 1]
-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
style.offset offset | {Left, Right, Top, Bottom}
style.width width
style.height height
]]


-- type                 = 'fill',
-- layer                = 'BACKGROUND',
--
-- gradient             = {'VERTICAL','744d00','996600'}
-- gradient_orientation = 'VERTICAL'|'HORIZONTAL ',
-- gradient_color       = {colorStart,colorEnd},
--
-- image                = {'texture-file', {left,right,top,bottom}, color, tiling_h, tiling_v}
-- image_file           = 'texture-file'
-- image_coords         = {left,right,top,bottom} | {row, coloumn, size, image width, image height }
-- image_color          = "FFFFFF"
-- image_tiling         = {'HORIZNONTAL','VERTICAL'}
--
-- color                = 'FFFFFF',
-- alpha                = 1 | {1,1}
--
-- position             = 0 | {0,0,0,0}

function DiesalStyle:StyleTexture(texture,style)
  -- | Setup Texture.style |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if not texture.style or style.clear then texture.style = {} end
  -- debugging
  texture.style.name  = style.name  or texture.style.name
  texture.style.debug = style.debug or texture.style.debug
  -- | Format Settings |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -- Gradient ~~~~~~~~~~~~~~~~~~~~~~~~~
  if style.gradient and type(style.gradient) == 'table' then
    texture.style.gradient = {
      orientation = formatOrientation(style.gradient[1]),
      color = style.gradient[2] and style.gradient[3] and {style.gradient[2],style.gradient[3]},
    }
  end
  style.gradient_orientation = formatOrientation(style.gradient_orientation) -- fuck you
  if not texture.style.gradient and (style.gradient_orientation or style.gradient_alpha or style.gradient_color) then texture.style.gradient = {} end
  -- Image ~~~~~~~~~~~~~~~~~~~~~~~~~
  if style.image and type(style.image) == 'table' then
    texture.style.image = {
      file = formatFile(style.image[1]),
      coords = formatCoords(style.image[2]),
      color = style.image[3],
      tiling = {style.image[4],style.image[5]},
    }
  end
  if not texture.style.image and style.image_file then texture.style.image = {} end
  -- | Update Settings |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  texture.style.layer                  = style.layer                      or texture.style.layer                or DEFAULT_LAYER
  texture.style.position               = formatPosition(style.position)   or texture.style.position             or {0,0,0,0}
  texture.style.width                  = style.width                      or texture.style.width
  texture.style.height                 = style.height                     or texture.style.height
  texture.style.color                  = style.color                      or texture.style.color
  texture.style.alpha                  = formatAlpha(style.alpha)         or texture.style.alpha                or {1,1}
  -- gradient
  if texture.style.gradient then
    texture.style.gradient.orientation = style.gradient_orientation       or texture.style.gradient.orientation or DEFAULT_GRADIENT_ORIENTATION
    texture.style.gradient.color       = style.gradient_color             or texture.style.gradient.color       or {DEFAULT_COLOR,DEFAULT_COLOR}
  end
  -- image
  if texture.style.image then
    texture.style.image.file           = formatFile(style.image_file)     or texture.style.image.file
    texture.style.image.coords         = formatCoords(style.image_coords) or texture.style.image.coords         or {0,1,0,1}
    texture.style.image.color          = style.image_color                or texture.style.image.color
    texture.style.image.tiling         = style.image_tiling               or texture.style.image.tiling
  end
  -- | Apply Settings |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  -- layer
  texture:SetDrawLayer(texture.style.layer, 0)
  -- position
  texture:ClearAllPoints() -- clear offsets
  if texture.style.position[1] then texture:SetPoint("LEFT", -texture.style.position[1],0) end
  if texture.style.position[2] then texture:SetPoint("RIGHT", texture.style.position[2],0) end
  if texture.style.position[3] then texture:SetPoint("TOP", 0,texture.style.position[3]) end
  if texture.style.position[4] then texture:SetPoint("BOTTOM", 0,-texture.style.position[4]) end
  -- size
  if texture.style.width  then texture:SetWidth(texture.style.width) end
  if texture.style.height then texture:SetHeight(texture.style.height) end

  if style.debug then print(texture:GetHeight(),texture.style.position[1], texture.style.position[2], texture.style.position[3], texture.style.position[4]) end
  -- [1] Texture > [2] gradient > [3] color
  if texture.style.image then -- [1] Texture
    -- set mode
    texture.style.mode = 'image'
    -- clear any old settings
    texture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1) -- clear gradient
    texture:SetColorTexture(1,1,1,1) -- clear color
    -- apply settings
    texture:SetTexCoord(texture.style.image.coords[1],texture.style.image.coords[2],texture.style.image.coords[3],texture.style.image.coords[4])
    texture:SetTexture(texture.style.image.file,texture.style.image.tiling and texture.style.image.tiling[1], texture.style.image.tiling and texture.style.image.tiling[2])
    texture:SetHorizTile(texture.style.image.tiling[1])
    texture:SetVertTile(texture.style.image.tiling[2])
    local r,g,b = GetBlizzColorValues(texture.style.image.color)
    texture:SetVertexColor(r or 1, g or 1, b or 1, texture.style.alpha[1])
  elseif texture.style.gradient then -- [2] gradient
    -- set mode
    texture.style.mode = 'gradient'
    -- clear any old  settings
    texture:SetTexture() -- clear image
    texture:SetColorTexture(1,1,1,1) -- clear color
    -- apply settings
    local r1,g1,b1 = GetBlizzColorValues(texture.style.gradient.color[texture.style.gradient.orientation == 'HORIZONTAL' and 1 or 2])
    local r2,g2,b2 = GetBlizzColorValues(texture.style.gradient.color[texture.style.gradient.orientation == 'HORIZONTAL' and 2 or 1])
    local a1,a2    = texture.style.alpha[texture.style.gradient.orientation == 'HORIZONTAL' and 1 or 2], texture.style.alpha[texture.style.gradient.orientation == 'HORIZONTAL' and 2 or 1]
    setGradient(texture, texture.style.gradient.orientation, r1, g1, b1, a1, r2, g2, b2, a2)
  elseif texture.style.color then -- [3] color
    -- set mode
    texture.style.mode = 'color'
    -- clear any old settings
    texture:SetTexture() -- clear image
    texture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1) -- clear gradient
    -- apply settings
    local r,g,b = GetBlizzColorValues(texture.style.color)
    setColor(texture, r, g, b, texture.style.alpha[1])
  else
    -- set mode
    texture.style.mode = 'none!'
    -- clear the texture
    texture:SetTexture() -- clear image
    texture:SetGradientAlpha('HORIZONTAL',0,0,0,0,0,0,0,0) -- clear gradient
    texture:SetColorTexture(0,0,0,0) -- clear color
  end
end

function DiesalStyle:StyleOutline(leftTexture,rightTexture,topTexture,bottomTexture,style)
  -- | Setup Texture.style |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if not leftTexture.style or style.clear then leftTexture.style = {}; rightTexture.style = leftTexture.style; topTexture.style = leftTexture.style; bottomTexture.style = leftTexture.style end
  local texture = leftTexture
  -- debugging
  texture.style.name  = style.name  or texture.style.name
  texture.style.debug = style.debug or texture.style.debug
  -- | Format Settings |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if style.gradient and type(style.gradient) == 'table' then
    texture.style.gradient = {
      orientation = formatOrientation(style.gradient[1]),
      color = style.gradient[2] and style.gradient[3] and {style.gradient[2],style.gradient[3]},
    }
  end
  style.gradient_orientation = formatOrientation(style.gradient_orientation) -- fuck you
  if not texture.style.gradient and (style.gradient_orientation or style.gradient_alpha or style.gradient_color) then texture.style.gradient = {} end
  -- | Update Settings |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  texture.style.layer                  = style.layer                      or texture.style.layer                or DEFAULT_LAYER
  texture.style.position               = formatPosition(style.position)   or texture.style.position             or {0,0,0,0}
  texture.style.width                  = style.width                      or texture.style.width
  texture.style.height                 = style.height                     or texture.style.height
  texture.style.color                  = style.color                      or texture.style.color
  texture.style.alpha                  = formatAlpha(style.alpha)         or texture.style.alpha                or {1,1}
  -- gradient
  if texture.style.gradient then
    texture.style.gradient.orientation = style.gradient_orientation       or texture.style.gradient.orientation or DEFAULT_GRADIENT_ORIENTATION
    texture.style.gradient.color       = style.gradient_color             or texture.style.gradient.color       or {DEFAULT_COLOR,DEFAULT_COLOR}
  end
  -- | Apply Settings |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  -- layer
  leftTexture:SetDrawLayer(texture.style.layer, 0)
  rightTexture:SetDrawLayer(texture.style.layer, 0)
  topTexture:SetDrawLayer(texture.style.layer, 0)
  bottomTexture:SetDrawLayer(texture.style.layer, 0)
  -- position
  leftTexture:ClearAllPoints()
  rightTexture:ClearAllPoints()
  topTexture:ClearAllPoints()
  bottomTexture:ClearAllPoints()

  if texture.style.position [1] then leftTexture:SetPoint("LEFT", -texture.style.position [1],0)
  else                               leftTexture:SetPoint("RIGHT", -texture.style.width,0) end
  if texture.style.position [3] then leftTexture:SetPoint("TOP", 0,texture.style.position [3]) end
  if texture.style.position [4] then leftTexture:SetPoint("BOTTOM", 0,-texture.style.position [4]) end
  if texture.style.position [2] then rightTexture:SetPoint("RIGHT", texture.style.position [2],0)
  else                               rightTexture:SetPoint("LEFT", texture.style.width-(texture.style.position [1]+1),0) end
  if texture.style.position [3] then rightTexture:SetPoint("TOP", 0,texture.style.position [3]) end
  if texture.style.position [4] then rightTexture:SetPoint("BOTTOM", 0,-texture.style.position [4]) end
  if texture.style.position [1] then topTexture:SetPoint("LEFT", -texture.style.position [1]+1,0) end
  if texture.style.position [2] then topTexture:SetPoint("RIGHT", (texture.style.position [2])-1,0) end
  if texture.style.position [3] then topTexture:SetPoint("TOP", 0,texture.style.position [3])
  else                               topTexture:SetPoint("BOTTOM", 0,texture.style.height-1) end
  if texture.style.position [1] then bottomTexture:SetPoint("LEFT", -texture.style.position [1]+1,0) end
  if texture.style.position [2] then bottomTexture:SetPoint("RIGHT", texture.style.position [2]-1,0) end
  if texture.style.position [4] then bottomTexture:SetPoint("BOTTOM", 0,-texture.style.position [4])
  else                               bottomTexture:SetPoint("TOP", 0,-(texture.style.height+1)+(texture.style.position [3]+2)) end
  -- size
  leftTexture:SetWidth(1)
  if texture.style.height then leftTexture:SetHeight(texture.style.height) end
  rightTexture:SetWidth(1)
  if texture.style.height then rightTexture:SetHeight(texture.style.height) end
  topTexture:SetHeight(1)
  if texture.style.width then topTexture:SetWidth(texture.style.width-2) end
  bottomTexture:SetHeight(1)
  if texture.style.width then bottomTexture:SetWidth(texture.style.width-2) end
  -- texture
  if texture.style.gradient then
    -- set mode
    texture.style.mode = 'gradient'
    -- clear any old  settings
    leftTexture:SetTexture() -- clear image
    -- leftTexture:SetAlpha(1) -- reset alpha
    rightTexture:SetTexture() -- clear image
    -- rightTexture:SetAlpha(1) -- reset alpha
    topTexture:SetTexture() -- clear image
    -- topTexture:SetAlpha(1) -- reset alpha
    bottomTexture:SetTexture() -- clear image
    -- bottomTexture:SetAlpha(1) -- reset alpha

    local r1,g1,b1,r2,g2,b2,a1,a2

    if texture.style.gradient.orientation == 'HORIZONTAL' then
      -- clear settings
      leftTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)
      rightTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)
      topTexture:SetColorTexture(1,1,1,1) -- clear color
      bottomTexture:SetColorTexture(1,1,1,1) -- clear color

      -- aply settings
      r1,g1,b1 = GetBlizzColorValues(texture.style.gradient.color[1])
      r2,g2,b2 = GetBlizzColorValues(texture.style.gradient.color[2])
      a1,a2    = texture.style.alpha[1], texture.style.alpha[2]

      setColor( leftTexture,  r1,g1,b1,a1 )
      setColor( rightTexture, r2,g2,b2,a2 )
      setGradient(topTexture,   'HORIZONTAL', r1, g1, b1, a1, r2, g2, b2, a2)
      setGradient(bottomTexture,'HORIZONTAL', r1, g1, b1, a1, r2, g2, b2, a2)
    elseif texture.style.gradient.orientation == 'VERTICAL' then
      -- clear settings
      leftTexture:SetColorTexture(1,1,1,1) -- clear color
      rightTexture:SetColorTexture(1,1,1,1) -- clear color
      topTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)
      bottomTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)

      -- aply settings
      r1,g1,b1 = GetBlizzColorValues(texture.style.gradient.color[2])
      r2,g2,b2 = GetBlizzColorValues(texture.style.gradient.color[1])
      a1,a2    = texture.style.alpha[2], texture.style.alpha[1]

      setColor( topTexture,    r2,g2,b2,a2 )
      setColor( bottomTexture, r1,g1,b1,a1 )
      setGradient(leftTexture,  'VERTICAL', r1, g1, b1, a1, r2, g2, b2, a2)
      setGradient(rightTexture, 'VERTICAL', r1, g1, b1, a1, r2, g2, b2, a2)
    else
      texture.style.mode = 'gradient: no orientation!'
      -- should never be here
    end
  elseif texture.style.color then
    -- set mode
    texture.style.mode = 'color'
    -- clear any old settings
    leftTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)
    rightTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)
    topTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)
    bottomTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)
    -- apply settings
    local r,g,b = GetBlizzColorValues(texture.style.color)

    setColor( leftTexture,   r,g,b,texture.style.alpha[1] )
    setColor( rightTexture,  r,g,b,texture.style.alpha[1] )
    setColor( topTexture,    r,g,b,texture.style.alpha[1] )
    setColor( bottomTexture, r,g,b,texture.style.alpha[1] )
  else
    -- set mode
    texture.style.mode = 'none!'
    -- clear the texture
    leftTexture:SetTexture() -- clear image
    leftTexture:SetGradientAlpha('HORIZONTAL',0,0,0,0,0,0,0,0) -- clear gradient
    leftTexture:SetColorTexture(0,0,0,0) -- clear color
    rightTexture:SetTexture() -- clear image
    rightTexture:SetGradientAlpha('HORIZONTAL',0,0,0,0,0,0,0,0) -- clear gradient
    rightTexture:SetColorTexture(0,0,0,0) -- clear color
    topTexture:SetTexture() -- clear image
    topTexture:SetGradientAlpha('HORIZONTAL',0,0,0,0,0,0,0,0) -- clear gradient
    topTexture:SetColorTexture(0,0,0,0) -- clear color
    bottomTexture:SetTexture() -- clear image
    bottomTexture:SetGradientAlpha('HORIZONTAL',0,0,0,0,0,0,0,0) -- clear gradient
    bottomTexture:SetColorTexture(0,0,0,0) -- clear color
  end
end


function DiesalStyle:StyleShadow(object,frame,style)
  object.shadow = object.shadow or CreateFrame("Frame",nil,frame,BackdropTemplateMixin and "BackdropTemplate") --CreateFrame("Frame",nil,frame) 
  object.shadow:Show()
  if not object.shadow.style or style.clear then object.shadow.style = {} end
  local shadowStyle = object.shadow.style
  -- ~~ Format New Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  local red,green,blue = DiesalTools.GetColor(style.color)
  local offset = style.offset and type(style.offset)=='number' and {style.offset,style.offset,style.offset,style.offset} or style.offset
  -- Setting ~~~~~~~~~~~~~~~~~~~~~~~ New Setting ~~~~~~~~~~~~~~~ Old Setting ~~~~~~~~~~~~~~~~~ Default ~~~~~~~~~~~~~~~~~~
  shadowStyle.edgeFile = style.edgeFile or shadowStyle.edgeFile or getMedia('border','shadow')
  shadowStyle.edgeSize = style.edgeSize or shadowStyle.edgeSize or 28

  shadowStyle.red = red or shadowStyle.red or 0
  shadowStyle.green = green or shadowStyle.green or 0
  shadowStyle.blue = blue or shadowStyle.blue or 0
  shadowStyle.alpha = style.alpha or shadowStyle.alpha or .45

  shadowStyle.offset = offset or shadowStyle.offset or {20,20,20,20}
  -- ~~ Apply Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if shadowStyle.offset[1] then object.shadow:SetPoint("LEFT", -shadowStyle.offset[1],0) end
  if shadowStyle.offset[2] then object.shadow:SetPoint("RIGHT", shadowStyle.offset[2],0) end
  if shadowStyle.offset[3] then object.shadow:SetPoint("TOP", 0,shadowStyle.offset[3]) end
  if shadowStyle.offset[4] then object.shadow:SetPoint("BOTTOM", 0,-shadowStyle.offset[4]) end

  object.shadow:SetBackdrop({ edgeFile = shadowStyle.edgeFile, edgeSize = shadowStyle.edgeSize })
  object.shadow:SetBackdropBorderColor(shadowStyle.red, shadowStyle.green, shadowStyle.blue, shadowStyle.alpha)
end
--[[ Font style table format
TODO style.offset ( offset|{ Left, Right, Top, Bottom })
TODO style.width ( width )
TODO style.height ( height )

style.font ( Path to a font file )
style.fontSize ( Size (point size) of the font to be displayed (in pixels) )
style.flags ( Additional properties specified by one or more of the following tokens: MONOCHROME, OUTLINE | THICKOUTLINE ) (comma delimitered string)
style.alpha ( alpha )
style.color ( hexColor|{ Red, Green, Blue } [0-255])
style.lineSpacing ( number - Sets the font instance's amount of spacing between lines)
]]
function DiesalStyle:StyleFont(fontInstance,name,style)
  local filename, fontSize, flags = fontInstance:GetFont()
  local red,green,blue,alpha = fontInstance:GetTextColor()
  local lineSpacing = fontInstance:GetSpacing()
   -- Fallback to DiesalFontNormal for Patch 8.1
   if not filename then 
    filename, fontSize, flags = DiesalFontNormal:GetFont()
    red,green,blue,alpha = DiesalFontNormal:GetTextColor()
    lineSpacing = DiesalFontNormal:GetSpacing()
  end
  style.red, style.green, style.blue = DiesalTools.GetColor(style.color)
  -- ~~ Set Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  style.filename = style.filename or filename
  style.fontSize = style.fontSize or fontSize
  style.flags = style.flags or flags

  style.red = style.red or red
  style.green = style.green or green
  style.blue = style.blue or blue
  style.alpha = style.alpha or alpha
  style.lineSpacing = style.lineSpacing or lineSpacing
  -- ~~ Apply Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  fontInstance:SetFont( style.filename, style.fontSize, style.flags )
  fontInstance:SetTextColor(style.red, style.green, style.blue, style.alpha)
  fontInstance:SetSpacing(style.lineSpacing)

  fontInstance.style = style
end

function DiesalStyle:UpdateObjectStyle(object,name,style)
  if not style or type(style) ~='table' then return end
  if type(name) ~='string' then return end
  -- ~~ Clear Texture ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if style.clear then
    -- clear texture
    if object.textures[name] then DiesalStyle:ReleaseTexture(object,name) end
    -- clear OUTLINE
    for i=1, #OUTLINES do
      if object.textures[name..OUTLINES[i]] then DiesalStyle:ReleaseTexture(object,name..OUTLINES[i]) end
    end
  end
  -- add texture name to style for better debugging
  style.name = name
  -- ~~ Get styleType ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if not style.type then return end
  local styleType = DiesalTools.Capitalize(style.type)
  if not DiesalStyle['Style'..styleType] then geterrorhandler()(style.type..' is not a valid style type') return end
  -- ~~ Get Frame ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  local framename = name:match('^[ \t]*([%w%d%_]*)')
  local frame = object[framename]
  if not frame then return end
  -- ~~ Style ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if styleType == 'Texture' then
    local texture = object.textures[name]
    if not texture then
      texture = newTexture()
      object.textures[name] = texture
    end
    texture:SetParent(frame)
    DiesalStyle:StyleTexture(texture,style)
  return end
  if styleType == 'Outline' then
    local textures = {}
    for i=1, #OUTLINES do
      local texture = object.textures[name..OUTLINES[i]]
      if not texture then
        texture = newTexture()
        object.textures[name..OUTLINES[i]] = texture
      end
      texture:SetParent(frame)
      textures[i] = texture
    end
    DiesalStyle:StyleOutline(textures[1],textures[2],textures[3],textures[4],style)
  return end
  if styleType == 'Shadow' then
    DiesalStyle:StyleShadow(object,frame,style)
  return end
  if styleType == 'Font' then
    DiesalStyle:StyleFont(frame,name,style)
  end
end
function DiesalStyle:SetObjectStyle(object,name,style)
  if not style or type(style) ~='table' then return end
  if type(name) ~='string' then return end
  -- clear texture
  if object.textures[name] then DiesalStyle:ReleaseTexture(object,name) end
  -- clear OUTLINE
  for i=1, #OUTLINES do
    if object.textures[name..OUTLINES[i]] then DiesalStyle:ReleaseTexture(object,name..OUTLINES[i]) end
  end
  -- Set object style
  DiesalStyle:UpdateObjectStyle(object,name,style)
end
function DiesalStyle:UpdateObjectStylesheet(object,Stylesheet)
  if not Stylesheet or type(Stylesheet) ~='table' then return end
  if not object.textures then object.textures = {} end

  for name,style in pairs(Stylesheet) do
    self:UpdateObjectStyle(object,name,style)
  end
end
function DiesalStyle:SetObjectStylesheet(object,Stylesheet)
  if not object.textures then object.textures = {} end

  DiesalStyle:ReleaseTextures(object)

  for name,style in pairs(Stylesheet) do
    self:UpdateObjectStyle(object,name,style)
  end
end
function DiesalStyle:ReleaseTexture(object,name)
  if not object or not object.textures or not object.textures[name] then
    error('No such texture on ojbect',2)
  return end
  releaseTexture(object.textures[name])
  object.textures[name] = nil
end
function DiesalStyle:ReleaseTextures(object)
  for name,texture in pairs(object.textures) do
    releaseTexture(texture)
    object.textures[name] = nil
  end
end
function DiesalStyle:GetMedia(mediaType,name)
  return getMedia(mediaType,name)
end
function DiesalStyle:AddMedia(mediaType,name,mediaFile)
  addMedia(mediaType,name,mediaFile)
end



-- deprecated

--- function DiesalStyle:StyleTexture(txture,style)
--   if not texture.style or style.clear then texture.style = {} end
--   -- ~~ Format New Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--   local red,green,blue = DiesalTools.GetColor(style.color)
--   local redEnd,greenEnd,blueEnd = DiesalTools.GetColor(style.colorEnd)
--   local texColorRed,texColorGreen,texColorBlue = DiesalTools.GetColor(style.texColor)
--   local offset = style.offset and type(style.offset)=='number' and {style.offset,style.offset,style.offset,style.offset} or style.offset
--   if type(style.texCoord) == 'table' and #style.texCoord > 4 then
--     style.texCoord = DiesalTools.Pack(DiesalTools.GetIconCoords(style.texCoord[1],style.texCoord[2],style.texCoord[3],style.texCoord[4],style.texCoord[5]))
--   end
--   -- Setting ~~~~~~~~~~~~~~~~~~~~~~~ New Setting ~~~~~~~~~~~~~~~ Old Setting
--   texture.style.layer = style.layer or texture.style.layer
--
--   texture.style.red = red or texture.style.red
--   texture.style.green = green or texture.style.green
--   texture.style.blue = blue or texture.style.blue
--   texture.style.alpha = style.alpha or texture.style.alpha or 1
--   texture.style.redEnd = redEnd or texture.style.redEnd or texture.style.red
--   texture.style.greenEnd = greenEnd or texture.style.greenEnd or texture.style.green
--   texture.style.blueEnd = blueEnd or texture.style.blueEnd or texture.style.blue
--   texture.style.alphaEnd = style.alphaEnd or texture.style.alphaEnd or texture.style.alpha
--   texture.style.gradient = style.gradient or texture.style.gradient
--
--   texture.style.texFile = style.texFile or texture.style.texFile
--   texture.style.texTile = style.texTile or texture.style.texTile
--   texture.style.texCoord = style.texCoord or texture.style.texCoord
--   texture.style.texColorRed = texColorRed or texture.style.texColorRed or 1
--   texture.style.texColorGreen = texColorGreen or texture.style.texColorGreen or 1
--   texture.style.texColorBlue = texColorBlue or texture.style.texColorBlue or 1
--   texture.style.texColorAlpha = style.texColorAlpha or style.alpha or texture.style.texColorAlpha or 1
--
--   texture.style.offset = offset or texture.style.offset or {0,0,0,0}
--   texture.style.width = style.width or texture.style.width
--   texture.style.height = style.height or texture.style.height
--
--   -- Clear settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--   -- clear texture settings, so things play nicely when overwritten [order cleared is significant]
--   texture:ClearAllPoints() -- clear offsets
--   texture:SetTexCoord(0,1,0,1) -- clear texture coords
--   texture:SetTexture() -- clear texture
--   texture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1) -- clear gradient
--   texture:SetColorTexture(1,1,1,1) -- clear color
--   -- ~~ Apply Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--   texture:SetDrawLayer(texture.style.layer or 'ARTWORK', 0)
--
--   if texture.style.texCoord and texture.style.texCoord[1] and texture.style.texCoord[2] and texture.style.texCoord[3] and texture.style.texCoord[4] then
--     texture:SetTexCoord(texture.style.texCoord[1],texture.style.texCoord[2],texture.style.texCoord[3],texture.style.texCoord[4])
--   end
--   -- offsets
--   if texture.style.offset[1] then texture:SetPoint("LEFT", -texture.style.offset[1],0) end
--   if texture.style.offset[2] then texture:SetPoint("RIGHT", texture.style.offset[2],0) end
--   if texture.style.offset[3] then texture:SetPoint("TOP", 0,texture.style.offset[3]) end
--   if texture.style.offset[4] then texture:SetPoint("BOTTOM", 0,-texture.style.offset[4]) end
--
--   if texture.style.width then texture:SetWidth(texture.style.width) end
--   if texture.style.height then texture:SetHeight(texture.style.height) end
--   -- precedence [1] Texture , [2] gradient , [3] color
--   if texture.style.texFile then
--     -- [1] Texture
--     if texture.style.texFile and Media.texture[texture.style.texFile] then texture.style.texFile = Media.texture[texture.style.texFile] end
--     texture:SetTexture(texture.style.texFile,texture.style.texTile)
--     texture:SetHorizTile(texture.style.texTile)
--     texture:SetVertTile(texture.style.texTile)
--     texture:SetVertexColor(texture.style.texColorRed,texture.style.texColorGreen,texture.style.texColorBlue,texture.style.texColorAlpha)
--   elseif texture.style.gradient then
--     -- [2] gradient
--     texture:SetAlpha(1)
--     texture:SetGradientAlpha(texture.style.gradient,texture.style.red,texture.style.green,texture.style.blue,texture.style.alpha or 1, texture.style.redEnd,texture.style.greenEnd,texture.style.blueEnd,texture.style.alphaEnd or 1)
--   elseif texture.style.red and texture.style.green and texture.style.blue then
--     -- [3] color
--     texture:SetColorTexture(texture.style.red,texture.style.green,texture.style.blue,texture.style.alpha or 1)
--   end
-- end
