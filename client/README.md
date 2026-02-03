# 🐺 LXR Scratchcard - Client Scripts

```
════════════════════════════════════════════════════════════════════════════════════════════════
CLIENT-SIDE SCRIPTS
════════════════════════════════════════════════════════════════════════════════════════════════
```

## 📂 Purpose

This folder contains all **client-side scripts** for the LXR Scratchcard System.

### Scope

- Player interaction and input handling
- NUI (UI) communication and display
- Animation and visual effects
- Framework adapter integration (client-side)
- Local state management

### Files

- `client.lua` - Main client-side logic and event handlers

---

## 🔧 Responsibilities

### UI Management
- Opening and closing the scratchcard interface
- Handling NUI focus and input
- Communicating scratch progress to server

### Player Interaction
- Detecting scratchcard usage
- Playing animations
- Providing visual/audio feedback

### Framework Integration
- Using the unified Framework adapter for notifications
- Closing inventory through framework-specific events
- Handling framework-specific player load events

---

## 📡 Key Events

### Received Events (Server → Client)
- `lxr-scratchcard:client:showCard` - Display scratchcard UI with prize
- `lxr-scratchcard:client:notify` - Show notification to player
- `lxr-scratchcard:client:closeInventory` - Close player inventory

### Sent Events (Client → Server)
- `lxr-scratchcard:server:useCard` - Request to use scratchcard
- `lxr-scratchcard:server:claimPrize` - Claim revealed prize
- `lxr-scratchcard:server:invalidMovement` - Report suspicious movement

---

## 🛡️ Security Considerations

Client scripts must:
- Never calculate prizes (server-side only)
- Validate player position for exploits
- Report suspicious behavior to server
- Trust server for all authoritative data

---

```
🐺 The Land of Wolves - Where History Lives
© 2026 The Lux Empire / iBoss21
```
