target("ksignals")
    set_basename("ksignals")
    set_kind("headeronly")

    -- This target is Windows x86 only
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end

	-- Source files and headers
    add_includedirs(".", {public = true})

target_end()
