
Mission_Airstrike = Mission_Auto:new{ 
	Environment = "Env_Airstrike",
	BonusPool = {BONUS_GRID, BONUS_MECHS, BONUS_KILL_FIVE}, -- Took out BONUS_BLOCK because it's hard in combination with environment
	UseBonus = true
}

Env_Airstrike = Env_Attack:new{
	Image = "env_airstrike",
	Name = "Air Support",
	Text = "Bombs will be dropped on the marked spaces, killing any unit.",
	StratText = "AIR SUPPORT",
	CombatIcon = "combat/tile_icon/tile_airstrike.png",
	CombatName = "AIR SUPPORT",
	Damage = DAMAGE_DEATH
}

function Env_Airstrike:GetAttackArea(space)
	local ret = { space }
	for dir = DIR_START, DIR_END do
		ret[#ret+1] = space + DIR_VECTORS[dir]
	end

	return ret
end

function Env_Airstrike:MarkSpace(space, active)
	local spaces = self:GetAttackArea(space)
	
	for i,v in ipairs(spaces) do
		Board:MarkSpaceImage(v,self.CombatIcon, GL_Color(255,226,88,0.75))
		Board:MarkSpaceDesc(v,"air_strike")
	
		if active then
			Board:MarkSpaceImage(v,self.CombatIcon, GL_Color(255,150,150,0.75))
		end
	end
end

function Env_Airstrike:GetAttackEffect(location)
	
	local effect = SkillEffect()
	
	--if Game:GetTurnCount() == 1 then
	effect:AddVoice("Mission_Airstrike_Incoming", -1)
		--effect:AddDelay(1)
	--end
	
	effect:AddDelay(0.75)
	effect:AddSound("/props/airstrike")
	effect:AddAirstrike(location,"units/mission/bomber_1.png")
	
	
	local spaces = self:GetAttackArea(location)
	
	local damage = SpaceDamage(Point(0,0), self.Damage)
	damage.sAnimation = "ExploArt2"
	damage.sSound = "/props/airstrike_explosion"
	
	for i,v in ipairs(spaces) do
		damage.loc = v
		effect:AddDamage(damage)
		effect:AddBounce(v,6)
	end
			
	return effect
end

function Env_Airstrike:BlockSpawn(space)
	local spaces = self:GetAttackArea(space)
	
	for i,v in ipairs(spaces) do
		Board:BlockSpawn(v,BLOCKED_TEMP)
	end
end

function Env_Airstrike:IsValidTarget(space)
	return Board:GetTerrain(space) ~= TERRAIN_BUILDING and not Board:IsPod(space)
end

function Env_Airstrike:SelectSpaces()

	local ret = {}
	
	local start = Point(3,1)
	
	local choices = {}
	for i = start.x, (start.x + 2) do
		for j = start.y, (start.y + 5) do
			local spaces = self:GetAttackArea(Point(i,j))
			local valid = true
			for i,v in ipairs(spaces) do
				valid = valid and self:IsValidTarget(v)
			end
			if valid then choices[#choices+1] = Point(i,j) end
		end
	end

	if #choices ~= 0 then 
		ret[1] = random_removal(choices)
	end

	return ret
end