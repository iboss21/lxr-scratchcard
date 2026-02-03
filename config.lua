--[[
════════════════════════════════════════════════════════════════════════════════════════════════
  ██╗  ██╗██████╗     ███████╗ ██████╗██████╗  █████╗ ████████╗ ██████╗██╗  ██╗ ██████╗ █████╗ ██████╗ ██████╗ 
  ██║  ██║██╔══██╗    ██╔════╝██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║  ██║██╔════╝██╔══██╗██╔══██╗██╔══██╗
  ██║  ██║██████╔╝    ███████╗██║     ██████╔╝███████║   ██║   ██║     ███████║██║     ███████║██████╔╝██║  ██║
  ██║  ██║██╔══██╗    ╚════██║██║     ██╔══██╗██╔══██║   ██║   ██║     ██╔══██║██║     ██╔══██║██╔══██╗██║  ██║
  ███████║██║  ██║    ███████║╚██████╗██║  ██║██║  ██║   ██║   ╚██████╗██║  ██║╚██████╗██║  ██║██║  ██║██████╔╝
  ╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ 
════════════════════════════════════════════════════════════════════════════════════════════════

    🐺 LXR Scratchcard System - Configuration
    
    A multi-framework scratchcard/lottery system for RedM with secure server-side validation,
    anti-abuse protection, and comprehensive framework support. Players can purchase and scratch
    lottery cards for a chance to win prizes with configurable odds and rewards.
    
    ════════════════════════════════════════════════════════════════════════════════════════════
    🏛️ SERVER INFORMATION
    ════════════════════════════════════════════════════════════════════════════════════════════
    Server:     The Land of Wolves 🐺 (Georgian RP 🇬🇪)
    Tagline:    მგლების მიწა - რჩეულთა ადგილი! (The Land of the Chosen!)
    Type:       Serious Hardcore Roleplay
    Website:    https://www.wolves.land
    Discord:    https://discord.gg/CrKcWdfd3A
    Store:      https://theluxempire.tebex.io
    Developer:  iBoss21 / The Lux Empire
    GitHub:     https://github.com/iBoss21
    
    ════════════════════════════════════════════════════════════════════════════════════════════
    📦 RESOURCE INFORMATION
    ════════════════════════════════════════════════════════════════════════════════════════════
    Version:    2.0.0 (Land of Wolves Edition)
    Author:     iBoss21 / The Lux Empire
    Target:     <5ms idle / <10ms active per player
    Category:   Economy, Casino, Mini-Games
    
    ════════════════════════════════════════════════════════════════════════════════════════════
    🔧 FRAMEWORK SUPPORT
    ════════════════════════════════════════════════════════════════════════════════════════════
    Primary Frameworks (Full Support):
        • LXR-Core         (Priority 1 - Native Integration)
        • RSG-Core         (Priority 2 - Full Compatibility)
    
    Supported Frameworks (Legacy):
        • VORP Core        (Maintained for backwards compatibility)
        • RedEM:RP         (Original framework support)
    
    Optional Frameworks (If Detected):
        • QBR-Core         (Limited support)
        • QR-Core          (Limited support)
        • Standalone       (Basic functionality)
    
    ════════════════════════════════════════════════════════════════════════════════════════════
    👥 CREDITS & ATTRIBUTION
    ════════════════════════════════════════════════════════════════════════════════════════════
    Original Concept:   flux_scratchcard by xFluXioN
    Original Version:   qadr_scratchcard
    Transformed by:     iBoss21 for The Land of Wolves 🐺
    License:            All Rights Reserved - The Lux Empire
    
    ════════════════════════════════════════════════════════════════════════════════════════════
    © 2026 The Lux Empire / iBoss21 - All Rights Reserved
    https://www.wolves.land | https://github.com/iBoss21
    ════════════════════════════════════════════════════════════════════════════════════════════
]]

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ RESOURCE NAME PROTECTION (MANDATORY - DO NOT MODIFY)
-- ════════════════════════════════════════════════════════════════════════════════════════════

local REQUIRED_RESOURCE_NAME = "lxr-scratchcard"
local CURRENT_RESOURCE_NAME = GetCurrentResourceName()

