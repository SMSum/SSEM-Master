local abs = math.abs
local min = math.min
local max = math.max
local clamp = math.Clamp
local round = math.Round
local pi = math.pi


AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")


ENT.OverlayUpdateRate = 2
ENT.LastOverlayUpdate = 1
ENT.WireDebugName     = "SSEM ENGINE"
duplicator.Allow("ssem_engine")


function ENT:PreEntityCopy()
	local Data = self:GetStoredInfo()
	duplicator.StoreEntityModifier( self, "engineData", Data )
	self.BaseClass.PreEntityCopy( self )
end

function DupeFinished(Player, Entity, Data) 
	Entity:Setup(Data.Bore, Data.Stroke, Data.Cylinders, Data.Airflow, Data.Idle, Data.Redline, Data.FlywheelMass, Data.Config, Data.GearboxFinal, Data.GearboxRatio, Data.SoundON, Data.SoundOff, Data.Starter)
	Entity:SetEngineConfig(Data.Config)
	Entity:SetRedline(Data.Redline)
	Entity:SetPlayer(Player)
end

duplicator.RegisterEntityModifier( "engineData", DupeFinished )



function ENT:Initialize()

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.Inputs = WireLib.CreateSpecialInputs(self, {"WHEELS", "Ignition", "Throttle" , "Brake", "Clutch", "ShiftUp", "ShiftDown"}, {"ARRAY", "NORMAL", "NORMAL", "NORMAL", "NORMAL", "NORMAL"})
	self.Outputs = WireLib.CreateOutputs(self, {"Active", "CurrentGear", "Wheel_RPM", "Engine_RPM"})
	
	
	self.TargetPlayers = false
	
	self:TriggerInput("On", 0)
	
	
	-- Added all sounds for now, can be changed to different classes later on
	
	self.SoundTurbo      = "acf_engines/turbine_small.wav"
	self.SoundBOV        = "acf_extra/vehiclefx/boost/turbo_hiss1.wav"
	
	self.SoundGearChange = "physics/plaster/ceiling_tile_impact_hard3.wav"
	
	-- Should probably be set from sseem_menu
	self.Engine_RevLimiter = true
	
	-- Gearbox settings, maybe moved somewhere else later?

	self.Gearbox_Delay = 0.15 -- 150 (in seconds)
	self.Gearbox_ClutchSpeed = 0.2
	self.Gearbox_LockValue = 0.05
	
	-- Fuel settings, should probably also be moved somewhere else later
	self.Fuel_Enabled = false
	self.Fuel_Air_Ratio = 1 / 12.5
	self.Fuel_Density = 0.72 -- 0.72 | 0.745 ( Petrol | Diesel )
	self.Air_Density = 0.0012
	
	-- Some variables, no touchy
	self.Flywheel = {}
	self.Brake = 0
	
	self.Engine_Active = false
	self.Engine_Ignition = 0
	self.Engine_RPM = 0
	self.Engine_IdleRev = 0.1
	self.Engine_RealRPM = 0
	self.Engine_Throttle = 0
	self.Engine_IdleThrottle = 0
	self.Engine_PowerCut = 0
	self.Engine_Volume = 0
	
	self.Flywheel_PowerInertia = 0
	
	self.Gearbox_Gear = 0 --1
	self.Gearbox_Lock = false
	self.Gearbox_Ratio = 0 --self.Gearbox_Ratios[self.Gearbox_Gear] * self.Gearbox_FinalDrive
	self.Gearbox_Clutch = 0
	
	self.Fuel_Capacity = 100 -- (FUELENTITY:OBBMaxs() - FUELENTITY:OBBMins()):Length()
	self.Fuel_Liters = self.Fuel_Capacity
	
	self.Turbo_RPM = 0
	
	self.Throttle_Delay = false
	self.Clutch_Delay = false
	
	self.GearTimer = 0
	
	self.Key_W = 0 -- W / throttle
	self.Key_S = 0 -- S / brake
	self.Key_Sp = 0 -- Shift / clutch
	
	--Null Values, they get changed anyway
	self.Gearbox_Ratios = {0}
	self.Gearbox_Ratios[-1] = -1
	self.Gearbox_FinalDrive = -1

	self:ShiftGear(0)

	--These are blank values that prevents the engine from erroring out when pasting a larger dupe
	--They get changed right after duplication is finished pasting but there is one tick prior that causes nil values so this has to be done...
	self:SetBore(1)
	self:SetStroke(1)
	self:SetCylinders(4)
	self:SetAirflow(1)
	self:SetIdle(600)
	self:SetRedline(8000)
	self:SetFlywheelMass(8)
	self.Engine_PeakTorque = 100


	-- Turbo settings, probably should be moved somewhere else later on
	--[[
	self.Turbo = true
	self.Turbo_Exp = 0.25
	self.Turbo_Inertia = 0.018
	self.Turbo_FlowScale = 70
	self.Turbo_DragScale = 0.025
	self.Turbo_PSIMax = 45
	self.Turbo_AirPressure = 24.7
	self.Turbo_MaxFlow = self:GetRedline() * ((self.Turbo_PSIMax + self.Turbo_AirPressure) / self.Turbo_AirPressure) --Disabled for now, causes errors when duped since its up here
	self.Turbo_MaxRPM = 150000
	--]]

	self.Engine_TorqueTable = {0, 0, 0, 0, 0}


