
Mission_Belt = Mission_Auto:new{ 
	--MapTags = {"belt"},
	Environment = "Env_BeltLine",
	UseBonus = true
}

Mission_BeltRandom = Mission_Auto:new{
	Environment = "Env_BeltRandom",
	UseBonus = true
}

Env_Belt = Environment:new{
	Name = "Conveyors",
	Text = "Conveyor Belts will push any unit on them in the marked direction at the start of the enemy turn.",
	StratText = "CONVEYOR BELTS",
	CombatIcon = "combat/tile_icon/tile_conveyor.png",
	CombatName = "CONVEYORS",
	Belts = nil,
	BeltsDir = nil,
}

function Env_Belt:IsValidTarget(p)
    local tile = Board:GetTerrain(p)
	
	return Board:IsValid(p) and 
			not Board:IsPod(p) and 
			not Board:IsBuilding(p) and 
			not (tile == TERRAIN_MOUNTAIN)
end

function Env_Belt:IsBelt(p)
    if self.Belts == nil then return false end
    
	for i,v in ipairs(self.Belts) do
		if v == p then return true end
	end
	
	return false
end

function Env_Belt:GetDir(p)
	if self.Belts == nil then return DIR_NONE end
	
	for i,v in ipairs(self.Belts) do
		if v == p then return self.BeltsDir[i] end
	end
	
	return DIR_NONE
end

function Env_Belt:AddBelt(p,dir)
	self.Belts = self.Belts or {}
	self.BeltsDir = self.BeltsDir or {}
	
	self.Belts[#self.Belts+1] = p
	self.BeltsDir[#self.BeltsDir+1] = dir
	Board:ClearSpace(p)
	Board:BlockSpawn(p,BLOCKED_PERM)
end

function Env_Belt:MarkBoard()
	for i,v in ipairs(self.Belts) do
		Board:SetCustomTile(v,"conveyor"..self.BeltsDir[i]..".png")
		Board:MarkSpaceDesc(v,"belt")
		Board:SetTerrainIcon(v,"arrow_"..self.BeltsDir[i])
	end
end

function Env_Belt:IsEffect()
	return true
end

function Env_Belt:ApplyBelts()
		
	local effect = SkillEffect()
	effect:AddSound("/props/conveyor_belt")
	
	for i, v in ipairs(self.Belts) do
		local damage = SpaceDamage(v,0,self.BeltsDir[i])
		damage.sAnimation = "Conveyor_"..self.BeltsDir[i]
		effect:AddDamage(damage)
		
		if Board:IsPawnSpace(v) then
			effect:AddDelay(0.2)
		end
	end
	
	effect.iOwner = ENV_EFFECT
    Board:AddEffect(effect)	
    
    return false--no more to do
end

function Env_Belt:ApplyEffect()
	return self:ApplyBelts()
end

Env_BeltLine = Env_Belt:new{
	
}

function Env_BeltLine:Start()
    self.Belts = {}
    self.BeltsDir = {}
	
	local path = self:GetCrossingPath()
	
	Board:SetTerrain(path[#path], TERRAIN_WATER)
	Board:SetAcid(path[#path],true)
			
	for i = #path - 1, 1, -1 do
		self:AddBelt(path[i], GetDirection(path[i+1]-path[i]))
	end
	
	self:MarkBoard()
end

Env_BeltRandom = Env_Belt:new{

}

function Env_BeltRandom:IsValidTarget(p, path)
	path = path or {}
	local origin = #path > 0 and path[1] or nil

    if self:IsBelt(p) then return false end
	
	for i,v in ipairs(path) do
		if p == v then return false end
	end
	
	for i = DIR_START, DIR_END do
		if self:IsBelt(p + DIR_VECTORS[i]) and origin ~= p + DIR_VECTORS[i] then
			return false
		end
	end
	
	return Env_Belt:IsValidTarget(p)
end

function Env_BeltRandom:Start()
	self.Belts = {}
    self.BeltsDir = {}
	
	local hash = function(point) return point.x + point.y*10 end
	
	local quarters = self:GetQuarters()
	local destinations = {}
	
	for i,choices in ipairs(quarters) do
		local path = {}
		local valid_choices = {}
		
		for index,point in ipairs(choices) do
			if self:IsValidTarget(point) then
				valid_choices[#valid_choices+1] = point
			end
		end
		
		if #valid_choices > 0 then
			path[#path+1] = random_element(valid_choices)
			local length = random_int(3)
			for count = 1, length do
				local pot = {}
				for i = DIR_START, DIR_END do
					if self:IsValidTarget(path[#path] + DIR_VECTORS[i], path) then
						pot[#pot+1] = path[#path] + DIR_VECTORS[i]
					end
				end
				
				if #pot == 0 then break end
				
				path[#path+1] = random_element(pot)
			end
						
			if #path > 1 then
							
				local final_dir = GetDirection(path[#path] - path[#path-1])
				local final_dest = path[#path] + DIR_VECTORS[final_dir]
				--LOG("Final dest = "..final_dest:GetString())
				if not Board:IsValid(final_dest) or destinations[hash(final_dest)] ~= nil then
					path = reverse_table(path)
					final_dir = GetDirection(path[#path] - path[#path-1])		
					final_dest = path[#path] + DIR_VECTORS[final_dir]
				end
						
				self:AddBelt(path[#path], final_dir)
				destinations[hash(final_dest)] = true
				
				for i = #path - 1, 1, -1 do
					self:AddBelt(path[i], GetDirection(path[i+1]-path[i]))
				end
				
			elseif #path > 0 then
				local choices = {}
				for dir = DIR_START, DIR_END do
					local dest = path[1] + DIR_VECTORS[dir]
					if Board:IsValid(dest) and destinations[hash(dest)] == nil then
						choices[#choices+1] = dir
					end
				end
				
				if #choices > 0 then
					local choice = random_element(choices)
					self:AddBelt(path[1], choice)
					destinations[hash(path[1] + DIR_VECTORS[choice])] = true
				end
			end
		end
	end
	
	self:MarkBoard()
end