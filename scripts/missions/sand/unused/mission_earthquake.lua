
Mission_Earthquake = Mission_Infinite:new{
	UseBonus = true,
	Environment = "Env_Sliding"
}

Env_Sliding = Environment:new{
	Name = "Earthquake Fractures",
	Text = "The land will slide around.",
	StratText = "EARTHQUAKES",
	Direction = 1,
}

function Env_Sliding:Start()
    for y = 0, 7 do
		Board:BlockSpawn(Point(7,y),BLOCKED_PERM)--can't have units spawn on the edge
	end
end

function Env_Sliding:IsEffect()
	return true
end

function Env_Sliding:ApplyEffect()
		
	local effect = SkillEffect()
	
	for x = 0, 7 do
		if x % 2 == 0 then
			effect:AddBoardShake(0.5)
			local start = (self.Direction == 1) and 7 or 0
			if Board:GetTerrain(Point(x,start)) ~= TERRAIN_HOLE then
				local damage = SpaceDamage(Point(x,start))
				damage.iTerrain = TERRAIN_HOLE
				damage.fDelay = 0.75
				effect:AddDamage(damage)
			else
				effect:AddDelay(0.25)
			end
			
			effect:AddScript("Board:ShiftColumn("..x..","..self.Direction..")")
			effect:AddDelay(0.5)
		end
	end
	
    Board:AddEffect(effect)	
	
	self.Direction = (self.Direction == 1) and -1 or 1
    
    return false--no more to do
end