
Island_Locations = {
	Point(14,0),
	Point(100,150),
	Point(250,88),
	Point(395,189),
	Point(180,0)
}

Island_Magic = {
	Point(146, 131),
	Point(115, 104),
	Point(149, 86),
	Point(135,76),
	Point(0,0),
}

--[[Island_Centers = {
	Point(80,65),
	Point(148,197), 
	Point(318,144), 
	Point(484,237)
}--]]

--this is bullshit to translate between high res zoomed in images and low res zoomed out
local Island_Shifts = {
	Point(14,5),
	Point(16,15),
	Point(17,12),
	Point(18,15),
	Point(0,0)
}

for i = 0,4 do
	Location["strategy/island"..i..".png"] = Island_Locations[i+1] 
	Location["strategy/island1x_"..i..".png"] = Island_Locations[i+1] - Island_Shifts[i+1]
	Location["strategy/island1x_"..i.."_out.png"] = Island_Locations[i+1] - Island_Shifts[i+1]
end

Region_Data = {}
Region_Data["island_0_0"] = RegionInfo(Point(21,120), Point(0,-38), 100)
Region_Data["island_0_1"] = RegionInfo(Point(127,40), Point(0,0), 300)
Region_Data["island_0_2"] = RegionInfo(Point(98,139), Point(35,-15), 100)
Region_Data["island_0_3"] = RegionInfo(Point(200,99), Point(0,0), 100)
Region_Data["island_0_4"] = RegionInfo(Point(259,118), Point(-4,0), 100)
Region_Data["island_0_5"] = RegionInfo(Point(308,131), Point(-18,0), 100)
Region_Data["island_0_6"] = RegionInfo(Point(102,220), Point(0,-25), 300)
Region_Data["island_0_7"] = RegionInfo(Point(296,249), Point(4,-32), 300)

Network_Island_0 = {}
Network_Island_0["0"] = {2,6}
Network_Island_0["1"] = {2,3}
Network_Island_0["2"] = {1,3,6,0}
Network_Island_0["3"] = {1,2,4,6}
Network_Island_0["4"] = {3,6,5,7}
Network_Island_0["5"] = {4,7}
Network_Island_0["6"] = {0,2,3,4}
Network_Island_0["7"] = {4,5}

Region_Data["island_1_0"] = RegionInfo(Point(14,114), Point(-8, -32),100)
Region_Data["island_1_1"] = RegionInfo(Point(33,23), Point(15,-10),300)
Region_Data["island_1_2"] = RegionInfo(Point(162,19), Point(-30, -35), 300)
Region_Data["island_1_3"] = RegionInfo(Point(162,70), Point(0, -30),100)
Region_Data["island_1_4"] = RegionInfo(Point(253,96), Point(0, -35),100)
Region_Data["island_1_5"] = RegionInfo(Point(154,145), Point(20,-25),100)
Region_Data["island_1_6"] = RegionInfo(Point(42,199), Point(0,-25),300)
Region_Data["island_1_7"] = RegionInfo(Point(171,202), Point(-5,-15),300)

Network_Island_1 = {}
Network_Island_1["0"] = {6,1}
Network_Island_1["1"] = {0,2,3}
Network_Island_1["2"] = {1,3,4}
Network_Island_1["3"] = {1,2,4,5}
Network_Island_1["4"] = {2,3,5,7}
Network_Island_1["5"] = {3,4,7,6}
Network_Island_1["6"] = {0,5,7}
Network_Island_1["7"] = {6,5,4}

Region_Data["island_2_0"] = RegionInfo(Point(75,138), Point(0, -15),300)
Region_Data["island_2_1"] = RegionInfo(Point(9,14), Point(-17, -47),100)
Region_Data["island_2_2"] = RegionInfo(Point(43,84), Point(4, -40),100)
Region_Data["island_2_3"] = RegionInfo(Point(143,53), Point(-8, -40),100)
Region_Data["island_2_4"] = RegionInfo(Point(212,13), Point(-15, -18),100)
Region_Data["island_2_5"] = RegionInfo(Point(212,92), Point(15, -40),100)
Region_Data["island_2_6"] = RegionInfo(Point(287,30), Point(0, -45),100)
Region_Data["island_2_7"] = RegionInfo(Point(341,76), Point(0, -25),100)

