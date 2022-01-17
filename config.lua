Config = {}

Config.Debug = false
Config.Time =  60 * 60000 -- How long after getting a Fine/Bill you automatically pay it.
Config.AllowedJobs = {
    police = { maxBill = 10000 },
    ambulance = { maxBill = 10000 },
    mechanic = { maxBill = 10000 }
}