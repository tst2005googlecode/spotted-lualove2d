function intro_load()
	gamestate = "intro"
	
	introduration = 2.5
	blackafterintro = 0.3
	introfadetime = 0.5
	introprogress = -0.2 
	
	screenwidth = 400 * scale
	screenheight = 224 * scale
	allowskip = false
end

function intro_update(dt)
	allowskip = true
	if introprogress < introduration + blackafterintro then
		introprogress = introprogress + dt
		if introprogress > introduration + blackafterintro then
			introprogress = introduration + blackafterintro
		end
		if introprogress == introduration + blackafterintro then
			menu_load()
		end
	end
end

function intro_draw()
	strPrint = "spotted!"
	basic_properprint(strPrint)
end

function intro_keypressed()
	if not allowskip then
		return
	end
	menu_load()
end