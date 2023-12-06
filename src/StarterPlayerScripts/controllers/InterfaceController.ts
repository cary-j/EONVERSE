import { Controller, OnStart, OnInit } from "@flamework/core";
import { Players } from "@rbxts/services";
const LocalPlayer = Players.LocalPlayer;

@Controller()
export class InterfaceController implements OnInit, OnStart {
    onStart(): void {

    }
    onInit(): void | Promise<void> {

    }
    getPlayerGui() {
        while (!LocalPlayer.PlayerGui.FindFirstChild("Loading") || !LocalPlayer.PlayerGui.FindFirstChild("MainServer")) {
            wait()
        }
        const pg: PlayerGui = LocalPlayer.PlayerGui
        return pg
    }
}