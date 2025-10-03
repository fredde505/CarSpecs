-- GameUI.lua
-- Client-side script for managing the game UI
-- Displays player stats, minigame info, and notifications

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local GameUI = {}
GameUI.ScreenGui = nil
GameUI.StatusLabel = nil
GameUI.PlayerCountLabel = nil
GameUI.NotificationFrame = nil

-- Create the main UI
function GameUI:CreateUI()
	print("[GameUI] Creating UI for player...")
	
	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PartyGameUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	self.ScreenGui = screenGui
	
	-- Create top bar
	self:CreateTopBar(screenGui)
	
	-- Create notification area
	self:CreateNotificationArea(screenGui)
	
	-- Create player stats display
	self:CreateStatsDisplay(screenGui)
	
	print("[GameUI] UI created successfully")
end

-- Create top status bar
function GameUI:CreateTopBar(parent)
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 50)
	topBar.Position = UDim2.new(0, 0, 0, 0)
	topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	topBar.BackgroundTransparency = 0.3
	topBar.BorderSizePixel = 0
	topBar.Parent = parent
	
	-- Game title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(0.3, 0, 1, 0)
	titleLabel.Position = UDim2.new(0, 10, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "🎮 Party Game"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextScaled = true
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = topBar
	
	-- Add padding
	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.PaddingTop = UDim.new(0, 5)
	padding.PaddingBottom = UDim.new(0, 5)
	padding.Parent = titleLabel
	
	-- Status label (center)
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(0.4, 0, 1, 0)
	statusLabel.Position = UDim2.new(0.3, 0, 0, 0)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = "In Lobby"
	statusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
	statusLabel.TextScaled = true
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.Parent = topBar
	
	self.StatusLabel = statusLabel
	
	-- Player count (right)
	local playerCountLabel = Instance.new("TextLabel")
	playerCountLabel.Name = "PlayerCountLabel"
	playerCountLabel.Size = UDim2.new(0.3, -10, 1, 0)
	playerCountLabel.Position = UDim2.new(0.7, 0, 0, 0)
	playerCountLabel.BackgroundTransparency = 1
	playerCountLabel.Text = "👥 Players: 0"
	playerCountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	playerCountLabel.TextScaled = true
	playerCountLabel.Font = Enum.Font.Gotham
	playerCountLabel.TextXAlignment = Enum.TextXAlignment.Right
	playerCountLabel.Parent = topBar
	
	local padding2 = Instance.new("UIPadding")
	padding2.PaddingRight = UDim.new(0, 10)
	padding2.Parent = playerCountLabel
	
	self.PlayerCountLabel = playerCountLabel
end

-- Create notification area
function GameUI:CreateNotificationArea(parent)
	local notificationFrame = Instance.new("Frame")
	notificationFrame.Name = "NotificationFrame"
	notificationFrame.Size = UDim2.new(0.4, 0, 0.15, 0)
	notificationFrame.Position = UDim2.new(0.3, 0, 0.1, 0)
	notificationFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	notificationFrame.BackgroundTransparency = 0.3
	notificationFrame.BorderSizePixel = 0
	notificationFrame.Visible = false
	notificationFrame.Parent = parent
	
	-- Round corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = notificationFrame
	
	-- Notification text
	local notificationText = Instance.new("TextLabel")
	notificationText.Name = "NotificationText"
	notificationText.Size = UDim2.new(1, -20, 1, -20)
	notificationText.Position = UDim2.new(0, 10, 0, 10)
	notificationText.BackgroundTransparency = 1
	notificationText.Text = ""
	notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
	notificationText.TextScaled = true
	notificationText.Font = Enum.Font.GothamBold
	notificationText.TextWrapped = true
	notificationText.Parent = notificationFrame
	
	self.NotificationFrame = notificationFrame
end

-- Create stats display
function GameUI:CreateStatsDisplay(parent)
	local statsFrame = Instance.new("Frame")
	statsFrame.Name = "StatsFrame"
	statsFrame.Size = UDim2.new(0.2, 0, 0.3, 0)
	statsFrame.Position = UDim2.new(0.02, 0, 0.15, 0)
	statsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	statsFrame.BackgroundTransparency = 0.4
	statsFrame.BorderSizePixel = 0
	statsFrame.Parent = parent
	
	-- Round corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = statsFrame
	
	-- Stats title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "Your Stats"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
	titleLabel.TextScaled = true
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Parent = statsFrame
	
	-- Score label
	local scoreLabel = Instance.new("TextLabel")
	scoreLabel.Name = "ScoreLabel"
	scoreLabel.Size = UDim2.new(1, -20, 0.25, 0)
	scoreLabel.Position = UDim2.new(0, 10, 0.25, 0)
	scoreLabel.BackgroundTransparency = 1
	scoreLabel.Text = "Score: 0"
	scoreLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	scoreLabel.TextScaled = true
	scoreLabel.Font = Enum.Font.Gotham
	scoreLabel.TextXAlignment = Enum.TextXAlignment.Left
	scoreLabel.Parent = statsFrame
	
	-- Wins label
	local winsLabel = Instance.new("TextLabel")
	winsLabel.Name = "WinsLabel"
	winsLabel.Size = UDim2.new(1, -20, 0.25, 0)
	winsLabel.Position = UDim2.new(0, 10, 0.5, 0)
	winsLabel.BackgroundTransparency = 1
	winsLabel.Text = "Wins: 0"
	winsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	winsLabel.TextScaled = true
	winsLabel.Font = Enum.Font.Gotham
	winsLabel.TextXAlignment = Enum.TextXAlignment.Left
	winsLabel.Parent = statsFrame
end

-- Show notification
function GameUI:ShowNotification(message, duration)
	if not self.NotificationFrame then return end
	
	local notificationText = self.NotificationFrame:FindFirstChild("NotificationText")
	if notificationText then
		notificationText.Text = message
	end
	
	self.NotificationFrame.Visible = true
	
	-- Hide after duration
	task.delay(duration or 3, function()
		if self.NotificationFrame then
			self.NotificationFrame.Visible = false
		end
	end)
end

-- Update status
function GameUI:UpdateStatus(status)
	if self.StatusLabel then
		self.StatusLabel.Text = status
	end
end

-- Update player count
function GameUI:UpdatePlayerCount(count)
	if self.PlayerCountLabel then
		self.PlayerCountLabel.Text = "👥 Players: " .. tostring(count)
	end
end

-- Update stats
function GameUI:UpdateStats(score, wins)
	if not self.ScreenGui then return end
	
	local statsFrame = self.ScreenGui:FindFirstChild("StatsFrame")
	if not statsFrame then return end
	
	local scoreLabel = statsFrame:FindFirstChild("ScoreLabel")
	if scoreLabel then
		scoreLabel.Text = "Score: " .. tostring(score)
	end
	
	local winsLabel = statsFrame:FindFirstChild("WinsLabel")
	if winsLabel then
		winsLabel.Text = "Wins: " .. tostring(wins)
	end
end

-- Initialize UI
function GameUI:Initialize()
	print("[GameUI] Initializing UI...")
	
	self:CreateUI()
	
	-- Update player count periodically
	spawn(function()
		while wait(2) do
			local playerCount = #Players:GetPlayers()
			self:UpdatePlayerCount(playerCount)
		end
	end)
	
	-- Show welcome notification
	wait(1)
	self:ShowNotification("Welcome to the Party Game! Find a portal to play!", 5)
	
	print("[GameUI] UI initialization complete")
end

-- Initialize on load
GameUI:Initialize()

return GameUI
