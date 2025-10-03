-- Portal.lua
-- Module for creating and managing portals to minigames
-- Each portal represents an entry point to a different minigame

local Portal = {}
Portal.__index = Portal

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Portal configuration
local PORTAL_SIZE = Vector3.new(8, 10, 0.5)
local PORTAL_COLOR = Color3.fromRGB(100, 200, 255)
local INTERACTION_DISTANCE = 10
local PULSE_DURATION = 2

-- Create a new portal instance
function Portal.new(config)
	local self = setmetatable({}, Portal)
	
	-- Required configuration
	self.Name = config.Name or "Unknown Portal"
	self.MinigameName = config.MinigameName or "Unknown"
	self.Position = config.Position or Vector3.new(0, 5, 0)
	self.Rotation = config.Rotation or Vector3.new(0, 0, 0)
	
	-- Optional configuration
	self.Color = config.Color or PORTAL_COLOR
	self.RequiredPlayers = config.RequiredPlayers or 1
	self.MaxPlayers = config.MaxPlayers or 10
	
	-- Internal state
	self.Model = nil
	self.ProximityPrompt = nil
	self.NearbyPlayers = {}
	self.IsActive = true
	
	-- Create the portal visualization
	self:CreatePortal()
	
	return self
end

-- Create the physical portal in the workspace
function Portal:CreatePortal()
	-- Create portal model
	local portalModel = Instance.new("Model")
	portalModel.Name = self.Name .. "_Portal"
	
	-- Create portal frame
	local frame = Instance.new("Part")
	frame.Name = "Frame"
	frame.Size = Vector3.new(PORTAL_SIZE.X + 1, PORTAL_SIZE.Y + 1, 0.8)
	frame.Position = self.Position
	frame.Anchored = true
	frame.Material = Enum.Material.Neon
	frame.Color = Color3.fromRGB(50, 50, 50)
	frame.Parent = portalModel
	
	-- Create portal surface
	local surface = Instance.new("Part")
	surface.Name = "Surface"
	surface.Size = PORTAL_SIZE
	surface.Position = self.Position
	surface.Anchored = true
	surface.CanCollide = false
	surface.Material = Enum.Material.ForceField
	surface.Color = self.Color
	surface.Transparency = 0.3
	surface.Parent = portalModel
	
	-- Add glow effect
	local pointLight = Instance.new("PointLight")
	pointLight.Brightness = 2
	pointLight.Range = 20
	pointLight.Color = self.Color
	pointLight.Parent = surface
	
	-- Create sign above portal
	local sign = Instance.new("Part")
	sign.Name = "Sign"
	sign.Size = Vector3.new(6, 2, 0.2)
	sign.Position = self.Position + Vector3.new(0, PORTAL_SIZE.Y/2 + 2, 0)
	sign.Anchored = true
	sign.Material = Enum.Material.SmoothPlastic
	sign.Color = Color3.fromRGB(40, 40, 40)
	sign.Parent = portalModel
	
	-- Add text to sign
	local surfaceGui = Instance.new("SurfaceGui")
	surfaceGui.Face = Enum.NormalId.Front
	surfaceGui.Parent = sign
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = self.MinigameName
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = surfaceGui
	
	-- Add ProximityPrompt for interaction
	local proximityPrompt = Instance.new("ProximityPrompt")
	proximityPrompt.ObjectText = self.MinigameName
	proximityPrompt.ActionText = "Enter Portal"
	proximityPrompt.MaxActivationDistance = INTERACTION_DISTANCE
	proximityPrompt.RequiresLineOfSight = false
	proximityPrompt.Parent = surface
	
	-- Connect proximity prompt
	proximityPrompt.Triggered:Connect(function(player)
		self:OnPlayerInteract(player)
	end)
	
	self.Model = portalModel
	self.ProximityPrompt = proximityPrompt
	
	-- Apply rotation
	portalModel:SetPrimaryPartCFrame(CFrame.new(self.Position) * CFrame.Angles(
		math.rad(self.Rotation.X),
		math.rad(self.Rotation.Y),
		math.rad(self.Rotation.Z)
	))
	
	portalModel.Parent = workspace
	
	-- Start pulsing animation
	self:StartPulseAnimation(surface)
	
	print("[Portal] Created portal: " .. self.Name .. " for minigame: " .. self.MinigameName)
end

-- Animate portal pulsing effect
function Portal:StartPulseAnimation(part)
	local tweenInfo = TweenInfo.new(
		PULSE_DURATION,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		-1, -- Infinite repeats
		true -- Reverse
	)
	
	local goal = {
		Transparency = 0.1,
		Size = PORTAL_SIZE * 1.05
	}
	
	local tween = TweenService:Create(part, tweenInfo, goal)
	tween:Play()
end

-- Handle player interaction with portal
function Portal:OnPlayerInteract(player)
	if not self.IsActive then
		warn("[Portal] Portal is not active: " .. self.Name)
		return
	end
	
	print("[Portal] Player " .. player.Name .. " interacting with portal: " .. self.Name)
	
	-- TODO: Check if minigame can start
	-- TODO: Teleport player to minigame
	-- For now, just notify
	
	-- Fire event to server for handling
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local portalEvent = ReplicatedStorage:FindFirstChild("PortalEvent")
	if portalEvent then
		portalEvent:FireServer(self.MinigameName, player)
	end
end

-- Enable/disable portal
function Portal:SetActive(active)
	self.IsActive = active
	self.ProximityPrompt.Enabled = active
	
	if self.Model and self.Model:FindFirstChild("Surface") then
		local surface = self.Model.Surface
		if active then
			surface.Transparency = 0.3
			surface.Material = Enum.Material.ForceField
		else
			surface.Transparency = 0.7
			surface.Material = Enum.Material.Glass
		end
	end
end

-- Update portal text
function Portal:SetText(text)
	if self.Model and self.Model:FindFirstChild("Sign") then
		local sign = self.Model.Sign
		local surfaceGui = sign:FindFirstChild("SurfaceGui")
		if surfaceGui then
			local textLabel = surfaceGui:FindFirstChild("TextLabel")
			if textLabel then
				textLabel.Text = text
			end
		end
	end
end

-- Destroy portal
function Portal:Destroy()
	if self.Model then
		self.Model:Destroy()
	end
	print("[Portal] Destroyed portal: " .. self.Name)
end

return Portal
