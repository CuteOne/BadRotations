-- $Id: DiesalStyle-1.0.lua 53 2016-07-12 21:56:30Z diesal2010 $
local MAJOR, MINOR = "DiesalStyle-1.0", "$Rev: 53 $"
local DiesalStyle, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not DiesalStyle then return end -- No Upgrade needed.
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools 	= LibStub("DiesalTools-1.0")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, select, pairs, tonumber					= type, select, pairs, tonumber
local next																	= next
-- ~~| DiesalStyle Values |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DiesalStyle.Media							= DiesalStyle.Media							or {} 
DiesalStyle.ReleasedTextures	= DiesalStyle.ReleasedTextures	or {} 
DiesalStyle.TextureFrame			= DiesalStyle.TextureFrame 			or CreateFrame("Frame"); DiesalStyle.TextureFrame:Hide();
-- ~~| DiesalStyle UpValues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local AddonName 			= ...
local ReleasedTextures= DiesalStyle.ReleasedTextures
local TextureFrame		= DiesalStyle.TextureFrame
local Media						= DiesalStyle.Media
-- ~~| DiesalStyle Locals |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local OUTLINES 			= {'_LEFT','_RIGHT','_TOP','_BOTTOM'}
-- ~~| DiesalStyle Media |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local MediaPath
do -- ~~ find current MediaPath 	
	if AddonName == 'DiesalLibs' then -- in DiesalStyle in DeisalLibs
		MediaPath = string.format("Interface\\AddOns\\%s\\%s\\Media\\",AddonName,MAJOR)
	else -- in a library instance of DiesalStyle
		MediaPath = string.format("Interface\\AddOns\\%s\\Libs\\%s\\Media\\",AddonName,MAJOR)
	end
end
local function addMedia(mediaType,name,mediaFile)	
	Media[mediaType] = Media[mediaType] or {}	 
	-- update or create new media entry
	Media[mediaType][name] = MediaPath..mediaFile	
end
local function getMedia(mediaType,name)
	if not Media[mediaType] then error('media type: '..mediaType..' does not exist',2)	return end
	if not Media[mediaType][name] then error('media: "'..name..'" does not exist',2)	return end	
	return Media[mediaType][name]
end
-- ~~ Addmedia ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
addMedia('border','shadow','shadow.tga')
addMedia('border','shadowNoDist','shadowNoDist.tga')
-- ~~ SharedMedia ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
-- Set Fonts ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CreateFont("DiesalFontNormal")
DiesalFontNormal:SetFont( getMedia('font','calibrib'),11 )
CreateFont("DiesalFontPixel")
DiesalFontPixel:SetFont( getMedia('font','Standard0755'), 8 )
CreateFont("DiesalFontPixelOutLine")
DiesalFontPixelOutLine:SetFont( getMedia('font','Standard0755'), 6, "OUTLINE, MONOCHROME" )
DiesalFontPixelOutLine:SetSpacing(2)
CreateFont("DiesalFontPixel2")
DiesalFontPixel2:SetFont( getMedia('font','FFF Intelligent Thin Condensed'), 8, "OUTLINE, MONOCHROME" )
-- ~~| Internal methods |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Returns new Texture
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
-- Releases Texture
local function releaseTexture(texture)	
	-- reset texture	
	texture:ClearAllPoints()
	texture:SetDrawLayer("ARTWORK", 0)
	texture:SetTexCoord(0,1,0,1)			
	-- specific order based on testing! for a close as possible full texture reset
	texture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)
	texture:SetColorTexture(0,0,0,0)
	texture:SetTexture()
	texture:SetVertexColor(1,1,1,1)	
		
	texture:SetParent(TextureFrame)	
	texture:Hide()
	texture.style = nil
	
	if ReleasedTextures[texture] then	error("Attempt to Release a texture that is already released", 2)	end
	ReleasedTextures[texture] = true
