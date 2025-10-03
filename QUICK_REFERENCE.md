# Quick Reference Guide

## File Structure Quick Reference

```
CarSpecs/
├── src/
│   ├── server/              # Server-side scripts (ServerScriptService)
│   │   ├── InitServer.lua   # Initialization and verification
│   │   ├── GameManager.lua  # Core game state management
│   │   └── LobbySetup.lua   # Lobby and portal creation
│   │
│   ├── client/              # Client-side scripts (StarterPlayerScripts)
│   │   ├── GameUI.lua       # Player UI and HUD
│   │   └── PortalClient.lua # Portal interactions
│   │
│   └── shared/              # Shared modules (ReplicatedStorage)
│       └── modules/
│           ├── Portal.lua   # Portal class
│           └── GameUtils.lua # Utility functions
│
├── ROBLOX_README.md         # Main documentation
├── SETUP_GUIDE.txt          # Step-by-step setup
├── ARCHITECTURE.md          # System architecture
└── QUICK_REFERENCE.md       # This file
```

## Common Tasks

### Adding a New Portal

**File:** `src/server/LobbySetup.lua`

**Location:** Find the `portalConfigs` table in `CreatePortals()` function

**Add:**
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

### Changing Lobby Size

**File:** `src/server/LobbySetup.lua`

**Location:** `CreateLobbyWalls()` function

**Change:**
```lua
local lobbySize = 100  -- Change this value
```

### Adding Custom UI Elements

**File:** `src/client/GameUI.lua`

**Location:** Add new function to `GameUI` object

**Example:**
```lua
function GameUI:CreateCustomElement(parent)
    local element = Instance.new("Frame")
    -- Configure element...
    element.Parent = parent
end
```

### Customizing Portal Colors

**Option 1:** In portal config (LobbySetup.lua)
```lua
Color = Color3.fromRGB(255, 100, 100)
```

**Option 2:** Change after creation
```lua
portal.Color = Color3.fromRGB(100, 255, 100)
portal:CreatePortal() -- Recreate with new color
```

## Function Reference

### GameManager.lua

| Function | Description | Parameters |
|----------|-------------|------------|
| `Initialize()` | Set up game systems | None |
| `OnPlayerAdded(player)` | Handle player join | player: Player |
| `OnPlayerRemoving(player)` | Handle player leave | player: Player |
| `GetPlayerCount()` | Get active player count | None → number |
| `StartMinigame(name)` | Start a minigame | name: string → boolean |
| `EndMinigame()` | End current minigame | None |

### Portal.lua

| Function | Description | Parameters |
|----------|-------------|------------|
| `Portal.new(config)` | Create portal instance | config: table → Portal |
| `CreatePortal()` | Build portal in workspace | None |
| `StartPulseAnimation(part)` | Animate portal | part: Part |
| `OnPlayerInteract(player)` | Handle interaction | player: Player |
| `SetActive(active)` | Enable/disable portal | active: boolean |
| `SetText(text)` | Update portal text | text: string |
| `Destroy()` | Remove portal | None |

### GameUtils.lua

| Function | Description | Returns |
|----------|-------------|---------|
| `TeleportPlayer(player, pos, rot)` | Move player | boolean |
| `GetPlayersInArea(pos, radius)` | Find nearby players | table |
| `CreateCountdown(duration, callback)` | Timer | void |
| `ShuffleTable(tbl)` | Random shuffle | table |
| `GetRandomElement(tbl)` | Random pick | any |
| `Round(num, decimals)` | Round number | number |
| `FormatTime(seconds)` | Format to MM:SS | string |
| `IsPlayerAlive(player)` | Check if alive | boolean |
| `GetDistance(pos1, pos2)` | Calculate distance | number |

### GameUI.lua

| Function | Description | Parameters |
|----------|-------------|------------|
| `CreateUI()` | Build all UI | None |
| `ShowNotification(msg, dur)` | Display message | msg: string, dur: number |
| `UpdateStatus(status)` | Set status text | status: string |
| `UpdatePlayerCount(count)` | Update player count | count: number |
| `UpdateStats(score, wins)` | Update stats | score: number, wins: number |

