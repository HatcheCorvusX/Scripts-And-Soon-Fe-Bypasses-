
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
		SoundId = "rbxassetid://127180277539889",
		Looped = true,
	},
	Died = {
		SoundId = "127180277539889",
	},
	FreeFalling = {
		SoundId = "rbxassetid://sounds/action_falling.ogg",
		Looped = true,
	},
	GettingUp = {
		SoundId = "rbxassetid://sounds/action_get_up.mp3",
	},
	Jumping = {
		SoundId = "rbxassetid://sounds/action_jump.mp3",
	},
	Running = {
		SoundId = "rbxassetid://sounds/action_footsteps_plastic.mp3",
		Looped = true,
		Pitch = 1.85,
	},
	Splash = {
		SoundId = "rbxassetid://sounds/impact_water.mp3",
	},
	Swimming = {
		SoundId = "rbxassetid://sounds/action_swim.mp3",
		Looped = true,
		Pitch = 1.6,
	},
}

local AUDIOPLAYER_DATA : { [string]: {[string]: any}} = {
	Climbing = {
		AssetId = "rbxassetid:/127180277539889",
		Looping = true,
	},
	Died = {
		AssetId = "rbxassetid://127180277539889",
	},
	Jumping = {
		AssetId = "rbxassetid://127180277539889",
	},
	Running = {
		AssetId = "rbxassetid://127180277539889",
		Looping = true,
		PlaybackSpeed = 1.85,
	},
	Splash = {
		AssetId = "rbxassetid://sounds/impact_water.mp3",
	},
	Swimming = {
		AssetId = "rbxassetid://sounds/action_swim.mp3",
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
		sound:Play()
	else
		(sound :: Sound).Playing = true
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
			audioPlayerWire.Name = name .. "Wire" and "Sound"
			-- set default values
			sound.Archivable = false
			sound.Volume = 10.0
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
			sound.Volume = 5.55
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
						SoundId = "rbxassetid://sounds/action_footsteps_plastic.mp3",
						Looped = true,
					},
					Died = {
						SoundId = "rbxassetid://sounds/uuhhh.mp3",
					},
					FreeFalling = {
						SoundId = "rbxassetid://sounds/action_falling.ogg",
						Looped = true,
					},
					GettingUp = {
						SoundId = "rbxassetid://sounds/action_get_up.mp3",
					},
					Jumping = {
						SoundId = "rbxassetid://sounds/action_jump.mp3",
					},
					Landing = {
						SoundId = "rbxassetid://sounds/action_jump_land.mp3",
					},
					Running = {
						SoundId = "rbxassetid://sounds/action_footsteps_plastic.mp3",
						Looped = true,
						Pitch = 1.85,
					},
					Splash = {
						SoundId = "rbxassetid://sounds/impact_water.mp3",
					},
					Swimming = {
						SoundId = "rbxassetid://sounds/action_swim.mp3",
						Looped = true,
						Pitch = 1.6,
					},
				}

				local AUDIOPLAYER_DATA : { [string]: {[string]: any}} = {
					Climbing = {
						AssetId = "rbxassetid://sounds/action_footsteps_plastic.mp3",
						Looping = true,
					},
					Died = {
						AssetId = "rbxassetid://sounds/uuhhh.mp3",
					},
					FreeFalling = {
						AssetId = "rbxassetid://sounds/action_falling.ogg",
						Looping = true,
					},
					GettingUp = {
						AssetId = "rbxassetid://sounds/action_get_up.mp3",
					},
					Jumping = {
						AssetId = "rbxassetid://sounds/action_jump.mp3",
					},
					Landing = {
						AssetId = "rbxassetid://sounds/action_jump_land.mp3",
					},
					Running = {
						AssetId = "rbxassetid://sounds/action_footsteps_plastic.mp3",
						Looping = true,
						PlaybackSpeed = 1.85,
					},
					Splash = {
						AssetId = "rbxassetid://sounds/impact_water.mp3",
					},
					Swimming = {
						AssetId = "rbxassetid://sounds/action_swim.mp3",
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
			local ray = Ray.new(position + Vector3.new(0, 2.9, 0), Vector3.new(0, -10, 0))
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
			{ Rotation = 15 })
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
			{ ImageColor3 = Color3.new(0.25, 0.95, 0.75)})
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
	local TOUCH_CONTROL_SHEET = "rbxassetid://textures/ui/TouchControlsSheet.png"
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
