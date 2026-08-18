local Item = KInventory.Item

function Item:networkUse( )
	net.Start( "PlayerUseItem" )
		net.WriteInt( self.id, 32 )
	net.SendToServer( )
end

function Item:initialize( )
end

function Item:getIcon( )
	self.icon = vgui.Create( "DModelPanel" )
	self.icon:SetModel( self.iconModel or self.class.iconModel or "models/props/cs_office/cardboard_box03.mdl" )
	self.icon:SetSize( 64, 64 )
	function self.icon:LayoutEntity( ent )
		self:SetCamPos( Vector( 20, 20, 20 ) )
		self:SetLookAt( ent:GetPos( ) + Vector( 0, 0, 5 ) )
		if self.Hovered then
			ent:SetAngles( ent:GetAngles( ) + Angle( 0, FrameTime() * 50,  0) )
		end
	end
	return self.icon
end

-- change by cookie9216
function Item:getCrashsafeIcon( )
	local icon = self:getIcon( )
	if IsValid( icon ) then
		self.icon = icon
		return icon
	end

	local placeholder = vgui.Create( "DPanel" )
	placeholder:SetSize( 64, 64 )
	function placeholder:Paint( w, h )
		surface.SetDrawColor( 40, 40, 40, 200 )
		surface.DrawRect( 0, 0, w, h )
	end
	self.icon = placeholder
	return placeholder
end

function Item:getHoverPanel( )
	local panel = vgui.Create( "DItemDescriptionPanel" )
	panel:SetSize( 220, 100 )
	return panel
end

function Item:openMenu( )
	local menu = DermaMenu( )
	if self.droppable or self.class.droppable then
		menu:AddOption( "Drop", function( )
			InventoryView:getInstance( ):dropItem( self )
		end )
	end
	
	if self.usable or self.class.usable then
		menu:AddOption( "Use", function( )
			InventoryView:getInstance( ):useItem( self )
		end )
	end
	menu:Open( )
end