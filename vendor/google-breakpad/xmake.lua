target("breakpad")
	set_kind("static")
	set_basename("breakpad")

	add_files("src/client/*.cc",
		"src/common/*.cc",
		"src/common/*.c",
		"src/processor/*.cc",
		"src/third_party/glog/src/*.cc",
		"src/third_party/libdisasm/*.c",
		"src/third_party/protobuf/protobuf/src/**.c")

	add_includedirs("src", "src/third_party/glog/src", {public = true})

	if is_plat("windows") then
		set_enabled(false)
	end

	if is_plat("linux") then
		add_files("src/client/linux/**.cc",
			"src/common/linux/**.cc",
			"src/common/dwarf/**.cc")
	elseif is_plat("macosx") then
		add_files("src/client/mac/**.cc",
			"src/client/mac/**.mm",
			"src/common/mac/**.mm",
			"src/common/mac/**.cc")

		add_includedirs("src/client/apple/Framework", "src/common/mac", {public = true})
	end

	remove_files("src/client/linux/sender/google_crash_report_sender.cc")
	remove_files("src/common/linux/tests/**.cc")
	remove_files("src/client/mac/tests/**")
	remove_files("src/client/mac/handler/testcases/**")
	remove_files("src/common/stabs_reader.cc")
target_end()