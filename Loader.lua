-- ВСТАВЛЯТЬ
_G.WindowsXP_Share = {
    CurrentSpeed = 16,
    CurrentJump = 50,
    FlyEnabled = false,
    InfJumpEnabled = false,
    RagdollEnabled = false,
    PhantomActive = false,
    TriggerStatsUpdate = false
}

local function loadScript(url)
    local success, content = pcall(function() return game:HttpGet(url) end)
    if success and content then
        local func, err = loadstring(content)
        if func then task.spawn(func) else warn("Ошибка Lua: " .. tostring(err)) end
    else
        warn("Ошибка скачивания: " .. url)
    end
end

-- КАЛтент админки
local URL_LOGIC = "https://github.com/pilgor1337goat432/dryftugytdutfyig/commit/2e370069b62075e21328e60e1f5720375d6713a2"
local URL_UI = "https://githubusercontent.com"

loadScript(URL_LOGIC)
task.wait(0.1) -- безопастный интервал
loadScript(URL_UI)
