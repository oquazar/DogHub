local success, redzlib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/main/V5/Source.lua"))()
end)
if not success or not redzlib then
    warn("❌ Falha ao carregar a biblioteca redzlib!")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Dog Hub - Erro",
        Text = "Falha ao carregar a biblioteca!",
        Duration = 5
    })
    return
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local activeLoops = {}
local espSettings = { players=false, tracers=false, boxes=false }
local highlights, tracers, boxes, nameTags = {}, {}, {}, {}

local function Notify(title, message, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title, Text = message, Duration = duration or 5
    })
end

if shared.connectCharacter then shared.connectCharacter:Disconnect() end
shared.connectCharacter = LocalPlayer.CharacterAdded:Connect(function(c) Character = c end)

local Window = redzlib:MakeWindow({Title="🐶 Dog Hub | BrookHaven", SubTitle="✨ Best mobile experience", SaveFolder="DogHub"})
Window:AddMinimizeButton({
    Button={ Image=redzlib:GetIcon("rbxassetid://78494550405765"), Size=UDim2.fromOffset(60,60), BackgroundTransparency=0 },
    Corner={ CornerRadius=UDim.new(0,6) }
})

local TabPlayer = Window:MakeTab({"🚶 Player", "rbxassetid://4483362458"})
TabPlayer:AddSection({"🕹️ Movement"})
TabPlayer:AddToggle({Name="💨 Super Speed", Flag="SuperSpeed", Callback=function(v)
    if activeLoops.speed then activeLoops.speed:Disconnect() end
    if v then
        activeLoops.speed = RunService.Heartbeat:Connect(function()
            if Character and Character:FindFirstChild("Humanoid") then
                Character.Humanoid.WalkSpeed = getgenv().valueSpeed or 16
            end
        end)
    else
        if Character and Character:FindFirstChild("Humanoid") then Character.Humanoid.WalkSpeed = 16 end
    end
end})
TabPlayer:AddSlider({Name="⚡ Set Speed", Min=16, Max=100, Default=16, Callback=function(val) getgenv().valueSpeed = val end})

TabPlayer:AddSection({"🦘 Jump"})
TabPlayer:AddToggle({Name="🚀 Super Jump", Flag="SuperJump", Callback=function(v)
    if activeLoops.jump then activeLoops.jump:Disconnect() end
    if v then
        activeLoops.jump = RunService.Heartbeat:Connect(function()
            if Character and Character:FindFirstChild("Humanoid") then
                Character.Humanoid.JumpPower = getgenv().valueJumpPower or 50
            end
        end)
    else
        if Character and Character:FindFirstChild("Humanoid") then Character.Humanoid.JumpPower = 50 end
    end
end})
TabPlayer:AddSlider({Name="📏 Adjust Jump Height", Min=50, Max=250, Default=50, Callback=function(val) getgenv().valueJumpPower = val end})

