if getgenv().ObsidianExampleLibrary then
    pcall(function()
        getgenv().ObsidianExampleLibrary:Unload()
    end)
    getgenv().ObsidianExampleLibrary = nil
end

local libraryUrl = "https://raw.githubusercontent.com/D3f4ultscript/Cryptic-Scripts/refs/heads/main/Obsidian_UI/Obsidian_UI.lua"

local success, Library = pcall(function()
    return loadstring(game:HttpGet(libraryUrl))()
end)

if not success or not Library then
    return
end

getgenv().ObsidianExampleLibrary = Library

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "Obsidian Full Showcase",
    Footer = ".gg/XDpsSW7Ybs",
    Icon = 120217226033572,
    NotifySide = "Right",
    Center = true,
    AutoShow = true,
    ToggleKeybind = Enum.KeyCode.RightControl,
    Folder = "ObsidianShowcase",
    ConfigIgnoreIndexes = { "MenuKeybind" },
})

local Tabs = {
    Main = Window:AddTab("Main", "layout-grid"),
    Elements = Window:AddTab("Elements", "component"),
    Advanced = Window:AddTab("Advanced", "settings-2"),
    Visuals = Window:AddTab("Visuals", "image"),
    Key = Window:AddKeyTab("Key System"),
    Utility = Window:AddTab("Utility", "wrench"),
}

local Toggles = Library.Toggles
local Options = Library.Options

local function buildMainTab(Tab)
    local LeftGroupBox = Tab:AddGroupbox({
        Side = "Left",
        Name = "Labels & Buttons",
        Description = "Basic display and interaction elements",
        IconName = "type",
    })

    LeftGroupBox:AddLabel("This is a simple label")
    LeftGroupBox:AddLabel({
        Text = "This is a wrapped label demonstrating longer text content that spans multiple lines",
        DoesWrap = true,
    })

    LeftGroupBox:AddDivider("Buttons")

    local MainButton = LeftGroupBox:AddButton({
        Text = "Click Me",
        Func = function()
            Library:Notify("Button clicked!", 3)
        end,
        Tooltip = "A simple button",
    })

    MainButton:AddButton({
        Text = "Nested Action",
        Func = function()
            Library:Notify("Nested button clicked!", 3)
        end,
    })

    MainButton:AddKeyPicker("MainButtonKeybind", {
        Text = "Main Button Keybind",
        Default = "F",
        Mode = "Press",
    })

    LeftGroupBox:AddButton({
        Text = "Risky Action",
        Risky = true,
        Func = function()
            Library:Notify("Risky action executed", 3)
        end,
    })

    LeftGroupBox:AddButton({
        Text = "Confirm to Reset",
        DoubleClick = true,
        Func = function()
            Library:Notify("Reset confirmed", 3)
        end,
    })

    LeftGroupBox:AddButton({
        Text = "Disabled Button",
        Disabled = true,
        DisabledTooltip = "This button is disabled",
        Func = function() end,
    })

    local RightGroupBox = Tab:AddGroupbox({
        Side = "Right",
        Name = "Toggles & Checkboxes",
        IconName = "toggle-left",
    })

    local MasterToggle = RightGroupBox:AddToggle("MasterToggle", {
        Text = "Enable Master Feature",
        Default = false,
        Tooltip = "Enables the main feature",
        Callback = function(value) end,
    })

    MasterToggle:AddKeyPicker("MasterToggleKeybind", {
        Text = "Master Toggle Keybind",
        Default = "V",
        Mode = "Toggle",
        SyncToggleState = true,
    })

    MasterToggle:AddColorPicker("MasterToggleColor", {
        Default = Color3.fromRGB(255, 0, 0),
        Title = "Feature Color",
        Transparency = 0,
    })

    RightGroupBox:AddCheckbox("ExampleCheckbox", {
        Text = "Enable Checkbox Option",
        Default = false,
        Tooltip = "A standalone checkbox",
        Callback = function(value) end,
    })

    Toggles.MasterToggle:OnChanged(function(state) end)

    Toggles.MasterToggle:SetValue(false)
end