## Configuration Quick Change

### Portal Positions (X, Y, Z)
```lua
-- Left side
Position = Vector3.new(-30, 5, -40)

-- Center
Position = Vector3.new(0, 5, -40)

-- Right side
Position = Vector3.new(30, 5, -40)
```

### Common Colors
```lua
-- Red
Color3.fromRGB(255, 100, 100)

-- Green
Color3.fromRGB(100, 255, 100)

-- Blue
Color3.fromRGB(100, 100, 255)

-- Yellow
Color3.fromRGB(255, 255, 100)

-- Purple
Color3.fromRGB(200, 100, 255)

-- Orange
Color3.fromRGB(255, 165, 0)
```

### UI Positions
```lua
-- Top left
Position = UDim2.new(0, 10, 0, 10)

-- Top right
Position = UDim2.new(1, -210, 0, 10)

-- Center
Position = UDim2.new(0.5, -100, 0.5, -50)

-- Bottom center
Position = UDim2.new(0.5, -100, 1, -110)
```

## Event Flow

### Player Joins Game
```
1. Player connects → Players.PlayerAdded fires
2. GameManager.OnPlayerAdded() called
3. Player added to ActivePlayers table
4. Character spawns → CharacterAdded fires
5. GameManager.OnCharacterAdded() called
6. Character teleported to LobbySpawn
7. Client scripts load (GameUI, PortalClient)
8. UI appears on player's screen
```

### Player Interacts with Portal
```
1. Player approaches portal
2. ProximityPrompt appears
3. Player presses 'E' → Triggered event fires
4. Portal.OnPlayerInteract() called
5. PortalEvent:FireServer() sends to server
6. Server validates request
7. Server responds with action
8. Client plays effects/shows notification
```

## Debugging Tips

### Check Output Window
All scripts use print statements with module names:
- `[GameManager]` - Server game logic
- `[LobbySetup]` - Lobby creation
- `[Portal]` - Portal operations
- `[GameUI]` - Client UI
- `[PortalClient]` - Client portal handling
- `[Init]` - Initialization checks

### Common Issues

**Portals not appearing:**
```lua
-- Check Output for:
[Init] ❌ Portal module not found in ReplicatedStorage
-- Solution: Add Portal ModuleScript to ReplicatedStorage
```

**UI not showing:**
```lua
-- Check Output for:
[GameUI] Initializing UI...
-- If missing, check GameUI is LocalScript in StarterPlayerScripts
```

**Interaction not working:**
```lua
-- Check Output for:
[Init] ❌ PortalEvent RemoteEvent not found
-- Solution: Add RemoteEvent named "PortalEvent" to ReplicatedStorage
```

## Testing Checklist

- [ ] Run game in Play mode
- [ ] Check Output for initialization messages
- [ ] Verify lobby appears with spawn point
- [ ] Count 3 portals (red, green, yellow)
- [ ] Check UI appears at top of screen
- [ ] Verify stats panel on left side
- [ ] Walk to portal and check ProximityPrompt
- [ ] Interact with portal (press E)
- [ ] Check notification appears
- [ ] Test with multiple players (if possible)

## Next Steps for Development

1. **Implement Minigame Logic**
   - Create minigame areas in Workspace
   - Write minigame-specific scripts
   - Add win/lose conditions

2. **Add Teleportation**
   - Use GameUtils.TeleportPlayer()
   - Create minigame spawn points
   - Implement return to lobby

3. **Scoring System**
   - Extend GameManager to track scores
   - Update GameUI to display scores
   - Add leaderboard

4. **Team System**
   - Divide players into teams
   - Add team colors to UI
   - Implement team-based minigames

5. **Polish**
   - Add sound effects
   - Improve visual effects
   - Add transitions
   - Create better lighting

## Resources

- **Main Docs:** ROBLOX_README.md
- **Setup:** SETUP_GUIDE.txt
- **Architecture:** ARCHITECTURE.md
- **Roblox API:** https://create.roblox.com/docs
