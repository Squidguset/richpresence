local lovely_path = false -- This line is patched, don't edit it


local discordRPC = require("discordrpc")


local appId = require("applicationId")

function discordRPC.ready(userId, username, discriminator, avatar)
    print(string.format("Discord: ready (%s, %s, %s, %s)", userId, username, discriminator, avatar))
end

function discordRPC.disconnected(errorCode, message)
    print(string.format("Discord: disconnected (%d: %s)", errorCode, message))
end

function discordRPC.errored(errorCode, message)
    print(string.format("Discord: error (%d: %s)", errorCode, message))
end

function discordRPC.joinGame(joinSecret)
    print(string.format("Discord: join (%s)", joinSecret))
end

function discordRPC.spectateGame(spectateSecret)
    print(string.format("Discord: spectate (%s)", spectateSecret))
end

function discordRPC.joinRequest(userId, username, discriminator, avatar)
    print(string.format("Discord: join request (%s, %s, %s, %s)", userId, username, discriminator, avatar))
    discordRPC.respond(userId, "yes")
end


local pl = love.load

function love.load()
    local r = pl()

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

    return r
end

local pu = love.update

function love.update()
    local r = pu()
    if nextPresenceUpdate < love.timer.getTime() then
        discordRPC.updatePresence(presence)
        nextPresenceUpdate = love.timer.getTime() + 2.0
    end
    discordRPC.runCallbacks()

    return r
end

local pq = love.quit

function love.quit()
    local r = pq()
    discordRPC.shutdown()
    return r
end
