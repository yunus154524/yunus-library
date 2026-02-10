local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

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
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 580, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(45, 45, 45)
    MakeDraggable(MainFrame)

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
        
        -- Buraya Toggle ve Slider fonksiyonlarını da aynı mantıkla ekleyebilirsin.
        return Elements
    end
    return TabLogic
end

return Library