end

function ENT:OnRemove()
	Wire_Remove(self)
end

function ENT:Setup(Engine_Bore, Engine_Stroke, Engine_Cylinders, Engine_Airflow, Engine_Idle, EngineRedlineVal, Engine_FlywheelMass, Engine_Configuration, Gearbox_Finaldrive, Gearbox_Gears, Engine_SoundOn, Engine_SoundOff, Engine_Starter)
	if(Engine_Configuration == 1 and Engine_Cylinders < 5)then
		self:SetModel("models/sem/engines/sem_v4.mdl")
	elseif(Engine_Configuration == 1 and Engine_Cylinders < 7)then
		self:SetModel("models/sem/engines/sem_v6.mdl")
	elseif(Engine_Configuration == 1 and Engine_Cylinders < 9)then
		self:SetModel("models/sem/engines/sem_v8.mdl")
	elseif(Engine_Configuration == 1 and Engine_Cylinders < 11)then
		self:SetModel("models/sem/engines/sem_v10.mdl")
	elseif(Engine_Configuration == 1 and Engine_Cylinders > 11)then
		self:SetModel("models/sem/engines/sem_v12.mdl")
	elseif(Engine_Configuration == 0)then
		self:SetModel("models/sem/misc/sem_flywheel.mdl")
	end


	self:SetBore(Engine_Bore)
	self:SetStroke(Engine_Stroke)
	self:SetCylinders(Engine_Cylinders)
	self:SetAirflow(Engine_Airflow)
	self:SetIdle(Engine_Idle)
	self:SetRedline(EngineRedlineVal)
	self:SetFlywheelMass(Engine_FlywheelMass)
	self:SetEngineConfig(Engine_Configuration)
	
	-- Calculate some stuff
	self.Engine_Displacement = round((Engine_Cylinders * pi * Engine_Bore ^ 2 * Engine_Stroke / 4000000), 1)
	
	self.Engine_PeakTorque = round((Engine_Stroke / Engine_Bore * self.Engine_Displacement * Engine_Airflow) * (Engine_Stroke  / Engine_Bore), 2) * 1.2
	
	self.Fuel_Liters = self.Fuel_Capacity
	
	-- Mass is set outside of the engine in ssem_menu

	local Gearbox_Ratio_Parse = string.Split( Gearbox_Gears, "," )

	self.Gearbox_Ratios = {}

	for i=1, table.Count(Gearbox_Ratio_Parse) - 1 do 
		self.Gearbox_Ratios[i] = Gearbox_Ratio_Parse[i]
	end
	self.Gearbox_Ratios[-1] = Gearbox_Ratio_Parse[table.Count(Gearbox_Ratio_Parse)] --Add the negative (reverse gear)

	self.Gearbox_FinalDrive = Gearbox_Finaldrive

	self.SoundEngineOn   = Engine_SoundOn
	self.SoundEngineOff  = Engine_SoundOff
	self.SoundStart      = Engine_Starter


		


