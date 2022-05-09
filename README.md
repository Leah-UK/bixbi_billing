### <p align='center'>[Organisation](https://github.com/Bixbi-FiveM) | [Support Me Here](https://ko-fi.com/bixbi) | [FiveM Profile](https://forum.cfx.re/u/Leah_UK/summary)</p>
------

# Information

[**Bixbi_Billing**](https://forum.cfx.re/t/free-bixbi-billing/4803834) is a *simple* billing script. Intended to be used on FiveM Roleplaying Servers.

Originally created to combat hackers/script-kiddies that found it fun to send random, usually racist, bills to everyone on the server. Using this script you can limit bills being sent to a specific job, you can further limit the amount amount that a bill can be. ***Optionally*** you're able to enable the use of target scripts (*such as qtarget*). Furthermore, you have the ability to open a "search for bill" menu, where a job (*such as the police*) can search a players bills using their First and Last **RP** name.

### [Demonstration Video](https://youtu.be/gTbI0aiX9mw)

---

# Requirements

- [ox_lib](https://github.com/overextended/ox_lib)
- [oxmysql](https://github.com/overextended/oxmysql)

---

# Exports

## Client

#### Open Menu
```lua
TriggerEvent('bixbi_billing:OpenMenu') -- sent from client
TriggerClientEvent('bixbi_billing:OpenMenu', source) -- sent from server
```
#### Open Lookup Menu
```lua
TriggerEvent('bixbi_billing:OpenLookupMenu') -- sent from client
TriggerClientEvent('bixbi_billing:OpenLookupMenu', source) -- sent from server
```

## Server

#### Send Bill
```lua
local data = {
  targetId = id, -- int
  reason = "string", -- string
  amount = 100, -- int
  playerId = nil -- int, only required when event is sent from *server*. If sent from client this is automatic.
}

TriggerServerEvent('bixbi_billing:SendBill', data) -- sent from client
TriggerEvent('bixbi_billing:SendBill, data) -- sent from server
```

---
<p align='center'>Feel free to modify to your liking. Please keep my name <b>(Leah#0001)</b> in the credits of the fxmanifest. <i>If your modification is a bug-fix I ask that you make a pull request, this is a free script; please contribute when you can.</i></p>
