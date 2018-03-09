
---- MISSION DESCRIPTION
Mission_Barnicle = Mission:new{
	--Name = "Goo Boss",
	Loss = "Die",
	MapTags = {"goo"},
	SpawnStart = 0,
}

function Mission_Barnicle:StartMission()
	Board:AddPawn(PAWN_FACTORY:CreatePawn("Barnicle"), "blob")
end

Barnicle = 
	{
		Name = "Barnicle",
		Health = 5,
		MoveSpeed = 2,
		Image = "barnicle",		
		SkillList = { },
		MyPawn = "BarnicleFlower",
		DefaultTeam = TEAM_ENEMY,
		Ranged = 1,
		Minor = true
	}
AddPawn("Barnicle") 

BarnicleAtk = Skill:new{
			Name = "Blob Attack",
			Description = "4 DMG and move onto the next space",
			ArtillerySize = 3
		}

function BarnicleAtk:GetTargetArea(point)
	local points = general_DiamondTarget(point, self.ArtillerySize)
	local ret = PointList()
	
	for i = 1, points:size() do
		if not Board:IsBlocked(points:index(i), PATH_GROUND) then
			ret:push_back(points:index(i))
		end
	end
	
	return ret
end
function BarnicleAtk:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
--[[
	for i = DIR_START, DIR_END do
		local damage = SpaceDamage(DIR_VECTORS[i] + p1)
		damage.sPawn = self.MyPawn
		ret:AddDamage(damage)
		
	end
	]]	
	local damage = SpaceDamage(p1 + DIR_VECTORS[DIR_UP])
	damage.sPawn = self.MyPawn
	ret:AddDamage(damage)
		
	damage = SpaceDamage(p2 ,1)
	ret:AddDamage(damage)
	return ret
end	





BarnicleFlower = Barnicle:new
	{
		Name = "Flowerd Barnicle",
		Health = 4,
		Image = "barniclef",		
		SkillList = {  },
		Massive = true,
		DefaultTeam = TEAM_ENEMY
	}
	
AddPawnName("BarnicleFlower") 

function BarnicleFlower:GetDeathEffect(point)
	local ret = SkillEffect()
	
	
	return ret
end

