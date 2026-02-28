local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local parent = gethui and gethui() or game:GetService("CoreGui")

-- CLEAN OLD
if parent:FindFirstChild("PremiumUI") then
	parent.PremiumUI:Destroy()
end

-- GUI
local gui = Instance.new("ScreenGui", parent)
gui.Name = "PremiumUI"
gui.ResetOnSpawn = false

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(540,380)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(20,20,25)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,20)

-- GRADIENT
local grad = Instance.new("UIGradient", main)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,35)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,20))
}
grad.Rotation = 90

-- SHADOW EFFECT
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(0,170,255)
stroke.Transparency = 0.6

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
title.Size = UDim2.new(1,-20,0,45)
title.Position = UDim2.new(0,15,0,10)
title.BackgroundTransparency = 1
title.Text = "Premium Modern UI"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Left

-- TAB HOLDER
local tabHolder = Instance.new("Frame", main)
tabHolder.Size = UDim2.new(0,140,1,-70)
tabHolder.Position = UDim2.new(0,15,0,60)
tabHolder.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabHolder)
tabLayout.Padding = UDim.new(0,8)

-- CONTENT
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-170,1,-70)
content.Position = UDim2.new(0,160,0,60)
content.BackgroundTransparency = 1

local currentPage

local function createTab(name)
	local btn = Instance.new("TextButton", tabHolder)
	btn.Size = UDim2.new(1,0,0,40)
	btn.BackgroundColor3 = Color3.fromRGB(35,35,45)
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = Color3.new(1,1,1)
	btn.AutoButtonColor = false
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)

	local page = Instance.new("Frame", content)
	page.Size = UDim2.new(1,0,1,0)
	page.Visible = false
	page.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0,12)

	btn.MouseButton1Click:Connect(function()
		if currentPage then currentPage.Visible = false end
		currentPage = page
		page.Visible = true
	end)

	return page
end

-- CARD
local function createCard(parent, height)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1,0,0,height)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,38)
	frame.BorderSizePixel = 0
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)
	return frame
end

-- PREMIUM BUTTON
local function createButton(parent, text)
	local card = createCard(parent,50)
	local btn = Instance.new("TextButton", card)
	btn.Size = UDim2.new(1,-20,1,-20)
	btn.Position = UDim2.new(0,10,0,10)
	btn.BackgroundTransparency = 1
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 15
	btn.TextColor3 = Color3.new(1,1,1)

	btn.MouseEnter:Connect(function()
		TweenService:Create(card,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(0,170,255)}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(card,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(30,30,38)}):Play()
	end)
end

-- PREMIUM TOGGLE
local function createToggle(parent, text)
	local card = createCard(parent,50)

	local label = Instance.new("TextLabel", card)
	label.Size = UDim2.new(0.7,0,1,0)
	label.Position = UDim2.new(0,15,0,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 15
	label.TextColor3 = Color3.new(1,1,1)
	label.TextXAlignment = Left

	local toggle = Instance.new("Frame", card)
	toggle.Size = UDim2.fromOffset(46,24)
	toggle.Position = UDim2.new(1,-70,0.5,-12)
	toggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame", toggle)
	knob.Size = UDim2.fromOffset(20,20)
	knob.Position = UDim2.new(0,2,0.5,-10)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

	local state = false

	card.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			state = not state
			TweenService:Create(toggle,TweenInfo.new(0.15),
				{BackgroundColor3 = state and Color3.fromRGB(0,170,255) or Color3.fromRGB(60,60,70)}):Play()

			TweenService:Create(knob,TweenInfo.new(0.15),
				{Position = state and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)}):Play()
		end
	end)
end
