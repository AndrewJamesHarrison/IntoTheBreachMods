
--------------------------------------------------------
Pawn_Airfield = 
	{
		Name = "Airfield",
		Health = 1,
		Image = "anim_airfield",
		MoveSpeed = 0,
		DefaultTeam = TEAM_PLAYER,
	}
	
AddPawn("Pawn_Airfield")

--------------------------------------------------------

Structure_Force = Grenade_Base:new{  
	Name = "Targeted Strike", 
	Description = "Deals 1 damage and pushes all adjacent squares.",
	Icon = "weapons/structure_force.png",
	DamageInner = 1,
	InnerAnimation = "explo_fire1",
	Limited = 1
}	

function Structure_Force:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	ret:AddAirstrike(p2,"units/player/mech_jet_1.png")
	local dam = SpaceDamage(p2,1)
	dam.sAnimation = "explo_fire1"
	ret:AddDamage(dam)
	
	for i = DIR_START, DIR_END do
		dam = SpaceDamage(p2 + DIR_VECTORS[i],0,i)
		dam.sAnimation = PUSH_ANIMS[i]
		ret:AddDamage(dam)
	end
	
	return ret
end				
----------------------------------------------------------

Structure_Repair = Skill:new{
	Name = "Repair Bots",
	Description = "Heal all player units (including disabled Mechs)",
	Limited = 1
}

function Structure_Repair:GetTargetArea(point)
	local ret = PointList()
	
	local board_size = Board:GetSize()
	for i = 0, board_size.x - 1 do
		for j = 0, board_size.y - 1  do
			if Board:IsPawnTeam(Point(i,j),TEAM_PLAYER) then
				ret:push_back(Point(i,j))
			end
		end
	end
	
	return ret
end
				
function Structure_Repair:GetSkillEffect(p1, p2)
	local targets = Structure_Repair:GetTargetArea(point)
	
	local ret = SkillEffect()
	
	for i = 1, targets:size() do
		ret:AddDamage(SpaceDamage(targets:index(i),-5))
	end
	
	return ret
end



