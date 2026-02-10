local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

-- Bildirim Sistemi (Ekstra Özellik)
function Library:Notify(title, text, duration)
    local NotifyGui = Instance.new("ScreenGui", CoreGui)
    local NotifyFrame = Instance.new("Frame", NotifyGui)
    NotifyFrame.Size = UDim2.new(0, 250, 0, 80)
    NotifyFrame.Position = UDim2.new(1, -260, 1, 100) -- Başlangıçta ekran dışında
    NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", NotifyFrame).Color = Color3.fromRGB(0, 255, 150)

    local Tl = Instance.new("TextLabel", NotifyFrame)
    Tl.Text = title; Tl.Size = UDim2.new(1, -20, 0, 30); Tl.Position = UDim2.new(0, 10, 0, 5)
    Tl.TextColor3 = Color3.fromRGB(0, 255, 150); Tl.Font = "GothamBold"; Tl.TextSize = 16; Tl.BackgroundTransparency = 1; Tl.TextXAlignment = "Left"

    local Tx = Instance.new("TextLabel", NotifyFrame)
    Tx.Text = text; Tx.Size = UDim2.new(1, -20, 0, 40); Tx.Position = UDim2.new(0, 10, 0, 30)
    Tx.TextColor3 = Color3.fromRGB(255, 255, 255); Tx.Font = "Gotham"; Tx.TextSize = 14; Tx.BackgroundTransparency = 1; Tx.TextXAlignment = "Left"; Tx.TextWrapped = true

    NotifyFrame:TweenPosition(UDim2.new(1, -260, 1, -90), "Out", "Quart", 0.5, true)
    task.wait(duration or 3)
    NotifyFrame:TweenPosition(UDim2.new(1, -260, 1, 100), "In", "Quart", 0.5, true)
    task.delay(0.5, function() NotifyGui:Destroy() end)
end

function Library.Window(title)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    
    -- Ana Panel
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 580, 0, 380)
    Main.Position = UDim2.new(0.5, -290, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(45, 45, 45); Stroke.Thickness = 2

    -- Rainbow Başlık Sistemi
    local LeftPanel = Instance.new("Frame", Main)
    LeftPanel.Size = UDim2.new(0, 165, 1, 0); LeftPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", LeftPanel)
    Title.Size = UDim2.new(1, 0, 0, 60); Title.Text = title; Title.Font = "GothamBold"; Title.TextSize = 20; Title.BackgroundTransparency = 1
    RunService.RenderStepped:Connect(function() 
        Title.TextColor3 = Color3.fromHSV(tick()%5/5, 0.6, 1) 
    end)

    -- Toggle Button (Sade)
    local Tog = Instance.new("TextButton", ScreenGui)
    Tog.Size = UDim2.new(0, 120, 0, 40); Tog.Position = UDim2.new(0, 50, 0, 50); Tog.Text = "Toggle GUI"; Tog.Font = "GothamBold"
    Tog.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Tog.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Tog).CornerRadius = UDim.new(0, 8)
    Tog.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -185, 1, -20); Container.Position = UDim2.new(0, 175, 0, 10); Container.BackgroundTransparency = 1

    local TabHolder = Instance.new("ScrollingFrame", LeftPanel)
    TabHolder.Size = UDim2.new(1, 0, 1, -70); TabHolder.Position = UDim2.new(0, 0, 0, 65); TabHolder.BackgroundTransparency = 1; TabHolder.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabHolder).HorizontalAlignment = "Center"

    local TabLogic = {First = true}

    function TabLogic:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        local Layout = Instance.new("UIListLayout", Page); Layout.Padding = UDim.new(0, 10)

        local TBtn = Instance.new("TextButton", TabHolder)
        TBtn.Size = UDim2.new(0, 145, 0, 38); TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); TBtn.Text = name; TBtn.TextColor3 = Color3.fromRGB(200, 200, 200); TBtn.Font = "GothamMedium"
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)

        if TabLogic.First then Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); TabLogic.First = false end

        TBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Page.Visible = true
        end)

        local Elements = {}

        function Elements:CreateButton(txt, cb)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1, -10, 0, 40); B.BackgroundColor3 = Color3.fromRGB(30, 30, 30); B.Text = txt; B.TextColor3 = Color3.fromRGB(255,255,255); B.Font = "GothamBold"
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
            B.MouseButton1Click:Connect(cb)
        end

        function Elements:CreateToggle(txt, cb)
            local s = false
            local T = Instance.new("TextButton", Page)
            T.Size = UDim2.new(1, -10, 0, 40); T.BackgroundColor3 = Color3.fromRGB(30, 30, 30); T.Text = "  "..txt; T.TextColor3 = Color3.fromRGB(200,200,200); T.TextXAlignment = "Left"; T.Font = "GothamMedium"
            Instance.new("UICorner", T).CornerRadius = UDim.new(0, 6)
            local Box = Instance.new("Frame", T); Box.Size = UDim2.new(0, 18, 0, 18); Box.Position = UDim2.new(1, -30, 0.5, -9); Box.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
            T.MouseButton1Click:Connect(function()
                s = not s
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 50)}):Play()
                cb(s)
            end)
        end

        function Elements:CreateSlider(txt, min, max, def, cb)
            local S = Instance.new("Frame", Page)
            S.Size = UDim2.new(1, -10, 0, 50); S.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", S).CornerRadius = UDim.new(0, 6)
            local L = Instance.new("TextLabel", S); L.Text = txt..": "..def; L.Size = UDim2.new(1, -20, 0, 20); L.Position = UDim2.new(0, 10, 0, 5); L.TextColor3 = Color3.fromRGB(255,255,255); L.BackgroundTransparency = 1; L.TextXAlignment = "Left"
            local Bar = Instance.new("TextButton", S); Bar.Size = UDim2.new(1, -20, 0, 6); Bar.Position = UDim2.new(0, 10, 0, 35); Bar.BackgroundColor3 = Color3.fromRGB(50,50,50); Bar.Text = ""
            local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
            Bar.MouseButton1Down:Connect(function()
                local conn; conn = RunService.RenderStepped:Connect(function()
                    local p = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local v = math.floor(min + (max - min) * p)
                    Fill.Size = UDim2.new(p, 0, 1, 0); L.Text = txt..": "..v; cb(v)
                end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() end end)
            end)
        end

        return Elements
    end
    return TabLogic
end

return Library