local engineInfo = {}
engineInfo.Bore = Engine_Bore
engineInfo.Stroke = Engine_Stroke
engineInfo.Cylinders = Engine_Cylinders
engineInfo.Airflow = Engine_Airflow
engineInfo.Idle = Engine_Idle
engineInfo.Redline = self:GetRedline()
engineInfo.FlywheelMass = Engine_FlywheelMass
engineInfo.GearboxFinal = Gearbox_Finaldrive
engineInfo.GearboxRatio = Gearbox_Gears
engineInfo.SoundON = Engine_SoundOn
engineInfo.SoundOff = Engine_SoundOff
engineInfo.Starter = Engine_Starter
engineInfo.Config = Engine_Configuration

self:StoreInfo(engineInfo)

self.Engine_TorqueTable = {0.6, 0.7, 1.1, 1.0, 0.7}



self:ShowOutput()

	if self:GetEngineConfig() == 0 then 
		self.VEngineFix = 1
	else
		self.VEngineFix = -1
	end


	if self.CSoundEngineOn then
		self.CSoundEngineOn:Stop()
		self.CSoundEngineOn = CreateSound(self, self.SoundEngineOn)
		self.CSoundEngineOn:PlayEx(0, 100)
	end

	if self.CSoundEngineOff then
		self.CSoundEngineOff:Stop()
		self.CSoundEngineOff = CreateSound(self, self.SoundEngineOff)
		self.CSoundEngineOff:PlayEx(0, 100)
	end

end



local function applyTorque(phys, tq)
	local torqueamount = tq:Length()
	
	-- Convert torque from local to world axis
	tq = phys:LocalToWorld( tq ) - phys:GetPos()
	
	-- Find two vectors perpendicular to the torque axis
	local off
	if abs(tq.x) > torqueamount * 0.1 or abs(tq.z) > torqueamount * 0.1 then
		off = Vector(-tq.z, 0, tq.x)
	else
		off = Vector(-tq.y, tq.x, 0)
	end
	off = off:GetNormal() * torqueamount * 0.5
	
	local dir = ( tq:Cross(off) ):GetNormal()
	
	phys:ApplyForceOffset( dir, off )
	phys:ApplyForceOffset( dir * -1, off * -1 )
end

local function applyTorqueWorld(phys, tq)
	local torqueamount = tq:Length()
	
	-- Find two vectors perpendicular to the torque axis
	local off
	if abs(tq.x) > torqueamount * 0.1 or abs(tq.z) > torqueamount * 0.1 then
		off = Vector(-tq.z, 0, tq.x)
	else
		off = Vector(-tq.y, tq.x, 0)
	end
	off = off:GetNormal() * torqueamount * 0.5
	
	local dir = ( tq:Cross(off) ):GetNormal()
	
	phys:ApplyForceOffset( dir, off )
	phys:ApplyForceOffset( dir * -1, off * -1 )
end

local function sign(n)
	if n < -1e-7 then return -1 end
	if n > 1e-7 then return 1 end
	return 0
end

function ENT:DestroySounds()
	if self.CSoundEngineOn then
		self.CSoundEngineOn:Stop()
	end
	
	if self.CSoundEngineOff then
		self.CSoundEngineOff:Stop()
	end
	
	if self.CSoundStart then
		self.CSoundStart:Stop()
	end
	
	
	if self.CSoundTurbo then
		self.CSoundTurbo:Stop()
	end
	
end


