using System;
using Grill.Models;
using System.Collections;

namespace Grill.Configuration.Impl
{
	public class Configuration : IConfiguration
	{
		public const String GLOBAL_DIR_ENV_VAR = "GRILL_GLOBAL_DIR";

		private String _globalDir = new .() ~ delete _;
		public readonly String GlobalDir { get => _globalDir; };

		public Result<void> LoadConfiguration()
		{
			Environment.GetEnvironmentVariable(GLOBAL_DIR_ENV_VAR, _globalDir);

			if (_globalDir.IsEmpty)
			{
				Console.Error.WriteLine("Error loading configuration: env var GRILL_GLOBAL_DIR missing.");
				return .Err;
			}

			return .Ok;
		}
	}
}
