local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

-- Sürükleme Sistemi (Toggle Butonu İçin de Aktif)
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:Notify(title, text, duration)
    local NotifyGui = Instance.new("ScreenGui", CoreGui)
    local NotifyFrame = Instance.new("Frame", NotifyGui)
    NotifyFrame.Size = UDim2.new(0, 250, 0, 80)
    NotifyFrame.Position = UDim2.new(1, -260, 1, 100)
    NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", NotifyFrame)
    s.Color = Color3.fromRGB(0, 255, 150)

    local Tl = Instance.new("TextLabel", NotifyFrame)
    Tl.Text = title; Tl.Size = UDim2.new(1, -20, 0, 30); Tl.Position = UDim2.new(0, 10, 0, 5)
    Tl.TextColor3 = Color3.fromRGB(0, 255, 150); Tl.Font = Enum.Font.GothamBold; Tl.TextSize = 16; Tl.BackgroundTransparency = 1; Tl.TextXAlignment = Enum.TextXAlignment.Left

    local Tx = Instance.new("TextLabel", NotifyFrame)
    Tx.Text = text; Tx.Size = UDim2.new(1, -20, 0, 40); Tx.Position = UDim2.new(0, 10, 0, 30)
    Tx.TextColor3 = Color3.fromRGB(255, 255, 255); Tx.Font = Enum.Font.Gotham; Tx.TextSize = 14; Tx.BackgroundTransparency = 1; Tx.TextXAlignment = Enum.TextXAlignment.Left; Tx.TextWrapped = true

    NotifyFrame:TweenPosition(UDim2.new(1, -260, 1, -90), "Out", "Quart", 0.5, true)
    task.delay(duration or 3, function()
        NotifyFrame:TweenPosition(UDim2.new(1, -260, 1, 100), "In", "Quart", 0.5, true)
        task.wait(0.5)
        NotifyGui:Destroy()
    end)
end

function Library.Window(title)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 650, 0, 450) -- Panel büyütüldü
    Main.Position = UDim2.new(0.5, -325, 0.5, -225)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(50, 50, 50); Stroke.Thickness = 3
    MakeDraggable(Main)

    local LeftPanel = Instance.new("Frame", Main)
    LeftPanel.Size = UDim2.new(0, 200, 1, 0); LeftPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 15)

    local Title = Instance.new("TextLabel", LeftPanel)
    Title.Size = UDim2.new(1, 0, 0, 80); Title.Text = title; Title.Font = "GothamBold"; Title.TextSize = 30; Title.BackgroundTransparency = 1
    RunService.RenderStepped:Connect(function() 
        Title.TextColor3 = Color3.fromHSV(tick()%5/5, 0.6, 1) 
    end)

    local Tog = Instance.new("TextButton", ScreenGui)
    Tog.Size = UDim2.new(0, 180, 0, 60); Tog.Position = UDim2.new(0, 50, 0, 50)
    Tog.Text = "Toggle GUI"; Tog.Font = "GothamBold"; Tog.TextSize = 28 -- DEVASE BUTON YAZISI
    Tog.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Tog.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Tog).CornerRadius = UDim.new(0, 12)
    MakeDraggable(Tog)
    Tog.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -220, 1, -30); Container.Position = UDim2.new(0, 215, 0, 15); Container.BackgroundTransparency = 1

    local TabHolder = Instance.new("ScrollingFrame", LeftPanel)
    TabHolder.Size = UDim2.new(1, 0, 1, -90); TabHolder.Position = UDim2.new(0, 0, 0, 85); TabHolder.BackgroundTransparency = 1; TabHolder.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabHolder).HorizontalAlignment = "Center"

    local TabLogic = {First = true}

    function TabLogic:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        local Layout = Instance.new("UIListLayout", Page); Layout.Padding = UDim.new(0, 15)

        local TBtn = Instance.new("TextButton", TabHolder)
        TBtn.Size = UDim2.new(0, 170, 0, 50); TBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); TBtn.Text = name; TBtn.TextColor3 = Color3.fromRGB(200, 200, 200); TBtn.Font = "GothamBold"; TBtn.TextSize = 24
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 10)

        if TabLogic.First then Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); TabLogic.First = false end

        TBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Page.Visible = true
        end)

        local Elements = {}

        function Elements:CreateButton(txt, cb)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1, -15, 0, 65); B.BackgroundColor3 = Color3.fromRGB(35, 35, 35); B.Text = txt; B.TextColor3 = Color3.fromRGB(255,255,255); B.Font = "GothamBold"; B.TextSize = 26
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 10)
            B.MouseButton1Click:Connect(cb)
        end

        function Elements:CreateToggle(txt, cb)
            local s = false
            local T = Instance.new("TextButton", Page)
            T.Size = UDim2.new(1, -15, 0, 65); T.BackgroundColor3 = Color3.fromRGB(30, 30, 30); T.Text = "  "..txt; T.TextColor3 = Color3.fromRGB(230,230,230); T.TextXAlignment = "Left"; T.Font = "GothamBold"; T.TextSize = 26
            Instance.new("UICorner", T).CornerRadius = UDim.new(0, 10)
            local Box = Instance.new("Frame", T); Box.Size = UDim2.new(0, 30, 0, 30); Box.Position = UDim2.new(1, -45, 0.5, -15); Box.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
            T.MouseButton1Click:Connect(function()
                s = not s
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 50)}):Play()
                cb(s)
            end)
        end

        function Elements:CreateSlider(txt, min, max, def, cb)
            local S = Instance.new("Frame", Page)
            S.Size = UDim2.new(1, -15, 0, 80); S.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", S).CornerRadius = UDim.new(0, 10)
            local L = Instance.new("TextLabel", S); L.Text = txt..": "..def; L.Size = UDim2.new(1, -20, 0, 30); L.Position = UDim2.new(0, 15, 0, 8); L.TextColor3 = Color3.fromRGB(255,255,255); L.BackgroundTransparency = 1; L.TextXAlignment = "Left"; L.Font = "GothamBold"; L.TextSize = 22
            local Bar = Instance.new("TextButton", S); Bar.Size = UDim2.new(1, -30, 0, 10); Bar.Position = UDim2.new(0, 15, 0, 55); Bar.BackgroundColor3 = Color3.fromRGB(50,50,50); Bar.Text = ""
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
