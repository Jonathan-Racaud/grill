using System;
using Grill.Models;

namespace Grill.Services
{
	public interface IPackageService
	{
		/// \Brief Install the specified package.
		Result<void> Install(Package package, bool global);

		/// \Brief Removes the specified package.
		Result<void> Remove(Package package, bool global);
	}
}
