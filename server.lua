RegisterServerEvent('aleks:tpwarning')
AddEventHandler('aleks:tpwarning', function(distance, lastCoords, newCoords)
    local src = source
    local WHITELISTEDCOORDS = false
    if IsPlayerAceAllowed(src, Config.WhitelistPermission) then
        return
    end
    for _, coords in pairs(Config.WhitelistedCoords) do
        if IsNearbyWhitelistedCoords(lastCoords, coords) or IsNearbyWhitelistedCoords(newCoords, coords) then
            WHITELISTEDCOORDS = true
            break
        end
    end
    if not WHITELISTEDCOORDS then
        MEDIA = nil
        local identifier = GetPlayerIdentifierByType(src, "license:")
        identifier = identifier:gsub('license:', '')
        local discord = GetPlayerIdentifierByType(src, "discord:")
        discord = discord:gsub('discord:', '')
        MEDIA = GetPlayerScreenshot(src)
        Wait(5000)
        if MEDIA == nil then -- fallback, screenshot export sometimes is buggy
            MEDIA = "https://r2.fivemanage.com/yzHS0l1S443Se8uXAv6eB/No_Image_Available.jpg"
        end
        
        DiscordPayload = {
            ["content"] = MEDIA,
            ["embeds"] = {
                {
                    ["author"] = {
                        ["name"] = "Anti Teleport Warning"
                    },
                    ["title"] = "Anti Teleport Cheat Warnung [" .. src .. "]",
                    ["color"] = 16711680,
                    ["footer"] = {
                        ["text"] = "Aleks Security",
                    },
                    ["image"] = {
                        ["url"] = MEDIA
                    },
                    ["timestamp"] = GetCurrentTimestamp(),
                    ["fields"] = {
                        {
                            ["name"] = "Player",
                            ["value"] = src,
                            ["inline"] = true,
                        },
                        {
                            ["name"] = "Discord",
                            ["value"] = string.format("<@%s>", discord),
                            ["inline"] = true,
                        },
                        {
                            ["name"] = "License",
                            ["value"] = identifier,
                            ["inline"] = true,
                        },
                        {
                            ["name"] = "Distance",
                            ["value"] = tostring(distance),
                            ["inline"] = true,
                        },
                        {
                            ["name"] = "Last coords",
                            ["value"] = tostring(lastCoords),
                            ["inline"] = true,
                        },
                        {
                            ["name"] = "New coords",
                            ["value"] = tostring(newCoords),
                            ["inline"] = true,
                        },
                    }
                }
            }
        }

        PerformHttpRequest(ServerConfig.Webhook, function(statusCode, responseText, headers)            
        end, 'POST', json.encode(DiscordPayload), { ['Content-Type'] = 'application/json' })

        if distance >= Config.BanDistance then
            exports[ServerConfig.Fiveguard]:fg_BanPlayer(src, "Teleport Detected", true)
        end
    end
end)


function GetPlayerScreenshot(src)
    if GetResourceState(ServerConfig.Fiveguard) == "started" then
        local promise = promise.new()
        exports[ServerConfig.Fiveguard]:screenshotPlayer(src, function(photo)
            promise:resolve(photo)
        end)
        local media = Citizen.Await(promise)
        return media
    else
        return "https://r2.fivemanage.com/yzHS0l1S443Se8uXAv6eB/No_Image_Available.jpg"
    end
end

function IsNearbyWhitelistedCoords(playerCoords, newCoords)
    return #(playerCoords - newCoords) <= 10.0
end

function GetCurrentTimestamp()
    local currentTime = os.time()
    local isoTimestamp = os.date("!%Y-%m-%dT%H:%M:%SZ", currentTime)
    return isoTimestamp
end