local function buildElementsTab(Tab)
    local LeftGroupBox = Tab:AddGroupbox({
        Side = "Left",
        Name = "Inputs & Sliders",
        IconName = "sliders-horizontal",
    })

    LeftGroupBox:AddInput("PlayerNameInput", {
        Text = "Player Name",
        Default = "",
        Numeric = false,
        Finished = true,
        ClearTextOnFocus = false,
        Placeholder = "Enter a name",
        MaxLength = 20,
        Callback = function(value) end,
    })

    LeftGroupBox:AddInput("AmountInput", {
        Text = "Amount",
        Default = "0",
        Numeric = true,
        Placeholder = "0",
        Callback = function(value) end,
    })

    LeftGroupBox:AddSlider("SpeedSlider", {
        Text = "Speed",
        Default = 16,
        Min = 0,
        Max = 200,
        Rounding = 0,
        Suffix = " studs",
        Callback = function(value) end,
    })

    LeftGroupBox:AddSlider("VolumeSlider", {
        Text = "Volume",
        Default = 50,
        Min = 0,
        Max = 100,
        Rounding = 1,
        Compact = true,
        Suffix = "%",
    })

    LeftGroupBox:AddSlider("CustomDisplaySlider", {
        Text = "Custom display slider",
        Default = 0,
        Min = 0,
        Max = 5,
        Rounding = 0,
        FormatDisplayValue = function(slider, value)
            if value == slider.Max then return "Everything" end
            if value == slider.Min then return "Nothing" end
        end,
    })

    local RightGroupBox = Tab:AddGroupbox({
        Side = "Right",
        Name = "Dropdowns & Keybinds",
        IconName = "chevrons-up-down",
    })

    RightGroupBox:AddDropdown("WeaponDropdown", {
        Text = "Select Weapon",
        Values = { "Sword", "Bow", "Staff", "Dagger" },
        Default = 1,
        Multi = false,
        Callback = function(value) end,
    })

    RightGroupBox:AddDropdown("TargetsDropdown", {
        Text = "Select Targets",
        Values = { "Head", "Torso", "Legs" },
        Default = { "Head" },
        Multi = true,
        AllowNull = true,
        Searchable = true,
        SelectAllButtons = true,
        Callback = function(values) end,
    })

    Options.TargetsDropdown:SetValue({
        Head = true,
        Torso = true,
    })

    RightGroupBox:AddDropdown("PlayerDropdown", {
        Text = "Select Player",
        SpecialType = "Player",
        Callback = function(value) end,
    })

    RightGroupBox:AddDropdown("TeamDropdown", {
        Text = "Select Team",
        SpecialType = "Team",
        Callback = function(value) end,
    })

    RightGroupBox:AddDivider()

    local KeybindLabel = RightGroupBox:AddLabel("Standalone Keybind")
    local StandaloneKeybind = KeybindLabel:AddKeyPicker("StandaloneKeybind", {
        Text = "Fire Action",
        Default = "G",
        Mode = "Hold",
        Callback = function() end,
    })

    local PressKeybindLabel = RightGroupBox:AddLabel("Press Keybind")
    PressKeybindLabel:AddKeyPicker("PressKeybind", {
        Text = "Increase Number",
        Default = "X",
        Mode = "Press",
        WaitForCallback = false,
        Callback = function() end,
    })

    task.spawn(function()
        while task.wait(1) do
            if Library.Unloaded then
                break
            end

            if Options.PressKeybind:GetState() then
            end
        end
    end)

    local AccentLabel = RightGroupBox:AddLabel("Standalone Color Picker")
    AccentLabel:AddColorPicker("AccentColorPicker", {
        Default = Color3.fromRGB(0, 170, 255),
        Title = "Accent Color",
        Transparency = 0,
        Changed = function(color, transparency) end,
    })

    local AdvancedDropdownsBox = Tab:AddGroupbox({
        Side = "Right",
        Name = "Advanced Dropdowns",
        IconName = "list-tree",
    })

    AdvancedDropdownsBox:AddDropdown("FormattedDropdown", {
        Text = "Formatted dropdown",
        Values = { "This", "is", "formatted" },
        Default = 1,
        FormatDisplayValue = function(value)
            if value == "formatted" then
                return "display formatted"
            end
            return value
        end,
        Callback = function(value) end,
    })

    AdvancedDropdownsBox:AddDropdown("DictionaryDropdown", {
        Text = "Dictionary dropdown",
        Values = {
            item01 = "Excalibur",
            item05 = "Aegis Shield",
            item06 = "Wooden Club",
        },
        Default = "item01",
        Multi = true,
        DisabledValues = { "item05" },
        Callback = function(value) end,
    })

    AdvancedDropdownsBox:AddDropdown("DisabledValueDropdown", {
        Text = "Dropdown with disabled value",
        Values = { "This", "is", "disabled" },
        DisabledValues = { "disabled" },
        Default = 1,
        Callback = function(value) end,
    })

    AdvancedDropdownsBox:AddDropdown("LongDropdown", {
        Text = "Long dropdown",
        Values = { "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten" },
        Default = 1,
        MaxVisibleDropdownItems = 12,
        Callback = function(value) end,
    })

    AdvancedDropdownsBox:AddDropdown("DisabledDropdown", {
        Text = "Disabled dropdown",
        Values = { "This", "is", "disabled" },
        Default = 1,
        Disabled = true,
        DisabledTooltip = "This dropdown is disabled",
    })
