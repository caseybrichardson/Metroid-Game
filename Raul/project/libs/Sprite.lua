local Sprite_mt = {}

function Sprite_mt:__index(key)
	return self.__baseclass[key]
end

Sprite = setmetatable({ __baseclass = {} }, Sprite_mt)

--- Create a new sprite object
-- @return The created sprite
function Sprite:new(spriteinfo)
	local a = {}
	a.__baseclass = self;
	setmetatable(a, getmetatable(self))
	if a.init then
		a:init(spriteinfo);
	end
	return a
end

function Sprite:init(spriteinfo)
	-- load the image
	self.img = love.graphics.newImage(spriteinfo.image);
	self.img:setFilter('nearest', 'linear');
	-- Grab info from spriteinfo table
	stateCount = #spriteinfo.state_info;
	self.states = {};
	self.frameWidth = spriteinfo.frame_width;
	self.frameHeight = spriteinfo.frame_height;
	local imgw = self.img:getWidth();
	local imgh = self.img:getHeight();
	-- process all states
	for i=1, stateCount do
		self.states[i] = {};
		-- process all poses
		local posecount = spriteinfo.state_info[i].poses;
		local poses = {};
		for j=1, posecount do
			poses[j] = {
				['directional'] = spriteinfo.state_info[i].pose_info[j].is_directional,
				['frameCount'] = spriteinfo.state_info[i].pose_info[j].frames,
				['delay'] = spriteinfo.state_info[i].pose_info[j].delay,
				['speed'] = spriteinfo.state_info[i].pose_info[j].speed,
				['mode'] = spriteinfo.state_info[i].pose_info[j].mode,
				['frames'] = {}
			};
			if poses[j].frameCount > 1 then -- is animated pose
				-- Build quads for state
				local column = spriteinfo.state_info[i].pose_info[j].start_column;
				local row = spriteinfo.state_info[i].pose_info[j].start_row;
				for k=1, poses[j].frameCount do
					poses[j].frames[k] = {['frameQuads'] = {}};
					local firstFrame = love.graphics.newQuad(column*self.frameWidth, row*self.frameHeight, self.frameWidth, self.frameHeight, imgw, imgh)
					poses[j].frames[k].frameQuads[1] = firstFrame;
					if poses[j].directional then
						local secondFrame = love.graphics.newQuad(column*self.frameWidth, (row+1)*self.frameHeight, self.frameWidth, self.frameHeight, imgw, imgh);
						poses[j].frames[k].frameQuads[2] = secondFrame;
					end
					column = column+1;
				end
			else -- is static pose
				-- Build quads for state
				poses[j].frames[1] = {['frameQuads'] = {}};
				local column = spriteinfo.state_info[i].pose_info[j].start_column;
				local row = spriteinfo.state_info[i].pose_info[j].start_row;
				local firstFrame = love.graphics.newQuad(column*self.frameWidth, row*self.frameHeight, self.frameWidth, self.frameHeight, imgw, imgh)
				poses[j].frames[1].frameQuads[1] = firstFrame;
				if poses[j].directional then
					local secondFrame = love.graphics.newQuad(column*self.frameWidth, (row+1)*self.frameHeight, self.frameWidth, self.frameHeight, imgw, imgh);
					poses[j].frames[1].frameQuads[2] = secondFrame;
				end
			end
		end
		self.states[i].poses = poses;
	end
	-- Initialize some stuff
	self.timer = 0;
	self.speed = 1;
	self.currentFrame = 1;
	self.state = 1;
	self.pose = 1;
	self.direction = 1; -- 1=right, -1=left
	self.animating = false;
	self.animDirection = 1; -- 1=right, -1=left
	self.scale = 1;
end

--- Update the animation if any
-- @param dt Time that has passed since last call
function Sprite:update(dt)
	-- Only if on animation
	if self.animating then
		local frameCount = self.states[self.state].poses[self.pose].frameCount;
		self.timer = self.timer + dt * self.speed
		if self.timer > self.states[self.state].poses[self.pose].delay then
			self.timer = self.timer - self.states[self.state].poses[self.pose].delay
			self.currentFrame = self.currentFrame + self.animDirection;
			local mode = self.states[self.state].poses[self.pose].mode;
			if self.currentFrame > frameCount then
				if mode == 1 then
					self.currentFrame = 1
				elseif mode == 2 then
					self.currentFrame = self.currentFrame - 1
					self:stop()
				elseif mode == 3 then
					self.animDirection = -1
					self.currentFrame = self.currentFrame - 1
				end
			elseif self.currentFrame < 1 and mode == 3 then
				self.animDirection = 1
				self.currentFrame = 1
			end
		end
	end
end

--- Draw the sprite
local drawq = love.graphics.drawq or love.graphics.draw
function Sprite:draw(xOffset, yOffset)
	local fQuad = 1;
	if self.states[self.state].poses[self.pose].directional then
		if self.direction < 0 then -- moving to the left
			fQuad = 2;
		end
	end
	return drawq(self.img, self.states[self.state].poses[self.pose].frames[self.currentFrame].frameQuads[fQuad], xOffset, yOffset, 0, self.scale, self.scale);
end

--- Play the animation
-- Starts it if it was stopped.
function Sprite:play()
	if self.states[self.state].poses[self.pose].frameCount > 1 then
		self.animating = true;
	end
end

--- Stop the animation
function Sprite:stop()
	self.animating = false
end

--- Reset
-- Go back to the first frame.
function Sprite:reset()
	return self:seek(1)
end

--- Seek to a frame
-- @param frame The frame to display now
function Sprite:seek(frame)
	if frame > 0 and frame <= self.states[self.state].poses[self.pose].frameCount then
		self.currentFrame = frame;
		self.timer = 0;
	end
end

--- Get the currently shown frame
-- @return The current frame
function Sprite:getCurrentFrame()
	return self.currentFrame;
end

--- Get the number of frames
-- @return The number of frames
function Sprite:getSize()
	return self.states[self.state].poses[self.pose].frameCount;
end

--- Set the speed
-- @param speed The speed to play at (1 is normal, 2 is double, etc)
function Sprite:setSpeed(speed)
	self.speed = speed;
end

function Sprite:setState(state)
	if self.states[state] ~= nil then
		self.state = state;
		-- Reset remaining state
		self.timer = 0;
		self.currentFrame = 1;
		--self.pose = 1;
		self.speed = self.states[self.state].poses[self.pose].speed;
		self.animDirection = 1;
		self.animating = self.states[self.state].poses[self.pose].frameCount > 1;
	end
end

function Sprite:setPose(pose)
	if self.states[self.state].poses[pose] ~= nil then
		self.pose = pose;
		-- Reset remaining state
		--self.timer = 0;
		--self.currentFrame = 1;
		self.speed = self.states[self.state].poses[self.pose].speed;
		self.animDirection = 1;
		self.animating = self.states[self.state].poses[self.pose].frameCount > 1;
	end
end

function Sprite:setDirection(dir)
	if dir ~= self.direction then
		self.direction = dir;
		-- Reset remaining state
		self.timer = 0;
		self.currentFrame = 1;
		self.animDirection = 1;
		self.animating = self.states[self.state].poses[self.pose].frameCount > 1;
	end
end

function Sprite:setScale(scale)
	self.scale = scale;
end
