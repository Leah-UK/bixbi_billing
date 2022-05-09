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

AddEventHandler('onResourceStart', function(resourceName)
    if (resourceName ~= GetCurrentResourceName()) then return end
    b:GetFramework()
    while (b['Framework'] == nil) do Citizen.Wait(100) end
    b:FrameworkEventHandlers()

    if (Config.Debug) then b:PlayerLoadedFunc() end
    Target.Setup()
end)