local mutedPlayers = {}

function MutePlayer(playerId, duration, source)
    mutedPlayers[playerId] = true
    TriggerClientEvent('chat:addMessage', playerId, {
        template = '<div class="chat-message server"><b>SYSTEM:</b> You have been muted for ' .. duration .. ' minutes.</div>',
        args = {}
    })
    Citizen.SetTimeout(duration * 60000, function()
        mutedPlayers[playerId] = nil
        TriggerClientEvent('chat:addMessage', playerId, {
            template = '<div class="chat-message server"><b>SYSTEM:</b> Your mute has expired. You can now chat again.</div>',
            args = {}
        })
    end)
end

function UnmutePlayer(playerId, source)
    if mutedPlayers[playerId] then
        mutedPlayers[playerId] = nil
        TriggerClientEvent('chat:addMessage', playerId, {
            template = '<div class="chat-message server"><b>SYSTEM:</b> Your mute has been removed. You can now chat again.</div>',
            args = {}
        })
    else
        TriggerClientEvent('chat:addMessage', playerId, {
            template = '<div class="chat-message server"><b>SYSTEM:</b> You are not currently muted.</div>',
            args = {}
        })
    end
end

exports("getMutedPlayers", function()
    return mutedPlayers
end)

AddEventHandler("chatMessage", function(source, color, message)
    local src = source

    if mutedPlayers[src] then
        TriggerClientEvent('chat:addMessage', src, {
            template = '<div class="chat-message server"><b>SYSTEM:</b> You are currently muted and cannot send messages.</div>',
            args = {}
        })
        CancelEvent()
        return
    end

    args = stringsplit(message, " ")
    CancelEvent()

    if string.lower(message) == "/dv" then
        return
    end

    if string.find(args[1], "/") then
        local cmd = args[1]
        table.remove(args, 1)
        if cmd == "/ooc" then
            local user = GetPlayerName(src)
            local serverId = src
            local identifier = GetPlayerIdentifiers(src)[1]
            local chatRole = exports.DiscordChatRoles:GetChatRoleByIdentifier(identifier)
            local chatRoleStr = chatRole and chatRole .. ' ' or ''
            TriggerEvent("knight-serverlogs:internal:logevent", {webhook = 'chat', color = 'white', src = src, title = "New Chat Message", msg = table.concat(args, " ")})
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div class="chat-message"><b>(OOC) {0}{1} ({2}):</b> <br>{3}</div>',
                args = { chatRoleStr, user, serverId, table.concat(args, " ") }
            })
        else
            TriggerClientEvent('chat:addMessage', src, {
                template = '<div class="chat-message server"><b>SYSTEM:</b> Invalid Command</div>',
                args = { message }
            })
        end
    else
        local user = GetPlayerName(src)
        local serverId = src
        local identifier = GetPlayerIdentifiers(src)[1]
        local chatRole = exports.DiscordChatRoles:GetChatRoleByIdentifier(identifier)
        local chatRoleStr = chatRole and chatRole .. ' ' or ''
        TriggerEvent("knight-serverlogs:internal:logevent", {webhook = 'chat', color = 'white', src = src, title = "New Chat Message", msg = message})
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div class="chat-message"><b>(OOC) {0}{1} ({2}):</b> <br>{3}</div>',
            args = { chatRoleStr, user, serverId, message }
        })
    end
end)

local tipList = {
    "Want to have your own Custom Ped? Purchase one on our store at store.rivalroleplay.com",
    "Join our discord for updates, giveaways and much more! discord.gg/rivalroleplay",
    "Have a report to make on a player? Use /calladmin and our staff will happily help you!",
    "Want to own your own property? Purchase a Custom MLO on our store, store.rivalroleplay.com"
}

local currentTipIndex = 1

function ShowNextTip()
    local currentTip = tipList[currentTipIndex]
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="tip"><b>Server Tip:</b> {0}</div>',
        args = { currentTip }
    })
    currentTipIndex = currentTipIndex + 1
    if currentTipIndex > #tipList then
        currentTipIndex = 1
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(600000) -- 10 minutes in milliseconds
        ShowNextTip()
    end
end)

RegisterServerEvent('chat:server:ServerPSA')
AddEventHandler('chat:server:ServerPSA', function(message)
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div class="chat-message server">SERVER: {0}</div>',
        args = { message }
    })
    CancelEvent()
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end