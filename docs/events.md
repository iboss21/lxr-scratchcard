# 🐺 LXR Scratchcard System - Events & API Documentation

```
════════════════════════════════════════════════════════════════════════════════════════════════
EVENTS, CALLBACKS & API REFERENCE
════════════════════════════════════════════════════════════════════════════════════════════════
```

## 📋 Table of Contents

1. [Client Events](#client-events)
2. [Server Events](#server-events)
3. [NUI Callbacks](#nui-callbacks)
4. [Exports](#exports)
5. [Framework Adapter API](#framework-adapter-api)
6. [Usage Examples](#usage-examples)

---

## 📡 Client Events

### Received Events (Server → Client)

#### `lxr-scratchcard:client:showCard`
Display the scratchcard UI with a prize amount.

**Parameters:**
- `prize` (number) - Prize amount to display (0 = no prize)

**Example:**
```lua
TriggerClientEvent('lxr-scratchcard:client:showCard', source, 1000)
```

---

#### `lxr-scratchcard:client:notify`
Show a notification to the player.

**Parameters:**
- `message` (string) - Notification message
- `type` (string) - Notification type ('info', 'success', 'error', 'warning')
- `duration` (number) - Duration in milliseconds

**Example:**
```lua
TriggerClientEvent('lxr-scratchcard:client:notify', source, 'You won $1000!', 'success', 5000)
```

---

#### `lxr-scratchcard:client:useCard`
Trigger the client to initiate card usage.

**Parameters:** None

**Example:**
```lua
TriggerClientEvent('lxr-scratchcard:client:useCard', source)
```

---

#### `lxr-scratchcard:client:closeInventory`
Tell client to close the inventory.

**Parameters:** None

**Example:**
```lua
TriggerClientEvent('lxr-scratchcard:client:closeInventory', source)
```

---

### Sent Events (Client → Server)

#### `lxr-scratchcard:server:useCard`
Request to use a scratchcard (triggers prize calculation).

**Parameters:** None

**Example:**
```lua
TriggerServerEvent('lxr-scratchcard:server:useCard')
```

---

#### `lxr-scratchcard:server:claimPrize`
Claim the revealed prize.

**Parameters:** None

**Example:**
```lua
TriggerServerEvent('lxr-scratchcard:server:claimPrize')
```

---

#### `lxr-scratchcard:server:invalidMovement`
Report suspicious player movement during scratch.

**Parameters:**
- `distance` (number) - Distance moved in meters

**Example:**
```lua
TriggerServerEvent('lxr-scratchcard:server:invalidMovement', 15.5)
```

---

## 🖥️ Server Events

### Received Events (Client → Server)

All server events are registered with `RegisterServerEvent` and handled with `AddEventHandler`.

#### `lxr-scratchcard:server:useCard`
Handle scratchcard usage request.

**Handler:**
```lua
RegisterServerEvent("lxr-scratchcard:server:useCard")
AddEventHandler("lxr-scratchcard:server:useCard", function()
    local source = source
    -- Prize calculation logic
end)
```

---

#### `lxr-scratchcard:server:claimPrize`
Handle prize claim request.

**Handler:**
```lua
RegisterServerEvent("lxr-scratchcard:server:claimPrize")
AddEventHandler("lxr-scratchcard:server:claimPrize", function()
    local source = source
    -- Prize awarding logic
end)
```

---

### Sent Events (Server → Client)

All server-to-client events use `TriggerClientEvent`.

---

## 🎨 NUI Callbacks

### `closenui`
Called when player closes the scratchcard UI.

**Data:** None

**Response:**
```lua
{status = 'ok'}
```

**Handler:**
```lua
RegisterNUICallback("closenui", function(data, cb)
    -- Close UI logic
    if cb then
        cb({status = 'ok'})
    end
end)
```

---

### `scratchProgress`
Called during scratch progress (optional feature).

**Data:**
- `progress` (number) - Scratch completion (0.0 - 1.0)

**Response:**
```lua
{status = 'ok'}
```

**Handler:**
```lua
RegisterNUICallback("scratchProgress", function(data, cb)
    -- Progress tracking logic
    if cb then
        cb({status = 'ok'})
    end
end)
```

---

## 📤 Exports

### Client Exports

#### `UseScratchcard`
Manually trigger scratchcard usage.

**Usage:**
```lua
exports['lxr-scratchcard']:UseScratchcard()
```

---

#### `IsScratching`
Check if player is currently scratching a card.

**Returns:** `boolean`

**Usage:**
```lua
local scratching = exports['lxr-scratchcard']:IsScratching()
if scratching then
    print('Player is scratching a card')
end
```

---

### Server Exports

#### `AwardPrize`
Manually award a prize to a player.

**Parameters:**
- `source` (number) - Player server ID
- `amount` (number) - Prize amount

**Usage:**
```lua
exports['lxr-scratchcard']:AwardPrize(source, 1000)
```

---

#### `CalculatePrize`
Calculate a random prize based on configuration.

**Returns:** `number` - Prize amount (0 = no prize)

**Usage:**
```lua
local prize = exports['lxr-scratchcard']:CalculatePrize()
print('Generated prize: $' .. prize)
```

---

## 🔌 Framework Adapter API

The framework adapter provides a unified interface for all frameworks.

### Client-Side Functions

#### `Framework.Notify(message, type, duration)`
Show a notification using the active framework.

**Parameters:**
- `message` (string) - Notification text
- `type` (string) - Type: 'info', 'success', 'error', 'warning'
- `duration` (number) - Duration in milliseconds

**Example:**
```lua
Framework.Notify('Card scratched!', 'success', 3000)
```

---

#### `Framework.CloseInventory()`
Close player's inventory using framework method.

**Example:**
```lua
Framework.CloseInventory()
```

---

### Server-Side Functions

#### `Framework.GetPlayer(source)`
Get player object from framework.

**Parameters:**
- `source` (number) - Player server ID

**Returns:** `table|nil` - Player object or nil

**Example:**
```lua
local Player = Framework.GetPlayer(source)
if Player then
    -- Use player object
end
```

---

#### `Framework.AddMoney(source, amount, moneyType)`
Add money to player.

**Parameters:**
- `source` (number) - Player server ID
- `amount` (number) - Amount to add
- `moneyType` (string) - Type: 'cash', 'bank', 'gold' (default: 'cash')

**Returns:** `boolean` - Success status

**Example:**
```lua
local success = Framework.AddMoney(source, 1000, 'cash')
```

---

#### `Framework.RemoveItem(source, item, amount)`
Remove item from player inventory.

**Parameters:**
- `source` (number) - Player server ID
- `item` (string) - Item name
- `amount` (number) - Quantity (default: 1)

**Returns:** `boolean` - Success status

**Example:**
```lua
local removed = Framework.RemoveItem(source, 'scratchcard', 1)
```

---

#### `Framework.HasItem(source, item, amount)`
Check if player has item.

**Parameters:**
- `source` (number) - Player server ID
- `item` (string) - Item name
- `amount` (number) - Required quantity (default: 1)

**Returns:** `boolean` - Has item status

**Example:**
```lua
local hasCard = Framework.HasItem(source, 'scratchcard', 1)
```

---

#### `Framework.GetIdentifier(source)`
Get player's unique identifier.

**Parameters:**
- `source` (number) - Player server ID

**Returns:** `string|nil` - Player identifier

**Example:**
```lua
local identifier = Framework.GetIdentifier(source)
print('Player ID: ' .. identifier)
```

---

## 💡 Usage Examples

### Give Player a Scratchcard

```lua
-- Server-side
RegisterCommand('givecard', function(source, args)
    local amount = tonumber(args[1]) or 1
    
    -- Give item through framework
    if Framework.Name == 'lxr-core' or Framework.Name == 'rsg-core' then
        local Player = Framework.GetPlayer(source)
        if Player then
            Player.Functions.AddItem('scratchcard', amount)
        end
    elseif Framework.Name == 'vorp' then
        exports.vorp_inventory:addItem(source, 'scratchcard', amount)
    elseif Framework.Name == 'redemrp' then
        -- RedEM:RP method
        TriggerEvent('redemrp_inventory:getData', function(call)
            local ItemData = call.getItem(source, 'scratchcard')
            if ItemData then
                ItemData.AddItem(amount)
            end
        end)
    end
    
    Framework.Notify(source, 'You received ' .. amount .. ' scratchcard(s)', 'success', 3000)
end, true) -- restricted to admins
```

---

### Custom Prize Event Hook

```lua
-- Server-side in config.lua
Config.Advanced.customHooks = {
    onWin = function(source, prize)
        -- Log to Discord
        if Config.Security.enableWebhook then
            local identifier = Framework.GetIdentifier(source)
            local playerName = GetPlayerName(source)
            
            -- Send webhook (implement your webhook function)
            SendDiscordLog({
                title = '🎰 Scratchcard Win!',
                description = playerName .. ' won $' .. prize,
                color = 3066993, -- Green
                fields = {
                    {name = 'Player', value = playerName},
                    {name = 'Prize', value = '$' .. prize},
                    {name = 'Identifier', value = identifier},
                }
            })
        end
        
        -- Give bonus for large wins
        if prize >= 5000 then
            -- Give extra reward
            Framework.AddMoney(source, 500, 'gold')
            Framework.Notify(source, 'Bonus! You also received 500 gold!', 'success', 5000)
        end
    end
}
```

---

### Check If Player Can Use Card

```lua
-- Server-side
function CanUseCard(source)
    -- Check if player has card
    if not Framework.HasItem(source, 'scratchcard', 1) then
        return false, 'No scratchcard in inventory'
    end
    
    -- Check cooldown (implement your cooldown check)
    local identifier = Framework.GetIdentifier(source)
    if IsOnCooldown(identifier) then
        return false, 'Cooldown active'
    end
    
    -- Check if player is scratching
    local scratchData = GetScratchData(identifier)
    if scratchData and scratchData.stillUsing then
        return false, 'Already scratching'
    end
    
    return true
end

-- Usage
RegisterCommand('usecard', function(source)
    local canUse, reason = CanUseCard(source)
    if canUse then
        -- Trigger card use
        TriggerEvent('lxr-scratchcard:server:useCard', source)
    else
        Framework.Notify(source, reason, 'error', 3000)
    end
end)
```

---

### Custom Scratch Animation

```lua
-- Client-side
function CustomScratchAnimation()
    local playerPed = PlayerPedId()
    
    -- Custom animation
    RequestAnimDict('amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop')
    while not HasAnimDictLoaded('amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop') do
        Citizen.Wait(10)
    end
    
    TaskPlayAnim(
        playerPed,
        'amb_work@world_human_box_pickup@1@male_a@stand_exit_withprop',
        'exit_withprop',
        8.0, -8.0, -1,
        1, 0, false, false, false
    )
end

-- Override default animation
RegisterNetEvent('lxr-scratchcard:client:showCard')
AddEventHandler('lxr-scratchcard:client:showCard', function(prize)
    CustomScratchAnimation()
    -- Continue with normal UI display
end)
```

---

## 🔍 Event Flow Diagram

```
Player Uses Item
       ↓
[Framework Item Event]
       ↓
RegisterUsableItem Callback
       ↓
HandleItemUse(source)
       ↓
Security Checks (cooldown, rate limit, inventory)
       ↓
RemoveItemFromInventory(source)
       ↓
TriggerEvent('lxr-scratchcard:server:useCard')
       ↓
CalculatePrize()
       ↓
SetCard(identifier, prize)
       ↓
TriggerClientEvent('lxr-scratchcard:client:showCard', source, prize)
       ↓
[Client] ShowScratchcardUI(prize)
       ↓
[Client] Player Scratches
       ↓
[NUI] closenui callback
       ↓
[Client] CloseScratchcardUI()
       ↓
TriggerServerEvent('lxr-scratchcard:server:claimPrize')
       ↓
[Server] AwardPrize(source, prize)
       ↓
Framework.AddMoney(source, prize)
       ↓
TriggerClientEvent('lxr-scratchcard:client:notify', source, message)
```

---

## 📚 Related Documentation

- [Overview](overview.md) - System architecture
- [Framework Guide](frameworks.md) - Framework integration
- [Security Guide](security.md) - Security features

---

```
🐺 The Land of Wolves - Where History Lives
© 2026 The Lux Empire / iBoss21
```
