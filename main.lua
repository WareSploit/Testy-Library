local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local HAS_FILE = (typeof(writefile) == "function") and (typeof(readfile) == "function")

local function getGui()
	local ok, cg = pcall(function() return game:GetService("CoreGui") end)
	if ok and cg then return cg end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local Colors = {
	BG = Color3.fromRGB(36, 36, 36),
	Bar = Color3.fromRGB(31, 31, 31),
	Surface = Color3.fromRGB(43, 43, 43),
	SurfaceHover = Color3.fromRGB(53, 53, 53),
	ListBG = Color3.fromRGB(28, 28, 28),
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

if getgenv and getgenv().TestyGUI then
	pcall(function() getgenv().TestyGUI:Destroy() end)
end

local ScreenGui = create("ScreenGui", {
	Name = "TestyGui",
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = getGui(),
})

if getgenv then
	getgenv().TestyGUI = ScreenGui
end

local MainFrame = create("Frame", {
	Name = "MainFrame",
	Size = UDim2.fromOffset(334, 250),
	Position = UDim2.new(0.5, -167, 0.5, -125),
	BackgroundColor3 = Colors.BG,
	BorderSizePixel = 0,
	Active = true,
	Visible = false,
	ClipsDescendants = true,
	ZIndex = 50,
	Parent = ScreenGui,
})
corner(6, MainFrame)
stroke(Colors.Border, 2, MainFrame)

local UiTitle = create("TextLabel", {
	Name = "UiTitle",
	Size = UDim2.new(1, 0, 0, 30),
	Position = UDim2.new(0, 0, 0, 0),
	BackgroundTransparency = 1,
	Text = "Testy-UI",
	TextColor3 = Colors.Text,
	TextSize = 20,
	FontFace = FontBold,
	TextXAlignment = Enum.TextXAlignment.Center,
	ZIndex = 60,
	Parent = MainFrame,
})

create("ImageLabel", {
	Name = "SVG",
	Size = UDim2.fromOffset(20, 20),
	Position = UDim2.new(0, 5, 0, 5),
	BackgroundTransparency = 1,
	Image = "rbxassetid://1072321290",
	ImageColor3 = Colors.Accent,
	ZIndex = 61,
	Parent = MainFrame,
})

local CloseBtn = create("TextButton", {
	Name = "Close",
	Size = UDim2.fromOffset(24, 24),
	Position = UDim2.new(1, -30, 0, 3),
	BackgroundColor3 = Colors.Bar,
	BackgroundTransparency = 0.3,
	Text = "X",
	TextColor3 = Colors.Text,
	TextSize = 16,
	FontFace = FontBold,
	AutoButtonColor = false,
	BorderSizePixel = 0,
	ZIndex = 61,
	Parent = MainFrame,
})
corner(4, CloseBtn)

local TopBar = create("Frame", {
	Name = "TopBar",
	Size = UDim2.new(1, 0, 0, 29),
	Position = UDim2.new(0, 0, 0, 30),
	BackgroundColor3 = Colors.BG,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	ZIndex = 55,
	Parent = MainFrame,
})

create("Frame", {
	Name = "Line",
	BackgroundColor3 = Colors.Line,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 1),
	Position = UDim2.new(0, 0, 1, -1),
	ZIndex = 56,
	Parent = TopBar,
})

local Content = create("Frame", {
	Name = "Content",
	Size = UDim2.new(1, 0, 1, -59),
	Position = UDim2.new(0, 0, 0, 59),
	BackgroundColor3 = Colors.BG,
	BorderSizePixel = 0,
	ZIndex = 54,
	Parent = MainFrame,
})

local TabOpener = create("Frame", {
	Name = "TabOpener",
	Size = UDim2.fromOffset(349, 41),
	Position = UDim2.new(0.5, -175, 0, 16),
	BackgroundColor3 = Colors.BG,
	BackgroundTransparency = 0.1,
	BorderSizePixel = 0,
	Parent = ScreenGui,
})
stroke(Colors.Border, 2, TabOpener)

local OpenBtn = create("ImageButton", {
	Name = "OpenButton",
	Size = UDim2.fromOffset(41, 41),
	Position = UDim2.new(0, 0, 0, 0),
	BackgroundTransparency = 1,
	Image = "rbxassetid://1424953189",
	ScaleType = Enum.ScaleType.Fit,
	AutoButtonColor = false,
	BorderSizePixel = 0,
	ZIndex = 100,
	Parent = TabOpener,
})

create("TextLabel", {
	Name = "Version",
	Size = UDim2.new(0, 220, 0, 27),
	Position = UDim2.new(0, 60, 0, 7),
	BackgroundTransparency = 1,
	Text = "Testy-UI v1.1.0",
	TextColor3 = Colors.Text,
	TextSize = 18,
	FontFace = FontRegular,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = TabOpener,
})

