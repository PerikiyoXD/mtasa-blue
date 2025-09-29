target("tinyxml")
    set_basename("tinyxml")
    set_kind("static")

    add_files("*.cpp")
    add_includedirs(".", {public = true})

	add_defines("TIXML_USE_STL")
target_end()