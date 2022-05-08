AddEventHandler('onResourceStart', function(resourceName)
    if (resourceName ~= GetCurrentResourceName()) then return end
    local currentVersion, versionURL = GetResourceMetadata(resourceName, 'version'), GetResourceMetadata(resourceName, 'versioncheck')
    if (not currentVersion or not versionURL) then return end

    Citizen.CreateThread(function()
        Citizen.Wait(5000)

        PerformHttpRequest(versionURL, function (errorCode, resultData, resultHeaders)
            if errorCode ~= 200 then print("Returned error code:" .. tostring(errorCode)) else
                local data, version = tostring(resultData)
                for line in data:gmatch("([^\n]*)\n?") do if line:find('^version ') then version = line:sub(10, (line:len(line) - 1)) break end end
                
                if (not version) then return end
                local latestVersion = tonumber(version) or version

                local outdated = '^3[' .. resourceName .. ']^7 - You can upgrade to ^2v%s^7 (currently using ^1v%s^7)'
                if (type(latestVersion) == 'string') then
                    if (currentVersion ~= latestVersion) then print(outdated:format(latestVersion, currentVersion)) end
                else
                    if (currentVersion < latestVersion) then print(outdated:format(latestVersion, currentVersion)) end
                end
            end
        end)
    end)
end)

