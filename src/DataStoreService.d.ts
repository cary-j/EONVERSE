interface DataStoreService extends Instance{
    player:DataStore&{
        allTimeKills:number,
        allTimeDeaths:number
    }
}