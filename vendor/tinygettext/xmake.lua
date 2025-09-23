target("tinygettext")
    set_basename("tinygettext")
    set_kind("static")

    add_files("*.cpp")
    add_includedirs(".", {public = true})

    add_deps("SharedSDK")

target_end()