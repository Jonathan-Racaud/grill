using System;
using Grill.Models;

namespace Grill.Configuration
{
	public interface IConfiguration
	{
		Result<void> LoadConfiguration();
		Result<void> Configure(ConfigurationParameters parameters);
	}
}
