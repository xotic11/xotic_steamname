Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Config.ESX                           = nil

local PlayerData              = {}

Citizen.CreateThread(function ()
    while Config.ESX == nil do
        TriggerEvent('Config.esx:getSharedObject', function(obj) Config.ESX = obj end)
        Citizen.Wait(1)
    end

    while Config.ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = Config.ESX.GetPlayerData()

end)

RegisterNetEvent(Config.esx .. ':playerLoaded')
AddEventHandler(Config.esx .. ':playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	if not Config.usecommand then
	  blip = AddBlipForCoord(Config.position.x, Config.position.y, Config.position.z)
		SetBlipSprite(blip, 521)
		SetBlipColour(blip, 4)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Steamreward")
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords  = GetEntityCoords(GetPlayerPed(-1))
		if(GetDistanceBetweenCoords(coords, Config.position.x, Config.position.y, Config.position.z, 331, true) < 2) then
			MarkerEntered  = true
		else
			MarkerEntered = false
		end
		if MarkerEntered and not Config.usecommand then                    
            Config.ESX.ShowHelpNotification(Config.enteredmarkermessage)
            if IsControlPressed(0, 38) then
				TriggerEvent('xotic_steamname:anzeigen')
				Wait(1000)
            end
		end
	end
end)

Citizen.CreateThread(function()
	if not Config.usecommand then
    RequestModel(GetHashKey("csb_chin_goon"))
	
    while not HasModelLoaded(GetHashKey("csb_chin_goon")) do
        Wait(1)
    end
	
		local npc = CreatePed(4, 0xA8C22996, Config.position.x, Config.position.y, Config.position.z, 360, false, true)
			
		SetEntityHeading(npc, 318)
		FreezeEntityPosition(npc, true)
		SetEntityInvincible(npc, true)
		SetBlockingOfNonTemporaryEvents(npc, true)
end
end)

RegisterNUICallback('einloesen', function(data, cb)
   SetNuiFocus(false, false)
   TriggerEvent('xotic_steamname:belohnung')
	PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)

RegisterNUICallback('verlassen', function(data, cb)
	SetNuiFocus(false, false)
	 PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
 end)

RegisterNetEvent('xotic_steamname:anzeigen')
AddEventHandler('xotic_steamname:anzeigen', function(zeigen)
    SendNUIMessage({
        zeigen = zeigen,
    })

    SetNuiFocus(true, true)
end)

RegisterCommand("steamreward", function(source, args, rawCommand)
    if Config.usecommand then
		TriggerEvent('xotic_steamname:anzeigen')
	end
end, false)


RegisterNetEvent('xotic_steamname:belohnung')
AddEventHandler('xotic_steamname:belohnung', function(source)
	local id = PlayerId()
	local playerName = GetPlayerName(id)
		if string.find(GetPlayerName(PlayerId()), Config.steamname) then
		PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
		Config.ESX.ShowNotification(Config.eingeloest)
		TriggerServerEvent("xotic_steamname:check")
	else
		Config.ESX.ShowNotification(Config.error)
	end

end)