function ENT:ShiftGear(gear)
	local mi, ma = math.huge, -math.huge
	
	for i, _ in pairs(self.Gearbox_Ratios) do
		mi = min(mi, i)
		ma = max(ma, i)
	end
	
	local l = self.Gearbox_Gear
	self.Gearbox_Gear = clamp(round(gear), mi, ma)
	
	if self.Gearbox_Gear == l then return end
	
	if self.Gearbox_Ratios[self.Gearbox_Gear] then
		self.Gearbox_Ratio = self.Gearbox_Ratios[self.Gearbox_Gear] * self.Gearbox_FinalDrive
	end
	
	sound.Play(self.SoundGearChange, self:GetPos(), 100, 60, 0.3)
	
	self.GearTimer = self.Gearbox_Delay
	
	self.Throttle_Delay = true
	self.Clutch_Delay = true
	
	WireLib.TriggerOutput(self, "CurrentGear", self.Gearbox_Gear)
end

function ENT:Think() 
	local dt = FrameTime()
	local Engine_Redline = self:GetRedline()
	
	-- Input
	self.Engine_Ignition = min(self.Engine_Ignition, self.Engine_Active and 1 or 2)
	
	if self.Last_Engine_Ignition ~= self.Engine_Ignition then
		if self.Engine_Ignition == 2 then
			self.CSoundStart = CreateSound(self, self.SoundStart)
			self.CSoundStart:PlayEx(0.5, 100)
		elseif self.CSoundStart then
			self.CSoundStart:Stop()
		end
	end
	
	if self.CSoundStart then
		self.CSoundStart:ChangePitch(max(self.Engine_RPM / self:GetIdle(), 0.35) * 300)
	end
	
	self.Brake = (self.Brake + (self.Key_S - self.Brake) * 0.025) * self.Key_S
	
	self.Engine_Active = ((self.Engine_RPM > 350 and 1 or 0) * sign(self.Engine_Ignition)) ~= 0


	if self.Last_Engine_Active ~= self.Engine_Active then
		WireLib.TriggerOutput(self, "Active", self.Engine_Active and 1 or 0)
		--[[
		if self.Engine_Active then
			if self.Turbo and not self.CSoundTurbo then
				self.CSoundTurbo = CreateSound(self, self.SoundTurbo)
				self.CSoundTurbo:PlayEx(1, 100)
			end
		end
		--]]
	end
	
	if not self.Engine_Active and self.Engine_Ignition == 2 and self.Gearbox_Clutch == 1 then
		self.Engine_RPM = self.Engine_RPM + 15
	end
	
	-- Flywheel / wheels stuff
	local Chassis_Feedback = Vector()
	local Flywheel_RPM = 0
	local Flywheel_Count = 0
	
	if (self.VEngineFix == -1) then 
	up = self:GetRight() 
	elseif (self.VEngineFix == 1) then 
	up = -self:GetUp() 
	end

if (table.Count(self.Flywheel) != 0) then
	for k, ent in pairs(self.Flywheel) do
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then	
			local fix = 1

				if self:GetEngineConfig() == 0 then
				if (self:WorldToLocal(phys:GetEntity():GetPos()).z > 0) then fix = -1 else fix = 1 end
					elseif self:GetEngineConfig() == 1 then
				if (self:WorldToLocal(phys:GetEntity():GetPos()).y > 0) then fix = -1 else fix = 1 end
			end
			
			local rpm = phys:GetAngleVelocity()[2] / 6 * fix

			Flywheel_RPM = Flywheel_RPM - rpm
			Flywheel_Count = Flywheel_Count + 1
			Flywheel_RPM = Flywheel_RPM
			
			if self.Key_S > 0 then
				local force = rpm * 500 * self.Brake
				applyTorqueWorld(phys, -up * force)
				Chassis_Feedback = Chassis_Feedback + Vector(force)
			end
		end
	end
