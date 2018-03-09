

Mission_Tides = Mission_Infinite:new{ 
	UseBonus = true,
	Environment = "Env_Tides",
	Ambience = "/ambience/amb_grass_ocean",
	BonusPool = {BONUS_GRID, BONUS_MECHS, BONUS_KILL_FIVE}, -- Took out BONUS_BLOCK because it's hard in combination with environment
	MapTags = {"tide"},
	SpawnMod = 1,
	TurnLimit = 3
}

Env_Tides = Environment:new{
	Name = "High Tides",
	Text = "Marked tiles will turn to water at the start of the enemy turn.",
	StratText = "TIDAL WAVES",
	CombatIcon = "combat/tile_icon/tile_hightide.png",
	CombatName = "TIDES",
	Index = 1,
	Planned = true,
}

function Env_Tides:Start()
    for x = 0, 7 do
		Board:BlockSpawn(Point(x,1),BLOCKED_PERM)--can't have units spawn on the next set of doomed tiles
	end
end

function Env_Tides:IsEffect()
	return true
end

--this is ugly repeating code but i'm too lazy to properly manage a list of intended points generated in Plan()
function Env_Tides:MarkBoard()
	local building = {}
	if not self.Planned then
		return
	end
	
	for y = 0, self.Index do
		for x = 0, 7 do
			if Board:IsBuilding(Point(x,y)) then
				building[x] = y
			elseif building[x] ~= nil and building[x] < y then
				--do nothing
			else
				if y == self.Index and Board:GetTerrain(Point(x,y)) ~= TERRAIN_WATER then
					Board:MarkSpaceImage(Point(x,y),self.CombatIcon, GL_Color(255,226,88,0.75))
					Board:MarkSpaceDesc(Point(x,y), "high_tide")
				end
			end
		end
	end
end

function Env_Tides:Plan()
	self.Index = self.Index + 1
	self.Planned = true
	for x = 0, 7 do
	    Board:BlockSpawn(Point(x,self.Index),BLOCKED_PERM)--can't have units spawn on the next set of doomed tiles
	end
	
	return false
end

function Env_Tides:ApplyEffect()
		
	local effect = SkillEffect()
	--damage.fDelay = 0.2
	--effect:AddBoardShake(1.5)
	
	--local y = self.Index
	local building = {}
	for y = 0, self.Index do
		if y == self.Index then
			effect:AddSound("/props/tide_flood_last")
		else
			effect:AddSound("/props/tide_flood")
		end
		
		for x = 0, 7 do
			if Board:IsBuilding(Point(x,y)) then
				building[x] = y
			elseif building[x] ~= nil and building[x] < y then
				--do nothing
			else
				local floodAnim = SpaceDamage(Point(x,y))
				if y == self.Index then
					floodAnim.iTerrain = TERRAIN_WATER
					
					if Board:GetTerrain(Point(x,y)) == TERRAIN_MOUNTAIN then
						floodAnim.iDamage = DAMAGE_DEATH
					end
					
				end
				--floodAnim.fDelay = 0.4
				effect:AddDamage(floodAnim)
				effect:AddBounce(floodAnim.loc,-6)
			end
		end
		effect:AddDelay(0.2)
	end
    
	effect.iOwner = ENV_EFFECT
    Board:AddEffect(effect)	
    
	self.Planned = false
    return false--no more to do
end