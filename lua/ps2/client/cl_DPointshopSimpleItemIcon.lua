local PANEL = {}

function PANEL:Init( )
	self:SetSkin( Pointshop2.Config.DermaSkin )
	self:InitText( )
end

function PANEL:InitText( )
	self.lbl = vgui.Create( "DLabel", self )
	self.lbl:Dock( FILL )
	self.lbl:SetColor( color_white )
	self.lbl:SetTextColor( color_white )
	self.lbl:SetText( "" )
	self.lbl:SetFont( self:GetSkin( ).BigTitleFont )
	self.lbl:SetContentAlignment( 5 )
end

function PANEL:Paint( w, h )
	-- change by cookie9216
	if Pointshop2 and Pointshop2.DrawItemTileBackground then
		Pointshop2.DrawItemTileBackground( w, h, Pointshop2.IsTileHovered( self ) )
	end
	if IsValid( self.lbl ) and self.itemClass and self.itemClass.GetPrintName then
		local txt = self.itemClass:GetPrintName( )
		self.lbl:SetText( txt and txt[1] or "" )
		self.lbl:SetTextColor( color_white )
	end
end

derma.DefineControl( "DPointshopSimpleItemIcon", "", PANEL, "DPointshopItemIcon" )

local PANEL = {}
function PANEL:Init( )
	self:SetSkin( Pointshop2.Config.DermaSkin )
	
	self.lbl = vgui.Create( "DLabel", self )
	self.lbl:Dock( FILL )
	self.lbl:SetColor( color_white )
	self.lbl:SetTextColor( color_white )
	self.lbl:SetText( "C" )
	self.lbl:SetFont( self:GetSkin( ).BigTitleFont )
	self.lbl:SetContentAlignment( 5 )
end


function PANEL:Paint( w, h )
	-- change by cookie9216
	if Pointshop2 and Pointshop2.DrawItemTileBackground then
		Pointshop2.DrawItemTileBackground( w, h, Pointshop2.IsTileHovered( self ) )
	end
	if IsValid( self.lbl ) and self.item and self.item.GetPrintName then
		local txt = self.item:GetPrintName( )
		self.lbl:SetText( txt and txt[1] or "" )
		self.lbl:SetTextColor( color_white )
	end
end

function PANEL:SetItem( item )
	self.BaseClass.SetItem( self, item )
	self.itemClass = item.class
end

derma.DefineControl( "DPointshopSimpleInventoryIcon", "", PANEL, "DPointshopInventoryItemIcon" )