end
	if Flywheel_Count > 0 then
		Flywheel_RPM = Flywheel_RPM / Flywheel_Count
		
		-- Chassis Feedback being applied to engine, it works I guess
		if self.Key_S > 0 then
			local phys = self:GetPhysicsObject()
			if IsValid(phys) then
				applyTorque(phys, Chassis_Feedback * self:WorldToLocal(up + self:GetPos()))
			end
		end
	end
	
	self.Flywheel_RPM = Flywheel_RPM
	WireLib.TriggerOutput(self, "Wheel_RPM", self.Flywheel_RPM)
	
	-- Gearbox stuff, dont know what to do with it yet
	self.Gearbox_Clutch = self.Gearbox_Clutch - self.Gearbox_Clutch * self.Gearbox_ClutchSpeed
	if self.Gearbox_Gear == 0 or self.Cluch_Delay or self.Key_S > 0 then
		self.Gearbox_Clutch = 1
	else
		self.Gearbox_Clutch = self.Key_Sp
	end

	-- Engine related things
	self.Engine_RealRPM = (self.Engine_RPM * self.Gearbox_Clutch) + ((self.Flywheel_RPM * self.Gearbox_Ratio ) * (1 - self.Gearbox_Clutch))
	
	local Engine_Throttle = self.Key_W

	local it = self.Engine_IdleThrottle + (min(self.Engine_RPM, self.Engine_RealRPM) < self:GetIdle() and self.Engine_IdleRev or -self.Engine_IdleRev)
	self.Engine_IdleThrottle = clamp(it, 0, 0.5) * (self.Engine_Active and 1 or 0)
	
	self.Engine_Throttle = max(Engine_Throttle, self.Engine_IdleThrottle)
	
	-- Fuel
	--[[
	if self.Fuel_Enabled then
		local fl = self.Fuel_Liters - (self.Engine_Active and (self.Engine_Displacement * (self.Engine_RPM / 2) * self.Air_Density * self.Fuel_Air_Ratio / self.Fuel_Density / 3900 * max(self.Engine_Throttle, 0.01)) or 0)
		self.Fuel_Liters = clamp(fl, 0, self.Fuel_Capacity)
		
		if self.Fuel_Liters <= 0 then
			self.Engine_Active = false
			WireLib.TriggerOutput(self, "Active", false)
		end
		
		-- When using this, might wanna only set mass once a second to not cause any unneccesery physics calls or w/e
		-- FUELENTITY:setMass(round(self.Fuel_Liters * self.Fuel_Density + self.Fuel_Capacity * 0.1, 1))
	end
	--]]

	-- More engine things
	self.Engine_Throttle = self.Engine_Throttle * (self.Engine_Active and 1 or 0) * ((not self.Throttle_Delay) and 1 or 0)
	
	local pc = self.Engine_PowerCut + ((self.Engine_RealRPM > Engine_Redline) and 0.05 or -0.05)
	self.Engine_PowerCut = clamp(pc, 0, 1) * round(self.Engine_Throttle)
	
	-- TODO, probably in gearbox entity once created
	if self.GearTimer > 0 then
		self.GearTimer = self.GearTimer - dt
		
		if self.GearTimer <= 0 then
			self.Throttle_Delay = false
			self.Clutch_Delay = false
		end
	end
	
	local Factor = clamp(self.Engine_RPM / self:GetRedline(), 0, 1)
	local Factor1 = 1 - Factor
	local et = (5 * Factor1 ^ 4 * Factor * self.Engine_TorqueTable[1]) +
			   (10 * Factor1 ^ 3 * Factor ^ 2 * self.Engine_TorqueTable[2]) +
			   (10 * Factor1 ^ 2 * Factor ^ 3 * self.Engine_TorqueTable[3]) +
			   (5 * Factor1 * Factor ^ 4 * self.Engine_TorqueTable[4]) +
			   (Factor ^ 5 * self.Engine_TorqueTable[5])
	local Engine_Torque = clamp(et, 0, 1)
	
	-- Turbo
	--[[
	if self.Turbo then
		local Turbo_PSI = self.Turbo_PSIMax * self.Turbo_RPM / self.Turbo_MaxRPM
		local Turbo_Boost = (Turbo_PSI + self.Turbo_AirPressure) / self.Turbo_AirPressure
		local Turbo_Flow = max(self.Engine_RPM, 1) * Turbo_Boost / self.Turbo_MaxFlow
		local Turbo_Drag = (self.Turbo_MaxFlow * self.Turbo_DragScale) * (self.Turbo_RPM / self.Turbo_MaxRPM) * (1 - self.Engine_Throttle) / self.Turbo_Inertia
		self.Turbo_RPM = clamp(self.Turbo_RPM + (self.Turbo_FlowScale * (Turbo_Flow ^ self.Turbo_Exp)) / self.Turbo_Inertia - Turbo_Drag, 1, self.Turbo_MaxRPM)
		
		if self.CSoundTurbo then
			self.CSoundTurbo:ChangeVolume(Turbo_Flow / 1.5 - 0.25)
			self.CSoundTurbo:ChangePitch(75 + 50 * self.Turbo_RPM / self.Turbo_MaxRPM)
		end
		
		if self.Engine_Throttle ~= self.Last_Engine_Throttle and self.Engine_Throttle == 0 then

			sound.Play(self.SoundBOV, self:GetPos(), 100,
				85 + 25 * (self.Turbo_RPM / self.Turbo_MaxRPM),
			 	max(self.Turbo_RPM / self.Turbo_MaxRPM - 0.2, 0)
			)
		end
		
		Engine_Torque = Engine_Torque * (Turbo_Boost / 1.25)
	end
	--]]
	self.Last_Engine_Throttle = self.Engine_Throttle
	
	-- More flywheel stuff
	local Engine_FlywheelMass = self:GetFlywheelMass()
	local fpi = (self.Engine_PeakTorque * Engine_Torque - self.Flywheel_PowerInertia) / Engine_FlywheelMass
	self.Flywheel_PowerInertia = max(fpi, self.Engine_PeakTorque * Engine_Torque)
	
	local Gearbox_Feedback = 0
	if self.Gearbox_Clutch < 1 then
		local Engine_Inertia = (clamp(self.Engine_RealRPM, 0, Engine_Redline) - (self.Flywheel_RPM * self.Gearbox_Ratio)) * (1 - self.Gearbox_Clutch) / Engine_Redline
		
		self.Engine_Throttle = self.Engine_Throttle - (self.Engine_Throttle <= 0 and (0.285 * (self.Engine_RealRPM / Engine_Redline)) or 0)
		
		local Flywheel_Power = self.Flywheel_PowerInertia * self.Gearbox_Ratio * (1 - self.Gearbox_Clutch)
		
		Flywheel_Power = Flywheel_Power * min(clamp(self.Engine_Throttle, -1, ((1 - self.Engine_PowerCut) ^ 2)) + Engine_Inertia, 1) *
		                 clamp(1 - (((self.Engine_RealRPM / self.Engine_RPM) - 1) * self.Engine_Throttle), -1, 1) ^ Engine_FlywheelMass
		
		if Flywheel_Power ~= 0 and Flywheel_Power == Flywheel_Power --[[This so we dont get crazy velocity diffusing because of nan]] then


			if (self.VEngineFix == -1) then 
				right = -self:GetUp()
			elseif (self.VEngineFix == 1) then 
				right = -self:GetRight()
			end

			local forward = self:GetForward() * 39.37
			local wheelpower = Flywheel_Power / Flywheel_Count
			local fix = 1
			for k, ent in pairs(self.Flywheel) do
				local phys = ent:GetPhysicsObject()
				if IsValid(phys) then
					local pos = ent:GetPos()
					if self:GetEngineConfig() == 0 then
							if (self:WorldToLocal(phys:GetEntity():GetPos()).z > 0) then fix = -1 else fix = 1 end
						elseif self:GetEngineConfig() == 1 then
							if (self:WorldToLocal(phys:GetEntity():GetPos()).y > 0) then fix = -1 else fix = 1 end
					end
					phys:ApplyForceOffset(phys:GetEntity():GetUp() * -wheelpower * -fix, phys:GetEntity():LocalToWorld(Vector(39.37, 0, 0)))
					phys:ApplyForceOffset(phys:GetEntity():GetUp() * wheelpower * -fix, phys:GetEntity():LocalToWorld(Vector(-39.37, 0, 0)))
				end
			end
			
			local phys = self:GetPhysicsObject()
			if IsValid(phys) then
				local pos = self:GetPos()
				phys:ApplyForceOffset(right * wheelpower, pos - forward)
				phys:ApplyForceOffset(right *  -wheelpower, pos + forward)
			end
		end
	   
		Gearbox_Feedback = (Flywheel_RPM * self.Gearbox_Ratio - self.Engine_RPM) / Engine_FlywheelMass
	end
	
	-- EngineRPM
	Gearbox_Feedback = Gearbox_Feedback * (1 - self.Gearbox_Clutch)
	
	local Engine_Feedback = (sign(self.Engine_Throttle) * Engine_Redline - self.Engine_RPM) * (sign(self.Engine_Throttle) ~= 0 and abs(self.Engine_Throttle * Engine_Torque) or (self.Engine_Active and 0.03 or 0.13)) / 4 * self.Gearbox_Clutch
	
	local rpm = self.Engine_RPM + min(Gearbox_Feedback + Engine_Feedback, (Engine_Redline - self.Engine_RPM) / (Engine_FlywheelMass * (self:GetStroke() / self:GetBore())))
	if rpm > Engine_Redline * 0.95 and self.Engine_RevLimiter then
		rpm = Engine_Redline * 0.9
	end
	self.Engine_RPM = min(rpm, Engine_Redline) * math.Rand(0.995, 1.005)
	WireLib.TriggerOutput(self, "Engine_RPM", self.Engine_RPM)
	
	-- Audio
	self.Engine_Volume = self.Engine_Volume + (max(math.abs(self.Engine_Throttle) ^ 1.25, ((self.Engine_RPM) / 9000) * 0.25) - self.Engine_Volume) * 0.2
	
	local pitch = self.Engine_Active and self.Engine_RPM / 9000 * 155 + 50 or 0

	if self.CSoundEngineOn then
		self.CSoundEngineOn:ChangePitch(pitch)
		self.CSoundEngineOn:ChangeVolume(self.Engine_Volume * 0.75)
	end
	
	if self.CSoundEngineOff then
		self.CSoundEngineOff:ChangePitch(pitch)
		self.CSoundEngineOff:ChangeVolume(((1 - self.Engine_Volume) ^ 1.5) * 0.25)
	end
	
	-- Set Last values
	self.Last_Engine_Ignition = self.Engine_Ignition
	self.Last_Engine_Active = self.Engine_Active
	
	
	--Refresh fast AF
	self:NextThink(CurTime())
	
	return true
