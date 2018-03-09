
---------- This file should not be altered -----
---------- Unless you're really sure you know what you're doing -------

function LOG(...)
	local output = ""
	for i,v in ipairs(arg) do
        output = output .. tostring(v) .. "    "
	end
	ConsolePrint(output)
	print(output)
end


SCREEN_CENTER = Point(ScreenSizeX()/2, ScreenSizeY()/2)

DIR_VECTORS = {}
DIR_VECTORS[DIR_UP] = VEC_UP
DIR_VECTORS[DIR_DOWN] = VEC_DOWN
DIR_VECTORS[DIR_RIGHT] = VEC_RIGHT
DIR_VECTORS[DIR_LEFT] = VEC_LEFT 

PUSH_ANIMS = {}
PUSH_ANIMS[DIR_UP] = "airpush_0"
PUSH_ANIMS[DIR_DOWN] = "airpush_2"
PUSH_ANIMS[DIR_RIGHT] = "airpush_1"
PUSH_ANIMS[DIR_LEFT] = "airpush_3"

PUSHEXPLO1_ANIMS = {}
PUSHEXPLO1_ANIMS[DIR_UP] = "explopush1_0"
PUSHEXPLO1_ANIMS[DIR_DOWN] = "explopush1_2"
PUSHEXPLO1_ANIMS[DIR_RIGHT] = "explopush1_1"
PUSHEXPLO1_ANIMS[DIR_LEFT] = "explopush1_3"

PUSHEXPLO2_ANIMS = {}
PUSHEXPLO2_ANIMS[DIR_UP] = "explopush2_0"
PUSHEXPLO2_ANIMS[DIR_DOWN] = "explopush2_2"
PUSHEXPLO2_ANIMS[DIR_RIGHT] = "explopush2_1"
PUSHEXPLO2_ANIMS[DIR_LEFT] = "explopush2_3"


--Gets filled with various useful constants
Values = {} 
Location = {}
Buttons = {}
Texts = {}
Boxes = {}
Colors = {}
Lines = {}

------------ Set a global access point for the current Board ----------------------

function SetBoard(board)
	Board = board
end

function SetPawn(pawn)
	Pawn = pawn
end

function SetGame(game)
	Game = game
end

function GetBoard()
	return Board
end

function GetGame()
	return Game
end

function GetPawn()
	return Pawn
end

function GetSector()
    if Game ~= nil then
       return Game:GetSector()
    end
    return 1
end

------------- Help for setting up generic classes to ease interface with C++ ------------

