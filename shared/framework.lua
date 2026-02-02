--[[
════════════════════════════════════════════════════════════════════════════════════════════════
  ██╗  ██╗██████╗     ███████╗ ██████╗██████╗  █████╗ ████████╗ ██████╗██╗  ██╗ ██████╗ █████╗ ██████╗ ██████╗ 
  ██║  ██║██╔══██╗    ██╔════╝██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║  ██║██╔════╝██╔══██╗██╔══██╗██╔══██╗
  ██║  ██║██████╔╝    ███████╗██║     ██████╔╝███████║   ██║   ██║     ███████║██║     ███████║██████╔╝██║  ██║
  ██║  ██║██╔══██╗    ╚════██║██║     ██╔══██╗██╔══██║   ██║   ██║     ██╔══██║██║     ██╔══██║██╔══██╗██║  ██║
  ███████║██║  ██║    ███████║╚██████╗██║  ██║██║  ██║   ██║   ╚██████╗██║  ██║╚██████╗██║  ██║██║  ██║██████╔╝
  ╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ 
════════════════════════════════════════════════════════════════════════════════════════════════

    🐺 LXR Scratchcard - Framework Adapter Layer (Shared)
    
    Universal framework detection and adapter system that provides a unified interface for
    interacting with multiple RedM frameworks. Automatically detects the active framework
    and maps unified function calls to framework-specific implementations.
    
    This adapter layer ensures clean core logic while maintaining true multi-framework
    compatibility without "fake" event names or incorrect framework mappings.
    
    ════════════════════════════════════════════════════════════════════════════════════════════
    © 2026 The Lux Empire / iBoss21 - https://www.wolves.land
    ════════════════════════════════════════════════════════════════════════════════════════════
]]

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ FRAMEWORK ADAPTER INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

Framework = {}
Framework.Name = nil
Framework.Object = nil
Framework.Ready = false

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ FRAMEWORK AUTO-DETECTION
-- ════════════════════════════════════════════════════════════════════════════════════════════

function Framework.Detect()
    if Config.Framework ~= 'auto' then
        -- Manual framework override
        Framework.Name = Config.Framework
        if Config.Debug.printFramework then
            print('^3[LXR-Scratchcard]^7 Framework manually set to: ^2' .. Framework.Name .. '^7')
        end
        return Framework.Initialize()
    end
    
    -- Priority-based framework detection
    local detectionOrder = {
        {name = 'lxr-core',  resource = 'lxr-core',     export = 'GetCoreObject'},
        {name = 'rsg-core',  resource = 'rsg-core',     export = 'GetCoreObject'},
        {name = 'vorp',      resource = 'vorp_core',    export = 'getCore'},
        {name = 'redemrp',   resource = 'redemrp_core', export = nil},
        {name = 'qbr',       resource = 'qbr-core',     export = 'GetCoreObject'},
        {name = 'qr',        resource = 'qr-core',      export = 'GetCoreObject'},
    }
    
    for _, framework in ipairs(detectionOrder) do
        local resourceState = GetResourceState(framework.resource)
        if resourceState == 'started' or resourceState == 'starting' then
            Framework.Name = framework.name
            
            -- Attempt to get framework object via export
            if framework.export then
                local success, result = pcall(function()
                    return exports[framework.resource][framework.export]()
                end)
                if success and result then
                    Framework.Object = result
                end
            end
            
            if Config.Debug.printFramework then
                print('^2[LXR-Scratchcard]^7 Framework auto-detected: ^2' .. Framework.Name .. '^7')
            end
            
            return Framework.Initialize()
        end
    end
    
    -- Fallback to standalone mode
    Framework.Name = 'standalone'
    if Config.Debug.printFramework then
        print('^3[LXR-Scratchcard]^7 No framework detected, running in ^2standalone^7 mode')
    end
    
    return Framework.Initialize()
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ FRAMEWORK INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

function Framework.Initialize()
    if not Framework.Name then
        return false
    end
    
    -- Framework-specific initialization
    if Framework.Name == 'lxr-core' then
        Framework.InitLXR()
    elseif Framework.Name == 'rsg-core' then
        Framework.InitRSG()
    elseif Framework.Name == 'vorp' then
        Framework.InitVORP()
    elseif Framework.Name == 'redemrp' then
        Framework.InitRedEMRP()
    elseif Framework.Name == 'qbr' or Framework.Name == 'qr' then
        Framework.InitQB()
    elseif Framework.Name == 'standalone' then
        Framework.InitStandalone()
    end
    
    Framework.Ready = true
    return true
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ LXR-CORE FRAMEWORK INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

