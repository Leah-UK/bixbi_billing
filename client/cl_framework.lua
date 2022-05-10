b = { Framework = nil }
function b:GetFramework()
    if (self.Framework ~= nil) then return end
    Config.Framework = Config.Framework:upper()
    if (Config.Framework == "ESX") then
        self.PlayerLoaded = 'esx:playerLoaded'
        self.PlayerLogout = 'esx:onPlayerLogout'
        
        Citizen.CreateThread(function()
            while (self.Framework == nil) do
                TriggerEvent('esx:getSharedObject', function(obj) self.Framework = obj end)
                Citizen.Wait(10)
            end
        end)
    elseif (Config.Framework == "QBCORE") then
        self.PlayerLoaded = 'QBCore:Client:OnPlayerLoaded'
        self.PlayerLogout = 'QBCore:Client:OnPlayerUnload'
        
        Citizen.CreateThread(function()
            while (self.Framework == nil) do
                self.Framework = exports['qb-core']:GetCoreObject()
                Citizen.Wait(10)
            end
        end)
    else
        -- Add in your framework related code here.
    end
end

function b:FrameworkEventHandlers()
    while (self['Framework'] == nil) do Citizen.Wait(100) end

    RegisterNetEvent(self['PlayerLoaded'])
    AddEventHandler(self['PlayerLoaded'], function(player)
        Target.Setup()
        b:PlayerLoadedFunc(player)
    end)

    RegisterNetEvent(self['PlayerLogout'])
    AddEventHandler(self['PlayerLogout'], function()
        b:PlayerLogoutFunc()
    end)
end

function b:PlayerLoadedFunc(player)
    if (Config.Framework == "ESX") then
        if (player) then self['Framework'].PlayerData = player end
        self['Framework'].PlayerLoaded = true
    elseif (Config.Framework == "QBCORE") then
        self['Framework'].PlayerData = self['Framework'].Functions.GetPlayerData()
        self['Framework'].PlayerLoaded = true
    else
        -- Add in your framework related code here.
    end
end

function b:PlayerLogoutFunc()
    if (Config.Framework == "ESX") then
        self['Framework'].PlayerData = {}
        self['Framework'].PlayerLoaded = false
    elseif (Config.Framework == "QBCORE") then
        self['Framework'].PlayerData = {}
        self['Framework'].PlayerLoaded = false
    else
        -- Add in your framework related code here.
    end    
end