namespace RiotApi.BFF.Model
{
    public class GetTopMaesteryResponse
    {
        public string Puuid { get; set; }
        public long ChampionId { get; set; }
        public int ChampionLevel { get; set; }
        public int ChampionPoints { get; set; }
        public long LastPlayTime { get; set; }
        public long ChampionPointsSinceLastLevel { get; set; }
        public long ChampionPointsUntilNextLevel { get; set; }
        public int MarkRequiredForNextLevel { get; set; }
        public bool ChestGranted { get; set; }
        public int TokensEarned { get; set; }
        public int ChampionSeasonMilestone { get; set; }
        public string ChampionName { get; set; }
    }
}
