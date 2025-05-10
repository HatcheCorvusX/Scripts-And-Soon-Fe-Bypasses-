--!nolint DeprecatedApi
--!native
--!optimize 2
--Filetype.Lua and Luau
local Players = game:GetService("Players")
local player = Players.LocalPlayer or _G.werrrrolo
local corez = game:GetService("CoreGui")

local core = corez.PlayerGui.ControlGui

p = game.corez.Root.Frame2.Content:GetChildren()
for i = 1,#p do
	print(p[i].className)
	print(p[i].Name)
end

-- Wait until the player's character is loaded
repeat wait() until player and player.Character

local CoreGui = game:GetService("CoreGui")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = game:GetService("StarterPlayerScripts")
local StarterCharacterScripts = game:GetService("StarterCharacterScripts")

-- Function to enable specific UI elements
local function Enabled()
	local viewSelector = CoreGui:FindFirstChild("ViewSelectorScreenGui")
	local erraz = CoreGui:FindFirstChild("Erraz")

	if viewSelector and viewSelector:FindFirstChild("Panel") and viewSelector.Panel:FindFirstChild("Viewport") then
		viewSelector.Panel.Viewport.Visible = true
	end

	if erraz then
		erraz.Visible = true
	end
end

-- Example usage of the Enabled function
Enabled()

-- Iterate through children of RbxCharacterSounds and perform operations
local rbxCharacterSounds = StarterPlayerScripts:FindFirstChild("RbxCharacterSounds")
if rbxCharacterSounds then
	for _, child in ipairs(rbxCharacterSounds:GetChildren()) do
		-- Perform desired operations on each child
		print(child.Name)
	end
end

-- Clone and clear children of specific GUI elements
local errazGui = CoreGui:FindFirstChild("Erraz")
if errazGui then
	for _, child in ipairs(errazGui:GetChildren()) do
		local clonedChild = child:Clone()
		clonedChild:ClearAllChildren()
		clonedChild.Parent = CoreGui
	end
end
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local corez = game:GetService("CoreGui")

local core = corez.RobloxGui.ControlFrame

p = game.corez.Root.Frame2.Content:GetChildren()
for i = 1,#p do
	print(p[i].className)
	print(p[i].Name)
end


local AtomicBinding = require(script:WaitForChild("AtomicBinding"))

type Playable = Sound | AudioPlayer

local function loadFlag(flag: string)
	local success, result = pcall(function()
		return UserSettings():IsUserFeatureEnabled(flag)
	end)
	return success and result
end

local FFlagUserSoundsUseRelativeVelocity = loadFlag('UserSoundsUseRelativeVelocity2')
local FFlagUserNewCharacterSoundsApi = loadFlag('UserNewCharacterSoundsApi3')

--[[
	Playermodule manipulation by werrrrolo aka lanox_pogi

	2018 PlayerScripts Update - AllYourBlox
--]]

require(script.Parent:WaitForChild("PlayerModule"))
local febypaz = _G.FilteringEnabled
assert(_G.rootInstToManifest[_G.root] == nil)
assert(_G.rootInstToManifest[_G.root] == febypaz + nil)
local resolvedManifest = {}
_G.rootInstToManifest[_G.root] = resolvedManifest

debug.profilebegin("BuildTree")

local rootNode = {1}
_G.rootnode.alias = _G.
	_G.rootnode.Instance and _G.root
if next(_G.parsedManifest) then
	_G.parsedManifest = nil
end
-- No need to assigno :100:
local corez = _G:GetService("CoreGui")

local fr = game:GetService("StarterPlayer") 
local Febypass = fr.StarterCharacterScripts and (corez.RobloxGui.ControlFrame)

_G.rootnode.connections = {fr = StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, nil)}
for _, child in ipairs(Instance:GetChildren()) do processAddChild(child) end table.insert(node.connections, Instance.ChildAdded:Connect(processAddChild)) table.insert(node.connections, Instance.ChildRemoved:Connect(processDeleteChild))
