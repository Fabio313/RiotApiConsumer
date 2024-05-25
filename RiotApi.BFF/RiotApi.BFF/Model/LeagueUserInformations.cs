namespace RiotApi.BFF.Model
{
    public class LeagueUserInformations
    {
        public GetAccountResponse Account { get; set; }
        public GetSummonerResponse Summoner { get; set; }
        public IEnumerable<GetLeagueResponse> Leagues { get; set; }
        public IEnumerable<GetTopMaesteryResponse> TopMaesterys { get; set; }
    }
}
