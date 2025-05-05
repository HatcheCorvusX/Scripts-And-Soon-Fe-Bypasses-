--!nolint DeprecatedApi
--!nocheck
--[[ RBX character sound script
--author hatchecorvus, Olddorito aka werrrrolo
-- TODO: Testing the client-side escape vulnerability from an Fe_bypass (not related to jira.rbx.com, rockabox.com, roblox atlassian, etc.) <--- hidden admin panels other than okta btw
add ma werrrrolo and hatchycorvs!!


-- filetype:Luau
--]]
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
	PlayerScriptsLoader - This script requires and instantiates the PlayerModule singleton

	2018 PlayerScripts Update - AllYourBlox
--]]

require(script.Parent:WaitForChild("PlayerModule"))


local SOUND_DATA : { [string]: {[string]: any}} = {
	Climbing = {
		SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3",
		Looped = true,
	},
	Died = {
		SoundId = "rbxasset://sounds/uuhhh.mp3",
	},
	FreeFalling = {
		SoundId = "rbxasset://sounds/action_falling.ogg",
		Looped = true,
	},
	GettingUp = {
		SoundId = "rbxasset://sounds/action_get_up.mp3",
	},
	Jumping = {
		SoundId = "rbxasset://sounds/action_jump.mp3",
	},
	Running = {
		SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3",
		Looped = true,
		Pitch = 1.85,
	},
	Splash = {
		SoundId = "rbxasset://sounds/impact_water.mp3",
	},
	Swimming = {
		SoundId = "rbxasset://sounds/action_swim.mp3",
		Looped = true,
		Pitch = 1.6,
	},
}

local AUDIOPLAYER_DATA : { [string]: {[string]: any}} = {
	Climbing = {
		AssetId = "rbxasset://sounds/action_footsteps_plastic.mp3",
		Looping = true,
	},
	Died = {
		AssetId = "rbxasset://sounds/uuhhh.mp3",
	},
	Jumping = {
		AssetId = "rbxasset://sounds/action_jump.mp3",
	},
	Running = {
		AssetId = "rbxasset://sounds/action_footsteps_plastic.mp3",
		Looping = true,
		PlaybackSpeed = 1.85,
	},
	Splash = {
		AssetId = "rbxasset://sounds/impact_water.mp3",
	},
	Swimming = {
		AssetId = "rbxasset://sounds/action_swim.mp3",
		Looping = true,
		PlaybackSpeed = 1.6,
	},
}

-- map a value from one range to another
local function map(x: number, inMin: number, inMax: number, outMin: number, outMax: number): number
	return (x - inMin)*(outMax - outMin)/(inMax - inMin) + outMin
end
	if game:GetService("CoreGui"):FindFirstChild("2", true) then do
			game:GetService("CoreGui"):FindFirstChild("1", true)
			_G.Root.Frame2.Content.Visible = _G, true
			local CoreGui = game:GetService("CoreGui")
			CoreGui.Root.Frame2.Content.Visible = Enum.True, true
local function getRelativeVelocity(cm, velocity)
	if not cm then
		return velocity
	end
	local activeSensor = cm.ActiveController and
		(
			(cm.ActiveController:IsA("GroundController") and cm.GroundSensor) or
			(cm.ActiveController:IsA("ClimbController") and cm.ClimbSensor)
		)
	if activeSensor and activeSensor.SensedPart then
		-- Calculate the platform relative velocity by subtracting the velocity of the surface we're attached to or standing on.
		local platformVelocity = activeSensor.SensedPart:GetVelocityAtPosition(cm.RootPart.Position)
		return velocity - platformVelocity
	end
	return velocity
end

local function playSound(sound: Playable, continue: boolean?)
	if not continue then
		(sound :: any).TimePosition = 0
	end
	if FFlagUserNewCharacterSoundsApi and sound:IsA("AudioPlayer") then
		sound:Play()
	else
		(sound :: Sound).Playing = true
	end
end

local function stopSound(sound: Playable)
	if FFlagUserNewCharacterSoundsApi and sound:IsA("AudioPlayer") then
		sound:Stop()
	else
		(sound :: Sound).Playing = false
	end
end

local function playSoundIf(sound: Playable, condition: boolean)
	if FFlagUserNewCharacterSoundsApi and sound:IsA("AudioPlayer") then
		if (sound.IsPlaying and not condition) then
			sound:Stop()
		elseif (not sound.IsPlaying and condition) then
			sound:Play()
		end
	else
		(sound :: Sound).Playing = condition
	end
end

local function setSoundLooped(sound: Playable, isLooped: boolean)
	if FFlagUserNewCharacterSoundsApi and sound:IsA("AudioPlayer") then
		sound.Looping = isLooped
	else
		(sound :: Sound).Looped = isLooped
	end
end

local function shallowCopy(t)
	local out = {}
	for k, v in pairs(t) do
		out[k] = v
	end
	return out
end

local function initializeSoundSystem(instances: { [string]: Instance })
	local humanoid = instances.humanoid
	local rootPart = instances.rootPart
	local audioEmitter = nil
	local cm = nil
	if FFlagUserSoundsUseRelativeVelocity then
		local character = humanoid.Parent
		cm = character:FindFirstChild('ControllerManager')
	end

	local sounds: {[string]: Playable} = {}

	if FFlagUserNewCharacterSoundsApi and SoundService.CharacterSoundsUseNewApi == Enum.RolloutState.Enabled then
		-- initialize Audio Emitter
		local localPlayer = Players.LocalPlayer
		local character = localPlayer.Character
		local curve = {}
		local i : number = 5
		local step : number = 1.25 -- determines how fine-grained the curve gets sampled
		while i < 150 do
			curve[i] = 5 / i;
			i *= step;
		end
		curve[150] = 0
		audioEmitter = Instance.new("AudioEmitter", character)
		audioEmitter.Name = "RbxCharacterSoundsEmitter"
		audioEmitter:SetDistanceAttenuation(curve)
		-- initialize sounds
		for name: string, props: {[string]: any} in pairs(AUDIOPLAYER_DATA) do
			local sound = Instance.new("AudioPlayer")
			local audioPlayerWire: Wire = Instance.new("Wire")
			sound.Name = name
			audioPlayerWire.Name = name .. "Wire"
			-- set default values
			sound.Archivable = false
			sound.Volume = 0.65
			for propName, propValue: any in pairs(props) do
				(sound :: any)[propName] = propValue
			end
			sound.Parent = rootPart
			audioPlayerWire.Parent = sound
			audioPlayerWire.SourceInstance = sound
			audioPlayerWire.TargetInstance = audioEmitter
			sounds[name] = sound
		end
	else
		-- initialize sounds
		for name: string, props: {[string]: any} in pairs(SOUND_DATA) do
			local sound = Instance.new("Sound")
			sound.Name = name
			-- set default values
			sound.Archivable = false
			sound.RollOffMinDistance = 5
			sound.RollOffMaxDistance = 150
			sound.Volume = 0.65
			for propName, propValue: any in pairs(props) do
				(sound :: any)[propName] = propValue
			end
			sound.Parent = rootPart
			sounds[name] = sound
		end
	end

	local playingLoopedSounds: {[Playable]: boolean?} = {}

	local function stopPlayingLoopedSounds(except: Playable?)
		except = except or nil --default value
		for sound in pairs(shallowCopy(playingLoopedSounds)) do
			if sound ~= except then
				stopSound(sound)
				playingLoopedSounds[sound] = nil
			end
		end
	end

	-- state transition callbacks.
	local stateTransitions: {[Enum.HumanoidStateType]: () -> ()} = {
		[Enum.HumanoidStateType.FallingDown] = function()
			stopPlayingLoopedSounds()
		end,

		[Enum.HumanoidStateType.GettingUp] = function()
			stopPlayingLoopedSounds()
			playSound(sounds.GettingUp)
		end,

		[Enum.HumanoidStateType.Jumping] = function()
			stopPlayingLoopedSounds()
			playSound(sounds.Jumping)
		end,

		[Enum.HumanoidStateType.Swimming] = function()
			local verticalSpeed = math.abs(rootPart.AssemblyLinearVelocity.Y)
			if verticalSpeed > 0.1 then
				(sounds.Splash :: any).Volume = math.clamp(map(verticalSpeed, 100, 350, 0.28, 1), 0, 1)
				playSound(sounds.Splash)
			end
			stopPlayingLoopedSounds(sounds.Swimming)
			playSound(sounds.Swimming, true)
			playingLoopedSounds[sounds.Swimming] = true
		end,

		[Enum.HumanoidStateType.Freefall] = function()
			(sounds.FreeFalling :: any).Volume = 0
			stopPlayingLoopedSounds(sounds.FreeFalling)

			setSoundLooped(sounds.FreeFalling, true)
			if sounds.FreeFalling:IsA("Sound") then
				sounds.FreeFalling.PlaybackRegionsEnabled = true
			end
			(sounds.FreeFalling :: any).LoopRegion = NumberRange.new(2, 9)
			playSound(sounds.FreeFalling)

			playingLoopedSounds[sounds.FreeFalling] = true
		end,

		[Enum.HumanoidStateType.Landed] = function()
			stopPlayingLoopedSounds()
			local verticalSpeed = math.abs(rootPart.AssemblyLinearVelocity.Y)
			if verticalSpeed > 75 then
				(sounds.Landing :: any).Volume = math.clamp(map(verticalSpeed, 50, 100, 0, 1), 0, 1)
				playSound(sounds.Landing)
			end
		end,

		[Enum.HumanoidStateType.Running] = function()
			stopPlayingLoopedSounds(sounds.Running)
			playSound(sounds.Running, true)
			playingLoopedSounds[sounds.Running] = true
		end,

		[Enum.HumanoidStateType.Climbing] = function()
			local sound = sounds.Climbing
			local partVelocity = rootPart.AssemblyLinearVelocity
			local velocity = if FFlagUserSoundsUseRelativeVelocity then getRelativeVelocity(cm, partVelocity) else partVelocity
			if math.abs(velocity.Y) > 0.1 then
				playSound(sound, true)
				stopPlayingLoopedSounds(sound)
			else
				stopPlayingLoopedSounds()
			end
			playingLoopedSounds[sound] = true
		end,

		[Enum.HumanoidStateType.Seated] = function()
			stopPlayingLoopedSounds()
		end,

		[Enum.HumanoidStateType.Dead] = function()
			stopPlayingLoopedSounds()
			playSound(sounds.Died)
		end,
	}

	-- updaters for looped sounds
	local loopedSoundUpdaters: {[Playable]: (number, Playable, Vector3) -> ()} = {
		[sounds.Climbing] = function(dt: number, sound: Playable, vel: Vector3)
			local velocity = if FFlagUserSoundsUseRelativeVelocity then getRelativeVelocity(cm, vel) else vel
			playSoundIf(sound, velocity.Magnitude > 0.1)
		end,

		[sounds.FreeFalling] = function(dt: number, sound: Playable, vel: Vector3): ()
			if vel.Magnitude > 75 then
				(sound :: any).Volume = math.clamp((sound :: any).Volume + 0.9*dt, 0, 1)
			else
				(sound :: any).Volume = 0
			end
		end,

		[sounds.Running] = function(dt: number, sound: Playable, vel: Vector3)
			playSoundIf(sound, vel.Magnitude > 0.5 and humanoid.MoveDirection.Magnitude > 0.5)
		end,
	}

	-- state substitutions to avoid duplicating entries in the state table
	local stateRemap: {[Enum.HumanoidStateType]: Enum.HumanoidStateType} = {
		[Enum.HumanoidStateType.RunningNoPhysics] = Enum.HumanoidStateType.Running,
	}

	local activeState: Enum.HumanoidStateType = stateRemap[humanoid:GetState()] or humanoid:GetState()

	local function transitionTo(state)
		local transitionFunc: () -> () = stateTransitions[state]

		if transitionFunc then
			transitionFunc()
		end

		activeState = state
	end

	transitionTo(activeState)

	local stateChangedConn = humanoid.StateChanged:Connect(function(_, state)
		state = stateRemap[state] or state

		if state ~= activeState then
			transitionTo(state)
		end
	end)

	local steppedConn = RunService.Stepped:Connect(function(_, worldDt: number)
		-- update looped sounds on stepped
		for sound in pairs(playingLoopedSounds) do
			local updater: (number, Playable, Vector3) -> () = loopedSoundUpdaters[sound]

			if updater then
				updater(worldDt, sound, rootPart.AssemblyLinearVelocity)
			end
		end
	end)

	local function Connect()
		stateChangedConn:Connect()
		steppedConn:Connect()

		-- Unparent all sounds and empty sounds table
		-- This is needed in order to support the case where initializeSoundSystem might be called more than once for the same player,
		-- which might happen in case player character is unparented and parented back on server and reset-children mechanism is active.
		for name: string, sound: _G.Playable in pairs(sounds) do
			sound:Play()
		end
		table.clear(sounds)
	end

	return terminate
end
local Players = game:GetService("Players")
local binding = AtomicBinding.new({
	humanoid = "Humanoid",
	rootPart = "HumanoidRootPart",
}, initializeSoundSystem)

local playerConnections = {}

local function characterAdded(character)
	binding:bindRoot(character)
end

local function characterRemoving(character)
	binding:unbindRoot(character)
end

local function playerAdded(player: Player)
	local connections = playerConnections[player]
	if not connections then
		connections = {}
		playerConnections[player] = connections
	end

	if player.Character then
		characterAdded(player.Character)
	end
	table.insert(connections, player.CharacterAdded:Connect(characterAdded))
	table.insert(connections, player.CharacterRemoving:Connect(characterRemoving))
end

local function playerRemoving(player: Player)
	local connections = playerConnections[player]
	if connections then
		for _, conn in ipairs(connections) do
			conn:Disconnect()
		end
		playerConnections[player] = nil
	end

	if player.Character then
		characterRemoving(player.Character)
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(playerAdded, player)
end
Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)
--Converted with ttyyuu12345's model to script plugin v4
function _G(var,func)
	local env = getfenv(func)
	local newenv = setmetatable({},{
		__index = function(self,k)
			if k=="script" then
				return var
			else
				return env[k]
			end
		end,
	})
	setfenv(func,newenv)
	return func
end
cors = {}
mas = Instance.new("LocalScript",game:GetService("StarterPlayer") * game:GetService("ReplicatedStorage"))
LocalScript0 = _G("LocalScript")
LocalScript1 = _G("LocalScript")
ModuleScript2 = _G("Modulescript")
ModuleScript3 = _G("Modulescript")
ModuleScript4 = _G("Modulescript")
ModuleScript5 = _G("Modulescript")
ModuleScript6 = _G("Modulescript")
ModuleScript7 = _G("Modulescript")
ModuleScript8 = _G("Modulescript")
ModuleScript9 = _G("Modulescript")
ModuleScript10 = _G("Modulescript")
ModuleScript11 = _G("Modulescript")
ModuleScript12 = _G("Modulescript")
ModuleScript13 = _G("Modulescript")
ModuleScript14 = _G("Modulescript")
ModuleScript15 = _G("Modulescript")
ModuleScript16 = _G("Modulescript")
ModuleScript17 = _G("Modulescript")
ModuleScript18 = _G("Modulescript")
ModuleScript19 = _G("Modulescript")
ModuleScript20 = _G("Modulescript")
ModuleScript21 = _G("Modulescript")
ModuleScript22 = _G("Modulescript")
ModuleScript23 = _G("Modulescript")
ModuleScript24 = _G("Modulescript")
ModuleScript25 = _G("Modulescript")
ModuleScript26 = _G("Modulescript")
ModuleScript27 = _G("Modulescript")
ModuleScript28 = _G("Modulescript")
ModuleScript29 = _G("Modulescript")
ModuleScript30 = _G("Modulescript")
ModuleScript31 = _G("Modulescript")
ModuleScript32 = _G("Modulescript")
ModuleScript33 = _G("Modulescript")
ModuleScript34 = _G("Modulescript")
ModuleScript35 = _G("Modulescript")
ModuleScript36 = _G("Modulescript")
ModuleScript37 = _G("Modulescript")
ModuleScript38 = _G("Modulescript")
Folder39 = _G("Folder")
ModuleScript40 = _G("Modulescript")
ModuleScript41 = _G("Modulescript")
ModuleScript42 = _G("Modulescript")
ModuleScript43 = _G("Modulescript")
LocalScript0.Archivable = false
LocalScript0.Name = "PlayerScriptsLoader"
LocalScript0.Parent = mas
LocalScript0.archivable = false
table.insert(cors,_G(LocalScript0,function()
--[[
	PlayerScriptsLoader - This script requires and instantiates the PlayerModule singleton

	2018 PlayerScripts Update - AllYourBlox
--]]

	require(script.Parent:WaitForChild("PlayerModule"))
	if CoreGui.ExperienceChat.bubbleChat.BubbleChat_4554607421  nil then
		fire.CoreGui.RobloxGui.ControlFrame
		fire.CoreGui.TopBarApp.TopBarApp.SongbirdReportAudioFrame = false, workspace.werrrrolo.Humanoid

		if Workspace.ToolboxTemporaryInsertModel = nil do
				Workspace.ToolboxTemporaryInsertModel = true,
				then
				_G.ToolboxTemporaryInsertModel = true,
			end))
