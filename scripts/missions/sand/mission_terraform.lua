
Mission_Terraform = Mission_Infinite:new{ 
	MapTags = { "terraformer" },
	Objectives = { Objective("Defend the Terraformer",1), Objective("Terraform the grassland back to desert", 1),  }, 
	TerraformerId = -1,
	TerraformComplete = false,
	SpawnMod = 1,
	UseBonus = false,
}

function Mission_Terraform:IsEndBlocked()
	return not self.TerraformComplete and Board:IsPawnAlive(self.TerraformerId)
end

function Mission_Terraform:NextTurn()
	if Game:GetTurnCount() == 1 and Game:GetTeamTurn() == TEAM_PLAYER then
		Game:AddTutorial("Tutorial_Terraform",Board:GetPawnSpace(self.TerraformerId))
	end
end

function Mission_Terraform:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	
	if not Board:IsPawnAlive(self.TerraformerId) then
		ret[1] = ret[1]:Failed()
	end
	
	if not self.TerraformComplete then
		ret[2] = ret[2]:Failed()
	end
	
	return ret
end

function Mission_Terraform:UpdateObjectives()
	local terraformAlive = Board:IsPawnAlive(self.TerraformerId) and OBJ_STANDARD or OBJ_FAILED
	local terraformStatus = self.TerraformComplete and OBJ_COMPLETE or OBJ_STANDARD
	
	if terraformAlive == OBJ_FAILED and terraformStatus == OBJ_STANDARD then
		terraformStatus = OBJ_FAILED
	end
	
	--if terraformAlive == OBJ_FAILED then
	--	self:TriggerMissionEvent("Destroyed")
	--end
	
	Game:AddObjective("Defend the Terraformer", terraformAlive)	
	Game:AddObjective("Terraform the grassland back to desert", terraformStatus)	
end

--used for briefing messages
function Mission_Terraform:GetCompletedStatus()
	if not Board:IsPawnAlive(self.TerraformerId) then 
		return "Failure"
	elseif not self.TerraformComplete then
		return "Incomplete"
	else
		return "Success"
	end
end

function Mission_Terraform:StartMission()
	local terraformer = PAWN_FACTORY:CreatePawn("Terraformer")
	self.TerraformerId = terraformer:GetId()
	Board:AddPawn(terraformer,"terraformer")
	Board:SetTerrain(terraformer:GetSpace(),TERRAIN_ROAD)--make sure it's not on sand or something weird
end

function Mission_Terraform:UpdateMission()

	local grassFound = false
	
	if not self.TerraformComplete then 
		local grass = Board:GetZone("grass")
		for i = 1, grass:size() do
			if Board:GetCustomTile(grass:index(i)) == "ground_grass.png" then
				grassFound = true
				Board:MarkSpaceDesc(grass:index(i), "grassland")
			else
				Board:MarkSpaceDesc(grass:index(i), "terraformed")
			end
		end
	end

	if not grassFound then
		self.TerraformComplete = true
	end
end

Terraformer = 
{
	Name = "Terraformer",
	Image = "terraformer3",
	Health = 2,
	MoveSpeed = 0,
	SkillList = { "Terraformer_Attack" }, 
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SoundLocation = "/support/terraformer",
	Pushable = false,
	Corporate = true,
	PilotDesc = "RST Corp \nTerraformer",
}
AddPawn("Terraformer") 

Terraformer_Attack = Skill:new{  
	Range = 1,
	PathSize = 1,
	Explosion = "",
	Icon = "weapons/structure_terraform.png",	
	Class = "Unique",
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,2),
		Enemy = Point(2,1),
		Enemy2 = Point(3,2),
		Mountain = Point(1,2),
		Forest = Point(1,1),
		Forest2 = Point(3,1),
		Forest3 = Point(2,2),
		CustomPawn = "Terraformer"
	}
}
				
function Terraformer_Attack:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
		
	ret:AddSound("/support/terraformer/attack_first")
	ret:AddBoardShake(1.5)
	ret:AddDelay(0.5)
	
	for i = 0, 1 do
		local current = p2 + DIR_VECTORS[direction]*i + DIR_VECTORS[(direction+1)%4]
		local change = DIR_VECTORS[(direction-1)%4]

       -- if i == 0 then
      --      ret:AddSound("/support/terraformer/attack_first")
       -- else
		ret:AddSound("/support/terraformer/attack_wave")
      --  end

		for j = 0, 2 do
			local damage = SpaceDamage(current,DAMAGE_DEATH)
			damage.iSmoke = EFFECT_REMOVE
			damage.iFire = EFFECT_REMOVE
			
			if Board:GetTerrain(current) ~= TERRAIN_MOUNTAIN then
				damage.iTerrain = TERRAIN_SAND
			end
			
			damage.sScript = "Board:SetCustomTile("..current:GetString()..",\"\")"
			ret:AddDamage(damage)
			ret:AddBounce(current,-6)
			--damage.iDamage = 0
			
			--ret:AddDamage(damage)
			
			current = current + change
		end
		ret:AddDelay(0.5)
	end
	
	--if Game:GetTurnCount() == 1 then
		--ret:AddVoice("Mission_Terraform_FirstTerraform", -1)
	--end
	
	return ret
end

