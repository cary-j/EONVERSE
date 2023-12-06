-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Controller = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local Players = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local LocalPlayer = Players.LocalPlayer
local InterfaceController
do
	InterfaceController = setmetatable({}, {
		__tostring = function()
			return "InterfaceController"
		end,
	})
	InterfaceController.__index = InterfaceController
	function InterfaceController.new(...)
		local self = setmetatable({}, InterfaceController)
		return self:constructor(...) or self
	end
	function InterfaceController:constructor()
	end
	function InterfaceController:onStart()
	end
	function InterfaceController:onInit()
	end
	function InterfaceController:getPlayerGui()
		while not LocalPlayer.PlayerGui:FindFirstChild("Loading") or not LocalPlayer.PlayerGui:FindFirstChild("MainServer") do
			wait()
		end
		local pg = LocalPlayer.PlayerGui
		return pg
	end
end
--(Flamework) InterfaceController metadata
Reflect.defineMetadata(InterfaceController, "identifier", "StarterPlayerScripts/controllers/InterfaceController@InterfaceController")
Reflect.defineMetadata(InterfaceController, "flamework:implements", { "$:flamework@OnInit", "$:flamework@OnStart" })
Reflect.decorate(InterfaceController, "$:flamework@Controller", Controller, {})
return {
	InterfaceController = InterfaceController,
}
