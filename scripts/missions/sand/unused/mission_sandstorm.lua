
Mission_Sandstorm = Mission_Infinite:new{
	Environment = "Env_Sandstorm",
	UseBonus = true,
}

Env_Sandstorm = Environment:new{
	Name = "Sandstorm",
	Text = "All DUNES will turn to SMOKE, all SMOKE will be removed.",
	StratText = "SANDSTORM DETECTED",
	Row = 7
}

function Env_Sandstorm:Start()

	for i = 0,7 do
		for j = 0,7 do
			local curr = Point(i,j)
			if Board:GetTerrain(curr) == TERRAIN_SAND then
				Board:SetTerrain(curr,TERRAIN_ROAD)
			end
		end
	end
	
	Board:RandomizeTerrain(TERRAIN_SAND,12)
end

function Env_Sandstorm:IsEffect()
	return true
end

function Env_Sandstorm:ApplyEffect()
	local choices = {}
	local sand = {}
	
	local effect = SkillEffect()
	effect:AddBoardShake(1)
	
	for i = 0, 1 do
		local smoke = {}
		for j = 0, 7 do
		    local curr = Point(self.Row, j)
			local damage = SpaceDamage(curr)
			damage.iSmoke = EFFECT_CREATE
			if Board:GetTerrain(curr) == TERRAIN_SAND then
				damage.iTerrain = TERRAIN_ROAD
			end
			effect:AddDamage(damage)
			
			if self.Row < 7 then
				curr = Point(self.Row + 1, j)
                local damage = SpaceDamage(curr)
                damage.iSmoke = EFFECT_REMOVE
                if Board:GetTerrain(curr) == TERRAIN_ROAD or Board:GetTerrain(curr) == TERRAIN_WATER then
                    damage.iTerrain = TERRAIN_SAND
                end
                effect:AddDamage(damage)
			end
		end
				
		effect:AddDelay(1)
		
		self.Row = self.Row - 1
	end
		
	Board:AddEffect(effect)
		
	return false
end
