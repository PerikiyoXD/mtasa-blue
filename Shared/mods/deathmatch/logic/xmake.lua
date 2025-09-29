target("SharedModDeathmatchLogic")
    set_kind("static")
    set_basename("shared_deathmatch_logic")

    add_files("**.cpp")
    add_includedirs(".", {public = true})

    add_deps("Shared SDK Core")
    add_packages("cryptopp")
target_end()
