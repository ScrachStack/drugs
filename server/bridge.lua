if GetResourceState('es_extended') ~= 'missing' then
    esx = false 
else 
    esx = true
end
if esx then 
    CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end)
    Config.Framework = 1
else 
    
end
if GetResourceState('qb-core') ~= 'missing' then
    qb = false
else 
    qb = true
    local QBCore = exports['qb-core']:GetCoreObject()
    Config.Framework = 2
end