local Testy = {}
Testy.Colors = Colors
Testy.Font = FontRegular
Testy.FontBold = FontBold
Testy.Pages = {}
Testy.TabButtons = {}
Testy.Flags = {}
Testy.Gui = ScreenGui
Testy.MainFrame = MainFrame
Testy.TopBar = TopBar
Testy.Content = Content
Testy.HasFile = HAS_FILE

local ActiveTab = nil
local TabOrder = 0
local TAB_WIDTH = 111

local function makePage(name)
	local page = create("ScrollingFrame", {
		Name = "Page_" .. name,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Colors.Line,
		Visible = false,
		ZIndex = 55,
		Parent = Content,
	})
	create("UIListLayout", {
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, page)
	create("UIPadding", {
		PaddingTop = UDim.new(0, 5),
		PaddingBottom = UDim.new(0, 5),
		PaddingLeft = UDim.new(0, 5),
		PaddingRight = UDim.new(0, 5),
	}, page)
	Testy.Pages[name] = page
	return page
end

local function switchTab(name)
	local tabButton = Testy.TabButtons[name]
	local page = Testy.Pages[name]
	if not tabButton or not page then return end

	if ActiveTab then
		tween(ActiveTab, 0.15, { BackgroundColor3 = Colors.Bar })
	end
	for pageName, pageInstance in pairs(Testy.Pages) do
		pageInstance.Visible = (pageName == name)
	end
	ActiveTab = tabButton
	tween(tabButton, 0.15, { BackgroundColor3 = Colors.SurfaceHover })
end

function Testy:RegisterTab(name)
	TabOrder = TabOrder + 1
	local order = TabOrder
	local xPos = (order - 1) * TAB_WIDTH

	local btn = create("TextButton", {
		Name = "Tab_" .. name,
		Size = UDim2.fromOffset(TAB_WIDTH, 29),
		Position = UDim2.fromOffset(xPos, 0),
		BackgroundColor3 = Colors.Bar,
		BorderSizePixel = 0,
		Text = name,
		TextColor3 = Colors.Text,
		TextSize = 14,
		FontFace = FontRegular,
		AutoButtonColor = false,
		ZIndex = 57,
		Parent = TopBar,
	})

	Testy.TabButtons[name] = btn
	makePage(name)

	btn.MouseEnter:Connect(function()
		if ActiveTab ~= btn then
			tween(btn, 0.12, { BackgroundColor3 = Colors.Surface })
		end
	end)
	btn.MouseLeave:Connect(function()
		if ActiveTab ~= btn then
			tween(btn, 0.12, { BackgroundColor3 = Colors.Bar })
		end
	end)
	btn.MouseButton1Click:Connect(function()
		switchTab(name)
	end)

	if not ActiveTab then
		switchTab(name)
	end

	return btn
end

OpenBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

CloseBtn.MouseEnter:Connect(function()
	tween(CloseBtn, 0.12, { BackgroundColor3 = Colors.Red, BackgroundTransparency = 0 })
end)
CloseBtn.MouseLeave:Connect(function()
	tween(CloseBtn, 0.12, { BackgroundColor3 = Colors.Bar, BackgroundTransparency = 0.3 })
end)
CloseBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

local dragging, dragStart, startPos
UiTitle.InputBegan:Connect(function(input)
	if isPress(input) then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and isMove(input) then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if isPress(input) then dragging = false end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		MainFrame.Visible = not MainFrame.Visible
	end
	if input.KeyCode == Enum.KeyCode.Escape then
		MainFrame.Visible = false
	end
end)

function Testy:GetPage(name)
	return self.Pages[name]
end

function Testy:Hover(button, baseColor, hoverColor)
	baseColor = baseColor or Colors.Surface
	hoverColor = hoverColor or Colors.SurfaceHover
	button.MouseEnter:Connect(function()
		tween(button, 0.12, { BackgroundColor3 = hoverColor })
	end)
	button.MouseLeave:Connect(function()
		tween(button, 0.12, { BackgroundColor3 = baseColor })
	end)
end

function Testy:CreateLabel(page, text)
	local p = type(page) == "string" and self.Pages[page] or page
	if not p then return end
	return create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Text = text or "",
		TextColor3 = Colors.Dim,
		TextSize = 13,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = p,
	})
end

