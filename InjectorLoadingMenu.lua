-- 简洁注入器加载UI
-- 复制粘贴到注入器中直接使用

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- 清理已存在的UI
pcall(function()
    if CoreGui:FindFirstChild("InjectorUI") then
        CoreGui:FindFirstChild("InjectorUI"):Destroy()
    end
end)

-- 创建UI
local gui = Instance.new("ScreenGui")
gui.Name = "InjectorUI"
gui.ResetOnSpawn = false

-- 背景
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.new(0, 0, 0)
bg.BackgroundTransparency = 0.4
bg.BorderSizePixel = 0
bg.Parent = gui

-- 主容器
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 180)
main.Position = UDim2.new(0.5, -150, 0.5, -90)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
main.BorderSizePixel = 0
main.Parent = bg

-- 圆角
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

-- 边框
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 150, 255)
stroke.Thickness = 1
stroke.Parent = main

-- 标题
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "⚡ INJECTING"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = main

-- 加载器
local loader = Instance.new("Frame")
loader.Size = UDim2.new(0, 40, 0, 40)
loader.Position = UDim2.new(0.5, -20, 0.4, -20)
loader.BackgroundTransparency = 1
loader.Parent = main

-- 创建旋转点
local dots = {}
for i = 1, 8 do
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 4, 0, 4)
    dot.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    dot.BorderSizePixel = 0
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0.5, 0)
    dotCorner.Parent = dot
    
    local angle = (i - 1) * 45
    local rad = math.rad(angle)
    local x = math.cos(rad) * 15
    local y = math.sin(rad) * 15
    
    dot.Position = UDim2.new(0.5, x - 2, 0.5, y - 2)
    dot.Parent = loader
    dots[i] = dot
end

-- 进度条背景
local progBg = Instance.new("Frame")
progBg.Size = UDim2.new(0.8, 0, 0, 6)
progBg.Position = UDim2.new(0.1, 0, 0.7, 0)
progBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
progBg.BorderSizePixel = 0
progBg.Parent = main

local progBgCorner = Instance.new("UICorner")
progBgCorner.CornerRadius = UDim.new(0, 3)
progBgCorner.Parent = progBg

-- 进度条
local progBar = Instance.new("Frame")
progBar.Size = UDim2.new(0, 0, 1, 0)
progBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
progBar.BorderSizePixel = 0
progBar.Parent = progBg

local progBarCorner = Instance.new("UICorner")
progBarCorner.CornerRadius = UDim.new(0, 3)
progBarCorner.Parent = progBar

-- 进度文本
local progText = Instance.new("TextLabel")
progText.Size = UDim2.new(1, 0, 0, 20)
progText.Position = UDim2.new(0, 0, 0.8, 0)
progText.BackgroundTransparency = 1
progText.Text = "0%"
progText.TextColor3 = Color3.fromRGB(200, 200, 200)
progText.TextSize = 14
progText.Font = Enum.Font.Gotham
progText.Parent = main

-- 状态文本
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0.9, 0)
status.BackgroundTransparency = 1
status.Text = "Initializing..."
status.TextColor3 = Color3.fromRGB(150, 150, 150)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.Parent = main

gui.Parent = CoreGui

-- 动画
local running = true
local animConn = RunService.Heartbeat:Connect(function()
    if not running then return end
    
    local t = tick()
    for i, dot in pairs(dots) do
        local phase = (t * 6 + i * 0.8) % (2 * math.pi)
        local alpha = (math.sin(phase) + 1) / 2
        dot.BackgroundTransparency = 1 - alpha
    end
    
    -- 标题闪烁
    local titlePhase = t * 2
    title.TextTransparency = (math.sin(titlePhase) + 1) * 0.1
end)

-- 加载过程
spawn(function()
    local steps = {
        {20, "Loading modules..."},
        {40, "Injecting DLL..."},
        {60, "Hooking functions..."},
        {80, "Loading Lua..."},
        {100, "Complete!"}
    }
    
    for _, step in pairs(steps) do
        local prog, text = step[1], step[2]
        
        -- 更新进度条
        TweenService:Create(progBar, TweenInfo.new(0.5), {
            Size = UDim2.new(prog / 100, 0, 1, 0)
        }):Play()
        
        progText.Text = prog .. "%"
        status.Text = text
        
        -- 颜色变化
        if prog < 50 then
            progBar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        elseif prog < 80 then
            progBar.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        else
            progBar.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        end
        
        wait(math.random(1, 2))
    end
    
    -- 完成
    title.Text = "✅ INJECTED!"
    title.TextColor3 = Color3.fromRGB(100, 255, 100)
    wait(2)
    
    -- 清理
    running = false
    if animConn then animConn:Disconnect() end
    
    TweenService:Create(gui, TweenInfo.new(1), {Enabled = false}):Play()
    wait(1)
    gui:Destroy()
end)

print("🚀 Injector UI loaded!")
