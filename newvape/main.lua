-- [초정밀 수정본] 모든 경로를 darknessdragonruppi-png 전용으로 고정
repeat task.wait() until game:IsLoaded()
if shared.vape then shared.vape:Uninject() end

-- 기존에 저장된 캐시(오류 파일)를 무시하고 새로 받기 위해 폴더를 체크합니다.
local function downloadFile(path)
    -- 님의 깃허브 Raw 경로
    local baseUrl = "https://raw.githubusercontent.com/darknessdragonruppi-png/tekware/main/newvape/"
    local relativePath = path:gsub('newvape/', '')
    
    local success, content = pcall(function() 
        return game:HttpGet(baseUrl .. relativePath, true) 
    end)
    
    if success and content ~= "404: Not Found" then
        -- 파일을 새로 씁니다 (기존 파일 덮어쓰기)
        writefile(path, content)
        return content
    else
        warn("파일을 가져오지 못함: " .. relativePath)
        return nil
    end
end

-- 1. 메인 GUI 로드
local guiContent = downloadFile("newvape/guis/new.lua") -- 보통 v4나 new 사용
if guiContent then
    local vape = loadstring(guiContent, "gui")()
    shared.vape = vape
    
    -- 2. 공용 스크립트 로드
    local uniContent = downloadFile("newvape/games/universal.lua")
    if uniContent then loadstring(uniContent, "universal")() end
    
    -- 3. 배드워즈(6872274481) 로드 - 님이 고친 그 파일!
    local gameFile = "newvape/games/"..game.PlaceId..".lua"
    local gameContent = downloadFile(gameFile)
    if gameContent then
        loadstring(gameContent, tostring(game.PlaceId))()
    end
    
    vape:Load()
    vape:CreateNotification('TekWare', '성공적으로 실행되었습니다!', 5)
else
    print("GUI 로딩 실패 - 경로를 다시 확인하세요.")
end
