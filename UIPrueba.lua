-- LocalScript para StarterPlayerScripts o StarterGui.
-- Prueba aislada: solo muestra una ventana y el fondo indicado; no incluye opciones de juego.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local existing = playerGui:FindFirstChild("TGGX_UI_Prueba")
if existing then
	existing:Destroy()
end

local function make(className, properties, parent)
	local object = Instance.new(className)
	for property, value in pairs(properties) do
		object[property] = value
	end
	object.Parent = parent
	return object
end

local function addCorner(parent, radius)
	return make("UICorner", {CornerRadius = UDim.new(0, radius)}, parent)
end

local gui = make("ScreenGui", {
	Name = "TGGX_UI_Prueba",
	DisplayOrder = 100,
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local panel = make("Frame", {
	Name = "TestPanel",
	Active = true,
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(11, 17, 29), -- respaldo si Roblox no carga la imagen
	BackgroundTransparency = 0,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(456, 360),
	ZIndex = 1,
}, gui)
addCorner(panel, 18)

local panelStroke = make("UIStroke", {
	Color = Color3.fromRGB(67, 189, 255),
	Thickness = 1.5,
	Transparency = 0.12,
}, panel)

local uiScale = make("UIScale", {Scale = 1}, panel)
local initialSize = UDim2.fromOffset(456, 360)

local function updateScale()
	local camera = workspace.CurrentCamera
	if not camera then return end
	local viewport = camera.ViewportSize
	local fit = math.min(1, (viewport.X - 24) / 456, (viewport.Y - 24) / 360)
	uiScale.Scale = math.clamp(fit, 0.5, 1)
end

local cameraConnection
local function bindCamera()
	if cameraConnection then
		cameraConnection:Disconnect()
		cameraConnection = nil
	end
	local camera = workspace.CurrentCamera
	if camera then
		updateScale()
		cameraConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
	end
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
bindCamera()

local background = make("ImageLabel", {
	Name = "BackgroundImage",
	Active = false,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Image = "rbxassetid://135136288920049",
	ImageColor3 = Color3.new(1, 1, 1),
	ImageTransparency = 0,
	Position = UDim2.fromScale(0, 0),
	ScaleType = Enum.ScaleType.Crop,
	Size = UDim2.fromScale(1, 1),
	Visible = true,
	ZIndex = 2,
}, panel)

task.delay(8, function()
	if background.Parent and not background.IsLoaded then
		warn("La imagen 135136288920049 no cargó. Revisa View > Output: Roblox puede requerir permiso del asset para esta experiencia.")
	end
end)

local header = make("Frame", {
	Name = "Header",
	Active = true,
	BackgroundColor3 = Color3.fromRGB(7, 13, 24),
	BackgroundTransparency = 0.22,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 48),
	ZIndex = 3,
}, panel)
addCorner(header, 18)
make("Frame", {
	BackgroundColor3 = Color3.fromRGB(7, 13, 24),
	BackgroundTransparency = 0.22,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 1, -16),
	Size = UDim2.new(1, 0, 0, 16),
	ZIndex = 3,
}, header)

local title = make("TextLabel", {
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Position = UDim2.fromOffset(16, 0),
	Size = UDim2.new(1, -76, 1, 0),
	Text = "PRUEBA DE UI",
	TextColor3 = Color3.fromRGB(245, 249, 255),
	TextSize = 16,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 4,
}, header)

local closeButton = make("TextButton", {
	Name = "CloseButton",
	Active = true,
	AutoButtonColor = true,
	BackgroundColor3 = Color3.fromRGB(190, 55, 75),
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBold,
	Position = UDim2.new(1, -40, 0, 9),
	Size = UDim2.fromOffset(30, 30),
	Text = "X",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 14,
	ZIndex = 5,
}, header)
addCorner(closeButton, 9)

