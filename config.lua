Config = {}

Config.Debug = false -- Allows live-restarting of the script.
Config.AllowedJobs = { -- Add jobs that are able to give bills.
    police = { maxBill = 10000 },
    ambulance = { maxBill = 10000 },
    mechanic = { maxBill = 10000 }
} -- To give them qtarget capabilities you must edit SetupTargets() in client.lua.
Config.Keybind = nil    -- Set to 'k' for example.
Config.Command = 'billingmenu'
Config.DisableSocietyPayouts = false -- Set to true if you don't want to bill a persons job.
