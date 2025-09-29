target("CEGUI")
    set_kind("static")
    set_basename("CEGUI")
    set_languages("cxx23")

    set_pcxxheader("include/StdInc.h")

    add_files("src/**.cpp",
              "src/**.c")

    remove_files(
        "src/renderers/**",
        "src/pcre/ucptypetable.c",
        "src/pcre/ucptable.c",
        "src/pcre/ucp.c")

    add_includedirs("include", {public = true})

	add_defines("CEGUIBASE_EXPORTS", "_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING")

    add_deps("pcre", "tinyxml", "tinygettext", "Shared SDK Core")
    add_packages("freetype")
target_end()

includes("src/renderers/directx9GUIRenderer")