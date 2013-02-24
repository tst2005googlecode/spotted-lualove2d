local imgdataWall
local numImgSize = 32
local tabRows = {}
local numCols
local numRows

function wall_load()
	imgdataWall = love.image.newImageData("img/wall.png")
	
	currentconfig_wall = wall1_get()
	spritewall_pos = {} 
	
	numCols = math.ceil(love.graphics.getWidth() / numImgSize)
	numRows = math.ceil(love.graphics.getHeight() / numImgSize)
	for i = 1, numRows do
		tabRows[i] = {}
		for j = 1, numCols do
			if currentconfig_wall[i][j] == 1 then
				tabRows[i][j] = love.graphics.newImage(imgdataWall)
				
				local tabPos = {x = (j-1) * numImgSize, y = (i-1) * numImgSize, w = numImgSize, h = numImgSize}
				table.insert(spritewall_pos, tabPos)
			end
		end
	end
end

function wall_draw()
	for i = 1, numRows do
		for j = 1, numCols do
			if currentconfig_wall[i][j] == 1 then
				love.graphics.draw(tabRows[i][j], (j-1) * numImgSize, (i-1) * numImgSize)
			end
		end
	end
end