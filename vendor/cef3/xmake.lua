target("CEF")
    set_basename("CEF")
    set_kind("static")
    set_targetdir("$(projectdir)/Bin/mta")

    -- This target is Windows x86 only
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

    set_languages("cxx23")

	-- Source files and headers
    add_files("cef/libcef_dll/**.cc")
    add_includedirs("cef", {public = true})
    remove_files("cef/libcef_dll/*/test/**.cc")

    -- Defines
    add_defines("__STDC_CONSTANT_MACROS",
                "__STDC_FORMAT_MACROS",
                "_FILE_OFFSET_BITS=64",
                "_WINDOWS",
                "UNICODE",
                "_UNICODE",
                "WINVER=0x0602",
                "_WIN32_WINNT=0x602",
                "NOMINMAX",
                "WIN32_LEAN_AND_MEAN",
                "_HAS_EXCEPTIONS=0",
                "PSAPI_VERSION=1",
                "WRAPPING_CEF_SHARED")

	-- Dependencies and links
    add_links("Psapi", "version", "Winmm", "Ws2_32", "DbgHelp", "User32", "Shell32")

    -- Expose libcef.lib to dependents
    add_linkdirs("cef/Release", {public = true})

    after_build(function (target)
        local path     = "$(projectdir)/Bin/mta/"
        local cef_path = "$(scriptdir)/cef/"

        os.cp(cef_path .. "Release/**/*", path, {excludes = {"d3dcompiler_47.dll", "*.lib"}})
        os.cp(cef_path .. "Resources/icudtl.dat", path)
        os.cp(cef_path .. "Resources/*.pak", path)
        os.cp(cef_path .. "Resources/locales/*", path .. "cef/locales")
    end)

target_end()
