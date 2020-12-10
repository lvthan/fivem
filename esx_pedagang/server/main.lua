ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'pedagang', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'pedagang', _U('pedagang_customer'), true, true)
TriggerEvent('esx_society:registerSociety', 'pedagang', 'pedagang', 'society_pedagang', 'society_pedagang', 'society_pedagang', {type = 'private'})



RegisterServerEvent('esx_pedagangjob:getStockItem')
AddEventHandler('esx_pedagangjob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pedagang', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Quantity Invalid!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
      --TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Kamu Mangembil Barang!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
    --TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)

  end)

end)

RegisterServerEvent('esx_pedagangjob:Billing')--Not Working...
AddEventHandler('esx_pedagangjob:Billing', function(money, player)

  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(player)
  local valor = money

    if xTarget.getMoney() >= valor then
      xTarget.removeMoney(valor)
      xPlayer.addMoney(valor)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, "O seu cliente nao tem esse dinheiro, valor: " ..valor)
	  TriggerClientEvent('esx:showNotification', xTarget.source, "Voce nao tem esse dinheiro, valor: " ..valor)
    end
end)--Not Working

ESX.RegisterServerCallback('esx_pedagangjob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pedagang', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_pedagangjob:putStockItems')
AddEventHandler('esx_pedagangjob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pedagang', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Invalid Quantity!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
      --TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end
    TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Anda Memasukan Barang!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
    --TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)


RegisterServerEvent('esx_pedagangjob:getFridgeStockItem')
AddEventHandler('esx_pedagangjob:getFridgeStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pedagang_fridge', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Quantity Invalid!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
      --TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end
    TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Anda Mengambil Barang!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
    --TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_removed') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_pedagangjob:getFridgeStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pedagang_fridge', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_pedagangjob:putFridgeStockItems')
AddEventHandler('esx_pedagangjob:putFridgeStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pedagang_fridge', function(inventory)

    local item = inventory.getItem(itemName)
    local playerItemCount = xPlayer.getInventoryItem(itemName).count

    if item.count >= 0 and count <= playerItemCount then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Invalid Quantity!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
      --TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_quantity'))
    end

    TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Anda Memasukkan Barang!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
    --TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_added') .. count .. ' ' .. item.label)

  end)

end)


RegisterServerEvent('esx_pedagangjob:buyItem')
AddEventHandler('esx_pedagangjob:buyItem', function(itemName, price, itemLabel)

    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local weight = xPlayer.getInventoryItem(itemName).weight
    local qtty = xPlayer.getInventoryItem(itemName).count
    local societyAccount = nil

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pedagang', function(account)
        societyAccount = account
      end)
    
    if societyAccount ~= nil and societyAccount.money >= price then
        if qtty < weight then
            societyAccount.removeMoney(price)
            xPlayer.addInventoryItem(itemName, 1)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Anda Membeli Barang!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
            --TriggerClientEvent('esx:showNotification', _source, _U('bought') .. itemLabel)
        else
          TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Kantong Anda Tidak Cukup!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
            --TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
        end
    else
      TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Uang Anda Tidak Cukup!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
        --TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
    end

end)


