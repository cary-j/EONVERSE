import { Service, OnStart, OnInit } from "@flamework/core"
import { Players, Teams, Workspace } from "@rbxts/services";

class Terminal {
    static GetTermHolds(): Instance[] {
        return Workspace.GetPartBoundsInBox(Workspace.Term.CFrame, new Vector3(Workspace.Term.Size.X, 30, Workspace.Term.Size.Z))
    }
    static GetTermPlayers(): Player[] {
        const TermHolds = this.GetTermHolds();
        let players: Player[] = []
        TermHolds.forEach((part: Instance) => {
            if (part.Name === "HumanoidRootPart" && part.Parent?.FindFirstChild("Humanoid")) {
                const player = Players.GetPlayerFromCharacter(part.Parent);
                const humanoid = part.Parent?.FindFirstChild("Humanoid");
                if (humanoid && player && humanoid.IsA("Humanoid") && humanoid.Health > 0) {
                    players.push(player);
                }
            }
        })
        return players
    }
}

class BaseSystem {
    public timer = 0;
    public Running = false;
    public blueHold = 0;
    public redHold = 0;
    public bluePoints = 0;
    public redPoints = 0;
    public currentHolder: Team | undefined = undefined
    constructor(public MaxTime: number | undefined, public Overtime: boolean, public CaptureSpeed: number) { }
    public deployWin(winTeam: Team) {
        this.Running = false;
        print(`${winTeam.Name} has won the round!`)
    }
    public captureHandler() {
        while (this.Running === true) {
            wait()
            const TermHolds = Terminal.GetTermPlayers();
            TermHolds.forEach((player: Player) => {
                const playerTeam: Team | undefined = player.Team;
                if (playerTeam === Teams.Red) {
                    this.redHold += this.CaptureSpeed
                    this.blueHold -= this.CaptureSpeed
                } else if (playerTeam === Teams.Blue) {
                    this.redHold -= this.CaptureSpeed
                    this.blueHold += this.CaptureSpeed
                }
                if (this.redHold >= 1 && this.currentHolder !== Teams.Red) {
                    this.currentHolder = Teams.Red
                } else if (this.blueHold >= 1 && this.currentHolder !== Teams.Blue) {
                    this.currentHolder = Teams.Blue
                }
                this.redHold = math.clamp(this.redHold, 0, 1)
                this.blueHold = math.clamp(this.blueHold, 0, 1)
            })
        }
    }
}

export class DualCap extends BaseSystem {
    constructor(private MaxPoints = 600, MaxTime: number | undefined = undefined, CaptureSpeed = .01, Overtime = false) {
        super(MaxTime, Overtime, CaptureSpeed)
    }
    private pointHandler() {
        while (this.Running === true) {
            wait(1)
            this.timer += 1
            if (this.currentHolder === Teams.Red) {
                this.redPoints += 1
            } else if (this.currentHolder === Teams.Blue) {
                this.bluePoints += 1
            }
            if (this.redPoints >= this.MaxPoints) {
                if (this.Overtime) {
                    if (this.currentHolder === Teams.Red) {
                        this.deployWin(Teams.Red);
                    }
                } else {
                    this.deployWin(Teams.Red);
                }
            } else if (this.bluePoints >= this.MaxPoints) {
                if (this.Overtime) {
                    if (this.currentHolder === Teams.Blue) {
                        this.deployWin(Teams.Blue);
                    }
                } else {
                    this.deployWin(Teams.Blue);
                }
            }
            if (this.MaxTime && this.timer >= this.MaxTime) {
                if (!this.Overtime) {
                    this.deployWin(Teams.Blue);
                }
            }
        }
    }
    start() {
        this.Running = true;
        spawn(() => this.pointHandler())
        spawn(() => this.captureHandler())
    }
    stop() {
        this.Running = false;
    }
    resetValue(value: string) {
        if (value === "all") {
            this.bluePoints = 0;
            this.redPoints = 0;
            this.blueHold = 0;
            this.redHold = 0;
            this.timer = 0;
            this.currentHolder = undefined
        } else if (value === "bluePoints") { this.bluePoints = 0 }
        else if (value === "redPoints") { this.redPoints = 0 }
        else if (value === "blueHold") { this.blueHold = 0 }
        else if (value === "redHold") { this.redHold = 0 }
        else if (value === "timer") { this.timer = 0 }
        else if (value === "currentHolder") { this.currentHolder = undefined }
    }
    updateVales(values: Map<String, String | Number | Team>) {
        for (let [key, value] of values) {
            if (key === "bluePoints" && typeIs(value, "number")) { this.bluePoints = value }
            else if (key === "redPoints" && typeIs(value, "number")) { this.redPoints = value }
            else if (key === "blueHold" && typeIs(value, "number")) { this.blueHold = value }
            else if (key === "redHold" && typeIs(value, "number")) { this.redHold = value }
            else if (key === "timer" && typeIs(value, "number")) { this.timer = value }
            else if (key === "currentHolder" && ((typeIs(value, "Instance") && classIs(value, "Team")) || typeIs(value, "nil"))) { this.currentHolder = value }
        }
    }
    points() {
        return { red: this.redPoints, blue: this.bluePoints }
    }

}

@Service()
export class RaidService implements OnStart, OnInit {
    private startTick: number = 0;
    onStart(): void | Promise<void> {
        print(`[${script.Name}] Server loaded (${tick() - this.startTick})`);
    }
    onInit(): void | Promise<void> {
        print(`[${script.Name}] Server recognized`);
        this.startTick = tick()
    }

}