# Architecture Overview

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         ROBLOX PARTY GAME                        │
│                      Architecture Overview                       │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                          WORKSPACE                               │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    LOBBY                                 │   │
│  │  • SpawnLocation (LobbySpawn)                           │   │
│  │  • Baseplate (200x1x200)                                │   │
│  │  • Walls (North, South, East, West)                     │   │
│  │                                                          │   │
│  │  ┌────────┐      ┌────────┐      ┌────────┐           │   │
│  │  │ Portal │      │ Portal │      │ Portal │           │   │
│  │  │  Obby  │      │ Racing │      │  Tag   │           │   │
│  │  │  (Red) │      │(Green) │      │(Yellow)│           │   │
│  │  └────────┘      └────────┘      └────────┘           │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    SERVER SIDE                                   │
├─────────────────────────────────────────────────────────────────┤
│  ServerScriptService/                                            │
│  ├─ InitServer.lua                                              │
│  │   └─ Verifies setup and initializes systems                  │
│  │                                                               │
│  ├─ GameManager.lua                                             │
│  │   ├─ State Management (Lobby/Playing/Intermission)           │
│  │   ├─ Player Join/Leave Handling                              │
│  │   ├─ Character Spawning                                      │
│  │   └─ Minigame Start/End Logic                                │
│  │                                                               │
│  └─ LobbySetup.lua                                              │
│      ├─ Creates Lobby Structure                                 │
│      ├─ Instantiates Portals                                    │
│      └─ Manages Portal Configurations                           │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    CLIENT SIDE                                   │
├─────────────────────────────────────────────────────────────────┤
│  StarterPlayer/StarterPlayerScripts/                            │
│  ├─ GameUI.lua                                                  │
│  │   ├─ Top Status Bar                                          │
│  │   ├─ Player Count Display                                    │
│  │   ├─ Stats Panel (Score, Wins)                               │
│  │   └─ Notification System                                     │
│  │                                                               │
│  └─ PortalClient.lua                                            │
│      ├─ Portal Visual Effects                                   │
│      ├─ Proximity Detection                                     │
│      ├─ Interaction Feedback                                    │
│      └─ Server Communication                                    │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    SHARED MODULES                                │
├─────────────────────────────────────────────────────────────────┤
│  ReplicatedStorage/                                             │
│  ├─ Portal.lua (ModuleScript)                                   │
│  │   ├─ Portal.new(config)                                      │
│  │   ├─ CreatePortal()                                          │
│  │   ├─ StartPulseAnimation()                                   │
│  │   ├─ OnPlayerInteract()                                      │
│  │   ├─ SetActive(bool)                                         │
│  │   └─ SetText(string)                                         │
│  │                                                               │
│  ├─ GameUtils.lua (ModuleScript)                                │
│  │   ├─ TeleportPlayer()                                        │
│  │   ├─ GetPlayersInArea()                                      │
│  │   ├─ CreateCountdown()                                       │
│  │   ├─ FormatTime()                                            │
│  │   └─ [20+ utility functions]                                 │
│  │                                                               │
│  └─ PortalEvent (RemoteEvent)                                   │
│      └─ Server ↔ Client Communication                           │
└─────────────────────────────────────────────────────────────────┘

══════════════════════════════════════════════════════════════════
                        DATA FLOW
══════════════════════════════════════════════════════════════════

1. GAME INITIALIZATION
   ┌──────────────┐
   │ InitServer   │ Verifies all components
   └──────┬───────┘
          │
          ├──────► GameManager.Initialize()
          │        ├─ Sets up player events
          │        └─ Initializes state
          │
          └──────► LobbySetup.Initialize()
                   ├─ Creates lobby structure
                   └─ Instantiates portals

2. PLAYER JOINS
   ┌──────────────┐
   │ Player Joins │
   └──────┬───────┘
          │
          ├──────► GameManager.OnPlayerAdded()
          │        ├─ Adds to ActivePlayers
          │        └─ Sets up character events
          │
          └──────► Client Scripts Load
                   ├─ GameUI.Initialize()
                   │  └─ Creates player UI
                   └─ PortalClient.Initialize()
                      └─ Monitors portals

3. PORTAL INTERACTION
   ┌──────────────┐
   │Player clicks │
   │   Portal     │
   └──────┬───────┘
          │
          ├──────► ProximityPrompt.Triggered
          │        └─ Portal.OnPlayerInteract()
          │
          ├──────► Fire PortalEvent (RemoteEvent)
          │
          └──────► Server receives request
                   └─ GameManager handles logic
                        └─ Response to Client

4. UI UPDATES
   ┌──────────────┐
   │  Game State  │
   │    Changes   │
   └──────┬───────┘
          │
          ├──────► GameUI.UpdateStatus()
          ├──────► GameUI.UpdatePlayerCount()
          ├──────► GameUI.UpdateStats()
          └──────► GameUI.ShowNotification()

══════════════════════════════════════════════════════════════════
                    KEY FEATURES
══════════════════════════════════════════════════════════════════

✅ MODULARITY
   • Portal class can be reused for infinite minigames
   • Separated concerns (Server/Client/Shared)
   • Easy to add new portals via configuration

✅ EXTENSIBILITY
   • GameUtils provides 20+ helper functions
   • Clear architecture for adding minigames
   • Template structure for new features

✅ PERFORMANCE
   • Efficient tweening for animations
   • Throttled UI updates
   • Optimized proximity checks (0.5s intervals)

✅ USER EXPERIENCE
   • Visual portal effects (particles, glow, pulse)
   • Clear UI with stats and notifications
   • ProximityPrompt for easy interaction

══════════════════════════════════════════════════════════════════
                 PORTAL CONFIGURATION
══════════════════════════════════════════════════════════════════

Each portal is created with:
┌────────────────────────────────────────────────┐
│ {                                              │
│   Name = "Obby",                               │
│   MinigameName = "Obstacle Course",            │
│   Position = Vector3.new(-30, 5, -40),         │
│   Rotation = Vector3.new(0, 0, 0),             │
│   Color = Color3.fromRGB(255, 100, 100),       │
│   RequiredPlayers = 1,                         │
│   MaxPlayers = 8                               │
│ }                                              │
└────────────────────────────────────────────────┘

Portal Components:
├─ Frame (Border)
├─ Surface (Interactive area)
│  ├─ PointLight (Glow effect)
│  ├─ ProximityPrompt (Interaction)
│  └─ ParticleEmitter (Client-side)
└─ Sign (Display name)
   └─ SurfaceGui with TextLabel

══════════════════════════════════════════════════════════════════