end

local function buildAdvancedTab(Tab)
    local LeftGroupBox = Tab:AddGroupbox({
        Side = "Left",
        Name = "Structure Demo",
        IconName = "layers",
    })

    LeftGroupBox:AddToggle("EnableAudioFeature", {
        Text = "Enable Audio Feature",
        Default = false,
    })

    local DependentBox = LeftGroupBox:AddDependencyBox()
    DependentBox:AddSlider("AudioVolume", {
        Text = "Audio Volume",
        Default = 50,
        Min = 0,
        Max = 100,
        Rounding = 0,
    })
    DependentBox:AddInput("AudioPreset", {
        Text = "Audio Preset",
        Default = "Default",
    })
    DependentBox:SetupDependencies({
        { Toggles.EnableAudioFeature, true },
    })

    LeftGroupBox:AddToggle("EnableAdvancedGroup", {
        Text = "Enable Advanced Group",
        Default = false,
    })

    local DependentGroup = LeftGroupBox:AddDependencyGroupbox()
    DependentGroup:AddLabel("These options only appear when the toggle above is enabled")
    DependentGroup:AddCheckbox("AdvancedOptionOne", {
        Text = "Advanced Option One",
        Default = false,
    })
    DependentGroup:SetupDependencies({
        { Toggles.EnableAdvancedGroup, true },
    })

    local RightTabBox = Tab:AddTabbox({
        Side = "Right",
        Name = "Nested Tabbox",
    })

    local CombatSubTab = RightTabBox:AddTab("Combat", "sword")
    CombatSubTab:AddToggle("AutoAttack", {
        Text = "Auto Attack",
        Default = false,
    })
    CombatSubTab:AddSlider("AttackRange", {
        Text = "Attack Range",
        Default = 10,
        Min = 0,
        Max = 50,
        Rounding = 1,
    })

    local MovementSubTab = RightTabBox:AddTab("Movement", "footprints")
    MovementSubTab:AddToggle("InfiniteJump", {
        Text = "Infinite Jump",
        Default = false,
    })
    MovementSubTab:AddSlider("WalkSpeed", {
        Text = "Walk Speed",
        Default = 16,
        Min = 16,
        Max = 500,
        Rounding = 0,
    })
end

local function buildVisualsTab(Tab)
    local LeftGroupBox = Tab:AddGroupbox({
        Side = "Left",
        Name = "Media",
        IconName = "image",
    })

    LeftGroupBox:AddImage("ShowcaseImage", {
        Image = "http://www.roblox.com/asset/?id=135666356081915",
        Height = 180,
        ScaleType = Enum.ScaleType.Fit,
    })

    LeftGroupBox:AddDivider("Video")

    local ShowcaseVideo = LeftGroupBox:AddVideo("ShowcaseVideo", {
        Video = "rbxassetid://1234567890",
        Looped = true,
        Playing = false,
        Volume = 0.3,
        Height = 180,
    })

    LeftGroupBox:AddButton({
        Text = "Play Video",
        Func = function()
            ShowcaseVideo:Play()
        end,
    })

    LeftGroupBox:AddButton({
        Text = "Pause Video",
        Func = function()
            ShowcaseVideo:Pause()
        end,
    })

    local RightGroupBox = Tab:AddGroupbox({
        Side = "Right",
        Name = "Viewport & Passthrough",
        IconName = "box",
    })

    local ViewportPart = Instance.new("Part")
    ViewportPart.Size = Vector3.new(4, 4, 4)
    ViewportPart.Color = Color3.fromRGB(0, 170, 255)

    RightGroupBox:AddViewport("PartViewport", {
        Object = ViewportPart,
        Interactive = true,
        AutoFocus = true,
        Height = 200,
    })

    local CustomFrame = Instance.new("Frame")
    CustomFrame.Size = UDim2.fromOffset(200, 60)
    CustomFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local CustomLabel = Instance.new("TextLabel")
    CustomLabel.Size = UDim2.fromScale(1, 1)
    CustomLabel.BackgroundTransparency = 1
    CustomLabel.Text = "Custom Passthrough UI"
    CustomLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CustomLabel.Parent = CustomFrame

    RightGroupBox:AddUIPassthrough("CustomPassthrough", {
        Instance = CustomFrame,
        Height = 80,
    })
