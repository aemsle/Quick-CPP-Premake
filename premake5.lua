-- premake5.lua

-- Clean Function --
newaction {
    trigger     = "clean",
    description = "clean project directories",
    execute     = function ()
        print("cleaning project directory...")
        os.rmdir("./bin")
        os.rmdir("./bin-int")
        local ok, err = os.remove{"**.sln", "**.vcxproj"}
        if not ok then
            error(err)
        end
        print("done.")
    end
}

-- Clean Function --
newaction {
    trigger     = "generate",
    description = "generate project directories",
    execute     = function ()
       print("setting up project directories...")
       os.mkdir("./bin")
       os.mkdir("./bin-int")
       os.execute("premake5 vs2022")
       print("done.")
    end
}


-- Define the project
workspace "Project"
    configurations { "debug", "profile", "release", "release_final" }
    platforms { "Win64" }
    cppdialect "C++20"

    filter { "platforms:Win64" }
        system "Windows"
        architecture "x86_64"

    filter{}

-- Configuration-specific settings
filter "configurations:debug"
    defines { "_DEBUG" }
    symbols "On"

filter "configurations:profile"
    defines { "_PROFILE" }
    optimize "On"
    symbols "On"

filter "configurations:release"
    defines { "_RELEASE" }
    optimize "On"
    symbols "Off"

filter "configurations:release_final"
    defines { "_FINAL" }
    optimize "Full"
    symbols "Off"

filter{}

project "Runtime"
    kind "ConsoleApp"
    language "C++"
    targetdir "bin/%{cfg.buildcfg}"
    objdir "bin-int/%{cfg.buildcfg}"

    files
    {
        "src/**.cpp",
        "src/**.c",  -- Add C source files
        "inc/**.h",
    }

    includedirs
    {
        "inc"
    }

    prebuildcommands { "{COPYDIR} \"%{wks.location}res\" \"%{cfg.buildtarget.directory}res\"" }