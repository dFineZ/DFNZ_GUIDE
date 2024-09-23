local WebhookURL = ''  --> insert your webhook link here

-- CALLBACK
lib.callback.register('guide:check', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = MySQL.query.await('SELECT hasTour FROM users WHERE identifier = ?', {xPlayer.identifier})
    for i=1, #data do
        return data[i].hasTour
    end
end)

-- REWARD EVENT
RegisterServerEvent('guide:reward')
AddEventHandler('guide:reward', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    for k, v in pairs(Config.SuccessItems) do
        xPlayer.addInventoryItem(k, v)
    end
    MySQL.update('UPDATE users SET hasTour = ? WHERE identifier = ?', {
        1, xPlayer.identifier
    })
    if Config.EnableWebhook then
        exports['DFNZ_LOGGER']:sendHook(WebhookURL, Config.Text['guide_complete'], xPlayer.name..' '..Config.Text['guide_complete_wbh'], xPlayer.source)
    end
end)

-- SCRIPT START EVENT
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if not Config.EnableWebhook then
        print('^2[INFO]^0 Webhhoks are disabled!')
    end
    if not Config.UseLogger then
        print('^2[INFO]^0 Config.UseLogger is set to false, if you want to use webhooks you can use DFNZ_LOGGER or your own system!')
    end
    if Config.UseLogger then
        if GetResourceState('DFNZ_LOGGER') ~= 'started' then
            print('^1[ERROR]^0 DFNZ_LOGGER is missing or is not started!')
        end
    end
    if GetResourceState('ox_lib') ~= 'started' then
        print('^1[ERROR]^0 ox_lib is missing or is not started!')
    end 
    if Config.UseTarget then
        if GetResourceState('ox_target') ~= 'started' then
            print('^1[ERROR]^0 ox_target is missing or is not started!')
        end 
    end
    if GetResourceState('oxmysql') ~= 'started' then
        print('^1[ERROR]^0 oxmysql is missing or is not started!')
    end
    if GetResourceState('es_extended') ~= 'started' then
        print('^1[ERROR]^0 es_extended is missing or is not started!')
    end
end)

-- ADMIN COMAND
lib.addCommand(Config.AdminCommand, {
    help = Config.Text['admin_help'],
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = Config.Text['admin_help_info'],
        },
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    
    if not args.target then
        return
    end

    local xPlayer = ESX.GetPlayerFromId(args.target)
    MySQL.update('UPDATE users SET hasTour = ? WHERE identifier = ?', {
        0, xPlayer.identifier
    })

end)

