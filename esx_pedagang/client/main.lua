local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local Blips                   = {}

local isBarman                = false
local isInMarker              = false
local isInPublicMarker        = false
local hintIsShowed            = false
local hintToDisplay           = "no hint to display"

ESX                           = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function IsJobTrue()
    if PlayerData ~= nil then
        local IsJobTrue = false
        if PlayerData.job ~= nil and PlayerData.job.name == 'pedagang' then
            IsJobTrue = true
        end
        return IsJobTrue
    end
end

function IsGradeBoss()
    if PlayerData ~= nil then
        local IsGradeBoss = false
        if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'viceboss' then
            IsGradeBoss = true
        end
        return IsGradeBoss
    end
end

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 0,
    modBrakes       = 0,
    modTransmission = 0,
    modSuspension   = 0,
    modTurbo        = false,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


function cleanPlayer(playerPed)
  ClearPedBloodDamage(playerPed)
  ResetPedVisibleDamage(playerPed)
  ClearPedLastWeaponDamage(playerPed)
  ResetPedMovementClipset(playerPed, 0)
end

function setClipset(playerPed, clip)
  RequestAnimSet(clip)
  while not HasAnimSetLoaded(clip) do
    Citizen.Wait(0)
  end
  SetPedMovementClipset(playerPed, clip, true)
end

function setUniform(job, playerPed)
  TriggerEvent('skinchanger:getSkin', function(skin)

    if skin.sex == 0 then
      if Config.Uniforms[job].male ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
      else
        exports['mythic_notify']:SendAlert('inform', 'No Outfit!', 2500, { ['background-color'] = '#007dd1', ['color'] = '#ffffff' })
        --ESX.ShowNotification(_U('no_outfit'))
      end
      if job ~= 'citizen_wear' and job ~= 'barman_outfit' then
        setClipset(playerPed, "MOVE_M@POSH@")
      end
    else
      if Config.Uniforms[job].female ~= nil then
        TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
      else
        exports['mythic_notify']:SendAlert('inform', 'No Outfit!', 2500, { ['background-color'] = '#007dd1', ['color'] = '#ffffff' })
      end
      if job ~= 'citizen_wear' and job ~= 'barman_outfit' then
        setClipset(playerPed, "MOVE_F@POSH@")
      end
    end

  end)
end

function OpenCloakroomMenu()

  local playerPed = GetPlayerPed(-1)

  local elements = {
    { label = "Baju Bebas",     value = 'citizen_wear'},
    { label = "Baju Kerja",    value = 'barman_outfit'}
  }

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'cloakroom',
    {
      title    = _U('cloakroom'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      isBarman = false
      cleanPlayer(playerPed)

      if data.current.value == 'citizen_wear' then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
          TriggerEvent('skinchanger:loadSkin', skin)
        end)
      end

      if data.current.value == 'barman_outfit' then
        setUniform(data.current.value, playerPed)
      end

      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}

    end,
    function(data, menu)
      menu.close()
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end
  )
end

