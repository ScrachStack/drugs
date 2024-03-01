

CreateThread(function()
    local waitTime = 500  
    while true do
        Citizen.Wait(waitTime)
        local playerPed = PlayerId()
        local playerCoords = GetEntityCoords(PlayerPedId())
        local nearAnyLocation = false  
        for i = 1, #Config.Drugs do
            local properties = Config.Drugs[i] 
            if IsNearLocation(playerCoords, properties.harvestLocation, 10) or 
               IsNearLocation(playerCoords, properties.processLocation, 10) or
               IsNearLocation(playerCoords, properties.sellLocation, 10) then
                nearAnyLocation = true
                break
            end
        end
                
        if nearAnyLocation then
            waitTime = 0
            
            for i = 1, #Config.Drugs do
                local drug = Config.Drugs[i]
                local properties = drug -- Assuming Config.Drugs[i] directly contains the properties
        
                local harvestDist = #(playerCoords - vector3(properties.harvestLocation.x, properties.harvestLocation.y, properties.harvestLocation.z))
                local processDist = #(playerCoords - vector3(properties.processLocation.x, properties.processLocation.y, properties.processLocation.z))
                local sellDist = #(playerCoords - vector3(properties.sellLocation.x, properties.sellLocation.y, properties.sellLocation.z))
                
                if harvestDist < 5.0 then
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to harvest " .. drug)
                    EndTextCommandDisplayHelp(0, false, true, -1)
                    
                    if IsControlJustReleased(0, 38) then
                        progbar("Harvesting...", "bar")
                        TriggerServerEvent("harvestDrug", drug, playerCoords)
                    end
                elseif processDist < 5.0 then
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to process " .. drug)
                    EndTextCommandDisplayHelp(0, false, true, -1)
                    
                    if IsControlJustReleased(0, 38) then
                        progbar("Processing...", "circle")
                        TriggerServerEvent("processDrug", drug)
                    end
                elseif sellDist < 5.0 then
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to sell " .. drug)
                    EndTextCommandDisplayHelp(0, false, true, -1)
                    
                    if IsControlJustReleased(0, 38) then
                        progbar("Selling...", "bar")
                        TriggerServerEvent("sellDrug", drug)
                    end
                end
            end
        else
            waitTime = 500
        end        
    end
end)

function IsNearLocation(playerCoords, location, radius)
    return #(playerCoords - vector3(location.x, location.y, location.z)) < radius
end

local isProgressActive = false  

function progbar(label, progressType)
    if isProgressActive then  
        print('Another progress action is currently active.')
        return
    end

    local pbConfig = Config.progressBar

    local commonConfig = {
        duration = pbConfig.duration,
        label = label or pbConfig.label,
        useWhileDead = pbConfig.useWhileDead,
        canCancel = pbConfig.canCancel,
        disable = {
            car = pbConfig.controlDisables.disableCarMovement,
        },
        anim = {
            dict = pbConfig.animation.animDict,
            clip = pbConfig.animation.anim
        },
        prop = {
        },
    }

    isProgressActive = true 

    local chosenType = progressType or pbConfig.type 

    if chosenType == 'bar' then
        if lib.progressBar(commonConfig) then
            print('Do stuff when complete')
        else
            print('Do stuff when cancelled')
        end
    elseif chosenType == 'circle' then
        if lib.progressCircle(commonConfig) then
            print('Do stuff when complete')
        else
            print('Do stuff when cancelled')
        end
    else
        print('Invalid progressType. Choose either "bar" or "circle".')
    end
    
    isProgressActive = false 
end


