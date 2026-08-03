-- GitHub Файл: Loader.lua
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
    -- Добавляем кэш-бастер (?t=time), чтобы GitHub отдавал обновленный код моментально
    local finalUrl = url .. "?t=" .. tostring(os.time())
    local success, content = pcall(function() return game:HttpGet(finalUrl) end)
    
    if success and content then
        if string.find(content, "404: Not Found") then
            warn("[XP Loader] Ошибка: Файл не найден на GitHub по адресу: " .. url)
            return
        end
        local func, err = loadstring(content)
        if func then 
            task.spawn(func) 
        else 
            warn("[XP Loader] Ошибка синтаксиса в файле: " .. tostring(err)) 
        end
    else
        warn("[XP Loader] Инжектор заблокировал загрузку: " .. url)
    end
end

-- Ваши точные ссылки на логику и интерфейс
local URL_LOGIC = "https://raw.githubusercontent.com/pilgor1337goat432/dryftugytdutfyig/refs/heads/main/logic.lua"
local URL_UI = "https://raw.githubusercontent.com/pilgor1337goat432/dryftugytdutfyig/refs/heads/main/ui.lua"

loadScript(URL_LOGIC)
task.wait(0.3)
loadScript(URL_UI)
