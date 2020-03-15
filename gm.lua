-- gm.lua
-- Implements gamemode and gm commands and console commands
-- Modified for the Aedificium platform.

-- Used to translate gamemodes into strings
local GameModeNameTable =
{
	[gmSurvival]  = "survival",
	[gmCreative]  = "creative",
	[gmAdventure] = "adventure",
	[gmSpectator] = "spectator",
}

-- Translate strings to their representative gamemodes
-- All options from vanilla minecraft
local GameModeTable =
{
	["0"]         = gmSurvival,
	["survival"]  = gmSurvival,
	["s"]         = gmSurvival,
	["1"]         = gmCreative,
	["creative"]  = gmCreative,
	["c"]         = gmCreative,
	["2"]         = gmAdventure,
	["adventure"] = gmAdventure,
	["a"]         = gmAdventure,
	["3"]         = gmSpectator,
	["spectator"] = gmSpectator,
	["sp"]        = gmSpectator,
}

local MessageFailure = "Couldn't find that player."

--- Changes the gamemode of the given player
-- 
--  @param GameMode The gamemode to change to
--  @param PlayerName The player name of the player to change the gamemode of
--  
--  @return true if player was found and gamemode successfully changed, false otherwise
--  
local function ChangeGameMode( GameMode, PlayerName )

	local GMChanged = false
	local lcPlayerName = string.lower(PlayerName)

	-- Search through online players and if one matches
	-- the given PlayerName then change their gamemode
	cRoot:Get():FindAndDoWithPlayer(PlayerName, 
		function(PlayerMatch)
			if string.lower(PlayerMatch:GetName()) == lcPlayerName then
				PlayerMatch:SetGameMode(GameMode)
				SendMessage(PlayerMatch, cChatColor.LightGray .. "Set your gamemode to " .. GameModeNameTable[GameMode] .. ".")
				GMChanged = true
			end
			return true
		end
	)

	return GMChanged

end

--- Handles the `/gamemode <survival|creative|adventure|spectator> [player]` in-game command
--  
function HandleChangeGMCommand(Split, Player)

	-- Check params, translate into gamemode and player name:
	local GameMode = GameModeTable[Split[2]]

	if not GameMode then
		SendMessage(Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " <survival|creative|adventure|spectator> [player]")
		return true
	end

	local PlayerToChange = Split[3] or Player:GetName()

	-- Report success or failure:
	if ChangeGameMode( GameMode, PlayerToChange ) then

		local Message = PlayerToChange .. "'s gamemode was set to " .. GameModeNameTable[GameMode]
		local MessageTail = " by the player " .. Player:GetName()

		if PlayerToChange ~= Player:GetName() then
			SendMessageSuccess(Player, cChatColor.LightGray .. Message .. ".")
		end

		LOGINFO(Message .. MessageTail .. ".")

	else
		SendMessageFailure(Player, cChatColor.LightGray .. MessageFailure)
	end

	return true
end

--- Handles the `gamemode <survival|creative|adventure|spectator> [player]` console command
--  
function HandleConsoleGamemode( a_Split )

	-- Check params, translate into gamemode and player name:
	local GameMode = GameModeTable[a_Split[2]]
	local PlayerToChange = a_Split[3]
	
	if not PlayerToChange or not GameMode then
		return true, "Usage: " .. a_Split[1] .. " <survival|creative|adventure|spectator> <player>"
	end

	-- Report success or failure:
	if ChangeGameMode( GameMode, PlayerToChange ) then

		local Message = PlayerToChange .. "'s gamemode was set to " .. GameModeNameTable[GameMode]
		local MessageTail = " by the " .. "console"

		LOGINFO(Message .. MessageTail .. ".")

	else
		LOG(MessageFailure)
	end
	
	return true
end
