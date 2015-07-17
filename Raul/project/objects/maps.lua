
__HAS_SECS_COMPATIBLE_CLASSES__ = true

-- Map Class
local MapClass_mt = {}

function MapClass_mt:__index(key)
    return self.__baseclass[key]
end

Map = setmetatable({ __baseclass = {} }, MapClass_mt)

function Map:new(...)
    local c = {}
    c.__baseclass = self
    setmetatable(c, getmetatable(self))
    if c.init then
        c:init(...)
    end
    return c
end

function Map:init(name)
	rootDir = 'resources/maps/' .. name .. '/';
	-- load map data
	self.data = require(rootDir .. name .. '_data');
	-- load map tiles
	self.info = require(rootDir .. name .. '_info');
	self.tiles = {};
	-- Load tile graphics
	for i=1, self.info.count do
		self.tiles[i-1] = love.graphics.newImage(rootDir .. 'img/' .. self.info.image_files[i]);
	end
	self.display_buffer = 2;
end

function Map:draw(mapX, mapY)
	offset_x = mapX % self.info.tile_w;
	offset_y = mapY % self.info.tile_h;
	firstTile_x = math.floor(mapX / self.info.tile_w);
	firstTile_y = math.floor(mapY / self.info.tile_h);
	for y=1, (self.info.map_display_h + self.display_buffer) do
		for x=1, (self.info.map_display_w + self.display_buffer) do
			if y+firstTile_y >= 1 and y+firstTile_y <= self.info.map_height and x+firstTile_x >= 1 and x+firstTile_x <= self.info.map_width then
				love.graphics.draw(
					self.tiles[self.data[y+firstTile_y][x+firstTile_x]], 
					((x-1)*self.info.tile_w) - offset_x - self.info.tile_w/2, 
					((y-1)*self.info.tile_h) - offset_y - self.info.tile_h/2 )
			end
		end
	end
end
-- end Map Class


-- Maps Class
local MapsClass_mt = {}

function MapsClass_mt:__index(key)
    return self.__baseclass[key]
end

Maps = setmetatable({ __baseclass = {} }, MapsClass_mt)

function Maps:new(...)
    local c = {}
    c.__baseclass = self
    setmetatable(c, getmetatable(self))
    if c.init then
        c:init(...)
    end
    return c
end

function Maps:init()

	self.mapset = {}

end

function Maps:getMap(name)

	if (self.mapset[name] == nil) then
		self.mapset[name] = Map:new(name);
	end
	
	return self.mapset[name]

end