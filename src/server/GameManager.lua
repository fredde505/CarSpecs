-- GameManager.lua
-- Main server-side script for managing the party game
-- Handles game state, player management, and minigame coordination

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local GameManager = {}
GameManager.State = "Lobby" -- Lobby, Playing, Intermission
GameManager.ActivePlayers = {}
GameManager.CurrentMinigame = nil

-- Initialize the game
function GameManager:Initialize()
	print("[GameManager] Initializing party game...")
	
	-- Set up player connections
	Players.PlayerAdded:Connect(function(player)
		self:OnPlayerAdded(player)
	end)
	
	Players.PlayerRemoving:Connect(function(player)
		self:OnPlayerRemoving(player)
	end)
	
	-- Initialize any existing players
	for _, player in ipairs(Players:GetPlayers()) do
		self:OnPlayerAdded(player)
	end
	
	print("[GameManager] Initialization complete. State: " .. self.State)
end

-- Handle player joining
function GameManager:OnPlayerAdded(player)
	print("[GameManager] Player joined: " .. player.Name)
	
	-- Add player to active players list
	self.ActivePlayers[player.UserId] = {
		Player = player,
		Score = 0,
		MinigamesWon = 0
	}
	
	-- Wait for character to load
	player.CharacterAdded:Connect(function(character)
		self:OnCharacterAdded(player, character)
	end)
	
	-- Handle existing character
	if player.Character then
		self:OnCharacterAdded(player, player.Character)
	end
end

-- Handle character spawning
function GameManager:OnCharacterAdded(player, character)
	print("[GameManager] Character spawned for: " .. player.Name)
	
	-- Spawn player in lobby
	if self.State == "Lobby" then
		self:SpawnInLobby(character)
	end
end

-- Spawn character in lobby
function GameManager:SpawnInLobby(character)
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	local spawnLocation = workspace:FindFirstChild("LobbySpawn")
	
	if spawnLocation then
		humanoidRootPart.CFrame = spawnLocation.CFrame + Vector3.new(0, 3, 0)
	end
end

-- Handle player leaving
function GameManager:OnPlayerRemoving(player)
	print("[GameManager] Player left: " .. player.Name)
	self.ActivePlayers[player.UserId] = nil
end

-- Get active player count
function GameManager:GetPlayerCount()
	local count = 0
	for _ in pairs(self.ActivePlayers) do
		count = count + 1
	end
	return count
end

-- Start a minigame
function GameManager:StartMinigame(minigameName)
	if self.State ~= "Lobby" then
		warn("[GameManager] Cannot start minigame. Current state: " .. self.State)
		return false
	end
	
	print("[GameManager] Starting minigame: " .. minigameName)
	self.State = "Playing"
	self.CurrentMinigame = minigameName
	
	-- TODO: Teleport players to minigame
	-- TODO: Initialize minigame logic
	
	return true
end

-- End current minigame
function GameManager:EndMinigame()
	if self.State ~= "Playing" then
		warn("[GameManager] No minigame to end")
		return
	end
	
	print("[GameManager] Ending minigame: " .. (self.CurrentMinigame or "Unknown"))
	self.State = "Intermission"
	self.CurrentMinigame = nil
	
	-- TODO: Calculate scores
	-- TODO: Teleport players back to lobby
	
	wait(5) -- Intermission period
	self.State = "Lobby"
end

-- Initialize on script load
GameManager:Initialize()

return GameManager
