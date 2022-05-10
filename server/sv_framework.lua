b = { Framework = nil }
function b:GetFramework()
    if (self.Framework) then return end
    if (not Config.Framework or Config.Framework == '') then print("^3[bixbi_billing]^7 You must set your Framework in sh_config.lua") end

    Config.Framework = Config.Framework:upper() -- Makes framework checks use ALL CAPS. To remove case-sensitivity issues.
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
    if (Config.Days < 1) then return end
    local currentTime = os.time()
    Citizen.Wait(10000)

    if (Config.Framework == "ESX") then
    elseif (Config.Framework == "QBCORE") then
    else
        -- Add in your framework related code here.
    end

    local result = MySQL.query.await('SELECT * FROM bixbi_billing WHERE target = ?', { b.GetPlayerIdentifier(player) })
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
    if (not player) then return end
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

function b.GetPlayerJob(player)
    if (not player) then return end
    if (Config.Framework == "ESX") then
        return player.job.name
    elseif (Config.Framework == "QBCORE") then
        return player.PlayerData.job.name
    else
        -- Add in your framework related code here.
    end
end

function b:GetPlayerIdentifier(player)
    if (not player) then return end
    if (Config.Framework == "ESX") then
        return player.identifier
    elseif (Config.Framework == "QBCORE") then
        return self['Framework'].Functions.GetIdentifier(player.PlayerData.source, 'license')
    else
        -- Add in your framework related code here.
    end
end

function b.GetPlayerServerId(player)
    if (not player) then return end
    if (Config.Framework == "ESX") then
        return player.playerId
    elseif (Config.Framework == "QBCORE") then
        return player.PlayerData.source
    else
        -- Add in your framework related code here.
    end
end

function b.GetPlayerName(player)
    if (not player) then return end
    if (Config.Framework == "ESX") then
        return player.name
    elseif (Config.Framework == "QBCORE") then
        return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
    else
        -- Add in your framework related code here.
    end
end