using System;
using Grill.Models;
using System.Collections;

namespace Grill.Configuration.Impl
{
	public class Configuration : IConfiguration
	{
		public const String GLOBAL_DIR_ENV_VAR = "GRILL_GLOBAL_DIR";

		private static String _globalDir = new .() ~ delete _;
		public static readonly String GlobalDir => _globalDir;

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

		public Result<void> Configure(ConfigurationParameters parameters)
		{
			if (parameters.GlobalFolder.IsEmpty)
			{
				Console.Error.WriteLine("Error configuring Grill: GRILL_GLOBAL_DIR invalid.");
				return .Err;
			}

			var envVars = scope Dictionary<String, String>();
			_globalDir.Set(parameters.GlobalFolder);
			Environment.GetEnvironmentVariables(envVars);
			Environment.SetEnvironmentVariable(envVars, GLOBAL_DIR_ENV_VAR, _globalDir);
			return .Ok;
		}
	}
}
