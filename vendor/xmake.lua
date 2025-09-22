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

-- tinygettext
target("tinygettext")
    set_kind("static")
    set_languages("cxx")

    add_includedirs("../Shared/sdk")
    add_files("tinygettext/*.cpp")
    add_headerfiles("tinygettext/*.hpp")

-- bcrypt (blowfish)
target("bcrypt")
    set_kind("static")
    set_languages("c")

    add_files("bcrypt/*.c")
    add_headerfiles("bcrypt/*.h")

-- blowfish_bcrypt (alias for bcrypt)
target("blowfish_bcrypt")
    set_kind("static")
    set_languages("c")

    add_files("bcrypt/*.c")
    add_headerfiles("bcrypt/*.h")

-- discord-rpc
target("discord-rpc")
    set_kind("static")
    set_languages("cxx")

    add_includedirs("discord-rpc/discord/include", "discord-rpc/discord/thirdparty/rapidjson/include")
    add_defines("DISCORD_DISABLE_IO_THREAD")
    add_files(
        "discord-rpc/discord/src/discord_rpc.cpp",
        "discord-rpc/discord/src/rpc_connection.cpp",
        "discord-rpc/discord/src/serialization.cpp",
        "discord-rpc/discord/src/connection_win.cpp",
        "discord-rpc/discord/src/discord_register_win.cpp"
    )
    add_headerfiles("discord-rpc/discord/include/*.h")

    -- Only build for Windows x86 (from premake)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- pcre
target("pcre")
    set_kind("shared")
    set_basename("pcre3")
    set_languages("cxx")
    set_targetdir("$(projectdir)/Bin/server/mods/deathmatch")

    add_defines("HAVE_CONFIG_H")
    add_includedirs("pcre")
    add_files("pcre/*.c", "pcre/*.cc")
    add_headerfiles("pcre/*.h")

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

    add_files(
        "detours/4.0.1/src/creatwth.cpp",
        "detours/4.0.1/src/detours.cpp",
        "detours/4.0.1/src/image.cpp",
        "detours/4.0.1/src/modules.cpp",
        "detours/4.0.1/src/disolx86.cpp",
        "detours/4.0.1/src/disolx64.cpp",
        "detours/4.0.1/src/disasm.cpp"
    )
    add_headerfiles("detours/4.0.1/src/*.h")
    add_includedirs("detours/4.0.1/src")
    add_defines("WIN32_LEAN_AND_MEAN")

-- CEGUI
target("CEGUI")
    set_kind("static")
    set_languages("cxx")

    add_files("cegui-0.4.0-custom/src/*.cpp")
    add_headerfiles("cegui-0.4.0-custom/include/*.h")
    add_includedirs("cegui-0.4.0-custom/include", "cegui-0.4.0-custom/dependencies/include", "freetype/include", {public = true})

    -- Exclude the renderer directory (built separately)
    remove_files("cegui-0.4.0-custom/src/renderers/**")
    -- Exclude these files (from premake)
    remove_files("cegui-0.4.0-custom/src/pcre/ucptypetable.c", "cegui-0.4.0-custom/src/pcre/ucptable.c", "cegui-0.4.0-custom/src/pcre/ucp.c")

    add_defines("CEGUIBASE_EXPORTS", "_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING")
    add_deps("freetype")

    -- Windows x86 only (from premake)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- DirectX9GUIRenderer
target("DirectX9GUIRenderer")
    set_kind("static")
    set_languages("cxx")

    add_defines("_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING")
    add_includedirs("cegui-0.4.0-custom/include")
    add_files(
        "cegui-0.4.0-custom/src/renderers/directx9GUIRenderer/d3d9renderer.cpp",
        "cegui-0.4.0-custom/src/renderers/directx9GUIRenderer/d3d9texture.cpp"
    )
    add_headerfiles(
        "cegui-0.4.0-custom/include/renderers/d3d9texture.h",
        "cegui-0.4.0-custom/include/renderers/d3d9renderer.h"
    )

    -- Windows x86 only (from premake)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- Falagard
target("Falagard")
    set_kind("static")
    set_languages("cxx")

    add_defines("FALAGARDBASE_EXPORTS", "_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING")
    add_includedirs("cegui-0.4.0-custom/WidgetSets/Falagard/include", "cegui-0.4.0-custom/include")
    add_files("cegui-0.4.0-custom/WidgetSets/Falagard/src/*.cpp")
    add_headerfiles("cegui-0.4.0-custom/WidgetSets/Falagard/include/*.h")

    -- Windows x86 only (from premake)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

