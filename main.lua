local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Colors = {
	BG = Color3.fromRGB(36, 36, 36),
	Bar = Color3.fromRGB(31, 31, 31),
	Surface = Color3.fromRGB(43, 43, 43),
	SurfaceHover = Color3.fromRGB(53, 53, 53),
	Line = Color3.fromRGB(56, 56, 56),
	Border = Color3.fromRGB(28, 28, 28),
	Text = Color3.fromRGB(255, 255, 255),
	Dim = Color3.fromRGB(171, 171, 171),
	Accent = Color3.fromRGB(101, 171, 255),
	On = Color3.fromRGB(60, 180, 100),
	Off = Color3.fromRGB(56, 56, 56),
	Red = Color3.fromRGB(220, 60, 70),
	Yellow = Color3.fromRGB(240, 190, 80),
	Green = Color3.fromRGB(80, 200, 120),
}

local FontRegular = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local FontBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local function create(class, props, parent)
	local instance = Instance.new(class)
	for key, value in pairs(props or {}) do
		instance[key] = value
	end
	if parent then
		instance.Parent = parent
	end
	return instance
end

local function corner(radius, parent)
	return create("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function stroke(color, thickness, parent)
	return create("UIStroke", { Color = color, Thickness = thickness }, parent)
end

local function tween(instance, time, props, style, direction)
	local info = TweenInfo.new(time, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
	local track = TweenService:Create(instance, info, props)
	track:Play()
	return track
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
end

local Testy = {}
Testy.Colors = Colors
Testy.Font = FontRegular
Testy.FontBold = FontBold
Testy.Pages = {}
Testy.Flags = {}

function Testy:Attach(guiName)
	guiName = guiName or "TestyGui"

	local gui = PlayerGui:WaitForChild(guiName, 10)
	if not gui then
		warn("[Testy] GUI not found: " .. guiName)
		return nil
	end

	local mainFrame = gui:FindFirstChild("MainFrame")
	local tabOpener = gui:FindFirstChild("TabOpener")
	if not mainFrame or not tabOpener then
		warn("[Testy] Missing MainFrame or TabOpener")
		return nil
	end

	local topBar = mainFrame:FindFirstChild("TopBar")
	local content = mainFrame:FindFirstChild("Content")
	local closeBtn = mainFrame:FindFirstChild("Close")
	local uiTitle = mainFrame:FindFirstChild("UiTitle")
	local openBtn = tabOpener:FindFirstChild("OpenButton")

	if not topBar or not content then
		warn("[Testy] Missing TopBar or Content")
		return nil
	end

	self.Gui = gui
	self.MainFrame = mainFrame
	self.TabOpener = tabOpener
	self.TopBar = topBar
	self.Content = content

	for _, page in ipairs(content:GetChildren()) do
		if page:IsA("ScrollingFrame") then
			local pageName = page.Name:gsub("^Page_", "")
			self.Pages[pageName] = page
		end
	end

	local tabs = {}
	for _, tab in ipairs(topBar:GetChildren()) do
		if tab:IsA("TextButton") and tab.Name:match("^Tab_") then
			local tabName = tab.Name:gsub("^Tab_", "")
			tabs[tabName] = tab
		end
	end

	local activeTabButton = nil
	local function switchTab(tabName)
		local tabButton = tabs[tabName]
		local page = self.Pages[tabName]
		if not tabButton or not page then return end

		if activeTabButton then
			tween(activeTabButton, 0.15, { BackgroundColor3 = Colors.Bar })
		end
		for pageName, pageInstance in pairs(self.Pages) do
			pageInstance.Visible = (pageName == tabName)
		end
		activeTabButton = tabButton
		tween(tabButton, 0.15, { BackgroundColor3 = Colors.SurfaceHover })
	end

	for tabName, tabButton in pairs(tabs) do
		tabButton.MouseEnter:Connect(function()
			if activeTabButton ~= tabButton then
				tween(tabButton, 0.12, { BackgroundColor3 = Colors.Surface })
			end
		end)
		tabButton.MouseLeave:Connect(function()
			if activeTabButton ~= tabButton then
				tween(tabButton, 0.12, { BackgroundColor3 = Colors.Bar })
			end
		end)
		tabButton.MouseButton1Click:Connect(function()
			switchTab(tabName)
		end)
	end

	for name, page in pairs(self.Pages) do
		if tabs[name] then
			page.Visible = false
		end
	end
	if tabs["Main"] then
		switchTab("Main")
	end

	if openBtn then
		openBtn.MouseButton1Click:Connect(function()
			mainFrame.Visible = not mainFrame.Visible
		end)
	end

	if closeBtn then
		closeBtn.MouseEnter:Connect(function()
			tween(closeBtn, 0.12, { BackgroundColor3 = Colors.Red, BackgroundTransparency = 0 })
		end)
		closeBtn.MouseLeave:Connect(function()
			tween(closeBtn, 0.12, { BackgroundColor3 = Colors.Bar, BackgroundTransparency = 0.3 })
		end)
		closeBtn.MouseButton1Click:Connect(function()
			mainFrame.Visible = false
		end)
	end

	if uiTitle then
		local dragging, dragStart, startPos
		uiTitle.InputBegan:Connect(function(input)
			if isPress(input) then
				dragging = true
				dragStart = input.Position
				startPos = mainFrame.Position
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and isMove(input) then
				local delta = input.Position - dragStart
				mainFrame.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if isPress(input) then
				dragging = false
			end
		end)
	end

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.RightControl then
			mainFrame.Visible = not mainFrame.Visible
		end
		if input.KeyCode == Enum.KeyCode.Escape then
			mainFrame.Visible = false
		end
	end)

	self.Hover = function(button, baseColor, hoverColor)
		baseColor = baseColor or Colors.Surface
		hoverColor = hoverColor or Colors.SurfaceHover
		button.MouseEnter:Connect(function()
			tween(button, 0.12, { BackgroundColor3 = hoverColor })
		end)
		button.MouseLeave:Connect(function()
			tween(button, 0.12, { BackgroundColor3 = baseColor })
		end)
	end

	return self
end

function Testy:GetPage(name)
	return self.Pages[name]
end

function Testy:CreateLabel(page, text)
	local pageInstance = type(page) == "string" and self.Pages[page] or page
	if not pageInstance then return end

	return create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Text = text or "",
		TextColor3 = Colors.Dim,
		TextSize = 13,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = pageInstance,
	})
