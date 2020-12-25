using System;
using CowieCLI;
using Grill.Configuration;
using DependencyInjector;

namespace Grill.Commands
{
	public enum ConfigurationResults
	{
		Ok = 0
	}

	public class ConfigurationCommand : ICommand
	{
		private CommandInfo _info =
			new CommandInfo("configuration")
				.About("Gets information about Grill's configuration.")
			~ delete _;

		public override CommandInfo Info => _info;

		private readonly IConfiguration _configuration;

		// Needed because CowieCLI does not know about the DependencyInjector mechanism
		public this()
		{
			if (Injector.Get<IConfiguration>() case .Ok(let configuration))
			{
				_configuration = configuration;
			}
		}

		public this(IConfiguration configuration)
		{
			_configuration = configuration;
		}

		public override int Execute()
		{
			Console.WriteLine("Global path: {}", _configuration.GlobalDir);
			return ConfigurationResults.Ok.Underlying;
		}
	}
}
