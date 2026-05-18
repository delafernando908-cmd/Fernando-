local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- Variables Globales de Control compartidas
_G.SilentAimEnabled = false
_G.AutoShotEnabled = false 
_G.AutoFarmActivo = false 
_G.SpeedHackActivo = false 
_G.JumpHackActivo = false
_G.InfJumpEnabled = false

_G.WalkSpeedActual = 16 
_G.JumpPowerActual = 50
_G.FOV_Radius = 150 

_G.EspEnabled = false
_G.EspColor = Color3.fromRGB(255, 0, 0) 
_G.RainbowEnabled = true 
_G.MenuColor = Color3.fromRGB(0, 120, 255)

if CoreGui:FindFirstChild("DV_FERNANDO_HUB_FINAL") then CoreGui.DV_FERNANDO_HUB_FINAL:Destroy() end

local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "DV_FERNANDO_HUB_FINAL"
sg.ResetOnSpawn = false
_G.FernandoSG = sg

--- [ SISTEMA DE NOTIFICACIONES ] ---
local function Notify(text, state)
    local color = (state == true or state == "info") and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(255, 50, 50)
    local statusText = ""
    if state == true then statusText = ": ACTIVADO" elseif state == false then statusText = ": DESACTIVADO" end 
    
    local NotifFrame = Instance.new("Frame", sg)
    NotifFrame.Size = UDim2.new(0, 240, 0, 60); NotifFrame.Position = UDim2.new(1, 30, 1, -70); NotifFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 15); NotifFrame.BorderSizePixel = 0
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", NotifFrame); Stroke.Color = color; Stroke.Thickness = 1.5
    local TTitle = Instance.new("TextLabel", NotifFrame); TTitle.Size = UDim2.new(1, -20, 0, 25); TTitle.Position = UDim2.new(0, 10, 0, 5); TTitle.BackgroundTransparency = 1; TTitle.Text = "FERNANDO-HUB"; TTitle.TextColor3 = color; TTitle.Font = "GothamBold"; TTitle.TextSize = 12; TTitle.TextXAlignment = "Left"
    local TDesc = Instance.new("TextLabel", NotifFrame); TDesc.Size = UDim2.new(1, -20, 0, 20); TDesc.Position = UDim2.new(0, 10, 0, 25); TDesc.BackgroundTransparency = 1; TDesc.Text = text .. statusText; TDesc.TextColor3 = Color3.fromRGB(200, 200, 200); TDesc.Font = "Gotham"; TDesc.TextSize = 11; TDesc.TextXAlignment = "Left"
    local TimerBar = Instance.new("Frame", NotifFrame); TimerBar.Size = UDim2.new(1, 0, 0, 2); TimerBar.Position = UDim2.new(0, 0, 1, -2); TimerBar.BackgroundColor3 = color; TimerBar.BorderSizePixel = 0
    NotifFrame:TweenPosition(UDim2.new(1, -260, 1, -70), "Out", "Quart", 0.4, true)
    TweenService:Create(TimerBar, TweenInfo.new(3, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()
    task.delay(3, function() if NotifFrame then NotifFrame:TweenPosition(UDim2.new(1, 30, 1, -70), "In", "Quart", 0.4, true, function() NotifFrame:Destroy() end) end end)
end
_G.FernandoNotify = Notify

--- [ INTERFAZ GRÁFICA ] ---
local OpenBtn = Instance.new("TextButton", sg)
OpenBtn.Size = UDim2.new(0, 50, 0, 50); OpenBtn.Position = UDim2.new(0, 20, 0.5, -25); OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255); OpenBtn.Text = "FH"; OpenBtn.TextColor3 = Color3.new(1,1,1); OpenBtn.Font = "GothamBold"; OpenBtn.TextSize = 18; OpenBtn.Visible = false; OpenBtn.Draggable = true; Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 500, 0, 350); Main.Position = UDim2.new(0.5, -250, 0.5, -175); Main.BackgroundColor3 = Color3.fromRGB(5, 7, 10); Main.Active = true; Main.Draggable = true; Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local NeonStroke = Instance.new("UIStroke", Main); NeonStroke.Thickness = 2.5
task.spawn(function()
    local h = 0
    while task.wait() do 
        if _G.RainbowEnabled then h = h + (1/800); NeonStroke.Color = Color3.fromHSV(h % 1, 0.8, 1) 
        else NeonStroke.Color = _G.MenuColor end
    end
end)

