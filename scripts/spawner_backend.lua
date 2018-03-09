
EnemyLists = {
	
	Leaders = { "Jelly_Health", "Jelly_Regen", "Jelly_Armor", "Jelly_Explode" }, -- Leaders
	Core = { "Firefly", "Hornet", "Scarab", "Scorpion", "Leaper"},
	Unique = { "Crab", "Beetle", "Digger", "Spider", "Blobber", "Burrower", "Centipede" }
}

IslandLocks = {
	Firefly = 1, Hornet = 1, Scorpion = 1, Leaper = 3, Scarab = 2, 
	Jelly_Health = 1, Jelly_Explode = 2, Jelly_Regen = 4, Jelly_Armor = 3, Jelly_Lava = 1,
	Crab = 1, Beetle = 2, Digger = 3, Blobber = 1, Spider = 4, Burrower = 4, Centipede = 3,
	
	Mission_FireflyBoss = 1, Mission_ScorpionBoss = 2, Mission_BeetleBoss = 2, Mission_BlobBoss = 2, Mission_SpiderBoss = 4, Mission_BotBoss = 3, Mission_HornetBoss = 1, Mission_JellyBoss = 3,
}
--do the nature of island unlocks, putting Beetle in #2 will make it the first choice for Island 2, which will make it the first "Unique" enemy a new player sees. So just leave that alone. And ignore the fact that Blobber is 1, because you never see the "Unique" enemies on the very first island you play.

ExclusiveElements = { 
	--Mutually exclusive units -- You can only have one or the other on an island
	Scorpion = "Leaper", Blobber = "Spider", Scarab = "Crab", Burrower = "Jelly_Explode", Burrower = "Mission_Acid"
}

local WeakPawns = { 
	Jelly_Health = true, Jelly_Regen = true, Jelly_Armor = true, Jelly_Explode = true, 
    Jelly_Lava = true, Scorpion = true, Firefly = true, Hornet = true, Leaper = true, Scarab = true,
    Snowmine = true, Snowlaser = true, Snowtank = true
}

Spawner = {
	max_pawns = { 
		Scorpion = 3, Firefly = 3, Hornet = 3, Beetle = 2, Scarab = 2, Digger = 1, Blobber = 1, Spider = 1, Leaper = 2, Crab = 2, Centipede = 2, Burrower = 2,
		Snowmine = 1, Snowlaser = 3, Snowtank = 3, Snowart = 2, 
		Jelly_Health = 1, Jelly_Regen = 1, Jelly_Armor = 1, Jelly_Explode = 1, Jelly_Lava = 1,
	},
	max_level = { Jelly_Health = 1, Jelly_Regen = 1, Jelly_Armor = 1, Jelly_Explode = 1, Jelly_Lava = 1},  
	num_weak = 3, -- weak units / total units
	num_upgrades = 1, -- T2 units / total units
	pawn_counts = nil,
	num_spawns = 0,
	curr_weakRatio = nil,
	curr_upgradeRatio = nil,
	upgrade_streak = 0,
	upgrade_max = 1,
	spawn_island = nil,
}
			
CreateClass(Spawner)

function Spawner:BlockPawns(pawns)
	self.pawn_counts = self.pawn_counts or {}
	
	if type(pawns) ~= "table" then
		pawns = {pawns}
	end
	
	for i,v in ipairs(pawns) do
		self.pawn_counts[v] = 5
	end
end
				 
