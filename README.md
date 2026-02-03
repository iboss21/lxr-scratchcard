# 🐺 LXR Scratchcard System

```
════════════════════════════════════════════════════════════════════════════════════════════════
  ██╗  ██╗██████╗     ███████╗ ██████╗██████╗  █████╗ ████████╗ ██████╗██╗  ██╗ 
  ██║  ██║██╔══██╗    ██╔════╝██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║  ██║
  ██║  ██║██████╔╝    ███████╗██║     ██████╔╝███████║   ██║   ██║     ███████║
  ██║  ██║██╔══██╗    ╚════██║██║     ██╔══██╗██╔══██║   ██║   ██║     ██╔══██║
  ███████║██║  ██║    ███████║╚██████╗██║  ██║██║  ██║   ██║   ╚██████╗██║  ██║
  ╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝
════════════════════════════════════════════════════════════════════════════════════════════════
```

## 🎰 Overview

**LXR Scratchcard System** is a comprehensive, multi-framework lottery/scratchcard resource for **RedM** servers. Players can purchase and scratch lottery cards for a chance to win prizes with configurable odds and rewards.

### ✨ Key Features

- 🎯 **Multi-Framework Support** - Works with LXR-Core, RSG-Core, VORP, RedEM:RP, QBR, and standalone
- 🔒 **Secure Server-Side Validation** - All prize calculations happen server-side
- 🛡️ **Anti-Abuse Protection** - Cooldowns, rate limiting, and distance validation
- 🎨 **Interactive Scratch UI** - Engaging HTML5/Canvas scratch mechanic
- ⚙️ **Highly Configurable** - Extensive configuration options for all aspects
- 📊 **Statistics & Logging** - Optional tracking and Discord webhooks
- 🌍 **Multi-Language Support** - Built-in localization system
- 🚀 **Performance Optimized** - <5ms idle, <10ms active per player

---

## 🐺 Server Information

**The Land of Wolves** 🇬🇪  
*Georgian RP - მგლების მიწა - რჩეულთა ადგილი!*  
*ისტორია ცოცხლდება აქ!* (History Lives Here!)

