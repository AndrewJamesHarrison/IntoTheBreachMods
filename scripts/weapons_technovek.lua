
---------------[[[[ Volatile  ]]]]----------------------
--------------  ChargeMech - Beetle charge  ------------
	
Vek_Beetle = Brute_Beetle:new{
	Class = "TechnoVek",
	Portrait = "",
	Icon = "weapons/vek_beetle.png",	
	Rarity = 3,
	Explosion = "",
	Push = 1,--TOOLTIP HELPER
	Fly = 1,
	Damage = 1,
	SelfDamage = 0,
	BackSmoke = 0,
	PathSize = INT_MAX,
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = {1,3},
	LaunchSound = "/weapons/charge",
	ImpactSound = "/weapons/charge_impact",
	TipImage = {
		Unit = Point(0,2),
		Enemy = Point(3,2),
		Target = Point(3,2),
		CustomPawn = "BeetleMech"
	}
}
			
Vek_Beetle_A = Vek_Beetle:new{
		BackSmoke = 1,
		TipImage = {
		Unit = Point(1,2),
		Enemy = Point(3,2),
		Target = Point(3,2),
		CustomPawn = "BeetleMech"
		}
}

Vek_Beetle_B = Vek_Beetle:new{
		Damage = 3,
}

Vek_Beetle_AB = Vek_Beetle:new{
		BackSmoke = 1,
		Damage = 3,
		TipImage = {
		Unit = Point(1,2),
		Enemy = Point(3,2),
		Target = Point(3,2),
		CustomPawn = "BeetleMech"
		}
}

-------------------------------------
-------------------------------------

Vek_Hornet = Prime_Spear:new{  
	Class = "TechnoVek",
	Icon = "weapons/vek_hornet.png",
	Explosion = "",
	Range = 1, 
	PathSize = 1,
	Damage = 1,
	Push = 1,
	PowerCost = 0,
	Upgrades = 2,
	UpgradeCost = { 2 , 3 },
	LaunchSound = "/enemy/hornet_1/attack",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Target = Point(2,2),
		CustomPawn = "HornetMech"
	}
}

function Vek_Hornet:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local distance = p1:Manhattan(p2)

	for i = 1, distance do
		local push = (i == distance) and direction*self.Push or DIR_NONE
		local damage = SpaceDamage(p1 + DIR_VECTORS[direction]*i,self.Damage, push)
		damage.sAnimation = "explohornet_"..direction
		damage.fDelay = 0.15
		ret:AddDamage(damage)
	end

	return ret
end	

Vek_Hornet_A = Vek_Hornet:new{
	PathSize = 2, 
	Range = 2,
	Damage = 2,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "HornetMech"
	}
}

Vek_Hornet_B = Vek_Hornet:new{
	PathSize = 2, 
	Range = 2,
	Damage = 2,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "HornetMech"
	}
}

Vek_Hornet_AB = Vek_Hornet:new{
	PathSize = 3, 
	Range = 3,
	Damage = 3,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "HornetMech"
	}
}

-------------------------------------
-------------------------------------


Vek_Scarab = 	ArtilleryDefault:new{
	Class = "TechnoVek",
	Icon = "weapons/vek_scarab.png",
	Rarity = 3,
	UpShot = "effects/shotup_ant1.png",
	ArtilleryStart = 2,
	ArtillerySize = 8,
	BuildingDamage = true,
	Push = 1,
	DamageOuter = 0,
	DamageCenter = 1,
	BigSize = 0,
	PowerCost = 0,
	Damage = 1,---USED FOR TOOLTIPS
	Explosion = "",
	ExplosionCenter = "ExploArt1",
	ExplosionOuter = "",
	Upgrades = 2,
	UpgradeCost = {1,3},
	LaunchSound = "/enemy/scarab_1/attack",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(3,2),
		Enemy3 = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,3),
		CustomPawn = "ScarabMech"
	}
}
		
function Vek_Scarab:GetSkillEffect(p1, p2)	
	local ret = SkillEffect()
	direction = GetDirection(p2 - p1)
	
	local damage = SpaceDamage(p2,self.DamageCenter)
	damage.sAnimation = self.ExplosionCenter
	ret:AddArtillery(damage, self.UpShot)
	
	
	if self.BigSize == 1 then
		damage = SpaceDamage(p2 + DIR_VECTORS[direction], self.DamageCenter)
		ret:AddDamage(damage)
		
		for dir = 0, 2 do
			damage = SpaceDamage(p2 + DIR_VECTORS[(direction-dir-1)%4],  self.DamageOuter, (direction-dir-1)%4 )
			damage.sAnimation = "airpush_"..(direction-dir-1)%4
			ret:AddDamage(damage)
		end
		for dir = 0, 2 do
			damage = SpaceDamage(p2 + DIR_VECTORS[direction]+DIR_VECTORS[(direction+dir-1)%4],  self.DamageOuter, (direction+dir-1)%4 )
			damage.sAnimation = "airpush_"..(direction+dir-1)%4
			ret:AddDamage(damage)
		end
		
	else
		for dir = 0, 3 do
			damage = SpaceDamage(p2 + DIR_VECTORS[dir],  self.DamageOuter, dir)
			damage.sAnimation = "airpush_"..dir
			ret:AddDamage(damage)
		end
	end

	return ret
end		

Vek_Scarab_A = Vek_Scarab:new{
	BigSize = 1,
	ExplosionCenter = "ExploArt1",
}
	
Vek_Scarab_B = Vek_Scarab:new{
	DamageCenter = 3,
	Damage = 3,---USED FOR TOOLTIPS
	ExplosionCenter = "ExploArt2",
	ImpactSound = "/impact/generic/explosion_large",
}
			
Vek_Scarab_AB = Vek_Scarab:new{
		BigSize = 1,
		DamageCenter = 3,
		Damage = 3,---USED FOR TOOLTIPS
		ExplosionCenter = "ExploArt2",
		ImpactSound = "/impact/generic/explosion_large",
		--BuildingDamage = false
	}
	