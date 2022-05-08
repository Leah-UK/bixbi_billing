b = { Framework = nil }
function b.Notify(title, text, type)
    -- Replace code with your own notify script if you wish to change the default.
    lib.notify({title = title, description = text, type = type})
end
RegisterNetEvent('bixbi_billing:Notify', b.Notify)

function b.RegisterContext(data)
    lib.registerContext(data)
end
function b.ShowContext(id)
    lib.showContext(id)
end

function b:GetFramework()
    if (self.Framework ~= nil) then return end
    if (Config.Framework == "ESX") then
        self.PlayerLoaded = 'esx:playerLoaded'
        self.PlayerLogout = 'esx:onPlayerLogout'
        
        Citizen.CreateThread(function()
            while (self.Framework == nil) do
                TriggerEvent('esx:getSharedObject', function(obj) self.Framework = obj end)
                Citizen.Wait(10)
            end
        end)
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if (resourceName ~= GetCurrentResourceName()) then return end
    b:GetFramework()
    while (b['Framework'] == nil) do Citizen.Wait(100) end
    b:FrameworkEventHandlers()

    if (Config.Debug) then b['Framework'].PlayerLoaded = true end
    Target.Setup()
end)

function b:FrameworkEventHandlers()
    while (self['Framework'] == nil) do Citizen.Wait(100) end

    RegisterNetEvent(self['PlayerLoaded'])
    AddEventHandler(self['PlayerLoaded'], function(Player)
        Target.Setup()
        self['Framework'].PlayerData = Player
        self['Framework'].PlayerLoaded = true
    end)

    RegisterNetEvent(self['PlayerLogout'])
    AddEventHandler(self['PlayerLogout'], function()
        self['Framework'].PlayerData = {}
        self['Framework'].PlayerLoaded = false
    end)
end