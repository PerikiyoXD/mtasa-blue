-- =============================================================================
-- External Package Requirements
-- =============================================================================

add_requires("cryptopp", {configs = {shared = false}})
add_requires("zlib-ng", {alias = "zlib", configs = {zlib_compat = true, shared = false}})
add_requires("libpng", {configs = {shared = false}})
add_requires("libjpeg v9f", {configs = {shared = false}})
add_requires("minizip-ng", {alias = "zip", configs = {shared = false}})
add_requires("freetype", {configs = {shared = false}})

-- Windows-only requirements
if is_client() then
    add_requires("pthreads4w", {alias = "pthreads", configs = {shared = true}})
    add_requires("microsoft-detours", {alias = "detours", configs = {shared = false}})
end

-- =============================================================================
-- Targets
-- =============================================================================

includes("sparsehash")
includes("bcrypt")
includes("tinygettext")
includes("tinyxml")
includes("pcre")
includes("pthreads")
includes("json-c")
includes("sqlite")
includes("google-breakpad")

-- Client Targets
if is_client() then
    includes("dxsdk")
    includes("ksignals")
    includes("cef3")
    includes("cegui-0.4.0-custom")
end




-- DirectX9GUIRenderer




-- pcre-static (renamed to avoid conflict with pcre shared library)
target("pcre-static")
    set_kind("static")
    set_languages("c")

    add_files("pcre/*.c")
    add_headerfiles("pcre/*.h")
    -- Exclude standalone tools
    remove_files("pcre/pcregrep.c")
    add_defines("HAVE_CONFIG_H")
    add_includedirs("pcre")
target_end()

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
target_end()

-- ehs (HTTP server library)
target("ehs")
    set_kind("static")
    set_languages("cxx23")

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
target_end()

target("glob")
    set_kind("static")
    set_languages("cxx23")

    add_files("glob/source/*.cpp")
    add_headerfiles("glob/include/*.h")
    add_includedirs("glob/source", "glob/include")
target_end()

-- pme (Perl-compatible Matching Engine)
target("pme")
    set_kind("static")
    set_languages("cxx")

    add_files("pme/pme.cpp")
    add_headerfiles("pme/pme.h")
    add_includedirs("pcre")
target_end()

-- Lua_Client (separate lua build for client)
target("Lua_Client")
    set_kind("static")
    set_languages("c")

    add_files("lua/src/*.c")
    add_headerfiles("lua/src/*.h")
    -- Remove lua interpreter main
    remove_files("lua/src/lua.c", "lua/src/luac.c")

    -- Add API check defines for debug builds
    add_defines("LUA_USE_APICHECK")
target_end()

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
target_end()

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
target_end()

-- lunasvg
target("lunasvg")
    set_kind("static")
    set_languages("cxx23")  -- lunasvg requires C++17 for std::clamp, std::string_view, etc.
    set_runtimes("MT")  -- Use static runtime to match main project

    add_defines("PLUTOVG_BUILD", "LUNASVG_BUILD", "_CRT_SECURE_NO_WARNINGS")
    add_includedirs("lunasvg/3rdparty/plutovg", "lunasvg/source", "lunasvg/include")
    add_files("lunasvg/source/*.cpp", "lunasvg/3rdparty/plutovg/*.c")
    add_headerfiles("lunasvg/include/**/*.h", "lunasvg/source/*.h", "lunasvg/3rdparty/**/*.h")

    -- Disable specific warnings (matching premake)
    if is_plat("windows") then
        add_cxxflags("/wd4244", "/wd4018", {force = true})
    end

    -- Windows x86 only (matching premake)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end
target_end()

-- detours
target("detours")
    set_kind("static")
    set_languages("cxx")

    add_defines("WIN32_LEAN_AND_MEAN")
    add_includedirs("detours/4.0.1/src")

    add_files(
        "detours/4.0.1/src/creatwth.cpp",
        "detours/4.0.1/src/detours.cpp",
        "detours/4.0.1/src/image.cpp",
        "detours/4.0.1/src/modules.cpp",
        "detours/4.0.1/src/disolx86.cpp",
        "detours/4.0.1/src/disolx64.cpp",
        "detours/4.0.1/src/disasm.cpp"
    )

    add_headerfiles("detours/4.0.1/src/detours.h", "detours/4.0.1/src/detver.h")

    -- Windows x86 only (matching premake)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end
target_end()