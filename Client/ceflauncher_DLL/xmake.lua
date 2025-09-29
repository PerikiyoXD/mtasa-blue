target("CEF Launcher DLL")
	set_kind("binary")
	set_basename("CEFLauncher_DLL")

	set_targetdir("$(projectdir)/Bin/mta/cef")

	add_files("Main.cpp")
    add_includedirs(".")

    add_defines("UNICODE", "PSAPI_VERSION=1")
	add_deps("Client SDK", "CEF")
    add_links("delayimp", "Psapi", "version", "Winmm", "Ws2_32", "DbgHelp")
	add_ldflags("/DELAYLOAD:libcef.dll")
target_end()
