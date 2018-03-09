
Mission_Filler = Mission_Infinite:new{
	UseBonus = true,
	MapTags = {"filler"},
	Objectives = Objective("Defend the Earth Mover", 1),
	Filler = nil,
}

function Mission_Filler:StartMission()
	local unit = PAWN_FACTORY:CreatePawn("Filler_Pawn")
	local loc = Board:AddPawn(unit,"filler")
	Board:SetTerrain(loc,TERRAIN_ROAD)
	self.Filler = unit:GetId()
end

function Mission_Filler:UpdateObjectives()
	local status = Board:IsPawnAlive(self.Filler) and OBJ_STANDARD or OBJ_FAILED
	
	Game:AddObjective("Defend the Earth Mover",status)
end

function Mission_Filler:GetCompletedObjectives()
	if Board:IsPawnAlive(self.Filler) then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

Filler_Pawn = 
{
	Name = "Earth Mover",
	Image = "generator3",
	Health = 2,
	MoveSpeed = 0,
	SkillList = { "Filler_Attack" }, 
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Pushable = false,
	Corporate = true,
	Neutral = true,
	Corpse = true,
	SoundLocation = "/support/earthmover",
}

AddPawn("Filler_Pawn") 

Filler_Attack = SelfTarget:new{
	Explosion = "",
	TipImage = {
		Unit = Point(2,2),
		Hole = Point(2,1),
		Hole2 = Point(2,0),
		Hole3 = Point(2,3),
		Hole4 = Point(2,4),
		Target = Point(2,2),
		Second_Origin = Point(2,2),
		Second_Target = Point(2,2),
	}
}

function Filler_Attack:GetTargetScore(p1)
	return 10
end

function Filler_Attack:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(0)
	damage.iTerrain = TERRAIN_ROAD
		
	local directions = {DIR_UP, DIR_DOWN}
	local distance = 1
	
	ret:AddBoardShake(0.5)
	
	while true do
		local done = false

		if distance == 1 then
			ret:AddSound("/support/earthmover/attack_first")
		else
			ret:AddSound("/support/earthmover/attack_wave")
		end

		for i = 0, 1 do
			for dir = 1, 2 do 
			    local move_vec = DIR_VECTORS[directions[dir]]*distance
				local curr = p1 + Point(i,0) + move_vec
				
				damage.loc = curr
				ret:AddDamage(damage)
				ret:AddBounce(curr,-6)
				
				if Board:GetTerrain(curr) == TERRAIN_HOLE then
					done = true
				end
			end
		end
		
		ret:AddDelay(0.3)
		if done or distance > 5 then break end
		distance = distance + 1
	end
	
	return ret
end
