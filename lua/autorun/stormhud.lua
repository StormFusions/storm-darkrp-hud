if SERVER then
	AddCSLuaFile("cl_hud.lua")
	AddCSLuaFile("cl_hudmenu.lua")
	include("sv_hud.lua")
else
	include("cl_hud.lua")
	include("cl_hudmenu.lua")
end