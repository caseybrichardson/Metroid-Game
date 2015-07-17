Component = class:new();

function Component:init()
  self.poo = 1;
end

function Component:doStuff()
  self.poo = self.poo + 1;
end
