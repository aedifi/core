function HandleKickCommand( Split, Player )

	if( #Split < 2 ) then
		SendMessage(Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " <player> [reason]")
		return true
	end

	local Reason = cChatColor.Rose .. "You have been kicked."
	if ( #Split > 2 ) then
		Reason = table.concat( Split, " ", 3 )
	end
	local IsPlayerKicked = false
	local Kick = function(OtherPlayer)
		if (OtherPlayer:GetName() == Split[2]) then
			IsPlayerKicked = true
			KickPlayer(Split[2], Reason)
		end
	end

	cRoot:Get():FindAndDoWithPlayer(Split[2], Kick)
	if (IsPlayerKicked) then
		SendMessage(Player, cChatColor.LightGray .. "Kicked the player " .. Split[2] .. ".")
		return true
	end
	if (IsPlayerKicked == false) then
		SendMessageFailure( Player, cChatColor.LightGray .. "Couldn't find that player.")       
		return true
	end
end
