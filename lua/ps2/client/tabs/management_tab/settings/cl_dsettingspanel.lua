local PANEL = {}

function PANEL:Init( )
	self.settings = {}
end

function PANEL:AddSection( name )
	local section = vgui.Create( "DSettingsSection", self )
	section:SetSettingsListener( self )
	section:Dock( TOP )
	section:DockMargin( 0, 5, 0, 5 )
	section.title:SetText( name )
	
	return section
end

function PANEL:SetData( data )
	-- change by cookie9216
	self.settings = istable(data) and data or {}
	self:InitSettings( )
end

function PANEL:InitSettings( )
	-- change by cookie9216
	if not istable(self.settings) then return end
	for path, value in pairs( self.settings ) do
		if self.settingsLookup[path] then
			self.settingsLookup[path]:SetValue( value )
		end
	end
end

function PANEL:OnValueChanged( path, value )
	self.settings[path] = value
end

-- change by cookie9216
function PANEL:CollectSettings( )
	local out = {}
	if istable( self.settings ) then
		for path, value in pairs( self.settings ) do
			out[path] = value
		end
	end
	for path, panel in pairs( self.settingsLookup or {} ) do
		if not IsValid( panel ) then continue end
		if IsValid( panel.container ) and IsValid( panel.container.checkbox ) then
			out[path] = panel.container.checkbox:GetChecked() == true
		elseif IsValid( panel.numberWang ) then
			out[path] = tonumber( panel.numberWang:GetValue() ) or 0
		elseif IsValid( panel.textEntry ) then
			out[path] = panel.textEntry:GetValue()
		elseif IsValid( panel.combobox ) then
			out[path] = panel.combobox:GetSelected() or panel.combobox:GetValue()
		elseif IsValid( panel.radiobox ) and panel.radiobox.GetSelectedOption then
			local opt = panel.radiobox:GetSelectedOption()
			if IsValid( opt ) then out[path] = opt:GetText() end
		end
	end
	return out
end

function PANEL:AutoAddSettingsTable( tbl, settingListener )
	settingListener = settingListener or self
	
	self.settingsLookup = self.settingsLookup or {}
	for catPath, settingsTable in pairs( tbl ) do
		if settingsTable.info and settingsTable.info.isManualSetting then
			continue
		end
		
		self[catPath] = self:AddSection( settingsTable.info and settingsTable.info.label or catPath )
		self[catPath]:SetSettingsListener( settingListener )
		
		for settingPath, settingInfo in pairs( settingsTable ) do
			if settingPath == "info" then
				--Info about the category
				continue
			end
			
			local path = catPath .. "." .. settingPath
			local panel = self[catPath]:AddSettingByType( path, settingInfo )
			self.settingsLookup[path] = panel
		end
	end
end

function PANEL:PerformLayout( )
	self:SizeToChildren( false, true )
end

function PANEL:Paint( w, h )
end

derma.DefineControl( "DSettingsPanel", "", PANEL, "DPanel" )