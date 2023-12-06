-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local Service = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Service
local _services = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players = _services.Players
local Teams = _services.Teams
local Workspace = _services.Workspace
local Terminal
do
	Terminal = setmetatable({}, {
		__tostring = function()
			return "Terminal"
		end,
	})
	Terminal.__index = Terminal
	function Terminal.new(...)
		local self = setmetatable({}, Terminal)
		return self:constructor(...) or self
	end
	function Terminal:constructor()
	end
	function Terminal:GetTermHolds()
		return Workspace:GetPartBoundsInBox(Workspace.Term.CFrame, Vector3.new(Workspace.Term.Size.X, 30, Workspace.Term.Size.Z))
	end
	function Terminal:GetTermPlayers()
		local TermHolds = self:GetTermHolds()
		local players = {}
		local _arg0 = function(part)
			local _condition = part.Name == "HumanoidRootPart"
			if _condition then
				local _result = part.Parent
				if _result ~= nil then
					_result = _result:FindFirstChild("Humanoid")
				end
				_condition = _result
			end
			if _condition then
				local player = Players:GetPlayerFromCharacter(part.Parent)
				local _humanoid = part.Parent
				if _humanoid ~= nil then
					_humanoid = _humanoid:FindFirstChild("Humanoid")
				end
				local humanoid = _humanoid
				if humanoid and (player and (humanoid:IsA("Humanoid") and humanoid.Health > 0)) then
					table.insert(players, player)
				end
			end
		end
		for _k, _v in TermHolds do
			_arg0(_v, _k - 1, TermHolds)
		end
		return players
	end
end
local BaseSystem
do
	BaseSystem = setmetatable({}, {
		__tostring = function()
			return "BaseSystem"
		end,
	})
	BaseSystem.__index = BaseSystem
	function BaseSystem.new(...)
		local self = setmetatable({}, BaseSystem)
		return self:constructor(...) or self
	end
	function BaseSystem:constructor(MaxTime, Overtime, CaptureSpeed)
		self.MaxTime = MaxTime
		self.Overtime = Overtime
		self.CaptureSpeed = CaptureSpeed
		self.timer = 0
		self.Running = false
		self.blueHold = 0
		self.redHold = 0
		self.bluePoints = 0
		self.redPoints = 0
		self.currentHolder = nil
	end
	function BaseSystem:deployWin(winTeam)
		self.Running = false
		print(winTeam.Name .. " has won the round!")
	end
	function BaseSystem:captureHandler()
		while self.Running == true do
			wait()
			local TermHolds = Terminal:GetTermPlayers()
			local _arg0 = function(player)
				local playerTeam = player.Team
				if playerTeam == Teams.Red then
					self.redHold += self.CaptureSpeed
					self.blueHold -= self.CaptureSpeed
				elseif playerTeam == Teams.Blue then
					self.redHold -= self.CaptureSpeed
					self.blueHold += self.CaptureSpeed
				end
				if self.redHold >= 1 and self.currentHolder ~= Teams.Red then
					self.currentHolder = Teams.Red
				elseif self.blueHold >= 1 and self.currentHolder ~= Teams.Blue then
					self.currentHolder = Teams.Blue
				end
				self.redHold = math.clamp(self.redHold, 0, 1)
				self.blueHold = math.clamp(self.blueHold, 0, 1)
			end
			for _k, _v in TermHolds do
				_arg0(_v, _k - 1, TermHolds)
			end
		end
	end
