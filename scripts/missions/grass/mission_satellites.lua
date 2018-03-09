
Mission_Satellite = Mission_Infinite:new{
	Count = 2,
	Name = "Satellite Launch",
	MapTags = {"satellite"},
	Objectives = Objective("Defend the Satellite Launches",2),
	Satellites = nil,
	UseBonus = false,
}

function Mission_Satellite:GetSavedCount()
	local savedCount = 0
	if self:IsGone(1) then savedCount = savedCount + 1 end
	if self:IsGone(2) then savedCount = savedCount +1 end
	
	return savedCount
end

function Mission_Satellite:GetCompletedObjectives()
	local savedcount = self:GetSavedCount()
	if savedcount == 1 then
--		self:TriggerMissionEvent("
		return Objective("Defend the Satellite Launches (One Lost)",1,2)
	elseif savedcount == 2 then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

function Mission_Satellite:StartMission()
	self.Satellites = {-1,-1}
	local options = extract_table(Board:GetZone("satellite"))
		
	if #options < self.Count then LOG("ERROR NO VALID SPACE") return end
	
---	LOG("Options "..#options)
	--LOG("STARTING MISSION SATELLITE")
	local rocket = PAWN_FACTORY:CreatePawn("SatelliteRocket")
	self.Satellites[1] = rocket:GetId()
	local choice = random_removal(options)
	Board:SetTerrain(choice, TERRAIN_ROAD)
	Board:SetCustomTile(choice,"square_missilesilo.png")
	Board:AddPawn(rocket,choice)
	rocket:SetPowered(false)
	--LOG("choice = "..choice:GetString())
	
	local choice2 = choice
	while math.abs(choice.x - choice2.x) <= 1 and math.abs(choice.y - choice2.y) <= 1 and #options > 0 do
		--LOG("Choices = "..choice2:GetString().." and "..choice:GetString())
		choice2 = random_removal(options)
	--	LOG("Options remaining "..#options)
	--	LOG("checking "..choice2:GetString())
	end
	
	if math.abs(choice.x - choice2.x) <= 1 and math.abs(choice.y - choice2.y) <= 1 then 
		LOG("ERROR NO VALID SECOND SPACE") 
		return 
	end
		
	rocket = PAWN_FACTORY:CreatePawn("SatelliteRocket")
	self.Satellites[2] = rocket:GetId()
	Board:AddPawn(rocket, choice2)
	Board:SetTerrain(choice2, TERRAIN_ROAD)
	Board:SetCustomTile(choice2,"square_missilesilo.png")
	rocket:SetPowered(false)
end

function Mission_Satellite:NextTurn()
	if Game:GetTurnCount() == 1 and Game:GetTeamTurn() == TEAM_ENEMY and Board:IsPawnAlive(self.Satellites[1]) then
		Board:GetPawn(self.Satellites[1]):SetPowered(true)
	end
	
	if Game:GetTurnCount() == 3 and Game:GetTeamTurn() == TEAM_ENEMY and Board:IsPawnAlive(self.Satellites[2]) then
		Board:GetPawn(self.Satellites[2]):SetPowered(true)
	end
end

function Mission_Satellite:UpdateMission()
	--if Game:GetTurnCount() == 4 and Game:GetTeamTurn() == TEAM_ENEMY then
	--	self.TimesUp = true
	--end

	--if Board:IsPawnAlive(self.Satellites[1]) and Game:GetTurnCount() < 1 then
	--	Board:GetPawn(self.Satellites[1]):SetActive(false)
	--end
	
	--if Board:IsPawnAlive(self.Satellites[2]) and Game:GetTurnCount() < 3 then
	--	Board:GetPawn(self.Satellites[2]):SetActive(false)
	--end
end

function Mission_Satellite:IsDestroyed(id)
	return Board:GetPawn(self.Satellites[id]) ~= nil and not Board:IsPawnAlive(self.Satellites[id])
end

function Mission_Satellite:IsGone(id)
	return Board:GetPawn(self.Satellites[id]) == nil
end

function Mission_Satellite:UpdateObjectives()
	local status1 = self:IsGone(1) and OBJ_COMPLETE or OBJ_STANDARD
	
	if self:IsDestroyed(1) then
		status1 = OBJ_FAILED
	end
	
	local first_text = IsLargeFont() and "Defend the 1st\nsatellite launch" or "Defend the 1st satellite launch" 
	Game:AddObjective(first_text,status1)
	
	local status2 = self:IsGone(2) and OBJ_COMPLETE or OBJ_STANDARD
	
	if self:IsDestroyed(2) then
		status2 = OBJ_FAILED
	end
	
	local sec_text = IsLargeFont() and "Defend the 2nd\nsatellite launch" or "Defend the 2nd satellite launch" 
	Game:AddObjective(sec_text,status2)
			
	local count = 3 - math.max(0,Game:GetTurnCount())
	if status1 ~= OBJ_STANDARD then
		count = 5 - Game:GetTurnCount()
	end
	
	--[[if Game:GetTurnCount() == 0 then return end
	
	if count <= 1 then 
		Game:AddNote("Satellite will launch this turn!") 
	else
		--local turn = " turns"
		--if count == 1 then turn = " turn" end
		Game:AddNote("Satellite getting ready to launch") 
	end]]--
end

SatelliteRocket = 
{
	Name = "Satellite Rocket",
	Image = "missile",
	Health = 2,
	Neutral = true,
	Corpse = true,
	MoveSpeed = 0,
	SkillList = { "Rocket_Launch" }, 
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Pushable = false,
	SpaceColor = false,
	IsPortrait = false,
	SoundLocation = "/support/satellite/"
}
AddPawn("SatelliteRocket") 

Rocket_Launch = SelfTarget:new{  
	Explosion = "",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,2),
		Friendly = Point(3,2),
		Length = 6,
		CustomPawn = "SatelliteRocket"
	}
}

function Rocket_Launch:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	
	local damage = SpaceDamage()
	damage.sScript = "Board:StartShake(1)";
	damage.fDelay = 0.75
	damage.sSound = "/props/satellite_launch"
	ret:AddVoice("Mission_Satellite_Imminent", -1)
	ret:AddQueuedDamage(damage)
	
	for dir = DIR_START, DIR_END do
		local damage = SpaceDamage(p1 + DIR_VECTORS[dir], DAMAGE_DEATH)
		damage.sAnimation = "exploout2_"..dir
		ret:AddQueuedDamage(damage)
	end
	
	local flight = SpaceDamage(p1)
	flight.bHide = true
	flight.sScript = "Board:GetPawn("..p1:GetString().."):SetCustomAnim(\"missile_flying\") "
	flight.sScript = flight.sScript.."Board:GetPawn("..p1:GetString().."):FlyAway()"
	flight.sScript = flight.sScript.."Board:SetCustomTile("..p1:GetString()..",\"square_missilesilo2.png\")"
	ret:AddQueuedDamage(flight)
	--ret:AddQueuedVoice("Mission_Satellite_Launch", -1)
	
	--local kill = SpaceDamage(p1, DAMAGE_DEATH)
	--kill.bHidden = true
	--ret:AddDamage(kill)
	
	return ret
end