-- загрузчик
-- инициализация между logic.lua и ui.lia
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
    local finalUrl = url .. "?t=" .. tostring(os.time()) -- обход кэша
    local success, content = pcall(function() return game:HttpGet(finalUrl) end)
    
    if success and content then
        if string.find(content, "404: Not Found") then
            warn("[XP Loader] Ошибка: Файл не найден на GitHub!")
            return
        end
        local func, err = loadstring(content)
        if func then task.spawn(func) else warn("[XP Loader] Ошибка: " .. tostring(err)) end
    else
        warn("[XP Loader] Ошибка загрузки: " .. url)
    end
end

-- ссылки
local URL_LOGIC = "https://raw.githubusercontent.com/pilgor1337goat432/dryftugytdutfyig/refs/heads/main/logic.lua"
local URL_UI = "https://raw.githubusercontent.com/pilgor1337goat432/dryftugytdutfyig/refs/heads/main/ui.lua"

loadScript(URL_LOGIC)
task.wait(0.5) -- безопасная пауза, чтобы логика успела прогрузиться
loadScript(URL_UI)