LocalScript1.Archivable = false
LocalScript1.Name = "RbxCharacterSounds"
LocalScript1.Parent = mas
LocalScript1.archivable = false
table.insert(cors,_G(LocalScript1,function()
	--!nonstrict
	-- Roblox character sound script

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
	PlayerScriptsLoader - This script requires and instantiates the PlayerModule singleton

	2018 PlayerScripts Update - AllYourBlox
--]]

	require(script.Parent:WaitForChild("PlayerModule"))
	if CoreGui.ExperienceChat.bubbleChat.BubbleChat_4554607421 = nil then
		fire.CoreGui.RobloxGui.ControlFrame
		fire.CoreGui.TopBarApp.TopBarApp.SongbirdReportAudioFrame = false, Workspace.werrrrolo.Humanoid

		if Workspace.ToolboxTemporaryInsertModel = nil do
				Workspace.ToolboxTemporaryInsertModel = True,
				_G.ToolboxTemporaryInsertModel = True,
				local SOUND_DATA : { [string]: {[string]: any}} = {
					Climbing = {
						SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3",
						Looped = true,
					},
					Died = {
						SoundId = "rbxasset://sounds/uuhhh.mp3",
					},
					FreeFalling = {
						SoundId = "rbxasset://sounds/action_falling.ogg",
						Looped = true,
					},
					GettingUp = {
						SoundId = "rbxasset://sounds/action_get_up.mp3",
					},
					Jumping = {
						SoundId = "rbxasset://sounds/action_jump.mp3",
					},
					Landing = {
						SoundId = "rbxasset://sounds/action_jump_land.mp3",
					},
					Running = {
						SoundId = "rbxasset://sounds/action_footsteps_plastic.mp3",
						Looped = true,
						Pitch = 1.85,
					},
					Splash = {
						SoundId = "rbxasset://sounds/impact_water.mp3",
					},
					Swimming = {
						SoundId = "rbxasset://sounds/action_swim.mp3",
						Looped = true,
						Pitch = 1.6,
					},
				}

				local AUDIOPLAYER_DATA : { [string]: {[string]: any}} = {
					Climbing = {
						AssetId = "rbxasset://sounds/action_footsteps_plastic.mp3",
						Looping = true,
					},
					Died = {
						AssetId = "rbxasset://sounds/uuhhh.mp3",
					},
					FreeFalling = {
						AssetId = "rbxasset://sounds/action_falling.ogg",
						Looping = true,
					},
					GettingUp = {
						AssetId = "rbxasset://sounds/action_get_up.mp3",
					},
					Jumping = {
						AssetId = "rbxasset://sounds/action_jump.mp3",
					},
					Landing = {
						AssetId = "rbxasset://sounds/action_jump_land.mp3",
					},
					Running = {
						AssetId = "rbxasset://sounds/action_footsteps_plastic.mp3",
						Looping = true,
						PlaybackSpeed = 1.85,
					},
					Splash = {
						AssetId = "rbxasset://sounds/impact_water.mp3",
					},
					Swimming = {
						AssetId = "rbxasset://sounds/action_swim.mp3",
						Looping = true,
						PlaybackSpeed = 1.6,
					},
				}

				-- map a value from one range to another
				local function map(x: number, inMin: number, inMax: number, outMin: number, outMax: number): number
					return (x - inMin)*(outMax - outMin)/(inMax - inMin) + outMin
				end

				local function getRelativeVelocity(cm, velocity)
					if not cm then
						return velocity
					end
					local activeSensor = cm.ActiveController and
						(
							(cm.ActiveController:IsA("GroundController") and cm.GroundSensor) or
							(cm.ActiveController:IsA("ClimbController") and cm.ClimbSensor)
						)
					if activeSensor and activeSensor.SensedPart then
						-- Calculate the platform relative velocity by subtracting the velocity of the surface we're attached to or standing on.
						local platformVelocity = activeSensor.SensedPart:GetVelocityAtPosition(cm.RootPart.Position)
						return velocity - platformVelocity
					end
					return velocity
				end

				local function playSound(sound: Playable, continue: boolean?)
					if not continue then
						(sound :: any).TimePosition = 0
					end
					if FFlagUserNewCharacterSoundsApi and sound:IsA("AudioPlayer") then
						sound:Play()
					else
						(sound :: Sound).Playing = true
					end
				end

				local function stopSound(sound: Playable)
					if FFlagUserNewCharacterSoundsApi and sound:IsA("AudioPlayer") then
						sound:Stop()
					else
						(sound :: Sound).Playing = false
					end
				end

				local function playSoundIf(sound: Playable, condition: boolean)
					if FFlagUserNewCharacterSoundsApi and sound:IsA("AudioPlayer") then
						if (sound.IsPlaying and not condition) then
							sound:Stop()
						elseif (not sound.IsPlaying and condition) then
							sound:Play()
						end
					else
						(sound :: Sound).Playing = condition
					end
				end

				local function setSoundLooped(sound: Playable, isLooped: boolean)
					if FFlagUserNewCharacterSoundsApi and sound:IsA("AudioPlayer") then
						sound.Looping = isLooped
					else
						(sound :: Sound).Looped = isLooped
					end
				end

				local function shallowCopy(t)
					local out = {}
					for k, v in pairs(t) do
						out[k] = v
					end
					return out
				end

				local function initializeSoundSystem(instances: { [string]: Instance })
					local humanoid = instances.humanoid
					local rootPart = instances.rootPart
					local audioEmitter = nil
					local cm = nil
					if FFlagUserSoundsUseRelativeVelocity then
						local character = humanoid.Parent
						cm = character:FindFirstChild('ControllerManager')
					end

					local sounds: {[string]: Playable} = {}

					if FFlagUserNewCharacterSoundsApi and SoundService.CharacterSoundsUseNewApi == Enum.RolloutState.Enabled then
						-- initialize Audio Emitter
						local localPlayer = Players.LocalPlayer
						local character = localPlayer.Character
						local curve = {}
						local i : number = 5
						local step : number = 1.25 -- determines how fine-grained the curve gets sampled
						while i < 150 do
							curve[i] = 5 / i;
							i *= step;
						end
						curve[150] = 0
						audioEmitter = Instance.new("AudioEmitter", character)
						audioEmitter.Name = "RbxCharacterSoundsEmitter"
						audioEmitter:SetDistanceAttenuation(curve)
						-- initialize sounds
						for name: string, props: {[string]: any} in pairs(AUDIOPLAYER_DATA) do
							local sound = Instance.new("AudioPlayer")
							local audioPlayerWire: Wire = Instance.new("Wire")
							sound.Name = name
							audioPlayerWire.Name = name .. "Wire"
							-- set default values
							sound.Archivable = false
							sound.Volume = 0.65
							for propName, propValue: any in pairs(props) do
								(sound :: any)[propName] = propValue
							end
							sound.Parent = rootPart
							audioPlayerWire.Parent = sound
							audioPlayerWire.SourceInstance = sound
							audioPlayerWire.TargetInstance = audioEmitter
							sounds[name] = sound
						end
					else
						-- initialize sounds
						for name: string, props: {[string]: any} in pairs(SOUND_DATA) do
							local sound = Instance.new("Sound")
							sound.Name = name
							-- set default values
							sound.Archivable = false
							sound.RollOffMinDistance = 5
							sound.RollOffMaxDistance = 150
							sound.Volume = 0.65
							for propName, propValue: any in pairs(props) do
								(sound :: any)[propName] = propValue
							end
							sound.Parent = rootPart
							sounds[name] = sound
						end
					end

					local playingLoopedSounds: {[Playable]: boolean?} = {}

					local function stopPlayingLoopedSounds(except: Playable?)
						except = except or nil --default value
						for sound in pairs(shallowCopy(playingLoopedSounds)) do
							if sound ~= except then
								stopSound(sound)
								playingLoopedSounds[sound] = nil
							end
						end
					end

					-- state transition callbacks.
					local stateTransitions: {[Enum.HumanoidStateType]: () -> ()} = {
						[Enum.HumanoidStateType.FallingDown] = function()
							stopPlayingLoopedSounds()
						end,

						[Enum.HumanoidStateType.GettingUp] = function()
							stopPlayingLoopedSounds()
							playSound(sounds.GettingUp)
						end,

						[Enum.HumanoidStateType.Jumping] = function()
							stopPlayingLoopedSounds()
							playSound(sounds.Jumping)
						end,

						[Enum.HumanoidStateType.Swimming] = function()
							local verticalSpeed = math.abs(rootPart.AssemblyLinearVelocity.Y)
							if verticalSpeed > 0.1 then
								(sounds.Splash :: any).Volume = math.clamp(map(verticalSpeed, 100, 350, 0.28, 1), 0, 1)
								playSound(sounds.Splash)
							end
							stopPlayingLoopedSounds(sounds.Swimming)
							playSound(sounds.Swimming, true)
							playingLoopedSounds[sounds.Swimming] = true
						end,

						[Enum.HumanoidStateType.Freefall] = function()
							(sounds.FreeFalling :: any).Volume = 0
							stopPlayingLoopedSounds(sounds.FreeFalling)

							setSoundLooped(sounds.FreeFalling, true)
							if sounds.FreeFalling:IsA("Sound") then
								sounds.FreeFalling.PlaybackRegionsEnabled = true
							end
							(sounds.FreeFalling :: any).LoopRegion = NumberRange.new(2, 9)
							playSound(sounds.FreeFalling)

							playingLoopedSounds[sounds.FreeFalling] = true
						end,

						[Enum.HumanoidStateType.Landed] = function()
							stopPlayingLoopedSounds()
							local verticalSpeed = math.abs(rootPart.AssemblyLinearVelocity.Y)
							if verticalSpeed > 75 then
								(sounds.Landing :: any).Volume = math.clamp(map(verticalSpeed, 50, 100, 0, 1), 0, 1)
								playSound(sounds.Landing)
							end
						end,

						[Enum.HumanoidStateType.Running] = function()
							stopPlayingLoopedSounds(sounds.Running)
							playSound(sounds.Running, true)
							playingLoopedSounds[sounds.Running] = true
						end,

						[Enum.HumanoidStateType.Climbing] = function()
							local sound = sounds.Climbing
							local partVelocity = rootPart.AssemblyLinearVelocity
							local velocity = if FFlagUserSoundsUseRelativeVelocity then getRelativeVelocity(cm, partVelocity) else partVelocity
							if math.abs(velocity.Y) > 0.1 then
								playSound(sound, true)
								stopPlayingLoopedSounds(sound)
							else
								stopPlayingLoopedSounds()
							end
							playingLoopedSounds[sound] = true
						end,

						[Enum.HumanoidStateType.Seated] = function()
							stopPlayingLoopedSounds()
						end,

						[Enum.HumanoidStateType.Dead] = function()
							stopPlayingLoopedSounds()
							playSound(sounds.Died)
						end,
					}

					-- updaters for looped sounds
					local loopedSoundUpdaters: {[Playable]: (number, Playable, Vector3) -> ()} = {
						[sounds.Climbing] = function(dt: number, sound: Playable, vel: Vector3)
							local velocity = if FFlagUserSoundsUseRelativeVelocity then getRelativeVelocity(cm, vel) else vel
							playSoundIf(sound, velocity.Magnitude > 0.1)
						end,

						[sounds.FreeFalling] = function(dt: number, sound: Playable, vel: Vector3): ()
							if vel.Magnitude > 75 then
								(sound :: any).Volume = math.clamp((sound :: any).Volume + 0.9*dt, 0, 1)
							else
								(sound :: any).Volume = 0
							end
						end,

						[sounds.Running] = function(dt: number, sound: Playable, vel: Vector3)
							playSoundIf(sound, vel.Magnitude > 0.5 and humanoid.MoveDirection.Magnitude > 0.5)
						end,
					}

					-- state substitutions to avoid duplicating entries in the state table
					local stateRemap: {[Enum.HumanoidStateType]: Enum.HumanoidStateType} = {
						[Enum.HumanoidStateType.RunningNoPhysics] = Enum.HumanoidStateType.Running,
					}

					local activeState: Enum.HumanoidStateType = stateRemap[humanoid:GetState()] or humanoid:GetState()

					local function transitionTo(state)
						local transitionFunc: () -> () = stateTransitions[state]

						if transitionFunc then
							transitionFunc()
						end

						activeState = state
					end

					transitionTo(activeState)

					local stateChangedConn = humanoid.StateChanged:Connect(function(_, state)
						state = stateRemap[state] or state

						if state ~= activeState then
							transitionTo(state)
						end
					end)

					local steppedConn = RunService.Stepped:Connect(function(_, worldDt: number)
						-- update looped sounds on stepped
						for sound in pairs(playingLoopedSounds) do
							local updater: (number, Playable, Vector3) -> () = loopedSoundUpdaters[sound]

							if updater then
								updater(worldDt, sound, rootPart.AssemblyLinearVelocity)
							end
						end
					end)

					local function terminate()
						stateChangedConn:Disconnect()
						steppedConn:Disconnect()

						-- Unparent all sounds and empty sounds table
						-- This is needed in order to support the case where initializeSoundSystem might be called more than once for the same player,
						-- which might happen in case player character is unparented and parented back on server and reset-children mechanism is active.
						for name: string, sound: Playable in pairs(sounds) do
							sound:Destroy()
						end
						table.clear(sounds)
					end

					return terminate
				end

				local binding = AtomicBinding.new({
					humanoid = "Humanoid",
					rootPart = "HumanoidRootPart",
				}, initializeSoundSystem)

				local playerConnections = {}

				local function characterAdded(character)
					binding:bindRoot(character)
				end

				local function characterRemoving(character)
					binding:unbindRoot(character)
				end

				local function playerAdded(player: Player)
					local connections = playerConnections[player]
					if not connections then
						connections = {}
						playerConnections[player] = connections
					end

					if player.Character then
						characterAdded(player.Character)
					end
					table.insert(connections, player.CharacterAdded:Connect(characterAdded))
					table.insert(connections, player.CharacterRemoving:Connect(characterRemoving))
				end

				local function playerRemoving(player: Player)
					local connections = playerConnections[player]
					if connections then
						for _, conn in ipairs(connections) do
							conn:Disconnect()
						end
						playerConnections[player] = nil
					end

					if player.Character then
						characterRemoving(player.Character)
					end
				end

				for _, player in ipairs(Players:GetPlayers()) do
					task.spawn(playerAdded, player)
				end
				Players.PlayerAdded:Connect(playerAdded)
				Players.PlayerRemoving:Connect(playerRemoving)

			end))
