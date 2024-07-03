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


local debugMaxDisance = 0
CreateThread(function()
    while true do
        local playedPed = PlayerPedId()
        local oldplayerCoords = GetEntityCoords(playedPed)
        Wait(1500)    
        local newplayerCoords = GetEntityCoords(playedPed)
        local distance = #(oldplayerCoords - newplayerCoords)
        if Config.Debug then
            if distance > debugMaxDisance then
                debugMaxDisance = distance
            end
            print(debugMaxDisance)
        end
        if distance >= Config.WarnDistance and not WasTeleported then
            if IsPedInAnyVehicle(playerPed, false) then
                if GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed, false), -1) == playerPed then -- only throw warning when player is in driver seat - this can otherwise call false positives because of driver in car lagging
                    TriggerServerEvent('aleks:tpwarning', distance, oldplayerCoords, newplayerCoords)
                end
            else
                TriggerServerEvent('aleks:tpwarning', distance, oldplayerCoords, newplayerCoords)
            end
        end
        Wait(250)
    end
end)
