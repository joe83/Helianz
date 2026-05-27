using Newtonsoft.Json;

namespace HelianzBusiness.OpenAi {
	public class OAIAssistantsListResponse<T> {
		[JsonProperty("object")]
		public string Object;
		public T[] Data;
		public string FirstId;
		public string LastId;
		public bool HasMore;
	}
}
