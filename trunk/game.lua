spritehero_pos = {}
spriteennemy_pos = {}
spriteennemyvision_pos = {}
spriteennemyvision_polygon = {}
spriteennemyaudition_pos = {}
spritewall_pos = {}
--pos en nombre de mur : 25*19 soit 23*17

local numTotalTime = 0

function game_load()
	gamestate = "game"
end

function game_draw()
	if numTotalTime < 1 then 
		strPrint = "the game has started!"
		basic_properprint(strPrint)
	end
	
	wall_draw()
	spritehero_draw()
	spriteennemy_draw()
end

function game_update(dt)
	numTotalTime = numTotalTime + dt
	
	spritehero_update(dt)
	spriteennemy_update(dt)
	
	--repositionne l'ennemie pour ne pas contrer les murs
	local numWalls = table.getn(spritewall_pos)
	for i = 1, numWalls do
		game_hitTest(spriteennemy_pos, spritewall_pos[i])
	end
	
	--repositionne le joueur pour ne pas contrer l'ennemi
	game_hitTest(spritehero_pos, spriteennemy_pos)
	--repositionne le joueur pour ne pas contrer les murs
	local numWalls = table.getn(spritewall_pos)
	for i = 1, numWalls do
		game_hitTest(spritehero_pos, spritewall_pos[i])
	end
	
	--DEBUG haut gauche
	--game_hitTest(spritehero_pos, spritewall_pos[1])
	--game_hitTest(spritehero_pos, spritewall_pos[2])
	--game_hitTest(spritehero_pos, spritewall_pos[26])
end

function game_hitTest(spritehero_pos, spritetest_pos)
	testWidth = false
	testHeight = false
	if ((spritehero_pos["x"] > spritetest_pos["x"]) and (spritehero_pos["x"] <= spritetest_pos["x"] + spritetest_pos["w"])) or ((spritehero_pos["x"] < spritetest_pos["x"]) and (spritehero_pos["x"] + spritehero_pos["w"] >= spritetest_pos["x"])) then
		testWidth = true
	end
	if ((spritehero_pos["y"] > spritetest_pos["y"]) and (spritehero_pos["y"] <= spritetest_pos["y"] + spritetest_pos["h"])) or ((spritehero_pos["y"] < spritetest_pos["y"]) and (spritehero_pos["y"] + spritetest_pos["h"] >= spritetest_pos["y"])) then
		testHeight = true
	end
	
	if testWidth and testHeight then
		if (spritehero_pos["x"] > spritetest_pos["x"]) and (spritehero_pos["x"] == spritetest_pos["x"] + spritetest_pos["w"]) then 
			spritehero_pos["x"] = spritetest_pos["x"] + spritetest_pos["w"] + 1 
		end
		if (spritehero_pos["y"] > spritetest_pos["y"]) and (spritehero_pos["y"] == spritetest_pos["y"] + spritetest_pos["h"]) then
			spritehero_pos["y"] = spritetest_pos["y"] + spritetest_pos["h"] + 1
		end
		if (spritehero_pos["x"] < spritetest_pos["x"]) and (spritehero_pos["x"] + spritehero_pos["w"] == spritetest_pos["x"]) then
			spritehero_pos["x"] = spritetest_pos["x"] - spritehero_pos["w"] - 1
		end
		if (spritehero_pos["y"] < spritetest_pos["y"]) and (spritehero_pos["y"] + spritehero_pos["h"] == spritetest_pos["y"]) then
			spritehero_pos["y"] = spritetest_pos["y"] - spritehero_pos["h"] - 1
		end
	end
end

function game_keypressed(key, unicode)
	spritehero_keypressed(key, unicode)
	spriteennemy_keypressed(key, unicode)
end

function game_keyreleased(key, unicode)
	spritehero_keyreleased(key, unicode)
	spriteennemy_keyreleased(key, unicode)
end