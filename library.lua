local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

-- THEME
local Theme = {
    Background = Color3.fromRGB(20,22,28),
    Surface = Color3.fromRGB(28,31,38),
    Surface2 = Color3.fromRGB(34,37,45),
    Accent = Color3.fromRGB(88,101,242),
    Text = Color3.fromRGB(235,235,235),
    SubText = Color3.fromRGB(160,165,180),
    Stroke = Color3.fromRGB(45,48,58)
}

-- DRAG SYSTEM
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
            gui.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- NOTIFY
function Library:Notify(title, text, duration)
    local NotifyGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", NotifyGui)
    Frame.Size = UDim2.new(0, 300, 0, 90)
    Frame.Position = UDim2.new(1, -320, 1, 120)
    Frame.BackgroundColor3 = Theme.Surface
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", Frame)
    stroke.Color = Theme.Stroke

    local Tl = Instance.new("TextLabel", Frame)
    Tl.Text = title
    Tl.Font = Enum.Font.GothamBold
    Tl.TextSize = 16
    Tl.TextColor3 = Theme.Text
    Tl.BackgroundTransparency = 1
    Tl.Position = UDim2.new(0,15,0,10)
    Tl.Size = UDim2.new(1,-30,0,25)
    Tl.TextXAlignment = Left

    local Tx = Instance.new("TextLabel", Frame)
    Tx.Text = text
    Tx.Font = Enum.Font.Gotham
    Tx.TextSize = 13
    Tx.TextColor3 = Theme.SubText
    Tx.BackgroundTransparency = 1
    Tx.Position = UDim2.new(0,15,0,35)
    Tx.Size = UDim2.new(1,-30,0,40)
    Tx.TextWrapped = true
    Tx.TextXAlignment = Left

    Frame:TweenPosition(UDim2.new(1, -320, 1, -110),"Out","Quart",0.4,true)

    task.delay(duration or 3,function()
        Frame:TweenPosition(UDim2.new(1, -320, 1, 120),"In","Quart",0.4,true)
        task.wait(0.4)
        NotifyGui:Destroy()
    end)
end