local Header = Instance.new("Frame", Main); Header.Size = UDim2.new(1, 0, 0, 45); Header.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", Header); Title.Position = UDim2.new(0, 20, 0, 12); Title.Size = UDim2.new(0, 250, 0, 20); Title.BackgroundTransparency = 1; Title.Text = "<font color='rgb(0, 120, 255)'>FERNANDO-HUB</font>"; Title.RichText = true; Title.TextColor3 = Color3.new(1,1,1); Title.Font = "GothamBold"; Title.TextSize = 18; Title.TextXAlignment = "Left"

local CloseBtn = Instance.new("TextButton", Header); CloseBtn.Size = UDim2.new(0, 25, 0, 25); CloseBtn.Position = UDim2.new(1, -35, 0, 10); CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.Text = "×"; CloseBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

local MinimizeBtn = Instance.new("TextButton", Header); MinimizeBtn.Size = UDim2.new(0, 25, 0, 25); MinimizeBtn.Position = UDim2.new(1, -65, 0, 10); MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 55); MinimizeBtn.Text = "─"; MinimizeBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", MinimizeBtn)
MinimizeBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)

local Sidebar = Instance.new("Frame", Main); Sidebar.Size = UDim2.new(0, 130, 1, -70); Sidebar.Position = UDim2.new(0, 10, 0, 55); Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 8)

local Container = Instance.new("Frame", Main); Container.Size = UDim2.new(1, -160, 1, -70); Container.Position = UDim2.new(0, 150, 0, 55); Container.BackgroundTransparency = 1

local PerfFrame = Instance.new("Frame", Main); PerfFrame.Size = UDim2.new(0, 120, 0, 40); PerfFrame.Position = UDim2.new(0, 10, 1, -50); PerfFrame.BackgroundColor3 = Color3.fromRGB(12, 15, 20); Instance.new("UICorner", PerfFrame)
local PerfLabel = Instance.new("TextLabel", PerfFrame); PerfLabel.Size = UDim2.new(1, 0, 1, 0); PerfLabel.BackgroundTransparency = 1; PerfLabel.TextColor3 = Color3.fromRGB(150, 150, 150); PerfLabel.Font = "GothamBold"; PerfLabel.TextSize = 9; PerfLabel.Text = "FPS: 00 | PING: 00"
task.spawn(function()
    while task.wait(1) do
        if not sg or not sg.Parent then break end
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        PerfLabel.Text = "FPS: " .. fps .. " | PING: " .. ping .. "ms"
    end
end)

_G.Pages = {}
_G.CreatePage = function(name)
    local Page = Instance.new("Frame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1
    local Scroll = Instance.new("ScrollingFrame", Page); Scroll.Size = UDim2.new(1, 0, 1, 0); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 0
    local Layout = Instance.new("UIListLayout", Scroll); Layout.Padding = UDim.new(0, 10); Layout.SortOrder = Enum.SortOrder.LayoutOrder
    _G.Pages[name] = {Main = Page, List = Scroll}
    return _G.Pages[name]
end

_G.AddTab = function(name, pageName)
    local btn = Instance.new("TextButton", Sidebar); btn.Size = UDim2.new(1, 0, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(15, 18, 25); btn.Text = name:upper(); btn.TextColor3 = Color3.new(1,1,1); btn.Font = "GothamBold"; btn.TextSize = 10; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(_G.Pages) do p.Main.Visible = false end
        if _G.Pages[pageName] then _G.Pages[pageName].Main.Visible = true end
        for _, b in pairs(Sidebar:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(15, 18, 25) end end
        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end)
end

_G.AddToggle = function(page, text, callback, default, order)
    local Row = Instance.new("Frame", page.List); Row.Size = UDim2.new(1, -10, 0, 35); Row.BackgroundColor3 = Color3.fromRGB(12, 15, 20); Instance.new("UICorner", Row); Row.LayoutOrder = order or 0
    local Label = Instance.new("TextLabel", Row); Label.Position = UDim2.new(0, 10, 0.5, -7); Label.Size = UDim2.new(0, 150, 0, 14); Label.Text = text; Label.TextColor3 = Color3.new(1,1,1); Label.Font = "GothamBold"; Label.TextSize = 10; Label.TextXAlignment = "Left"; Label.BackgroundTransparency = 1
    local SwitchBg = Instance.new("TextButton", Row); SwitchBg.Size = UDim2.new(0, 30, 0, 15); SwitchBg.Position = UDim2.new(1, -40, 0.5, -7); SwitchBg.BackgroundColor3 = default and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 45, 55); SwitchBg.Text = ""; Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)
    local SliderBtn = Instance.new("Frame", SwitchBg); SliderBtn.Size = UDim2.new(0, 11, 0, 11); SliderBtn.Position = default and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5); SliderBtn.BackgroundColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", SliderBtn).CornerRadius = UDim.new(1, 0)
    local state = default or false
    SwitchBg.MouseButton1Click:Connect(function()
        state = not state; callback(state); Notify(text, state)
        TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(40, 45, 55)}):Play()
        TweenService:Create(SliderBtn, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
    end)
