-- PortalClient.lua
-- Client-side script for handling portal interactions and effects
-- Manages portal visualization and player feedback

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local PortalClient = {}
PortalClient.NearbyPortals = {}

-- Initialize portal client
function PortalClient:Initialize()
	print("[PortalClient] Initializing portal client...")
	
	-- Set up portal event listener
	self:SetupEventListeners()
	
	-- Monitor portals in workspace
	self:MonitorPortals()
	
	print("[PortalClient] Portal client initialized")
end

-- Set up event listeners
function PortalClient:SetupEventListeners()
	-- Wait for portal event
	local portalEvent = ReplicatedStorage:WaitForChild("PortalEvent", 10)
	
	if portalEvent then
		-- Listen for portal responses from server
		portalEvent.OnClientEvent:Connect(function(action, data)
			self:HandlePortalResponse(action, data)
		end)
	end
end

-- Handle responses from server about portals
function PortalClient:HandlePortalResponse(action, data)
	print("[PortalClient] Received portal action: " .. tostring(action))
	
	if action == "TeleportToMinigame" then
		self:PlayTeleportEffect()
	elseif action == "NotEnoughPlayers" then
		self:ShowPortalMessage("Not enough players!", Color3.fromRGB(255, 100, 100))
	elseif action == "MinigameStarting" then
		self:ShowPortalMessage("Minigame Starting!", Color3.fromRGB(100, 255, 100))
	end
end

-- Play teleport effect
function PortalClient:PlayTeleportEffect()
	local character = player.Character
	if not character then return end
	
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	
	-- Create particle effect
	local particles = Instance.new("ParticleEmitter")
	particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	particles.Rate = 100
	particles.Lifetime = NumberRange.new(1, 2)
	particles.Speed = NumberRange.new(5, 10)
	particles.SpreadAngle = Vector2.new(180, 180)
	particles.Color = ColorSequence.new(Color3.fromRGB(100, 200, 255))
	particles.Parent = humanoidRootPart
	
	-- Remove after 2 seconds
	task.delay(2, function()
		particles:Destroy()
	end)
end

-- Show portal message
function PortalClient:ShowPortalMessage(message, color)
	-- Find GameUI to show notification
	local playerGui = player:WaitForChild("PlayerGui")
	local partyGameUI = playerGui:FindFirstChild("PartyGameUI")
	
	if partyGameUI then
		local notificationFrame = partyGameUI:FindFirstChild("NotificationFrame")
		if notificationFrame then
			local notificationText = notificationFrame:FindFirstChild("NotificationText")
			if notificationText then
				notificationText.Text = message
				notificationText.TextColor3 = color or Color3.fromRGB(255, 255, 255)
			end
			notificationFrame.Visible = true
			
			task.delay(3, function()
				notificationFrame.Visible = false
			end)
		end
	end
end

-- Monitor portals in workspace
function PortalClient:MonitorPortals()
	-- Find all portals
	local function checkPortals()
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj.Name:find("Portal") and obj:IsA("Model") then
				self:EnhancePortalVisuals(obj)
			end
		end
	end
	
	-- Check initially
	task.delay(2, checkPortals)
	
	-- Check when new portals are added
	workspace.DescendantAdded:Connect(function(obj)
		if obj.Name:find("Portal") and obj:IsA("Model") then
			task.wait(0.1)
			self:EnhancePortalVisuals(obj)
		end
	end)
end

-- Add client-side visual enhancements to portals
function PortalClient:EnhancePortalVisuals(portalModel)
	local surface = portalModel:FindFirstChild("Surface")
	if not surface then return end
	
	-- Add particle effect
	local particles = Instance.new("ParticleEmitter")
	particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	particles.Rate = 20
	particles.Lifetime = NumberRange.new(1, 2)
	particles.Speed = NumberRange.new(2, 5)
	particles.SpreadAngle = Vector2.new(30, 30)
	particles.Color = ColorSequence.new(surface.Color)
	particles.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.5),
		NumberSequenceKeypoint.new(1, 1)
	})
	particles.LightEmission = 1
	particles.Parent = surface
	
	print("[PortalClient] Enhanced visuals for portal: " .. portalModel.Name)
end

-- Check if player is near any portal
function PortalClient:CheckNearbyPortals()
	local character = player.Character
	if not character then return end
	
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	
	-- Find all portal surfaces
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name == "Surface" and obj.Parent and obj.Parent.Name:find("Portal") then
			local distance = (humanoidRootPart.Position - obj.Position).Magnitude
			
			if distance < 15 then
				-- Player is near portal
				if not self.NearbyPortals[obj] then
					self.NearbyPortals[obj] = true
					self:OnEnterPortalProximity(obj)
				end
			else
				-- Player left portal area
				if self.NearbyPortals[obj] then
					self.NearbyPortals[obj] = nil
					self:OnLeavePortalProximity(obj)
				end
			end
		end
	end
end

-- Handle entering portal proximity
function PortalClient:OnEnterPortalProximity(portalSurface)
	print("[PortalClient] Entered portal proximity")
	-- Could add visual feedback here
end

-- Handle leaving portal proximity
function PortalClient:OnLeavePortalProximity(portalSurface)
	print("[PortalClient] Left portal proximity")
	-- Could remove visual feedback here
end

-- Start proximity checking
function PortalClient:StartProximityCheck()
	spawn(function()
		while true do
			wait(0.5)
			self:CheckNearbyPortals()
		end
	end)
end

-- Initialize
PortalClient:Initialize()
PortalClient:StartProximityCheck()

return PortalClient
