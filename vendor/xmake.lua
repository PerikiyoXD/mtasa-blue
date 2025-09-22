-- Vendor libraries

-- zlib
target("zlib")
    set_kind("static")
    set_languages("c")

    add_files("zlib/*.c")
    add_headerfiles("zlib/*.h")
    remove_files("zlib/example.c")
    add_defines("verbose=-1")

    if is_plat("macosx") then
        add_defines("HAVE_UNISTD_H")
    end

-- tinyxml
target("tinyxml")
    set_kind("static")
    set_languages("cxx")

    add_includedirs("../Shared/sdk")
    add_defines("TIXML_USE_STL")
    add_files("tinyxml/*.cpp")
    add_headerfiles("tinyxml/*.h")

-- cryptopp
target("cryptopp")
    set_kind("static")
    set_languages("cxx")

    add_files("cryptopp/*.cpp")
    add_headerfiles("cryptopp/*.h")
    -- Exclude test and example files
    remove_files("cryptopp/test*.cpp", "cryptopp/bench*.cpp")

-- bcrypt (blowfish)
target("bcrypt")
    set_kind("static")
    set_languages("c")

    add_files("bcrypt/*.c")
    add_headerfiles("bcrypt/*.h")

-- json-c
target("json-c")
    set_kind("static")
    set_languages("c")

    add_files("json-c/*.c")
    add_headerfiles("json-c/*.h")

-- lua
target("lua")
    set_kind("static")
    set_languages("c")

    add_files("lua/src/*.c")
    add_headerfiles("lua/src/*.h")
    -- Remove lua interpreter main
    remove_files("lua/src/lua.c", "lua/src/luac.c")

-- sqlite
target("sqlite")
    set_kind("static")
    set_languages("c")

    add_files("sqlite/*.c")
    add_headerfiles("sqlite/*.h")