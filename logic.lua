-- логика
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local activeCharacter = nil
local phantomClone = nil
local realBodyStorage = Vector3.new(0, -999, 0)
local lastRagdollState = false
local lastPhantomState = false

-- применение валкспида и джампповер
local function updateStats()
	local char = activeCharacter or player.Character
	if char and _G.WindowsXP_Share then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = _G.WindowsXP_Share.CurrentSpeed
			hum.UseJumpPower = true
			hum.JumpPower = _G.WindowsXP_Share.CurrentJump
		end
	end
end

-- рагдолл(локально)
local function setRagdoll(state)
	local char = activeCharacter or player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	
	hum.PlatformStand = state
	for _, desc in pairs(char:GetDescendants()) do
		if desc:IsA("Motor6D") and state then
			local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
			a0.Name, a1.Name = "RagAtt0", "RagAtt1"
			a0.CFrame, a1.CFrame = desc.C0, desc.C1
			a0.Parent, a1.Parent = desc.Part0, desc.Part1
			
			local b = Instance.new("BallSocketConstraint")
			b.Name = "RagSocket" b.Attachment0 = a0 b.Attachment1 = a1
			b.Parent = desc.Parent
			desc.Enabled = false
		elseif not state and desc.Name == "RagSocket" then
			local motor = desc.Parent:FindFirstChildOfClass("Motor6D")
			if motor then motor.Enabled = true end
			if desc.Parent:FindFirstChild("RagAtt0") then desc.Parent.RagAtt0:Destroy() end
			if desc.Parent:FindFirstChild("RagAtt1") then desc.Parent.RagAtt1:Destroy() end
			desc:Destroy()
		end
	end
end

-- фантом
local function handlePhantomMode(state)
	local realChar = player.Character
	if not realChar or not realChar:FindFirstChild("HumanoidRootPart") then return end
	
	if state then
		realChar.Archivable = true
		phantomClone = realChar:Clone()
		realChar.Archivable = false
		phantomClone.Name = "PhantomKlon"
		phantomClone.Parent = workspace
		activeCharacter = phantomClone
		
		for _, part in pairs(phantomClone:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("Decal") then
				if part.Name ~= "HumanoidRootPart" then part.Transparency = 0.5 part.CanCollide = true end
			end
		end
		
		local realRoot = realChar.HumanoidRootPart
		local originalPos = realRoot.CFrame
		realRoot.Anchored = true
		realRoot.CFrame = CFrame.new(realBodyStorage)
		
		phantomClone:SetPrimaryPartCFrame(originalPos)
		camera.CameraSubject = phantomClone:FindFirstChildOfClass("Humanoid")
		updateStats()
	else
		if phantomClone and phantomClone:FindFirstChild("HumanoidRootPart") then
			local phantomPos = phantomClone.HumanoidRootPart.CFrame
			if realChar and realChar:FindFirstChild("HumanoidRootPart") then
				realChar.HumanoidRootPart.Anchored = false
				realChar.HumanoidRootPart.CFrame = phantomPos
				camera.CameraSubject = realChar:FindFirstChildOfClass("Humanoid")
			end
			phantomClone:Destroy()
			phantomClone = nil
		end
		activeCharacter = nil
		updateStats()
	end
end

-- постоянный цикл проверки кнопок из таблицы _G
RunService.RenderStepped:Connect(function()
	if not _G.WindowsXP_Share then return end
	
	-- Принудительное обновление статов по триггеру кнопки
	if _G.WindowsXP_Share.TriggerStatsUpdate then
		_G.WindowsXP_Share.TriggerStatsUpdate = false
		updateStats()
	end
	
	-- проверка изменения фантома
	if _G.WindowsXP_Share.PhantomActive ~= lastPhantomState then
		lastPhantomState = _G.WindowsXP_Share.PhantomActive
		handlePhantomMode(lastPhantomState)
	end
	
	-- проверка изменения Рэгдолла
	if _G.WindowsXP_Share.RagdollEnabled ~= lastRagdollState then
		lastRagdollState = _G.WindowsXP_Share.RagdollEnabled
		setRagdoll(lastRagdollState)
	end
	
	-- логика управления фантома и полёта
	local targetChar = activeCharacter or player.Character
	if not targetChar then return end
	local root = targetChar:FindFirstChild("HumanoidRootPart")
	local hum = targetChar:FindFirstChildOfClass("Humanoid")
	
	if root and hum then
		-- движение фантома
		if _G.WindowsXP_Share.PhantomActive and not _G.WindowsXP_Share.FlyEnabled then
			local moveDir = hum.MoveDirection
			root.Velocity = Vector3.new(moveDir.X * _G.WindowsXP_Share.CurrentSpeed, root.Velocity.Y, moveDir.Z * _G.WindowsXP_Share.CurrentSpeed)
			if moveDir.Magnitude > 0 then
				local targetAngle = math.atan2(-moveDir.X, -moveDir.Z)
				root.CFrame = root.CFrame:Lerp(CFrame.new(root.Position) * CFrame.Angles(0, targetAngle, 0), 0.2)
			end
		end
		
		-- полёт
		if _G.WindowsXP_Share.FlyEnabled then
			hum.PlatformStand = true
			local camCFrame = camera.CFrame
			local velocity = Vector3.new(0,0,0)
			
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + camCFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - camCFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - camCFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + camCFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then velocity = velocity - Vector3.new(0, 1, 0) end
			
			root.Velocity = velocity.Magnitude > 0 and velocity.Unit * 50 or Vector3.new(0, 0.1, 0)
		elseif not _G.WindowsXP_Share.FlyEnabled and hum.PlatformStand and not _G.WindowsXP_Share.RagdollEnabled then
			hum.PlatformStand = false
		end
	end
end)

-- бесконечный прыжок
UserInputService.JumpRequest:Connect(function()
	if not _G.WindowsXP_Share then return end
	local char = activeCharacter or player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum and _G.WindowsXP_Share.InfJumpEnabled then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- прыжок для фантома
UserInputService.InputBegan:Connect(function(input, processed)
	if processed or not _G.WindowsXP_Share or not _G.WindowsXP_Share.PhantomActive or not phantomClone then return end
	if input.KeyCode == Enum.KeyCode.Space and not _G.WindowsXP_Share.FlyEnabled then
		local hum = phantomClone:FindFirstChildOfClass("Humanoid")
		local root = phantomClone:FindFirstChild("HumanoidRootPart")
		if hum and root then
			local ray = Ray.new(root.Position, Vector3.new(0, -3.5, 0))
			local hit = workspace:FindPartOnRayWithIgnoreList(ray, {phantomClone, player.Character})
			if hit or _G.WindowsXP_Share.InfJumpEnabled then
				root.Velocity = Vector3.new(root.Velocity.X, _G.WindowsXP_Share.CurrentJump, root.Velocity.Z)
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)

player.CharacterAdded:Connect(function()
	if _G.WindowsXP_Share then _G.WindowsXP_Share.PhantomActive = false end
	activeCharacter, phantomClone = nil, nil
end)
