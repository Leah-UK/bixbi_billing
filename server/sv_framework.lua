b = { Framework = nil }
function b:GetFramework()
    if (self.Framework) then return end
    Config.Framework = Config.Framework:upper()
    if (Config.Framework == "ESX") then
        self.PlayerLoaded = 'esx:playerLoaded'
        TriggerEvent("esx:getSharedObject", function(obj) self.Framework = obj end)
    elseif (Config.Framework == "QBCORE") then
        self.PlayerLoaded = 'QBCore:Server:PlayerLoaded'
        self.Framework = exports['qb-core']:GetCoreObject()
    else
        -- Add in your framework related code here.
    end
end

function b:FrameworkEventHandlers()
    while (self['Framework'] == nil) do Citizen.Wait(100) end

    AddEventHandler(self['PlayerLoaded'], function(source, player)
        b.PlayerLoadedFunc(source, player)
    end)
end

function b.PlayerLoadedFunc(source, player)
    if (Config.Days == -1) then return end
    local currentTime = os.time()
    Citizen.Wait(10000)

    if (Config.Framework == "ESX") then
    elseif (Config.Framework == "QBCORE") then
    else
        -- Add in your framework related code here.
    end

    local playerIdentifier = b.GetIdentifier(player)
    local result = MySQL.query.await('SELECT * FROM bixbi_billing WHERE target = ?', { playerIdentifier })
    if (not result) then return end

    local bills = {}
    for _,v in pairs(result) do
        if ((os.difftime(tonumber(v.time), currentTime) * -1) > (Config.Days * 86400)) then
            TriggerEvent('bixbi_billing:PayBill', {id = v.id, job = v.senderjob, amount = v.amount, playerId = source})
        end
    end
end

function b:GetPlayerFromId(id)
    if (Config.Framework == "ESX") then
        return self['Framework'].GetPlayerFromId(id)
    elseif (Config.Framework == "QBCORE") then
        return self['Framework'].Functions.GetPlayer(id)
    else
        -- Add in your framework related code here.
    end
end

function b.RemoveAccountMoney(player, amount)
    if (Config.Framework == "ESX") then
        player.removeAccountMoney(Config.WithdrawAccount, amount)
        return true
    elseif (Config.Framework == "QBCORE") then
        player.Functions.RemoveMoney(Config.WithdrawAccount, amount)
        return true
    else
        -- Add in your framework related code here.
    end
    return false
end

function b.GetJob(player)
    if (Config.Framework == "ESX") then
        return player.job.name
    elseif (Config.Framework == "QBCORE") then
        return player.PlayerData.job.name
    else
        -- Add in your framework related code here.
    end
end

function b.GetIdentifier(player)
    if (Config.Framework == "ESX") then
        return player.getIdentifier()
    elseif (Config.Framework == "QBCORE") then
        return player.Functions.GetIdentifier()
    else
        -- Add in your framework related code here.
    end
end