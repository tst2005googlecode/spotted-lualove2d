function init()
	gamestate = "intro"
	scale = 2
	
	fontglyphs = "0123456789abcdefghijklmnopqrstuvwxyz.:/,'C-_>* !{}?"
	fontquads = {}
	fontimage = love.graphics.newImage("img/font.png")
	for i = 1, string.len(fontglyphs) do
		fontquads[string.sub(fontglyphs, i, i)] = love.graphics.newQuad((i-1)*8, 0, 8, 8, 512, 8)
	end
end

function love.load()
	require "lib"
	
	--love.physics.setMeter(64)
	--world = love.physics.newWorld(0, 9.81*64, true)
	
	init()
	fullscreen = false
	love.graphics.setBackgroundColor(0, 0, 0)
	love.graphics.clear()
	love.graphics.setColor(100, 100, 100)
	love.graphics.present()
	
	require "intro"
	require "menu"
	require "options"
	require "game"
	
	require "spritehero"
	require "spriteennemy"
	require "wall"
	require "wall1"
	
	intro_load()
	
	spritehero_load()
	spriteennemy_load()
	wall_load()
end

function love.update(dt)
	if gamestate == "intro" then
		intro_update(dt)
	elseif gamestate == "game" then
		game_update(dt)
	end
end

function love.draw()
	if gamestate == "intro" then
		intro_draw()
	elseif gamestate == "menu" then
		menu_draw()
	elseif gamestate == "options" then
		options_draw()
	elseif gamestate == "game" then
		game_draw()
	end
	
	love.graphics.setColor(255, 255, 255)
end

function love.keypressed(key, unicode)
	if gamestate == "intro" then
		intro_keypressed()
	elseif gamestate == "menu" then
		menu_keypressed(key, unicode)
	elseif gamestate == "options" then
		options_keypressed()
	elseif gamestate == "game" then
		game_keypressed(key, unicode)
	end
end

function love.keyreleased(key, unicode)
	if gamestate == "menu" then
		menu_keyreleased(key, unicode)
	elseif gamestate == "game" then
		game_keyreleased(key, unicode)
	end
end

function love.focus(f)
end