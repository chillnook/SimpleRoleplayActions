Config = {}

Config.GLOBAL = {
    locale = 'en',
    displayTime = 6,
    textScale = 0.5,
    textColor = { 255, 230, 100 }, -- fallback color (RGB)
    radius = 20.0,
    baseHeight = 1.2,
    serverLogging = true,

    textShadow = {
        enabled = true,
        distance = 2,
        color = { 0, 0, 0, 255 },
    },
    textOutline = false,

    spam = {
        cooldownMs = 1000,
        burstLimit = 3,
        burstWindowMs = 10000,
        spamPrefix = nil,
        spamMessage = nil,
        allowAdminBypass = true,
        adminAcePermission = 'actiontext.bypass',
        notify = false,
    },
}

Config.ME = {
    color = { 100, 230, 255 },
    chat = false,
    chatColor = { 100, 230, 255 },
    chatPrefix = '[ME]: ',
    useChatPrefix = true,  
    chatPrefixFormat = '^*%s^*^7 ',
    chatFormat = '%s - ^*%s^*', 
    overheadFormat = '* %s *',
    suggestion = nil
}

Config.DO = {
    color = { 255, 230, 120 },
    chat = true,
    chatColor = { 255, 200, 80 },
    chatPrefix = '[DO]: ',
    useChatPrefix = true,
    chatPrefixFormat = '^*%s^*^7 ',
    chatFormat = '%s - ^*%s^*',
    overheadFormat = '* %s',
    suggestion = nil
}