RegisterServerEvent('esx_pedagangjob:craftingCoktails')
AddEventHandler('esx_pedagangjob:craftingCoktails', function(Value)

    local _source = source
    local escolha = Value       
		if escolha == "hamburger" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('tomat').count
            local bethQuantity      = xPlayer.getInventoryItem('meat').count
            local gammaQuantity      = xPlayer.getInventoryItem('bread').count

            if alephQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Tidak ada tomat!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Keju Potong~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Tidak ada meat!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Hamburger Beku~w~")
              elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Tidak ada bread!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Hamburger Beku~w~")
            else
              TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Memasak hamburger!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
              --TriggerClientEvent('esx:showNotification', _source, "Memasak ~b~Hamburger Biasa~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(20000)
                    TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Selesai Memasak Hamburger!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                    --TriggerClientEvent('esx:showNotification', _source, "Hamburger Biasa ~g~lista~w~")
                    xPlayer.removeInventoryItem('tomat', 3)
                    xPlayer.removeInventoryItem('meat', 5)
                    xPlayer.removeInventoryItem('bread', 2)
                    xPlayer.addInventoryItem('hamburger', 5)
            end
          elseif escolha == "salad" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('selada').count
            local bethQuantity      = xPlayer.getInventoryItem('tomat').count
            local gammaQuantity      = xPlayer.getInventoryItem('wortel').count

            if alephQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada selada!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Air~w~")
              elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada tomat!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Hamburger Beku~w~")
              elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada wortel!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Hamburger Beku~w~")
            else
              TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Membuat salad!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
              --TriggerClientEvent('esx:showNotification', _source, "Persiapan ~b~kopi Berhasil~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(25000)
              TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Selesai membuat salad!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })   
                    --TriggerClientEvent('esx:showNotification', _source, "Kopi Berhasil ~g~lista~w~")
                    xPlayer.removeInventoryItem('selada', 5)
                    xPlayer.removeInventoryItem('tomat', 2)
                    xPlayer.removeInventoryItem('wortel', 3)
                    xPlayer.addInventoryItem('salad', 5)
            end
          elseif escolha == "nasgor" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('nasi').count
            local bethQuantity      = xPlayer.getInventoryItem('tomat').count
            local gammaQuantity      = xPlayer.getInventoryItem('meat').count

            if alephQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada nasi!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Air~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada tomat!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Bubuk~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada meat!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Hamburger Beku~w~")
            else
              TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Membuat nasi goreng!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
              --TriggerClientEvent('esx:showNotification', _source, "Persiapan ~b~espresso Berhasil~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(25000)
              TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Selesai membuat nasi goreng!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })   
                    --TriggerClientEvent('esx:showNotification', _source, "espresso Berhasil ~g~lista~w~")
                    xPlayer.removeInventoryItem('nasi', 3)
                    xPlayer.removeInventoryItem('tomat', 4)
                    xPlayer.removeInventoryItem('meat', 3)
                    xPlayer.addInventoryItem('nasgor', 8)
            end
          elseif escolha == "nasbung" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('nasi').count
            local bethQuantity      = xPlayer.getInventoryItem('selada').count
            local gammaQuantity      = xPlayer.getInventoryItem('meat').count

            if alephQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada nasi!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Air~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada selada!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Bubuk~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada meat!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Hamburger Beku~w~")
            else
              TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Membuat nasi bungkus!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
              --TriggerClientEvent('esx:showNotification', _source, "Persiapan ~b~espresso Berhasil~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(25000)
              TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Selesai membuat nasi bungkus!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })   
                    --TriggerClientEvent('esx:showNotification', _source, "espresso Berhasil ~g~lista~w~")
                    xPlayer.removeInventoryItem('nasi', 3)
                    xPlayer.removeInventoryItem('selada', 4)
                    xPlayer.removeInventoryItem('meat', 3)
                    xPlayer.addInventoryItem('nasbung', 5)
            end
          elseif escolha == "rotbar" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('bread').count
            local bethQuantity      = xPlayer.getInventoryItem('chocolate').count
            local gammaQuantity      = xPlayer.getInventoryItem('mentega').count

            if alephQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada bread!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Air~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada chocolate!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Bubuk~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada mentega!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Hamburger Beku~w~")
            else
              TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Membuat bread bakar!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
              --TriggerClientEvent('esx:showNotification', _source, "Persiapan ~b~espresso Berhasil~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(25000)
              TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Selesai membuat bread bakar!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })   
                    --TriggerClientEvent('esx:showNotification', _source, "espresso Berhasil ~g~lista~w~")
                    xPlayer.removeInventoryItem('bread', 5)
                    xPlayer.removeInventoryItem('chocolate', 3)
                    xPlayer.removeInventoryItem('mentega', 1)
                    xPlayer.addInventoryItem('rotbar', 5)
            end
          elseif escolha == "kengor" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('kentang').count
            local bethQuantity      = xPlayer.getInventoryItem('water').count
            local gammaQuantity      = xPlayer.getInventoryItem('tomat').count

            if alephQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada kanteng!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Air~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada air!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Bubuk~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada tomat!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Hamburger Beku~w~")
            else
              TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Membuat kentang rebus!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
              --TriggerClientEvent('esx:showNotification', _source, "Persiapan ~b~espresso Berhasil~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(25000)
              TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Selesai membuat kentang rebus!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })   
                    --TriggerClientEvent('esx:showNotification', _source, "espresso Berhasil ~g~lista~w~")
                    xPlayer.removeInventoryItem('kentang', 5)
                    xPlayer.removeInventoryItem('water', 4)
                    xPlayer.removeInventoryItem('tomat', 1)
                    xPlayer.addInventoryItem('kengor', 10)
            end
          elseif escolha == "nuggets" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('meat').count
            local bethQuantity      = xPlayer.getInventoryItem('water').count
            local gammaQuantity      = xPlayer.getInventoryItem('mentega').count

            if alephQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada meat!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Air~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada air!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Bubuk~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada mentega!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Hamburger Beku~w~")
            else
              TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Membuat nugget!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
              --TriggerClientEvent('esx:showNotification', _source, "Persiapan ~b~espresso Berhasil~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(25000)
              TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Selesai membuat nugget!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })   
                    --TriggerClientEvent('esx:showNotification', _source, "espresso Berhasil ~g~lista~w~")
                    xPlayer.removeInventoryItem('meat', 3)
                    xPlayer.removeInventoryItem('water', 4)
                    xPlayer.removeInventoryItem('mentega', 2)
                    xPlayer.addInventoryItem('nuggtes', 10)
            end
          elseif escolha == "coffe" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('b_kopi').count
            local bethQuantity      = xPlayer.getInventoryItem('water').count

            if alephQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada biji kopi!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Air~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada air!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Bubuk~w~")
            else
              TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Membuat kopi!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
              --TriggerClientEvent('esx:showNotification', _source, "Persiapan ~b~espresso Berhasil~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(25000)
              TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Selesai membuat kopi!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })   
                    --TriggerClientEvent('esx:showNotification', _source, "espresso Berhasil ~g~lista~w~")
                    xPlayer.removeInventoryItem('b_kopi', 3)
                    xPlayer.removeInventoryItem('water', 4)
                    xPlayer.addInventoryItem('coffe', 5)
            end
          elseif escolha == "icetea" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('d_teh').count
            local bethQuantity      = xPlayer.getInventoryItem('water').count

            if alephQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada daun teh!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Air~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada air!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Bubuk~w~")
            else
              TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Membuat es teh!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
              --TriggerClientEvent('esx:showNotification', _source, "Persiapan ~b~espresso Berhasil~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(25000)
              TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Selesai membuat es teh!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })   
                    --TriggerClientEvent('esx:showNotification', _source, "espresso Berhasil ~g~lista~w~")
                    xPlayer.removeInventoryItem('d_teh', 3)
                    xPlayer.removeInventoryItem('water', 4)
                    xPlayer.addInventoryItem('icetea', 5)
            end
          elseif escolha == "jusapel" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('apel').count
            local bethQuantity      = xPlayer.getInventoryItem('water').count

            if alephQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada apel!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Air~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada air!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Bubuk~w~")
            else
              TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Membuat jus apel!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
              --TriggerClientEvent('esx:showNotification', _source, "Persiapan ~b~espresso Berhasil~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(25000)
              TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Selesai membuat jus apel!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })   
                    --TriggerClientEvent('esx:showNotification', _source, "espresso Berhasil ~g~lista~w~")
                    xPlayer.removeInventoryItem('apel', 3)
                    xPlayer.removeInventoryItem('water', 4)
                    xPlayer.addInventoryItem('jusapel', 5)
            end
          elseif escolha == "jusmelon" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('melon').count
            local bethQuantity      = xPlayer.getInventoryItem('water').count

            if alephQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada melon!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Air~w~")
            elseif bethQuantity < 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Tidak ada air!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
                --TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Bubuk~w~")
            else
              TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Membuat jus melon!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })
              --TriggerClientEvent('esx:showNotification', _source, "Persiapan ~b~espresso Berhasil~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(25000)
              TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Selesai membuat jus melon!', length = 2500, style = { ['background-color'] = '#007dd1', ['color'] = '#ffffff' } })   
                    --TriggerClientEvent('esx:showNotification', _source, "espresso Berhasil ~g~lista~w~")
                    xPlayer.removeInventoryItem('melon', 3)
                    xPlayer.removeInventoryItem('water', 4)
                    xPlayer.addInventoryItem('jusmelon', 5)
            end
  elseif escolha == "ctomato" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('tomato').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Tomat~w~")
            else
              TriggerClientEvent('esx:showNotification', _source, "Memotong ~b~tomat~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(15000)
                    TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('esx:showNotification', _source, "Rodajas de tomate estan ~g~listas~w~")
                    xPlayer.removeInventoryItem('tomato', 1)
                    xPlayer.addInventoryItem('ctomato', 4)
            end
  elseif escolha == "clettuce" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('lettuce').count

            if alephQuantity < 2 then
                TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Salada~w~")
            else
              TriggerClientEvent('esx:showNotification', _source, "Memotong ~b~Salada~w~")
              TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(15000)
                    TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('esx:showNotification', _source, "Hojas de lechuga estan ~g~listas~w~")
                    xPlayer.removeInventoryItem('lettuce', 1)
                    xPlayer.addInventoryItem('clettuce', 4)
            end
  elseif escolha == "ccheese" then
            local xPlayer           = ESX.GetPlayerFromId(_source)

            local alephQuantity     = xPlayer.getInventoryItem('cheese').count

            if alephQuantity < 1 then
                TriggerClientEvent('esx:showNotification', _source, "Tidak ada ~r~Keju~w~")
            else
                TriggerClientEvent('esx:showNotification', _source, "Memotong ~b~Keju~w~")
                TriggerClientEvent('esx_pedagang:StartCookAnimation', _source)
                    Citizen.Wait(15000)
                    TriggerClientEvent('esx_pedagang:StopCookAnimation', _source)
                    TriggerClientEvent('esx:showNotification', _source, "Fetas de queso estan ~g~listas~w~")
                    xPlayer.removeInventoryItem('cheese', 1)
                    xPlayer.addInventoryItem('ccheese', 5)
            end
		else
			TriggerClientEvent('esx:showNotification', _source, "Rip ~r~ERRO 404~w~")
		end
end)

RegisterServerEvent('esx_pedagangjob:shop')
AddEventHandler('esx_pedagangjob:shop', function(item, valor)

    local _source = source
    local xPlayer           = ESX.GetPlayerFromId(_source)
	local comida = item
	local preco = valor
	if xPlayer.getMoney() >= preco then
        xPlayer.removeMoney(preco)
        xPlayer.addInventoryItem(comida, 1)
	end
end)

ESX.RegisterServerCallback('esx_pedagangjob:getVaultWeapons', function(source, cb)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_pedagang', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)

ESX.RegisterServerCallback('esx_pedagangjob:addVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.removeWeapon(weaponName)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_pedagang', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = weapons[i].count + 1
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 1
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_pedagangjob:removeVaultWeapon', function(source, cb, weaponName)

  local xPlayer = ESX.GetPlayerFromId(source)

  xPlayer.addWeapon(weaponName, 1000)

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_pedagang', function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    local foundWeapon = false

    for i=1, #weapons, 1 do
      if weapons[i].name == weaponName then
        weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
        foundWeapon = true
      end
    end

    if not foundWeapon then
      table.insert(weapons, {
        name  = weaponName,
        count = 0
      })
    end

     store.set('weapons', weapons)

     cb()

  end)

end)

ESX.RegisterServerCallback('esx_pedagangjob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
