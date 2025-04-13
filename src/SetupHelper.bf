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
		mixin RunCmd(StringView cmd)
		{
			var process = scope SpawnedProcess();
			var processInfo = scope ProcessStartInfo();
			processInfo.SetFileNameAndArguments(cmd);
			processInfo.CreateNoWindow = true;
			processInfo.UseShellExecute = true;
			processInfo.RedirectStandardOutput = true;

			process.Start(processInfo);

			FileStream stream = scope .();
			process.AttachStandardOutput(stream);
			StreamReader r = scope .(stream);
			Console.OnCancel.Add(new (cancelKind, terminate) => {
			    process.Kill();
			    terminate = true;
			});

			String output = scope .();
			while(true)
			{
			    if (r.ReadLine(output..Clear()) case .Err)
					break;
			    Console.WriteLine(output);
			}
		}

		RunCmd!(scope $"cmake.exe -S {txtPath} -B {buildPath}");
		RunCmd!(scope $"cmake.exe --build {buildPath} --config Debug");
		RunCmd!(scope $"cmake.exe --build {buildPath} --config Release");
	}
}