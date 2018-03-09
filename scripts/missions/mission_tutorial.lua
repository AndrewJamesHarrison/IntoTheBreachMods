
TUT_ATTACKS = 0
TUT_COMBATMECH = 1


Mission_Tutorial = Mission:new{ 
	Name = "Tutorial",
	MapList = { "tutorial" },
	MapTags = "",
	TurnLimit = 7,
	SpawnStartMod = -10,
	Punch_ID = -1,
	Tank_ID = -1,
	Art_ID = -1,
	State = -1,
	
	---Positions of units on the map
	Firefly1 = Point(3,5),
	Firefly1_Target = Point(3,6),
	Firefly2 = Point(6,1),
	Firefly2_Target = Point(6,0),
	Hornet1 = Point(5,4),
	Hornet1_Target = Point(4,4),
	Hornet2 = Point(6,4),
	Hornet2_Target = Point(6,3),
	Hornet3 = Point(5,5),
	Hornet3_Target = Point(4,5),
	PunchMech = Point(1,4),
	Tank = Point(0,2),
	Artillery = Point(1,4),
	
	ShowedArmingTip = false,
	
	TaughtUndo = false,
	TeachingUndo = false,
	UndoPawn = nil,
	
	ShowingPushTip = false,
	PushTipLoc = Point(-1,-1),
	ShowingTankTip = false,
	
	GameoverTip = false,
	UseBonus = false,
}

function Mission_Tutorial:StartMission()

end

function Mission_Tutorial:NextTurn()

	if Game:GetTeamTurn() == TEAM_ENEMY then
		if Game:GetTurnCount() == 0 then
			local Firefly = PAWN_FACTORY:CreatePawn("Firefly1")
			Firefly:SetPriorityTarget(self.Firefly1_Target)
			Firefly:SetMoveSpeed(0)
			Board:SpawnPawn(Firefly,self.Firefly1)
		elseif Game:GetTurnCount() == 1 then
			local Firefly2 = PAWN_FACTORY:CreatePawn("Leaper1")
			Firefly2:SetPriorityTarget(self.Firefly2_Target)
			Firefly2:SetMoveSpeed(0)
			Board:SpawnPawn(Firefly2,self.Firefly2)
		elseif Game:GetTurnCount() == 2 then
			local Hornet1 = PAWN_FACTORY:CreatePawn("Hornet1")
			Hornet1:SetPriorityTarget(self.Hornet1_Target)
			Hornet1:SetMoveSpeed(0)
			Board:SpawnPawn(Hornet1,self.Hornet1)
			
			local Hornet2 = PAWN_FACTORY:CreatePawn("Firefly1")
			Hornet2:SetPriorityTarget(self.Hornet2_Target)
			Hornet2:SetMoveSpeed(0)
			Board:SpawnPawn(Hornet2,self.Hornet2)
			
			local Hornet3 = PAWN_FACTORY:CreatePawn("Firefly1")
			Hornet3:SetPriorityTarget(self.Hornet2_Target)
			Hornet3:SetMoveSpeed(0)
			Board:SpawnPawn(Hornet3,self.Hornet3)
			
			Game:ClearTips()
		elseif Game:GetTurnCount() == 3 then
		
			Game:ClearTips()
			
			local count = Board:GetEnemyCount()
			
			Board:SpawnPawn("Firefly1")
			Board:SpawnPawn("Hornet1")
			
			if count <= 1 then
				Board:SpawnPawn("Firefly1")
			end
			
			if count == 0 then
				Board:SpawnPawn("Hornet1")
			end
		end
	end
	
	Board:SpawnQueued()--instantly spawn anything that spawned above
	
	if Game:GetTeamTurn() == TEAM_PLAYER then
	
		---INITIALIZE FIRST TURN STUFF -----
		if Game:GetTurnCount() == 1 then

			Game:AddVerticalInterfaceTip("Tutorial_CombatPower", Location["combat_morale_bar"] + Point(160,40))
				
			Game:AddTip("Tutorial_CombatMonster", self.Firefly1);
			
            self.State = 1
			
			Game:BlockNextTurn()
			
		--- INITIALIZE SECOND TURN STUFF -----	
		elseif Game:GetTurnCount() == 2 then
		
			local Tank = PAWN_FACTORY:CreatePawn("TankMech")
			Tank:SetMech()
			Board:SpawnPawn(Tank,self.Tank)
			self.Tank_ID = Tank:GetId()
			
			Game:AddTip("Tutorial_CombatTank", self.Tank);
			self.State = 1
						
		elseif Game:GetTurnCount() == 3 then
			local Artillery = PAWN_FACTORY:CreatePawn("ArtiMech")
			Artillery:SetMech()
			Board:SpawnPawn(Artillery,self.Artillery)
			self.Art_ID = Artillery:GetId()
			self.State = 1
			
		elseif Game:GetTurnCount() == 4 then
		
			local objective_point = Point(Boxes["objective_info"].x, Boxes["objective_info"].y)
			objective_point = objective_point + Point(50,-20)
			Game:AddVerticalInterfaceTip("Tutorial_CombatComplete",objective_point)
			objective_point.y = objective_point.y + 100
			Game:AddVerticalInterfaceTip("Tutorial_CombatBonus",objective_point)	
		end
	end
	