if CURRENT_RESOURCE_NAME ~= REQUIRED_RESOURCE_NAME then
    error(([[

        ╔═══════════════════════════════════════════════════════════════════════════════════╗
        ║                                                                                   ║
        ║   🐺 LXR SCRATCHCARD - RESOURCE NAME MISMATCH ERROR                              ║
        ║                                                                                   ║
        ║   The resource folder name MUST match the expected name exactly.                 ║
        ║                                                                                   ║
        ║   Expected: %s                                                                    ║
        ║   Got:      %s                                                                    ║
        ║                                                                                   ║
        ║   ⚠️  ACTION REQUIRED:                                                            ║
        ║   Rename the resource folder to: %s                                              ║
        ║   Then restart the server.                                                       ║
        ║                                                                                   ║
        ║   This protection ensures proper functionality and prevents conflicts.           ║
        ║                                                                                   ║
        ╚═══════════════════════════════════════════════════════════════════════════════════╝

    ]]):format(REQUIRED_RESOURCE_NAME, CURRENT_RESOURCE_NAME, REQUIRED_RESOURCE_NAME))
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ MAIN CONFIGURATION TABLE
-- ════════════════════════════════════════════════════════════════════════════════════════════

Config = {}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ SERVER INFORMATION (CANONICAL - LAND OF WOLVES)
-- ════════════════════════════════════════════════════════════════════════════════════════════

Config.ServerInfo = {
    name          = 'The Land of Wolves 🐺',
    tagline       = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description   = 'ისტორია ცოცხლდება აქ!', -- History Lives Here!
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

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ FRAMEWORK CONFIGURATION (AUTO-DETECTION)
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    Framework Priority (Detection Order):
    1. LXR-Core      (Primary - wolves.land native framework)
    2. RSG-Core      (Primary - full compatibility target)
    3. VORP Core     (Supported - legacy/community servers)
    4. RedEM:RP      (Supported - original implementation)
    5. QBR-Core      (Optional - if detected)
    6. QR-Core       (Optional - if detected)
    7. Standalone    (Fallback - basic functionality)
    
    Set to 'auto' for automatic detection, or manually specify:
    'lxr-core', 'rsg-core', 'vorp', 'redemrp', 'qbr', 'qr', 'standalone'
]]

Config.Framework = 'auto'

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ FRAMEWORK SETTINGS (PER-FRAMEWORK CONFIGURATION)
-- ════════════════════════════════════════════════════════════════════════════════════════════