end

function Testy:CreateButton(page, text, callback)
	local pageInstance = type(page) == "string" and self.Pages[page] or page
	if not pageInstance then return end

	local button = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		Text = text or "Button",
		TextColor3 = Colors.Text,
		TextSize = 13,
		FontFace = FontRegular,
		AutoButtonColor = false,
		Parent = pageInstance,
	})
	corner(4, button)
	self.Hover(button, Colors.Surface, Colors.SurfaceHover)

	button.MouseButton1Click:Connect(function()
		if callback then
			local ok, err = pcall(callback)
			if not ok then warn("[Testy] Button error: " .. tostring(err)) end
		end
	end)

	return button
end

function Testy:CreateToggle(page, label, default, callback)
	local pageInstance = type(page) == "string" and self.Pages[page] or page
	if not pageInstance then return end

	local state = default == true

	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		Active = true,
		Parent = pageInstance,
	})
	corner(4, row)

	create("TextLabel", {
		Size = UDim2.new(1, -60, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text = label or "Toggle",
		TextColor3 = Colors.Text,
		TextSize = 13,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})

	local pill = create("Frame", {
		Size = UDim2.fromOffset(36, 18),
		Position = UDim2.new(1, -46, 0.5, -9),
		BackgroundColor3 = state and Colors.On or Colors.Off,
		BorderSizePixel = 0,
		Parent = row,
	})
	corner(9, pill)

	local knob = create("Frame", {
		Size = UDim2.fromOffset(14, 14),
		Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Parent = pill,
	})
	corner(7, knob)

	local function render()
		tween(pill, 0.15, { BackgroundColor3 = state and Colors.On or Colors.Off })
		tween(knob, 0.15, { Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) })
	end

	row.InputBegan:Connect(function(input)
		if isPress(input) then
			state = not state
			render()
			if callback then
				local ok, err = pcall(callback, state)
				if not ok then warn("[Testy] Toggle error: " .. tostring(err)) end
			end
		end
	end)

	return {
		Set = function(_, value)
			state = value == true
			render()
			if callback then pcall(callback, state) end
		end,
		Get = function()
			return state
		end,
	}
