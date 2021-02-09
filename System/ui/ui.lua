local DiesalGUI = LibStub("DiesalGUI-1.0")

-- Global setup
br.ui = {}
br.spacing = 15
 --
local BRFont = "DiesalFontNormal"
do
    local locale = GetLocale()
    if locale == "koKR" or locale == "zhCN" or locale == "zhTW" then
        BRFont = "GameFontNormalSmall"
    end
end


--[[ FROM PE ]]
DiesalGUI:RegisterObjectConstructor(
    "FontString",
    function()
        local self = DiesalGUI:CreateObjectBase(Type)
        local frame = CreateFrame("Frame", nil, UIParent)
        local fontString = frame:CreateFontString(nil, "OVERLAY", BRFont)
        self.frame = frame
        self.fontString = fontString
        self.SetParent = function(self, parent)
            self.frame:SetParent(parent)
        end
        self.OnRelease = function(self)
            self.fontString:SetText("")
        end
        self.OnAcquire = function(self)
            self:Show()
        end
        self.type = "FontString"
        return self
    end,
    1
)

-- Styles
br.ui.buttonStyleSheet = {
    ["frame-color"] = {
        type = "texture",
        layer = "BACKGROUND",
        color = "2f353b",
        offset = 0
    },
    ["frame-highlight"] = {
        type = "texture",
        layer = "BORDER",
        gradient = "VERTICAL",
        color = "FFFFFF",
        alpha = 0,
        alphaEnd = .1,
        offset = -1
    },
    ["frame-outline"] = {
        type = "outline",
        layer = "BORDER",
        color = "000000",
        offset = 0
    },
    ["frame-inline"] = {
        type = "outline",
        layer = "BORDER",
        gradient = "VERTICAL",
        color = "ffffff",
        alpha = .02,
        alphaEnd = .09,
        offset = -1
    },
    ["frame-hover"] = {
        type = "texture",
        layer = "HIGHLIGHT",
        color = "ffffff",
        alpha = .1,
        offset = 0
    },
    ["text-color"] = {
        type = "Font",
        color = "b8c2cc"
    }
}
br.ui.arrowRight = {
    type = "texture",
    offset = {-2, nil, -2, nil},
    height = 16,
    width = 16,
    alpha = .7,
    image = {"DiesalGUIcons", {7, 5, 16, 256, 128}}
}
br.ui.arrowLeft = {
    type = "texture",
    offset = {-2, nil, -2, nil},
    height = 16,
    width = 16,
    alpha = .7,
    image = {"DiesalGUIcons", {8, 5, 16, 256, 128}}
}
br.ui.messageStylesheet = {
    ["track-background"] = {
        type = "texture",
        layer = "BACKGROUND",
        color = "0e0e0e"
    },
    ["track-outline"] = {
        type = "outline",
        layer = "BORDER",
        color = "060606"
    },
    ["grip-background"] = {
        type = "texture",
        layer = "BACKGROUND",
        gradient = "HORIZONTAL",
        color = "5d5d5d",
        colorEnd = "252525"
    },
    ["grip-outline"] = {
        type = "outline",
        layer = "BORDER",
        color = "060606"
    }
}
