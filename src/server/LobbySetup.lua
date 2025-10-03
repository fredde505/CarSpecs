-- LobbySetup.lua
-- Server script to set up the lobby area and portal instances
-- Creates the spawn point, lobby structure, and minigame portals

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Wait for shared modules to be available
local Portal = require(ReplicatedStorage:WaitForChild("Portal"))

local LobbySetup = {}
LobbySetup.Portals = {}

-- Create the basic lobby structure
function LobbySetup:CreateLobbyStructure()
	print("[LobbySetup] Creating lobby structure...")
	
	-- Create or find lobby folder
	local lobby = workspace:FindFirstChild("Lobby")
	if not lobby then
		lobby = Instance.new("Folder")
		lobby.Name = "Lobby"
		lobby.Parent = workspace
	end
	
	-- Create spawn location if it doesn't exist
	local spawnLocation = workspace:FindFirstChild("LobbySpawn")
	if not spawnLocation then
		spawnLocation = Instance.new("SpawnLocation")
		spawnLocation.Name = "LobbySpawn"
		spawnLocation.Size = Vector3.new(10, 1, 10)
		spawnLocation.Position = Vector3.new(0, 0.5, 0)
		spawnLocation.Anchored = true
		spawnLocation.BrickColor = BrickColor.new("Bright green")
		spawnLocation.Material = Enum.Material.Neon
		spawnLocation.Transparency = 0.5
		spawnLocation.CanCollide = true
		spawnLocation.TopSurface = Enum.SurfaceType.Smooth
		spawnLocation.Parent = lobby
		
		print("[LobbySetup] Created spawn location at origin")
	end
	
	-- Create baseplate if it doesn't exist
	local baseplate = workspace:FindFirstChild("Baseplate")
	if not baseplate then
		baseplate = Instance.new("Part")
		baseplate.Name = "Baseplate"
		baseplate.Size = Vector3.new(200, 1, 200)
		baseplate.Position = Vector3.new(0, -0.5, 0)
		baseplate.Anchored = true
		baseplate.BrickColor = BrickColor.new("Dark stone grey")
		baseplate.Material = Enum.Material.Concrete
		baseplate.TopSurface = Enum.SurfaceType.Smooth
		baseplate.Parent = lobby
		
		print("[LobbySetup] Created baseplate")
	end
	
	-- Create lobby walls
	self:CreateLobbyWalls(lobby)
	
	print("[LobbySetup] Lobby structure complete")
end

-- Create decorative lobby walls
function LobbySetup:CreateLobbyWalls(lobby)
	local wallHeight = 20
	local wallThickness = 2
	local lobbySize = 100
	
	-- North wall
	local northWall = Instance.new("Part")
	northWall.Name = "NorthWall"
	northWall.Size = Vector3.new(lobbySize, wallHeight, wallThickness)
	northWall.Position = Vector3.new(0, wallHeight/2, -lobbySize/2)
	northWall.Anchored = true
	northWall.BrickColor = BrickColor.new("Medium stone grey")
	northWall.Material = Enum.Material.Brick
	northWall.Parent = lobby
	
	-- South wall
	local southWall = northWall:Clone()
	southWall.Name = "SouthWall"
	southWall.Position = Vector3.new(0, wallHeight/2, lobbySize/2)
	southWall.Parent = lobby
	
	-- East wall
	local eastWall = Instance.new("Part")
	eastWall.Name = "EastWall"
	eastWall.Size = Vector3.new(wallThickness, wallHeight, lobbySize)
	eastWall.Position = Vector3.new(lobbySize/2, wallHeight/2, 0)
	eastWall.Anchored = true
	eastWall.BrickColor = BrickColor.new("Medium stone grey")
	eastWall.Material = Enum.Material.Brick
	eastWall.Parent = lobby
	
	-- West wall
	local westWall = eastWall:Clone()
	westWall.Name = "WestWall"
	westWall.Position = Vector3.new(-lobbySize/2, wallHeight/2, 0)
	westWall.Parent = lobby
end

-- Create portal instances for minigames
function LobbySetup:CreatePortals()
	print("[LobbySetup] Creating portals...")
	
	-- Portal configuration for different minigames
	local portalConfigs = {
		{
			Name = "Obby",
			MinigameName = "Obstacle Course",
			Position = Vector3.new(-30, 5, -40),
			Rotation = Vector3.new(0, 0, 0),
			Color = Color3.fromRGB(255, 100, 100),
			RequiredPlayers = 1,
			MaxPlayers = 8
		},
		{
			Name = "Racing",
			MinigameName = "Speed Race",
			Position = Vector3.new(0, 5, -40),
			Rotation = Vector3.new(0, 0, 0),
			Color = Color3.fromRGB(100, 255, 100),
			RequiredPlayers = 2,
			MaxPlayers = 6
		},
		{
			Name = "TagGame",
			MinigameName = "Tag Arena",
			Position = Vector3.new(30, 5, -40),
			Rotation = Vector3.new(0, 0, 0),
			Color = Color3.fromRGB(255, 255, 100),
			RequiredPlayers = 3,
			MaxPlayers = 10
		}
	}
	
	-- Create each portal
	for _, config in ipairs(portalConfigs) do
		local portal = Portal.new(config)
		table.insert(self.Portals, portal)
		print("[LobbySetup] Created portal: " .. config.MinigameName)
	end
	
	print("[LobbySetup] All portals created. Total: " .. #self.Portals)
end

-- Initialize lobby
function LobbySetup:Initialize()
	print("[LobbySetup] Initializing lobby...")
	
	-- Create lobby structure
	self:CreateLobbyStructure()
	
	-- Wait a moment for everything to load
	wait(1)
	
	-- Create portals
	self:CreatePortals()
	
	print("[LobbySetup] Lobby initialization complete")
end

-- Initialize on load
LobbySetup:Initialize()

return LobbySetup
