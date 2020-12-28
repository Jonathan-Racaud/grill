using System;
using System.IO;
using System.Diagnostics;
using Grill.Services;

namespace Grill.Services.Impl
{
	public class GitService : IRepositoryService
	{
		/*public static String GitPath = new String();
		public static String ExePath = new String();

		public static void Init()
		{
			Path.InternalCombine(GitPath, GrillPath.SourceDirectory, "Git");
			Path.InternalCombine(ExePath, GitPath, "bin/git.exe");

			if (!File.Exists(ExePath))
				CowieCLI.Error("Git executable not found");
		}

		public static bool Clone(String url, String to)
		{
			return Execute("-c", "http.sslVerify=false", "clone", url, to);
		}

		private static bool Execute(params StringView[] args)
		{
			if (!File.Exists(ExePath))
				return false;

			var command = scope String()..AppendF("\"\"{}\" ", ExePath);

			for (var arg in args)
			{
				if ((arg.Length >= 2 && arg[0].IsLetter && arg[1] == ':' && (arg[2] == '/' || arg[2] == '\\')) ||
					arg.StartsWith('/') ||
					arg.StartsWith('\\') ||
					arg.StartsWith('.')) 
					command.AppendF("\"{}\" ", arg);
				else
					command.AppendF("{} ", arg);
			}

			if (CowieCLI.CurrentVerbosity != .Debug)
				command.Append("> /dev/null 2>&1");

			command.Append('"');

			return Cpp.system(command) == 0;
		}

		public static ~this()
		{
			delete GitPath;
			delete ExePath;
		}*/

		private readonly String GitExePath ~ delete _;

		public this()
		{
			String currentDir = scope String();
			String grillExePath = scope String();
			Environment.GetExecutableFilePath(grillExePath);
			Path.GetDirectoryPath(grillExePath, currentDir);

			GitExePath = new String();
			Path.InternalCombine(GitExePath, currentDir, "bin", "Git", "bin", "git.exe");
		}

		public Result<void> Download(String source, String dest)
		{
			if (!File.Exists(GitExePath))
				return .Err;

			var gitArgs = scope String();
			gitArgs.AppendF("-c http.sslVerify=false clone {} {}", source, dest);

			var gitProcessInfo = scope ProcessStartInfo();
			gitProcessInfo.SetFileName(GitExePath);
			gitProcessInfo.SetArguments(gitArgs);

			var gitProcess = scope SpawnedProcess();

			if (gitProcess.Start(gitProcessInfo) case .Err)
				return .Err;

			while (gitProcess.WaitFor() == false)
				continue;

			if (gitProcess.ExitCode != 0)
				return .Err;

			return .Ok;
		}

		public Result<void> Remove(String dest)
		{
			return .Err;
		}
	}
}
