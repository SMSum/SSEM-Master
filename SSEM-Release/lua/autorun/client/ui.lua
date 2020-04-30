local ply = LocalPlayer()


function ssem_frame_create() 

	local uiSizeW = ScrW() / 1.05
	local uiSizeH = ScrH() / 1.05
	local panelSizeW = uiSizeW / 6
	local panelSizeH = uiSizeH / 2

	currentPage = 1
	Engine_UI_Configuration = -1
--Main Menu Frame--
	menuFrame = vgui.Create("DFrame")
	menuFrame:SetPos(ScrW() - (ScrW() / 2) - (uiSizeW / 2), ScrH() / 2 - (uiSizeH / 2))
	menuFrame:SetSize(uiSizeW ,uiSizeH)
	menuFrame:SetTitle("SSEM Menu")
	menuFrame.lblTitle:SetContentAlignment(5)
	menuFrame.lblTitle:SetFont("HudHintTextSmall")
	menuFrame:SetVisible(false) 
	menuFrame:SetDraggable(true)
	menuFrame:SetBackgroundBlur(true)
	menuFrame.btnMinim:SetVisible( false )
	menuFrame.btnClose.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125,125,125,255))
		if (self:IsDown()) then
			draw.RoundedBox(0, 0, 0, w, h, Color(100,100,100,255))
		end
	end
	menuFrame.btnClose:SetText("X")
	menuFrame.btnClose:SetFont("HudHintTextSmall")	
	menuFrame.btnClose:SetTextColor(Color(255,255,255))
	menuFrame.btnMaxim:SetVisible( false )
	menuFrame:MakePopup()
	menuFrame.OnClose = function() 
		ssem_frame_create()
	end
	menuFrame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50,50,50,225))
	end

--Back Button--
	menuBackButton = vgui.Create( "DButton", menuFrame) 
	menuBackButton:SetText( "Back" )					
	menuBackButton:SetPos( 5, panelSizeH + (panelSizeH - 35))					
	menuBackButton:SetSize( 250, 30 )	
	menuBackButton:SetVisible(false)	
	menuBackButton:SetTextColor(Color(255,255,255))
	menuBackButton:SetFont("HudHintTextSmall")		
	menuBackButton.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125,125,125,255))
		if (self:IsDown()) then
			draw.RoundedBox(0, 0, 0, w, h, Color(100,100,100,255))
		end

	end		
	menuBackButton.DoClick = function()				
		currentPage = currentPage - 1
		PageChanger(currentPage)
		PageNumber:SetText( currentPage )
		surface.PlaySound("buttons/lightswitch2.wav")
	end

--Forward Button--
	menuForwardButton = vgui.Create( "DButton", menuFrame) 
	menuForwardButton:SetText( "Next" )					
	menuForwardButton:SetPos(uiSizeW - 255, panelSizeH + (panelSizeH - 35))					
	menuForwardButton:SetSize( 250, 30 )	
	menuForwardButton:SetVisible(true)	
	menuForwardButton:SetTextColor(Color(255,255,255))	
	menuForwardButton:SetFont("HudHintTextSmall")	
	menuForwardButton.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125,125,125,255))
		if (self:IsDown()) then
			draw.RoundedBox(0, 0, 0, w, h, Color(100,100,100,255))
		end
		if (self:GetDisabled()) then
			draw.RoundedBox(0, 0, 0, w, h, Color(100,0,0,255))
		end

	end		
	menuForwardButton.DoClick = function()				
		currentPage = currentPage + 1
		PageChanger(currentPage)
		PageNumber:SetText( currentPage )
		surface.PlaySound("buttons/lightswitch2.wav")
	end

--Creation Button--
	menuCreateButton = vgui.Create( "DButton", menuFrame) 
	menuCreateButton:SetText( "Create" )					
	menuCreateButton:SetPos(uiSizeW - 255, panelSizeH + (panelSizeH - 35))					
	menuCreateButton:SetSize( 250, 30 )	
	menuCreateButton:SetVisible(false)		
	menuCreateButton:SetTextColor(Color(255,255,255))	
	menuCreateButton.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125,125,125,255))
		if (self:IsDown()) then
			draw.RoundedBox(0, 0, 0, w, h, Color(100,100,100,255))
		end
	end		
	menuCreateButton.DoClick = function()				
		timer.Simple(0.25, function() menuFrame:Close() end)
		surface.PlaySound("buttons/lever6.wav") 
		ssem_engine_info_push()
	end

--Page Number--
	PageNumber = vgui.Create( "DLabel", menuFrame )
	PageNumber:SetPos(uiSizeW - (uiSizeW / 2) - 5, panelSizeH + (panelSizeH - 25))	
	PageNumber:SetText( currentPage )

