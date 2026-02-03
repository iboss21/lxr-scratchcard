# 🐺 LXR Scratchcard System - Performance Guide

```
════════════════════════════════════════════════════════════════════════════════════════════════
PERFORMANCE OPTIMIZATION & MONITORING
════════════════════════════════════════════════════════════════════════════════════════════════
```

## 📊 Performance Targets

| Metric | Target | Acceptable | Critical |
|--------|--------|------------|----------|
| **Idle (per player)** | <3ms | <5ms | >10ms |
| **Active (scratching)** | <8ms | <10ms | >20ms |
| **Memory Usage** | <8MB | <10MB | >20MB |
| **Network (per use)** | <2KB | <5KB | >10KB |

---

## ⚡ Optimization Features

### 1. Event-Driven Architecture
**No continuous loops or threads running idle.**

✅ **What We Do:**
- React to player actions only
- No `while true do` loops
- Minimal thread creation
- Event-based state changes

❌ **What We Avoid:**
- Constant coordinate checks
- Continuous distance calculations
- Idle resource consumption

---

### 2. Minimal Network Traffic

**Only essential events are transmitted.**

**Client → Server:**
- Item use request
- Prize claim request
- Invalid movement report (rare)

**Server → Client:**
- Prize reveal (once per use)
- Notification (as needed)
- UI display command

**Total:** ~1-3 events per scratch

---

### 3. Efficient State Management

**Smart caching and cleanup:**

```lua
-- Automatic cleanup thread
if Config.Performance.enableCaching then
    Citizen.CreateThread(function()
        while true do
            Wait(Config.Performance.cleanupInterval * 1000)
            CleanupStaleData()
        end
    end)
end
```

**Configuration:**
```lua
Config.Performance = {
    enableCaching = true,
    cacheTimeout = 300,      -- 5 minutes
    cleanupInterval = 600,   -- 10 minutes
}
```

---

### 4. Native Function Usage

**Prefer native Lua/CFX functions:**

✅ **Optimized:**
```lua
local coords = GetEntityCoords(playerPed)
local distance = #(coords1 - coords2)
```

❌ **Avoid:**
```lua
-- Manual math calculations when natives exist
local distance = math.sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
```

---

## 🔧 Performance Configuration

### Optimal Settings

```lua
Config.Performance = {
    -- Memory Management
    enableCaching = true,
    cacheTimeout = 300,         -- 5 minutes
    cleanupInterval = 600,      -- 10 minutes
    
    -- Resource Optimization
    useNatives = true,
    minimizeThreads = true,
    
    -- UI Performance
    uiUpdateRate = 50,          -- 20 FPS (sufficient for scratch)
}
```

### High-Performance Server

```lua
-- For servers with 100+ players
Config.Performance = {
    enableCaching = true,
    cacheTimeout = 180,         -- 3 minutes (aggressive)
    cleanupInterval = 300,      -- 5 minutes (frequent)
    uiUpdateRate = 100,         -- 10 FPS (lower UI demand)
}
```

### Low-Population Server

```lua
-- For servers with <32 players
Config.Performance = {
    enableCaching = true,
    cacheTimeout = 600,         -- 10 minutes
    cleanupInterval = 900,      -- 15 minutes
    uiUpdateRate = 33,          -- 30 FPS (smoother UI)
}
```

---

## 📈 Monitoring Performance

### 1. TxAdmin Resource Monitor

Access: `http://your-server-ip:40120/resources`

**What to Check:**
- **Thread Time:** Should be 0.00ms when idle
- **Memory:** Should be stable (5-10MB)
- **Spikes:** Temporary spikes during use are normal

**Healthy Example:**
```
lxr-scratchcard
├─ Threads: 0.00ms
├─ Memory: 7.2MB
└─ Status: ✅ Running
```

---

### 2. In-Game Performance

**Client Console (F8):**
```lua
-- Check resource status
resmon

-- Look for lxr-scratchcard entry
-- Should show low CPU usage (<0.5%)
```

**Server Console:**
```bash
# Monitor resource
monitor lxr-scratchcard

# Should show:
# - Low thread count
# - Stable memory
# - No errors
```

---

### 3. Performance Testing

**Test Script:**
```lua
-- Server console
RegisterCommand('testperf', function()
    local startTime = GetGameTimer()
    
    -- Simulate 100 prize calculations
    for i = 1, 100 do
        local prize = CalculatePrize()
    end
    
    local endTime = GetGameTimer()
    local totalTime = endTime - startTime
    
    print(string.format('100 calculations: %dms (avg: %.2fms)', 
        totalTime, totalTime / 100))
end, true)
```

**Expected Results:**
- Total: <50ms
- Average: <0.5ms per calculation

---

## 🚀 Optimization Tips

### 1. Reduce UI Update Rate

**For lower-end clients:**
```lua
Config.Performance = {
    uiUpdateRate = 100,  -- 10 FPS instead of 20 FPS
}
```

**Impact:**
- ✅ Lower client CPU usage
- ✅ Better performance on old PCs
- ⚠️ Slightly less smooth scratch animation