end

function ENT:ShowOutput()
	local EnginePeakTorque = math.Round((self:GetStroke() / self:GetBore()  * self:GetDisplacement() * self:GetAirflow()) * (self:GetStroke()  / self:GetBore()), 2)
	local EnginePeakTorque = math.Round(EnginePeakTorque * 0.8, 2)

	local EnginePeakHP = math.Round(((EnginePeakTorque * self:GetRedline()) / 5252), 1 )
	
	if (self:GetEngineConfig() == 1) then
		self:SetOverlayText(
			"SSEM Engine \n V"..self:GetCylinders().."\n Displacement: "..self:GetDisplacement().."L\n Peak Torque: "..EnginePeakTorque.." NM \n Peak HP: "..EnginePeakHP.." HP".."\n Redline: "..self:GetRedline().." RPM\n Flywheel Mass: "..self:GetFlywheelMass().." KG"
		)
	else
		self:SetOverlayText(
			"SSEM Engine \n Inline "..self:GetCylinders().."\n Displacement: "..self:GetDisplacement().."L\n Peak Torque: "..EnginePeakTorque.." NM \n Peak HP: "..EnginePeakHP.." HP".."\n Redline: "..self:GetRedline().." RPM\n Flywheel Mass: "..self:GetFlywheelMass().." KG"
		)
	end
	