---------------------------------------------------------------PAGE ONE-----------------------------------------------------------------
	menuForwardButton:SetDisabled(true)
	--Engine Icon--
	menuInlineEngineIcon = vgui.Create( "DModelPanel", menuFrame )
	menuInlineEngineIcon:SetSize( 250, 250 )
	menuInlineEngineIcon:SetPos((uiSizeW/4) - 125, panelSizeH - panelSizeH/2)
	menuInlineEngineIcon:SetVisible(true)
	menuInlineEngineIcon:SetModel( "models/sem/misc/sem_flywheel.mdl" )

				local mn, mx = menuInlineEngineIcon.Entity:GetRenderBounds()
				local size = 20
				size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
				size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
				size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

				menuInlineEngineIcon:SetFOV( 75 )
				menuInlineEngineIcon:SetCamPos( Vector( size, size, size * 0.5) )
				menuInlineEngineIcon:SetLookAt( ( mn + mx ) * 0.2 )

	menuInlineEngineIcon.DoClick = function(self, w, h)	
				Engine_UI_Configuration = 0
				FOVChanger(0)
				menuForwardButton:SetDisabled(false)
	end



	--Engine Icon Text--				
	menuInlineEngineIconText = vgui.Create( "DLabel", menuFrame )
	menuInlineEngineIconText:SetPos((uiSizeW/4) - 125 + 80, panelSizeH - (panelSizeH/2) + 200)
	menuInlineEngineIconText:SetFont("HudHintTextLarge")
	menuInlineEngineIconText:SetSize(150, 50)
	menuInlineEngineIconText:SetText( "Inline Engine" )
	--Engine Icon--
	menuVEngineIcon = vgui.Create( "DModelPanel", menuFrame )
	menuVEngineIcon:SetSize( 250, 250 )
	menuVEngineIcon:SetPos((uiSizeW - uiSizeW/4) - 125, panelSizeH - panelSizeH/2)
	menuVEngineIcon:SetVisible(true)
	menuVEngineIcon:SetModel( "models/sem/engines/sem_v8.mdl" )

				local mn, mx = menuVEngineIcon.Entity:GetRenderBounds()
				local size = 20
				size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
				size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
				size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

				menuVEngineIcon:SetFOV( 75 )
				menuVEngineIcon:SetCamPos( Vector( size, size, size * 0.5) )
				menuVEngineIcon:SetLookAt( ( mn + mx ) * 0.2 )		


	menuVEngineIcon.DoClick = function(self, w, h)	
		Engine_UI_Configuration = 1
		FOVChanger(1)
		menuForwardButton:SetDisabled(false)
	end



	--Engine Icon Text--		
	menuVEngineIconText = vgui.Create( "DLabel", menuFrame )
	menuVEngineIconText:SetPos((uiSizeW - uiSizeW/4) - 125/4, panelSizeH - (panelSizeH/2) + 200)
	menuVEngineIconText:SetFont("HudHintTextLarge")
	menuVEngineIconText:SetSize(150, 50)
	menuVEngineIconText:SetText( "V Engine" )
	--Engine Selection Text--

	menuEngineTypeSelectionText = vgui.Create( "DLabel", menuFrame )
	menuEngineTypeSelectionText:SetPos((uiSizeW - (uiSizeW / 2)) - 150/2, 75)
	menuEngineTypeSelectionText:SetFont("HudHintTextLarge")
	menuEngineTypeSelectionText:SetSize(150, 50)
	menuEngineTypeSelectionText:SetText( "Select an engine type:" )

---------------------------------------------------------------PAGE TWO-----------------------------------------------------------------
--Property Sheet--
local menuPropertySheet = vgui.Create( "DPropertySheet", menuFrame )
menuPropertySheet:SetVisible(false)
menuPropertySheet:DockMargin( 10, 0, 10, 40 )
menuPropertySheet:Dock( FILL )
menuPropertySheet.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(100,100,100,255))
	end
--Engine Panel--
local menuEnginePropertyPanel = vgui.Create( "DPanel", menuPropertySheet )
menuEnginePropertyPanel.Paint = function( self, w, h ) 
	draw.RoundedBox( 4, 0, 0, w, h, Color( 100, 100, 100, self:GetAlpha() ) ) 
end
menuPropertySheet:AddSheet( "Engine", menuEnginePropertyPanel)
menuPropertySheet:GetItems()[1].Tab.Paint = function( self, w, h ) 
	draw.RoundedBoxEx(0, 0, 0, w, h, Color(125, 125, 125, self:GetAlpha() ),  true, true, false, false)
	end
menuPropertySheet:GetItems()[1].Tab:SetFont("HudHintTextLarge")
----------------------------------------------------------------------------------------------

--Cylinder Count--
local menuEngineCylinderNumberValue = vgui.Create("DNumberWang", menuEnginePropertyPanel)
menuEngineCylinderNumberValue:SetVisible(true)
menuEngineCylinderNumberValue:SetSize(100, 25)
menuEngineCylinderNumberValue:SetPos( 175, 50  )
menuEngineCylinderNumberValue:SetMinMax(1,48)
menuEngineCylinderNumberValue:SetValue(ply:GetInfoNum( "SSEM_Engine_Cylinders" , -1))
function menuEngineCylinderNumberValue:OnEnter()
	if menuEngineCylinderNumberValue:GetValue() < 1 then
		print("Error would go here")
	end
	ssem_engine_calc_func()
