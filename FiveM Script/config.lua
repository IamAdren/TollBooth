Config = {}
Config.Locale = 'en'
Config.Radius = 135.0
Config.Speed = 10.0 -- Speed at which A.I will drive through the tolls
Config.Blips = {Color = 1, Sprite = 79, Scale = 0.6, Name = 'Toll Booth'}
Config.TollPrice = 125 -- Price per time the user goes through the toll.
Config.TickRateMS = 1250 -- Every set amount of time it will check. If you are having FPS problems with the script it is suggested you turn down the MS rate

Config.DevMode = false -- If set as true it will draw markers for Config.Zones

Config.UseDiscordBot = true -- If you have purchased the Discord Bot from Sheriff Matt this script supports Discord! Look into the Discord bot config for more info.

Config.useCameraSound = true -- If the vehicle comes back as stolen then it will send a camera flash sound effect
Config.useCameraFlash = true -- If the vehicle comes back as stolen then it will send a mock camera flash effect

Config.UseSQL = true -- This will log everytime a stolen vehicle comes through, ETC more info on the README

Config.IgnoreEmergencyVehicles = true -- If the vehicle is classed as emergency then it will be ignored

-- Lane Zones -- 
-- Lane Zones are for lane in the road.

Config.Zones = {
	vector3(2429.41, -187.62, 87.5),
	vector3(2425.13, -184.62, 87.46),
	vector3(2435.68, -209.49, 86.75),
	vector3(2430.29, -206.43, 86.73),
	
	vector3(1310.88, 588.94, 80.17),
	vector3(1306.93, 592.87, 80.18),
	vector3(1319.98, 616.62, 80.31),
	vector3(1315.41, 621.53, 80.27),
	
	vector3(-2437.91, -238.47, 16.35),
	vector3(-2440.77, -244.3, 16.29),
	vector3(-2411.58, -243.92, 15.64),
	vector3(-2407.8, -239.41, 15.55),
}

-- Blip Zones -- 
-- Blip zones are for each "Toll Station"

Config.BlipZones = {
	{id = 1, x = -2424.94, y = -240.95, z = 16.0, speed = true, speedRadius = true, name = 'Great Ocean Toll Booth'},
	{id = 2, x = 1310.12,  y = 601.01, z = 80.06, speed = true, speedRadius = true, name = 'Route 13 Toll Booth'},
	{id = 3, x = 2429.63,  y = -198.48, z = 87.03, speed = true, speedRadius = true, name = 'Route 15 Toll Booth'}
}