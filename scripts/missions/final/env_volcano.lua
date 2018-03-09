
local ENV_ROCKS = 1
local ENV_LAVA = 2

Env_Volcano = Env_Attack:new{
	Image = "env_lightning",
	Name = "Volcano",
	Text = "Watch out for the active volcano!",
	StratText = "",
	CombatIcon = "combat/tile_icon/tile_fireball.png", --used at the top of the screen
	RockIcon = "combat/tile_icon/tile_fireball.png",
	LavaIcon = "combat/tile_icon/tile_lava.png",
	CombatName = "VOLCANO",
	LavaStart = nil,
	Ordered = true,
	Mode = ENV_ROCKS,
	WaterTarget = false,
	Phase = 0,
}

function Env_Volcano:Start()
	Env_Attack.Start(self)
	self.LavaStart = self.LavaStart or {Point(2,1), Point(1,2)}
end

function Env_Volcano:MarkSpace(space, active)
	local icon = self.RockIcon
	local tooltip = "flying_rock"
	if self.Mode == ENV_LAVA then
		icon = self.LavaIcon
		tooltip = "volcano_lava"
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

function Env_Volcano:SelectSpaces()
	self.Phase = self.Phase + 1
	if self.Phase > 4 then
		self.Phase = 1
	end
	
	if self.Mode == ENV_ROCKS then
		self.Mode = ENV_LAVA
	else
		self.Mode = ENV_ROCKS
	end
		
	local ret = {}
		
	if self.Phase == 1 or self.Phase == 3 then
		local curr = random_removal(self.LavaStart)
		ret[1] = curr
		for i = 1, 3 do
			local dirs = {DIR_RIGHT,DIR_DOWN}
			local choices = {}
			for j,v in ipairs(dirs) do
				local choice = curr + DIR_VECTORS[v]
				if not Board:IsTerrain(choice,TERRAIN_LAVA) and not Board:IsTerrain(choice,TERRAIN_MOUNTAIN) and not Board:IsTerrain(choice,TERRAIN_BUILDING) then
					choices[#choices+1] = choice
				end
			end
			
			if #choices == 0 then
				break
			end
			
			curr = random_removal(choices)
			ret[#ret+1] = curr
		end
	elseif self.Phase == 2 or self.Phase == 4 then
		local quarters = self:GetQuarters()
		for i,v in ipairs(quarters) do
			local choice = Point(1,1)
			while choice == Point(1,1) do
				choice = random_element(v)
			end
			
			ret[#ret+1] = choice 
		end
	end
	
	return ret
end

function Env_Volcano:GetAttackEffect(location, effect)
	local effect = effect or SkillEffect()
	
	if self.Mode == ENV_ROCKS then
		effect.piOrigin = Point(0,0)
		effect:AddSound("/weapons/fireball")
		local damage = SpaceDamage(location, DAMAGE_DEATH)
		damage.iFire = 1
		damage.sAnimation = "explo_fire1"
		effect:AddArtillery(damage,"effects/shotup_fireball.png")
	else
		local damage = SpaceDamage(location, 0)
		damage.iTerrain = TERRAIN_LAVA
		effect:AddSound("/props/lava_tile")
		effect:AddDamage(damage)
	end
	
	return effect
end