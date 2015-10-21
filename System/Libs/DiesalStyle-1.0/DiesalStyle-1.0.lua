-- $Id: DiesalStyle-1.0.lua 52 2014-04-08 11:52:40Z diesal@reece-tech.com $
local MAJOR, MINOR = "DiesalStyle-1.0", "$Rev: 52 $"
local DiesalStyle, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not DiesalStyle then return end -- No Upgrade needed.
-- ~~| Libraries |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local DiesalTools 	= LibStub("DiesalTools-1.0")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
-- ~~| Lua Upvalues |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local type, select, pairs, tonumber									= type, select, pairs, tonumber
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
addMedia('font','Standard0755','Standard0755.ttf') 
addMedia('font','FFF Intelligent Thin Condensed','FFF Intelligent Thin Condensed.ttf') 
addMedia('texture','DiesalGUIcons','DiesalGUIcons16x256x128.tga') 
addMedia('border','shadow','shadow.tga')
addMedia('border','shadowNoDist','shadowNoDist.tga')
-- ~~ SharedMedia ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LibSharedMedia:Register("font","Calibri Bold",getMedia('font','calibrib'))
LibSharedMedia:Register("font","Standard0755",getMedia('font','Standard0755'))
LibSharedMedia:Register("font","FFF Intelligent",getMedia('font','FFF Intelligent Thin Condensed'))
-- ~~ Set Fonts ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CreateFont("DiesalFontNormal")
DiesalFontNormal:SetFont( getMedia('font','calibrib'),11 )
CreateFont("DiesalFontPixel")
DiesalFontPixel:SetFont( getMedia('font','Standard0755'),8 )
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
	texture:SetTexture(nil)
	texture:SetDrawLayer("ARTWORK", 0)
	texture:SetTexCoord(0,1,0,1)			
	texture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)
		
	texture:SetParent(TextureFrame)	
	texture:Hide()
	texture.style = nil
	
	if ReleasedTextures[texture] then
		error("Attempt to Release a texture that is already released", 2)
	end
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
		local textureStyle = texture.style			
		-- ~~ Format New Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local red,green,blue									= DiesalTools:GetColor(style.color)		
		local redEnd,greenEnd,blueEnd						= DiesalTools:GetColor(style.colorEnd)
		local texColorRed,texColorGreen,texColorBlue	= DiesalTools:GetColor(style.texColor)		
		local offset											= style.offset and type(style.offset)=='number' and {style.offset,style.offset,style.offset,style.offset} or style.offset		
		if type(style.texCoord) == 'table' and #style.texCoord > 4 then style.texCoord = DiesalTools:Pack(DiesalTools:GetIconCoords(style.texCoord[1],style.texCoord[2],style.texCoord[3],style.texCoord[4],style.texCoord[5]))	end 
	-- Setting ~~~~~~~~~~~~~~~~~~~~~~~ New Setting ~~~~~~~~~~~~~~~ Old Setting ~~~~~~~~~~~~~~~~~ Default ~~~~~~~~~~~~~~~~~~
		textureStyle.layer				= style.layer					or textureStyle.layer					or 'ARTWORK'						
					
		textureStyle.red					= red									or textureStyle.red			
		textureStyle.green				= green								or textureStyle.green		
		textureStyle.blue					= blue								or textureStyle.blue
		textureStyle.alpha				= style.alpha					or textureStyle.alpha					or 1 						
		textureStyle.redEnd				= redEnd							or textureStyle.redEnd				or textureStyle.red	 	
		textureStyle.greenEnd			= greenEnd						or textureStyle.greenEnd			or textureStyle.green
		textureStyle.blueEnd			= blueEnd							or textureStyle.blueEnd				or textureStyle.blue
		textureStyle.alphaEnd			= style.alphaEnd			or textureStyle.alphaEnd			or textureStyle.alpha
		textureStyle.gradient			= style.gradient			or textureStyle.gradient
		
		textureStyle.texFile			= style.texFile				or textureStyle.texFile	
		textureStyle.texTile			= style.texTile				or textureStyle.texTile
		textureStyle.texCoord			= style.texCoord			or textureStyle.texCoord			or	{0,1,0,1}
		textureStyle.texColorRed	= texColorRed					or textureStyle.texColorRed		or 1
		textureStyle.texColorGreen= texColorGreen				or textureStyle.texColorGreen	or 1		
		textureStyle.texColorBlue	= texColorBlue				or textureStyle.texColorBlue	or 1	
		textureStyle.texColorAlpha= style.texColorAlpha	or textureStyle.texColorAlpha	or 1
		
		textureStyle.offset				= offset							or textureStyle.offset				or {0,0,0,0} 	
		textureStyle.width				= style.width					or textureStyle.width
		textureStyle.height				= style.height				or textureStyle.height		
		-- ~~ Apply Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	
		texture:ClearAllPoints()
		texture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)	
		texture:SetDrawLayer(textureStyle.layer, 0)	
		texture:SetVertexColor(textureStyle.texColorRed,textureStyle.texColorGreen,textureStyle.texColorBlue,textureStyle.texColorAlpha)	
		texture:SetTexCoord(textureStyle.texCoord[1],textureStyle.texCoord[2],textureStyle.texCoord[3],textureStyle.texCoord[4])	
		texture:SetAlpha(textureStyle.alpha)
			
		if textureStyle.offset[1] 	then texture:SetPoint("LEFT", 	-textureStyle.offset[1],0) 		end
		if textureStyle.offset[2] 	then texture:SetPoint("RIGHT", 	textureStyle.offset[2],0) 		end
		if textureStyle.offset[3] 	then texture:SetPoint("TOP", 		0,textureStyle.offset[3])			end		
		if textureStyle.offset[4]		then texture:SetPoint("BOTTOM", 	0,-textureStyle.offset[4]) 	end
		if textureStyle.width 			then texture:SetWidth(textureStyle.width) 										end
		if textureStyle.height			then texture:SetHeight(textureStyle.height) 									end		
		if textureStyle.texFile then 
			if Media.texture[textureStyle.texFile] then textureStyle.texFile = Media.texture[textureStyle.texFile] end		
			texture:SetTexture(textureStyle.texFile,textureStyle.texTile)			
			texture:SetHorizTile(textureStyle.texTile)
			texture:SetVertTile(textureStyle.texTile)		
		else		
			texture:SetTexture(textureStyle.red,textureStyle.green,textureStyle.blue)	
		end
		if textureStyle.gradient then
			texture:SetAlpha(1)
			texture:SetTexture(1,1,1,1)
			texture:SetGradientAlpha(textureStyle.gradient,textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha, textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd,textureStyle.alphaEnd)		
		end	
