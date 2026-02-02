# 🐺 LXR Scratchcard System - Security Guide

```
════════════════════════════════════════════════════════════════════════════════════════════════
SECURITY FEATURES & BEST PRACTICES
════════════════════════════════════════════════════════════════════════════════════════════════
```

## 🔒 Security Overview

LXR Scratchcard System implements **defense-in-depth** security with multiple layers of protection against common exploits and abuse.

---

## 🎯 Security Principles

### 1. Server Authority
**All critical operations are server-side:**
- ✅ Prize calculation (never on client)
- ✅ Inventory validation
- ✅ Money transactions
- ✅ State management
- ✅ Cooldown enforcement

**The client is NEVER trusted** with authoritative data.

### 2. Input Validation
All client inputs are validated:
- Player source verification
- Identifier validation
- Distance/position checks
- State consistency checks

### 3. Rate Limiting
Protection against spam/DOS:
- Per-player action limits
- Configurable time windows
- Automatic violation logging

### 4. Audit Logging
Comprehensive activity tracking:
- Suspicious behavior logs
- Large win notifications
- Rate limit violations
- Discord webhooks (optional)

---

## 🛡️ Security Features

### Layer 1: Client-Side Validation

#### Position Tracking
```lua
-- Client stores position when card is used
ClientState.scratchStartCoords = GetEntityCoords(PlayerPedId())

-- Validates distance on completion
local distance = #(ClientState.scratchStartCoords - currentCoords)
if distance > Config.Security.maxDistance then
    TriggerServerEvent('lxr-scratchcard:server:invalidMovement', distance)
end
```

**Configuration:**
```lua
Config.Security = {
    validateDistance = true,
    maxDistance = 10.0,  -- meters
}
```

**Prevents:**
- Teleport exploits during scratch
- Movement-based duplication

---

### Layer 2: Server-Side Validation

#### Inventory Verification
```lua
-- Verify player has item before use
local removed = RemoveItemFromInventory(source)
if not removed then
    Utils.Error('Failed to remove scratchcard')
    return
end
```

**Prevents:**
- Item duplication
- Using items you don't have
- Inventory desync exploits

---

#### Cooldown System
```lua
-- Check if player on cooldown
local onCooldown, remaining = IsOnCooldown(source)
if onCooldown then
    -- Reject request
    return
end

-- Set cooldown after use
SetCooldown(source)
```

**Configuration:**
```lua
Config.Security = {
    enableCooldown = true,
    cooldownTime = 5,  -- seconds
}
```

**Prevents:**
- Rapid-fire card usage
- Automated farming
- Server spam

---

#### Rate Limiting
```lua
-- Track actions per minute
if not CheckRateLimit(source) then
    LogSuspiciousActivity(source, 'rate_limit_exceeded')
    return
end
```

**Configuration:**
```lua
Config.Security = {
    enableRateLimit = true,
    maxActionsPerMinute = 10,
}
```

**Prevents:**
- DOS attacks
- Automated exploits
- Server overload

---

### Layer 3: Session Management

#### Per-Player State Tracking
```lua
ServerState.scratchData = {
    {user = identifier, stillUsing = false, prize = 0},
    -- ...
}
```

**Features:**
- Prize stored server-side only
- One active scratch per player
- Automatic session cleanup

**Prevents:**
- Session hijacking
- Prize manipulation
- State desync

---

### Layer 4: Logging & Monitoring

#### Suspicious Activity Logging
```lua
function LogSuspiciousActivity(source, reason, details)
    local identifier = Framework.GetIdentifier(source)
    local playerName = GetPlayerName(source) or 'Unknown'
    
    Utils.Error('SUSPICIOUS: Player %s [%s] - %s', 
        playerName, identifier, reason)
end
```

**Logged Events:**
- Rate limit violations
- Invalid movement
- State inconsistencies
- Duplicate requests

---

