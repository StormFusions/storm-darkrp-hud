
local hud = {}

surface.CreateFont("stormhud.name", {
	font = "Trebuchet24",
	size = 24,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 
surface.CreateFont("stormhud.health", {
	font = "Trebuchet18",
	size = 12,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 
surface.CreateFont("stormhud.small", {
	font = "Trebuchet18",
	size = 18,
	weight = 5000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
}) 

local wantedstar = Material("materials/icon16/star.png", "smooth")
local gunlicensepng = Material("materials/icon16/page.png", "smooth")

function hud.AAText( text, font, x, y, color, align )

    draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,math.min(color.a,120)), align )
    draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,math.min(color.a,50)), align )
    draw.SimpleText( text, font, x, y, color, align )

end

function hud.formatCurrency( number )
	local output = tonumber(number)
	if number < 1000000 then
		output = string.gsub( number, "^(-?%d+)(%d%d%d)", "%1,%2" ) 
	elseif number > 1000000000 then
		output = string.gsub( number, "^(-?%d+)(%d%d%d)(%d%d%d)(%d%d%d)", "%1,%2,%3,%4" )
	else
		output = string.gsub( number, "^(-?%d+)(%d%d%d)(%d%d%d)", "%1,%2,%3" )
	end

	return output
end 

function hud.GetCustomColor()
	if file.Exists("hudcolorconfig.txt", "DATA") then
		local data = file.Read("hudcolorconfig.txt","DATA")
		local str = string.Explode(",",data)
		local color = Color(tonumber(str[1]),tonumber(str[2]),tonumber(str[3]),255)
		return color
	else
		return Color(140,0,0,255)
	end
end

CreateClientConVar( "storm_hudpos", 2, true, false )

--Settings

local avatar = vgui.Create("AvatarImage", self)

function hud.Paint()
	local ply = LocalPlayer()

	--Settings
	local hudconvar = GetConVarNumber("storm_hudpos")

	if hudconvar == 1 then
		hud.x = 15
		hud.y = 15
		
	elseif hudconvar == 2 then
		hud.x = 15
		hud.y = ScrH()-160
	elseif hudconvar == 3 then
		hud.x = ScrW()-365
		hud.y = 15
	elseif hudconvar == 4 then
		hud.x = ScrW()-365
		hud.y = ScrH()-165
	else
		hud.x = 15
		hud.y = ScrH()-165
	end

	hud.avatarx = hud.x+5
	hud.avatary = hud.y+5
	hud.infox = hud.x+74
	hud.infoy = hud.y+5
	hud.healthx = hud.x+5
	hud.healthy = hud.y+74


	local plycustom = hud.GetCustomColor()

	--background
	draw.RoundedBox(0,hud.x, hud.y, 350, 150, Color(60,60,60,255))
	draw.RoundedBox(0, hud.infox, hud.infoy, 271, 64, plycustom)

	draw.RoundedBox(0, hud.healthx, hud.healthy, 340, 71, plycustom )

	avatar:SetPos(hud.avatarx, hud.avatary)
	avatar:SetSize(64, 64)
	avatar:SetPlayer(ply, 100)

	surface.SetMaterial(wantedstar)
	local wanted = ply:getDarkRPVar("wanted")
	if wanted then
		surface.SetDrawColor(Color(255,255,255,255))
	else
		surface.SetDrawColor(Color(0,0,0,255))
	end
	surface.DrawTexturedRect(hud.infox+250,hud.infoy+5, 16,16)

	surface.SetMaterial(gunlicensepng)
	local gunlicense = ply:getDarkRPVar("HasGunlicense")
	if gunlicense then
		surface.SetDrawColor(Color(255,255,255,255))
	else
		surface.SetDrawColor(Color(0,0,0,255))
	end
	surface.DrawTexturedRect(hud.infox+250, hud.infoy+44, 16, 16)

	hud.AAText("Job: "..ply:getDarkRPVar("job"), "stormhud.small", hud.infox+5, hud.infoy, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	hud.AAText("Salary: "..ply:getDarkRPVar("salary"), "stormhud.small", hud.infox+5, hud.infoy+15, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	hud.AAText("Money: "..hud.formatCurrency(ply:getDarkRPVar("money")), "stormhud.small", hud.infox+5, hud.infoy+30, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	hud.AAText("Name: "..ply:Name(), "stormhud.small", hud.infox+5, hud.infoy+45, Color(255,255,255,255), TEXT_ALIGN_LEFT)

	local barhealthx = hud.healthx+5
	local barhealthy = hud.healthy+15
	local bararmorx = hud.healthx+5
	local bararmory = hud.healthy+40
	
	local BL, Border = 327, 2
	local hp = ply:Alive() and ply:Health() or 0 

	if ply:getDarkRPVar("Energy") then
		local hunger = ply:getDarkRPVar("Energy")
		draw.RoundedBox(4, hud.healthx+5, hud.healthy+50, 330, 15, Color(60,60,60,255))

		barhealthx = hud.healthx+5
		barhealthy = hud.healthy+5
		bararmorx = hud.healthx+5
		bararmory = hud.healthy+27

		if hunger ~= 0 then
			if hunger > 0 then
				local hungerbar = (BL - Border) * (math.Clamp(hunger,0,100)/100)

				draw.RoundedBox(4, hud.healthx+8, hud.healthy+52, hungerbar, 10, Color(0, 170, 0, 255))
			end
		end
		hud.AAText(hunger, "stormhud.health", hud.healthx+170, hud.healthy+51, Color(255,255,255,255), TEXT_ALIGN_CENTER)
	end

	draw.RoundedBox(4, barhealthx, barhealthy, 330, 15, Color(60,60,60,255))
	draw.RoundedBox(4, bararmorx, bararmory, 330, 15, Color(60,60,60,255))

	if hp ~= 0 then
		if hp > 0 then
			local hpbar = (BL - Border) * (math.Clamp(hp,0,100)/100)

			draw.RoundedBox(4, barhealthx+3, barhealthy+2, hpbar, 10, Color(230, 0, 0, 255))
		end
	end
	hud.AAText(ply:Health(), "stormhud.health", hud.healthx+170, barhealthy+1, Color(255,255,255,255), TEXT_ALIGN_CENTER)

	local armor = ply:Armor() or 0
	if armor ~= 0 then
		if armor > 0 then
			local armorbar = (BL - Border) * (math.Clamp(armor,0,100)/100)

			draw.RoundedBox(4, bararmorx+3, bararmory+2, armorbar, 10, Color(0, 0, 170, 255))
		end
	end
	hud.AAText(ply:Armor(), "stormhud.health", hud.healthx+170, bararmory+1, Color(255,255,255,255), TEXT_ALIGN_CENTER)

	

	GAMEMODE.BaseClass:HUDPaint()
end

hook.Add("HUDPaint", "storm_hud", hud.Paint)

local HUDHide = {
	
	["CHudHealth"] = true,
	["CHudSuitPower"] = true,
	["CHudBattery"] = true,
	["DarkRP_HUD"] = true,
	["DarkRP_Hungermod"] = true,
	--["CHudAmmo"] = true,
	--["CHudSecondaryAmmo"] = true,

}

function hud.Hide( No )
	if HUDHide[No] then return false end

	return true
end
hook.Add("HUDShouldDraw", "storm_hidey", hud.Hide)
