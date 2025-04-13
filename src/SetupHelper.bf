using System;
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
		Runtime.Assert(false, "TODO");
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
}