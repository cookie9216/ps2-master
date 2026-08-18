Pointshop2.ClientSettings = {}

Pointshop2.ClientSettings.SettingsTable = {
	BasicSettings = {
		info = {
			label = "General Settings"
		},
		LowendMode = {
			tooltip = "This turns all icons into simple icons to save performance",
			label = "Lowend Mode", 
			value = false
		},
		DrawDistance = {
			value = 20000,
			tooltip = "Distance that PAC items are drawn",
			label = "Item Draw Distance",
		},
		VisualsDisabled = {
			label = "Disable Visuals",
			tooltip = "Disables all Pointshop2 ingame visuals (trails, hats, pets etc.)",
			value = false
		},
		AutoconfirmSale = {
			label = "Autoconfirm selling items",
			tooltip = "Disables the confirmation when selling an item",
			value = false
		},
		HoverPanelEnabled = {
			label = "Show hover panel",
			tooltip = "Displays information in inventory on hover",
			value = false
		}
	}, 
}

function Pointshop2.ClientSettings.SaveSettings( settings )
	-- change by cookie9216
	local function normalizeStoredValue( value )
		if value == "true" then return true end
		if value == "false" then return false end
		return value
	end

	local copy = {}
	if istable( settings ) then
		for k, v in pairs( settings ) do
			copy[k] = normalizeStoredValue( v )
		end
	end

	Pointshop2.ClientSettings.Settings = copy
	file.CreateDir( "pointshop2" )
	local encoded = util.TableToJSON( copy, true )
	if not encoded then
		ErrorNoHalt( "[PS2] Failed to encode client settings.\n" )
		return false
	end
	file.Write( "pointshop2/client_settings.json", encoded )
	file.Write( "pointshop2-settings.txt", encoded )
	return true
end

function Pointshop2.ClientSettings.LoadSettings( )
	-- change by cookie9216
	local raw = file.Read( "pointshop2/client_settings.json", "DATA" )
		or file.Read( "pointshop2-settings.txt", "DATA" )
		or "{}"
	local settings = util.JSONToTable( raw ) or {}
	for k, v in pairs( settings ) do
		if v == "true" then settings[k] = true end
		if v == "false" then settings[k] = false end
	end
	
	Pointshop2.ClientSettings.Settings = {}
	Pointshop2.recursiveSettingsInitialize( Pointshop2.ClientSettings.SettingsTable, settings, Pointshop2.ClientSettings.Settings )
	hook.Run( "PS2_ClientSettingsUpdated" )
	
	KLogf( 5, "[PS2] Loaded client settings" )
end

function Pointshop2.ClientSettings.GetSetting( path )
	-- change by cookie9216
	local settings = Pointshop2.ClientSettings.Settings
	if not istable( settings ) then
		return nil
	end
	return settings[path]
end

hook.Add( "PS2_ClientSettingsUpdated", "UpdatePACConvars", function( )
	RunConsoleCommand( "pac_draw_distance", Pointshop2.ClientSettings.GetSetting( "BasicSettings.DrawDistance" ) )
	if IsValid( Pointshop2.Menu ) then
		if Pointshop2.Menu.LowendModeEnabled != Pointshop2.ClientSettings.GetSetting( "BasicSettings.LowendMode" ) then
			Pointshop2.Menu:Remove( )
			Pointshop2.OpenMenu( )
		end
	end
end )

hook.Add("OnReloaded", "reloadsettingsclient", function()
	if LibK.Debug then
		Pointshop2.ClientSettings.LoadSettings( )		
	end
end)