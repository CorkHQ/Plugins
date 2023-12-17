-- https://stackoverflow.com/a/7615129
function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function PluginExecute()
	local dllOverrideString = GetEnvironment("WINEDLLOVERRIDES")
	local dllPathString = GetEnvironment("WINEDLLPATH")
	
	local dllOverrides = split(dllOverrideString, ";")
	local dllPath = split(dllPathString, ":")
	
	local dxvkDisabled = GetEnvironment("DXVK_DISABLED")
	if dxvkDisabled ~= "1" then
		dllOverrides[#dllOverrides + 1] = "dxgi,d3d9,d3d10core,d3d11=n"
		dllPath[#dllPath + 1] = PATH_PLUGIN .. "/bin32"
		dllPath[#dllPath + 1] = PATH_PLUGIN .. "/bin64"
		
		Log("DXVK is enabled!", "info")
	else
		dllOverrides[#dllOverrides + 1] = "dxgi,d3d9,d3d10core,d3d11=b"
		
		Log("DXVK is disabled!", "info")
	end
	
	local newDllOverrideString = ""
	for _, element in pairs(dllOverrides) do
		if newDllOverrideString ~= "" then
			newDllOverrideString = newDllOverrideString .. ";"
		end
		newDllOverrideString = newDllOverrideString .. element
	end
	SetEnvironment("WINEDLLOVERRIDES", newDllOverrideString)
	
	local newDllPathString = ""
	for _, element in pairs(dllPath) do
		if newDllPathString ~= "" then
			newDllPathString = newDllPathString .. ":"
		end
		newDllPathString = newDllPathString .. element
	end
	SetEnvironment("WINEDLLPATH", newDllPathString)
end
