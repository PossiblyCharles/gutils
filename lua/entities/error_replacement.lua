AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "error_replacement"
ENT.Spawnable = true

function ENT:Initialize()
    if SERVER then
        self:SetModel( "models/props_junk/PopCan01a.mdl" )
    else
        self:CreateMesh()
    end
    self:DrawShadow( false )
end

function ENT:CreateMesh()
	if self.Mesh then self.Mesh:Destroy() end

	local mesh = modelMeshs[self.model]
	if !mesh then return end

    self.material = Material("models/debug/debugwhite")
	self.Mesh = Mesh()
    self.Mesh:BuildFromTriangles(mesh[1])
end

-- A special hook to override the normal mesh for rendering
function ENT:GetRenderMesh()
	-- If the mesh doesn't exist, create it!
	if ( !self.Mesh ) then return self:CreateMesh() end
    
	return { Mesh = self.Mesh, Material = self.material }
end

function ENT:Draw()
    self:DrawModel()
end