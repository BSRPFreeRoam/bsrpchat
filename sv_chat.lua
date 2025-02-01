RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntfuckmeered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')
local QBCore = exports['qb-core']:GetCoreObject()
AddEventHandler('_chat:messageEntfuckmeered', function(author, color, message)
    if not message or not author then
        return
    end

    local src = source -- Get the source player ID
    local playerName = GetPlayerName(src) -- Get the player's name
    local character = QBCore.Functions.GetPlayer(src).PlayerData.charinfo -- Get the player's character information
    local firstName = character.firstname -- Get the character's first name
    local lastName = character.lastname -- Get the character's last name

    -- Construct the full name (first name + last name)
    local fullName = firstName .. " " .. lastName

    -- Check if the event was canceled to avoid duplication
    if not WasEventCanceled() then
        -- Broadcast the chat message to all clients
        TriggerClientEvent('chatMessage', -1, 'OOC | '..fullName, false, message)
    end
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, false, '/' .. command)
    end

    CancelEvent()
end)

local GwebhookURL = "" -- Replace this with your actual webhook URL

function SendWebhook(embed)
    PerformHttpRequest(GwebhookURL, function(statusCode, responseBody, headers)
        if statusCode ~= 200 then
            print("[BSRP FreeRoam - Chat] Failed to send webhook: " .. statusCode)
        end
    end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('playerDropped', function(reason)
    local playerName = GetPlayerName(source)

    local embed = {
        {
            ["title"] = "Player Dropped",
            ["description"] = string.format("**%s** left (%s)", playerName, reason),
            ["color"] = 16711680, -- Red color
            ["footer"] = {
                ["text"] = "BSRP FreeRoam - Logs"
            }
        }
    }

    SendWebhook(embed)
end)

AddEventHandler('chat:init', function()
    local playerName = GetPlayerName(source)

    local embeds = {
        {
            ["title"] = "Player Joined",
            ["description"] = string.format("**%s** joined.", playerName),
            ["color"] = 65535, -- Cyan color (0x00FFFF)
            ["footer"] = {
                ["text"] = "BSRP FreeRoam - Logs"
            }
        }
    }

    SendWebhook(embeds)
end)

-- command suggestions for clients
local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)
