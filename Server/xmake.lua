-- Server targets

-- Server Core
target("Core")
    set_kind("shared")
    set_basename("core")
    set_targetdir("$(projectdir)/Bin/server")

    add_includedirs(
        "../Shared/sdk",
        "sdk",
        "../vendor/google-breakpad/src",
        "../vendor/sparsehash/current/src/"
    )

    if is_plat("windows") then
        add_includedirs("../vendor/sparsehash/current/src/windows")
        if is_arch("x86") then
            add_includedirs("../vendor/detours/4.0.1/src")
            add_links("detours", "Imagehlp")
        end
    elseif is_plat("linux") then
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

-- Server Deathmatch
target("Deathmatch")
    set_kind("shared")
    set_targetdir("$(projectdir)/Bin/server/mods/deathmatch")

    add_files("mods/deathmatch/logic/*.cpp")
    add_headerfiles("mods/deathmatch/logic/*.h")
    add_includedirs("../Shared/sdk", "sdk", "../vendor")

-- DB Connection MySQL
target("Dbconmy")
    set_kind("shared")
    set_targetdir("$(projectdir)/Bin/server/mods/deathmatch")

    add_files("dbconmy/*.cpp")
    add_headerfiles("dbconmy/*.h")
    add_includedirs("../vendor")
