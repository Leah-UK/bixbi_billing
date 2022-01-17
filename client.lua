ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
end)

--[[-----------------------------------------------------------------------
Menus
--]]-----------------------------------------------------------------------
AddEventHandler('bixbi_billing:BillingMenu', function(data)
    ESX.TriggerServerCallback('bixbi_billing:getBills', function(result)
        while (result == nil) do Citizen.Wait(100) end
        if (#result == 0) then
            exports.bixbi_core:Notify('success', 'No bills found.')
            return
        end

        local elements = {}
        for _, v in pairs(result) do
            table.insert(elements, {id = #elements+1, header = '[' .. v.id .. '] £' .. v.amount, txt = v.senderJob .. ' | ' .. v.reason, params = {event = 'bixbi_billing:PayBillCheck', args = { id = v.id, job = v.senderJob, amount = v.amount }}})
        end
        exports['zf_context']:openMenu(elements)
    end)
end)

AddEventHandler('bixbi_billing:PayBillCheck', function(data)
    exports['zf_context']:openMenu({
        { id = 1, header = 'Pay Bill', txt = ' ',
            params = { event = 'bixbi_billing:PayBillConf', args = { id = data.id, job = data.job, amount = data.amount } }
        },
        { 
            id = 2, header = 'Cancel', txt = ' ', params = { event = 'bixbi_billing:BillingMenu' }
        }
    })
end)

AddEventHandler('bixbi_billing:PayBillConf', function(data)
    TriggerServerEvent('bixbi_billing:payBill', data.id, data.job, data.amount)
end)

AddEventHandler('bixbi_billing:BillingLookup', function()
    local dialog = exports['zf_dialog']:DialogInput({
        header = "Lookup Individual", 
        rows = {
            {
                id = 0, 
                txt = "First Name"
            },
            {
                id = 1, 
                txt = "Last Name"
            },
        }
    })
    if (dialog ~= nil) then
        if (dialog[1].input == nil or dialog[2].input == nil) then return end
        
        ESX.TriggerServerCallback('bixbi_billing:PlayerLookup', function(result)
            while (result == nil) do Citizen.Wait(100) end
            if (#result == 0) then
                exports.bixbi_core:Notify('success', 'No bills found.')
                return
            end
    
            local elements = {}
            for _, v in pairs(result) do
                table.insert(elements, {id = #elements+1, header = '[' .. v.id .. '] £' .. v.amount, txt = v.senderJob .. ' | ' .. v.reason})
            end
            exports['zf_context']:openMenu(elements)
        end, dialog[1].input, dialog[2].input)
    end
end)

--[[-----------------------------------------------------------------------
qTarget Setup
--]]-----------------------------------------------------------------------
function SetupTargets()
    exports['qtarget']:Vehicle({
        options = {
            {
                event = "bixbi_billing:FineDriver",
                icon = "fas fa-file-invoice-dollar",
                label = "[PD] Fine Driver",
                job = "police"
            },
        },
        distance = 2.0
    })
    
    exports['qtarget']:Player({
        options = {
            {
                event = "bixbi_billing:Bill",
                icon = "fas fa-file-invoice-dollar",
                label = "[PD] Fine",
                job = "police"
            },
            {
                event = "bixbi_billing:Bill",
                icon = "fas fa-file-invoice-dollar",
                label = "[EMS] Bill",
                job = "ambulance"
            },
            {
                event = "bixbi_billing:Bill",
                icon = "fas fa-file-invoice-dollar",
                label = "[MECH] Bill",
                job = "mechanic"
            },
        },
        distance = 2.0
    })
end

AddEventHandler('bixbi_billing:FineDriver', function(data)
    local ped = GetPedInVehicleSeat(data.entity, -1)
    if (ped == 0) then return end
    data.entity = ped
    TriggerEvent('bixbi_billing:Bill', data)
end)

AddEventHandler('bixbi_billing:Bill', function(data)
    local dialog = exports['zf_dialog']:DialogInput({
        header = "Send Bill", 
        rows = {
            {
                id = 0, 
                txt = "Reason"
            },
            {
                id = 1, 
                txt = "Amount"
            }
        }
    })
    if dialog ~= nil then
        if dialog[1].input == nil or dialog[2].input == nil then return end
        if (tonumber(dialog[2].input) == nil) then return end
        TriggerServerEvent('bixbi_billing:sendBill', GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)), dialog[1].input, tonumber(dialog[2].input))
    end
end)

--[[--------------------------------------------------
Setup
--]]--------------------------------------------------
AddEventHandler('onResourceStart', function(resourceName)
	if (resourceName == GetCurrentResourceName() and Config.Debug) then
        while (ESX == nil) do Citizen.Wait(100) end
        Citizen.Wait(5000)
        ESX.PlayerLoaded = true
        SetupTargets()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler("esx:playerLoaded", function(xPlayer)
	while (ESX == nil) do Citizen.Wait(100) end
    ESX.PlayerData = xPlayer
 	ESX.PlayerLoaded = true
    SetupTargets()
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)