
Mission_Lightning = Mission_Auto:new{ 
	Environment = "Env_Lightning",
	UseBonus = true
}

function Mission_Lightning:StartMission()
	Board:StopWeather()
end

Env_Lightning = Env_Attack:new{
	Image = "env_lightning",
	Name = "Lightning Storm",
	Text = "Lightning will strike four spaces every turn, killing any unit on the marked tiles.",
	StratText = "LIGHTNING STORM",
	CombatIcon = "combat/tile_icon/tile_lightning.png",
	CombatName = "LIGHTNING",
	--DidVoice = false,
}

function Env_Lightning:MarkSpace(space, active)
	Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255,226,88,0.75))
	Board:MarkSpaceDesc(space,"lightning")
	
	if active then
		Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255,150,150,0.75))
	end
end

function Env_Lightning:GetAttackEffect(location)
	
	local effect = SkillEffect()
	
	--if not self.DidVoice then
		--effect:AddVoice("Mission_Lightning_Strike", -1)
		--effect:AddDelay(1)
	--	self.DidVoice = true
	--end
	
	local damage = SpaceDamage(location, DAMAGE_DEATH)
	damage.sAnimation = "LightningBolt"..random_int(2)
	
	local rain = location - Point(1,1)
	local script = "Board:SetWeather(3,"..RAIN_NORMAL..","..rain:GetString()..",Point(2,2),2)"
	effect:AddScript(script)
	effect:AddSound("/props/lightning_strike")
	
	effect:AddDelay(1)
	
	effect:AddDamage(damage)
	
	return effect
end

function Env_Lightning:SelectSpaces()

	local ret = {}
	
	local quarters = self:GetQuarters()
	
	for i,v in ipairs(quarters) do
		ret[#ret+1] = random_element(v)
	end
	
	return ret
end