end
-- ~~| DiesalStyle API |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--[[ Texture style table format
	style.layer				BACKGROUND | BORDER | ARTWORK | OVERLAY | HIGHLIGHT (texture in this layer is automatically shown when the mouse is over the containing Frame)
	**FontStrings always appear on top of all textures in a given draw layer. avoid using sublayer
	-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
	style.alpha				alpha [0 - 1]
	style.alphaEnd			alpha [0 - 1]	
	style.color				hexColor | {Red, Green, Blue} [0-255]
	style.colorEnd			hexColor | {Red, Green, Blue} [0-255]
	style.gradient			VERTICAL | HORIZONTAL
	-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	style.texFile			texture fileName
	style.texTile			true | false	
	style.texCoord			{left, right, top, bottom} [0-1] | {column,row,size,textureWidth,TextureHeight}
	style.texColor			hexColor | {Red,Green,Blue} [0-255]
	style.texColorAlpha	alpha [0 - 1]
	-- ~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	style.offset			offset | {Left, Right, Top, Bottom}
	style.width				width
	style.height			height	
]]
function DiesalStyle:StyleTexture(texture,style)
	if not texture.style or style.clear then texture.style = {}	end	
	-- ~~ Format New Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	local red,green,blue									= DiesalTools:GetColor(style.color)		
	local redEnd,greenEnd,blueEnd					= DiesalTools:GetColor(style.colorEnd)
	local texColorRed,texColorGreen,texColorBlue	= DiesalTools:GetColor(style.texColor)		
	local offset = style.offset and type(style.offset)=='number' and {style.offset,style.offset,style.offset,style.offset} or style.offset	
	if type(style.texCoord) == 'table' and #style.texCoord > 4 then
		style.texCoord = DiesalTools:Pack(DiesalTools:GetIconCoords(style.texCoord[1],style.texCoord[2],style.texCoord[3],style.texCoord[4],style.texCoord[5]))	
	end 
