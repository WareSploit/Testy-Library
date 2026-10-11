local Testy = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/Testy-Library/main/main.lua"))()

local main = Testy:GetPage("Main")
Testy:CreateToggle(main, "Enable Feature", false, function(state)
	Testy.Flags.EnableFeature = state
end)
Testy:CreateSlider(main, "Volume", 0, 100, 50, function(value)
	Testy.Flags.Volume = value
end)
Testy:CreateDropdown(main, "Theme", { "Dark", "Light", "System" }, "Dark", function(value)
	Testy.Flags.Theme = value
end)
Testy:CreateInput(main, "Username", "enter name...", "", function(text)
	Testy.Flags.Username = text
end)
Testy:CreateButton(main, "Save Config", function()
	Testy:Notify("Config", "Saved", "success", 2)
end)

local player = Testy:GetPage("Player")
Testy:CreateSlider(player, "Walk Speed", 16, 100, 16, function(value)
	local char = game.Players.LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = value end
	end
end)
Testy:CreateSlider(player, "Jump Power", 50, 200, 50, function(value)
	local char = game.Players.LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.JumpPower = value end
	end
end)
Testy:CreateKeybind(player, "Reset Key", Enum.KeyCode.R, function()
	Testy:Notify("Keybind", "R pressed", "info", 2)
end)

local visual = Testy:GetPage("Visual")
Testy:CreateSlider(visual, "Field of View", 70, 120, 70, function(value)
	if workspace.CurrentCamera then
		workspace.CurrentCamera.FieldOfView = value
	end
end)
Testy:CreateToggle(visual, "Brightness Boost", false, function(state)
	local lighting = game:GetService("Lighting")
	if state then
		lighting.Brightness = 3
		lighting.ClockTime = 12
	else
		lighting.Brightness = 2
	end
end)
