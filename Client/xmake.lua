-- Client targets (Windows only)

-- CEF Launcher
target("CEFLauncher")
    set_kind("binary")
    set_targetdir("$(projectdir)/Bin")

    add_files("ceflauncher/*.cpp")
    add_headerfiles("ceflauncher/*.h")
    add_includedirs("../vendor/cef3/cef")

    -- Only build on Windows x86 (matching premake)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- CEF Launcher DLL
target("CEFLauncher_DLL")
    set_kind("shared")
    set_basename("CEFLauncher_DLL")
    set_targetdir("$(projectdir)/Bin/mta/cef")

    add_files("ceflauncher_DLL/*.cpp")
    add_headerfiles("ceflauncher_DLL/*.h")
    add_includedirs("../vendor/cef3/cef")
    add_linkdirs("../vendor/cef3/cef/Release")

    -- CEF launcher needs UNICODE (from premake)
    add_defines("UNICODE", "_UNICODE", "PSAPI_VERSION=1")

    -- CEF libraries and delay loading
    add_links("delayimp", "libcef", "Psapi", "version", "Winmm", "Ws2_32", "DbgHelp")
    add_ldflags("/DELAYLOAD:libcef.dll")

    -- Only build on Windows x86 (matching premake)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- Client Web Browser
target("Client_Webbrowser")
    set_kind("shared")
    set_basename("Client_Webbrowser")
    set_targetdir("$(projectdir)/Bin/mta")
    set_languages("cxx17")  -- CEF requires C++17

    -- Match premake5 configuration
    add_defines("PSAPI_VERSION=1")
    -- TODO: Fix precompiled headers later
    -- set_pcheader("cefweb/StdInc.h")
    -- set_pcxxheader("cefweb/StdInc.h")

    add_files("cefweb/*.cpp")
    add_headerfiles("cefweb/*.h")
    add_includedirs("../vendor", "../vendor/cef3/cef", "../Shared/sdk", "sdk")
    add_includedirs("../vendor/sparsehash/src/windows", "../vendor/sparsehash/src")

    -- Link against CEF target and system libraries
    add_deps("CEF")
    add_links("Psapi", "version", "Winmm", "Ws2_32", "DbgHelp", "User32", "Shell32")

-- Client Core
target("Client_Core")
    set_kind("shared")
    set_basename("core")
    set_targetdir("$(projectdir)/Bin/mta")

    -- Precompiled headers (matching premake)
    set_pcheader("core/StdInc.h")
    set_pcxxheader("core/StdInc.h")

    add_includedirs(
        "../Shared/sdk",
        "core",  -- Self include for PCH
        "sdk",
        "../vendor/tinygettext",
        "../vendor/zlib",
        "../vendor/jpeg-9f",
        "../vendor/pthreads/include",
        "../vendor/detours/4.0.1/src",
        "../vendor/discord-rpc/discord/include"
    )

    if is_plat("windows") then
        add_cxflags("/Zm130")  -- Matching premake buildoptions
    end

    add_files("core/*.cpp", "core/*.rc")
    add_headerfiles("core/*.h", "core/*.hpp")
    -- Include icon resource (matching premake)
    -- add_files("launch/resource/mtaicon.ico")

    add_deps("detours")

    if is_plat("windows") then
        add_links(
            "ws2_32", "d3dx9", "Userenv", "DbgHelp", "xinput", "Imagehlp",
            "dxguid", "dinput8", "strmiids", "odbc32", "odbccp32", "shlwapi",
            "winmm", "gdi32", "Imm32", "Psapi", "dwmapi", "wintrust", "crypt32"
        )
        add_deps("tinygettext", "discord-rpc", "zlib", "libpng", "jpeg")
    end

    add_defines("INITGUID", "PNG_SETJMP_NOT_SUPPORTED")

    -- Prebuild command (matching premake)
    before_build(function (target)
        -- Generate language list
        os.execv("utils/gen_language_list.exe", {"Shared/data/MTA San Andreas/MTA/locale", "Client/core/languages.generated.h"})
    end)

    -- Only build on Windows x86 (matching premake)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- Client Deathmatch
target("Client_Deathmatch")
    set_kind("shared")
    set_basename("client")
    set_targetdir("$(projectdir)/Bin/mods/deathmatch")

    -- Precompiled headers (matching premake)
    set_pcheader("mods/deathmatch/StdInc.h")
    set_pcxxheader("mods/deathmatch/StdInc.h")
    add_files("mods/deathmatch/StdInc.cpp") -- PCH source

    add_includedirs(
        "../Shared/sdk",
        "mods/deathmatch",
        "mods/deathmatch/logic",
        "sdk",
        "../vendor/pthreads/include",
        "../vendor/bochs",
        "../vendor/bass",
        "../vendor/libspeex",
        "../vendor/zlib",
        "../vendor/pcre",
        "../vendor/json-c",
        "../vendor/lua/src",
        "../Shared/mods/deathmatch/logic",
        "../Shared/animation",
        "../vendor/lunasvg/include"
    )

    if is_plat("windows") then
        add_cxflags("/Zm180")  -- Matching premake buildoptions
        add_ldflags("/SAFESEH:NO")  -- Matching premake linkoptions
    end

    add_files(
        "mods/deathmatch/*.cpp",
        "../Shared/mods/deathmatch/logic/*.cpp",
        "../Shared/animation/CEasingCurve.cpp",
        "../Shared/animation/CPositionRotationAnimation.cpp",
        "../vendor/bochs/bochs_internal/bochs_crc32.cpp"
    )
    add_headerfiles("mods/deathmatch/*.h", "../Shared/mods/deathmatch/logic/*.h")

    add_defines("LUNASVG_BUILD", "LUA_USE_APICHECK", "SDK_WITH_BCRYPT")

    if is_plat("windows") then
        -- Bass library links with full path (matching premake)
        add_linkdirs("../vendor/bass/lib")
        add_links(
            "ws2_32", "portaudio", "bass", "bass_fx", "bassmix", "tags"
        )
        add_deps("Lua_Client", "pcre", "json-c", "zlib", "cryptopp", "libspeex", "blowfish_bcrypt", "lunasvg")
    end

    -- Only build on Windows x86 (matching premake filters)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- GUI
