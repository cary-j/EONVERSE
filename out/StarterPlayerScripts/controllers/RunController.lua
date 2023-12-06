-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Controller = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
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
	function RunController:constructor()
	end
	function RunController:onStart()
	end
end
--(Flamework) RunController metadata
Reflect.defineMetadata(RunController, "identifier", "StarterPlayerScripts/controllers/RunController@RunController")
Reflect.defineMetadata(RunController, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(RunController, "$:flamework@Controller", Controller, {})
return {
	RunController = RunController,
}
