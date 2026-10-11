local Testy = loadstring(game:HttpGet("https://raw.githubusercontent.com/WareSploit/testy/main/main.lua"))()

Testy:Attach("TestyGui")

Testy:Notify("Testy UI", "v1.0.0 loaded", "success", 3)

local main = Testy:GetPage("Main")
if main then
	Testy:CreateToggle(main, "Auto Enable", false, function(state)
		Testy.Flags.AutoEnable = state
	end)

	Testy:CreateSlider(main, "Volume", 0, 100, 50, function(value)
		Testy.Flags.Volume = value
	end)

	Testy:CreateDropdown(main, "Theme Preset", { "Dark", "Light", "System" }, "Dark", function(value)
		Testy.Flags.Theme = value
	end)

	Testy:CreateInput(main, "Username", "enter name...", "", function(text)
		Testy.Flags.Username = text
	end)

	Testy:CreateButton(main, "Save Config", function()
		Testy:Notify("Config", "Settings saved", "success", 3)
	end)
end

local player = Testy:GetPage("Player")
if player then
	Testy:CreateSlider(player, "Walk Speed", 16, 100, 16, function(value)
		local character = game.Players.LocalPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.WalkSpeed = value
			end
		end
	end)

	Testy:CreateSlider(player, "Jump Power", 50, 200, 50, function(value)
		local character = game.Players.LocalPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.JumpPower = value
			end
		end
	end)

	Testy:CreateKeybind(player, "Reset Key", Enum.KeyCode.R, function()
		Testy:Notify("Keybind", "R pressed", "info", 2)
	end)
end

local visual = Testy:GetPage("Visual")
if visual then
	Testy:CreateSlider(visual, "Field of View", 70, 120, 70, function(value)
		workspace.CurrentCamera.FieldOfView = value
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
end