end

function Testy:CreateSlider(page, label, minValue, maxValue, default, callback)
	local pageInstance = type(page) == "string" and self.Pages[page] or page
	if not pageInstance then return end

	minValue = minValue or 0
	maxValue = maxValue or 100
	local value = default or minValue

	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		Active = true,
		Parent = pageInstance,
	})
	corner(4, row)

	create("TextLabel", {
		Size = UDim2.new(1, -60, 0, 18),
		Position = UDim2.new(0, 10, 0, 4),
		BackgroundTransparency = 1,
		Text = label or "Slider",
		TextColor3 = Colors.Text,
		TextSize = 13,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})

	local valueLabel = create("TextLabel", {
		Size = UDim2.new(0, 50, 0, 18),
		Position = UDim2.new(1, -60, 0, 4),
		BackgroundTransparency = 1,
		Text = tostring(value),
		TextColor3 = Colors.Accent,
		TextSize = 13,
		FontFace = FontBold,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = row,
	})

	local track = create("Frame", {
		Size = UDim2.new(1, -20, 0, 6),
		Position = UDim2.new(0, 10, 1, -16),
		BackgroundColor3 = Colors.SurfaceHover,
		BorderSizePixel = 0,
		Parent = row,
	})
	corner(3, track)

	local fill = create("Frame", {
		Size = UDim2.new((value - minValue) / math.max(maxValue - minValue, 0.0001), 0, 1, 0),
		BackgroundColor3 = Colors.Accent,
		BorderSizePixel = 0,
		Parent = track,
	})
	corner(3, fill)

	local handle = create("Frame", {
		Size = UDim2.fromOffset(12, 12),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new((value - minValue) / math.max(maxValue - minValue, 0.0001), 0, 0.5, 0),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = track,
	})
	corner(6, handle)

	local hit = create("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 20, 0, 30),
		Position = UDim2.new(0, -10, 0.5, -15),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 3,
		Parent = track,
	})

	local dragging = false
	local function updateFromPosition(posX)
		local absPos = track.AbsolutePosition.X
		local absSize = track.AbsoluteSize.X
		if absSize <= 0 then return end
		local alpha = math.clamp((posX - absPos) / absSize, 0, 1)
		value = minValue + (maxValue - minValue) * alpha
		tween(fill, 0.08, { Size = UDim2.new(alpha, 0, 1, 0) })
		tween(handle, 0.08, { Position = UDim2.new(alpha, 0, 0.5, 0) })
		if value % 1 == 0 then
			valueLabel.Text = tostring(math.floor(value))
		else
			valueLabel.Text = string.format("%.2f", value)
		end
		if callback then pcall(callback, value) end
	end

	hit.InputBegan:Connect(function(input)
		if isPress(input) then
			dragging = true
			updateFromPosition(input.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and isMove(input) then
			updateFromPosition(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if isPress(input) then
			dragging = false
		end
	end)

	return {
		Set = function(_, newValue)
			value = math.clamp(newValue, minValue, maxValue)
			local alpha = (value - minValue) / math.max(maxValue - minValue, 0.0001)
			fill.Size = UDim2.new(alpha, 0, 1, 0)
			handle.Position = UDim2.new(alpha, 0, 0.5, 0)
			valueLabel.Text = tostring(value)
			if callback then pcall(callback, value) end
		end,
		Get = function()
			return value
		end,
	}
end

function Testy:CreateDropdown(page, label, options, default, callback)
	local pageInstance = type(page) == "string" and self.Pages[page] or page
	if not pageInstance then return end

	options = options or {}
	local selected = default or options[1]
	local expanded = false

	local holder = create("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Active = true,
		Parent = pageInstance,
	})
	corner(4, holder)

	create("TextLabel", {
		Size = UDim2.new(0.5, -14, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text = label or "Dropdown",
		TextColor3 = Colors.Text,
		TextSize = 13,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = holder,
	})

	local current = create("TextLabel", {
		Size = UDim2.new(0.4, -26, 1, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = tostring(selected),
		TextColor3 = Colors.Accent,
		TextSize = 13,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = holder,
	})

	local arrow = create("TextLabel", {
		Size = UDim2.fromOffset(18, 34),
		Position = UDim2.new(1, -24, 0, 0),
		BackgroundTransparency = 1,
		Text = "v",
		TextColor3 = Colors.Dim,
		TextSize = 12,
		FontFace = FontRegular,
		Parent = holder,
	})

	local list = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 0, 34),
		BackgroundColor3 = Colors.SurfaceHover,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 5,
		Parent = holder,
	})
	corner(4, list)
	create("UIListLayout", {
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, list)
	create("UIPadding", {
		PaddingTop = UDim.new(0, 3),
		PaddingBottom = UDim.new(0, 3),
		PaddingLeft = UDim.new(0, 3),
		PaddingRight = UDim.new(0, 3),
	}, list)

	local optionButtons = {}
	local function refresh()
		for option, button in pairs(optionButtons) do
			button.BackgroundColor3 = option == selected and Colors.Accent or Colors.Surface
			button.TextColor3 = option == selected and Colors.Text or Colors.Dim
		end
		current.Text = tostring(selected)
	end

	for index, option in ipairs(options) do
		local optionBtn = create("TextButton", {
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundColor3 = Colors.Surface,
			BorderSizePixel = 0,
			Text = "  " .. tostring(option),
			TextColor3 = Colors.Text,
			TextSize = 12,
			FontFace = FontRegular,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutoButtonColor = false,
			LayoutOrder = index,
			Parent = list,
		})
		corner(3, optionBtn)
		optionButtons[option] = optionBtn

		optionBtn.MouseButton1Click:Connect(function()
			selected = option
			refresh()
			expanded = false
			list.Size = UDim2.new(1, 0, 0, 0)
			holder.Size = UDim2.new(1, 0, 0, 34)
			arrow.Text = "v"
			if callback then pcall(callback, selected) end
		end)
	end
	refresh()

	local header = create("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 34),
		Text = "",
		ZIndex = 2,
		Parent = holder,
	})
	header.MouseButton1Click:Connect(function()
		expanded = not expanded
		if expanded then
			local listHeight = #options * 26 + 6
			list.Size = UDim2.new(1, 0, 0, listHeight)
			holder.Size = UDim2.new(1, 0, 0, 34 + listHeight)
			arrow.Text = "^"
		else
			list.Size = UDim2.new(1, 0, 0, 0)
			holder.Size = UDim2.new(1, 0, 0, 34)
			arrow.Text = "v"
		end
	end)

	return {
		Set = function(_, value)
			if optionButtons[value] then
				selected = value
				refresh()
				if callback then pcall(callback, value) end
			end
		end,
		Get = function()
			return selected
		end,
	}
