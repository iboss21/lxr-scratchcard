--[[
════════════════════════════════════════════════════════════════════════════════════════════════
  ██╗  ██╗██████╗     ███████╗ ██████╗██████╗  █████╗ ████████╗ ██████╗██╗  ██╗ ██████╗ █████╗ ██████╗ ██████╗ 
  ██║  ██║██╔══██╗    ██╔════╝██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║  ██║██╔════╝██╔══██╗██╔══██╗██╔══██╗
  ██║  ██║██████╔╝    ███████╗██║     ██████╔╝███████║   ██║   ██║     ███████║██║     ███████║██████╔╝██║  ██║
  ██║  ██║██╔══██╗    ╚════██║██║     ██╔══██╗██╔══██║   ██║   ██║     ██╔══██║██║     ██╔══██║██╔══██╗██║  ██║
  ███████║██║  ██║    ███████║╚██████╗██║  ██║██║  ██║   ██║   ╚██████╗██║  ██║╚██████╗██║  ██║██║  ██║██████╔╝
  ╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ 
════════════════════════════════════════════════════════════════════════════════════════════════

    🐺 LXR Scratchcard - Server Script
    
    Server-side logic for scratchcard system with comprehensive security, validation,
    anti-abuse protection, and framework integration. All prize calculations and
    monetary transactions are handled server-side to prevent client-side exploits.
    
    ════════════════════════════════════════════════════════════════════════════════════════════
    Scope: Prize Calculation, Security, Validation, Database, Economy Integration
    ════════════════════════════════════════════════════════════════════════════════════════════
    © 2026 The Lux Empire / iBoss21 - https://www.wolves.land
    ════════════════════════════════════════════════════════════════════════════════════════════
]]

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ SERVER STATE MANAGEMENT
-- ════════════════════════════════════════════════════════════════════════════════════════════

