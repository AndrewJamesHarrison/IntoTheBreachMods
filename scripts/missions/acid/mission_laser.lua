
Mission_Laser = Mission_Auto:new{ 
	MapTags = {"lasers"},
	UseBonus = true,
	Count = 1
}

function Mission_Laser:GetLaserDirection(p)
	local furthest = 0
	local side = DIR_NONE
	for dir = DIR_START, DIR_END do
		local length = 0
		if dir == DIR_LEFT then length = p.x end
		if dir == DIR_RIGHT then length = 7 - p.x end
		if dir == DIR_UP then length = p.y end
		if dir == DIR_DOWN then length = 7 - p.y end
		
		if length > furthest then
			side = dir
			furthest = length
		end
	end
	
	return side
end

function Mission_Laser:StartMission()
	local zone = extract_table(Board:GetZone("lasers"))
	local names = { "Pawn_Laser_U", "Pawn_Laser_R", "Pawn_Laser_D", "Pawn_Laser_L" }
	
	local count = 0
	while count < self.Count and #zone > 0 do
		local p = random_removal(zone)
		local dir = self:GetLaserDirection(p)
			
		Board:ClearSpace(p)
		Board:AddPawn(PAWN_FACTORY:CreatePawn(names[dir + 1]),p)
        count = count + 1		
	end
end

Pawn_Laser_U = Pawn:new{
	Name = "Laser Thingy",
	Image = "piston_u",
	Health = 1,
	Neutral = true,
	Corpse = true,
	MoveSpeed = 0,
	SkillList = { "Laser_U_Atk" }, 
	DefaultTeam = TEAM_NONE,
	Pushable = false,
	SpaceColor = false,
	IsPortrait = false
}

Pawn_Laser_R = Pawn_Laser_U:new{ Image = "piston_r", SkillList = { "Laser_R_Atk" } }
Pawn_Laser_L = Pawn_Laser_U:new{ Image = "piston_l", SkillList = { "Laser_L_Atk" } }
Pawn_Laser_D = Pawn_Laser_U:new{ Image = "piston_d", SkillList = { "Laser_D_Atk" } }

---

Laser_U_Atk = Laser_Base:new{  
	Direction = DIR_UP,
	Damage = 5,
	MinDamage = 1,
}

function Laser_U_Atk:GetTargetArea(p1)
	local ret = PointList()
	ret:push_back(p1)
	return ret
end

function Laser_U_Atk:GetTargetScore(p1, p2)
	return 100
end

function Laser_U_Atk:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	self:AddQueuedLaser(ret, p1 + DIR_VECTORS[self.Direction], self.Direction)
	return ret
end

Laser_R_Atk = Laser_U_Atk:new{ Direction = DIR_RIGHT }
Laser_L_Atk = Laser_U_Atk:new{ Direction = DIR_LEFT }
Laser_D_Atk = Laser_U_Atk:new{ Direction = DIR_DOWN }
