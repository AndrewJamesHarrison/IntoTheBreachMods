
--- Ignore me
Environment = {
	Image = "", Text = "", Name = "", StratText = "", CombatIcon = "", CombatName = "ENVIRONMENT"
}

function Environment:Start() end
function Environment:MarkBoard() end
function Environment:Plan() return false end -- Return TRUE if you're not done planning
function Environment:IsEffect() return false end 
function Environment:ApplyEffect() return false end --return TRUE if you're not done acting

--generally, the environment shouldn't target buildings,pods,etc. -- but some environments can override this
function Environment:IsValidTarget(space)
	local tile = Board:GetTerrain(space)
	
	return Board:IsValid(space) and 
			not Board:IsPod(space) and 
			not Board:IsBuilding(space) and 
			(tile ~= TERRAIN_WATER or self.WaterTarget)
end

CreateClass(Environment)

Env_Null = Environment:new{}
-----------------------

--- Attack Environment (An effect is queued on a number of squares, then enacted the next turn)

Env_Attack = Environment:new{
	Locations = nil,
	Planned = nil,
	CurrentAttack = nil,
	Ordered = false,
	WaterTarget = false,
	Instant = false,
	StartEffect = false,
	EndEffect = false,
}

function Env_Attack:Start()
	self.Locations = {}
	self.Planned = {}
end

function Env_Attack:IsEffect()
	return #self.Locations ~= 0
end

function Env_Attack:BlockSpawn(space)
	Board:BlockSpawn(space,BLOCKED_TEMP)
end

