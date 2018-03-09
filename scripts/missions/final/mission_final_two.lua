local FAST_VERSION = not IsRelease() --debug purposes

Mission_Final_Cave = Mission_Infinite:new{
	MapTags = { "final_cave" },
	Environment = "Env_Final",
	SpawnStart = 3,
	MaxEnemy = 7,
	MaxEnemy_Easy = 6,
	SpawnMod = 1,
	UseBonus = false,
	CustomTile = "tiles_lava",
	PhaseCount = 2,
	BossList = {"BeetleBoss", "FireflyBoss", "HornetBoss",}
}

local function SpawnMechs(effect,zone)
	for i = 0,2 do
		local choice = random_removal(zone)
		effect:AddScript("Board:GetPawn("..(i).."):SetSpace("..choice:GetString()..") Board:GetPawn("..(i).."):SpawnAnimation()")
		effect:AddDelay(0.5)
	end
end

function Mission_Final_Cave:MissionEnd()
	local effect = SkillEffect()
	
	effect:AddVoice("MissionFinal_BombArmed",PAWN_ID_CEO)--bomb is going off
	effect:AddDelay(5.5)
	effect:AddScript("Board:StartMechTravel()")
	
	Board:AddEffect(effect)
end

function Mission_Final_Cave:NextTurn()

end

function Mission_Final_Cave:IsFinalTurn()
	return false --let it always spawn enemies just in case the bomb is destroyed
end

function Mission_Final_Cave:StartMission()
	local effect = SkillEffect()
	self:GetSpawner():SetSpawnIsland(5)
	self:GetSpawner():ModifyCount("Scorpion",2)
	self:GetSpawner():ModifyCount("Leaper",2)
	
	local pylons = extract_table(Board:GetZone("pylons"))
	local drop_zone = extract_table(Board:GetZone("deployment"))
	local bomb_loc = random_removal(drop_zone)
	
	if random_int(2) == 0 then
		Board:SpawnPawn(self:NextPawn(),bomb_loc)
	end
	
	effect:AddDelay(2)
	effect:AddBoardShake(3)
	local mounts = extract_table(Board:GetZone("mountain"))
	local rock = SpaceDamage(Point(0,0),DAMAGE_DEATH)
	while #mounts > 0 do
		rock.loc = random_removal(mounts)
		rock.iDamage = DAMAGE_DEATH
		Board:BlockSpawn(rock.loc,BLOCKED_TEMP)
		effect:AddDropper(rock,"effects/shotdown_rock.png")
		effect:AddDelay(0.2)
	end
	
	effect:AddDelay(1)
	SpawnMechs(effect,drop_zone)
	
	effect:AddDelay(1)
	
	if not FAST_VERSION then
		effect:AddVoice("MissionFinal_Pylons",PAWN_ID_CEO)
		effect:AddDelay(3)
	end
	
	local building = SpaceDamage(Point(0,0),0)
	building.iTerrain = TERRAIN_BUILDING
	while #pylons > 0 do
		building.loc = random_removal(pylons)
		Board:BlockSpawn(building.loc,BLOCKED_PERM)
		if Board:IsPawnSpace(building.loc) then
			building.iDamage = DAMAGE_DEATH
		end
		effect:AddDropper(building,"combat/tiles_grass/building_fall.png")
		effect:AddDropper(building,"combat/tiles_grass/building_fall.png")
		if not FAST_VERSION then
			effect:AddDelay(0.5)
		end
	end
	
	if not FAST_VERSION then
		effect:AddVoice("MissionFinal_Bomb",PAWN_ID_MECH)
		effect:AddVoice("MissionFinal_BombResponse",PAWN_ID_CEO)
		effect:AddDelay(7)
	end
	
	effect:AddDelay(2)
	self:AddBomb(effect, bomb_loc)
	
	Board:AddEffect(effect)
	
	Board:SpawnPawn(random_element(self.BossList))
end

function Mission_Final_Cave:UpdateSpawning()
	self:SpawnPawns(self:GetSpawnCount())
	
--	if Game:GetTurnCount() == 2 then
	--	Board:SpawnPawn(random_element(self.BossList))
--	end
end

function Mission_Final_Cave:UpdateMission()
	if Board:IsBusy() then return end
	
	if not IsBomb() then
		local effect = SkillEffect()
		self:AddBomb(effect)
		self.TurnLimit = self.TurnLimit + 2
		Board:AddEffect(effect)
	end
end

function Mission_Final_Cave:UpdateObjectives()
	Game:AddObjective("Defend the Renfield Bomb until it explodes",OBJ_STANDARD,REWARD_REP,0)
end

function Mission_Final_Cave:AddBomb(effect, bomb_loc)
	--local bomb = extract_table(Board:GetZone("bomb"))
	
	if bomb_loc == nil then
		local choices = {}
		
		for i = 0,7 do
			for j = 0,7 do
				local curr = Point(i,j)
				if Board:GetPawnTeam(curr) ~= TEAM_PLAYER and 
					not Board:IsBuilding(curr) and 
					not Board:IsEnvironmentDanger(curr) then
					choices[#choices+1] = curr
				end
			end
		end
		
		if #choices == 0 then
			LOG("This can't happen. There aren't enough player units or buildings")
			bomb_loc = Point(4,4)
		else
			local choice = random_removal(choices)
			
			while #choices > 0 and (choice.x <= 1 or choice.x >= 6 or choice.y <= 1 or choice.y >= 6) do
				choice = random_removal(choices)
			end
			
			bomb_loc = choice
		end
	end
	--bomb_loc = bomb_loc or random_removal(bomb)
	
	--while Board:GetPawnTeam(bomb_loc) == TEAM_PLAYER do
	--	bomb_loc = random_removal(bomb)
	--end
	
	local add_bomb = SpaceDamage(bomb_loc,0)
	add_bomb.sPawn = "BigBomb"
	add_bomb.sSound = "/props/bomb_impact"
	add_bomb.iTerrain = TERRAIN_ROAD
	effect:AddDropper(add_bomb,"units/mission/bomb.png")
end


function Mission_Final_Cave:IsEndBlocked()
	return true
end

BigBomb = {
	Name = "Renfield Bomb",
	Health = 4,
	Neutral = true,
	Corpse = false,
	IgnoreFire = true,
	MoveSpeed = 0,
	Image = "bomb1",
	DefaultTeam = TEAM_PLAYER,
	IsPortrait = false
}
AddPawn("BigBomb") 
