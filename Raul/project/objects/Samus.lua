require('libs/Sprite')

-- Samus Entity

local SamusClass_mt = {}

function SamusClass_mt:__index(key)
	return self.__baseclass[key]
end

Samus = setmetatable({ __baseclass = {} }, SamusClass_mt)

function Samus:new(...)
	local c = {}
	c.__baseclass = self
	setmetatable(c, getmetatable(self))
	if c.init then
		c:init(...)
	end
	return c
end

function Samus:init()
	-- set some stuff
	self.sprites = {};
	-- Set defaults
	self.posX = 0;
	self.posY = 0;
	self.yAccel = 9.8;
	self.xVel = 0;
	self.yVel = 0;
	self.speed = 1;
	self.spriteWidth = 22;
	self.spriteHeight = 44;
	self.suitState = 1;
	self.state = 1; -- 1=still, 2=running, 3=jumping, 4=roll jumping, 5=falling
	self.pose = 1; -- 1=normal, 2=gun forward, 3=gun up, 4=crouching, 5=front-facing ... Todo: add more poses
	self.direction = 1; -- 1=right, -1=left
	-- Load initial Samus spritesheet
	self:setSuitState(1);
	-- used as debug output for anything
	self.debugOutput = 0;
end

function Samus:update(dt, canMove)
	-- Update sprite animation
	self.sprites[self.suitState]:update(dt);
	if canMove then -- User has control over Samus
		if love.keyboard.isDown('down') then
			--self.posY = self.posY + speed;
		end
		if love.keyboard.isDown('a') then
			self.xVel = -self.speed;
		elseif love.keyboard.isDown('d') then
			self.xVel = self.speed;
		else
			self.xVel = 0;
		end

		-- Apply Y Velocity. Usually gravity
		--self.yVel = math.max(self.yVel + (self.yAccel * dt), -10);
		self.yVel = self.yVel + (self.yAccel * dt);

		-- Check for jump
		if self.yVel < 0 and self.state ~= 3  and self.state ~= 4 then
			if self.xVel ~= 0 then -- roll jump
				self:setState(4);
			else
				self:setState(3); -- Set jump state
			end
		end

		-- Apply velocity
		self.posX = self.posX + (self.xVel * 300 * dt);
		self.posY = self.posY + (self.yVel * 300 * dt);

		-- Temp stuff to simulate floor
		if self.posY > 400 and self.yVel > 0 then
			self.yVel = 0; -- Stop movement
			self.posY = 400; -- Fix positioning
			if self.xVel == 0 and self.state ~= 1 then -- not moving
				self:setState(1); -- Set still state
			end
			if self.xVel ~= 0 and self.state ~= 2 then
				self:setState(2);
			end
		end

		-- Set direction based on current velocity
		if self.xVel < 0 then
			self:setDirection(-1);
		elseif self.xVel > 0 then
			self:setDirection(1);
		end
		-- Change state based on current velocity
		if self.xVel ~= 0 and self.state == 1 then -- Started moving. Was standing still
			self:setState(2);
		elseif self.xVel == 0 and self.state == 2 then -- Stopped moving. Was moving
			self:setState(1);
		end

		-- Set pose
		if love.keyboard.isDown('w') then
			if self.pose ~= 3 then
				self:setPose(3);
			end
		else
			if self.pose ~= 1 then
				self:setPose(1);
			end
		end
	end
end

function Samus:keypressed(key, unicode, canMove)
	--if canMove then -- User has control over Samus
		if key == " " and self.yVel == 0 then
			--self.debugOutput = self.debugOutput + 1;
			self.yVel = -3;
			self.debugOutput = '_'..key..'_'..self.yVel;
		else
			self.debugOutput = '_'..key..'_'..self.yVel..'_'..self.posY;
		end
	--end
end

function Samus:setSuitState(state)
	if state >= 1 and state <= 3 then
		self.suitState = state;
		-- Check if spritesheet has been loaded
		if self.sprites[state] == nil then
			self.sprites[state] = Sprite:new(require('resources/spritesheets/samus/suitstate'..state..'_info'));
			--self.sprites[state]:setScale(2);
		end
	end
end

function Samus:setDirection(dir)
	self.sprites[self.suitState]:setDirection(dir);
end

function Samus:setState(state)
	if state >= 1 and state <= 4 then
		self.state = state;
		self.sprites[self.suitState]:setState(state);
	end
end

function Samus:setPose(pose)
	if pose >= 1 and pose <= 5 then
		self.pose = pose;
		self.sprites[self.suitState]:setPose(pose);
	end
end

function Samus:draw(xOffset, yOffset)
	self.sprites[self.suitState]:draw(xOffset+self.posX, yOffset+self.posY);
end
