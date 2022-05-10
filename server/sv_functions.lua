AddEventHandler('onResourceStart', function(resourceName)
    if (resourceName ~= GetCurrentResourceName()) then return end
    b:GetFramework()
    while (b['Framework'] == nil) do Citizen.Wait(100) end
    b:FrameworkEventHandlers()
end)

local onTimer = {}
RegisterServerEvent('bixbi_billing:PayBill')
AddEventHandler('bixbi_billing:PayBill', function(data) -- id, job, amount, playerId
    if (type(data) ~= 'table') then return end
    if ((not source or source == '') and data.playerId) then source = data.playerId end
    
    local player = b:GetPlayerFromId(source)
    local result = b.RemoveAccountMoney(player, data.amount)
    if (not result) then
        print('There was an issue with removing money from your account. Please inform the staff team.')
        return
    end

    MySQL.update('DELETE FROM bixbi_billing WHERE id = ?', { data.id })
    TriggerClientEvent('bixbi_billing:Notify', source, 'Bill Paid', 'You have paid a bill of $' .. data.amount, 'success')
end)


RegisterServerEvent('bixbi_billing:SendBill')
AddEventHandler('bixbi_billing:SendBill', function(data) -- targetId, reason, amount, playerId
    if (type(data) ~= 'table') then return end
    if ((not source or source == '') and data.playerId) then source = data.playerId end

    local player, target = b:GetPlayerFromId(source), b:GetPlayerFromId(data.targetId)
    if (not player or not target) then return end

    if onTimer[source] and onTimer[source] > GetGameTimer() then
        local timeLeft = (onTimer[source] - GetGameTimer()) / 1000
        TriggerClientEvent('bixbi_billing:Notify', source, 'Send Bill', 'Please wait ' .. tostring(timeLeft) .. ' seconds before sending another bill', 'error')
        return
    end

    local playerJob, playerIdentifier = b.GetPlayerJob(player), b:GetPlayerIdentifier(player)
    
    if (Config.AllowedJobs[playerJob] == nil) then
        print(playerIdentifier .. ' (' .. source .. ') has tried to send a bill.')
        TriggerClientEvent('bixbi_billing:Notify', source, 'Send Bill', 'You are unable to do this', 'error')
        return
    end

    if (data.amount > Config.AllowedJobs[playerJob].maxBill) then 
        data.amount = Config.AllowedJobs[playerJob].maxBill
        TriggerClientEvent('bixbi_billing:Notify', source, 'Send Bill', 'Fine exceeded max bill amount, bill has been reduced to the max (' .. data.amount .. ')', 'error')
    end
    
    MySQL.insert('INSERT INTO bixbi_billing (sender, senderJob, reason, target, amount, time) VALUES (?, ?, ?, ?, ?, ?)', {
        playerIdentifier, playerJob, data.reason, b:GetPlayerIdentifier(target), data.amount, os.time() },
    function(rowid)
        TriggerClientEvent('bixbi_billing:Notify', data.targetId, 'Bill', 'You have received a bill from ' .. b.GetPlayerName(player) .. ' with the value of $' .. data.amount, 'error')
    end)

    TriggerClientEvent('bixbi_billing:Notify', source, 'Send Bill', 'You have sent a bill of $' .. data.amount .. ' to ' .. b.GetPlayerName(target), 'success')
    onTimer[source] = GetGameTimer() + (10 * 1000)
end)