local activeTexts = {}

local function addText(serverId, actionType, text)
    local player = GetPlayerFromServerId(serverId)
    if player == -1 then return end
    local ped = GetPlayerPed(player)
    if not DoesEntityExist(ped) then return end

    local coords = GetEntityCoords(ped)
    local color = (Config.GLOBAL and Config.GLOBAL.textColor) or {255,255,255}
    if actionType == 'me' and Config.ME and Config.ME.color then
        color = Config.ME.color
    elseif actionType == 'do' and Config.DO and Config.DO.color then
        color = Config.DO.color
    end

    local fmt = '%s'
    if actionType == 'me' and Config.ME and Config.ME.overheadFormat then
        fmt = Config.ME.overheadFormat
    elseif actionType == 'do' and Config.DO and Config.DO.overheadFormat then
        fmt = Config.DO.overheadFormat
    end
    text = string.format(fmt, text)

        activeTexts[serverId] = {
        serverId = serverId,
        actionType = actionType,
        text = text,
        coords = coords,
        color = color,
            expireAt = GetGameTimer() + ((Config.GLOBAL and Config.GLOBAL.displayTime or 6) * 1000)
    }
end

local function DrawText3D(x, y, z, text, scale, color)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    if onScreen then
            SetTextScale(scale, scale)
            SetTextFont(0)
            SetTextProportional(1)
            if Config.GLOBAL and Config.GLOBAL.textShadow and Config.GLOBAL.textShadow.enabled then
                local sd = Config.GLOBAL.textShadow.distance or 2
                local sc = Config.GLOBAL.textShadow.color or {0,0,0,255}
                SetTextDropshadow(sd, sc[1] or 0, sc[2] or 0, sc[3] or 0, sc[4] or 255)
            end
            if Config.GLOBAL and Config.GLOBAL.textOutline then
                SetTextOutline()
            end
            SetTextColour(color[1], color[2], color[3], 255)
        SetTextCentre(1)
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

Citizen.CreateThread(function()
    while true do
        local now = GetGameTimer()
        local redraw = false

        for id, item in pairs(activeTexts) do
            if item.expireAt <= now then
                activeTexts[id] = nil
            else
                redraw = true
            end
        end

        if redraw then
            for _, item in pairs(activeTexts) do
                local player = GetPlayerFromServerId(item.serverId)
                if player ~= -1 then
                    local ped = GetPlayerPed(player)
                    if DoesEntityExist(ped) then
                        local coords = GetEntityCoords(ped)
                        local z = coords.z + ((Config.GLOBAL and Config.GLOBAL.baseHeight) or 1.2)
                        local distance = #(GetEntityCoords(PlayerPedId()) - coords)
                        if distance <= ((Config.GLOBAL and Config.GLOBAL.radius) or 20.0) then
                            DrawText3D(coords.x, coords.y, z, item.text, ((Config.GLOBAL and Config.GLOBAL.textScale) or 0.5), item.color)
                        end
                    end
                end
            end
            Wait(0)
        else
            Wait(250)
        end
    end
end)

local function sendAction(actionType, text)
    if not text or text == '' then
        local title = (Config.GLOBAL and Config.GLOBAL.lang and Config.GLOBAL.lang.usageTitle) or '^1Actions'
        local fmt = (Config.GLOBAL and Config.GLOBAL.lang and Config.GLOBAL.lang.usageFormat) or 'Usage: /%s <message>'
        TriggerEvent('chat:addMessage', { args = { title, string.format(fmt, actionType) } })
        return
    end

    TriggerServerEvent('actiontext:send', actionType, text)
end

RegisterCommand('me', function(source, args)
    local text = table.concat(args, ' ')
    sendAction('me', text)
end, false)

RegisterCommand('do', function(source, args)
    local text = table.concat(args, ' ')
    sendAction('do', text)
end, false)

Citizen.CreateThread(function()
    local lang = (Config.GLOBAL and Config.GLOBAL.lang) or {}
    TriggerEvent('chat:addSuggestion', '/me', (Config.ME and Config.ME.suggestion) or lang.suggestionMe or 'Perform a roleplay emote', {{ name = 'message', help = lang.suggestionHelpMe or 'Describe your action' }})
    TriggerEvent('chat:addSuggestion', '/do', (Config.DO and Config.DO.suggestion) or lang.suggestionDo or 'Describe the environment or state', {{ name = 'message', help = lang.suggestionHelpDo or 'Describe scene/state' }})
end)

RegisterNetEvent('actiontext:display')
AddEventHandler('actiontext:display', function(serverId, actionType, text)
    addText(serverId, actionType, text)
end)