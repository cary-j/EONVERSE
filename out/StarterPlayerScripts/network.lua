-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _network = TS.import(script, game:GetService("ReplicatedStorage"), "Source", "network")
local GlobalEvents = _network.GlobalEvents
local GlobalFunctions = _network.GlobalFunctions
local Events = GlobalEvents.client
local Functions = GlobalFunctions.client
return {
	Events = Events,
	Functions = Functions,
}
