function ssem_frame_create() 

local ply = LocalPlayer()



	local uiSizeW = ScrW() / 1.05
	local uiSizeH = ScrH() / 1.05
	local panelSizeW = uiSizeW / 6
	local panelSizeH = uiSizeH / 2

--Main Menu Frame--
	menuFrame = vgui.Create("DFrame")
	menuFrame:SetPos(ScrW() - (ScrW() / 2) - (uiSizeW / 2), ScrH() / 2 - (uiSizeH / 2))
	menuFrame:SetSize(uiSizeW ,uiSizeH)
    menuFrame:SetTitle("")
	--menuFrame.lblTitle:SetContentAlignment(5)
	--menuFrame.lblTitle:SetFont("HudHintTextSmall")
	--menuFrame:lblTitle:SetTextColor(Color(255,255,255,0))
	menuFrame:SetVisible(true) 
	menuFrame:SetDraggable(true)
	menuFrame:SetBackgroundBlur(true)
	--menuFrame.btnMinim:SetVisible( true )
	--menuFrame.btnMaxim:SetVisible( true )
	--menuFrame.btnClose.Paint = function(self, w, h)
	--	draw.RoundedBox(0, 0, 0, w, h, Color(125,125,125,255))
	--	if (self:IsDown()) then
	--		draw.RoundedBox(0, 0, 0, w, h, Color(100,100,100,255))
	--	end
	--end
	menuFrame.btnClose:SetText("X")
	--menuFrame.btnClose:SetFont("HudHintTextSmall")	
	--menuFrame.btnClose:SetTextColor(Color(255,255,255))
	menuFrame:MakePopup()
	--menuFrame.OnClose = function() 
	--	ssem_frame_create()
	--end
	menuFrame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50,50,50,220))
	end



---------------------------------------------------------------ENGINE TAB-----------------------------------------------------------------

--Property Sheet--
local menuPropertySheet = vgui.Create( "DPropertySheet", menuFrame )
menuPropertySheet:SetVisible(true)
menuPropertySheet:DockMargin( 10, 0, 10, 40 )
menuPropertySheet:Dock( FILL )
menuPropertySheet.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 20, w, h-20, Color(149,149,149,255))
	end
menuPropertySheet:InvalidateParent(true)
--Main Panel--
local menuEnginePropertyPanel = vgui.Create( "DPanel" )
menuEnginePropertyPanel.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 183, 183, 183, self:GetAlpha() ) ) 
end

--Paint Engine Tab--
menuPropertySheet:AddSheet( "    Engine    ", menuEnginePropertyPanel)
	menuPropertySheet:GetItems()[1].Tab.Paint = function( self, w, h ) 
		if (self:IsActive()) then draw.RoundedBoxEx(0, 1, 1, w-7, h, Color(149, 149, 149, self:GetAlpha() ),  true, true, false, false)
		else draw.RoundedBoxEx(0, 1, 1, w-7, h, Color(85, 85, 85, self:GetAlpha() ),  true, true, false, false) end
	end	
menuPropertySheet:GetItems()[1].Tab:SetFont("HudHintTextLarge")

--Bottom Input Panel--
local menuPropertyEngineBottomInput = vgui.Create( "DPanel", menuEnginePropertyPanel )
menuPropertyEngineBottomInput:SetPos(menuPropertySheet.x-6, menuPropertySheet.y + menuPropertySheet.y * 22.15 )
menuPropertyEngineBottomInput:SetSize(menuPropertySheet:GetWide()  - 34, (menuPropertySheet:GetTall() / 4) )
menuPropertyEngineBottomInput.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 37, 37, 37, self:GetAlpha() ) ) 
end

local I = 12.85714285714286

local engineTypePanel = vgui.Create( "DPanel", menuPropertyEngineBottomInput )
engineTypePanel:SetPos((menuPropertyEngineBottomInput.x * 2) , menuPropertyEngineBottomInput.y / 25)
engineTypePanel:SetSize(125, 200 )
engineTypePanel.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, self:GetAlpha() ) ) 
	draw.RoundedBox( 0, engineTypePanel.x * 6, 0, w / 6, h, Color( 75, 75, 75, self:GetAlpha() ) ) 
end

local engineTypePanelSlider = vgui.Create( "DSlider", engineTypePanel )
engineTypePanelSlider:SetPos( engineTypePanel.x * 6.15, 22 )
engineTypePanelSlider:SetSize( 10, 156 )
engineTypePanelSlider:SetLockX(0.5)
engineTypePanelSlider:SetSlideX(0.5)
engineTypePanelSlider:SetLockY()
engineTypePanelSlider.Knob:SetSize(20, 20)
engineTypePanelSlider.Knob:NoClipping(false)

