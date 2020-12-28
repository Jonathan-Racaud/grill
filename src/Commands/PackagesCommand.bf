using System;
using System.Collections;
using CowieCLI;
using DependencyInjector;
using Grill.Services;
using Grill.Models;
using System.IO;
using Grill.Configuration;

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
				.Option(new CommandOption("install", "Install a specific package from the registry")
							.Short("i")
							.List()
							.ConflictsWith("list", "find")
							.Optional())
				.Option(new CommandOption("global", "Tell to install packages globally")
							.Short("g")
							.Flag()
							.Optional())
			~ delete _;
		public override CommandInfo Info => _info;

		public bool List = false;
		public String Find ~ delete _;
		public List<String> Install = new .() ~ DeleteContainerAndItems!(_);
		public bool Global = false;

		private IRegistryService _registryService ~ delete _;
		private IRepositoryService _gitService ~ delete _;
		private IConfiguration _configuration;

		public this()
		{
			if (Injector.Get<IRegistryService>() case .Ok(let registry))
			{
				_registryService = registry;
			}

			if (Injector.Get<IRepositoryService>() case .Ok(let repository))
			{
				_gitService = repository;
			}

			if (Injector.Get<IConfiguration>() case .Ok(let configuration))
			{
				_configuration = configuration;
			}
		}

		public override int Execute()
		{
			if (List)
			{
				return ListPackages();
			}

			if (Find != null)
			{
				return FindPackage();
			}

			if (!Install.IsEmpty)
			{
				return InstallPackages();
			}

			return PackageResults.Ok.Underlying;
		}

		private int ListPackages()
		{
			List<Package> packages;
			_registryService.GetAllPackages(out packages);

			PrintAllPackages(packages);

			DeleteContainerAndItems!(packages);

			return PackageResults.Ok.Underlying;
		}

		private int FindPackage()
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

		private int InstallPackages()
		{
			List<Package> packages = scope List<Package>();
			let dest = scope String();

			RetrievePackages(packages);

			if (!Global)
			{
				MakeLocalLibDirectory(dest);
			}
			else
			{
				dest.Set(_configuration.GlobalDir);
			}

			DownloadPackagesFromRepository(packages, dest);

			ClearAndDeleteItems(packages);

			return PackageResults.Ok.Underlying;
		}

		private void RetrievePackages(List<Package> packages)
		{
			for (let item in Install)
			{
				Package package;

				if (_registryService.GetPackage(item, out package) case .Ok)
				{
					packages.Add(package);
				}
				else
				{
					Console.WriteLine("Could not install package {}: Not found", item);
				}
			}
		}

		private void MakeLocalLibDirectory(String directory)
		{
			var currentDirectory = scope String();
			Directory.GetCurrentDirectory(currentDirectory);

			Path.InternalCombine(directory, currentDirectory, "beef_libs");

			if (!Directory.Exists(directory))
			{
				Directory.CreateDirectory(directory);
			}
		}

		private void DownloadPackagesFromRepository(List<Package> packages, String destFolder)
		{
			for (let package in packages)
			{
				let packageFolder = scope String();

				Path.InternalCombine(packageFolder, destFolder, package.Name);
				if (_gitService.Download(package.Source, packageFolder) case .Err)
				{
					Console.Error.WriteLine("Error downloading package {} from source {}", package.Name, package.Source);
				}
				else
				{
					Console.WriteLine("Package {} successfully downloaded into {} folder", package.Name, Global ? "Global lib" : "Local lib");
				}
			}
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
