target("CEGUI")
    set_kind("static")
    set_basename("CEGUI")

    set_pcxxheader("src/StdInc.h")

    add_files("src/**.cpp",
              "src/**.c",
              "include/**.h")

    remove_files(
        "src/renderers/**",
        "src/pcre/ucptypetable.c",
        "src/pcre/ucptable.c",
        "src/pcre/ucp.c")

    add_includedirs("include", {public = true})

	add_defines("CEGUIBASE_EXPORTS", "_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING")

    add_deps("freetype", "pcre", "tinyxml", "tinygettext")
target_end()