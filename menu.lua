function menu_load()
	gamestate = "menu"
	numSelectedItem = 1
	arrItemsString = {"start", "options", "quit"}
	numItemsCount = table.getn(arrItemsString)
end

function menu_update(dt)
end

function menu_draw()
	strPrint = "spotted! - menu"
	basic_properprint(strPrint)
	
	for i=1, numItemsCount do
		menu_draw_item(i)
	end
end

function menu_draw_item(numItemToDraw)
	if (numItemToDraw == numSelectedItem) then
		love.graphics.setColor(255, 0, 0)
	else
		love.graphics.setColor(255, 255, 255)
	end
	love.graphics.printf(arrItemsString[numItemToDraw], 0, 5 + numItemToDraw * 10, 800, "center")
end

function menu_keypressed(key, unicode)
	if key == "up" then
		numSelectedItem = numSelectedItem - 1
		if (numSelectedItem == 0) then 
			numSelectedItem = numItemsCount
		end
	elseif key == "down" then
		numSelectedItem = numSelectedItem + 1
		if (numSelectedItem == numItemsCount + 1) then 
			numSelectedItem = 1
		end
	end
end

function menu_keyreleased(key, unicode)
	if key == "return" then
		if (arrItemsString[numSelectedItem] == "start") then
			game_load()
		
		elseif (arrItemsString[numSelectedItem] == "options") then
			options_load()
		
		elseif (arrItemsString[numSelectedItem] == "quit") then
			love.event.quit()
		end
	end
end