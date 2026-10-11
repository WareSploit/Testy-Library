# Testy UI

Lightweight Roblox UI library that attaches logic to a pre-built GUI inside StarterGui. Design stays as authored in Studio. The library only wires up interactions.

## Features

- Attach to any ScreenGui by name
- Automatic topbar tab switching
- Draggable window from title label
- Open and close via button or hotkey
- Hover animations on all interactive elements
- Notification system with four severity types
- Mobile and PC compatible
- No GUI rebuild, no re-parenting, no overwriting

## Repository structure

    testy/
    ├── main.lua
    ├── example.lua
    └── README.md

## Requirements

A ScreenGui named `TestyGui` inside StarterGui with the following hierarchy:

    TestyGui
    ├── MainFrame
    │   ├── Close          (TextButton)
    │   ├── UiTitle        (TextLabel, used as drag handle)
    │   ├── TopBar
    │   │   ├── Tab_Main   (TextButton)
    │   │   ├── Tab_Player (TextButton)
    │   │   └── Tab_Visual (TextButton)
    │   └── Content
    │       ├── Page_Main   (ScrollingFrame)
    │       ├── Page_Player (ScrollingFrame)
    │       └── Page_Visual (ScrollingFrame)
    └── TabOpener
        └── OpenButton     (ImageButton)

Tab and page names must match: `Tab_X` pairs with `Page_X`.

## Installation

Direct load:

    local Testy = loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/testy/main/main.lua"))()

Studio LocalScript:

    local Testy = require(game.ReplicatedStorage.Testy)

## Usage

Attach to the existing GUI:

    Testy:Attach("TestyGui")

Get a page reference:

    local main = Testy:GetPage("Main")

## API

### Testy:Attach(guiName)

Binds interactions to a ScreenGui. Returns the library table or nil if the GUI is missing. Default name is `TestyGui`.

### Testy:GetPage(name)

Returns the ScrollingFrame for a given tab name. Accepts `Main`, `Player`, `Visual`, or any tab you add.

### Testy:CreateLabel(page, text)

Adds a static label. Returns the TextLabel.

### Testy:CreateButton(page, text, callback)

Adds a clickable button with hover animation. Callback fires on click.

### Testy:CreateToggle(page, label, default, callback)

Adds a pill toggle. Callback receives `state` (boolean).

    Testy:CreateToggle(main, "Auto Enable", false, function(state)
        print(state)
    end)

### Testy:CreateSlider(page, label, min, max, default, callback)

Adds a slider with drag handle. Callback receives `value` (number).

    Testy:CreateSlider(main, "Volume", 0, 100, 50, function(value)
        print(value)
    end)

### Testy:CreateDropdown(page, label, options, default, callback)

Adds a dropdown list. Callback receives the selected option.

    Testy:CreateDropdown(main, "Mode", { "A", "B", "C" }, "A", function(value)
        print(value)
    end)

### Testy:CreateInput(page, label, placeholder, default, callback)

Adds a text input field. Callback fires on Enter or focus loss.

    Testy:CreateInput(main, "Nickname", "enter name...", "", function(text)
        print(text)
    end)

### Testy:CreateKeybind(page, label, default, callback)

Adds a keybind. Click the button, press a key to rebind. Callback fires when the key is pressed outside listening mode.

    Testy:CreateKeybind(main, "Toggle", Enum.KeyCode.T, function(key)
        print(key.Name)
    end)

### Testy:Notify(title, content, kind, duration)

Shows a notification in the bottom-right corner.

    Testy:Notify("Saved", "Config written", "success", 3)

Kinds: `info`, `success`, `warning`, `error`. Duration in seconds. Default 4.

### Testy.Flags

Shared table for storing values from callbacks.

    Testy.Flags.AutoEnable = true

### Testy.Colors

Color palette used by created widgets. Edit before creating widgets to retheme.

    Testy.Colors.Accent = Color3.fromRGB(255, 100, 200)

## Widget return values

Every widget except Label returns a table:

    local toggle = Testy:CreateToggle(main, "Example", false, callback)
    toggle:Set(true)
    toggle:Get()

Sliders, dropdowns, inputs and keybinds follow the same pattern.

## Hotkeys

- RightControl: toggle window visibility
- Escape: hide window

## Custom tabs

Add a new TextButton named `Tab_Inventory` inside TopBar and a ScrollingFrame named `Page_Inventory` inside Content. The library detects and wires them automatically.

## License

MIT
