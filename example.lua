local Testy = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Testy-Library/main/main.lua"))()

local main = Testy:GetPage("Main")
Testy:CreateToggle(main, "Enable Feature", false, function(state)
	Testy.Flags.EnableFeature = state
end)
Testy:CreateSlider(main, "Volume", 0, 100, 50, function(value)
	Testy.Flags.Volume = value
end)
Testy:CreateDropdown(main, "Theme", { "Dark", "Light", "System", "Midnight", "Nord", "Dracula", "Solar" }, "Dark", function(value)
	Testy.Flags.Theme = value
end)
Testy:CreateInput(main, "Username", "enter name...", "", function(text)
	Testy.Flags.Username = text
end)

local player = Testy:GetPage("Player")
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
Testy:CreateKeybind(player, "Reset Key", Enum.KeyCode.R, function()
	Testy:Notify("Keybind", "R pressed", "info", 2)
end)

local settings = Testy:GetPage("Settings")
Testy:CreateLabel(settings, "── Configuration ──")
Testy:CreateConfig(settings)
Testy:CreateLabel(settings, "── Interface ──")
Testy:CreateSlider(settings, "UI Scale", 80, 120, 100, function(value)
	local scale = value / 100
	Testy.MainFrame.Size = UDim2.fromOffset(334 * scale, 250 * scale)
end)
Testy:CreateToggle(settings, "Show Version", true, function(state)
	local tabOpener = Testy.Gui:FindFirstChild("TabOpener")
	if tabOpener then
		local version = tabOpener:FindFirstChild("Version")
		if version then version.Visible = state end
	end
end)
Testy:CreateKeybind(settings, "Panic Key", Enum.KeyCode.Delete, function()
	Testy:Notify("Panic", "All functions disabled", "warning", 2)
end)
