
local ENV_ROCKS = 1
local ENV_LAVA = 2

Env_Final = Env_Attack:new{
	Image = "env_lightning",
	Name = "Caverns",
	Text = "Watch out for falling rocks and lava!",
	StratText = "",
	CombatIcon = "combat/tile_icon/tile_rock.png", --used at the top of the screen
	RockIcon = "combat/tile_icon/tile_rock.png",
	LavaIcon = "combat/tile_icon/tile_tentacle.png",
	CombatName = "CAVERNS",
	Ordered = true,
	Mode = ENV_LAVA,
	Phase = 0,
	--NextCrack = 0,
}

function Env_Final:Start()
	Env_Attack.Start(self)
	self.LavaPath = self:GetCrossPath()
end

function Env_Final:MarkSpace(space, active)
	local icon = self.RockIcon
	local tooltip = "falling_rock"
	if self.Mode == ENV_LAVA then
		icon = self.LavaIcon
		tooltip = "tentacle_lava"
	end
	
	local color = GL_Color(255,226,88,0.75)
	if Board:IsTerrain(space,TERRAIN_LAVA) then
		color = GL_Color(40,40,0)
	end
	Board:MarkSpaceImage(space,icon, color)
	Board:MarkSpaceDesc(space,tooltip)
	
	if active then
		Board:MarkSpaceImage(space,icon, GL_Color(255,150,150,0.75))
	end
end

function Env_Final:SelectSpaces()
	self.Phase = self.Phase + 1
	if self.Phase > 4 then
		self.Phase = 1
	end
	
	if self.Mode == ENV_ROCKS then
		self.Mode = ENV_LAVA
	else
		self.Mode = ENV_ROCKS
	end
	
	self.WaterTarget = self.Mode == ENV_ROCKS --rocks can target the water
	
	local ret = {}
		
	if self.Phase == 1 then
		self.Instant = false
		local quarters = self:GetQuarters()
		for i,v in ipairs(quarters) do
			ret[#ret+1] = random_element(v)
		end
		--self.NextCrack = 2
	elseif self.Phase == 2 then
		self.Instant = false
		local pawns = extract_table(Board:GetPawns(TEAM_MECH))
		for i, pawn_id in ipairs(pawns) do
			ret[#ret+1] = Board:GetPawn(pawn_id):GetSpace()
		end
		--self.NextCrack = 2
	elseif self.Phase == 3 then
		self.Instant = true
		local lava = Mission:GetTerrainList(TERRAIN_LAVA)
		local choices = {}
		for i, v in pairs(lava) do
			if v.x > 1 and v.x < 6 and v.y > 1 and v.y < 6 then
				choices[#choices+1] = v
			end
		end
		
		if #choices == 0 then
			choices = { Point(4,4) }
		end
		
		local choice = random_element(choices)
		local final_choices = {}
		ret = {choice}
		for i = DIR_START, DIR_END do
			local neighbors = {choice + DIR_VECTORS[i], choice + DIR_VECTORS[i] + DIR_VECTORS[(i+1)%4]}
			for j,v in ipairs(neighbors) do
				if Board:IsTerrain(v,TERRAIN_LAVA) then
					ret[#ret+1] = v
				elseif not Board:IsBuilding(v) then
					final_choices[#final_choices+1] = v
				end
			end
		end
		
		while #ret < 6 and #final_choices > 0 do
			ret[#ret+1] = random_removal(final_choices)
		end
	--	self.NextCrack = 2
	elseif self.Phase == 4 then
		ret = self:GetCrossingPath()
	--	self.NextCrack = 2
	end	
	
	--never attack the bomb
	for i,v in ipairs(ret) do
		if IsBomb(v) then
			remove_element(v,ret)
			break
		end
	end
	
	---let enemies avoid these environments
	for i,v in ipairs(ret) do
		Board:SetDangerous(v)
	end
	
	return ret
end

function Env_Final:ApplyStart()
	local effect = SkillEffect()
	
	for i = 1, 2 do
		effect:AddScript("Board:Crack(CRACK_TENTACLE)")
	end
	
	effect:AddScript("Board:Crack(CRACK_LAVA)")
		
	if self.Mode == ENV_LAVA then
		effect:AddBoardShake(3)
		--for i = 1, self.NextCrack do
		--	effect:AddScript("Board:Crack(CRACK_TENTACLE)")
		--end
	else
		if self.Phase == 1 then
			effect:AddBoardShake(6)
		else
			effect:AddBoardShake(2)
		end	
	end
		
	Board:AddEffect(effect)
end

function Env_Final:ApplyEnd()
	
end

function Env_Final:GetAttackEffect(location, effect)
	local effect = effect or SkillEffect()
	
	if self.Mode == ENV_ROCKS then
		local damage = SpaceDamage(location, DAMAGE_DEATH)
		damage.iTerrain = TERRAIN_ROAD
		--if self.NextCrack > 0 then
			--damage.sScript = "Board:Crack(CRACK_LAVA)"
			--self.NextCrack = self.NextCrack - 1
		--end
		effect:AddDropper(damage,"effects/shotdown_rock.png")
	else
		effect:AddSound("/props/ground_break_tile")
		local damage = SpaceDamage(location, DAMAGE_DEATH)
		damage.sAnimation = "tentacles"
		damage.iTerrain = TERRAIN_LAVA
		damage.sSound = "/props/tentacle"
		effect:AddDamage(damage)
	end
	
	return effect
end

function IsBomb(point)
	if point ~= nil then
		return Board:IsPawnSpace(point) and Board:GetPawn(point):GetType() == "BigBomb"
	else
		local pawns = extract_table(Board:GetPawns(TEAM_PLAYER))
		local bomb = false
		for i, v in ipairs(pawns) do
			if Board:GetPawn(v):GetType() == "BigBomb" then
				bomb = true
			end
		end

		return bomb
	end
end