using System;
using System.Diagnostics;
using System.IO;

namespace BeefLibSetupHelper;

public static class SetupHelper
{
	private static String s_What;

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
		//Runtime.Assert(false, "TODO");
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

	public static void ConfigureAndBuild(StringView txtPath, StringView buildPath = "cmake-build")
	{
		ExecuteCmd("cmake.exe", scope $"-S {txtPath} -B {buildPath}");
		ExecuteCmd("cmake.exe", scope $"--build {buildPath} --config Debug");
		ExecuteCmd("cmake.exe", scope $"--build {buildPath} --config Release");
	}

	public static void ExecuteCmd(StringView cmd, StringView args, String stdOut = null, String stdErr = null)
	{
		var info = scope ProcessStartInfo()
			{
				UseShellExecute = false,
				RedirectStandardOutput = stdOut != null,
				RedirectStandardError = stdErr != null
			};

		info.SetFileName(cmd);
		info.SetArguments(args);
		SpawnedProcess process = scope .();

		if (process.Start(info) case .Err)
		{
			Console.WriteLine(scope $"Failed to execute: {cmd}");
			return;
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
	}
}