local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

-- Gelişmiş Sürükleme Fonksiyonu (Hata Giderilmiş)
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

-- Sadece Başlık İçin Rainbow
local function ApplyRainbow(label)
    RunService.RenderStepped:Connect(function()
        label.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 0.6, 1)
    end)
end

function Library.Window(title)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "YunusLo1545_V3"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- ANA PANEL
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 620, 0, 420) -- Biraz genişletildi (büyük yazılar için)
    MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(45, 45, 45)
    MakeDraggable(MainFrame)

    -- TOGGLE GUI BUTONU (Sürüklenebilir ve Büyük Yazılı)
    local OpenBtn = Instance.new("TextButton", ScreenGui)
    OpenBtn.Size = UDim2.new(0, 150, 0, 50)
    OpenBtn.Position = UDim2.new(0, 50, 0, 50)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    OpenBtn.Text = "Toggle GUI"
    OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 20 -- Büyütüldü
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 10)
    local BtnStroke = Instance.new("UIStroke", OpenBtn)
    BtnStroke.Color = Color3.fromRGB(70, 70, 70)
    MakeDraggable(OpenBtn) -- Sürükleme eklendi

    OpenBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- SOL PANEL
    local LeftPanel = Instance.new("Frame", MainFrame)
    LeftPanel.Size = UDim2.new(0, 180, 1, 0)
    LeftPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 12)

    local TitleLabel = Instance.new("TextLabel", LeftPanel)
    TitleLabel.Size = UDim2.new(1, 0, 0, 70)
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 26 -- Büyütüldü
    TitleLabel.BackgroundTransparency = 1
    ApplyRainbow(TitleLabel)

    local TabHolder = Instance.new("ScrollingFrame", LeftPanel)
    TabHolder.Size = UDim2.new(1, 0, 1, -80)
    TabHolder.Position = UDim2.new(0, 0, 0, 75)
    TabHolder.BackgroundTransparency = 1
    TabHolder.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabHolder).HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- İÇERİK ALANI
    local Container = Instance.new("Frame", MainFrame)
    Container.Size = UDim2.new(1, -200, 1, -20)
    Container.Position = UDim2.new(0, 190, 0, 10)
    Container.BackgroundTransparency = 1

    local TabLogic = {First = true}

    function TabLogic:CreateTab(tabName)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 15)

        local TBtn = Instance.new("TextButton", TabHolder)
        TBtn.Size = UDim2.new(0, 160, 0, 45)
        TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TBtn.Text = tabName
        TBtn.Font = Enum.Font.GothamMedium
        TBtn.TextSize = 18 -- Büyütüldü
        TBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 8)

        if TabLogic.First then
            Page.Visible = true
            TBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabLogic.First = false
        end

        TBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            for _, b in pairs(TabHolder:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end end
            Page.Visible = true
            TBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)

        local Elements = {}

        -- BÜYÜK BUTON
        function Elements:CreateButton(name, callback)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1, -10, 0, 55) -- Yükseklik arttı
            B.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            B.Text = name
            B.Font = Enum.Font.GothamBold
            B.TextSize = 22 -- Büyütüldü
            B.TextColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 10)
            B.MouseButton1Click:Connect(callback)
        end

        -- BÜYÜK TOGGLE
        function Elements:CreateToggle(name, callback)
            local state = false
            local T = Instance.new("TextButton", Page)
            T.Size = UDim2.new(1, -10, 0, 55)
            T.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            T.Text = "  " .. name
            T.Font = Enum.Font.GothamMedium
            T.TextSize = 21 -- Büyütüldü
            T.TextColor3 = Color3.fromRGB(230, 230, 230)
            T.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", T).CornerRadius = UDim.new(0, 10)

            local Ind = Instance.new("Frame", T)
            Ind.Size = UDim2.new(0, 28, 0, 28) -- Kutucuk büyüdü
            Ind.Position = UDim2.new(1, -45, 0.5, -14)
            Ind.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Instance.new("UICorner", Ind).CornerRadius = UDim.new(0, 8)

            T.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Ind, TweenInfo.new(0.3), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(60, 60, 60)}):Play()
                callback(state)
            end)
        end

        -- BÜYÜK SLIDER
        function Elements:CreateSlider(name, min, max, default, callback)
            local Sl = Instance.new("Frame", Page)
            Sl.Size = UDim2.new(1, -10, 0, 75) -- Yükseklik arttı
            Sl.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Instance.new("UICorner", Sl).CornerRadius = UDim.new(0, 10)

            local L = Instance.new("TextLabel", Sl)
            L.Size = UDim2.new(1, 0, 0, 35)
            L.Position = UDim2.new(0, 15, 0, 5)
            L.Text = name .. ": " .. default
            L.Font = Enum.Font.GothamMedium
            L.TextSize = 19 -- Büyütüldü
            L.TextColor3 = Color3.fromRGB(255, 255, 255)
            L.BackgroundTransparency = 1
            L.TextXAlignment = Enum.TextXAlignment.Left

            local B = Instance.new("TextButton", Sl)
            B.Size = UDim2.new(1, -40, 0, 10)
            B.Position = UDim2.new(0, 20, 0, 50)
            B.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            B.Text = ""
            Instance.new("UICorner", B)

            local F = Instance.new("Frame", B)
            F.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            F.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
            Instance.new("UICorner", F)

            B.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local move; move = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            local p = math.clamp((input.Position.X - B.AbsolutePosition.X) / B.AbsoluteSize.X, 0, 1)
                            local v = math.floor(min + (max - min) * p)
                            F.Size = UDim2.new(p, 0, 1, 0)
                            L.Text = name .. ": " .. v
                            callback(v)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end
                    end)
                end
            end)
        end

        return Elements
    end
    return TabLogic
end

return Library
