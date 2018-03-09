
Mission_SnowStorm = Mission_Infinite:new{
	SpawnStartMod = 1,
	Environment = "Env_SnowStorm",
}

function Mission_SnowStorm:StartMission()
	Board:StopWeather()
end

Env_SnowStorm = Env_Attack:new{
	Name = "Ice Storm",
	Text = "Marked tiles will be frozen at the start of the enemy turn.",
	StratText = "ICE STORM",
	CombatIcon = "combat/tile_icon/tile_snowstorm.png",
	CombatName = "ICE STORM",
	LastLoc = nil,
	Options = nil,
	Instant = true
}

function Env_SnowStorm:MarkSpace(space, active)
	Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255, 180, 0 ,0.75))
	Board:MarkSpaceDesc(space,"ice_storm")
	
	if active then
		Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255, 180, 0 ,0.75))
	end
end

function Env_SnowStorm:ApplyEffect()
	
	local effect = SkillEffect()
	local damage = SpaceDamage(Point(0,0), 0)
	damage.sAnimation = ""
	damage.iFrozen = 1
	
	local loc = self.LastLoc + Point(-1,-1)
	local script = "Board:SetWeather(5,"..RAIN_SNOW..","..loc:GetString()..",Point(3,3),2)"
	effect:AddScript(script)
	effect:AddSound("/props/snow_storm")
	effect:AddDelay(1)
	for i,v in ipairs(self.Locations) do
		damage.loc = v
		effect:AddDamage(damage)
	end
	effect.iOwner = ENV_EFFECT
	Board:AddEffect(effect)
	self.CurrentAttack = self.Locations
	self.Locations = {}
	
	return false
end

function Env_SnowStorm:SelectSpaces()

	if self.Options == nil or #self.Options == 0 then
		self.Options = { Point(3,2), Point(3,5), Point(2,3), Point(5,3)}
	end
	
	self.LastLoc = random_removal(self.Options)
		
	local ret = {self.LastLoc}
	for i = DIR_START, DIR_END do
		ret[#ret+1] = self.LastLoc + DIR_VECTORS[i]
		ret[#ret+1] = self.LastLoc + DIR_VECTORS[i] + DIR_VECTORS[(i+1)%4]
	end
		
	return ret
end
