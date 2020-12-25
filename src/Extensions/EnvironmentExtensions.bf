using System.Collections;

namespace System
{
	extension Environment
	{
		public static void GetEnvironmentVariable(String variable, String outValue)
		{
			outValue.Set(String.Empty);

			let dict = new Dictionary<String, String>();

			Environment.GetEnvironmentVariables(dict);

			if (dict.ContainsKey(variable))
				outValue.Set(dict[variable]);

			DeleteDictionaryAndKeysAndItems!(dict);
		}
	}
}
