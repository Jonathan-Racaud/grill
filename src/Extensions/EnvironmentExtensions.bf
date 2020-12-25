using System.Collections;

namespace System
{
	extension Environment
	{
		public static void GetEnvironmentVariable(String variable, String outValue)
		{
			outValue.Set(String.Empty);

			let dict = scope Dictionary<String, String>();

			Environment.GetEnvironmentVariables(dict);

			if (!dict.ContainsKey(variable))
				return;

			outValue.Set(dict[variable]);
		}
	}
}
