-- MTASA xmake build script

set_project("MTASA")
set_version("1.6.0")

-- Add custom modes matching premake
set_allowedmodes("debug", "release", "nightly")

-- Set up platforms matching premake5
-- On Windows: x86, x64, arm64
-- On Linux: x86, x64, arm, arm64
-- On macOS: arm64 only
if is_plat("windows") then
    set_allowedplats("windows")
    set_allowedarchs("windows", "x86", "x64", "arm64")
    set_defaultarchs("windows", "x86")
elseif is_plat("linux") then
    set_allowedplats("linux")
    set_allowedarchs("linux", "x86", "x64", "arm", "arm64")
elseif is_plat("macosx") then
    set_allowedplats("macosx")
    set_allowedarchs("macosx", "arm64")
end

-- Add is_client function for platform and architecture checks
function is_client()
    return is_plat("windows") and is_arch("x86")
end

-- Global settings (matching premake C++23)
set_languages("cxx23")
add_rules("mode.debug", "mode.release")
set_symbols("on")

-- Fix resource compiler hanging issue
if is_plat("windows") then
    set_toolchains("msvc")
    -- Explicitly configure resource compiler
    add_rules("utils.bin2c", {extensions = {".rc"}})
end

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

-- Enforcement of architecture-specific builds
function set_arch_enforcement(target_name)
    target(target_name)
        if is_plat("windows") then
            if is_arch("x86") then
                add_defines("MTA_PLATFORM_X86", "MTA_PLATFORM_X86_32", "MTA_PLATFORM_WINDOWS")
            elseif is_arch("x64") then
                add_defines("MTA_PLATFORM_X86", "MTA_PLATFORM_X86_64", "MTA_PLATFORM_WINDOWS")
            elseif is_arch("arm64") then
                add_defines("MTA_PLATFORM_ARM", "MTA_PLATFORM_ARM_64", "MTA_PLATFORM_WINDOWS")
            end
        elseif is_plat("linux") then
            if is_arch("x86") then
                add_defines("MTA_PLATFORM_X86", "MTA_PLATFORM_X86_32", "MTA_PLATFORM_LINUX")
            elseif is_arch("x64") then
                add_defines("MTA_PLATFORM_X86", "MTA_PLATFORM_X86_64", "MTA_PLATFORM_LINUX")
            elseif is_arch("arm") then
                add_defines("MTA_PLATFORM_ARM", "MTA_PLATFORM_ARM_32", "MTA_PLATFORM_LINUX")
            elseif is_arch("arm64") then
                add_defines("MTA_PLATFORM_ARM", "MTA_PLATFORM_ARM_64", "MTA_PLATFORM_LINUX")
            end
        elseif is_plat("macosx") then
            if is_arch("arm64") then
                add_defines("MTA_PLATFORM_ARM", "MTA_PLATFORM_ARM_64", "MTA_PLATFORM_MACOSX")
            end
        end
    target_end()
end

-- Include subprojects

includes("vendor")
includes("Shared")
includes("Server")

-- Only include client on Windows
if is_plat("windows") then
    includes("Client")
end