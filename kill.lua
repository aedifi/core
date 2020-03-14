function HandleKillCommand( Split, Player )

	if (Split[2] == nil) then
		LOGINFO(Player:GetName() .. " used commands to kill themselves.")
		Player:TakeDamage(dtInVoid, nil, 1000, 1000, 0)
		return true
	end

	local HasKilled = false
	local KillPlayer = function(OtherPlayer)
		if (OtherPlayer:GetName() == Split[2]) then
				OtherPlayer:TakeDamage(dtPlugin, nil, 1000, 1000, 0)
				HasKilled = true
		end
	end

	cRoot:Get():FindAndDoWithPlayer(Split[2], KillPlayer)
	if (HasKilled) then
		LOGINFO(Player:GetName() .. " used commands to kill " .. Split[2] .. ".")
		SendMessageSuccess(Player, cChatColor.LightGray .. "Killed the player " .. Split[2] .. ".")
		return true
	else
		SendMessageFailure(Player, cChatColor.LightGray .. "Couldn't find that player.")
		return true
	end

end
