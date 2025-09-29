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


    add_files("core/*.cpp")
    add_headerfiles("core/*.h")

    if not is_plat("windows") then
        remove_files("core/CExceptionInformation_Impl.cpp")
    end
target_end()
