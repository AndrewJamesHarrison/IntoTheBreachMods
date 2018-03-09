local FAST_VERSION = not IsRelease() --debug purposes

Mission_Final = Mission_Infinite:new{
	MapTags = { "final_island" },
	Environment = "Env_Volcano",
	SpawnStart = 3,
	MaxEnemy = 7,
	MaxEnemy_Easy = 6,
	SpawnMod = 1,
	UseBonus = false,
	CustomTile = "tiles_volcano",
	NextPhase = "Mission_Final_Cave",
	BossList = {"ScorpionBoss", "FireflyBoss", "HornetBoss",}
}

function Mission_Final:StartMission()
	self:GetSpawner():SetSpawnIsland(5)
	local pylons = extract_table(Board:GetZone("pylons"))
	for i,v in ipairs(pylons) do
		Board:BlockSpawn(v,BLOCKED_PERM)
	end
	
	if GetDifficulty() == DIFF_HARD then
		Board:SpawnPawn(random_element(self.BossList))
	end
end

function Mission_Final:NextTurn()
	if Game:GetTurnCount() == 0 and Game:GetTeamTurn() == TEAM_ENEMY then
		local pylons = extract_table(Board:GetZone("pylons"))
		local effect = SkillEffect()
		local building = SpaceDamage(Point(0,0),0)
		building.iTerrain = TERRAIN_BUILDING
		
		--if not FAST_VERSION then
		--	effect:AddVoice("MissionFinal_Start",random_int(0,3))
			--effect:AddVoice("MissionFinal_StartResponse",PAWN_ID_CEO)
			--effect:AddDelay(7)
		--end
		
		effect:AddDelay(4.5)
		
		while #pylons > 0 do
			building.loc = random_removal(pylons)
			if Board:IsPawnSpace(building.loc) then
				building.iDamage = DAMAGE_DEATH
			end
			effect:AddDropper(building,"combat/tiles_grass/building_fall.png")
			effect:AddDropper(building,"combat/tiles_grass/building_fall.png")
			if not FAST_VERSION then
				effect:AddDelay(0.5)
			end
		end
		
		Board:AddEffect(effect)
	end
end

function Mission_Final:MissionEnd()
	
	local effect = SkillEffect()
	local pylons = extract_table(Board:GetZone("pylons"))
	local drop_zone = extract_table(Board:GetZone("deployment"))
		
	effect:AddVoice("MissionFinal_FallStart",PAWN_ID_CEO)
	effect:AddDelay(2.5)
	effect:AddBoardShake(4)
	effect:AddSound("/props/final_ground_break")
	effect:AddDelay(1.5)
	effect:AddVoice("MissionFinal_FallResponse",PAWN_ID_MECH)
	
	fall_zone = extract_table(Board:GetZone("falling"))
	while #fall_zone > 0 do
		effect:AddBounce(random_removal(fall_zone),100)
		effect:AddDelay(0.1)
	end
	
	--effect:AddDelay(0.5)
	
	local pawns = extract_table(Board:GetPawns(TEAM_MECH))
	fall_zone = extract_table(Board:GetZone("falling"))
	
	while #pawns > 0 do
		local choice = Board:GetPawn(random_removal(pawns)):GetSpace()
		local found = false
		for i,v in ipairs(fall_zone) do
			found = found or choice == v
		end
		if not found then
			effect:AddBounce(choice,100)
			effect:AddDelay(0.1)
		end
	end
	
	effect:AddDelay(1)
	effect:AddScript("Board:Slide(DIR_UP)")
	
	Board:AddEffect(effect)
end

function Mission_Final:UpdateMission()
	local super_volcano = {Point(0,0),Point(1,0),Point(0,1),Point(1,1)}
	for i,v in ipairs(super_volcano) do
		Board:MarkSpaceDesc(v,"supervolcano")
		if Board:IsDamaged(v) then
			Board:SetTerrain(v,TERRAIN_MOUNTAIN)
		end
		
		if not Board:IsPawnSpace(v) then
			Board:SetFrozen(v,false)
			Board:RemoveShield(v)
		end
	end
end

function Mission_Final:UpdateObjectives()
	Game:AddObjective("Survive the Fight",OBJ_STANDARD,REWARD_REP,0)
end

function Mission_Final:IsEndBlocked()
	return true
end