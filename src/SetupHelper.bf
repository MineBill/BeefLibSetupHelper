using System;
using System.Diagnostics;
using System.IO;

namespace BeefLibSetupHelper;

public static class SetupHelper
{
#if false
	public enum Error
	{
		case GitMissing;
		case CMakeMissing;

		public void ToString(String buffer)
		{
			switch (this)
			{
			case GitMissing:
				buffer.Append("Git executable is missing");
			case CMakeMissing:
				buffer.Append("CMake executable is missing");
			}
		}
	}

	public static Result<void, Error> CheckDeps()
	{
		return .Ok;
	}

	public static mixin CheckDeps()
	{
		if (CheckDeps() case .Err(let err))
		{
			Runtime.Assert(false, scope $"CheckDeps! failed because: {err}");
		}
	}

	public struct CloneOptions
	{
		public StringView Url;
		public StringView CommitOrTag;
	}

	/// @param url A URL (can also be a file path) to the repo in question.
	/// @param clonePath The path to the repo to.
	public static void CloneRepo(CloneOptions opts, StringView clonePath)
	{
		Runtime.Assert(false, "TODO");
	}
#endif

	public static Result<void, int> ExecuteCmd(StringView cmd, StringView args, String stdOut = null, String stdErr = null)
	{
		var info = scope ProcessStartInfo()
			{
#if BF_PLATFORM_WINDOWS
				UseShellExecute = false,
#else
				UseShellExecute = true,
#endif
				RedirectStandardOutput = stdOut != null,
				RedirectStandardError = stdErr != null
			};

		info.SetFileName(cmd);
		info.SetArguments(args);
		SpawnedProcess process = scope .();

		if (process.Start(info) case .Err)
		{
			return .Err(-1);
		}

		FileStream outputStream = scope .();
		FileStream errStream = scope .();
		if (stdOut != null)
			process.AttachStandardOutput(outputStream);

		if (stdErr != null)
			process.AttachStandardOutput(errStream);

		if (stdOut != null)
		{
			StreamReader reader = scope .(outputStream);

			if (reader.ReadToEnd(stdOut) case .Err)
				Console.WriteLine("Failed to read process output");
		}

		if (stdErr != null)
		{
			StreamReader reader = scope .(errStream);

			if (reader.ReadToEnd(stdOut) case .Err)
				Console.WriteLine("Failed to read process output");
		}

		process.WaitFor();
		if (process.ExitCode == 0)
			return .Ok;
		return .Err(process.ExitCode);
	}
}