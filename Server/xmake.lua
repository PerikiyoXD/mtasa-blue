

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