Network_Island_2 = {}
Network_Island_2["0"] = {2,3}
Network_Island_2["1"] = {2}
Network_Island_2["2"] = {1,3,0}
Network_Island_2["3"] = {2,0,4,5}
Network_Island_2["4"] = {3,5,6}
Network_Island_2["5"] = {3,4,6}
Network_Island_2["6"] = {4,5,7}
Network_Island_2["7"] = {6}

Region_Data["island_3_0"] = RegionInfo(Point(9,13), Point(10, -30),100)
Region_Data["island_3_1"] = RegionInfo(Point(77,11), Point(0, -30),300)
Region_Data["island_3_2"] = RegionInfo(Point(175,24), Point(0, -30),300)
Region_Data["island_3_3"] = RegionInfo(Point(250,75), Point(0, -32),100)
Region_Data["island_3_4"] = RegionInfo(Point(77,88), Point(0, -45),100)
Region_Data["island_3_5"] = RegionInfo(Point(155,100), Point(0, -43),300)
Region_Data["island_3_6"] = RegionInfo(Point(250,136), Point(-10, -15),100)
Region_Data["island_3_7"] = RegionInfo(Point(317,144), Point(16, -25),100)

Network_Island_3 = {}
Network_Island_3["0"] = {1,4}
Network_Island_3["1"] = {0,4,5,2}
Network_Island_3["2"] = {1,5,3}
Network_Island_3["3"] = {2,5,6,7}
Network_Island_3["4"] = {0,1,5}
Network_Island_3["5"] = {4,1,2,3,6}
Network_Island_3["6"] = {5,3,7}
Network_Island_3["7"] = {3,6}


Colors["region_dark"] = GL_Color(55,55,51)
Colors["region_dark_OL"] = GL_Color(100,100,98)
Colors["region_dark_cb"] = GL_Color(55,55,51)
Colors["region_dark_OL_cb"] = GL_Color(100,100,98)

Colors["region_lost"] = GL_Color(75,80,125)
Colors["region_lost_OL"] = GL_Color(101,92,163)
Colors["region_lost_cb"] = GL_Color(45, 45, 88)--different
Colors["region_lost_OL_cb"] = GL_Color(64, 56, 121)--different

Colors["region_light"] = GL_Color(100,100,98)--unused
Colors["region_light_OL"] = GL_Color(164,164,138)--unused

Colors["region_green"] = GL_Color(70,92,61)
Colors["region_green_OL"] = GL_Color(83,117,69)
Colors["region_green_highlight"] = GL_Color(86,157,59)
Colors["region_green_cb"] = GL_Color(70,92,61)
Colors["region_green_OL_cb"] = GL_Color(83,117,69)
Colors["region_green_highlight_cb"] = GL_Color(86,157,59)

Colors["region_yellow"] = GL_Color(170,145,23)--unused
Colors["region_yellow_OL"] = GL_Color(224,195,0)--unused
Colors["region_yellow_highlight"] = GL_Color(244,195,0)--unused

Colors["region_red"] = GL_Color(149,69,69)
Colors["region_red_OL"] = GL_Color(223,79,76)
Colors["region_red_highlight"] = GL_Color(255,79,76)
Colors["region_red_cb"] = GL_Color(88, 165, 179)
Colors["region_red_OL_cb"] = GL_Color(102, 237, 252)
Colors["region_red_highlight_cb"] = GL_Color(102, 237, 252)

