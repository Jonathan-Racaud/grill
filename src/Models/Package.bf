using System;
using System.Collections;

namespace Grill.Models
{
	[Reflect]
	public class Package
	{
		private String _name = new .() ~ delete _;
		private String _description = new .() ~ delete _;
		private String _source = new .() ~ delete _;
		private List<Package> _dependencies = new .() ~ DeleteContainerAndItems!(_);

		public String Name { get => _name; set => _name.Set(value); };
		public String Description { get => _description; set => _description.Set(value); };
		public String Source { get => _source; set => _source.Set(value); }
		public List<Package> Dependencies
		{
			get => _dependencies;
			set
			{
				DeleteContainerAndItems!(_dependencies);
				_dependencies = new List<Package>(value.GetEnumerator());
			}
		}

		public PackageVersion Version = new .() ~ delete _;
		public Author Author = new .() ~ delete _;
		public ReleaseType ReleaseType;
	}
}