function Framework.InitLXR()
    if not Framework.Object then
        -- Attempt to get LXR-Core object
        local success, core = pcall(function()
            return exports['lxr-core']:GetCoreObject()
        end)
        if success and core then
            Framework.Object = core
        end
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ RSG-CORE FRAMEWORK INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

function Framework.InitRSG()
    if not Framework.Object then
        local success, core = pcall(function()
            return exports['rsg-core']:GetCoreObject()
        end)
        if success and core then
            Framework.Object = core
        end
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ VORP CORE FRAMEWORK INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

function Framework.InitVORP()
    if not Framework.Object then
        local success, core = pcall(function()
            return exports.vorp_core:getCore()
        end)
        if success and core then
            Framework.Object = core
        end
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ REDEMRP FRAMEWORK INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

function Framework.InitRedEMRP()
    -- RedEM:RP uses event-based system, no core object needed
    Framework.Object = nil
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ QB-CORE VARIANTS INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

function Framework.InitQB()
    if not Framework.Object then
        local resourceName = Framework.Name == 'qbr' and 'qbr-core' or 'qr-core'
        local success, core = pcall(function()
            return exports[resourceName]:GetCoreObject()
        end)
        if success and core then
            Framework.Object = core
        end
    end
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ STANDALONE INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════════════════

function Framework.InitStandalone()
    Framework.Object = nil
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ UNIFIED ADAPTER FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════════════════

