-- MTASA xmake build script

set_project("MTASA")
set_version("1.6.0")

-- Global settings
set_languages("cxx20")
add_rules("mode.debug", "mode.release")

-- Global include directories
add_includedirs("vendor", {public = true})

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
    -- Enable multiprocessor compilation
    add_cxflags("/MP")
elseif is_plat("linux", "macosx") then
    add_cxflags("-fvisibility=hidden")
end

-- Configuration-specific settings
if is_mode("debug") then
    add_defines("MTA_DEBUG", "DEBUG")
    set_suffixname("_d")
end

-- Include subprojects
includes("vendor")
includes("Shared")
includes("Server")
-- Only include client on Windows
if is_plat("windows") then
    includes("Client")
end