function Testy:CreateButton(page, text, callback)
	local p = type(page) == "string" and self.Pages[page] or page
	if not p then return end

	local button = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		Text = text or "Button",
		TextColor3 = Colors.Text,
		TextSize = 13,
		FontFace = FontRegular,
		AutoButtonColor = false,
		Parent = p,
	})
	corner(4, button)
	self:Hover(button, Colors.Surface, Colors.SurfaceHover)

	button.MouseButton1Click:Connect(function()
		if callback then
			local ok, err = pcall(callback)
			if not ok then warn("[Testy] Button error: " .. tostring(err)) end
		end
	end)
	return button
end

function Testy:CreateToggle(page, label, default, callback)
	local p = type(page) == "string" and self.Pages[page] or page
	if not p then return end

	local state = default == true
	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		Active = true,
		Parent = p,
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
			if callback then pcall(callback, state) end
		end
	end)

	return {
		Set = function(_, value) state = value == true; render(); if callback then pcall(callback, state) end end,
		Get = function() return state end,
	}
end

function Testy:CreateSlider(page, label, minValue, maxValue, default, callback)
	local p = type(page) == "string" and self.Pages[page] or page
	if not p then return end

	minValue = minValue or 0
	maxValue = maxValue or 100
	local value = default or minValue

	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		Active = true,
		Parent = p,
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
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		handle.Position = UDim2.new(alpha, 0, 0.5, 0)
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
		if isPress(input) then dragging = false end
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
		Get = function() return value end,
	}
end

function Testy:CreateDropdown(page, label, options, default, callback)
	local p = type(page) == "string" and self.Pages[page] or page
	if not p then return end

	options = options or {}
	local selected = default or options[1]
	local expanded = false

	local holder = create("Frame", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		ClipsDescendants = false,
		Active = true,
		ZIndex = 10,
		Parent = p,
	})
	corner(4, holder)

	local header = create("TextButton", {
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 36),
		Position = UDim2.new(0, 0, 0, 0),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 11,
		Parent = holder,
	})
	corner(4, header)

	create("TextLabel", {
		Size = UDim2.new(0.5, -14, 1, 0),
		Position = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Text = label or "Dropdown",
		TextColor3 = Colors.Text,
		TextSize = 13,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 12,
		Parent = header,
	})

	local current = create("TextLabel", {
		Size = UDim2.new(0.4, -30, 1, 0),
		Position = UDim2.new(0.5, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = tostring(selected),
		TextColor3 = Colors.Accent,
		TextSize = 13,
		FontFace = FontRegular,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 12,
		Parent = header,
	})

	local arrow = create("TextLabel", {
		Size = UDim2.fromOffset(18, 36),
		Position = UDim2.new(1, -26, 0, 0),
		BackgroundTransparency = 1,
		Text = "v",
		TextColor3 = Colors.Dim,
		TextSize = 12,
		FontFace = FontRegular,
		ZIndex = 12,
		Parent = header,
	})

	header.MouseEnter:Connect(function()
		if not expanded then
			tween(header, 0.12, { BackgroundColor3 = Colors.SurfaceHover })
		end
	end)
	header.MouseLeave:Connect(function()
		if not expanded then
			tween(header, 0.12, { BackgroundColor3 = Colors.Surface })
		end
	end)

	local list = create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 0, 38),
		BackgroundColor3 = Colors.ListBG,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Colors.Line,
		Visible = false,
		ZIndex = 15,
		Parent = holder,
	})
	corner(4, list)
	stroke(Colors.Line, 1, list)
	create("UIListLayout", {
		Padding = UDim.new(0, 1),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, list)
	create("UIPadding", {
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 4),
		PaddingLeft = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 4),
	}, list)

	local optionButtons = {}
	local function refresh()
		for option, button in pairs(optionButtons) do
			if option == selected then
				button.BackgroundColor3 = Colors.Accent
				button.TextColor3 = Colors.Text
			else
				button.BackgroundColor3 = Colors.ListBG
				button.TextColor3 = Colors.Dim
			end
		end
		current.Text = tostring(selected)
	end

	for index, option in ipairs(options) do
		local optionBtn = create("TextButton", {
			Size = UDim2.new(1, 0, 0, 26),
			BackgroundColor3 = Colors.ListBG,
			BorderSizePixel = 0,
			Text = "  " .. tostring(option),
			TextColor3 = Colors.Dim,
			TextSize = 12,
			FontFace = FontRegular,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutoButtonColor = false,
			LayoutOrder = index,
			ZIndex = 16,
			Parent = list,
		})
		corner(3, optionBtn)
		optionButtons[option] = optionBtn

		optionBtn.MouseEnter:Connect(function()
			if option ~= selected then
				tween(optionBtn, 0.1, { BackgroundColor3 = Colors.SurfaceHover, TextColor3 = Colors.Text })
			end
		end)
		optionBtn.MouseLeave:Connect(function()
			if option ~= selected then
				tween(optionBtn, 0.1, { BackgroundColor3 = Colors.ListBG, TextColor3 = Colors.Dim })
			end
		end)
		optionBtn.MouseButton1Click:Connect(function()
			selected = option
			refresh()
			expanded = false
			list.Visible = false
			list.Size = UDim2.new(1, 0, 0, 0)
			arrow.Text = "v"
			tween(header, 0.12, { BackgroundColor3 = Colors.Surface })
			if callback then pcall(callback, selected) end
		end)
	end
	refresh()

	header.MouseButton1Click:Connect(function()
		expanded = not expanded
		if expanded then
			local listHeight = math.min(#options * 27 + 8, 150)
			list.Size = UDim2.new(1, 0, 0, listHeight)
			list.Visible = true
			arrow.Text = "^"
			tween(header, 0.12, { BackgroundColor3 = Colors.SurfaceHover })
		else
			list.Visible = false
			list.Size = UDim2.new(1, 0, 0, 0)
			arrow.Text = "v"
			tween(header, 0.12, { BackgroundColor3 = Colors.Surface })
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
		Get = function() return selected end,
	}
end

function Testy:CreateInput(page, label, placeholder, default, callback)
	local p = type(page) == "string" and self.Pages[page] or page
	if not p then return end

	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		Active = true,
		Parent = p,
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
		Set = function(_, value) box.Text = tostring(value) end,
		Get = function() return box.Text end,
	}
