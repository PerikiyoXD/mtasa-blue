-- Client targets (Windows only)

-- CEF Launcher
target("CEFLauncher")
    set_kind("binary")
    set_targetdir("$(projectdir)/Bin")

    add_files("ceflauncher/*.cpp")
    add_headerfiles("ceflauncher/*.h")
    add_includedirs("../vendor", "../vendor/cef3/cef")

-- CEF Launcher DLL
target("CEFLauncher_DLL")
    set_kind("shared")
    set_targetdir("$(projectdir)/Bin")

    add_files("ceflauncher_DLL/*.cpp")
    add_headerfiles("ceflauncher_DLL/*.h")
    add_includedirs("../vendor", "../vendor/cef3/cef")

-- Client Web Browser
target("Client_Webbrowser")
    set_kind("shared")
    set_basename("Client_Webbrowser")
    set_targetdir("$(projectdir)/Bin/mta")

    add_files("cefweb/*.cpp")
    add_headerfiles("cefweb/*.h")
    add_includedirs("../vendor", "../vendor/cef3/cef", "../Shared/sdk", "sdk")

-- Client Core
target("Client_Core")
    set_kind("shared")
    set_basename("core")
    set_targetdir("$(projectdir)/Bin/mta")

    add_includedirs(
        "../Shared/sdk",
        "sdk",
        "../vendor/tinygettext",
        "../vendor/zlib",
        "../vendor/jpeg-9f",
        "../vendor/pthreads/include",
        "../vendor/sparsehash/src/",
        "../vendor/detours/4.0.1/src",
        "../vendor/discord-rpc/discord/include"
    )

    if is_plat("windows") then
        add_includedirs("../vendor/sparsehash/src/windows")
        add_cxflags("-Zm130")
    end

    add_files("core/*.cpp", "core/*.rc")
    add_headerfiles("core/*.h")

    add_deps("detours")

    if is_plat("windows") then
        add_links(
            "ws2_32", "d3dx9", "Userenv", "DbgHelp", "xinput", "Imagehlp",
            "dxguid", "dinput8", "strmiids", "odbc32", "odbccp32", "shlwapi",
            "winmm", "gdi32", "Imm32", "Psapi", "dwmapi", "wintrust", "crypt32"
        )
        add_deps("zlib", "tinygettext", "discord-rpc")
    end

    add_defines("INITGUID", "PNG_SETJMP_NOT_SUPPORTED")

    -- Only build on Windows x86
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- Client Deathmatch
target("Client_Deathmatch")
    set_kind("shared")
    set_targetdir("$(projectdir)/Bin/mods/deathmatch")

    add_files("mods/deathmatch/logic/*.cpp")
    add_headerfiles("mods/deathmatch/logic/*.h")
    add_includedirs("../Shared/sdk", "sdk", "../vendor", "mods/deathmatch")
