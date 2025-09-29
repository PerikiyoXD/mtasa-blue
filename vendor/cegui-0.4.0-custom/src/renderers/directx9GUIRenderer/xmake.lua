target("DirectX9GUIRenderer")
    set_kind("static")

    add_defines("_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING")
    add_includedirs("../../../include")
    add_files("d3d9renderer.cpp", "d3d9texture.cpp")
    add_deps("CEGUI", "dxsdk")

    -- Windows x86 only (from premake)
    if not is_plat("windows") or not is_arch("x86") then
        set_enabled(false)
    end
