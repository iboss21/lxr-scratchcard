# 🐺 LXR Scratchcard System - Configuration Guide

```
════════════════════════════════════════════════════════════════════════════════════════════════
COMPLETE CONFIGURATION REFERENCE
════════════════════════════════════════════════════════════════════════════════════════════════
```

## 📋 Table of Contents

1. [Configuration Overview](#configuration-overview)
2. [Server Information](#server-information)
3. [Framework Configuration](#framework-configuration)
4. [Language & Localization](#language--localization)
5. [General Settings](#general-settings)
6. [Economy & Prizes](#economy--prizes)
7. [Security Settings](#security-settings)
8. [Performance Settings](#performance-settings)
9. [Debug Options](#debug-options)
10. [Advanced Configuration](#advanced-configuration)

---

## 🎯 Configuration Overview

All configuration is centralized in `config.lua` with the following structure:

```lua
Config = {
    ServerInfo = {},        -- Server metadata
    Framework = 'auto',     -- Framework detection
    FrameworkSettings = {}, -- Per-framework config
    Lang = 'en',            -- Language
    Locale = {},            -- Translations
    General = {},           -- General settings
    Economy = {},           -- Prize config
    Security = {},          -- Security options
    Performance = {},       -- Performance tuning
    Debug = {},             -- Debug options
    Advanced = {},          -- Advanced features
}
```

---

## 🏛️ Server Information

**Path:** `Config.ServerInfo`

**Purpose:** Branding and metadata for The Land of Wolves.

```lua
Config.ServerInfo = {
    name          = 'The Land of Wolves 🐺',
    tagline       = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description   = 'ისტორია ცოცხლდება აქ!',  -- History Lives Here!
    type          = 'Serious Hardcore Roleplay',
    access        = 'Discord & Whitelisted',
    website       = 'https://www.wolves.land',
    discord       = 'https://discord.gg/CrKcWdfd3A',
    github        = 'https://github.com/iBoss21',
    store         = 'https://theluxempire.tebex.io',
    serverListing = 'https://servers.redm.net/servers/detail/8gj7eb',
    developer     = 'iBoss21 / The Lux Empire',
    tags          = {'RedM','Georgian','SeriousRP','Whitelist','Economy','RPG','Casino'}
}
```

**Customization:**
You can override these values for your server, but maintain the structure.

---

## 🔌 Framework Configuration

**Path:** `Config.Framework`

**Options:** `'auto'`, `'lxr-core'`, `'rsg-core'`, `'vorp'`, `'redemrp'`, `'qbr'`, `'qr'`, `'standalone'`

**Default:** `'auto'` (recommended)

```lua
-- Auto-detection (recommended)
Config.Framework = 'auto'

-- Manual override
Config.Framework = 'lxr-core'
```

### Framework Settings

**Path:** `Config.FrameworkSettings`

Each framework has dedicated configuration:

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

**See:** [Framework Guide](frameworks.md) for complete framework details.

---

## 🌍 Language & Localization

**Path:** `Config.Lang`, `Config.Locale`

**Supported Languages:**
- `'en'` - English (default)
- `'ka'` - Georgian (ქართული)
- `'tr'` - Turkish
- `'es'` - Spanish
- `'fr'` - French
- `'de'` - German
- `'ru'` - Russian

```lua
Config.Lang = 'en'

Config.Locale = {
    ['en'] = {
        ['already_scratching']  = 'You are already scratching a card!',
        ['won_prize']           = 'Congratulations! You won $%s!',
        -- ...
    },
    ['ka'] = {
        ['already_scratching']  = 'თქვენ უკვე ხახავთ ბარათს!',
        ['won_prize']           = 'გილოცავთ! მოიგეთ $%s!',
        -- ...
    },
}
```

**Adding New Language:**
1. Copy an existing language block
2. Translate all strings
3. Set `Config.Lang` to your language code

---

## ⚙️ General Settings

**Path:** `Config.General`

```lua
Config.General = {
    -- Item Configuration
    itemName        = 'scratchcard',    -- Item name in inventory
    itemLabel       = 'Scratch Card',   -- Display name
    itemWeight      = 0.1,              -- Weight
    itemLimit       = 20,               -- Max stack size
    
    -- UI Settings
    closeKey        = 'ESC',            -- Key to close UI
    scratchThreshold = 0.5,             -- % to scratch (0.0-1.0)
    
    -- Animation
    useAnimation    = true,             -- Enable animations
    animDict        = 'ai_react@gen@mg',
    animName        = 'gen_a_hold_obj',
    animDuration    = 3000,             -- ms
}
```

### Key Settings Explained

| Setting | Description | Values |
|---------|-------------|--------|
| `itemName` | Internal item identifier | Any string (must match inventory) |
| `scratchThreshold` | How much to scratch | 0.0 (none) to 1.0 (all) |
| `useAnimation` | Play scratch animation | `true` / `false` |

---

## 💰 Economy & Prizes

**Path:** `Config.Economy`

### Basic Prize System

```lua
Config.Economy = {
    -- Simple Prize Range
    prizes = {
        min = 0,        -- Minimum prize (0 = no prize)
        max = 10000,    -- Maximum prize
    },
    
    -- Win Chance
    winChance = 30,     -- 30% chance to win
    
    -- Currency Type
    currencyType = 'cash',  -- 'cash', 'bank', 'gold', 'tokens'
}
```

### Tiered Prize System (Advanced)

```lua
Config.Economy = {
    -- Enable Tiers
    useTiers = true,
    
    -- Tier Configuration
    tiers = {
        {chance = 50,  min = 1,    max = 100},      -- 50% - Small
        {chance = 30,  min = 101,  max = 500},      -- 30% - Medium
        {chance = 15,  min = 501,  max = 2000},     -- 15% - Large
        {chance = 4,   min = 2001, max = 5000},     -- 4%  - Jackpot
        {chance = 1,   min = 5001, max = 10000},    -- 1%  - MEGA
    },
}
```

**Note:** Tier chances must add up to ≤100%

### Prize Configuration Examples

**Conservative (Tight Economy):**
```lua
Config.Economy = {
    prizes = { min = 0, max = 1000 },
    winChance = 15,  -- 15%
}
```

**Balanced (Recommended):**
```lua
Config.Economy = {
    prizes = { min = 0, max = 5000 },
    winChance = 30,  -- 30%
}
```

**Generous (Loose Economy):**
```lua
Config.Economy = {
    prizes = { min = 100, max = 15000 },
    winChance = 50,  -- 50%
}
```

---

## 🔒 Security Settings

**Path:** `Config.Security`

```lua
Config.Security = {
    -- Validation
    validateInventory   = true,     -- Verify player has item
    validateDistance    = true,     -- Check movement
    maxDistance         = 10.0,     -- Max distance (meters)
    
    -- Anti-Spam
    enableCooldown      = true,     -- Per-player cooldown
    cooldownTime        = 5,        -- Seconds
    
    -- Rate Limiting
    enableRateLimit     = true,     -- Limit actions/minute
    maxActionsPerMinute = 10,       -- Max actions
    
    -- Exploit Prevention
    preventDuplication  = true,     -- Prevent duplication
    logSuspicious       = true,     -- Log suspicious activity
    
    -- Webhook Logging
    enableWebhook       = false,    -- Discord webhooks
    webhookURL          = '',       -- Your webhook URL
    logWins             = true,     -- Log all wins
    logLargeWins        = true,     -- Log large wins
    largeWinThreshold   = 5000,     -- Large win threshold
}
```

**Recommended Production Settings:**
```lua
Config.Security = {
    validateInventory = true,
    validateDistance = true,
    maxDistance = 10.0,
    enableCooldown = true,
    cooldownTime = 5,
    enableRateLimit = true,
    maxActionsPerMinute = 10,
    preventDuplication = true,
    logSuspicious = true,
}
```

**See:** [Security Guide](security.md) for detailed security information.

---

## ⚡ Performance Settings

**Path:** `Config.Performance`

```lua
Config.Performance = {
    -- Memory Management
    enableCaching       = true,     -- Cache player data
    cacheTimeout        = 300,      -- Cache timeout (seconds)
    cleanupInterval     = 600,      -- Cleanup interval (seconds)
    
    -- Optimization
    useNatives          = true,     -- Use native functions
    minimizeThreads     = true,     -- Minimize threads
    
    -- UI Performance
    uiUpdateRate        = 50,       -- UI update rate (ms)
}
```

**High-Performance Server (100+ players):**
```lua
Config.Performance = {
    enableCaching = true,
    cacheTimeout = 180,         -- 3 minutes
    cleanupInterval = 300,      -- 5 minutes
    uiUpdateRate = 100,         -- 10 FPS
}
```

**Low-Population Server (<32 players):**
```lua
Config.Performance = {
    enableCaching = true,
    cacheTimeout = 600,         -- 10 minutes
    cleanupInterval = 900,      -- 15 minutes
    uiUpdateRate = 33,          -- 30 FPS
}
```

**See:** [Performance Guide](performance.md) for optimization tips.

---

## 🐛 Debug Options

**Path:** `Config.Debug`

```lua
Config.Debug = {
    enabled             = false,    -- Enable debug mode
    printEvents         = false,    -- Print all events
    printFramework      = true,     -- Print framework detection
    printPrizes         = false,    -- Print prize calculations
    verboseLogging      = false,    -- Extra verbose output
    
    -- Testing
    testMode            = false,    -- Test mode (always win)
    forceWin            = false,    -- Force winning
    testPrize           = 1000,     -- Fixed test prize
}
```

**Development Settings:**
```lua
Config.Debug = {
    enabled = true,
    printEvents = true,
    printFramework = true,
    printPrizes = true,
    verboseLogging = true,
    testMode = false,  -- Don't use in production!
}
```

**Production Settings:**
```lua
Config.Debug = {
    enabled = false,
    printEvents = false,
    printFramework = true,  -- Only for startup
    printPrizes = false,
    verboseLogging = false,
    testMode = false,
}
```

---

## 🔧 Advanced Configuration

**Path:** `Config.Advanced`

```lua
Config.Advanced = {
    -- Database Integration
    useDatabase         = false,    -- Store history in DB
    tableName           = 'lxr_scratchcard_history',
    
    -- Statistics
    trackStats          = false,    -- Track usage stats
    statsInterval       = 3600,     -- Stats update interval
    
    -- Custom Hooks
    customHooks         = {
        beforeScratch   = nil,      -- function(source)
        afterScratch    = nil,      -- function(source, prize)
        onWin           = nil,      -- function(source, prize)
    },
}
```

### Custom Hooks Example

```lua
Config.Advanced.customHooks = {
    onWin = function(source, prize)
        -- Award bonus gold for large wins
        if prize >= 5000 then
            Framework.AddMoney(source, 500, 'gold')
            Framework.Notify(source, 'Bonus! +500 gold!', 'success', 5000)
        end
        
        -- Log to Discord
        if Config.Security.enableWebhook then
            -- Your webhook code
        end
    end
}
```

---

## 📝 Configuration Workflow

### 1. Initial Setup

```lua
-- Set framework (or leave as 'auto')
Config.Framework = 'auto'

-- Configure economy
Config.Economy = {
    prizes = { min = 0, max = 5000 },
    winChance = 30,
}

-- Enable security
Config.Security = {
    enableCooldown = true,
    cooldownTime = 5,
    enableRateLimit = true,
}
```

### 2. Test Configuration

```lua
-- Enable debug temporarily
Config.Debug = {
    enabled = true,
    printFramework = true,
}

-- Test with commands
/giveitem scratchcard 10
```

### 3. Production Deployment

```lua
-- Disable debug
Config.Debug.enabled = false

-- Verify security
Config.Security.validateInventory = true
Config.Security.enableCooldown = true

-- Optimize performance
Config.Performance.enableCaching = true
```

---

## 🔍 Configuration Validation

**Checklist before going live:**

- [ ] `Config.Framework` set appropriately
- [ ] Prize ranges reasonable for your economy
- [ ] Win chance not too high (inflation risk)
- [ ] Security features enabled
- [ ] Debug mode disabled
- [ ] Test mode disabled
- [ ] Webhook URL set (if using)
- [ ] Language set correctly
- [ ] Item name matches inventory config
- [ ] Performance settings appropriate for server size

---

## 📚 Related Documentation

- [Installation Guide](installation.md) - Initial setup
- [Security Guide](security.md) - Security features
- [Performance Guide](performance.md) - Optimization
- [Framework Guide](frameworks.md) - Framework integration

---

```
🐺 The Land of Wolves - Where History Lives
© 2026 The Lux Empire / iBoss21
```