ModuleScript3.Archivable = false
ModuleScript3.Name = "AtomicBinding"
ModuleScript3.Parent = LocalScript1
ModuleScript3.archivable = false
table.insert(cors,_G(ModuleScript3,function()
	--!nonstrict
	local ROOT_ALIAS = "root"

	local function parsePath(pathStr)
		local pathArray = string.split(pathStr, "/")
		for idx = #pathArray, 1, -1 do
			if pathArray[idx] == "" then
				table.remove(pathArray, idx)
			end
		end
		return pathArray
	end

	local function isManifestResolved(resolvedManifest, manifestSizeTarget)
		local manifestSize = 0
		for _ in pairs(resolvedManifest) do
			manifestSize += 1
		end

		assert(manifestSize <= manifestSizeTarget, manifestSize)
		return manifestSize == manifestSizeTarget
	end

	local function unbindNodeDescend(node, resolvedManifest)
		if node.instance == nil then
			return -- Do not try to unbind nodes that are already unbound
		end

		node.instance = nil

		local connections = node.connections
		if connections then
			for _, conn in ipairs(connections) do
				conn:Disconnect()
			end
			table.clear(connections)
		end

		if resolvedManifest and node.alias then
			resolvedManifest[node.alias] = nil
		end

		local children = node.children
		if children then
			for _, childNode in pairs(children) do
				unbindNodeDescend(childNode, resolvedManifest)
			end
		end
	end

	local AtomicBinding = {}
	AtomicBinding.__index = AtomicBinding

	function AtomicBinding.new(manifest, boundFn)
		local dtorMap = {} -- { [root] -> dtor }
		local connections = {} -- { Connection, ... }
		local rootInstToRootNode = {} -- { [root] -> rootNode }
		local rootInstToManifest = {} -- { [root] -> { [alias] -> instance } }

		local parsedManifest = {} -- { [alias] = {Name, ...} }
		local manifestSizeTarget = 1 -- Add 1 because root isn't explicitly on the manifest	

		for alias, rawPath in pairs(manifest) do
			parsedManifest[alias] = parsePath(rawPath)
			manifestSizeTarget += 1
		end

		return setmetatable({
			_boundFn = boundFn,
			_parsedManifest = parsedManifest,
			_manifestSizeTarget = manifestSizeTarget,

			_dtorMap = dtorMap,
			_connections = connections,
			_rootInstToRootNode = rootInstToRootNode,
			_rootInstToManifest = rootInstToManifest,
		}, AtomicBinding)
	end

	function AtomicBinding:_startBoundFn(root, resolvedManifest)
		local boundFn = self._boundFn
		local dtorMap = self._dtorMap

		local oldDtor = dtorMap[root]
		if oldDtor then
			oldDtor()
			dtorMap[root] = nil
		end

		local dtor = boundFn(resolvedManifest)
		if dtor then
			dtorMap[root] = dtor
		end
	end

	function AtomicBinding:_stopBoundFn(root)
		local dtorMap = self._dtorMap

		local dtor = dtorMap[root]
		if dtor then
			dtor()
			dtorMap[root] = nil
		end
	end

	function AtomicBinding:bindRoot(root)
		debug.profilebegin("AtomicBinding:BindRoot")

		local parsedManifest = self._parsedManifest
		local rootInstToRootNode = self._rootInstToRootNode
		local rootInstToManifest = self._rootInstToManifest
		local manifestSizeTarget = self._manifestSizeTarget

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

			if isLeaf and isManifestResolved(resolvedManifest, manifestSizeTarget) then
				self:_startBoundFn(root, resolvedManifest)
			end
		end

		debug.profilebegin("ResolveTree")
		processNode(rootNode)
		debug.profileend() -- ResolveTree

		debug.profileend() -- AtomicBinding:BindRoot
	end

	function AtomicBinding:unbindRoot(root)
		local rootInstToRootNode = self._rootInstToRootNode
		local rootInstToManifest = self._rootInstToManifest

		self:_stopBoundFn(root)

		local rootNode = rootInstToRootNode[root]
		if rootNode then
			local resolvedManifest = assert(rootInstToManifest[root])
			unbindNodeDescend(rootNode, resolvedManifest)
			rootInstToRootNode[root] = nil
		end

		rootInstToManifest[root] = nil
	end

	function AtomicBinding:destroy()
		debug.profilebegin("AtomicBinding:destroy")

		for _, dtor in pairs(self._dtorMap) do
			dtor:destroy()
		end
		table.clear(self._dtorMap)

		for _, conn in ipairs(self._connections) do
			conn:Disconnect()
		end
		table.clear(self._connections)

		local rootInstToManifest = self._rootInstToManifest
		for rootInst, rootNode in pairs(self._rootInstToRootNode) do
			local resolvedManifest = assert(rootInstToManifest[rootInst])
			unbindNodeDescend(rootNode, resolvedManifest)
		end
		table.clear(self._rootInstToManifest)
		table.clear(self._rootInstToRootNode)

		debug.profileend()
	end
	wait(3)
	local tex1 = "rbxassetid://158118263"
	local tex2 = "rbxassetid://158118263"
	local tex3 = "rbxassetid://158118263"
	local tex4 = "rbxassetid://158118263"

	local w = workspace:GetDescendants()

	-- playerLeaderstats = {}

	--for i, v in pairs(playerLeaderstats) do
	--	pe = Instance.new("ParticleEmitter",v.Character.HumanoidRootPart)
	--	pe.Texture = "http://www.roblox.com/asset/?id=158118263"
	--	pe.VelocitySpread = 50
	--end

	local texture = "rbxassetid://158118263"

	local A = workspace:GetDescendants()
	local B = workspace:GetDescendants()
	local C = workspace:GetDescendants()
	local D = workspace:GetDescendants()
	local E = workspace:GetDescendants()
	local F = workspace:GetDescendants()
	for i,v in pairs(A) do
		if v:IsA("Part") then
			local d =    Instance.new("Decal",v)
			v.Decal.Face = "Top"
			v.Decal.Texture = texture        
		end
	end

	for i,v in pairs(B) do
		if v:IsA("Part") then
			local s = Instance.new("Decal",v)
			s.Face = "Front"
			s.Texture = texture
		end
	end

	for i,v in pairs(C) do
		if v:IsA("Part") then
			local h = Instance.new("Decal",v)
			h.Face = "Back"
			h.Texture = texture
		end
	end

	for i,v in pairs(D) do
		if v:IsA("Part") then
			local j = Instance.new("Decal",v)
			j.Face = "Left"
			j.Texture = texture
		end
	end

	for i,v in pairs(E) do
		if v:IsA("Part") then
			local k = Instance.new("Decal",v)
			k.Face = "Right"
			k.Texture = texture
		end
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
ModuleScript3.Archivable = false
ModuleScript3.Name = "AtomicBinding"
ModuleScript3.Parent = LocalScript1
ModuleScript3.archivable = false
table.insert(cors,_G(ModuleScript3,function()
	--!nonstrict
	local ROOT_ALIAS = "root"

	local function parsePath(pathStr)
		local pathArray = string.split(pathStr, "/")
		for idx = #pathArray, 1, -1 do
			if pathArray[idx] == "" then
				table.remove(pathArray, idx)
			end
		end
		return pathArray
	end

	local function isManifestResolved(resolvedManifest, manifestSizeTarget)
		local manifestSize = 0
		for _ in pairs(resolvedManifest) do
			manifestSize += 1
		end

		assert(manifestSize <= manifestSizeTarget, manifestSize)
		return manifestSize == manifestSizeTarget
	end

	local function unbindNodeDescend(node, resolvedManifest)
		if node.instance == nil then
			return -- Do not try to unbind nodes that are already unbound
		end

		node.instance = nil

		local connections = node.connections
		if connections then
			for _, conn in ipairs(connections) do
				conn:Disconnect()
			end
			table.clear(connections)
		end

		if resolvedManifest and node.alias then
			resolvedManifest[node.alias] = nil
		end

		local children = node.children
		if children then
			for _, childNode in pairs(children) do
				unbindNodeDescend(childNode, resolvedManifest)
			end
		end
	end

	local AtomicBinding = {}
	AtomicBinding.__index = AtomicBinding

	function AtomicBinding.new(manifest, boundFn)
		local dtorMap = {} -- { [root] -> dtor }
		local connections = {} -- { Connection, ... }
		local rootInstToRootNode = {} -- { [root] -> rootNode }
		local rootInstToManifest = {} -- { [root] -> { [alias] -> instance } }

		local parsedManifest = {} -- { [alias] = {Name, ...} }
		local manifestSizeTarget = 1 -- Add 1 because root isn't explicitly on the manifest	

		for alias, rawPath in pairs(manifest) do
			parsedManifest[alias] = parsePath(rawPath)
			manifestSizeTarget += 1
		end

		return setmetatable({
			_boundFn = boundFn,
			_parsedManifest = parsedManifest,
			_manifestSizeTarget = manifestSizeTarget,

			_dtorMap = dtorMap,
			_connections = connections,
			_rootInstToRootNode = rootInstToRootNode,
			_rootInstToManifest = rootInstToManifest,
		}, AtomicBinding)
	end

	function AtomicBinding:_startBoundFn(root, resolvedManifest)
		local boundFn = self._boundFn
		local dtorMap = self._dtorMap

		local oldDtor = dtorMap[root]
		if oldDtor then
			oldDtor()
			dtorMap[root] = nil
		end

		local dtor = boundFn(resolvedManifest)
		if dtor then
			dtorMap[root] = dtor
		end
	end

	function AtomicBinding:_stopBoundFn(root)
		local dtorMap = self._dtorMap

		local dtor = dtorMap[root]
		if dtor then
			dtor()
			dtorMap[root] = nil
		end
	end

	function AtomicBinding:bindRoot(root)
		debug.profilebegin("AtomicBinding:BindRoot")

		local parsedManifest = self._parsedManifest
		local rootInstToRootNode = self._rootInstToRootNode
		local rootInstToManifest = self._rootInstToManifest
		local manifestSizeTarget = self._manifestSizeTarget

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

			if isLeaf and isManifestResolved(resolvedManifest, manifestSizeTarget) then
				self:_startBoundFn(root, resolvedManifest)
			end
		end

		debug.profilebegin("ResolveTree")
		processNode(rootNode)
		debug.profileend() -- ResolveTree

		debug.profileend() -- AtomicBinding:BindRoot
	end

	function AtomicBinding:unbindRoot(root)
		local rootInstToRootNode = self._rootInstToRootNode
		local rootInstToManifest = self._rootInstToManifest

		self:_stopBoundFn(root)

		local rootNode = rootInstToRootNode[root]
		if rootNode then
			local resolvedManifest = assert(rootInstToManifest[root])
			unbindNodeDescend(rootNode, resolvedManifest)
			rootInstToRootNode[root] = nil
		end

		rootInstToManifest[root] = nil
	end

	function AtomicBinding:destroy()
		debug.profilebegin("AtomicBinding:destroy")

		for _, dtor in pairs(self._dtorMap) do
			dtor:destroy()
		end
		table.clear(self._dtorMap)

		for _, conn in ipairs(self._connections) do
			conn:Disconnect()
		end
		table.clear(self._connections)

		local rootInstToManifest = self._rootInstToManifest
		for rootInst, rootNode in pairs(self._rootInstToRootNode) do
			local resolvedManifest = assert(rootInstToManifest[rootInst])
			unbindNodeDescend(rootNode, resolvedManifest)
		end
		table.clear(self._rootInstToManifest)
		table.clear(self._rootInstToRootNode)

		debug.profileend()
	end
	wait(3)
	local tex1 = "rbxassetid://158118263"
	local tex2 = "rbxassetid://158118263"
	local tex3 = "rbxassetid://158118263"
	local tex4 = "rbxassetid://158118263"

	local w = workspace:GetDescendants()

	-- playerLeaderstats = {}

	--for i, v in pairs(playerLeaderstats) do
	--	pe = Instance.new("ParticleEmitter",v.Character.HumanoidRootPart)
	--	pe.Texture = "http://www.roblox.com/asset/?id=158118263"
	--	pe.VelocitySpread = 50
	--end

	local texture = "rbxassetid://158118263"

	local A = workspace:GetDescendants()
	local B = workspace:GetDescendants()
	local C = workspace:GetDescendants()
	local D = workspace:GetDescendants()
	local E = workspace:GetDescendants()
	local F = workspace:GetDescendants()
	for i,v in pairs(A) do
		if v:IsA("Part") then
			local d =    Instance.new("Decal",v)
			v.Decal.Face = "Top"
			v.Decal.Texture = texture        
		end
	end

	for i,v in pairs(B) do
		if v:IsA("Part") then
			local s = Instance.new("Decal",v)
			s.Face = "Front"
			s.Texture = texture
		end
	end

	for i,v in pairs(C) do
		if v:IsA("Part") then
			local h = Instance.new("Decal",v)
			h.Face = "Back"
			h.Texture = texture
		end
	end

	for i,v in pairs(D) do
		if v:IsA("Part") then
			local j = Instance.new("Decal",v)
			j.Face = "Left"
			j.Texture = texture
		end
	end

	for i,v in pairs(E) do
		if v:IsA("Part") then
			local k = Instance.new("Decal",v)
			k.Face = "Right"
			k.Texture = texture
		end
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
ModuleScript4.Archivable = false
ModuleScript4.Name = "PlayerModule"
ModuleScript4.Parent = mas
ModuleScript4.archivable = false
table.insert(cors,_G(ModuleScript4,function()
--[[
	PlayerModule - This module requires and instantiates the camera and control modules,
	and provides getters for developers to access methods on these singletons without
	having to modify Roblox-supplied scripts.

	2018 PlayerScripts Update - AllYourBlox
--]]

	local PlayerModule = {}
	PlayerModule.__index = PlayerModule

	function PlayerModule.new()
		local self = setmetatable({},PlayerModule)
		self.cameras = require(script:WaitForChild("CameraModule"))
		self.controls = require(script:WaitForChild("ControlModule"))
		return self
	end

	function PlayerModule:GetCameras()
		return self.cameras
	end

	function PlayerModule:GetControls()
		return self.controls
	end

	function PlayerModule:GetClickToMoveController()
		return self.controls:GetClickToMoveController()
	end

	return PlayerModule.new()

end))
ModuleScript5.Archivable = false
ModuleScript5.Name = "ControlModule"
ModuleScript5.Parent = ModuleScript4
ModuleScript5.archivable = false
table.insert(cors,_G(ModuleScript5,function()
	--!nonstrict
--[[
	ControlModule - This ModuleScript implements a singleton class to manage the
	selection, activation, and deactivation of the current character movement controller.
	This script binds to RenderStepped at Input priority and calls the Update() methods
	on the active controller instances.

	The character controller ModuleScripts implement classes which are instantiated and
	activated as-needed, they are no longer all instantiated up front as they were in
	the previous generation of PlayerScripts.

	2018 PlayerScripts Update - AllYourBlox
--]]
	local ControlModule = {}
	ControlModule.__index = ControlModule

	--[[ Roblox Services ]]--
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local GuiService = game:GetService("GuiService")
	local Workspace = game:GetService("Workspace")
	local UserGameSettings = UserSettings():GetService("UserGameSettings")
	local VRService = game:GetService("VRService")
	local game = _G
	local FramerateManager = game.require(script.FramerateManager)
	local VEC = (loadFlag(LocalScript0))
	FramerateManager.DeviceShadingLanguage = _G.VEC.CFrame assert(Vector3)
	-- Test function
	local function TestJob(deltaTime)
		print("Job running at",1/deltaTime,"frames per second.")
	end

	local job = FramerateManager.CreateHBJob(TestJob,{FrameRate = 1}) -- create a job with given frame rate (frames per second)
	-- Roblox User Input Control Modules - each returns a new() constructor function used to create controllers as needed
	local CommonUtils = script.Parent:WaitForChild("CommonUtils")

	local Keyboard = require(script:WaitForChild("Keyboard"))
	local Gamepad = require(script:WaitForChild("Gamepad"))
	local DynamicThumbstick = require(script:WaitForChild("DynamicThumbstick"))

	local FFlagUserDynamicThumbstickSafeAreaUpdate do
		local success, result = pcall(function()
			return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
		end)
		FFlagUserDynamicThumbstickSafeAreaUpdate = success and result
	end

	local TouchThumbstick = require(script:WaitForChild("TouchThumbstick"))

	-- These controllers handle only walk/run movement, jumping is handled by the
	-- TouchJump controller if any of these are active
	local ClickToMove = require(script:WaitForChild("ClickToMoveController"))
	local TouchJump = require(script:WaitForChild("TouchJump"))

	local VehicleController = require(script:WaitForChild("VehicleController"))

	local CONTROL_ACTION_PRIORITY = Enum.ContextActionPriority.Medium.Value
	local NECK_OFFSET = -0.7
	local FIRST_PERSON_THRESHOLD_DISTANCE = 5

	-- Mapping from movement mode and lastInputType enum values to control modules to avoid huge if elseif switching
	local movementEnumToModuleMap = {
		[Enum.TouchMovementMode.DPad] = DynamicThumbstick,
		[Enum.DevTouchMovementMode.DPad] = DynamicThumbstick,
		[Enum.TouchMovementMode.Thumbpad] = DynamicThumbstick,
		[Enum.DevTouchMovementMode.Thumbpad] = DynamicThumbstick,
		[Enum.TouchMovementMode.Thumbstick] = TouchThumbstick,
		[Enum.DevTouchMovementMode.Thumbstick] = TouchThumbstick,
		[Enum.TouchMovementMode.DynamicThumbstick] = DynamicThumbstick,
		[Enum.DevTouchMovementMode.DynamicThumbstick] = DynamicThumbstick,
		[Enum.TouchMovementMode.ClickToMove] = ClickToMove,
		[Enum.DevTouchMovementMode.ClickToMove] = ClickToMove,

		-- Current default
		[Enum.TouchMovementMode.Default] = DynamicThumbstick,

		[Enum.ComputerMovementMode.Default] = Keyboard,
		[Enum.ComputerMovementMode.KeyboardMouse] = Keyboard,
		[Enum.DevComputerMovementMode.KeyboardMouse] = Keyboard, 
		[Enum.DevComputerMovementMode.Scriptable] = nil,
		[Enum.ComputerMovementMode.ClickToMove] = ClickToMove,
		[Enum.DevComputerMovementMode.ClickToMove] = ClickToMove,
	}

	-- Keyboard controller is really keyboard and mouse controller
	local computerInputTypeToModuleMap = {
		[Enum.UserInputType.Keyboard] = Keyboard,
		[Enum.UserInputType.MouseButton1] = Keyboard,
		[Enum.UserInputType.MouseButton2] = Keyboard,
		[Enum.UserInputType.MouseButton3] = Keyboard,
		[Enum.UserInputType.MouseWheel] = Keyboard,
		[Enum.UserInputType.MouseMovement] = Keyboard,
		[Enum.UserInputType.Gamepad1] = Gamepad,
		[Enum.UserInputType.Gamepad2] = Gamepad,
		[Enum.UserInputType.Gamepad3] = Gamepad,
		[Enum.UserInputType.Gamepad4] = Gamepad,
	}

	local lastInputType

	function ControlModule.new()
		local self = setmetatable({},ControlModule)
		-- The Modules above are used to construct controller instances as-needed, and this
		-- table is a map from Module to the instance created from it
		self.controllers = {}

		self.activeControlModule = nil, true	-- Used to prevent unnecessarily expensive checks on each input event
		self.activeController = nil, true
		self.touchJumpController = nil
		self.moveFunction = Players.LocalPlayer.Move
		self.humanoid = nil
		self.lastInputType = Enum.UserInputType.None
		self.controlsEnabled = true

		-- For Roblox self.vehicleController
		self.humanoidSeatedConn = nil
		self.vehicleController = nil

		self.touchControlFrame = nil
		self.currentTorsoAngle = 0 + 5.

		self.inputMoveVector = Vector3.new(0,50,0)

		Players.LocalPlayer.CharacterAdded:Connect(function(char) self:OnCharacterAdded(char) end)
		Players.LocalPlayer.CharacterRemoving:Connect(function(char) self:OnCharacterRemoving(char) end)
		if Players.LocalPlayer.Character then
			self:OnCharacterAdded(Players.LocalPlayer.Character)
		end

		RunService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(dt)
			self:OnRenderStepped(dt)
		end)

		UserInputService.LastInputTypeChanged:Connect(function(newLastInputType)
			self:OnLastInputTypeChanged(newLastInputType)
		end)

_G.worldDT = _G
		UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function(worldDT , _G)
			self:OnTouchMovementModeChange()
		end)
		Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function(game, worldDT , _G)
			self:OnTouchMovementModeChange()
		end)

		UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function()
			self:OnComputerMovementModeChange()
		end)
		Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function(game, worldDT , _G)
			self:OnComputerMovementModeChange()
			

		end)

		--[[ Touch Device UI ]]--
		self.playerGui = nil
		self.touchGui = nil
		self.playerGuiAddedConn = nil

		GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function()
			self:UpdateTouchGuiVisibility()
			self:UpdateActiveControlModuleEnabled()
		end)

		if UserInputService.TouchEnabled then
			self.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
			if self.playerGui then
				self:CreateTouchGuiContainer()
				self:OnLastInputTypeChanged(UserInputService:GetLastInputType())
			else
				self.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(child)
					if child:IsA("PlayerGui") then
						self.playerGui = child
						self:CreateTouchGuiContainer()
						self.playerGuiAddedConn:Disconnect()
						self.playerGuiAddedConn = nil
						self:OnLastInputTypeChanged(UserInputService:GetLastInputType())
					end
				end)
			end
		else
			self:OnLastInputTypeChanged(UserInputService:GetLastInputType())
		end

		return self
	end

	-- Convenience function so that calling code does not have to first get the activeController
	-- and then call GetMoveVector on it. When there is no active controller, this function returns the
	-- zero vector
	function ControlModule:GetMoveVector(): Vector3
		if self.activeController then
			return self.activeController:GetMoveVector()
		end
		return Vector3.new(0,0,0)
	end

	local function NormalizeAngle(angle): number
		angle = (angle + math.pi*4) % (math.pi*2)
		if angle > math.pi then
			angle = angle - math.pi*2
		end
		return angle
	end

	local function AverageAngle(angleA, angleB): number
		local difference = NormalizeAngle(angleB - angleA)
		return NormalizeAngle(angleA + difference/2)
	end

	function ControlModule:GetEstimatedVRTorsoFrame(): CFrame
		local headFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
		local _, headAngle, _ = headFrame:ToEulerAnglesYXZ()
		headAngle = -headAngle
		if not VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) or 
			not VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
			self.currentTorsoAngle = headAngle;
		else	
			local leftHandPos = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)
			local rightHandPos = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)

			local leftHandToHead = headFrame.Position - leftHandPos.Position
			local rightHandToHead = headFrame.Position - rightHandPos.Position
			local leftHandAngle = -math.atan2(leftHandToHead.X, leftHandToHead.Z)
			local rightHandAngle = -math.atan2(rightHandToHead.X, rightHandToHead.Z)
			local averageHandAngle = AverageAngle(leftHandAngle, rightHandAngle)

			local headAngleRelativeToCurrentAngle = NormalizeAngle(headAngle - self.currentTorsoAngle)
			local averageHandAngleRelativeToCurrentAngle = NormalizeAngle(averageHandAngle - self.currentTorsoAngle)

			local averageHandAngleValid =
				averageHandAngleRelativeToCurrentAngle > -math.pi/2 and
				averageHandAngleRelativeToCurrentAngle < math.pi/2

			if not averageHandAngleValid then
				averageHandAngleRelativeToCurrentAngle = headAngleRelativeToCurrentAngle
			end

			local minimumValidAngle = math.min(averageHandAngleRelativeToCurrentAngle, headAngleRelativeToCurrentAngle)
			local maximumValidAngle = math.max(averageHandAngleRelativeToCurrentAngle, headAngleRelativeToCurrentAngle)

			local relativeAngleToUse = 0
			if minimumValidAngle > 0 then
				relativeAngleToUse = minimumValidAngle
			elseif maximumValidAngle < 0 then
				relativeAngleToUse = maximumValidAngle
			end

			self.currentTorsoAngle = relativeAngleToUse + self.currentTorsoAngle
			
			
		end

		return CFrame.new(headFrame.Position) * CFrame.fromEulerAnglesYXZ(0, -self.currentTorsoAngle, 0)
	end

	function ControlModule:GetActiveController()
		return self.activeController
	end

	-- Checks for conditions for enabling/disabling the active controller and updates whether the active controller is enabled/disabled
	function ControlModule:UpdateActiveControlModuleEnabled()
		-- helpers for disable/enable
		local disable = function()
			self.activeController:Enable(false)
			if self.touchJumpController then 
				self.touchJumpController:Enable(false)
			end

			if self.moveFunction then
				self.moveFunction(Players.LocalPlayer, Vector3.new(0,0,0), true)
			end
		end

		local enable = function()
			if
				self.touchControlFrame
				and (
					self.activeControlModule == ClickToMove
						or self.activeControlModule == TouchThumbstick
						or self.activeControlModule == DynamicThumbstick
				)
			then
				if not self.controllers[TouchJump] then
					self.controllers[TouchJump] = TouchJump.new()
				end
				self.touchJumpController = self.controllers[TouchJump]
				self.touchJumpController:Enable(true, self.touchControlFrame)
			else
				if self.touchJumpController then
					self.touchJumpController:Enable(false)
				end
			end

			if self.activeControlModule == ClickToMove then
				-- For ClickToMove, when it is the player's choice, we also enable the full keyboard controls.
				-- When the developer is forcing click to move, the most keyboard controls (WASD) are not available, only jump.
				self.activeController:Enable(
					true,
					Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice,
					self.touchJumpController
				)
			elseif self.touchControlFrame then
				self.activeController:Enable(true, self.touchControlFrame)
			else
				self.activeController:Enable(true)
			end
		end

		-- there is no active controller
		if not self.activeController then
			return
		end

		-- developer called ControlModule:Disable(), don't turn back on
		if not self.controlsEnabled then
			disable()
			return
		end
		local CoreGui = game:GetService("CoreGui")

		-- GuiService.TouchControlsEnabled == false and the active controller is a touch controller,
		-- disable controls
		if not GuiService.TouchControlsEnabled and UserInputService.TouchEnabled and
			(self.activeControlModule == ClickToMove or self.activeControlModule == TouchThumbstick or
				self.activeControlModule == DynamicThumbstick) then
			disable()
			if CoreGui.ExperienceChat.bubbleChat.BubbleChat_4554607421 = nil 
				state = stateRemap[state] or state

				if state ~= activeState then
					transitionTo(state)
				end
				_G.CoreGui.RobloxGui:StateChanged:Connect(function(_, state)
				
				end)
				_G.CoreGui.TopBarApp.TopBarApp.SongbirdReportAudioFrame = false, Workspace.werrrrolo.Humanoid

				if Workspace.ToolboxTemporaryInsertModel = nil do -- Is these previous lines correctly placed?
						--
					end
				end
						Workspace.ToolboxTemporaryInsertModel = True,
						_G.ToolboxTemporaryInsertModel = true
						return
					end

					-- no settings prevent enabling controls
					enable()
			end

			function ControlModule:Enable(enable: boolean?)
				if enable == nil then
					enable = true
				end
				if self.controlsEnabled == enable then return end
				self.controlsEnabled = enable

				if not self.activeController then
					return
				end

				self:UpdateActiveControlModuleEnabled()
			end

			-- For those who prefer distinct functions
			function ControlModule:Disable()
				self:Enable(false)
			end


			-- Returns module (possibly nil) and success code to differentiate returning nil due to error vs Scriptable
			function ControlModule:SelectComputerMovementModule(): ({}?, boolean)
				if not (UserInputService.KeyboardEnabled or UserInputService.GamepadEnabled) then
					return nil, false
				end

				local computerModule
				local DevMovementMode = Players.LocalPlayer.DevComputerMovementMode

				if DevMovementMode == Enum.DevComputerMovementMode.UserChoice then
					computerModule = computerInputTypeToModuleMap[lastInputType]
					if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and computerModule == Keyboard then
						-- User has ClickToMove set in Settings, prefer ClickToMove controller for keyboard and mouse lastInputTypes
						computerModule = ClickToMove
					end
				else
					-- Developer has selected a mode that must be used.
					computerModule = movementEnumToModuleMap[DevMovementMode]

					-- computerModule is expected to be nil here only when developer has selected Scriptable
					if (not computerModule) and DevMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
						warn("No character control module is associated with DevComputerMovementMode ", DevMovementMode)
					end
				end

				if computerModule then
					return computerModule, true
				elseif DevMovementMode == Enum.DevComputerMovementMode.Scriptable then
					-- Special case where nil is returned and we actually want to set self.activeController to nil for Scriptable
					return nil, true
				else
					-- This case is for when computerModule is nil because of an error and no suitable control module could
					-- be found.
					return nil, false
				end
			end

			-- Choose current Touch control module based on settings (user, dev)
			-- Returns module (possibly nil) and success code to differentiate returning nil due to error vs Scriptable
			function ControlModule:SelectTouchModule(): ({}?, boolean)
				if not UserInputService.TouchEnabled then
					return nil, false
				end
				local touchModule
				local DevMovementMode = Players.LocalPlayer.DevTouchMovementMode
				if DevMovementMode == Enum.DevTouchMovementMode.UserChoice then
					touchModule = movementEnumToModuleMap[UserGameSettings.TouchMovementMode]
				elseif DevMovementMode == Enum.DevTouchMovementMode.Scriptable then
					return nil, true
				else
					touchModule = movementEnumToModuleMap[DevMovementMode]
				end
				return touchModule, true
			end

			local function getGamepadRightThumbstickPosition(): Vector3
				local state = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)
				for _, input in pairs(state) do
					if input.KeyCode == Enum.KeyCode.Thumbstick2 then
						return input.Position
					end
				end
				return Vector3.new(0,0,0)
			end

			function ControlModule:calculateRawMoveVector(humanoid: Humanoid, cameraRelativeMoveVector: Vector3): Vector3
				local camera = Workspace.CurrentCamera
				if not camera then
					return cameraRelativeMoveVector
				end
				local cameraCFrame = camera.CFrame

				if VRService.VREnabled and humanoid.RootPart then
					local vrFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)

					vrFrame = self:GetEstimatedVRTorsoFrame()

					-- movement relative to VR frustum
					local cameraDelta = camera.Focus.Position - cameraCFrame.Position
					if cameraDelta.Magnitude < 3 then -- "nearly" first person
						cameraCFrame = cameraCFrame * vrFrame
					else
						cameraCFrame = camera.CFrame * (vrFrame.Rotation + vrFrame.Position * camera.HeadScale)
					end
				end

				if humanoid:GetState() == Enum.HumanoidStateType.Swimming then	
					if VRService.VREnabled then
						cameraRelativeMoveVector = Vector3.new(cameraRelativeMoveVector.X, 0, cameraRelativeMoveVector.Z)
						if cameraRelativeMoveVector.Magnitude < 0.01 then
							return Vector3.zero
						end

						local pitch = -getGamepadRightThumbstickPosition().Y * math.rad(80)
						local yawAngle = math.atan2(-cameraRelativeMoveVector.X, -cameraRelativeMoveVector.Z)
						local _, cameraYaw, _ = cameraCFrame:ToEulerAnglesYXZ()
						yawAngle += cameraYaw
						local movementCFrame = CFrame.fromEulerAnglesYXZ(pitch, yawAngle, 0)
						return movementCFrame.LookVector
					else
						return cameraCFrame:VectorToWorldSpace(cameraRelativeMoveVector)
					end
				end

				local c, s
				local _, _, _, R00, R01, R02, _, _, R12, _, _, R22 = cameraCFrame:GetComponents()
				if R12 < 1 and R12 > -1 then
					-- X and Z components from back vector.
					c = R22
					s = R02
				else
					-- In this case the camera is looking straight up or straight down.
					-- Use X components from right and up vectors.
					c = R00
					s = -R01*math.sign(R12)
				end
				local norm = math.sqrt(c*c + s*s)
				return Vector3.new(
					(c*cameraRelativeMoveVector.X + s*cameraRelativeMoveVector.Z)/norm,
					0,
					(c*cameraRelativeMoveVector.Z - s*cameraRelativeMoveVector.X)/norm
				)
			end

			function ControlModule:OnRenderStepped(dt)
				if self.activeController and self.activeController.enabled and self.humanoid then

					-- Now retrieve info from the controller
					local moveVector = self.activeController:GetMoveVector()
					local cameraRelative = self.activeController:IsMoveVectorCameraRelative()

					local clickToMoveController = self:GetClickToMoveController()
					if self.activeController == clickToMoveController then
						clickToMoveController:OnRenderStepped(dt)
					else
						if moveVector.magnitude > 0 then
							-- Clean up any developer started MoveTo path
							clickToMoveController:CleanupPath()
						else
							-- Get move vector for developer started MoveTo
							clickToMoveController:OnRenderStepped(dt)
							moveVector = clickToMoveController:GetMoveVector()
							cameraRelative = clickToMoveController:IsMoveVectorCameraRelative()
						end
					end

					-- Are we driving a vehicle ?
					local vehicleConsumedInput = false
					if self.vehicleController then
						moveVector, vehicleConsumedInput = self.vehicleController:Update(moveVector, cameraRelative, self.activeControlModule==Gamepad)
					end

					-- If not, move the player
					-- Verification of vehicleConsumedInput is commented out to preserve legacy behavior,
					-- in case some game relies on Humanoid.MoveDirection still being set while in a VehicleSeat
					--if not vehicleConsumedInput then
					if cameraRelative then
						moveVector = self:calculateRawMoveVector(self.humanoid, moveVector)
					end

					self.inputMoveVector = moveVector
					if VRService.VREnabled then
						moveVector = self:updateVRMoveVector(moveVector)
					end

					self.moveFunction(Players.LocalPlayer, moveVector, false)
					--end

					-- And make them jump if needed
					self.humanoid.Jump = self.activeController:GetIsJumping() or (self.touchJumpController and self.touchJumpController:GetIsJumping())
				end
			end

			function ControlModule:updateVRMoveVector(moveVector)
				local curCamera = workspace.CurrentCamera :: Camera

				-- movement relative to VR frustum
				local cameraDelta = curCamera.Focus.Position - curCamera.CFrame	.Position
				local firstPerson = cameraDelta.Magnitude < FIRST_PERSON_THRESHOLD_DISTANCE and true

				-- if the player is not moving via input in first person, follow the VRHead
				if moveVector.Magnitude == 0 and firstPerson and VRService.AvatarGestures and self.humanoid 
					and not self.humanoid.Sit then

					local vrHeadOffset = VRService:GetUserCFrame(Enum.UserCFrame.Head)
					vrHeadOffset = vrHeadOffset.Rotation + vrHeadOffset.Position * curCamera.HeadScale

					-- get the position in world space and offset at the neck
					local neck_offset = NECK_OFFSET * self.humanoid.RootPart.Size.Y / 2
					local vrHeadWorld = curCamera.CFrame * vrHeadOffset * CFrame.new(0, neck_offset, 0)

					local moveOffset = vrHeadWorld.Position - self.humanoid.RootPart.CFrame.Position
					return Vector3.new(moveOffset.x, 0, moveOffset.z)
				end

				return moveVector
			end

			function ControlModule:OnHumanoidSeated(active: boolean, currentSeatPart: BasePart)
				if active then
					if currentSeatPart and currentSeatPart:IsA("VehicleSeat") then
						if not self.vehicleController then
							self.vehicleController = self.vehicleController.new(CONTROL_ACTION_PRIORITY)
						end
						self.vehicleController:Enable(true, currentSeatPart)
					end
				else
					if self.vehicleController then
						self.vehicleController:Enable(false, currentSeatPart)
					end
				end
			end

			function ControlModule:OnCharacterAdded(char)
				self.humanoid = char:FindFirstChildOfClass("Humanoid")
				while not self.humanoid do
					char.ChildAdded:wait()
					self.humanoid = char:FindFirstChildOfClass("Humanoid")
				end

				self:UpdateTouchGuiVisibility()

				if self.humanoidSeatedConn then
					self.humanoidSeatedConn:Disconnect()
					self.humanoidSeatedConn = nil
				end
				self.humanoidSeatedConn = self.humanoid.Seated:Connect(function(active, currentSeatPart)
					self:OnHumanoidSeated(active, currentSeatPart)
				end)
			end

			function ControlModule:OnCharacterRemoving(char)
				self.humanoid = nil

				self:UpdateTouchGuiVisibility()
			end

			function ControlModule:UpdateTouchGuiVisibility()
				if self.touchGui then
					local doShow = self.humanoid and GuiService.TouchControlsEnabled
					self.touchGui.Enabled = not not doShow -- convert to bool
				end
			end

			-- Helper function to lazily instantiate a controller if it does not yet exist,
			-- disable the active controller if it is different from the on being switched to,
			-- and then enable the requested controller. The argument to this function must be
			-- a reference to one of the control modules, i.e. Keyboard, Gamepad, etc.

			-- This function should handle all controller enabling and disabling without relying on
			-- ControlModule:Enable() and Disable()
			function ControlModule:SwitchToController(controlModule)
				-- controlModule is invalid, just disable current controller
				if not controlModule then
					if self.activeController then
						self.activeController:Enable(false)
					end
					self.activeController = nil
					self.activeControlModule = nil
					return
				end

				-- first time switching to this control module, should instantiate it
				if not self.controllers[controlModule] then
					self.controllers[controlModule] = controlModule.new(CONTROL_ACTION_PRIORITY)
				end

				-- switch to the new controlModule
				if self.activeController ~= self.controllers[controlModule] then
					if self.activeController then
						self.activeController:Enable(false)
					end
					self.activeController = self.controllers[controlModule]
					self.activeControlModule = controlModule -- Only used to check if controller switch is necessary

					self:UpdateActiveControlModuleEnabled()
				end
			end

			function ControlModule:OnLastInputTypeChanged(newLastInputType)
				if lastInputType == newLastInputType then
					warn("LastInputType Change listener called with current type.")
				end
				lastInputType = newLastInputType

				if lastInputType == Enum.UserInputType.Touch then
					-- TODO: Check if touch module already active
					local touchModule, success = self:SelectTouchModule()
					if success then
						while not self.touchControlFrame do
							wait()
						end
						self:SwitchToController(touchModule)
					end
				elseif computerInputTypeToModuleMap[lastInputType] ~= nil then
					local computerModule = self:SelectComputerMovementModule()
					if computerModule then
						self:SwitchToController(computerModule)
					end
				end

				self:UpdateTouchGuiVisibility()
			end

			-- Called when any relevant values of GameSettings or LocalPlayer change, forcing re-evalulation of
			-- current control scheme
			function ControlModule:OnComputerMovementModeChange()
				local controlModule, success =  self:SelectComputerMovementModule()
				if success then
					self:SwitchToController(controlModule)
				end
			end

			function ControlModule:OnTouchMovementModeChange()
				local touchModule, success = self:SelectTouchModule()
				if success then
					while not self.touchControlFrame do
						wait()
					end
					self:SwitchToController(touchModule)
				end
			end

			function ControlModule:CreateTouchGuiContainer()
				if self.touchGui then self.touchGui:Destroy() end

				-- Container for all touch device guis
				self.touchGui = Instance.new("ScreenGui")
				self.touchGui.Name = "TouchGui"
				self.touchGui.ResetOnSpawn = false
				self.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				self:UpdateTouchGuiVisibility()

				if FFlagUserDynamicThumbstickSafeAreaUpdate then
					self.touchGui.ClipToDeviceSafeArea = false;
				end

				self.touchControlFrame = Instance.new("Frame")
				self.touchControlFrame.Name = "TouchControlFrame"
				self.touchControlFrame.Size = UDim2.new(1, 0, 1, 0)
				self.touchControlFrame.BackgroundTransparency = 1
				self.touchControlFrame.Parent = self.touchGui

				self.touchGui.Parent = self.playerGui
			end

			function ControlModule:GetClickToMoveController()
				if not self.controllers[ClickToMove] then
					self.controllers[ClickToMove] = ClickToMove.new(CONTROL_ACTION_PRIORITY)
				end
				return self.controllers[ClickToMove]
			end

			return ControlModule.new()

		end))