end

function ENT:OnRestore()
	Wire_Restored(self)
end

function ENT:OnRemove()
	self:DestroySounds()
end

function ENT:SpawnFunction(ply, tr)
	if not tr.Hit then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	ent = ents.Create("ssem_engine")
	ent:SetPos(SpawnPos)

	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:Use(activator, caller, ent)
	if IsValid(caller) and caller:IsPlayer() then
						RunConsoleCommand("SSEM_Engine_Bore", self:GetStoredInfo().Bore)
						RunConsoleCommand("SSEM_Engine_Stroke", self:GetStoredInfo().Stroke)
						RunConsoleCommand("SSEM_Engine_Cylinders", self:GetStoredInfo().Cylinders)
						RunConsoleCommand("SSEM_Engine_Airflow", self:GetStoredInfo().Airflow)
						RunConsoleCommand("SSEM_Engine_Idle", self:GetStoredInfo().Idle)
						RunConsoleCommand("SSEM_Engine_Redline", self:GetStoredInfo().Redline)
						RunConsoleCommand("SSEM_Engine_FlywheelMass", self:GetStoredInfo().FlywheelMass)
						RunConsoleCommand("SSEM_Engine_Gearbox_FinalDrive", self:GetStoredInfo().GearboxFinal)
						RunConsoleCommand("SSEM_Engine_Gearbox_Ratios", self:GetStoredInfo().GearboxRatio)
						RunConsoleCommand("SSEM_Engine_Sound_EngineOn", self:GetStoredInfo().SoundOn)
						RunConsoleCommand("SSEM_Engine_Sound_EngineOff", self:GetStoredInfo().SoundOff)
						RunConsoleCommand("SSEM_Engine_Sound_EngineStarter", self:GetStoredInfo().Starter)
						RunConsoleCommand("SSEM_Engine_Configuration", self:GetStoredInfo().Config)
	end
