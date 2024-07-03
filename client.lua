local WasTeleported = false
RegisterNetEvent('txcl:tpToCoords') -- tx event when player was teleported
AddEventHandler('txcl:tpToCoords', function()
    WasTeleported = true
    Wait(5000)
    WasTeleported = false
end)

--[[
    ADD YOUR CUSTOM TELEPORT EVENT HERE AND CHANGE "WasTeleported" to true / false
]]

CreateThread(function()
    while true do
        local playedPed = PlayerPedId()
        local oldplayerCoords = GetEntityCoords(playedPed)
        Wait(1500)
        local newplayerCoords = GetEntityCoords(playedPed)
        local distance = #(oldplayerCoords - newplayerCoords)
        if distance >= Config.WarnDistance and not WasTeleported then
            TriggerServerEvent('aleks:tpwarning', distance, oldplayerCoords, newplayerCoords)
        end
        Wait(250)
    end
end)