lib.callback.register('bixbi_billing:GetBills', function()
    local player = b:GetPlayerFromId(source)
	return MySQL.query.await('SELECT * FROM bixbi_billing WHERE target = ?', { player.identifier })
end)

lib.callback.register('bixbi_billing:PlayerLookup', function(data)
    print(data.firstname)
    print(data.lastname)
    local result = MySQL.query.await('SELECT identifier FROM users WHERE firstname = ? and lastname = ?', { data.firstname, data.lastname })
    if (not result) then return nil end

    for _,v in pairs(result) do
        local identifier = v.identifier
        if (identifier) then
            return MySQL.query.await('SELECT * FROM bixbi_billing WHERE target = ?', { identifier })
        end
    end
end)