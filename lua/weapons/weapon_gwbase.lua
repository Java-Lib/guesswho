AddCSLuaFile()

SWEP.Base = "weapon_base"
SWEP.Name = "NONAME"

SWEP.Spawnable          = false
SWEP.ViewModelFOV       = 54

SWEP.AutoSwitchTo       = false
SWEP.AutoSwitchFrom     = false

SWEP.Primary.Damage         = 10
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.NumShots       = 1

SWEP.Secondary.ClipSize     = 1
SWEP.Secondary.DefaultClip  = 1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "ability"

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.HoldType = "normal"

function SWEP:Initialize()

    self:SetHoldType( self.HoldType )

end


function SWEP:PrimaryAttack()

    self.Weapon:SetNextPrimaryFire( CurTime() + 1.5 )

    if self.Owner.LagCompensation then
        self.Owner:LagCompensation(true)
    end
    local spos = self.Owner:GetShootPos()
    local sdest = spos + (self.Owner:GetAimVector() * 100)
    local tr = util.TraceLine( {start = spos, endpos = sdest, filter  = self.Owner, mask = MASK_SHOT_HULL} )
    self.Owner:LagCompensation(false)

    --print(tr.Entity)

    if tr.Hit and IsValid(tr.Entity) and (tr.Entity:GetClass() == "func_breakable" or tr.Entity:GetClass() == "func_breakable_surf") then

        if SERVER then tr.Entity:Fire("shatter") end

    end

end

function SWEP:SecondaryAttack()
    if ( !self:CanSecondaryAttack() ) then return end

    if self.AbilitySound and SERVER then
        local abilitySound
        if istable( self.AbilitySound ) then
            abilitySound = Sound( self.AbilitySound[ math.random( #self.AbilitySound ) ] )
        else
            abilitySound = Sound( self.AbilitySound )
        end
        if abilitySound then
            self.Owner:EmitSound( abilitySound )
        end
    end
    self:Ability()
    self:TakeSecondaryAmmo( 1 )
end

function SWEP:GiveSecondaryAmmo(amount)
    self.Owner:GiveAmmo(amount, "ability", true)
    self:SetClip2( self:Clip2() + amount )
end
