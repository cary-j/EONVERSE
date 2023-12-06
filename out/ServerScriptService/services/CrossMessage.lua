-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local MessagingService = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").MessagingService
local CrossMessage
do
	CrossMessage = setmetatable({}, {
		__tostring = function()
			return "CrossMessage"
		end,
	})
	CrossMessage.__index = CrossMessage
	function CrossMessage.new(...)
		local self = setmetatable({}, CrossMessage)
		return self:constructor(...) or self
	end
	function CrossMessage:constructor(ChannelName)
		self.ChannelName = ChannelName
		self.callbacks = {}
		if CrossMessage.ConnectionCount < CrossMessage.MaxConnections then
			local success, connection = pcall(function()
				MessagingService:SubscribeAsync(ChannelName, function(message)
					local _message = message
					if type(_message) == "string" then
						local SplitData = string.split(message, ":")
						local isReturn = false
						if SplitData[1] == game.JobId then
							return nil
						end
						if SplitData[2] == game.JobId then
							isReturn = true
						end
						local _callbacks = self.callbacks
						local _arg0 = function(value)
							pcall(function()
								value(SplitData, isReturn)
							end)
						end
						for _k, _v in _callbacks do
							_arg0(_v, _k - 1, _callbacks)
						end
					end
				end)
			end)
			if success then
				CrossMessage.ConnectionCount += 1
			else
				warn(connection)
			end
		end
	end
	function CrossMessage:addSubscription(callback, isReturn)
		if isReturn == nil then
			isReturn = true
		end
		local _callbacks = self.callbacks
		local _callback = callback
		table.insert(_callbacks, _callback)
	end
	function CrossMessage:getChannelName()
		return self.ChannelName
	end
	function CrossMessage:publish(message)
		return TS.Promise.new(function(resolve, reject)
			while CrossMessage.MessagesSent > CrossMessage.MaxSent do
				wait(1)
			end
			if CrossMessage.MessagesSent < CrossMessage.MaxSent then
				MessagingService:PublishAsync(self.ChannelName, game.JobId .. ":")
				CrossMessage.MessagesSent += 1
				resolve()
			else
				reject("Too many requests")
			end
		end)
	end
	function CrossMessage:disconnect()
		self.callbacks = {}
	end
	function CrossMessage:resetCount()
		self.MessagesSent = 0
	end
	CrossMessage.ConnectionCount = 0
	CrossMessage.MessagesSent = 0
	CrossMessage.MaxConnections = 5
	CrossMessage.MaxSent = 150
	CrossMessage.TimeKeeper = 0
end
spawn(function()
	while { wait(60) } do
		CrossMessage:resetCount()
	end
end)
return {
	CrossMessage = CrossMessage,
}