end

function Testy:CreateInput(page, label, placeholder, default, callback)
	local pageInstance = type(page) == "string" and self.Pages[page] or page
	if not pageInstance then return end

	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		Active = true,
		Parent = pageInstance,
	})
	corner(4, row)

	create("TextLabel", {
		Size = UDim2.new(1, -20, 0, 18),
		Position = UDim2.new(0, 10, 0, 4),
		BackgroundTransparency = 1,
		Text = label or "Input",
		TextColor3 = Colors.Text,
		TextSize = 13,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})

	local box = create("TextBox", {
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 10, 1, -24),
		BackgroundColor3 = Colors.SurfaceHover,
		BorderSizePixel = 0,
		Text = default or "",
		PlaceholderText = placeholder or "type...",
		PlaceholderColor3 = Colors.Dim,
		TextColor3 = Colors.Text,
		TextSize = 12,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Parent = row,
	})
	corner(3, box)
	create("UIPadding", {
		PaddingLeft = UDim.new(0, 6),
		PaddingRight = UDim.new(0, 6),
	}, box)

	box.FocusLost:Connect(function(enterPressed)
		if callback then pcall(callback, box.Text, enterPressed) end
	end)

	return {
		Set = function(_, value)
			box.Text = tostring(value)
		end,
		Get = function()
			return box.Text
		end,
	}
