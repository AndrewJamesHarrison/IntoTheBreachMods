
--- Misc Info ----



--artillery info
Values["gravity"] = 3
Values["x_velocity"] = 0.7
Values["y_velocity"] = 18

Values["laser_length"] = 0.5

---pod info
Values["pod_x"] = -7
Values["pod_y"] = 11
Values["pod_z"] = 300
Values["pod_velocity"] = 0.7
Values["pod_smoke"] = 0.9

------- EXPERIENCE INFO
Values["xp_level_1"] = 25 -- amount of XP required to level
Values["xp_level_2"] = 50 -- amount of XP required to level


-----------------------
--				OLD:  8 to 11 cards drawn - 17 cards in the deck
--Now 10 total cards!
local PodCards = {
	{ cores = 1 }, 3,   
	--{ cores = 2 }, 1,   
	{ weapon = "random", cores = 1 }, 4,  -- justin
	{ pilot = "random", cores = 1 }, 3,   -- justin       
} 

local GameObject = {
	PodDeck = {}, --populated below
	PilotDeck = {}, --populated automatically
	WeaponDeck = {}, --populated automatically
	SeenPilots = {},
	RepairKits =  random_int(3) + 2,
	Missions = {},--populated in createIncidents()
	Enemies = {}, --populated in startNewGame()
	Island = nil,
}

CreateClass(GameObject)

function GameObject:GetMissionId(mission)
	local stripmission = string.gsub(mission,"Mission","")
	local id = tonumber(stripmission)
	return id
end

function GameObject:GetMission(mission)
	return self.Missions[self:GetMissionId(mission)]
end

function GameObject:CreateNextPhase(mission)
	local id = self:GetMissionId(mission)
	local next_phase = self:GetMission(mission).NextPhase
	if next_phase == "" then 
		return
	end
	
	self.Missions[id] = CreateMission(next_phase)
end


function GameObject:GetBoss(island)	
	if island == 5 then
		return ""
	end
	
	if self.Bosses == nil or #self.Bosses == 0 then
		self.Bosses = generateBossList()
	end
	
	return self.Bosses[island or self.Island or 1]
end

