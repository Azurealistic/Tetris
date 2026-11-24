local shapes = require("src.utils.shapes")

local outline = {}

local cache = {}

function outline.edges(kind, rot)
	cache[kind] = cache[kind] or {}
	local edges = cache[kind][rot]
	if edges then
		return edges
	end

	local cells = shapes.cells(kind, rot)
	local has = {}
	for _, c in ipairs(cells) do
		has[c[1] .. "," .. c[2]] = true
	end

	edges = {}
	for _, c in ipairs(cells) do
		local x, y = c[1], c[2]
		if not has[x .. "," .. (y - 1)] then
			edges[#edges + 1] = { x, y, x + 1, y }
		end -- top
		if not has[x .. "," .. (y + 1)] then
			edges[#edges + 1] = { x, y + 1, x + 1, y + 1 }
		end -- bottom
		if not has[(x - 1) .. "," .. y] then
			edges[#edges + 1] = { x, y, x, y + 1 }
		end -- left
		if not has[(x + 1) .. "," .. y] then
			edges[#edges + 1] = { x + 1, y, x + 1, y + 1 }
		end -- right
	end

	cache[kind][rot] = edges
	return edges
end

return outline
