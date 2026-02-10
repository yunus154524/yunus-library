local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

-- Sürükleme Fonksiyonu
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Bildirim Sistemi
function Library:Notify(title, text, duration)
    local NotifyGui = Instance.new("ScreenGui", CoreGui)
    local NotifyFrame = Instance.new("Frame", NotifyGui)
    NotifyFrame.Size = UDim2.new(0, 260, 0, 85)
    NotifyFrame.Position = UDim2.new(1, -270, 1, 100)
    NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", NotifyFrame)
    s.Color = Color3.fromRGB(0, 255, 150)

    local Tl = Instance.new("TextLabel", NotifyFrame)
    Tl.Text = title
    Tl.Size = UDim2.new(1, -20, 0, 30)
    Tl.Position = UDim2.new(0, 10, 0, 5)
    Tl.TextColor3 = Color3.fromRGB(0, 255, 150)
    Tl.Font = Enum.Font.GothamBold
    Tl.TextSize = 18 -- Küçültüldü
    Tl.BackgroundTransparency = 1
    Tl.TextXAlignment = Enum.TextXAlignment.Left

    local Tx = Instance.new("TextLabel", NotifyFrame)
    Tx.Text = text
    Tx.Size = UDim2.new(1, -20, 0, 40)
    Tx.Position = UDim2.new(0, 10, 0, 35)
    Tx.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tx.Font = Enum.Font.Gotham
    Tx.TextSize = 14 -- Küçültüldü
    Tx.BackgroundTransparency = 1
    Tx.TextXAlignment = Enum.TextXAlignment.Left
    Tx.TextWrapped = true

    NotifyFrame:TweenPosition(UDim2.new(1, -270, 1, -95), "Out", "Quart", 0.5, true)
    task.delay(duration or 3, function()
        NotifyFrame:TweenPosition(UDim2.new(1, -270, 1, 100), "In", "Quart", 0.5, true)
        task.wait(0.5)
        NotifyGui:Destroy()
    end)
end

function Library.Window(title)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "YunusLoLib"
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 580, 0, 380) -- Panel boyutu normale çekildi
    Main.Position = UDim2.new(0.5, -290, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(45, 45, 45); Stroke.Thickness = 2
    MakeDraggable(Main)

    local LeftPanel = Instance.new("Frame", Main)
    LeftPanel.Size = UDim2.new(0, 160, 1, 0)
    LeftPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", LeftPanel)
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.Text = title
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 24 -- Başlık küçültüldü
    Title.BackgroundTransparency = 1
    RunService.RenderStepped:Connect(function() 
        Title.TextColor3 = Color3.fromHSV(tick()%5/5, 0.6, 1) 
    end)

    local Tog = Instance.new("TextButton", ScreenGui)
    Tog.Size = UDim2.new(0, 130, 0, 45) -- Açma butonu dengelendi
    Tog.Position = UDim2.new(0, 50, 0, 50)
    Tog.Text = "Toggle GUI"
    Tog.Font = Enum.Font.GothamBold
    Tog.TextSize = 18 -- Yazı küçültüldü
    Tog.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Tog.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Tog).CornerRadius = UDim.new(0, 8)
    MakeDraggable(Tog) 

    Tog.MouseButton1Click:Connect(function() 
        Main.Visible = not Main.Visible 
    end)

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -180, 1, -20)
    Container.Position = UDim2.new(0, 170, 0, 10)
    Container.BackgroundTransparency = 1

    local TabHolder = Instance.new("ScrollingFrame", LeftPanel)
    TabHolder.Size = UDim2.new(1, 0, 1, -70)
    TabHolder.Position = UDim2.new(0, 0, 0, 65)
    TabHolder.BackgroundTransparency = 1
    TabHolder.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabHolder).HorizontalAlignment = Enum.HorizontalAlignment.Center

    local TabLogic = {First = true}

    function TabLogic:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 10)

        local TBtn = Instance.new("TextButton", TabHolder)
        TBtn.Size = UDim2.new(0, 140, 0, 38)
        TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TBtn.Text = name
        TBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TBtn.Font = Enum.Font.GothamBold
        TBtn.TextSize = 16 -- Sekme yazısı küçültüldü
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)

        if TabLogic.First then 
            Page.Visible = true
            TBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TabLogic.First = false 
        end

        TBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do 
                if v:IsA("ScrollingFrame") then v.Visible = false end 
            end
            Page.Visible = true
        end)

        local Elements = {}

        function Elements:CreateButton(txt, cb)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1, -10, 0, 42) -- Buton boyutu dengelendi
            B.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            B.Text = txt
            B.TextColor3 = Color3.fromRGB(255,255,255)
            B.Font = Enum.Font.GothamBold
            B.TextSize = 18 -- Buton yazısı küçültüldü
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
            B.MouseButton1Click:Connect(cb)
        end

        function Elements:CreateToggle(txt, cb)
            local s = false
            local T = Instance.new("TextButton", Page)
            T.Size = UDim2.new(1, -10, 0, 42)
            T.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            T.Text = "  "..txt
            T.TextColor3 = Color3.fromRGB(200,200,200)
            T.TextXAlignment = Enum.TextXAlignment.Left
            T.Font = Enum.Font.GothamBold
            T.TextSize = 17 -- Toggle yazısı küçültüldü
            Instance.new("UICorner", T).CornerRadius = UDim.new(0, 6)
            
            local Box = Instance.new("Frame", T)
            Box.Size = UDim2.new(0, 22, 0, 22)
            Box.Position = UDim2.new(1, -32, 0.5, -11)
            Box.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
            
            T.MouseButton1Click:Connect(function()
                s = not s
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 50)}):Play()
                cb(s)
            end)
        end

        function Elements:CreateSlider(txt, min, max, def, cb)
            local S = Instance.new("Frame", Page)
            S.Size = UDim2.new(1, -10, 0, 55)
            S.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", S).CornerRadius = UDim.new(0, 6)
            
            local L = Instance.new("TextLabel", S)
            L.Text = txt..": "..def
            L.Size = UDim2.new(1, -20, 0, 25)
            L.Position = UDim2.new(0, 10, 0, 5)
            L.TextColor3 = Color3.fromRGB(255,255,255)
            L.BackgroundTransparency = 1
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.Font = Enum.Font.GothamBold
            L.TextSize = 16 -- Slider yazısı küçültüldü
            
            local Bar = Instance.new("TextButton", S)
            Bar.Size = UDim2.new(1, -20, 0, 8)
            Bar.Position = UDim2.new(0, 10, 0, 35)
            Bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Bar.Text = ""
            Instance.new("UICorner", Bar)
            
            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
            Instance.new("UICorner", Fill)
            
            Bar.MouseButton1Down:Connect(function()
                local conn
                conn = RunService.RenderStepped:Connect(function()
                    local p = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local v = math.floor(min + (max - min) * p)
                    Fill.Size = UDim2.new(p, 0, 1, 0)
                    L.Text = txt..": "..v
                    cb(v)
                end)
                UserInputService.InputEnded:Connect(function(i) 
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
                        conn:Disconnect() 
                    end 
                end)
            end)
        end

        return Elements
    end
    return TabLogic
end

return Library
