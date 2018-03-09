
Mission_Piston = Mission_Auto:new{ 
	MapTags = {"pistons"},
	UseBonus = true,
	Count = 4
}

function Mission_Piston:StartMission()
	local zone = extract_table(Board:GetZone("pistons"))
	local names = { "Pawn_Piston_U", "Pawn_Piston_R", "Pawn_Piston_D", "Pawn_Piston_L" }
	
	local count = 0
	while count < self.Count and #zone > 0 do
		local p = random_removal(zone)
		local choices = {}
		for dir = DIR_START, DIR_END do
			local curr = p + DIR_VECTORS[dir]
			local terrain = Board:GetTerrain(curr)
			if	terrain ~= TERRAIN_BUILDING 
					and terrain ~= TERRAIN_MOUNTAIN
					and terrain ~= TERRAIN_WATER
                    and not Board:IsPawnSpace(curr)
					and Board:IsValid(curr) 
					and not Board:IsEdge(curr) then 
					
				choices[#choices+1] = dir
				
			end
		end
		
		if #choices > 0 then
			count = count + 1
			local dir = random_element(choices)
			Board:ClearSpace(p)
			Board:AddPawn(PAWN_FACTORY:CreatePawn(names[dir + 1]),p)
			
			for i,v in ipairs(zone) do
				if v == p + DIR_VECTORS[dir] then
					table.remove(zone,i)
				end
			end
			
		end
	end
end


Pawn_Piston_U = Pawn:new{
	Name = "Trash Compactor",
	Image = "piston_u",
	Health = 1,
	Neutral = true,
	Corpse = true,
	MoveSpeed = 0,
	SkillList = { "Piston_U_Atk" }, 
	DefaultTeam = TEAM_NONE,
	Pushable = false,
	SpaceColor = false,
	IsPortrait = false
}

Pawn_Piston_R = Pawn_Piston_U:new{ Image = "piston_r", SkillList = { "Piston_R_Atk" } }
Pawn_Piston_L = Pawn_Piston_U:new{ Image = "piston_l", SkillList = { "Piston_L_Atk" } }
Pawn_Piston_D = Pawn_Piston_U:new{ Image = "piston_d", SkillList = { "Piston_D_Atk" } }

---

Piston_U_Atk = SelfTarget:new{  
	Direction = DIR_UP,
	Animation = "piston_u_push",
}

function Piston_U_Atk:GetTargetScore(p1, p2)
	return 100
end

function Piston_U_Atk:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p1)
	damage.sAnimation = self.Animation
	damage.bHide = true
	damage.fDelay = 0.15
	ret:AddQueuedDamage(damage)
	ret:AddQueuedDamage(SpaceDamage(p1+DIR_VECTORS[self.Direction],0,self.Direction))
	return ret
end

Piston_R_Atk = Piston_U_Atk:new{ Direction = DIR_RIGHT, Animation = "piston_r_push" }
Piston_L_Atk = Piston_U_Atk:new{ Direction = DIR_LEFT, Animation = "piston_l_push" }
Piston_D_Atk = Piston_U_Atk:new{ Direction = DIR_DOWN, Animation = "piston_d_push" }
