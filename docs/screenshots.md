# 🐺 LXR Scratchcard System - Screenshots Documentation

```
════════════════════════════════════════════════════════════════════════════════════════════════
SCREENSHOTS & VISUAL DOCUMENTATION
════════════════════════════════════════════════════════════════════════════════════════════════
```

## 📸 Screenshot Requirements

All production deployments of LXR Scratchcard System should include visual documentation to aid in:
- Troubleshooting and support
- Configuration verification
- Performance monitoring
- Feature demonstration

---

## 📂 Storage Location

Screenshots should be stored in:
```
docs/assets/screenshots/
```

### Required Screenshots

#### 1. Startup Console (`01_startup_console.png`)

**What to Capture:**
- Server console during resource startup
- Boot banner with wolf ASCII art
- Framework detection message
- Configuration summary
- No errors present

**When to Take:**
- After fresh server start
- After resource restart
- When verifying installation

**Requirements:**
- Full console window
- Clear, readable text
- Shows resource name
- Shows framework detected

---

#### 2. Configuration Sections (`02_config_sections.png`)

**What to Capture:**
- config.lua file open in editor
- Key configuration sections visible
- ASCII headers and banners
- Resource name protection
- Framework settings

**When to Take:**
- After initial configuration
- When documenting custom settings
- For support/troubleshooting

**Requirements:**
- Syntax highlighting enabled
- Multiple sections visible
- Clear code formatting
- No sensitive data (webhooks, etc.)

---

#### 3. UI Interaction (`03_ui_interaction.png`)

**What to Capture:**
- In-game scratchcard UI open
- Player scratch progress visible
- Prize amount (can be blurred if needed)
- Clean UI rendering
- No visual glitches

**When to Take:**
- During active scratchcard use
- Multiple stages if possible (before/during/after scratch)

**Requirements:**
- High resolution (1920x1080 minimum)
- UI centered in frame
- Clear visibility of scratch mechanics
- No HUD clutter (hide if possible)

**Recommended Settings:**
```
/hidehud
F12 or screenshot key
```

---

#### 4. Framework Detection (`04_framework_detection.png`)

**What to Capture:**
- Console output showing framework detection
- Framework name identified
- Framework object obtained (if applicable)
- Adapter initialization messages
- Any framework-specific events

**When to Take:**
- After confirming framework integration
- When testing framework switching
- For multi-framework documentation

**Requirements:**
- Shows detection log messages
- Framework name clearly visible
- No errors in framework loading

---

#### 5. Discord Logs (`05_discord_logs.png`)
*(Optional - if webhook enabled)*

**What to Capture:**
- Discord channel with scratchcard logs
- Win notifications
- Large win alerts
- Suspicious activity logs (if any)
- Formatted embed messages

**When to Take:**
- After enabling webhook logging
- When documenting notification features
- For security/monitoring examples

**Requirements:**
- Clean Discord interface
- Multiple log entries visible
- Embeds properly formatted
- Player names can be anonymized

---

#### 6. TxAdmin Performance (`06_txadmin_performance.png`)

**What to Capture:**
- TxAdmin resource monitor
- lxr-scratchcard performance metrics
- Memory usage
- Thread time (ms)
- Relative to other resources

**When to Take:**
- During normal server operation
- With players actively using cards
- After performance optimization

**Requirements:**
- Full resource list visible
- lxr-scratchcard highlighted or visible
- Multiple samples (not just startup)
- Comparison to similar resources

**Command to access:**
```
http://your-server-ip:40120
Resources → Resource Monitor
```

---

## 📋 Screenshot Checklist

Before submitting documentation:

- [ ] All 6 required screenshots present
- [ ] Screenshots in correct folder (`docs/assets/screenshots/`)
- [ ] Filenames match requirements
- [ ] High resolution (1920x1080+)
- [ ] No sensitive data visible (API keys, webhooks, IPs)
- [ ] Clear, readable text
- [ ] No watermarks or overlays (unless branding)
- [ ] PNG format preferred (JPG acceptable)

---

## 🎨 Screenshot Guidelines

