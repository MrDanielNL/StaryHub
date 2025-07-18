-- Load Luna Library
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

-- Create Window
local Window = Luna:CreateWindow({
	Name = "Luna Example Window",
	Subtitle = "v1.0",
	LogoID = "82795327169782",
	LoadingEnabled = true,
	LoadingTitle = "Luna Interface Suite",
	LoadingSubtitle = "by Nebula Softworks",
	ConfigSettings = {
		RootFolder = nil,
		ConfigFolder = "LunaExample"
	},
	KeySystem = false
})

-- Create Tab
local Tab = Window:CreateTab({
	Name = "Main Tab",
	Icon = "view_in_ar", -- Material icon example
	ImageSource = "Material",
	ShowTitle = true
})

-- Create a Section inside the Tab
Tab:CreateSection("Basic Controls")

-- Create a Button
local Button = Tab:CreateButton({
	Name = "Click Me",
	Description = "Prints a message in output",
	Callback = function()
		print("Button clicked!")
		Luna:Notification({
			Title = "Button Clicked",
			Icon = "check_circle",
			ImageSource = "Material",
			Content = "You clicked the button successfully!"
		})
	end
})

-- Create a Toggle
local Toggle = Tab:CreateToggle({
	Name = "Enable Feature",
	Description = "Toggle something on/off",
	CurrentValue = false,
	Callback = function(value)
		print("Toggle value:", value)
	end
}, "FeatureToggleFlag")

-- Create a Slider
local Slider = Tab:CreateSlider({
	Name = "Adjust Value",
	Range = {0, 100},
	Increment = 5,
	CurrentValue = 50,
	Callback = function(value)
		print("Slider value:", value)
	end
}, "SliderFlag")

-- Create a Dropdown
local Dropdown = Tab:CreateDropdown({
	Name = "Select Option",
	Description = "Choose an option",
	Options = {"Option 1", "Option 2", "Option 3"},
	CurrentOption = "Option 1",
	MultipleOptions = false,
	Callback = function(selected)
		print("Dropdown selected:", selected)
	end
}, "DropdownFlag")

-- Add Home Tab with some info and discord invite
Window:CreateHomeTab({
	SupportedExecutors = {"Synapse X", "Krnl", "Oxygen"}, 
	DiscordInvite = "NebulaSoftworks", -- just the code, no discord.gg/
	Icon = 1
})

-- Load saved config automatically
Luna:LoadAutoloadConfig()