-- libpng
target("libpng")
    set_kind("static")
    set_languages("c")

    -- Match premake5 file selection and config
    add_files("libpng/*.c")
    remove_files("libpng/example.c", "libpng/pngtest.c")  -- Exclude test files
    add_headerfiles("libpng/*.h")
    add_includedirs("zlib", "libpng", {public = true})
    add_defines("_CRT_SECURE_NO_WARNINGS", "WIN32_LEAN_AND_MEAN", "PNG_NO_MMX_CODE", "PNG_SETJMP_NOT_SUPPORTED")
    add_deps("zlib")

-- jpeg
target("jpeg")
    set_kind("static")
    set_languages("c")

    -- Match premake5 file selection - exclude DOS/MAC/Windows specific memory managers
    add_files("jpeg-9f/jaricom.c")
    add_files("jpeg-9f/jcapimin.c")
    add_files("jpeg-9f/jcapistd.c")
    add_files("jpeg-9f/jcarith.c")
    add_files("jpeg-9f/jccoefct.c")
    add_files("jpeg-9f/jccolor.c")
    add_files("jpeg-9f/jcdctmgr.c")
    add_files("jpeg-9f/jchuff.c")
    add_files("jpeg-9f/jcinit.c")
    add_files("jpeg-9f/jcmainct.c")
    add_files("jpeg-9f/jcmarker.c")
    add_files("jpeg-9f/jcmaster.c")
    add_files("jpeg-9f/jcomapi.c")
    add_files("jpeg-9f/jcparam.c")
    add_files("jpeg-9f/jcprepct.c")
    add_files("jpeg-9f/jcsample.c")
    add_files("jpeg-9f/jctrans.c")
    add_files("jpeg-9f/jdapimin.c")
    add_files("jpeg-9f/jdapistd.c")
    add_files("jpeg-9f/jdarith.c")
    add_files("jpeg-9f/jdatadst.c")
    add_files("jpeg-9f/jdatasrc.c")
    add_files("jpeg-9f/jdcoefct.c")
    add_files("jpeg-9f/jdcolor.c")
    add_files("jpeg-9f/jddctmgr.c")
    add_files("jpeg-9f/jdhuff.c")
    add_files("jpeg-9f/jdinput.c")
    add_files("jpeg-9f/jdmainct.c")
    add_files("jpeg-9f/jdmarker.c")
    add_files("jpeg-9f/jdmaster.c")
    add_files("jpeg-9f/jdmerge.c")
    add_files("jpeg-9f/jdpostct.c")
    add_files("jpeg-9f/jdsample.c")
    add_files("jpeg-9f/jdtrans.c")
    add_files("jpeg-9f/jerror.c")
    add_files("jpeg-9f/jfdctflt.c")
    add_files("jpeg-9f/jfdctfst.c")
    add_files("jpeg-9f/jfdctint.c")
    add_files("jpeg-9f/jidctflt.c")
    add_files("jpeg-9f/jidctfst.c")
    add_files("jpeg-9f/jidctint.c")
    add_files("jpeg-9f/jmemmgr.c")
    add_files("jpeg-9f/jmemnobs.c")  -- Use "no backing store" version
    add_files("jpeg-9f/jquant1.c")
    add_files("jpeg-9f/jquant2.c")
    add_files("jpeg-9f/jutils.c")
    add_headerfiles("jpeg-9f/*.h")

-- pcre
target("pcre")
    set_kind("static")
    set_languages("c")

    add_files("pcre/*.c")
    add_headerfiles("pcre/*.h")
    -- Exclude standalone tools
    remove_files("pcre/pcregrep.c")
    add_defines("HAVE_CONFIG_H")
    add_includedirs("pcre")

-- libspeex
target("libspeex")
    set_kind("static")
    set_languages("c")

    -- Match premake5 configuration
    add_defines("HAVE_CONFIG_H")
    add_includedirs("libspeex", "libspeex/libspeex", {public = true})
    add_files("libspeex/libspeex/*.c")
    add_files("libspeex/libspeexdsp/*.c")
    -- Exclude files as per premake5
    remove_files("libspeex/libspeexdsp/kiss_fft.c", "libspeex/libspeexdsp/kiss_fftr.c", "libspeex/libspeexdsp/smallft.c", "libspeex/libspeexdsp/fftwrap.c")
    add_headerfiles("libspeex/speex/*.h")
    add_headerfiles("libspeex/libspeex/*.h")
    add_headerfiles("libspeex/libspeexdsp/*.h")
    if is_plat("windows") then
        set_warnings("none")  -- Disable warnings as per premake5
    end

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
    set_languages("cxx17")  -- Requires C++17 for std::string_view, std::optional, std::clamp

    -- Match premake5 configuration
    add_defines("PLUTOVG_BUILD", "LUNASVG_BUILD", "_CRT_SECURE_NO_WARNINGS")
    set_fpmodels("fast")
    set_runtimes("MD")
    add_includedirs("lunasvg/3rdparty/plutovg", "lunasvg/source", "lunasvg/include", {public = true})
    -- Include all files recursively like premake5 does
    add_files("lunasvg/**.cpp")
    add_files("lunasvg/**.c")
    add_headerfiles("lunasvg/**.h")
    if is_plat("windows") then
        set_warnings("none")  -- Disable warnings as per premake5
    end