end

_G.AddCustomSelector = function(page, text, valRef, min, max, step, reqCheck, errorMsg, onValueChange, order)
    local Row = Instance.new("Frame", page.List); Row.Size = UDim2.new(1, -10, 0, 40); Row.BackgroundColor3 = Color3.fromRGB(12, 15, 20); Instance.new("UICorner", Row); Row.LayoutOrder = order or 0
    local Label = Instance.new("TextLabel", Row); Label.Position = UDim2.new(0, 10, 0.5, -7); Label.Size = UDim2.new(0, 120, 0, 14); Label.Text = text; Label.TextColor3 = Color3.new(1,1,1); Label.Font = "GothamBold"; Label.TextSize = 10; Label.TextXAlignment = "Left"; Label.BackgroundTransparency = 1
    local ValueBox = Instance.new("TextLabel", Row); ValueBox.Size = UDim2.new(0, 45, 0, 22); ValueBox.Position = UDim2.new(1, -100, 0.5, -11); ValueBox.BackgroundColor3 = Color3.fromRGB(20, 25, 35); ValueBox.Text = tostring(valRef); ValueBox.TextColor3 = Color3.fromRGB(0, 120, 255); ValueBox.Font = "GothamBold"; ValueBox.TextSize = 11; Instance.new("UICorner", ValueBox)
    local MinusBtn = Instance.new("TextButton", Row); MinusBtn.Size = UDim2.new(0, 22, 0, 22); MinusBtn.Position = UDim2.new(1, -130, 0.5, -11); MinusBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 45); MinusBtn.Text = "-"; MinusBtn.TextColor3 = Color3.new(1,1,1); MinusBtn.Font = "GothamBold"; MinusBtn.TextSize = 14; Instance.new("UICorner", MinusBtn)
    local PlusBtn = Instance.new("TextButton", Row); PlusBtn.Size = UDim2.new(0, 22, 0, 22); PlusBtn.Position = UDim2.new(1, -45, 0.5, -11); PlusBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 45); PlusBtn.Text = "+"; PlusBtn.TextColor3 = Color3.new(1,1,1); PlusBtn.Font = "GothamBold"; PlusBtn.TextSize = 14; Instance.new("UICorner", PlusBtn)
    
    local function checkRequirement()
        if reqCheck == "SpeedHackActivo" then return _G.SpeedHackActivo end
        if reqCheck == "JumpHackActivo" then return _G.JumpHackActivo end
        if reqCheck == "AutoShotEnabled" then return _G.AutoShotEnabled end
        if _G[reqCheck] ~= nil then return _G[reqCheck] end
        return true
    end

    MinusBtn.MouseButton1Click:Connect(function()
        if reqCheck and not checkRequirement() then Notify(errorMsg, false) return end
        if valRef > min then 
            valRef = math.max(min, valRef - step)
            ValueBox.Text = tostring(valRef)
            onValueChange(valRef)
            Notify(text .. " cambiado a: " .. tostring(valRef), "info")
        end
    end)
    PlusBtn.MouseButton1Click:Connect(function()
        if reqCheck and not checkRequirement() then Notify(errorMsg, false) return end
        if valRef < max then 
            valRef = math.min(max, valRef + step)
            ValueBox.Text = tostring(valRef)
            onValueChange(valRef)
            Notify(text .. " cambiado a: " .. tostring(valRef), "info")
        end
    end)
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local FarmConnection = nil 
local SpeedConnection = nil 
local JumpConnection = nil

