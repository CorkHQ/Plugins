DXVK_DLLS = {
	"dxgi",
	"d3d9",
	"d3d10core",
	"d3d11"
}

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
	local dllOverrides = split(dllOverrideString, ";")
	
	local dxvkDllString = ""
	for _, dll in pairs(DXVK_DLLS) do
		if dxvkDllString ~= "" then
			dxvkDllString= dxvkDllString .. ","
		end
		dxvkDllString = dxvkDllString .. dll
	end

	local dxvkDisabled = GetEnvironment("DXVK_DISABLED")
	if dxvkDisabled ~= "1" then
		dllOverrides[#dllOverrides + 1] = dxvkDllString .. "=n"
		for _, dll in pairs(DXVK_DLLS) do
			os.execute("ln -sf '" .. PATH_PLUGIN .. "/bin64/" .. dll .. ".dll" .. "' '" .. VERSION_PATH .. "/" .. dll .. ".dll" .. "'")
		end
		
		Log("DXVK is enabled!", "info")
	else
		dllOverrides[#dllOverrides + 1] = dxvkDllString .. "=b"
		for _, dll in pairs(DXVK_DLLS) do
			os.execute("rm -f '" .. VERSION_PATH .. "/" .. dll .. ".dll" .. "'")
		end
		
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
end
