

function love.load()
    discordRPC.initialize(appId, true)
    local now = os.time(os.date("*t"))
    presence = {
        state = "Looking to Play",
        details = "1v1 (Ranked)",
        startTimestamp = now,
        endTimestamp = now + 60,
        partyId = "party id",
        partyMax = 2,
        matchSecret = "match secret",
        joinSecret = "join secret",
        spectateSecret = "spectate secret",
    }

    nextPresenceUpdate = 0
end

function love.update()
    if nextPresenceUpdate < love.timer.getTime() then
        discordRPC.updatePresence(presence)
        nextPresenceUpdate = love.timer.getTime() + 2.0
    end
    discordRPC.runCallbacks()
end

function love.quit()
    discordRPC.shutdown()
end
