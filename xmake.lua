-- MTASA xmake build script

set_project("MTASA")
set_version("1.6.0")

-- Add custom modes matching premake
set_allowedmodes("debug", "release", "nightly")

-- Global settings (matching premake C++23)
set_languages("cxx23")
add_rules("mode.debug", "mode.release")
set_symbols("on")

-- Global include directories
if is_plat("windows") then
    -- On Windows, Windows-specific config must come first to override the main config
    add_includedirs("vendor", "vendor/sparsehash/src/windows", "vendor/sparsehash/src", {public = true})
else
    add_includedirs("vendor", "vendor/sparsehash/src", {public = true})
end

-- Global defines
add_defines(
    "_CRT_SECURE_NO_WARNINGS",
    "_SCL_SECURE_NO_WARNINGS",
    "_CRT_NONSTDC_NO_DEPRECATE",
    "NOMINMAX",
    "_TIMESPEC_DEFINED"
)

-- Platform-specific settings
if is_plat("windows") then
    add_defines("WIN32", "_WIN32", "_WIN32_WINNT=0x601")
    add_cxflags("/Zc:__cplusplus", "/permissive-")
    set_runtimes("MT")
    -- Enable multiprocessor compilation (matching premake MultiProcessorCompile)
    add_cxflags("/MP")
    -- Character set MBCS (matching premake)
    add_cxflags("/D_MBCS")

    -- DirectX SDK support
    local dxdir = os.getenv("DXSDK_DIR") or "C:\\Program Files (x86)\\Microsoft DirectX SDK (June 2010)"
    if os.isdir(dxdir) then
        add_includedirs(path.join(dxdir, "Include"), {public = true})
        add_linkdirs(path.join(dxdir, "Lib/x86"), {public = true})
        print("Using DirectX SDK at: " .. dxdir)
    else
        print("Warning: DirectX SDK not found at " .. dxdir)
        print("Please set DXSDK_DIR environment variable or install DirectX SDK June 2010")
    end
elseif is_plat("linux", "macosx") then
    add_cxflags("-fvisibility=hidden")
end

-- Configuration-specific settings
if is_mode("debug") then
    add_defines("MTA_DEBUG", "DEBUG")
    set_suffixname("_d")
elseif is_mode("release") or is_mode("nightly") then
    set_optimize("fastest")  -- Matching premake "Speed" optimize
end

-- CI Build support
if os.getenv("CI") == "true" then
    add_defines("CI_BUILD=1")
    if is_plat("linux") then
        add_ldflags("-s")
    end
end

-- Include subprojects

includes("vendor")
includes("Shared")
includes("Server")

-- Only include client on Windows
if is_plat("windows") then
    includes("Client")
end
