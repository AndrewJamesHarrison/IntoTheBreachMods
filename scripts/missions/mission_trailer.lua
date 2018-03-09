
Mission_Tutorial = Mission:new{
	MapTags = { "trailer" },
	TurnLimit = 7,
	SpawnStartMod = -10,
	EnemySpawn = false,
	MechSpawn = false,
	UseBonus = false,
}

function Mission_Tutorial:StartMission()
	self.EnemySpawn = false
	self.MechSpawn = false
end

function Mission_Tutorial:UpdateMission()
	if not self.EnemySpawn and not Board:IsBusy() then
		TrailerOpening()
		self.EnemySpawn = true
	end
	
	if not Board:IsBusy() and self.EnemySpawn and not self.MechSpawn then
		self.MechSpawn = true
		TrailerOpening_Two()
	end
	
	if not Board:IsBusy() and self.EnemySpawn and self.MechSpawn then
		local effect = SkillEffect()
		effect:AddDelay(5)
		Board:AddEffect(effect)
	end
end

function TrailerOpening()

	Board:GetPawn(Point(3,6)):SetInvisible(true)

	local effect = SkillEffect()
	effect:AddDelay(10)
	effect:AddScript("Board:SpawnPawn(\"Hornet1\",Point(4,2))")
	effect:AddDelay(0.3)
	effect:AddScript("Board:SpawnPawn(\"Firefly1\",Point(5,2))")
	effect:AddScript("Board:GetPawn(Point(4,2)):SetActive(true)")
	effect:AddScript("Board:GetPawn(Point(5,2)):SetActive(true)")
	effect:AddDelay(0.3)
	effect:AddScript("Board:GetPawn(Point(4,2)):Move(Point(4,3))")
	effect:AddScript("Board:SpawnPawn(\"Scorpion1\",Point(4,1))")
	effect:AddScript("Board:GetPawn(Point(4,1)):SetActive(true)")
	
--	effect:AddDelay(1)
	
	effect:AddDelay(1.6)
	effect:AddScript("Board:GetPawn(Point(4,3)):FireWeapon(Point(4,4),1)")
	effect:AddDelay(0.3)
	effect:AddScript("Board:GetPawn(Point(4,1)):FireWeapon(Point(3,1),1)")
	effect:AddDelay(0.3)
	effect:AddScript("Board:GetPawn(Point(5,2)):FireWeapon(Point(4,2),1)")
	
	

	
	--effect:AddDamage(SpaceDamage(0))
		
	Board:AddEffect(effect)
	--
--	local effect2 = SkillEffect()
	
	--effect2:AddDelay(3)
	--effect2:AddScript("Board:SpawnPawn(\"PunchMech\",Point(3,2))")
	
	--Board:AddEffect(effect2)
	
end

function TrailerOpening_Two()
	local effect = SkillEffect()
	
	--effect:AddDelay(0.7)
	local damage = SpaceDamage(Point(3,3))
	damage.sPawn = "PunchMech"
	effect:AddDamage(damage)
	
	effect:AddDelay(0.7)
	damage = SpaceDamage(Point(2,1))
	damage.sPawn = "ArtiMech"
	effect:AddDamage(damage)
	
	effect:AddDelay(0.7)
	damage = SpaceDamage(Point(2,4))
	damage.sPawn = "TankMech"
	effect:AddDamage(damage)
	
	effect:AddDelay(1.5)
	
	effect:AddScript("Board:GetPawn(Point(3,3)):FireWeapon(Point(4,3),1)")
	effect:AddScript("Board:GetPawn(Point(2,1)):FireWeapon(Point(4,1),1)")
	
	--effect:AddDelay(2)
	
	Board:AddEffect(effect)
end