end
function DiesalStyle:StyleOutline(leftTexture,rightTexture,topTexture,bottomTexture,style)
	if not leftTexture.style or style.clear then leftTexture.style = {}	end			
	local textureStyle = leftTexture.style			
	-- ~~ Format New Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	local red,green,blue									= DiesalTools:GetColor(style.color)		
	local redEnd,greenEnd,blueEnd						= DiesalTools:GetColor(style.colorEnd)
	local offset											= style.offset and type(style.offset)=='number' and {style.offset,style.offset,style.offset,style.offset} or style.offset	
-- Setting ~~~~~~~~~~~~~~~~~~~~~~~ New Setting ~~~~~~~~~~~~~~~ Old Setting ~~~~~~~~~~~~~~~~~ Default ~~~~~~~~~~~~~~~
	textureStyle.layer			= style.layer				or textureStyle.layer			or 'ARTWORK'	
	
	textureStyle.red				= red							or textureStyle.red			
	textureStyle.green			= green						or textureStyle.green		
	textureStyle.blue				= blue						or textureStyle.blue
	textureStyle.alpha			= style.alpha				or textureStyle.alpha			or 1					
	textureStyle.redEnd			= redEnd						or textureStyle.redEnd			or textureStyle.red	 	
	textureStyle.greenEnd		= greenEnd					or textureStyle.greenEnd		or textureStyle.green
	textureStyle.blueEnd			= blueEnd					or textureStyle.blueEnd			or textureStyle.blue
	textureStyle.alphaEnd		= style.alphaEnd			or textureStyle.alphaEnd		or textureStyle.alpha
	textureStyle.gradient		= style.gradient			or textureStyle.gradient						
	
	textureStyle.offset			= offset						or textureStyle.offset			or {0,0,0,0} 	
	textureStyle.width			= style.width				or textureStyle.width
	textureStyle.height			= style.height				or textureStyle.height		
	-- ~~ Apply Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~		
	leftTexture:ClearAllPoints()
	leftTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)	
	leftTexture:SetDrawLayer(textureStyle.layer, 0)
	leftTexture:SetWidth(1)	
	leftTexture:SetTexture(textureStyle.red,textureStyle.green,textureStyle.blue)
	leftTexture:SetAlpha(textureStyle.alpha)				
	if textureStyle.offset[1] 	then leftTexture:SetPoint("LEFT", 		-textureStyle.offset[1],0) 	
	else								  		  leftTexture:SetPoint("RIGHT", 	-textureStyle.width,0)		end	
	if textureStyle.offset[3] 	then leftTexture:SetPoint("TOP", 		0,textureStyle.offset[3])	end		
	if textureStyle.offset[4]	then leftTexture:SetPoint("BOTTOM", 	0,-textureStyle.offset[4]) end	
	if textureStyle.height		then leftTexture:SetHeight(textureStyle.height) 						end		
	if textureStyle.gradient =='VERTICAL' then
		leftTexture:SetAlpha(1)
		leftTexture:SetTexture(1,1,1,1)
		leftTexture:SetGradientAlpha(textureStyle.gradient,textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha, textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd,textureStyle.alphaEnd)		
	end

	rightTexture:ClearAllPoints()
	rightTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)		
	rightTexture:SetDrawLayer(textureStyle.layer, 0)
	rightTexture:SetWidth(1)	
	rightTexture:SetTexture(textureStyle.red,textureStyle.green,textureStyle.blue)
	rightTexture:SetAlpha(textureStyle.alpha)			
	if textureStyle.offset[2] 	then rightTexture:SetPoint("RIGHT", 	textureStyle.offset[2],0) 	
	else								  	  rightTexture:SetPoint("LEFT", 		textureStyle.width-(textureStyle.offset[1]+1),0)	end
	if textureStyle.offset[3] 	then rightTexture:SetPoint("TOP", 		0,textureStyle.offset[3])	end		
	if textureStyle.offset[4]	then rightTexture:SetPoint("BOTTOM", 	0,-textureStyle.offset[4]) end		
	if textureStyle.height		then rightTexture:SetHeight(textureStyle.height) 						end		
	if textureStyle.gradient then 		
		if textureStyle.gradient =='VERTICAL' then
			rightTexture:SetAlpha(1)
			rightTexture:SetTexture(1,1,1,1)
			rightTexture:SetGradientAlpha(textureStyle.gradient,textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha, textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd,textureStyle.alphaEnd)		
		else -- HORIZONTAL
			rightTexture:SetAlpha(textureStyle.alphaEnd)
			rightTexture:SetTexture(textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd)
		end	 		
	end
	
	topTexture:ClearAllPoints()
	topTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)				
	topTexture:SetDrawLayer(textureStyle.layer, 0)
	topTexture:SetHeight(1)	
	topTexture:SetTexture(textureStyle.red,textureStyle.green,textureStyle.blue)
	topTexture:SetAlpha(textureStyle.alpha)		
	if textureStyle.offset[1] 	then topTexture:SetPoint("LEFT", 		-textureStyle.offset[1]+1,0) 	end	
	if textureStyle.offset[2] 	then topTexture:SetPoint("RIGHT", 		(textureStyle.offset[2])-1,0) end	
	if textureStyle.offset[3] 	then topTexture:SetPoint("TOP", 		0,textureStyle.offset[3])		
	else								  		  topTexture:SetPoint("BOTTOM", 	0,textureStyle.height-1)		end	
	if textureStyle.width		then topTexture:SetWidth(textureStyle.width-2) 								end		
	if textureStyle.gradient then 		
		if textureStyle.gradient =='HORIZONTAL' then
			topTexture:SetAlpha(1)
			topTexture:SetTexture(1,1,1,1)
			topTexture:SetGradientAlpha(textureStyle.gradient,textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha, textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd,textureStyle.alphaEnd)		
		else -- VERTICAL							
			topTexture:SetAlpha(textureStyle.alphaEnd)
			topTexture:SetTexture(textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd)
		end	 		
	end
	
	bottomTexture:ClearAllPoints()
	bottomTexture:SetGradientAlpha('HORIZONTAL',1,1,1,1,1,1,1,1)				
	bottomTexture:SetDrawLayer(textureStyle.layer, 0)
	bottomTexture:SetHeight(1)	
	bottomTexture:SetTexture(textureStyle.red,textureStyle.green,textureStyle.blue)
	bottomTexture:SetAlpha(textureStyle.alpha)		
	if textureStyle.offset[1] 	then bottomTexture:SetPoint("LEFT", 		-textureStyle.offset[1]+1,0) 	end	
	if textureStyle.offset[2] 	then bottomTexture:SetPoint("RIGHT", 		textureStyle.offset[2]-1,0) 	end	
	if textureStyle.offset[4]	then bottomTexture:SetPoint("BOTTOM", 	0,-textureStyle.offset[4])
	else								  	  bottomTexture:SetPoint("TOP", 		0,-(textureStyle.height+1)+(textureStyle.offset[3]+2))	end			
	if textureStyle.width		then bottomTexture:SetWidth(textureStyle.width-2) 								end		
	if style.gradient =='HORIZONTAL' then
		bottomTexture:SetAlpha(1)
		bottomTexture:SetTexture(1,1,1,1)
		bottomTexture:SetGradientAlpha(textureStyle.gradient,textureStyle.red,textureStyle.green,textureStyle.blue,textureStyle.alpha, textureStyle.redEnd,textureStyle.greenEnd,textureStyle.blueEnd,textureStyle.alphaEnd)		
	end
					
