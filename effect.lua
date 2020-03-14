function HandleEffectCommand(Split, Player)
	if Split[4] == nil then
		Split[4] = 30
	end
	if Split[5] == nil then
		Split[5] = 0
	end
	local EffectID = tonumber(Split[3])
	local Amplifier = tonumber(Split[5])
	local ApplyEffect = function(OtherPlayer)
		local Seconds = tonumber(Split[4]) * 20
		OtherPlayer:AddEntityEffect(EffectID, Seconds, Amplifier)
		if Split[2] ~= "@a" then
			Player:SendMessageSuccess(cChatColor.LightGray .. "Added effect to " .. OtherPlayer:GetName() .. " for " .. Split[4] .. " seconds.")
		end
	end
	local RemoveEffects = function(OtherPlayer)
		OtherPlayer:ClearEntityEffects()
		if Split[2] ~= "@a" then
			Player:SendMessageSuccess(cChatColor.LightGray .. "Removed effects from " .. OtherPlayer:GetName() .. ".")
		end
	end
	if Split[3] ~= "clear" then
		if Split[3] == nil then
			Player:SendMessageInfo(cChatColor.LightGray .. "Usage: " .. Split[1] .. " <player> <effect> [seconds] [amplifier] | " .. Split[1] .. " <player> clear")
		elseif EffectID == nil or EffectID < 1 or EffectID > 23 then
			Player:SendMessageFailure(cChatColor.LightGray .. "Invalid effect: " .. Split[3])
		elseif tonumber(Split[4]) == nil then
			Player:SendMessageFailure(cChatColor.LightGray .. "Invalid duration: " .. Split[4])
		elseif tonumber(Split[4]) < 0 then
			Player:SendMessageFailure(cChatColor.LightGray .. "Duration in seconds must be a positive integer.")
		elseif tonumber(Split[4]) > 1000000 then
			Player:SendMessageFailure(cChatColor.LightGray .. "Duration in seconds must not exceed one million.")
		elseif Amplifier == nil then
			Player:SendMessageFailure(cChatColor.LightGray .. "Invalid amplification: " .. Split[5] .. ".")
		elseif Amplifier < 0 then
			Player:SendMessageFailure(cChatColor.LightGray .. "Amplification must be a positive integer.")
		elseif Amplifier > 24 and EffectID == 19 or Amplifier > 24 and EffectID == 20 then
			Player:SendMessageFailure(cChatColor.LightGray .. "Amplification must not exceed twenty-four.")
		elseif Amplifier > 49 and EffectID == 10 then
			Player:SendMessageFailure(cChatColor.LightGray .. "Amplification must not exceed forty-nine.")
		elseif Amplifier > 255 then
			Player:SendMessageFailure(cChatColor.LightGray .. "Amplification must not exceed two hundred and fifty-five.")
		elseif Split[2] == "@a" then
			cRoot:Get():ForEachPlayer(ApplyEffect)
			LOGINFO(Player:GetName() .. " applied a global effect.")
			Player:SendMessageSuccess(cChatColor.LightGray .. "Added effect to every player for " .. Split[4] .. " seconds.")
		else
			if not cRoot:Get():FindAndDoWithPlayer(Split[2], ApplyEffect) then
				Player:SendMessageFailure(cChatColor.LightGray .. "Couldn't find that player.")
			end
		end
	else
		if Split[2] == "@a" then
			cRoot:Get():ForEachPlayer(RemoveEffects)
			LOGINFO(Player:GetName() .. " globally cleared effects.")
			Player:SendMessageSuccess(cChatColor.LightGray .. "Removed effects from every player.")
		else
			if not cRoot:Get():FindAndDoWithPlayer(Split[2], RemoveEffects) then
				Player:SendMessageFailure(cChatColor.LightGray .. "Couldn't find that player.")
			end
		end
	end
	return true
end
