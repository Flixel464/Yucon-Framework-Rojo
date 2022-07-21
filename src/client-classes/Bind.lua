--[[
Basically a better ContextActionService

Example usage (shift-to-sprint):

self:NewInstance("Bind", {
	Name = "Sprint",
	
	BindedFunction = function(_, State)
		local CurrentSprintState = nil
		
		if State == Enum.UserInputState.Begin then
			CurrentSprintState = true
		elseif State == Enum.UserInputState.End then
			CurrentSprintState = false
		end
		
		if CurrentSprintState ~= nil then
			Character.Humanoid.WalkSpeed = CurrentSprintState and 23 or 16
		end
	end,
	
	Controls = {Enum.KeyCode.LeftShift}
})

--]]


local Bind = {};
Bind.__index = Bind;

local ContextActionService : ContextActionService = game:GetService("ContextActionService");

type Bind = {
	Name : string,
	Enabled : boolean,
	BindedFunction : (... any?) -> ... any?,
	MobileButton : boolean,
	Controls : {[any] : any?}
};

local BindDefaults : Bind = {
	Name = "", -- Name ALWAYS will be overridden
	
	Enabled = true,
	
	BindedFunction = function() return; end,
	
	MobileButton = false,
	
	Controls = {},
};

--// Constructor

function Bind.New(ConstructorDictionary)
	local self : Bind? = {};
	
	assert(ConstructorDictionary, "No constructor dictionary was passed during bind creation.");
	assert(ConstructorDictionary.Name, "Bind was not named.");
	
	for Index : string, Value : any? in pairs(BindDefaults) do
		
		self[Index] = ConstructorDictionary[Index] or Value;
	end;
	
	ContextActionService:BindAction(self.Name, function(...)
		
		if (self.Enabled) then
			
			self.BindedFunction(...);
		end;
		
	end, self.MobileButton, unpack(self.Controls));
	
	return (setmetatable(self, Bind));
end;

--// Methods

function Bind:Enable() : nil?
	
	self.Enabled = true;
end;

function Bind:Disable() : nil?
	
	self.Enabled = false;
end;

function Bind:Destroy() : nil?
	
	ContextActionService:UnbindAction(self.Name);
end;

return (Bind);