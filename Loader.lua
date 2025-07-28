-- Enhanced Dog Hub Loading Screen
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player and player:WaitForChild("PlayerGui")

local function CreateLoader()
    -- Create the interface
    local LoadScreen = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local ProgressBar = Instance.new("Frame")
    local ProgressFill = Instance.new("Frame")
    local StatusLabel = Instance.new("TextLabel")
    local Title = Instance.new("TextLabel")
    local DogIcon = Instance.new("ImageLabel")
    local CountdownLabel = Instance.new("TextLabel")
    
    -- Basic configuration
    LoadScreen.Name = "DogHubLoader"
    LoadScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LoadScreen.ResetOnSpawn = false

    -- Main frame (initially invisible and scaled down)
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = LoadScreen
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BackgroundTransparency = 1
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- Progress bar (background)
    ProgressBar.Name = "ProgressBar"
    ProgressBar.Parent = MainFrame
    ProgressBar.AnchorPoint = Vector2.new(0.5, 0)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Position = UDim2.new(0.5, 0, 0.7, 0)
    ProgressBar.Size = UDim2.new(0.8, 0, 0, 16)
    ProgressBar.Transparency = 1
    
    -- Progress bar (fill)
    ProgressFill.Name = "ProgressFill"
    ProgressFill.Parent = ProgressBar
    ProgressFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    ProgressFill.Transparency = 1
    
    -- Status text
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Parent = MainFrame
    StatusLabel.AnchorPoint = Vector2.new(0.5, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 22)
    StatusLabel.Font = Enum.Font.GothamMedium
    StatusLabel.Text = "Initializing..."
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.TextSize = 14
    StatusLabel.TextTransparency = 1
    StatusLabel.TextWrapped = true
    
    -- Title
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.AnchorPoint = Vector2.new(0.5, 0)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.5, 0, 0.2, 0)
    Title.Size = UDim2.new(0.9, 0, 0, 35)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🐶 Dog Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.TextTransparency = 1
    Title.TextWrapped = true
    
    -- Dog icon
    DogIcon.Name = "DogIcon"
    DogIcon.Parent = MainFrame
    DogIcon.AnchorPoint = Vector2.new(0.5, 0)
    DogIcon.BackgroundTransparency = 1
    DogIcon.Position = UDim2.new(0.5, 0, 0.35, 0)
    DogIcon.Size = UDim2.new(0, 50, 0, 50)
    -- Coloque o assetId do seu ícone aqui para aparecer:
    DogIcon.Image = "rbxassetid://1234567890"
    DogIcon.ImageColor3 = Color3.fromRGB(0, 162, 255)
    DogIcon.ImageTransparency = 1
    
    -- Countdown label (initially hidden)
    CountdownLabel.Name = "CountdownLabel"
    CountdownLabel.Parent = MainFrame
    CountdownLabel.AnchorPoint = Vector2.new(0.5, 0)
    CountdownLabel.BackgroundTransparency = 1
    CountdownLabel.Position = UDim2.new(0.5, 0, 0.8, 0)
    CountdownLabel.Size = UDim2.new(0.9, 0, 0, 20)
    CountdownLabel.Font = Enum.Font.GothamMedium
    CountdownLabel.Text = ""
    CountdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    CountdownLabel.TextSize = 12
    CountdownLabel.TextTransparency = 1
    CountdownLabel.TextWrapped = true
    
    -- Add to player interface
    LoadScreen.Parent = playerGui
    
    -- Entrance animation
    local entranceTween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(0, 320, 0, 180)
        }
    )
    
    local fadeInTween = TweenService:Create(
        ProgressBar,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.3),
        {Transparency = 0}
    )
    
    local fillFadeIn = TweenService:Create(
        ProgressFill,
        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.4),
        {Transparency = 0}
    )
    
    local textFadeIn = TweenService:Create(
        StatusLabel,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.5),
        {TextTransparency = 0}
    )
    
    local titleFadeIn = TweenService:Create(
        Title,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.2),
        {TextTransparency = 0}
    )
    
    local iconFadeIn = TweenService:Create(
        DogIcon,
        TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0.1),
        {ImageTransparency = 0}
    )
    
    -- Play entrance animations
    entranceTween:Play()
    fadeInTween:Play()
    fillFadeIn:Play()
    textFadeIn:Play()
    titleFadeIn:Play()
    iconFadeIn:Play()
    
    return {
        Screen = LoadScreen,
        Update = function(self, progress, text)
            -- Smooth progress update
            TweenService:Create(
                ProgressFill,
                TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(progress, 0, 1, 0)}
            ):Play()
            
            -- Text typing animation
            if text then
                StatusLabel.Text = ""
                task.spawn(function()
                    for i = 1, #text do
                        StatusLabel.Text = string.sub(text, 1, i)
                        task.wait(0.03)
                    end
                end)
            end
            
            -- Icon bounce animation
            TweenService:Create(
                DogIcon,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 55, 0, 55)}
            ):Play()
            task.delay(0.2, function()
                TweenService:Create(
                    DogIcon,
                    TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0, 50, 0, 50)}
                ):Play()
            end)
        end,
        ShowCountdown = function(self, seconds)
            -- Show countdown label
            TweenService:Create(
                CountdownLabel,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {TextTransparency = 0}
            ):Play()
            
            -- Update countdown text
            for i = seconds, 1, -1 do
                CountdownLabel.Text = string.format("Executing in %d seconds...", i)
                task.wait(1)
            end
        end,
        Destroy = function(self)
            -- Exit animations
            local exitTween = TweenService:Create(
                MainFrame,
                TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0)
                }
            )
            
            TweenService:Create(
                ProgressBar,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Transparency = 1}
            ):Play()
            
            TweenService:Create(
                ProgressFill,
                TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Transparency = 1}
            ):Play()
            
            TweenService:Create(
                StatusLabel,
                TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {TextTransparency = 1}
            ):Play()
            
            TweenService:Create(
                Title,
                TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {TextTransparency = 1}
            ):Play()
            
            TweenService:Create(
                DogIcon,
                TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {ImageTransparency = 1}
            ):Play()
            
            TweenService:Create(
                CountdownLabel,
                TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {TextTransparency = 1}
            ):Play()
            
            exitTween:Play()
            exitTween.Completed:Wait()
            LoadScreen:Destroy()
        end
    }
