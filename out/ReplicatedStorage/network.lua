-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local createNetworkingEvent = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "networking", "out", "events", "createNetworkingEvent").createNetworkingEvent
local t = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local createNetworkingFunction = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "networking", "out", "functions", "createNetworkingFunction").createNetworkingFunction
local GlobalEvents = createNetworkingEvent("ReplicatedStorage/network@GlobalEvents", {}, {
	loadingScreenMessage = { { t.string }, nil },
	loadingDone = { { t.boolean }, nil },
}, nil, nil, nil)
local GlobalFunctions = createNetworkingFunction("ReplicatedStorage/network@GlobalFunctions", {}, {}, nil, nil, nil)
return {
	GlobalEvents = GlobalEvents,
	GlobalFunctions = GlobalFunctions,
}