-- Setting ~~~~~~~~~~~~~~~~~~~~~~~ New Setting ~~~~~~~~~~~~~~~ Old Setting
	texture.style.layer					= style.layer					or texture.style.layer											
				
	texture.style.red						= red									or texture.style.red			
	texture.style.green					= green								or texture.style.green		
	texture.style.blue					= blue								or texture.style.blue
	texture.style.alpha					= style.alpha					or texture.style.alpha					or 1 						
	texture.style.redEnd				= redEnd							or texture.style.redEnd					or texture.style.red	 	
	texture.style.greenEnd			= greenEnd						or texture.style.greenEnd				or texture.style.green
	texture.style.blueEnd				= blueEnd							or texture.style.blueEnd				or texture.style.blue
	texture.style.alphaEnd			= style.alphaEnd			or texture.style.alphaEnd				or texture.style.alpha
	texture.style.gradient			= style.gradient			or texture.style.gradient

	texture.style.texFile				= style.texFile				or texture.style.texFile	
	texture.style.texTile				= style.texTile				or texture.style.texTile
	texture.style.texCoord			= style.texCoord			or texture.style.texCoord				
	texture.style.texColorRed		= texColorRed					or texture.style.texColorRed		or 1
	texture.style.texColorGreen	= texColorGreen				or texture.style.texColorGreen	or 1	
	texture.style.texColorBlue	= texColorBlue				or texture.style.texColorBlue		or 1
	texture.style.texColorAlpha	= style.texColorAlpha	or style.alpha or texture.style.texColorAlpha	or 1	
	
	texture.style.offset				= offset							or texture.style.offset					or {0,0,0,0}									
	texture.style.width					= style.width					or texture.style.width
	texture.style.height				= style.height				or texture.style.height			
	
	-- Clear settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	-- clear texture settings, so things play nicely when overwritten [order cleared is significant]
	texture:ClearAllPoints() -- clear offsets
	texture:SetTexCoord(0,1,0,1) -- clear texture coords
	texture:SetTexture() -- clear texture
	texture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)	-- clear gradient
	texture:SetColorTexture(1,1,1,1) -- clear color
	-- ~~ Apply Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	texture:SetDrawLayer(texture.style.layer or 'ARTWORK', 0)	
	
	if texture.style.texCoord and texture.style.texCoord[1] and texture.style.texCoord[2] and texture.style.texCoord[3] and texture.style.texCoord[4] then
		texture:SetTexCoord(texture.style.texCoord[1],texture.style.texCoord[2],texture.style.texCoord[3],texture.style.texCoord[4])	
	end
	-- offsets	
	if texture.style.offset[1] 	then texture:SetPoint("LEFT", 	-texture.style.offset[1],0) 	end
	if texture.style.offset[2] 	then texture:SetPoint("RIGHT", 	texture.style.offset[2],0) 		end
	if texture.style.offset[3] 	then texture:SetPoint("TOP", 		0,texture.style.offset[3])		end		
	if texture.style.offset[4]	then texture:SetPoint("BOTTOM", 	0,-texture.style.offset[4]) end
	
	if texture.style.width 			then texture:SetWidth(texture.style.width) 										end
	if texture.style.height			then texture:SetHeight(texture.style.height) 									end		
	-- precedence [1] Texture , [2] gradient , [3] color
	if texture.style.texFile then	
	-- [1] Texture	
		if texture.style.texFile and Media.texture[texture.style.texFile] then texture.style.texFile = Media.texture[texture.style.texFile] end	
		texture:SetTexture(texture.style.texFile,texture.style.texTile)			
		texture:SetHorizTile(texture.style.texTile)
		texture:SetVertTile(texture.style.texTile)
		texture:SetVertexColor(texture.style.texColorRed,texture.style.texColorGreen,texture.style.texColorBlue,texture.style.texColorAlpha)	
	elseif texture.style.gradient then
	-- [2] gradient	
		texture:SetAlpha(1) 
		texture:SetGradientAlpha(texture.style.gradient,texture.style.red,texture.style.green,texture.style.blue,texture.style.alpha or 1, texture.style.redEnd,texture.style.greenEnd,texture.style.blueEnd,texture.style.alphaEnd or 1)		
	elseif texture.style.red and texture.style.green and texture.style.blue then
	-- [3] color	
		texture:SetColorTexture(texture.style.red,texture.style.green,texture.style.blue,texture.style.alpha or 1)	
	end	
end
function DiesalStyle:StyleOutline(leftTexture,rightTexture,topTexture,bottomTexture,style)
	if not leftTexture.style or style.clear then leftTexture.style = {}	end			
	local textureStyle = leftTexture.style			
	-- ~~ Format New Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	local red,green,blue							= DiesalTools:GetColor(style.color)		
	local redEnd,greenEnd,blueEnd			= DiesalTools:GetColor(style.colorEnd)
	local offset											= style.offset and type(style.offset)=='number' and {style.offset,style.offset,style.offset,style.offset} or style.offset	