local Networking = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Networking")
local CollectRemote = Networking:FindFirstChild("RE/Events/CollectEventSpawnable")

local Notify = _G.FernandoNotify

--- [ CÍRCULO FOV ] ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.Color = Color3.fromRGB(255, 255, 255); FOVCircle.Transparency = 0.6; FOVCircle.Filled = false; FOVCircle.Radius = _G.FOV_Radius; FOVCircle.Visible = false 

RunService.RenderStepped:Connect(function()
    if _G.AutoShotEnabled then 
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = _G.FOV_Radius
    end
end)

--- [ COMPROBACIÓN DE PAREDES ] ---
local function isEnemyVisible(targetPart)
    if not targetPart then return false end
    local origin = Camera.CFrame.Position
    local destination = targetPart.Position
    local direction = destination - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    if raycastResult then
        if raycastResult.Instance:IsDescendantOf(targetPart.Parent) then return true end
    end
    return false
end

--- [ DETECCIÓN DE OBJETIVOS ] ---
local function getBestTargetPlayer()
    if not _G.AutoShotEnabled then return nil end 
    local bestPlayer = nil
    local shortestDistance = _G.FOV_Radius
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local isEnemy = true
            if LocalPlayer.Team and v.Team then if LocalPlayer.Team == v.Team then isEnemy = false end
            elseif LocalPlayer.TeamColor == v.TeamColor and LocalPlayer.TeamColor ~= BrickColor.new("White") then isEnemy = false end
            if isEnemy then
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if onScreen and isEnemyVisible(v.Character.Head) then
                    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local distance = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if distance < shortestDistance then bestPlayer = v; shortestDistance = distance end
                end
            end
        end
    end
    return bestPlayer
end

local function getBestTarget()
    if not _G.SilentAimEnabled then return nil end
    local target = nil
    local shortestDistance = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local isEnemy = true
            if LocalPlayer.Team and v.Team then if LocalPlayer.Team == v.Team then isEnemy = false end
            elseif LocalPlayer.TeamColor == v.TeamColor and LocalPlayer.TeamColor ~= BrickColor.new("White") then isEnemy = false end
            if isEnemy then
                local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                if onScreen and isEnemyVisible(v.Character.Head) then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if distance < shortestDistance then target = v.Character.Head; shortestDistance = distance end
                end
            end
        end
    end
    return target
end

-- HOOK DEL METATABLE
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(self, index)
    if _G.AutoShotEnabled and self == Mouse and (index == "Hit" or index == "Target") then
        local targetPlayer = getBestTargetPlayer()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local char = LocalPlayer.Character
            if char then
                local armaEquipada = char:FindFirstChildOfClass("Tool")
                if armaEquipada and armaEquipada:FindFirstChild("kill") then
                    task.spawn(pcall, function()
                        local killArgs = {[1] = targetPlayer, [2] = (targetPlayer.Character.Head.Position - Camera.CFrame.Position).Unit}
                        armaEquipada.kill:FireServer(unpack(killArgs))
                    end)
                end
            end
            return (index == "Hit" and targetPlayer.Character.Head.CFrame or targetPlayer.Character.Head)
        end
    end
    if _G.SilentAimEnabled and self == Mouse and (index == "Hit" or index == "Target") then
        local target = getBestTarget()
        if target then return (index == "Hit" and target.CFrame or target) end
    end
    return oldIndex(self, index)
end)
setreadonly(mt, true)

