# 🐺 LXR Scratchcard - Server Scripts

```
════════════════════════════════════════════════════════════════════════════════════════════════
SERVER-SIDE SCRIPTS
════════════════════════════════════════════════════════════════════════════════════════════════
```

## 📂 Purpose

This folder contains all **server-side scripts** for the LXR Scratchcard System.

### Scope

- Prize calculation and awarding
- Server-side validation and security
- Anti-abuse protection (cooldowns, rate limits)
- Framework integration (server-side)
- Database operations (optional)
- Player state management

### Files

- `server.lua` - Main server-side logic, validation, and economy integration

---

## 🔧 Responsibilities

### Security & Validation
- Verify player inventory before use
- Calculate prizes server-side (never trust client)
- Enforce cooldowns and rate limits
- Validate player distance/position
- Log suspicious activity

### Economy Integration
- Award prizes through framework systems
- Remove items from inventory
- Handle monetary transactions
- Track player balances

### Framework Integration
- Register useable items with framework
- Get player data through framework adapters
- Handle framework-specific events
- Support multiple frameworks simultaneously

### State Management
- Track active scratch sessions
- Manage per-player cooldowns
- Store rate limit data
- Clean up stale data periodically

---

## 📡 Key Events

### Received Events (Client → Server)
- `lxr-scratchcard:server:useCard` - Player used scratchcard item
- `lxr-scratchcard:server:claimPrize` - Player claimed their prize
- `lxr-scratchcard:server:invalidMovement` - Client detected suspicious movement

### Sent Events (Server → Client)
- `lxr-scratchcard:client:showCard` - Send prize and show UI
- `lxr-scratchcard:client:notify` - Send notification to player
- `lxr-scratchcard:client:closeInventory` - Tell client to close inventory

---

## 🛡️ Security Features

- ✅ Server-authoritative prize calculation
- ✅ Per-player cooldown enforcement
- ✅ Rate limiting (max actions per minute)
- ✅ Distance/position validation
- ✅ Inventory verification
- ✅ Suspicious activity logging
- ✅ Discord webhook integration (optional)

---

## 🔌 Framework Handlers

The server registers item usage handlers for:
- **LXR-Core** - `CreateUseableItem()`
- **RSG-Core** - `CreateUseableItem()`
- **VORP** - `registerUsableItem()`
- **RedEM:RP** - Event-based registration
- **QBR/QR** - `CreateUseableItem()`

---

```
🐺 The Land of Wolves - Where History Lives
© 2026 The Lux Empire / iBoss21
```
