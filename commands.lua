local QBCore = exports['qb-core']:GetCoreObject()

-- Functions --

local function GetRealPlayerName(source)
    local src = source
    PlayerData = PlayerData or {}
	PlayerData.name = GetPlayerName(src)

	if PlayerData then
		return PlayerData.name
	end
end

-- Roleplay Commands Start --
-- QBCore.Commands.Add('me', 'Show local message', {{name = 'message', help = 'Message to respond with'}}, false, function(source, args)
--     if #args < 1 then exports['dillen-notifications']:sendNotification({title = "Action", message = '/me', type = "All arguments must be present!", duration = 5000}) return end
--     local ped = GetPlayerPed(source)
--     local pCoords = GetEntityCoords(ped)
--     local msg = "* " .. '**' .. table.concat(args, ' '):gsub('[~<].-[>~]', '') .. " **"
--     local Players = QBCore.Functions.GetPlayers()
--     for i=1, #Players do
--         local Player = Players[i]
--         local target = GetPlayerPed(Player)
--         local tCoords = GetEntityCoords(target)
--         if target == ped or #(pCoords - tCoords) < 20 then
--             TriggerClientEvent('QBCore:Command:3dMe', Player, source, msg)
--         end
--     end
-- end, 'user')

QBCore.Commands.Add('me', 'Show local message', {{name = 'message', help = 'Message to respond with'}}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    
    -- Check if the player has provided a message argument
    if #args < 1 then
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message"><strong style="color: red;">Action</strong>: /me requires a message argument!</div>',
            args = {}
        })
        return
    end

    -- Check if the player has at least $1 in their bank account
    if Player.Functions.GetMoney('bank') >= 1 then
        -- Deduct $1 from the player's bank account
        Player.Functions.RemoveMoney('bank', 1)

        local ped = GetPlayerPed(source)
        local pCoords = GetEntityCoords(ped)
        local msg = "* " .. '**' .. table.concat(args, ' '):gsub('[~<].-[>~]', '') .. " **"
        local Players = QBCore.Functions.GetPlayers()

        -- Send the message to nearby players
        for i = 1, #Players do
            local TargetPlayer = Players[i]
            local target = GetPlayerPed(TargetPlayer)
            local tCoords = GetEntityCoords(target)

            -- If the target player is within 20 meters, show the message
            if target == ped or #(pCoords - tCoords) < 20 then
                TriggerClientEvent('QBCore:Command:3dMe', TargetPlayer, source, msg)
            end
        end

        -- Notify the player of the action success
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message"><strong style="color: green;">Success</strong>: Your message has been sent, $1 has been deducted from your bank.</div>',
            args = {}
        })
    else
        -- Notify the player if they don't have enough money
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message"><strong style="color: red;">Insufficient Funds</strong>: You need $1 in your bank to use /me.</div>',
            args = {}
        })
    end
end, 'user')


-- Initialize server funds (this can be stored in a database or a global variable)
local serverFunds = 0
QBCore.Commands.Add("say", "Send a Message", {}, false, function(source, args, rawCommand)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname  -- Combine first and last name
    local msg = rawCommand:sub(5)  -- Extracts the message after the command
    local formattedTime = os.date('%H:%M')  -- Formats the time in hours and minutes

    -- Check if the player has at least $1 in their bank
    if Player.Functions.GetMoney('bank') >= 1 then
        -- Deduct $1 from the player's bank account
        Player.Functions.RemoveMoney('bank', 1)

        -- Add $1 to server funds (assuming `serverFunds` is a global variable)
        serverFunds = serverFunds + 1

        -- Send message to in-game chat with a cloud icon
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-say say"><i class="fas fa-cloud"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
            args = { playerName, msg, formattedTime }
        })

        -- Send message to the player confirming their message has been posted and $1 added to server funds
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-say say"><b><span style="color: green;">[Message Sent]</span></b> Your message has been posted. $1 has been added to server funds.</div>',
            args = {}
        })

    else
        -- Send insufficient funds message to the player in chat
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-say say"><div class="chat-message-body"><strong style="color: red;">Insufficient Funds</strong>: You need $1 in your bank to send a message.</div></div>',
            args = {}
        })
    end
end, "user")