local function popSimpleMission(list)
	local least = 100
	local options = {}
	for i,m in ipairs(list) do
		local count = m:GetRewardCount()
		local asset = m.AssetId ~= ""
		if not asset then
            if count < least then
                least = count
                options = { m }
            elseif count == least then
                options[#options+1] = m
            end
        end
	end
	
	if #options == 0 then
	    return nil
	end

	return random_removal(options)
end

function createFinalMission()
	GAME.Missions = {}
	GAME.Missions[0] = CreateMission("Mission_Final")
end

function createIncidents(corporation, island)
	
	local corp = _G[corporation]
	GAME.Missions = {}
	GAME.Island = island + 1
	
	local enemies = GAME:GetSpawnList()
	local boss = GAME:GetBoss()
	
	--grab all of our missions / assets / etc. we have for constructing the island
	--make sure they don't conflict with enemy lists
	local low_value = {}
	local high_value = {}
	
	for i, v in pairs(corp.Missions_Low) do
		if not isExclusive(enemies,v) then
			low_value[#low_value+1] = v
		end
	end
	
	for i, v in pairs(corp.Missions_High) do
		if not isExclusive(enemies,v) then
			high_value[#high_value+1] = v
		end
	end
	
	-----------------------------
	
	local incidents = {}
	
	--2 to 3 "high value" missions, capped by the number of actual available missions
	local numHigh = math.min(#high_value,2 + random_int(2)) -- 0 or 1
	
	for i = 1, numHigh do
		incidents[#incidents+1] = random_removal(high_value)
	end
	
	for i = 1, (7-numHigh) do
		local mission = ""
		if #low_value == 0 then
			mission = "Mission_Survive" --random_bool(2) and "Mission_Battle" or 
		else
			mission = random_removal(low_value)
		end
		incidents[#incidents+1] = mission
	end
			
	--- randomize the mission order
	incidents = randomize(incidents)
	
	--Create the actual missions
	for index, inc in ipairs(incidents) do
		incidents[index] = CreateMission(inc)
	end
	
	--make sure each category has sufficient rewards
	--these are *suggestions* to guide the system, not hard set requirements. most islands will not end up with all of them.
	local expected = { [REWARD_REP] = 10, [REWARD_POWER] = 8, [REWARD_TECH] = 1 }
	
	if GetSector() == 1 then
		expected[REWARD_TECH] = 0
	end
	
	local assets = { 
		[REWARD_REP] = copy_table(corp.RepAssets),
		[REWARD_POWER] = copy_table(corp.PowAssets),
		[REWARD_TECH] = copy_table(corp.TechAssets)
	}
	
	--0 through 2 is REWARD_REP - REWARD_POWER - REWARD_TECH
	local templist = shallow_copy(incidents)
--	templist[1]:GetRewardCount()
	for reward = 0, 2 do
		local total = 0
		for i, m in ipairs(incidents) do
			total = m:GetRewardCount(reward) + total
		end
		
		--if not enough of a reward, 
		while total < expected[reward] and #assets[reward] > 0 do
		    local simple = popSimpleMission(templist)
		    if simple then
			    simple:AddAsset(random_removal(assets[reward]))
			    total = total + 1
			else
			    LOG("Could not find mission for reward id "..reward)
			    break
			end
		end
	end
	
	------ Modify how hard/easy some of the missions are based on their rewards
	
	local high = {}
	local low = {}
	for i,m in ipairs(incidents) do
		if m:GetRewardCount() >= 3 then
			if #high < 2 then
				high[#high+1] = m
			else
				m:RemoveBonus()
			end
		elseif not m.BlockEasy then
			low[#low+1] = m
		end
	end
	
	for i,m in ipairs(high) do m.DiffMod = DIFF_MOD_HARD end
	
	while #low > 0 do
		local easy = random_removal(low)
		easy:RemoveBonus()
		--LOG("Removing bonus")
		if easy:GetRewardCount() == 1 then
			easy.DiffMod = DIFF_MOD_EASY
			break
		end
	end
		
	-------------------------------------------------------------------------------
	
	--End by adding the boss
	incidents[#incidents + 1] = CreateMission(boss)
	
	GAME.Missions = incidents
	
	--return incidents
end
