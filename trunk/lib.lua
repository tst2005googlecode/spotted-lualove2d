--Gets the content of a variable
--Taken somewhere else
function print_r (t, indent) 
	local indent=indent or ''
	for key,value in pairs(t) do
		io.write(indent,'[',tostring(key),']') 
		if type(value)=="table" then io.write(':\n') print_r(value,indent..'\t')
		else io.write(' = ',tostring(value),'\n') end
	end
end

--Gets a string printed with the value taken
--Taken on Mari0
function properprint(s, x, y)
	local startx = x
	for i = 1, string.len(tostring(s)) do
		local char = string.sub(s, i, i)
		if char == "|" then
			x = startx-((i)*8)*scale
			y = y + 10*scale
		elseif fontquads[char] then
			love.graphics.drawq(fontimage, fontquads[char], x + ((i - 1) * 8) * scale, y, 0, scale, scale)
		end
	end
end

function basic_properprint(s)
	properprint(s, 25 * 8 * scale - string.len(s) * 4 * scale, 108 * scale)
end