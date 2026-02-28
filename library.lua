local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local parent = gethui and gethui() or game:GetService("CoreGui")

if parent:FindFirstChild("UltraUI") then
	parent.UltraUI:Destroy()
end

local gui = Instance.new("ScreenGui", parent)
gui.Name = "UltraUI"
gui.ResetOnSpawn = false

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(560,400)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(18,18,22)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,22)

-- SOFT STROKE
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(120,80,255)
stroke.Transparency = 0.4
stroke.Thickness = 1.5

-- GRADIENT
local grad = Instance.new("UIGradient", main)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(30,30,40)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,20))
}
grad.Rotation = 90

-- DRAG
do
	local dragging, startPos, startInput
	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startInput = input.Position
			startPos = main.Position
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - startInput
			main.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,-40,0,50)
title.Position = UDim2.new(0,20,0,15)
title.BackgroundTransparency = 1
title.Text = "Ultra Modern UI"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Left

-- TAB BAR
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1,-40,0,40)
tabBar.Position = UDim2.new(0,20,0,70)
tabBar.BackgroundTransparency = 1

local indicator = Instance.new("Frame", tabBar)
indicator.Size = UDim2.new(0,80,0,3)
indicator.Position = UDim2.new(0,0,1,-3)
indicator.BackgroundColor3 = Color3.fromRGB(140,90,255)
Instance.new("UICorner", indicator).CornerRadius = UDim.new(1,0)

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Horizontal
tabLayout.Padding = UDim.new(0,20)

-- CONTENT
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-40,1,-130)
content.Position = UDim2.new(0,20,0,110)
content.BackgroundTransparency = 1

local pages = {}
local current

local function createTab(name)
	local btn = Instance.new("TextButton", tabBar)
	btn.Size = UDim2.fromOffset(80,30)
	btn.BackgroundTransparency = 1
	btn.Text = name
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 16
	btn.TextColor3 = Color3.fromRGB(170,170,170)
	btn.AutoButtonColor = false

	local page = Instance.new("Frame", content)
	page.Size = UDim2.new(1,0,1,0)
	page.Visible = false
	page.BackgroundTransparency = 1
	pages[btn] = page

	btn.MouseButton1Click:Connect(function()
		if current then current.Visible = false end
		current = page
		page.Visible = true

		for b,_ in pairs(pages) do
			TweenService:Create(b,TweenInfo.new(0.2),{TextColor3=Color3.fromRGB(170,170,170)}):Play()
		end

		TweenService:Create(btn,TweenInfo.new(0.2),{TextColor3=Color3.new(1,1,1)}):Play()
		TweenService:Create(indicator,TweenInfo.new(0.25,Enum.EasingStyle.Quad),
			{Position = UDim2.new(0,btn.AbsolutePosition.X - tabBar.AbsolutePosition.X,1,-3),
			 Size = UDim2.new(0,btn.AbsoluteSize.X,0,3)}):Play()
	end)

	return page
end

-- CARD
local function createCard(parent, height)
	local card = Instance.new("Frame", parent)
	card.Size = UDim2.new(1,0,0,height)
	card.BackgroundColor3 = Color3.fromRGB(28,28,36)
	card.BackgroundTransparency = 0.1
	card.BorderSizePixel = 0
	Instance.new("UICorner", card).CornerRadius = UDim.new(0,16)
	return card
end

-- BUTTON
local function createButton(parent, text)
	local card = createCard(parent,55)
	local btn = Instance.new("TextButton", card)
	btn.Size = UDim2.new(1,-20,1,-20)
	btn.Position = UDim2.new(0,10,0,10)
	btn.BackgroundTransparency = 1
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 15
	btn.TextColor3 = Color3.new(1,1,1)

	btn.MouseEnter:Connect(function()
		TweenService:Create(card,TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(140,90,255)}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(card,TweenInfo.new(0.2),
			{BackgroundColor3 = Color3.fromRGB(28,28,36)}):Play()
	end)
end

-- LAYOUT FIX
local function applyLayout(page)
	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0,15)
end