function GameObject:GetIslandList(island)
	local ret = self:GetEnemies(island)
	ret[#ret+1] = _G[self:GetBoss(island)].BossPawn
	return ret
end

function GameObject:GetSpawnList(island)
	if island == 5 then -- final island!
		return { "Firefly", "Hornet", "Scarab", "Scorpion", 
				"Crab", "Beetle", "Digger", "Blobber",
				"Jelly_Lava", "Jelly_Lava", "Jelly_Lava",}--make it more likely
	end
	
	return self:GetEnemies(island or self.Island or 1, GetSector())
end

function GameObject:GetEnemies(island, sector)
    island = island or 1
	sector = sector or GetSector()
	local ret = {}
	local count = 3 + sector
	--if GetDifficulty() == DIFF_EASY then
	--	count = count - 1
	--end
	
	for i,v in ipairs(self.Enemies[island]) do
		if i <= count then
			ret[#ret+1] = v
		end
	end
	
	return ret
end

--for debugging only
function addCustomMission(mission)
	GAME.Missions[0] = CreateMission(mission)
end

function isExclusive(list,element)
	for i,v in ipairs(list) do
		if ExclusiveElements[v] == element or ExclusiveElements[element] == v then 
			return true 
		end --make sure nothing matches from the 'similar' lists
		
		if v == element then return true end--exact match is obviously 'similar'
	end
	
	return false
end

local function isUnlocked(island, unit)
	local lock = IslandLocks[unit] or 4
	return lock == nil or island >= lock or Game:IsIslandUnlocked(lock-1)
end
   
local function addEnemies(curr, lists, category)
 
	local counts = { Core = 3, Leaders = 1, Unique = 2}
	local desired = #curr + counts[category]
	local list = lists[category]
 
    while #curr < desired do	
		local choices = {}
		for i,v in ipairs(list) do
			if not isExclusive(curr,v) and isUnlocked(curr.island,v) then
				choices[#choices+1] = v
			end
		end
		
		if #choices > 0 then
			local choice = random_element(choices)
			curr[#curr+1] = choice
			remove_element(choice,list)
		else
			for i,v in ipairs(EnemyLists[category]) do list[i] = v end
		end	
    end	
end

local function createPodDeck()
    	---fill in the pod deck
    GAME.PodDeck = {}
	for i = 1, #PodCards, 2 do
		for count = 1, PodCards[i+1] do
			GAME.PodDeck[#GAME.PodDeck+1] = PodCards[i]
		end		
	end
end

function generateBossList()
	local ret = {}
	local seen_bosses = {}
	local corps = {"Corp_Grass", "Corp_Desert", "Corp_Snow", "Corp_Factory"}
	
	for i = 1, 4 do
		local corp = _G[corps[i]]
		local bosses = add_tables(corp.Bosses,corp.UniqueBosses)
		
		local boss = ""
		repeat 
			boss = random_removal(bosses)
		until (isUnlocked(i,boss) and not seen_bosses[boss]) or #bosses == 0
		
		if boss == "" or seen_bosses[boss] then
			boss = "Mission_SpiderBoss"
			LOG("Failed to find unique boss for the corporation\n")
		end
		
		seen_bosses[boss] = true
		
		ret[i] = boss
	end
	
	return ret
end

function startNewGame()

	GAME = GameObject:new{}
	
	initializeDecks()
    
	GAME.SeenPilots = {}
	--create enemy lists for 4 sectors
	
	GAME.Bosses = {}
	GAME.Enemies = {}
	local lists = copy_table(EnemyLists)
	for i = 1, 4 do
		local curr = {}
		curr.island = i
		
		addEnemies(curr, lists, "Core")
		addEnemies(curr, lists, "Leaders")
		addEnemies(curr, lists, "Unique")

		GAME.Enemies[i] = curr
	end
	
	GAME.Bosses = generateBossList()
end

function LoadGame()
	GAME = GameObject:new(GAME)
	ReloadMissions(GAME.Missions)
end

function SaveGame()
	ret = " \n\nGAME = "..save_table(GAME).."\n\n"
	return ret
end


function getCityPower(sector)
	return 7
end

function getPodList(sector)
	
	local podCount = 1
	if sector == 1 then podCount = 1 end 
	if sector == 2 then podCount = 2 end
	if sector == 3 then podCount = 2 end
	
	pods = {}
	
	GAME.PodDeck = GAME.PodDeck or {}
	
	if #GAME.PodDeck == 0 then
	    createPodDeck()
	end
	
	for i = 1, podCount do
		pods[#pods+1] = CreateEffect(random_removal(GAME.PodDeck))
	end
	
	return pods
end

function testRepair(chance)
	chance = chance or 50
	local found = 0
	local stats = {0,0,0,0}
	for i = 1,10000 do
		local count = testGetRepair(chance)
		stats[count] = stats[count] + 1
		found = found + count
	end
	LOG("AVERAGE PER GAME: "..found/10000)
	LOG(unpack(stats))
end

local function testGetRepair(reward_chance)
	GAME.RepairKits = random_int(3) + 2
	reward_chance = reward_chance or 50
	local total = 0
	local possible = GAME.RepairKits
	for sector = 1, 3 do
		local repair = -1
		if random_int(100) < reward_chance then
			repair = getRepairKit(sector,false)
			total = total+repair		
		end
		
		repair = getRepairKit(sector,true)
		total = total+repair
	end
	return total
end

function getRepairKit(sector, store)
	if sector == 0 or GAME.RepairKits == 0 then
		return 0
	end
	
	local opportunities = (4 - sector)*2 - bool_int(store)
	
	local dropped = 0
	if random_int(opportunities) < GAME.RepairKits then
		dropped = 1
	end
	
	GAME.RepairKits = GAME.RepairKits - dropped
	
	return dropped
end

function getRainChance(sectorType)
	local data = { grass = 20, snow = 20, sand = 0, acid = 20, lava = 0, volcano = 0, }
	return data[sectorType]
end

function getEnvironmentChance(sectorType, tileType)
	--numbers are just a raw percentage chance
	--example: TERRAIN_FOREST = 10 means 10% chance any plain tile will become Forest
	if sectorType == "lava" or sectorType == "volcano" then
		return 0
	end
	
	if tileType == TERRAIN_ACID then
		if sectorType == "acid" then
			return random_element({0,0,10,20})
		else
			return 0
		end
	end
	
	-- "normal" mode uses the same numbers as "hard"
	
	local data = { 	
		grass = { 
			--easy 
			{[TERRAIN_FOREST] = 10, [TERRAIN_SAND] = 0, [TERRAIN_ICE] = 0, },
			--hard
			{[TERRAIN_FOREST] = 16, [TERRAIN_SAND] = 0, [TERRAIN_ICE] = 0, },
		},
		sand = {
			--easy
			{ [TERRAIN_FOREST] = 0, [TERRAIN_SAND] = 10, [TERRAIN_ICE] = 0, },
			--hard
			{ [TERRAIN_FOREST] = 0, [TERRAIN_SAND] = 16, [TERRAIN_ICE] = 0, },
		},
		snow = {
			--easy
			{ [TERRAIN_FOREST] = 10, [TERRAIN_SAND] = 0, [TERRAIN_ICE] = 75,  },
			--hard
			{ [TERRAIN_FOREST] = 10, [TERRAIN_SAND] = 0, [TERRAIN_ICE] = 75,  },
		},
		acid = {
		--easy
			{ [TERRAIN_FOREST] = 0, [TERRAIN_SAND] = 0, [TERRAIN_ICE] = 0,},
			--hard
			{ [TERRAIN_FOREST] = 0, [TERRAIN_SAND] = 0, [TERRAIN_ICE] = 0,   },
		}
	}
		
	--translate easy => 1, normal or hard => 2
	local difficulty = (GetDifficulty() == DIFF_EASY) and 1 or 2
	
	--haha this is ugly
	if data[sectorType] ~= nil and data[sectorType][difficulty] ~= nil and data[sectorType][difficulty][tileType] ~= nil then
		return data[sectorType][difficulty][tileType]
	else
		LOG("Failed environment chance: terrain = "..sectorType..", tile = "..tileType)
		return 0
	end
end

function getBuildingHealth(sector)
	if sector == 0 then return {50,50,0,0} end
	if sector == 1 then return {50,50,0,0} end
	if sector == 2 then return {50,40,10,0} end
	return {50,40,10,0}
end

function getBonusMoney()
	local power = Game:GetPower()
	return math.ceil(power:GetValue())  -- was GetValue()/4
end