Config.FrameworkSettings = {
    
    -- LXR-Core Configuration (Primary Framework)
    ['lxr-core'] = {
        resourceName = 'lxr-core',
        
        -- Event naming convention for LXR-Core
        events = {
            -- Client Events
            playerLoaded    = 'lxr-core:client:player:loaded',
            notify          = 'lxr-core:client:notify',
            
            -- Server Events
            playerReady     = 'lxr-core:server:player:ready',
            
            -- Callbacks
            getPlayer       = 'lxr-core:callback:player:get',
            addMoney        = 'lxr-core:callback:player:addmoney',
            removeMoney     = 'lxr-core:callback:player:removemoney',
            removeItem      = 'lxr-core:callback:inventory:removeitem',
            hasItem         = 'lxr-core:callback:inventory:hasitem',
        },
        
        -- Inventory Configuration
        inventory = {
            resource = 'lxr-inventory',
            closeEvent = 'lxr-inventory:client:close',
        },
        
        -- Item name for scratchcard
        itemName = 'scratchcard',
    },
    
    -- RSG-Core Configuration (Primary Framework)
    ['rsg-core'] = {
        resourceName = 'rsg-core',
        
        events = {
            -- Client Events
            playerLoaded    = 'RSGCore:Client:OnPlayerLoaded',
            notify          = 'RSGCore:Client:Notify',
            
            -- Server Events  
            playerReady     = 'RSGCore:Server:OnPlayerLoaded',
            
            -- Callbacks
            getPlayer       = 'RSGCore:GetPlayer',
        },
        
        inventory = {
            resource = 'rsg-inventory',
            closeEvent = 'rsg-inventory:client:closeInventory',
        },
        
        itemName = 'scratchcard',
    },
    
    -- VORP Core Configuration (Supported Framework)
    ['vorp'] = {
        resourceName = 'vorp_core',
        
        events = {
            playerLoaded    = 'vorp:SelectedCharacter',
            notify          = 'vorp:TipRight',
        },
        
        inventory = {
            resource = 'vorp_inventory',
            closeEvent = 'vorp_inventory:CloseInv',
        },
        
        itemName = 'scratchcard',
    },
    
    -- RedEM:RP Configuration (Original Framework)
    ['redemrp'] = {
        resourceName = 'redemrp_core',
        
        events = {
            playerLoaded    = 'redemrp:playerLoaded',
            notify          = 'redem_roleplay:Tip',
        },
        
        inventory = {
            resource = 'redemrp_inventory',
            closeEvent = 'redemrp_inventory:closeinv',
        },
        
        itemName = 'scratchcard',
    },
    
    -- QBR-Core Configuration (Optional)
    ['qbr'] = {
        resourceName = 'qbr-core',
        events = {
            playerLoaded    = 'QBRCore:Client:OnPlayerLoaded',
            notify          = 'QBRCore:Client:Notify',
        },
        inventory = {
            resource = 'qbr-inventory',
            closeEvent = 'qbr-inventory:client:closeInventory',
        },
        itemName = 'scratchcard',
    },
    
    -- Standalone Configuration (Fallback)
    ['standalone'] = {
        resourceName = nil,
        itemName = 'scratchcard',
    },
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ LANGUAGE & LOCALIZATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

Config.Lang = 'en' -- Options: 'en', 'ka' (Georgian), 'tr', 'es', 'fr', 'de', 'ru'

Config.Locale = {
    ['en'] = {
        ['already_scratching']  = 'You are already scratching a card!',
        ['card_used']           = 'You used a scratchcard',
        ['won_prize']           = 'Congratulations! You won $%s!',
        ['no_prize']            = 'No luck this time. Try again!',
        ['card_removed']        = 'Scratchcard removed from inventory',
        ['insufficient_funds']  = 'You do not have enough money',
        ['cooldown_active']     = 'Wait %s seconds before scratching another card',
        ['invalid_action']      = 'Invalid action detected. Suspicious activity logged.',
        ['too_far']             = 'You are too far from where you used the card',
    },
    ['ka'] = {
        ['already_scratching']  = 'თქვენ უკვე ხახავთ ბარათს!',
        ['card_used']           = 'გამოიყენეთ სკრეჩ ბარათი',
        ['won_prize']           = 'გილოცავთ! მოიგეთ $%s!',
        ['no_prize']            = 'ამჯერად არა. სცადეთ კიდევ!',
        ['card_removed']        = 'სკრეჩ ბარათი ამოღებულია ინვენტარიდან',
        ['cooldown_active']     = 'დაელოდეთ %s წამს შემდეგი ბარათის გამოყენებამდე',
    },
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ GENERAL SETTINGS
-- ════════════════════════════════════════════════════════════════════════════════════════════

Config.General = {
    -- Scratchcard Item Configuration
    itemName        = 'scratchcard',        -- Item name in inventory
    itemLabel       = 'Scratch Card',       -- Display name
    itemWeight      = 0.1,                  -- Weight in inventory
    itemLimit       = 20,                   -- Max stack size
    
    -- UI Settings
    closeKey        = 'ESC',                -- Key to close scratchcard UI
    scratchThreshold = 0.5,                 -- % of card that must be scratched (0.0-1.0)
    
    -- Animation Settings
    useAnimation    = true,                 -- Enable scratch animation
    animDict        = 'ai_react@gen@mg',    -- Animation dictionary
    animName        = 'gen_a_hold_obj',     -- Animation name
    animDuration    = 3000,                 -- Animation duration (ms)
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ ECONOMY & REWARDS CONFIGURATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

Config.Economy = {
    -- Prize Configuration
    prizes = {
        min = 0,            -- Minimum prize (0 = no prize)
        max = 10000,        -- Maximum prize (dollars)
    },
    
    -- Win Chance (0-100)
    winChance = 30,         -- 30% chance to win a prize
    
    -- Prize Tiers (Optional - for more granular control)
    useTiers = false,       -- Enable tiered prize system
    tiers = {
        {chance = 50,  min = 1,    max = 100},      -- 50% - Small prize
        {chance = 30,  min = 101,  max = 500},      -- 30% - Medium prize
        {chance = 15,  min = 501,  max = 2000},     -- 15% - Large prize
        {chance = 4,   min = 2001, max = 5000},     -- 4%  - Jackpot
        {chance = 1,   min = 5001, max = 10000},    -- 1%  - MEGA Jackpot
    },
    
    -- Currency Type
    currencyType = 'cash',  -- Options: 'cash', 'bank', 'gold', 'tokens'
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ SECURITY & ANTI-ABUSE
-- ════════════════════════════════════════════════════════════════════════════════════════════

Config.Security = {
    -- Server-Side Validation
    validateInventory   = true,     -- Verify player has item before use
    validateDistance    = true,     -- Verify player hasn't moved too far
    maxDistance         = 10.0,     -- Max distance player can move (meters)
    
    -- Anti-Spam Protection
    enableCooldown      = true,     -- Enable per-player cooldown
    cooldownTime        = 5,        -- Seconds between card uses
    
    -- Rate Limiting
    enableRateLimit     = true,     -- Enable action rate limiting
    maxActionsPerMinute = 10,       -- Max actions per minute per player
    
    -- Exploit Prevention
    preventDuplication  = true,     -- Prevent item duplication exploits
    logSuspicious       = true,     -- Log suspicious activity
    
    -- Webhook Logging (Optional)
    enableWebhook       = false,    -- Enable Discord webhook logging
    webhookURL          = '',       -- Discord webhook URL
    logWins             = true,     -- Log all wins
    logLargeWins        = true,     -- Log wins over threshold
    largeWinThreshold   = 5000,     -- Threshold for "large win" logging
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ PERFORMANCE OPTIMIZATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

Config.Performance = {
    -- Memory Management
    enableCaching       = true,     -- Cache player data
    cacheTimeout        = 300,      -- Cache timeout (seconds)
    cleanupInterval     = 600,      -- Cleanup interval (seconds)
    
    -- Resource Optimization  
    useNatives          = true,     -- Use native functions when available
    minimizeThreads     = true,     -- Minimize active threads
    
    -- Update Intervals
    uiUpdateRate        = 50,       -- UI update rate (ms)
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ DEBUG & DEVELOPMENT
-- ════════════════════════════════════════════════════════════════════════════════════════════

Config.Debug = {
    enabled             = false,    -- Enable debug mode
    printEvents         = false,    -- Print all events to console
    printFramework      = true,     -- Print framework detection info
    printPrizes         = false,    -- Print prize calculations
    verboseLogging      = false,    -- Extra verbose console output
    
    -- Development Testing
    testMode            = false,    -- Enable test mode (always win)
    forceWin            = false,    -- Force winning every scratch
    testPrize           = 1000,     -- Fixed prize amount in test mode
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ ADVANCED CONFIGURATION (OPTIONAL)
-- ════════════════════════════════════════════════════════════════════════════════════════════

Config.Advanced = {
    -- Database Integration (Optional)
    useDatabase         = false,    -- Store scratchcard history in database
    tableName           = 'lxr_scratchcard_history',
    
    -- Statistics Tracking
    trackStats          = false,    -- Track usage statistics
    statsInterval       = 3600,     -- Stats update interval (seconds)
    
    -- Custom Integration Hooks
    customHooks         = {
        beforeScratch   = nil,      -- function(source) called before scratch
        afterScratch    = nil,      -- function(source, prize) called after scratch
        onWin           = nil,      -- function(source, prize) called on win
    },
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ END OF CONFIGURATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

-- Boot Banner
Citizen.CreateThread(function()
    Wait(100)
    print([[
    
        ╔═══════════════════════════════════════════════════════════════════════════════════╗
        ║                                                                                   ║
        ║        🐺 LXR SCRATCHCARD SYSTEM - SUCCESSFULLY LOADED                            ║
        ║                                                                                   ║
        ║        Version:    2.0.0 (Land of Wolves Edition)                                ║
        ║        Framework:  ]] .. Config.Framework .. [[ (Auto-Detection)                          ║
        ║        Server:     ]] .. Config.ServerInfo.name .. [[                          ║
        ║        Developer:  iBoss21 / The Lux Empire                                      ║
        ║                                                                                   ║
        ║        💰 Prize Range: $]] .. Config.Economy.prizes.min .. [[ - $]] .. Config.Economy.prizes.max .. [[                                         ║
        ║        🎲 Win Chance:  ]] .. Config.Economy.winChance .. [[%                                                    ║
        ║        🔒 Security:    ]] .. (Config.Security.enableCooldown and 'ENABLED' or 'DISABLED') .. [[                                            ║
        ║                                                                                   ║
        ║        🐺 https://www.wolves.land                                                 ║
        ║        📦 https://github.com/iBoss21/lxr-scratchcard                             ║
        ║                                                                                   ║
        ╚═══════════════════════════════════════════════════════════════════════════════════╝
    
    ]])
end)

-- Export config for external access
return Config