end

local function buildKeyTab(Tab)
    Tab:AddLabel({
        Text = "Key: Banana",
        DoesWrap = true,
        Size = 16,
    })

    Tab:AddKeyBox(function(ReceivedKey)
        local Success = ReceivedKey == "Banana"

        Library:Notify({
            Title = "Expected Key: Banana",
            Description = "Received Key: " .. ReceivedKey .. "\nSuccess: " .. tostring(Success),
            Time = 4,
        })
    end)
end

local function buildUtilityTab(Tab)
    local NotifyGroupBox = Tab:AddGroupbox({
        Side = "Left",
        Name = "Notifications & Dialogs",
        IconName = "bell",
    })

    NotifyGroupBox:AddButton({
        Text = "Simple Notification",
        Func = function()
            Library:Notify("Hello world!", 4)
        end,
    })

    NotifyGroupBox:AddButton({
        Text = "Notification with Icon",
        Func = function()
            Library:Notify({
                Title = "Obsidian Showcase",
                Description = "This notification has an icon.",
                Icon = "info",
                Time = 4,
            })
        end,
    })

    NotifyGroupBox:AddButton({
        Text = "Progress Notification",
        Func = function()
            local Notification = Library:Notify({
                Title = "Loading",
                Description = "Processing steps...",
                Steps = 10,
            })

            task.spawn(function()
                for i = 1, 10 do
                    Notification:ChangeStep(i)
                    task.wait(0.1)
                end
                Notification:Destroy()
            end)
        end,
    })

    NotifyGroupBox:AddButton({
        Text = "Open Confirm Dialog",
        Func = function()
            Window:AddDialog("ConfirmDialog", {
                Title = "Confirm Action",
                Description = "Are you sure you want to proceed?",
                AutoDismiss = true,
                OutsideClickDismiss = true,
                FooterButtons = {
                    Confirm = {
                        Title = "Confirm",
                        Variant = "Primary",
                        Order = 1,
                        Callback = function()
                            Library:Notify("Action confirmed", 3)
                        end,
                    },
                    Cancel = {
                        Title = "Cancel",
                        Variant = "Secondary",
                        Order = 2,
                        Callback = function() end,
                    },
                },
            })
        end,
    })

    local OverlayGroupBox = Tab:AddGroupbox({
        Side = "Left",
        Name = "Overlays",
        IconName = "square-dashed-mouse-pointer",
    })

    local DraggableLabel

    OverlayGroupBox:AddButton({
        Text = "Toggle Draggable Label",
        Func = function()
            if DraggableLabel then
                DraggableLabel:Destroy()
                DraggableLabel = nil
                return
            end
            DraggableLabel = Library:AddDraggableLabel("Obsidian demo")
            DraggableLabel:SetText("Obsidian demo v2")
        end,
    })

    OverlayGroupBox:AddButton({
        Text = "Spawn Draggable Button",
        Func = function()
            local DraggableButton = Library:AddDraggableButton("Click Me", function()
                Library:Notify("Draggable button clicked!", 3)
            end)
            task.delay(5, function()
                DraggableButton:Destroy()
            end)
        end,
    })

    OverlayGroupBox:AddButton({
        Text = "Open Keybind Menu",
        Func = function()
            Library.KeybindFrame.Visible = true
        end,
    })

    OverlayGroupBox:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
        Default = "RightShift",
        NoUI = true,
        Text = "Menu keybind",
    })

    Library.ToggleKeybind = Options.MenuKeybind
end

buildMainTab(Tabs.Main)
buildElementsTab(Tabs.Elements)
buildAdvancedTab(Tabs.Advanced)
buildVisualsTab(Tabs.Visuals)
buildKeyTab(Tabs.Key)
buildUtilityTab(Tabs.Utility)

Library:OnUnload(function()
    if getgenv().ObsidianExampleLibrary == Library then
        getgenv().ObsidianExampleLibrary = nil
    end
end)

Library:Notify({
    Title = "Obsidian Showcase",
    Description = "All UI elements have been loaded successfully.",
    Time = 5,
})