- **Type:** Serious Hardcore Roleplay
- **Access:** Discord & Whitelisted
- **Website:** [wolves.land](https://www.wolves.land)
- **Discord:** [Join Our Pack](https://discord.gg/CrKcWdfd3A)
- **Store:** [Tebex Store](https://theluxempire.tebex.io)
- **GitHub:** [@iBoss21](https://github.com/iBoss21)

---

## 📦 Installation

### Prerequisites

- RedM server (prerelease build)
- One of the supported frameworks (or run standalone)
- Basic understanding of Lua and FiveM/RedM resources

### Quick Install

1. **Download** the latest release or clone the repository
2. **Rename** the folder to exactly `lxr-scratchcard`
3. **Place** the folder in your server's `resources` directory
4. **Add** to your `server.cfg`:
   ```cfg
   ensure lxr-scratchcard
   ```
5. **Configure** the `config.lua` file (see [Configuration Guide](docs/configuration.md))
6. **Add item** to your inventory system (see [Installation Guide](docs/installation.md))
7. **Restart** your server

### Detailed Installation

For detailed installation instructions, including framework-specific setup, see:
- [📖 Installation Guide](docs/installation.md)

---

## 🔧 Configuration

The resource is highly configurable through `config.lua`. Key configuration sections include:

- **Framework Settings** - Auto-detection and manual override
- **Economy & Prizes** - Win chances, prize ranges, tiered rewards
- **Security** - Cooldowns, rate limits, anti-exploit measures
- **UI/UX** - Keys, animations, notifications
- **Performance** - Caching, optimization settings
- **Debug** - Development and testing tools

For detailed configuration documentation, see:
- [⚙️ Configuration Guide](docs/configuration.md)

---

## 🎮 Usage

### For Players

1. Obtain a scratchcard item (purchase from vendor, event reward, etc.)
2. Open your inventory
3. Use the scratchcard item
4. Scratch the card by dragging your mouse/cursor over it
5. Reveal your prize!
6. Press `ESC` to close the card

### For Server Admins

- Configure prize ranges and win chances in `config.lua`
- Monitor logs for suspicious activity
- Adjust security settings as needed
- Set up Discord webhooks for prize notifications (optional)

---

## 🎯 Framework Support

### Supported Frameworks

| Framework | Support Level | Status |
|-----------|---------------|--------|
| **LXR-Core** | ⭐ Primary | ✅ Full Support |
| **RSG-Core** | ⭐ Primary | ✅ Full Support |
| **VORP Core** | 🔧 Supported | ✅ Full Support |
| **RedEM:RP** | 🔧 Supported | ✅ Full Support |
| **QBR-Core** | 📦 Optional | ✅ Limited Support |
| **QR-Core** | 📦 Optional | ✅ Limited Support |
| **Standalone** | 🏗️ Fallback | ✅ Basic Support |

### Auto-Detection

The resource automatically detects your framework at startup. No manual configuration needed in most cases!

For more information on framework integration, see:
- [🔌 Framework Guide](docs/frameworks.md)

---

## 📚 Documentation

Comprehensive documentation is available in the `docs/` folder:

- [📖 Overview](docs/overview.md) - System architecture and design
- [🚀 Installation](docs/installation.md) - Step-by-step installation guide
- [⚙️ Configuration](docs/configuration.md) - All configuration options explained
- [🔌 Frameworks](docs/frameworks.md) - Framework integration details
- [📡 Events](docs/events.md) - All events and exports
- [🔒 Security](docs/security.md) - Security features and best practices
- [⚡ Performance](docs/performance.md) - Optimization and performance tips
- [📸 Screenshots](docs/screenshots.md) - Visual documentation requirements

---

## 🔐 Security Features

- ✅ Server-side prize calculation (no client trust)
- ✅ Per-player cooldowns (configurable)
- ✅ Rate limiting (max actions per minute)
- ✅ Distance validation (anti-teleport exploit)
- ✅ Inventory verification
- ✅ Suspicious activity logging
- ✅ Optional Discord webhook notifications

---

## 🛠️ API & Events

### Client Events

```lua
-- Show scratchcard UI
TriggerEvent('lxr-scratchcard:client:showCard', prize)

-- Use scratchcard (trigger server validation)
TriggerEvent('lxr-scratchcard:client:useCard')

-- Notify player
TriggerEvent('lxr-scratchcard:client:notify', message, type, duration)
```

### Server Events

```lua
-- Award prize to player
TriggerEvent('lxr-scratchcard:server:claimPrize')

-- Use card (calculate prize)
TriggerEvent('lxr-scratchcard:server:useCard')
```

### Exports

```lua
-- Client exports
local isScratching = exports['lxr-scratchcard']:IsScratching()
exports['lxr-scratchcard']:UseScratchcard()

-- Server exports
local prize = exports['lxr-scratchcard']:CalculatePrize()
exports['lxr-scratchcard']:AwardPrize(source, amount)
```

For complete event documentation, see:
- [📡 Events Documentation](docs/events.md)

---

## 📊 Performance

- **Idle:** <5ms per player
- **Active:** <10ms per player during scratch
- **Memory:** ~5-10MB depending on UI assets
- **Network:** Minimal (only essential events)

For performance optimization tips, see:
- [⚡ Performance Guide](docs/performance.md)

---

## 🤝 Credits

- **Original Concept:** [flux_scratchcard](https://github.com/xFluXioN/flux_scratchcard) by xFluXioN
- **Original Version:** qadr_scratchcard
- **Transformed & Enhanced:** iBoss21 for The Land of Wolves 🐺
- **Server:** The Land of Wolves (wolves.land)

---

## 📄 License

**All Rights Reserved** - The Lux Empire / iBoss21

This resource is proprietary software developed for The Land of Wolves. Unauthorized copying, distribution, or modification is prohibited without explicit permission.

For licensing inquiries, contact:
- **Website:** [wolves.land](https://www.wolves.land)
- **Discord:** [Join Our Pack](https://discord.gg/CrKcWdfd3A)
- **Store:** [Tebex Store](https://theluxempire.tebex.io)

---

## 🐛 Issues & Support

For bug reports, feature requests, or support:

1. Check the [documentation](docs/)
2. Join our [Discord server](https://discord.gg/CrKcWdfd3A)
3. Open an issue on [GitHub](https://github.com/iBoss21/lxr-scratchcard/issues)

---

## 🔗 Links

- 🌐 **Website:** [wolves.land](https://www.wolves.land)
- 💬 **Discord:** [discord.gg/CrKcWdfd3A](https://discord.gg/CrKcWdfd3A)
- 🛒 **Store:** [theluxempire.tebex.io](https://theluxempire.tebex.io)
- 📦 **GitHub:** [github.com/iBoss21](https://github.com/iBoss21)
- 📊 **Server:** [RedM Server Listing](https://servers.redm.net/servers/detail/8gj7eb)

---

```
════════════════════════════════════════════════════════════════════════════════════════════════
🐺 The Land of Wolves - Where History Lives (ისტორია ცოცხლდება აქ!)
© 2026 The Lux Empire / iBoss21 - All Rights Reserved
════════════════════════════════════════════════════════════════════════════════════════════════
```
