target("CEF Launcher")
	if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
	else
		set_kind("binary")
		set_basename("CEFLauncher")
		set_targetdir("$(projectdir)/Bin/mta/cef")
		add_files("Main.cpp", "CEFLauncher.manifest")
		add_deps("Client SDK")
    end
target_end()
