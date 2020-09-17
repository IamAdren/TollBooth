ESX = nil
local blip
local speedZone
local speedzones = {}
local CurrentAction = nil
local HasAlreadyEnteredMarker = false
local LastZone = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while not ESX.GetPlayerData().job do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	PlayerData = ESX.GetPlayerData()

	for k,v in ipairs(Config.BlipZones) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)

		if true== true then
			SetBlipHighDetail(blip, true)
			SetBlipSprite (blip, Config.Blips.Sprite)
			SetBlipScale	(blip, Config.Blips.Scale)
			SetBlipColour (blip, Config.Blips.Color)
			SetBlipAsShortRange(blip, true)
			
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.Blips.Name)
			EndTextCommandSetBlipName(blip)
		end

		if v.speed == true then
			TriggerServerEvent('matt_ZoneActivated', 'New Tollbooth', Config.Speed, Config.Radius, v.x, v.y, v.z)
		end
	end
end)

RegisterNetEvent('matt_Zone')
AddEventHandler('matt_Zone', function(speed, radius, x, y, z)
	speedZone = AddSpeedZoneForCoord(x, y, z, radius, speed, false)
	table.insert(speedzones, {x, y, z, speedZone, blip})
end)

AddEventHandler('matt_hasEnteredMarker', function (zone)
  	if zone ~= nil then
    	CurrentAction = 'toll'
  	end
end)
	
AddEventHandler('matt_hasExitedMarker', function (zone)
	CurrentAction = nil
end)

Citizen.CreateThread(function (source)
	while true do
		Citizen.Wait(Config.TickRateMS)
	
		local playerPed = GetPlayerPed(-1)
		local coords = GetEntityCoords(playerPed)
		
		if CurrentAction ~= nil then
			if IsPedInAnyVehicle(playerPed, false) then
				local ped = GetPlayerPed( -1 )
				local pos = GetEntityCoords( ped )
				local vehicle = GetVehiclePedIsIn( ped, false )
				local vehicleP = GetVehicleNumberPlateText(vehicle)

				for k,v in ipairs(Config.BlipZones) do
					if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 125 then
						ESX.TriggerServerCallback('matt_vehicleStatus', function(status)
							print(v.id)
							if status == true then
								ESX.TriggerServerCallback('matt_PayToll', function(ret)
									if ret == true then
										ESX.ShowNotification("<b>Toll Notification:</b> Payed ~g~125$")
									else 
										TriggerServerEvent('matt_alert', vehicleP, 'failure', v.name, v.id)
									end
								end, Config.TollPrice, v.id)
							elseif status == false then
								--local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(-1))
								if GetVehicleClass(vehicle) == 18 then
									if Config.IgnoreEmergencyVehicles then
										return
									end
								else
									TriggerServerEvent('matt_alert', vehicleP, 'stolen', v.name, v.id)
								end
								if Config.useCameraSound == true then
									TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
								end
								if Config.useCameraFlash == true then	
									TriggerEvent('matt_openGUI')
									Citizen.Wait(200)
									TriggerEvent('matt_closeGUI')
								end
							end
						end, vehicleP)
					end
				end
			end
		end
	end			 
end)

Citizen.CreateThread(function ()
	while true do
		Wait(0)
		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker = false
		local currentZone = nil
		
		for k,v in ipairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords,v.x, v.y, v.z, true) < 8) then
				isInMarker  = true
				currentZone = k

				if Config.DevMode then
					DrawMarker(21, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 255, 255, 255, 255, false, true, 2, false, false, false, false)
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('matt_hasEnteredMarker', currentZone, Location)
		end
		
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('matt_hasExitedMarker', LastZone)
		end

	end
end)

RegisterNetEvent('matt_openGUI')
AddEventHandler('matt_openGUI', function()
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openSpeedcamera'})
end)   

RegisterNetEvent('matt_closeGUI')
AddEventHandler('matt_closeGUI', function()
    SendNUIMessage({type = 'closeSpeedcamera'})
end)