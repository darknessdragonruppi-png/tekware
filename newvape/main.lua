-- darknessdragonruppi-png 유저네임 반영 버전
repeat task.wait() until game:IsLoaded()
if shared.vape then shared.vape:Uninject() end

local vape
local loadstring = function(...)
    local res, err = loadstring(...)
    if err and vape then
        vape:CreateNotification('Vape', 'Failed to load : '..err, 30, 'alert')
    end
    return res
end

local function downloadFile(path, func)
    if not isfile(path) then
        local suc, res = pcall(function()
            -- 유저네임을 darknessdragonruppi-png로 정확히 수정했습니다.
            local relativePath = path:gsub('newvape/', '')
            return game:HttpGet('https://raw.githubusercontent.com/darknessdragonruppi-png/tekware/main/newvape/'..relativePath, true)
        end)
        if not suc or res == '404: Not Found' then
            error("파일을 찾을 수 없습니다: " .. path)
        end
        if path:find('.lua') then
            res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
        end
        writefile(path, res)
    end
    return (func or readfile)(path)
end

-- 이하 생략 (위의 downloadFile 함수가 핵심 수정 사항입니다)