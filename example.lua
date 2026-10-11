local Testy = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Testy-Library/main/main.lua"))()

local main = Testy:GetPage("Main")

Testy:CreateLabel(main, "── General ──")

Testy:CreateToggle(main, "Enable Feature", false, function(state)
	Testy.Flags.EnableFeature = state
end)

Testy:CreateSlider(main, "Volume", 0, 100, 50, function(value)
	Testy.Flags.Volume = value
end)

Testy:CreateDropdown(main, "Theme", { "Dark", "Light", "System", "Midnight", "Nord", "Dracula" }, "Dark", function(value)
	Testy.Flags.Theme = value
end)

Testy:CreateInput(main, "Username", "enter name...", "", function(text)
	Testy.Flags.Username = text
end)

Testy:CreateKeybind(main, "Toggle Key", Enum.KeyCode.RightShift, function()
	Testy:Notify("Keybind", "RightShift pressed", "info", 2)
end)

local player = Testy:GetPage("Player")

Testy:CreateLabel(player, "── Movement ──")

Testy:CreateSlider(player, "Walk Speed", 16, 100, 16, function(value)
	local char = game.Players.LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = value end
	end
	Testy.Flags.WalkSpeed = value
end)

Testy:CreateSlider(player, "Jump Power", 50, 200, 50, function(value)
	local char = game.Players.LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.JumpPower = value end
	end
	Testy.Flags.JumpPower = value
end)

Testy:CreateToggle(player, "Infinite Jump", false, function(state)
	Testy.Flags.InfiniteJump = state
	getgenv().TestyInfJump = state
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
	if getgenv().TestyInfJump then
		local char = game.Players.LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end
	end
end)

Testy:CreateKeybind(player, "Reset Key", Enum.KeyCode.R, function()
	Testy:Notify("Player", "R pressed", "info", 2)
end)

local settings = Testy:GetPage("Settings")

Testy:CreateLabel(settings, "── Configuration ──")
Testy:CreateConfig(settings)

Testy:CreateLabel(settings, "── Interface ──")

Testy:CreateSlider(settings, "UI Scale", 80, 120, 100, function(value)
	local scale = value / 100
	Testy.MainFrame.Size = UDim2.fromOffset(334 * scale, 250 * scale)
	Testy.Flags.UIScale = value
end)

Testy:CreateToggle(settings, "Show Version", true, function(state)
	local opener = Testy.Gui:FindFirstChild("TabOpener")
	if opener then
		local version = opener:FindFirstChild("Version")
		if version then version.Visible = state end
	end
	Testy.Flags.ShowVersion = state
end)

Testy:CreateToggle(settings, "Mobile Mode", false, function(state)
	Testy.MainFrame.Size = state and UDim2.fromOffset(300, 400) or UDim2.fromOffset(334, 250)
	Testy.Flags.MobileMode = state
end)

Testy:CreateKeybind(settings, "Panic Key", Enum.KeyCode.Delete, function()
	Testy:Notify("Panic", "All functions disabled", "warning", 2)
end)

Testy:Notify("Example", "All widgets loaded", "success", 3)
