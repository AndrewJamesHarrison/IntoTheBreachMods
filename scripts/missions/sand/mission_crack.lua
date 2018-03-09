
Mission_Crack = Mission_Infinite:new{ 
	UseBonus = true,
	BonusPool = {BONUS_GRID, BONUS_MECHS, BONUS_KILL_FIVE}, -- Took out BONUS_BLOCK because it's hard in combination with environment
	Environment = "Env_Seismic"
}

Env_Seismic = Env_Attack:new{
	Name = "Seismic Activity",
	Text = "Marked squares will sink into the earth, killing anything on them.",
	StratText = "SEISMIC ACTIVITY",
	CombatIcon = "combat/tile_icon/tile_crack.png",
	CombatName = "CATACLYSM",
	Path = nil,
	Index = 1,
	Ordered = true,
	WaterTarget = true,
	FirstTile = nil
}

function Env_Seismic:MarkSpace(space, active)
	Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255,226,88,0.75))
	Board:MarkSpaceDesc(space,"seismic")
	
	--LOG(save_table(self))
	
	if active then
		Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255,150,150,0.75))
	end
end

function Env_Seismic:Start()
	Env_Attack.Start(self)
	self.Path = self:GetCrossPath()
end

function Env_Seismic:GetAttackEffect(location)
	
	local effect = SkillEffect()
	local damage = SpaceDamage(location)
	damage.iTerrain = TERRAIN_HOLE
	effect:AddDelay(0.5)
	effect:AddSound("/props/ground_break_tile")
	effect:AddBoardShake(0.5)
	effect:AddDamage(damage)
	
	return effect
end

function Env_Seismic:SelectSpaces()

	local ret = {}
	
	if self.Path == nil then return end
	
	for i = 1, 3 do
		if self.Index > #self.Path then
			return ret
		end
		
		if i == 1 then
			self.FirstTile = self.Path[self.Index]
		end
		
		ret[i] = self.Path[self.Index]
		self.Index = self.Index + 1
		
		Board:BlockSpawn(ret[i],BLOCKED_PERM)--can't have units spawn on doomed tiles
	end
	
	return ret
end