#### Discord Webhooks (Optional)
```lua
Config.Security = {
    enableWebhook = true,
    webhookURL = 'https://discord.com/api/webhooks/...',
    logWins = true,
    logLargeWins = true,
    largeWinThreshold = 5000,
}
```

**Webhook Notifications:**
- All wins
- Large wins (configurable threshold)
- Suspicious activity
- Rate limit violations

---

## 🚨 Threat Model

### Threats We Protect Against

#### 1. Client-Side Prize Manipulation
**Attack:** Player tries to modify prize value on client.

**Protection:**
- ✅ All prizes calculated server-side
- ✅ Prize stored in server session
- ✅ Client never receives prize before reveal
- ✅ Server validates claim request

**Result:** ❌ Attack fails - client has no control over prize

---

#### 2. Item Duplication
**Attack:** Player tries to use card without having it.

**Protection:**
- ✅ Server verifies inventory before use
- ✅ Item removed before processing
- ✅ Transaction logged
- ✅ Framework integration ensures consistency

**Result:** ❌ Attack fails - no item, no scratch

---

#### 3. Teleport Exploit
**Attack:** Player uses card, teleports away, uses again.

**Protection:**
- ✅ Client stores start position
- ✅ Distance validated on completion
- ✅ Suspicious movement logged
- ✅ Session invalidated on violation

**Result:** ❌ Attack detected and logged

---

#### 4. Spam/DOS Attack
**Attack:** Player spams card usage rapidly.

**Protection:**
- ✅ Per-player cooldowns
- ✅ Rate limiting (actions per minute)
- ✅ Automatic rejection
- ✅ Violation logging

**Result:** ❌ Attack blocked after threshold

---

#### 5. Session Hijacking
**Attack:** Player tries to claim another player's prize.

**Protection:**
- ✅ Identifier-based session tracking
- ✅ Source validation on claim
- ✅ Session cleared after claim
- ✅ No cross-player access

**Result:** ❌ Attack fails - wrong identifier

---

## 🔧 Security Configuration

### Recommended Production Settings

```lua
Config.Security = {
    -- Inventory Validation
    validateInventory = true,
    
    -- Position Validation
    validateDistance = true,
    maxDistance = 10.0,
    
    -- Cooldown System
    enableCooldown = true,
    cooldownTime = 5,  -- 5 seconds minimum
    
    -- Rate Limiting
    enableRateLimit = true,
    maxActionsPerMinute = 10,
    
    -- Exploit Prevention
    preventDuplication = true,
    logSuspicious = true,
    
    -- Webhook Logging
    enableWebhook = true,  -- If you have Discord
    webhookURL = 'YOUR_WEBHOOK_URL',
    logWins = false,  -- Only log large wins
    logLargeWins = true,
    largeWinThreshold = 5000,
}
```

### Development/Testing Settings

```lua
Config.Security = {
    validateInventory = true,  -- Keep enabled
    validateDistance = false,  -- Disable for testing
    enableCooldown = false,    -- Disable for rapid testing
    enableRateLimit = false,   -- Disable for testing
    preventDuplication = true,
    logSuspicious = true,      -- Keep enabled to see logs
    enableWebhook = false,     -- Disable in dev
}

Config.Debug = {
    enabled = true,
    printEvents = true,
    printPrizes = true,
}
```

---

## 🔍 Monitoring & Detection

### What to Monitor

1. **Console Logs**
   - Error messages
   - Suspicious activity warnings
   - Rate limit violations

2. **Discord Webhooks**
   - Large wins
   - Rapid prize claims
   - Multiple violations from same player

3. **Performance**
   - Resource usage spikes
   - Unusual player counts
   - Memory leaks

### Red Flags

🚩 **High Priority:**
- Same player hitting rate limits repeatedly
- Multiple "invalid movement" logs
- Prize claims without corresponding usage
- Inventory errors for specific players

🚩 **Medium Priority:**
- Unusual win patterns
- Very rapid scratching
- Many small wins in succession

