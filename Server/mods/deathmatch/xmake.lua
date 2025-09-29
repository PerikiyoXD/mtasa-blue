
-- Server Deathmatch
target("Server Deathmatch")
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


    -- Platform-specific sparsehash include
    if is_plat("windows") then
        add_includedirs("../vendor/sparsehash/src/windows")
    else
        add_includedirs("../vendor/sparsehash/src")
    end

    add_defines("SDK_WITH_BCRYPT")
    add_packages("cryptopp", "zip", "zlib")
    add_deps("blowfish_bcrypt", "ehs", "glob", "json-c", "pcre", "pme", "sqlite")
target_end()
