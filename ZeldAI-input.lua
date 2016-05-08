require("math")

function createinputs()
	local inputs = {}
	
	for l = 1,2 do
		local layer = {}
		for x = -boxradius,boxradus do
			layer[x] = {}
			for y = -boxradius,boxradus do
				local num = math.random()
				if num>.1 then
					layer[x][y] = 1
				else
					layer[x][y] =-1
				end
			end
		end
		inputs[l] = layer
	end

	return inputs
end