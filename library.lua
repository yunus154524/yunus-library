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

function Library.Window(title)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "YunusLoLib"
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 580, 0, 380)
    Main.Position = UDim2.new(0.5, -290, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(45, 45, 45); Stroke.Thickness = 2
    MakeDraggable(Main)

    local LeftPanel = Instance.new("Frame", Main)
    LeftPanel.Size = UDim2.new(0, 160, 1, 0); LeftPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", LeftPanel)
    Title.Size = UDim2.new(1, 0, 0, 60); Title.Text = title; Title.Font = Enum.Font.GothamBold; Title.TextSize = 21; Title.BackgroundTransparency = 1
    RunService.RenderStepped:Connect(function() Title.TextColor3 = Color3.fromHSV(tick()%5/5, 0.6, 1) end)

    local Tog = Instance.new("TextButton", ScreenGui)
    Tog.Size = UDim2.new(0, 130, 0, 45); Tog.Position = UDim2.new(0, 50, 0, 50); Tog.Text = "Toggle GUI"; Tog.Font = Enum.Font.GothamBold; Tog.TextSize = 18; Tog.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Tog.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Tog).CornerRadius = UDim.new(0, 8); MakeDraggable(Tog)
    Tog.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -180, 1, -20); Container.Position = UDim2.new(0, 170, 0, 10); Container.BackgroundTransparency = 1

    local TabHolder = Instance.new("ScrollingFrame", LeftPanel)
    TabHolder.Size = UDim2.new(1, 0, 1, -70); TabHolder.Position = UDim2.new(0, 0, 0, 65); TabHolder.BackgroundTransparency = 1; TabHolder.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabHolder).HorizontalAlignment = Enum.HorizontalAlignment.Center

    local TabLogic = {First = true}

    function TabLogic:CreateTab(name)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150); Page.CanvasSize = UDim2.new(0, 0, 0, 0); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local Layout = Instance.new("UIListLayout", Page); Layout.Padding = UDim.new(0, 10); Layout.SortOrder = Enum.SortOrder.LayoutOrder

        local TBtn = Instance.new("TextButton", TabHolder)
        TBtn.Size = UDim2.new(0, 140, 0, 38); TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); TBtn.Text = name; TBtn.TextColor3 = Color3.fromRGB(200, 200, 200); TBtn.Font = Enum.Font.GothamBold; TBtn.TextSize = 16
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)

        if TabLogic.First then Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); TabLogic.First = false end

        TBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Page.Visible = true
        end)

        local Elements = {}

        -- [YENİ] Section Oluşturma
        function Elements:CreateSection(txt)
            local SFrame = Instance.new("Frame", Page)
            SFrame.Size = UDim2.new(1, -10, 0, 30); SFrame.BackgroundTransparency = 1
            local SLbl = Instance.new("TextLabel", SFrame)
            SLbl.Text = txt; SLbl.Size = UDim2.new(1, 0, 1, 0); SLbl.TextColor3 = Color3.fromRGB(0, 255, 150); SLbl.Font = "GothamBold"; SLbl.TextSize = 15; SLbl.BackgroundTransparency = 1; SLbl.TextXAlignment = "Left"
            local Line = Instance.new("Frame", SFrame); Line.Size = UDim2.new(1, 0, 0, 1); Line.Position = UDim2.new(0, 0, 1, 0); Line.BackgroundColor3 = Color3.fromRGB(45, 45, 45); Line.BorderSizePixel = 0
        end

        -- [YENİ] Label Oluşturma
        function Elements:CreateLabel(txt)
            local L = Instance.new("TextLabel", Page)
            L.Size = UDim2.new(1, -10, 0, 25); L.Text = txt; L.TextColor3 = Color3.fromRGB(200, 200, 200); L.Font = "GothamMedium"; L.TextSize = 14; L.BackgroundTransparency = 1; L.TextXAlignment = "Left"
        end

        function Elements:CreateButton(txt, cb)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1, -10, 0, 42); B.BackgroundColor3 = Color3.fromRGB(35, 35, 35); B.Text = txt; B.TextColor3 = Color3.fromRGB(255,255,255); B.Font = "GothamBold"; B.TextSize = 18
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6); B.MouseButton1Click:Connect(cb)
        end

        function Elements:CreateToggle(txt, cb)
            local s = false
            local T = Instance.new("TextButton", Page)
            T.Size = UDim2.new(1, -10, 0, 42); T.BackgroundColor3 = Color3.fromRGB(30, 30, 30); T.Text = "  "..txt; T.TextColor3 = Color3.fromRGB(200,200,200); T.TextXAlignment = "Left"; T.Font = "GothamBold"; T.TextSize = 17
            Instance.new("UICorner", T).CornerRadius = UDim.new(0, 6)
            local Box = Instance.new("Frame", T); Box.Size = UDim2.new(0, 22, 0, 22); Box.Position = UDim2.new(1, -32, 0.5, -11); Box.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
            T.MouseButton1Click:Connect(function()
                s = not s
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 50)}):Play()
                cb(s)
            end)
        end

        function Elements:CreateSlider(txt, min, max, def, cb)
            local S = Instance.new("Frame", Page)
            S.Size = UDim2.new(1, -10, 0, 55); S.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", S).CornerRadius = UDim.new(0, 6)
            local L = Instance.new("TextLabel", S); L.Text = txt..": "..def; L.Size = UDim2.new(1, -20, 0, 25); L.Position = UDim2.new(0, 10, 0, 5); L.TextColor3 = Color3.fromRGB(255,255,255); L.BackgroundTransparency = 1; L.TextXAlignment = "Left"; L.Font = "GothamBold"; L.TextSize = 16
            local Bar = Instance.new("TextButton", S); Bar.Size = UDim2.new(1, -20, 0, 8); Bar.Position = UDim2.new(0, 10, 0, 35); Bar.BackgroundColor3 = Color3.fromRGB(50,50,50); Bar.Text = ""; Instance.new("UICorner", Bar)
            local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150); Instance.new("UICorner", Fill)
            Bar.MouseButton1Down:Connect(function()
                local conn; conn = RunService.RenderStepped:Connect(function()
                    local p = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local v = math.floor(min + (max - min) * p); Fill.Size = UDim2.new(p, 0, 1, 0); L.Text = txt..": "..v; cb(v)
                end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() end end)
            end)
        end

        return Elements
    end
    return TabLogic
end

return Library
