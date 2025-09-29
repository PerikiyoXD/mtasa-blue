target("Shared SDK Crypto")
    set_kind("static")
    set_basename("sharedcryptosdk")

    add_files("**.cpp")
    add_includedirs(".", {public = true})

    add_deps("tinyxml", "Shared SDK")
    add_packages("cryptopp")
target_end()