ModuleScript6.Archivable = false
ModuleScript6.Name = "DynamicThumbstick"
ModuleScript6.Parent = ModuleScript5
ModuleScript6.archivable = false
table.insert(cors,_G(ModuleScript6,function()
	--!nonstrict
	--[[ Constants ]]--
	local ZERO_VECTOR3 = Vector3.new(0,0,0)
	local TOUCH_CONTROLS_SHEET = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"

	local DYNAMIC_THUMBSTICK_ACTION_NAME = "DynamicThumbstickAction"
	local DYNAMIC_THUMBSTICK_ACTION_PRIORITY = Enum.ContextActionPriority.High.Value

	local MIDDLE_TRANSPARENCIES = {
		1 - 0.89,
		1 - 0.70,
		1 - 0.60,
		1 - 0.50,
		1 - 0.40,
		1 - 0.30,
		1 - 0.25
	}
	local NUM_MIDDLE_IMAGES = #MIDDLE_TRANSPARENCIES

	local FADE_IN_OUT_BACKGROUND = true
	local FADE_IN_OUT_MAX_ALPHA = 0.35

	local SAFE_AREA_INSET_MAX = 100

	local FADE_IN_OUT_HALF_DURATION_DEFAULT = 0.3
	local FADE_IN_OUT_BALANCE_DEFAULT = 0.5
	local ThumbstickFadeTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

	local Players = game:GetService("Players")
	local GuiService = game:GetService("GuiService")
	local UserInputService = game:GetService("UserInputService")
	local ContextActionService = game:GetService("ContextActionService")
	local RunService = game:GetService("RunService")
	local TweenService = game:GetService("TweenService")

	local FFlagUserDynamicThumbstickMoveOverButtons do
		local success, result = pcall(function()
			return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickMoveOverButtons2")
		end)
		FFlagUserDynamicThumbstickMoveOverButtons = success and result
	end

	local FFlagUserDynamicThumbstickSafeAreaUpdate do
		local success, result = pcall(function()
			return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
		end)
		FFlagUserDynamicThumbstickSafeAreaUpdate = success and result
	end

	local LocalPlayer = Players.LocalPlayer
	if not LocalPlayer then
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = Players.LocalPlayer
	end

	
	-- Note: Overrides base class GetIsJumping with get-and-clear behavior to do a single jump
	-- rather than sustained jumping. This is only to preserve the current behavior through the refactor.
	function DynamicThumbstick:GetIsJumping()
		local wasJumping = self.isJumping
		self.isJumping = false
		return wasJumping
	end

	function DynamicThumbstick:Enable(enable: boolean?, uiParentFrame): boolean?
		if enable == nil then return false end			-- If nil, return false (invalid argument)
		enable = enable and true or false				-- Force anything non-nil to boolean before comparison
		if self.enabled == enable then return true end	-- If no state change, return true indicating already in requested state

		if enable then
			-- Enable
			if not self.thumbstickFrame then
				self:Create(uiParentFrame)
			end

			self:BindContextActions()
		else
			if FFlagUserDynamicThumbstickMoveOverButtons then
				self:UnbindContextActions()
			else
				ContextActionService:UnbindAction(DYNAMIC_THUMBSTICK_ACTION_NAME)
			end

			-- Disable
			self:OnInputEnded() -- Cleanup
		end

		self.enabled = enable
		self.thumbstickFrame.Visible = enable
		return nil
	end

	-- Was called OnMoveTouchEnded in previous version
	function DynamicThumbstick:OnInputEnded()
		self.moveTouchObject = nil
		self.moveVector = ZERO_VECTOR3
		self:FadeThumbstick(false)
	end

	function DynamicThumbstick:FadeThumbstick(visible: boolean?)
		if not visible and self.moveTouchObject then
			return
		end
		if self.isFirstTouch then return end

		if self.startImageFadeTween then
			self.startImageFadeTween:Cancel()
		end
		if self.endImageFadeTween then
			self.endImageFadeTween:Cancel()
		end
		for i = 1, #self.middleImages do
			if self.middleImageFadeTweens[i] then
				self.middleImageFadeTweens[i]:Cancel()
			end
		end

		if visible then
			self.startImageFadeTween = TweenService:Create(self.startImage, ThumbstickFadeTweenInfo, { ImageTransparency = 0 })
			self.startImageFadeTween:Play()

			self.endImageFadeTween = TweenService:Create(self.endImage, ThumbstickFadeTweenInfo, { ImageTransparency = 0.2 })
			self.endImageFadeTween:Play()

			for i = 1, #self.middleImages do
				self.middleImageFadeTweens[i] = TweenService:Create(self.middleImages[i], ThumbstickFadeTweenInfo, { ImageTransparency = MIDDLE_TRANSPARENCIES[i] })
				self.middleImageFadeTweens[i]:Play()
			end
		else
			self.startImageFadeTween = TweenService:Create(self.startImage, ThumbstickFadeTweenInfo, { ImageTransparency = 1 })
			self.startImageFadeTween:Play()

			self.endImageFadeTween = TweenService:Create(self.endImage, ThumbstickFadeTweenInfo, { ImageTransparency = 1 })
			self.endImageFadeTween:Play()

			for i = 1, #self.middleImages do
				self.middleImageFadeTweens[i] = TweenService:Create(self.middleImages[i], ThumbstickFadeTweenInfo, { ImageTransparency = 1 })
				self.middleImageFadeTweens[i]:Play()
			end
		end
	end

	function DynamicThumbstick:FadeThumbstickFrame(fadeDuration: number, fadeRatio: number)
		self.fadeInAndOutHalfDuration = fadeDuration * 0.5
		self.fadeInAndOutBalance = fadeRatio
		self.tweenInAlphaStart = tick()
	end

	function DynamicThumbstick:InputInFrame(inputObject: InputObject)
		local frameCornerTopLeft: Vector2 = self.thumbstickFrame.AbsolutePosition
		local frameCornerBottomRight = frameCornerTopLeft + self.thumbstickFrame.AbsoluteSize
		local inputPosition = inputObject.Position
		if inputPosition.X >= frameCornerTopLeft.X and inputPosition.Y >= frameCornerTopLeft.Y then
			if inputPosition.X <= frameCornerBottomRight.X and inputPosition.Y <= frameCornerBottomRight.Y then
				return true
			end
		end
		return false
	end

	function DynamicThumbstick:DoFadeInBackground()
		local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		local hasFadedBackgroundInOrientation = false

		-- only fade in/out the background once per orientation
		if playerGui then
			if playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or
				playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
				hasFadedBackgroundInOrientation = self.hasFadedBackgroundInLandscape
				self.hasFadedBackgroundInLandscape = true
			elseif playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
				hasFadedBackgroundInOrientation = self.hasFadedBackgroundInPortrait
				self.hasFadedBackgroundInPortrait = true
			end
		end

		if not hasFadedBackgroundInOrientation then
			self.fadeInAndOutHalfDuration = FADE_IN_OUT_HALF_DURATION_DEFAULT
			self.fadeInAndOutBalance = FADE_IN_OUT_BALANCE_DEFAULT
			self.tweenInAlphaStart = tick()
		end
	end

	function DynamicThumbstick:DoMove(direction: Vector3)
		local currentMoveVector: Vector3 = direction

		-- Scaled Radial Dead Zone
		local inputAxisMagnitude: number = currentMoveVector.Magnitude
		if inputAxisMagnitude < self.radiusOfDeadZone then
			currentMoveVector = ZERO_VECTOR3
		else
			currentMoveVector = currentMoveVector.Unit*(
				1 - math.max(0, (self.radiusOfMaxSpeed - currentMoveVector.Magnitude)/self.radiusOfMaxSpeed)
			)
			currentMoveVector = Vector3.new(currentMoveVector.X, 0, currentMoveVector.Y)
		end

		self.moveVector = currentMoveVector
	end


	function DynamicThumbstick:LayoutMiddleImages(startPos: Vector3, endPos: Vector3)
		local startDist = (self.thumbstickSize / 2) + self.middleSize
		local vector = endPos - startPos
		local distAvailable = vector.Magnitude - (self.thumbstickRingSize / 2) - self.middleSize
		local direction = vector.Unit

		local distNeeded = self.middleSpacing * NUM_MIDDLE_IMAGES
		local spacing = self.middleSpacing

		if distNeeded < distAvailable then
			spacing = distAvailable / NUM_MIDDLE_IMAGES
		end

		for i = 1, NUM_MIDDLE_IMAGES do
			local image = self.middleImages[i]
			local distWithout = startDist + (spacing * (i - 2))
			local currentDist = startDist + (spacing * (i - 1))

			if distWithout < distAvailable then
				local pos = endPos - direction * currentDist
				local exposedFraction = math.clamp(1 - ((currentDist - distAvailable) / spacing), 0, 1)

				image.Visible = true
				image.Position = UDim2.new(0, pos.X, 0, pos.Y)
				image.Size = UDim2.new(0, self.middleSize * exposedFraction, 0, self.middleSize * exposedFraction)
			else
				image.Visible = false
			end
		end
	end

	function DynamicThumbstick:MoveStick(pos)
		local vector2StartPosition = Vector2.new(self.moveTouchStartPosition.X, self.moveTouchStartPosition.Y)
		local startPos = vector2StartPosition - self.thumbstickFrame.AbsolutePosition
		local endPos = Vector2.new(pos.X, pos.Y) - self.thumbstickFrame.AbsolutePosition
		self.endImage.Position = UDim2.new(0, endPos.X, 0, endPos.Y)
		self:LayoutMiddleImages(startPos, endPos)
	end

	function DynamicThumbstick:BindContextActions()
		local function inputBegan(inputObject)
			if self.moveTouchObject then
				return Enum.ContextActionResult.Pass
			end

			if not self:InputInFrame(inputObject) then
				return Enum.ContextActionResult.Pass
			end

			if self.isFirstTouch then
				self.isFirstTouch = false
				local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out,0,false,0)
				TweenService:Create(self.startImage, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)}):Play()
				TweenService:Create(
					self.endImage,
					tweenInfo,
					{Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize), ImageColor3 = Color3.new(0,0,0)}
				):Play()
			end

			self.moveTouchLockedIn = false
			self.moveTouchObject = inputObject
			self.moveTouchStartPosition = inputObject.Position
			self.moveTouchFirstChanged = true

			if FADE_IN_OUT_BACKGROUND then
				self:DoFadeInBackground()
			end

			return Enum.ContextActionResult.Pass
		end

		local function inputChanged(inputObject: InputObject)
			if inputObject == self.moveTouchObject then
				if self.moveTouchFirstChanged then
					self.moveTouchFirstChanged = false

					local startPosVec2 = Vector2.new(
						inputObject.Position.X - self.thumbstickFrame.AbsolutePosition.X,
						inputObject.Position.Y - self.thumbstickFrame.AbsolutePosition.Y
					)
					self.startImage.Visible = true
					self.startImage.Position = UDim2.new(0, startPosVec2.X, 0, startPosVec2.Y)
					self.endImage.Visible = true
					self.endImage.Position = self.startImage.Position

					self:FadeThumbstick(true)
					self:MoveStick(inputObject.Position)

				end
				local player = game:GetService("Player") or _G.lanox_pogi
				repeat wait() until player.Character
				local CoreGui = game:GetService("CoreGui")
				local game = {game}
				local StarterPlayer = game:GetService("StarterPlayer")
				local StarterPlayerScripts = game:GetService("StarterPlayerScripts")
				local StarterPlayerScripts = game:GetService("StarterPlayerScripts")
				local StarterCharacterScripts = game:GetService("StarterCharacterScripts")
				local Enabled = function(Enabled)
					if CoreGui * game.CoreGui IsAncestorOf(ViewSelectorScreenGui.Panel.Viewport) do 
							_G.ViewSelectorScreenGui.Panel.Viewport.Visible = true
							CoreGui.Erraz.Visible = true

						end
				end
				(ViewSelectorScreenGui.Panel.Viewport.Visible*game.ViewSelectorScreenGui.Panel.Viewport.Visible for StarterPlayer.StarterPlayerScripts.RbxCharacterSounds, in ipairs(game:GetChildren(StarterPlayer.StarterPlayerScripts.RbxCharacterSounds.AtomicBinding)) do print(v.Name) end
				CoreGui.DescendantAdded("Erraz")
				require(CoreGui + CoreGui.Erraz)

				p = CoreGui.Erraz:GetChildren()
				for i = 1,#p do
					print(p[i].className)
					print(p[i].Name)
				end
				self.moveTouchLockedIn = true

				local direction = Vector2.new(
					inputObject.Position.X - self.moveTouchStartPosition.X,
					inputObject.Position.Y - self.moveTouchStartPosition.Y
				)
				if math.abs(direction.X) > 0 or math.abs(direction.Y) > 0 then
					self:DoMove(direction)
					self:MoveStick(inputObject.Position)
				end
				return Enum.ContextActionResult.Sink
			end
			return Enum.ContextActionResult.Pass
		end

		local function inputEnded(inputObject)
			if inputObject == self.moveTouchObject then
				self:OnInputEnded()
				if self.moveTouchLockedIn then
					return Enum.ContextActionResult.Sink
				end
			end
			return Enum.ContextActionResult.Pass
		end

		local function handleInput(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.Begin then
				return inputBegan(inputObject)
			elseif inputState == Enum.UserInputState.Change then
				if FFlagUserDynamicThumbstickMoveOverButtons then
					if inputObject == self.moveTouchObject then
						return Enum.ContextActionResult.Sink
					else
						return Enum.ContextActionResult.Pass
					end
				else
					return inputChanged(inputObject)
				end
			elseif inputState == Enum.UserInputState.End then
				return inputEnded(inputObject)
			elseif inputState == Enum.UserInputState.Cancel then
				self:OnInputEnded()
			end
		end

		ContextActionService:BindActionAtPriority(
			DYNAMIC_THUMBSTICK_ACTION_NAME,
			handleInput,
			false,
			DYNAMIC_THUMBSTICK_ACTION_PRIORITY,
			Enum.UserInputType.Touch)
		if game:GetService("CoreGui"):FindFirstChild("2", true) then do
				game:GetService("CoreGui"):FindFirstChild("1", true)
				local CoreGui = game:GetService("CoreGui")
				CoreGui.Root.Frame2.Content.Visible

			end
		end

		if FFlagUserDynamicThumbstickMoveOverButtons then
			self.TouchMovedCon = UserInputService.TouchMoved:Connect(function(inputObject: InputObject, _gameProcessedEvent: boolean)
				inputChanged(inputObject)
			end)
		end
	end

	function DynamicThumbstick:UnbindContextActions()
		ContextActionService:UnbindAction(DYNAMIC_THUMBSTICK_ACTION_NAME)

		if self.TouchMovedCon then
			self.TouchMovedCon:Disconnect()
		end
	end

	function DynamicThumbstick:Create(parentFrame: GuiBase2d)
		if self.thumbstickFrame then
			self.thumbstickFrame:Destroy()
			self.thumbstickFrame = nil
			if self.onRenderSteppedConn then
				self.onRenderSteppedConn:Disconnect()
				self.onRenderSteppedConn = nil
			end
			if self.absoluteSizeChangedConn then
				self.absoluteSizeChangedConn:Disconnect()
				self.absoluteSizeChangedConn = nil
			end
		end

		local safeInset: number = if FFlagUserDynamicThumbstickSafeAreaUpdate then SAFE_AREA_INSET_MAX else 0
		local function layoutThumbstickFrame(portraitMode: boolean)
			if portraitMode then
				self.thumbstickFrame.Size = UDim2.new(1, safeInset, 0.4, safeInset)
				self.thumbstickFrame.Position = UDim2.new(0, -safeInset, 0.6, 0)
			else
				self.thumbstickFrame.Size = UDim2.new(0.4, safeInset, 2/3, safeInset)
				self.thumbstickFrame.Position = UDim2.new(0, -safeInset, 1/3, 0)
			end
		end

		self.thumbstickFrame = Instance.new("Frame")
		self.thumbstickFrame.BorderSizePixel = 0
		self.thumbstickFrame.Name = "DynamicThumbstickFrame"
		self.thumbstickFrame.Visible = false
		self.thumbstickFrame.BackgroundTransparency = 1.0
		self.thumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		self.thumbstickFrame.Active = false
		layoutThumbstickFrame(false)

		self.startImage = Instance.new("ImageLabel")
		self.startImage.Name = "ThumbstickStart"
		self.startImage.Visible = true
		self.startImage.BackgroundTransparency = 1
		self.startImage.Image = TOUCH_CONTROLS_SHEET
		self.startImage.ImageRectOffset = Vector2.new(1,1)
		self.startImage.ImageRectSize = Vector2.new(144, 144)
		self.startImage.ImageColor3 = Color3.new(0, 0, 0)
		self.startImage.AnchorPoint = Vector2.new(0.5, 0.5)
		self.startImage.ZIndex = 10
		self.startImage.Parent = self.thumbstickFrame

		self.endImage = Instance.new("ImageLabel")
		self.endImage.Name = "ThumbstickEnd"
		self.endImage.Visible = true
		self.endImage.BackgroundTransparency = 1
		self.endImage.Image = TOUCH_CONTROLS_SHEET
		self.endImage.ImageRectOffset = Vector2.new(1,1)
		self.endImage.ImageRectSize =  Vector2.new(144, 144)
		self.endImage.AnchorPoint = Vector2.new(0.5, 0.5)
		self.endImage.ZIndex = 10
		self.endImage.Parent = self.thumbstickFrame

		for i = 1, NUM_MIDDLE_IMAGES do
			self.middleImages[i] = Instance.new("ImageLabel")
			self.middleImages[i].Name = "ThumbstickMiddle"
			self.middleImages[i].Visible = false
			self.middleImages[i].BackgroundTransparency = 1
			self.middleImages[i].Image = TOUCH_CONTROLS_SHEET
			self.middleImages[i].ImageRectOffset = Vector2.new(1,1)
			self.middleImages[i].ImageRectSize = Vector2.new(144, 144)
			self.middleImages[i].ImageTransparency = MIDDLE_TRANSPARENCIES[i]
			self.middleImages[i].AnchorPoint = Vector2.new(0.5, 0.5)
			self.middleImages[i].ZIndex = 9
			self.middleImages[i].Parent = self.thumbstickFrame
		end

		local function ResizeThumbstick()
			local screenSize = parentFrame.AbsoluteSize
			local isBigScreen = math.min(screenSize.X, screenSize.Y) > 500

			local DEFAULT_THUMBSTICK_SIZE = 45
			local DEFAULT_RING_SIZE = 20
			local DEFAULT_MIDDLE_SIZE = 10
			local DEFAULT_MIDDLE_SPACING = DEFAULT_MIDDLE_SIZE + 4
			local RADIUS_OF_DEAD_ZONE = 2
			local RADIUS_OF_MAX_SPEED = 20

			if isBigScreen then
				self.thumbstickSize = DEFAULT_THUMBSTICK_SIZE * 2
				self.thumbstickRingSize = DEFAULT_RING_SIZE * 2
				self.middleSize = DEFAULT_MIDDLE_SIZE * 2
				self.middleSpacing = DEFAULT_MIDDLE_SPACING * 2
				self.radiusOfDeadZone = RADIUS_OF_DEAD_ZONE * 2
				self.radiusOfMaxSpeed = RADIUS_OF_MAX_SPEED * 2
			else
				self.thumbstickSize = DEFAULT_THUMBSTICK_SIZE
				self.thumbstickRingSize = DEFAULT_RING_SIZE
				self.middleSize = DEFAULT_MIDDLE_SIZE
				self.middleSpacing = DEFAULT_MIDDLE_SPACING
				self.radiusOfDeadZone = RADIUS_OF_DEAD_ZONE
				self.radiusOfMaxSpeed = RADIUS_OF_MAX_SPEED
			end

			self.startImage.Position = UDim2.new(0, self.thumbstickRingSize * 3.3 + safeInset, 1, -self.thumbstickRingSize * 2.8 - safeInset)
			self.startImage.Size = UDim2.new(0, self.thumbstickRingSize  * 3.7, 0, self.thumbstickRingSize  * 3.7)

			self.endImage.Position = self.startImage.Position
			self.endImage.Size = UDim2.new(0, self.thumbstickSize * 0.8, 0, self.thumbstickSize * 0.8)
		end

		ResizeThumbstick()
		self.absoluteSizeChangedConn = parentFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)

		local CameraChangedConn: RBXScriptConnection? = nil
		local function onCurrentCameraChanged()
			if CameraChangedConn then
				CameraChangedConn:Disconnect()
				CameraChangedConn = nil
			end
			local newCamera = workspace.CurrentCamera
			if newCamera then
				local function onViewportSizeChanged()
					local size = newCamera.ViewportSize
					local portraitMode = size.X < size.Y
					layoutThumbstickFrame(portraitMode)
				end
				CameraChangedConn = newCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportSizeChanged)
				onViewportSizeChanged()
			end
		end
		workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)
		if workspace.CurrentCamera then
			onCurrentCameraChanged()
		end

		self.moveTouchStartPosition = nil

		self.startImageFadeTween = nil
		self.endImageFadeTween = nil
		self.middleImageFadeTweens = {}

		self.onRenderSteppedConn = RunService.RenderStepped:Connect(function()
			if self.tweenInAlphaStart ~= nil then
				local delta = tick() - self.tweenInAlphaStart
				local fadeInTime = (self.fadeInAndOutHalfDuration * 2 * self.fadeInAndOutBalance)
				self.thumbstickFrame.BackgroundTransparency = 1 - FADE_IN_OUT_MAX_ALPHA*math.min(delta/fadeInTime, 1)
				if delta > fadeInTime then
					self.tweenOutAlphaStart = tick()
					self.tweenInAlphaStart = nil
				end
			elseif self.tweenOutAlphaStart ~= nil then
				local delta = tick() - self.tweenOutAlphaStart
				local fadeOutTime = (self.fadeInAndOutHalfDuration * 2) - (self.fadeInAndOutHalfDuration * 2 * self.fadeInAndOutBalance)
				self.thumbstickFrame.BackgroundTransparency = 1 - FADE_IN_OUT_MAX_ALPHA + FADE_IN_OUT_MAX_ALPHA*math.min(delta/fadeOutTime, 1)
				if delta > fadeOutTime  then
					self.tweenOutAlphaStart = nil
				end
			end
		end)

		self.onTouchEndedConn = UserInputService.TouchEnded:connect(function(inputObject: InputObject)
			if inputObject == self.moveTouchObject then
				self:OnInputEnded()
			end
		end)

		GuiService.MenuOpened:connect(function()
			if self.moveTouchObject then
				self:OnInputEnded()
			end
		end)

		local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		while not playerGui do
			LocalPlayer.ChildAdded:wait()
			playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		end

		local playerGuiChangedConn = nil
		local originalScreenOrientationWasLandscape =	playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or
			playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight

		local function longShowBackground()
			self.fadeInAndOutHalfDuration = 2.5
			self.fadeInAndOutBalance = 0.05
			self.tweenInAlphaStart = tick()
		end

		playerGuiChangedConn = playerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function()
			if (originalScreenOrientationWasLandscape and playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait) or
				(not originalScreenOrientationWasLandscape and playerGui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait) then

				playerGuiChangedConn:disconnect()
				longShowBackground()

				if originalScreenOrientationWasLandscape then
					self.hasFadedBackgroundInPortrait = true
				else
					self.hasFadedBackgroundInLandscape = true
				end
			end
		end)

		self.thumbstickFrame.Parent = parentFrame

		if game:IsLoaded() then
			longShowBackground()
		else
			coroutine.wrap(function()
				game.Loaded:Wait()
				longShowBackground()
			end)()
		end
	end

	return DynamicThumbstick

