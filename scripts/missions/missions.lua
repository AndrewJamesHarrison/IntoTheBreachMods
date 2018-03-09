
function CreateTutorial()
	Mission_ActiveTutorial = Mission_Tutorial:new()
	Mission_ActiveTutorial:Initialize()
end

function CreateMission(mission)
	local new_mission = _G[mission]:new()
	new_mission.ID = mission
	new_mission:Initialize()
--	LOG("Creating mission "..mission)
	
	return new_mission
end

function ReloadMissions(missions)
    if missions == nil then
        return
    end
    
	for i,mission in pairs(missions) do
		local baseMission = mission.ID
		mission = _G[baseMission]:new(mission)
		mission:CreateSpawner(mission.Spawner)
		mission.LiveEnvironment = _G[mission.Environment]:new(mission.LiveEnvironment)
	end
	
	--local loaded = _G[baseMission]:new(_G[mission.."Saved"])
	
	--loaded:CreateSpawner(loaded.Spawner)
	--loaded.LiveEnvironment = _G[loaded.Environment]:new(loaded.LiveEnvironment)
	
	--_G[mission] = loaded
	--_G[mission].ID = baseMission
end

-------------------------------------------------------
------------ Mission Definition -----------------------
-------------------------------------------------------

BONUS_ASSET = 1
BONUS_KILL = 2
BONUS_GRID = 3
BONUS_MECHS = 4
BONUS_BLOCK = 5
BONUS_KILL_FIVE = 6

function PowerObjective(text, value, potential)
	potential = potential or value
	local ret = Objective(text,value,potential)
	ret.category = REWARD_POWER
	return ret
end

Mission = 	{
	Name = "Mission",
	MapList = {},
	InfiniteSpawn = false,
	Spawner = nil,
	Objectives = { },
	BonusObjs = { },
	BonusPool = { BONUS_KILL, BONUS_GRID, BONUS_MECHS },
	UseBonus = true,
	BossMission = false,
	RetreatEndingMessage = true,
	Environment = "Env_Null",
	LiveEnvironment = Env_Null,
	TurnLimit = 4,
	SpawnStart = 5,
	SpawnStart_Easy = {4,5},
	GlobalSpawnMod = 0,--changes ALL spawning
	SpawnStartMod = 0,
	SpawnMod = 0,
	MapTags = "generic",
	MapVetoes = {},
	VoiceEvents = {},
	PowerStart = 0,
	AssetId = "",
	Ambience = "",
	AssetPassive = "",
	AssetLoc = nil,
	MaxEnemy = 6,   --JUSTIN
	MaxEnemy_Easy = 6,
	DiffMod = DIFF_MOD_NONE,
	BlockedSpawns = 0,
	KilledVek = 0,
	BlockEasy = false,
	CustomTile = "",
	NextPhase = "",
	PhaseCount = 1,
}	

function Mission:IsEndBlocked()
	return false
end

function Mission:IsNextPhase()
	return self.NextPhase ~= ""
end

function Mission:GetKillBonus()
	if GetDifficulty() == DIFF_EASY then
		return 5
	else
		return 7
	end
end