end

function Testy:CreateKeybind(page, label, default, callback)
	local pageInstance = type(page) == "string" and self.Pages[page] or page
	if not pageInstance then return end

	local key = default or Enum.KeyCode.Unknown
	local listening = false

	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		Active = true,
		Parent = pageInstance,
	})
	corner(4, row)

	create("TextLabel", {
		Size = UDim2.new(0.6, -14, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text = label or "Keybind",
		TextColor3 = Colors.Text,
		TextSize = 13,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})

	local keyBtn = create("TextButton", {
		Size = UDim2.fromOffset(70, 22),
		Position = UDim2.new(1, -80, 0.5, -11),
		BackgroundColor3 = Colors.SurfaceHover,
		Text = key.Name,
		TextColor3 = Colors.Accent,
		TextSize = 12,
		FontFace = FontBold,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Parent = row,
	})
	corner(3, keyBtn)

	keyBtn.MouseButton1Click:Connect(function()
		listening = true
		keyBtn.Text = "..."
		keyBtn.TextColor3 = Colors.Yellow
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if listening then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				key = input.KeyCode
				keyBtn.Text = key.Name
				keyBtn.TextColor3 = Colors.Accent
				listening = false
			end
		elseif input.KeyCode == key and key ~= Enum.KeyCode.Unknown then
			if callback then pcall(callback, key) end
		end
	end)

	return {
		Set = function(_, newKey)
			key = newKey
			keyBtn.Text = newKey.Name
		end,
		Get = function()
			return key
		end,
	}
end

local NotifyHolder = create("Frame", {
	Name = "NotifyHolder",
	Size = UDim2.new(0, 280, 1, -20),
	Position = UDim2.new(1, -296, 0, 10),
	BackgroundTransparency = 1,
	Parent = PlayerGui,
})
create("UIListLayout", {
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
}, NotifyHolder)

function Testy:Notify(title, content, kind, duration)
	kind = kind or "info"
	duration = duration or 4

	local accent = Colors.Accent
	if kind == "success" then accent = Colors.Green end
	if kind == "warning" then accent = Colors.Yellow end
	if kind == "error" then accent = Colors.Red end

	local card = create("Frame", {
		Size = UDim2.new(1, 0, 0, 56),
		BackgroundColor3 = Colors.Surface,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = NotifyHolder,
	})
	corner(6, card)
	stroke(Colors.Line, 1, card)

	create("Frame", {
		Size = UDim2.new(0, 3, 1, -12),
		Position = UDim2.new(0, 5, 0, 6),
		BackgroundColor3 = accent,
		BorderSizePixel = 0,
		Parent = card,
	})

	local titleLabel = create("TextLabel", {
		Size = UDim2.new(1, -22, 0, 18),
		Position = UDim2.new(0, 14, 0, 6),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Colors.Text,
		TextSize = 13,
		FontFace = FontBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = card,
	})

	local contentLabel = create("TextLabel", {
		Size = UDim2.new(1, -22, 0, 26),
		Position = UDim2.new(0, 14, 0, 26),
		BackgroundTransparency = 1,
		Text = content,
		TextColor3 = Colors.Dim,
		TextSize = 12,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Parent = card,
	})

	card.Position = UDim2.new(0, 40, 0, 0)
	tween(card, 0.25, { BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0) })

	task.delay(duration, function()
		if not card.Parent then return end
		tween(card, 0.25, { BackgroundTransparency = 1, Position = UDim2.new(0, 40, 0, 0) })
		task.wait(0.3)
		card:Destroy()
	end)
end

return Testy