function Spawner:SelectPawn(choices, weak)
    local available = {}
	local backup = {}
	local super_backup = {}
	for i,v in pairs(choices) do
		local max_count = self.max_pawns[v] or 3
		
		if self.num_spawns < 4 and v == "Jelly_Lava" then
			max_count = 0--never spawn Jelly_Lava in the start
		end
		
		local current_count = self.pawn_counts[v] or 0
		local under_max = current_count < max_count
		local is_match = weak == (WeakPawns[v] == true)
		--if it's a match and under the max then add it to the list
		if is_match and under_max then
			available[#available+1] = v
		--backup anything that's weak and not limited to 1 as a replacement backup
		elseif WeakPawns[v] and max_count ~= 1 then
			backup[#backup+1] = v 
		end
	end
	
	---every pawn is already maxed out. so ignore the maxes.
	if #available == 0 then
		--try backup list first
		if #backup ~= 0 then
			available = backup
		else --then just give up
		    LOG("Spawner GAVE UP and gave a COMPLETELY RANDOM pawn. This SHOULD NOT HAPPEN. Please tell Matthew")
			available = choices
		end
	end
	
	return random_element(available)
end

function Spawner:CountLivingUpgrades()
	if Board == NULL then
		return 0
	end
	
	local upgrades = {}
	local pawns = extract_table(Board:GetPawns(TEAM_ENEMY))
	local count = 0
	for i, v in ipairs(pawns) do
		if string.find(Board:GetPawn(v):GetType(), "2") ~= nil then
			count = count + 1
		end
	end
	
	return count
end

function Spawner:ModifyCount(pawn, val)
    self.pawn_counts = self.pawn_counts or {}
	self.pawn_counts[pawn] = self.pawn_counts[pawn] or 0
	self.pawn_counts[pawn] = self.pawn_counts[pawn] + val
	
	self.pawn_counts[pawn] = math.max(0,self.pawn_counts[pawn])
end

function Spawner:SetSpawnIsland(island)
	self.spawn_island = island
end

function Spawner:NextPawn(pawn_tables)

	pawn_tables = pawn_tables or GAME:GetSpawnList(self.spawn_island)
		
	self.pawn_counts = self.pawn_counts or {}
	
	local counts = ""
    for i,v in pairs(self.pawn_counts) do
        counts = counts..i.." = "..v.." "
    end
  --  LOG("Current pawn counts = "..counts)
	
	
	---initialize values
	if self.curr_weakRatio == nil then
		self.curr_weakRatio = {0,0}
		self.curr_upgradeRatio = {0,0}
		self.upgrade_streak = 0
	end
	
	if self.curr_weakRatio[2] == 0 then 
		self.curr_weakRatio[1] = self.num_weak
		self.curr_weakRatio[2] = 5		
	end
	
	if self.curr_upgradeRatio[2] == 0 then 
		self.curr_upgradeRatio[1] = self.num_upgrades
		self.curr_upgradeRatio[2] = 5		
	end
			
	local newPawn = ""
	local level = 1
	local upgrade = 0
	
	if random_int(self.curr_weakRatio[2]) < self.curr_weakRatio[1] then
		newPawn = self:SelectPawn(pawn_tables, true)
		self.curr_weakRatio[1] = self.curr_weakRatio[1] - 1	
	else
		newPawn = self:SelectPawn(pawn_tables,false)
	end
		
	local maxLvl = self.max_level[newPawn] or 2
	
	--this is an attempt to normalize 'streaks' to make sure it's a more consistent distribution of upgraded enemies
	--if non-upgraded choices are available, and you've had a streak of "num_upgrades-1" then break it up.
	local break_streak = self.curr_upgradeRatio[1] ~= self.curr_upgradeRatio[2] and self.upgrade_streak >= math.max(1,(self.num_upgrades - 1))
	
	if random_int(self.curr_upgradeRatio[2]) < self.curr_upgradeRatio[1] and maxLvl ~= 1 and not break_streak then
		level = 2
		self.curr_upgradeRatio[1] = self.curr_upgradeRatio[1] - 1
		self.upgrade_streak = self.upgrade_streak + 1
	else
		self.upgrade_streak = 0
	end
	
	self.curr_upgradeRatio[2] = self.curr_upgradeRatio[2] - 1
	self.curr_weakRatio[2] = self.curr_weakRatio[2] - 1
	
	self:ModifyCount(newPawn,1)
	
	--force downgrade if the tier 2 units are getting out of hand
	if self:CountLivingUpgrades() >= self.upgrade_max then
		level = 1
	end
	
	--LOG("Selected pawn = "..newPawn..level)
	self.num_spawns = self.num_spawns + 1
	
	return newPawn..level
end

function testSpawner(count,sector)

	local max_burrower = 0
	
	--for j = 1, 100 do
		--local curr_burrower = 0 
		local tester = SectorSpawners[DIFF_NORMAL][sector]:new()
		count = count or 6

		LOG(unpack(GAME:GetSpawnList()))
		
		local ret = {}
		for i = 1, count do
			ret[i] = tester:NextPawn(nil,true)
			
			--if ret[i] == "Burrower1" or ret[i] == "Burrower2" then
			--	curr_burrower = curr_burrower + 1
			--end
		end
		
		--if curr_burrower > max_burrower then
		--	max_burrower = curr_burrower
		--end
--	end
	--LOG(max_burrower)
	LOG(unpack(ret))
end