function OpenVaultMenu()

    local elements = {
      {label = "Salada (x1) - 8$", value = 'lettuce'},
      {label = "Tomat (x1) - 8$", value = 'tomato'},
      {label = "Keju (x1) - 6$", value = 'cheese'},
      {label = "Kentang (x1) - 2$", value = 'potato'},
      {label = "Hamburger Beku (x1) - 5$", value = 'fburger'},
      {label = "Hamburger Sayur (x1) - 4$", value = 'fvburger'},
      {label = "Roti (x1) - 3$", value = 'bread'},
      {label = "Nugget (x1) - 1.5$", value = 'nugget'},
      {label = "CocaCola (x1) - 3$", value = 'cocacola'},
      {label = "Aqua (x1) - 2$", value = 'water'},
      {label = "Kopi Espresso Bubuk (x1) - 2$", value = 'espressobubuk'},
      {label = "Kopi Cappucino Bubuk (x1) - 2$", value = 'cappucinobubuk'},
      {label = "Kopi Machiato Bubuk (x1) - 2$", value = 'machiatobubuk'},
      {label = "Kopi Latte Bubuk (x1) - 2$", value = 'lattebubuk'}
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault',
      {
        title    = _U('vault'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
	  local valor = 0
    
		
		TriggerServerEvent('esx_pedagangjob:shop', data.current.value, valor)
      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = "~g~E~w~ Untuk Memasak Sesuatu"
        CurrentActionData = {}
      end
    )

end

function OpenFridgeMenu()

    local elements = {
      {label = _U('get_object'), value = 'get_stock'},
      {label = _U('put_object'), value = 'put_stock'}
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge',
      {
        title    = "Lemari es",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        if data.current.value == 'put_stock' then
           OpenPutFridgeStocksMenu()
        end

        if data.current.value == 'get_stock' then
           OpenGetFridgeStocksMenu()
        end

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_fridge'
        CurrentActionMsg  = "~g~E~w~ Untuk Membuka Kulkas"
        CurrentActionData = {}
      end
    )

end

function OpenCozinharMenu()

	local elements = {
      {label = "Hamburger", value = 'hamburger'},
      {label = "Salad", value = 'salad'},
      {label = "Nasi Goreng", value = 'nasgor'},
      {label = "Nasi Bungkus", value = 'nasbung'},
     -- {label = "Roti Bakar", value = 'rotbar'},
     -- {label = "Kentang Rebus", value = 'kengor'},
      {label = "Nugget", value = 'nuggets'}
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cook',
      {
        title    = "Memasak",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		
        TriggerServerEvent('esx_pedagangjob:craftingCoktails', data.current.value)

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_cook'
        CurrentActionMsg  = "~g~E~w~ Untuk Memasak Sesuatu"
        CurrentActionData = {}
      end
    )

end

function OpenCozinharMenu2()

	local elements = {

      --{label = "Kopi", value = 'coffe'},
      {label = "Es Teh", value = 'icetea'},
      {label = "Jus Apel", value = 'jusapel'},
      {label = "Jus Melon", value = 'jusmelon'},
      --{label = "Susu", value = 'milk'}
    }
    

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'cook',
      {
        title    = "Memasak",
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)
		
        TriggerServerEvent('esx_pedagangjob:craftingCoktails', data.current.value)

      end,
      
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_cook2'
        CurrentActionMsg  = "~g~E~w~ Untuk Membuat Kopi"
        CurrentActionData = {}
      end
    )

end

function OpenVehicleSpawnerMenu()

  local vehicles = Config.Zones.Vehicles

  ESX.UI.Menu.CloseAll()

  if Config.EnableSocietyOwnedVehicles then

    local elements = {}

    ESX.TriggerServerCallback('esx_society:getVehiclesInGarage', function(garageVehicles)

      for i=1, #garageVehicles, 1 do
        table.insert(elements, {label = GetDisplayNameFromVehicleModel(garageVehicles[i].model) .. ' [' .. garageVehicles[i].plate .. ']', value = garageVehicles[i]})
      end

      ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_spawner',
        {
          title    = _U('vehicle_menu'),
          align    = 'top-left',
          elements = elements,
        },
        function(data, menu)

          menu.close()

          local vehicleProps = data.current.value
          ESX.Game.SpawnVehicle(vehicleProps.model, vehicles.SpawnPoint, vehicles.Heading, function(vehicle)
              ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
              local playerPed = GetPlayerPed(-1)
              --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)  -- teleport into vehicle
          end)            

          TriggerServerEvent('esx_society:removeVehicleFromGarage', 'pedagang', vehicleProps)

        end,
        function(data, menu)

          menu.close()

          CurrentAction     = 'menu_vehicle_spawner'
          CurrentActionMsg  = _U('vehicle_spawner')
          CurrentActionData = {}

        end
      )

    end, 'pedagang')

  else

    local elements = {}

    for i=1, #Config.AuthorizedVehicles, 1 do
      local vehicle = Config.AuthorizedVehicles[i]
      table.insert(elements, {label = vehicle.label, value = vehicle.name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = _U('vehicle_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        local model = data.current.value

        local vehicle = GetClosestVehicle(vehicles.SpawnPoint.x,  vehicles.SpawnPoint.y,  vehicles.SpawnPoint.z,  3.0,  0,  71)

        if not DoesEntityExist(vehicle) then

          local playerPed = GetPlayerPed(-1)

          if Config.MaxInService == -1 then

            ESX.Game.SpawnVehicle(model, {
              x = vehicles.SpawnPoint.x,
              y = vehicles.SpawnPoint.y,
              z = vehicles.SpawnPoint.z
            }, vehicles.Heading, function(vehicle)
              --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1) -- teleport into vehicle
              SetVehicleMaxMods(vehicle)
              SetVehicleDirtLevel(vehicle, 0)
            end)

          else

            ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)

              if canTakeService then

                ESX.Game.SpawnVehicle(model, {
                  x = vehicles[partNum].SpawnPoint.x,
                  y = vehicles[partNum].SpawnPoint.y,
                  z = vehicles[partNum].SpawnPoint.z
                }, vehicles[partNum].Heading, function(vehicle)
                  --TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)  -- teleport into vehicle
                  SetVehicleMaxMods(vehicle)
                  SetVehicleDirtLevel(vehicle, 0)
                end)

              else
                exports['mythic_notify']:SendAlert('inform', 'Service Max!', 2500, { ['background-color'] = '#007dd1', ['color'] = '#ffffff' })
                --ESX.ShowNotification(_U('service_max') .. inServiceCount .. '/' .. maxInService)
              end

            end, 'etat')

          end

        else
          exports['mythic_notify']:SendAlert('inform', 'Vehicle Out!', 2500, { ['background-color'] = '#007dd1', ['color'] = '#ffffff' })
          --ESX.ShowNotification(_U('vehicle_out'))
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {}

      end
    )

  end

