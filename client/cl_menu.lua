Menu = {}

if (Config.Keybind) then RegisterKeyMapping(Config.Command, 'Billing Menu', 'keyboard', Config.Keybind) end
RegisterCommand(Config.Command, function()
    Menu:Open()
end, false)

function Menu:Open()
    self.bills = lib.callback.await('bixbi_billing:GetBills')
    if (not self.bills or #self.bills == 0) then
        b.Notify('Bills', 'No Bills Found.', 'error')
        return
    end

    local cMenu = {
        id = 'bixbi_billing_menu',
        title = 'Billing Menu'
    }

    local billItem = {}
    for _, v in pairs(self.bills) do
        billItem['[' .. v.id .. '] £' .. v.amount] = {
            description = v.senderjob .. ' | ' .. v.reason,
            arrow = true,
            event = 'bixbi_billing:PayBill',
            args = { id = v.id, job = v.senderjob, amount = v.amount }
        }
    end
    cMenu.options = billItem

    b.RegisterContext(cMenu)
    b.ShowContext('bixbi_billing_menu')
end
function OpenMenu() Menu:Open() end
RegisterNetEvent('bixbi_billing:OpenMenu', OpenMenu)

AddEventHandler('bixbi_billing:PayBill', function(data)
    local cMenu = {
        id = 'bixbi_billing_pay',
        title = 'Pay [' .. data.id .. ']',
        options = {
            ['Confirm'] = {
                metadata = {'Click to confirm payment.'},
                event = 'bixbi_billing:PayBillConf',
                args = data
            },
            ['Cancel'] = {
                metadata = {'Click to cancel payment.'},
                event = 'bixbi_billing:OpenMenu'
            }
        }
    }
    b.RegisterContext(cMenu)
    b.ShowContext('bixbi_billing_pay')
end)

AddEventHandler('bixbi_billing:PayBillConf', function(data)
    TriggerServerEvent('bixbi_billing:PayBill', {id = data.id, job = data.job, amount = data.amount})
end)

function Menu:BillLookup()
    local input = lib.inputDialog('Lookup Individual', {'First Name', 'Last Name'})
    if (not input) then return end

    local firstName = input[1]
    local targetBills = lib.callback.await('bixbi_billing:getBills', {firstname = firstName, lastname = input[2]})
    if (not targetBills or #targetBills == 0) then
        b.Notify('Bills', 'No Bills Found.', 'error')
        return
    end

    local cMenu = {
        id = 'bixbi_billing_lookup_menu',
        title = 'Billing Lookup - ' .. firstName
    }

    local billItem = {}
    for _, v in pairs(self.bills) do
        billItem['[' .. v.id .. '] £' .. v.amount] = {
            description = v.senderjob .. ' | ' .. v.reason
        }
    end
    cMenu.options = billItem
    b.RegisterContext(cMenu)
    b.ShowContext('bixbi_billing_lookup_menu')
end
function OpenLookupMenu() Menu:BillLookup() end
RegisterNetEvent('bixbi_billing:OpenLookupMenu', OpenLookupMenu)