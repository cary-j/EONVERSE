-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Service = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Service
local HttpService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local Events = TS.import(script, game:GetService("ServerScriptService"), "Source", "network").Events
local CrossMessage = TS.import(script, game:GetService("ServerScriptService"), "Source", "services", "CrossMessage").CrossMessage
--type AllowedServersByPlayer = (key: Number) => { ReserveCode: String, OwnerId: number, Privacy: PrivacyType, PrivacyReason?: string }
local HubService
do
	HubService = setmetatable({}, {
		__tostring = function()
			return "HubService"
		end,
	})
	HubService.__index = HubService
	function HubService.new(...)
		local self = setmetatable({}, HubService)
		return self:constructor(...) or self
	end
	function HubService:constructor(DataService, TeleportationService)
		self.DataService = DataService
		self.TeleportationService = TeleportationService
		self.IsPrivateServer = false
		self.IsReserveServer = false
		self.startTick = 0
		self.Started = false
		self.ReserveServer = nil
		self.AllowedServersByPlayer = {}
		self.FullServerList = {}
		self.ServerAccessMessage = CrossMessage.new("server:access")
	end
	function HubService:getPlayerAllowedServers(player, cache)
		if cache == nil then
			cache = false
		end
		local _value = cache and self.AllowedServersByPlayer[player.UserId]
		if _value ~= 0 and (_value == _value and (_value ~= "" and _value)) then
			return self.AllowedServersByPlayer[player.UserId]
		end
		self.AllowedServersByPlayer[player.UserId] = {}
		Events.loadingScreenMessage(player, "Getting server list.")
		--   this.CrossMessage////ssssssssssssssssssssssssssssssssssss
	end
	function HubService:onStart()
		print("[" .. (script.Name .. ("] Server loaded (" .. (tostring(tick() - self.startTick) .. ")"))))
		if game.PrivateServerId ~= "" then
			if game.PrivateServerOwnerId == 0 then
				--Is reserve
				self.IsReserveServer = true
				local ReserveServerData = self.DataService:getReserveServerDocument()
				print(ReserveServerData, HttpService:JSONEncode(ReserveServerData))
			else
				--Is private
				self.IsPrivateServer = true
				local _exp = self.DataService:getPrivateServerDocument()
				local _arg0 = function(doc)
					local data = doc:read()
					if data.ReserveCode ~= "" then
						--tp players
						local _condition = data.ReserveCode
						if not (_condition ~= "" and _condition) then
							_condition = "wrong if"
						end
						self.ReserveServer = _condition
					else
						-- create code to tp
						local ReserveCode, ReserveId = self.TeleportationService:generateReserveCode()
						self.ReserveServer = ReserveCode
						doc:write({
							ReserveCode = ReserveCode,
							OwnerId = game.PrivateServerOwnerId,
						})
						local _exp_1 = self.DataService:getReserveServerDocument(ReserveId)
						local _arg0_1 = function(reserveDoc)
							--   reserveDoc.write({ ReserveCode: ReserveCode, OwnerId: game.PrivateServerOwnerId, CommandLogs: [], RaidLogs: [] });
							reserveDoc:close()
						end
						_exp_1:andThen(_arg0_1)
						doc:close()
					end
				end
				_exp:andThen(_arg0)
			end
		else
			--Pending hub
		end
		self.Started = true
	end
	function HubService:playerAdded(player)
		while not self.Started do
			wait()
		end
		local _exp = self.IsPrivateServer
		local _exp_1 = self.IsReserveServer
		local _condition = self.ReserveServer
		if not (_condition ~= "" and _condition) then
			_condition = "null"
		end
		print(_exp, _exp_1, _condition)
		wait(5)
		if self.IsPrivateServer then
			Events.loadingScreenMessage(player, "Teleporting to server.")
			local _value = self.ReserveServer
			if not (_value ~= "" and _value) then
				return player:Kick("Server failed to start properly.")
			end
			self.TeleportationService:teleportPlayer({ player }, self.ReserveServer)
		else
			-- Events.loadingScreenMessage(player, `Is a Hub Server: ${this.IsPrivateServer === false && this.IsReserveServer === false}\n Is Reserve Server: ${this.IsReserveServer}`)
		end
	end
	function HubService:onInit()
		print("[" .. (script.Name .. "] Server recognized"))
		self.startTick = tick()
		self.ServerAccessMessage:addSubscription(function(data, isReturn)
			if not isReturn then
				return nil
			end
			local ReturnFor = data[3]
			if ReturnFor == "all" then
				local ServerData = string.split(data[4], "&")
				local configuredData = {}
				local _arg0 = function(value)
					local data = string.split(value, "=")
					configuredData[data[1]] = data[2]
				end
				for _k, _v in ServerData do
					_arg0(_v, _k - 1, ServerData)
				end
			elseif ReturnFor == "player" then
				local ServerData = string.split(data[5], "&")
				local UserId = tonumber(data[4])
				if not (type(UserId) == "number") then
					return nil
				end
				local configuredData = {}
				local _arg0 = function(value)
					local data = string.split(value, "=")
					configuredData[data[1]] = data[2]
				end
				for _k, _v in ServerData do
					_arg0(_v, _k - 1, ServerData)
				end
				self.AllowedServersByPlayer[UserId] = configuredData
			end
		end)
	end
	function HubService:isPrivateServer()
		while not self.Started do
			wait()
		end
		return self.IsPrivateServer
	end
	function HubService:isReserveServer()
		while not self.Started do
			wait()
		end
		return self.IsReserveServer
	end
end
--(Flamework) HubService metadata
Reflect.defineMetadata(HubService, "identifier", "ServerScriptService/services/HubService@HubService")
Reflect.defineMetadata(HubService, "flamework:parameters", { "ServerScriptService/services/DataService@DataService", "ServerScriptService/services/TeleportationService@TeleportationService" })
Reflect.defineMetadata(HubService, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(HubService, "$:flamework@Service", Service, {})
return {
	HubService = HubService,
}
