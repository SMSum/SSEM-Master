TOOL.Category		= "SSEM Menu"
TOOL.Name			= "#tool.ssem_menu.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""


--THINGS TO DO--




if CLIENT then
	
	language.Add( "tool.ssem_menu.name", "SSEM Menu" )
    language.Add( "tool.ssem_menu.desc", "Spawns a Simulated Engine!" )
    language.Add( "SBoxLimit_SSEM_Custom_Engines", "Maximum SSEM Custom Engines Reached!" )


TOOL.Information = {}
local function ToolInfo(name, desc)
    table.insert(TOOL.Information, { name = name })
    language.Add("tool.ssem_menu." .. name, desc)
end

-- Info
ToolInfo("info_1", "Spawns a Simulated Engine, currently no UI. Use the console ConVars to edit engine settings.")
-- left click
ToolInfo("left_1", "Spawn an engine")
-- Right click
ToolInfo("right_1", "Update an engine")
-- Use 
ToolInfo("use_1", "Copy engine data to console ConVars")

    --ENGINE CONVARS-- DONT TOUCH!
    --Base Config is a Toyota 4AGE
    CreateConVar( "SSEM_Engine_Bore", "81", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Stroke", "77", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Cylinders", "4", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Airflow", "90", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Idle", "850", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Redline", "7600", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_FlywheelMass", "8", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Gearbox_FinalDrive", "-4.300", FCVAR_USERINFO) 
    CreateConVar( "SSEM_Engine_Gearbox_Ratios", "3.587,2.022,1.384,1.000,0.861,-5.85", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Sound_EngineOn", "acf_extra/vehiclefx/engines/fsp/i4_honda_B18C5.wav", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Sound_EngineOff", "acf_extra/vehiclefx/engines/l4/ae86_2000rpm.wav", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Sound_EngineStarter", "acf_extra/vehiclefx/starters/starter2.wav", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Configuration", "0", FCVAR_USERINFO) 

    
end

-- Moved to up here to not pollute _G
local function MakeEngine(ply, Pos, Ang, Engine_Bore, Engine_Stroke, Engine_Cylinders, Engine_Airflow, Engine_Idle, Engine_Redline, Engine_FlywheelMass, Engine_Configuration, Gearbox_Finaldrive, Gearbox_Gears, Engine_SoundOn, Engine_SoundOff, Engine_Starter, DupeSpawn) 

	--Setting Up Engine Values--
	local SSEMEngine = ents.Create("ssem_engine")
	if (!SSEMEngine:IsValid()) then return false end
	--Setting Pos, Ang and owner--
	SSEMEngine:SetPos(Pos)
	SSEMEngine:SetAngles(Ang)
	SSEMEngine:SetPlayer(ply)
	SSEMEngine:DrawShadow(true)
	SSEMEngine:Setup(Engine_Bore, Engine_Stroke, Engine_Cylinders, Engine_Airflow, Engine_Idle, Engine_Redline, Engine_FlywheelMass, Engine_Configuration, Gearbox_Finaldrive, Gearbox_Gears, Engine_SoundOn, Engine_SoundOff, Engine_Starter)
	
	--Create Ent--
	SSEMEngine:Spawn() 
	if (DupeSpawn == 0) then
	SSEMEngine:Setup(Engine_Bore, Engine_Stroke, Engine_Cylinders, Engine_Airflow, Engine_Idle, Engine_Redline, Engine_FlywheelMass, Engine_Configuration, Gearbox_Finaldrive, Gearbox_Gears, Engine_SoundOn, Engine_SoundOff, Engine_Starter)
	end
	
	local phys = SSEMEngine:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	--Weight Setting--
	Engine_Mass = math.Round((math.floor(SSEMEngine:GetDisplacement() * 45 + SSEMEngine:GetCylinders() * 4 + math.Clamp(SSEMEngine:GetEngineConfig(), 0, 1) * 10)), 0)
	Engine_Mass = Engine_Mass + SSEMEngine:GetFlywheelMass()
	phys:SetMass(Engine_Mass)

	return SSEMEngine
end


duplicator.RegisterEntityClass("ssem_engine", function(ply, data)
	return MakeEngine(ply, data.Pos, data.Angle, data.EntityMods.engineData.Stroke, data.EntityMods.engineData.Bore, data.EntityMods.engineData.Cylinders, data.EntityMods.engineData.Airflow, data.EntityMods.engineData.Idle, data.EntityMods.engineData.Redline, data.EntityMods.engineData.FlywheelMass, data.EntityMods.engineData.Config, data.EntityMods.engineData.GearboxFinal, data.EntityMods.engineData.GearboxRatio, data.EntityMods.engineData.SoundOn, data.EntityMods.engineData.SoundOff, data.EntityMods.engineData.Starter, 1) --duplicator.GenericDuplicatorFunction(ply, data) true
end, "Data")


function TOOL:LeftClick( trace, owner )

	if CLIENT then return true end
		
	local ply = self:GetOwner()
	--if not ply:CheckLimit("ssem_engine") then return false end

	-- Use local variables, dont pollute _G
	local Engine_Bore = ply:GetInfoNum( "SSEM_Engine_Bore" , -1)
	local Engine_Stroke = ply:GetInfoNum( "SSEM_Engine_Stroke" , -1)
	local Engine_Cylinders = ply:GetInfoNum( "SSEM_Engine_Cylinders" , -1)
	local Engine_Airflow = ply:GetInfoNum( "SSEM_Engine_Airflow" , -1)
	local Engine_Idle = ply:GetInfoNum( "SSEM_Engine_Idle" , -1)
	local Engine_Redline = ply:GetInfoNum( "SSEM_Engine_Redline" , -1)
	local Engine_FlywheelMass = ply:GetInfoNum( "SSEM_Engine_FlywheelMass" , -1)
	local Engine_Configuration = ply:GetInfoNum( "SSEM_Engine_Configuration" , -1) 


	local Gearbox_Finaldrive = ply:GetInfoNum( "SSEM_Engine_Gearbox_FinalDrive" , -1)
	local Gearbox_Gears = ply:GetInfo( "SSEM_Engine_Gearbox_Ratios" , -1)

	local Engine_SoundOn = ply:GetInfo( "SSEM_Engine_Sound_EngineOn", -1)
	local Engine_SoundOff = ply:GetInfo( "SSEM_Engine_Sound_EngineOff", -1)
	local Engine_Starter = ply:GetInfo( "SSEM_Engine_Sound_EngineStarter", -1)

	local Pos = trace.HitPos - trace.HitNormal + Vector(0, 0, 10)
	local Ang = Angle(0,0,0)
	local SSEMEngine = MakeEngine(ply, Pos, Ang, Engine_Bore, Engine_Stroke, Engine_Cylinders, Engine_Airflow, Engine_Idle, Engine_Redline, Engine_FlywheelMass, Engine_Configuration, Gearbox_Finaldrive, Gearbox_Gears, Engine_SoundOn, Engine_SoundOff, Engine_Starter, 0)
	if not IsValid(SSEMEngine) then return end	

	undo.Create("SSEM Engine")
		undo.AddEntity( SSEMEngine )
		undo.SetPlayer( ply )
	undo.Finish()
	cleanup.Register( "SSEM Engine" )
	ply:AddCleanup( "SSEM Engine", SSEMEngine )

end


function TOOL:RightClick( trace )
	if CLIENT then return end
	if (trace.Entity:GetClass() == "ssem_engine") then
		local caller = self:GetOwner()
		--[[
		if trace.Entity:GetEngineConfig() == 0 && caller:GetInfoNum( "SSEM_Engine_Configuration" , -1) == 1 then
			trace.Entity:SetAngles(trace.Entity:GetAngles() + Angle(0,0,-90))
		end
		if trace.Entity:GetEngineConfig() == 1 && caller:GetInfoNum( "SSEM_Engine_Configuration" , -1) == 0 then
			trace.Entity:SetAngles(trace.Entity:GetAngles() + Angle(0,0,90))
		end
		]]--
		trace.Entity:Setup(caller:GetInfoNum( "SSEM_Engine_Bore" , -1), caller:GetInfoNum( "SSEM_Engine_Stroke" , -1), caller:GetInfoNum( "SSEM_Engine_Cylinders" , -1), caller:GetInfoNum( "SSEM_Engine_Airflow" , -1), caller:GetInfoNum( "SSEM_Engine_Idle" , -1), caller:GetInfoNum( "SSEM_Engine_Redline" , -1), caller:GetInfoNum( "SSEM_Engine_FlywheelMass" , -1), caller:GetInfoNum( "SSEM_Engine_Configuration" , -1), caller:GetInfoNum( "SSEM_Engine_Gearbox_FinalDrive" , -1), caller:GetInfo( "SSEM_Engine_Gearbox_Ratios" , -1), caller:GetInfo( "SSEM_Engine_Sound_EngineOn", -1), caller:GetInfo( "SSEM_Engine_Sound_EngineOff", -1), caller:GetInfo( "SSEM_Engine_Sound_EngineStarter", -1), 0)
		trace.Entity:ShowOutput()

		
		-- Set new mass if updated :)
		Engine_Mass = math.Round((math.floor(trace.Entity:GetDisplacement() * 45 + trace.Entity:GetCylinders() * 4 + math.Clamp(trace.Entity:GetEngineConfig(), 0, 1) * 10)), 0)
		Engine_Mass = Engine_Mass + trace.Entity:GetFlywheelMass()
		trace.Entity:GetPhysicsObject():SetMass(Engine_Mass)
	end
		
end

function TOOL:Reload( trace )
if CLIENT then return false end
	local ply = self:GetOwner()
	--Disabled until UI is made
	--concommand.Run(ply, "ssem_menu_open")
	--ply:ConCommand( "ssem_menu_open" )
end


function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Text = "#tool.ssem_menu.name", Description	= "#tool.ssem_menu.desc" })
end


