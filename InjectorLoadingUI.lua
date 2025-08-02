-- Roblox注入器加载UI
-- 兼容所有主流注入器 (Synapse X, KRNL, Fluxus, etc.)
-- 直接复制粘贴到注入器中执行

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- 检查是否已存在加载UI，如果存在则删除
if CoreGui:FindFirstChild("InjectorLoadingUI") then
    CoreGui:FindFirstChild("InjectorLoadingUI"):Destroy()
end

print("🚀 [INJECTOR] 启动加载UI...")

-- 创建注入器专用加载UI
local function createInjectorUI()
    -- 使用CoreGui确保UI不会被游戏重置
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InjectorLoadingUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- 全屏背景
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.Position = UDim2.new(0, 0, 0, 0)
    background.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    background.BackgroundTransparency = 0.1
    background.BorderSizePixel = 0
    background.Parent = screenGui
    
    -- 主容器
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(0, 450, 0, 320)
    mainContainer.Position = UDim2.new(0.5, -225, 0.5, -160)
    mainContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainContainer.BorderSizePixel = 0
    mainContainer.Parent = background
    
    -- 容器圆角
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 20)
    containerCorner.Parent = mainContainer
    
    -- 容器边框发光效果
    local borderGlow = Instance.new("UIStroke")
    borderGlow.Color = Color3.fromRGB(100, 150, 255)
    borderGlow.Thickness = 2
    borderGlow.Transparency = 0.3
    borderGlow.Parent = mainContainer
    
    -- 标题区域
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 80)
    titleFrame.Position = UDim2.new(0, 0, 0, 0)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = mainContainer
    
    -- 主标题
    local mainTitle = Instance.new("TextLabel")
    mainTitle.Size = UDim2.new(1, 0, 0, 40)
    mainTitle.Position = UDim2.new(0, 0, 0, 15)
    mainTitle.BackgroundTransparency = 1
    mainTitle.Text = "⚡ INJECTOR LOADING"
    mainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainTitle.TextSize = 24
    mainTitle.Font = Enum.Font.GothamBold
    mainTitle.TextStrokeTransparency = 0.5
    mainTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    mainTitle.Parent = titleFrame
    
    -- 副标题
    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.new(1, 0, 0, 25)
    subTitle.Position = UDim2.new(0, 0, 0, 50)
    subTitle.BackgroundTransparency = 1
    subTitle.Text = "Initializing exploit environment..."
    subTitle.TextColor3 = Color3.fromRGB(150, 200, 255)
    subTitle.TextSize = 14
    subTitle.Font = Enum.Font.Gotham
    subTitle.Parent = titleFrame
    
    -- 加载器容器
    local loaderContainer = Instance.new("Frame")
    loaderContainer.Size = UDim2.new(0, 100, 0, 100)
    loaderContainer.Position = UDim2.new(0.5, -50, 0.35, -50)
    loaderContainer.BackgroundTransparency = 1
    loaderContainer.Parent = mainContainer
    
    -- 创建六边形加载器
    local hexagons = {}
    for i = 1, 6 do
        local hex = Instance.new("Frame")
        hex.Size = UDim2.new(0, 12, 0, 12)
        hex.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        hex.BorderSizePixel = 0
        
        local hexCorner = Instance.new("UICorner")
        hexCorner.CornerRadius = UDim.new(0, 2)
        hexCorner.Parent = hex
        
        -- 计算六边形位置
        local angle = (i - 1) * 60
        local radian = math.rad(angle)
        local radius = 35
        local x = math.cos(radian) * radius
        local y = math.sin(radian) * radius
        
        hex.Position = UDim2.new(0.5, x - 6, 0.5, y - 6)
        hex.Parent = loaderContainer
        
        hexagons[i] = hex
    end
    
    -- 进度区域
    local progressFrame = Instance.new("Frame")
    progressFrame.Size = UDim2.new(0.9, 0, 0, 60)
    progressFrame.Position = UDim2.new(0.05, 0, 0.65, 0)
    progressFrame.BackgroundTransparency = 1
    progressFrame.Parent = mainContainer
    
    -- 进度条背景
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, 0, 0, 8)
    progressBg.Position = UDim2.new(0, 0, 0, 20)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = progressFrame
    
    local progressBgCorner = Instance.new("UICorner")
    progressBgCorner.CornerRadius = UDim.new(0, 4)
    progressBgCorner.Parent = progressBg
    
    -- 进度条
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg
    
    local progressBarCorner = Instance.new("UICorner")
    progressBarCorner.CornerRadius = UDim.new(0, 4)
    progressBarCorner.Parent = progressBar
    
    -- 进度条发光效果
    local progressGlow = Instance.new("UIStroke")
    progressGlow.Color = Color3.fromRGB(100, 150, 255)
    progressGlow.Thickness = 1
    progressGlow.Transparency = 0.5
    progressGlow.Parent = progressBar
    
    -- 进度文本
    local progressText = Instance.new("TextLabel")
    progressText.Size = UDim2.new(1, 0, 0, 20)
    progressText.Position = UDim2.new(0, 0, 0, 35)
    progressText.BackgroundTransparency = 1
    progressText.Text = "0%"
    progressText.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressText.TextSize = 16
    progressText.Font = Enum.Font.GothamBold
    progressText.Parent = progressFrame
    
    -- 状态文本
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, 0, 0, 20)
    statusText.Position = UDim2.new(0, 0, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Loading modules..."
    statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = progressFrame
    
    -- 底部信息
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, 0, 0, 40)
    infoFrame.Position = UDim2.new(0, 0, 0.85, 0)
    infoFrame.BackgroundTransparency = 1
    infoFrame.Parent = mainContainer
    
    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, 0, 1, 0)
    infoText.BackgroundTransparency = 1
    infoText.Text = "🔒 Secure injection • 🚀 High performance • ⚡ Fast execution"
    infoText.TextColor3 = Color3.fromRGB(120, 120, 120)
    infoText.TextSize = 12
    infoText.Font = Enum.Font.Gotham
    infoText.Parent = infoFrame
    
    screenGui.Parent = CoreGui
    
    return {
        gui = screenGui,
        hexagons = hexagons,
        progressBar = progressBar,
        progressText = progressText,
        statusText = statusText,
        subTitle = subTitle,
        mainTitle = mainTitle,
        borderGlow = borderGlow
    }
