-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Service = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Service
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players = _services.Players
local Teams = _services.Teams
local GenerateLeaderStats = TS.import(script, game:GetService("ServerScriptService"), "Source", "services", "DataService").GenerateLeaderStats
--import { DualCap } from "./RaidService";
--[=[
	
	const bb = new CrossMessage("ee");
	bb.addSubscription((b: unknown, c: number) => {
	    print(b, c)
	})
	bb.publish("a").catch(warn)
	
	const aa = new DualCap()
	aa.start();
	aa.updateVales(new Map([["key", "value"]]))
]=]
local AllowedPlayers = { "minecraft2fun", -1, -2, "DevMinecraft2fun" }
local PlayerService
do
	PlayerService = setmetatable({}, {
		__tostring = function()
			return "PlayerService"
		end,
	})
	PlayerService.__index = PlayerService
	function PlayerService.new(...)
		local self = setmetatable({}, PlayerService)
		return self:constructor(...) or self
	end
	function PlayerService:constructor(DataService, HubService)
		self.DataService = DataService
		self.HubService = HubService
		self.startTick = 0
	end
	function PlayerService:onStart()
		print("[" .. (script.Name .. ("] Server loaded (" .. (tostring(tick() - self.startTick) .. ")"))))
	end
	function PlayerService:onInit()
		print("[" .. (script.Name .. "] Server recognized"))
		self.startTick = tick()
		Players.PlayerAdded:Connect(function(p)
			return self:playerAdded(p)
		end)
		Players.PlayerRemoving:Connect(function(p)
			return self:playerRemoving(p)
		end)
		local _exp = Players:GetPlayers()
		local _arg0 = function(p)
			return self:playerAdded(p)
		end
		for _k, _v in _exp do
			_arg0(_v, _k - 1, _exp)
		end
	end
	function PlayerService:playerAdded(player)
		local allowed = false
		for _, value in AllowedPlayers do
			if type(value) == "string" and value == player.Name then
				allowed = true
				break
			elseif type(value) == "number" and value == player.UserId then
				allowed = true
				break
			end
		end
		if not allowed then
			player:Kick("Game is currently in testing")
		end
		self.DataService:playerAdded(player)
		self.HubService:playerAdded(player)
		local leaderStats = GenerateLeaderStats.new(player)
		player.Chatted:Connect(function(msg)
			if msg == "red" then
				player.Team = Teams.Red
			elseif msg == "blue" then
				player.Team = Teams.Blue
			end
		end)
	end
	function PlayerService:playerRemoving(player)
		self.DataService:playerRemoving(player)
	end
end
--(Flamework) PlayerService metadata
Reflect.defineMetadata(PlayerService, "identifier", "ServerScriptService/services/PlayerService@PlayerService")
Reflect.defineMetadata(PlayerService, "flamework:parameters", { "ServerScriptService/services/DataService@DataService", "ServerScriptService/services/HubService@HubService" })
Reflect.defineMetadata(PlayerService, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(PlayerService, "$:flamework@Service", Service, {})
return {
	PlayerService = PlayerService,
}
