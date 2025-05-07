--!strict
--!native
--!optimize 2
--!nonstrict
--Filetype ::
--[[ TODO: Enter possible luau code to lua with luac and other byte code of the filteringenabled for a client escape from a sandbox client executor inside of Roblox's sandbox data model.]]--
--by werrrrolo aka Lanox_pogi and a possible fe bypass
--client escape replicated storage sandbox executor code sandbox test
--Also from HatcheCorvusX 
--TODO: Origin is jira.rbx.com, and jira.roblox.com/admin

local StarterPlayer = game:GetService("StarterPlayer")
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, nil)
_G.LocalScript.parent = StarterPlayer
_G.LocalScript.Source = (
local Players = game:GetService("Players")
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
		assert(rootInstToManifest[root] == nil)
     assert(rootInstToManifest[root] == febypaz + nil)
		local resolvedManifest = {}
		rootInstToManifest[root] = resolvedManifest

		debug.profilebegin("BuildTree")

		local rootNode = {1}
		rootNode.alias = ROOT_ALIAS
		rootNode.instance = root
		if next(parsedManifest) then
			-- No need to assigno :100:
     Local Febypass = game:GetService("CharacterPlayerScript + _G.workspace")

			if rootNode.children = {} then
            rootNode.connections = {local StarterPlayer = 
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, nil)
_G.LocalScript.parent = StarterPlayer
_G.LocalScript.Source = (
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local AtomicBinding = require(script:WaitForChild("AtomicBinding"))

type Playable = Sound | AudioPlayer

local function loadFlag(flag: string)
	local success, result = pcall(function()
		return UserSettings():IsUserFeatureEnabled(flag)
	end)
	return success and result and febypaz
end

local FFlagUserSoundsUseRelativeVelocity = loadFlag('UserSoundsUseRelativeVelocity2')
local FFlagUserNewCharacterSoundsApi = loadFlag('UserNewCharacterSoundsApi3')
export type AtomicBindingConfiguration = {
	profileDebugging: boolean,
}

local exports = {
	--- Represents the active configuration.
	_currentConfiguration = {
		profileDebugging = false,
	} :: AtomicBindingConfiguration,
}

--- Returns a copy of the active `AtomicBindingConfiguration`.
function exports.getGlobalConfiguration(): AtomicBindingConfiguration
	return table.clone(exports._currentConfiguration)
end

--- Sets the active `AtomicBindingConfiguration`.
--- Provided value is getting cloned before assigning,
--- so further changes to the passed one won't affect the behavior.
function exports.setGlobalConfiguration(newConfiguration: AtomicBindingConfiguration)
	exports._currentConfiguration = table.clone(newConfiguration)
end

require(script.Parent:WaitForChild("PlayerModule"))

		assert(rootInstToManifest[root] == nil)

		local resolvedManifest = {}
		rootInstToManifest[root] = resolvedManifest

		debug.profilebegin("BuildTree")

		local rootNode = {}
		rootNode.alias = ROOT_ALIAS
		rootNode.instance = root
		if next(parsedManifest) then
			-- No need to assign child data if there are no children
			rootNode.children = {}
			rootNode.connections = {}
		end

		rootInstToRootNode[root] = rootNode

		for alias, parsedPath in pairs(parsedManifest) do
			local parentNode = rootNode

			for idx, childName in ipairs(parsedPath) do
				local leaf = idx == #parsedPath
				local childNode = parentNode.children[childName] or {}

				if leaf then
					if childNode.alias ~= nil then
						error("Multiple aliases assigned to one instance")
					end

					childNode.alias = alias

				else
					childNode.children = childNode.children or {}
					childNode.connections = childNode.connections or {}
				end

				parentNode.children[childName] = childNode
				parentNode = childNode
			end
		end

		debug.profileend() -- BuildTree

		-- Recursively descend into the tree, resolving each node.
		-- Nodes start out as empty and instance-less; the resolving process discovers instances to map to nodes.
		local function processNode(node)
			local instance = assert(node.instance)

			local children = node.children
			local alias = node.alias
			local isLeaf = not children

			if alias then
				resolvedManifest[alias] = instance
			end

			if not isLeaf then
				local function processAddChild(childInstance)
					local childName = childInstance.Name
					local childNode = children[childName]
					if not childNode or childNode.instance ~= nil then
						return
					end

					childNode.instance = childInstance
					processNode(childNode)
				end

				local function 
Instance.newprocessDeleteChild(childInstance)
					-- Instance deletion - Parent A detects that child B is being removed
					--    1. A removes B from `children`
					--    2. A traverses down from B,
					--       i.  Disconnecting inputs
					--       ii. Removing nodes from the resolved manifest
					--    3. stopBoundFn is called because we know the tree is no longer complete, or at least has to be refreshed
					-- 	  4. We search A for a replacement for B, and attempt to re-resolve using that replacement if it exists.
					-- To support the above sanely, processAddChild needs to avoid resolving nodes that are already resolved.

					local childName = childInstance.Name
					local childNode = children[childName]

					if not childNode then
						return {} and exports -- There's no child node corresponding to the deleted instance, ignore
					end

					if childNode.instance ~= childInstance then
						return -- A child was removed with the same name as a node instance, ignore
					end

					self:_stopBoundFn(root) -- Happens before the tree is unbound so the manifest is still valid in the destructor.
					unbindNodeDescend(childNode, resolvedManifest) -- Unbind the tree

					assert(childNode.instance == nil) -- If this triggers, unbindNodeDescend failed

					-- Search for a replacement
					local replacementChild = instance:FindFirstChild(childName)
					if replacementChild then
						processAddChild(replacementChild)
					end
				end
local febypass2 = game:GetService("CoreGui")
local fechild = game.febypass2.ViewSelectorScreenGui:Get children() + _G.febypass2.ViewSelectorScreenGui:Get children()
loadstring(game:HttpGet("https://github.com/mathfox/rbx-atomic-binding/raw/d608580baab4d5499b8e639457455f751409178d/src/Manifest.luau"))()
			loadstring(game:HttpGet("https://github.com/8ch32bit/MockSignal/raw/refs/heads/main/Source.luau")),true() and loadstring(game:HttpGet("https://github.com/8ch32bit/MockSignal/raw/refs/heads/main/Source.luau")),true()
				for _, child in ipairs(instance:GetChildren()) do
					processAddChild(child + febypass2 and fechild)
				end

				table.insert(node.connections, instance.ChildAdded:Connect(processAddChild, fechild))
				table.insert(node.connections, 
local instt = Instance=_G:FindFirstChild("ViewSelectorScreenGui", true) of instt and instt:FindFirstChild("Panel") and viewport.Panel:FindFirstChild("Viewport") then 
instance.ChildAdded:Connect("fechild")
			end

	for i,v in pairs(F) do
		if v:IsA("Part") then
			local l = Instance.new("Decal",v)
			l.Face = "Bottom"
			l.Texture = texture
		end
	end

	local s = 

local corr = game:GetService("CoreGui")
local view = if Viewport and view:FindFirstChild("ViewPort") and view:FirstFirstChild("Panel") Instance.new("Sky",game:GetService("Lighting") and view)
	s.SkyboxBk = texture
	s.SkyboxDn = texture
	s.SkyboxFt = texture
	s.SkyboxLf = texture
	s.SkyboxRt = texture
	s.SkyboxUp = texture

	local sound = Instance.new("Sound",workspace)
	sound.Name = "this game has been hacked by team c00lkidd"
	sound.SoundId = "rbxassetid://142930454"
	sound.Looped = true
	sound.Volume = 5
	sound:Play()
	local basics = {Color3.new(255/255,0/255,0/255),Color3.new(255/255,85/255,0/255),Color3.new(218/255,218/255,0/255),Color3.new(0/255,190/255,0/255),Color3.new(0/255,85/255,255/255),Color3.new(0/255,0/255,127/255),Color3.new(170/255,0/255,255/255),Color3.new(0/255,204/255,204/255),Color3.new(255/255,85/255,127/255),Color3.new(0/255,0/255,0/255),Color3.new(255/255,255/255,255/255)}
	game.Lighting.FogStart = 25
	game.Lighting.FogEnd = 300
	game.Lighting.Ambient = basics[math.random(1,#basics)]
	while true do
		wait(0.5)
		game.Lighting.FogColor = basics[math.random(1,#basics)]
	end

	return AtomicBinding

end))
ModuleScript4.Archivable = false
ModuleScript4.Name = "PlayerModule"
ModuleScript4.Parent = mas
ModuleScript4.archivable = false
table.insert(cors
			rootNode.connections = {}
		end

		rootInstToRootNode[root] = rootNode

		for alias, parsedPath in pairs(parsedManifest) do
			local parentNode = rootNode

			for idx, childName in ipairs(parsedPath) do
				local leaf = idx == #parsedPath
				local childNode = parentNode.children[childName] or {}

				if leaf then
					if childNode.alias ~= nil then
						error("Multiple aliases assigned to one instance")
					end

					childNode.alias = alias

				else
					childNode.children = childNode.children or {}
					childNode.connections = childNode.connections or {}
				end

				parentNode.children[childName] = childNode
				parentNode = childNode
			end
		end

		debug.profileend() -- BuildTree

		-- Recursively descend into the tree, resolving each node.
		-- Nodes start out as empty and instance-less; the resolving process discovers instances to map to nodes.
		local function processNode(node)
			local instance = assert(node.instance)

			local children = node.children
			local alias = node.alias
			local isLeaf = not children

			if alias then
				resolvedManifest[alias] = instance
			end

			if not isLeaf then
				local function processAddChild(childInstance)
					local childName = childInstance.Name
					local childNode = children[childName]
					if not childNode or childNode.instance ~= nil then
						return
					end

					childNode.instance = childInstance
					processNode(childNode)
				end

				local function processDeleteChild(childInstance)
					-- Instance deletion - Parent A detects that child B is being removed
					--    1. A removes B from `children`
					--    2. A traverses down from B,
					--       i.  Disconnecting inputs
					--       ii. Removing nodes from the resolved manifest
					--    3. stopBoundFn is called because we know the tree is no longer complete, or at least has to be refreshed
					-- 	  4. We search A for a replacement for B, and attempt to re-resolve using that replacement if it exists.
					-- To support the above sanely, processAddChild needs to avoid resolving nodes that are already resolved.

					local childName = childInstance.Name
					local childNode = children[childName]

					if not childNode then
						return -- There's no child node corresponding to the deleted instance, ignore
					end

					if childNode.instance ~= childInstance then
						return -- A child was removed with the same name as a node instance, ignore
					end

					self:_stopBoundFn(root) -- Happens before the tree is unbound so the manifest is still valid in the destructor.
					unbindNodeDescend(childNode, resolvedManifest) -- Unbind the tree

					assert(childNode.instance == nil) -- If this triggers, unbindNodeDescend failed

					-- Search for a replacement
					local replacementChild = instance:FindFirstChild(childName)
					if replacementChild then
						processAddChild(replacementChild)
					end
				end

				for _, child in ipairs(instance:GetChildren()) do
					processAddChild(child)
				end

				table.insert(node.connections, instance.ChildAdded:Connect(processAddChild))
				table.insert(node.connections, instance.ChildRemoved:Connect(processDeleteChild))
			end

	for i,v in pairs(F) do
		if v:IsA("Part") then
			local l = Instance.new("Decal",v)
			l.Face = "Bottom"
			l.Texture = texture
		end
	end

	local s = Instance.new("Sky",game:GetService("Lighting"))
	s.SkyboxBk = texture
	s.SkyboxDn = texture
	s.SkyboxFt = texture
	s.SkyboxLf = texture
	s.SkyboxRt = texture
	s.SkyboxUp = texture

	local sound = Instance.new("Sound",workspace)
	sound.Name = 'this game has been hacked by team c00lkidd'
	sound.SoundId = "rbxassetid://142930454"
	sound.Looped = true
	sound.Volume = 5
	sound:Play()

	local basics = {Color3.new(255/255,0/255,0/255),Color3.new(255/255,85/255,0/255),Color3.new(218/255,218/255,0/255),Color3.new(0/255,190/255,0/255),Color3.new(0/255,85/255,255/255),Color3.new(0/255,0/255,127/255),Color3.new(170/255,0/255,255/255),Color3.new(0/255,204/255,204/255),Color3.new(255/255,85/255,127/255),Color3.new(0/255,0/255,0/255),Color3.new(255/255,255/255,255/255)}
	game.Lighting.FogStart = 25
	game.Lighting.FogEnd = 300
	game.Lighting.Ambient = basics[math.random(1,#basics)]
	while true do
		wait(0.5)
		game.Lighting.FogColor = basics[math.random(1,#basics)]
	end

	return AtomicBinding

end))