function CreateClass(newclass)
	local members = {}
	
	for i,v in pairs(newclass) do
		members[#members + 1] = i 
	end
	
	for i = 1, #members do
		newclass["Get" .. members[i]] = function (self, pawn) return self[members[i]] end
	end
	
	newclass.new = 	function(self,o)
						o = o or {} -- create table if user does not provide one
						setmetatable(o, self)
						self.__index = self
						return o
					end
end

----------- Pawn Setup Stuff -----------------

Pawn = {
	Name = "Unnamed Pawn",
	Class = "",
	Health = 3,
	Image = "battle_walk_down",
	MoveSpeed = 0,
	Weapon = 1,
	SkillList = {},
	Neutral = false,
	Massive = false,
	Corpse = false,
	Ranged = 0,
	Flying = false,
	Teleporter = false,
	Image = "",
	ImageOffset = 0,
	Jumper = false,
	IgnoreSmoke = false,
	SelfHeal = false, -- this is a hack and won't actually add this ability (see BotBoss)
	IgnoreFire = false,
	Pushable = true,
	Minor = false,
	Mission = false,
	Leader = LEADER_NONE,
	Tier = TIER_NORMAL,
	Upgrades = {},
	Armor = false,
	Energy = 0,
	SoundLocation = "",
	ScoreDanger = -10,
	DefaultTeam = TEAM_NONE,
	DefaultFaction = FACTION_DEFAULT,
	ReactorCosts = { 1,1,1,1,1,2,2,2,2,2 },
	ExtraSpaces = {},
	Portrait = "",
	ImpactMaterial = IMPACT_NULL,
	SpaceColor = true,
	PositionScore = 0, --can overwrite the get method to make a custom AI positioning scorer
	Corporate = false,--decides if it gets a corporate pilot
	IsPortrait = true, --don't give it a portrait in combat
	AiPortrait = false,
	AvoidingMines = false,
	Burrows = false,
	Explodes = false,
	SpawnLimit = true,
	Tooltip = "",
	IsDeathEffect = false,
	PilotDesc = "",
}

CreateClass(Pawn)

function Pawn:GetDeathEffect()
	local ret = SkillEffect()
	return ret
end

function Pawn:GetReactorCost(num)
	if num >= 1 and num <= #self.ReactorCosts then
		return self.ReactorCosts[num]
	else
		return 5
	end
end

function Pawn:GetUpgrades(tier)
	local upgradeList = {}
		
	if #self.Upgrades == 0 then
		return ret
	end
	
	if type(self.Upgrades[1]) == "table" then
		if tier - 1 <= #self.Upgrades then
			upgradeList = self.Upgrades[tier-1]
		else
			upgradeList = {}
		end
	else
		upgradeList = self.Upgrades
	end
	
	return upgradeList
end

PawnList = {}
PawnCount = 0

function AddPawnName(name)
	PawnList[#PawnList+1] = name
	PawnCount = #PawnList
end

function AddPawn(name)
	_G[name] = Pawn:new(_G[name])
	PawnList[#PawnList+1] = name
	PawnCount = #PawnList
end


---------- Skill Setup Stuff-------------------

RANGE_PROJECTILE = -2
RANGE_ARTILLERY = -3

StandardTips = {}

StandardTips.Ranged = {
	Unit = Point(2,3),
	Enemy = Point(2,1),
	Target = Point(2,1)
}

StandardTips.Surrounded = {
	Unit = Point(2,2),
	Target = Point(2,1),
	Enemy = Point(2,3),
	Enemy2 = Point(3,2),
	Enemy3 = Point(2,1)
}

StandardTips.Deploy = {
	Unit = Point(2,3),
	Target = Point(2,1)
}

StandardTips.Melee = {
	Unit = Point(2,2),
	Enemy = Point(2,1),
	Target = Point(2,1)
}

StandardTips.RangedAoe = {
	Unit = Point(2,3),
	Enemy = Point(2,1),
	Enemy2 = Point(3,1),
	Target = Point(2, 1)
}

Skill = 
	{
		CornersAllowed = false,
		PathSize = INT_MAX,
		Explosion = "",
		Upgrades = 0,
		UpgradeList = {},
		UpgradeCost = {},
		Name = "Weapon Name",
		SkillName = "Skill Name",
		Description = "Null",
		Description2 = "Null",
		EffectImage = "todo",
		ScoreEnemy = 5,
		Icon = "weapons/skill_default.png",
		ScoreFriendlyDamage = -2,
		ScoreBuilding = 5,
		ScoreNothing = 0,
		LaunchSound = "default",
		ImpactSound = "",
		Limited = 0,
		PowerCost = 0,
		UpgradeDescription = "Null",
		UpgradeCosts = {1,1},
		Class = "",
		Cost = "med",
		Tags = { "" },
		----This stuff is used for generating tooltips, and it's strongly encouraged that
		---- you use it for actual weapon data as well
		Damage = 0,
		Web = 0,
		Push = 0,
		Acid = 0,
		Range = 0,
		Smoke = 0,
		Fire = 0,
		SelfDamage = 0,
		Shield = 0,
		MinDamage = -1,
		----Optionally, just manually write the tooltip section
		TipDamage = -1,
		DamageTooltip = TipData("",""),
		Rarity = 1,
		TipImage = {},
		CustomTipImage = "",
		Passive = "",
	}

function Skill:GetTipData(data)
	local ret = {}
	for i,v in pairs(self.TipImage) do
		if type(v) ~= "string" and type(v) ~= "number" then
			ret[#ret+1] = data == 0 and i or v
		end
	end
	return ret
end

function Skill:GetTipString(key)
	if self.TipImage[key] ~= nil then return self.TipImage[key] end
	return ""
end

function Skill:GetTipNum(key)
	if self.TipImage[key] ~= nil then return self.TipImage[key] end
	return 0
end
	
CreateClass(Skill)

--[[------------------------------------------------------]]--

function Skill:GetCost()
	return getAutoWeaponCost(self.Cost)
end

function Skill:GetTargetArea(point)
	return Board:GetSimpleReachable(point, self.PathSize, self.CornersAllowed)
end

function Skill:GetUpgradeCost(upgrade)
	upgrade = upgrade + 1
	
	if upgrade > #self.UpgradeCost then return 1 end
	
	return self.UpgradeCost[upgrade]
end

function Skill:GetSkillEffect(p1, p2)
	return SkillEffect()
end	

function Skill:GetTargetScore(p1, p2)
	local skillEffect = self:GetSkillEffect(p1,p2)
	
	local queued_score = self:ScoreList(skillEffect.q_effect,true)
	local instant_score = self:ScoreList(skillEffect.effect,false)
	
	if instant_score < -20 then
		return -100--don't do anything so horrible if it's instant
	end
	
	if skillEffect.q_effect:empty() then
		return instant_score
	end
	
	return queued_score
end

function isEnemy(team1,team2)
	if team1 == TEAM_NONE or team2 == TEAM_NONE then return false end
	return team1 ~= team2
end

function Skill:ScoreList(list, queued)
	local score = 0
	local posScore = 0
	for i = 1, list:size() do
		local spaceDamage = list:index(i)
		local target = spaceDamage.loc
		local damage = spaceDamage.iDamage 
		local moving = spaceDamage:IsMovement() and spaceDamage:MoveStart() == Pawn:GetSpace()
		
		if Board:IsValid(target) or moving then	
			if spaceDamage:IsMovement() then
				posScore = posScore + ScorePositioning(spaceDamage:MoveEnd(), Pawn)
			elseif Board:GetPawnTeam(target) == Pawn:GetTeam() and damage > 0 then
				if Board:IsFrozen(target) and not Board:IsTargeted(target) then
					score = score + self.ScoreEnemy
				else
					score = score + self.ScoreFriendlyDamage
				end
			elseif isEnemy(Board:GetPawnTeam(target),Pawn:GetTeam()) then
					if Board:GetPawn(target):IsDead() then 
						score = self.ScoreNothing
					else
						score = score + self.ScoreEnemy
					end
			elseif Board:IsBuilding(target) and Board:IsPowered(target) and damage > 0 then
				score = score + self.ScoreBuilding
			elseif Board:IsPod(target) and not queued and (damage > 0 or spaceDamage.sPawn ~= "") then
				return -100
			else
				score = score + self.ScoreNothing
			end
		end
	end
	
	--if position is REALLY BAD don't do this (blocking friends, dying, etc.)
	if posScore < -5 then	
		return posScore 
	end
	
	return score
end

-------- AI Scoring Function for positioning -------------------------

function ScorePositioning(point, pawn)

	--LOG("Scoring position ("..point.x..","..point.y..")")

	if Board:IsPod(point) then return -10 end
	
	if Board:GetTerrain(point) == TERRAIN_HOLE and not pawn:IsFlying() then
		return -10
	end
	
	if Board:IsTargeted(point) then return pawn:GetDangerScore() end
	
	if Board:IsSmoke(point) then return -2 end
	
--	if Board:IsAcid(point) then return -10 end --let the enemies walk on acid, it's more fun.
	
	if Board:IsFire(point) and not pawn:IsFire() then return -10 end
	
	if Board:IsSpawning(point) then return -10 end
	
	if Board:IsDangerous(point) then return -10 end --generic danger marked custom in missions
	
	if Board:IsDangerousItem(point) and pawn:IsAvoidingMines() 
		then return -10 
	end
	
	if Board:GetTerrain(point) == TERRAIN_WATER and not pawn:IsFlying() then return -5 end
	
	local custom = pawn:GetCustomPositionScore(point)
	if custom ~= 0 then return custom end

	local edge1 = point.x == 0 or point.x == 7
	local edge2 = point.y == 0 or point.y == 7
	
	if edge1 and edge2 then
		return -2 --really avoid corners
	elseif edge1 or edge2 then
		return 0--edges are discouraged
	end
	
	local enemy = (pawn:GetTeam() == TEAM_PLAYER) and TEAM_ENEMY or TEAM_PLAYER --this assumes black and white teams. melee bots wouldn't work. we don't have melee bots though.
		
	--melee units, lets make sure they at least try to get closer
	if not pawn:IsRanged() then
		
		for i = DIR_START, DIR_END do
			if Board:IsPawnTeam(point + DIR_VECTORS[i], enemy) then return 5 end
			if Board:IsBuilding(point + DIR_VECTORS[i]) then return 5 end
		end
		
		local closest_pawn = Board:GetDistanceToPawn(point,enemy)
		local closest_building = Board:GetDistanceToBuilding(point)
		local closest = math.min(closest_pawn,closest_building) --should some pawns emphasize one over the other?
		return math.max(0, (10-closest)/2)
	end
	
	--ranged units, if you got this far it's probably fine
	return 5
end

-----------------------------------------------------

--syntactic sugar to help make event lists more readable
function Dialog(...)
	local ret = {}
	for i,v in ipairs(arg) do
		ret[i] = v
	end
	return ret
end

------------ Useful functions -------------

function GetTurnString(turns)
	if turns == 1 then return "1 turn" end
	
	return turns.." turns"
end

function CallMethod(obj, func, arg1, arg2)
	
	if string.find(obj,"Mission") ~= nil then
	    local mission = GAME:GetMission(obj)
		--local mission = GAME.Missions[tonumber(string.gsub(obj,"Mission",""))] 
		if mission ~= nil then
			return mission[func](mission,arg1,arg2)
		end
	end
	
	--LOG("calling "..obj.."::"..func)
	if _G[obj] == nil then LOG(obj .. " does not exist") return 0 end
	
	if _G[obj][func] == nil then LOG(obj .. "::" .. func .. " does not exist") return 0 end
	
	return _G[obj][func](_G[obj],arg1,arg2)
end

function randomize(list)
	local ret = {}
	for i = 1, #list do
		ret[i] = random_removal(list)
	end
	return ret
end

function list_contains(list, obj)
	for i,v in ipairs(list) do
		if obj == v then return true end
	end
	
	return false
end

function random_element(list)
	if #list == 0 then
		return nil
	end
	
	return list[random_int(#list)+1]
end

function remove_element(item,list)
	for i = 1, #list do
		if list[i] == item then
			table.remove(list,i)
			break
		end
	end
end

function pop_back(list)
	local back = list[#list]
	table.remove(list,#list)
	return back
end

function random_removal(list)
	return table.remove(list,random_int(#list)+1)
end

function reverse_table(list)
	local ret = {}
	for i = #list, 1, -1 do
		ret[#ret+1] = list[i]
	end
	return ret
end

function shallow_copy(list)
	local ret = {}
	if type(list) ~= 'table' then return list end
	for k, v in pairs(list) do ret[k] = v end 
	return ret
end

function copy_table(list)
	local ret = {}
	if type(list) ~= 'table' then return list end
	for k, v in pairs(list) do ret[k] = copy_table(v) end 
	return ret
end

function add_tables(list1,list2)
	local base = copy_table(list1)
	
	for i,v in ipairs(list2) do
		base[#base+1] = v
	end
	
	return base
end

function save_table(target)
	local ret = "{"
	for i, v in pairs(target) do
		local value = ""
	    if type(v) == "table" then
	        if v ~= target.__index then
				value = save_table(v)
			end    
		elseif type(v) == "userdata" and v["GetLuaString"] ~= nil then
			value = v:GetLuaString()
        elseif type(v) ~= "userdata" and type(v) ~= "function" then
            if type(v) == "string" then
	    	    value = "\""..v.."\""
	    	elseif type(v) == "boolean" then
	    	    value = v and "true" or "false"
	        else
                value = v
            end    
	    end
		
	-- 	if string.len(value) ~= 0 then
			if type(i) == "string" then
				ret = ret.." \n[\""..i.."\"] = "..value..","
			else
				ret = ret.." \n["..i.."] = "..value..","
			end
	--	end
	end
	
	if string.len(ret) > 1 then
		ret = string.sub(ret,1,string.len(ret)-1)
	end
	
	ret = ret.." \n}"
	
	return ret
end


-------- Set object -- used in Sectors.lua -----------

Set = { items = {} }

Set.new = 	function(self,o)
				o = o or {} -- create table if user does not provide one
				setmetatable(o, self)
				self.__index = self
				for i,v in ipairs(o) do
					self.items[v] = i
				end
				return o
			end

function Set:Add(item)
	if self.items[item] == nil then
		self[#self + 1] = item
		self.items[item] = #self
	end
end

function Set:Contains(item)
	return self.items[item] ~= nil
end

function Set:Remove(item)
	if self.items[item] == nil then return end
	table.remove(self,self.items[item])
	self.items[item] = nil
end

function Set:RandomRemove()
	local choice = random_element(self)
	self:Remove(choice)
	return choice
end

function RandomTest()
	local list = {}
	for i = 1,10000000 do
		local num = math.random(100)
		list[num] = list[num] and list[num] + 1 or 1
	end
	
	for i,v in ipairs(list) do
		LOG(i..": "..v)
	end
end

function bool_int(val)
	return val and 1 or 0
end

function subsign(val)
	return val > 0 and 1 or -1
end

function getMinIndex(list)
	local val = list[1]
	local mini = 1
	for i,v in ipairs(list) do
		if v <= val then
			val = val
			mini = i
		end
	end
	return mini
end

function getMaxIndex(list)
	local val = list[1]
	local maxi = 1
	for i,v in ipairs(list) do
		if v >= val then
			val = val
			maxi = i
		end
	end
	return maxi
end

--- Debugging nonsense

function DropTile(p)
	local damage = SpaceDamage(p)
	damage.iTerrain = TERRAIN_HOLE
	local effect = SkillEffect()
	effect:AddDamage(damage)
	Board:AddEffect(effect)
end
