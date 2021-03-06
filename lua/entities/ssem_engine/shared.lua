ENT.Type           = "anim"
ENT.Base           = "base_wire_entity"

ENT.PrintName      = "ssem_engine"
ENT.Author         = "Summer"
ENT.Contact        = ""
ENT.Purpose        = ""
ENT.Instructions   = ""

ENT.Spawnable      = false
ENT.AdminOnly      = false


--Bore
function ENT:SetBore(Engine_Bore) self:GetTable().BoreVal = Engine_Bore end
function ENT:GetBore() return self:GetTable().BoreVal end
--Stroke
function ENT:SetStroke(Engine_Stroke) self:GetTable().StrokeVal = Engine_Stroke end
function ENT:GetStroke() return self:GetTable().StrokeVal end
--Piston
function ENT:SetCylinders(Engine_Cylinders) self:GetTable().CylinderVal = Engine_Cylinders end
function ENT:GetCylinders() return self:GetTable().CylinderVal end
--Airflow
function ENT:SetAirflow(Engine_Airflow) self:GetTable().AirflowVal = Engine_Airflow end
function ENT:GetAirflow() return self:GetTable().AirflowVal end
--Idle
function ENT:SetIdle(Engine_Idle) self:GetTable().IdleVal = Engine_Idle end
function ENT:GetIdle() return self:GetTable().IdleVal end
--RevCalcOverwrite
function ENT:SetRevCalcOverwrite(Engine_RevLimiterOverwrite) self:GetTable().RevCalcOverwriteVal = Engine_RevLimiterOverwrite end
function ENT:GetRevCalcOverwrite() return self:GetTable().RevCalcOverwriteVal end
--Redline
function ENT:SetRedline(Engine_Redline) self:GetTable().RedlineVal = Engine_Redline end
function ENT:GetRedline() return self:GetTable().RedlineVal end
--Flywheel
function ENT:SetFlywheelMass(Engine_FlywheelMass) self:GetTable().FlywheelMassVal = Engine_FlywheelMass end
function ENT:GetFlywheelMass() return self:GetTable().FlywheelMassVal end
-- Set internally
-- --Displacement
function ENT:SetDisplacement(Engine_Displacement)  end
function ENT:GetDisplacement() return self.Engine_Displacement end
--Engine Config
function ENT:SetEngineConfig(Engine_Configuration) self:GetTable().EngineConfig = Engine_Configuration end
function ENT:GetEngineConfig() return self:GetTable().EngineConfig end
--Cuts a corner by saving the entire table instead of using 20 million commands, bless
--Could consolidate this entire area down into just getting info table, writing and saving when needed. Might do at a later date!
function ENT:StoreInfo(Engine_Info) self:GetTable().EngineInfoTable = Engine_Info end
function ENT:GetStoredInfo() return self:GetTable().EngineInfoTable end
