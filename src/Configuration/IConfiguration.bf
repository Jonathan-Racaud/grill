using System;
using Grill.Models;

namespace Grill.Configuration
{
	public interface IConfiguration
	{
		/// \Brief Loads the configuration
		Result<void> LoadConfiguration();

		/// \Brief Configure Grill according to the parameters
		Result<void> Configure(ConfigurationParameters parameters);
	}
}
