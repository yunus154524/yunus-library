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

-- Rainbow Efekt (Sadece Başlık)
local function ApplyRainbow(label)
    RunService.RenderStepped:Connect(function()
        local hue = tick() % 5 / 5
        label.TextColor3 = Color3.fromHSV(hue, 0.6, 1)
    end)
end

function Library.Window(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "YunusLo1545_Lib"
    ScreenGui.Parent = CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 580, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(45, 45, 45)
    MakeDraggable(MainFrame)

    -- SADE TOGGLE BUTONU (Rainbowsız, Beyaz Yazı)
    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Size = UDim2.new(0, 130, 0, 45)
    OpenBtn.Position = UDim2.new(0, 50, 0, 50)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    OpenBtn.Text = "Toggle GUI"
    OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 17
    OpenBtn.Parent = ScreenGui
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 10)
    local BtnStroke = Instance.new("UIStroke", OpenBtn)
    BtnStroke.Color = Color3.fromRGB(60, 60, 60)
    MakeDraggable(OpenBtn)

    OpenBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    local LeftPanel = Instance.new("Frame")
    LeftPanel.Size = UDim2.new(0, 165, 1, 0)
    LeftPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    LeftPanel.Parent = MainFrame
    Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 12)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 60)
    TitleLabel.Text = title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 22
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = LeftPanel
    ApplyRainbow(TitleLabel)

    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Size = UDim2.new(1, 0, 1, -70)
    TabHolder.Position = UDim2.new(0, 0, 0, 65)
    TabHolder.BackgroundTransparency = 1
    TabHolder.ScrollBarThickness = 0
    TabHolder.Parent = LeftPanel
    Instance.new("UIListLayout", TabHolder).HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -185, 1, -20)
    Container.Position = UDim2.new(0, 175, 0, 10)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    local TabLogic = {First = true}

    function TabLogic:CreateTab(tabName)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Page.Parent = Container
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 12)

        local TBtn = Instance.new("TextButton")
        TBtn.Size = UDim2.new(0, 145, 0, 40)
        TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TBtn.Text = tabName
        TBtn.Font = Enum.Font.GothamMedium
        TBtn.TextSize = 16
        TBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TBtn.Parent = TabHolder
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 8)

        if TabLogic.First then
            Page.Visible = true
            TBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TabLogic.First = false
        end

        TBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            Page.Visible = true
        end)

        local Elements = {}

        -- BUTTON
        function Elements:CreateButton(name, callback)
            local B = Instance.new("TextButton")
            B.Size = UDim2.new(1, -10, 0, 45)
            B.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            B.Text = name
            B.Font = Enum.Font.GothamBold
            B.TextSize = 18
            B.TextColor3 = Color3.fromRGB(255, 255, 255)
            B.Parent = Page
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)
            B.MouseButton1Click:Connect(callback)
        end

        -- TOGGLE (AÇMA/KAPAMA)
        function Elements:CreateToggle(name, callback)
            local state = false
            local T = Instance.new("TextButton")
            T.Size = UDim2.new(1, -10, 0, 45)
            T.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            T.Text = "  " .. name
            T.Font = Enum.Font.GothamMedium
            T.TextSize = 18
            T.TextColor3 = Color3.fromRGB(230, 230, 230)
            T.TextXAlignment = Enum.TextXAlignment.Left
            T.Parent = Page
            Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)

            local Ind = Instance.new("Frame")
            Ind.Size = UDim2.new(0, 22, 0, 22)
            Ind.Position = UDim2.new(1, -35, 0.5, -11)
            Ind.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Ind.Parent = T
            Instance.new("UICorner", Ind).CornerRadius = UDim.new(0, 6)

            T.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Ind, TweenInfo.new(0.3), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(60, 60, 60)}):Play()
                callback(state)
            end)
        end

        -- SLIDER (ARTTIRMA/KISMA)
        function Elements:CreateSlider(name, min, max, default, callback)
            local Sl = Instance.new("Frame")
            Sl.Size = UDim2.new(1, -10, 0, 65)
            Sl.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Sl.Parent = Page
            Instance.new("UICorner", Sl).CornerRadius = UDim.new(0, 8)

            local L = Instance.new("TextLabel")
            L.Size = UDim2.new(1, 0, 0, 30)
            L.Position = UDim2.new(0, 15, 0, 5)
            L.Text = name .. ": " .. default
            L.Font = Enum.Font.GothamMedium
            L.TextSize = 16
            L.TextColor3 = Color3.fromRGB(255, 255, 255)
            L.BackgroundTransparency = 1
            L.TextXAlignment = Enum.TextXAlignment.Left
            L.Parent = Sl

            local B = Instance.new("TextButton")
            B.Size = UDim2.new(1, -30, 0, 8)
            B.Position = UDim2.new(0, 15, 0, 45)
            B.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            B.Text = ""
            B.Parent = Sl
            Instance.new("UICorner", B)

            local F = Instance.new("Frame")
            F.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            F.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
            F.Parent = B
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