end

function ENT:TriggerInput(iname, value)
	if iname == "WHEELS" then
		self.Flywheel = value
	elseif iname == "Ignition" then
		if value > 0 then
			if self.Engine_Ignition == 0 then
				self.Engine_Ignition = 1
			end
			
			if self.Engine_Ignition == 1 and self.Engine_Active then
				self.Engine_Ignition = 0
			end
		end

		if self.Engine_Ignition == 1 and not self.Engine_Active then
			self.Engine_Ignition = 2
		end
		
		if self.Engine_Ignition == 2 and value <= 0 then
			self.Engine_Ignition = 1
		end
	elseif iname == "Throttle" then
		self.Key_W = clamp(value, 0, 1)
	elseif iname == "Brake" then
		self.Key_S = clamp(value, 0, 1)
	elseif iname == "Clutch" then
		self.Key_Sp = clamp(value, 0, 1)
	elseif iname == "Gear" then
		self:ShiftGear(value)
	elseif iname == "ShiftUp" and value ~= 0 then
		self:ShiftGear(self.Gearbox_Gear + 1)
	elseif iname == "ShiftDown" and value ~= 0 then
		self:ShiftGear(self.Gearbox_Gear - 1)
	end


SoundEngineOnEX = ""
SoundEngineOffEX = ""
if (self.SoundEngineOn != nil) then
	SoundEngineOnEX = self.SoundEngineOn
end
if (self.SoundEngineOff != nil) then
	SoundEngineOffEX = self.SoundEngineOff
end
--Engine Sound Creation and Refreshing for when updated :)
		if not self.CSoundEngineOn then
				self.CSoundEngineOn = CreateSound(self, SoundEngineOnEX)
				self.CSoundEngineOn:PlayEx(0, 100)
			end


		if not self.CSoundEngineOff then
				self.CSoundEngineOff = CreateSound(self, SoundEngineOffEX)
				self.CSoundEngineOff:PlayEx(0, 100)
			end

		if not self.SoundStart then
				self.SoundStart	 = CreateSound(self, Engine_Starter)
				self.SoundStart:PlayEx(0, 100)
			end

end