end

function Testy:CreateKeybind(page, label, default, callback)
	local p = type(page) == "string" and self.Pages[page] or page
	if not p then return end

	local key = default or Enum.KeyCode.Unknown
	local listening = false

	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = Colors.Surface,
		BorderSizePixel = 0,
		Active = true,
		Parent = p,
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
		Set = function(_, newKey) key = newKey; keyBtn.Text = newKey.Name end,
		Get = function() return key end,
	}
end

local NotifyHolder = create("Frame", {
	Name = "NotifyHolder",
	Size = UDim2.new(0, 280, 1, -20),
	Position = UDim2.new(1, -296, 0, 10),
	BackgroundTransparency = 1,
	Parent = ScreenGui,
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

	create("TextLabel", {
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

	create("TextLabel", {
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
		pcall(function() card:Destroy() end)
	end)
end

function Testy:SaveConfig(filename)
	filename = filename or "testy_config.json"
	if not HAS_FILE then
		self:Notify("Config", "Executor has no writefile", "error", 3)
		return false
	end
	local data = {}
	for k, v in pairs(self.Flags) do
		data[k] = v
	end
	local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
	if not ok then
		self:Notify("Config", "Encode failed", "error", 3)
		return false
	end
	local wrote = pcall(function() writefile(filename, encoded) end)
	if wrote then
		self:Notify("Config", "Saved to " .. filename, "success", 3)
		return true
	end
	self:Notify("Config", "Write failed", "error", 3)
	return false
end

function Testy:LoadConfig(filename)
	filename = filename or "testy_config.json"
	if not HAS_FILE then
		self:Notify("Config", "Executor has no readfile", "error", 3)
		return false
	end
	local exists = pcall(function() return isfile(filename) end)
	if not exists or not isfile(filename) then
		self:Notify("Config", "File not found", "warning", 3)
		return false
	end
	local ok, contents = pcall(function() return readfile(filename) end)
	if not ok or not contents then
		self:Notify("Config", "Read failed", "error", 3)
		return false
	end
	local ok2, decoded = pcall(function() return HttpService:JSONDecode(contents) end)
	if not ok2 then
		self:Notify("Config", "Decode failed", "error", 3)
		return false
	end
	for k, v in pairs(decoded) do
		self.Flags[k] = v
	end
	self:Notify("Config", "Loaded from " .. filename, "success", 3)
	return true
end

function Testy:CreateConfig(page, configName)
	local p = type(page) == "string" and self.Pages[page] or page
	if not p then return end

	configName = configName or "testy_config.json"

	self:CreateInput(p, "Config file", "testy_config.json", configName, function(text)
		if text and text ~= "" then
			configName = text
		end
	end)

	self:CreateButton(p, "Save Config", function()
		self:SaveConfig(configName)
	end)

	self:CreateButton(p, "Load Config", function()
		self:LoadConfig(configName)
	end)

	return {
		SetName = function(name) configName = name end,
		GetName = function() return configName end,
	}
end

Testy:RegisterTab("Main")
Testy:RegisterTab("Player")
Testy:RegisterTab("Settings")

MainFrame.Visible = true

task.delay(0.3, function()
	Testy:Notify("Testy UI", "v1.1.0 loaded - RCTRL to toggle", "success", 4)
end)

return Testy
