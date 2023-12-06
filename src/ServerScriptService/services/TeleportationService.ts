import { OnInit, OnStart, Service } from "@flamework/core";
import { TeleportService } from "@rbxts/services";

@Service()
export class TeleportationService implements OnStart, OnInit {
    private startTick: number = 0;
    onStart(): void {
        print(`[${script.Name}] Server loaded (${tick() - this.startTick})`);
    }
    onInit(): void | Promise<void> {
        print(`[${script.Name}] Server recognized`);
        this.startTick = tick();
    }
    teleportPlayer(player: Player[], ServerCode: string) {
        TeleportService.TeleportToPrivateServer(game.PlaceId, ServerCode, player, undefined, undefined/*, teleport data*/)
    }
    generateReserveCode() {
        return TeleportService.ReserveServer(game.PlaceId);
    }
}
