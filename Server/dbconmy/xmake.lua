target("Dbconmy")
    set_kind("shared")
    set_basename("dbconmy")
    set_targetdir("$(projectdir)/Bin/server/mods/deathmatch")

    add_files("*.cpp")
    add_includedirs(".")

    -- Platform-specific includedirs
    if is_os("windows") then
        add_includedirs("../../vendor/mysql/include", "../../vendor/sparsehash/src/windows")
    end
    add_includedirs("../../Shared/sdk", "../sdk", "../../vendor/google-breakpad/src", "../../vendor/sparsehash/src/")
    if is_os("linux") then
        add_includedirs("/usr/include/mysql")
    elseif is_os("macosx") then
        -- Assuming similar paths as premake
        add_includedirs(os.findheader("mysql.h", {
            "/usr/local/opt/mysql/include/mysql",
            "/opt/homebrew/include/mysql",
            "/opt/homebrew/opt/mysql-client/include/mysql",
        }))
        add_libdirs(os.findlib("libmysqlclient.a", {
            "/usr/local/opt/mysql/lib",
            "/opt/homebrew/lib",
            "/opt/homebrew/opt/mysql-client/lib",
        }))
    end

    -- PCH
    set_pcxxheader("StdInc.h")

    -- Dependencies
    add_deps("Shared SDK", "Server SDK", "sparsehash")

    -- Links
    if is_os("linux") then
        add_links("rt")
        if GLIBC_COMPAT then
            add_cxflags("-pthread")
            add_ldflags("-pthread")
            add_links("z", "dl", "m", "mysqlclient", "zstd", "ssl", "crypto", "resolv")
        else
            add_links("mysqlclient")
        end
    elseif is_os("macosx") then
        add_links("mysqlclient")
    elseif is_os("windows") then
        if is_arch("x64") then
            add_links("../../vendor/mysql/lib/x64/libmysql.lib")
        elseif is_arch("x86") then
            add_links("../../vendor/mysql/lib/x86/libmysql.lib")
        elseif is_arch("arm64") then
            add_links("../../vendor/mysql/lib/arm64/libmysql.lib")
        end
    end

    -- Platform-specific targetdirs
    if is_arch("x64") then
        set_targetdir("$(projectdir)/Bin/server/x64")
    elseif is_arch("arm") then
        set_targetdir("$(projectdir)/Bin/server/arm")
    elseif is_arch("arm64") then
        set_targetdir("$(projectdir)/Bin/server/arm64")
    end
target_end()
