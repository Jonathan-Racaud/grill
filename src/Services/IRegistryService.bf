using System;
using System.Collections;
using Grill.Models;

namespace Grill.Services
{
	public interface IRegistryService
	{
		Result<void> GetAllPackages(out List<Package> packages);
		Result<void> GetPackage(String name, out Package package);
		Result<bool> HasPackage(String name);
	}
}
