local MobDamages =
{
	["cSpider"]       = { 2, 2, 3  },
	["cEnderman"]     = { 4, 7, 10 },
	["cZombie"]       = {          },  -- Handled in OnTakeDamage()
	["cSlime"]        = { 4, 4, 4  },
	["cCaveSpider"]   = { 2, 2, 3  },
	["cZombiePigman"] = { 5, 9, 13 },
	["cSkeleton"]     = { 2, 2, 3  },
	["cBlaze"]        = { 4, 6, 9  }
}

local IsEntityBlockedInPeaceful =
{
	["cZombie"]       = true,
	["cZombiePigman"] = true,
	["cSpider"]       = true,
	["cCaveSpider"]   = true,
	["cEnderman"]     = true,
	["cEnderDragon"]  = true,
	["cSkeleton"]     = true,
	["cGhast"]        = true,
	["cCreeper"]      = true,
	["cSilverfish"]   = true,
	["cBlaze"]        = true,
	["cSlime"]        = true,
	["cWitch"]        = true,
	["cWither"]       = true,
	["cSilverfish"]   = true,
	["cGuardian"]     = true,
}

function HandleDifficultyCommand ( Split, Player )
	if (Split[2] == nil) then
		if (#Split == 1) then
			SendMessage(Player, cChatColor.LightGray .. "Current world difficulty: " .. GetWorldDifficulty(Player:GetWorld()))
			SendMessage(Player, cChatColor.LightGray .. "To change: " .. Split[1] .. " <peaceful|easy|normal|hard>")
		else
			SendMessage( Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " <peaceful|easy|normal|hard>" )
		end
		return true
	end

	if (Split[2] == "peaceful") or (Split[2] == "0") or (Split[2] == "p") then
		SetWorldDifficulty(Player:GetWorld(), 0)
		LOGINFO(Player:GetName() .. " set the world difficulty to peaceful.")
		SendMessage(Player, cChatColor.LightGray .. "Set the world difficulty to peaceful.")

		--Remove mobs which are not allowed in peaceful
		Player:GetWorld():ForEachEntity(
			function (a_Entity)
				if not(a_Entity:IsMob()) then
					return
				end
				if (a_Entity:GetMobFamily() == cMonster.mfHostile) then
					a_Entity:Destroy()
				end
			end
		)
	elseif (Split[2] == "easy") or (Split[2] == "1") or (Split[2] == "e") then
		SetWorldDifficulty(Player:GetWorld(), 1)
		LOGINFO(Player:GetName() .. " set the world difficulty to easy.")
		SendMessage(Player, cChatColor.LightGray .. "Set the world difficulty to easy.")
	elseif (Split[2] == "normal") or (Split[2] == "2") or (Split[2] == "n") then
		SetWorldDifficulty(Player:GetWorld(), 2)
		LOGINFO(Player:GetName() .. " set the world difficulty to normal.")
		SendMessage(Player, cChatColor.LightGray .. "Set the world difficulty to normal.")
	elseif (Split[2] == "hard") or (Split[2] == "3") or (Split[2] == "h") then
		SetWorldDifficulty(Player:GetWorld(), 3)
		LOGINFO(Player:GetName() .. " set the world difficulty to hard.")
		SendMessage(Player, cChatColor.LightGray .. "Set the world difficulty to hard.")
	else
		SendMessage(Player, cChatColor.LightGray .. "Usage: " .. Split[1] .. " <peaceful|easy|normal|hard>")
	end

	return true
end

function OnTakeDamage(Receiver, TDI)
	if (TDI.Attacker == nil) then
		return false
	end

	local Attacker = TDI.Attacker
	local WorldDifficulty = GetWorldDifficulty(Attacker:GetWorld())

	if Attacker:IsA("cZombie") then
		-- The damage value from the zombie is computed from the zombie health. See http://minecraft.gamepedia.com/Zombie
		if (WorldDifficulty == 1) then
			if (Attacker:GetHealth() >= 16)     then TDI.FinalDamage = 2
			elseif (Attacker:GetHealth() >= 11) then TDI.FinalDamage = 3
			elseif (Attacker:GetHealth() >= 6)  then TDI.FinalDamage = 3
			else TDI.FinalDamage = 4 end
		elseif (WorldDifficulty == 2) then
			if (Attacker:GetHealth() >= 16)     then TDI.FinalDamage = 3
			elseif (Attacker:GetHealth() >= 11) then TDI.FinalDamage = 4
			elseif (Attacker:GetHealth() >= 6)  then TDI.FinalDamage = 5
			else TDI.FinalDamage = 6 end
		elseif (WorldDifficulty == 3) then
			if (Attacker:GetHealth() >= 16)     then TDI.FinalDamage = 4
			elseif (Attacker:GetHealth() >= 11) then TDI.FinalDamage = 6
			elseif (Attacker:GetHealth() >= 6)  then TDI.FinalDamage = 7
			else TDI.FinalDamage = 9 end
		end
		return false
	end

	local Damages = MobDamages[Attacker:GetClass()]
	if (Damages ~= nil) then
		TDI.FinalDamage = Damages[WorldDifficulty]
	end
end

function OnSpawningEntity(World, Entity)
	if GetWorldDifficulty(World) == 0 then
		return IsEntityBlockedInPeaceful[Entity:GetClass()]
	end
	return false
end
