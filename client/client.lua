--[[
════════════════════════════════════════════════════════════════════════════════════════════════
  ██╗  ██╗██████╗     ███████╗ ██████╗██████╗  █████╗ ████████╗ ██████╗██╗  ██╗ ██████╗ █████╗ ██████╗ ██████╗ 
  ██║  ██║██╔══██╗    ██╔════╝██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██║  ██║██╔════╝██╔══██╗██╔══██╗██╔══██╗
  ██║  ██║██████╔╝    ███████╗██║     ██████╔╝███████║   ██║   ██║     ███████║██║     ███████║██████╔╝██║  ██║
  ██║  ██║██╔══██╗    ╚════██║██║     ██╔══██╗██╔══██║   ██║   ██║     ██╔══██║██║     ██╔══██║██╔══██╗██║  ██║
  ███████║██║  ██║    ███████║╚██████╗██║  ██║██║  ██║   ██║   ╚██████╗██║  ██║╚██████╗██║  ██║██║  ██║██████╔╝
  ╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ 
════════════════════════════════════════════════════════════════════════════════════════════════

    🐺 LXR Scratchcard - Client Script
    
    Client-side logic for the scratchcard system. Handles UI interaction, NUI communication,
    and player input for scratching cards. Integrates with the framework adapter for
    cross-framework compatibility.
    
    ════════════════════════════════════════════════════════════════════════════════════════════
    Scope: Client-side UI, Player Interaction, NUI Communication
    ════════════════════════════════════════════════════════════════════════════════════════════
    © 2026 The Lux Empire / iBoss21 - https://www.wolves.land
    ════════════════════════════════════════════════════════════════════════════════════════════
]]

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ CLIENT STATE MANAGEMENT
-- ════════════════════════════════════════════════════════════════════════════════════════════

local ClientState = {
    isScratching = false,
    currentPrize = 0,
    scratchStartCoords = nil,
}

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ FRAMEWORK READY EVENT
-- ════════════════════════════════════════════════════════════════════════════════════════════

Citizen.CreateThread(function()
    -- Wait for framework to be ready
    while not Framework or not Framework.Ready do
        Citizen.Wait(100)
    end
    
    Utils.Log('Client initialized with framework: %s', Framework.Name)
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ CORE SCRATCHCARD FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════════════════

-- Request to Use Scratchcard
function UseScratchcard()
    if ClientState.isScratching then
        Framework.Notify(Utils.GetLocale('already_scratching'), 'error', 3000)
        return
    end
    
    -- Store player position for distance validation
    local playerPed = PlayerPedId()
    ClientState.scratchStartCoords = GetEntityCoords(playerPed)
    
    -- Trigger server-side validation and prize calculation
    TriggerServerEvent('lxr-scratchcard:server:useCard')
    
    Utils.Debug('Scratchcard use requested')
end

-- Display Scratchcard UI
function ShowScratchcardUI(prize)
    if ClientState.isScratching then
        return
    end
    
    ClientState.isScratching = true
    ClientState.currentPrize = prize
    
    Wait(100)
    
    -- Enable NUI focus
    SetNuiFocus(true, true)
    
    -- Send data to NUI
    SendNUIMessage({
        type = "shownui",
        value = prize,
        threshold = Config.General.scratchThreshold or 0.5
    })
    
    -- Play animation if enabled
    if Config.General.useAnimation then
        PlayScratchAnimation()
    end
    
    Utils.Debug('Scratchcard UI displayed with prize: $%d', prize)
end

-- Close Scratchcard UI
function CloseScratchcardUI()
    if not ClientState.isScratching then
        return
    end
    
    SetNuiFocus(false, false)
    
    -- Validate player hasn't moved too far (anti-exploit)
    if Config.Security.validateDistance and ClientState.scratchStartCoords then
        local playerPed = PlayerPedId()
        local currentCoords = GetEntityCoords(playerPed)
        local distance = #(ClientState.scratchStartCoords - currentCoords)
        
        if distance > Config.Security.maxDistance then
            Utils.Debug('Player moved too far: %.2fm', distance)
            TriggerServerEvent('lxr-scratchcard:server:invalidMovement', distance)
        end
    end
    
    -- Notify server that scratching is complete
    TriggerServerEvent('lxr-scratchcard:server:claimPrize')
    
    -- Reset state
    ClientState.isScratching = false
    ClientState.currentPrize = 0
    ClientState.scratchStartCoords = nil
    
    Utils.Debug('Scratchcard UI closed')
end

-- Play Scratch Animation
function PlayScratchAnimation()
    local playerPed = PlayerPedId()
    
    -- Load animation dictionary
    RequestAnimDict(Config.General.animDict)
    while not HasAnimDictLoaded(Config.General.animDict) do
        Citizen.Wait(10)
    end
    
    -- Play animation
    TaskPlayAnim(
        playerPed,
        Config.General.animDict,
        Config.General.animName,
        8.0, -8.0, Config.General.animDuration,
        1, 0, false, false, false
    )
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ EVENT HANDLERS
-- ════════════════════════════════════════════════════════════════════════════════════════════

-- Legacy Event Support (for backwards compatibility)
RegisterNetEvent("qadr_scratchcard:useCard")
AddEventHandler("qadr_scratchcard:useCard", function()
    UseScratchcard()
end)

RegisterNetEvent("qadr_scratchcard:kartGoster")
AddEventHandler("qadr_scratchcard:kartGoster", function(prize)
    ShowScratchcardUI(prize)
end)

-- Modern Event Naming (LXR Style)
RegisterNetEvent("lxr-scratchcard:client:useCard")
AddEventHandler("lxr-scratchcard:client:useCard", function()
    UseScratchcard()
end)

RegisterNetEvent("lxr-scratchcard:client:showCard")
AddEventHandler("lxr-scratchcard:client:showCard", function(prize)
    ShowScratchcardUI(prize)
end)

RegisterNetEvent("lxr-scratchcard:client:notify")
AddEventHandler("lxr-scratchcard:client:notify", function(message, type, duration)
    Framework.Notify(message, type, duration)
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ NUI CALLBACKS
-- ════════════════════════════════════════════════════════════════════════════════════════════

-- Close NUI Callback
RegisterNUICallback("closenui", function(data, cb)
    CloseScratchcardUI()
    
    if cb then
        cb({status = 'ok'})
    end
end)

-- Scratch Progress Callback (optional - for future features)
RegisterNUICallback("scratchProgress", function(data, cb)
    if Config.Debug.printEvents then
        Utils.Debug('Scratch progress: %.2f%%', (data.progress or 0) * 100)
    end
    
    if cb then
        cb({status = 'ok'})
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ EXPORTS (FOR EXTERNAL ACCESS)
-- ════════════════════════════════════════════════════════════════════════════════════════════

exports('UseScratchcard', UseScratchcard)
exports('IsScratching', function()
    return ClientState.isScratching
end)

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ DEBUG COMMANDS (DEVELOPMENT ONLY)
-- ════════════════════════════════════════════════════════════════════════════════════════════

if Config.Debug.enabled then
    RegisterCommand('testcard', function()
        ShowScratchcardUI(1000)
    end, false)
    
    RegisterCommand('closecard', function()
        CloseScratchcardUI()
    end, false)
end

-- ════════════════════════════════════════════════════════════════════════════════════════════
-- █████ CLIENT INITIALIZATION COMPLETE
-- ════════════════════════════════════════════════════════════════════════════════════════════

Citizen.CreateThread(function()
    Wait(1000)
    Utils.Log('Client-side scratchcard system initialized')
end)
