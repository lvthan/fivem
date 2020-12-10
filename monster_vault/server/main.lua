ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('monster_vault:getItem')
AddEventHandler('monster_vault:getItem', function(--[[owner,--]] job, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(xPlayer.identifier)

	if type == 'item_standard' then

		local sourceItem = xPlayer.getInventoryItem(item)

		if xPlayer.job.name == job then
			TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..job, function(inventory)
				local inventoryItem = inventory.getItem(item)
				if count > 0 and inventoryItem.count >= count then
					if sourceItem.weight ~= -1 and (sourceItem.count + count) > sourceItem.weight then
						print('notify: player cannot hold')
						TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = _U('player_cannot_hold'), length = 5500})
					else
						inventory.removeItem(item, count)
						xPlayer.addInventoryItem(item, count)
						TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'success', text = _U('have_withdrawn', count, inventoryItem.label), length = 7500})
						local _source = source
						local name = GetPlayerName(source)
						local ip = GetPlayerEndpoint(source)
						local steamhex = GetPlayerIdentifier(source)
						local communtiylogo = ""
						local logs = "https://discord.com/api/webhooks/770594707423887390/EZPJvVun91OyppSn2gAkGMiXhqJieeIQ2U5pHEAnS1LANp9hPMvmrtyXUOoDX_82Jhls"
						local money = xPlayer.getMoney()
						local bank = xPlayer.getAccount('bank').money
						local black = xPlayer.getAccount('black_money').money
						local job = xPlayer.job.name
						local armorypolicelog = {
							{
								["color"] = "8663711",
									["title"] = "LOG WITHDRAW ITEM BERANGKAS",
									["description"] = "Player: **"..name.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**\nUang Cash : **Rp."..ESX.Math.GroupDigits(money).."**\nBank : **Rp."..ESX.Math.GroupDigits(bank).."**\nUang Gelap : **Rp."..ESX.Math.GroupDigits(black).."**\nPekerjaan : **"..job.."**\nNama Barang : **"..count.."x ".. inventoryItem.label.."**",
								["footer"] = {
									["text"] = "GOI ROLEPLAY",
									["icon_url"] = communtiylogo,
								},
							}
						}
						PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG WITHDRAW ITEM BERANGKAS", embeds = armorypolicelog}), { ['Content-Type'] = 'application/json' })
					end
				else
					print('not enough in vault')
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = _U('not_enough_in_vault'), length = 5500})
				end
			end)
		elseif job == 'vault' then
			TriggerEvent('esx_addoninventory:getInventory', 'vault', xPlayerOwner.identifier, function(inventory)
				local inventoryItem = inventory.getItem(item)
	
				
				if count > 0 and inventoryItem.count >= count then
					if sourceItem.weight ~= -1 and (sourceItem.count + count) > sourceItem.weight then
						TriggerClientEvent('mythic_notify:client:SendAlert', _source,  {type = 'error', text = _U('player_cannot_hold'), length = 5500})
					else
						inventory.removeItem(item, count)
						xPlayer.addInventoryItem(item, count)
						TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'success', text = _U('have_withdrawn', count, inventoryItem.label), length = 8500})
					end
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = _U('not_enough_in_vault'), length = 5500})
				end
			end)
		else
			print('notify: not permission for this job')
		end

	elseif type == 'item_account' then
		if xPlayer.job.name == job then
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job..'_'..item, function(account)
				local policeAccountMoney = account.money

				if policeAccountMoney >= count then
					account.removeMoney(count)
					xPlayer.addAccountMoney(item, count)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = _U('amount_invalid'), length = 5500})
				end
			end)
		elseif job == 'vault' then
			TriggerEvent('esx_addonaccount:getAccount', 'vault_' .. item, xPlayerOwner.identifier, function(account)
				local roomAccountMoney = account.money
	
				if roomAccountMoney >= count then
					account.removeMoney(count)
					xPlayer.addAccountMoney(item, count)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = _U('amount_invalid'), length = 5500})
				end
			end)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = "You not have permission", length = 5500})
		end
	elseif type == 'item_weapon' then
		if xPlayer.job.name == job then
			TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
				local storeWeapons = store.get('weapons') or {}
				local weaponName   = nil
				local ammo         = nil
	
				for i=1, #storeWeapons, 1 do
					if storeWeapons[i].name == item then
						weaponName = storeWeapons[i].name
						ammo       = storeWeapons[i].ammo
	
						table.remove(storeWeapons, i)
						break
					end
				end
	
				store.set('weapons', storeWeapons)
				xPlayer.addWeapon(weaponName, ammo)
				local _source = source
    			local name = GetPlayerName(source)
    			local ip = GetPlayerEndpoint(source)
    			local steamhex = GetPlayerIdentifier(source)
    			local communtiylogo = ""
    			local logs = "https://discord.com/api/webhooks/770594915344318474/o-j7drrWMTNqtKiF-fHdHz17NWunyoBdYWtZYymXPlLY6BtIZob2K-6b01J-B7KbxNu0"
    			local money = xPlayer.getMoney()
    			local bank = xPlayer.getAccount('bank').money
    			local black = xPlayer.getAccount('black_money').money
    			local job = xPlayer.job.name
    			local armorypolicelog = {
					{
            			["color"] = "8663711",
            			["title"] = "LOG WITHDRAW SENJATA BERANGKAS",
           				["description"] = "Player: **"..name.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**\nUang Cash : **Rp."..ESX.Math.GroupDigits(money).."**\nBank : **Rp."..ESX.Math.GroupDigits(bank).."**\nUang Gelap : **Rp."..ESX.Math.GroupDigits(black).."**\nPekerjaan : **"..job.."**\nNama Barang : **"..weaponName.."**",
           				["footer"] = {
                		["text"] = "INRP ROLEPLAY",
                		["icon_url"] = communtiylogo,
           			 },
        			}
				}
				
				PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG WITHDRAW SENJATA BERANGKAS", embeds = armorypolicelog}), { ['Content-Type'] = 'application/json' })

			end)
		elseif job == 'vault' then
			TriggerEvent('esx_datastore:getDataStore', 'vault', xPlayerOwner.identifier, function(store)
				local storeWeapons = store.get('weapons') or {}
				local weaponName   = nil
				local ammo         = nil
	
				for i=1, #storeWeapons, 1 do
					if storeWeapons[i].name == item then
						weaponName = storeWeapons[i].name
						ammo       = storeWeapons[i].ammo
	
						table.remove(storeWeapons, i)
						break
					end
				end
	
				store.set('weapons', storeWeapons)
				xPlayer.addWeapon(weaponName, ammo)
			end)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = 'You not have permission', length = 5500})
		end
	end

