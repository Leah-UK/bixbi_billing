Config = {
    Debug = false,
    Framework = 'ESX',      -- ESX, QBCORE. --> Use BLOCK CAPS.
    AllowedJobs = {         -- Add jobs that are able to give bills.
        police = { maxBill = 10000 },
        ambulance = { maxBill = 10000 },
        mechanic = { maxBill = 10000 }
    },
    Keybind = nil,          -- nil to disable. Example: 'k'
    Command = 'billingmenu',-- nil to disable.
    Days = 7,               -- How many days (IRL) you have to pay for the bills before they're automatically paid off.
                            -- Set to 0 or less to disable.
    WithdrawAccount = 'bank'-- Account to withdraw the money from.
}

Config.Target = {           -- Set to nil to disable (replace the entire {} block).
    type = 'qtarget',       -- qtarget, qbtarget
    police = {['police'] = 0}, -- https://overextended.github.io/qtarget/usage
    jobs = {['police'] = 0, ['ambulance'] = 0, ['mechanic'] = 0}
}

-- Config.Society = {          -- Set to nil to disable (replace the entire {} block).
--     MinimumValue = 0,       -- The lowest amount that the account can have.
--     MaximumValue = -1,      -- The maximum amount  that an account can have. -1 to disable.
--     Societies = {
--         ['police'] = {
--             enabled = true,
--             jobs = { 'police', 'fbi' }
--         },
--         ['emergency'] = {
--             enabled = false,
--             jobs = { 'police', 'fbi', 'ems' }
--         }
--     }
    
-- }