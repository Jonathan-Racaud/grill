using System;

namespace Grill.Services
{
	public interface IRepositoryService
	{
		/// \Brief Downloads a repository from the source into the dest folder
		Result<void> Download(String source, String dest);

		/// \Brief Removes the repository from the dest folder
		Result<void> Remove(String dest);
	}
}
