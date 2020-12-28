using System;
using System.Collections;
using Grill.Models;

namespace Grill.Services.Impl
{
	public class DummyRegistryService : IRegistryService
	{
		public Result<void> GetAllPackages(out List<Package> packages)
		{
			packages = new List<Package>()
			{
				new Package() { Name = "Package 1" },
				new Package() { Name = "Package 2" },
				new Package()
				{
					Name = "Package 3",
					Dependencies = scope List<Package>() { new Package() { Name = "Dependency 1" } }
				}
			};

			return .Ok;
		}

		public Result<void> GetPackage(String name, out Package package)
		{
			package = new Package() { Name = "JSON_Beef", Source = "https://github.com/Jonathan-Racaud/JSON_Beef.git" };

			return .Ok;
		}

		public Result<bool> HasPackage(String name)
		{
			return true;
		}
	}
}
