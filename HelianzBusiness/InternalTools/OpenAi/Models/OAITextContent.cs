using Newtonsoft.Json;
using System.Collections.Generic;

namespace HelianzBusiness.OpenAi {
	public class OAITextContent {
		[JsonProperty("value")]
		public string Value;
		[JsonProperty("annotations")]
		public List<object> Annotations=new List<object>();
	}
}
