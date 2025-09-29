target("Shared XML")
    set_kind("shared")
    set_basename("xmll")
    set_targetdir("$(projectdir)/Bin/server")

    add_files("**.cpp")
    add_includedirs(".", {public = true})
    add_deps("tinyxml", "Shared SDK")
target_end()
