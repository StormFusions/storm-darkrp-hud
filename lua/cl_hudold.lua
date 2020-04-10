

surface.CreateFont( "Storm_Small", { font = "Ebrima", size = 20, weight = 1000, antialias = true } )
surface.CreateFont( "Storm_Info", { font = "Ebrima", size = 31, weight = 1000, antialias = true } )

function draw.AAText( text, font, x, y, color, align )

    draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,math.min(color.a,120)), align )
    draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,math.min(color.a,50)), align )
    draw.SimpleText( text, font, x, y, color, align )

end

local HUD = {}
HUD.BGx	= 10
HUD.BGy = ScrH()-135

HUD.TOPx = ScrW()/2-40
HUD.TOPy = 5

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

----------------------------------------------------------------------

function playerteam(ply)
	if ply:Alive() and ply:Team() == TEAM_RUNNER then
		return "Runner"
	elseif ply:Alive() and ply:Team() == TEAM_DEATH then
		return "Death"
	else 
		return "*DEAD*"
	end
end

function playerteamcolor(ply)
	if ply:Alive() then
		return team.GetColor(ply:Team())
	else
		return Color(255, 0, 0, 255)
	end
end

------------------------------------------------------------------------

local avatar = vgui.Create("AvatarImage", self)
avatar:SetPos(HUD.BGx+2, HUD.BGy+2)
avatar:SetSize(64, 64)

-------------------------------------------------------------------------

local GRADIENT_UP = Material("vgui/gradient_up")
function storm_create_hud()
	local ply = LocalPlayer()
	local ob = ply:GetObserverTarget() 

	local newcolor = GetCustomColor()

	draw.RoundedBox(4, HUD.BGx-2, HUD.BGy-2, 350, 135, Color(0, 0, 0, 230))
	--draw.RoundedBox(4, HUD.BGx, HUD.BGy, 346, 146, Color(120, 120, 120, 255) )

	draw.RoundedBoxEx(4, HUD.BGx+72, HUD.BGy, 274, 70, newcolor, false, true, false, false)
	draw.RoundedBoxEx(4, HUD.BGx, HUD.BGy+70, 346, 61, newcolor, false, false, true, true)

	draw.RoundedBox(0, HUD.BGx-2, HUD.BGy+70, 350, 2, Color(30,30,30,255))
	draw.RoundedBox(0, HUD.BGx-2, HUD.BGy+70-2, 350, 2, Color(90,90,90,255))

	draw.RoundedBox(0, HUD.BGx+70, HUD.BGy, 2, 70, Color(30,30,30,255))
	draw.RoundedBox(0, HUD.BGx+70+2, HUD.BGy, 2, 70, Color(90,90,90,255))

	draw.RoundedBox(4, HUD.TOPx, HUD.TOPy, 80, 40, Color(0, 0, 0, 255))
	draw.RoundedBox(4, HUD.TOPx+2, HUD.TOPy+2, 76, 36, newcolor)

	local rt = string.ToMinutesSeconds(GAMEMODE:GetRoundTime())

	draw.AAText(tostring(rt), "Storm_Info", HUD.TOPx+10, HUD.TOPy+4, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	draw.AAText(ply:Name(), "Storm_Info", HUD.BGx+84, HUD.BGy+33, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
 

	if ob and IsValid(ob) and ob:IsPlayer() and ob:Alive() then 
		ply = ob

		local playername = ply:Name()

		surface.SetFont("Storm_Info")
		local NameSize = surface.GetTextSize(playername)

		draw.RoundedBox(4, 5, 5, 12+NameSize, 40, Color(0, 0, 0, 255))
		draw.RoundedBox(4, 7, 7, 8+NameSize, 36, newcolor)

		
		draw.AAText(ply:Name(), "Storm_Info", 10, 10, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	end

	avatar:SetPlayer(ply, 100)

	--Information Text
	surface.SetFont("Storm_Info")
	local TeamSize = surface.GetTextSize("Team: ")

	draw.AAText("Team: ", "Storm_Info", HUD.BGx+84, HUD.BGy, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	draw.AAText(playerteam(ply), "Storm_Info", HUD.BGx+84+TeamSize, HUD.BGy, playerteamcolor(ply), TEXT_ALIGN_LEFT)
	
	--Health/Velocity

	draw.AAText("Health", "Storm_Small", HUD.BGx+7, HUD.BGy+76, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
	draw.AAText("Speed", "Storm_Small", HUD.BGx+9, HUD.BGy+105, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

	draw.RoundedBox(4, HUD.BGx+58, HUD.BGy+76, 280, 25, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)

	draw.RoundedBox(4, HUD.BGx+58, HUD.BGy+104, 280, 25, Color(0, 0, 0, 255))

	--draw.RoundedBox(4, HUD.HVx+59, HUD.HVy+7, 310, 28, Color(0, 0, 0, 250))

	local BL, Border = 278, 2
	local hp = ply:Alive() and ply:Health() or 0 
	local thp = ply:Alive() and ply:Health() or 0
	if thp < 0 then thp = 0 elseif thp > 100 then thp = 100 end
	if hp != 0 then
		if hp > 0 then
			local hpbar = (BL - Border) * (math.Clamp(hp,0,100)/100)

			draw.RoundedBox(4, HUD.BGx+60, HUD.BGy+78, hpbar, 21, Color(230, 0, 0, 255), TEXT_ALIGN_LEFT)
		end
	end
	draw.AAText(tostring(thp), "Storm_Small", HUD.BGx+195, HUD.BGy+77, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

	--Velocity Bar/Text
	
	local vel = ply:GetVelocity():Length2D() or 0
	if ply:Alive() then
		if vel > 0 then
			local velbar = Lerp(vel/1500, 5, 276)

			draw.RoundedBox(4, HUD.BGx+60, HUD.BGy+106, velbar, 21, Color(0, 100, 200, 255))
		end
		draw.AAText(math.floor(vel), "Storm_Small", HUD.BGx+195, HUD.BGy+105, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end

	GAMEMODE.BaseClass:HUDPaint()

end

hook.Add("HUDPaint", "storm_hud", storm_create_hud)

function storm_hudtargetplayer()
	local ob = LocalPlayer():GetObserverTarget()
	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end

	local text = "ERROR"
	local font = "TargetID"

	if (trace.Entity:IsPlayer()) then
		if ob then return end
		text = trace.Entity:Nick()
	else
		return
		--text = trace.Entity:GetClass()
	end

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	local MouseX, MouseY = gui.MousePos()

	if ( MouseX == 0 && MouseY == 0 ) then

		MouseX = ScrW() / 2
		MouseY = ScrH() / 2

	end

	local x = MouseX
	local y = MouseY

	x = x - w / 2
	y = y + 30

	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )

	y = y + h + 5

	local text = "Health:" .. trace.Entity:Health()
	local font = "TargetIDSmall"

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	local x =  MouseX  - w / 2

	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )


end

hook.Add("HUDDrawTargetID", "storm_targetid", storm_hudtargetplayer)

local HUDHide = {
	
	["CHudHealth"] = true,
	["CHudSuitPower"] = true,
	["CHudBattery"] = true,
	--["CHudAmmo"] = true,
	--["CHudSecondaryAmmo"] = true,

}

function storm_hidey( No )
	if HUDHide[No] then return false end

	return true
end
hook.Add("HUDShouldDraw", "storm_hidey", storm_hidey)