end

function Mission_Tutorial:AddUndoTip()
    local tipPoint = Buttons["undo"].pos
	tipPoint.x = tipPoint.x + Buttons["undo"].hitstats.w + 10
	tipPoint.y = tipPoint.y + Buttons["undo"].hitstats.h/2
	Game:AddInterfaceTip("Tutorial_CombatUndo",tipPoint)
	self.TeachingUndo = true
end

function Mission_Tutorial:GetCompletedObjectives()
	local available = Board:GetEnemyCount() <= 0 and 0 or 1
	return Objective("Kill all enemies before they retreat", 0,available)
end

function Mission_Tutorial:UpdateObjectives()
	if Game:GetTurnCount() > 3 then
		local status = Board:GetEnemyCount() <= 0 and OBJ_COMPLETE or OBJ_STANDARD
		Game:AddObjective("Kill all enemies before \nthey retreat",status,REWARD_REP,0)
	end
end

function Mission_Tutorial:UpdateTurnOne()

	if self.State == 1 and not Game:IsTip() then 
		local PunchMech = PAWN_FACTORY:CreatePawn("PunchMech")
		PunchMech:SetMech()
		PunchMech:SetPriorityTarget(self.Firefly1)
		self.Punch_ID = PunchMech:GetId()
		Board:SpawnPawn(PunchMech,self.PunchMech)
		Game:AddPermaTip("Tutorial_CombatMech", self.PunchMech);
		
		self.State = 2
	end
	
	if self.State == 2 and Board:GetPawn(self.Punch_ID):IsSelected() and not self.TeachingUndo then
		Game:ClearTips()
		Game:AddPermaTip("Tutorial_CombatPunch",self.Firefly1)
		self.State = 3
	end
	
	if self.State == 3 and not self.TaughtUndo and not self.TeachingUndo then
		local currPoint = Board:GetPawn(self.Punch_ID):GetSpace()
		if currPoint ~= self.PunchMech and currPoint ~= Point(2,5) and not Board:GetPawn(self.Punch_ID):IsBusy() then
			Game:ClearTips()
			self:AddUndoTip()
			self.State = 2
			self.UndoPawn = Board:GetPawn(self.Punch_ID)
		end
	end
	
	if self.State == 3 then
		if Board:GetPawn(self.Punch_ID):GetSpace() == Point(2,5) then 
			Game:ClearTips()
			local weaponTip = Point(300, -100)
			Game:AddInterfaceTip("Tutorial_CombatWeapon", Location["mech_box"] + weaponTip)
			self.State = 4
		end
	end
	
	if self.State == 4 then
		local pawn = Board:GetPawn(self.Punch_ID)
		local weaponArmed = pawn:IsWeaponArmed() and pawn:GetArmedWeaponId() ~= 0
		
		if weaponArmed or not Game:IsTip() then 
			Game:ClearTips()
			Game:AddPermaTip("Tutorial_CombatPunch",self.Firefly1)
			self.State = 5
		end
	end
	
	if self.State == 5 then
		if Board:IsPawnSpace(self.Firefly1) then
			Board:MarkSpaceSimpleColor(self.Firefly1,COLOR_YELLOW) 	
		else
			self.State = 6
			Game:ClearTips()
			Game:AddTip("Tutorial_CombatPush",self.Firefly1 + Point(1,0))
		end
	end
	
	if self.State == 6 and not Game:IsTip() then
		local tipPoint = Buttons["action_end"].pos
		tipPoint.x = tipPoint.x + Buttons["action_end"].hitstats.w + 10
		tipPoint.y = tipPoint.y + Buttons["action_end"].hitstats.h/2
        Game:AddInterfaceTip("Tutorial_CombatEnd", tipPoint)
		self.State = 7
	end
	
	if self.State ~= 7 and self.State > 0 then
		Game:BlockNextTurn()
	end
