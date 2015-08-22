AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"
ENT.PrintName		= "SBC Planet"
ENT.Author			= "Ludsoe"
ENT.Category		= "Other"

ENT.Spawnable		= false

if(SERVER)then
	function ENT:Initialize()
		self:SetModel( "models/combine_helicopter/helicopter_bomb01" ) --setup stuff
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		self:PhysicsInitSphere(1)
		self:SetCollisionBounds(Vector(-1,-1,-1),Vector(1,1,1))
		self:SetTrigger( true )
		self:GetPhysicsObject():EnableMotion( false )
		self:DrawShadow(false)
		
		local phys = self:GetPhysicsObject() --reset physics
		if phys:IsValid() then
			phys:Wake()
		end
		self:SetNotSolid( true )
		
		self:SetColor(Color(255,255,255,0)) --Make invis
		
		//Important Tables
		self.Entities = {}
	end
	
	--fixes stargate stuff
	ENT.IgnoreStaff = true
	ENT.IgnoreTouch = true
	ENT.NotTeleportable = true
	
	--Dont allow players to interact with this entity
	function ENT:CanTool() return false end
	function ENT:GravGunPunt() return false end
	function ENT:GravGunPickupAllowed() return false end
else
	function ENT:Draw()
		return false
	end
end		