function Env_Attack:Plan()

	self.EndEffect = true
	self.StartEffect = true
	
	if #self.Locations == #self.Planned and #self.Locations ~= 0 then
		return false
	end
	
	if #self.Locations == 0 then
		self.Planned = self:SelectSpaces()
		
		for i,v in ipairs(self.Planned) do
			self:BlockSpawn(v)
		end
	end
	
	if #self.Planned == 0 then
	    return false
	end
	
	Game:TriggerSound("/props/square_lightup")
	if self.Instant then
	    self.Locations = self.Planned
	    return false
	end

	self.Locations[#self.Locations + 1] = self.Planned[#self.Locations+1]
	return true
end

function Env_Attack:ApplyStart()

end

function Env_Attack:ApplyEnd()

end

function Env_Attack:ApplyEffect()
	
	if self.StartEffect then
		self:ApplyStart()
		self.StartEffect = false
	end
	
	if self.Instant then
	--	local delay = SkillEffect()
		--delay:AddDelay(0.5)
		local effect = SkillEffect()
	    for i,v in ipairs(self.Locations) do
	        effect = self:GetAttackEffect(v,effect)
	    end
		effect.iOwner = ENV_EFFECT
		Board:AddEffect(effect)
	    self.CurrentAttack = self.Locations
	    self.Locations = {}
	else
		if not self.Ordered then
		    self.CurrentAttack = random_removal(self.Locations)
	    else
		    self.CurrentAttack = self.Locations[1]
		    table.remove(self.Locations,1)
    	end
	
		local effect = self:GetAttackEffect(self.CurrentAttack)
		effect.iOwner = ENV_EFFECT
	    Board:AddEffect(effect)
	end
	
	if not self:IsEffect() and self.EndEffect then
		self:ApplyEnd()
		self.EndEffect = false
	end
	
	return self:IsEffect()
end

function Env_Attack:MarkBoard()
	if not self:IsEffect() and not Board:IsBusy() then 
		self.CurrentAttack = nil
	end
		
	for i,v in ipairs(self.Locations) do
	    local focused = false
        if self.Instant and self.CurrentAttack ~= nil then
	        focused = true
	    elseif self.CurrentAttack == v then
	        focused = true
	    end
		self:MarkSpace(v,focused)
	end
end


------------- Flooding environment

Env_LandChange = Environment:new{
	Locations = nil,--initialize in any object that inherits, otherwise they change the base class
	EnvFlag = 0,
	Zone = ""
}

function Env_LandChange:GetTerrain()
	return TERRAIN_GROUND
end

function Env_LandChange:GetCustomTile()
	return "\"\""
end

function Env_LandChange:SetupLocations()
	local zone = Board:GetZone(self.Zone)
	self.Locations = {}
	for i = 1, zone:size() do
		self.Locations[#self.Locations+1] = zone:index(i)
	end
end

function Env_LandChange:Start() 
	self:SetupLocations()
	for i,v in ipairs(self.Locations) do
		Board:SetTerrain(v,self:GetTerrain())
		Board:SetCustomTile(v,self:GetCustomTile())
	end
end

function Env_LandChange:IsEffect()
	if self.Locations == nil or #self.Locations == 0 then
		return false
	end
	
	return true
end

function Env_LandChange:ApplyEffect()
	self.EnvFlag = self.EnvFlag == 0 and 1 or 0

    local terrain = self:GetTerrain()
	local custom = self:GetCustomTile()

	local tiles = copy_table(self.Locations)
	local effect = SkillEffect()
	
	while #tiles ~= 0 do
		local current = random_removal(tiles)
		local damage = SpaceDamage(current)
		damage.iTerrain = terrain
		damage.sScript = "Board:SetCustomTile("..current:GetString()..","..custom..")"
		damage.fDelay = 0.2
		effect:AddDamage(damage)
	end
	
	Board:AddEffect(effect)
	
	return false
end

---- Flooding Environment

Env_Flooding = Env_LandChange:new{Zone = "flooding"}

function Env_Flooding:GetTerrain()
	return self.EnvFlag == 0 and TERRAIN_WATER or TERRAIN_ROAD
end

function Env_Flooding:GetCustomTile()
	return self.EnvFlag == 0 and "\"\"" or "\"flood_0.png\""
end

------- Environment Helper Functions

function Environment:GetQuarters()
	local quarters = {}
	local start = Point(1,1)
	for count = 1, 4 do--find one in each quadrant
	    local choices = {}
	    for i = start.x, (start.x + 2) do
	        for j = start.y, (start.y + 2) do
                if self:IsValidTarget(Point(i,j)) then
                    choices[#choices+1] = Point(i,j)
                end
			end
		end

	--	ret[#ret+1] = random_removal(choices)
		quarters[#quarters+1] = choices
		
		if count == 1 then start = Point(1,4) end
		if count == 2 then start = Point(4,1) end
		if count == 3 then start = Point(4,4) end
	end
	
	return quarters
end

function Environment:GetCrossingPath()
	local path = {}
	
	while #path == 0 do
		local endpoints = self:FindEndpoints()
		path = extract_table(Board:GetPath(endpoints[1],endpoints[2],PATH_ROADRUNNER))
	end
	
	for i = 2, #path do
		if Board:IsEdge(path[i]) then
			table.remove(path,i-1)
		else
			break
		end
	end
	
	for i = #path - 1, 2, -1 do
		if Board:IsEdge(path[i]) then
			table.remove(path,i+1)
		else
			break
		end
	end
	
	return path
end

function Environment:FindEndpoints(horizontal)

	local endpoints = {}
	local choices = {}
	local start_x = -1
	
	local second = horizontal ~= nil
	
	horizontal = horizontal or random_bool(2)
	
	for j = 1,2 do
		local choices = {}
		for i = 2,5 do
			local curr = Point(i,7)
			if j == 2 then curr = Point(i,0) end
			
			if horizontal then
				curr = Point(7,i)
				if j == 2 then curr = Point(0,i) end
			end
			
			if self:IsValidTarget(curr) and curr.x ~= start_x then
				choices[#choices+1] = curr
			end
		end
		
		if #choices == 0 then 
		    if not second then 
		    	return self:FindEndpoints(not horizontal)--try the other direction
		    end 
		    
		    return {Point(4,7), Point(3,0)}-- last resort options.
		else
			endpoints[j] = random_removal(choices)
			start_x = endpoints[j].x
		end
	end
	
	--go the other way, but don't start from behind the player
	if random_bool(2) and not horizontal then
		local temp = endpoints[1]
		endpoints[1] = endpoints[2]
		endpoints[2] = temp
	end
	
	return endpoints
end

function Environment:GetCrossPath()

	local endpoints = self:FindEndpoints()
	
	local hash = function(point) return point.x + point.y*10 end
	
	local path = { endpoints[1] }
	local curr = endpoints[1]
	local onPath = { }
	onPath[hash(curr)] = true
	local dead = { }
	local fin = endpoints[2]

	while curr ~= fin do
		local choices = {}
		
		--grab all choices that aren't on the path already and are neighbors
		for dir = DIR_START, DIR_END do
			local n = curr + DIR_VECTORS[dir]
			if self:IsValidTarget(n) and not onPath[hash(n)] then
				choices[#choices+1] = n
			end
		end
		
		if #choices == 0 then
			dead[hash(curr)] = true
			--go back across the path and try other paths
			for i,v in ipairs(path) do
				if v == curr and i ~= 1 and not dead[hash(v)] then
					curr = path[i-1]
				end
			end
			
			if dead[hash(curr)] then
				return path -- return whatever we've got. it failed!
			end
		else
			--grab the best options
			local best = nil
			local closest = 100000
			for i,v in ipairs(choices) do
			    local dist = v:Manhattan(fin)
			    
			    if (v.y == 7 or v.y == 0) and fin ~= v then
			        dist = dist + 0.5--discourage edges
			    end
			    
				if  dist < closest then
					best = { v }
					closest =  dist
				elseif dist == closest then
					best[#best+1] = v
				end
			end
			
			curr = random_element(best)
			onPath[hash(curr)] = true
			path[#path+1] = curr
		end
	end
	
	return path
end