end)

RegisterServerEvent('monster_vault:putItem')
AddEventHandler('monster_vault:putItem', function(--[[owner,--]] job, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(xPlayer.identifier)

	if type == 'item_standard' then

		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			if xPlayer.job.name == job then
				TriggerEvent('esx_addoninventory:getSharedInventory', 'society_'..job, function(inventory)
					xPlayer.removeInventoryItem(item, count)
					inventory.addItem(item, count)
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'success', text = _U('have_deposited', count, inventory.getItem(item).label), length = 7500})
					local _source = source
					local name = GetPlayerName(source)
					local ip = GetPlayerEndpoint(source)
					local steamhex = GetPlayerIdentifier(source)
					local communtiylogo = ""
					local logs = "https://discord.com/api/webhooks/770314105642156035/Ezr7MZAEnUkMnXDJW58g-_RKg1C5oyS1jUT5XtaOh9hd6X8Uym7KxUND5lt8nIqyjorB"
					local money = xPlayer.getMoney()
					local bank = xPlayer.getAccount('bank').money
					local black = xPlayer.getAccount('black_money').money
					local job = xPlayer.job.name
					local armorypolicelog = {
						{
							["color"] = "8663711",
								["title"] = "LOG DEPOSIT ITEM BERANGKAS",
								["description"] = "Player: **"..name.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**\nUang Cash : **Rp."..ESX.Math.GroupDigits(money).."**\nBank : **Rp."..ESX.Math.GroupDigits(bank).."**\nUang Gelap : **Rp."..ESX.Math.GroupDigits(black).."**\nPekerjaan : **"..job.."**\nNama Barang : **"..count.."x ".. inventory.getItem(item).label.."**",
							["footer"] = {
								["text"] = "INRP ROLEPLAY",
								["icon_url"] = communtiylogo,
							},
						}
					}
					PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG DEPOSIT ITEM BERANGKAS", embeds = armorypolicelog}), { ['Content-Type'] = 'application/json' })
				end)
				-- print("monster_vault:putItem")
			elseif job == 'vault' then
				TriggerEvent('esx_addoninventory:getInventory', 'vault', xPlayerOwner.identifier, function(inventory)
					xPlayer.removeInventoryItem(item, count)
					inventory.addItem(item, count)
					TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'success', text = _U('have_deposited', count, inventory.getItem(item).label), length = 7500})
				end)
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = "error", text = 'You not have permission for this job!', length = 5500})
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = "error", text = _U('invalid_quantity'), length = 5500})
		end

	elseif type == 'item_account' then

		local playerAccountMoney = xPlayer.getAccount(item).money

		if playerAccountMoney >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)
			if xPlayer.job.name == job and job == 'police' then
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job..'_'..item, function(account)
					account.addMoney(count)
				end)
			elseif job == 'vault' then
				TriggerEvent('esx_addonaccount:getAccount', 'vault_' .. item, xPlayerOwner.identifier, function(account)
					account.addMoney(count)
				end)
			else
				xPlayer.addAccountMoney(item, count)
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = 'This job not allow for black money', length = 5500})
			end
			
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = _U('amount_invalid'), length = 5500})
		end

	elseif type == 'item_weapon' then
		if xPlayer.job.name == job then
			TriggerEvent('esx_datastore:getSharedDataStore', 'society_'..job, function(store)
				local storeWeapons = store.get('weapons') or {}
	
				table.insert(storeWeapons, {
					name = item,
					count = count
				})
	
				xPlayer.removeWeapon(item)
				store.set('weapons', storeWeapons)

				local _source = source
				local name = GetPlayerName(source)
				local ip = GetPlayerEndpoint(source)
				local steamhex = GetPlayerIdentifier(source)
				local communtiylogo = ""
				local logs = "https://discord.com/api/webhooks/770595122969575424/OAcATD6Ef1IgSvgXMJQFOr-giE3ehn0MUolXT7LYbDgV0k2LS48Qb1h-DcPW6HCFX37F"
				local money = xPlayer.getMoney()
				local bank = xPlayer.getAccount('bank').money
				local black = xPlayer.getAccount('black_money').money
				local job = xPlayer.job.name
				local armorypolicelog = {
					{
						["color"] = "8663711",
							["title"] = "LOG DEPOSIT SENJATA BERANGKAS",
							["description"] = "Player: **"..name.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**\nUang Cash : **Rp."..ESX.Math.GroupDigits(money).."**\nBank : **Rp."..ESX.Math.GroupDigits(bank).."**\nUang Gelap : **Rp."..ESX.Math.GroupDigits(black).."**\nPekerjaan : **"..job.."**\nNama Barang : **"..count.."x "..item.."**",
						["footer"] = {
							["text"] = "GOI ROLEPLAY",
							["icon_url"] = communtiylogo,
						},
					}
				}
				PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "LOG DEPOSIT SENJATA BERANGKAS", embeds = armorypolicelog}), { ['Content-Type'] = 'application/json' })

				
			end)
		elseif job == 'vault' then
			TriggerEvent('esx_datastore:getDataStore', 'vault', xPlayerOwner.identifier, function(store)
				local storeWeapons = store.get('weapons') or {}
	
				table.insert(storeWeapons, {
					name = item,
					ammo = count
				})
	
				xPlayer.removeWeapon(item)
				store.set('weapons', storeWeapons)
				
			end)
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, {type = 'error', text = 'You not have permission', length = 5500})
		end
	end

