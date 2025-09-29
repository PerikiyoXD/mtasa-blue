target("Shared SDK")
    set_kind("static")
    set_basename("shared_sdk_core")
    set_languages("cxx23")

    add_files("**.cpp")
    add_includedirs(".", {public = true})

    -- if is_plat("windows") then
    --     add_cxxflags("/showIncludes", {force = true})
    -- end

    add_deps("tinyxml", "pthread")
    add_packages("cryptopp", "zlib", "detours")

    if is_plat("windows") then
        add_links("shell32")
    end
target_end()
