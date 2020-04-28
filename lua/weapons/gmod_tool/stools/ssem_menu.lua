TOOL.Category		= "SSEM Menu"
TOOL.Name			= "#tool.ssem_menu.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

cleanup.Register( "SSEM_Custom_Engine" )

if CLIENT then
	
	language.Add( "tool.ssem_menu.name", "SSEM Menu" )
    language.Add( "tool.ssem_menu.desc", "Spawns a Simulated Engine!" )
    language.Add( "tool.ssem_menu.0", "Primary: Spawn Engine, Reload: Open creation window" )
    language.Add( "SBoxLimit_SSEM_Custom_Engines", "Maximum SSEM Custom Engines Reached!" )


    --ENGINE CONVARS-- DONT TOUCH!
    CreateConVar( "SSEM_Engine_Bore", "60", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Stroke", "60", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Cylinders", "4", FCVAR_USERINFO)
    --CreateConVar( "SSEM_Engine_Airflow", "0", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Idle", "850", FCVAR_USERINFO)
    CreateConVar( "SSEM_EngineRevCalcOverwriteVal", "1", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Redline", "9200", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_FlywheelMass", "8", FCVAR_USERINFO)
    CreateConVar( "SSEM_Engine_Configuration", "0", FCVAR_USERINFO)


    
end

-- Moved to up here to not pollute _G
local function MakeEngine(trace, ply, Engine_Bore, Engine_Stroke, Engine_Cylinders, Engine_Airflow, Engine_Idle, Engine_IdleRev, Engine_RevLimiterOverwrite, Engine_Redline, Engine_FlywheelMass, Engine_Displacement, Engine_Configuration) 
	--Setting Up Engine Values--
	local SSEMEngine = ents.Create("ssem_engine")
	if (!SSEMEngine:IsValid()) then return false end
	--Setting Pos, Ang and owner--
	SSEMEngine:SetPos(trace.HitPos - trace.HitNormal + Vector(0, 0, 10))
	SSEMEngine:SetAngles(Angle(0, ply:GetAngles()[2] + 90, 0))
	SSEMEngine:SetPlayer(ply)
	SSEMEngine:SetColor(Color(144,144,144,255))
	SSEMEngine:DrawShadow(true)
	SSEMEngine:Setup(Engine_Bore, Engine_Stroke, Engine_Cylinders, Engine_Airflow, Engine_Idle, Engine_IdleRev, Engine_RevLimiterOverwrite, Engine_Redline, Engine_FlywheelMass, Engine_Displacement, Engine_Configuration)
	
	-- Done insude ENT:Setup
	-- SSEMEngine:SetBore(Engine_Bore)
	-- SSEMEngine:SetStroke(Engine_Stroke)
	-- SSEMEngine:SetCylinders(Engine_Cylinders)
	-- SSEMEngine:SetAirflow(Engine_Airflow)
	-- SSEMEngine:SetIdle(Engine_Idle)
	-- SSEMEngine:SetIdleRev(Engine_IdleRev)
	-- SSEMEngine:SetRevCalcOverwrite(Engine_RevLimiterOverwrite)
	-- SSEMEngine:SetRedline(Engine_Redline)
	-- SSEMEngine:SetFlywheelMass(Engine_FlywheelMass)
	-- SSEMEngine:SetDisplacement(Engine_Displacement)
	-- SSEMEngine:SetEngineConfig(Engine_Configuration)

	-- --Choosing model--
	-- if(Engine_Configuration == 1 && Engine_Cylinders < 5)then
	-- 	SSEMEngine:SetModel("models/sem/engines/sem_v4.mdl")
	-- elseif(Engine_Configuration == 1 && Engine_Cylinders < 7)then
	-- 	SSEMEngine:SetModel("models/sem/engines/sem_v6.mdl")
	-- elseif(Engine_Configuration == 1 && Engine_Cylinders < 9)then
	-- 	SSEMEngine:SetModel("models/sem/engines/sem_v8.mdl")
	-- elseif(Engine_Configuration == 1 && Engine_Cylinders < 11)then
	-- 	SSEMEngine:SetModel("models/sem/engines/sem_v10.mdl")
	-- elseif(Engine_Configuration == 1 && Engine_Cylinders > 11)then
	-- 	SSEMEngine:SetModel("models/sem/engines/sem_v12.mdl")
	-- elseif(Engine_Configuration == 0)then
	-- 	SSEMEngine:SetModel("models/sem/misc/sem_flywheel.mdl")
	-- end  

	
	--SSEMEngine:SetModel("models/sem/engines/sem_v12.mdl")
	--Create Ent--
	SSEMEngine:Spawn()

	--SSEMEngine Physics--
	-- Already done in ENT:Initialize
	-- SSEMEngine:PhysicsInit( SOLID_VPHYSICS )      	
	-- SSEMEngine:SetMoveType( MOVETYPE_VPHYSICS )     	
	-- SSEMEngine:SetSolid( SOLID_VPHYSICS )

	local phys = SSEMEngine:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	--Weight Setting--
	Engine_Mass = math.Round((math.floor(SSEMEngine:GetDisplacement() * 45 + SSEMEngine:GetCylinders() * 4 + math.Clamp(SSEMEngine:GetEngineConfig(), 0, 1) * 10)), 0)
	Engine_Mass = Engine_Mass + SSEMEngine:GetFlywheelMass()
	phys:SetMass(Engine_Mass)

	--Deletion Shit--
	undo.Create("SSEM_Custom_Engine")
		undo.AddEntity( SSEMEngine )
		undo.SetPlayer( ply )
	undo.Finish()
	ply:AddCleanup( "SSEM_Custom_Engine", SSEMEngine )
end

function TOOL:LeftClick( trace, owner )

	if CLIENT then return true end
	
	local ply = self:GetOwner()

	-- Use local variables, dont pollute _G
	local Engine_Bore = ply:GetInfoNum( "SSEM_Engine_Bore" , -1)
	local Engine_Stroke = ply:GetInfoNum( "SSEM_Engine_Stroke" , -1)
	local Engine_Cylinders = ply:GetInfoNum( "SSEM_Engine_Cylinders" , -1)
	local Engine_Airflow = 50
	local Engine_Idle = ply:GetInfoNum( "SSEM_Engine_Idle" , -1)
	local Engine_RevLimiterOverwrite = ply:GetInfoNum( "SSEM_Engine_RevLimiterOverwrite" , -1)
	local Engine_Redline = ply:GetInfoNum( "SSEM_Engine_Redline" , -1)
	local Engine_FlywheelMass = ply:GetInfoNum( "SSEM_Engine_FlywheelMass" , -1)
	local Engine_Displacement = ply:GetInfoNum( "SSEM_Engine_Displacement" , -1)
	local Engine_Configuration = ply:GetInfoNum( "SSEM_Engine_Configuration" , -1)

	local SSEMEngine = MakeEngine(trace, ply, Engine_Bore, Engine_Stroke, Engine_Cylinders, Engine_Airflow, Engine_Idle, Engine_IdleRev, Engine_RevLimiterOverwrite, Engine_Redline, Engine_FlywheelMass, Engine_Displacement, Engine_Configuration)
	if not IsValid(SSEMEngine) then return end	
end




function TOOL:RightClick( trace )
	if CLIENT then return end
	
end

function TOOL:Reload( trace )
if CLIENT then return false end
	local ply = self:GetOwner()
	--concommand.Run(ply, "ssem_menu_open")
	ply:ConCommand( "ssem_menu_open" )
end


function TOOL.BuildCPanel( CPanel )
	CPanel:AddControl( "Header", { Text = "#tool.ssem_menu.name", Description	= "#tool.ssem_menu.desc" })
end


--function ENT:Draw()
--	self:DrawModel()
--end


--duplicator.RegisterEntityClass("gmod_wire_realmagnet", MakeWireMagnet, "Pos", "Len", "Strength", "TargetOnlyMetal", "Model", "PropFilter", "On" )
--This is what I need for duplicator work!