function love.load()
  require "class";
  require "entity";
  require "component";
  require "entitymanager";
  require "system";
  require "systemmanager";
  
  em = EntityManager:new();
  
  for i = 1, 10 do
    e = em:createEntity();
    c = Component:new();
    em:addComponent(e, c);
  end
  
  t = "Not Tested";
end

function love.update(dt)
  
end

function love.keypressed(key)
  if key == "w" then
    c:doStuff();
  elseif key == "s" then
    em:removeComponent(e, type(Component));
  elseif key == "j" then
    c = Component:new();
    em:addComponent(e, c);
  elseif key == "k" then
    t = em.removeEntity(e);
  end
end

function love.draw()
  comp = em:entityComponent(e, type(Component));
  
  if comp ~= nil then
    love.graphics.print(comp.poo, 10, 10);
  else
    love.graphics.print("Removed", 10, 10);
  end
  
  love.graphics.print(tostring(em.components), 10, 30);
end