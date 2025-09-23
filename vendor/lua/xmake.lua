target("lua")
    set_kind("static")
    set_languages("c")

    add_files("src/*.c")
    add_headerfiles("src/*.h")

    -- Remove lua interpreter main
    remove_files("src/lua.c", "src/luac.c")
target_end()