end
function DiesalStyle:StyleShadow(object,frame,style)
		object.shadow = object.shadow or CreateFrame("Frame",nil,frame)
		if not object.shadow.style or style.clear then object.shadow.style = {}	end	
		local shadowStyle = object.shadow.style				
		-- ~~ Format New Settings ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		local red,green,blue									= DiesalTools:GetColor(style.color)		
		local offset											= style.offset and type(style.offset)=='number' and {style.offset,style.offset,style.offset,style.offset} or style.offset		
	-- Setting ~~~~~~~~~~~~~~~~~~~~~~~ New Setting ~~~~~~~~~~~~~~~ Old Setting ~~~~~~~~~~~~~~~~~ Default ~~~~~~~~~~~~~~~~~~			
		shadowStyle.edgeFile				= style.edgeFile				or shadowStyle.edgeFile			or getMedia('border','shadow')
		shadowStyle.edgeSize				= style.edgeSize				or shadowStyle.edgeSize			or 28		
			
		shadowStyle.red					= red								or shadowStyle.red				or 0	
		shadowStyle.green					= green							or shadowStyle.green				or 0
		shadowStyle.blue					= blue							or shadowStyle.blue				or 0
		shadowStyle.alpha					= style.alpha					or shadowStyle.alpha				or .45
		
		shadowStyle.offset				= offset							or shadowStyle.offset			or {20,20,20,20} 					
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
	local styleType = DiesalTools:Capitalize(style.type)
	if not DiesalStyle['Style'..styleType] then geterrorhandler()(style.type..' is not a valid styling method') return end
	
	if type(name) ~='string' then return end 	
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
