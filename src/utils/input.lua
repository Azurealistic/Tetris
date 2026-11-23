local input = {
	queue = {},
	count = 0,
}

function input.push(action)
	input.count = input.count + 1
	input.queue[input.count] = action
end

function input.clear()
	for i = 1, input.count do
		input.queue[i] = nil
	end
	input.count = 0
end

return input
