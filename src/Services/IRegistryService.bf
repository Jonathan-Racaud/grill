using System;
using System.Collections;
using Grill.Models;

namespace Grill.Services
{
	public interface IRegistryService
	{
		/// \Brief Get all the packages from the registry.
		Result<void> GetAllPackages(out List<Package> packages);

		/// \Brief Get the package with the specified name.
		Result<void> GetPackage(String name, out Package package);

		/// \Brief Check if the registry has a package matching the specified name
		/// \returns true if the package exists, false otherwise
		Result<bool> HasPackage(String name);
	}
}