-- Setting ~~~~~~~~~~~~~~~~~~~~~~~ New Setting ~~~~~~~~~~~~~~~ Old Setting ~~~~~~~~~~~~~~~~~ Default ~~~~~~~~~~~~~~~
	textureStyle.layer			= style.layer			or textureStyle.layer			or 'ARTWORK'	
	
	textureStyle.red				= red							or textureStyle.red			
	textureStyle.green			= green						or textureStyle.green		
	textureStyle.blue				= blue						or textureStyle.blue
	textureStyle.alpha			= style.alpha			or textureStyle.alpha				or 1					
	textureStyle.redEnd			= redEnd					or textureStyle.redEnd			or textureStyle.red	 	
	textureStyle.greenEnd		= greenEnd				or textureStyle.greenEnd		or textureStyle.green
	textureStyle.blueEnd		= blueEnd					or textureStyle.blueEnd			or textureStyle.blue
	textureStyle.alphaEnd		= style.alphaEnd	or textureStyle.alphaEnd		or textureStyle.alpha
	textureStyle.gradient		= style.gradient	or textureStyle.gradient						
	
	textureStyle.offset			= offset					or textureStyle.offset			or {0,0,0,0} 	
	textureStyle.width			= style.width			or textureStyle.width
	textureStyle.height			= style.height		or textureStyle.height		
	-- ~~ Apply Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
	leftTexture:ClearAllPoints()
	leftTexture:SetDrawLayer(textureStyle.layer, 0)
	leftTexture:SetWidth(1)	
	leftTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)		
	leftTexture:SetColorTexture(textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha)
	if textureStyle.offset[1] then leftTexture:SetPoint("LEFT", 	-textureStyle.offset[1],0) 	
	else								  		  	 leftTexture:SetPoint("RIGHT", 		-textureStyle.width,0)		end	
	if textureStyle.offset[3] then leftTexture:SetPoint("TOP", 		0,textureStyle.offset[3])		end		
	if textureStyle.offset[4]	then leftTexture:SetPoint("BOTTOM", 0,-textureStyle.offset[4]) 	end	
	if textureStyle.height		then leftTexture:SetHeight(textureStyle.height) 								end		
	if textureStyle.gradient =='VERTICAL' then
		leftTexture:SetColorTexture(1,1,1,1)
		leftTexture:SetGradientAlpha(textureStyle.gradient,textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha, textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd,textureStyle.alphaEnd)		
	end

	rightTexture:ClearAllPoints()
	rightTexture:SetDrawLayer(textureStyle.layer, 0)
	rightTexture:SetWidth(1)
	rightTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)		
	rightTexture:SetColorTexture(textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha)
	if textureStyle.offset[2] 	then rightTexture:SetPoint("RIGHT", 	textureStyle.offset[2],0) 	
	else								  	  rightTexture:SetPoint("LEFT", 		textureStyle.width-(textureStyle.offset[1]+1),0)	end
	if textureStyle.offset[3] 	then rightTexture:SetPoint("TOP", 		0,textureStyle.offset[3])	end		
	if textureStyle.offset[4]	then rightTexture:SetPoint("BOTTOM", 	0,-textureStyle.offset[4]) end		
	if textureStyle.height		then rightTexture:SetHeight(textureStyle.height) 						end		
	if textureStyle.gradient then 		
		if textureStyle.gradient =='VERTICAL' then
			rightTexture:SetColorTexture(1,1,1,1)
			rightTexture:SetGradientAlpha(textureStyle.gradient,textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha, textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd,textureStyle.alphaEnd)		
		else -- HORIZONTAL
			rightTexture:SetColorTexture(textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd,textureStyle.alphaEnd)
		end	 		
	end
	
	topTexture:ClearAllPoints()
	topTexture:SetDrawLayer(textureStyle.layer, 0)
	topTexture:SetHeight(1)	
	topTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)		
	topTexture:SetColorTexture(textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha)
	if textureStyle.offset[1] 	then topTexture:SetPoint("LEFT", 		-textureStyle.offset[1]+1,0) 	end	
	if textureStyle.offset[2] 	then topTexture:SetPoint("RIGHT", 		(textureStyle.offset[2])-1,0) end	
	if textureStyle.offset[3] 	then topTexture:SetPoint("TOP", 		0,textureStyle.offset[3])		
	else								  		  topTexture:SetPoint("BOTTOM", 	0,textureStyle.height-1)		end	
	if textureStyle.width		then topTexture:SetWidth(textureStyle.width-2) 								end		
	if textureStyle.gradient then 		
		if textureStyle.gradient =='HORIZONTAL' then
			topTexture:SetColorTexture(1,1,1,1)
			topTexture:SetGradientAlpha(textureStyle.gradient,textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha, textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd,textureStyle.alphaEnd)		
		else -- VERTICAL							
			topTexture:SetColorTexture(textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd,textureStyle.alphaEnd)
		end	 		
	end
	
	bottomTexture:ClearAllPoints()
	bottomTexture:SetDrawLayer(textureStyle.layer, 0)
	bottomTexture:SetHeight(1)	
	bottomTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)		
	bottomTexture:SetColorTexture(textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha)
	-- bottomTexture:SetAlpha(textureStyle.alpha)		
	if textureStyle.offset[1] 	then bottomTexture:SetPoint("LEFT", 		-textureStyle.offset[1]+1,0) 	end	
	if textureStyle.offset[2] 	then bottomTexture:SetPoint("RIGHT", 		textureStyle.offset[2]-1,0) 	end	
	if textureStyle.offset[4]	then bottomTexture:SetPoint("BOTTOM", 	0,-textureStyle.offset[4])
	else								  	  bottomTexture:SetPoint("TOP", 		0,-(textureStyle.height+1)+(textureStyle.offset[3]+2))	end			
	if textureStyle.width		then bottomTexture:SetWidth(textureStyle.width-2) 								end		
	if style.gradient =='HORIZONTAL' then
		bottomTexture:SetColorTexture(1,1,1,1)
		bottomTexture:SetGradientAlpha(textureStyle.gradient,textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha, textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd,textureStyle.alphaEnd)		
	end
					
