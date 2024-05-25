using static System.Net.Mime.MediaTypeNames;

namespace RiotApi.BFF.Model
{
    public class GetChampionDTO
    {
        public string version { get; set; }
        public string id { get; set; }
        public string key { get; set; }
        public string name { get; set; }
        public string title { get; set; }
        public string blurb { get; set; }
        public ImageDTO image { get; set; }
        public List<string> tags { get; set; }
        public string partype { get; set; }
    }

    public class ImageDTO
    {
        public string full { get; set; }
        public string sprite { get; set; }
        public string group { get; set; }
    }
}
