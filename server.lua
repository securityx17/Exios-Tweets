ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

local discordWebhook = "https://discord.com/api/webhooks/your-webhook-here"

function GetPlayerGroup(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    if xPlayer then
        local playerGroup = xPlayer.getGroup()

        if playerGroup == 'admin' then
            return 'Admin'
        elseif playerGroup == 'superadmin' then
            return 'Superadmin'
        else
            return 'User'
        end
    else
        return 'Unknown'
    end
end

function SendToDiscord(name, message, group)
    local embeds = {
        {
            ["title"] = "Twt Log",
            ["type"] = "rich",
            ["color"] = 16711680,
            ["fields"] = {
                { ["name"] = "Player", ["value"] = name, ["inline"] = true },
                { ["name"] = "Message", ["value"] = message, ["inline"] = true },
                { ["name"] = "Group", ["value"] = group, ["inline"] = true }
            },
            ["footer"] = {
                ["text"] = "Exios Tweets"
            },
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S')
        }
    }

    PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode({embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterCommand('twt', function(source, args, rawCommand)
    local msg = table.concat(args, " ")
    local playerName = GetPlayerName(source)
    
    local playerGroup = GetPlayerGroup(source)

    if msg == "" then
        TriggerClientEvent('chat:addMessage', source, {
            template = '<div class="chat-message system"><strong>TWT</strong> Je moet een bericht invoeren!</div>',
            args = {}
        })
    else
        local prefix = playerGroup == "Admin" and "[ZV] " or ""
        local formattedMessage = string.format('<div class="chat-message system"><strong>%s%s:</strong> %s</div>', prefix, playerName, msg)

        TriggerClientEvent('chat:addMessage', -1, {
            template = formattedMessage,
            args = {}
        })

        SendToDiscord(playerName, msg, playerGroup)
    end
end, false)
