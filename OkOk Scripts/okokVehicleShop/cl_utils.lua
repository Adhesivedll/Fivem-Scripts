local QBCore = exports["qb-core"]:GetCoreObject()

RegisterNetEvent(Config.EventPrefix..":giveKeys")
AddEventHandler(Config.EventPrefix..":giveKeys", function(vehicle)
	TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehicle))
end)

RegisterNetEvent(Config.EventPrefix..":notification")
AddEventHandler(Config.EventPrefix..":notification", function(notifyName, text)
	local data = Config.NotificationsText[notifyName]

	exports['okokNotify']:Alert(data.title, text, data.time, data.type)
end)
