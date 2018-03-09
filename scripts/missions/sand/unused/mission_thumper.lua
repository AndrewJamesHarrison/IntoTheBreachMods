
Mission_Thumper = Mission_Infinite:new{ 
	UseBonus = true,
	MapTags = {"thumper"},
	SpawnMod = 1,
}

function Mission_Thumper:StartMission()
	Board:AddPawn(PAWN_FACTORY:CreatePawn("Thumper"),"thumper")
end

Thumper = 
{
	Name = "Thumper",
	Image = "generator1",
	Health = 3,
	MoveSpeed = 0,
	SkillList = { "Thumper_Attack" }, 
	DefaultTeam = TEAM_PLAYER,
	Pushable = false,
	Corporate = true,
	Neutral = true
}

AddPawn("Thumper") 

Thumper_Attack = Skill:new{
	Name = "Thumper",
	Description = "",
	Explosion = "",
	Range = 1,
	PathSize = 1
}

--[[function Thumper_Attack:GetTargetArea(point)
	local ret = PointList()
	
	for dir = DIR_START, DIR_END do
		local curr = point + DIR_VECTORS[dir]
		while Board:IsValid(curr) do
			ret:push_back(curr)
			curr = curr + DIR_VECTORS[dir]
		end
	end
	
	return ret
end]]--

function Thumper_Attack:GetTargetScore(p1)
	return 10
end

function Thumper_Attack:GetSkillEffect(p1,p2)
	local dir = GetDirection(p2-p1)
	local ret = SkillEffect()
	local damage = SpaceDamage(0)
	
	damage.sScript = "Board:Bounce(Point("..p1.x..","..p1.y.."),-8) Board:StartShake(0.5)"
	damage.fDelay = 0.4
	ret:AddQueuedDamage(damage)
	damage.fDelay = 0
	
	--for j = 1, 3 do
		for i = 1, 8 do
			for dir = DIR_START, DIR_END do
				
				damage.iDamage = DAMAGE_DEATH --j == 3 and DAMAGE_DEATH or 0
				damage.loc = p1 + DIR_VECTORS[dir]*i
				
				local height = -10 --j == 3 and -10 or -5
				damage.sScript = "Board:Bounce(Point("..damage.loc.x..","..damage.loc.y.."),"..height..")"
				
				if Board:IsValid(damage.loc) then
					ret:AddQueuedDamage(damage)
				end
			end
			local dummy = SpaceDamage()
			dummy.fDelay = 0.1
			ret:AddQueuedDamage(dummy)
		end
	--end
	
	return ret
end
