using Newtonsoft.Json;

namespace HelianzBusiness.OpenAi {
	public class OAIContent {
		[JsonProperty("type")]
		public string Type;
		[JsonProperty("text")]
		public OAITextContent Text;
	}
}
