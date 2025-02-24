client = client or {}
client.spawnedVehicles = client.spawnedVehicles or {}

exports('useItem', function(data)
    local success = lib.progressBar({
        duration = data.client.usetime,
        label = 'Preparing vehicle',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    })

    if not success then
        exports.ox_lib:notify({ description = 'Canceled', type = 'inform' })
        return
    end

    TriggerServerEvent('maestro_itemvehicles:server:spawnVehicle', data.name)

    return true
end)

RegisterNetEvent('maestro_itemvehicles:client:spawnvehicle', function(itemName, model)
    spawnVehicle(itemName, model)
end)

function spawnVehicle(itemName, model)
    if client.spawnedVehicles[itemName] then
        DeleteVehicle(client.spawnedVehicles[itemName])
        client.spawnedVehicles[itemName] = nil
        return
    end

    lib.requestModel(model)

    local ped = cache.ped
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)

    if DoesEntityExist(vehicle) then
        SetVehicleOnGroundProperly(vehicle)
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
        SetVehicleFuelLevel(vehicle, 100.0)
        SetVehicleEngineOn(vehicle, true, true, true)

        client.spawnedVehicles[itemName] = vehicle

        exports.ox_target:addLocalEntity(vehicle, {
            {
                label = 'Pick up',
                icon = 'fas fa-undo',
                distance = 2.0,
                onSelect = function()
                    PickupVehicle(itemName)
                end
            }
        })
    else
        exports.ox_lib:notify({ title = 'Error', description = 'Failed to spawn ' .. itemName, type = 'error' })
    end
end

function PickupVehicle(itemName)
    local vehicle = client.spawnedVehicles[itemName]

    if vehicle and DoesEntityExist(vehicle) then
        local success = lib.progressBar({
            duration = 2500,
            label = 'taking back',
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = { move = true, car = true, combat = true }
        })

        if not success then return end

        DeleteVehicle(vehicle)
        client.spawnedVehicles[itemName] = nil
        TriggerServerEvent('maestro_itemvehicles:server:returnItem', itemName)
        exports.ox_lib:notify({ title = 'Success', description = 'Received ' .. itemName, type = 'success' })
    else
        exports.ox_lib:notify({ title = 'Error', description = 'Nothing to pick up!', type = 'error' })
    end
end