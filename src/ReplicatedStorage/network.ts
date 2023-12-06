import { Networking } from "@flamework/networking";

interface ClientToServerEvents { }

interface ServerToClientEvents {
    loadingScreenMessage(message: string): void
    loadingDone(done: boolean): void
}

interface ClientToServerFunctions { }

interface ServerToClientFunctions { }

export const GlobalEvents = Networking.createEvent<ClientToServerEvents, ServerToClientEvents>();
export const GlobalFunctions = Networking.createFunction<ClientToServerFunctions, ServerToClientFunctions>();
