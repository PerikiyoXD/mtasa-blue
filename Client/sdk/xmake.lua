target("Client SDK")
    set_basename("sdk")
    set_kind("static")

    add_files("**.cpp")

    add_includedirs(".", {public = true})
target_end()