end

function OpenSocietyActionsMenu()

  local elements = {}

  table.insert(elements, {label = _U('billing'),    value = 'billing'})

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'pedagang_actions',
    {
      title    = "Billing",
      align    = 'top-left',
      elements = elements
    },
    function(data, menu)

      if data.current.value == 'billing' then
        OpenBillingMenu()
      end    
    end,
    function(data, menu)

      menu.close()

    end
  )

end

function OpenBillingMenu()

  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
    title = _U('billing_amount')
  }, function(data, menu)
    local amount = tonumber(data.value)

    if amount == nil or amount < 0 then
      exports['mythic_notify']:SendAlert('inform', 'Amount Invalid!', 2500, { ['background-color'] = '#007dd1', ['color'] = '#ffffff' })
      --ESX.ShowNotification(_U('amount_invalid'))
    else
      local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
      if closestPlayer == -1 or closestDistance > 3.0 then
        exports['mythic_notify']:SendAlert('inform', 'No Player Nearby!', 2500, { ['background-color'] = '#007dd1', ['color'] = '#ffffff' })
        --ESX.ShowNotification(_U('no_players_nearby'))
      else
        menu.close()
        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_pedagang', _U('pedagang'), amount)
      end
    end
  end, function(data, menu)
    menu.close()
  end)
end

