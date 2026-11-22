local shapes = {}

-- Box size (n x n) and the cells for rotation 1 (spawn orientation).
local base = {
	I = { n = 4, cells = { { 0, 1 }, { 1, 1 }, { 2, 1 }, { 3, 1 } } },
	O = { n = 2, cells = { { 0, 0 }, { 1, 0 }, { 0, 1 }, { 1, 1 } } },
	T = { n = 3, cells = { { 1, 0 }, { 0, 1 }, { 1, 1 }, { 2, 1 } } },
	S = { n = 3, cells = { { 1, 0 }, { 2, 0 }, { 0, 1 }, { 1, 1 } } },
	Z = { n = 3, cells = { { 0, 0 }, { 1, 0 }, { 1, 1 }, { 2, 1 } } },
	J = { n = 3, cells = { { 0, 0 }, { 0, 1 }, { 1, 1 }, { 2, 1 } } },
	L = { n = 3, cells = { { 2, 0 }, { 0, 1 }, { 1, 1 }, { 2, 1 } } },
}

-- Kinds (handy for random spawning / bags).
shapes.kinds = { "I", "O", "T", "S", "Z", "J", "L" }

-- Rotate a list of {dx, dy} cells 90 degrees clockwise inside an n x n box:
--   (dx, dy) -> (n - 1 - dy, dx)
local function rotate_cw(cells, n)
	local out = {}
	for i, c in ipairs(cells) do
		out[i] = { n - 1 - c[2], c[1] }
	end
	return out
end

-- Build shapes.data[kind][rotation] = { {dx, dy} x4 } once at load time.
shapes.data = {}
shapes.size = {}

for kind, def in pairs(base) do
	local rotations = { def.cells }
	for r = 2, 4 do
		rotations[r] = rotate_cw(rotations[r - 1], def.n)
	end
	shapes.data[kind] = rotations
	shapes.size[kind] = def.n
end

-- The four {dx, dy} offsets for a kind in a given rotation (1..4).
function shapes.cells(kind, rotation)
	return shapes.data[kind][rotation]
end

-- Rotation state helpers (1-based wrap-around).
function shapes.rotate_cw(rotation)
	return rotation % 4 + 1
end

function shapes.rotate_ccw(rotation)
	return (rotation - 2) % 4 + 1
end

return shapes
