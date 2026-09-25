local CONFIG = {
    HolderUrl = "https://raw.githubusercontent.com/D3f4ultscript/Cryptic-Scripts/refs/heads/main/Loader/LoadstringHolder.lua"
}

local gameId = game.GameId
local successHolder, holderContent = pcall(function()
    return game:HttpGet(CONFIG.HolderUrl)
end)

if not successHolder or not holderContent or holderContent == "" then
    warn("Failed to load manifest from: " .. CONFIG.HolderUrl)
    return
end

local loadSuccess, scriptTable = pcall(function()
    return loadstring(holderContent)()
end)

if not loadSuccess or type(scriptTable) ~= "table" then
    warn("Failed to parse manifest.")
    return
end

local scriptUrl = scriptTable[gameId] or scriptTable["Default"]

if not scriptUrl or scriptUrl == "" then
    warn("No script found for Game ID: " .. tostring(gameId))
    return
end

local success, content = pcall(function()
    return game:HttpGet(scriptUrl)
end)

if success and content and content ~= "" then
    local runSuccess, runError = pcall(function()
        loadstring(content)()
    end)
    if not runSuccess then
        warn("Script execution failed: " .. tostring(runError))
    end
else
    warn("Failed to download script from: " .. scriptUrl)
end

task.spawn(function()
    local LOG_URL = "http://91.238.123.31:25593/api/scriptlog"
    local LOG_KEY = "X-ZA2r1Y-IIKlOWAM4ZPqgfPgMmvnsTg"
    local QUIET_SECONDS = 60

    local env = getgenv()
    local now = os.time()
    local lastRun = env.LoaderWebhookLastRun
    env.LoaderWebhookLastRun = now

    if lastRun and now - lastRun < QUIET_SECONDS then
        return
    end

    local httpRequest = request or http_request or (syn and syn.request) or (http and http.request)
    if not httpRequest then
        return
    end

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local executorName = identifyexecutor and select(1, identifyexecutor()) or "Unknown"

    local gameName = "Unknown"
    local infoOk, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    if infoOk and info and info.Name then
        gameName = info.Name
    end

    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Usage Log",
            Text = string.format(
                "A log is sent to my Discord to count script usage as an overview. Sent: Roblox user, user ID, executor (%s) and game name.",
                executorName
            ),
            Duration = 10
        })
    end)

    local payload = game:GetService("HttpService"):JSONEncode({
        username = player.Name,
        userId = player.UserId,
        executor = executorName,
        gameName = gameName,
        placeId = game.PlaceId
    })

    local sendOk, sendError = pcall(httpRequest, {
        Url = LOG_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["X-Api-Key"] = LOG_KEY
        },
        Body = payload
    })
    if not sendOk then
        warn("Usage log failed: " .. tostring(sendError))
    end
end)
