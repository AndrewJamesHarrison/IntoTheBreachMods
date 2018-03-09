
local function random_drop(droplist)
	local choices = {}
	local odds = {40, 30, 20, 10}
	
	local emergency_break = 0
	while true do
		local roll = random_int(100)
		local current = 0
		for i,v in ipairs(odds) do
			current = current + v
			if roll < current then
				rarity = i
				break
			end
		end
		choices = {}
		for i,v in ipairs(droplist) do
			if v.rarity == rarity then
				choices[#choices+1] = v.name
			end
		end
		
		if #choices > 0 then
			break
		end
		
		emergency_break = emergency_break + 1
		
		if emergency_break > 100 then
		    break
		end
	end
	
	return random_element(choices)
	
	--[[local list = {}
	local total_weight = 0
	for i,v in ipairs(droplist) do
		local rarity = v.rarity
		local curr = v.name
		if rarity ~= 0 then
			list[#list+1] = { name = curr, weight = (5 - rarity) }
			total_weight = total_weight + (5 - rarity)
		end
	end
	
	local choice = random_int(total_weight)
	local item = ""
	for i,v in ipairs(list) do
		choice = choice - v.weight
		if choice <= 0 then
			item = v.name
			break
		end
	end
	
	if item == "" then item = list[#list].name end
	
	return item]]--
end

function removePilot(pilot)
	remove_element(pilot,GAME.PilotDeck)
	GAME.SeenPilots[#GAME.SeenPilots+1] = pilot
end

function isPilotSeen(pilot)
	for i,v in ipairs(GAME.SeenPilots) do
		if v == pilot then
			return true
		end
	end
	
	return false
end

function testPilot()
    local tests = {}
    local goal = #PilotList
    local games = 0
    local count = 0
    local total_games = 0
    local total = 0
    
	for x = 1, 100 do
		count = 0
		games = 0
		tests = {}
		while count ~= goal do
		
			GAME.PilotDeck = copy_table(PilotList)

			for i = 1,6 do
			    if random_int(11) <= 3 then
			    	tests[getPilotDrop()] = true
			    end
			end
			
			tests[getPilotDrop()] = true
			
			count = 0
			for i,v in pairs(tests) do
				count = count + 1
			end
			
			games = games + 1
			LOG("Found "..count.." pilots so far. Goal is "..goal)
			
			if games > 100 then
				break
			end
		end
		
		if games < 100 then
			total_games = games + total_games
			LOG("It took "..games.." games")
			total = total + 1
		end
		
		LOG("It took on average "..total_games/total.." games across "..total)
	end
end

function getPilotDrop()
	if #GAME.PilotDeck == 0 then
		GAME.PilotDeck = copy_table(PilotList)
	end
	
	local dropList = {}
	
	for i,v in ipairs(GAME.PilotDeck) do
		local pilot = _G[v]
		local rare = pilot.Rarity
		dropList[#dropList+1] = { name = v, rarity = rare }
	end
	
	local drop = random_drop(dropList)
	removePilot(drop)
	
	return drop
end

	
local weapon_list = {	
------
	"Prime_Punchmech",
	"Prime_Lightning",
	"Prime_Lasermech",
	"Prime_ShieldBash",
	"Prime_Rockmech",
	"Prime_RightHook",
	"Prime_RocketPunch",
	"Prime_Shift",
	"Prime_Flamethrower",
	"Prime_Areablast",
	"Prime_Spear",
		--
	"Prime_Leap",
	"Prime_SpinFist",
		--
	"Prime_Sword", 
	"Prime_Smash",
------
------
	"Brute_Tankmech",
	"Brute_Jetmech",
	"Brute_Mirrorshot",
	"Brute_PhaseShot",
		--
	"Brute_Grapple",
	"Brute_Shrapnel",
		--
	"Brute_Sniper",
	"Brute_Shockblast",
	"Brute_Beetle",
	"Brute_Unstable",
		--
	"Brute_Heavyrocket",
	"Brute_Splitshot",
	"Brute_Bombrun",
	"Brute_Sonic",
------
------
	"Ranged_Artillerymech",
	"Ranged_Rockthrow",
	"Ranged_Defensestrike",
	"Ranged_Rocket",
	"Ranged_Ignite",
	"Ranged_ScatterShot",
	"Ranged_BackShot",
		--
	"Ranged_Ice",
	"Ranged_SmokeBlast",
		--
	"Ranged_Fireball",
	"Ranged_RainingVolley",
		--
	"Ranged_Wide",
	"Ranged_Dual",
------
------
	"Science_Pullmech",
	"Science_Gravwell",
	"Science_Swap",
	"Science_Repulse",
	"Science_AcidShot",
	"Science_Confuse",
		--
	"Science_SmokeDefense",
	"Science_Shield",
	"Science_FireBeam",
	"Science_FreezeBeam",
	"Science_LocalShield",
	"Science_PushBeam",
------
------
	"Support_Boosters",
	"Support_Smoke",
	"Support_Refrigerate",
	"Support_Destruct",
		--
	"DeploySkill_ShieldTank",
	"DeploySkill_Tank",
	"DeploySkill_AcidTank",
	"DeploySkill_PullTank",
		--
	"Support_Force",
	"Support_SmokeDrop",
	"Support_Repair",
	"Support_Missiles",
	"Support_Wind",
	"Support_Blizzard",
------
------
	"Passive_FlameImmune",
	"Passive_Electric",
	"Passive_Leech",
	"Passive_MassRepair",
	"Passive_Defenses",
	"Passive_Burrows",
	"Passive_AutoShields",
	"Passive_Psions",
	"Passive_Boosters",
	"Passive_Medical",
	"Passive_FriendlyFire",
	--"Passive_FastDecay",  --REMOVE?
	"Passive_ForceAmp",
	--"Passive_Ammo", -- REMOVE?
	"Passive_CritDefense",
------
}

function Skill:GetRarity()
	if GetSector() == 1 then
		return self.PowerCost + 1
	elseif GetSector() == 2 then
		return math.min(2,self.PowerCost+1)
	else
		return math.min(1,self.PowerCost+1)
	end
end

function removeWeapon(weapon)
	remove_element(weapon,GAME.WeaponDeck)
end

function getWeaponDrop(classes)

	if #GAME.WeaponDeck == 0 then GAME.WeaponDeck = copy_table(weapon_list) end
	
	local dropList = {}
	
	for i,v in ipairs(GAME.WeaponDeck) do
		local weapon = _G[v]
		
        if weapon ~= nil then
            local rare = weapon:GetRarity()
            if not Game:IsMechClass(weapon.Class) then 
                rare = 4--math.min(5,rare + 4)
            end
            dropList[#dropList+1] = { name = v, rarity = rare }
		end
	end
	
	--LOG("Drop list = "..#dropList)
	local drop = random_drop(dropList)
	removeWeapon(drop)
	
	return drop
	--return random_removal(GAME.WeaponDeck)
end

function initializeDecks()
	GAME.WeaponDeck = copy_table(weapon_list)
	GAME.PilotDeck = copy_table(PilotList)
end

function testWeaponDrops()
	
	local weapons = {}
	for i = 1, 1000 do
		--GAME.PilotDeck = copy_table(PilotList)
		GAME.WeaponDeck = copy_table(weapon_list)
		
		for j = 1, 10 do
			local drop = getWeaponDrop()
			--local drop = getPilotDrop()
			weapons[drop] = weapons[drop] or 0
			weapons[drop] = weapons[drop] + 1
		end
	end
	
	local rarity_counts = {0,0,0,0,0}
	for i, v in pairs(weapons) do  
		local rarity = _G[i]:GetRarity()
		local is_class = Game:IsMechClass(_G[i].Class)
		
		if not is_class then
			rarity = 4
		end
		
        local modified_rarity = (not is_class) and " (wrong class)" or ""
		LOG(i.." = "..v..",  rarity = "..rarity..modified_rarity)
		
		rarity_counts[rarity] = rarity_counts[rarity] + 1
	end
	
	for i,v in ipairs(rarity_counts) do
		LOG("Total "..i.." rarity: "..v)
	end
end
