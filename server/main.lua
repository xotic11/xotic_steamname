Config.ESX 						   = nil

TriggerEvent(Config.esx .. ':getSharedObject', function(obj) Config.ESX = obj end)

RegisterServerEvent('xotic_steamname:check')
AddEventHandler('xotic_steamname:check', function()
    local xPlayer = Config.ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT steamreward FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)
        if result[1] then
            local resultfrommysql = json.encode(result[1].steamreward)
            local resultfrommysql2 = result[1].steamreward
            if resultfrommysql2 == "0" then
                MySQL.Sync.execute("UPDATE users SET steamreward = 1 WHERE identifier = @identifier", {
                    ['@identifier'] = xPlayer.identifier
                })

                xPlayer.addWeapon("WEAPON_ADVANCEDRIFLE", 250)
                xPlayer.addMoney(25000)
            end
        end
        
        end)
end)