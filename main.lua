-- require point library and physics library
local point = require("point")
local physics = require("physics")

-- start physics and set gravity to zero
physics.start()
physics.setGravity(0, 0)

-- init some needed variables
local _X = display.contentCenterX
local _Y = display.contentCenterY
local _W = display.actualContentWidth
local _H = display.contentHeight
local online = true
local gameReset
local scoreAI, score = 0, 0

-- this function creates some (if not all of them) visible/displayable things
local function createObstacles()
	local wall1 = display.newRect(_X  + _W / 2, _Y, 10, _H)
	wall1:setFillColor(1,1,1)
	wall1.name = "wall1"
	physics.addBody(wall1, "static", {bounce = 1})

	local wall2 = display.newRect(_X  - _W / 2, _Y, 10, _H)
	wall2:setFillColor(1,1,1)
	physics.addBody(wall2, "static", {bounce = 1})
   	wall2.name = "wall2"

	roof1 = display.newRect(_X, _Y - _H / 2, _W, 10)
	roof1:setFillColor(1,1,1)
	physics.addBody(roof1, "static", {bounce = 1})
	roof1.name = "roof1"

	roof2 = display.newRect(_X, _Y + _H / 2, _W, 10)
	roof2:setFillColor(1,1,1)
	physics.addBody(roof2, "static", {bounce = 1})
	roof2.name = "roof2"

	es = display.setDefault("background", 0, 0, 0)

	scoreText = display.newText(""..scoreAI.."      "..score.."", _X, _Y - _H/2.3, es, 25)
	scoreText:setFillColor(1,1,1)
	scoreText:toBack()

	clap1 = display.newRoundedRect(_X  + _W / 2.1, _Y, 10, _H / 4, 4.5)
	clap1:setFillColor(1,1,1)
	physics.addBody(clap1, "static", {bounce = 1})
	clap1.name = "clap1"

	clap2 = display.newRoundedRect(_X  - _W / 2.1, _Y, 10, _H / 4, 4.5)
	clap2:setFillColor(1,1,1)
	physics.addBody(clap2, "static", {bounce = 1})
	clap2.name = "clap2"
end
createObstacles()

-- this function is the collision checker function
local function collide(event)
	if "began" == event.phase then

		if event.object1.name == "wall1" then
			scoreAI = scoreAI + 1
			gameReset()
		elseif event.object1.name == "wall2" then
			score = score + 1
			gameReset()

		end
		scoreText.text = ""..scoreAI.."      "..score..""
	end
end
Runtime:addEventListener("collision", collide)

-- this function will start up the physics create ball and make it move and some other things
function gameStart()
	physics.start()
	if ball then physics.removeBody(ball) display.remove(ball) ball = nil end
	ball = display.newCircle(_X, _Y, 10)
	ball.name = "ball"
	
	timer.performWithDelay(50, function() physics.addBody(ball, {bounce = 1, radius = 10}) ball:applyForce(2, math.random(-300,300) / 100, ball.x, ball.y) end, 1)
	online = true
end

-- this function resets the game, stopping physics and removing ball and some other things
-- also makes the screen flash several times before starting up the game again
function gameReset()
	physics.stop()
	physics.removeBody(ball) display.remove(ball) ball = nil
	online = false
	

	es = display.setDefault("background", 1, 0, 0)
	timer.performWithDelay(200, function() es = display.setDefault("background", 0, 1, 0) end, 1)
	timer.performWithDelay(400, function() es = display.setDefault("background", 1, 0, 1) end, 1)
	timer.performWithDelay(600, function() es = display.setDefault("background", 1, 1, 0) end, 1)
	timer.performWithDelay(800, function() es = display.setDefault("background", 0, 1, 0) end, 1)
	timer.performWithDelay(1000, function() es = display.setDefault("background", 0, 0, 1) end, 1)
	timer.performWithDelay(1200, function() es = display.setDefault("background", 1, 0, 0) end, 1)
	timer.performWithDelay(1400, function() es = display.setDefault("background", 0, 1, 0) end, 1)
	timer.performWithDelay(1600, function() es = display.setDefault("background", 1, 0, 1) end, 1)
	timer.performWithDelay(1800, function() es = display.setDefault("background", 1, 1, 0) end, 1)
	timer.performWithDelay(2000, function() es = display.setDefault("background", 0, 1, 0) end, 1)
	timer.performWithDelay(2200, function() es = display.setDefault("background", 0, 0, 0) gameStart() end, 1)
end

-- this function makes the clap 1 move when user moves finger/mouse on the screen
local function moveClap1 (event)
	if "began" == event.phase then

		-- see if event.y is upper or below the clap1.y and then make a variable that we use later
		-- to make so that the user does not need to press directly the clap1
		if event.y < clap1.y then
			yzz = clap1.y - event.y
		elseif event.y > clap1.y then
			yzz = (event.y - clap1.y) * -1
		end

		-- once moved the mouse/finger on the screen, check if the event.y + yzz is more/less than roof.y
		-- and adjust it so that the clap can not go below/over roofs
	elseif "moved" == event.phase then
		if event.y + yzz > roof1.y + clap1.height / 2 and event.y + yzz < roof2.y - clap1.height / 2 then
			clap1.y = event.y + yzz
		end
	end
end
Runtime:addEventListener("touch", moveClap1)

-- this is the AI function and it controls and moves the AI clap
local function clap2AI (event)
	if online == true then
		if ball.y > clap2.y then
			clap2.y = clap2.y + 1.5
		end
		if ball.y < clap2.y then
			clap2.y = clap2.y - 1.5
		end
	end
end
timer.performWithDelay(10, clap2AI, 0)

-- this makes the game go on (just calls the gameStart function)
gameStart()