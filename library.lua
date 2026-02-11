local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Library = {}s

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

function Library:Notify(title, text, duration)
    local NotifyGui = Instance.new("ScreenGui", CoreGui)
    local NotifyFrame = Instance.new("Frame", NotifyGui)
    NotifyFrame.Size = UDim2.new(0, 260, 0, 85)
    NotifyFrame.Position = UDim2.new(1, -270, 1, 100)
    NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", NotifyFrame); s.Color = Color3.fromRGB(0, 255, 150)

    local Tl = Instance.new("TextLabel", NotifyFrame)
    Tl.Text = title; Tl.Size = UDim2.new(1, -20, 0, 30); Tl.Position = UDim2.new(0, 10, 0, 5)
    Tl.TextColor3 = Color3.fromRGB(0, 255, 150); Tl.Font = Enum.Font.GothamBold; Tl.TextSize = 18; Tl.BackgroundTransparency = 1; Tl.TextXAlignment = Enum.TextXAlignment.Left

    local Tx = Instance.new("TextLabel", NotifyFrame)
    Tx.Text = text; Tx.Size = UDim2.new(1, -20, 0, 40); Tx.Position = UDim2.new(0, 10, 0, 35)
    Tx.TextColor3 = Color3.fromRGB(255, 255, 255); Tx.Font = Enum.Font.Gotham; Tx.TextSize = 14; Tx.BackgroundTransparency = 1; Tx.TextXAlignment = Enum.TextXAlignment.Left; Tx.TextWrapped = true

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
    Main.Size = UDim2.new(0, 580, 0, 380)
    Main.Position = UDim2.new(0.5, -290, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", Main); Stroke.Color = Color3.fromRGB(45, 45, 45); Stroke.Thickness = 2
    MakeDraggable(Main)

    local LeftPanel = Instance.new("Frame", Main)
    LeftPanel.Size = UDim2.new(0, 160, 1, 0); LeftPanel.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", LeftPanel).CornerRadius = UDim.new(0, 12)

    local TitleLbl = Instance.new("TextLabel", LeftPanel)
    TitleLbl.Size = UDim2.new(1, 0, 0, 60); TitleLbl.Text = title; TitleLbl.Font = Enum.Font.GothamBold; TitleLbl.TextSize = 21; TitleLbl.BackgroundTransparency = 1
    RunService.RenderStepped:Connect(function() TitleLbl.TextColor3 = Color3.fromHSV(tick()%5/5, 0.6, 1) end)

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -180, 1, -20); Container.Position = UDim2.new(0, 170, 0, 10); Container.BackgroundTransparency = 1

    local TabHolder = Instance.new("ScrollingFrame", LeftPanel)
    TabHolder.Size = UDim2.new(1, 0, 1, -70); TabHolder.Position = UDim2.new(0, 0, 0, 65); TabHolder.BackgroundTransparency = 1; TabHolder.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabHolder).HorizontalAlignment = Enum.HorizontalAlignment.Center

    local WindowFunctions = {First = true}

    function WindowFunctions:CreateTab(name)
        -- Tab Sayfası (ScrollingFrame)
        local Page = Instance.new("ScrollingFrame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150); Page.CanvasSize = UDim2.new(0, 0, 0, 0); Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local PageLayout = Instance.new("UIListLayout", Page); PageLayout.Padding = UDim.new(0, 12); PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

        -- Tab Butonu (Sol Panel)
        local TBtn = Instance.new("TextButton", TabHolder)
        TBtn.Size = UDim2.new(0, 140, 0, 38); TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); TBtn.Text = name; TBtn.TextColor3 = Color3.fromRGB(200, 200, 200); TBtn.Font = Enum.Font.GothamBold; TBtn.TextSize = 16
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)

        if WindowFunctions.First then Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45); WindowFunctions.First = false end

        TBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Page.Visible = true
        end)

        local TabFunctions = {}

        -- >>> SECTION OLUŞTURMA <<<
        function TabFunctions:CreateSection(sectionName)
            -- Section Ana Kutusu (İçine elementler gelecek)
            local SectionContainer = Instance.new("Frame", Page)
            SectionContainer.Size = UDim2.new(1, -10, 0, 0) -- Yükseklik otomatik artacak
            SectionContainer.BackgroundTransparency = 1
            SectionContainer.AutomaticSize = Enum.AutomaticSize.Y -- İçindekilere göre büyür

            local SectionLayout = Instance.new("UIListLayout", SectionContainer)
            SectionLayout.Padding = UDim.new(0, 8)
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder

            -- Section Başlığı
            local TitleFrame = Instance.new("Frame", SectionContainer)
            TitleFrame.Size = UDim2.new(1, 0, 0, 30); TitleFrame.BackgroundTransparency = 1
            
            local TitleText = Instance.new("TextLabel", TitleFrame)
            TitleText.Text = sectionName; TitleText.Size = UDim2.new(1, 0, 1, 0); TitleText.TextColor3 = Color3.fromRGB(0, 255, 150); TitleText.Font = Enum.Font.GothamBold; TitleText.TextSize = 15; TitleText.BackgroundTransparency = 1; TitleText.TextXAlignment = Enum.TextXAlignment.Left

            local Line = Instance.new("Frame", TitleFrame); Line.Size = UDim2.new(1, 0, 0, 1); Line.Position = UDim2.new(0, 0, 1, 0); Line.BackgroundColor3 = Color3.fromRGB(45, 45, 45); Line.BorderSizePixel = 0

            -- ELEMENT FONKSİYONLARI (Artık Section'a bağlı)
            local SectionFunctions = {}

            function SectionFunctions:CreateLabel(txt)
                local L = Instance.new("TextLabel", SectionContainer)
                L.Size = UDim2.new(1, 0, 0, 25); L.Text = txt; L.TextColor3 = Color3.fromRGB(200, 200, 200); L.Font = Enum.Font.GothamMedium; L.TextSize = 14; L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left
                return L
            end

            function SectionFunctions:CreateButton(txt, cb)
                local B = Instance.new("TextButton", SectionContainer)
                B.Size = UDim2.new(1, 0, 0, 42); B.BackgroundColor3 = Color3.fromRGB(35, 35, 35); B.Text = txt; B.TextColor3 = Color3.fromRGB(255,255,255); B.Font = Enum.Font.GothamBold; B.TextSize = 18
                Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6); B.MouseButton1Click:Connect(cb)
                return B
            end

            function SectionFunctions:CreateToggle(txt, cb)
                local s = false
                local T = Instance.new("TextButton", SectionContainer)
                T.Size = UDim2.new(1, 0, 0, 42); T.BackgroundColor3 = Color3.fromRGB(30, 30, 30); T.Text = "  "..txt; T.TextColor3 = Color3.fromRGB(200,200,200); T.TextXAlignment = Enum.TextXAlignment.Left; T.Font = Enum.Font.GothamBold; T.TextSize = 17
                Instance.new("UICorner", T).CornerRadius = UDim.new(0, 6)
                local Box = Instance.new("Frame", T); Box.Size = UDim2.new(0, 22, 0, 22); Box.Position = UDim2.new(1, -32, 0.5, -11); Box.BackgroundColor3 = Color3.fromRGB(50,50,50)
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
                T.MouseButton1Click:Connect(function()
                    s = not s
                    TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = s and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(50, 50, 50)}):Play()
                    cb(s)
                end)
                return T
            end

            function SectionFunctions:CreateSlider(txt, min, max, def, cb)
                local S = Instance.new("Frame", SectionContainer)
                S.Size = UDim2.new(1, 0, 0, 55); S.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", S).CornerRadius = UDim.new(0, 6)
                local L = Instance.new("TextLabel", S); L.Text = txt..": "..def; L.Size = UDim2.new(1, -20, 0, 25); L.Position = UDim2.new(0, 10, 0, 5); L.TextColor3 = Color3.fromRGB(255,255,255); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Font = Enum.Font.GothamBold; L.TextSize = 16
                local Bar = Instance.new("TextButton", S); Bar.Size = UDim2.new(1, -20, 0, 8); Bar.Position = UDim2.new(0, 10, 0, 35); Bar.BackgroundColor3 = Color3.fromRGB(50,50,50); Bar.Text = ""; Instance.new("UICorner", Bar)
                local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150); Instance.new("UICorner", Fill)
                
                Bar.MouseButton1Down:Connect(function()
                    local conn; conn = RunService.RenderStepped:Connect(function()
                        local p = math.clamp((UserInputService:GetMouseLocation().X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        local v = math.floor(min + (max - min) * p); Fill.Size = UDim2.new(p, 0, 1, 0); L.Text = txt..": "..v; cb(v)
                    end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() end end)
                end)
                return S
            end

            return SectionFunctions -- Burası önemli: Section'ı değişkene atamana izin verir
        end

        return TabFunctions
    end
    return WindowFunctions
end

return Library