end
function DiesalStyle:StyleShadow(object,frame,style)
		object.shadow = object.shadow or CreateFrame("Frame",nil,frame)
		object.shadow:Show()
		if not object.shadow.style or style.clear then object.shadow.style = {}	end	
		local shadowStyle = object.shadow.style				
		-- ~~ Format New Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local red,green,blue									= DiesalTools:GetColor(style.color)		
		local offset											= style.offset and type(style.offset)=='number' and {style.offset,style.offset,style.offset,style.offset} or style.offset		
	-- Setting ~~~~~~~~~~~~~~~~~~~~~~~ New Setting ~~~~~~~~~~~~~~~ Old Setting ~~~~~~~~~~~~~~~~~ Default ~~~~~~~~~~~~~~~~~~			
		shadowStyle.edgeFile			= style.edgeFile		or shadowStyle.edgeFile		or getMedia('border','shadow')
		shadowStyle.edgeSize			= style.edgeSize		or shadowStyle.edgeSize		or 28		
			
		shadowStyle.red						= red								or shadowStyle.red				or 0	
		shadowStyle.green					= green							or shadowStyle.green			or 0
		shadowStyle.blue					= blue							or shadowStyle.blue				or 0
		shadowStyle.alpha					= style.alpha				or shadowStyle.alpha			or .45
		
		shadowStyle.offset				= offset						or shadowStyle.offset			or {20,20,20,20} 					
		-- ~~ Apply Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	

		if shadowStyle.offset[1] 	then object.shadow:SetPoint("LEFT", 	-shadowStyle.offset[1],0) 	end
		if shadowStyle.offset[2] 	then object.shadow:SetPoint("RIGHT", 	shadowStyle.offset[2],0) 	end
		if shadowStyle.offset[3] 	then object.shadow:SetPoint("TOP", 		0,shadowStyle.offset[3])	end		
		if shadowStyle.offset[4]	then object.shadow:SetPoint("BOTTOM", 	0,-shadowStyle.offset[4]) 	end	
		
		object.shadow:SetBackdrop({ edgeFile = shadowStyle.edgeFile, edgeSize = shadowStyle.edgeSize })
		object.shadow:SetBackdropBorderColor(shadowStyle.red, shadowStyle.green, shadowStyle.blue, shadowStyle.alpha)	
