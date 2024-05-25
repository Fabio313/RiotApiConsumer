using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Server.IIS.Core;
using RiotApi.BFF.Model;
using System.Net;
using System.Net.Http.Headers;
using System.Text.Json;

namespace RiotApi.BFF.Controllers
{
    [ApiController]
    [Route("api/v1/lol")]
    public class RiotLeagueController : ControllerBase
    {
        private readonly ILogger<RiotLeagueController> _logger;

        public RiotLeagueController(ILogger<RiotLeagueController> logger)
        {
            _logger = logger;
        }

        [HttpGet("getInformations")]
        public async Task<ActionResult<LeagueUserInformations>> GetAsync([FromQuery] string gameName, [FromQuery] string gameTag)
        {
            var leagueInformation = new LeagueUserInformations();

            using (HttpClient client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                client.DefaultRequestHeaders.Add("X-Riot-Token", "RGAPI-d1c486f4-184f-4859-9715-60186e845b3c");

                var getAccountResponse = await client.GetAsync($"https://americas.api.riotgames.com/riot/account/v1/accounts/by-riot-id/{gameName}/{gameTag}");
                leagueInformation.Account = await ValidateResponseAsync<GetAccountResponse>(getAccountResponse);

                var getSummonerResponse = await client.GetAsync($"https://br1.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/{leagueInformation.Account.Puuid}");
                leagueInformation.Summoner = await ValidateResponseAsync<GetSummonerResponse>(getSummonerResponse);

                var getLeagueResponse = await client.GetAsync($"https://br1.api.riotgames.com/lol/league/v4/entries/by-summoner/{leagueInformation.Summoner.Id}");
                leagueInformation.Leagues = await ValidateResponseAsync<IEnumerable<GetLeagueResponse>>(getLeagueResponse);

                var getTopMaesteryResponse = await client.GetAsync($"https://br1.api.riotgames.com/lol/champion-mastery/v4/champion-masteries/by-puuid/{leagueInformation.Account.Puuid}/top?count=3");
                leagueInformation.TopMaesterys = await ValidateResponseAsync<IEnumerable<GetTopMaesteryResponse>>(getTopMaesteryResponse);

                var getAllChampions = await client.GetAsync($"https://ddragon.leagueoflegends.com/cdn/14.9.1/data/en_US/champion.json");
                JsonDocument.Parse(await getAllChampions.Content.ReadAsStringAsync()).RootElement.TryGetProperty("data", out var championsData);

                foreach (var sla in leagueInformation.TopMaesterys)
                {
                    var achei = false;
                    foreach (var champions in championsData.EnumerateObject())
                    {
                        if (achei)
                            break;
                        foreach (var championData in champions.Value.EnumerateObject())
                        {
                            if (championData.Name == "key" && long.Parse(championData.Value.ToString()) == sla.ChampionId)
                            {
                                sla.ChampionName = champions.Name;
                                achei = true;
                                break;
                            }
                        }
                    }
                }

            }

            return leagueInformation;
        }

        private async Task<T> ValidateResponseAsync<T>(HttpResponseMessage response)
        {
            if (response.IsSuccessStatusCode)
                return await response?.Content?.ReadFromJsonAsync<T>();
            else
                throw new Exception(response.StatusCode.ToString() + response.ToString());
        }
    }
}