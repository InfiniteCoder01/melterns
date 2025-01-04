-- Metal Melter for Minetest 5.0.0+
-- Copyright (c) 2019 Evert "Diamond" Prants <evert@lunasqu.ee>

local modpath = minetest.get_modpath("metal_melter")
metal_melter = {}

-- Crafting components
dofile(modpath.."/components.lua")

-- Fluid bar for formspec
function metal_melter.fluid_bar(x, y, fluid_buffer)
	local texture = "default_water.png"
	local metric  = 0

	if fluid_buffer and fluid_buffer.fluid and fluid_buffer.fluid ~= "" and
		minetest.registered_nodes[fluid_buffer.fluid] ~= nil then
		texture = minetest.registered_nodes[fluid_buffer.fluid].tiles[1]
		if type(texture) == "table" then
			texture = texture.name
		end
		metric  = math.floor(100 * fluid_buffer.amount / fluid_buffer.capacity)
	end

	return "image["..x..","..y..";1,2.8;melter_gui_barbg.png"..
		   "\\^[lowpart\\:"..metric.."\\:"..texture.."\\\\^[resize\\\\:64x128]"..
		   "image["..x..","..y..";1,2.8;melter_gui_gauge.png]"
end

-- Melter
dofile(modpath.."/melter.lua")

-- Caster
dofile(modpath.."/caster.lua")

core.register_on_mods_loaded(function()
	if i3 and i3.register_craft_type then
		i3.register_craft_type("metal_melter:casting", {
			description = "Casting using Metal Caster",
			icon = "caster_front.png",
		})

		if i3.register_craft then
			-- Recipies for casts
			for name, cast in pairs(metal_caster.casts) do
				for metal, types in pairs(fluidity.melts) do
					if types[name] then
						for _, item in ipairs(types[name]) do
							i3.register_craft {
								type   = "metal_melter:casting",
								result = (cast.mod_name or "metal_melter")..":"..name.."_cast",
								items  = {item},
							}
						end
					end
				end
			end
			i3.register_craft {
				type   = "metal_melter:casting",
				result ="metal_melter:ingot_cast",
				items  = {"default:clay_brick"},
			}
			i3.register_craft {
				type   = "metal_melter:casting",
				result ="metal_melter:ingot_cast",
				items  = {"metal_melter:heated_brick"},
			}

			-- Recipies for items out of casts
			for metal, types in pairs(fluidity.melts) do
				if fluidity.molten_metals[metal] then
					for	type, items in pairs(types) do
						if items[1] and items[1] ~= "" and metal_caster.casts[type] then
							i3.register_craft {
								type   = "metal_melter:casting",
								result = items[1],
								items  = {fluidity.molten_metals[metal], (metal_caster.casts[type].mod_name or "metal_melter")..":"..type.."_cast"},
							}
						end
					end
				end
			end
		end
	end
end)
