using System;
using System.IO;
using System.Collections;

namespace BeefLibSetupHelper;

public static class CMake
{
	private static Result<void> Exe(String buff)
	{
		Dictionary<String, String> vars = new .();
		defer { DeleteDictionaryAndKeysAndValues!(vars); }
		Environment.GetEnvironmentVariables(vars);

		if (vars.ContainsKey("CMAKE"))
		{
			let path = vars["CMAKE"];
			if (!File.Exists(path))
				return .Err;
			buff.Append(path);
			return .Ok;
		}
		buff.Append("cmake");
		return .Ok;
	}

	private static void GetGenerator(String buff)
	{
#if BF_PLATFORM_WINDOWS
		buff.Append("Visual Studio 17 2022");
#elif BF_PLATFORM_LINUX
		buff.Append("Ninje Multi-Config");
#endif
	}

	public static Result<void> CheckDeps()
	{
		let cmd = Exe(.. scope String());
		Try!(SetupHelper.ExecuteCmd(cmd, "--version"));
		return .Ok;
	}

	public static mixin CheckDeps()
	{
		let cmd = Exe(.. scope String());
		if (SetupHelper.ExecuteCmd(cmd, "--version") case .Err)
		{
			Console.Error.WriteLine("CMake executable is not available in PATH, consider installing it or set the CMAKE variable to point to valid cmake executable.");
			Environment.Exit(1);
		}
	}

	public static Result<void> ConfigureAndBuild(StringView txtPath, StringView buildPath = "cmake-build")
	{
		let cmd = Exe(.. scope String());
		Try!(SetupHelper.ExecuteCmd(cmd, scope $"-S {txtPath} -B {buildPath} -G\"{GetGenerator(.. scope String())}\""));
		Try!(SetupHelper.ExecuteCmd(cmd, scope $"--build {buildPath} --config Debug"));
		Try!(SetupHelper.ExecuteCmd(cmd, scope $"--build {buildPath} --config Release"));
		return .Ok;
	}
}