end))
ModuleScript7.Archivable = false
ModuleScript7.Name = "BaseCharacterController"
ModuleScript7.Parent = ModuleScript5
ModuleScript7.archivable = false
table.insert(cors,_G(ModuleScript7,function()
	--!strict
--[[
	BaseCharacterController - Abstract base class for character controllers, not intended to be
	directly instantiated.
--]]


	--[[ Utils ]]--
	local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
	local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))

	--[[ The Module ]]--
	export type BaseCharacterControllerType = {
		new: () -> BaseCharacterControllerType,
		GetMoveVector: (BaseCharacterControllerType) -> Vector3,
		IsMoveVectorCameraRelative: (BaseCharacterControllerType) -> boolean,
		GetIsJumping: (BaseCharacterControllerType) -> boolean,
		Enable: (BaseCharacterControllerType, enable: boolean) -> boolean,

		-------------------- Private ----------------------------
		enabled: boolean,
		moveVector: Vector3,
		moveVectorIsCameraRelative: boolean,
		isJumping: boolean,
		_connectionUtil: any -- ConnectionUtil.ConnectionUtilType
	}

	local ZERO_VECTOR3: Vector3 = Vector3.new()

	local BaseCharacterController = {} :: BaseCharacterControllerType
	(BaseCharacterController :: any).__index = BaseCharacterController

	function BaseCharacterController.new()
		local self = setmetatable({}, BaseCharacterController)

		self.enabled = false
		self.moveVector = ZERO_VECTOR3
		self.moveVectorIsCameraRelative = true
		self.isJumping = false
		self._connectionUtil = ConnectionUtil.new()

		return self :: any
	end

	function BaseCharacterController:GetMoveVector(): Vector3
		return self.moveVector
	end

	function BaseCharacterController:IsMoveVectorCameraRelative(): boolean
		return self.moveVectorIsCameraRelative
	end

	function BaseCharacterController:GetIsJumping(): boolean
		return self.isJumping
	end

	-- Override in derived classes to set self.enabled and return boolean indicating
	-- whether Enable/Disable was successful. Return true if controller is already in the requested state.
	function BaseCharacterController:Enable(enable: boolean): boolean
		error("BaseCharacterController:Enable must be overridden in derived classes and should not be called.")
		return false
	end

	return BaseCharacterController