end

function Mission_Tutorial:UpdateTurnTwo()

	local pawn = Board:GetPawn(self.Tank_ID)

	if self.State == 1 then
		if pawn:IsSelected() then
			Game:ClearTips()
		end
		
		if not Game:IsTip() then
			self.State = 2
		--	Game:AddPermaTip("Shoot this monster with your tank!","",self.Firefly2)
		end
	end
	
	
	if self.State == 2 then
		if pawn:IsWeaponArmed() and pawn:GetArmedWeaponId() ~= 0 then
			self.State = 3
			Game:AddPermaTip("Tutorial_CombatAiming",pawn:GetSpace() + Point(1,0))
		end
	end
	
	if self.State == 3 then
		if not pawn:IsWeaponArmed() or pawn:GetArmedWeaponId() == 0 then
			self.State = 4
			Game:ClearTips()
		end
	end
	 	
	if self.State < 2 then
		Game:BlockNextTurn()
	end	
end

function Mission_Tutorial:UpdateTurnThree()
	if self.State == 1 then
		if Board:GetPawn(self.Art_ID):IsSelected() and not self.TeachingUndo then
			Game:ClearTips()
		end
		
		if not Game:IsTip() then
			self.State = 2
		end
	end
	 			
	if self.State < 2 then
		Game:BlockNextTurn()
	end	
end

function Mission_Tutorial:UpdateMission()	
	
	if self.TeachingUndo and (not Game:IsTip() or not self.UndoPawn:IsUndoPossible()) then
		self.TeachingUndo = false
		self.TaughtUndo = true
		Game:ClearTips()
	end
	
	if Game:GetTurnCount() == 1 and Game:GetTeamTurn() == TEAM_PLAYER then 
		self:UpdateTurnOne()
	end
	
	if Game:GetTurnCount() == 2 and Game:GetTeamTurn() == TEAM_PLAYER then
		self:UpdateTurnTwo()
	end
	
	if Game:GetTurnCount() == 3 and Game:GetTeamTurn() == TEAM_PLAYER then
		self:UpdateTurnThree()
	end
	
	--CLEAR FIRST TURN RESTRICTIONS ONCE COMPLETE
	if Game:GetTurnCount() > 1 then
		Board:GetPawn(self.Punch_ID):SetPriorityTarget(Point(-1,-1))
	end	
	
--[[	if Game:GetTurnCount() > 1 then
		Board:GetPawn(self.Tank_ID):SetPriorityTarget(Point(-1,-1))
	end
	
	if Game:GetTurnCount() > 2 then
		Board:GetPawn(self.Art_ID):SetPriorityTarget(Point(-1,-1))
	end]]--
	
	if not self.GameoverTip and Game:GetPower():GetValue() == 0 then
		self.GameoverTip = true
		Game:AddVerticalInterfaceTip("Tutorial_CombatGameover", Location["combat_morale_bar"] + Point(160,40))
	end	
end
