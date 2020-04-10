
hook.Add("PlayerSay", "hudchatcommand_storm", function(ply,text)

	if string.lower(text) == "!hud" then
		ply:ConCommand("hudcolormenu")
		return ""
	end

end)