target("Server Launcher")
    set_kind("binary")
    set_targetdir("$(projectdir)/Bin/server")

    add_files("launcher/*.cpp")
    add_headerfiles("launcher/*.h")
    add_includedirs("../Shared/sdk", "sdk")

    if is_plat("windows") then
        add_links("User32", "Shell32", "Kernel32", "Advapi32")
        add_ldflags("/SUBSYSTEM:CONSOLE")
        if is_arch("x64") then
            set_basename("MTA Server64")
        elseif is_arch("arm") then
            set_basename("MTA Server ARM")
        elseif is_arch("arm64") then
            set_basename("MTA Server ARM64")
        else
            set_basename("MTA Server")
        end
    else
        add_links("dl")
        add_cxflags("-pthread", "-fvisibility=default")
        add_ldflags("-pthread", "-rdynamic")
        if is_arch("arm") then
            set_basename("mta-server-arm")
        elseif is_arch("arm64") then
            set_basename("mta-server-arm64")
        elseif is_arch("x64") then
            set_basename("mta-server64")
        end
    end


target_end()
