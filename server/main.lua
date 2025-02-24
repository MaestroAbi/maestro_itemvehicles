local Config = require 'shared.config'

RegisterNetEvent('maestro_itemvehicles:server:spawnVehicle', function(itemName)
    local src = source
    local model = Config.Vehicles[itemName]?.model

    if not model then
        exports.ox_inventory:AddItem(src, itemName, 1)
        return
    end

    local count = exports.ox_inventory:GetItemCount(src, itemName)
    if count < 1 then
        print("[CHEAT] Player attempted to spawn without item:"..GetPlayerName(src))
        return
    end

    exports.ox_inventory:RemoveItem(src, itemName, 1)

    TriggerClientEvent('maestro_itemvehicles:client:spawnvehicle', src, itemName, model)
end)

RegisterNetEvent('maestro_itemvehicles:server:returnItem', function(itemName)
    exports.ox_inventory:AddItem(source, itemName, 1)
end)

