using System;
using System.Collections;
using System.Reflection;
using System.Net;
using System.IO;
using CowieCLI;
using Grill.Configuration.Impl;
using DependencyInjector;
using Grill.Configuration;
using Grill.Commands;

namespace Grill
{
	public enum GrillResults
	{
		Ok = 0,
		ErrorLoadingConfiguration
	}

	public static class Program
	{
		public const String Name = "Grill";
		public const String Description = "A Beeflang package manager.";
		public static readonly Version ProgramVersion = .(0, 1, 0, 0);

		static int Main(String[] args)
		{
			let cli = scope CowieCLI(Name, Description);

			SetupCommands(cli);
			SetupDependencyInjection();

			if (LoadConfiguration() case .Err)
			{
				return GrillResults.ErrorLoadingConfiguration.Underlying;
			}

			return cli.Run(args);
		}

		static void SetupCommands(CowieCLI cli)
		{
			//cli.RegisterCommand<InstallCommand>("install");
			//cli.RegisterCommand<AddCommand>("add");
			cli.RegisterCommand<ConfigurationCommand>("configuration");
		}

		static void SetupDependencyInjection()
		{
			Injector.RegisterSingleton<IConfiguration, Configuration>();
		}

		static Result<void> LoadConfiguration()
		{
			if (Injector.Get<IConfiguration>() case .Ok(let configuration))
			{
				return configuration.LoadConfiguration();
			}

			Console.Error.WriteLine("Error getting configuration");
			return .Err;
		}
	}
}