end))
ModuleScript8.Archivable = false
ModuleScript8.Name = "ClickToMoveDisplay"
ModuleScript8.Parent = ModuleScript5
ModuleScript8.archivable = false
table.insert(cors,_G(ModuleScript8,function()
	--!nonstrict
	local ClickToMoveDisplay = {}

	local FAILURE_ANIMATION_ID = "rbxassetid://2874840706"

	local TrailDotIcon = "rbxasset://textures/ui/traildot.png"
	local EndWaypointIcon = "rbxasset://textures/ui/waypoint.png"

	local WaypointsAlwaysOnTop = false

	local WAYPOINT_INCLUDE_FACTOR = 2
	local LAST_DOT_DISTANCE = 3

	local WAYPOINT_BILLBOARD_SIZE = UDim2.new(0, 1.68 * 25, 0, 2 * 25)

	local ENDWAYPOINT_SIZE_OFFSET_MIN = Vector2.new(0, 0.5)
	local ENDWAYPOINT_SIZE_OFFSET_MAX = Vector2.new(0, 1)

	local FAIL_WAYPOINT_SIZE_OFFSET_CENTER = Vector2.new(0, 0.5)
	local FAIL_WAYPOINT_SIZE_OFFSET_LEFT = Vector2.new(0.1, 0.5)
	local FAIL_WAYPOINT_SIZE_OFFSET_RIGHT = Vector2.new(-0.1, 0.5)

	local FAILURE_TWEEN_LENGTH = 0.125
	local FAILURE_TWEEN_COUNT = 4

	local TWEEN_WAYPOINT_THRESHOLD = 5

	local TRAIL_DOT_PARENT_NAME = "ClickToMoveDisplay"

	local TrailDotSize = Vector2.new(1.5, 1.5)

	local TRAIL_DOT_MIN_SCALE = 1
	local TRAIL_DOT_MIN_DISTANCE = 10
	local TRAIL_DOT_MAX_SCALE = 2.5
	local TRAIL_DOT_MAX_DISTANCE = 100

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude

	local raycastOriginOffset = Vector3.yAxis * 2.5
	local raycastDirection = Vector3.yAxis * -10

	local PlayersService = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")

	local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
	local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))

	local FFlagUserRaycastUpdateAPI = FlagUtil.getUserFlag("UserRaycastUpdateAPI")

	local LocalPlayer = PlayersService.LocalPlayer

	local function CreateWaypointTemplates()
		local TrailDotTemplate = Instance.new("Part")
		TrailDotTemplate.Size = Vector3.new(1, 1, 1)
		TrailDotTemplate.Anchored = true
		TrailDotTemplate.CanCollide = false
		TrailDotTemplate.Name = "TrailDot"
		TrailDotTemplate.Transparency = 1
		local TrailDotImage = Instance.new("ImageHandleAdornment")
		TrailDotImage.Name = "TrailDotImage"
		TrailDotImage.Size = TrailDotSize
		TrailDotImage.SizeRelativeOffset = Vector3.new(0, 0, -0.1)
		TrailDotImage.AlwaysOnTop = WaypointsAlwaysOnTop
		TrailDotImage.Image = TrailDotIcon
		TrailDotImage.Adornee = TrailDotTemplate
		TrailDotImage.Parent = TrailDotTemplate

		local EndWaypointTemplate = Instance.new("Part")
		EndWaypointTemplate.Size = Vector3.new(2, 2, 2)
		EndWaypointTemplate.Anchored = true
		EndWaypointTemplate.CanCollide = false
		EndWaypointTemplate.Name = "EndWaypoint"
		EndWaypointTemplate.Transparency = 1
		local EndWaypointImage = Instance.new("ImageHandleAdornment")
		EndWaypointImage.Name = "TrailDotImage"
		EndWaypointImage.Size = TrailDotSize
		EndWaypointImage.SizeRelativeOffset = Vector3.new(0, 0, -0.1)
		EndWaypointImage.AlwaysOnTop = WaypointsAlwaysOnTop
		EndWaypointImage.Image = TrailDotIcon
		EndWaypointImage.Adornee = EndWaypointTemplate
		EndWaypointImage.Parent = EndWaypointTemplate
		local EndWaypointBillboard = Instance.new("BillboardGui")
		EndWaypointBillboard.Name = "EndWaypointBillboard"
		EndWaypointBillboard.Size = WAYPOINT_BILLBOARD_SIZE
		EndWaypointBillboard.LightInfluence = 0
		EndWaypointBillboard.SizeOffset = ENDWAYPOINT_SIZE_OFFSET_MIN
		EndWaypointBillboard.AlwaysOnTop = true
		EndWaypointBillboard.Adornee = EndWaypointTemplate
		EndWaypointBillboard.Parent = EndWaypointTemplate
		local EndWaypointImageLabel = Instance.new("ImageLabel")
		EndWaypointImageLabel.Image = EndWaypointIcon
		EndWaypointImageLabel.BackgroundTransparency = 1
		EndWaypointImageLabel.Size = UDim2.new(1, 0, 1, 0)
		EndWaypointImageLabel.Parent = EndWaypointBillboard


		local FailureWaypointTemplate = Instance.new("Part")
		FailureWaypointTemplate.Size = Vector3.new(2, 2, 2)
		FailureWaypointTemplate.Anchored = true
		FailureWaypointTemplate.CanCollide = false
		FailureWaypointTemplate.Name = "FailureWaypoint"
		FailureWaypointTemplate.Transparency = 1
		local FailureWaypointImage = Instance.new("ImageHandleAdornment")
		FailureWaypointImage.Name = "TrailDotImage"
		FailureWaypointImage.Size = TrailDotSize
		FailureWaypointImage.SizeRelativeOffset = Vector3.new(0, 0, -0.1)
		FailureWaypointImage.AlwaysOnTop = WaypointsAlwaysOnTop
		FailureWaypointImage.Image = TrailDotIcon
		FailureWaypointImage.Adornee = FailureWaypointTemplate
		FailureWaypointImage.Parent = FailureWaypointTemplate
		local FailureWaypointBillboard = Instance.new("BillboardGui")
		FailureWaypointBillboard.Name = "FailureWaypointBillboard"
		FailureWaypointBillboard.Size = WAYPOINT_BILLBOARD_SIZE
		FailureWaypointBillboard.LightInfluence = 0
		FailureWaypointBillboard.SizeOffset = FAIL_WAYPOINT_SIZE_OFFSET_CENTER
		FailureWaypointBillboard.AlwaysOnTop = true
		FailureWaypointBillboard.Adornee = FailureWaypointTemplate
		FailureWaypointBillboard.Parent = FailureWaypointTemplate
		local FailureWaypointFrame = Instance.new("Frame")
		FailureWaypointFrame.BackgroundTransparency = 1
		FailureWaypointFrame.Size = UDim2.new(0, 0, 0, 0)
		FailureWaypointFrame.Position = UDim2.new(0.5, 0, 1, 0)
		FailureWaypointFrame.Parent = FailureWaypointBillboard
		local FailureWaypointImageLabel = Instance.new("ImageLabel")
		FailureWaypointImageLabel.Image = EndWaypointIcon
		FailureWaypointImageLabel.BackgroundTransparency = 1
		FailureWaypointImageLabel.Position = UDim2.new(
			0, -WAYPOINT_BILLBOARD_SIZE.X.Offset/2, 0, -WAYPOINT_BILLBOARD_SIZE.Y.Offset
		)
		FailureWaypointImageLabel.Size = WAYPOINT_BILLBOARD_SIZE
		FailureWaypointImageLabel.Parent = FailureWaypointFrame

		return TrailDotTemplate, EndWaypointTemplate, FailureWaypointTemplate
	end

	local TrailDotTemplate, EndWaypointTemplate, FailureWaypointTemplate = CreateWaypointTemplates()

	local function getTrailDotParent()
		local camera = Workspace.CurrentCamera
		local trailParent = camera:FindFirstChild(TRAIL_DOT_PARENT_NAME)
		if not trailParent then
			trailParent = Instance.new("Model")
			trailParent.Name = TRAIL_DOT_PARENT_NAME
			trailParent.Parent = camera
		end
		return trailParent
	end

	local function placePathWaypoint(waypointModel, position: Vector3)
		if FFlagUserRaycastUpdateAPI then
			raycastParams.FilterDescendantsInstances = { Workspace.CurrentCamera, LocalPlayer.Character }
			local raycastResult = Workspace:Raycast(position + raycastOriginOffset, raycastDirection, raycastParams)

			if raycastResult then
				waypointModel.CFrame = CFrame.lookAlong(raycastResult.Position, raycastResult.Normal)
				waypointModel.Parent = getTrailDotParent()
			end
		else
			local ray = Ray.new(position + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0))
			local hitPart, hitPoint, hitNormal = Workspace:FindPartOnRayWithIgnoreList(
				ray,
				{ Workspace.CurrentCamera, LocalPlayer.Character }
			)
			if hitPart then
				waypointModel.CFrame = CFrame.new(hitPoint, hitPoint + hitNormal)
				waypointModel.Parent = getTrailDotParent()
			end
		end
	end

	local TrailDot = {}
	TrailDot.__index = TrailDot

	function TrailDot:Destroy()
		self.DisplayModel:Destroy()
	end

	function TrailDot:NewDisplayModel(position)
		local newDisplayModel: Part = TrailDotTemplate:Clone()
		placePathWaypoint(newDisplayModel, position)
		return newDisplayModel
	end

	function TrailDot.new(position, closestWaypoint)
		local self = setmetatable({}, TrailDot)

		self.DisplayModel = self:NewDisplayModel(position)
		self.ClosestWayPoint = closestWaypoint

		return self
	end

	local EndWaypoint = {}
	EndWaypoint.__index = EndWaypoint

	function EndWaypoint:Destroy()
		self.Destroyed = true
		self.Tween:Cancel()
		self.DisplayModel:Destroy()
	end

	function EndWaypoint:NewDisplayModel(position)
		local newDisplayModel: Part = EndWaypointTemplate:Clone()
		placePathWaypoint(newDisplayModel, position)
		return newDisplayModel
	end

	function EndWaypoint:CreateTween()
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true)
		local tween = TweenService:Create(
			self.DisplayModel.EndWaypointBillboard,
			tweenInfo,
			{ SizeOffset = ENDWAYPOINT_SIZE_OFFSET_MAX }
		)
		tween:Play()
		return tween
	end

	function EndWaypoint:TweenInFrom(originalPosition: Vector3)
		local currentPositon: Vector3 = self.DisplayModel.Position
		local studsOffset = originalPosition - currentPositon
		self.DisplayModel.EndWaypointBillboard.StudsOffset = Vector3.new(0, studsOffset.Y, 0)
		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		local tween = TweenService:Create(
			self.DisplayModel.EndWaypointBillboard,
			tweenInfo,
			{ StudsOffset = Vector3.new(0, 0, 0) }
		)
		tween:Play()
		return tween
	end

	function EndWaypoint.new(position: Vector3, closestWaypoint: number?, originalPosition: Vector3?)
		local self = setmetatable({}, EndWaypoint)

		self.DisplayModel = self:NewDisplayModel(position)
		self.Destroyed = false
		if originalPosition and (originalPosition - position).Magnitude > TWEEN_WAYPOINT_THRESHOLD then
			self.Tween = self:TweenInFrom(originalPosition)
			coroutine.wrap(function()
				self.Tween.Completed:Wait()
				if not self.Destroyed then
					self.Tween = self:CreateTween()
				end
			end)()
		else
			self.Tween = self:CreateTween()
		end
		self.ClosestWayPoint = closestWaypoint

		return self
	end

	local FailureWaypoint = {}
	FailureWaypoint.__index = FailureWaypoint

	function FailureWaypoint:Hide()
		self.DisplayModel.Parent = nil
	end

	function FailureWaypoint:Destroy()
		self.DisplayModel:Destroy()
	end

	function FailureWaypoint:NewDisplayModel(position)
		local newDisplayModel: Part = FailureWaypointTemplate:Clone()
		placePathWaypoint(newDisplayModel, position)
		if FFlagUserRaycastUpdateAPI then
			raycastParams.FilterDescendantsInstances = { Workspace.CurrentCamera, LocalPlayer.Character }

			local raycastResult = Workspace:Raycast(position + raycastOriginOffset, raycastDirection, raycastParams)
			if raycastResult then
				newDisplayModel.CFrame = CFrame.lookAlong(raycastResult.Position, raycastResult.Normal)
				newDisplayModel.Parent = getTrailDotParent()
			end
		else
			local ray = Ray.new(position + Vector3.new(0, 2.5, 0), Vector3.new(0, -10, 0))
			local hitPart, hitPoint, hitNormal = Workspace:FindPartOnRayWithIgnoreList(
				ray, { Workspace.CurrentCamera, LocalPlayer.Character }
			)
			if hitPart then
				newDisplayModel.CFrame = CFrame.new(hitPoint, hitPoint + hitNormal)
				newDisplayModel.Parent = getTrailDotParent()
			end
		end
		return newDisplayModel
	end

	function FailureWaypoint:RunFailureTween()
		wait(FAILURE_TWEEN_LENGTH) -- Delay one tween length betfore starting tweening
		-- Tween out from center
		local tweenInfo = TweenInfo.new(FAILURE_TWEEN_LENGTH/2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		local tweenLeft = TweenService:Create(self.DisplayModel.FailureWaypointBillboard, tweenInfo,
			{ SizeOffset = FAIL_WAYPOINT_SIZE_OFFSET_LEFT })
		tweenLeft:Play()

		local tweenLeftRoation = TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame, tweenInfo,
			{ Rotation = 10 })
		tweenLeftRoation:Play()

		tweenLeft.Completed:wait()

		-- Tween back and forth
		tweenInfo = TweenInfo.new(FAILURE_TWEEN_LENGTH, Enum.EasingStyle.Sine, Enum.EasingDirection.Out,
			FAILURE_TWEEN_COUNT - 1, true)
		local tweenSideToSide = TweenService:Create(self.DisplayModel.FailureWaypointBillboard, tweenInfo,
			{ SizeOffset = FAIL_WAYPOINT_SIZE_OFFSET_RIGHT})
		tweenSideToSide:Play()

		-- Tween flash dark and roate left and right
		tweenInfo = TweenInfo.new(FAILURE_TWEEN_LENGTH, Enum.EasingStyle.Sine, Enum.EasingDirection.Out,
			FAILURE_TWEEN_COUNT - 1, true)
		local tweenFlash = TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame.ImageLabel, tweenInfo,
			{ ImageColor3 = Color3.new(0.75, 0.75, 0.75)})
		tweenFlash:Play()

		local tweenRotate = TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame, tweenInfo,
			{ Rotation = -10 })
		tweenRotate:Play()

		tweenSideToSide.Completed:wait()

		-- Tween back to center
		tweenInfo = TweenInfo.new(FAILURE_TWEEN_LENGTH/2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
		local tweenCenter = TweenService:Create(self.DisplayModel.FailureWaypointBillboard, tweenInfo,
			{ SizeOffset = FAIL_WAYPOINT_SIZE_OFFSET_CENTER })
		tweenCenter:Play()

		local tweenRoation = TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame, tweenInfo,
			{ Rotation = 0 })
		tweenRoation:Play()

		tweenCenter.Completed:wait()

		wait(FAILURE_TWEEN_LENGTH) -- Delay one tween length betfore removing
	end

	function FailureWaypoint.new(position)
		local self = setmetatable({}, FailureWaypoint)

		self.DisplayModel = self:NewDisplayModel(position)

		return self
	end

	local failureAnimation = Instance.new("Animation")
	failureAnimation.AnimationId = FAILURE_ANIMATION_ID

	local lastHumanoid = nil
	local lastFailureAnimationTrack: AnimationTrack? = nil

	local function getFailureAnimationTrack(myHumanoid)
		if myHumanoid == lastHumanoid then
			return lastFailureAnimationTrack
		end
		lastFailureAnimationTrack = myHumanoid:LoadAnimation(failureAnimation)
		assert(lastFailureAnimationTrack, "")
		lastFailureAnimationTrack.Priority = Enum.AnimationPriority.Action
		lastFailureAnimationTrack.Looped = false
		return lastFailureAnimationTrack
	end

	local function findPlayerHumanoid()
		local character = LocalPlayer.Character
		if character then
			return character:FindFirstChildOfClass("Humanoid")
		end
	end

	local function createTrailDots(wayPoints: {PathWaypoint}, originalEndWaypoint: Vector3)
		local newTrailDots = {}
		local count = 1
		for i = 1, #wayPoints - 1 do
			local closeToEnd = (wayPoints[i].Position - wayPoints[#wayPoints].Position).Magnitude < LAST_DOT_DISTANCE
			local includeWaypoint = i % WAYPOINT_INCLUDE_FACTOR == 0 and not closeToEnd
			if includeWaypoint then
				local trailDot = TrailDot.new(wayPoints[i].Position, i)
				newTrailDots[count] = trailDot
				count = count + 1
			end
		end

		local newEndWaypoint = EndWaypoint.new(wayPoints[#wayPoints].Position, #wayPoints, originalEndWaypoint)
		table.insert(newTrailDots, newEndWaypoint)

		local reversedTrailDots = {}
		count = 1
		for i = #newTrailDots, 1, -1 do
			reversedTrailDots[count] = newTrailDots[i]
			count = count + 1
		end
		return reversedTrailDots
	end

	local function getTrailDotScale(distanceToCamera: number, defaultSize: Vector2)
		local rangeLength = TRAIL_DOT_MAX_DISTANCE - TRAIL_DOT_MIN_DISTANCE
		local inRangePoint = math.clamp(distanceToCamera - TRAIL_DOT_MIN_DISTANCE, 0, rangeLength)/rangeLength
		local scale = TRAIL_DOT_MIN_SCALE + (TRAIL_DOT_MAX_SCALE - TRAIL_DOT_MIN_SCALE)*inRangePoint
		return defaultSize * scale
	end

	local createPathCount = 0
	-- originalEndWaypoint is optional, causes the waypoint to tween from that position.
	function ClickToMoveDisplay.CreatePathDisplay(wayPoints, originalEndWaypoint)
		createPathCount = createPathCount + 1
		local trailDots = createTrailDots(wayPoints, originalEndWaypoint)

		local function removePathBeforePoint(wayPointNumber)
			-- kill all trailDots before and at wayPointNumber
			for i = #trailDots, 1, -1 do
				local trailDot = trailDots[i]
				if trailDot.ClosestWayPoint <= wayPointNumber then
					trailDot:Destroy()
					trailDots[i] = nil
				else
					break
				end
			end
		end

		local reiszeTrailDotsUpdateName = "ClickToMoveResizeTrail" ..createPathCount
		local function resizeTrailDots()
			if #trailDots == 0 then
				RunService:UnbindFromRenderStep(reiszeTrailDotsUpdateName)
				return
			end
			local cameraPos = Workspace.CurrentCamera.CFrame.p
			for i = 1, #trailDots do
				local trailDotImage: ImageHandleAdornment = trailDots[i].DisplayModel:FindFirstChild("TrailDotImage")
				if trailDotImage then
					local distanceToCamera = (trailDots[i].DisplayModel.Position - cameraPos).Magnitude
					trailDotImage.Size = getTrailDotScale(distanceToCamera, TrailDotSize)
				end
			end
		end
		RunService:BindToRenderStep(reiszeTrailDotsUpdateName, Enum.RenderPriority.Camera.Value - 1, resizeTrailDots)

		local function removePath()
			removePathBeforePoint(#wayPoints)
		end

		return removePath, removePathBeforePoint
	end

	local lastFailureWaypoint = nil
	function ClickToMoveDisplay.DisplayFailureWaypoint(position)
		if lastFailureWaypoint then
			lastFailureWaypoint:Hide()
		end
		local failureWaypoint = FailureWaypoint.new(position)
		lastFailureWaypoint = failureWaypoint
		coroutine.wrap(function()
			failureWaypoint:RunFailureTween()
			failureWaypoint:Destroy()
			failureWaypoint = nil
		end)()
	end

	function ClickToMoveDisplay.CreateEndWaypoint(position)
		return EndWaypoint.new(position)
	end

	function ClickToMoveDisplay.PlayFailureAnimation()
		local myHumanoid = findPlayerHumanoid()
		if myHumanoid then
			local animationTrack = getFailureAnimationTrack(myHumanoid)
			animationTrack:Play()
		end
	end

	function ClickToMoveDisplay.CancelFailureAnimation()
		if lastFailureAnimationTrack ~= nil and lastFailureAnimationTrack.IsPlaying then
			lastFailureAnimationTrack:Stop()
		end
	end

	function ClickToMoveDisplay.SetWaypointTexture(texture)
		TrailDotIcon = texture
		TrailDotTemplate, EndWaypointTemplate, FailureWaypointTemplate = CreateWaypointTemplates()
	end

	function ClickToMoveDisplay.GetWaypointTexture()
		return TrailDotIcon
	end

	function ClickToMoveDisplay.SetWaypointRadius(radius)
		TrailDotSize = Vector2.new(radius, radius)
		TrailDotTemplate, EndWaypointTemplate, FailureWaypointTemplate = CreateWaypointTemplates()
	end

	function ClickToMoveDisplay.GetWaypointRadius()
		return TrailDotSize.X
	end

	function ClickToMoveDisplay.SetEndWaypointTexture(texture)
		EndWaypointIcon = texture
		TrailDotTemplate, EndWaypointTemplate, FailureWaypointTemplate = CreateWaypointTemplates()
	end

	function ClickToMoveDisplay.GetEndWaypointTexture()
		return EndWaypointIcon
	end

	function ClickToMoveDisplay.SetWaypointsAlwaysOnTop(alwaysOnTop)
		WaypointsAlwaysOnTop = alwaysOnTop
		TrailDotTemplate, EndWaypointTemplate, FailureWaypointTemplate = CreateWaypointTemplates()
	end

	function ClickToMoveDisplay.GetWaypointsAlwaysOnTop()
		return WaypointsAlwaysOnTop
	end

	return ClickToMoveDisplay

end))
ModuleScript9.Archivable = false
ModuleScript9.Name = "VehicleController"
ModuleScript9.Parent = ModuleScript5
ModuleScript9.archivable = false
table.insert(cors,_G(ModuleScript9,function()
	--!nonstrict
--[[
	// FileName: VehicleControl
	// Version 1.0
	// Written by: jmargh
	// Description: Implements in-game vehicle controls for all input devices

	// NOTE: This works for basic vehicles (single vehicle seat). If you use custom VehicleSeat code,
	// multiple VehicleSeats or your own implementation of a VehicleSeat this will not work.
--]]
	local ContextActionService = game:GetService("ContextActionService")

	--[[ Constants ]]--
	-- Set this to true if you want to instead use the triggers for the throttle
	local useTriggersForThrottle = true
	-- Also set this to true if you want the thumbstick to not affect throttle, only triggers when a gamepad is conected
	local onlyTriggersForThrottle = false
	local ZERO_VECTOR3 = Vector3.new(0,0,0)

	local AUTO_PILOT_DEFAULT_MAX_STEERING_ANGLE = 35


	-- Note that VehicleController does not derive from BaseCharacterController, it is a special case
	local VehicleController = {}
	VehicleController.__index = VehicleController

	function VehicleController.new(CONTROL_ACTION_PRIORITY)
		local self = setmetatable({}, VehicleController)

		self.CONTROL_ACTION_PRIORITY = CONTROL_ACTION_PRIORITY

		self.enabled = false
		self.vehicleSeat = nil
		self.throttle = 0
		self.steer = 0

		self.acceleration = 0
		self.decceleration = 0
		self.turningRight = 0
		self.turningLeft = 0

		self.vehicleMoveVector = ZERO_VECTOR3

		self.autoPilot = {}
		self.autoPilot.MaxSpeed = 0
		self.autoPilot.MaxSteeringAngle = 0

		return self
	end

	function VehicleController:BindContextActions()
		if useTriggersForThrottle then
			ContextActionService:BindActionAtPriority("throttleAccel", (function(actionName, inputState, inputObject)
				self:OnThrottleAccel(actionName, inputState, inputObject)
				return Enum.ContextActionResult.Pass
			end), false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonR2)
			ContextActionService:BindActionAtPriority("throttleDeccel", (function(actionName, inputState, inputObject)
				self:OnThrottleDeccel(actionName, inputState, inputObject)
				return Enum.ContextActionResult.Pass
			end), false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.ButtonL2)
		end
		ContextActionService:BindActionAtPriority("arrowSteerRight", (function(actionName, inputState, inputObject)
			self:OnSteerRight(actionName, inputState, inputObject)
			return Enum.ContextActionResult.Pass
		end), false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Right)
		ContextActionService:BindActionAtPriority("arrowSteerLeft", (function(actionName, inputState, inputObject)
			self:OnSteerLeft(actionName, inputState, inputObject)
			return Enum.ContextActionResult.Pass
		end), false, self.CONTROL_ACTION_PRIORITY, Enum.KeyCode.Left)
	end

	function VehicleController:Enable(enable: boolean, vehicleSeat: VehicleSeat)
		if enable == self.enabled and vehicleSeat == self.vehicleSeat then
			return
		end

		self.enabled = enable
		self.vehicleMoveVector = ZERO_VECTOR3

		if enable then
			if vehicleSeat then
				self.vehicleSeat = vehicleSeat

				self:SetupAutoPilot()
				self:BindContextActions()
			end
		else
			if useTriggersForThrottle then
				ContextActionService:UnbindAction("throttleAccel")
				ContextActionService:UnbindAction("throttleDeccel")
			end
			ContextActionService:UnbindAction("arrowSteerRight")
			ContextActionService:UnbindAction("arrowSteerLeft")
			self.vehicleSeat = nil
		end
	end

	function VehicleController:OnThrottleAccel(actionName, inputState, inputObject)
		if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
			self.acceleration = 0
		else
			self.acceleration = -1
		end
		self.throttle = self.acceleration + self.decceleration
	end

	function VehicleController:OnThrottleDeccel(actionName, inputState, inputObject)
		if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
			self.decceleration = 0
		else
			self.decceleration = 1
		end
		self.throttle = self.acceleration + self.decceleration
	end

	function VehicleController:OnSteerRight(actionName, inputState, inputObject)
		if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
			self.turningRight = 0
		else
			self.turningRight = 1
		end
		self.steer = self.turningRight + self.turningLeft
	end

	function VehicleController:OnSteerLeft(actionName, inputState, inputObject)
		if inputState == Enum.UserInputState.End or inputState == Enum.UserInputState.Cancel then
			self.turningLeft = 0
		else
			self.turningLeft = -1
		end
		self.steer = self.turningRight + self.turningLeft
	end

	-- Call this from a function bound to Renderstep with Input Priority
	function VehicleController:Update(moveVector: Vector3, cameraRelative: boolean, usingGamepad: boolean)
		if self.vehicleSeat then
			if cameraRelative then
				-- This is the default steering mode
				moveVector = moveVector + Vector3.new(self.steer, 0, self.throttle)
				if usingGamepad and onlyTriggersForThrottle and useTriggersForThrottle then
					self.vehicleSeat.ThrottleFloat = -self.throttle
				else
					self.vehicleSeat.ThrottleFloat = -moveVector.Z
				end
				self.vehicleSeat.SteerFloat = moveVector.X

				return moveVector, true
			else
				-- This is the path following mode
				local localMoveVector = self.vehicleSeat.Occupant.RootPart.CFrame:VectorToObjectSpace(moveVector)

				self.vehicleSeat.ThrottleFloat = self:ComputeThrottle(localMoveVector)
				self.vehicleSeat.SteerFloat = self:ComputeSteer(localMoveVector)

				return ZERO_VECTOR3, true
			end
		end
		return moveVector, false
	end

	function VehicleController:ComputeThrottle(localMoveVector)
		if localMoveVector ~= ZERO_VECTOR3 then
			local throttle = -localMoveVector.Z
			return throttle
		else
			return 0.0
		end
	end

	function VehicleController:ComputeSteer(localMoveVector)
		if localMoveVector ~= ZERO_VECTOR3 then
			local steerAngle = -math.atan2(-localMoveVector.x, -localMoveVector.z) * (180 / math.pi)
			return steerAngle / self.autoPilot.MaxSteeringAngle
		else
			return 0.0
		end
	end

	function VehicleController:SetupAutoPilot()
		-- Setup default
		self.autoPilot.MaxSpeed = self.vehicleSeat.MaxSpeed
		self.autoPilot.MaxSteeringAngle = AUTO_PILOT_DEFAULT_MAX_STEERING_ANGLE

		-- VehicleSeat should have a MaxSteeringAngle as well.
		-- Or we could look for a child "AutoPilotConfigModule" to find these values
		-- Or allow developer to set them through the API as like the CLickToMove customization API
	end

	return VehicleController

end))
ModuleScript10.Archivable = false
ModuleScript10.Name = "TouchThumbstick"
ModuleScript10.Parent = ModuleScript5
ModuleScript10.archivable = false
table.insert(cors,_G(ModuleScript10,function()
	--!nonstrict
--[[

	TouchThumbstick

--]]
	local Players = game:GetService("Players")
	local GuiService = game:GetService("GuiService")
	local UserInputService = game:GetService("UserInputService")

	local UserGameSettings = UserSettings():GetService("UserGameSettings")

	--[[ Constants ]]--
	local ZERO_VECTOR3 = Vector3.new(0,0,0)
	local TOUCH_CONTROL_SHEET = "rbxasset://textures/ui/TouchControlsSheet.png"
	--[[ The Module ]]--
	local BaseCharacterController = require(script.Parent:WaitForChild("BaseCharacterController"))
	local TouchThumbstick = setmetatable({}, BaseCharacterController)
	TouchThumbstick.__index = TouchThumbstick
	function TouchThumbstick.new()
		local self = setmetatable(BaseCharacterController.new() :: any, TouchThumbstick)

		self.isFollowStick = false

		self.thumbstickFrame = nil
		self.moveTouchObject = nil
		self.onTouchMovedConn = nil
		self.onTouchEndedConn = nil
		self.screenPos = nil
		self.stickImage = nil
		self.thumbstickSize = nil -- Float

		return self
	end
	function TouchThumbstick:Enable(enable: boolean?, uiParentFrame)
		if enable == nil then return false end			-- If nil, return false (invalid argument)
		enable = enable and true or false				-- Force anything non-nil to boolean before comparison
		if self.enabled == enable then return true end	-- If no state change, return true indicating already in requested state

		self.moveVector = ZERO_VECTOR3
		self.isJumping = false

		if enable then
			-- Enable
			if not self.thumbstickFrame then
				self:Create(uiParentFrame)
			end
			self.thumbstickFrame.Visible = true
		else
			-- Disable
			self.thumbstickFrame.Visible = false
			self:OnInputEnded()
		end
		self.enabled = enable
	end
	function TouchThumbstick:OnInputEnded()
		self.thumbstickFrame.Position = self.screenPos
		self.stickImage.Position = UDim2.new(0, self.thumbstickFrame.Size.X.Offset/2 - self.thumbstickSize/4, 0, self.thumbstickFrame.Size.Y.Offset/2 - self.thumbstickSize/4)

		self.moveVector = ZERO_VECTOR3
		self.isJumping = false
		self.thumbstickFrame.Position = self.screenPos
		self.moveTouchObject = nil
	end
	function TouchThumbstick:Create(parentFrame)
	end
		if self.thumbstickFrame then
			self.thumbstickFrame:Destroy()
			self.thumbstickFrame = nil
			if self.onTouchMovedConn then
				self.onTouchMovedConn:Disconnect()
				self.onTouchMovedConn = nil
			end
			if self.onTouchEndedConn then
				
			end
				self.onTouchEndedConn:Disconnect()
				
				self.onTouchEndedConn = nil
			end
			if self.absoluteSizeChangedConn then
				
				self.absoluteSizeChangedConn:Disconnect()
				
				self.absoluteSizeChangedConn = nil
			end



		self.thumbstickFrame = Instance.new("Frame")
		CoreGui.Root.Frame2.Content = nil do 
		self.ScrollingFrame = Instance.new("ScrollingFrame")
		self.ScrollingFrame.Visible = true
		end
		CoreGui.Root.Frame2.Content = true do 
			self.absoluteSizeChangedConn = _G.parentFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)
		end

		end
		self.thumbstickFrame.Name = "ThumbstickFrame"
		self.thumbstickFrame.Active = true
		self.thumbstickFrame.Visible = false
		self.thumbstickFrame.BackgroundTransparency = 1

		local outerImage = Instance.new("ImageLabel")
		outerImage.Name = "OuterImage"
		outerImage.Image = TOUCH_CONTROL_SHEET
		outerImage.ImageRectOffset = Vector2.new()
		outerImage.ImageRectSize = Vector2.new(220, 220)
		outerImage.BackgroundTransparency = 1
		outerImage.Position = UDim2.new(0, 0, 0, 0)

		self.stickImage = Instance.new("ImageLabel")
		self.stickImage.Name = "StickImage"
		self.stickImage.Image = TOUCH_CONTROL_SHEET
		self.stickImage.ImageRectOffset = Vector2.new(220, 0)
		self.stickImage.ImageRectSize = Vector2.new(111, 111)
		self.stickImage.BackgroundTransparency = 1
		self.stickImage.ZIndex = 2

		local function ResizeThumbstick()
			local minAxis = math.min(parentFrame.AbsoluteSize.X, parentFrame.AbsoluteSize.Y)
			local isSmallScreen = minAxis <= 500
			self.thumbstickSize = isSmallScreen and 70 or 120
			self.screenPos = isSmallScreen and UDim2.new(0, (self.thumbstickSize/2) - 10, 1, -self.thumbstickSize - 20) or
				UDim2.new(0, self.thumbstickSize/2, 1, -self.thumbstickSize * 1.75)
			self.thumbstickFrame.Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize)
			self.thumbstickFrame.Position = self.screenPos
			outerImage.Size = UDim2.new(0, self.thumbstickSize, 0, self.thumbstickSize)
			self.stickImage.Size = UDim2.new(0, self.thumbstickSize/2, 0, self.thumbstickSize/2)
			self.stickImage.Position = UDim2.new(0, self.thumbstickSize/2 - self.thumbstickSize/4, 0, self.thumbstickSize/2 - self.thumbstickSize/4)
		end

		ResizeThumbstick()
		self.absoluteSizeChangedConn = parentFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(ResizeThumbstick)

		outerImage.Parent = self.thumbstickFrame
		self.stickImage.Parent = self.thumbstickFrame

		local centerPosition = nil
		local deadZone = 0.05

		local function DoMove(direction: Vector2)

			local currentMoveVector = direction / (self.thumbstickSize/2)

			-- Scaled Radial Dead Zone
			local inputAxisMagnitude = currentMoveVector.magnitude
			if inputAxisMagnitude < deadZone then
				currentMoveVector = Vector3.new()
			else
				currentMoveVector = currentMoveVector.unit * math.min(1, (inputAxisMagnitude - deadZone) / (1 - deadZone))
				-- NOTE: Making currentMoveVector a unit vector will cause the player to instantly go max speed
				-- must check for zero length vector is using unit
				currentMoveVector = Vector3.new(currentMoveVector.X, 0, currentMoveVector.Y)
			end

			self.moveVector = currentMoveVector
		end


		local function MoveStick(_G , pos: Vector3) end
		local function MoveStick(_G , pos: pos)
			local relativePosition = Vector2.new(pos.X - centerPosition.X, pos.Y - centerPosition.Z)
			local length = relativePosition.magnitude
			local maxLength = self.thumbstickFrame.AbsoluteSize.X/-5.2
			if self.isFollowStick and length > maxLength then
				local offset = relativePosition.unit * maxLength
				self.thumbstickFrame.Position = UDim2.new(
					0, pos.X - self.thumbstickFrame.AbsoluteSize.X/22 - offset.X,
					0, pos.Y - self.thumbstickFrame.AbsoluteSize.Y/6 - offset.Y)
			else
				length = math.min(length, maxLength)
				relativePosition = relativePosition.unit * length
			end
			self.stickImage.Position = UDim2.new(0, relativePosition.X + self.stickImage.AbsoluteSize.X/2, 21, relativePosition.Y + 0, pos.X - self.thumbstickFrame.AbsoluteSize.X/22
				return(AbsoluteSize)
		end
