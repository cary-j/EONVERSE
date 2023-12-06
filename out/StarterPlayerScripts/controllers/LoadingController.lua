-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Controller = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local Events = TS.import(script, script.Parent.Parent, "network").Events
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ContentProvider = _services.ContentProvider
local ReplicatedFirst = _services.ReplicatedFirst
local TweenService = _services.TweenService
local RunController
do
	RunController = setmetatable({}, {
		__tostring = function()
			return "RunController"
		end,
	})
	RunController.__index = RunController
	function RunController.new(...)
		local self = setmetatable({}, RunController)
		return self:constructor(...) or self
	end
	function RunController:constructor(InterfaceController)
		self.InterfaceController = InterfaceController
		self.InLoading = true
		self.CurrentLoadingMessage = "Loading Client"
		self.PlayerGui = InterfaceController:getPlayerGui()
		self.LoadingUi = self.PlayerGui.Loading
	end
	function RunController:StartAnimations()
		local primaryUi = self.LoadingUi.Primary
		task.spawn(function()
			while self.InLoading do
				local transparency = 0
				if primaryUi.Bottom.CurrentLoading.TextTransparency >= .85 then
					transparency = 0
				else
					if primaryUi.Bottom.CurrentLoading.Text == self.CurrentLoadingMessage then
						transparency = .85
					else
						transparency = 1
					end
				end
				local anim = TweenService:Create(primaryUi.Bottom.CurrentLoading, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {
					TextTransparency = transparency,
				})
				anim:Play()
				task.wait(1.5)
				if primaryUi.Bottom.CurrentLoading.TextTransparency == 1 then
					task.wait(.1)
					primaryUi.Bottom.CurrentLoading.Text = self.CurrentLoadingMessage
					task.wait(.1)
				end
			end
		end)
		local _exp = primaryUi.Top:GetChildren()
		local _arg0 = function(v)
			local _v = v
			if _v.ClassName == "Frame" then
				task.spawn(function()
					while self.InLoading do
						local x = (math.random() + v.Position.X.Scale - .1) * v.Position.X.Scale + .1
						local y = (math.random() + v.Position.Y.Scale - .1) * v.Position.Y.Scale + .1
						x = math.clamp(x, .2, .5)
						y = math.clamp(y, .3, .4)
						local anim = TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Linear), {
							Position = UDim2.fromScale(x, y),
						})
						anim:Play()
						task.wait(.7)
					end
				end)
			end
		end
		for _k, _v in _exp do
			_arg0(_v, _k - 1, _exp)
		end
	end
	function RunController:onStart()
		Events.loadingScreenMessage:connect(function(text)
			self.CurrentLoadingMessage = text
		end)
		Events.loadingDone:connect(function(done)
			if done then
				self.InLoading = false
			end
		end)
	end
	function RunController:onInit()
		ReplicatedFirst:RemoveDefaultLoadingScreen()
		self:StartAnimations()
		ContentProvider:PreloadAsync(game.Workspace:GetDescendants())
	end
end
--(Flamework) RunController metadata
Reflect.defineMetadata(RunController, "identifier", "StarterPlayerScripts/controllers/LoadingController@RunController")
Reflect.defineMetadata(RunController, "flamework:parameters", { "StarterPlayerScripts/controllers/InterfaceController@InterfaceController" })
Reflect.defineMetadata(RunController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(RunController, "$:flamework@Controller", Controller, {})
return {
	RunController = RunController,
}