-- freetype
target("freetype")
    set_kind("static")
    set_languages("c")

    add_files(
        "freetype/src/base/ftbbox.c",
        "freetype/src/base/ftbdf.c",
        "freetype/src/base/ftbitmap.c",
        "freetype/src/base/ftcid.c",
        "freetype/src/base/ftfstype.c",
        "freetype/src/base/ftgasp.c",
        "freetype/src/base/ftglyph.c",
        "freetype/src/base/ftgxval.c",
        "freetype/src/base/ftmm.c",
        "freetype/src/base/ftotval.c",
        "freetype/src/base/ftpatent.c",
        "freetype/src/base/ftpfr.c",
        "freetype/src/base/ftstroke.c",
        "freetype/src/base/ftsynth.c",
        "freetype/src/base/fttype1.c",
        "freetype/src/base/ftwinfnt.c",
        "freetype/src/autofit/autofit.c",
        "freetype/src/base/ftbase.c",
        "freetype/src/base/ftinit.c",
        "freetype/src/base/ftsystem.c",
        "freetype/src/bdf/bdf.c",
        "freetype/src/bzip2/ftbzip2.c",
        "freetype/src/cache/ftcache.c",
        "freetype/src/cff/cff.c",
        "freetype/src/cid/type1cid.c",
        "freetype/src/gxvalid/gxvalid.c",
        "freetype/src/gzip/ftgzip.c",
        "freetype/src/lzw/ftlzw.c",
        "freetype/src/otvalid/otvalid.c",
        "freetype/src/pcf/pcf.c",
        "freetype/src/pfr/pfr.c",
        "freetype/src/psaux/psaux.c",
        "freetype/src/pshinter/pshinter.c",
        "freetype/src/psnames/psmodule.c",
        "freetype/src/raster/raster.c",
        "freetype/src/sdf/sdf.c",
        "freetype/src/sfnt/sfnt.c",
        "freetype/src/smooth/smooth.c",
        "freetype/src/svg/svg.c",
        "freetype/src/truetype/truetype.c",
        "freetype/src/type1/type1.c",
        "freetype/src/type42/type42.c",
        "freetype/src/winfonts/winfnt.c",
        "freetype/builds/windows/ftdebug.c"
    )
    add_headerfiles("freetype/include/**.h")
    add_includedirs("freetype/include", "freetype/src")
    add_defines("FT2_BUILD_LIBRARY", "_UNICODE", "UNICODE", "_LIB")

-- ehs (HTTP server library)
target("ehs")
    set_kind("static")
    set_languages("cxx17")

    add_files(
        "ehs/datum.cpp",
        "ehs/ehs.cpp",
        "ehs/httprequest.cpp",
        "ehs/httpresponse.cpp",
        "ehs/socket.cpp"
    )
    add_headerfiles("ehs/*.h")

    add_includedirs(
        "../Shared/sdk",
        "pcre",
        "pme",
        "pthreads/include"
    )

    add_defines("WIN32_LEAN_AND_MEAN", "_LIB")-- glob
target("glob")
    set_kind("static")
    set_languages("cxx17")

    add_files("glob/source/*.cpp")
    add_headerfiles("glob/include/*.h")
    add_includedirs("glob/source", "glob/include")

-- pme (Perl-compatible Matching Engine)
target("pme")
    set_kind("static")
    set_languages("cxx")

    add_files("pme/pme.cpp")
    add_headerfiles("pme/pme.h")
    add_includedirs("pcre")

-- zip
target("zip")
    set_kind("static")
    set_languages("c")

    add_files("zip/*.c")
    add_headerfiles("zip/*.h")
    add_includedirs("zlib")
    add_deps("zlib")

