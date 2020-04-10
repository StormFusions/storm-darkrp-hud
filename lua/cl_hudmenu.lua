
local Storm = {}

function Storm.CreateFile(color)
	local str = tostring(color.r)..","..tostring(color.g)..","..tostring(color.b)

	file.Write("hudcolorconfig.txt",str)

end

function Storm.CreateCloseButton(frame)
    local Close = vgui.Create("StormClose", frame)
    Close:SetPos(frame:GetWide()-24, 2)
    Close.DoClick = function()
        frame:Close()
    end
end

function Storm.hudcolormenu()
	local Frame = vgui.Create("StormFrameMenu")
	Frame:SetSize(400, 420)
	Frame:Center()
	Frame:SetFrameName("HUD Colour Menu")

	Storm.CreateCloseButton(Frame)

    local ColorPanel = vgui.Create("DColorMixer", Frame)
	ColorPanel:SetSize(380, 310)
	ColorPanel:SetPos(10, 38)
	ColorPanel:SetPalette( true )
	ColorPanel:SetAlphaBar( false )
	ColorPanel:SetWangs( true )
	ColorPanel:SetColor( Color( 255, 255, 255 ) )

    local dcombo = vgui.Create("DComboBox", Frame)
    dcombo:SetSize(380, 20)
    dcombo:SetPos(10, Frame:GetTall()-65)
    dcombo:SetValue("HUD Position (Not required to set everytime you changing colors)")
    dcombo:AddChoice("Top_Left")
    dcombo:AddChoice("Bottom_Left")
    dcombo:AddChoice("Top_Right")
    dcombo:AddChoice("Bottom_Right")
    dcombo.OnSelect = function(self, index, value)
        RunConsoleCommand("storm_hudpos", index)
    end

    local setbutton = vgui.Create( "StormSetButton", Frame )
    setbutton:SetPos( 10, Frame:GetTall()-40 )
    setbutton:SetSize( Frame:GetWide()-20, 32 )
    setbutton:SetButtonText("Set")
    setbutton.DoClick = function()
    	local ply = LocalPlayer() 
    	local color = ColorPanel:GetColor()

		Storm.CreateFile(color)

        timer.Simple(0.2, function() Frame:Remove() end)
    end
end
--
concommand.Add("hudcolormenu", Storm.hudcolormenu)