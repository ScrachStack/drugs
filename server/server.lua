


RegisterServerEvent("harvestDrug")
AddEventHandler("harvestDrug", function(drug, playerCoords)
    local source = source 
    if Config.Framework == 1 or 4 then
     xPlayer = ESX.GetPlayerFromId(source)
elseif Config.Framework == 2 then
    xPlayer = QBCore.Functions.GetPlayer(source)
elseif Config.Framework == 3 then
    xPlayer = NDCore.Functions.GetPlayer(source)

    end
     
    if xPlayer then
        local properties = Config.Drugs[drug]
        local distance = #(vector3(properties.harvestLocation.x, properties.harvestLocation.y, properties.harvestLocation.z) - vector3(playerCoords.x, playerCoords.y, playerCoords.z))
        if distance > 10 then  
            if Config.Framework == 1 or 4 then

            TriggerClientEvent('esx:showNotification', source, "You are too far away.")
            end
            return
        end
        
   
        for rewardItem, rewardAmount in pairs(properties.harvestRewards) do
            if Framework == 1 or Framework == 4 then
                local xPlayer = ESX.GetPlayerFromId(source)
                xPlayer.addInventoryItem(rewardItem, rewardAmount)
            elseif Framework == 2 then
                xPlayer = QBCore.Functions.GetPlayer(source)
                exports.ox_inventory:AddItem(xPlayer, rewardItem, rewardAmount, nil, nil, function()
                end)
              
            elseif Framework == 3 then
                xPlayer = NDCore.Functions.GetPlayer(source)
                exports.ox_inventory:AddItem(xPlayer, rewardItem, rewardAmount, nil, nil, function()
                end)
            end
        
        end
        if Config.Framework == 1 or 4 then
        TriggerClientEvent('esx:showNotification', source, "You have received rewards for harvesting " .. drug)
        else 

    end
    end
end)
RegisterServerEvent("processDrug")
AddEventHandler("processDrug", function(drug)
    local source = source 
    local properties = Config.Drugs[drug]
    if Config.Framework == 1 or 4 then
        xPlayer = ESX.GetPlayerFromId(source)
   elseif Config.Framework == 2 then
       xPlayer = QBCore.Functions.GetPlayer(source)
   elseif Config.Framework == 3 then
       xPlayer = NDCore.Functions.GetPlayer(source)
       end
    if properties and xPlayer then
        local rawMaterialCount = xPlayer.getInventoryItem(drug).count
        if rawMaterialCount > 0 then
            Citizen.Wait(properties.processTime)
            xPlayer.removeInventoryItem(drug, 1)
            for rewardItem, rewardAmount in pairs(properties.processRewards) do
                if Framework == 1 or Framework == 4 then
                    local xPlayer = ESX.GetPlayerFromId(source)
                    xPlayer.addInventoryItem(rewardItem, rewardAmount)
                elseif Framework == 2 then
                    xPlayer = QBCore.Functions.GetPlayer(source)
                    exports.ox_inventory:AddItem(xPlayer, rewardItem, rewardAmount, nil, nil, function()
                    end)
                elseif Framework == 3 then
                    xPlayer = NDCore.Functions.GetPlayer(source)
                    exports.ox_inventory:AddItem(xPlayer, rewardItem, rewardAmount, nil, nil, function()
                    end)
                end
            end
            if Config.Framework == 1 or 4 then
            TriggerClientEvent('esx:showNotification', source, 'You have processed some ' .. drug)
            end
        else
            if Config.Framework == 1 or 4 then
 
            TriggerClientEvent('esx:showNotification', source, 'You don\'t have any ' .. drug .. ' to process')
            end
        end
    end
end)



RegisterServerEvent("sellDrug")
AddEventHandler("sellDrug", function(drug)
    local source = source  
    local properties = Config.Drugs[drug]
    
    if Config.Framework == 1 or Config.Framework == 4 then
        xPlayer = ESX.GetPlayerFromId(source)
    elseif Config.Framework == 2 then
        xPlayer = QBCore.Functions.GetPlayer(source)
    elseif Config.Framework == 3 then
        xPlayer = NDCore.Functions.GetPlayer(source)
    end

    local processedDrug = properties.processRewards and next(properties.processRewards)

    if properties and xPlayer and processedDrug then
        local drugCount = xPlayer.getInventoryItem(processedDrug).count
        if drugCount > 0 then
            xPlayer.removeInventoryItem(processedDrug, 1)
            
            if Config.Framework == 1 or Config.Framework == 4 then
                xPlayer.addMoney(properties.sellPrice)
            elseif Config.Framework == 2 then
                Player.Functions.AddMoney('cash', properties.sellPrice)
            elseif Config.Framework == 3 then
                NDCore.Functions.AddMoney(amount, source, "cash", "Sold Processed Drugs")
            end
            
            if Config.Framework == 1 or Config.Framework == 4 then
                TriggerClientEvent('esx:showNotification', source, 'You have sold some processed ' .. drug)
            end
        else
            if Config.Framework == 1 or Config.Framework == 4 then
                TriggerClientEvent('esx:showNotification', source, 'You don\'t have any processed ' .. drug .. ' to sell')
            end
        end
    end
end)
if Config.Framework == 1 or 4 then