--[[
    The following functions provide a unified interface for framework interactions.
    Core logic should ONLY call these unified functions, never framework-specific code directly.
    The adapter handles mapping to the correct framework implementation.
]]

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- CLIENT-SIDE ADAPTER FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() == 0 then -- Client-side only
    
    -- Unified Notification Function
    function Framework.Notify(message, type, duration)
        type = type or 'info'
        duration = duration or 3000
        
        if Framework.Name == 'lxr-core' then
            TriggerEvent(Config.FrameworkSettings['lxr-core'].events.notify, message, type, duration)
            
        elseif Framework.Name == 'rsg-core' then
            if Framework.Object then
                Framework.Object.Functions.Notify(message, type, duration)
            end
            
        elseif Framework.Name == 'vorp' then
            TriggerEvent('vorp:TipRight', message, duration)
            
        elseif Framework.Name == 'redemrp' then
            TriggerEvent('redem_roleplay:Tip', message, duration)
            
        elseif Framework.Name == 'qbr' or Framework.Name == 'qr' then
            if Framework.Object then
                Framework.Object.Functions.Notify(message, type, duration)
            end
            
        else
            -- Standalone fallback
            print('[Notification] ' .. message)
        end
    end
    
    -- Close Inventory Function
    function Framework.CloseInventory()
        if Framework.Name == 'lxr-core' then
            TriggerEvent(Config.FrameworkSettings['lxr-core'].inventory.closeEvent)
            
        elseif Framework.Name == 'rsg-core' then
            TriggerEvent(Config.FrameworkSettings['rsg-core'].inventory.closeEvent)
            
        elseif Framework.Name == 'vorp' then
            TriggerEvent(Config.FrameworkSettings['vorp'].inventory.closeEvent)
            
        elseif Framework.Name == 'redemrp' then
            TriggerEvent(Config.FrameworkSettings['redemrp'].inventory.closeEvent)
            
        elseif Framework.Name == 'qbr' or Framework.Name == 'qr' then
            TriggerEvent(Config.FrameworkSettings[Framework.Name].inventory.closeEvent)
        end
    end
    
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- SERVER-SIDE ADAPTER FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() == 1 then -- Server-side only
    
    -- Get Player Data
    function Framework.GetPlayer(source)
        if Framework.Name == 'lxr-core' then
            if Framework.Object and Framework.Object.Functions then
                return Framework.Object.Functions.GetPlayer(source)
            end
            
        elseif Framework.Name == 'rsg-core' then
            if Framework.Object and Framework.Object.Functions then
                return Framework.Object.Functions.GetPlayer(source)
            end
            
        elseif Framework.Name == 'vorp' then
            if Framework.Object then
                local player = Framework.Object.getUser(source)
                if player then
                    return player.getUsedCharacter
                end
            end
            
        elseif Framework.Name == 'redemrp' then
            -- RedEM:RP uses getAllPlayers system
            return nil -- Handled separately in server logic
            
        elseif Framework.Name == 'qbr' or Framework.Name == 'qr' then
            if Framework.Object and Framework.Object.Functions then
                return Framework.Object.Functions.GetPlayer(source)
            end
        end
        
        return nil
    end
    
    -- Add Money to Player
    function Framework.AddMoney(source, amount, moneyType)
        moneyType = moneyType or 'cash'
        
        if Framework.Name == 'lxr-core' then
            local Player = Framework.GetPlayer(source)
            if Player and Player.Functions then
                Player.Functions.AddMoney(moneyType, amount)
                return true
            end
            
        elseif Framework.Name == 'rsg-core' then
            local Player = Framework.GetPlayer(source)
            if Player and Player.Functions then
                Player.Functions.AddMoney(moneyType, amount)
                return true
            end
            
        elseif Framework.Name == 'vorp' then
            local Player = Framework.GetPlayer(source)
            if Player then
                Player.addCurrency(0, amount) -- 0 = cash in VORP
                return true
            end
            
        elseif Framework.Name == 'redemrp' then
            -- Handled by RedEM:RP player object in server logic
            return false
            
        elseif Framework.Name == 'qbr' or Framework.Name == 'qr' then
            local Player = Framework.GetPlayer(source)
            if Player and Player.Functions then
                Player.Functions.AddMoney(moneyType, amount)
                return true
            end
        end
        
        return false
    end
    
    -- Remove Item from Player
    function Framework.RemoveItem(source, item, amount)
        amount = amount or 1
        
        if Framework.Name == 'lxr-core' then
            local Player = Framework.GetPlayer(source)
            if Player and Player.Functions then
                return Player.Functions.RemoveItem(item, amount)
            end
            
        elseif Framework.Name == 'rsg-core' then
            local Player = Framework.GetPlayer(source)
            if Player and Player.Functions then
                return Player.Functions.RemoveItem(item, amount)
            end
            
        elseif Framework.Name == 'vorp' then
            local success = false
            exports.vorp_inventory:subItem(source, item, amount, function(result)
                success = result
            end)
            return success
            
        elseif Framework.Name == 'redemrp' then
            -- Handled by RedEM:RP inventory system
            return false
            
        elseif Framework.Name == 'qbr' or Framework.Name == 'qr' then
            local Player = Framework.GetPlayer(source)
            if Player and Player.Functions then
                return Player.Functions.RemoveItem(item, amount)
            end
        end
        
        return false
    end
    
    -- Check if Player Has Item
    function Framework.HasItem(source, item, amount)
        amount = amount or 1
        
        if Framework.Name == 'lxr-core' then
            local Player = Framework.GetPlayer(source)
            if Player and Player.Functions then
                local itemData = Player.Functions.GetItemByName(item)
                return itemData and itemData.amount >= amount
            end
            
        elseif Framework.Name == 'rsg-core' then
            local Player = Framework.GetPlayer(source)
            if Player and Player.Functions then
                local itemData = Player.Functions.GetItemByName(item)
                return itemData and itemData.amount >= amount
            end
            
        elseif Framework.Name == 'vorp' then
            local hasItem = false
            exports.vorp_inventory:getItem(source, item, function(itemData)
                hasItem = itemData and itemData.count >= amount
            end)
            return hasItem
            
        elseif Framework.Name == 'redemrp' then
            return false -- Handled separately
            
        elseif Framework.Name == 'qbr' or Framework.Name == 'qr' then
            local Player = Framework.GetPlayer(source)
            if Player and Player.Functions then
                local itemData = Player.Functions.GetItemByName(item)
                return itemData and itemData.amount >= amount
            end
        end
        
        return false
    end
    
    -- Get Player Identifier
    function Framework.GetIdentifier(source)
        if Framework.Name == 'lxr-core' then
            local Player = Framework.GetPlayer(source)
            return Player and Player.PlayerData and Player.PlayerData.citizenid or nil
            
        elseif Framework.Name == 'rsg-core' then
            local Player = Framework.GetPlayer(source)
            return Player and Player.PlayerData and Player.PlayerData.citizenid or nil
            
        elseif Framework.Name == 'vorp' then
            local Player = Framework.GetPlayer(source)
            return Player and Player.identifier or nil
            
        elseif Framework.Name == 'redemrp' then
            for _, id in ipairs(GetPlayerIdentifiers(source)) do
                if string.match(id, 'steam:') then
                    return id
                end
            end
            
        elseif Framework.Name == 'qbr' or Framework.Name == 'qr' then
            local Player = Framework.GetPlayer(source)
            return Player and Player.PlayerData and Player.PlayerData.citizenid or nil
        end
        
        return tostring(source) -- Fallback to source ID
    end
    
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ AUTO-INITIALIZE ON LOAD
-- ════════════════════════════════════════════════════════════════════════════════════════════

Citizen.CreateThread(function()
    Framework.Detect()
end)

-- Export the Framework adapter
_G.Framework = Framework
