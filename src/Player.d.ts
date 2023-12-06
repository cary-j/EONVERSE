interface Player extends Instance {
    leaderstats: Folder & {
        Kills: NumberValue,
        Deaths: NumberValue
    },
    PlayerGui: PlayerGui
}