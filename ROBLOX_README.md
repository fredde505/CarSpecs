# Roblox Party Game

A modular party game framework for Roblox with a lobby system and portal-based minigame selection.

## Project Structure

```
src/
├── server/              # Server-side scripts
│   ├── GameManager.lua  # Main game state management
│   └── LobbySetup.lua   # Lobby creation and portal setup
├── client/              # Client-side scripts
│   ├── GameUI.lua       # Player UI and HUD
│   └── PortalClient.lua # Portal interaction handling
└── shared/              # Shared modules
    └── modules/
        └── Portal.lua   # Portal class for minigame entry points
```

## Features

### 1. Lobby System
- Automatic spawn point creation
- Baseplate and lobby walls
- Support for multiple simultaneous players
- Clean, organized lobby structure

### 2. Portal System
- Reusable Portal class for easy minigame addition
- Visual portal effects with customizable colors
- ProximityPrompt for player interaction
- Portal signs with minigame names
- Animated pulsing effects

### 3. Game Management
- Player join/leave handling
- Character spawning management
- Game state tracking (Lobby, Playing, Intermission)
- Player statistics tracking

### 4. Client UI
- Top bar with game status
- Player count display
- Stats panel (Score, Wins)
- Notification system for game events
- Responsive design

## Setup Instructions

### For Roblox Studio:

1. **Set up the folder structure:**
   - Create folders in your Roblox game:
     - `ReplicatedStorage` (for shared modules)
     - `ServerScriptService` (for server scripts)
     - `StarterPlayer > StarterPlayerScripts` (for client scripts)

2. **Add the Portal module:**
   - Create a ModuleScript in `ReplicatedStorage`
   - Name it "Portal"
   - Copy contents from `src/shared/modules/Portal.lua`

3. **Add server scripts:**
   - Create a Script in `ServerScriptService` named "GameManager"
   - Copy contents from `src/server/GameManager.lua`
   - Create another Script named "LobbySetup"
   - Copy contents from `src/server/LobbySetup.lua`

4. **Add client scripts:**
   - Create a LocalScript in `StarterPlayer > StarterPlayerScripts` named "GameUI"
   - Copy contents from `src/client/GameUI.lua`
   - Create another LocalScript named "PortalClient"
   - Copy contents from `src/client/PortalClient.lua`

5. **Create RemoteEvent:**
   - Create a RemoteEvent in `ReplicatedStorage` named "PortalEvent"
   - This allows server-client communication for portal interactions

6. **Test the game:**
   - Press Play to test
   - You should see the lobby with three portals
   - Walk up to a portal and interact using the ProximityPrompt

## Adding New Minigames

To add a new minigame portal, edit `LobbySetup.lua` and add a new configuration to the `portalConfigs` table:

```lua
{
    Name = "YourMinigame",
    MinigameName = "Display Name",
    Position = Vector3.new(x, y, z),
    Rotation = Vector3.new(0, 0, 0),
    Color = Color3.fromRGB(r, g, b),
    RequiredPlayers = 1,
    MaxPlayers = 10
}
```

## Current Portals

1. **Obstacle Course** (Red portal)
   - Position: Left side of lobby
   - Min players: 1, Max players: 8

2. **Speed Race** (Green portal)
   - Position: Center of lobby
   - Min players: 2, Max players: 6

3. **Tag Arena** (Yellow portal)
   - Position: Right side of lobby
   - Min players: 3, Max players: 10

## Game States

The game operates in three states:
- **Lobby**: Players can freely move and select portals
- **Playing**: Players are in an active minigame
- **Intermission**: Brief period between minigames

## Future Development

Areas for expansion:
- Implement actual minigame logic
- Add teleportation between lobby and minigames
- Create scoring and leaderboard systems
- Add more visual effects and polish
- Implement team systems for team-based minigames
- Add sound effects and music
- Create admin commands for game management

## Architecture Notes

### Modularity
The system is designed to be modular:
- Portal class can be reused for any number of minigames
- Server and client scripts are separated
- Shared modules are accessible from both server and client

### Communication
- Server manages game state
- Client handles UI and visual feedback
- RemoteEvents facilitate server-client communication

### Performance
- Portals use efficient tweening for animations
- UI updates are throttled to reduce overhead
- Proximity checking runs at 0.5 second intervals

## Contributing

When adding new features:
1. Keep server and client code separated
2. Use shared modules for code used by both
3. Follow the existing naming conventions
4. Document new features in this README

## License

This is a template/framework for creating party games in Roblox.
