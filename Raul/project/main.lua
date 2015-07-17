require("libs/AnAL")
require("objects/maps");
require("objects/Samus");

maps = nil;
currentMap = nil;
currentXPos = 0;
currentYPos = 0;
frametime = 0;
framerate = 0;
frames = 0;

-- Test stuff
samus = nil;

function love.load()
	-- Set window size/mode
	love.window.setMode(960, 540, {vsync=true, fsaa=0, resizable=false, borderless=false, centered=true, highdpi=true, srgb=true})

	-- Load animation resource
	local img = love.graphics.newImage("resources/spritesheets/Resource-AnalExplosion.png");
	-- Create animation
	anim = newAnimation(img, 96, 96, 0.1, 0);
	
	samus = Samus:new();
	--samus:setPose(3);
	samus:setState(2);
	
	maps = Maps:new();
	
	currentMap = maps:getMap('map1');
end

function love.update(dt)
	-- Update animation
	anim:update(dt);
	
	samus:update(dt, true);
	currentXPos = samus.posX;
	currentYPos = samus.posY;
	
	frametime = frametime + dt;
	framerate = frames / frametime;
end

function love.draw()
	currentMap:draw(currentXPos, currentYPos);
    love.graphics.print(samus.debugOutput, 400, 300)
    love.graphics.print(framerate, 800, 500)
	anim:draw(100, 100);
	samus:draw(0, 0);

	frames = frames + 1;
end

function love.keypressed(key, unicode)
	samus:keypressed(key, unicode, true);
--	if key == 'up' then
--		currentYPos = math.max(currentYPos-1, 0);
--	end
--	if key == 'down' then
--		currentYPos = currentYPos+1;
--	end
--	if key == 'left' then
--		currentXPos = math.max(currentXPos-1, 0);
--	end
--	if key == 'right' then
--		currentXPos = currentXPos+1;
--	end
end


