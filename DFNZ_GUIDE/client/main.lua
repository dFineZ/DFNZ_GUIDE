local ped
local hasUi, hasCar = false, false
local currentPoint, nextStop, car = 0, nil, nil

-- BLIP THREAD
CreateThread(function()
    if not Config.Location.blip then         
        return
    end

    local blip = AddBlipForCoord(Config.Location.coords[1], Config.Location.coords[2], Config.Location.coords[3])
    SetBlipDisplay(blip, 4)
    SetBlipSprite(blip, Config.Location.blipSettings.sprite)
    SetBlipColour(blip, Config.Location.blipSettings.color)
    SetBlipScale(blip, Config.Location.blipSettings.size)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Location.blipSettings.name)
    EndTextCommandSetBlipName(blip)
end)

-- KEY THREAD
CreateThread(function()
    if Config.UseTarget then
        return
    end

    local keybind = lib.addKeybind({
        name = 'interact_guide',
        description = Config.Text['keyInfo'],
        defaultKey = Config.TextUi.key,
        onReleased = function(self)
            if hasUi then
                startRoute()
            end
        end
    })
end)

-- POINT 
local point = lib.points.new({
    coords = vec3(Config.Location.coords[1], Config.Location.coords[2], Config.Location.coords[3]),
    distance = 20,
})

-- ENTER POINT FUNCTION
function point:onEnter()
    spawnPed()              
end

-- INSIDE POINT FUNCTION
if not Config.UseTarget then
    function point:nearby()
        if self.currentDistance < 2.0 then
            if not hasUi then
                if lib.isTextUIOpen() then
                    lib.hideTextUI()
                end
        
                lib.showTextUI(Config.Text['textui'], {position = Config.TextUi.position, icon = Config.TextUi.icon, iconAnimation = Config.TextUi.animation, iconColor = Config.TextUi.color})
                hasUi = true
            end
        else
            lib.hideTextUI()
            hasUi = false
        end
    end
end

-- EXIT POINT FUNCTION
function point:onExit()
    deletePed()
end

-- SPAWN PED FUNCTION
function spawnPed()
    -- request ped
    local hash = GetHashKey(Config.Location.ped)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end            
    -- create ped
    ped = CreatePed(4, hash, Config.Location.coords[1], Config.Location.coords[2], Config.Location.coords[3] - 1.0, Config.Location.coords[4], false, true)
    SetEntityHeading(ped, Config.Location.coords[4])
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD_FACILITY', -1, true)
    SetModelAsNoLongerNeeded(hash, true)
    -- set target
    if Config.UseTarget then
        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'guide',
                label = Config.Text['target'],
                icon = 'fa-solid fa-location-dot',
                onSelect = function()
                    startRoute()
                end
            },
        })
    end
end

-- DELETE PED FUNCTION
function deletePed()
    DeleteEntity(ped)
end

-- START ROUTE FUNCTION
function startRoute()
    if hasCar then
        return
    end

    lib.callback('guide:check', 0, function(status)
        if status == 1 then
            lib.notify({description = Config.Text['allready_done'], type = 'error', position = Config.Notify.position, iconAnimation = Config.Notify.animation, duration = Config.Notify.duration * 1000})
            return
        else
            if not ESX.Game.IsSpawnPointClear(vec3(Config.Car.coords[1], Config.Car.coords[2], Config.Car.coords[3]), 3.0) then
                lib.notify({description = Config.Text['no_parking_space'], type = 'error', position = Config.Notify.position, iconAnimation = Config.Notify.animation, duration = Config.Notify.duration * 1000})
                return
            end

            ESX.Game.SpawnVehicle(Config.Car.model, vec3(Config.Car.coords[1], Config.Car.coords[2], Config.Car.coords[3]), Config.Car.coords[4], function(guideCar)
                ESX.Game.SetVehicleProperties(guideCar, {
                    plate = Config.Car.plate,
                    fuelLevel = 100.0
                })
                SetPedIntoVehicle(PlayerPedId(), guideCar, -1)
                hasCar = true
                car = guideCar
            end)
            currentPoint = 1
            setWaypoint(currentPoint)
            lib.notify({description = Config.Text['command_info'], type = 'info', position = Config.Notify.position, iconAnimation = Config.Notify.animation, duration = Config.Notify.duration * 1000})
        end
    end)
end

-- DRIVE THREAD
CreateThread(function()
    while true do
        local sleep = 350
        if hasCar then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local check = Config.Route[currentPoint].coords

            if #(coords - check) <= 25.0 then
                sleep = 1
                DrawMarker(1, Config.Route[currentPoint].coords.x, Config.Route[currentPoint].coords.y, Config.Route[currentPoint].coords.z - 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 6.0, 6.0, 1.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
                if #(coords - check) <= 3.0 then
                    FreezeEntityPosition(GetVehiclePedIsIn(ped), true)
                    showText(currentPoint)
                    sleep = 350
                end
            end            
        end
        Wait(sleep)
    end
end)

-- SHOW TEXT FUNCTION
function showText(number)
    local alert = lib.alertDialog({
        header = Config.Text['show_text_header'],
        content = Config.Route[currentPoint].text,
        centered = true,
        labels = {
            confirm = Config.Text['accept']
        }
    })
    if alert == 'confirm' then
        currentPoint = currentPoint + 1
        if Config.Route[currentPoint] == nil then
            DeleteEntity(GetVehiclePedIsIn(PlayerPedId()))
            RemoveBlip(nextStop)
            TriggerServerEvent('guide:reward')
        else
            setWaypoint(currentPoint)
            FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId()), false)
        end
    end
end

-- SET NEW WAYPOINT FUNCTION
function setWaypoint(number)
    if nextStop ~= nil then
        RemoveBlip(nextStop)
    end

    nextStop = AddBlipForCoord(Config.Route[number].coords)
    SetBlipSprite(nextStop, Config.RouteBlip.sprite)
    SetBlipColour(nextStop, Config.RouteBlip.color)
    SetBlipScale(nextStop, Config.RouteBlip.size)
    SetBlipDisplay(nextStop, 4)
    SetBlipAsShortRange(nextStop, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Config.Text['next_stop'])
    EndTextCommandSetBlipName(nextStop)
    SetBlipRoute(nextStop, true)

    lib.notify({description = Config.Text['new_waypoint'], type = 'info', position = Config.Notify.position, iconAnimation = Config.Notify.animation, duration = Config.Notify.duration * 1000})
end

-- COMMAND
RegisterCommand(Config.Command, function()
    if not hasCar then 
        return
    end

    local number = currentPoint - 1
    if Config.Route[number] == nil then
        return
    end

    local alert = lib.alertDialog({
        header = Config.Text['show_text_header'],
        content = Config.Route[number].text,
        centered = true,
        labels = {
            confirm = Config.Text['accept']
        }
    })
end)

-- STOP SCRIPT EVENT
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    if not hasCar then
        return
    end
    if not DoesEntityExist(car) then 
        return
    end
    DeleteEntity(car)
    lib.notify({description = Config.Text['resource_stop'], type = 'info', position = Config.Notify.position, iconAnimation = Config.Notify.animation, duration = Config.Notify.duration * 1000})
end)