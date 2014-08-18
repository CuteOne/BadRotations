--[[
    
    How to use:
         
    ----------------------------------------------
    
    CreateBorder(myFrame, borderSize, r, g, b, uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2)
        
        myFrame         -> The name of your frame, It must be a frame not a texture/fontstring
        borderSize      -> The size of the simple square Border. 10-12 looks amazing with the default beautycase texture
        r, g, b         -> The colors of the Border. r = Red, g = Green, b = Blue
        uL1, uL2        -> top left x, top left y
        uR1, uR2        -> top right x, top right y
        bL1, bL2        -> bottom left x, bottom left y
        bR1, bR2        -> bottom right x, bottom right y
    
    
    for example:
            
            local r, g, b = 1, 1, 0 -- for yellow
            CreateBorder(myFrame, 12, r, g, b, 1, 1, 1, 1, 1, 1, 1, 1)
        
        
        shorter method if the spacing between the frame is always the same
        
            CreateBorder(myFrame, 12, r, g, b, 1)
            
        
        or for no spacing
        
            CreateBorder(myFrame, 12, r, g, b)
    
    
    ----------------------------------------------
    
    If you want you recolor the border or shadow (for aggrowarning or similar) you can make this with this little trick
    
        ColorBorder(myFrame, r, g, b, alpha)
        ColorBorderShadow(myFrame, r, g, b, alpha)
        
    ----------------------------------------------
    
    For changing the border or shadow texture
    
        SetBorderTexture(myFrame, texture.tga)
        SetBorderShadowTexture(myFrame, texture.tga)
     
    ----------------------------------------------
    
    For all Border Infos
    
        local borderSize, texture, r, g, b, alpha = GetBorderInfo(myFrame)
     
    ----------------------------------------------
    
    
    
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    NEW!
    
    myFrame:CreateBorder(borderSize)
    myFrame:SetBorderSize(borderSize)
    
    myFrame:SetBorderPadding(number or [uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2])
    
    myFrame:SetBorderTexture(texture)
    myFrame:SetBorderShadowTexture(texture)
    
    myFrame:SetBorderColor(r, g, b)
    myFrame:SetBorderShadowColor(r, g, b)
    
    myFrame:HideBorder()
    myFrame:ShowBorder()
    
    myFrame:GetBorder() - true if has a beautycase border, otherwise false
    
    local borderSize, texture, r, g, b, alpha = myFrame:GetBorderInfo()
    
    
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
--]]

local addonName = select(1, GetAddOnInfo('!Beautycase'))
local formatName = '|cffFF0000'..addonName

local textureNormal = 'Interface\\AddOns\\!Beautycase\\media\\textureNormal'
local textureShadow = 'Interface\\AddOns\\!Beautycase\\media\\textureShadow'

local function GetBorder(self)
    if (self.beautyBorder) then
        return true
    else
        return false
    end
end

function GetBorderInfo(self)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.beautyBorder) then
        local tex = self.beautyBorder[1]:GetTexture()
        local size = self.beautyBorder[1]:GetSize()
        local r, g, b, a = self.beautyBorder[1]:GetVertexColor()
        
        return size, tex, r, g, b, a
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')   
    end
end

local function SetBorderPadding(self, uL1, ...)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
        return
    end
    
    if (not self:IsObjectType('Frame')) then
        local frame  = 'frame'
        print(formatName..' error:|r The entered object is not a '..frame..'!') 
        return
    end
    
    local uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
    if (uL1) then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end
    
    local space
    if (GetBorderInfo(self) >= 10) then
        space = 3
    else
        space = GetBorderInfo(self)/3.5
    end
        
    if (self.beautyBorder) then
        self.beautyBorder[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)
        self.beautyShadow[1]:SetPoint('TOPLEFT', self, -(uL1 or 0)-space, (uL2 or 0)+space)
        
        self.beautyBorder[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)
        self.beautyShadow[2]:SetPoint('TOPRIGHT', self, (uR1 or 0)+space, (uR2 or 0)+space)
        
        self.beautyBorder[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))
        self.beautyShadow[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0)-space, -(bL2 or 0)-space)
        
        self.beautyBorder[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))
        self.beautyShadow[4]:SetPoint('BOTTOMRIGHT', self, (bR1 or 0)+space, -(bR2 or 0)-space)
    end
