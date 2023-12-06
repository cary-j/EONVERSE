import { Service, OnStart, OnInit } from "@flamework/core";
import { Document, createCollection, setConfig } from "@rbxts/lapis"
import { Players } from "@rbxts/services";
import { t } from "@rbxts/t";
import { Events } from "ServerScriptService/network";
import { HubService } from "./HubService";
import { PrivacyType } from "types";
setConfig({
    saveAttempts: 5,
    loadAttempts: 5,
    loadRetryDelay: 3,
    showRetryWarnings: true
})

interface PlayerCollection {
    totalDeaths: number,
    totalKills: number,
    ReserveCode: string,
    PrivateServers: string[]
}
const PlayerCollection = createCollection(
    "PlayerData",
    {
        defaultData: {
            totalDeaths: 0,
            totalKills: 0,
            ReserveCode: "",
            PrivateServers: []
        },
        validate: t.strictInterface({
            totalDeaths: t.number,
            totalKills: t.number,
            ReserveCode: t.string,
            PrivateServers: t.array(t.string)
        })
    }
)

type CommandLog = {
    SenderId: number,
    Command: string,
    Time: number
}
type RaidLog = {
    DefendingGroup: number,
    RaidingGroup: number,
    Overtime: boolean,
    GameLength: number,
    MaxTime: number,
    BluePoints: number,
    RedPoints: number,
    WinTime: number
}

interface ReserveServerData {
    ReserveCode: string,
    OwnerId: number,
    CommandLogs: CommandLog[],
    RaidLogs: RaidLog[],
    Admins: {
        Groups: Map<number, number[]>,
        Players: number[]
    },
    Privacy: {
        Type: PrivacyType,
        CodeEnabled: boolean,
        Code: string,
        FriendsCanJoin: boolean,
        GroupCanJoin: number[],
        LaunchJoinEnabled: boolean,
        LaunchJoinCode: string
    },
    TermType: string,
    TermSettings: {}
}

const ReserveServerCollection = createCollection(
    "ReserveServerData",
    {
        defaultData: {
            ReserveCode: "",
            OwnerId: 0,
            CommandLogs: [],
            RaidLogs: [],
            Admins: {
                Groups: new Map<number, number[]>(),
                Players: []
            },
            Privacy: {
                Type: "private",
                CodeEnabled: false,
                Code: "",
                FriendsCanJoin: false,
                GroupCanJoin: [],
                LaunchJoinEnabled: false,
                LaunchJoinCode: ""
            },
            TermType: "",
            TermSettings: {}
        },
        validate: t.strictInterface({
            ReserveCode: t.string,
            OwnerId: t.number,
            CommandLogs: t.array(t.interface({
                SenderId: t.number,
                Command: t.string,
                Time: t.number
            })),
            RaidLogs: t.array(t.interface({
                DefendingGroup: t.number,
                RaidingGroup: t.number,
                Overtime: t.boolean,
                GameLength: t.number,
                MaxTime: t.number,
                BluePoints: t.number,
                RedPoints: t.number,
                WinTime: t.number
            })),
            Admins: t.interface({
                Groups: t.map(t.number, t.array(t.number)),
                Players: t.array(t.number)
            }),
            Privacy: t.interface({
                Type: t.literal("public", "private"),
                CodeEnabled: t.boolean,
                Code: t.string,
                FriendsCanJoin: t.boolean,
                GroupCanJoin: t.array(t.number),
                LaunchJoinEnabled: t.boolean,
                LaunchJoinCode: t.string
            }),
            TermType: t.string,
            TermSettings: t.interface({})
        })
    }
)

interface PrivateServerData {
    ReserveCode: string,
    OwnerId: number
}
const PrivateServerCollection = createCollection(
    "PrivateServerData",
    {
        defaultData: {
            ReserveCode: "",
            OwnerId: 0,

        },
        validate: t.strictInterface({
            ReserveCode: t.string,
            OwnerId: t.number,
        })
    }
)

export class GenerateLeaderStats {
    private Kills: NumberValue;
    private Deaths: NumberValue;
    constructor(player: Player) {
        this.Kills = new Instance("NumberValue");
        this.Deaths = new Instance("NumberValue");
        let folder = new Instance("Folder");
        folder.Name = "leaderstats";
        this.Kills.Name = "Kills";
        this.Deaths.Name = "Deaths"
        this.Kills.Value = 0;
        this.Deaths.Value = 0;
        this.Kills.Parent = folder;
        this.Deaths.Parent = folder;
        folder.Parent = player
    }
    getKills() {
        return this.Kills.Value
    }
    getDeaths() {
        return this.Deaths.Value
    }
    resetAll() {
        this.Kills.Value = 0;
        this.Deaths.Value = 0;
    }
    reset(value: "kills" | "deaths") {
        if (value === "kills") {
            this.Kills.Value = 0;
        } else if (value === "deaths") {
            this.Deaths.Value = 0;
        }
    }
}
export class LeaderStats {
    static getPlayerStats(player: Player) {
        if (player.FindFirstChild("leaderstats")) {
            return player.leaderstats;
        }
    }
    static resetPlayerStats(player: Player) {
        if (player.FindFirstChild("leaderstats")) {
            player.leaderstats.GetChildren().forEach((value) => {
                if (classIs(value, "NumberValue")) {
                    value.Value = 0
                }
            })
        }
    }
}

@Service()
export class DataService implements OnStart, OnInit {
    private startTick: number = 0;
    private playerDocuments: { [userId: string]: Document<PlayerCollection> | undefined } = {};
    constructor(private HubService: HubService) { }
    playerAdded(player: Player) {
        Events.loadingScreenMessage(player, "Loading player data");
        PlayerCollection.load(tostring(player.UserId)).then((document) => {
            this.playerDocuments[tostring(player.UserId)] = document
            Events.loadingScreenMessage(player, "Data loaded");
        }).catch(warn)
    }
    playerRemoving(player: Player) {
        let doc = this.playerDocuments[tostring(player.UserId)]
        if (doc) {
            doc.close();
            doc = undefined;
        }
    }
    onStart(): void | Promise<void> {
        print(`[${script.Name}] Server loaded (${tick() - this.startTick})`);
    }
    onInit(): void | Promise<void> {
        print(`[${script.Name}] Server recognized`);
        this.startTick = tick();
    }
    getReserveServerDocument(id: string | undefined = undefined): Promise<Document<ReserveServerData>> {
        return new Promise(async (resolve) => {
            const document = await ReserveServerCollection.load(id || game.PrivateServerId);
            resolve(document)
        })
    }
    getPrivateServerDocument(id: string | undefined = undefined): Promise<Document<PrivateServerData>> {
        return new Promise(async (resolve) => {
            const document = await PrivateServerCollection.load(id || game.PrivateServerId);
            return resolve(document);
        })
    }
}