end
--[[ Font style table format	
	TODO style.offset		( offset|{ Left, Right, Top, Bottom })
	TODO style.width		( width )
	TODO style.height		( height )	
	
	style.font				( Path to a font file ) 
	style.fontSize 		( Size (point size) of the font to be displayed (in pixels) ) 
	style.flags				( Additional properties specified by one or more of the following tokens: MONOCHROME, OUTLINE | THICKOUTLINE )  (comma delimitered string)
	style.alpha				( alpha ) 
	style.color				( hexColor|{ Red, Green, Blue } [0-255])
	style.lineSpacing		( number - Sets the font instance's amount of spacing between lines)	
]]
function DiesalStyle:StyleFont(fontInstance,name,style)	
	local filename, fontSize, flags 	= fontInstance:GetFont()	
	local red,green,blue,alpha 				= fontInstance:GetTextColor()	
	local lineSpacing									= fontInstance:GetSpacing()	
	style.red, style.green, style.blue 	= DiesalTools:GetColor(style.color)		
	-- ~~ Set Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~			
	style.filename	= style.filename	or filename
	style.fontSize	= style.fontSize	or fontSize
	style.flags			= style.flags			or flags
	
	style.red 			= style.red 			or red
	style.green 		= style.green 		or green
	style.blue	 		= style.blue 			or blue
	style.alpha			= style.alpha			or alpha			
	style.lineSpacing	= style.lineSpacing	or lineSpacing	
	-- ~~ Apply Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
	fontInstance:SetFont( style.filename, style.fontSize, style.flags	)				
	fontInstance:SetTextColor(style.red, style.green, style.blue, style.alpha)		
	fontInstance:SetSpacing(style.lineSpacing)		
	
	fontInstance.style = style	 
end
function DiesalStyle:SetObjectStyle(object,name,style)	
	if not style or type(style) ~='table' then return end	
	if type(name) ~='string' then return end 	
	-- ~~ Clear Texture ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	if style.clear then
		-- clear texture 
		if object.textures[name] then
			DiesalStyle:ReleaseTexture(object,name)
		end
		-- clear OUTLINE
		for i=1, #OUTLINES do
			if object.textures[name..OUTLINES[i]] then
				DiesalStyle:ReleaseTexture(object,name..OUTLINES[i])
			end				
		end		 
	end
	-- ~~ Get styleType ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	if not style.type then return end
	local styleType = DiesalTools:Capitalize(style.type)
	if not DiesalStyle['Style'..styleType] then geterrorhandler()(style.type..' is not a valid styling method') return end
	-- ~~ Get Frame ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	local framename = name:match('^[ \t]*([%w%d]*)')
	local frame = object[framename]	
	if not frame then geterrorhandler()('object['..framename..'] frame does not exist on object') return end	
	-- ~~ Style ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
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
function DiesalStyle:AddObjectStyleSheet(object,stylesheet)
	for name,style in pairs(stylesheet) do 
		self:SetObjectStyle(object,name,style)		
	end
end
function DiesalStyle:SetFrameStyle(frame,name,style)
	if not style or type(style) ~='table' then return end		
	if not name then error('[Settings.name] missing from style table',2)	return end
	local styleType = DiesalTools:Capitalize(style.type)
	if not DiesalStyle['Style'..styleType] then error(style.type..' is not a valid styling method',2) return end
		
	-- ~~ Get Texture ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
	frame.textures 	= frame.textures or {}
	
	if styleType == 'Texture' then
		local texture = frame.textures[name]
		if not texture then
			texture = newTexture()
			frame.textures[name] = texture
		end
		texture:SetParent(frame)
		DiesalStyle:StyleTexture(texture,style)		
	return end	
	if styleType == 'Outline' then			
		local textures = {}
		for i=1, #OUTLINES do
			local texture = frame.textures[name..OUTLINES[i]]
			if not texture then
				texture = newTexture()
				frame.textures[name..OUTLINES[i]] = texture					
			end			
			texture:SetParent(frame)			
			textures[i] = texture
		end
		DiesalStyle:StyleOutline(textures[1],textures[2],textures[3],textures[4],style)
	return end	
	if styleType == 'Shadow'  then
		DiesalStyle:StyleShadow(object,frame,style)
	return end
	if styleType == 'Font'	  then		
		DiesalStyle:StyleFont(frame,style)					 
	end	
end
function DiesalStyle:AddFrameStyleSheet(frame,stylesheet)
	for name,style in pairs(stylesheet) do		 
		self:SetFrameStyle(frame,name,style)		
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
