function HandleDoCommand(Split, Player)

	if #Split < 3 then
		SendMessage(Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " <player> <command> [arguments]")
		return true
	end

	-- Get the command and arguments.
	local newSplit = table.concat(Split, " ", 3)

	local FoundPlayerCallback = function(a_Player)
		local pluginManager = cRoot:Get():GetPluginManager()
		if (pluginManager:ExecuteCommand(a_Player, newSplit)) then
			LOGINFO(Player:GetName() .. " executed a sudo command.")
			SendMessageSuccess(Player, cChatColor.LightGray .. "Executed the command.")
		else
			LOGINFO(Player:GetName() .. " failed to execute a sudo command.")
			SendMessageFailure(Player, cChatColor.LightGray .. "Couldn't execute that command.")
		end
		return true
	end

	if not cRoot:Get():FindAndDoWithPlayer( Split[2], FoundPlayerCallback ) then
		SendMessageFailure(Player, cChatColor.LightGray .. "Couldn't find that player.")
		return true
	end
	
	return true
end

function HandleSudoCommand ( Split, Player )

if #Split < 3 then
		SendMessage(Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " <player> <command> [arguments]")
		return true
	end

	-- Get the command and arguments.
	local newSplit = table.concat( Split, " ", 3 )

	local FoundPlayerCallback = function( a_Player )
		local pluginManager = cRoot:Get():GetPluginManager()
		if (pluginManager:ForceExecuteCommand( a_Player, newSplit )) then
			LOGINFO(Player:GetName() .. " executed a sudo command.")
			SendMessageSuccess(Player, cChatColor.LightGray .. "Executed the command.")
		else
			LOGINFO(Player:GetName() .. " failed to execute a sudo command.")
			SendMessageFailure(Player, cChatColor.LightGray .. "Couldn't execute that command.")
		end
		return true
	end

	if not cRoot:Get():FindAndDoWithPlayer( Split[2], FoundPlayerCallback ) then
		SendMessageFailure(Player, cChatColor.LightGray .. "Couldn't find that player.")
		return true
	end
	
	return true
end
