target("dxsdk")
    set_kind("phony") -- or "static", "headeronly", etc. depending on what you want

    on_config(function (target)
        -- Attempt to locate the DirectX SDK
        local dxdir = os.getenv("DXSDK_DIR") or "C:\\Program Files (x86)\\Microsoft DirectX SDK (June 2010)"
        if os.isdir(dxdir) then
            target:add("includedirs", {path.join(dxdir, "Include")}, {public = true})
            if is_arch("x86") then
                target:add("linkdirs", path.join(dxdir, "Lib/x86"), {public = true})
            elseif is_arch("x64") then
                target:add("linkdirs", path.join(dxdir, "Lib/x64"), {public = true})
            end
            print("Using DirectX SDK at: " .. dxdir)
        else
            print("Warning: DirectX SDK not found at " .. dxdir)
            print("Please set DXSDK_DIR environment variable or install DirectX SDK June 2010")
        end
    end)
target_end()