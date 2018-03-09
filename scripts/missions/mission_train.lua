Mission_Train = Mission_Infinite:new{ 
	Objectives = Objective("Defend the train",2),
	MapTags = {"train"},
	Train = -1,
	TrainLoc = Point(-1,-1),
	TurnLimit = 3,
	TrainStopped = false,
	UseBonus = false,
}

function Mission_Train:StartMission()
	local train = PAWN_FACTORY:CreatePawn("Train_Pawn")
	self.Train = train:GetId()
	Board:AddPawn(train,Point(4,6))
end

function Mission_Train:IsTrainAlive()
	return Board:IsPawnAlive(self.Train)
end	

function Mission_Train:UpdateObjectives()
	local status = not self.TrainStopped and OBJ_STANDARD or OBJ_FAILED
	
	Game:AddObjective("Defend the train",status, REWARD_REP, 2)
	
	status = self:IsTrainAlive() and OBJ_STANDARD or OBJ_FAILED
	
	if self.TrainStopped then
		Game:AddObjective("Defend the damaged train",status, REWARD_REP, 1)
	end
	
	if self:IsTrainAlive() then
		if self.TrainStopped then Game:AddNote("The train is damaged and will no longer move") 
		else Game:AddNote("If the train is blocked when moving, it will explode") end
	end
end

function Mission_Train:GetCompletedObjectives()
	if self:IsTrainAlive() then
		if self.TrainStopped then
			return Objective("Defend the train (damaged)", 1, 2)
		else
			return self.Objectives
		end
	end
	
	return self.Objectives:Failed()
end

function Mission_Train:StopTrain()
	local trainPawn = Board:GetPawn(self.Train)
	if trainPawn then Board:RemovePawn(trainPawn) end
	
	local train = PAWN_FACTORY:CreatePawn("Train_Damaged")
	self.Train = train:GetId()
	Board:AddPawn(train,self.TrainLoc)
	self.TrainStopped = true
	
	--self:TriggerMissionEvent("TrainStopped")
end

function Mission_Train:UpdateMission()
	
	--if not self:IsTrainAlive() and self.TrainStopped then
	--	self:TriggerMissionEvent("TrainDestroyed")
--	end
	
	if self.TrainStopped then trainDesc = "It is too damaged to continue. Defend it." end
	
	local trainPawn = Board:GetPawn(self.Train)
		
	if not self:IsTrainAlive() then
		if not self.TrainStopped then
			self:StopTrain()
			return
		end
	end
	
	self.TrainLoc = trainPawn:GetSpace()
	
	if self.TrainStopped then
		trainPawn:SetActive(false)
	end
end

------- UNIT AND SKILLS FOR THE MISSION -------------------

Train_Pawn = 
{
	Name = "Supply Train",
	Health = 1,
	Neutral = true,
	Image = "train_dual",
	MoveSpeed = 0,
	SkillList = { "Train_Move" },
	DefaultTeam = TEAM_PLAYER,
	IgnoreSmoke = true,
	IgnoreFire = true,
	ExtraSpaces = { Point(0,1) },
	SoundLocation = "/support/train",
	Pushable = false,
	Corporate = true,
	Corpse = true
}
	
AddPawn("Train_Pawn") 

Train_Damaged = 
{
	Name = "Damaged Train",
	Health = 1,
	Neutral = true,
	IgnoreFire = true,
	Image = "train_dual_damaged",
	MoveSpeed = 0,
	SkillList = { },
	DefaultTeam = TEAM_PLAYER,
	Corpse = true,
	SoundLocation = "/support/train",
	ExtraSpaces = { Point(0,1) },
	Pushable = false,
	Corporate = true
}
	
AddPawn("Train_Damaged")
--------------------

Train_Move = Skill:new{
	Name = "Choo Choo",
	Class = "Enemy",
	Description = "Move forward 2 spaces, but will be destroyed if blocked.",
	AttackAnimation = "ExploArt2",
	LaunchSound = "/support/train/move",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,2),
		CustomPawn = "Train_Pawn"
	}
}

function Train_Move:GetTargetArea(point)
	local ret = PointList()
	ret:push_back(point + VEC_UP)
	return ret
end

function Train_Move:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local q_move = PointList()
	
	q_move:push_back(p1)
	local current = p2
	local damage = Point(-1,-1)
	for k = 1, 2 do
		if Board:IsBlocked(current, PATH_GROUND) and Board:IsValid(current) then
			ret:AddQueuedCharge(q_move, FULL_DELAY)
			local damage = SpaceDamage(current, DAMAGE_DEATH)
			ret:AddQueuedDamage(damage)
			damage.sImageMark = "combat/arrow_hit.png"
			damage.loc = current + VEC_DOWN
			damage.iDamage = DAMAGE_DEATH
			ret:AddQueuedDamage(damage)
			return ret
		elseif Board:IsValid(current) then
			q_move:push_back(current)
		end
		
		current = current + VEC_UP
	end
	
	ret:AddQueuedCharge(q_move, FULL_DELAY)
		
	return ret
end

function Train_Move:GetTargetScore(p1, p2)
	return 100
end