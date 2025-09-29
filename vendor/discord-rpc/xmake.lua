target("discord-rpc")
    set_kind("static")
    set_languages("cxx")

    add_includedirs("discord/include", "discord/thirdparty/rapidjson/include")
    add_defines("DISCORD_DISABLE_IO_THREAD")

    add_files(
        "discord/src/discord_rpc.cpp",
        "discord/src/rpc_connection.cpp",
        "discord/src/serialization.cpp",
        "discord/src/connection_win.cpp",
        "discord/src/discord_register_win.cpp"
    )
target_end()