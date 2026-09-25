local CONFIG = {
    HolderUrl = "https://raw.githubusercontent.com/D3f4ultscript/Cryptic-Scripts/refs/heads/main/Loader/LoadstringHolder-OneClick.lua"
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