local discords = ""  -- Replace with your actual Discord webhook URL

 -- Replace with your actual Discord webhook URL

 QBCore.Commands.Add("post", "Send a Lifeinvader Post", {}, false, function(source, args, rawCommand)
    local Player = QBCore.Functions.GetPlayer(source)
    local firstName = Player.PlayerData.charinfo.firstname
    local lastName = Player.PlayerData.charinfo.lastname
    local playerName = firstName .. " " .. lastName
    local msg = table.concat(args, ' ')  -- The message the player types
    local formattedTime = os.date('%H:%M')  -- Time in 24-hour format

    -- Check if the player has enough money
    if Player.Functions.GetMoney('cash') >= 10 then
        -- Deduct $10 from the player's cash
        Player.Functions.RemoveMoney('cash', 10)

        -- Send message to in-game chat with a cloud-like icon
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-say say"><i class="fas fa-cloud"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">LifeInvader - {0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
            args = { playerName, msg, formattedTime }
        })

        -- Create and send Discord embed message
        local embed = {
            {
                title = "LifeInvader Post",
                description = playerName .. " sent a message: " .. msg,
                color = 16776960, -- Yellow color
                author = {
                    name = playerName,
                    icon_url = "https://kappa.lol/utBSI.2024-04-30-1714484744.png"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") -- ISO 8601 UTC format
            }
        }

        PerformHttpRequest(discords, function(err, _, _)
            if err ~= 200 then
                print("Error sending Discord message: " .. err)
            end
        end, 'POST', json.encode({ username = "LifeInvader Bot", embeds = embed }), { ['Content-Type'] = 'application/json' })

    else
        -- Notify the player in the chat if they don't have enough money
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-error"><b><span style="color: red;">[LifeInvader] You need $10 to post a message.</span></b></div>',
            args = {}
        })
    end
end, "user")



QBCore.Commands.Add("posta", "Send an Anonymous Lifeinvader Post", {}, false, function(source, args, rawCommand)
    local Player = QBCore.Functions.GetPlayer(source)
    local msg = table.concat(args, ' ')
    local formattedTime = os.date('%I:%M %p')

    -- Check if the player has enough money
    if Player.Functions.GetMoney('cash') >= 10 then
        -- Deduct $10 from the player's cash
        Player.Functions.RemoveMoney('cash', 10)

        -- Send message to in-game chat (broadcast post to all players)
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-cloud"><i class="fas fa-cloud"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">LifeInvader - Anonymous</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{1}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{0}</div></div>',
            args = { msg, formattedTime }
        })

        -- Create and send Discord embed message
        local embed = {
            {
                title = "Anonymous LifeInvader Post",
                description = "Anonymous sent a message: " .. msg,
                color = 16776960, -- Yellow color
                author = {
                    name = "Anonymous",
                    icon_url = "https://kappa.lol/utBSI.2024-04-30-1714484744.png"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") -- ISO 8601 UTC format
            }
        }

        PerformHttpRequest(discords, function(err, _, _)
            if err ~= 200 then
                print("Error sending Discord message: " .. err)
            end
        end, 'POST', json.encode({ username = "LifeInvader - Posts", embeds = embed }), { ['Content-Type'] = 'application/json' })

    else
        -- Notify the player if they don't have enough money
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-cloud"><i class="fas fa-cloud"></i> <b><span style="color: #ff0000;">Error</span></b><div style="margin-top: 5px; font-weight: 300;">You don\'t have enough money to post. You need $10.</div></div>',
            args = {}
        })
    end
end, "user")






-- Function to trigger notification on a specific client from the server


-- Roleplay Commands End --



