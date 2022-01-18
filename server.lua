ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

local onTimer = {}
ESX.RegisterCommand('sendbill', 'superadmin', function(xPlayer, args, showError)
	TriggerEvent('bixbi_billing:sendBill', args.target, args.reason, args.amount, xPlayer.playerId)
end, true, {help = 'Send player a bill. Used for dev.', validate = false, arguments = {
	{name = 'target', help = 'Player ID', type = 'number'},
    {name = 'amount', help = 'Amount', type = 'number'},
	{name = 'reason', help = 'Reason for the Bill', type = 'string'}
}})

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local currentTime = os.time()
    Citizen.Wait(10000)
	exports.oxmysql.query('SELECT * FROM bixbi_billing WHERE target = ?', { xPlayer.identifier }, 
	function(result)
		local bills = {}
        for i=1, #result, 1 do
            if ((os.difftime(tonumber(result[i].time), currentTime) * -1) > 604800) then
                TriggerEvent('bixbi_billing:payBill', result[i].id, result[i].senderjob, result[i].amount, source)
            end
        end
	end)
end)

ESX.RegisterServerCallback('bixbi_billing:getBills', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

	exports.oxmysql.query('SELECT * FROM bixbi_billing WHERE target = ?', { xPlayer.identifier },
    function(result)
        local bills = {}
        for i=1, #result, 1 do
            table.insert(bills, {
                id = result[i].id,
                sender = result[i].sender,
                senderJob = result[i].senderjob,
                reason = result[i].reason,
                target = result[i].target,
                amount = result[i].amount
            })
        end
        cb(bills)
    end)
end)

RegisterServerEvent('bixbi_billing:sendBill')
AddEventHandler('bixbi_billing:sendBill', function(targetId, reason, amount, playerId)
    if ((source == nil or source == '') and playerId ~= nil) then source = playerId end
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if onTimer[xPlayer.playerId] and onTimer[xPlayer.playerId] > GetGameTimer() then
        local timeLeft = (onTimer[xPlayer.playerId] - GetGameTimer()) / 1000
        TriggerClientEvent('bixbi_core:Notify', source, 'error', 'Please wait ' .. tostring(ESX.Math.Round(timeLeft)) .. ' seconds before sending another bill')
        return
    end

    if (Config.AllowedJobs[xPlayer.job.name] == nil) then
        print(xPlayer.identifier .. ' (' .. xPlayer.playerId .. ') has tried to send a bill.')
        xTarget.triggerEvent('bixbi_core:Notify', 'error', 'You are unable to do this')
        return
    end

    if (amount > Config.AllowedJobs[xPlayer.job.name].maxBill) then 
        amount = Config.AllowedJobs[xPlayer.job.name].maxBill
        xPlayer.triggerEvent('bixbi_core:Notify', 'error', 'Fine exceeded max bill amount, bill has been reduced to the max (' .. amount .. ')')
    end
    
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xTarget.job.name, function(account)
        if (account == nil or account.money < amount) then
            exports.oxmysql.insert('INSERT INTO bixbi_billing (sender, senderJob, reason, target, amount, time) VALUES (?, ?, ?, ?, ?, ?)', {
                xPlayer.identifier, xPlayer.job.name, reason, xTarget.identifier, amount, os.time()
            },
            function(rowid)
                xTarget.triggerEvent('bixbi_core:Notify', 'error', 'You have received a bill from ' .. xPlayer.name .. ' with the value of $' .. amount, 10000)
            end)
        else
            account.removeMoney(amount)
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xPlayer.job.name, function(sourceaccount)
                if (sourceaccount ~= nil) then
                    sourceaccount.addMoney(amount)
                    xTarget.triggerEvent('bixbi_core:Notify', 'error', 'Your society has paid a bill of $' .. amount, 10000)
                end
            end)
        end
    end)

    xPlayer.triggerEvent('bixbi_core:Notify', 'success', 'You have sent a bill of $' .. amount .. ' to ' .. xTarget.name, 10000)
    onTimer[xPlayer.playerId] = GetGameTimer() + (10 * 1000)
end)

RegisterServerEvent('bixbi_billing:payBill')
AddEventHandler('bixbi_billing:payBill', function(id, job, amount, playerId)
    if ((source == nil or source == '') and playerId ~= nil) then source = playerId end
    local xPlayer = ESX.GetPlayerFromId(source)
    local accountInfo = xPlayer.getAccount('bank')

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(account)
        if (account ~= nil) then
            account.addMoney(amount)
        end
    end)
    xPlayer.removeAccountMoney('bank', amount)
    exports.oxmysql.execute('DELETE FROM bixbi_billing WHERE id = @id', { ['@id'] = id } )
    xPlayer.triggerEvent('bixbi_core:Notify', 'success', 'You have paid a bill of $' .. amount, 10000)
end)

ESX.RegisterServerCallback('bixbi_billing:PlayerLookup', function(source, cb, firstname, lastname)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer.job.name ~= 'police') then return end

    exports.oxmysql.query('SELECT identifier FROM users WHERE firstname = ? and lastname = ?', { firstname, lastname, }, 
    function(result)
        for _,v in pairs(result) do
            local identifier = v.identifier
            if (identifier ~= nil) then
                exports.oxmysql.query('SELECT * FROM bixbi_billing WHERE target = @target', {
                    ['@target'] = identifier
                },
                function(result)
                    local bills = {}
                    for i=1, #result, 1 do
                        table.insert(bills, {
                            id = result[i].id,
                            sender = result[i].sender,
                            senderJob = result[i].senderjob,
                            reason = result[i].reason,
                            target = result[i].target,
                            amount = result[i].amount
                        })
                    end
                    cb(bills)
                end)
            end
        end
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetResourceState('bixbi_core') ~= 'started' ) then
        print('Bixbi_Billing - ERROR: Bixbi_Core hasn\'t been found! This could cause errors!')
    end
end)