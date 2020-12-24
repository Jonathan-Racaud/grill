using System;
using System.Collections;

namespace Grill.Models
{
	[Reflect]
	public class Package
	{
		public String Name = new .() ~ delete _;
		public String Description = new .() ~ delete _;
		public List<Package> Dependencies = new .() ~ DeleteContainerAndItems!(_);

		public PackageVersion Version = new .() ~ delete _;
		public Author Author = new .() ~ delete _;
		public ReleaseType ReleaseType;
	}
}
