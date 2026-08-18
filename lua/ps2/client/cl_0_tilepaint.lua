-- change by cookie9216

Pointshop2 = Pointshop2 or {}

local TILE_MAT
local PREVIEW_MAT

local TILE_CANDIDATES = {
	"itembg-ps2.png",
	"itembg-ps2",
	"pointshop2/itembg.png",
	"item_bg",
}

local TILE_FALLBACK = Color(27, 27, 34, 255)
local HOVER_OVERLAY = Color(80, 150, 255, 24)
local HOVER_OUTLINE = Color(80, 150, 255, 82)
local DRAG_OVERLAY = Color(8, 10, 16, 172)
local POPUP_BACKDROP = Color(8, 10, 16, 235)
local POPUP_PANEL = Color(27, 27, 34, 255)
local POPUP_OUTLINE = Color(65, 65, 78, 255)

local function normalizeMaterialPath(path)
	if not isstring(path) or path == "" then return nil end
	path = string.Trim(string.Replace(path, "\\", "/"))
	path = string.TrimLeft(path, "/")
	if string.StartWith(string.lower(path), "materials/") then
		path = string.sub(path, 11)
	end
	return path
end

local function resolveMaterial(candidates)
	local tried = {}
	for _, raw in ipairs(candidates) do
		local path = normalizeMaterialPath(raw)
		if path and not tried[path] then
			tried[path] = true
			local mat = Material(path, "noclamp smooth")
			if mat and not mat:IsError() then
				return mat
			end
			local noPng = string.gsub(path, "%.png$", "")
			if noPng ~= path and not tried[noPng] then
				tried[noPng] = true
				mat = Material(noPng, "noclamp smooth")
				if mat and not mat:IsError() then
					return mat
				end
			end
		end
	end
end

function Pointshop2.RefreshTileMaterials()
	TILE_MAT = resolveMaterial(TILE_CANDIDATES)
	PREVIEW_MAT = TILE_MAT
end

Pointshop2.RefreshTileMaterials()
hook.Add("InitPostEntity", "PS2_RefreshTileMaterials", Pointshop2.RefreshTileMaterials)

local function drawMat(mat, w, h)
	if not mat then return false end
	surface.SetMaterial(mat)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(0, 0, w, h)
	return true
end

function Pointshop2.IsTileHovered(pnl)
	if not IsValid(pnl) then return false end
	if pnl.Selected or pnl.Hovered or pnl.Dragging then return true end
	if pnl.IsHoveredRecursive then return pnl:IsHoveredRecursive() end
	if pnl.IsChildHovered then return pnl:IsChildHovered(2) end
	return pnl:IsHovered()
end

function Pointshop2.DrawItemTileBackground(w, h, hovered)
	if hovered and drawMat(PREVIEW_MAT, w, h) then
		surface.SetDrawColor(HOVER_OUTLINE)
		surface.DrawOutlinedRect(0, 0, w, h, 1)
		return
	end

	if not drawMat(TILE_MAT, w, h) then
		surface.SetDrawColor(TILE_FALLBACK)
		surface.DrawRect(0, 0, w, h)
	end

	if hovered then
		surface.SetDrawColor(HOVER_OVERLAY)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(HOVER_OUTLINE)
		surface.DrawOutlinedRect(0, 0, w, h, 1)
	end
end

function Pointshop2.DrawPreviewBackground(w, h)
	if not drawMat(PREVIEW_MAT, w, h) then
		surface.SetDrawColor(POPUP_PANEL)
		surface.DrawRect(0, 0, w, h)
	end
end

function Pointshop2.DrawPopupPanelBackground(w, h)
	surface.SetDrawColor(POPUP_PANEL)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(POPUP_OUTLINE)
	surface.DrawOutlinedRect(0, 0, w, h, 1)
end

function Pointshop2.AddPopupBackdrop(frame)
	if not IsValid(frame) or IsValid(frame.__PS2Backdrop) then return end

	local backdrop = vgui.Create("DPanel")
	backdrop:SetSize(ScrW(), ScrH())
	backdrop:SetPos(0, 0)
	backdrop:SetMouseInputEnabled(false)
	backdrop:SetKeyboardInputEnabled(false)
	function backdrop:Paint(pw, ph)
		surface.SetDrawColor(POPUP_BACKDROP)
		surface.DrawRect(0, 0, pw, ph)
	end

	frame.__PS2Backdrop = backdrop
	frame:MoveToFront()

	local oldRemove = frame.OnRemove
	function frame:OnRemove(...)
		if IsValid(self.__PS2Backdrop) then
			self.__PS2Backdrop:Remove()
		end
		if oldRemove then
			return oldRemove(self, ...)
		end
	end
end

function Pointshop2.DrawItemSlotBackground(pnl, w, h)
	Pointshop2.DrawItemTileBackground(w, h, Pointshop2.IsTileHovered(pnl))
	if pnl.Dragging then
		surface.SetDrawColor(DRAG_OVERLAY)
		surface.DrawRect(0, 0, w, h)
	end
end

