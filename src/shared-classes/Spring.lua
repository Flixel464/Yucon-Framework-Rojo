--[[
	
    __   __                     ______                                           _    
	\ \ / /                     |  ___|                                         | |   
	 \ V /   _  ___ ___  _ __   | |_ _ __ __ _ _ __ ___   _____      _____  _ __| | __
	  \ / | | |/ __/ _ \| '_ \  |  _| '__/ _` | '_ ` _ \ / _ \ \ /\ / / _ \| '__| |/ /
	  | | |_| | (_| (_) | | | | | | | | | (_| | | | | | |  __/\ V  V / (_) | |  |   < 
	  \_/\__,_|\___\___/|_| |_| \_| |_|  \__,_|_| |_| |_|\___| \_/\_/ \___/|_|  |_|\_\
	                                                                                  

Module for creating and simulating springs.

Example using this:

local Spring = self:NewInstance("Spring", 0, 25, 0.95)
Spring.Target = 1

task.wait(1)

print(Spring.Position)

--]]

local Spring : any?, EulersNumber : number = {}, 2.71828;

-- Euler's Number is equal to the "limit of 1 plus infininity all to the infinite power"
-- This is approximately 2.71828, and has a large number of use cases (such as this, or as the natural log base)

local function GetPositionDerivative(Speed : number, Dampening : number, Position0 : number, Coordinate1 : number, Coordinate2 : number, Tick0 : number) : number
	-- This returns position and instantaneous velocity
	-- The first derivative of position is ALWAYS velocity
	
	local Time : number = tick() - Tick0;
	
	if (Dampening >= 1) then
		local EulersFastTime : number = math.pow(EulersNumber, (Speed * Time));
		
		return ((Coordinate1 + Coordinate2 * Speed * Time) / EulersFastTime + Position0), -- POSITION
			((Coordinate2 * Speed * (1 - Time) - Coordinate1) / EulersFastTime); -- VELOCITY
	else
		local High : number = math.sqrt(1 - Dampening * Dampening);
		
		local HighSpeedTime : number = Speed * High * Time;
		local DampenedSpeedTime : number = math.pow(EulersNumber, Speed * Dampening * Time);
		local SineHighSpeedTime : number, CosineHighSpeedTime : number = math.sin(HighSpeedTime), math.cos(HighSpeedTime);
		
		return ((Coordinate1 * CosineHighSpeedTime + Coordinate2 * SineHighSpeedTime) / DampenedSpeedTime + Position0),  -- POSITION
			(Speed * ((High * Coordinate2 - Dampening * Coordinate1) * CosineHighSpeedTime - (High * Coordinate1 + Dampening * Coordinate1) * SineHighSpeedTime) / DampenedSpeedTime); -- VELOCITY
	end;
end;

function Spring.New(InitialValue, Speed, Dampening)
	local self = {};
	
	local Speed : number? = Speed or 15;
	local Dampening : number? = Dampening or 0.5;
	local Position0 : number? = InitialValue or 0;
	
	local Coordinate1 : number, Coordinate2 : number = 0, 0; -- 0 * Position0
	local Tick0 : number = tick();

	function self:Impulse(Amount : number) : nil?
		local Position : number, Velocity : number = GetPositionDerivative(Speed, Dampening, Position0, Coordinate1, Coordinate2, Tick0);
		
		Tick0, Coordinate1 = tick(), Position;
		
		if (Dampening >= 1) then
			Coordinate2 = Coordinate1 + (Velocity + Amount) / Speed;
		else
			local High : number = math.sqrt(1 - Dampening * Dampening);
			
			Coordinate2 = Dampening / High * Coordinate1 + (Velocity + Amount) / (Speed * High);
		end;
	end;

	local Metatable : any? = {};

	function Metatable.__index(_, Index : string) : ... number?
		Index = string.lower(Index);
		
		if (Index == "position") then
			return GetPositionDerivative(Speed, Dampening, Position0, Coordinate1, Coordinate2, Tick0);
			
		elseif (Index == "velocity") then
			local _, Velocity : number = GetPositionDerivative(Speed, Dampening, Position0, Coordinate1, Coordinate2, Tick0);
			
			return (Velocity);
			
		elseif (Index == "dampen") or (Index == "dampening") then
			return (Dampening);
			
		elseif (Index == "speed") then
			return (Speed);
		end;
	end;

	function Metatable.__newindex(_, Index : string, Value : any?) : ... any?
		Index = string.lower(Index);
		
		if (Index == "dampen") or (Index == "dampening") then
			Dampening = Value;
			
		elseif (Index == "speed") then
			Speed = Value;
			
		elseif (Index == "target") then
			local Position : number, Velocity : number = GetPositionDerivative(Speed, Dampening, Position0, Coordinate1, Coordinate2, Tick0);
			
			Tick0, Position0 = tick(), Value;
			Coordinate1 = Position - Position0;
			
			if (Dampening >= 1) then
				Coordinate2 = Coordinate1 + Velocity / Speed;
			else
				local High : number = math.sqrt(1 - Dampening * Dampening);
				
				Coordinate2 = Dampening / High * Coordinate1 + Velocity / (Speed * High);
			end;
		end;
	end;

	return (setmetatable(self, Metatable));
end;

return (Spring);