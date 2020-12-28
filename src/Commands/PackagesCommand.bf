using System;
using System.Collections;
using CowieCLI;
using DependencyInjector;
using Grill.Services;
using Grill.Models;

namespace Grill.Commands
{
	public enum PackageResults
	{
		Ok = 0
	}

	public class PackagesCommand : ICommand
	{
		private CommandInfo _info =
			new CommandInfo("packages")
				.About("Manage one or several packages.")
				.Option(new CommandOption("list", "List all the available packages from the registry.")
							.Short("l")
							.Flag()
							.ConflictsWith("find")
							.Optional())
				.Option(new CommandOption("find", "Find a specific package from the registry.")
							.Short("f")
							.ConflictsWith("list")
							.Optional())
			~ delete _;
		public override CommandInfo Info => _info;

		public bool List = false;
		public String Find ~ delete _;

		private IRegistryService _registryService ~ delete _;

		public this()
		{
			if (Injector.Get<IRegistryService>() case .Ok(let registry))
			{
				_registryService = registry;
			}
		}

		public override int Execute()
		{
			if (List)
			{
				List<Package> packages;
				_registryService.GetAllPackages(out packages);

				PrintAllPackages(packages);

				DeleteContainerAndItems!(packages);

				return PackageResults.Ok.Underlying;
			}

			if (!Find.IsEmpty)
			{
				Package package;
				_registryService.GetPackage(Find, out package);

				if (package == default)
				{
					Console.WriteLine("Package {} not found", Find);
					return PackageResults.Ok.Underlying;
				}

				PrintPackage(package);

				delete package;

				return PackageResults.Ok.Underlying;
			}

			return PackageResults.Ok.Underlying;
		}

		private void PrintAllPackages(List<Package> packages, int level = 0)
		{
			for (let package in packages)
			{
				PrintPackage(package, level);
				Console.WriteLine(level == 0 ? "============" : "");
			}
		}

		private void PrintPackage(Package package, int level = 0)
		{
			let tabs = scope String();
			for (int i = 0; i < level; i++)
			{
				tabs.Append("  ");
			}

			Console.WriteLine("{}Package: {}", tabs, package.Name);
			Console.WriteLine("{}Description: {}", tabs, package.Description);

			Console.WriteLine("{}Author:", tabs);
			Console.WriteLine("{}  Name: {}", tabs, package.Author.Name);
			Console.WriteLine("{}  Email: {}", tabs, package.Author.Email);

			Console.WriteLine("{}Dependencies:", tabs);
			PrintAllPackages(package.Dependencies, level + 1);
		}
	}
}