TabPlayer:AddSection({"👻 Physics"})
local noclipConnection
TabPlayer:AddToggle({Name="🛸 Noclip (Ghost)", Callback=function(v)
    if noclipConnection then noclipConnection:Disconnect() end
    if v and Character then
        noclipConnection = RunService.Stepped:Connect(function()
            for _, part in ipairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    elseif Character then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end})

TabPlayer:AddSection({"🔧 Utilities"})
TabPlayer:AddButton({"🔄 Rejoin Server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end})

local TabAvatar = Window:MakeTab({"🎨 Avatar", "rbxassetid://4483362458"})
local selectedPlayer = ""
TabAvatar:AddSection({"👤 Copy Avatar"})
local playerDropdown = TabAvatar:AddDropdown({Name="👤 Select Player", Options={}, Callback=function(n) selectedPlayer = n end})
TabAvatar:AddButton({"🔄 Update List", function()
    local t = {} for _, p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then table.insert(t,p.Name) end end
    playerDropdown:Set(t)
end})
TabAvatar:AddButton({Name="📋 Copy Avatar", Callback=function()
    if selectedPlayer == "" then return Notify("❌ Error","Select a player first!") end
    local tp = Players:FindFirstChild(selectedPlayer)
    if not tp or not tp.Character then return Notify("❌ Error","Player not found!") end
    local h = tp.Character:FindFirstChildOfClass("Humanoid")
    if not h then return Notify("❌ Error","Humanoid not found!") end
    local desc = h:GetAppliedDescription()
    local function applyItems(items)
        for _, item in ipairs(items) do
            if tonumber(item) then
                Remotes.Wear:InvokeServer(tonumber(item))
                task.wait(0.2)
            end
        end
    end
    local curr = Character:FindFirstChildOfClass("Humanoid"):GetAppliedDescription()
    applyItems({curr.Shirt, curr.Pants, curr.Face})
    if Remotes:FindFirstChild("ChangeCharacterBody") then
        Remotes.ChangeCharacterBody:InvokeServer{desc.Torso,desc.RightArm,desc.LeftArm,desc.RightLeg,desc.LeftLeg,desc.Head}
        task.wait(0.5)
    end
    applyItems({desc.Shirt,desc.Pants,desc.Face})
    for _, acc in ipairs(desc:GetAccessories(true)) do
        if acc.AssetId and tonumber(acc.AssetId) then
            Remotes.Wear:InvokeServer(tonumber(acc.AssetId)); task.wait(0.2)
        end
    end
    local skinColor = tp.Character:FindFirstChild("Body Colors")
    if skinColor and Remotes:FindFirstChild("ChangeBodyColor") then
        Remotes.ChangeBodyColor:FireServer(tostring(skinColor.HeadColor)); task.wait(0.2)
    end
    if tonumber(desc.IdleAnimation) and Remotes:FindFirstChild("Wear") then
        Remotes.Wear:InvokeServer(tonumber(desc.IdleAnimation))
    end
    Notify("✅ Success", "Copied avatar from "..selectedPlayer)
end})

local TabTroll = Window:MakeTab({"🃏 Troll","rbxassetid://4483362458"}); local selectedTarget="", viewConnection
TabTroll:AddSection({"🎯 Target Selection"})
TabTroll:AddDropdown({Name="🎯 Choose Target Player", Options={}, Callback=function(n) selectedTarget=n end})
TabTroll:AddButton({"🔃 Update Player List", function()
    local t={} for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then table.insert(t,p.Name) end end
    TabTroll:GetDropdown("🎯 Choose Target Player"):Set(t)
end})
TabTroll:AddSection({"😈 Troll Actions"})
TabTroll:AddButton({"📌 Teleport to Target", function()
    local tp = Players:FindFirstChild(selectedTarget)
    if tp and tp.Character and tp.Character:FindFirstChild("HumanoidRootPart") then
        Character:FindFirstChild("HumanoidRootPart").CFrame = tp.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
        Notify("✅ Teleported","You went to "..selectedTarget)
    end
end})
TabTroll:AddToggle({Name="👁️ Spectate Player", Callback=function(v)
    if viewConnection then viewConnection:Disconnect() end
    if v then
        viewConnection = RunService.Heartbeat:Connect(function()
            local tp=Players:FindFirstChild(selectedTarget)
            if tp and tp.Character and tp.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = tp.Character.Humanoid
            end
        end)
    else
        Camera.CameraSubject = Character:FindFirstChild("Humanoid")
    end
end})

local TabCasas = Window:MakeTab({"🏠 Houses","rbxassetid://4483362458"})
TabCasas:AddSection({"🛡️ Utilities"})
TabCasas:AddToggle({Name="🚫 Auto AntiBan (BannedBlock)", Callback=function(v)
    if antiBanConnection then antiBanConnection:Disconnect() end
    if v then
        antiBanConnection = RunService.Heartbeat:Connect(function()
            for _, p in ipairs(workspace:GetDescendants()) do
                if p:IsA("BasePart") and p.Name=="BannedBlock" then
                    p:Destroy()
                end
            end
        end)
    end
end})

local TabChams = Window:MakeTab({"👓 ESP","rbxassetid://4483362458"})
local function clearESP()
    for _,hl in pairs(highlights) do hl:Destroy() end
    for _,ln in pairs(tracers) do ln:Remove() end
    for _,bx in pairs(boxes) do bx:Remove() end
    for _,tag in pairs(nameTags) do if tag then tag:Destroy() end end
    highlights, tracers, boxes, nameTags = {}, {}, {}, {}
end
local function createBox() return Drawing.new("Square") end
local function createTracer() return Drawing.new("Line") end
local function createNameTag(player)
    local head = player.Character and player.Character:FindFirstChild("Head")
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not head and not root then return end
    local bg = Instance.new("BillboardGui")
    bg.Name="DogHubNameESP"; bg.Adornee=head or root
    bg.Size=UDim2.new(0,100,0,30); bg.StudsOffset=Vector3.new(0,2.5,0); bg.AlwaysOnTop=true
    bg.Parent=player.Character
    local lbl=Instance.new("TextLabel",bg)
    lbl.BackgroundTransparency=1; lbl.Size=UDim2.new(1,0,1,0)
    lbl.Text=player.Name; lbl.TextColor3=Color3.fromRGB(0,162,255)
    lbl.TextStrokeTransparency=0; lbl.TextScaled=true; lbl.Font=Enum.Font.SourceSansBold
    return bg
end

local espConnection; espConnection=RunService.RenderStepped:Connect(function()
    clearESP()
    for _,player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local c = player.Character; local humanoid = c and c:FindFirstChildOfClass("Humanoid")
            local rootPart = c and c:FindFirstChild("HumanoidRootPart")
            if humanoid and humanoid.Health>0 and rootPart then
                local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if espSettings.players then
                    local hl = highlights[player] or Instance.new("Highlight",workspace)
                    hl.Adornee = player.Character; hl.FillColor = Color3.fromRGB(0,162,255)
                    hl.OutlineColor = Color3.fromRGB(0,162,255)
                    highlights[player]=hl
                    if not nameTags[player] then nameTags[player]=createNameTag(player) end
                end
                if espSettings.tracers and onScreen then
                    local tr = tracers[player] or createTracer()
                    local sz = Camera.ViewportSize
                    tr.From=Vector2.new(sz.X/2,sz.Y); tr.To=Vector2.new(pos.X,pos.Y); tr.Visible=true
                    tracers[player]=tr
                end
                if espSettings.boxes and onScreen then
                    local bx = boxes[player] or createBox()
                    local size=Vector3.new(2,5,1)
                    local corners={
                        rootPart.Position+Vector3.new(-size.X/2,size.Y/2,-size.Z/2),
                        rootPart.Position+Vector3.new(size.X/2,size.Y/2,-size.Z/2),
                        rootPart.Position+Vector3.new(size.X/2,-size.Y/2,-size.Z/2),
                        rootPart.Position+Vector3.new(-size.X/2,-size.Y/2,-size.Z/2)
                    }
                    local tl = Camera:WorldToViewportPoint(corners[1])
                    local br = Camera:WorldToViewportPoint(corners[3])
                    if tl and br then
                        bx.Position=Vector2.new(tl.X,tl.Y)
                        bx.Size = Vector2.new(br.X-tl.X, br.Y-tl.Y)
                        bx.Visible=true
                        boxes[player]=bx
                    end
                end
            end
        end
    end
end)

TabChams:AddSection({"🟢 ESP Types"})
TabChams:AddToggle({Name="🟢 Player ESP", Callback=function(v) espSettings.players=v end})
TabChams:AddToggle({Name="📏 Tracers", Callback=function(v) espSettings.tracers=v end})
TabChams:AddToggle({Name="🟦 Box ESP", Callback=function(v) espSettings.boxes=v end})

print("✅ Dog Hub: Script carregado com sucesso!")
