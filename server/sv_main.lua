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
    -- local target = b:GetPlayerFromId(data.targetId)

    if onTimer[player.playerId] and onTimer[player.playerId] > GetGameTimer() then
        local timeLeft = (onTimer[player.playerId] - GetGameTimer()) / 1000
        TriggerClientEvent('bixbi_billing:Notify', source, 'Send Bill', 'Please wait ' .. tostring(timeLeft) .. ' seconds before sending another bill', 'error')
        return
    end

    local playerJob = b.GetJob(player)
    if (Config.AllowedJobs[playerJob] == nil) then
        print(player.identifier .. ' (' .. player.playerId .. ') has tried to send a bill.')
        TriggerClientEvent('bixbi_billing:Notify', source, 'Send Bill', 'You are unable to do this', 'error')
        return
    end

    if (data.amount > Config.AllowedJobs[playerJob].maxBill) then 
        data.amount = Config.AllowedJobs[playerJob].maxBill
        TriggerClientEvent('bixbi_billing:Notify', source, 'Send Bill', 'Fine exceeded max bill amount, bill has been reduced to the max (' .. data.amount .. ')', 'error')
    end
    
    MySQL.insert('INSERT INTO bixbi_billing (sender, senderJob, reason, target, amount, time) VALUES (?, ?, ?, ?, ?, ?)', {
        player.identifier, playerJob, data.reason, target.identifier, data.amount, os.time() },
    function(rowid)
        TriggerClientEvent('bixbi_billing:Notify', data.targetId, 'Bill', 'You have received a bill from ' .. player.name .. ' with the value of $' .. data.amount, 'error')
    end)

    TriggerClientEvent('bixbi_billing:Notify', source, 'Send Bill', 'You have sent a bill of $' .. data.amount .. ' to ' .. target.name, 'success')
    onTimer[player.playerId] = GetGameTimer() + (10 * 1000)
end)