end

-- 启动加载UI
local ui = createInjectorUI()
local isRunning = true

print("✨ [INJECTOR] UI创建完成，开始动画...")

-- 六边形旋转动画
local hexAnimation = RunService.Heartbeat:Connect(function()
    if not isRunning then return end
    
    local time = tick()
    
    for i, hex in pairs(ui.hexagons) do
        -- 创建波浪效果
        local phase = (time * 4 + (i - 1) * 1) % (2 * math.pi)
        local scale = 0.7 + (math.sin(phase) + 1) * 0.3
        local transparency = (math.sin(phase * 1.5) + 1) * 0.3
        
        hex.Size = UDim2.new(0, 12 * scale, 0, 12 * scale)
        hex.BackgroundTransparency = transparency
        
        -- 颜色变化
        local colorPhase = (time + i * 0.5) % 3
        if colorPhase < 1 then
            hex.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        elseif colorPhase < 2 then
            hex.BackgroundColor3 = Color3.fromRGB(150, 100, 255)
        else
            hex.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
        end
    end
    
    -- 边框发光动画
    local glowPhase = time * 2
    local glowIntensity = (math.sin(glowPhase) + 1) * 0.3 + 0.2
    ui.borderGlow.Transparency = 1 - glowIntensity
end)

-- 标题脉冲动画
local titleAnimation = RunService.Heartbeat:Connect(function()
    if not isRunning then return end
    
    local time = tick()
    local pulse = (math.sin(time * 3) + 1) * 0.1
    ui.mainTitle.TextTransparency = pulse
end)

-- 模拟注入器加载过程
spawn(function()
    local loadingSteps = {
        {progress = 10, status = "Loading core modules...", subtitle = "Initializing exploit environment..."},
        {progress = 25, status = "Injecting DLL...", subtitle = "Bypassing anti-cheat systems..."},
        {progress = 40, status = "Hooking functions...", subtitle = "Establishing secure connection..."},
        {progress = 55, status = "Loading Lua environment...", subtitle = "Preparing script execution..."},
        {progress = 70, status = "Initializing UI...", subtitle = "Setting up user interface..."},
        {progress = 85, status = "Finalizing injection...", subtitle = "Completing security checks..."},
        {progress = 100, status = "Injection complete!", subtitle = "Ready for script execution! ⚡"}
    }
    
    print("📊 [INJECTOR] 开始模拟加载过程...")
    
    for _, step in ipairs(loadingSteps) do
        -- 更新进度条
        local progressTween = TweenService:Create(
            ui.progressBar,
            TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(step.progress / 100, 0, 1, 0)}
        )
        progressTween:Play()
        
        -- 更新文本
        ui.progressText.Text = step.progress .. "%"
        ui.statusText.Text = step.status
        ui.subTitle.Text = step.subtitle
        
        -- 在不同阶段改变颜色主题
        if step.progress < 30 then
            ui.progressBar.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        elseif step.progress < 60 then
            ui.progressBar.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        elseif step.progress < 90 then
            ui.progressBar.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        else
            ui.progressBar.BackgroundColor3 = Color3.fromRGB(100, 255, 200)
        end
        
        wait(math.random(1, 2)) -- 随机延迟使其更真实
    end
    
    print("✅ [INJECTOR] 加载完成！")
    
    -- 完成效果
    ui.mainTitle.Text = "🎉 INJECTION SUCCESSFUL"
    ui.mainTitle.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    -- 等待3秒后淡出
    wait(3)
    
    print("🧹 [INJECTOR] 清理UI...")
    isRunning = false
    
    -- 断开连接
    if hexAnimation then hexAnimation:Disconnect() end
    if titleAnimation then titleAnimation:Disconnect() end
    
    -- 淡出动画
    local fadeOut = TweenService:Create(
        ui.gui,
        TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Enabled = false}
    )
    fadeOut:Play()
    
    fadeOut.Completed:Connect(function()
        ui.gui:Destroy()
        print("🏁 [INJECTOR] UI已清理完成！")
    end)
end)

print("🎬 [INJECTOR] 加载UI已启动！享受你的注入体验！")
