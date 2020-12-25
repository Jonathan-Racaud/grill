using System;
using Grill.Models;

namespace Grill.Configuration
{
	public interface IConfiguration
	{
		String GlobalDir { get; }

		/// \Brief Loads the configuration
		Result<void> LoadConfiguration();
	}
}
