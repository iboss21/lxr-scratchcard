# 🐺 LXR Scratchcard - Shared Scripts

```
════════════════════════════════════════════════════════════════════════════════════════════════
SHARED SCRIPTS (CLIENT & SERVER)
════════════════════════════════════════════════════════════════════════════════════════════════
```

## 📂 Purpose

This folder contains **shared scripts** that are loaded on both client and server.

### Scope

- Framework detection and adapter layer
- Shared utility functions
- Common data structures
- Localization helpers
- Debug/logging functions

### Files

- `framework.lua` - Framework auto-detection and unified adapter layer
- `utils.lua` - Shared utility functions and helpers

---

## 🔧 Framework Adapter (`framework.lua`)

The framework adapter provides a **unified interface** for interacting with multiple RedM frameworks.

### Features

- **Auto-Detection** - Automatically detects active framework at runtime
- **Unified API** - Single function calls for all frameworks
- **Priority System** - LXR-Core → RSG-Core → VORP → RedEM:RP → Others
- **No Fake Events** - Only uses real framework events and exports

### Supported Frameworks

| Framework | Support | Object Access |
|-----------|---------|---------------|
| LXR-Core | ⭐ Primary | `exports['lxr-core']:GetCoreObject()` |
| RSG-Core | ⭐ Primary | `exports['rsg-core']:GetCoreObject()` |
| VORP Core | 🔧 Supported | `exports.vorp_core:getCore()` |
| RedEM:RP | 🔧 Supported | Event-based system |
| QBR-Core | 📦 Optional | `exports['qbr-core']:GetCoreObject()` |
| QR-Core | 📦 Optional | `exports['qr-core']:GetCoreObject()` |
| Standalone | 🏗️ Fallback | None |

### Unified Functions

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

---

## 🔧 Utilities (`utils.lua`)

Shared helper functions used throughout the resource.

### Functions

**Localization:**
```lua
Utils.GetLocale(key, ...)  -- Get localized string
```

**Debugging:**
```lua
Utils.Debug(message, ...)   -- Debug logging
Utils.Log(message, ...)     -- Info logging
Utils.Error(message, ...)   -- Error logging
```

**Table Utilities:**
```lua
Utils.TableCount(tbl)           -- Count table entries
Utils.TableHasValue(tbl, value) -- Check if value exists
```

**String Utilities:**
```lua
Utils.Trim(str)              -- Trim whitespace
Utils.Split(str, delimiter)  -- Split string
```

**Math Utilities:**
```lua
Utils.Round(num, decimals)   -- Round number
Utils.RandomFloat(min, max)  -- Random float
Utils.Clamp(value, min, max) -- Clamp value
```

---

## 🎯 Design Philosophy

The shared layer is designed to:

1. **Maintain Clean Core Logic** - Business logic shouldn't know about frameworks
2. **Prevent Code Duplication** - Write once, use everywhere
3. **Enable Easy Testing** - Unified interfaces are easier to mock/test
4. **Support Future Frameworks** - Adding new frameworks is straightforward

---

## 🔌 Adding New Framework Support

To add support for a new framework:

1. Add detection logic in `Framework.Detect()`
2. Create initialization function (e.g., `Framework.InitNewFramework()`)
3. Implement unified function mappings
4. Add framework settings to `config.lua`
5. Test thoroughly on both client and server

---

```
🐺 The Land of Wolves - Where History Lives
© 2026 The Lux Empire / iBoss21
```
