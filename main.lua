-- requirataan kirjastoja
local point = require("point")
local physics = require("physics")

-- aloita fysiikat
physics.start()
physics.setGravity(0, 0)

-- init joitain muuttujia
local X = display.contentCenterX
local Y = display.contentCenterY
local W = display.actualContentWidth
local H = display.contentHeight
local online = true
local gameReset
local scoreAI = 0
local score = 0

-- tämä funktio luo joitain näkyviä asioita
local function luoJuttuja()
	local seina1 = display.newRect(X + W / 2, Y, 10, H)
	seina1.nimi = "seina1"
	physics.addBody(seina1, "static", {bounce = 1})

	local seina2 = display.newRect(X - W / 2, Y, 10, H)
	seina2.nimi = "seina2"
	physics.addBody(seina2, "static", {bounce = 1})

	katto1 = display.newRect(X, Y - H / 2, W, 10)
	katto1.nimi = "katto1"
	physics.addBody(katto1, "static", {bounce = 1})

	katto2 = display.newRect(X, Y + H / 2, W, 10)
	katto2.nimi = "katto2"
	physics.addBody(katto2, "static", {bounce = 1})

	tausta = display.setDefault("background", 0, 0, 0)

	scoreTeksti = display.newText(""..scoreAI.." "..score.."", X, Y - H / 2.3, native.systemFont, 25)
	scoreTeksti:toBack()

	maila1 = display.newRect(X + W / 2.1, Y, 10, H /4, 4.5)
	maila1.nimi = "maila1"
	physics.addBody(maila1, "static", {bounce = 1})

	maila2 = display.newRect(X - W / 2.1, Y, 10, H /4, 4.5)
	maila2.nimi = "maila2"
	physics.addBody(maila2, "static", {bounce = 1})
end
luoJuttuja()

local function gameStart()
	physics.start()
	if pallo then physics.removeBody(pallo) display.remove(pallo) pallo = nil end
	pallo = display.newCircle(X, Y, 10)
	pallo.nimi = "pallo"

	timer.performWithDelay(50, function() physics.addBody(pallo, {bounce = 1, radius = 10}) pallo:applyForce(2, math.random(-300, 300) / 100) end, 1)
	online = true
end

local function gameReset()
	physics.stop()
	physics.removeBody(pallo)
	display.remove(pallo)
	pallo = nil
	online = false

	timer.performWithDelay(1000, gameStart, 1)
end

local function collide(event)
	if "began" == event.phase then

		if event.object1.nimi == "seina1" then
			scoreAI = scoreAI + 1
			gameReset()
		elseif event.object1.nimi == "seina2" then
			score = score + 1
			gameReset()
		end
		scoreTeksti.text = ""..scoreAI.." "..score..""
	end
end
Runtime:addEventListener("collision", collide)

local function liikutaMaila1(event)
	if "began" == event.phase then
		if event.y < maila1.y then
			vali = maila1.y - event.y
		elseif event.y > maila1.y then
			vali = (event.y - maila1.y) * -1
		end

		elseif "moved" == event.phase then
			if event.y + vali > katto1.y + maila1.height / 2 and event.y + vali < katto2.y - maila1.height / 2 then
				maila1.y = event.y + vali
			end
		end
end
Runtime:addEventListener("touch", liikutaMaila1)

local function maila2AI (event)
	if online == true then
		if pallo.y > maila2.y then
			maila2.y = maila2.y + 1.5
		end
		if pallo.y < maila2.y then
			maila2.y = maila2.y - 1.5
		end
	end
end
timer.performWithDelay(10, maila2AI, 0)

gameStart()