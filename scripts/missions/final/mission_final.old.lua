local FAST_VERSION = true --debug purposes
local PHASE_TWO = 3

Mission_Final = Mission_Infinite:new{
	MapTags = { "final" },
	SpawnStart = 0,
	SpawnsPerTurn = 0,
	SpawnsPerTurn_Easy = -1,
	Environment = "Env_Final",
	TurnLimit = 10,
	SupplyDrop = nil
}

Env_Final = Env_Attack:new{
	Image = "env_lightning",
	Name = "Caverns",
	Text = "Watch out for Vek Eggs, falling rocks, and lava!",
	StratText = "",
	CombatIcon = "combat/tile_icon/tile_lightning.png",
	CombatName = "CAVERNS",
	Ordered = true,
	LavaPath = nil
}

function Env_Final:Hash()


end

function Env_Final:Start()
	Env_Attack.Start(self)
	self.LavaPath = self:GetCrossPath()
end

function Env_Final:MarkSpace(space, active)
	Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255,226,88,0.75))
	Board:MarkSpaceDesc(space,"falling_rock")
	
	if active then
		Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255,150,150,0.75))
	end
end

function Env_Final:SelectSpaces()
	local ret = {}
	if Game:GetTurnCount() < PHASE_TWO then
		return ret
	end
	
	local quarters = self:GetQuarters()
	for i,v in ipairs(quarters) do
		ret[#ret+1] = random_element(v)
	end
	return ret
end

function Env_Final:GetAttackEffect(location)
	local effect = SkillEffect()
	local damage = SpaceDamage(location, DAMAGE_DEATH)
	effect:AddDropper(damage,"effects/shotdown_rock.png")
	
	return effect
end


local egg_list = { "Beetle", "Firefly", "Hornet", "Scarab" }

local function SpawnPawns(effect,zone)
	for i,v in ipairs(zone) do
		effect:AddScript("Board:GetPawn("..(i-1).."):SetSpace("..v:GetString()..") Board:GetPawn("..(i-1).."):SpawnAnimation()")
		effect:AddDelay(0.5)
	end
end

function Mission_Final:StartMission()
	local effect = SkillEffect()
	
	local drop_zone = extract_table(Board:GetZone("deployment"))
	local pylons = extract_table(Board:GetZone("pylons"))
	
	--island, not underground
	if #pylons == 0 then
        
        if FAST_VERSION then return end
        
		SpawnPawns(effect,drop_zone)
		effect:AddVoice("MissionFinal_Start",PAWN_ID_CEO)
	    effect:AddDelay(2.5)
	    effect:AddBoardShake(4)
		effect:AddDelay(1.5)
		effect:AddVoice("MissionFinal_Response",random_int(0,3))
		
		fall_zone = extract_table(Board:GetZone("falling"))
		while #fall_zone > 0 do
			effect:AddBounce(random_removal(fall_zone),100)
			effect:AddDelay(0.1)
		end
		
		effect:AddDelay(0.5)
		
		while #drop_zone > 0 do
			effect:AddBounce(random_removal(drop_zone),100)
			effect:AddDelay(0.1)
		end
		
		effect:AddDelay(1)
		effect:AddScript("Board:Fade(FADE_OUT)")
	else
		for i = 1, 2 do
			local egg = Board:AddPawn("FinalEgg_"..self:NextPawn(egg_list,true),"eggs")
			Board:GetPawn(egg):FireWeapon(egg,1)
		end
		
		for i = 1, 2 do
			Board:AddPawn("EggLayer","layer")
		end
		
		--self:UpdateEggs()
				
		effect:AddBoardShake(3)
		local mounts = extract_table(Board:GetZone("mountain"))
		local mountain = SpaceDamage(Point(0,0),DAMAGE_DEATH)
		mountain.iTerrain = TERRAIN_MOUNTAIN
		while #mounts > 0 do
			mountain.loc = random_removal(mounts)
			effect:AddDropper(mountain,"combat/tiles_lava/mountain_0.png")
			effect:AddDelay(0.2)
		end
		
		SpawnPawns(effect,drop_zone)
		
		effect:AddDelay(1)
		
		if not FAST_VERSION then
		    effect:AddVoice("MissionFinal_Pylons",random_int(0,3))
		    effect:AddVoice("MissionFinal_PylonsResponse",PAWN_ID_CEO)
		    effect:AddDelay(7)
		end
		
		local building = SpaceDamage(Point(0,0),DAMAGE_DEATH)
		building.iTerrain = TERRAIN_BUILDING
		while #pylons > 0 do
			building.loc = random_removal(pylons)
			effect:AddDropper(building,"effects/pylon.png")
			if not FAST_VERSION then
			    effect:AddDelay(0.5)
			end
		end
	end
	
	Board:AddEffect(effect)
end

function Mission_Final:NextTurn()
	if Game:GetTurnCount() == PHASE_TWO + 1 then
		self:AddSupplyDrop()
	end
end

function Mission_Final:IsEndBlocked()
	return true
end

function Mission_Final:AddSupplyDrop()
	local choices = {}
	for i = 1,6 do
		for j = 1,6 do
			if not Board:IsBlocked(Point(i,j),PATH_GROUND) then
				choices[#choices+1] = Point(i,j)
			end
		end
	end
	
	if #choices == 0 then LOG("Couldn't drop supplies\n") return end
	
	local drop = SpaceDamage(random_element(choices), 0)
	self.SupplyDrop = drop.loc
	drop.sItem = "Supply_Drop"
	local effect = SkillEffect()
	effect:AddDropper(drop, "combat/pod/pod_air.png")
	Board:AddEffect(effect)
end

function Mission_Final:ActivateSupply()
    if Board:IsPawnTeam(self.SupplyDrop, TEAM_PLAYER) then
	    --Board:AddAlert(self.SupplyDrop, "combat/icons/warn_pod_secured.png")
		local pawns = extract_table(Board:GetPawns(TEAM_PLAYER))
		local effect = SkillEffect()
		for i, pawn_id in ipairs(pawns) do
		    Board:GetPawn(pawn_id):ResetUses()
			effect:AddDamage(SpaceDamage(Board:GetPawnSpace(pawn_id),-10))
		end
		Board:AddEffect(effect)
	else
		Board:AddAlert(self.SupplyDrop, "combat/icons/pod_destroyed.png")
	end
	
	self.SupplyDrop = nil
end

function Mission_Final:UpdateMission()
	if Game:GetTurnCount() >= PHASE_TWO then
		self.SpawnsPerTurn = Mission_Infinite.SpawnsPerTurn
		self.SpawnsPerTurn_Easy = Mission_Infinite.SpawnsPerTurn_Easy
	end
	
	if self.SupplyDrop ~= nil and not Board:IsBusy() and not Board:IsItem(self.SupplyDrop) then
		self:ActivateSupply()
	end
end


ANIMS.final_egg = ANIMS.BaseUnit:new{ Image = "units/aliens/barnicle_1.png", PosX = -14, PosY = 6 }
ANIMS.final_egg_hatching = ANIMS.BaseUnit:new{ Image = "units/aliens/barnicle_f_1.png", PosX = -18, PosY = 6 }

for i,pawn in ipairs(egg_list) do

	for j = 1, 2 do
		local egg = Pawn:new{
			Health = 2,
			MoveSpeed = 0,
			Name = "Vek Egg",
			Minor = true,
			Image = "final_egg",
			SkillList = {"FinalEggHatch_"..pawn..j},
			DefaultTeam = TEAM_ENEMY,
			Explodes = true,
			ImpactMaterial = IMPACT_FLESH
		}
		
		local weapon = SelfTarget:new{}

        weapon.GetTargetScore = function(self,p1,p2) return 10 end
        
		weapon.GetSkillEffect = function(self,p1,p2)
			local ret = SkillEffect()
		--	ret:AddScript("Board:GetPawn("..p1:GetString().."):SetCustomAnim(\"final_egg_hatching\")")
			local damage = SpaceDamage(p1,0)
			damage.sPawn = pawn..j
			ret:AddQueuedScript("Board:RemovePawn("..p1:GetString()..")")
			ret:AddQueuedDamage(damage)
			return ret
		end
		
		_G["FinalEgg_"..pawn..j] = egg
		_G["FinalEggHatch_"..pawn..j] = weapon
	end

end

EggLayer = Pawn:new{
	Health = 5,
	Name = "Egg Layer",
	Image = "egglayer",
	MoveSpeed = 0,
	DefaultTeam = TEAM_ENEMY,
	SkillList = {"EggLayer_Atk"},
	ImpactMaterial = IMPACT_INSECT,
	SoundLocation = "/enemy/burrower_2/",
	Pushable = false,
	Armor = true
}

ANIMS.egglayer = ANIMS.BaseUnit:new{ Image = "units/aliens/burrower_1.png", PosX = -23, PosY = -3 }
ANIMS.egglayera = ANIMS.BaseUnit:new{ Image = "units/aliens/burrower_1a.png", PosX = -23, PosY = -3, NumFrames = 4 }
ANIMS.egglayere = ANIMS.BaseEmerge:new{ Image = "units/aliens/burrower_1_emerge.png", PosX = -23, PosY = -8 }
ANIMS.egglayerd = ANIMS.BaseUnit:new{ Image = "units/aliens/burrower_1_death.png", PosX = -28, PosY = -6, NumFrames = 8, Time = 0.14, Loop = false  }

EggLayer_Atk = SelfTarget:new{
	Name = "Lay Egg",
	Description = "Deposit a single Vek Egg.",
	Damage = 1,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		CustomPawn = "EggLayer"
	}
}

function EggLayer_Atk:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	local choices = {}
	for i = 1, 6 do
		for j = 1, 6 do
			if not Board:IsBlocked(Point(i,j),PATH_GROUND) then
				choices[#choices+1] = Point(i,j)
			end
		end
	end
	
	for i = 1,2 do
		if #choices == 0 then break end
		local damage = SpaceDamage(random_removal(choices),0)
		damage.sPawn = "FinalEgg_"..random_element(egg_list).."1"
		
		if i == 1 and #choices >= 1 then
			ret:AddArtillery(damage,"effects/vek_egg.png",NO_DELAY)
		else
			ret:AddArtillery(damage,"effects/vek_egg.png")
		end
	end
	
	return ret
end

