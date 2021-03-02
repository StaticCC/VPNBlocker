-- Coded by Static#3780
--
AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local player = source
    local name, setKickReason, deferrals = name, setKickReason, deferrals;
    local ipIdentifier
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()
    Wait(0)
    deferrals.update(string.format("Hello %s. Your IP Address is being checked.", name))
	print(string.format("Checking %s\'s IP address!", name))
    for _, v in pairs(identifiers) do
        if string.find(v, "ip") then
            ipIdentifier = v:sub(4)
            break
        end
    end
    Wait(0)
    if not ipIdentifier then
        deferrals.done("We could not find your IP Address.")
		print(string.format("Failed to get %s IP address!", name))
    else
        PerformHttpRequest("http://ip-api.com/json/" .. ipIdentifier .. "?fields=proxy", function(err, text, headers)
            if tonumber(err) == 200 then
                local tbl = json.decode(text)
                if tbl["proxy"] == false then
                    deferrals.done()
					print(string.format("%s passed VPN detection! IP:" .. ipIdentifier, name))
                else
                    deferrals.done("You are using a VPN. Please disable and try again. If the issue persists, please contact staff at http://discord.gg/affinityrp")
					print(string.format("%s failed VPN detection! Using a VPN. IP: " .. ipIdentifier, name))
                end
            else
                deferrals.done("There was an error in the API. Please contact staff at http://discord.gg/affinityrp")
				print(string.format("%s failed VPN detection! ERROR IN API", name))
            end
        end)
    end
end)
