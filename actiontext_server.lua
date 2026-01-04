RegisterNetEvent('actiontext:send')
AddEventHandler('actiontext:send', function(actionType, text)
    local src = source
    local playerName = GetPlayerName(src) or ('Player' .. tostring(src))

    local lang = (Config.GLOBAL and Config.GLOBAL.lang) or {}

    if not global_spam_tracker then global_spam_tracker = {} end
    local now = (os.time() * 1000)
    local spamCfg = (Config.GLOBAL and Config.GLOBAL.spam) or { cooldownMs = 1000, burstLimit = 3, burstWindowMs = 10000 }
    local s = global_spam_tracker[src]
    if not s then
        s = { times = {} }
        global_spam_tracker[src] = s
    end

    local newTimes = {}
    for _, t in ipairs(s.times) do
        if now - t <= spamCfg.burstWindowMs then table.insert(newTimes, t) end
    end
    s.times = newTimes

    local isAdmin = false
    if spamCfg and spamCfg.allowAdminBypass and spamCfg.adminAcePermission then
        pcall(function()
            isAdmin = IsPlayerAceAllowed(src, spamCfg.adminAcePermission)
        end)
    end

    if not isAdmin and #s.times >= spamCfg.burstLimit then
        if spamCfg.notify ~= false then
            local prefix = (spamCfg and spamCfg.spamPrefix) or lang.spamPrefix or 'SPAM'
            local msg = (spamCfg and spamCfg.spamMessage) or lang.spamMessage or 'You are sending actions too quickly. Please slow down.'
            TriggerClientEvent('chat:addMessage', src, { color = { 255, 100, 100 }, args = { prefix, msg } })
        end
        return
    end

    if not isAdmin and #s.times > 0 then
        local last = s.times[#s.times]
        if now - last < spamCfg.cooldownMs then
            if spamCfg.notify ~= false then
                local prefix = (spamCfg and spamCfg.spamPrefix) or lang.spamPrefix or 'SPAM'
                local msg = (spamCfg and spamCfg.spamMessage) or lang.spamMessage or 'Please wait before sending another action.'
                TriggerClientEvent('chat:addMessage', src, { color = { 255, 100, 100 }, args = { prefix, msg } })
            end
            return
        end
    end

    table.insert(s.times, now)

    if Config.GLOBAL and Config.GLOBAL.serverLogging then
        print(('[ActionText] /%s from %s (id=%s): %s'):format(actionType, playerName, tostring(src), text))
    end

    TriggerClientEvent('actiontext:display', -1, src, actionType, text)

    local postChat = false
    local chatColor = { 255, 183, 0 }
    local formatted = ('%s %s'):format(playerName, text)

    if actionType == 'me' and Config.ME and Config.ME.chat then
        postChat = true
        chatColor = (Config.ME.chatColor or chatColor)

        formatted = (Config.ME.chatFormat or '%s %s'):format(playerName, text)
        if Config.ME.useChatPrefix and Config.ME.chatPrefix then
            local pf = (Config.ME.chatPrefixFormat or '^*%s^*^7 ')
            formatted = (pf:format(Config.ME.chatPrefix) or '') .. formatted
        else
            formatted = '^7' .. formatted
        end
    elseif actionType == 'do' and Config.DO and Config.DO.chat then
        postChat = true
        chatColor = (Config.DO.chatColor or chatColor)

        formatted = (Config.DO.chatFormat or '%s %s'):format(playerName, text)
        if Config.DO.useChatPrefix and Config.DO.chatPrefix then
            local pf = (Config.DO.chatPrefixFormat or '^*%s^*^7 ')
            formatted = (pf:format(Config.DO.chatPrefix) or '') .. formatted
        else
            formatted = '^7' .. formatted
        end
    end
    if postChat then
        TriggerClientEvent('chat:addMessage', -1, {
            color = chatColor,
            multiline = true,
            args = { formatted }
        })
    end
end)