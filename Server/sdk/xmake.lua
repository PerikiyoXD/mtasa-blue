-- Workaround for `kind "None"` only being supported for Visual Studio.
if _ACTION == "gmake" then
	return
end

target("Server SDK")
	set_kind("phony")
	set_basename("sdk")
	add_includedirs(".", { public = true })
target_end()
