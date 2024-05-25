namespace RiotApi.BFF.Model
{
    public class GetSummonerResponse
    {
        public string Id { get; set; }
        public string AccountId { get; set; }
        public string PuuId { get; set; }
        public int ProfileIconId { get; set; }
        public long RevisionDate { get; set; }
        public long SummonerLevel { get; set; }
    }
}
