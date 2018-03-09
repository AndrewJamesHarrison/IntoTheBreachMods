
Mission_Cataclysm = Mission_Infinite:new{ 
	Environment = "Env_Cataclysm",
	MapTags = {"cataclysm"},
	BonusPool = {BONUS_GRID, BONUS_MECHS, BONUS_KILL_FIVE},-- Took out BONUS_BLOCK because it's hard in combination with environment
	SpawnMod = 1,
	TurnLimit = 3
}

Env_Cataclysm = Environment:new{
	Name = "Cataclysmic Earthquakes",
	Text = "Marked tiles will become Chasms at the start of the enemy turn, killing any ground units present.",
	StratText = "CATACLYSM",
	CombatIcon = "combat/tile_icon/tile_crack.png",
	CombatName = "CATACLYSM",
	Index = 0,
	WaterTarget = true,
}

function Env_Cataclysm:MarkBoard()
	local x = 7 - self.Index
	for y = 0, 7 do
		if Board:GetTerrain(Point(x,y)) ~= TERRAIN_HOLE and not Board:IsBuilding(Point(x,y)) then
			Board:MarkSpaceImage(Point(x,y),self.CombatIcon, GL_Color(255,226,88,0.75))
			Board:MarkSpaceDesc(Point(x,y),"seismic")
		end
	end
end

function Env_Cataclysm:Start()
	for y = 0, 7 do
		Board:BlockSpawn(Point(7,y),BLOCKED_PERM)--can't have units spawn on the next set of doomed tiles
	end
end

function Env_Cataclysm:IsEffect()
	return true
end

function Env_Cataclysm:Plan()
	self.Index = self.Index + 1
	Game:TriggerSound("/props/square_lightup")
	return false
end

function Env_Cataclysm:ApplyEffect()
		
	local effect = SkillEffect()
	local damage = SpaceDamage()
	damage.iTerrain = TERRAIN_HOLE
	damage.fDelay = 0.2
	effect:AddBoardShake(1.5)
	effect:AddSound("/props/ground_break_line")
--	effect:AddDamage(damage)
	
	local x = 7 - self.Index
	for y = 0, 7 do
		damage.loc = Point(x,y)
		if not Board:IsBuilding(damage.loc) then
	    	effect:AddDamage(damage)
	    end
		Board:BlockSpawn(Point(x-1,y),BLOCKED_PERM)--can't have units spawn on the next set of doomed tiles
	end

	effect.iOwner = ENV_EFFECT
    Board:AddEffect(effect)	
    
    return false--no more to do
end
