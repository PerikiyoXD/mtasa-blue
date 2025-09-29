target("sparsehash")
    set_kind("phony")
    set_languages("cxx23")
    --add_defines("HASH_NAMESPACE=google", "SPARSEHASH_HASH", "HAVE_CONFIG_H")

    -- Only build on Windows x86 (matching premake)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

    add_includedirs("src", {public = true})

target_end()