function OpenGetStocksMenu()

  ESX.TriggerServerCallback('esx_pedagangjob:getStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('pedagang_stock'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              exports['mythic_notify']:SendAlert('inform', 'Invalid Quantity!', 2500, { ['background-color'] = '#007dd1', ['color'] = '#ffffff' })
              --ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_pedagangjob:getStockItem', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

ESX.TriggerServerCallback('esx_pedagangjob:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = _U('inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              exports['mythic_notify']:SendAlert('inform', 'Invalid Quantity!', 2500, { ['background-color'] = '#007dd1', ['color'] = '#ffffff' })
              --ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenPutStocksMenu()

              TriggerServerEvent('esx_pedagangjob:putStockItems', itemName, count)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenGetFridgeStocksMenu()

  ESX.TriggerServerCallback('esx_pedagangjob:getFridgeStockItems', function(items)

    print(json.encode(items))

    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge_menu',
      {
        title    = _U('pedagang_fridge_stock'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'fridge_menu_get_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              exports['mythic_notify']:SendAlert('inform', 'Invalid Quantity!', 2500, { ['background-color'] = '#007dd1', ['color'] = '#ffffff' })
              --ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenGetStocksMenu()

              TriggerServerEvent('esx_pedagangjob:getFridgeStockItem', itemName, count)
            end
            local player = GetPlayerPed(-1)
            local dict = "mp_am_hold_up"
        
            RequestAnimDict(dict)
            while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
            
            TaskPlayAnim(player, dict, "purchase_beerbox_shopkeeper", 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutFridgeStocksMenu()

ESX.TriggerServerCallback('esx_pedagangjob:getPlayerInventory', function(inventory)

    local elements = {}

    for i=1, #inventory.items, 1 do

      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
      end

    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'fridge_menu',
      {
        title    = _U('fridge_inventory'),
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'fridge_menu_put_item_count',
          {
            title = _U('quantity')
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              exports['mythic_notify']:SendAlert('inform', 'Invalid Quantity!', 2500, { ['background-color'] = '#007dd1', ['color'] = '#ffffff' })
              --ESX.ShowNotification(_U('invalid_quantity'))
            else
              menu2.close()
              menu.close()
              OpenPutFridgeStocksMenu()

              TriggerServerEvent('esx_pedagangjob:putFridgeStockItems', itemName, count)
              local player = GetPlayerPed(-1)
              local dict = "mp_am_hold_up"
          
              RequestAnimDict(dict)
              while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
              
              TaskPlayAnim(player, dict, "purchase_beerbox_shopkeeper", 8.0, 2.0, -1, 48, 2, 0, 0, 0 )
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_pedagangjob:getVaultWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vault_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

        ESX.TriggerServerCallback('esx_pedagangjob:removeVaultWeapon', function()
          OpenGetWeaponMenu()
        end, data.current.value)

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutWeaponMenu()

  local elements   = {}
  local playerPed  = GetPlayerPed(-1)
  local weaponList = ESX.GetWeaponList()

  for i=1, #weaponList, 1 do

    local weaponHash = GetHashKey(weaponList[i].name)

    if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
      local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
      table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
    end

  end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vault_put_weapon',
    {
      title    = _U('put_weapon_menu'),
      align    = 'top-left',
      elements = elements,
    },
    function(data, menu)

      menu.close()

      ESX.TriggerServerCallback('esx_pedagangjob:addVaultWeapon', function()
        OpenPutWeaponMenu()
      end, data.current.value)

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenShopMenu(zone)

    local elements = {}
    for i=1, #Config.Zones[zone].Items, 1 do

        local item = Config.Zones[zone].Items[i]

        table.insert(elements, {
            label     = item.label .. ' - <span style="color:red;">$' .. item.price .. ' </span>',
            realLabel = item.label,
            value     = item.name,
            price     = item.price
        })

    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pedagang_shop',
        {
            title    = _U('shop'),
            elements = elements
        },
        function(data, menu)
            TriggerServerEvent('esx_pedagangjob:buyItem', data.current.value, data.current.price, data.current.realLabel)
        end,
        function(data, menu)
            menu.close()
        end
    )

end

function animsAction(animObj)
    Citizen.CreateThread(function()
        if not playAnim then
            local playerPed = GetPlayerPed(-1);
            if DoesEntityExist(playerPed) then -- Check if ped exist
                dataAnim = animObj

                -- Play Animation
                RequestAnimDict(dataAnim.lib)
                while not HasAnimDictLoaded(dataAnim.lib) do
                    Citizen.Wait(0)
                end
                if HasAnimDictLoaded(dataAnim.lib) then
                    local flag = 0
                    if dataAnim.loop ~= nil and dataAnim.loop then
                        flag = 1
                    elseif dataAnim.move ~= nil and dataAnim.move then
                        flag = 49
                    end

                    TaskPlayAnim(playerPed, dataAnim.lib, dataAnim.anim, 8.0, -8.0, -1, flag, 0, 0, 0, 0)
                    playAnimation = true
                end

                -- Wait end animation
                while true do
                    Citizen.Wait(0)
                    if not IsEntityPlayingAnim(playerPed, dataAnim.lib, dataAnim.anim, 3) then
                        playAnim = false
                        TriggerEvent('ft_animation:ClFinish')
                        break
                    end
                end
            end -- end ped exist
        end
    end)
end


AddEventHandler('esx_pedagangjob:hasEnteredMarker', function(zone)
 
    if zone == 'BossActions' and IsGradeBoss() then
      CurrentAction     = 'menu_boss_actions'
      CurrentActionMsg  = _U('open_bossmenu')
      CurrentActionData = {}
    end

    if zone == 'Cloakrooms' then
      CurrentAction     = 'menu_cloakroom'
      CurrentActionMsg  = _U('open_cloackroom')
      CurrentActionData = {}
    end

      if zone == 'Vaults' then
        CurrentAction     = 'menu_vault'
        CurrentActionMsg  = "~g~E~w~ Untuk Membuat Bahan"
        CurrentActionData = {}
      end

    if zone == 'Fridge' then
      CurrentAction     = 'menu_fridge'
      CurrentActionMsg  = _U('open_fridge')
      CurrentActionData = {}
    end
	
	if zone == 'Cook' then
      CurrentAction     = 'menu_cook'
      CurrentActionMsg  = "~g~E~w~ Untuk Memasak Sesuatu"
      CurrentActionData = {}
    end
    if zone == 'Cook2' then
      CurrentAction     = 'menu_cook2'
      CurrentActionMsg  = "~g~E~w~ Untuk Memasak Sesuatu"
      CurrentActionData = {}
    end

    if zone == 'Flacons' or zone == 'NoAlcool' or zone == 'Apero' or zone == 'Ice' then
      CurrentAction     = 'menu_shop'
      CurrentActionMsg  = _U('shop_menu')
      CurrentActionData = {zone = zone}
    end
    
    if zone == 'Vehicles' then
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = _U('vehicle_spawner')
        CurrentActionData = {}
    end

    if zone == 'VehicleDeleters' then

      local playerPed = GetPlayerPed(-1)

      if IsPedInAnyVehicle(playerPed,  false) then

        local vehicle = GetVehiclePedIsIn(playerPed,  false)

        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = _U('store_vehicle')
        CurrentActionData = {vehicle = vehicle}
      end

    end

    if Config.EnableHelicopters then
        if zone == 'Helicopters' then

          local helicopters = Config.Zones.Helicopters

          if not IsAnyVehicleNearPoint(helicopters.SpawnPoint.x, helicopters.SpawnPoint.y, helicopters.SpawnPoint.z,  3.0) then

            ESX.Game.SpawnVehicle('swift2', {
              x = helicopters.SpawnPoint.x,
              y = helicopters.SpawnPoint.y,
              z = helicopters.SpawnPoint.z
            }, helicopters.Heading, function(vehicle)
              SetVehicleModKit(vehicle, 0)
              SetVehicleLivery(vehicle, 0)
            end)

          end

        end

        if zone == 'HelicopterDeleters' then

          local playerPed = GetPlayerPed(-1)

          if IsPedInAnyVehicle(playerPed,  false) then

            local vehicle = GetVehiclePedIsIn(playerPed,  false)

            CurrentAction     = 'delete_vehicle'
            CurrentActionMsg  = _U('store_vehicle')
            CurrentActionData = {vehicle = vehicle}
          end

        end
    end


end)

AddEventHandler('esx_pedagangjob:hasExitedMarker', function(zone)

    CurrentAction = nil
    ESX.UI.Menu.CloseAll()

end)

-- Create blips
Citizen.CreateThread(function()

    local blipMarker = Config.Blips.Blip
    local blipCoord = AddBlipForCoord(blipMarker.Pos.x, blipMarker.Pos.y, blipMarker.Pos.z)

    SetBlipSprite (blipCoord, blipMarker.Sprite)
    SetBlipDisplay(blipCoord, blipMarker.Display)
    SetBlipScale  (blipCoord, blipMarker.Scale)
    SetBlipColour (blipCoord, blipMarker.Colour)
    SetBlipAsShortRange(blipCoord, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Coffe Bean and Burger")
    EndTextCommandSetBlipName(blipCoord)


end)

-- Display markers
Citizen.CreateThread(function()
    while true do

        Wait(0)
        if IsJobTrue() then

            local coords = GetEntityCoords(GetPlayerPed(-1))

            for k,v in pairs(Config.Zones) do
                if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, false, false, false, false)
                end
            end

        end

    end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do

        Wait(0)
        if IsJobTrue() then

            local coords      = GetEntityCoords(GetPlayerPed(-1))
            local isInMarker  = false
            local currentZone = nil

            for k,v in pairs(Config.Zones) do
                if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
                    isInMarker  = true
                    currentZone = k
                end
            end

            if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
                HasAlreadyEnteredMarker = true
                LastZone                = currentZone
                TriggerEvent('esx_pedagangjob:hasEnteredMarker', currentZone)
            end

            if not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                TriggerEvent('esx_pedagangjob:hasExitedMarker', LastZone)
            end

        end

    end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do

    Citizen.Wait(0)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlJustReleased(0,  Keys['E']) and IsJobTrue() then

        if CurrentAction == 'menu_cloakroom' then
            OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_vault' then
            OpenVaultMenu()
        end

        if CurrentAction == 'menu_fridge' then
            OpenFridgeMenu()
        end
		
		if CurrentAction == 'menu_cook' then
            OpenCozinharMenu()
        end
        if CurrentAction == 'menu_cook2' then
          OpenCozinharMenu2()
      end
  

        if CurrentAction == 'menu_shop' then
            OpenShopMenu(CurrentActionData.zone)
        end
        
        if CurrentAction == 'menu_vehicle_spawner' then
            OpenVehicleSpawnerMenu()
        end

        if CurrentAction == 'delete_vehicle' then

          if Config.EnableSocietyOwnedVehicles then

            local vehicleProps = ESX.Game.GetVehicleProperties(CurrentActionData.vehicle)
            TriggerServerEvent('esx_society:putVehicleInGarage', 'pedagang', vehicleProps)

          else

            if
              GetEntityModel(vehicle) == GetHashKey('rentalbus')
            then
              TriggerServerEvent('esx_service:disableService', 'pedagang')
            end

          end

          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        end


        if CurrentAction == 'menu_boss_actions' and IsGradeBoss() then

          local options = {
            wash      = Config.EnableMoneyWash,
          }

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', 'pedagang', function(data, menu)

            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = _U('open_bossmenu')
            CurrentActionData = {}

          end,options)

        end

        
        CurrentAction = nil

      end

    end


    if IsControlJustReleased(0,  Keys['F6']) and IsJobTrue() and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'pedagang_actions') then
        OpenSocietyActionsMenu()
    end


  end
end)

RegisterNetEvent('esx_pedagang:StartCookAnimation')
AddEventHandler('esx_pedagang:StartCookAnimation', function()
local ped = GetPlayerPed(-1)
local x,y,z = table.unpack(GetEntityCoords(playerPed, true))
  if not IsEntityPlayingAnim(ped, "anim@amb@business@weed@weed_sorting_seated@", "sorter_right_sort_v3_sorter02", 3) then
  FreezeEntityPosition(ped,true)
    RequestAnimDict("anim@amb@business@weed@weed_sorting_seated@")
      while not HasAnimDictLoaded("anim@amb@business@weed@weed_sorting_seated@") do
        Citizen.Wait(100)
      end
    Wait(100)
    TaskPlayAnim(ped, "anim@amb@business@weed@weed_sorting_seated@", "sorter_right_sort_v3_sorter02", 8.0, -8, -1, 49, 0, 0, 0, 0)
      Wait(2000)
  end
end)

RegisterNetEvent('esx_pedagang:StopCookAnimation')
AddEventHandler('esx_pedagang:StopCookAnimation', function()
local ped = GetPlayerPed(-1)
  ClearPedTasksImmediately(ped)
  FreezeEntityPosition(ped,false)
end)