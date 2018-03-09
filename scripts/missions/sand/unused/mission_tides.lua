

Mission_Tides = Mission_Infinite:new{ 
	UseBonus = true,
	BonusPool = {BONUS_GRID, BONUS_MECHS, BONUS_KILL_FIVE},
	Environment = "Env_Tides",
	MapTags = {"tide"},
	SpawnMod = 1,
	TurnLimit = 3
}

Env_Tides = Environment:new{
	Name = "High Tides",
	Text = "Water will spread from the coast every turn.",
	StratText = "TIDAL WAVES",
	Index = 1,
}

function Env_Tides:Start()
    for x = 0, 7 do
		Board:BlockSpawn(Point(x,1),BLOCKED_PERM)--can't have units spawn on the next set of doomed tiles
	end
end

function Env_Tides:IsEffect()
	return true
end

function Env_Tides:ApplyEffect()
		
	local effect = SkillEffect()
	--damage.fDelay = 0.2
	--effect:AddBoardShake(1.5)
	
	--local y = self.Index
	local building = {}
	for y = 0, self.Index do
		for x = 0, 7 do
			if Board:IsBuilding(Point(x,y)) then
				building[x] = y
			elseif building[x] ~= nil and building[x] < y then
				--do nothing
			else
				local floodAnim = SpaceDamage(Point(x,y))
				if y == self.Index then
					floodAnim.iTerrain = TERRAIN_WATER
				end
				--floodAnim.fDelay = 0.4
				--floodAnim.sScript = "Board:Bounce(Point("..floodAnim.loc.x..","..floodAnim.loc.y.."),-6,0.6)"
				effect:AddDamage(floodAnim)
				effect:AddBounce(floodAnim.loc,-6)
			end
		end
		effect:AddDelay(0.2)
	end
	
	self.Index = self.Index + 1
	
	for x = 0, 7 do
	    Board:BlockSpawn(Point(x,self.Index),BLOCKED_PERM)--can't have units spawn on the next set of doomed tiles
	end
    
	effect.iOwner = ENV_EFFECT
    Board:AddEffect(effect)	
    
    return false--no more to do
end