target("GUI")
    set_kind("shared")
    set_basename("cgui")
    set_targetdir("$(projectdir)/Bin/mta")

    -- Precompiled headers (matching premake)
    set_pcheader("gui/StdInc.h")
    set_pcxxheader("gui/StdInc.h")
    add_files("gui/StdInc.cpp")

    add_includedirs(
        "../Shared/sdk",
        "sdk",
        "../vendor/cegui-0.4.0-custom/include"
    )

    add_files("gui/*.cpp")
    add_headerfiles("gui/*.h")

    add_defines("_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING")

    if is_plat("windows") then
        add_links("d3dx9", "dxerr")
        add_deps("CEGUI", "DirectX9GUIRenderer", "Falagard")
    end

    -- Only build on Windows x86
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- Game SA
target("Game_SA")
    set_kind("shared")
    set_basename("game_sa")
    set_targetdir("$(projectdir)/Bin/mta")

    -- Precompiled headers (matching premake)
    set_pcheader("game_sa/StdInc.h")
    set_pcxxheader("game_sa/StdInc.h")
    add_files("game_sa/StdInc.cpp")

    add_includedirs(
        "../Shared/sdk",
        "sdk"
    )

    add_files("game_sa/*.cpp")
    add_headerfiles("game_sa/*.h", "game_sa/*.hpp")

    -- Only build on Windows x86
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- Multiplayer SA
target("Multiplayer_SA")
    set_kind("shared")
    set_basename("multiplayer_sa")
    set_targetdir("$(projectdir)/Bin/mta")

    -- Precompiled headers (matching premake)
    set_pcheader("multiplayer_sa/StdInc.h")
    set_pcxxheader("multiplayer_sa/StdInc.h")
    add_files("multiplayer_sa/StdInc.cpp")

    add_includedirs(
        "../Shared/sdk",
        "sdk"
    )

    add_files("multiplayer_sa/*.cpp")
    add_headerfiles("multiplayer_sa/*.h")

    -- Only build on Windows x86
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- Client Launcher
target("Client_Launcher")
    set_kind("binary")
    set_basename("Multi Theft Auto")
    set_targetdir("$(projectdir)/Bin")

    -- Precompiled headers (matching premake)
    set_pcheader("launch/StdInc.h")
    set_pcxxheader("launch/StdInc.h")
    add_files("launch/StdInc.cpp")

    add_includedirs(
        "../Shared/sdk",
        "sdk"
    )

    add_files("launch/*.cpp", "launch/*.rc")
    add_headerfiles("launch/*.h")

    -- Windows app entry point
    if is_plat("windows") then
        add_ldflags("/SUBSYSTEM:WINDOWS", "/ENTRY:WinMainCRTStartup")
    end

    -- Only build on Windows x86
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- Loader
target("Loader")
    set_kind("shared")
    set_basename("loader")
    set_targetdir("$(projectdir)/Bin/mta")

    -- Precompiled headers (matching premake)
    set_pcheader("loader/StdInc.h")
    set_pcxxheader("loader/StdInc.h")
    add_files("loader/StdInc.cpp")

    add_includedirs(
        "../Shared/sdk",
        "sdk",
        "../vendor",
        "../vendor/detours/4.0.1/src"
    )

    add_files("loader/*.cpp", "loader/*.rc")
    add_headerfiles("loader/*.h")

    if is_plat("windows") then
        add_links("unrar", "d3d9", "Imagehlp")
        add_linkdirs("../vendor/nvapi/x86")
        add_links("nvapi")
        add_deps("detours", "cryptopp")

        -- Disable specific warnings (matching premake)
        add_cxflags("/wd4996")
    end

    -- Only build on Windows x86
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- Loader Proxy
target("Loader_Proxy")
    set_kind("shared")
    set_basename("mtaloader")
    set_targetdir("$(projectdir)/Bin")

    add_includedirs("../Shared/sdk", "sdk")
    add_files("loader-proxy/*.cpp")
    add_headerfiles("loader-proxy/*.h")

    -- Only build on Windows x86
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- Client SDK
target("Client_SDK")
    set_kind("headeronly")

    add_headerfiles("sdk/*.h", "sdk/*.hpp")
    add_includedirs("../Shared/sdk", "sdk")
    add_headerfiles("multiplayer_sa/*.h")

    -- Only build on Windows x86
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end
