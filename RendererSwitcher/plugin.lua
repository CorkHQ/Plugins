validRenderers = {
	["OpenGL"] = true,
	["Vulkan"] = true,
	["D3D11FL10"] = true,
	["D3D11"] = true
}

function PluginExecute()
	local rendererOverride = GetEnvironment("FORCE_RENDERER")
	if rendererOverride ~= "" and validRenderers[rendererOverride] == true then
		Log("Overriding renderer to " .. rendererOverride .. "!", "info")
		for renderer,_ in pairs(validRenderers) do
			if renderer == rendererOverride then
				SetFFlag("FFlagDebugGraphicsPrefer" .. renderer, "true")
				SetFFlag("FFlagDebugGraphicsDisable" .. renderer, "false")
			else
				SetFFlag("FFlagDebugGraphicsPrefer" .. renderer, "false")
				SetFFlag("FFlagDebugGraphicsDisable" .. renderer, "true")
			end
		end
	end
end
