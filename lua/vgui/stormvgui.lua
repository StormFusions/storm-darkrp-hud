function Storm_AAText( text, font, x, y, color, align )

    draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,math.min(color.a,120)), align )
    draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,math.min(color.a,50)), align )
    draw.SimpleText( text, font, x, y, color, align )

end

local function GetCustomColor()
    local data = file.Exists("hudcolorconfig.txt", "DATA")
    if data then
        local d = file.Read("hudcolorconfig.txt","DATA")
        local str = string.Explode(",", d)
        local color = Color(tonumber(str[1]),tonumber(str[2]),tonumber(str[3]),255)
        return color
    else
        return Color(140,0,0,255)
    end
end

local plycustomcolor = GetCustomColor()

surface.CreateFont( "storm.title", { font = "Trebuchet18", size = 18, weight = 750, antialias = true } )
surface.CreateFont( "storm.med", { font = "Trebuchet18", size = 14, weight = 100, antialias = true })
surface.CreateFont( "storm.small", { font = "Trebuchet18", size = 12, weight = 100, antialias = true })

local CloseB = {}

function CloseB:Init()
    self:SetSize( 16, 16 )
    self:SetText( "" )
    self.Hover = false
    self.OnCursorEntered = function() self.Hover = true end
    self.OnCursorExited = function() self.Hover = false end
end

function CloseB:Paint(w, h)
    Storm_AAText("X", "storm.small", w/2, 4, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
end

vgui.Register("StormClose", CloseB, "DButton")

local FrameS = {}

function FrameS:Init()
    self:MakePopup()
    self:SetTitle( " " )
    self:ShowCloseButton( false )
    self:SetDraggable( false )
end

function FrameS:SetFrameName(text)
    self.Text = text
end

function FrameS:Paint(w, h)
    Derma_DrawBackgroundBlur( self, 0 ) 

    draw.RoundedBox(0, 0, 25, w, h, Color(0, 0, 0, 255))
    draw.RoundedBox(0, 5, 30, w-10, h-35, Color(30, 30, 30, 255))
    draw.RoundedBox(0, 0, 0, w, 25, plycustomcolor)
    
    Storm_AAText(self.Text, "storm.med", 5, 5, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
end

vgui.Register("StormFrameMenu", FrameS, "DFrame")

local SetButton = {}

function SetButton:Init()
    self:SetText("")
    self.Hover = false
    self.OnCursorEntered = function() self.Hover = true end
    self.OnCursorExited = function() self.Hover = false end
end

function SetButton:SetButtonText(text)
    self.Text = text
end

function SetButton:Paint(w,h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 140, 0, 255))        

    if self.Hover then
        draw.RoundedBox(0, 2, 2, w-4, h-4, Color(0, 200, 0, 255))
    end
    
    Storm_AAText( self.Text, "storm.title", w/2, 6, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
end

vgui.Register("StormSetButton", SetButton, "DButton")
