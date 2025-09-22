-- Vendor libraries

-- zlib
target("zlib")
    set_kind("static")
    set_languages("c")

    add_files("zlib/*.c")
    add_headerfiles("zlib/*.h")
    remove_files("zlib/example.c")

    -- Stop "bit length overflow" warning (from premake)
    add_defines("verbose=-1")

    if is_plat("windows") then
        -- Windows-specific configuration
        add_defines("_WIN32", "_WINDOWS")
        add_cflags("/D_CRT_SECURE_NO_WARNINGS")
    elseif is_plat("macosx") then
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

-- detours
target("detours")
    set_kind("static")
    set_languages("cxx")

    add_files("detours/4.0.1/src/*.cpp")
    add_headerfiles("detours/4.0.1/src/*.h")
    add_includedirs("detours/4.0.1/src")

-- CEGUI
target("CEGUI")
    set_kind("static")
    set_languages("cxx")

    add_files("cegui-0.4.0-custom/src/*.cpp")
    add_headerfiles("cegui-0.4.0-custom/include/*.h")
    add_includedirs("cegui-0.4.0-custom/include", "freetype/include")

-- DirectX9GUIRenderer
target("DirectX9GUIRenderer")
    set_kind("static")
    set_languages("cxx")

    add_files("cegui-0.4.0-custom/src/renderers/directx9GUIRenderer/*.cpp")
    add_headerfiles("cegui-0.4.0-custom/include/renderers/DirectX9GUIRenderer/*.h")
    add_includedirs("cegui-0.4.0-custom/include")

-- Falagard
target("Falagard")
    set_kind("static")
    set_languages("cxx")

    add_files("cegui-0.4.0-custom/WidgetSets/Falagard/src/*.cpp")
    add_headerfiles("cegui-0.4.0-custom/WidgetSets/Falagard/include/*.h")
    add_includedirs("cegui-0.4.0-custom/include", "cegui-0.4.0-custom/WidgetSets/Falagard/include")

-- libpng
target("libpng")
    set_kind("static")
    set_languages("c")

    add_files("libpng/*.c")
    add_headerfiles("libpng/*.h")
    add_deps("zlib")

-- jpeg
target("jpeg")
    set_kind("static")
    set_languages("c")

    add_files("jpeg-9f/*.c")
    add_headerfiles("jpeg-9f/*.h")

-- pcre
target("pcre")
    set_kind("static")
    set_languages("c")

    add_files("pcre/*.c")
    add_headerfiles("pcre/*.h")

-- libspeex
target("libspeex")
    set_kind("static")
    set_languages("c")

    add_files("libspeex/libspeex/*.c")
    add_headerfiles("libspeex/include/speex/*.h")
    add_includedirs("libspeex/include")

-- tinygettext
target("tinygettext")
    set_kind("static")
    set_languages("cxx")

    add_files("tinygettext/*.cpp")
    add_headerfiles("tinygettext/*.hpp")
    add_includedirs("tinygettext")

-- blowfish_bcrypt
target("blowfish_bcrypt")
    set_kind("static")
    set_languages("c")

    add_files("bcrypt/*.c")
    add_headerfiles("bcrypt/*.h")

-- lunasvg
target("lunasvg")
    set_kind("static")
    set_languages("cxx")

    add_files("lunasvg/source/*.cpp")
    add_headerfiles("lunasvg/include/**.h")
    add_includedirs("lunasvg/include")

-- freetype
target("freetype")
    set_kind("static")
    set_languages("c")

    add_files("freetype/src/**.c")
    add_headerfiles("freetype/include/**.h")
    add_includedirs("freetype/include")
    add_defines("FT2_BUILD_LIBRARY")

-- Lua_Client (separate lua build for client)
target("Lua_Client")
    set_kind("static")
    set_languages("c")

    add_files("lua/src/*.c")
    add_headerfiles("lua/src/*.h")
    -- Remove lua interpreter main
    remove_files("lua/src/lua.c", "lua/src/luac.c")