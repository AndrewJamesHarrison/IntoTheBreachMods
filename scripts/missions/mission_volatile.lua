-------------------------

Mission_Volatile = Mission_Auto:new{ 
	Objectives = Objective("Do not kill the Volatile Vek", 1, 1),
	Target = -1,
	TargetDied = false,
	TargetLeft = false,
	UseBonus = false,
	SpawnStartMod = -1
}

function Mission_Volatile:GetCompletedObjectives()
	if not self.TargetDied then
		return self.Objectives
	end
	return self.Objectives:Failed()
end

function Mission_Volatile:NextTurn()
	if Game:GetTurnCount() == 1 and Game:GetTeamTurn() == TEAM_PLAYER then
		Game:AddTutorial("Tutorial_VolatileVek",Board:GetPawnSpace(self.Target));
	end
end

function Mission_Volatile:UpdateObjectives()
	local status = self.TargetDied and OBJ_FAILED or OBJ_STANDARD
	Game:AddObjective("Don't let the Volatile \nVek die",status)
--	Game:AddObjective("Defeat all other enemies")
end

function Mission_Volatile:StartMission()
	self.Target = Board:SpawnPawn("GlowingScorpion")
	if Board:IsPawnAlive(self.Target) then
		Board:GetPawn(self.Target):SetMissionCritical(true)
	end
end

function Mission_Volatile:UpdateMission()
	self.TargetDied = not Board:IsPawnAlive(self.Target) and not self.TargetLeft
	
	if Board:GetEnemyCount() == 1 and not self.TargetDied and not self.TargetLeft and not self.InfiniteSpawn then
		Board:GetPawn(self.Target):Retreat()
		self.TargetLeft = true
	end
	
end

---------

GlowingScorpion = 
	{
		Name = "Volatile Vek",
		Health = 4,
		Image = "scorpion",
		ImageOffset = 3,
		MoveSpeed = 3,
		SkillList = { "ScorpionAtk1" },
		SoundLocation = "/enemy/scorpion_soldier_1/",
		DefaultTeam = TEAM_ENEMY,
		Explodes = true,
	}
AddPawn("GlowingScorpion")

--[[function GlowingScorpion:GetDeathEffect(point)
	local ret = SkillEffect()
	local damage = SpaceDamage(point,2)
	damage.sAnimation = "ExploAir2"
	ret:AddDamage(damage)
	for dir = DIR_START, DIR_END do
		damage.loc = point + DIR_VECTORS[dir]
		ret:AddDamage(damage)
	end
	return ret
end]]--