Citizen.CreateThread(function()
    for i = 1, #Config.Drugs do
        local properties = Config.Drugs[i]
        if properties.blip and properties.blip.enable then
            local harvestBlip = AddBlipForCoord(properties.harvestLocation.x, properties.harvestLocation.y, properties.harvestLocation.z)
            SetBlipSprite(harvestBlip, properties.blip.sprite)
            SetBlipColour(harvestBlip, properties.blip.color)
            SetBlipAsShortRange(harvestBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(properties.blip.label)
            EndTextCommandSetBlipName(harvestBlip)
    
            local processBlip = AddBlipForCoord(properties.processLocation.x, properties.processLocation.y, properties.processLocation.z)
            SetBlipSprite(processBlip, properties.blip.sprite)
            SetBlipColour(processBlip, properties.blip.color)
            SetBlipAsShortRange(processBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(properties.blip.processLabel)
            EndTextCommandSetBlipName(processBlip)
    
            local sellBlip = AddBlipForCoord(properties.sellLocation.x, properties.sellLocation.y, properties.sellLocation.z)
            SetBlipSprite(sellBlip, properties.blip.sprite)
            SetBlipColour(sellBlip, properties.blip.color)
            SetBlipAsShortRange(sellBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(properties.blip.sellLabel)
            EndTextCommandSetBlipName(sellBlip)
        end
    end
    end)
if Config.DrugDealer.Enabled then 
RegisterCommand("dealer", function()
    startDrugDeal()
end, false)

function spawnNPC(callback)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    RequestModel(Config.CrackHeadModel)
    while not HasModelLoaded(Config.CrackHeadModel) do
        Wait(1)
    end
   local  npc = CreatePed(4, Config.CrackHeadModel, coords.x + Config.SpawnDistance, coords.y + Config.SpawnDistance, coords.z, 0.0, false, true)
    TaskGoToCoordAnyMeans(npc, coords.x, coords.y, coords.z, Config.ApproachSpeed, 0, 0, 786603, 0xbf800000)
    CreateThread(function()
        local reached = false
        while not reached do
            Wait(500)
            if GetDistanceBetweenCoords(coords, GetEntityCoords(npc), true) < 2.0 then
                reached = true
            end
        end

        local animDict = 'switch@franklin@002110_04_magd_3_weed_exchange'
        local animName = '002110_04_magd_3_weed_exchange_franklin'

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(1)
        end

        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 0, 0.0, false, false, false)
        Wait(3000)  
        ClearPedTasksImmediately(playerPed)

        if callback then
            callback()
        end

        TaskGoToCoordAnyMeans(npc, coords.x + Config.SpawnDistance, coords.y + Config.SpawnDistance, coords.z, Config.ApproachSpeed, 0, 0, 786603, 0xbf800000)
        Wait(5000) 
        DeleteEntity(npc)
    end)
end
if  Config.Framework == 1 or 4 then

function startDrugDeal()
    ESX.TriggerServerCallback('getWhitelistedItemsFromPlayerInventory', function(itemsToSell)
        local numItems = #itemsToSell
        if numItems > 1 then
            lib.registerContext({
                id = 'drug_sell_menu',
                title = 'Select an item to sell',
                options = generateMenuOptions(itemsToSell)
            })

            lib.showContext('drug_sell_menu')
        elseif numItems == 1 then
            local selling = true  

            Citizen.CreateThread(function()
                while selling do 
                    spawnNPC(function()
                        if not proceedWithSelling(itemsToSell[1].name) then  
                            selling = false
                        end
                    end)

                    Wait(10000) 
                end
            end)
        else
            TriggerEvent('esx:showNotification', "You don't have any items to sell.")
        end
    end)
end
end
if   Config.Framework == 2 then
    function startDrugDeal()
    QBCore.Functions.TriggerCallback('getWhitelistedItemsFromPlayerInventory', function(itemsToSell)
        local numItems = #itemsToSell
        if numItems > 1 then
            lib.registerContext({
                id = 'drug_sell_menu',
                title = 'Select an item to sell',
                options = generateMenuOptions(itemsToSell)  
            })

            lib.showContext('drug_sell_menu')  
        elseif numItems == 1 then
            local selling = true  

            Citizen.CreateThread(function()
                while selling do 
                    spawnNPC(function()
                        if not proceedWithSelling(itemsToSell[1].name) then  
                            selling = false
                        end
                    end)

                    Wait(10000)
                end
            end)
        else
            TriggerEvent('QBCore:Notify', "You don't have any items to sell.", "error")
        end
    end)
end

end


function generateMenuOptions(itemsToSell)
    local menuOptions = {}
    for _, item in ipairs(itemsToSell) do
        table.insert(menuOptions, {
            title = item.label, 
            onSelect = function()
                spawnNPC(function()
                    
                    proceedWithSelling(item.name)

                end)  
            end,
            metadata = {
                {label = 'Item', value = item.name},
            }
        })
    end
    return menuOptions
end

function proceedWithSelling(itemID)

    
    local successRate = math.random(1, 100)

    if successRate <= 70 then
        TriggerServerEvent('sellItem', itemID)
        TriggerEvent('esx:showNotification', "You've successfully sold the item!")
        return true  
    else
        TriggerEvent('esx:showNotification', "They didn't want the bullshit.")
        return false  
    end
end

end