-- SISTEMA INF JUMP
UserInputService.JumpRequest:Connect(function()
    if _G.InfJumpEnabled then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

--- [ SISTEMA ESP ] ---
local function ApplyAura(player)
    local function UpdateAura()
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local highlight = char:FindFirstChild("AuraESP")
                if _G.EspEnabled then
                    if not highlight then
                        highlight = Instance.new("Highlight"); highlight.Name = "AuraESP"; highlight.Parent = char; highlight.FillTransparency = 0.5; highlight.OutlineColor = Color3.fromRGB(255, 255, 255); highlight.OutlineTransparency = 0
                    end
                    highlight.FillColor = _G.EspColor 
                else if highlight then highlight:Destroy() end end
            else
                if char and char:FindFirstChild("AuraESP") then char.AuraESP:Destroy() end
            end
        end
    end
    player.CharacterAdded:Connect(function() task.wait(0.5); UpdateAura() end); RunService.RenderStepped:Connect(UpdateAura)
end
for _, p in pairs(Players:GetPlayers()) do ApplyAura(p) end
Players.PlayerAdded:Connect(ApplyAura)

--- [ ENLAZAR BOTONES CON INTERFAZ Y REGLAS ] ---
_G.AddTab("Aimbot", "AimTab")
_G.AddTab("Movilidad", "MoveTab")
_G.AddTab("Visuals", "VisTab")
_G.AddTab("Evento", "EventTab") 
_G.AddTab("Menu", "MenuTab")

local AimP = _G.Pages.AimTab
_G.AddToggle(AimP, "Silent Aim", function(v) _G.SilentAimEnabled = v end, false, 1)
_G.AddToggle(AimP, "Auto-Shot", function(v) _G.AutoShotEnabled = v; FOVCircle.Visible = v end, false, 2)
_G.AddCustomSelector(AimP, "Radio del FOV", _G.FOV_Radius, 50, 600, 25, "AutoShotEnabled", "¡Error! Activa el Auto-Shot primero", function(v) _G.FOV_Radius = v end, 3)

local MoveP = _G.Pages.MoveTab
_G.AddToggle(MoveP, "SpeedHack", function(state)
    _G.SpeedHackActivo = state
    if _G.SpeedHackActivo then
        SpeedConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = _G.WalkSpeedActual end
        end)
    else
        if SpeedConnection then SpeedConnection:Disconnect(); SpeedConnection = nil end
        local char = LocalPlayer.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end, false, 1)

_G.AddCustomSelector(MoveP, "Modificar Velocidad", _G.WalkSpeedActual, 16, 500, 10, "SpeedHackActivo", "¡Error! Primero activa el SpeedHack", function(newSpeed)
    _G.WalkSpeedActual = newSpeed
    if _G.SpeedHackActivo then local char = LocalPlayer.Character; local hum = char and char:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed = newSpeed end end
end, 2)

_G.AddToggle(MoveP, "Modificar Salto", function(state)
    _G.JumpHackActivo = state
    if _G.JumpHackActivo then
        JumpConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = _G.JumpPowerActual; hum.UseJumpPower = true end
        end)
    else
        if JumpConnection then JumpConnection:Disconnect(); JumpConnection = nil end
        local char = LocalPlayer.Character; local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = 50 end
    end
end, false, 3)

_G.AddCustomSelector(MoveP, "Fuerza de Salto", _G.JumpPowerActual, 50, 300, 10, "JumpHackActivo", "¡Error! Activa Modificar Salto", function(newJump)
    _G.JumpPowerActual = newJump
    if _G.JumpHackActivo then local char = LocalPlayer.Character; local hum = char and char:FindFirstChildOfClass("Humanoid") if hum then hum.JumpPower = newJump end end
end, 4)

_G.AddToggle(MoveP, "Saltos Infinitos", function(v) _G.InfJumpEnabled = v end, false, 5)

