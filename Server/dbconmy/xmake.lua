-- /*****************************************************************************
--  *
--  *  PROJECT:     Multi Theft Auto
--  *  LICENSE:     See LICENSE in the top level directory
--  *
--  *  Multi Theft Auto is available from https://www.multitheftauto.com/
--  *
--  *****************************************************************************/

target("Dbconmy")
    set_kind("shared")
    set_basename("dbconmy")
    set_targetdir("$(projectdir)/Bin/server/mods/deathmatch")

    add_files("*.cpp")
    add_includedirs(".")

    add_deps("Shared SDK", "Server SDK", "google-breakpad", "sparsehash")
target_end()
