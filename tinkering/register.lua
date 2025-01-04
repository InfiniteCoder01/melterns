
-- Register components and base tools
local start_load = os.clock()
local num_components = 0
local num_tools = 0

if i3 and i3.register_craft_type then
	i3.register_craft_type("tinkering:pattern_creating", {
		description = "Making pattern in the Pattern Table",
		icon = "tinkering_sword_blade_pattern.png",
	})

	i3.register_craft_type("tinkering:part_building", {
		description = "Part Building",
		icon = "tinkering_tool_binding_pattern.png",
	})
end

-- Create base tools
for m, s in pairs(tinkering.materials) do
	tinkering.register_material_tool(m)
	num_tools = num_tools + 1
end

-- Register tool components
for i, v in pairs(tinkering.components) do
	tinkering.register_component(i, v)
	num_components = num_components + 1
end

print(("[tinkering] Added %d components and %d base tools in %f seconds."):format(num_components, num_tools, os.clock() - start_load))
