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
