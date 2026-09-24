workspace "HazelClone"
    architecture "x64"

    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "HazelClone/vendor/GLFW/include"

include "HazelClone/vendor/GLFW"

project "HazelClone"
    location "HazelClone"
    kind "SharedLib"
    language "C++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    pchheader "hzpch.h"
    pchsource "HazelClone/src/hzpch.cpp"

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "HazelClone/src",
        "HazelClone/vendor/spdlog/include",
        "%{IncludeDir.GLFW}"
    }
    links
    {
        "GLFW",
        "opengl32.lib",
        "dwmapi.lib"
    }

    filter "system:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"

        defines
        {
            "HZ_PLATFORM_WINDOWS",
            "HZ_BUILD_DLL"
        }

        postbuildcommands
        {
            ("{MKDIR} ../bin/" .. outputdir .. "/Sandbox"),
            ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox/")
        }

    filter "system:linux"
        cppdialect "C++17"

        defines
        {
            "HZ_PLATFORM_LINUX",
            "HZ_BUILD_DLL"
        }

        postbuildcommands
        {
            ("{MKDIR} ../bin/" .. outputdir .. "/Sandbox"),
            ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox/")
        }

    filter "configurations:Debug"
        defines { "HZ_DEBUG", "HZ_ENABLE_ASSERTS" }
        symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        optimize "On"

    filter "configurations:Dist"
        defines "HZ_DIST"
        symbols "On"

project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "HazelClone/src",
        "HazelClone/vendor/spdlog/include"
    }

    links
    {
        "HazelClone"
    }

    filter "system:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"

        defines
        {
            "HZ_PLATFORM_WINDOWS"
        }

    filter "system:linux"
        cppdialect "C++17"

        defines
        {
            "HZ_PLATFORM_LINUX"
        }

    filter "configurations:Debug"
        defines { "HZ_DEBUG", "HZ_ENABLE_ASSERTS" }
        symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        optimize "On"

    filter "configurations:Dist"
        defines "HZ_DIST"
        symbols "On"