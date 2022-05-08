b = { Framework = nil }

function b:GetPlayerFromId(id)
    if (Config.Framework == "ESX") then
        return self['Framework'].GetPlayerFromId(id)
    end
end

function b.RemoveAccountMoney(player, amount)
    if (Config.Framework == "ESX") then
        player.removeAccountMoney('bank', amount)
        return true
    end
    return false
end

function b.GetJob(player)
    if (Config.Framework == "ESX") then
        return player.job.name
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if (resourceName ~= GetCurrentResourceName()) then return end
    b:GetFramework()
    while (b['Framework'] == nil) do Citizen.Wait(100) end
    b:FrameworkEventHandlers()
end)

function b:GetFramework()
    if (self.Framework) then return end
    if (Config.Framework == "ESX") then
        self.PlayerLoaded = 'esx:playerLoaded'
        TriggerEvent("esx:getSharedObject", function(obj) self.Framework = obj end)
    end
end

function b:FrameworkEventHandlers()
    while (self['Framework'] == nil) do Citizen.Wait(100) end

    AddEventHandler(self['PlayerLoaded'], function(source, Player)
        if (Config.Days == -1) then return end
        local currentTime = os.time()
        Citizen.Wait(10000)

        local result = MySQL.query.await('SELECT * FROM bixbi_billing WHERE target = ?', { Player.identifier })
        if (not result) then return end

        local bills = {}
        for _,v in pairs(result) do
            if ((os.difftime(tonumber(v.time), currentTime) * -1) > (Config.Days * 86400)) then
                TriggerEvent('bixbi_billing:PayBill', {id = v.id, job = v.senderjob, amount = v.amount, playerId = source})
            end
        end
    end)
end

