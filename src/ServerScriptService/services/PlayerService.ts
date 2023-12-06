import { Service, OnStart, OnInit } from "@flamework/core";
import { Players, Teams } from "@rbxts/services";
import { GenerateLeaderStats, DataService } from "./DataService";
import { HubService } from "./HubService";
//import { DualCap } from "./RaidService";

/*
const bb = new CrossMessage("ee");
bb.addSubscription((b: unknown, c: number) => {
    print(b, c)
})
bb.publish("a").catch(warn)

const aa = new DualCap()
aa.start();
aa.updateVales(new Map([["key", "value"]]))*/
const AllowedPlayers = ["minecraft2fun", -1, -2, "DevMinecraft2fun"]

@Service()
export class PlayerService implements OnStart, OnInit {
    private startTick = 0;
    constructor(private DataService: DataService, private HubService: HubService) { }
    onStart(): void | Promise<void> {
        print(`[${script.Name}] Server loaded (${tick() - this.startTick})`);
    }
    onInit(): void | Promise<void> {
        print(`[${script.Name}] Server recognized`);
        this.startTick = tick()
        Players.PlayerAdded.Connect((p) => this.playerAdded(p));
        Players.PlayerRemoving.Connect((p) => this.playerRemoving(p))
        Players.GetPlayers().forEach((p) => this.playerAdded(p))
    }
    playerAdded(player: Player) {
        let allowed = false;
        for (const value of AllowedPlayers) {
            if (typeIs(value, "string") && value === player.Name) {
                allowed = true;
                break;
            } else if (typeIs(value, "number") && value === player.UserId) {
                allowed = true;
                break;
            }
        }
        if (!allowed) {
            player.Kick("Game is currently in testing")
        }
        this.DataService.playerAdded(player)
        this.HubService.playerAdded(player)
        const leaderStats = new GenerateLeaderStats(player);
        player.Chatted.Connect((msg) => {
            if (msg === "red") {
                player.Team = Teams.Red
            } else if (msg === "blue") {
                player.Team = Teams.Blue
            }
        })
    }
    playerRemoving(player: Player) {
        this.DataService.playerRemoving(player)
    }
}