-- WINDOW
function Library.Window(title)

    if CoreGui:FindFirstChild("YunusLoModern") then
        CoreGui.YunusLoModern:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "YunusLoModern"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 620, 0, 420)
    Main.Position = UDim2.new(0.5, -310, 0.5, -210)
    Main.BackgroundColor3 = Theme.Background
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)

    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Theme.Stroke
    Stroke.Thickness = 1

    MakeDraggable(Main)

    -- LEFT PANEL
    local Left = Instance.new("Frame", Main)
    Left.Size = UDim2.new(0, 170, 1, 0)
    Left.BackgroundColor3 = Theme.Surface
    Instance.new("UICorner", Left).CornerRadius = UDim.new(0, 16)

    local Title = Instance.new("TextLabel", Left)
    Title.Size = UDim2.new(1,0,0,60)
    Title.Text = title
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextColor3 = Theme.Text
    Title.BackgroundTransparency = 1

    local TabHolder = Instance.new("UIListLayout", Left)
    TabHolder.Padding = UDim.new(0,6)
    TabHolder.HorizontalAlignment = Center

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1,-190,1,-20)
    Container.Position = UDim2.new(0,180,0,10)
    Container.BackgroundTransparency = 1

    local Tabs = {First = true}

    function Tabs:CreateTab(name)

        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1,0,1,0)
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.ScrollBarThickness = 4
        Page.BackgroundTransparency = 1
        Page.Visible = false

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0,12)

        local Button = Instance.new("TextButton", Left)
        Button.Size = UDim2.new(0,150,0,40)
        Button.BackgroundColor3 = Theme.Surface
        Button.Text = name
        Button.TextColor3 = Theme.SubText
        Button.Font = Enum.Font.GothamSemibold
        Button.TextSize = 14
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0,10)

        local stroke = Instance.new("UIStroke", Button)
        stroke.Color = Theme.Stroke

        if Tabs.First then
            Tabs.First = false
            Page.Visible = true
            Button.BackgroundColor3 = Theme.Surface2
            Button.TextColor3 = Theme.Text
        end

        Button.MouseButton1Click:Connect(function()

            for _,v in pairs(Container:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end

            for _,v in pairs(Left:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundColor3 = Theme.Surface
                    v.TextColor3 = Theme.SubText
                end
            end

            Page.Visible = true
            Button.BackgroundColor3 = Theme.Surface2
            Button.TextColor3 = Theme.Text
        end)

        local Elements = {}

        function Elements:CreateButton(text, callback)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1,-10,0,48)
            B.BackgroundColor3 = Theme.Surface
            B.Text = text
            B.TextColor3 = Theme.Text
            B.Font = Enum.Font.GothamSemibold
            B.TextSize = 14
            Instance.new("UICorner", B).CornerRadius = UDim.new(0,10)

            local s = Instance.new("UIStroke", B)
            s.Color = Theme.Stroke

            B.MouseEnter:Connect(function()
                TweenService:Create(B,TweenInfo.new(0.15),{
                    BackgroundColor3 = Theme.Surface2
                }):Play()
            end)

            B.MouseLeave:Connect(function()
                TweenService:Create(B,TweenInfo.new(0.15),{
                    BackgroundColor3 = Theme.Surface
                }):Play()
            end)

            B.MouseButton1Click:Connect(callback)
        end

        function Elements:CreateToggle(text, callback)
            local state = false

            local Holder = Instance.new("Frame", Page)
            Holder.Size = UDim2.new(1,-10,0,50)
            Holder.BackgroundColor3 = Theme.Surface
            Instance.new("UICorner", Holder).CornerRadius = UDim.new(0,10)

            local s = Instance.new("UIStroke", Holder)
            s.Color = Theme.Stroke

            local Label = Instance.new("TextLabel", Holder)
            Label.Text = text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 14
            Label.TextColor3 = Theme.Text
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0,15,0,0)
            Label.Size = UDim2.new(0.7,0,1,0)
            Label.TextXAlignment = Left

            local Toggle = Instance.new("Frame", Holder)
            Toggle.Size = UDim2.new(0,44,0,22)
            Toggle.Position = UDim2.new(1,-60,0.5,-11)
            Toggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1,0)

            local Knob = Instance.new("Frame", Toggle)
            Knob.Size = UDim2.new(0,18,0,18)
            Knob.Position = UDim2.new(0,2,0.5,-9)
            Knob.BackgroundColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0)

            Holder.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    state = not state

                    TweenService:Create(Toggle,TweenInfo.new(0.2),{
                        BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(60,60,70)
                    }):Play()

                    TweenService:Create(Knob,TweenInfo.new(0.2),{
                        Position = state and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
                    }):Play()

                    callback(state)
                end
            end)
        end

        function Elements:CreateSlider(text,min,max,default,callback)
            local value = default

            local Holder = Instance.new("Frame", Page)
            Holder.Size = UDim2.new(1,-10,0,60)
            Holder.BackgroundColor3 = Theme.Surface
            Instance.new("UICorner", Holder).CornerRadius = UDim.new(0,10)

            local stroke = Instance.new("UIStroke", Holder)
            stroke.Color = Theme.Stroke

            local Label = Instance.new("TextLabel", Holder)
            Label.Text = text.." : "..value
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 14
            Label.TextColor3 = Theme.Text
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0,15,0,5)
            Label.Size = UDim2.new(1,-30,0,25)
            Label.TextXAlignment = Left

            local Bar = Instance.new("Frame", Holder)
            Bar.Size = UDim2.new(1,-30,0,6)
            Bar.Position = UDim2.new(0,15,0,40)
            Bar.BackgroundColor3 = Color3.fromRGB(55,58,68)
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1,0)

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
            Fill.BackgroundColor3 = Theme.Accent
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1,0)

            local dragging = false

            Bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            RunService.RenderStepped:Connect(function()
                if dragging then
                    local pos = (UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X
                    pos = math.clamp(pos,0,1)
                    value = math.floor(min + (max-min)*pos)
                    Fill.Size = UDim2.new(pos,0,1,0)
                    Label.Text = text.." : "..value
                    callback(value)
                end
            end)
        end

        return Elements
    end

    return Tabs
end

return Library
