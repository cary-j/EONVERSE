-- Compiled with roblox-ts v2.2.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "Source", "components" })
Flamework._addPaths({ "StarterPlayer", "StarterPlayerScripts", "Source", "controllers" })
Flamework._addPaths({ "ReplicatedStorage", "Source", "components" })
Flamework.ignite()