-- ESX.RegisterUsableItem('weed', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     if xPlayer.getInventoryItem('lighter').count > 0 then

--     xPlayer.removeInventoryItem('weed', 1)
--     TriggerClientEvent('esx_drug_effects:startWeedEffect', source)
--     else 
--         TriggerClientEvent('esx:showNotification', source, 'You need a lighter to use the weed!')

-- end 
-- end)

for itemName, itemConfig in pairs(Config.UsableItems) do
    ESX.RegisterUsableItem(itemName, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

        local canUse = true

        -- Convert to numeric loop for checking requirements
        for i = 1, #itemConfig.requirements do
            local req = itemConfig.requirements[i]
            if xPlayer.getInventoryItem(req.item).count <= 0 then
                TriggerClientEvent('esx:showNotification', source, req.label)
                canUse = false
                break
            end
        end

        if canUse then
            -- Convert to numeric loop for removing items
            for i = 1, #itemConfig.removeItems do
                local removeItem = itemConfig.removeItems[i]
                xPlayer.removeInventoryItem(removeItem.item, removeItem.count)
            end

            TriggerClientEvent('esx:showNotification', source, itemConfig.notification)

            -- Convert to numeric loop for adding items
            for i = 1, #itemConfig.addItems do
                local addItem = itemConfig.addItems[i]
                xPlayer.addInventoryItem(addItem.item, addItem.count)
            end

            if itemConfig.clientEffect then
                TriggerClientEvent(itemConfig.clientEffect, source)
            end
        end
    end)
end
ESX.RegisterServerCallback('getWhitelistedItemsFromPlayerInventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.inventory 
    
    local whitelistedItems = {} 

    for drugName, _ in pairs(Config.Drugs) do
        whitelistedItems[drugName] = true
    end
    
    local itemsToSell = {}
    for i = 1, #items do
        local item = items[i]
        if item.count > 0 and whitelistedItems[item.name] then
            table.insert(itemsToSell, {name = item.name, label = item.label})
        end
    end

    cb(itemsToSell)
end)

end
RegisterNetEvent('sellItem')
AddEventHandler('sellItem', function(itemID)
if Config.Framework == 1 or 4 then
    local xPlayer = ESX.GetPlayerFromId(source)
elseif Config.Framework == 2 then
    xPlayer = QBCore.Functions.GetPlayer(source)
elseif Config.Framework == 3 then
    xPlayer = NDCore.Functions.GetPlayer(source)
end 
    if xPlayer.getInventoryItem(itemID).count > 0 then
        local price = math.random(10, 100) 
        xPlayer.removeInventoryItem(itemID, 1)
        xPlayer.addMoney(price)
        
        TriggerClientEvent('esx:showNotification', xPlayer.source, "You've successfully sold the item for $" .. price)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "You don't have this item to sell!")
    end
end)

if   Config.Framework == 2 then
for itemName, itemConfig in pairs(Config.UsableItems) do
    QBCore.Functions.CreateUseableItem(itemName, function(source)
        local Player = QBCore.Functions.GetPlayer(source)

        local canUse = true

        for _, req in pairs(itemConfig.requirements) do
            if Player.Functions.GetItemByName(req.item) == nil then
                TriggerClientEvent('QBCore:Notify', source, req.label, 'error')
                canUse = false
                break
            end
        end

        if canUse then
            for _, removeItem in pairs(itemConfig.removeItems) do
                Player.Functions.RemoveItem(removeItem.item, removeItem.count)
            end

            TriggerClientEvent('QBCore:Notify', source, itemConfig.notification, 'success')

            for _, addItem in pairs(itemConfig.addItems) do
                Player.Functions.AddItem(addItem.item, addItem.count)
            end

            if itemConfig.clientEffect then
                TriggerClientEvent(itemConfig.clientEffect, source)
            end
        end
    end)
end

QBCore.Functions.CreateCallback('getWhitelistedItemsFromPlayerInventory', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local items = Player.PlayerData.items

    local whitelistedItems = {}

    for drugName, _ in pairs(Config.Drugs) do
        whitelistedItems[drugName] = true
    end

    local itemsToSell = {}
    for _, item in pairs(items) do
        if item.amount > 0 and whitelistedItems[item.name] then
            table.insert(itemsToSell, {name = item.name, label = QBCore.Shared.Items[item.name]["label"]})
        end
    end

    cb(itemsToSell)
end)
end