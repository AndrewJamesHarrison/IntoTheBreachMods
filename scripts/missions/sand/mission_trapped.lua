
Mission_Trapped = Mission_Infinite:new{
	UseBonus = true,
}

function Mission_Trapped:StartMission()
	local buildings = extract_table(Board:GetBuildings())
	local choices = {}
	
	for i,space in ipairs(buildings) do
		local empties = 0
		for dir = DIR_START, DIR_END do
			if not Board:IsBlocked(space + DIR_VECTORS[dir], PATH_FLYER) then
				empties = empties + 1
			end
		end
		
		if empties > 1 then
			choices[#choices+1] = space
		end
	end
	
	if #choices == 0 then return end
	
	local choice = random_removal(choices)
	Board:ClearSpace(choice)
	Board:AddPawn("Trapped_Building",choice)
	
	if #choices == 0 then return end
	
	local choice2 = random_removal(choices)
	while choice2:Manhattan(choice) == 1 and #choices > 0 do
		choice2 = random_removal(choices)
	end
	
	Board:ClearSpace(choice2)
	Board:AddPawn("Trapped_Building",choice2)
end

Trapped_Building = Pawn:new{
	Image = "trapped_bldg",
	Health = 2,
	MoveSpeed = 0,
	DefaultTeam = TEAM_PLAYER,
	IgnoreSmoke = true,
	Pushable = false,
	IsPortrait = true,
	SkillList = {"Trapped_Explode"}
}

Trapped_Explode = Skill:new{  
	PathSize = 1,
	Name = "Area Blast",
	Description = "Self-Destruct, damaging neighboring tiles.",
	Explosion = "ExploAir2",
}

function Trapped_Explode:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local damage = SpaceDamage(p1,DAMAGE_DEATH)
	ret:AddDamage(damage)
	
	for dir = DIR_START, DIR_END do
		if not Board:IsBuilding(p1 + DIR_VECTORS[dir]) then
			damage.loc = p1 + DIR_VECTORS[dir]
			ret:AddDamage(damage)
		end
	end
	
	return ret
end