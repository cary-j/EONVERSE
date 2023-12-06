import { OnInit, OnStart } from "@flamework/core";
import { MessagingService } from "@rbxts/services";

export type PrivacyType = "public" | "private";
type MessageReturn = (data: string[], isReturn: boolean) => void;

export class CrossMessage {
    private callbacks: MessageReturn[] = []
    static ConnectionCount = 0;
    static MessagesSent = 0;
    static readonly MaxConnections = 5;
    static readonly MaxSent = 150;
    static TimeKeeper = 0;
    constructor(private ChannelName: string) {
        if (CrossMessage.ConnectionCount < CrossMessage.MaxConnections) {
            const [success, connection] = pcall(() => {
                MessagingService.SubscribeAsync(ChannelName, (message) => {
                    if (typeIs(message, "string")) {
                        const SplitData = message.split(":");
                        let isReturn = false
                        if (SplitData[0] === game.JobId) { return }
                        if (SplitData[1] === game.JobId) { isReturn = true }
                        this.callbacks.forEach((value) => {
                            pcall(() => {
                                value(SplitData, isReturn)
                            })
                        })
                    }
                })
            })
            if (success) {
                CrossMessage.ConnectionCount++;
            } else {
                warn(connection)
            }
        }
    }
    public addSubscription(callback: (data: string[], isReturn: boolean) => void, isReturn = true) {
        this.callbacks.push(callback)
    }
    public getChannelName() {
        return this.ChannelName
    }
    public publish(message: string): Promise<void> {
        return new Promise((resolve, reject) => {
            while (CrossMessage.MessagesSent > CrossMessage.MaxSent) {
                wait(1)
            }
            if (CrossMessage.MessagesSent < CrossMessage.MaxSent) {
                MessagingService.PublishAsync(this.ChannelName, `${game.JobId}:`)
                CrossMessage.MessagesSent++;
                resolve()
            } else { reject("Too many requests") }
        })
    }
    public disconnect() {
        this.callbacks = []
    }
    static resetCount() {
        this.MessagesSent = 0;
    }
}
spawn(() => {
    while (wait(60)) {
        CrossMessage.resetCount();
    }
})