local ServerState = {
    scratchData = {},      -- Player scratch session data
    allPlayers = {},       -- RedEM:RP player cache
    inventoryData = {},    -- RedEM:RP inventory data cache
    cooldowns = {},        -- Per-player cooldowns
    rateLimits = {},       -- Rate limiting data
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ FRAMEWORK-SPECIFIC INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

Citizen.CreateThread(function()
    -- Wait for framework to be ready
    while not Framework or not Framework.Ready do
        Citizen.Wait(100)
    end
    
    Utils.Log('Server initialized with framework: %s', Framework.Name)
    
    -- RedEM:RP specific initialization
    if Framework.Name == 'redemrp' then
        InitializeRedEMRP()
    end
    
    -- Register item usage handlers
    RegisterItemHandlers()
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ REDEMRP SPECIFIC INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

function InitializeRedEMRP()
    -- Get inventory system data
    TriggerEvent("redemrp_inventory:getData", function(call)
        ServerState.inventoryData = call
    end)
    
    -- Load all players
    LoadAllPlayers()
    
    -- Reload on player connection
    AddEventHandler("redemrp:playerLoaded", function()
        LoadAllPlayers()
    end)
    
    Utils.Log('RedEM:RP initialization complete')
end

function LoadAllPlayers()
    TriggerEvent("redemrp:getAllPlayers", function(allusers)
        ServerState.allPlayers = allusers
        Utils.Debug('Loaded %d RedEM:RP players', Utils.TableCount(allusers))
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ ITEM USAGE REGISTRATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

function RegisterItemHandlers()
    local itemName = Config.General.itemName
    
    -- RedEM:RP item usage
    if Framework.Name == 'redemrp' then
        RegisterServerEvent("RegisterUsableItem:" .. itemName)
        AddEventHandler("RegisterUsableItem:" .. itemName, function(source, meta)
            HandleItemUse(source)
        end)
    end
    
    -- LXR-Core / RSG-Core item usage
    if Framework.Name == 'lxr-core' or Framework.Name == 'rsg-core' then
        if Framework.Object and Framework.Object.Functions then
            Framework.Object.Functions.CreateUseableItem(itemName, function(source, item)
                HandleItemUse(source)
            end)
        end
    end
    
    -- VORP item usage
    if Framework.Name == 'vorp' then
        exports.vorp_inventory:registerUsableItem(itemName, function(data)
            HandleItemUse(data.source)
        end)
    end
    
    Utils.Log('Item handler registered for: %s', itemName)
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ SECURITY & VALIDATION FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════════════════

-- Check Player Cooldown
function IsOnCooldown(source)
    if not Config.Security.enableCooldown then
        return false
    end
    
    local identifier = Framework.GetIdentifier(source)
    if not identifier then
        return false
    end
    
    local cooldownData = ServerState.cooldowns[identifier]
    if not cooldownData then
        return false
    end
    
    local currentTime = os.time()
    local timeSince = currentTime - cooldownData.lastUse
    
    if timeSince < Config.Security.cooldownTime then
        local remaining = Config.Security.cooldownTime - timeSince
        return true, remaining
    end
    
    return false
end

-- Set Player Cooldown
function SetCooldown(source)
    if not Config.Security.enableCooldown then
        return
    end
    
    local identifier = Framework.GetIdentifier(source)
    if identifier then
        ServerState.cooldowns[identifier] = {
            lastUse = os.time()
        }
    end
end

-- Check Rate Limit
function CheckRateLimit(source)
    if not Config.Security.enableRateLimit then
        return true
    end
    
    local identifier = Framework.GetIdentifier(source)
    if not identifier then
        return true
    end
    
    local currentTime = os.time()
    local rateData = ServerState.rateLimits[identifier]
    
    if not rateData then
        ServerState.rateLimits[identifier] = {
            actions = 1,
            windowStart = currentTime
        }
        return true
    end
    
    -- Reset window if minute has passed
    if currentTime - rateData.windowStart >= 60 then
        ServerState.rateLimits[identifier] = {
            actions = 1,
            windowStart = currentTime
        }
        return true
    end
    
    -- Check if over limit
    if rateData.actions >= Config.Security.maxActionsPerMinute then
        Utils.Error('Rate limit exceeded for player %s', identifier)
        LogSuspiciousActivity(source, 'rate_limit_exceeded', rateData.actions)
        return false
    end
    
    rateData.actions = rateData.actions + 1
    return true
end

-- Log Suspicious Activity
function LogSuspiciousActivity(source, reason, details)
    if not Config.Security.logSuspicious then
        return
    end
    
    local identifier = Framework.GetIdentifier(source)
    local playerName = GetPlayerName(source) or 'Unknown'
    
    Utils.Error('SUSPICIOUS ACTIVITY: Player %s [%s] - %s - Details: %s', 
        playerName, identifier, reason, tostring(details))
    
    -- TODO: Implement webhook logging if needed
    if Config.Security.enableWebhook and Config.Security.webhookURL ~= '' then
        -- SendToWebhook(source, reason, details)
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ SCRATCH DATA MANAGEMENT
-- ════════════════════════════════════════════════════════════════════════════════════════════

function GetScratchData(identifier)
    for i = 1, #ServerState.scratchData do
        if ServerState.scratchData[i].user == identifier then
            return ServerState.scratchData[i], i
        end
    end
    return nil
end

function CreateScratchData(identifier)
    table.insert(ServerState.scratchData, {
        user = identifier,
        stillUsing = false,
        prize = 0
    })
    return ServerState.scratchData[#ServerState.scratchData]
end

function CheckCard(identifier)
    local data = GetScratchData(identifier)
    if data then
        return data.stillUsing
    end
    
    -- Create new entry
    CreateScratchData(identifier)
    return false
end

function CheckPrize(identifier)
    local data = GetScratchData(identifier)
    if data then
        return data.prize
    end
    
    CreateScratchData(identifier)
    return 0
end

function SetCard(identifier, bool, prize)
    local data = GetScratchData(identifier)
    if not data then
        data = CreateScratchData(identifier)
    end
    
    if bool ~= nil then
        data.stillUsing = bool
    end
    
    if prize ~= nil then
        data.prize = prize
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ PRIZE CALCULATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

function CalculatePrize()
    -- Test mode override
    if Config.Debug.testMode and Config.Debug.forceWin then
        return Config.Debug.testPrize
    end
    
    -- Tiered prize system
    if Config.Economy.useTiers then
        return CalculateTieredPrize()
    end
    
    -- Simple win chance system
    local chance = math.random(1, 100)
    local prize = 0
    
    if chance <= Config.Economy.winChance then
        local rewards = Config.Economy.prizes
        prize = math.random(rewards.min, rewards.max)
    end
    
    if Config.Debug.printPrizes then
        Utils.Debug('Prize calculated: $%d (chance roll: %d/%d)', prize, chance, Config.Economy.winChance)
    end
    
    return prize
end

function CalculateTieredPrize()
    local roll = math.random(1, 100)
    local cumulative = 0
    
    for _, tier in ipairs(Config.Economy.tiers) do
        cumulative = cumulative + tier.chance
        if roll <= cumulative then
            local prize = math.random(tier.min, tier.max)
            Utils.Debug('Tiered prize: $%d from tier [%d-%d] (roll: %d)', prize, tier.min, tier.max, roll)
            return prize
        end
    end
    
    return 0
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ ITEM USE HANDLER
-- ════════════════════════════════════════════════════════════════════════════════════════════

function HandleItemUse(source)
    -- Rate limit check
    if not CheckRateLimit(source) then
        TriggerClientEvent("lxr-scratchcard:client:notify", source, 
            Utils.GetLocale('invalid_action'), 'error', 3000)
        return
    end
    
    local identifier = Framework.GetIdentifier(source)
    if not identifier then
        Utils.Error('Could not get identifier for source %s', source)
        return
    end
    
    -- Check if already scratching
    local isScratching = CheckCard(identifier)
    if isScratching then
        TriggerClientEvent("lxr-scratchcard:client:notify", source, 
            Utils.GetLocale('already_scratching'), 'error', 3000)
        return
    end
    
    -- Check cooldown
    local onCooldown, remaining = IsOnCooldown(source)
    if onCooldown then
        TriggerClientEvent("lxr-scratchcard:client:notify", source, 
            Utils.GetLocale('cooldown_active', remaining), 'error', 3000)
        return
    end
    
    -- Remove item from inventory (framework-specific)
    local removed = RemoveItemFromInventory(source)
    if not removed then
        Utils.Error('Failed to remove scratchcard from player %s inventory', identifier)
        return
    end
    
    -- Set scratch state
    SetCard(identifier, true, nil)
    SetCooldown(source)
    
    -- Trigger use card event
    TriggerEvent('lxr-scratchcard:server:useCard', source)
    TriggerClientEvent("lxr-scratchcard:client:useCard", source)
    
    -- Close inventory
    ClosePlayerInventory(source)
    
    Utils.Debug('Player %s used scratchcard', identifier)
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ FRAMEWORK-SPECIFIC INVENTORY FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════════════════

function RemoveItemFromInventory(source)
    local itemName = Config.General.itemName
    
    -- RedEM:RP
    if Framework.Name == 'redemrp' then
        if ServerState.inventoryData and ServerState.inventoryData.getItem then
            local ItemData = ServerState.inventoryData.getItem(source, itemName)
            if ItemData and ItemData.RemoveItem then
                ItemData.RemoveItem(1)
                return true
            end
        end
        return false
    end
    
    -- Other frameworks use adapter
    return Framework.RemoveItem(source, itemName, 1)
end

function ClosePlayerInventory(source)
    if Framework.Name == 'redemrp' then
        TriggerClientEvent("redemrp_inventory:closeinv", source)
    else
        -- Use framework adapter
        TriggerClientEvent("lxr-scratchcard:client:closeInventory", source)
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ EVENT HANDLERS
-- ════════════════════════════════════════════════════════════════════════════════════════════

-- Use Card Event (Prize Calculation)
RegisterServerEvent("lxr-scratchcard:server:useCard")
AddEventHandler("lxr-scratchcard:server:useCard", function()
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    if not identifier then
        return
    end
    
    -- Calculate prize
    local prize = CalculatePrize()
    
    -- Store prize in scratch data
    SetCard(identifier, nil, prize)
    
    -- Send card to client
    TriggerClientEvent("lxr-scratchcard:client:showCard", source, prize)
    
    -- Legacy event support
    TriggerClientEvent("qadr_scratchcard:kartGoster", source, prize)
    
    Utils.Debug('Prize generated for player %s: $%d', identifier, prize)
end)

-- Claim Prize Event
RegisterServerEvent("lxr-scratchcard:server:claimPrize")
AddEventHandler("lxr-scratchcard:server:claimPrize", function()
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    if not identifier then
        return
    end
    
    -- Get prize amount
    local prize = CheckPrize(identifier)
    
    -- Clear scratch data
    SetCard(identifier, false, nil)
    
    -- Award prize if won
    if prize > 0 then
        AwardPrize(source, prize)
        
        -- Log large wins
        if Config.Security.logLargeWins and prize >= Config.Security.largeWinThreshold then
            Utils.Log('LARGE WIN: Player %s won $%d', identifier, prize)
        end
    else
        TriggerClientEvent("lxr-scratchcard:client:notify", source, 
            Utils.GetLocale('no_prize'), 'info', 3000)
    end
    
    Utils.Debug('Prize claimed by player %s: $%d', identifier, prize)
end)

-- Invalid Movement Detection
RegisterServerEvent("lxr-scratchcard:server:invalidMovement")
AddEventHandler("lxr-scratchcard:server:invalidMovement", function(distance)
    local source = source
    Utils.Error('Player %s moved too far during scratch: %.2fm', source, distance)
    LogSuspiciousActivity(source, 'excessive_movement', distance)
end)

-- Legacy Event Support
RegisterServerEvent("qadr_scratchcard:prize")
AddEventHandler("qadr_scratchcard:prize", function()
    TriggerEvent("lxr-scratchcard:server:claimPrize")
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ PRIZE AWARDING
-- ════════════════════════════════════════════════════════════════════════════════════════════

function AwardPrize(source, amount)
    local identifier = Framework.GetIdentifier(source)
    
    -- RedEM:RP specific
    if Framework.Name == 'redemrp' then
        local roleplayer = ServerState.allPlayers[source]
        if roleplayer and roleplayer.addMoney then
            roleplayer.addMoney(amount)
            TriggerClientEvent("lxr-scratchcard:client:notify", source, 
                Utils.GetLocale('won_prize', amount), 'success', 5000)
            Utils.Log('Awarded $%d to player %s (RedEM:RP)', amount, identifier)
            return
        end
    end
    
    -- Other frameworks use adapter
    local success = Framework.AddMoney(source, amount, Config.Economy.currencyType)
    if success then
        TriggerClientEvent("lxr-scratchcard:client:notify", source, 
            Utils.GetLocale('won_prize', amount), 'success', 5000)
        Utils.Log('Awarded $%d to player %s', amount, identifier)
    else
        Utils.Error('Failed to award prize to player %s', identifier)
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ CLEANUP & MAINTENANCE
-- ════════════════════════════════════════════════════════════════════════════════════════════

if Config.Performance.enableCaching then
    Citizen.CreateThread(function()
        while true do
            Wait(Config.Performance.cleanupInterval * 1000)
            
            -- Clean up old cooldown data
            local currentTime = os.time()
            for identifier, data in pairs(ServerState.cooldowns) do
                if currentTime - data.lastUse > Config.Performance.cacheTimeout then
                    ServerState.cooldowns[identifier] = nil
                end
            end
            
            -- Clean up old rate limit data
            for identifier, data in pairs(ServerState.rateLimits) do
                if currentTime - data.windowStart > 120 then
                    ServerState.rateLimits[identifier] = nil
                end
            end
            
            Utils.Debug('Server cleanup completed')
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ EXPORTS (FOR EXTERNAL ACCESS)
-- ════════════════════════════════════════════════════════════════════════════════════════════

exports('AwardPrize', AwardPrize)
exports('CalculatePrize', CalculatePrize)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ SERVER INITIALIZATION COMPLETE
-- ════════════════════════════════════════════════════════════════════════════════════════════

Utils.Log('Server-side scratchcard system initialized')
