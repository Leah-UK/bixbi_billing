lib.callback.register('bixbi_billing:GetBills', function()
	return MySQL.query.await('SELECT * FROM bixbi_billing WHERE target = ?', { b:GetPlayerIdentifier(b:GetPlayerFromId(source)) })
end)

lib.callback.register('bixbi_billing:PlayerLookup', function(source, data)
    local result = nil
    if (Config.Framework == "ESX") then
        result = MySQL.query.await('SELECT identifier FROM users WHERE firstname = ? and lastname = ?', { data.firstname, data.lastname })
    elseif (Config.Framework == "QBCORE") then
        print(GetCurrentResourceName() .. ': You cannot do this on QBCore because of the way in which finding players by their first and last name works.')
        return nil
    else
        -- Add in your framework related code here.
    end

    if (not result) then return nil end

    for _,v in pairs(result) do
        local identifier = v.identifier
        if (identifier) then
            return MySQL.query.await('SELECT * FROM bixbi_billing WHERE target = ?', { identifier })
        end
    end
end)