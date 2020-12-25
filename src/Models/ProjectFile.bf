using System;
using System.Collections;

namespace Grill
{
	[Reflect]
	public class ProjectFile
	{
		public int FileVersion;

		public Project Project ~ delete _;
		public Dictionary<String, Object> Dependencies ~ DeleteDictionaryAndKeysAndItems!(_);
	}
}