end

-- Create and show loading screen
local Loader = CreateLoader()

-- Simulate prolonged loading process with smooth transitions
local loadingStages = {
    {progress = 0.1, text = "Establishing connection...", duration = 1.2},
    {progress = 0.25, text = "Loading core modules...", duration = 1.5},
    {progress = 0.4, text = "Verifying dependencies...", duration = 1.8},
    {progress = 0.55, text = "Initializing components...", duration = 1.3},
    {progress = 0.7, text = "Preparing interface...", duration = 1.6},
    {progress = 0.85, text = "Finalizing setup...", duration = 1.4},
    {progress = 0.95, text = "Loading main script...", duration = 0.9}
}

-- Function to run all loading stages sequentially
local function RunLoadingStages()
    for _, stage in ipairs(loadingStages) do
        Loader:Update(stage.progress, stage.text)
        task.wait(stage.duration)
    end
    
    -- After all stages complete
    Loader:Update(1, "Loading complete!")
    task.wait(1.2)
    
    -- Show 10-second countdown
    Loader:ShowCountdown(10)
    
    -- Execute main script only after countdown is complete
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/oquazar/DHub/refs/heads/main/Script"))()
    end)
    
    if not success then
        Loader:Update(1, "Error: Failed to load script")
        warn("Script error: "..tostring(err))
        task.wait(2.5)
    end
    
    -- Destroy loader after everything is complete
    Loader:Destroy()
end

-- Start the loading process
RunLoadingStages()
