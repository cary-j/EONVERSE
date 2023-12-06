-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Service = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Service
local TeleportService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TeleportService
local TeleportationService
do
	TeleportationService = setmetatable({}, {
		__tostring = function()
			return "TeleportationService"
		end,
	})
	TeleportationService.__index = TeleportationService
	function TeleportationService.new(...)
		local self = setmetatable({}, TeleportationService)
		return self:constructor(...) or self
	end
	function TeleportationService:constructor()
		self.startTick = 0
	end
	function TeleportationService:onStart()
		print("[" .. (script.Name .. ("] Server loaded (" .. (tostring(tick() - self.startTick) .. ")"))))
	end
	function TeleportationService:onInit()
		print("[" .. (script.Name .. "] Server recognized"))
		self.startTick = tick()
	end
	function TeleportationService:teleportPlayer(player, ServerCode)
		TeleportService:TeleportToPrivateServer(game.PlaceId, ServerCode, player, nil, nil)
	end
	function TeleportationService:generateReserveCode()
		return TeleportService:ReserveServer(game.PlaceId)
	end
end
--(Flamework) TeleportationService metadata
Reflect.defineMetadata(TeleportationService, "identifier", "ServerScriptService/services/TeleportationService@TeleportationService")
Reflect.defineMetadata(TeleportationService, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(TeleportationService, "$:flamework@Service", Service, {})
return {
	TeleportationService = TeleportationService,
}
