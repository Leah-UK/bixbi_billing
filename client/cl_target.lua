Target = {}
function Target.Setup()
    if (not Config.Target) then return end
    Config.Target.type = Config.Target.type:upper()

    if (Config.Target.type == 'QTARGET') then
        Target.qTargetSetup()
    elseif (Config.Target.type == 'QBTARGET') then
        Target.qbTargetSetup()
    end
end

function Target.qTargetSetup()
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

function Target.qbTargetSetup()
    exports['qb-target']:AddGlobalVehicle({
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

    exports['qb-target']:AddGlobalPed({
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