-- Server targets

-- Configure MTA_DEBUG for debug builds (matching premake behavior)
if is_mode("debug") then
    add_defines("MTA_DEBUG")
end

-- Server Core
target("Core")
    set_kind("shared")
    set_basename("core")
    set_targetdir("$(projectdir)/Bin/server")

    add_includedirs(
        "../Shared/sdk",
        "sdk",
        "../vendor/google-breakpad/src"
    )

    -- Platform-specific sparsehash include
    if is_plat("windows") then
        add_includedirs("../vendor/sparsehash/src/windows")
        -- Add common Windows system libraries for file operations
        add_links("Shell32", "User32", "Kernel32", "Advapi32", "Ole32", "Gdi32")
        if is_arch("x86") then
            add_includedirs("../vendor/detours/4.0.1/src")
            add_linkdirs("$(builddir)/windows/x86/release")
            add_links("detours", "Imagehlp")
        end
    elseif is_plat("linux") then
        add_includedirs("../vendor/sparsehash/src")
        add_links("breakpad", "rt")
        add_cxflags("-pthread")
        add_ldflags("-pthread", "-l:libncursesw.so.6")
    elseif is_plat("macosx") then
        add_links("ncurses", "breakpad", "CoreFoundation.framework")
        add_cxflags("-pthread")
        add_ldflags("-pthread")
        add_defines("_XOPEN_SOURCE_EXTENDED=1")
    end

    add_files("core/*.cpp")
    add_headerfiles("core/*.h")

    if not is_plat("windows") then
        remove_files("core/CExceptionInformation_Impl.cpp")
    end

-- Server Launcher
target("Launcher")
    set_kind("binary")
    set_targetdir("$(projectdir)/Bin/server")

    add_files("launcher/*.cpp")
    add_headerfiles("launcher/*.h")
    add_includedirs("../Shared/sdk", "sdk")

    if is_plat("windows") then
        add_links("User32", "Shell32", "Kernel32", "Advapi32")
    end

-- Server Deathmatch
target("Deathmatch")
    set_kind("shared")
    set_basename("deathmatch")
    set_targetdir("$(projectdir)/Bin/server/mods/deathmatch")

    -- Precompiled header
    set_pcheader("StdInc.h")
    add_files("mods/deathmatch/StdInc.cpp")

    add_files("mods/deathmatch/logic/*.cpp")
    add_files("../Shared/mods/deathmatch/logic/*.cpp")
    add_headerfiles("mods/deathmatch/logic/*.h")
    add_headerfiles("mods/deathmatch/*.h")
    add_headerfiles("../Shared/mods/deathmatch/logic/*.h")

    add_includedirs(
        "../Shared/sdk",
        "sdk",
        "../vendor/bochs",
        "../vendor/pme",
        "../vendor/zip",
        "../vendor/glob/include",
        "../vendor/zlib",
        "../vendor/pcre",
        "../vendor/json-c",
        "../vendor/lua/src",
        "../vendor/pthreads/include",
        "../Shared/gta",
        "../Shared/mods/deathmatch/logic",
        "../Shared/animation",
        "../Shared/publicsdk/include",
        "mods/deathmatch/logic",
        "mods/deathmatch/utils",
        "mods/deathmatch"
    )

    -- Platform-specific sparsehash include
    if is_plat("windows") then
        add_includedirs("../vendor/sparsehash/src/windows")
    else
        add_includedirs("../vendor/sparsehash/src")
    end

    add_defines("SDK_WITH_BCRYPT")
    add_deps("blowfish_bcrypt", "cryptopp", "ehs", "glob", "json-c", "pcre", "pme", "sqlite", "zip", "zlib")

-- DB Connection MySQL
target("Dbconmy")
    set_kind("shared")
    set_targetdir("$(projectdir)/Bin/server/mods/deathmatch")

    add_files("dbconmy/*.cpp")
    add_headerfiles("dbconmy/*.h")
    add_includedirs("../Shared/sdk", "sdk", "../vendor")

    -- MySQL includes and links
    add_includedirs("../vendor/mysql/include")

    if is_plat("windows") then
        -- Add common Windows system libraries for file operations (same as Core)
        add_links("Shell32", "User32", "Kernel32", "Advapi32", "Ole32")
        if is_arch("x64") then
            add_linkdirs("../vendor/mysql/lib/x64")
            add_links("libmysql")
        elseif is_arch("x86") then
            add_linkdirs("../vendor/mysql/lib/x86")
            add_links("libmysql")
        elseif is_arch("arm64") then
            add_linkdirs("../vendor/mysql/lib/arm64")
            add_links("libmysql")
        end
    elseif is_plat("linux") then
        add_includedirs("/usr/include/mysql")
        add_links("z", "dl", "m", "mysqlclient", "zstd", "ssl", "crypto", "resolv")
    elseif is_plat("macosx") then
        -- macOS MySQL paths would be dynamic based on installation
        add_links("mysqlclient")
    end