local hint = make("TextLabel", {
	BackgroundColor3 = Color3.fromRGB(7, 13, 24),
	BackgroundTransparency = 0.22,
	BorderSizePixel = 0,
	Font = Enum.Font.GothamMedium,
	Position = UDim2.new(0, 14, 1, -36),
	Size = UDim2.new(1, -28, 0, 24),
	Text = "Fondo de prueba  |  ID 135136288920049",
	TextColor3 = Color3.fromRGB(238, 244, 255),
	TextSize = 11,
	ZIndex = 4,
}, panel)
addCorner(hint, 8)

local reopenButton = make("TextButton", {
	Name = "ReopenButton",
	Active = true,
	AnchorPoint = Vector2.new(0.5, 0.5),
	AutoButtonColor = true,
	BackgroundColor3 = Color3.fromRGB(18, 38, 58),
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBold,
	Position = UDim2.new(1, -70, 1, -54),
	Size = UDim2.fromOffset(110, 40),
	Text = "ABRIR UI",
	TextColor3 = Color3.fromRGB(245, 249, 255),
	TextSize = 13,
	Visible = false,
	ZIndex = 20,
}, gui)
addCorner(reopenButton, 12)
make("UIStroke", {
	Color = Color3.fromRGB(67, 189, 255),
	Thickness = 1.2,
	Transparency = 0.18,
}, reopenButton)

local animationBusy = false
local dragging = false
local dragStart
local panelStart

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		panelStart = panel.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		panel.Position = UDim2.new(
			panelStart.X.Scale, panelStart.X.Offset + delta.X,
			panelStart.Y.Scale, panelStart.Y.Offset + delta.Y
		)
	end
end)

local function closeWithAnimation()
	if animationBusy or not panel.Visible then return end
	animationBusy = true
	local info = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local panelTween = TweenService:Create(panel, info, {
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1,
	})
	TweenService:Create(background, info, {ImageTransparency = 1}):Play()
	TweenService:Create(header, info, {BackgroundTransparency = 1}):Play()
	TweenService:Create(title, info, {TextTransparency = 1}):Play()
	TweenService:Create(closeButton, info, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
	TweenService:Create(hint, info, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
	TweenService:Create(panelStroke, info, {Transparency = 1}):Play()
	panelTween:Play()
	panelTween.Completed:Wait()
	panel.Visible = false
	panel.Size = initialSize
	panel.BackgroundTransparency = 0
	reopenButton.Visible = true
	reopenButton.Size = UDim2.fromOffset(0, 0)
	reopenButton.TextTransparency = 1
	TweenService:Create(reopenButton, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.fromOffset(110, 40),
		TextTransparency = 0,
	}):Play()
	animationBusy = false
end

local function openWithAnimation()
	if animationBusy or panel.Visible then return end
	animationBusy = true
	reopenButton.Visible = false
	panel.Visible = true
	panel.Size = UDim2.fromOffset(0, 0)
	panel.BackgroundTransparency = 1
	background.ImageTransparency = 1
	header.BackgroundTransparency = 1
	title.TextTransparency = 1
	closeButton.BackgroundTransparency = 1
	closeButton.TextTransparency = 1
	hint.BackgroundTransparency = 1
	hint.TextTransparency = 1
	panelStroke.Transparency = 1
	local info = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local panelTween = TweenService:Create(panel, info, {
		Size = initialSize,
		BackgroundTransparency = 0,
	})
	TweenService:Create(background, info, {ImageTransparency = 0}):Play()
	TweenService:Create(header, info, {BackgroundTransparency = 0.22}):Play()
	TweenService:Create(title, info, {TextTransparency = 0}):Play()
	TweenService:Create(closeButton, info, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
	TweenService:Create(hint, info, {BackgroundTransparency = 0.22, TextTransparency = 0}):Play()
	TweenService:Create(panelStroke, info, {Transparency = 0.12}):Play()
	panelTween:Play()
	panelTween.Completed:Wait()
	animationBusy = false
end

closeButton.Activated:Connect(closeWithAnimation)
reopenButton.Activated:Connect(openWithAnimation)
