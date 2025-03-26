-- everything made Chatgpt :-}

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local mouse = player:GetMouse()

local floating = false
local bodyVelocity, spin
local spinSpeed = 0.5 -- WASD spin adjustment speed (slower)
local spinDirection = Vector3.new(0.2, 0.2, 0.2) -- Slower initial spin

local function startFloating()
    if floating then return end
    floating = true

    -- Disable movement
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.AutoRotate = false

    -- Floating movement towards cursor
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = humanoidRootPart

    -- Add controlled spinning effect
    spin = Instance.new("BodyAngularVelocity")
    spin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    spin.AngularVelocity = spinDirection
    spin.Parent = humanoidRootPart

    -- Update movement toward cursor
    runService.RenderStepped:Connect(function()
        if floating then
            local targetPosition = mouse.Hit.Position
            local direction = (targetPosition - humanoidRootPart.Position).unit
            bodyVelocity.Velocity = direction * 5 -- Adjust speed
            spin.AngularVelocity = spinDirection -- Update spin
        end
    end)
end

local function stopFloating()
    if not floating then return end
    floating = false

    -- Remove floating effects
    if bodyVelocity then bodyVelocity:Destroy() end
    if spin then spin:Destroy() end

    -- Restore movement
    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50
    humanoid.AutoRotate = true
end

-- Handle key inputs for spinning
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not floating then return end

    if input.KeyCode == Enum.KeyCode.W then
        spinDirection = spinDirection + Vector3.new(spinSpeed, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.S then
        spinDirection = spinDirection - Vector3.new(spinSpeed, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.A then
        spinDirection = spinDirection + Vector3.new(0, spinSpeed, 0)
    elseif input.KeyCode == Enum.KeyCode.D then
        spinDirection = spinDirection - Vector3.new(0, spinSpeed, 0)
    end
end)

-- Toggle flying when pressing "F"
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
        if floating then
            stopFloating()
        else
            startFloating()
        end
    end
end)