engineTypePanelSlider.Knob.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, self:GetAlpha() ) ) 
end


function engineTypePanelSlider:OnCursorMoved( x, y )

	if ( !self.Dragging && !self.Knob.Depressed ) then return end

	local w, h = self:GetSize()
	local iw, ih = self.Knob:GetSize()

	if ( self.m_bTrappedInside ) then

		w = w - iw 
		h = h - ih 

		x = x - iw * 0.5
		y = y - ih * 0.5

	end

	x = math.Clamp( x, 0, w ) / w 
	if (engineTypePanelSlider:GetSlideY() > 0.5) then 
	y = math.Clamp( y , 0, h + 20) / h
elseif (engineTypePanelSlider:GetSlideY() < 0.5) then
	y = math.Clamp( y , 0, h + 20) / h
end

	if ( self.m_iLockX ) then x = self.m_iLockX end
	if ( self.m_iLockY ) then y = self.m_iLockY end

	x, y = self:TranslateValues( x, y)

	self:SetSlideX( x )
	self:SetSlideY( y )

	self:InvalidateLayout()

end

function engineTypePanelSlider.Knob:OnReleased()
	print(engineTypePanelSlider:GetSlideY())
end


local engineCylindersPanel = vgui.Create( "DPanel", menuPropertyEngineBottomInput )
engineCylindersPanel:SetPos((menuPropertyEngineBottomInput.x * 2) * I  , menuPropertyEngineBottomInput.y / 25)
engineCylindersPanel:SetSize(125, 200 )
engineCylindersPanel.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, self:GetAlpha() ) ) 
end





local engineBorePanel = vgui.Create( "DPanel", menuPropertyEngineBottomInput )
engineBorePanel:SetPos((menuPropertyEngineBottomInput.x * 2) * I * 2, menuPropertyEngineBottomInput.y / 25)
engineBorePanel:SetSize(125, 200 )
engineBorePanel.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, self:GetAlpha() ) ) 
end





local engineStrokePanel = vgui.Create( "DPanel", menuPropertyEngineBottomInput )
engineStrokePanel:SetPos((menuPropertyEngineBottomInput.x * 2) * I * 3, menuPropertyEngineBottomInput.y / 25)
engineStrokePanel:SetSize(125, 200 )
engineStrokePanel.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, self:GetAlpha() ) ) 
end





local engineAirflowPanel = vgui.Create( "DPanel", menuPropertyEngineBottomInput )
engineAirflowPanel:SetPos((menuPropertyEngineBottomInput.x * 2) * I * 4, menuPropertyEngineBottomInput.y / 25)
engineAirflowPanel:SetSize(125, 200 )
engineAirflowPanel.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, self:GetAlpha() ) ) 
end

local engineIdlePanel = vgui.Create( "DPanel", menuPropertyEngineBottomInput )
engineIdlePanel:SetPos((menuPropertyEngineBottomInput.x * 2) * I * 5, menuPropertyEngineBottomInput.y / 25)
engineIdlePanel:SetSize(125, 200 )
engineIdlePanel.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, self:GetAlpha() ) ) 
end

local engineRedlinePanel = vgui.Create( "DPanel", menuPropertyEngineBottomInput )
engineRedlinePanel:SetPos((menuPropertyEngineBottomInput.x * 2) * I * 6, menuPropertyEngineBottomInput.y / 25)
engineRedlinePanel:SetSize(125, 200 )
engineRedlinePanel.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, self:GetAlpha() ) ) 
end

local engineFlywheelMassPanel = vgui.Create( "DPanel", menuPropertyEngineBottomInput )
engineFlywheelMassPanel:SetPos((menuPropertyEngineBottomInput.x * 2) * I * 7, menuPropertyEngineBottomInput.y / 25)
engineFlywheelMassPanel:SetSize(125, 200 )
engineFlywheelMassPanel.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 25, 25, 25, self:GetAlpha() ) ) 
end









--Left Info Panel--
local menuPropertyEngineLeftInfo = vgui.Create( "DPanel", menuEnginePropertyPanel )
menuPropertyEngineLeftInfo:SetPos(menuPropertySheet.x-6, menuPropertySheet.y - (menuPropertySheet.y / 1.85) )
menuPropertyEngineLeftInfo:SetSize(menuPropertySheet:GetWide() / 5, (menuPropertySheet:GetTall() / 4) * 2.70 )
menuPropertyEngineLeftInfo.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 37, 37, 37, self:GetAlpha() ) ) 
end