local VisP = _G.Pages.VisTab
_G.AddToggle(VisP, "Aura ESP", function(v) _G.EspEnabled = v end)
local EspColorTitle = Instance.new("TextLabel", VisP.List)
EspColorTitle.Size = UDim2.new(1, -10, 0, 20); EspColorTitle.BackgroundTransparency = 1; EspColorTitle.Text = "Color del ESP"; EspColorTitle.TextColor3 = Color3.new(1, 1, 1); EspColorTitle.Font = "GothamBold"; EspColorTitle.TextSize = 10; EspColorTitle.TextXAlignment = "Left"
local EspColorBox = Instance.new("Frame", VisP.List)
EspColorBox.Size = UDim2.new(1, -10, 0, 40); EspColorBox.BackgroundTransparency = 1
local EspColorList = Instance.new("UIListLayout", EspColorBox); EspColorList.FillDirection = "Horizontal"; EspColorList.Padding = UDim.new(0, 8)
local espColors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 0)}
for _, c in pairs(espColors) do
    local b = Instance.new("TextButton", EspColorBox); b.Size = UDim2.new(0, 25, 0, 25); b.BackgroundColor3 = c; b.Text = ""; Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function() if _G.EspEnabled then _G.EspColor = c; Notify("Color ESP aplicado", true) else Notify("¡Error! Primero activa el ESP", false) end end)
end

local EventP = _G.Pages.EventTab
if CollectRemote then
    _G.AddToggle(EventP, "Cinco de mayo festival", function(state) 
        _G.AutoFarmActivo = state
        if _G.AutoFarmActivo then FarmConnection = RunService.Heartbeat:Connect(function() CollectRemote:FireServer() end)
        else if FarmConnection then FarmConnection:Disconnect(); FarmConnection = nil end end
    end, false, 1)
else
    local ErrorLabel = Instance.new("TextLabel", EventP.List)
    ErrorLabel.Size = UDim2.new(1, -10, 0, 30); ErrorLabel.BackgroundTransparency = 1; ErrorLabel.Text = "¡Error! No se encontró el RemoteEvent."; ErrorLabel.TextColor3 = Color3.fromRGB(255, 50, 50); ErrorLabel.Font = "GothamBold"; ErrorLabel.TextSize = 10; ErrorLabel.TextXAlignment = "Left"
end

local MenuP = _G.Pages.MenuTab
_G.AddToggle(MenuP, "Sistema Arcoiris", function(v) _G.RainbowEnabled = v end, true, 1)
local CustomLabel = Instance.new("TextLabel", MenuP.List)
CustomLabel.Size = UDim2.new(1, -10, 0, 25); CustomLabel.BackgroundTransparency = 1; CustomLabel.Text = "personaliza a tu gusto"; CustomLabel.TextColor3 = Color3.new(1, 1, 1); CustomLabel.Font = "GothamBold"; CustomLabel.TextSize = 12; CustomLabel.TextXAlignment = "Left"; CustomLabel.LayoutOrder = 2
local ColorTitle = Instance.new("TextLabel", MenuP.List)
ColorTitle.Size = UDim2.new(1, -10, 0, 15); ColorTitle.BackgroundTransparency = 1; ColorTitle.Text = "colores del panel"; ColorTitle.TextColor3 = Color3.fromRGB(200, 200, 200); ColorTitle.Font = "Gotham"; ColorTitle.TextSize = 10; ColorTitle.TextXAlignment = "Left"; CustomLabel.LayoutOrder = 3
local ColorBox = Instance.new("Frame", MenuP.List)
ColorBox.Size = UDim2.new(1, -10, 0, 40); ColorBox.BackgroundTransparency = 1; ColorBox.LayoutOrder = 4
local ColorList = Instance.new("UIListLayout", ColorBox); ColorList.FillDirection = "Horizontal"; ColorList.Padding = UDim.new(0, 8)
local colors = {Color3.fromRGB(0, 120, 255), Color3.fromRGB(255, 50, 50), Color3.fromRGB(0, 255, 100), Color3.fromRGB(170, 0, 255), Color3.fromRGB(255, 200, 0)}
for _, c in pairs(colors) do
    local b = Instance.new("TextButton", ColorBox); b.Size = UDim2.new(0, 25, 0, 25); b.BackgroundColor3 = c; b.Text = ""; Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function() if not _G.RainbowEnabled then _G.MenuColor = c; Notify("Color aplicado", true) else Notify("Apaga el Arcoiris", false) end end)
end

_G.Pages.AimTab.Main.Visible = true

--- [ NOTIFICACIÓN AL CARGAR ] ---
Notify("Gracias por utilizar FERNANDO-HUB", "info")
