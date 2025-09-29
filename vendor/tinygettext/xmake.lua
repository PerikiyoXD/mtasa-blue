target("tinygettext")
    set_basename("tinygettext")
    set_kind("static")

    add_files("*.cpp")
    add_includedirs(".", {public = true})
target_end()