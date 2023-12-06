import { Service, OnStart, OnInit } from "@flamework/core";
import { HttpService, Players } from "@rbxts/services";
import { Events } from "../network";
import { DataService } from "./DataService";
import { TeleportationService } from "./TeleportationService";
import { CrossMessage } from "./CrossMessage";
import { PrivacyType } from "types";

//type AllowedServersByPlayer = (key: Number) => { ReserveCode: String, OwnerId: number, Privacy: PrivacyType, PrivacyReason?: string }
interface BaseServerData {
    ReserveCode: String,
    OwnerId: number,
    Privacy: PrivacyType,
}
interface AllowedServersByPlayer extends BaseServerData { PrivacyReason?: string }
@Service()
export class HubService implements OnStart, OnInit {
    private IsPrivateServer = false;
    private IsReserveServer = false;
    private startTick: number = 0;
    private Started = false;
    private ReserveServer: undefined | string = undefined;
    private AllowedServersByPlayer: { [key: number]: AllowedServersByPlayer | {} } = {};
    private FullServerList: BaseServerData[] = []
    private ServerAccessMessage = new CrossMessage("server:access")
    constructor(private DataService: DataService, private TeleportationService: TeleportationService) { }
    getPlayerAllowedServers(player: Player, cache = false) {
        if (cache && this.AllowedServersByPlayer[player.UserId]) {
            return this.AllowedServersByPlayer[player.UserId];
        }
        this.AllowedServersByPlayer[player.UserId] = {}
        Events.loadingScreenMessage(player, "Getting server list.")
        //   this.CrossMessage////ssssssssssssssssssssssssssssssssssss
    }
    onStart(): void | Promise<void> {
        print(`[${script.Name}] Server loaded (${tick() - this.startTick})`);
        if (game.PrivateServerId !== "") {
            if (game.PrivateServerOwnerId === 0) {
                //Is reserve
                this.IsReserveServer = true
                const ReserveServerData = this.DataService.getReserveServerDocument();
                print(ReserveServerData, HttpService.JSONEncode(ReserveServerData))
            } else {
                //Is private
                this.IsPrivateServer = true
                this.DataService.getPrivateServerDocument().then((doc) => {
                    const data = doc.read();
                    if (data.ReserveCode !== "") {
                        //tp players
                        this.ReserveServer = data.ReserveCode || "wrong if";
                    } else {
                        // create code to tp
                        const [ReserveCode, ReserveId] = this.TeleportationService.generateReserveCode();
                        this.ReserveServer = ReserveCode;
                        doc.write({ ReserveCode: ReserveCode, OwnerId: game.PrivateServerOwnerId })
                        this.DataService.getReserveServerDocument(ReserveId).then((reserveDoc) => {
                            //   reserveDoc.write({ ReserveCode: ReserveCode, OwnerId: game.PrivateServerOwnerId, CommandLogs: [], RaidLogs: [] });
                            reserveDoc.close();
                        })
                        doc.close();
                    }
                })
            }
        } else {
            //Pending hub
        }
        this.Started = true;
    }
    playerAdded(player: Player) {
        while (!this.Started) { wait() }
        print(this.IsPrivateServer, this.IsReserveServer, this.ReserveServer || "null")
        wait(5)
        if (this.IsPrivateServer) {
            Events.loadingScreenMessage(player, "Teleporting to server.")
            if (!this.ReserveServer) { return player.Kick("Server failed to start properly.") }
            this.TeleportationService.teleportPlayer([player], this.ReserveServer)
        } else {
            // Events.loadingScreenMessage(player, `Is a Hub Server: ${this.IsPrivateServer === false && this.IsReserveServer === false}\n Is Reserve Server: ${this.IsReserveServer}`)
        }
    }
    onInit(): void | Promise<void> {
        print(`[${script.Name}] Server recognized`);
        this.startTick = tick();

        this.ServerAccessMessage.addSubscription((data, isReturn) => {
            if (!isReturn) return;
            const ReturnFor = data[2];
            if (ReturnFor === "all") {
                const ServerData = data[3].split("&");
                let configuredData: { [Key: string]: string } = {}
                ServerData.forEach((value) => {
                    let data = value.split("=");
                    configuredData[data[0]] = data[1]
                })
            } else if (ReturnFor === "player") {
                const ServerData = data[4].split("&");
                const UserId = tonumber(data[3]);
                if (!typeIs(UserId, "number")) { return; }
                let configuredData: { [Key: string]: string } = {}
                ServerData.forEach((value) => {
                    let data = value.split("=");
                    configuredData[data[0]] = data[1];
                })
                this.AllowedServersByPlayer[UserId] = configuredData
            }
        })
    }
    isPrivateServer() {
        while (!this.Started) { wait() }
        return this.IsPrivateServer;
    }
    isReserveServer() {
        while (!this.Started) { wait() }
        return this.IsReserveServer;
    }
}