using System;

namespace Grill
{
	public class PackageVersion
	{
		public int Major;
		public int Minor;
		public int Patch;

		public this(int major = 0, int minor = 0, int patch = 0)
		{
			Major = major;
			Minor = minor;
			Patch = patch;
		}

		public this(StringView version)
		{
			var numbers = version.Split('.');
			Major = int.Parse(numbers.GetNext());
			Minor = int.Parse(numbers.GetNext());
			Patch = int.Parse(numbers.GetNext());
		}

		public bool IsGreaterThan(PackageVersion other)
		{
			return (Major > other.Major || (Major == other.Major &&
					Minor > other.Minor || (Minor == other.Major &&
					Patch > other.Patch)));
		}

		public bool IsGreaterThanOrEqualTo(PackageVersion other)
		{
			if (Major == other.Major &&
				Minor == other.Minor &&
				Patch == other.Patch)
				return true;

			return IsGreaterThan(other);
		}

		public override void ToString(String strBuffer)
		{
			strBuffer.AppendF("{}.{}.{}", Major, Minor, Patch);
		}
	}
}
