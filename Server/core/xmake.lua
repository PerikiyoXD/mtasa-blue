-- /*****************************************************************************
--  *
--  *  PROJECT:     Multi Theft Auto
--  *  LICENSE:     See LICENSE in the top level directory
--  *
--  *  Multi Theft Auto is available from https://www.multitheftauto.com/
--  *
--  *****************************************************************************/

target("Server Core")
    set_kind("shared")
    set_basename("core")
    set_targetdir("$(projectdir)/Bin/server")

    add_files("*.cpp")
    add_headerfiles("*.h")

    -- Include directories (matching premake)
    add_includedirs("../../Shared/sdk", "../sdk", "../../vendor/google-breakpad/src", "../../vendor/sparsehash/current/src")

    if is_plat("windows") then
        add_includedirs("../../vendor/sparsehash/current/src/windows")
        if is_arch("x86") then
            add_includedirs("../../vendor/detours/4.0.1/src")
            add_deps("detours", "Shared SDK")
            add_links("Imagehlp")
        end
        remove_files("CExceptionInformation_Impl.cpp")
    else
        remove_files("CExceptionInformation_Impl.cpp")
    end
target_end()
