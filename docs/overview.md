# 🐺 LXR Scratchcard System - Overview

```
════════════════════════════════════════════════════════════════════════════════════════════════
SYSTEM OVERVIEW & ARCHITECTURE
════════════════════════════════════════════════════════════════════════════════════════════════
```

## 📋 Table of Contents

1. [Introduction](#introduction)
2. [System Architecture](#system-architecture)
3. [Design Philosophy](#design-philosophy)
4. [Component Overview](#component-overview)
5. [Data Flow](#data-flow)
6. [Security Model](#security-model)

---

## 🎯 Introduction

The **LXR Scratchcard System** is a comprehensive lottery/scratchcard resource for RedM servers that provides:

- Multi-framework compatibility (LXR-Core, RSG-Core, VORP, RedEM:RP, etc.)
- Secure server-side validation and prize calculation
- Comprehensive anti-abuse protection
- Interactive HTML5/Canvas scratch mechanic
- Extensive configuration options

### Key Goals

1. **Security First** - All authoritative operations happen server-side
2. **Framework Agnostic** - Works with any RedM framework through adapter pattern
3. **Performance Optimized** - Minimal resource usage (<5ms idle)
4. **Highly Configurable** - Extensive options for server owners
5. **Developer Friendly** - Clean code, good documentation, easy to extend

---

## 🏗️ System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     CLIENT LAYER                                │
├─────────────────────────────────────────────────────────────────┤
│  • Player Input & Interaction                                   │
│  • NUI Communication (HTML5 Canvas)                             │
│  • Animation & Visual Effects                                   │
│  • Local State Management                                       │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                     SHARED LAYER                                │
├─────────────────────────────────────────────────────────────────┤
│  • Framework Detection & Adapter                                │
│  • Utility Functions                                            │
│  • Configuration                                                │
│  • Localization                                                 │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                     SERVER LAYER                                │
├─────────────────────────────────────────────────────────────────┤
│  • Prize Calculation (RNG)                                      │
│  • Security & Validation                                        │
│  • Economy Integration                                          │
│  • Anti-Abuse Protection                                        │
│  • Database Operations (optional)                               │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                 FRAMEWORK LAYER                                 │
├─────────────────────────────────────────────────────────────────┤
│  LXR-Core | RSG-Core | VORP | RedEM:RP | QBR | Standalone     │
└─────────────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

#### Client Layer (`client/`)
- Handles all player-facing interactions
- Manages NUI (browser UI) communication
- Plays animations and effects
- Reports actions to server for validation

#### Shared Layer (`shared/`)
- Framework detection and adapter pattern
- Shared utility functions
- Configuration management
- Cross-environment code

#### Server Layer (`server/`)
- Authoritative prize calculations
- Security validation
- Economy/inventory integration
- Anti-cheat enforcement

---

## 💡 Design Philosophy

### 1. Server Authority

**All critical operations must be server-side:**
- Prize calculation
- Inventory validation
- Money transactions
- State management

The client is **never trusted** with authoritative data.

### 2. Framework Adapter Pattern

Instead of framework-specific code throughout, we use an **adapter layer**:

```lua
-- ❌ BAD: Framework-specific code everywhere
if Framework == 'lxr-core' then
    Player.AddMoney(amount)
elseif Framework == 'rsg-core' then
    Player.Functions.AddMoney(amount)
-- ... more frameworks
end

-- ✅ GOOD: Unified adapter interface
Framework.AddMoney(source, amount)
```

This keeps core logic clean and maintainable.

### 3. Configuration Over Code

Prefer configuration over hardcoded values:
- All game mechanics configurable
- Easy server-specific customization
- No code changes for most adjustments

### 4. Defense in Depth

Multiple layers of security:
1. Client-side position validation
2. Server-side inventory checks
3. Cooldown enforcement
4. Rate limiting
5. Activity logging

---

## 🧩 Component Overview

### Configuration (`config.lua`)

Central configuration with:
- Resource name protection
- Framework settings
- Economy configuration
- Security settings
- Performance tuning
- Debug options

### Framework Adapter (`shared/framework.lua`)

Provides unified interface:
- Auto-detects active framework
- Maps unified functions to framework-specific implementations
- Handles framework initialization
- Supports 7+ frameworks

### Client Script (`client/client.lua`)

Manages player interaction:
- Item usage triggering
- NUI display and interaction
- Animation playback
- Position tracking

### Server Script (`server/server.lua`)

Handles authoritative operations:
- Prize calculation using RNG
- Security validation
- Cooldown enforcement
- Rate limiting
- Economy integration

### Utilities (`shared/utils.lua`)

Helper functions:
- Localization
- Logging
- Math utilities
- String manipulation

---

## 🔄 Data Flow

### Scratchcard Use Flow

```
[Player Uses Item]
       ↓
[Inventory Opens] → [Player Clicks Scratchcard]
       ↓
[Framework Event: Item Used]
       ↓
[Client: UseScratchcard()] → Stores position
       ↓
[Server: Handle Item Use]
       ↓
[Server: Security Checks]
   • Check cooldown
   • Check rate limit
   • Verify inventory
       ↓
[Server: Remove Item]
       ↓
[Server: Calculate Prize] (RNG)
       ↓
[Server: Store Prize in Session]
       ↓
[Client: Show Scratchcard UI]
   • Enable NUI focus
   • Display scratch interface
   • Play animation
       ↓
[Player Scratches Card]
       ↓
[NUI: Scratch Progress] → Reports to client
       ↓
[Player: Press ESC to Close]
       ↓
[Client: Validate Distance]
       ↓
[Server: Claim Prize]
   • Retrieve stored prize
   • Award money
   • Clear session
   • Notify player
```

---

## 🔒 Security Model

### Threat Model

We protect against:
1. **Client-side prize manipulation** - Never calculated on client
2. **Item duplication** - Server validates inventory
3. **Spam/DOS attacks** - Rate limiting and cooldowns
4. **Teleport exploits** - Distance validation
5. **Session hijacking** - Identifier-based tracking

### Security Layers

#### Layer 1: Client-Side Position Tracking
- Client stores position when card is used
- Validates distance hasn't exceeded threshold
- Reports suspicious movement to server

#### Layer 2: Server-Side Validation
- Verifies player has item before use
- Checks cooldown timer
- Enforces rate limits
- Validates all state changes

#### Layer 3: Session Management
- Per-player session tracking
- Prize stored server-side only
- Session cleared after claim
- Automatic cleanup of stale sessions

#### Layer 4: Logging & Monitoring
- Logs suspicious activity
- Optional Discord webhooks
- Rate limit violation tracking
- Large win notifications

---

## 📊 Performance Characteristics

### Resource Usage

- **Idle:** <5ms per player
- **Active (scratching):** <10ms per player
- **Memory:** ~5-10MB (including UI assets)
- **Network:** Minimal (only essential events)

### Optimization Strategies

1. **Minimal Threads** - No continuous loops
2. **Event-Driven** - React to player actions only
3. **Caching** - Player data cached when needed
4. **Cleanup** - Automatic removal of stale data
5. **Native Functions** - Use native Lua/CFX natives

---

## 🔌 Extensibility

The system is designed for easy extension:

### Adding New Frameworks

1. Add detection logic to `Framework.Detect()`
2. Implement unified function mappings
3. Add configuration to `config.lua`
4. Test thoroughly

### Adding New Features

1. Add configuration options
2. Implement in appropriate layer (client/server/shared)
3. Update documentation
4. Consider security implications

### Custom Hooks

The system supports custom integration hooks:
```lua
Config.Advanced.customHooks = {
    beforeScratch = function(source)
        -- Your code before scratch
    end,
    afterScratch = function(source, prize)
        -- Your code after scratch
    end,
    onWin = function(source, prize)
        -- Your code on win
    end,
}
```

---

## 📚 Related Documentation

- [Installation Guide](installation.md)
- [Configuration Guide](configuration.md)
- [Framework Integration](frameworks.md)
- [Events & API](events.md)
- [Security Guide](security.md)
- [Performance Guide](performance.md)

---

```
🐺 The Land of Wolves - Where History Lives
© 2026 The Lux Empire / iBoss21
```
