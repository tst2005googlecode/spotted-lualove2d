local MIN_INDEX_STEP = 1
local UPDATE_ANIM_INTERVAL = 0.15
local UPDATE_MOVE_INTERVAL = 0.05
local UPDATE_ANIM_INTERVAL_RUNNING = 0.10
local UPDATE_MOVE_INTERVAL_RUNNING = 0.01
local VISION_CIRCLE_RADIUS = 70
local AUDITION_CIRCLE_RADIUS = 80
local INIT_ENNEMY_POS_X = 150
local INIT_ENNEMY_POS_Y = 150
local SPRITE_ENNEMY_W = 48
local SPRITE_ENNEMY_H = 48
local TOTAL_SPRITE_CANVAS_W = 192
local TOTAL_SPRITE_CANVAS_H = 192

local strLastKeyPressed = ''
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

	
function spriteennemy_load()
	imgSprite = love.graphics.newImage("img/spriteennemy.png")
	for i = MIN_INDEX_STEP, 4 do
		quadDown[i] = love.graphics.newQuad(0, (i-1)*SPRITE_ENNEMY_H, SPRITE_ENNEMY_W, SPRITE_ENNEMY_H, TOTAL_SPRITE_CANVAS_W, TOTAL_SPRITE_CANVAS_H)
		quadLeft[i] = love.graphics.newQuad(SPRITE_ENNEMY_W, (i-1)*SPRITE_ENNEMY_H, SPRITE_ENNEMY_W, SPRITE_ENNEMY_H, TOTAL_SPRITE_CANVAS_W, TOTAL_SPRITE_CANVAS_H)
		quadUp[i] = love.graphics.newQuad(SPRITE_ENNEMY_W * 2, (i-1)*SPRITE_ENNEMY_H, SPRITE_ENNEMY_W, SPRITE_ENNEMY_H, TOTAL_SPRITE_CANVAS_W, TOTAL_SPRITE_CANVAS_H)
		quadRight[i] = love.graphics.newQuad(SPRITE_ENNEMY_W * 3, (i-1)*SPRITE_ENNEMY_H, SPRITE_ENNEMY_W, SPRITE_ENNEMY_H, TOTAL_SPRITE_CANVAS_W, TOTAL_SPRITE_CANVAS_H)
	end
	
	numIndexStep = MIN_INDEX_STEP
	quadCurrent = quadDown
	
	spriteennemy_pos = { x = INIT_ENNEMY_POS_X, y = INIT_ENNEMY_POS_Y, w = SPRITE_ENNEMY_W, h = SPRITE_ENNEMY_H }
end

function spriteennemy_draw()
	local oldColorR, oldColorG, oldColorB, oldColorA = love.graphics.getColor()
	
	love.graphics.drawq(imgSprite, quadCurrent[numIndexStep], spriteennemy_pos["x"], spriteennemy_pos["y"])
	--dessiner le cercle de vision
	if (table.getn(spriteennemyvision_polygon) > 0) then
		love.graphics.setColor(255, 255, 0, 40)
		love.graphics.polygon("fill", spriteennemyvision_polygon)
	end
	--dessiner le cercle d'audition
	if (spriteennemyaudition_pos["x"] ~= nil) then
		love.graphics.setColor(255, 128, 0, 40)
		love.graphics.circle("fill", spriteennemyaudition_pos["x"], spriteennemyaudition_pos["y"], AUDITION_CIRCLE_RADIUS)
	end
	
	love.graphics.setColor(oldColorR, oldColorG, oldColorB, oldColorA)
end

function spriteennemy_update(dt)
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
		
		if strLastKeyPressed == "w" then 
			quadCurrent = quadUp
		elseif strLastKeyPressed == "a" then 
			quadCurrent = quadLeft
		elseif strLastKeyPressed == "d" then 
			quadCurrent = quadRight
		else 
			quadCurrent = quadDown
		end
	end
	
	if (numTotalTime - numLastMoveUpdate) > numUpdateMoveInterval then
		numLastMoveUpdate = numTotalTime
		if isLastKeyPressed then
			if strLastKeyPressed == "w" then 
				spriteennemy_pos["y"] = spriteennemy_pos["y"] - 1
				spriteennemyvision_polygon = {spriteennemy_pos["x"], spriteennemy_pos["y"],
												spriteennemy_pos["x"] + spriteennemy_pos["w"], spriteennemy_pos["y"], 
												spriteennemy_pos["x"] + spriteennemy_pos["w"] + 15, spriteennemy_pos["y"] - VISION_CIRCLE_RADIUS, 
												spriteennemy_pos["x"] - 15, spriteennemy_pos["y"] - VISION_CIRCLE_RADIUS}
			elseif strLastKeyPressed == "a" then
				spriteennemy_pos["x"] = spriteennemy_pos["x"] - 1
				spriteennemyvision_polygon = {spriteennemy_pos["x"], spriteennemy_pos["y"],
												spriteennemy_pos["x"] - VISION_CIRCLE_RADIUS, spriteennemy_pos["y"] - 15, 
												spriteennemy_pos["x"] - VISION_CIRCLE_RADIUS, spriteennemy_pos["y"] + spriteennemy_pos["h"] + 15, 
												spriteennemy_pos["x"], spriteennemy_pos["y"] + spriteennemy_pos["h"]}
			elseif strLastKeyPressed == "d" then 
				spriteennemy_pos["x"] = spriteennemy_pos["x"] + 1
				spriteennemyvision_polygon = {spriteennemy_pos["x"] + spriteennemy_pos["w"], spriteennemy_pos["y"],
												spriteennemy_pos["x"] + spriteennemy_pos["w"] + VISION_CIRCLE_RADIUS, spriteennemy_pos["y"] - 15, 
												spriteennemy_pos["x"] + spriteennemy_pos["w"] + VISION_CIRCLE_RADIUS, spriteennemy_pos["y"] + spriteennemy_pos["h"] + 15, 
												spriteennemy_pos["x"] + spriteennemy_pos["w"], spriteennemy_pos["y"] + spriteennemy_pos["h"]}
			elseif strLastKeyPressed == "s" then 
				spriteennemy_pos["y"] = spriteennemy_pos["y"] + 1 
				spriteennemyvision_polygon = {spriteennemy_pos["x"], spriteennemy_pos["y"] + spriteennemy_pos["h"],
												spriteennemy_pos["x"] + spriteennemy_pos["w"], spriteennemy_pos["y"] + spriteennemy_pos["h"], 
												spriteennemy_pos["x"] + spriteennemy_pos["w"] + 15, spriteennemy_pos["y"] + spriteennemy_pos["h"] + VISION_CIRCLE_RADIUS, 
												spriteennemy_pos["x"] - 15, spriteennemy_pos["y"] + spriteennemy_pos["h"] + VISION_CIRCLE_RADIUS}
			end
			spriteennemyaudition_pos["x"] = spriteennemy_pos["x"] + AUDITION_CIRCLE_RADIUS / 4
			spriteennemyaudition_pos["y"] = spriteennemy_pos["y"] + AUDITION_CIRCLE_RADIUS / 4
		end
	end
end

function spriteennemy_keypressed(key, unicode)
	if key == "w" or key == "s" or key == "a" or key == "d" then
		strLastKeyPressed = key
		isLastKeyPressed = true
	end
	if key == "r" then
		isRunning = true
	end
end

function spriteennemy_keyreleased(key, unicode)
	if key == strLastKeyPressed then
		isLastKeyPressed = false
		numIndexStep = MIN_INDEX_STEP
	end
	
	if key == "r" then
		isRunning = false
	end
end