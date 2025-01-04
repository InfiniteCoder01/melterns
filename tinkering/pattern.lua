tinkering.patterns = {}

-- Register a new pattern
function tinkering.register_pattern(name, data)
	local mod    = data.mod_name or minetest.get_current_modname()
	local desc   = data.description

	tinkering.patterns[name] = data

	local itemname = mod..":"..name.."_pattern"
	core.register_craftitem(itemname, {
		description     = desc.." Pattern\n\nMaterial Cost: "..data.cost,
		inventory_image = "tinkering_"..name.."_pattern.png",
		groups          = {tinker_pattern=1, ["tc_"..name.."_pattern"] = 1}
	})

	if i3 and i3.register_craft then
		i3.register_craft {
			type   = "tinkering:pattern_creating",
			result = itemname,
			items  = {"tinkering:blank_pattern"},
		}
	end
end

-- Create blank pattern
minetest.register_craftitem("tinkering:blank_pattern", {
	description     = "Blank Pattern",
	inventory_image = "tinkering_blank_pattern.png",
	groups          = {tinker_pattern=1}
})
