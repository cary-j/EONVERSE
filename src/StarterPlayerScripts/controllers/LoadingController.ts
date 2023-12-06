import { Controller, OnStart, OnInit } from "@flamework/core";
import { Events } from "../network";
import { InterfaceController } from "./InterfaceController";
import { ContentProvider, ReplicatedFirst, ReplicatedStorage, TweenService } from "@rbxts/services";

@Controller()
export class RunController implements OnInit, OnStart {
    private PlayerGui: PlayerGui
    private LoadingUi: LoadingUi;
    private InLoading = true;
    private CurrentLoadingMessage = "Loading Client";
    constructor(private InterfaceController: InterfaceController) {
        this.PlayerGui = InterfaceController.getPlayerGui();
        this.LoadingUi = this.PlayerGui.Loading
    }
    StartAnimations() {
        const primaryUi = this.LoadingUi.Primary
        task.spawn(() => {
            while (this.InLoading) {
                let transparency = 0;
                if (primaryUi.Bottom.CurrentLoading.TextTransparency >= .85) {
                    transparency = 0
                } else {
                    if (primaryUi.Bottom.CurrentLoading.Text === this.CurrentLoadingMessage) {
                        transparency = .85;
                    } else {
                        transparency = 1;
                    }
                }
                const anim = TweenService.Create(primaryUi.Bottom.CurrentLoading, new TweenInfo(1.5, Enum.EasingStyle.Linear), { TextTransparency: transparency });
                anim.Play();
                task.wait(1.5)
                if (primaryUi.Bottom.CurrentLoading.TextTransparency === 1) {
                    task.wait(.1)
                    primaryUi.Bottom.CurrentLoading.Text = this.CurrentLoadingMessage;
                    task.wait(.1)
                }
            }
        })
        primaryUi.Top.GetChildren().forEach((v) => {
            if (classIs(v, "Frame")) {
                task.spawn(() => {
                    while (this.InLoading) {
                        let x = (math.random() + v.Position.X.Scale - .1) * v.Position.X.Scale + .1;
                        let y = (math.random() + v.Position.Y.Scale - .1) * v.Position.Y.Scale + .1;
                        x = math.clamp(x, .2, .5);
                        y = math.clamp(y, .3, .4);
                        const anim = TweenService.Create(v, new TweenInfo(1, Enum.EasingStyle.Linear), { Position: UDim2.fromScale(x, y) });
                        anim.Play();
                        task.wait(.7)
                    }
                })
            }
        })
    }
    onStart(): void {
        Events.loadingScreenMessage.connect((text) => {
            this.CurrentLoadingMessage = text;
        })
        Events.loadingDone.connect((done) => {
            if (done) {
                this.InLoading = false;
            }
        })
    }
    onInit(): void | Promise<void> {
        ReplicatedFirst.RemoveDefaultLoadingScreen()
        this.StartAnimations()
        ContentProvider.PreloadAsync(game.Workspace.GetDescendants())
    }
}