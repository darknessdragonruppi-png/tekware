-- darknessdragonruppi-png 전용 최종 수정본
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
        local relativePath = path:gsub('newvape/', '')
        -- 님의 유저네임과 폴더 경로를 정확히 일치시켰습니다.
        local baseUrl = "https://raw.githubusercontent.com/darknessdragonruppi-png/tekware/main/newvape/"
        local success, content = pcall(function() 
            return game:HttpGet(baseUrl .. relativePath, true) 
        end)
        
        if success and content ~= "404: Not Found" then
            if path:find('.lua') then
                content = '--Watermark\n'..content
            end
            writefile(path, content)
        else
            -- 어디서 막혔는지 콘솔에 출력합니다.
            warn("다운로드 실패: " .. relativePath)
            error("404: Not Found")
        end
    end
    return (func or readfile)(path)
end

local function finishLoading()
    vape.Init = nil
    vape:Load()
    -- 로딩 완료 알림
    vape:CreateNotification('Vape', 'Successfully Loaded!', 5)
end

-- GUI 및 유니버설 파일 로드
if not isfile('newvape/profiles/gui.txt') then writefile('newvape/profiles/gui.txt', 'new') end
local gui = readfile('newvape/profiles/gui.txt')

if not isfolder('newvape/assets/'..gui) then makefolder('newvape/assets/'..gui) end

-- 메인 모듈 로드
vape = loadstring(downloadFile('newvape/guis/'..gui..'.lua'), 'gui')()
shared.vape = vape

-- 게임 전용 파일 로드 (6872274481.lua 등)
if not shared.VapeIndependent then
    loadstring(downloadFile('newvape/games/universal.lua'), 'universal')()
    -- 현재 접속한 게임의 ID에 맞는 파일을 님의 깃허브에서 가져옵니다.
    local gameFile = 'newvape/games/'..game.PlaceId..'.lua'
    local suc, res = pcall(function() return downloadFile(gameFile) end)
    if suc then
        loadstring(res, tostring(game.PlaceId))()
    end
    finishLoading()
end