-- Job Commands Start --
QBCore.Commands.Add("Taxi", "", {}, false, function(source, args, rawCommand)
    local msg = table.concat(args, ' ')  -- Get the message from args
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) -- Get player information
    local playerName = GetRealPlayerName(src) -- Get player name in-game
    local time = os.date('%H:%M')  -- Use 24-hour format for time

    -- Check if the player is a taxi driver and on duty
    if Player.PlayerData.job.name == "taxi" and Player.PlayerData.job.onduty then
        -- Check if the player has enough money (e.g., $10) to post the message
        if Player.Functions.GetMoney('cash') >= 10 then
            -- Deduct the cost for posting a message
            Player.Functions.RemoveMoney('cash', 10)

            -- Send message to in-game chat
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-taxi"><i class="fas fa-taxi"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
                args = { playerName, msg, time }
            })

            -- Send the message to the Discord webhook
            local discordWebhook = ""
            PerformHttpRequest(discordWebhook, function(statusCode, response, headers)
                if statusCode ~= 204 then
                    print("Error sending Discord message: " .. statusCode)
                end
            end, 'POST', json.encode({
                username = "Los Santo's Taxi Company",
                embeds = {{
                    title = "Los Santo's Taxi Company",
                    description = playerName .. " sent a message: " .. msg,
                    color = 16776960, -- Yellow color (decimal) of the embed
                    author = {
                        name = playerName,
                        icon_url = "https://kappa.lol/utBSI.2024-04-30-1714484744.png" -- URL to the player's avatar
                    }
                }}
            }), { ['Content-Type'] = 'application/json' })
        else
            -- Notify the player they don't have enough money to post the message
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div class="chat-error"><b><span style="color: #FF0000;">You need $10 to post a message.</span></b></div>',
                args = {}
            })
        end
    else
        -- Notify player they don't have the Taxi job or aren't on duty
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-error"><b><span style="color: #FF0000;">You don\'t have the Taxi job or you\'re not on duty.</span></b></div>',
            args = {}
        })
    end
end, "user")


QBCore.Commands.Add("pol", "Police Ad Command", {}, false, function(source, args, rawCommand)
    local msg = table.concat(args, ' ')  -- Get the message from args
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) -- Takes player information
    local playerName = GetRealPlayerName(src) -- Get Player Name In Game
    local time = os.date('%H:%M')  -- Use 24-hour format

    -- List of allowed jobs
    local allowedJobs = {
        "leo"
    }

    -- Check if player's job is in the allowed jobs list and if they are on duty
    local isAllowedJob = false
    for _, job in ipairs(allowedJobs) do
        if Player.PlayerData.job.name == job and Player.PlayerData.job.onduty then
            isAllowedJob = true
            break
        end
    end

    if isAllowedJob then
        -- Send message to in-game chat
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-police pol"><i class="fas fa-user-shield"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
            args = { playerName, msg, time }
        })
    else
        -- Notify player that they are not in an allowed job or not on duty
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-police"><div class="chat-message-body"><strong>Dispatch</strong>: You are not authorized or not on duty.</div></div>',
            args = { "1" }  -- This can be customized further if needed
        })
    end
end, "user")



QBCore.Commands.Add("amb", "EMS Ad Command", {}, false, function(source, args, rawCommand)
    local msg = table.concat(args, ' ')  -- Get the message from args
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) -- Get player information
    local playerName = GetRealPlayerName(src) -- Get player name in game
    local time = os.date('%H:%M')  -- Use 24-hour format for timestamp

    -- Check if the player is either EMS (ambulance) or Fire and on duty
    if (Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "fire") and Player.PlayerData.job.onduty then
        -- Send message to in-game chat
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-ems ems"><i class="fas fa-heartbeat"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
            args = { playerName, msg, time }
        })
    else
        -- Notify the player if they are not EMS or not on duty
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-ems"><div class="chat-message-body"><strong>Dispatch</strong>: You are not EMS or not on duty.</div></div>',
            args = { "1" }  -- You can customize this message as needed
        })
    end
end, "user")



QBCore.Commands.Add('mechad', 'Post Mechanic Ad', {}, false, function(source, args, rawCommand)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerName = GetRealPlayerName(source)
    local msg = table.concat(args, ' ')
    local time = os.date('%I:%M')

    -- Check if the player is a mechanic and on duty
    if Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty then
        if Player.Functions.GetMoney('cash') >= 10 then
            Player.Functions.RemoveMoney('cash', 10)
            -- Send message to in-game chat
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-mechanic mechanic"><i class="fas fa-cogs"></i> <b><span style="color: #ffffff">{0}</span> <span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
                args = { playerName, msg, time }
            })
        else
            -- Notify player if they don't have enough money
            TriggerClientEvent('chat:addMessage', source, {
                template = '<div class="chat-mechanic"><div class="chat-message-body"><strong>Mechanic Ad</strong>: You need $10 to post an ad.</div></div>',
                args = { "1" }  -- Customize the message as needed
            })
        end
    else
        -- Notify player if they are not a mechanic or not on duty
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-mechanic"><div class="chat-message-body"><strong>Mechanic Ad</strong>: You must be a mechanic on duty to post an ad.</div></div>',
            args = { "1" }  -- Customize the message as needed
        })
    end
end, "user")


