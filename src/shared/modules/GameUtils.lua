-- GameUtils.lua
-- Shared utility functions for the party game
-- Contains helper functions used across server and client

local GameUtils = {}

-- Teleport a player's character to a position
function GameUtils.TeleportPlayer(player, position, rotation)
	if not player or not player.Character then
		warn("[GameUtils] Cannot teleport - player or character not found")
		return false
	end
	
	local character = player.Character
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	
	if not humanoidRootPart then
		warn("[GameUtils] Cannot teleport - HumanoidRootPart not found")
		return false
	end
	
	-- Calculate CFrame with optional rotation
	local targetCFrame
	if rotation then
		targetCFrame = CFrame.new(position) * CFrame.Angles(
			math.rad(rotation.X),
			math.rad(rotation.Y),
			math.rad(rotation.Z)
		)
	else
		targetCFrame = CFrame.new(position)
	end
	
	humanoidRootPart.CFrame = targetCFrame
	return true
end

-- Get all players in a specific area
function GameUtils.GetPlayersInArea(position, radius)
	local Players = game:GetService("Players")
	local playersInArea = {}
	
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				local distance = (humanoidRootPart.Position - position).Magnitude
				if distance <= radius then
					table.insert(playersInArea, player)
				end
			end
		end
	end
	
	return playersInArea
end

-- Create a countdown timer
function GameUtils.CreateCountdown(duration, callback)
	for i = duration, 1, -1 do
		if callback then
			callback(i)
		end
		wait(1)
	end
	
	if callback then
		callback(0)
	end
end

-- Shuffle a table randomly
function GameUtils.ShuffleTable(tbl)
	local shuffled = {}
	for i = 1, #tbl do
		shuffled[i] = tbl[i]
	end
	
	for i = #shuffled, 2, -1 do
		local j = math.random(i)
		shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
	end
	
	return shuffled
end

-- Get a random element from a table
function GameUtils.GetRandomElement(tbl)
	if #tbl == 0 then return nil end
	return tbl[math.random(#tbl)]
end

-- Round a number to specified decimal places
function GameUtils.Round(number, decimals)
	local mult = 10^(decimals or 0)
	return math.floor(number * mult + 0.5) / mult
end

-- Format time in MM:SS format
function GameUtils.FormatTime(seconds)
	local minutes = math.floor(seconds / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d", minutes, secs)
end

-- Check if a player is alive
function GameUtils.IsPlayerAlive(player)
	if not player or not player.Character then
		return false
	end
	
	local humanoid = player.Character:FindFirstChild("Humanoid")
	if not humanoid then
		return false
	end
	
	return humanoid.Health > 0
end

-- Get the distance between two positions
function GameUtils.GetDistance(pos1, pos2)
	return (pos1 - pos2).Magnitude
end

-- Create a colored chat message
function GameUtils.SendColoredMessage(player, message, color)
	local textChatService = game:GetService("TextChatService")
	local textChannel = textChatService:FindFirstChild("TextChannels")
	
	if textChannel then
		local generalChannel = textChannel:FindFirstChild("RBXGeneral")
		if generalChannel then
			-- Send formatted message
			local formattedMessage = string.format("[GAME] %s", message)
			generalChannel:DisplaySystemMessage(formattedMessage)
		end
	end
end

-- Clone a table (shallow copy)
function GameUtils.CloneTable(tbl)
	local clone = {}
	for k, v in pairs(tbl) do
		clone[k] = v
	end
	return clone
end

-- Check if a table contains a value
function GameUtils.TableContains(tbl, value)
	for _, v in pairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end

-- Remove a value from a table
function GameUtils.RemoveFromTable(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then
			table.remove(tbl, i)
			return true
		end
	end
	return false
end

-- Get the number of elements in a dictionary table
function GameUtils.GetTableSize(tbl)
	local count = 0
	for _ in pairs(tbl) do
		count = count + 1
	end
	return count
end

-- Wait for a child with timeout
function GameUtils.WaitForChildTimeout(parent, childName, timeout)
	local startTime = tick()
	while tick() - startTime < timeout do
		local child = parent:FindFirstChild(childName)
		if child then
			return child
		end
		wait(0.1)
	end
	return nil
end

-- Create a simple part with specific properties
function GameUtils.CreatePart(properties)
	local part = Instance.new("Part")
	
	-- Default properties
	part.Anchored = true
	part.CanCollide = true
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	
	-- Apply custom properties
	for key, value in pairs(properties) do
		part[key] = value
	end
	
	return part
end

-- Debug print with timestamp
function GameUtils.DebugPrint(module, message)
	local timestamp = os.date("%H:%M:%S")
	print(string.format("[%s][%s] %s", timestamp, module, message))
end

return GameUtils