end

local menuEngineCylinderNumberText = vgui.Create("DLabel", menuEnginePropertyPanel)
menuEngineCylinderNumberText:SetText("Cylinders")
menuEngineCylinderNumberText:SetPos( 15, 50  )
menuEngineCylinderNumberText:SetSize(150, 25)
menuEngineCylinderNumberText:SetTextColor(Color(255,255,255))
menuEngineCylinderNumberText:SetContentAlignment(5)
menuEngineCylinderNumberText:SetFont("HudHintTextLarge")

--Bore Count--
local menuEngineBoreNumberValue = vgui.Create("DNumberWang", menuEnginePropertyPanel)
menuEngineBoreNumberValue:SetVisible(true)
menuEngineBoreNumberValue:SetSize(100, 25)
menuEngineBoreNumberValue:SetPos( 175, 100  )
menuEngineBoreNumberValue:SetMinMax(1,500)
menuEngineBoreNumberValue:SetValue(ply:GetInfoNum( "SSEM_Engine_Bore" , -1))
function menuEngineBoreNumberValue:OnEnter()
	if menuEngineBoreNumberValue:GetValue() < 1 then
		print("Error would go here")
	end
	ssem_engine_calc_func()
end

local menuEngineBoreNumberText = vgui.Create("DLabel", menuEnginePropertyPanel)
menuEngineBoreNumberText:SetText("Bore (mm)")
menuEngineBoreNumberText:SetPos( 15, 100  )
menuEngineBoreNumberText:SetSize(150, 25)
menuEngineBoreNumberText:SetTextColor(Color(255,255,255))
menuEngineBoreNumberText:SetContentAlignment(5)
menuEngineBoreNumberText:SetFont("HudHintTextLarge")

--Stroke Count--
local menuEngineStrokeNumberValue = vgui.Create("DNumberWang", menuEnginePropertyPanel)
menuEngineStrokeNumberValue:SetVisible(true)
menuEngineStrokeNumberValue:SetSize(100, 25)
menuEngineStrokeNumberValue:SetPos( 175, 150 )
menuEngineStrokeNumberValue:SetMinMax(1,500)
menuEngineStrokeNumberValue:SetValue(ply:GetInfoNum( "SSEM_Engine_Stroke" , -1))
function menuEngineStrokeNumberValue:OnEnter()
	if menuEngineStrokeNumberValue:GetValue() < 1 then
		print("Error would go here")
	end
	ssem_engine_calc_func()
end

local menuEngineStrokeNumberText = vgui.Create("DLabel", menuEnginePropertyPanel)
menuEngineStrokeNumberText:SetText("Stroke (mm)")
menuEngineStrokeNumberText:SetPos( 15, 150  )
menuEngineStrokeNumberText:SetSize(150, 25)
menuEngineStrokeNumberText:SetTextColor(Color(255,255,255))
menuEngineStrokeNumberText:SetContentAlignment(5)
menuEngineStrokeNumberText:SetFont("HudHintTextLarge")
--Idle Count--
local menuEngineIdleNumberValue = vgui.Create("DNumberWang", menuEnginePropertyPanel)
menuEngineIdleNumberValue:SetVisible(true)
menuEngineIdleNumberValue:SetSize(100, 25)
menuEngineIdleNumberValue:SetPos( 175, 200  )
menuEngineIdleNumberValue:SetMinMax(1,2000)
menuEngineIdleNumberValue:SetValue(ply:GetInfoNum( "SSEM_Engine_Idle" , -1))
function menuEngineIdleNumberValue:OnEnter()
	if menuEngineIdleNumberValue:GetValue() < 1 then
		print("Error would go here")
	end
	ssem_engine_calc_func()
end

local menuEngineIdleNumberText = vgui.Create("DLabel", menuEnginePropertyPanel)
menuEngineIdleNumberText:SetText("Idle RPM")
menuEngineIdleNumberText:SetPos( 15, 200  )
menuEngineIdleNumberText:SetSize(150, 25)
menuEngineIdleNumberText:SetTextColor(Color(255,255,255))
menuEngineIdleNumberText:SetContentAlignment(5)
menuEngineIdleNumberText:SetFont("HudHintTextLarge")
--Redline Count--
local menuEngineRedlineNumberValue = vgui.Create("DNumberWang", menuEnginePropertyPanel)
menuEngineRedlineNumberValue:SetVisible(true)
menuEngineRedlineNumberValue:SetSize(100, 25)
menuEngineRedlineNumberValue:SetPos( 175, 250  )
menuEngineRedlineNumberValue:SetMinMax(1,20000)
menuEngineRedlineNumberValue:SetValue(ply:GetInfoNum( "SSEM_Engine_Redline" , -1))
function menuEngineRedlineNumberValue:OnEnter()
	if menuEngineRedlineNumberValue:GetValue() < 1 then
		print("Error would go here")
	end
	ssem_engine_calc_func()
