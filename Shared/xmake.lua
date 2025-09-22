-- Shared libraries

-- XML Library
target("XML")
    set_kind("shared")
    set_basename("xmll")
    set_targetdir("$(projectdir)/Bin/server")

    add_includedirs("sdk", "../vendor/tinyxml")
    add_deps("tinyxml")
    add_defines("TIXML_USE_STL")

    add_files("XML/*.cpp")
    add_headerfiles("XML/*.h")