--Right Info Panel--
local menuPropertyEngineRightInfo = vgui.Create( "DPanel", menuEnginePropertyPanel )
menuPropertyEngineRightInfo:SetPos((menuPropertySheet.x + menuPropertySheet.x * 93.2 ) , menuPropertySheet.y - (menuPropertySheet.y / 1.85) )
menuPropertyEngineRightInfo:SetSize(menuPropertySheet:GetWide() / 5, (menuPropertySheet:GetTall() / 4) * 2.70 )
menuPropertyEngineRightInfo.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 37, 37, 37, self:GetAlpha() ) ) 
end

--Center Graph Panel--
local menuPropertyEngineCenterGraph = vgui.Create( "DPanel", menuEnginePropertyPanel )
menuPropertyEngineCenterGraph:SetPos((menuPropertySheet.x + menuPropertySheet.x * 24.465 ) , menuPropertySheet.y - (menuPropertySheet.y / 1.85) )
menuPropertyEngineCenterGraph:SetSize(menuPropertySheet:GetWide() / 1.765 , (menuPropertySheet:GetTall() / 4) * 2.70 )
menuPropertyEngineCenterGraph.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 37, 37, 37, self:GetAlpha() ) ) 
end




---------------------------------------------------------------TURBO TAB-----------------------------------------------------------------
local PlaceHolder = vgui.Create( "DPanel" )
PlaceHolder.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 183, 183, 183, self:GetAlpha() ) ) 
end
menuPropertySheet:AddSheet( "    Turbo    ", PlaceHolder)

menuPropertySheet:GetItems()[2].Tab.Paint = function( self, w, h ) 
		if (self:IsActive()) then
		draw.RoundedBoxEx(0, 1, 1, w-7, h, Color(149, 149, 149, self:GetAlpha() ),  true, true, false, false)
	else 
		
		draw.RoundedBoxEx(0, 1, 1, w-7, h, Color(85, 85, 85, self:GetAlpha() ),  true, true, false, false)
		end
end
menuPropertySheet:GetItems()[2].Tab:SetFont("HudHintTextLarge")


---------------------------------------------------------------GEARBOX TAB-----------------------------------------------------------------
local PlaceHolder2 = vgui.Create( "DPanel" )
PlaceHolder2.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 183, 183, 183, self:GetAlpha() ) ) 
end
menuPropertySheet:AddSheet( "    Gearbox    ", PlaceHolder2)

menuPropertySheet:GetItems()[3].Tab.Paint = function( self, w, h ) 
	if (self:IsActive()) then
		draw.RoundedBoxEx(0, 1, 1, w-7, h, Color(149, 149, 149, self:GetAlpha() ),  true, true, false, false)
	else 

		draw.RoundedBoxEx(0, 1, 1, w-7, h, Color(85, 85, 85, self:GetAlpha() ),  true, true, false, false)
		end
end
menuPropertySheet:GetItems()[3].Tab:SetFont("HudHintTextLarge")

---------------------------------------------------------------PRESET TAB-----------------------------------------------------------------
local PlaceHolder3 = vgui.Create( "DPanel" )
PlaceHolder3.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 183, 183, 183, self:GetAlpha() ) ) 
end
menuPropertySheet:AddSheet( "    Presets    ", PlaceHolder3)

menuPropertySheet:GetItems()[4].Tab.Paint = function( self, w, h ) 
	if (self:IsActive()) then
		draw.RoundedBoxEx(0, 1, 1, w-7, h, Color(149, 149, 149, self:GetAlpha() ),  true, true, false, false)
	else 

		draw.RoundedBoxEx(0, 1, 1, w-7, h, Color(85, 85, 85, self:GetAlpha() ),  true, true, false, false)
		end
end
menuPropertySheet:GetItems()[4].Tab:SetFont("HudHintTextLarge")
-----------------------------------------------------------------------------------------------------------------------------------------
end


if CLIENT then end
print("------------------------------------------------------------------ SSEM LOADED ------------------------------------------------------------------")
concommand.Add("ssem_menu_open",function() ssem_frame_create() end)
concommand.Add("ssem_menu_close", function() menuFrame:Close() end)
--hook.Add("Initialize","ssem_frame_create", ssem_frame_create)