function Mission:FlyingSpawns(origin, count, pawn, projectile_info, exclude)
	exclude = exclude or {}
	local projectile = projectile_info.image or ""
	local launch = projectile_info.launch or ""
	local impact = projectile_info.impact or ""
	--local zone = Board:GetReachable(origin, 3, PATH_GROUND)
	local zone = general_DiamondTarget(origin,3)
	
	local hash = function(point) return point.x + point.y*10 end
	
	local dont_use = {}
	for i,v in ipairs(exclude) do
		dont_use[hash(v)] = true
	end

	local i = 1
	while i <= zone:size() do
		if not Board:IsSafe(zone:index(i)) or dont_use[hash(zone:index(i))] then
			zone:erase(i)
		else
			i = i + 1
		end
	end
	
	local ret = {}
	local effect = SkillEffect()
	effect.piOrigin = origin
	effect.impact_sound = impact
	for i = 1, count do	
		if zone:empty() then break end
		local choice = random_int(zone:size()) + 1
		local space = zone:index(choice)
		local damage = SpaceDamage(space)
		damage.sPawn = pawn
		
		if launch ~= "" then
			effect:AddDamage(SoundEffect(space,launch))
		end
		
		effect:AddArtillery(damage, projectile)
		
		zone:erase(choice)
		ret[#ret+1] = space
	end
	
	Board:AddEffect(effect)
		
	return ret
end

function Mission:UndoMove(p1, p2)

end

function Mission:AddDefended(unit)
	local ret = {-1,-1}
	local options = extract_table(Board:GetZone("satellite"))
		
	if #options < self.Count then LOG("DEFEND MISSION: ERROR NO VALID SPACE") return end
	
	local pawn = PAWN_FACTORY:CreatePawn(unit)
	ret[1] = pawn:GetId()
	local choice = random_removal(options)
	Board:SetTerrain(choice, TERRAIN_ROAD)
	Board:AddPawn(pawn,choice)
	
	local choice2 = choice
	while math.abs(choice.x - choice2.x) <= 1 and math.abs(choice.y - choice2.y) <= 1 and #options > 0 do
		choice2 = random_removal(options)
	end
	
	if math.abs(choice.x - choice2.x) <= 1 and math.abs(choice.y - choice2.y) <= 1 then 
		LOG("DEFEND MISSION: ERROR NO VALID SECOND SPACE") 
		return 
	end
		
	pawn = PAWN_FACTORY:CreatePawn(unit)
	ret[2] = pawn:GetId()
	Board:AddPawn(pawn, choice2)
	Board:SetTerrain(choice2, TERRAIN_ROAD)
	
	return ret
end

function Mission:AddAsset(id)

	self.BonusObjs[#self.BonusObjs+1] = BONUS_ASSET
	self.AssetId = id
		
	--if _G[id].Passives then
		--self.AssetPassive = random_element(_G[id].Passives)
	--end
end

function Mission:GetDamage()
	return math.max(0,(self.PowerStart - Game:GetPower():GetValue()))
end

function Mission:TriggerMissionEvent(name)
	if self.VoiceEvents[name] then
		return
	end

	self.VoiceEvents[name] = true
	
	PrepareVoiceEvent(self.ID.."_"..name, -1, -1, 100)
end

function Mission:GetObjectives()
	return self.Objectives
end

function Mission:GetObjectiveList(primary_only)
	primary_only = primary_only or false
	local ret = {}
	
	local objectives = self:GetObjectives()
	if type(objectives) ~= "table" then
		secondary = { objectives }
	else
		secondary = copy_table(objectives)
	end
	
	ret = add_tables(ret,secondary)
	
	if not primary_only then
		ret = add_tables(ret,self:GetBonusList())
	end
	
	return ret
end

function Mission:GetRewardCount(category, primary_only)
	local objectives = self:GetObjectiveList(primary_only)
	category = category or -1
	
	if type(objectives) ~= "table" then
	    objectives = { objectives } 
	end
	
	local total = 0
	for i,v in ipairs(objectives) do
		if v.category == category or category == -1 then
			total = v.potential + total
		end
	end
	
	return total
end

function Mission:GetCompletedStatus()
	local objectives = self:GetCompletedObjectives()
	
	if type(objectives) ~= "table" then
	    objectives = { objectives } 
	end
	
	local total_rep = 0
	local total_possible = 0
	for i,v in ipairs(objectives) do
		total_rep = v.rep + total_rep
		total_possible = v.potential + total_possible
	end
	
	if total_rep == total_possible then
		return "Success"
	elseif total_rep == 0 then
		return "Failure"
	else
		return "Partial"
	end
end

function Mission:GetCompletedObjectives()
	return {}
end

function Mission:BaseCompletedObjectives()
	local secondary = self:GetCompletedObjectives()
	local ret = {}
	
	if type(secondary) ~= "table" then
		secondary = { secondary }
	end
	
	ret = add_tables(ret,secondary)
	ret = add_tables(ret,self:GetBonusCompleted())
			
	return ret
end


-- Briefing -- Focus on unique if present. Example: Mission_Mines *always* addresses the mines to properly setup the mission theme. 

function Mission:GetCeoBriefing(ceo)
	local text = ""
	if Personality[ceo] ~= nil then
		text = GetPilotDialog(ceo, self.ID.."_Briefing")
		
		if text == "" then
			local bonus = self:GetBonusInfo(false)
			local options = {"Mission_Generic_Briefing"}
			
			if self.BossMission and self.BossGeneric then
				options = {"Mission_BossGeneric_Briefing"}
			end
			
			if bonus~= nil and bonus.text_id ~= nil then
				options[#options+1] = bonus.text_id
				options[#options+1] = bonus.text_id
			end
			
			while text == "" and #options > 0 do
				text = GetPilotDialog(ceo, random_removal(options))
			end
		end
	end
	
	if text == "" then
		text = "This is a CEO mission briefing message. It is very atmospheric and exciting, giving you a closer look at the world and the mission you're about to engage in."
	end
	
	return text
end

--[[
1) Full success -- pull from any success possibility for any of the objectives or a generic.

2) Any failure -- pull from the text of any of the possible failed objectives
--]]

function Mission:GetCeoClosing(ceo)
	local text = ""
	
	if Personality[ceo] ~= nil then
		
		if self:GetDamage() > 3 then 
			text = GetPilotDialog(ceo, "Mission_ExtremeDamage")
			if text ~= "" then
				return text
			end
		end
		
		local status = self:GetCompletedStatus()
		local bonus = self:GetBonusInfo(true)
		local success = status == "Success" and (bonus == nil or bonus.success == true)
		local choices = {}
		
		if success then
			choices[#choices + 1] = "Mission_Generic_Success"
		end
		
		if bonus ~= nil and success == bonus.success then
			choices[#choices + 1] = bonus.text_id
		end
	
		if success == (status == "Success") then
			--if priority objective (value > 1) then clear choices
			if self:GetRewardCount(-1,true) > 1 then
				choices = {}
			end
						
			choices[#choices+1] = self.ID.."_"..status
			
			if self.BossMission then
				choices[#choices+1] = "Mission_BossGeneric_"..status
			end
		end
		
		--LOG("\n\nSelecting closing message\n")
	--	local choice_string = "Choices ="
		--for i,v in ipairs(choices) do choice_string = choice_string.." "..v end
		--LOG(choice_string)
		local choice = ""
		while text == "" and #choices > 0 do
		    choice = random_removal(choices)
			text = GetPilotDialog(ceo, choice)
		end
		
		--LOG("\nChoice = "..choice.."\n")
	end
	
	if text == "" then
		text = "This is a CEO mission closing message. It reflects on how well the mission just went. It has glowing praise, or possibly it's rather insulting of your skills."
	end
	
	return text
end

--return the bonus ID for the text (ex: Mission_KillAll_Success) and a flag for if it was a success or not
function Mission:GetBonusInfo(endstate)
	for i,obj in ipairs(self.BonusObjs) do
		local info = {}
        if obj == BONUS_KILL then
			info.text_id = "Mission_KillAll"
		elseif obj == BONUS_GRID then
			info.text_id = "Mission_GridHealth"
		elseif obj == BONUS_MECHS then
			info.text_id = "Mission_MechHealth"
		elseif obj == BONUS_BLOCK then
			info.text_id = "Mission_Block"
		elseif obj == BONUS_KILL_FIVE then
			info.text_id = "Mission_KillAll"
		end
		
		if obj ~= BONUS_ASSET then
		    
		    if endstate then
		        info.success = self:GetBonusStatus(obj, endstate) == OBJ_COMPLETE
				info.text_id = info.text_id..(info.success and "_Success" or "_Failure")
			else
				info.text_id = info.text_id.."_Briefing"		    	
			end
			
			return info
		end
	end
	
	return nil
end

function Mission:StartDeployment()

end

function Mission:BaseDeployment()
	self.PowerStart = Game:GetPower():GetValue()
	self:StartDeployment()
end

function Mission:GetMapTag()
	if type(self.MapTags) == "table" then 
		return random_element(self.MapTags) 
	end
	
	return self.MapTags
end

function Mission:GetStartingPawns()
	
	local spawnCount = self.SpawnStart
	
	if GetDifficulty() == DIFF_EASY and self.SpawnStart_Easy ~= -1 then
		spawnCount = self.SpawnStart_Easy
	end

	local mod = self.GlobalSpawnMod + self.SpawnStartMod
	local count = 0
    if type(spawnCount) == "table" then
		local sector = math.max(1,math.min(GetSector(),#spawnCount))
		count = spawnCount[sector]
	else
		count = spawnCount
	end
	
	local new_count = count + mod
			
	return math.max(0,new_count)
end

function Mission:ApplyEnvironmentEffect()
	return self.LiveEnvironment:ApplyEffect()
end

function Mission:Initialize()--Done before the mission even has a map, really not intended for much
	self:PrepBonus()
end

function Mission:RemoveBonus()
	if #self.BonusPool ~= 0 then
		local choice = random_removal(self.BonusObjs)
		
		if choice == BONUS_ASSET then self.AssetId = nil end
	end
end

function Mission:PrepBonus()
	self.BonusObjs = {}
    if #self.BonusPool ~= 0 and self.UseBonus then
        self.BonusObjs[1] = random_element(self.BonusPool)
	end
end

function Mission:BaseStart()
	self.VoiceEvents = {}
	
	if self.AssetId ~= "" then
		self.AssetLoc = Board:AddUniqueBuilding(_G[self.AssetId].Image)
	end
	
	self.LiveEnvironment = _G[self.Environment]:new()
	self.LiveEnvironment:Start()
	self:StartMission()
	
	self:SetupDiffMod()
	
	self:SpawnPawns(self:GetStartingPawns())
end

function Mission:CreateSpawner(data)

	local diff = GetDifficulty()
	local spawner = SectorSpawners[diff][GetSector()]

	self.Spawner = spawner:new(data)
end

function Mission:GetSpawner()
	if self.Spawner == nil then self:CreateSpawner() end
    return self.Spawner
end

function Mission:NextRobotName()
	return self:NextRobot(true)
end

function Mission:NextRobot(name_only)
	name_only = name_only or false
	return self:NextPawn( {"Snowtank", "Snowlaser", "Snowart" }, name_only )
end

function Mission:NextPawn(pawn_tables, name_only)
	local next_pawn = self:GetSpawner():NextPawn(pawn_tables)
	
	if not name_only then
		return PAWN_FACTORY:CreatePawn(next_pawn)
	end
	
	return next_pawn
end
			
function Mission:SpawnPawn(location)
	Board:SpawnPawn(self:NextPawn(),location)
end
			
function Mission:SpawnPawns(count)
	for i = 1, count do
		Board:SpawnPawn(self:NextPawn())
	end
end

function Mission:GetDiffMod()
	return self.DiffMod
end
	
function Mission:SetupDiffMod()
	if self.DiffMod == DIFF_MOD_EASY then
		
		--shield some buildings
		local buildings = extract_table(Board:GetBuildings())
		
		local shield = SpaceDamage(0)
		shield.iShield = 1
		for i = 1,3 do 
			if #buildings == 0 then return end
			shield.loc = random_removal(buildings)
			Board:DamageSpace(shield)
		end
		
	elseif self.DiffMod == DIFF_MOD_HARD then
		
		--force a purple unit onto the board now
		local choice = ""
		repeat choice = random_element(GAME:GetSpawnList()) until (self:GetSpawner().max_level[choice] ~= 1)
		self:GetSpawner():ModifyCount(choice,1)
		choice = choice.."2"
		Board:AddPawn(choice)
	
	end
end

function Mission:UpdateObjectives()

end

function Mission:BaseObjectives()
	self:UpdateObjectives()
	for index, obj in ipairs(self.BonusObjs) do
		local status = self:GetBonusStatus(obj, false)
		
		if obj == BONUS_KILL then
			Game:AddObjective("Kill all enemies before \nthey retreat", status)
		elseif obj == BONUS_GRID then
			Game:AddObjective("Less than 3 Grid Damage \n".."(Current Damage: "..self:GetDamage()..")", status)
		elseif obj == BONUS_MECHS then
			Game:AddObjective("End with less than 4 Mech Damage ".."(Current: "..Board:GetMechDamage()..")", status)
		elseif obj == BONUS_BLOCK then
			local base = "Block Vek Spawning 3 times\n"
			if IsLargeFont() then
				base = "Block Vek Spawning\n3 times "
			end
			Game:AddObjective(base.."(Current: "..self.BlockedSpawns..")",status)
		elseif obj == BONUS_KILL_FIVE then
			Game:AddObjective("Kill at least "..self:GetKillBonus().." Enemies \n".."(Current: "..self.KilledVek..")",status)
		elseif obj == BONUS_ASSET then
			local asset = _G[self.AssetId]
			Game:AddObjective("Protect the "..asset.Name, status, asset.Reward, 1)
		end
	end
end

function Mission:GetBonusCompleted()
	return self:GetBonusList(true)
end

function Mission:GetBonusList(endstate)
	local ret = {}
	endstate = endstate or false
	for index, obj in ipairs(self.BonusObjs) do
		ret[#ret+1] = self:GetBonusObjective(obj)
		if endstate and self:GetBonusStatus(obj, true) == OBJ_FAILED then
			ret[#ret] = ret[#ret]:Failed()
		end
	end
	
	return ret
end

function Mission:GetBonusObjective(objective)
	if objective == BONUS_KILL then
		return Objective("Kill all enemies before they retreat",1)
	elseif objective == BONUS_GRID then
		return Objective("Take less than 3 Grid Damage",1)
	elseif objective == BONUS_MECHS then
		return Objective("End battle with less than 4 Mech Damage",1)
	elseif objective == BONUS_BLOCK then
		return Objective("Block Vek Spawning 3 times",1)
	elseif objective == BONUS_KILL_FIVE then
		return Objective("Kill at least "..self:GetKillBonus().." Enemies", 1)
	elseif objective == BONUS_ASSET then
		local asset = _G[self.AssetId]
		local text = "Protect the "..asset.Name
		if self.AssetPassive ~= "" then
			return Objective(text,self.AssetPassive)
		else
			local ret = Objective(text,1,1)
			ret.category = asset.Reward
			return ret
		end
	end
end

--'endstate' means to judge the objective based on a completed mission, not mid-mission
function Mission:GetBonusStatus(objective, endstate)
	if objective == BONUS_KILL then
		local default = endstate and OBJ_FAILED or OBJ_STANDARD--if 'endstate' 
		return Board:GetEnemyCount() <= 0 and OBJ_COMPLETE or default
	elseif objective == BONUS_GRID then
		local default = endstate and OBJ_COMPLETE or OBJ_STANDARD
		return self:GetDamage() < 3 and default or OBJ_FAILED
	elseif objective == BONUS_MECHS then
	    local default = endstate and OBJ_COMPLETE or OBJ_STANDARD
		return Board:GetMechDamage() < 4 and default or OBJ_FAILED
	elseif objective == BONUS_BLOCK then
		local default = endstate and OBJ_FAILED or OBJ_STANDARD
		return self.BlockedSpawns >= 3 and OBJ_COMPLETE or default
	elseif objective == BONUS_KILL_FIVE then
		local default = endstate and OBJ_FAILED or OBJ_STANDARD
		return self.KilledVek >= self:GetKillBonus() and OBJ_COMPLETE or default
	elseif objective == BONUS_ASSET then
	    local default = endstate and OBJ_COMPLETE or OBJ_STANDARD
		return Board:IsDamaged(self.AssetLoc) and OBJ_FAILED or default
	end
end

function Mission:StartMission()
	
end

function Mission:BaseNextTurn()
	if Game:GetTeamTurn() == TEAM_PLAYER and Game:GetTurnCount() == 2 then
		for index,obj in ipairs(self.BonusObjs) do
			if obj == BONUS_BLOCK and self.BlockedSpawns == 0 then
				PrepareVoiceEvent("Mission_Block_Reminder")
			end
		end
	end
	
	self:NextTurn()
end

function Mission:BaseUpdate()
    if self.LiveEnvironment == nil then
        self.LiveEnvironment = Env_Null:new()
    end
	
	self.LiveEnvironment:MarkBoard()
	
	for index, obj in ipairs(self.BonusObjs) do
		if obj == BONUS_ASSET then
			local status = self:GetBonusStatus(obj, false)
			local tense = status == OBJ_STANDARD and "is" or "was"
			local name = _G[self.AssetId].Name--status == OBJ_STANDARD and _G[self.AssetId].Name or "Destroyed ".._G[self.AssetId].Name
			TILE_TOOLTIPS[name] = {name,"Your bonus objective "..tense.." to defend this structure."}
			Board:MarkSpaceDesc(self.AssetLoc,name)
		elseif obj == BONUS_BLOCK then
			self.BlockedSpawns = self.BlockedSpawns + Game:GetEventCount(EVENT_SPAWNBLOCKED)
		elseif obj == BONUS_KILL_FIVE then
			self.KilledVek = self.KilledVek + Game:GetEventCount(EVENT_ENEMY_KILLED)
		end
	end
	
	self:UpdateMission()
end

function Mission:UpdateMission() end
function Mission:NextTurn() end
function Mission:Render() end
function Mission:GetChoiceEvent() end

function Mission:GetMap()
	return self.MapList[random_int(#self.MapList)+1]
end

CreateClass(Mission)

function Mission:GetRetreatEvent()
	return CreateChoiceEvent(
		{ 
			Text = "You withdrew from the battlefield, leaving supplies and civilians behind.",
			structure = "destroy"
		}
	)
end

function Mission:GetDeadEvent()
	return CreateChoiceEvent(
		{ 
			Text = "All of your mechs have been disabled. An evacuation team will arrive shortly to recover your pilots and their wreckage.",
			structure = "destroy"
		}
	)
end

function Mission:GetSpawnsPerTurn()
	local spawnCount = copy_table(self.SpawnsPerTurn)
	
	if GetDifficulty() == DIFF_EASY and self.SpawnsPerTurn_Easy ~= -1 then
        spawnCount = copy_table(self.SpawnsPerTurn_Easy)
    end
	
	if type(spawnCount) ~= "table" then
		spawnCount = {spawnCount, spawnCount}
	end
	
	local mod = self.GlobalSpawnMod + self.SpawnMod
	
	while mod ~= 0 do
		local curr = getMinIndex(spawnCount)
		if subsign(mod) < 0 then
			curr = getMaxIndex(spawnCount)
		end
		
		spawnCount[curr] = math.max(1,spawnCount[curr] + subsign(mod))
		
		mod = mod - subsign(mod)
	end
	
	local spawns = " {"
	for i = 1, #spawnCount do
		spawns = spawns..spawnCount[i]..","
	end
	spawns = spawns.."}"
	--LOG("Modified spawns per turn: "..spawns)
	
	return spawnCount
end

function Mission:GetMaxEnemy()
	if GetDifficulty() == DIFF_EASY and self.MaxEnemy_Easy ~= -1 then
        return self.MaxEnemy_Easy
    else
		return self.MaxEnemy
	end
end

function Mission:GetSpawnCount()
	if not self.InfiniteSpawn then return 0 end
	
	if self:IsFinalTurn() then return 0 end
	
	--LOG("Turn counter: "..Game:GetTurnCount())
	
	local spawnCount = self:GetSpawnsPerTurn()

--	LOG("Current index: "..(Game:GetTurnCount() % #spawnCount) + 1)
	spawnCount = spawnCount[(Game:GetTurnCount() % #spawnCount) + 1]
	
	local enemies = Board:GetPawnCount(TEAM_ENEMY_MAJOR)
	local all_enemies = Board:GetPawnCount(TEAM_ENEMY)
	
--	LOG("All enemy count = "..all_enemies)
--	LOG("Enemy count = "..enemies)
	--LOG("Enemy max = "..self:GetMaxEnemy())
	--LOG("Spawn goal = "..spawnCount)
	
	if enemies <= 2 and all_enemies <= 3 and spawnCount < 3 and GetDifficulty() ~= DIFF_EASY then
		LOG("2 or less enemies present. Increasing spawn count")
		spawnCount = spawnCount + 1
	end
	
	spawnCount = math.min(math.max(0,self:GetMaxEnemy() - enemies), spawnCount)
	LOG("Final spawn = "..spawnCount)
	
	return spawnCount
end

function Mission:IsFinalTurn()
	return Game:GetTurnCount() == self.TurnLimit - 1
end

function Mission:UpdateSpawning()
	self:SpawnPawns(self:GetSpawnCount())
end

function Mission:IsEnvironmentEffect()
	return self.LiveEnvironment:IsEffect()
end

function Mission:PlanEnvironment()
	if Game:GetTurnCount() == self.TurnLimit then
		return false--don't plan the environment if the mission is over
	end
	
	if self.LiveEnvironment == nil then
	    return false--hack to make editor work
	end
	
	return self.LiveEnvironment:Plan()
end



-----------------------------------------------------
----------------------------------------------------- --JUSTIN--


Mission_Infinite = Mission:new{
	InfiniteSpawn = true,
	SpawnsPerTurn = {2,3},  -- WAS 2 only
	SpawnsPerTurn_Easy = {2,1},
	SpawnStart = {3,3,4,4},   -- WAS 3333
	SpawnStart_Easy = {2,2,3,3},
	BonusPool = {BONUS_GRID, BONUS_MECHS, BONUS_BLOCK, BONUS_KILL_FIVE}
}

-------------------------------------------------------
-------------------------------------------------------

--Mission type that randomizes a little more -- used for 
--generic missions like "Air Support" where it could work 
--for infinite spawning or pre-set spawning or something inbetween

Mission_Battle = Mission:new{ }
Mission_Survive = Mission_Infinite:new{ }
Mission_Auto = Mission:new{ }

function Mission_Auto:Initialize()
	--50% of time, essentially turn this into Mission_Infinite
	--now turn it into infinite every time
	--if random_bool(2) then
		self.InfiniteSpawn = true
		self.SpawnsPerTurn = Mission_Infinite.SpawnsPerTurn
		self.SpawnsPerTurn_Easy = Mission_Infinite.SpawnsPerTurn_Easy
		self.SpawnStart = Mission_Infinite.SpawnStart
		self.SpawnStart_Easy = Mission_Infinite.SpawnStart_Easy
		self.BonusPool = Mission_Infinite.BonusPool
	--end
	
	self:PrepBonus()
end

----------------------------------------------------
----------------------------------------------------

function Mission:MissionEnd()
	local ret = SkillEffect()
	local enemy_count = Board:GetEnemyCount()
	
	if enemy_count == 0 then
		ret:AddVoice("MissionEnd_Dead", -1)
	elseif self.RetreatEndingMessage then
		ret:AddVoice("MissionEnd_Retreat", -1)
	end
	
	if self:GetDamage() == 0 then
		ret:AddScript("Board:StartPopEvent(\"Closing_Perfect\")")
	elseif self:GetDamage() > 4 then
		ret:AddScript("Board:StartPopEvent(\"Closing_Bad\")")
	elseif enemy_count > 0 then
		ret:AddScript("Board:StartPopEvent(\"Closing\")")
	else
		ret:AddScript("Board:StartPopEvent(\"Closing_Dead\")")
	end
	
	local effect = SpaceDamage()
	effect.bEvacuate = true
	effect.fDelay = 0.5
	
	local retreated = 0
	local board_size = Board:GetSize()
	for i = 0, board_size.x - 1 do
		for j = 0, board_size.y - 1  do
			if Board:IsPawnTeam(Point(i,j),TEAM_ENEMY)  then
				effect.loc = Point(i,j)
				ret:AddDamage(effect)
				retreated = retreated + 1
			end
		end
	end
	
	ret:AddDelay(math.max(0,4-retreated*0.5))
		
	Board:AddEffect(ret)
end

function Mission:GetTerrainList(terrain)
	local func = function(point) return Board:IsTerrain(point,terrain) end
	return self:GetBoardList(func)
end

function Mission:GetBoardList(func)
	local ret = {}
	for i = 0, 7 do
		for j = 0, 7 do
			if func(Point(i,j)) then
				ret[#ret+1] = Point(i,j)
			end
		end
	end
	
	return ret
end

Mission_Test = Mission:new{ }