target("sqlite")
    set_kind("static")
    set_languages("c")

    add_files("*.c")
    add_headerfiles("*.h")
target_end()