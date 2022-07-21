--- Lua-side duplication of the API of events on Roblox objects.
-- Signals are needed for to ensure that for local events objects are passed by
-- reference rather than by value where possible, as the BindableEvent objects
-- always pass signal arguments by value, meaning tables will be deep copied.
-- Roblox's deep copy method parses to a non-lua table compatable format.
-- @classmod Signal

local Signal : any? = {};

Signal.__index = Signal;
Signal.ClassName = "Signal";

--- Constructs a new signal.
-- @constructor Signal.new()
-- @treturn Signal
function Signal.new() : any?
	local self = setmetatable({}, Signal);

	self._BindableEvent = Instance.new("BindableEvent");
	
	self._ArgumentData = nil;
	self._ArgumentCount = nil; -- Prevent edge case of :Fire("A", nil) --> "A" instead of "A", nil

	return (self);
end;

--- Fire the event with the given arguments. All handlers will be invoked. Handlers follow
-- Roblox signal conventions.
-- @param ... Variable arguments to pass to handler
-- @treturn nil
function Signal:Fire(...) : any?
	self._ArgumentData = {...};
	self._ArgumentCount = select("#", ...);
	self._BindableEvent:Fire();
	self._ArgumentData = nil;
	self._ArgumentCount = nil;
end;

--- Connect a new handler to the event. Returns a connection object that can be disconnected.
-- @tparam function handler Function handler called with arguments passed when `:Fire(...)` is called
-- @treturn Connection Connection object that can be disconnected
function Signal:Connect(Handler : (... any?) -> ... any?) : ... any?
	if not (type(Handler) == "function") then
		error(string.format("Connect(%s)", typeof(Handler)), 2);
	end;

	return (self._BindableEvent.Event:Connect(function() : nil?
		Handler(unpack(self._ArgumentData, 1, self._ArgumentCount));
	end));
end;

--- Wait for fire to be called, and return the arguments it was given.
-- @treturn ... Variable arguments from connection
function Signal:Wait(...) : ... any?
	self._BindableEvent.Event:Wait(...);
	
	assert(self._ArgumentData, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.");
	
	return unpack(self._ArgumentData, 1, self._ArgumentCount);
end;

--- Disconnects all connected events to the signal. Voids the signal as unusable.
-- @treturn nil
function Signal:Destroy() : nil?
	if (self._BindableEvent) then
		self._BindableEvent:Destroy();
		self._BindableEvent = nil;
	end;

	self._ArgumentData = nil;
	self._ArgumentCount = nil;
end;

return (Signal);