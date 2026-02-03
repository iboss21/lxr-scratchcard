# 🐺 LXR Scratchcard System - Installation Guide

```
════════════════════════════════════════════════════════════════════════════════════════════════
INSTALLATION GUIDE
════════════════════════════════════════════════════════════════════════════════════════════════
```

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Installation](#quick-installation)
3. [Framework-Specific Setup](#framework-specific-setup)
4. [Inventory Item Configuration](#inventory-item-configuration)
5. [Server Configuration](#server-configuration)
6. [Verification](#verification)
7. [Troubleshooting](#troubleshooting)

---

## ✅ Prerequisites

Before installing LXR Scratchcard System, ensure you have:

- **RedM Server** - Prerelease build compatible with RedM
- **Framework** - One of: LXR-Core, RSG-Core, VORP, RedEM:RP, QBR, QR, or standalone
- **Inventory System** - Framework-compatible inventory
- **Basic Knowledge** - Lua and RedM resource configuration

### Recommended Setup

- Latest RedM server artifacts
- Up-to-date framework version
- Server restart capability
- Access to server console/logs

---

## 🚀 Quick Installation

### Step 1: Download

**Option A: GitHub Release**
```bash
# Download latest release
wget https://github.com/iBoss21/lxr-scratchcard/releases/latest/download/lxr-scratchcard.zip

# Extract
unzip lxr-scratchcard.zip
```

**Option B: Git Clone**
```bash
cd /path/to/your/resources
git clone https://github.com/iBoss21/lxr-scratchcard.git
```

### Step 2: Rename Folder

**⚠️ CRITICAL:** The folder **MUST** be named exactly `lxr-scratchcard`

```bash
# If downloaded with different name
mv qadr_scratchcard lxr-scratchcard
mv lxr-scratchcard-main lxr-scratchcard
# etc.
```

The resource has built-in name protection and will **not start** if the folder name is incorrect.

### Step 3: Place in Resources

Move the `lxr-scratchcard` folder to your server's resources directory:

```
your-server/
└── resources/
    └── [category]/
        └── lxr-scratchcard/    ← Place here
```

Common locations:
- `resources/[standalone]/lxr-scratchcard`
- `resources/[economy]/lxr-scratchcard`
- `resources/[minigames]/lxr-scratchcard`

### Step 4: Add to server.cfg

Add to your `server.cfg`:

```cfg
# LXR Scratchcard System
ensure lxr-scratchcard
```

**Important:** Add this **after** your framework starts:

```cfg
# Example order
ensure lxr-core          # Your framework
ensure lxr-inventory     # Your inventory
ensure lxr-scratchcard   # This resource
```

### Step 5: Configure

Edit `config.lua` to match your server settings:

```lua
-- Minimum required configuration
Config.Framework = 'auto'  -- or 'lxr-core', 'rsg-core', etc.

Config.Economy = {
    prizes = {
        min = 0,
        max = 10000,
    },
    winChance = 30,  -- 30% win rate
}
```

See [Configuration Guide](configuration.md) for all options.

### Step 6: Add Item to Inventory

See [Inventory Item Configuration](#inventory-item-configuration) below for framework-specific instructions.

### Step 7: Restart Server

```bash
# Stop server
# Start server
# or use restart command in console
restart lxr-scratchcard
```

---

## 🔌 Framework-Specific Setup

### LXR-Core

**1. Item Configuration**

Add to `lxr-core/shared/items.lua`:

```lua
['scratchcard'] = {
    ['name'] = 'scratchcard',
    ['label'] = 'Scratch Card',
    ['weight'] = 100,
    ['type'] = 'item',
    ['image'] = 'scratchcard.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A lottery scratchcard. Scratch to reveal your prize!'
},
```

**2. Add Image**

Place `scratchcard.png` in:
- `lxr-inventory/html/images/scratchcard.png`

**3. Resource Order**

```cfg
ensure lxr-core
ensure lxr-inventory
ensure lxr-scratchcard
```

---

### RSG-Core

**1. Item Configuration**

Add to `rsg-core/shared/items.lua`:

```lua
['scratchcard'] = {
    ['name'] = 'scratchcard',
    ['label'] = 'Scratch Card',
    ['weight'] = 100,
    ['type'] = 'item',
    ['image'] = 'scratchcard.png',
    ['unique'] = false,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['description'] = 'A lottery scratchcard. Scratch to reveal your prize!'
},
```

**2. Add Image**

Place `scratchcard.png` in:
- `rsg-inventory/html/images/scratchcard.png`

**3. Resource Order**

```cfg
ensure rsg-core
ensure rsg-inventory
ensure lxr-scratchcard
```

---

### VORP Core

**1. Database Setup**

Add item to database:

```sql
INSERT INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`) 
VALUES ('scratchcard', 'Scratch Card', 20, 1, 'item_standard', 1);
```

**2. Item Metadata**

Add to `vorp_inventory/config.lua`:

```lua
Config.Items = {
    ['scratchcard'] = {
        label = 'Scratch Card',
        description = 'A lottery scratchcard. Scratch to reveal your prize!',
        weight = 0.1,
        limit = 20,
        can_remove = true,
    },
}
```

**3. Add Image**

Place `scratchcard.png` in:
- `vorp_inventory/html/img/items/scratchcard.png`

**4. Resource Order**

```cfg
ensure vorp_core
ensure vorp_inventory
ensure lxr-scratchcard
```

---

### RedEM:RP

**1. Database Setup**

Add item to database:

```sql
INSERT INTO `items` (`item`, `label`, `description`, `limit`, `can_remove`, `type`, `usable`) 
VALUES ('scratchcard', 'Scratch Card', 'A lottery scratchcard.', 20, 1, 'item_standard', 1);
```

**2. Inventory Config**

Add to `redemrp_inventory/config.lua`:

```lua
Config.Items = {
    scratchcard = {
        label = "Scratchcard",
        description = "A lottery scratchcard. Scratch to reveal your prize!",
        weight = 0.1,
        canBeDropped = true,
        canBeUsed = true,
        requireLvl = 0,
        limit = 20,
        imgsrc = "items/scratchcard.png",
        type = "item_standard",
    },
}
```

**3. Add Image**

Place `scratchcard.png` in:
- `redemrp_inventory/html/img/items/scratchcard.png`

**4. Resource Order**

```cfg
ensure redemrp_core
ensure redemrp_inventory
ensure lxr-scratchcard
```

---

### Standalone Mode

If running without a framework:

1. Set `Config.Framework = 'standalone'` in `config.lua`
2. Implement custom item usage (no built-in inventory support)
3. Use commands or custom triggers to give/use cards

---

## 📦 Inventory Item Configuration

### Item Properties

Recommended item configuration across all frameworks:

| Property | Value | Description |
|----------|-------|-------------|
| **Name** | `scratchcard` | Internal item name |
| **Label** | `Scratch Card` | Display name |
| **Weight** | `0.1` or `100` | Item weight (framework dependent) |
| **Limit** | `20` | Max stack size |
| **Useable** | `true` | Can be used from inventory |
| **Close on Use** | `true` | Close inventory when used |
| **Removable** | `true` | Can be dropped/removed |

### Item Image

**Image Requirements:**
- Format: PNG with transparency
- Size: 256x256 or 512x512 pixels
- File name: `scratchcard.png`

**Image Location by Framework:**
- LXR-Core: `lxr-inventory/html/images/`
- RSG-Core: `rsg-inventory/html/images/`
- VORP: `vorp_inventory/html/img/items/`
- RedEM:RP: `redemrp_inventory/html/img/items/`

---

## ⚙️ Server Configuration

### Essential Configuration

Edit `config.lua`:

```lua
-- Framework (auto-detect or manual)
Config.Framework = 'auto'

-- Prize configuration
Config.Economy = {
    prizes = {
        min = 0,
        max = 10000,
    },
    winChance = 30,  -- 30%
}

-- Security (recommended)
Config.Security = {
    enableCooldown = true,
    cooldownTime = 5,  -- seconds
    enableRateLimit = true,
    maxActionsPerMinute = 10,
}
```

### Optional Configuration

```lua
-- Localization
Config.Lang = 'en'  -- or 'ka', 'tr', etc.

-- Debug (disable in production)
Config.Debug = {
    enabled = false,
    printFramework = true,
}

-- Tiered prizes (advanced)
Config.Economy.useTiers = true
Config.Economy.tiers = {
    {chance = 50,  min = 1,    max = 100},
    {chance = 30,  min = 101,  max = 500},
    {chance = 15,  min = 501,  max = 2000},
    {chance = 4,   min = 2001, max = 5000},
    {chance = 1,   min = 5001, max = 10000},
}
```

See [Configuration Guide](configuration.md) for all options.

---

## ✔️ Verification

### 1. Check Console on Startup

Look for the boot banner:

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║        🐺 LXR SCRATCHCARD SYSTEM - SUCCESSFULLY LOADED            ║
║                                                                   ║
║        Version:    2.0.0 (Land of Wolves Edition)                ║
║        Framework:  lxr-core (Auto-Detection)                     ║
║        ...                                                        ║
╚═══════════════════════════════════════════════════════════════════╝
```

### 2. Check Framework Detection

Console should show:
```
[LXR-Scratchcard] Framework auto-detected: lxr-core
[LXR-Scratchcard] Server initialized with framework: lxr-core
```

### 3. Test Item Usage

1. Give yourself a scratchcard:
   ```
   # LXR/RSG/QBR/QR
   /giveitem [id] scratchcard 1
   
   # VORP
   /giveitem scratchcard 1
   
   # RedEM:RP
   /giveitem scratchcard 1
   ```

2. Open inventory
3. Use the scratchcard
4. Scratch the card
5. Verify prize (if won)

### 4. Check for Errors

Monitor console for:
- Red error messages
- Missing dependencies
- Framework issues
- Item registration failures

---

## 🔧 Troubleshooting

### Resource Won't Start

**Issue:** Resource name mismatch error

**Solution:**
```bash
# Rename folder to exactly: lxr-scratchcard
mv current-folder-name lxr-scratchcard
restart lxr-scratchcard
```

---

### Framework Not Detected

**Issue:** "No framework detected, running in standalone mode"

**Solutions:**
1. Ensure framework starts **before** lxr-scratchcard
2. Check framework resource name matches config
3. Manually set framework: `Config.Framework = 'lxr-core'`
4. Verify framework resource state: `resmon` command

---

### Item Not Useable

**Issue:** Item doesn't trigger scratchcard

**Solutions:**
1. Verify item is registered in inventory config
2. Check `useable = true` in item config
3. Verify item name is exactly `scratchcard`
4. Check console for item registration errors
5. Restart both inventory and scratchcard resources

---

### UI Won't Open

**Issue:** Nothing happens when using item

**Solutions:**
1. Check F8 client console for errors
2. Verify `html/` folder and files exist
3. Check NUI callbacks are registered
4. Test with debug mode: `Config.Debug.enabled = true`

---

### No Prize Awarded

**Issue:** Prize shows but money not added

**Solutions:**
1. Check server console for errors
2. Verify economy integration
3. Test framework money functions
4. Check player has valid character/player data
5. Enable debug logging: `Config.Debug.printPrizes = true`

---

### Distance Validation Errors

**Issue:** "You moved too far" errors

**Solutions:**
1. Increase `Config.Security.maxDistance` (default: 10.0)
2. Disable distance validation: `Config.Security.validateDistance = false`
3. Check for teleport/position bugs in other resources

---

## 📞 Getting Help

If you encounter issues not covered here:

1. **Check Logs** - Server and client F8 console
2. **Enable Debug** - Set `Config.Debug.enabled = true`
3. **Read Docs** - Check other documentation files
4. **Discord Support** - [Join our Discord](https://discord.gg/CrKcWdfd3A)
5. **GitHub Issues** - [Report bugs](https://github.com/iBoss21/lxr-scratchcard/issues)

---

## 📚 Next Steps

After installation:

1. [Configure](configuration.md) the resource for your server
2. Review [Security](security.md) best practices
3. Check [Framework Integration](frameworks.md) details
4. Learn about [Events & API](events.md)
5. Optimize [Performance](performance.md)

---

```
🐺 The Land of Wolves - Where History Lives
© 2026 The Lux Empire / iBoss21
```