end

function ColorBorder(self, ...)
    local r, g, b, a = ...
    
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.beautyBorder) then
        for i = 1, 8 do
            self.beautyBorder[i]:SetVertexColor(r, g, b, a or 1)
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

function ColorBorderShadow(self, ...)
    local r, g, b, a = ...
    
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.beautyShadow) then
        for i = 1, 8 do
            self.beautyShadow[i]:SetVertexColor(r, g, b, a or 1)
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

function SetBorderTexture(self, texture)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.beautyBorder) then
        for i = 1, 8 do
            self.beautyBorder[i]:SetTexture(texture)
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

function SetBorderShadowTexture(self, texture)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.beautyShadow) then
        for i = 1, 8 do
            self.beautyShadow[i]:SetTexture(texture)
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

local function SetBorderSize(self, size)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.beautyShadow) then
        for i = 1, 8 do
            self.beautyBorder[i]:SetSize(size, size) 
            self.beautyShadow[i]:SetSize(size, size) 
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

local function HideBorder(self)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.beautyShadow) then
        for i = 1, 8 do
            self.beautyBorder[i]:Hide()
            self.beautyShadow[i]:Hide()
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

local function ShowBorder(self)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
    elseif (self.beautyShadow) then
        for i = 1, 8 do
            self.beautyBorder[i]:Show()
            self.beautyShadow[i]:Show()
        end
    else
        print(formatName..' error:|r Invalid frame! This object has no '..addonName..' border')  
    end
end

