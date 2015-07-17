EntityManager = class:new();

function EntityManager:init()
  self.nextGUID = 0;
  self.components = {};
end

-- Create and return a new entity
function EntityManager:createEntity()
  entity = Entity:new(self.nextGUID);
  self.nextGUID = self.nextGUID + 1;
  return entity;
end

-- Add a component to an entity
function EntityManager:addComponent(entity, component)
  local compType = type(component);
  
  if self.components[compType] == nil then
    self.components[compType] = {};
  end
  
  self.components[compType][entity] = component;
end

-- Remove the component from an entity
function EntityManager:removeComponent(entity, componentType)
  if self.components == nil then
    return;
  end
  
  if self.components[componentType] == nil then
    return;
  end
  
  if self.components[componentType][entity] == nil then
    return;
  end
  
  self.components[componentType][entity] = nil;
end

-- Returns a list of tuples containing the entity and the component specified
function EntityManager:entityComponentPairs(componentType)
  return pairs(self.components[componentType]);
end

-- Returns the component of a entity
function EntityManager:entityComponent(entity, componentType)
  if self.components[componentType] == nil then
    return nil;
  end
  
  if self.components[componentType][entity] == nil then
    return nil;
  end
  
  return self.components[componentType][entity];
end

-- Remove the specified entity and all components belonging to entity
function EntityManager:removeEntity(entity)
  if self.components ~= nil then
    for key, value in pairs(self.components) do
      if value[entity] ~= nil then
        value[entity] = nil;
      end
    end
    
    return "Success";
  else
    return "Fail";
  end
end