-- InitServer.lua
-- Main initialization script for the Roblox Party Game
-- Place this in ServerScriptService to start everything

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("===========================================")
print("🎮 ROBLOX PARTY GAME - INITIALIZING")
print("===========================================")

-- Verify required components exist
local function verifySetup()
	print("[Init] Verifying game setup...")
	
	local errors = {}
	
	-- Check for Portal module
	local portalModule = ReplicatedStorage:FindFirstChild("Portal")
	if not portalModule then
		table.insert(errors, "❌ Portal module not found in ReplicatedStorage")
	else
		print("✅ Portal module found")
	end
	
	-- Check for PortalEvent
	local portalEvent = ReplicatedStorage:FindFirstChild("PortalEvent")
	if not portalEvent then
		table.insert(errors, "❌ PortalEvent RemoteEvent not found in ReplicatedStorage")
	else
		print("✅ PortalEvent found")
	end
	
	-- Check for GameManager
	local gameManager = ServerScriptService:FindFirstChild("GameManager")
	if not gameManager then
		table.insert(errors, "❌ GameManager script not found in ServerScriptService")
	else
		print("✅ GameManager found")
	end
	
	-- Check for LobbySetup
	local lobbySetup = ServerScriptService:FindFirstChild("LobbySetup")
	if not lobbySetup then
		table.insert(errors, "❌ LobbySetup script not found in ServerScriptService")
	else
		print("✅ LobbySetup found")
	end
	
	-- Report results
	if #errors > 0 then
		print("\n⚠️ SETUP ERRORS DETECTED:")
		for _, error in ipairs(errors) do
			warn(error)
		end
		print("\n📖 Please refer to SETUP_GUIDE.txt for instructions")
		return false
	else
		print("\n✅ All required components found!")
		return true
	end
end

-- Initialize game systems
local function initializeSystems()
	print("\n[Init] Starting game systems...")
	
	-- Wait for other scripts to load
	wait(1)
	
	-- Check if lobby was created
	local lobby = workspace:FindFirstChild("Lobby")
	if lobby then
		print("✅ Lobby created successfully")
		
		-- Count portals
		local portalCount = 0
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj.Name:match("Portal") and obj:IsA("Model") then
				portalCount = portalCount + 1
			end
		end
		print("✅ Portals created: " .. portalCount)
	else
		warn("⚠️ Lobby not found - LobbySetup may not have run")
	end
	
	print("\n🎮 Game initialization complete!")
	print("Players can now join and interact with portals")
	print("===========================================\n")
end

-- Run verification and initialization
if verifySetup() then
	initializeSystems()
else
	warn("\n❌ INITIALIZATION FAILED - Please fix setup errors")
end