end

local menuEngineRedlineNumberText = vgui.Create("DLabel", menuEnginePropertyPanel)
menuEngineRedlineNumberText:SetText("Redline RPM")
menuEngineRedlineNumberText:SetPos( 15, 250  )
menuEngineRedlineNumberText:SetSize(150, 25)
menuEngineRedlineNumberText:SetTextColor(Color(255,255,255))
menuEngineRedlineNumberText:SetContentAlignment(5)
menuEngineRedlineNumberText:SetFont("HudHintTextLarge")

--Flywheel Count--
local menuEngineFlywheelNumberValue = vgui.Create("DNumberWang", menuEnginePropertyPanel)
menuEngineFlywheelNumberValue:SetVisible(true)
menuEngineFlywheelNumberValue:SetSize(100, 25)
menuEngineFlywheelNumberValue:SetPos( 175, 300  )
menuEngineFlywheelNumberValue:SetMinMax(1,20000)
menuEngineFlywheelNumberValue:SetValue(ply:GetInfoNum( "SSEM_Engine_FlywheelMass" , -1))
function menuEngineFlywheelNumberValue:OnEnter()
	if menuEngineFlywheelNumberValue:GetValue() < 1 then
		print("Error would go here")
	end
	ssem_engine_calc_func()
end

local menuEngineFlywheelNumberText = vgui.Create("DLabel", menuEnginePropertyPanel)
menuEngineFlywheelNumberText:SetText("Flywheel Mass (Kg)")
menuEngineFlywheelNumberText:SetPos( 15, 300  )
menuEngineFlywheelNumberText:SetSize(150, 25)
menuEngineFlywheelNumberText:SetTextColor(Color(255,255,255))
menuEngineFlywheelNumberText:SetContentAlignment(5)
menuEngineFlywheelNumberText:SetFont("HudHintTextLarge")

---------------------------------------------------------------PAGE THREE---------------------------------------------------------------
---------------------------------------------------------------PAGE FOUR----------------------------------------------------------------
---------------------------------------------------------------PAGE FIVE----------------------------------------------------------------
---------------------------------------------------------------PAGE SIX-----------------------------------------------------------------


----------------------------------------------------------PAGE CHANGE FUNCTION----------------------------------------------------------
function PageChanger(n) 
	--Button Removal--
		if (n > 1) then menuBackButton:SetVisible(true) end
		if(n >= 6) then 
			menuForwardButton:SetVisible(false) 
			menuCreateButton:SetVisible(true) 
		end
		if (n <= 1) then menuBackButton:SetVisible(false) end
		if (n >=1) then menuForwardButton:SetVisible(true) end
		if (n < 6) then menuCreateButton:SetVisible(false) end
	--PAGE ONE--
		if (currentPage != 1) then 
			menuInlineEngineIcon:SetVisible(false) 
			menuVEngineIcon:SetVisible(false) 
			menuInlineEngineIconText:SetVisible(false) 
			menuVEngineIconText:SetVisible(false)
			menuEngineTypeSelectionText:SetVisible(false)
		else 
			menuInlineEngineIcon:SetVisible(true) 
			menuVEngineIcon:SetVisible(true) 
			menuInlineEngineIconText:SetVisible(true) 
			menuVEngineIconText:SetVisible(true)
			menuEngineTypeSelectionText:SetVisible(true)
		end
	--PAGE TWO--
		if (currentPage == 2) then 
			menuPropertySheet:SetVisible(true)
		else 
			menuPropertySheet:SetVisible(false)
		end

end

function FOVChanger(n)
	if (n == 0) then	
			menuInlineEngineIcon:SetFOV( 55 )
			menuVEngineIcon:SetFOV(95)
	end
	if (n == 1) then
			menuInlineEngineIcon:SetFOV( 95 )
			menuVEngineIcon:SetFOV(55)	
	end
end