---

### 2. Aggressive Cache Cleanup

**For high-traffic servers:**
```lua
Config.Performance = {
    cacheTimeout = 180,      -- 3 minutes
    cleanupInterval = 300,   -- 5 minutes
}
```

**Impact:**
- ✅ Lower memory usage
- ✅ Better for many players
- ⚠️ Slightly more frequent cleanup

---

### 3. Disable Debug Logging

**In production:**
```lua
Config.Debug = {
    enabled = false,
    printEvents = false,
    printFramework = false,  -- Or true for startup only
    printPrizes = false,
    verboseLogging = false,
}
```

**Impact:**
- ✅ Reduced console spam
- ✅ Better server performance
- ✅ Cleaner logs

---

### 4. Optimize Cooldowns

**Balance security vs performance:**
```lua
-- Strict (more checks)
Config.Security = {
    enableCooldown = true,
    cooldownTime = 2,  -- Frequent checks
}

-- Relaxed (fewer checks)
Config.Security = {
    enableCooldown = true,
    cooldownTime = 10,  -- Less frequent checks
}
```

---

## 🔍 Troubleshooting Performance Issues

### High Thread Time

**Symptom:** TxAdmin shows >1ms constant

**Possible Causes:**
1. Debug logging enabled
2. Too many active scratch sessions
3. Memory leak from stale data
4. Framework integration issue

**Solutions:**
```lua
-- 1. Disable debug
Config.Debug.enabled = false

-- 2. Enable aggressive cleanup
Config.Performance.cleanupInterval = 300

-- 3. Check framework integration
Config.Debug.printFramework = true
```

---

### High Memory Usage

**Symptom:** Memory grows over time (>20MB)

**Possible Causes:**
1. Cleanup disabled
2. Too many cached sessions
3. NUI assets not optimized

**Solutions:**
```lua
-- Enable cleanup
Config.Performance.enableCaching = true
Config.Performance.cleanupInterval = 300

-- Reduce cache timeout
Config.Performance.cacheTimeout = 180
```

---

### Client FPS Drops

**Symptom:** FPS drops when scratching

**Possible Causes:**
1. High UI update rate
2. Complex scratch animation
3. Too many NUI elements

**Solutions:**
```lua
-- Reduce UI update rate
Config.Performance.uiUpdateRate = 100  -- 10 FPS

-- Disable animation
Config.General.useAnimation = false
```

---

### Network Lag

**Symptom:** Delay between action and response

**Possible Causes:**
1. Too many events
2. Large data payloads
3. Server overload

**Solutions:**
- Check server tick rate
- Review event frequency
- Ensure only essential data sent

---

## 📊 Performance Benchmarks

### Expected Performance by Server Size

| Players | Idle (ms) | Active (ms) | Memory (MB) |
|---------|-----------|-------------|-------------|
| 1-16    | 0.00-0.01 | 0.01-0.05   | 5-7         |
| 17-32   | 0.01-0.02 | 0.05-0.10   | 7-9         |
| 33-64   | 0.02-0.03 | 0.10-0.20   | 9-12        |
| 65-128  | 0.03-0.05 | 0.20-0.50   | 12-15       |

### Test Environment

- **Server:** Ubuntu 20.04, 4 cores, 8GB RAM
- **Framework:** LXR-Core
- **Other Resources:** ~30 active
- **Config:** Default settings

---

## ⚙️ Advanced Optimization

### 1. Database Integration

**Only if needed:**
```lua
Config.Advanced = {
    useDatabase = false,  -- Keep disabled unless necessary
}
```

**Impact:**
- Database queries add latency
- Not needed for core functionality
- Only enable for persistent history

---

### 2. Statistics Tracking

**Disable if not used:**
```lua
Config.Advanced = {
    trackStats = false,  -- Disable unless monitoring
}
```

**Impact:**
- Saves processing time
- Reduces memory usage
- No historical data loss if not tracked

---

### 3. Webhook Optimization

**Batch notifications:**
```lua
-- Instead of sending every win
Config.Security = {
    logWins = false,        -- Don't log all wins
    logLargeWins = true,    -- Only log large wins
    largeWinThreshold = 5000,
}
```

**Impact:**
- Fewer webhook calls
- Reduced network usage
- Better Discord rate limits

---

## 🎯 Performance Checklist

Before deployment:

- [ ] Debug mode disabled
- [ ] Verbose logging disabled
- [ ] Cache cleanup enabled
- [ ] Appropriate cleanup intervals
- [ ] UI update rate configured
- [ ] Unnecessary features disabled
- [ ] TxAdmin monitoring checked
- [ ] No memory leaks detected
- [ ] Thread time < 0.05ms idle
- [ ] Network usage minimal

---

## 📚 Related Documentation

- [Configuration Guide](configuration.md) - Performance config
- [Security Guide](security.md) - Security vs performance
- [Installation Guide](installation.md) - Setup optimization

---

```
🐺 The Land of Wolves - Where History Lives
© 2026 The Lux Empire / iBoss21
```
