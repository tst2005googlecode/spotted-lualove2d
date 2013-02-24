local MIN_INDEX_STEP = 1
local UPDATE_ANIM_INTERVAL = 0.15
local UPDATE_MOVE_INTERVAL = 0.05
local UPDATE_ANIM_INTERVAL_RUNNING = 0.10
local UPDATE_MOVE_INTERVAL_RUNNING = 0.01

local lastKeyPressed = ''
local isLastKeyPressed = false
local numIndexStep
local quadCurrent
local numTotalTime = 0
local numLastAnimUpdate = 0
local numLastMoveUpdate = 0
local isRunning = false

local imgSprite
local quadDown = {}
local quadUp = {}
local quadLeft = {}
local quadRight = {}


function spritehero_load()
	imgSprite = love.graphics.newImage("img/spriteman.png")
	for i = MIN_INDEX_STEP, 4 do
		quadDown[i] = love.graphics.newQuad((i-1)*32, 0, 32, 32, 128, 128)
		quadUp[i] = love.graphics.newQuad((i-1)*32, 32, 32, 32, 128, 128)
		quadLeft[i] = love.graphics.newQuad((i-1)*32, 64, 32, 32, 128, 128)
		quadRight[i] = love.graphics.newQuad((i-1)*32, 96, 32, 32, 128, 128)
	end
	
	numIndexStep = MIN_INDEX_STEP
	quadCurrent = quadDown
	
	spritehero_pos = {x = 100, y = 100, w = 32, h = 32}
end

function spritehero_draw()
	love.graphics.drawq(imgSprite, quadCurrent[numIndexStep], spritehero_pos["x"], spritehero_pos["y"])
end

function spritehero_update(dt)
	numTotalTime = numTotalTime + dt
	numUpdateAnimInterval = UPDATE_ANIM_INTERVAL
	numUpdateMoveInterval = UPDATE_MOVE_INTERVAL
	if isRunning then 
		numUpdateAnimInterval = UPDATE_ANIM_INTERVAL_RUNNING
		numUpdateMoveInterval = UPDATE_MOVE_INTERVAL_RUNNING
	end
	
	if (numTotalTime - numLastAnimUpdate) > numUpdateAnimInterval then
		numLastAnimUpdate = numTotalTime
		
		if isLastKeyPressed then numIndexStep = numIndexStep + 1 end
		if numIndexStep > 4 then numIndexStep = MIN_INDEX_STEP end
		
		if lastKeyPressed == "up" then 
			quadCurrent = quadUp
		elseif lastKeyPressed == "left" then 
			quadCurrent = quadLeft
		elseif lastKeyPressed == "right" then 
			quadCurrent = quadRight
		else 
			quadCurrent = quadDown
		end
	end
	
	if (numTotalTime - numLastMoveUpdate) > numUpdateMoveInterval then
		numLastMoveUpdate = numTotalTime
		if isLastKeyPressed then
			if lastKeyPressed == "up" then 
				spritehero_pos["y"] = spritehero_pos["y"] - 1
			elseif lastKeyPressed == "left" then
				spritehero_pos["x"] = spritehero_pos["x"] - 1
			elseif lastKeyPressed == "right" then 
				spritehero_pos["x"] = spritehero_pos["x"] + 1
			elseif lastKeyPressed == "down" then 
				spritehero_pos["y"] = spritehero_pos["y"] + 1 
			end
		end
	end
end

function spritehero_keypressed(key, unicode)
	if key == "up" or key == "down" or key == "left" or key == "right" then
		lastKeyPressed = key
		isLastKeyPressed = true
	end
	if key == "kp1" then
		isRunning = true
	end
end

function spritehero_keyreleased(key, unicode)
	if key == lastKeyPressed then
		isLastKeyPressed = false
		numIndexStep = MIN_INDEX_STEP
	end
	
	if key == "kp1" then
		isRunning = false
	end
end