-- pthread (Windows pthread implementation)
target("pthread")
    set_kind("shared")
    set_languages("cxx")
    set_targetdir("$(projectdir)/Bin/server")

    add_files("pthreads/include/pthread.c")
    add_headerfiles(
        "pthreads/include/config.h",
        "pthreads/include/context.h",
        "pthreads/include/implement.h",
        "pthreads/include/need_errno.h",
        "pthreads/include/pthread.h",
        "pthreads/include/sched.h",
        "pthreads/include/semaphore.h"
    )
    add_includedirs("pthreads/include")

-- CEF (Chromium Embedded Framework)
target("CEF")
    set_kind("static")
    set_languages("cxx17")  -- CEF requires C++17 for std::in_place_t and other features

    -- Match premake5 configuration
    add_defines("__STDC_CONSTANT_MACROS", "__STDC_FORMAT_MACROS", "_FILE_OFFSET_BITS=64")
    add_defines("_WINDOWS", "UNICODE", "_UNICODE", "WINVER=0x0602", "_WIN32_WINNT=0x602", "NOMINMAX", "WIN32_LEAN_AND_MEAN", "_HAS_EXCEPTIONS=0")
    add_defines("PSAPI_VERSION=1", "WRAPPING_CEF_SHARED")

    add_includedirs("cef3/cef", {public = true})
    add_files("cef3/cef/libcef_dll/**.cc")
    add_headerfiles("cef3/**.h")

    -- Add the CEF library directory and dependencies
    add_linkdirs("cef3/cef/Release", {public = true})
    add_links("libcef", "Psapi", "version", "Winmm", "Ws2_32", "DbgHelp", {public = true})

-- Lua_Client (separate lua build for client)
target("Lua_Client")
    set_kind("static")
    set_languages("c")

    add_files("lua/src/*.c")
    add_headerfiles("lua/src/*.h")
    -- Remove lua interpreter main
    remove_files("lua/src/lua.c", "lua/src/luac.c")

-- unrar
target("unrar")
    set_kind("static")
    set_languages("cxx")

    add_defines("RARDLL")

    -- Specific files from premake5.lua
    add_files(
        "unrar/archive.cpp",
        "unrar/arcread.cpp",
        "unrar/cmddata.cpp",
        "unrar/consio.cpp",
        "unrar/crc.cpp",
        "unrar/crypt.cpp",
        "unrar/dll.cpp",
        "unrar/encname.cpp",
        "unrar/errhnd.cpp",
        "unrar/extinfo.cpp",
        "unrar/extract.cpp",
        "unrar/filcreat.cpp",
        "unrar/file.cpp",
        "unrar/filefn.cpp",
        "unrar/filestr.cpp",
        "unrar/find.cpp",
        "unrar/getbits.cpp",
        "unrar/global.cpp",
        "unrar/list.cpp",
        "unrar/match.cpp",
        "unrar/options.cpp",
        "unrar/pathfn.cpp",
        "unrar/rar.cpp",
        "unrar/rarpch.cpp",
        "unrar/rarvm.cpp",
        "unrar/rawread.cpp",
        "unrar/rdwrfn.cpp",
        "unrar/recvol.cpp",
        "unrar/rijndael.cpp",
        "unrar/rs.cpp",
        "unrar/scantree.cpp",
        "unrar/secpassword.cpp",
        "unrar/sha1.cpp",
        "unrar/smallfn.cpp",
        "unrar/strfn.cpp",
        "unrar/strlist.cpp",
        "unrar/system.cpp",
        "unrar/timefn.cpp",
        "unrar/unicode.cpp",
        "unrar/unpack.cpp",
        "unrar/volume.cpp",
        "unrar/blake2s.cpp",
        "unrar/hash.cpp",
        "unrar/headers.cpp",
        "unrar/qopen.cpp",
        "unrar/rs16.cpp",
        "unrar/sha256.cpp",
        "unrar/threadpool.cpp",
        "unrar/ui.cpp"
    )

    add_headerfiles("unrar/*.hpp")

    -- Windows-specific files and settings
    if is_plat("windows") then
        add_files("unrar/isnt.cpp")
        -- Disable deprecation warnings (from premake)
        add_cxxflags("/wd4996", {force = true})
    end

-- portaudio (Windows x86 only, matching premake)
target("portaudio")
    set_kind("static")
    set_languages("cxx")

    add_files("portaudio/*.c")
    add_headerfiles("portaudio/*.h")

    -- Only build on Windows x86 (matching premake)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    else
        -- Disable deprecation warnings on Windows
        add_cxxflags("/wd4996", {force = true})
    end