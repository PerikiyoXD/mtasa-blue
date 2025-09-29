target("pthread")
    set_kind("shared")
    set_basename("pthread")
    set_targetdir("$(projectdir)/Bin/server")

    add_files("include/pthread.c")
    add_includedirs("include", {public = true})

    add_defines("HAVE_PTW32_CONFIG_H",
			    "PTW32_BUILD_INLINED")
target_end()