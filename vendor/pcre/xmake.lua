target("pcre")
    set_basename("pcre3")
    set_kind("static")

 	add_defines("HAVE_CONFIG_H")

	add_files("*.c", "*.cc")
	add_includedirs(".", {public = true})

    on_config(function (target)
        local arch = target:arch()
        local valid_archs = {"x86", "x64", "arm", "arm64"}
        if not table.contains(valid_archs, arch) then
            assert(false, "Unsupported architecture: " .. arch)
        end
        local outpath = "$(projectdir)/Bin/server/" .. arch
        print("Setting targetdir for architecture: \"" .. outpath .. "\"")
        target:targetdir(outpath)
    end)

	if is_plat("windows") then
    	set_kind("shared")
		add_ldflags("/ignore:4217", "/ignore:4049", "/ignore:4251") --Ignore 4217 (non-DLL interface), 4049 (locally defined symbol) and 4251 (DLL-interface)
	else
		set_kind("static")
		add_defines("HAVE_STRTOLL")
	end
target_end()