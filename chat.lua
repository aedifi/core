function HandleSayCommand(Split, Player)
	if (Split[2] == nil) then
		SendMessage(Player, cChatColor.LightGray .. "Usage: " ..Split[1].. " <message>")
		return true
	end

	cRoot:Get():BroadcastChat("" .. Player:GetName() .. " says " .. table.concat(Split, " ", 2))
	return true
end