end
local DualCap
do
	local super = BaseSystem
	DualCap = setmetatable({}, {
		__tostring = function()
			return "DualCap"
		end,
		__index = super,
	})
	DualCap.__index = DualCap
	function DualCap.new(...)
		local self = setmetatable({}, DualCap)
		return self:constructor(...) or self
	end
	function DualCap:constructor(MaxPoints, MaxTime, CaptureSpeed, Overtime)
		if MaxPoints == nil then
			MaxPoints = 600
		end
		if MaxTime == nil then
			MaxTime = nil
		end
		if CaptureSpeed == nil then
			CaptureSpeed = .01
		end
		if Overtime == nil then
			Overtime = false
		end
		super.constructor(self, MaxTime, Overtime, CaptureSpeed)
		self.MaxPoints = MaxPoints
	end
	function DualCap:pointHandler()
		while self.Running == true do
			wait(1)
			self.timer += 1
			if self.currentHolder == Teams.Red then
				self.redPoints += 1
			elseif self.currentHolder == Teams.Blue then
				self.bluePoints += 1
			end
			if self.redPoints >= self.MaxPoints then
				if self.Overtime then
					if self.currentHolder == Teams.Red then
						self:deployWin(Teams.Red)
					end
				else
					self:deployWin(Teams.Red)
				end
			elseif self.bluePoints >= self.MaxPoints then
				if self.Overtime then
					if self.currentHolder == Teams.Blue then
						self:deployWin(Teams.Blue)
					end
				else
					self:deployWin(Teams.Blue)
				end
			end
			local _condition = self.MaxTime
			if _condition ~= 0 and (_condition == _condition and _condition) then
				_condition = self.timer >= self.MaxTime
			end
			if _condition ~= 0 and (_condition == _condition and _condition) then
				if not self.Overtime then
					self:deployWin(Teams.Blue)
				end
			end
		end
	end
	function DualCap:start()
		self.Running = true
		spawn(function()
			return self:pointHandler()
		end)
		spawn(function()
			return self:captureHandler()
		end)
	end
	function DualCap:stop()
		self.Running = false
	end
	function DualCap:resetValue(value)
		if value == "all" then
			self.bluePoints = 0
			self.redPoints = 0
			self.blueHold = 0
			self.redHold = 0
			self.timer = 0
			self.currentHolder = nil
		elseif value == "bluePoints" then
			self.bluePoints = 0
		elseif value == "redPoints" then
			self.redPoints = 0
		elseif value == "blueHold" then
			self.blueHold = 0
		elseif value == "redHold" then
			self.redHold = 0
		elseif value == "timer" then
			self.timer = 0
		elseif value == "currentHolder" then
			self.currentHolder = nil
		end
	end
	function DualCap:updateVales(values)
		for key, value in values do
			local _condition = key == "bluePoints"
			if _condition then
				local _value = value
				_condition = type(_value) == "number"
			end
			if _condition then
				self.bluePoints = value
			else
				local _condition_1 = key == "redPoints"
				if _condition_1 then
					local _value = value
					_condition_1 = type(_value) == "number"
				end
				if _condition_1 then
					self.redPoints = value
				else
					local _condition_2 = key == "blueHold"
					if _condition_2 then
						local _value = value
						_condition_2 = type(_value) == "number"
					end
					if _condition_2 then
						self.blueHold = value
					else
						local _condition_3 = key == "redHold"
						if _condition_3 then
							local _value = value
							_condition_3 = type(_value) == "number"
						end
						if _condition_3 then
							self.redHold = value
						else
							local _condition_4 = key == "timer"
							if _condition_4 then
								local _value = value
								_condition_4 = type(_value) == "number"
							end
							if _condition_4 then
								self.timer = value
							else
								local _condition_5 = key == "currentHolder"
								if _condition_5 then
									local _value = value
									local _condition_6 = typeof(_value) == "Instance"
									if _condition_6 then
										local _value_1 = value
										_condition_6 = _value_1.ClassName == "Team"
									end
									local _condition_7 = _condition_6
									if not _condition_7 then
										local _value_1 = value
										_condition_7 = type(_value_1) == "nil"
									end
									_condition_5 = _condition_7
								end
								if _condition_5 then
									self.currentHolder = value
								end
							end
						end
					end
				end
			end
		end
	end
	function DualCap:points()
		return {
			red = self.redPoints,
			blue = self.bluePoints,
		}
	end
end
local RaidService
do
	RaidService = setmetatable({}, {
		__tostring = function()
			return "RaidService"
		end,
	})
	RaidService.__index = RaidService
	function RaidService.new(...)
		local self = setmetatable({}, RaidService)
		return self:constructor(...) or self
	end
	function RaidService:constructor()
		self.startTick = 0
	end
	function RaidService:onStart()
		print("[" .. (script.Name .. ("] Server loaded (" .. (tostring(tick() - self.startTick) .. ")"))))
	end
	function RaidService:onInit()
		print("[" .. (script.Name .. "] Server recognized"))
		self.startTick = tick()
	end
end
--(Flamework) RaidService metadata
Reflect.defineMetadata(RaidService, "identifier", "ServerScriptService/services/RaidService@RaidService")
Reflect.defineMetadata(RaidService, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(RaidService, "$:flamework@Service", Service, {})
return {
	DualCap = DualCap,
	RaidService = RaidService,
}
