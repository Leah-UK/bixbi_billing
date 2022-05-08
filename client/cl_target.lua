Target = {}
function Target.Setup()
    print('here')
    if (not Config.Target) then return end

    if (Config.Target.type == 'qtarget') then
        Target.qTargetSetup()
    end
end

function Target.qTargetSetup()
    print('here2')
    exports['qtarget']:Vehicle({
        options = {
            {
                event = "bixbi_billing:FineDriver",
                icon = "fas fa-file-invoice-dollar",
                label = "Fine Driver",
                job = Config.Target.police
            },
        },
        distance = 2.0
    })

    exports['qtarget']:Player({
        options = {
            {
                event = "bixbi_billing:Bill",
                icon = "fas fa-file-invoice-dollar",
                label = "Bill",
                job = Config.Target.jobs
            }
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
    local input = lib.inputDialog('Send Bill', {'Reason', 'Amount'})
    if (not input) then return end
    TriggerServerEvent('bixbi_billing:SendBill', {targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)), reason = input[1], amount = tonumber(input[2])})
end)