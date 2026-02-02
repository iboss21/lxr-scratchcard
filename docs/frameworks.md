# 🐺 LXR Scratchcard System - Framework Integration Guide

```
════════════════════════════════════════════════════════════════════════════════════════════════
FRAMEWORK INTEGRATION & COMPATIBILITY
════════════════════════════════════════════════════════════════════════════════════════════════
```

## 🎯 Overview

LXR Scratchcard System uses a **unified adapter pattern** to support multiple RedM frameworks without framework-specific code throughout the resource.

---

## 🔌 Supported Frameworks

| Framework | Priority | Status | Support Level |
|-----------|----------|--------|---------------|
| **LXR-Core** | Primary (1) | ✅ Active | Full Support - Native integration for wolves.land |
| **RSG-Core** | Primary (2) | ✅ Active | Full Support - Complete compatibility |
| **VORP Core** | Supported | ✅ Active | Full Support - Legacy/community servers |
| **RedEM:RP** | Supported | ✅ Active | Full Support - Original implementation |
| **QBR-Core** | Optional | ✅ Active | Limited Support - If detected |
| **QR-Core** | Optional | ✅ Active | Limited Support - If detected |
| **Standalone** | Fallback | ✅ Active | Basic Support - No framework required |

---

## 🔍 Auto-Detection

The system automatically detects your framework at startup using priority-based detection:

```lua
Detection Order:
1. LXR-Core     (lxr-core resource)
2. RSG-Core     (rsg-core resource)
3. VORP Core    (vorp_core resource)
4. RedEM:RP     (redemrp_core resource)
5. QBR-Core     (qbr-core resource)
6. QR-Core      (qr-core resource)
7. Standalone   (fallback)
```

### Manual Override

Set framework manually in `config.lua`:

```lua
Config.Framework = 'lxr-core'  -- Instead of 'auto'
```

---

## 🏗️ Framework Adapter Architecture

### Unified Interface

The adapter provides a single interface for all frameworks:

**Client-Side:**
```lua
Framework.Notify(message, type, duration)
Framework.CloseInventory()
```

**Server-Side:**
```lua
Framework.GetPlayer(source)
Framework.AddMoney(source, amount, type)
Framework.RemoveItem(source, item, amount)
Framework.HasItem(source, item, amount)
Framework.GetIdentifier(source)
```

### No Framework-Specific Code in Core Logic

❌ **Bad (Framework-Specific):**
```lua
if Framework == 'lxr-core' then
    -- LXR code
elseif Framework == 'rsg-core' then
    -- RSG code
-- ... many more
end
```

✅ **Good (Unified):**
```lua
Framework.AddMoney(source, amount)
-- Adapter handles framework differences
```

---

## 📋 Framework-Specific Details

### LXR-Core

**Export:**
```lua
exports['lxr-core']:GetCoreObject()
```

**Events Used:**
- `lxr-core:client:player:loaded`
- `lxr-core:client:notify`
- `lxr-core:callback:player:get`

**Item Registration:**
```lua
LXR.Functions.CreateUseableItem('scratchcard', callback)
```

**Dependencies:**
- lxr-core
- lxr-inventory (recommended)

---

### RSG-Core

**Export:**
```lua
exports['rsg-core']:GetCoreObject()
```

**Events Used:**
- `RSGCore:Client:OnPlayerLoaded`
- `RSGCore:Client:Notify`
- `RSGCore:GetPlayer`

**Item Registration:**
```lua
RSGCore.Functions.CreateUseableItem('scratchcard', callback)
```

**Dependencies:**
- rsg-core
- rsg-inventory (recommended)

---

### VORP Core

**Export:**
```lua
exports.vorp_core:getCore()
```

**Events Used:**
- `vorp:SelectedCharacter`
- `vorp:TipRight`

**Item Registration:**
```lua
exports.vorp_inventory:registerUsableItem('scratchcard', callback)
```

**Dependencies:**
- vorp_core
- vorp_inventory

---

### RedEM:RP

**System:** Event-based (no export)

**Events Used:**
- `redemrp:playerLoaded`
- `redem_roleplay:Tip`
- `redemrp:getAllPlayers`
- `redemrp_inventory:getData`

**Item Registration:**
```lua
-- Event-based via RegisterUsableItem:itemname
RegisterServerEvent("RegisterUsableItem:scratchcard")
```

**Dependencies:**
- redemrp_core
- redemrp_inventory

---

## 🔧 Configuration Per Framework

Each framework has dedicated settings in `config.lua`:

```lua
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resourceName = 'lxr-core',
        events = {
            playerLoaded = 'lxr-core:client:player:loaded',
            notify = 'lxr-core:client:notify',
            -- ...
        },
        inventory = {
            resource = 'lxr-inventory',
            closeEvent = 'lxr-inventory:client:close',
        },
        itemName = 'scratchcard',
    },
    -- ... other frameworks
}
```

---

## 🎮 Adding New Framework Support

### Step 1: Add Detection

Edit `shared/framework.lua`:

```lua
local detectionOrder = {
    -- Add your framework
    {name = 'newframework',  resource = 'new-core',  export = 'GetCore'},
    -- ...
}
```

### Step 2: Add Initialization

```lua
function Framework.InitNewFramework()
    if not Framework.Object then
        local success, core = pcall(function()
            return exports['new-core']:GetCore()
        end)
        if success and core then
            Framework.Object = core
        end
    end
end
```

### Step 3: Add Function Mappings

Implement unified functions for your framework:

```lua
-- In Framework adapter
if Framework.Name == 'newframework' then
    -- Add money implementation
    local Player = Framework.GetPlayer(source)
    if Player and Player.AddCash then
        Player.AddCash(amount)
        return true
    end
end
```

### Step 4: Add Configuration

Add to `config.lua`:

```lua
Config.FrameworkSettings['newframework'] = {
    resourceName = 'new-core',
    events = {
        playerLoaded = 'newframework:playerLoaded',
        notify = 'newframework:notify',
    },
    itemName = 'scratchcard',
}
```

### Step 5: Test Thoroughly

- Test item usage
- Test prize awarding
- Test notifications
- Test inventory integration
- Test all edge cases

---

## 🔍 Debugging Framework Issues

### Enable Debug Logging

```lua
Config.Debug = {
    enabled = true,
    printFramework = true,
    printEvents = true,
}
```

### Check Framework Detection

Look for console output:
```
[LXR-Scratchcard] Framework auto-detected: lxr-core
[LXR-Scratchcard] Server initialized with framework: lxr-core
```

### Common Issues

**Framework not detected:**
- Ensure framework resource is started first
- Check resource name matches detection logic
- Try manual override: `Config.Framework = 'lxr-core'`

**Item not useable:**
- Verify item registered in inventory config
- Check item name matches exactly
- Ensure `useable = true` in item config

**Prize not awarded:**
- Check framework player object is valid
- Verify money functions work
- Test framework export manually

---

## 📚 Related Documentation

- [Installation Guide](installation.md) - Framework-specific install steps
- [Configuration Guide](configuration.md) - Framework settings
- [Events Documentation](events.md) - Framework events used

---

```
🐺 The Land of Wolves - Where History Lives
© 2026 The Lux Empire / iBoss21
```