QBCore.Commands.Add('towad', 'Tow Ad Command', {}, false, function(source, args, rawCommand)
    args = table.concat(args, ' ')  -- Get the full message
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) -- Get player information
    local playerName = GetRealPlayerName(src) -- Get player name in game
    local msg = rawCommand:sub(9)  -- Remove the command prefix
    local time = os.date('%I:%M')  -- Use 12-hour format for time
    
    -- Check if the player is a tow and on duty
    if Player.PlayerData.job.name == "tow" and Player.PlayerData.job.onduty then
        -- Check if the player has enough money
        if Player.Functions.GetMoney('cash') >= 10 then
            -- Deduct $10 from the player's cash
            Player.Functions.RemoveMoney('cash', 10)

            -- Send the message to all players
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-mechanic mechanic"><i class="fa-regular fa-truck-tow"></i> <b><span style="color: #ffffff">{0}</span> <span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
                args = { playerName, msg, time }
            })

            -- Send the message to the Discord webhook
            local discordWeb = "https://discord.com/api/webhooks/1234865568105107465/rKP5Crxqj6KtwV8TWrvnVRMLuCqTFOQTUYoEeDZDlvRCojUO2cyvTuKcKsPvB-RG1tFq"
            PerformHttpRequest(discordWeb, function(statusCode, response, headers) end, 'POST', json.encode({
                embeds = {{
                    title = "Los Santo's Auto Work's",
                    description = playerName .. " posted an advertisement: " .. msg,
                    color = 16776960, -- Yellow color (decimal) of the embed
                    author = {
                        name = playerName,
                        icon_url = "https://kappa.lol/inlFD.2024-04-30-1714485276.png" -- URL to the player's avatar
                    }
                }}
            }), { ['Content-Type'] = 'application/json' })
        else
            -- Notify the player they don't have enough money
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div class="chat-mechanic"><div class="chat-message-body"><strong>Tow Ad</strong>: You don\'t have enough money. $10 is required to post an ad.</div></div>',
                args = { "1" }  -- Customize the message as needed
            })
        end
    else
        -- Notify the player they're not on duty or not a tow
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-mechanic"><div class="chat-message-body"><strong>Tow Ad</strong>: You are not active as a tow. Must be on duty.</div></div>',
            args = { "1" }  -- Customize the message as needed
        })
    end
end, "user")


-- Job Commands End --

-- Admin Chat | Commands --

QBCore.Commands.Add('joinstaff', "Login as staff", {}, false, function(source)
    local src = source
    if getStaffStatus(src) then return QBCore.Functions.Notify(src, 'Already joined Staff duty', "info") end
    SetResourceKvp('staff:'..src, true)
    QBCore.Functions.Notify(src, 'Joined Staff duty', "info")

end, 'admin')

QBCore.Commands.Add('leavestaff', "Logout as staff", {}, false, function(source)
    local src = source
    if getStaffStatus(src) then
        QBCore.Functions.Notify(src, 'Left Staff duty', "info")

        DeleteResourceKvp('staff:'..src)
    end
end, 'admin')

QBCore.Commands.Add('checkstaff', "Check online staff", {}, false, function(source)
    local src = source
    local kvpHandle = StartFindKvp('staff:')
    local key = nil

    print('---- Online Staff ----')
    repeat
        key = FindKvp(kvpHandle)
        if not key then EndFindKvp(kvpHandle) QBCore.Functions.Notify(src, 'No Staff on duty', 'info', 7500) return end

        local playerId = key:gsub('staff:', "")
        local Player = QBCore.Functions.GetPlayer(tonumber(playerId))
        QBCore.Functions.Notify(src, 'Check your F8 console', "info")

        print(Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname .. ' [ ' ..Player.PlayerData.citizenid .. ' ]')

    until not key
    EndFindKvp(kvpHandle)
end, 'admin')

---@param player source
function getStaffStatus(player)
    local result = GetResourceKvpString('staff:'..player)
    return result
end

exports('getStaffStatus', getStaffStatus)

AddEventHandler('playerDropped', function ()
    DeleteResourceKvp('staff:'..source)
end)
QBCore.Commands.Add("clearall", "Clear Chat to all the players",  { }, true ,function()
    TriggerClientEvent('chat:clear', -1)
     lib.notify(src, { title = 'BSRP FreeRoam', description = 'You Cleared The Chat', type = 'info', duration = 4000})
end, "god")

-- Admin Chat | Commands End--QBCore.Functions.LoadParticleDictionary(dictionary)



