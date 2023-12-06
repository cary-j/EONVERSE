-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Service = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Service
local _lapis = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "lapis", "out")
local createCollection = _lapis.createCollection
local setConfig = _lapis.setConfig
local t = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local Events = TS.import(script, game:GetService("ServerScriptService"), "Source", "network").Events
setConfig({
	saveAttempts = 5,
	loadAttempts = 5,
	loadRetryDelay = 3,
	showRetryWarnings = true,
})
local PlayerCollection = createCollection("PlayerData", {
	defaultData = {
		totalDeaths = 0,
		totalKills = 0,
		ReserveCode = "",
		PrivateServers = {},
	},
	validate = t.strictInterface({
		totalDeaths = t.number,
		totalKills = t.number,
		ReserveCode = t.string,
		PrivateServers = t.array(t.string),
	}),
})
local ReserveServerCollection = createCollection("ReserveServerData", {
	defaultData = {
		ReserveCode = "",
		OwnerId = 0,
		CommandLogs = {},
		RaidLogs = {},
		Admins = {
			Groups = {},
			Players = {},
		},
		Privacy = {
			Type = "private",
			CodeEnabled = false,
			Code = "",
			FriendsCanJoin = false,
			GroupCanJoin = {},
			LaunchJoinEnabled = false,
			LaunchJoinCode = "",
		},
		TermType = "",
		TermSettings = {},
	},
	validate = t.strictInterface({
		ReserveCode = t.string,
		OwnerId = t.number,
		CommandLogs = t.array(t.interface({
			SenderId = t.number,
			Command = t.string,
			Time = t.number,
		})),
		RaidLogs = t.array(t.interface({
			DefendingGroup = t.number,
			RaidingGroup = t.number,
			Overtime = t.boolean,
			GameLength = t.number,
			MaxTime = t.number,
			BluePoints = t.number,
			RedPoints = t.number,
			WinTime = t.number,
		})),
		Admins = t.interface({
			Groups = t.map(t.number, t.array(t.number)),
			Players = t.array(t.number),
		}),
		Privacy = t.interface({
			Type = t.literal("public", "private"),
			CodeEnabled = t.boolean,
			Code = t.string,
			FriendsCanJoin = t.boolean,
			GroupCanJoin = t.array(t.number),
			LaunchJoinEnabled = t.boolean,
			LaunchJoinCode = t.string,
		}),
		TermType = t.string,
		TermSettings = t.interface({}),
	}),
})
local PrivateServerCollection = createCollection("PrivateServerData", {
	defaultData = {
		ReserveCode = "",
		OwnerId = 0,
	},
	validate = t.strictInterface({
		ReserveCode = t.string,
		OwnerId = t.number,
	}),
})
local GenerateLeaderStats
do
	GenerateLeaderStats = setmetatable({}, {
		__tostring = function()
			return "GenerateLeaderStats"
		end,
	})
	GenerateLeaderStats.__index = GenerateLeaderStats
	function GenerateLeaderStats.new(...)
		local self = setmetatable({}, GenerateLeaderStats)
		return self:constructor(...) or self
	end
	function GenerateLeaderStats:constructor(player)
		self.Kills = Instance.new("NumberValue")
		self.Deaths = Instance.new("NumberValue")
		local folder = Instance.new("Folder")
		folder.Name = "leaderstats"
		self.Kills.Name = "Kills"
		self.Deaths.Name = "Deaths"
		self.Kills.Value = 0
		self.Deaths.Value = 0
		self.Kills.Parent = folder
		self.Deaths.Parent = folder
		folder.Parent = player
	end
	function GenerateLeaderStats:getKills()
		return self.Kills.Value
	end
	function GenerateLeaderStats:getDeaths()
		return self.Deaths.Value
	end
	function GenerateLeaderStats:resetAll()
		self.Kills.Value = 0
		self.Deaths.Value = 0
	end
	function GenerateLeaderStats:reset(value)
		if value == "kills" then
			self.Kills.Value = 0
		elseif value == "deaths" then
			self.Deaths.Value = 0
		end
	end
end
local LeaderStats
do
	LeaderStats = setmetatable({}, {
		__tostring = function()
			return "LeaderStats"
		end,
	})
	LeaderStats.__index = LeaderStats
	function LeaderStats.new(...)
		local self = setmetatable({}, LeaderStats)
		return self:constructor(...) or self
	end
	function LeaderStats:constructor()
	end
	function LeaderStats:getPlayerStats(player)
		if player:FindFirstChild("leaderstats") then
			return player.leaderstats
		end
	end
	function LeaderStats:resetPlayerStats(player)
		if player:FindFirstChild("leaderstats") then
			local _exp = player.leaderstats:GetChildren()
			local _arg0 = function(value)
				local _value = value
				if _value.ClassName == "NumberValue" then
					value.Value = 0
				end
			end
			for _k, _v in _exp do
				_arg0(_v, _k - 1, _exp)
			end
		end
	end
end
local DataService
do
	DataService = setmetatable({}, {
		__tostring = function()
			return "DataService"
		end,
	})
	DataService.__index = DataService
	function DataService.new(...)
		local self = setmetatable({}, DataService)
		return self:constructor(...) or self
	end
	function DataService:constructor(HubService)
		self.HubService = HubService
		self.startTick = 0
		self.playerDocuments = {}
	end
	function DataService:playerAdded(player)
		Events.loadingScreenMessage(player, "Loading player data")
		local _exp = PlayerCollection:load(tostring(player.UserId))
		local _arg0 = function(document)
			self.playerDocuments[tostring(player.UserId)] = document
			Events.loadingScreenMessage(player, "Data loaded")
		end
		_exp:andThen(_arg0):catch(warn)
	end
	function DataService:playerRemoving(player)
		local doc = self.playerDocuments[tostring(player.UserId)]
		if doc then
			doc:close()
			doc = nil
		end
	end
	function DataService:onStart()
		print("[" .. (script.Name .. ("] Server loaded (" .. (tostring(tick() - self.startTick) .. ")"))))
	end
	function DataService:onInit()
		print("[" .. (script.Name .. "] Server recognized"))
		self.startTick = tick()
	end
	function DataService:getReserveServerDocument(id)
		if id == nil then
			id = nil
		end
		return TS.Promise.new(TS.async(function(resolve)
			local _fn = ReserveServerCollection
			local _condition = id
			if not (_condition ~= "" and _condition) then
				_condition = game.PrivateServerId
			end
			local document = TS.await(_fn:load(_condition))
			resolve(document)
		end))
	end
	function DataService:getPrivateServerDocument(id)
		if id == nil then
			id = nil
		end
		return TS.Promise.new(TS.async(function(resolve)
			local _fn = PrivateServerCollection
			local _condition = id
			if not (_condition ~= "" and _condition) then
				_condition = game.PrivateServerId
			end
			local document = TS.await(_fn:load(_condition))
			return resolve(document)
		end))
	end
end
--(Flamework) DataService metadata
Reflect.defineMetadata(DataService, "identifier", "ServerScriptService/services/DataService@DataService")
Reflect.defineMetadata(DataService, "flamework:parameters", { "ServerScriptService/services/HubService@HubService" })
Reflect.defineMetadata(DataService, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(DataService, "$:flamework@Service", Service, {})
return {
	GenerateLeaderStats = GenerateLeaderStats,
	LeaderStats = LeaderStats,
	DataService = DataService,
}
