

Mission_Dam = Mission_Infinite:new{ 
	MapTags = {"dam"},
	Dam = nil,
	DamPos = nil,
	Flooded = false,
	Objectives = Objective("Destroy the dam",1),
}

function Mission_Dam:StartMission()
	local dam = PAWN_FACTORY:CreatePawn("Dam_Pawn")
	Board:AddPawn(dam,"dam")
	self.DamPos = dam:GetSpace()
	self.Dam = dam:GetId()
	Board:SetTerrain(self.DamPos,TERRAIN_WATER)
	Board:SetTerrain(self.DamPos + Point(1,0), TERRAIN_WATER)
	self.Flooded = false
end

function Mission_Dam:IsEndBlocked()
	return Board:IsPawnAlive(self.Dam)--give the players a chance to destroy the dam
end

function Mission_Dam:UpdateObjectives()
	local status = Board:IsPawnAlive(self.Dam) and OBJ_STANDARD or OBJ_COMPLETE
	
	Game:AddObjective("Destroy the dam",status)
end

function Mission_Dam:GetCompletedObjectives()
	if Board:IsPawnAlive(self.Dam) then
		return self.Objectives:Failed()
	else
		return self.Objectives
	end
end

function Mission_Dam:NextTurn()
	if Game:GetTeamTurn() == TEAM_PLAYER and Game:GetTurnCount() == 3 and Board:IsPawnAlive(self.Dam) then
		PrepareVoiceEvent("Mission_Dam_Reminder")
	end
end

function Mission_Dam:UpdateMission()
	if not Board:IsPawnAlive(self.Dam) and not self.Flooded then
	    local effect = SkillEffect()
		for y = 1, 7 do
			for x = 0, 1 do
				local floodAnim = SpaceDamage(self.DamPos + Point(1*x,y))
				floodAnim.iTerrain = TERRAIN_WATER
				effect:AddDamage(floodAnim)
				effect:AddBounce(floodAnim.loc,-6)
			end
		effect:AddDelay(0.3)
		end
		
		self.Flooded = true
		Board:AddEffect(effect)
	end
end

Dam_Pawn = 
{
	Name = "Old Earth Dam",
	Health = 2,
	Neutral = true,
	Image = "dam_dual",
	MoveSpeed = 0,
	DefaultTeam = TEAM_NONE,
	SoundLocation = "/support/dam",
	IgnoreSmoke = true,
	ExtraSpaces = { Point(1,0) },
	Pushable = false,
	Corpse = true,
	Massive = true,
	IsPortrait = false
}

AddPawn("Dam_Pawn")