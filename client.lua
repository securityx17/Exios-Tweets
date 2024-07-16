RegisterNetEvent('chat:addMessage')
AddEventHandler('chat:addMessage', function(message)
    SendNUIMessage({
        type = 'chatMessage',
        template = message.template,
        args = message.args
    })
end)