### Resolution
- **Minimum:** 1920x1080 (1080p)
- **Recommended:** 2560x1440 (1440p)
- **Maximum:** 3840x2160 (4K)

### Format
- **Preferred:** PNG (lossless)
- **Acceptable:** JPG (high quality, 90%+)
- **Avoid:** Compressed/low-quality images

### Composition
- Center subject in frame
- Remove unnecessary clutter
- Ensure good contrast
- Use dark theme for code/console
- Maintain aspect ratio

### Privacy
- Anonymize player names if needed
- Remove IP addresses
- Hide API keys/tokens
- Blur sensitive configuration
- Remove admin/staff names

---

## 🖼️ Example Screenshot Workflow

### For In-Game Screenshots

1. **Prepare Scene**
   ```
   /hidehud
   Position camera
   ```

2. **Capture**
   ```
   F12 (Steam)
   Print Screen
   OBS/Shadowplay
   ```

3. **Edit** (Optional)
   - Crop unnecessary areas
   - Add annotations
   - Blur sensitive data
   - Enhance contrast

4. **Save**
   ```
   Format: PNG
   Location: docs/assets/screenshots/
   Name: 03_ui_interaction.png
   ```

### For Console Screenshots

1. **Trigger Action**
   ```
   restart lxr-scratchcard
   or
   /giveitem scratchcard 1
   ```

2. **Capture Console**
   ```
   Snipping Tool (Windows)
   Shift+Cmd+4 (Mac)
   Flameshot (Linux)
   ```

3. **Save**
   ```
   Format: PNG
   Location: docs/assets/screenshots/
   Name: 01_startup_console.png
   ```

---

## 📊 Performance Screenshot Guide

### TxAdmin Resource Monitor

1. **Access TxAdmin**
   ```
   http://your-server-ip:40120
   Login with credentials
   ```

2. **Navigate to Resources**
   ```
   Resources → Resource Monitor
   ```

3. **Wait for Stable Metrics**
   - Let server run for 5+ minutes
   - Ensure players are active
   - Multiple lxr-scratchcard uses

4. **Capture**
   - Full browser window
   - Sort by time or memory
   - Highlight lxr-scratchcard
   - Show relative performance

5. **Annotate** (Optional)
   - Circle or highlight resource
   - Add performance notes
   - Compare to benchmarks

---

## 🔍 Verification Screenshots

### What Makes a Good Screenshot?

✅ **Good Screenshot:**
- Clear, high resolution
- Relevant content visible
- No errors or issues
- Properly formatted
- Anonymized if needed

❌ **Bad Screenshot:**
- Blurry or low resolution
- Irrelevant content
- Errors/bugs visible
- Sensitive data exposed
- Poorly cropped

---

## 📝 Screenshot Annotations

### Recommended Tools

- **Windows:** Paint, Snip & Sketch, ShareX
- **Mac:** Preview, Skitch
- **Linux:** GIMP, Shutter, Flameshot
- **Cross-Platform:** Greenshot, LightShot

### Annotation Guidelines

- Use red boxes/circles for highlights
- Add arrows for flow
- Include text labels sparingly
- Keep annotations minimal
- Ensure contrast with background

---

## 🌐 Sharing Screenshots

### For Support

When requesting help:
1. Include relevant screenshot(s)
2. Describe the issue
3. Provide context
4. Show error messages
5. Include configuration

### For Documentation

When contributing:
1. Follow naming convention
2. Place in correct folder
3. Maintain high quality
4. Add to README if needed
5. Update documentation links

---

## 📚 Related Documentation

- [Installation Guide](installation.md)
- [Configuration Guide](configuration.md)
- [Performance Guide](performance.md)
- [Security Guide](security.md)

---

## 🎯 Screenshot Status

Track your screenshot completion:

```
docs/assets/screenshots/
├── [ ] 01_startup_console.png
├── [ ] 02_config_sections.png
├── [ ] 03_ui_interaction.png
├── [ ] 04_framework_detection.png
├── [ ] 05_discord_logs.png (optional)
└── [ ] 06_txadmin_performance.png
```

---

```
🐺 The Land of Wolves - Where History Lives
© 2026 The Lux Empire / iBoss21
```