--[[
--Engine Selection List--

	EngineMDLString = "models/props_c17/canister_propane01a.mdl" --Setting Default MDL


--Icon Panel--

	EngineIconPanel = vgui.Create( "DPanel", ssemui )
	EngineIconPanel:SetPos( panelSizeW, panelSizeH )
	EngineIconPanel:SetPos(panelSizeW, panelSizeH)
	EngineIconPanel:SetSize( panelSizeW, panelSizeH )
	EngineIconPanel:SetBackgroundColor( PanelBackgroundColor )

--Engine Icon--

	EngineIcon = vgui.Create( "DModelPanel", EngineIconPanel )
	EngineIcon:SetSize( panelSizeW, panelSizeH )

	

--Engine Type List--

	EngineTypeList = vgui.Create( "DListView", ssemui )
	EngineTypeList:SetSize( panelSizeW, panelSizeH )
	EngineTypeList:SetPos(panelSizeW / 8, panelSizeH / 6)
	EngineTypeList:SetMultiSelect( false )
	EngineTypeList:AddColumn( "Engine Type" )
	EngineTypeList:AddLine( "Inline", "models/sem/misc/sem_flywheel.mdl", 0)
	EngineTypeList:AddLine( "V-Engine", "models/sem/engines/sem_v4.mdl", 1)
	EngineTypeList:SetBackgroundColor( PanelBackgroundColor )

--Engine Data List--

		EngineDataList = vgui.Create( "DListView", ssemui )
		EngineDataList:SetVisible(false)
		EngineDataList:SetSize( panelSizeW, panelSizeH )
		EngineDataList:SetPos(panelSizeW + (panelSizeW / 6) , panelSizeH / 6)
		EngineDataList:SetMultiSelect( false )
		EngineDataList:AddColumn( "Select an item" )
		EngineDataList:AddLine( "Engine")
		EngineDataList:AddLine( "Gearbox")
		EngineDataList:AddLine( "Fuel")

--Engine Image Refresh--

		EngineTypeList.OnRowSelected = function( lst, index, pnl )
				EngineConfigurationNum = pnl:GetColumnText( 3 ) 
				EngineMDLString = pnl:GetColumnText( 2 ) 
				EngineIcon:SetModel( EngineMDLString )

				local mn, mx = EngineIcon.Entity:GetRenderBounds()
				local size = 20
				size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
				size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
				size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

				EngineIcon:SetFOV( 45 )
				EngineIcon:SetCamPos( Vector( size, size, size ) )
				EngineIcon:SetLookAt( ( mn + mx ) * 0.2 )
				print(pnl:GetColumnText( 2 ) )
				EngineDataList:SetVisible(true)
	end

	


	--Engine Slider Panel--
	EngineSliderPanel = vgui.Create( "DPanel", ssemui )
	EngineSliderPanel:SetPos(panelSizeW * 2.25 , panelSizeH / 6 ) 
	EngineSliderPanel:SetSize( panelSizeW * 3.5, panelSizeH * 3.5 )
	EngineSliderPanel:SetVisible(false)
	EngineSliderPanel:SetBackgroundColor( PanelBackgroundColor )

	--Engine Create DButton--
	EngineCreateDButton = vgui.Create( "DButton", ssemui) 
	EngineCreateDButton:SetText( "Create!" )					
	EngineCreateDButton:SetPos( panelSizeW + (panelSizeW / 2), panelSizeH + (panelSizeH - 30))					
	EngineCreateDButton:SetSize( 250, 30 )	
	EngineCreateDButton:SetVisible(false)				
	EngineCreateDButton.DoClick = function()				
		ssem_engine_array_push()	
		timer.Simple(0.25, function() ssemui:Close() end)
		surface.PlaySound("buttons/lever6.wav")
	end


										--Engine DLabels For Information--
											--Engine Displacement--
											EngineDisplacementDLabel = vgui.Create( "DLabel", EngineSliderPanel )
											EngineDisplacementDLabel:SetPos( 0, 225 )
											EngineDisplacementDLabel:SetSize( panelSizeW * 3, 25 )
											EngineDisplacementDLabel:SetText("")
											EngineDisplacementDLabel:SetFont("EngineSpecFont")

											--Engine Peak Torque--
											EnginePeakTorqueDLabel = vgui.Create( "DLabel", EngineSliderPanel )
											EnginePeakTorqueDLabel:SetPos( 0, 250 )
											EnginePeakTorqueDLabel:SetSize( panelSizeW * 3, 25 )
											EnginePeakTorqueDLabel:SetText("")
											EnginePeakTorqueDLabel:SetFont("EngineSpecFont")

											--Engine Redline--
											EngineRedlineDLabel = vgui.Create( "DLabel", EngineSliderPanel )
											EngineRedlineDLabel:SetPos( 0, 275 )
											EngineRedlineDLabel:SetSize( panelSizeW * 3, 25 )
											EngineRedlineDLabel:SetText("")
											EngineRedlineDLabel:SetFont("EngineSpecFont")

											--Engine Flywheel Mass--
											EngineFlywheelDLabel = vgui.Create( "DLabel", EngineSliderPanel )
											EngineFlywheelDLabel:SetPos( 0, 300 )
											EngineFlywheelDLabel:SetSize( panelSizeW * 3, 25 )
											EngineFlywheelDLabel:SetText("")
											EngineFlywheelDLabel:SetFont("EngineSpecFont")

											--Engine Peak HP--
											EnginePeakHPDLabel = vgui.Create( "DLabel", EngineSliderPanel )
											EnginePeakHPDLabel:SetPos( 0, 320 )
											EnginePeakHPDLabel:SetSize( panelSizeW * 3, 25 )
											EnginePeakHPDLabel:SetText("")
											EnginePeakHPDLabel:SetFont("EngineSpecFont")



				--Engine Piston Count Slider--
				EnginePistonSlider = vgui.Create( "DNumSlider", EngineSliderPanel  )
				EnginePistonSlider:SetPos( 0, 10 )			// Set the position
			    EnginePistonSlider:SetSize( panelSizeW * 3.5, 15 )		// Set the size
				EnginePistonSlider:SetText( "Numer Of Pistons" )	// Set the text above the slider
				EnginePistonSlider:SetMin( 1 )				// Set the minimum number you can slide to
				EnginePistonSlider:SetMax( 48 )				// Set the maximum number you can slide to
				EnginePistonSlider:SetDecimals( 0 )			// Decimal places - zero for whole number


				--Engine Bore Slider--
				EngineBoreSlider = vgui.Create( "DNumSlider", EngineSliderPanel  )
				EngineBoreSlider:SetPos( 0,  30 )			// Set the position
			    EngineBoreSlider:SetSize( panelSizeW * 3.5, 15 )	// Set the size
				EngineBoreSlider:SetText( "Engine Bore" )	// Set the text above the slider
				EngineBoreSlider:SetMin( 1 )				// Set the minimum number you can slide to
				EngineBoreSlider:SetMax( 300 )				// Set the maximum number you can slide to
				EngineBoreSlider:SetDecimals( 1 )			// Decimal places - zero for whole number

				--Engine Stroke Slider--
				EngineStrokeSlider = vgui.Create( "DNumSlider", EngineSliderPanel  )
				EngineStrokeSlider:SetPos( 0,  50 )			// Set the position
			    EngineStrokeSlider:SetSize( panelSizeW * 3.5, 15 )		// Set the size
				EngineStrokeSlider:SetText( "Engine Stroke" )	// Set the text above the slider
				EngineStrokeSlider:SetMin( 1 )				// Set the minimum number you can slide to
				EngineStrokeSlider:SetMax( 300 )				// Set the maximum number you can slide to
				EngineStrokeSlider:SetDecimals( 1 )			// Decimal places - zero for whole number

				--Engine Airflow Slider--
				EngineAirflowSlider = vgui.Create( "DNumSlider", EngineSliderPanel  )
				EngineAirflowSlider:SetPos( 0,   70)			// Set the position
			    EngineAirflowSlider:SetSize( panelSizeW * 3.5, 15 )		// Set the size
				EngineAirflowSlider:SetText( "Engine Airflow" )	// Set the text above the slider
				EngineAirflowSlider:SetMin( 1 )				// Set the minimum number you can slide to
				EngineAirflowSlider:SetMax( 300 )				// Set the maximum number you can slide to
				EngineAirflowSlider:SetDecimals( 1 )			// Decimal places - zero for whole number

				--Engine Idle Slider--
				EngineIdleSlider = vgui.Create( "DNumSlider", EngineSliderPanel  )
				EngineIdleSlider:SetPos( 0,   90)			// Set the position
			    EngineIdleSlider:SetSize( panelSizeW * 3.5, 15 )		// Set the size
				EngineIdleSlider:SetText( "Engine Idle RPM" )	// Set the text above the slider
				EngineIdleSlider:SetMin( 1 )				// Set the minimum number you can slide to
				EngineIdleSlider:SetMax( 12000 )				// Set the maximum number you can slide to
				EngineIdleSlider:SetDecimals( 0 )			// Decimal places - zero for whole number

				--Engine Rev Limit Calculate? Slider--
				EngineRevLimCalcOverwriteSlider = vgui.Create( "DNumSlider", EngineSliderPanel  )
				EngineRevLimCalcOverwriteSlider:SetPos( 0,   110)			// Set the position
			    EngineRevLimCalcOverwriteSlider:SetSize( panelSizeW * 3.5, 25 )		// Set the size
				EngineRevLimCalcOverwriteSlider:SetText( "Calculate max RPM? \n(1 = Overwrite)" )	// Set the text above the slider
				EngineRevLimCalcOverwriteSlider:SetMin( 0 )				// Set the minimum number you can slide to
				EngineRevLimCalcOverwriteSlider:SetMax( 1 )				// Set the maximum number you can slide to
				EngineRevLimCalcOverwriteSlider:SetDecimals( 0 )			// Decimal places - zero for whole number

				--Engine Rev Limit Slider--
				EngineRevLimitSlider = vgui.Create( "DNumSlider", EngineSliderPanel  )
				EngineRevLimitSlider:SetPos( 0,   140)			// Set the position
			    EngineRevLimitSlider:SetSize( panelSizeW * 3.5, 25 )	// Set the size
				EngineRevLimitSlider:SetText( "Max RPM \n(NULL if Overwrite = 0)" )	// Set the text above the slider
				EngineRevLimitSlider:SetMin( 1 )				// Set the minimum number you can slide to
				EngineRevLimitSlider:SetMax( 12000 )				// Set the maximum number you can slide to
				EngineRevLimitSlider:SetDecimals( 0 )			// Decimal places - zero for whole number

				--Flywheel Mass Slider--
				EngineFlyWheelMassSlider = vgui.Create( "DNumSlider", EngineSliderPanel  )
				EngineFlyWheelMassSlider:SetPos( 0,   160)			// Set the position
			    EngineFlyWheelMassSlider:SetSize( panelSizeW * 3.5, 25 )		// Set the size
				EngineFlyWheelMassSlider:SetText( "Flywheel Mass (Kg)" )	// Set the text above the slider
				EngineFlyWheelMassSlider:SetMin( 0.01 )				// Set the minimum number you can slide to
				EngineFlyWheelMassSlider:SetMax( 10 )				// Set the maximum number you can slide to
				EngineFlyWheelMassSlider:SetDecimals( 2 )			// Decimal places - zero for whole number

EnginePistonSlider.OnValueChanged  = function(panel, value)
	ssem_engine_calc_func()
	if(EngineConfigurationNum == 1 && EnginePistonSlider:GetValue() < 5)then
		EngineIcon:SetModel("models/sem/engines/sem_v4.mdl")
	elseif(EngineConfigurationNum == 1 && EnginePistonSlider:GetValue() < 7)then
		EngineIcon:SetModel("models/sem/engines/sem_v6.mdl")
	elseif(EngineConfigurationNum == 1 && EnginePistonSlider:GetValue() < 9)then
		EngineIcon:SetModel("models/sem/engines/sem_v8.mdl")
	elseif(EngineConfigurationNum == 1 && EnginePistonSlider:GetValue() < 11)then
		EngineIcon:SetModel("models/sem/engines/sem_v10.mdl")
	elseif(EngineConfigurationNum == 1 && EnginePistonSlider:GetValue() > 11)then
		EngineIcon:SetModel("models/sem/engines/sem_v12.mdl")
	elseif(EngineConfigurationNum == 0)then
		EngineIcon:SetModel("models/sem/misc/sem_flywheel.mdl")
	end 
	local mn, mx = EngineIcon.Entity:GetRenderBounds()
	local size = 20
	size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
	size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
	size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
	EngineIcon:SetFOV( 45 )
	EngineIcon:SetCamPos( Vector( size, size, size ) )
	EngineIcon:SetLookAt( ( mn + mx ) * 0.2 )
end

EngineBoreSlider.OnValueChanged = function(panel, value)
	ssem_engine_calc_func()
end

EngineStrokeSlider.OnValueChanged= function(panel, value)
	ssem_engine_calc_func()
end

EngineAirflowSlider.OnValueChanged = function(panel, value)
	ssem_engine_calc_func()
end

EngineRevLimCalcOverwriteSlider.OnValueChanged = function(panel, value)
	ssem_engine_calc_func()

end



EngineFlyWheelMassSlider.OnValueChanged = function(panel, value)
			EngineFlywheelDLabel:SetText( "Your Engine's Flywheel Mass is "..math.Round(EngineFlyWheelMassSlider:GetValue(), 1).." KG")
end
			
			


--Gearbox Slider Area--
--Fuel Slider Area--

--Showing Panels Based On Selection--
EngineDataList.OnRowSelected = function( lst, index, pnl )

	if (index == 1) then
		EngineSliderPanel:SetVisible(true)
		EngineCreateDButton:SetVisible(true)
	elseif (index == 2) then
		EngineSliderPanel:SetVisible(false)
	elseif (index == 3) then
		EngineSliderPanel:SetVisible(false)
	end
		

	end



end

--]]
 --[[
function ssem_engine_calc_func()
	                            --Displacement
								EngineDisplacement = math.Round((math.Round(EnginePistonSlider:GetValue(), 0) * 3.1415926535898 * EngineBoreSlider:GetValue() ^ 2 * EngineStrokeSlider:GetValue() / 4000000), 1)
								EngineDisplacementDLabel:SetText( "Your Engine's Displacement is "..EngineDisplacement.."L" )
								--Peak Torque
								EnginePeakTorque = math.Round((EngineStrokeSlider:GetValue() / EngineBoreSlider:GetValue()  * EngineDisplacement * EngineAirflowSlider:GetValue()) * (EngineStrokeSlider:GetValue()  / EngineBoreSlider:GetValue() ), 2)
							    EnginePeakTorque = EnginePeakTorque *0.8
							    
							    EnginePeakTorqueDLabel:SetText( "Your Engine's Peak Torque is "..math.Round(EnginePeakTorque, 1).." nm" )
							    --Calculate Redline?--
							    if (EngineRevLimCalcOverwriteSlider:GetValue() == 0) then
									local EngineRedline = math.Round((EngineBoreSlider:GetValue() / EngineStrokeSlider:GetValue() * EngineAirflowSlider:GetValue() * 2000 / 6), 0)
								     EngineRedline = EngineRedline * (EngineBoreSlider:GetValue() / EngineStrokeSlider:GetValue())
									 EngineRedline = EngineRedline - EngineRedline % 100

									 --Peak HP
									 EnginePeakHP = (EnginePeakTorque * EngineRedline) / 5252
								 	 EnginePeakHPDLabel:SetText( "Your Engine's Peak HP is "..math.Round(EnginePeakHP, 1).." HP" )

									EngineRedlineDLabel:SetText( "Your Engine's Redline is "..math.Round(EngineRedline, 1).." RPM")
								end
								--Overwrite Redline--
								if (EngineRevLimCalcOverwriteSlider:GetValue() == 1) then
									local EngineRedline = EngineRevLimitSlider:GetValue()

									--Peak HP
									 EnginePeakHP = (EnginePeakTorque * EngineRedline) / 5252
								 	 EnginePeakHPDLabel:SetText( "Your Engine's Peak HP is "..math.Round(EnginePeakHP, 1).." HP" )

									EngineRedlineDLabel:SetText( "Your Engine's Redline is "..math.Round(EngineRedline, 1).." RPM")
								end
								
end

function ssem_engine_array_push() 

ssem_engine_data_array_redline = 0

if (EngineRevLimCalcOverwriteSlider:GetValue() == 0) then
		local EngineRedline = math.Round((EngineBoreSlider:GetValue() / EngineStrokeSlider:GetValue() * EngineAirflowSlider:GetValue() * 2000 / 6), 0)
			EngineRedline = EngineRedline * (EngineBoreSlider:GetValue() / EngineStrokeSlider:GetValue())
			EngineRedline = EngineRedline - EngineRedline % 100
			ssem_engine_data_array_redline = EngineRedline
		end
								--Overwrite Redline--
	if (EngineRevLimCalcOverwriteSlider:GetValue() == 1) then
		local EngineRedline = EngineRevLimitSlider:GetValue()
				ssem_engine_data_array_redline = EngineRedline
	end

ssem_engine_data_array = {
	--math.Round(EngineBoreSlider:GetValue(), 2),
	--math.Round(EngineStrokeSlider:GetValue(), 2),
	--math.Round(EnginePistonSlider:GetValue(), 0),
	--math.Round(EngineAirflowSlider:GetValue(), 2),
	--math.Round(EngineIdleSlider:GetValue(), 1),
	--math.Round(EngineRevLimCalcOverwriteSlider:GetValue(), 0),
	--math.Round(ssem_engine_data_array_redline, 0),
	--math.Round(EngineFlyWheelMassSlider:GetValue(), 2),
	--EngineDisplacement,
	--EngineConfigurationNum
}

--[[
if CLIENT then
local ply = LocalPlayer()
timer.Simple(0.05,function() ply:ConCommand("SSEM_Engine_Bore "..ssem_engine_data_array[1]) end)
timer.Simple(0.06,function() ply:ConCommand("SSEM_Engine_Stroke "..ssem_engine_data_array[2]) end)
timer.Simple(0.07,function() ply:ConCommand("SSEM_Engine_Cylinders "..ssem_engine_data_array[3]) end)
timer.Simple(0.08,function() ply:ConCommand("SSEM_Engine_Airflow "..ssem_engine_data_array[4]) end)
timer.Simple(0.09,function() ply:ConCommand("SSEM_Engine_Idle "..ssem_engine_data_array[5]) end)
timer.Simple(0.11,function() ply:ConCommand("SSEM_EngineRevCalcOverwriteVal "..ssem_engine_data_array[6]) end)
timer.Simple(0.12,function() ply:ConCommand("SSEM_Engine_Redline "..ssem_engine_data_array[7]) end)
timer.Simple(0.13,function() ply:ConCommand("SSEM_Engine_FlywheelMass "..ssem_engine_data_array[8]) end)
timer.Simple(0.14,function() ply:ConCommand("SSEM_Engine_Displacement "..ssem_engine_data_array[9]) end)
timer.Simple(0.15,function() ply:ConCommand("SSEM_Engine_Configuration "..ssem_engine_data_array[10]) end)

		
	]]--	
		
function ssem_engine_calc_func()

end		
		
		
function ssem_engine_info_push() 
	print(Engine_UI_Configuration, menuEngineBoreNumberValue:GetValue())
end		
		
		



end

if CLIENT then end
print("------------------------------------------------------------------ SSEM LOADED ------------------------------------------------------------------")
--concommand.Add("ssem_menu_open",function() menuFrame:SetVisible(true) end)
--concommand.Add("ssem_menu_close", function() menuFrame:SetVisible(false) end)
hook.Add("Initialize","ssem_frame_create",ssem_frame_create)