end)

ESX.RegisterServerCallback('monster_vault:getVaultInventory', function(source, cb, item, refresh)
	-- local xPlayer    = ESX.GetPlayerFromIdentifier(owner)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem
	if item.needItemLicense ~= '' or item.needItemLicense ~= nil then
		xItem = xPlayer.getInventoryItem(item.needItemLicense)
	else
		xItem = nil
	end
	local refresh = refresh or false

	local blackMoney = 0
	local items      = {}
	local weapons    = {}

	if not refresh and (item.needItemLicense ~= '' or item.needItemLicense ~= nil) and xItem ~= nil and xItem.count < 1 then
		-- if xItem.count < 1 then
		cb(false)
		-- end
		-- return
	elseif not item.InfiniteLicense and not refresh and xItem ~= nil and xItem.count > 0 then
		-- if not item.InfiniteLicense then
			xPlayer.removeInventoryItem(item.needItemLicense, 1)
		-- end
	end

	-- if item.job == xPlayer.job.name then
	-- 	print('u job: '..xPlayer.job.name)
	-- end

	local typeVault = ''
	local society = false
	if string.find(item.job, "vault") then
		typeVault = item.job
	else
		typeVault = "society_"..item.job
		society = true
	end
	print("Vault: "..typeVault)

	if society then
		if item.job == 'police' then
			TriggerEvent('esx_addonaccount:getSharedAccount', typeVault..'_black_money', function(account)
				blackMoney = account.money
			end)
		else
			blackMoney = 0
		end
		TriggerEvent('esx_addoninventory:getSharedInventory', typeVault, function(inventory)
			items = inventory.items
		end)
		TriggerEvent('esx_datastore:getSharedDataStore', typeVault, function(store)
			weapons = store.get('weapons') or {}
		end)
		cb({
			blackMoney = blackMoney,
			items      = items,
			weapons    = weapons,
			job = item.job
		})
	else
		TriggerEvent('esx_addonaccount:getAccount', typeVault..'_black_money', xPlayer.identifier, function(account)
			blackMoney = account.money
		end)

		TriggerEvent('esx_addoninventory:getInventory', typeVault, xPlayer.identifier, function(inventory)
			items = inventory.items
		end)

		TriggerEvent('esx_datastore:getDataStore', typeVault, xPlayer.identifier, function(store)
			weapons = store.get('weapons') or {}
		end)

		cb({
			blackMoney = blackMoney,
			items      = items,
			weapons    = weapons,
			job = item.job
		})
	end
end)
