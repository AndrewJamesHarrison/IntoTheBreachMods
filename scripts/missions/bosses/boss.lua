
Mission_Boss = Mission_Infinite:new{
	BossPawn = "",
	BossID = -1,
	BossText = "",
	BossMission = true,
	BossGeneric = true,--use generic boss briefing
}

--hack to make this mission's custom text higher priority for briefings
function Mission_Boss:GetRewardCount()
	return 2
end

function Mission_Boss:GetObjectives()
	return Objective(self.BossText,1)
end

function Mission_Boss:GetBossPawn()
	return self.BossPawn
end

function Mission_Boss:IsBossDead()
	return not Board:IsPawnAlive(self.BossID)
end

function Mission_Boss:GetCompletedStatus()
	if self:GetBonusStatus(BONUS_ASSET, true) == OBJ_FAILED then
		return "Tower"
	elseif self:IsBossDead() then
		return "Success"
	else
		return "Boss"
	end
end

function Mission_Boss:Initialize()
	self.BonusObjs = {}
	self:AddAsset("Str_Tower")
end

function Mission_Boss:StartBoss()
	local pawn = PAWN_FACTORY:CreatePawn(self:GetBossPawn())
	self.BossID = pawn:GetId()
	Board:AddPawn(pawn)
	
	if self:GetBossPawn() == "ScorpionBoss" then
		self:GetSpawner():ModifyCount("Scorpion",1)
	end
end

function Mission_Boss:NextTurn()
	if Game:GetTurnCount() == 1 and Game:GetTeamTurn() == TEAM_PLAYER then
		Game:AddTutorial("Tutorial_InfoButton",Board:GetPawnSpace(self.BossID));
	end
end


function Mission_Boss:StartMission()
	self:StartBoss()
end

function Mission_Boss:UpdateObjectives()
	local status = self:IsBossDead() and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective(self.BossText,status)
end

function Mission_Boss:GetCompletedObjectives()
	if self:IsBossDead() then
		return self:GetObjectives()
	else
		return self:GetObjectives():Failed()
	end
end