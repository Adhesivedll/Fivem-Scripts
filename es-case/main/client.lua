
local display = false
function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
end


RegisterNUICallback("exit",function(data)
    SetDisplay(false)
end)

RegisterNUICallback('give', function(data) 
    TriggerServerEvent('give',source, data.case)
end)




if Config.Framework == "ESX" then
     Citizen.CreateThread(function()
     while Framework == nil do
          TriggerEvent('esx:getSharedObject', function(obj) Framework = obj end)
          Citizen.Wait(4)
     end

     RegisterNUICallback('GetGold', function(data, cb) 
        Framework.TriggerServerCallback("GoldBuy", function(result, bank)
            cb(
               {
               data = result,
               bank = bank,
               }
            )
           end, data)
       end)

         RegisterNUICallback("Purchase",function(data, cb)
         Framework.TriggerServerCallback("GetPurchase", function(result, amount)
            cb(
                {
                    variable = result,
                    amount = amount
                }
            )
         end, data)
         end)

         RegisterNUICallback('sell', function(data, cb) 
            Framework.TriggerServerCallback("GetSell", function(result, new)
                cb(
                    {
                        variable = result,
                        amount = new
                    }
                )
            end, data)
        end)
        
        RegisterNUICallback('GetCase', function(data, cb) 
            Framework.TriggerServerCallback("Case", function(result)
             cb(
                {
                check = result
                }
             )
            end, data)
        end)

        RegisterNUICallback("Check",function(data)
            Framework.TriggerServerCallback("Profile", function(gold, bank, name, avatar)
                SendNUIMessage(
                    {
                        type = "purchase",
                        gold =  gold,
                        bank =  bank,
                        name =  name,
                        avatar = avatar,
                    }
                )
            end)
        end)

        RegisterCommand('case', function()
            Framework.TriggerServerCallback("Profile", function(gold, bank, name, avatar)
                SendNUIMessage(
                    {
                        type = "purchase",
                        gold =  gold,
                        bank =  bank,
                        name =  name,
                        avatar = avatar,
                    }
                )
            end)
            SendNUIMessage(
                {
                    type = "case",
                    cases = Config.Live,
                    standart =  Config.Standart,
                    things = Config.System['Items that can be found in the safe'],
                    gold = Config.System['Store Gold Section'],
                    categories = Config.System['Case Categories']
                }
            )
            SetDisplay(true, true)
        end)
    end)


elseif Config.Framework == 'QBCore' or Config.Framework == 'OLDQBCore'  then
     if Config.Framework == "OLDQBCore" then
          while Framework == nil do
               TriggerEvent('QBCore:GetObject', function(obj) Framework = obj end)
               Citizen.Wait(4)
          end
     else  Framework = exports['qb-core']:GetCoreObject() end


     RegisterNUICallback("Purchase",function(data, cb)
        Framework.Functions.TriggerCallback("GetPurchase", function(result, amount)
            cb(
                {
                    variable = result,
                    amount = amount
                }
            )
        end, data)
        end)

        RegisterNUICallback('sell', function(data, cb) 
            Framework.Functions.TriggerCallback("GetSell", function(result, new)
                cb(
                    {
                        variable = result,
                        amount = new
                    }
                )
           end, data)
       end)
       
       RegisterNUICallback('GetCase', function(data, cb) 
        Framework.Functions.TriggerCallback("Case", function(result)
            cb(
               {
               check = result
               }
            )
           end, data)
       end)

       RegisterNUICallback("Check",function(data)
        Framework.Functions.TriggerCallback("Profile", function(gold, bank, name, avatar)
               SendNUIMessage(
                   {
                       type = "purchase",
                       gold =  gold,
                       bank =  bank,
                       name =  name,
                       avatar = avatar,
                   }
               )
           end)
       end)

       RegisterCommand('case', function()
        Framework.Functions.TriggerCallback("Profile", function(gold, bank, name, avatar)
               SendNUIMessage(
                   {
                       type = "purchase",
                       gold =  gold,
                       bank =  bank,
                       name =  name,
                       avatar = avatar,
                   }
               )
           end)
           SendNUIMessage(
               {
                   type = "case",
                   cases = Config.Live,
                   standart =  Config.Standart,
                   things = Config.System['Items that can be found in the safe'],
                   gold = Config.System['Store Gold Section'],
                   categories = Config.System['Case Categories']
               }
           )
           SetDisplay(true, true)
       end)

       RegisterNUICallback('GetGold', function(data, cb) 
        Framework.Functions.TriggerCallback("GoldBuy", function(result, bank)
            cb(
               {
               data = result,
               bank = bank,
               }
            )
           end, data)
       end)

                
    end



