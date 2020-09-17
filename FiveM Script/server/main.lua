ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('matt_ZoneActivated')
AddEventHandler('matt_ZoneActivated', function(message, speed, radius, x, y, z)
    TriggerClientEvent('matt_Zone', -1, speed, radius, x, y, z)
end)

ESX.RegisterServerCallback('matt_vehicleStatus', function(source, cb, plate)
	local identifier = GetPlayerIdentifiers(source)[1]
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate
		},
		function(result)

			local found = false

			for i=1, #result, 1 do

				local vehicleProps = result[i].carplate

				if vehicleProps == vehPlate then
					found = true
					break
				end

			end

			if found then
				cb(true)
			else
				cb(false)
			end

		end
	)
end)

ESX.RegisterServerCallback('matt_PayToll', function(source, cb, price, id)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)

		cb(true)

		if Config.UseSQL then 
			MySQL.Async.fetchAll('SELECT * FROM toll_booth_stats WHERE id = @id', {
				['@id'] = id
			},
			function (result)
				local successfulStops = result[1].successful
				MySQL.Async.execute('UPDATE toll_booth_stats SET successful = @successful WHERE id = @id', {
					['@id'] = id,
					['@successful'] = successfulStops + 1
				}, function(rowsChanged)
					local newValue = successfulStops + 1
					if Config.DevMode then
						print('[TollBooth] Succesfull Car went through Toll Booth ID: ' .. id .. ' New Value: ' .. newValue)
					end	
				end)
			end)
		end
	else
		cb(false)
	end
end)

RegisterServerEvent('matt_alert')
AddEventHandler('matt_alert', function(plate, reason, toll, id)
	local _source = source
	local xPlayers = ESX.GetPlayers()

	if Config.UseDiscordBot then
		TriggerEvent("matt_discordbot:tollAlert", plate, reason, toll, id)
	end

	if Config.UseSQL then 
		MySQL.Async.fetchAll('SELECT * FROM toll_booth_stats WHERE id = @id', {
			['@id'] = id
		},
		function (result)
			local failureToPay = result[1].failure
			local stolenVehicles = result[1].stolen
			if reason == 'stolen' then
				MySQL.Async.execute('UPDATE toll_booth_stats SET stolen = @stolen WHERE id = @id', {
					['@id'] = id,
					['@stolen'] = stolenVehicles + 1
				}, function(rowsChanged)
					local newValue = stolenVehicles + 1
					if Config.DevMode then
						print('[TollBooth] Toll Booth ID: ' .. id .. ' Stolen Vehicles updated to ' .. newValue)
					end
				end)
			elseif reason == 'failure' then
				MySQL.Async.execute('UPDATE toll_booth_stats SET failure = @failure WHERE id = @id', {
					['@id'] = id,
					['@failure'] = failureToPay + 1
				}, function(rowsChanged)
					local newValue = failureToPay + 1
					if Config.DevMode then
						print('[TollBooth] Toll Booth ID: ' .. id .. ' Failure To Pay Table updated to ' .. newValue)
					end
				end)
			end
		end)
	end

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer.job.name == 'police' then
			if reason == 'stolen' then
				TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'STOLEN VEHICLE', 'at ' .. toll, 'Vehicle with the License Plate ~r~ ' .. plate ..'~s~ has been spotted at <b>' .. toll, 'CHAR_CALL911', 1)
			elseif reason == 'failure' then
				TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Failure to Pay Toll', 'at ' .. toll, 'Vehicle with the License Plate ~r~ ' .. plate ..'~s~ at <b>' .. toll, 'CHAR_CALL911', 1)
			end
		end
	end
end)
