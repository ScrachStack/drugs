local player = cache.ped or PlayerPedId()

RegisterNetEvent('esx_drug_effects:startcokeeffect')
AddEventHandler('esx_drug_effects:startcokeeffect', function()
    TaskStartScenarioInPlace(player, "WORLD_HUMAN_SMOKING_POT", 0, false)
    local armor = GetPedArmour(player)
    SetPedArmour(player, armor + 25)
    SetPedIsDrunk(playerPed, true)
    SetTimecycleModifier("spectator5")
    AnimpostfxPlay("Rampage", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 1.5)
    Citizen.Wait(10000) -- 120 seconds

    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)

end)

RegisterNetEvent('esx_drug_effects:startxanaxeffect')
AddEventHandler('esx_drug_effects:startxanaxeffect', function()
    TaskStartScenarioInPlace(player, "WORLD_HUMAN_SMOKING_POT", 0, false)
    local armor = GetPedArmour(player)
    SetPedArmour(player, armor + 25)
    SetPedIsDrunk(playerPed, true)
    SetTimecycleModifier("spectator5")
    AnimpostfxPlay("Rampage", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 1.5)
    Citizen.Wait(10000) -- 120 seconds
    SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)

end)

RegisterNetEvent('esx_drug_effects:startWeedEffect')
AddEventHandler('esx_drug_effects:startWeedEffect', function()
    TaskStartScenarioInPlace(player, "WORLD_HUMAN_SMOKING_POT", 0, true)
    local armor = GetPedArmour(player)
    SetPedArmour(player, armor + 10)
    StartScreenEffect("ChopVision", 3.0, 0)
    Citizen.Wait(10000)  -- 10 seconds
    StopScreenEffect("ChopVision")
    ClearPedTasks(player)
end)


RegisterNetEvent('esx_drug_effects:startLeanEffect')
AddEventHandler('esx_drug_effects:startLeanEffect', function()
    TaskStartScenarioInPlace(player, "WORLD_HUMAN_SMOKING_POT", 0, true)
    local armor = GetPedArmour(player)
    SetPedArmour(player, armor + 10)
    StartScreenEffect("ChopVision", 3.0, 0)
    Citizen.Wait(10000)  
    StopScreenEffect("ChopVision")
    ClearPedTasks(player)
end)