🚩 **Low Priority:**
- Occasional cooldown messages
- Single distance violations
- Normal usage patterns

---

## 🛠️ Hardening Recommendations

### 1. Enable All Security Features
```lua
Config.Security = {
    validateInventory = true,
    validateDistance = true,
    enableCooldown = true,
    enableRateLimit = true,
    preventDuplication = true,
    logSuspicious = true,
}
```

### 2. Adjust Cooldown for Your Server
```lua
-- High population server
cooldownTime = 10,  -- 10 seconds

-- Medium population
cooldownTime = 5,   -- 5 seconds

-- Low population/RP server
cooldownTime = 2,   -- 2 seconds
```

### 3. Configure Rate Limits
```lua
-- Strict (recommended)
maxActionsPerMinute = 6,  -- 1 every 10 seconds

-- Moderate
maxActionsPerMinute = 10,

-- Relaxed (not recommended)
maxActionsPerMinute = 20,
```

### 4. Set Appropriate Prize Ranges
```lua
-- Prevent economic inflation
Config.Economy = {
    prizes = {
        min = 0,
        max = 5000,  -- Not too high
    },
    winChance = 20,  -- Not too generous
}
```

### 5. Enable Webhook Logging
```lua
Config.Security = {
    enableWebhook = true,
    webhookURL = 'YOUR_SECURE_WEBHOOK',
    logLargeWins = true,
    largeWinThreshold = 2500,  -- Adjust for your economy
}
```

---

## 🔐 Best Practices

### For Server Owners

1. ✅ **Keep security features enabled** in production
2. ✅ **Monitor logs regularly** for suspicious activity
3. ✅ **Adjust thresholds** based on your server population
4. ✅ **Test updates** in development environment first
5. ✅ **Use Discord webhooks** for real-time alerts
6. ✅ **Review win patterns** periodically
7. ✅ **Update regularly** to get security patches

### For Developers

1. ✅ **Never trust client data**
2. ✅ **Validate all inputs** server-side
3. ✅ **Use framework functions** for inventory/money
4. ✅ **Log security events** appropriately
5. ✅ **Test with malicious mindset**
6. ✅ **Follow secure coding practices**
7. ✅ **Document security features**

---

## 🚫 Common Pitfalls

### ❌ DON'T Do This:

```lua
-- BAD: Trusting client-provided prize
RegisterServerEvent('scratchcard:claim')
AddEventHandler('scratchcard:claim', function(prize)
    -- Client could send any amount!
    Framework.AddMoney(source, prize)
end)
```

### ✅ DO This Instead:

```lua
-- GOOD: Server calculates and stores prize
RegisterServerEvent('scratchcard:claim')
AddEventHandler('scratchcard:claim', function()
    local identifier = Framework.GetIdentifier(source)
    local prize = GetStoredPrize(identifier)  -- Server-side storage
    if prize > 0 then
        Framework.AddMoney(source, prize)
    end
end)
```

---

## 📊 Security Audit Checklist

Before deploying to production:

- [ ] All security features enabled in config
- [ ] Cooldown time appropriate for server
- [ ] Rate limits configured
- [ ] Prize ranges reasonable for economy
- [ ] Distance validation enabled
- [ ] Suspicious activity logging enabled
- [ ] Webhook configured (if using)
- [ ] Debug mode disabled
- [ ] Test mode disabled
- [ ] Resource name matches exactly
- [ ] No hardcoded admin bypasses
- [ ] Framework integration tested
- [ ] Console logs reviewed
- [ ] No client-side prize calculation
- [ ] All inputs validated server-side

---

## 📚 Related Documentation

- [Overview](overview.md) - System architecture
- [Configuration Guide](configuration.md) - All config options
- [Events & API](events.md) - API documentation

---

```
🐺 The Land of Wolves - Where History Lives
© 2026 The Lux Empire / iBoss21
```