local function ApplyBorder(self, borderSize, R, G, B, uL1, ...)
    if (not self) then
        print(formatName..' error:|r This frame does not exist!') 
        return
    end
    
    if (not self:IsObjectType('Frame')) then
        local frame  = 'frame'
        print(formatName..' error:|r The entered object is not a '..frame..'!') 
        return
    end
    
    if (self.HasBeautyBorder) then
        return
    end
    
    local uL2, uR1, uR2, bL1, bL2, bR1, bR2 = ...
    if (uL1) then
        if (not uL2 and not uR1 and not uR2 and not bL1 and not bL2 and not bR1 and not bR2) then
            uL2, uR1, uR2, bL1, bL2, bR1, bR2 = uL1, uL1, uL1, uL1, uL1, uL1, uL1
        end
    end
    
    local space
    if (borderSize >= 10) then
        space = 3
    else
        space = borderSize/3.5
    end
        
    if (not self.HasBeautyBorder) then
    
        self.beautyShadow = {}
        for i = 1, 8 do
            self.beautyShadow[i] = self:CreateTexture(nil, 'BORDER')
            self.beautyShadow[i]:SetParent(self)
            self.beautyShadow[i]:SetTexture(textureShadow)
            self.beautyShadow[i]:SetSize(borderSize, borderSize)  
            self.beautyShadow[i]:SetVertexColor(0, 0, 0, 1)
        end
        
        self.beautyBorder = {}
        for i = 1, 8 do
            self.beautyBorder[i] = self:CreateTexture(nil, 'OVERLAY')
            self.beautyBorder[i]:SetParent(self)
            self.beautyBorder[i]:SetTexture(textureNormal)
            self.beautyBorder[i]:SetSize(borderSize, borderSize) 
            self.beautyBorder[i]:SetVertexColor(R or 1, G or 1, B or 1)
        end
        
        self.beautyBorder[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.beautyBorder[1]:SetPoint('TOPLEFT', self, -(uL1 or 0), uL2 or 0)

        self.beautyBorder[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.beautyBorder[2]:SetPoint('TOPRIGHT', self, uR1 or 0, uR2 or 0)

        self.beautyBorder[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.beautyBorder[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0), -(bL2 or 0))

        self.beautyBorder[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.beautyBorder[4]:SetPoint('BOTTOMRIGHT', self, bR1 or 0, -(bR2 or 0))

        self.beautyBorder[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.beautyBorder[5]:SetPoint('TOPLEFT', self.beautyBorder[1], 'TOPRIGHT')
        self.beautyBorder[5]:SetPoint('TOPRIGHT', self.beautyBorder[2], 'TOPLEFT')

        self.beautyBorder[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.beautyBorder[6]:SetPoint('BOTTOMLEFT', self.beautyBorder[3], 'BOTTOMRIGHT')
        self.beautyBorder[6]:SetPoint('BOTTOMRIGHT', self.beautyBorder[4], 'BOTTOMLEFT')

        self.beautyBorder[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.beautyBorder[7]:SetPoint('TOPLEFT', self.beautyBorder[1], 'BOTTOMLEFT')
        self.beautyBorder[7]:SetPoint('BOTTOMLEFT', self.beautyBorder[3], 'TOPLEFT')

        self.beautyBorder[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.beautyBorder[8]:SetPoint('TOPRIGHT', self.beautyBorder[2], 'BOTTOMRIGHT')
        self.beautyBorder[8]:SetPoint('BOTTOMRIGHT', self.beautyBorder[4], 'TOPRIGHT')
        
        self.beautyShadow[1]:SetTexCoord(0, 1/3, 0, 1/3) 
        self.beautyShadow[1]:SetPoint('TOPLEFT', self, -(uL1 or 0)-space, (uL2 or 0)+space)

        self.beautyShadow[2]:SetTexCoord(2/3, 1, 0, 1/3)
        self.beautyShadow[2]:SetPoint('TOPRIGHT', self, (uR1 or 0)+space, (uR2 or 0)+space)

        self.beautyShadow[3]:SetTexCoord(0, 1/3, 2/3, 1)
        self.beautyShadow[3]:SetPoint('BOTTOMLEFT', self, -(bL1 or 0)-space, -(bL2 or 0)-space)

        self.beautyShadow[4]:SetTexCoord(2/3, 1, 2/3, 1)
        self.beautyShadow[4]:SetPoint('BOTTOMRIGHT', self, (bR1 or 0)+space, -(bR2 or 0)-space)

        self.beautyShadow[5]:SetTexCoord(1/3, 2/3, 0, 1/3)
        self.beautyShadow[5]:SetPoint('TOPLEFT', self.beautyShadow[1], 'TOPRIGHT')
        self.beautyShadow[5]:SetPoint('TOPRIGHT', self.beautyShadow[2], 'TOPLEFT')

        self.beautyShadow[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
        self.beautyShadow[6]:SetPoint('BOTTOMLEFT', self.beautyShadow[3], 'BOTTOMRIGHT')
        self.beautyShadow[6]:SetPoint('BOTTOMRIGHT', self.beautyShadow[4], 'BOTTOMLEFT')

        self.beautyShadow[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
        self.beautyShadow[7]:SetPoint('TOPLEFT', self.beautyShadow[1], 'BOTTOMLEFT')
        self.beautyShadow[7]:SetPoint('BOTTOMLEFT', self.beautyShadow[3], 'TOPLEFT')

        self.beautyShadow[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
        self.beautyShadow[8]:SetPoint('TOPRIGHT', self.beautyShadow[2], 'BOTTOMRIGHT')
        self.beautyShadow[8]:SetPoint('BOTTOMRIGHT', self.beautyShadow[4], 'TOPRIGHT')
        
        self.HasBeautyBorder = true
    end
end

function CreateBorder(self, borderSize, R, G, B, uL1, ...)
    ApplyBorder(self, borderSize, R, G, B, uL1, ...)
end

local function FuncCreateBorder(self, borderSize)
    ApplyBorder(self, borderSize)
end

local function addapi(object)
	local mt = getmetatable(object).__index
    
	mt.CreateBorder = FuncCreateBorder
    mt.SetBorderSize = SetBorderSize
    
    mt.SetBorderPadding = SetBorderPadding
    
    mt.SetBorderTexture = SetBorderTexture
    mt.SetBorderShadowTexture = SetBorderShadowTexture
    
    mt.SetBorderColor = ColorBorder
    mt.SetBorderShadowColor = ColorBorderShadow
    
    mt.HideBorder = HideBorder
    mt.ShowBorder = ShowBorder
    
    mt.GetBorder = GetBorder
    mt.GetBorderInfo = GetBorderInfo
end


local handled = {
    ['Frame'] = true
}

local object = CreateFrame('Frame')
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()

while object do
	if (not handled[object:GetObjectType()]) then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end