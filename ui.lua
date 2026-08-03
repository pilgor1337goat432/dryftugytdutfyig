-- интерфейс
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- screengui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WindowsXP_GithubGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- главное окно
local window = Instance.new("Frame")
window.Size = UDim2.new(0, 420, 0, 360)
window.Position = UDim2.new(0.5, -210, 0.5, -180)
window.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
window.BorderSizePixel = 1
window.Active = true
window.ClipsDescendants = true
window.Parent = screenGui

local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(0, 84, 227)
border.Thickness = 3
border.Parent = window

-- заголовок окна
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 84, 227)
titleBar.Parent = window

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -70, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Be a toy script (Cloud Mode)"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- свернуть и закрыть
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 22, 0, 22)
closeButton.Position = UDim2.new(1, -26, 0.5, -11)
closeButton.BackgroundColor3 = Color3.fromRGB(224, 79, 48)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = titleBar
Instance.new("UICorner", closeButton)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 22, 0, 22)
minimizeButton.Position = UDim2.new(1, -52, 0.5, -11)
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 84, 227)
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.Parent = titleBar
Instance.new("UICorner", minimizeButton)

-- белый контент
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -12, 1, -42)
contentFrame.Position = UDim2.new(0, 6, 0, 36)
contentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
contentFrame.Parent = window

local playerCategoryButton = Instance.new("TextButton")
playerCategoryButton.Size = UDim2.new(1, -20, 0, 30)
playerCategoryButton.Position = UDim2.new(0, 10, 0, 10)
playerCategoryButton.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
playerCategoryButton.Text = "player"
playerCategoryButton.Font = Enum.Font.SourceSansBold
playerCategoryButton.TextSize = 16
playerCategoryButton.Parent = contentFrame

-- настройки ввода скорости
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(1, -20, 0, 120)
settingsFrame.Position = UDim2.new(0, 10, 0, 45)
settingsFrame.BackgroundTransparency = 1
settingsFrame.Parent = contentFrame

local function createInputRow(labelTxt, placeholder, yPos)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 150, 0, 25)
	label.Position = UDim2.new(0, 10, 0, yPos)
	label.BackgroundTransparency = 1
	label.Text = labelTxt
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextSize = 15
	label.Parent = settingsFrame

	local input = Instance.new("TextBox")
	input.Size = UDim2.new(0, 100, 0, 25)
	input.Position = UDim2.new(0, 180, 0, yPos)
	input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	input.PlaceholderText = placeholder
	input.Text = ""
	input.TextSize = 15
	input.Parent = settingsFrame
	return input
end

local speedInput = createInputRow("WalkSpeed (Скорость):", "Default (16)", 5)
local jumpInput = createInputRow("JumpPower (Прыжок):", "Default (50)", 35)

local applyButton = Instance.new("TextButton")
applyButton.Size = UDim2.new(0, 120, 0, 25)
applyButton.Position = UDim2.new(0.5, -60, 0, 70)
applyButton.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
applyButton.Text = "Apply Settings"
applyButton.Font = Enum.Font.SourceSansBold
applyButton.Parent = settingsFrame

-- передача данных при _G клике
applyButton.MouseButton1Click:Connect(function()
	if _G.WindowsXP_Share then
		_G.WindowsXP_Share.CurrentSpeed = tonumber(speedInput.Text) or 16
		_G.WindowsXP_Share.CurrentJump = tonumber(jumpInput.Text) or 50
		_G.WindowsXP_Share.TriggerStatsUpdate = true
	end
end)

-- кнопки для админки
local cheatsFrame = Instance.new("Frame")
cheatsFrame.Size = UDim2.new(1, -20, 0, 130)
cheatsFrame.Position = UDim2.new(0, 10, 0, 170)
cheatsFrame.BackgroundTransparency = 1
cheatsFrame.Parent = contentFrame

local function createCheatButton(gKey, text, pos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 180, 0, 30)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(236, 233, 216)
	btn.Text = text .. ": OFF"
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Parent = cheatsFrame
	
	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
	в	btn.Text = text .. (state and ": ON" or ": OFF")
		btn.BackgroundColor3 = state and Color3.fromRGB(190, 220, 190) or Color3.fromRGB(236, 233, 216)
		if _G.WindowsXP_Share then
			_G.WindowsXP_Share[gKey] = state
		end
	end)
end

createCheatButton("FlyEnabled", "Fly (Полёт)", UDim2.new(0, 10, 0, 10))
createCheatButton("InfJumpEnabled", "Infinite Jump", UDim2.new(0, 200, 0, 10))
createCheatButton("RagdollEnabled", "Ragdoll (Труп)", UDim2.new(0, 10, 0, 50))
createCheatButton("PhantomActive", "Phantom (Фантом)", UDim2.new(0, 200, 0, 50))

-- закрытие и сворачивание окна
closeButton.MouseButton1Click:Connect(function() 
	if _G.WindowsXP_Share then _G.WindowsXP_Share.PhantomActive = false end
	screenGui:Destroy() 
end)

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	contentFrame.Visible = not isMinimized
	TweenService:Create(window, TweenInfo.new(0.2), {Size = isMinimized and UDim2.new(0, 420, 0, 30) or UDim2.new(0, 420, 0, 360)}):Play()
end)

-- перетаскивание окна
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true dragStart = input.Position startPos = window.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
