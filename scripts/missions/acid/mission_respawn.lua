
Mission_Respawn = Mission:new{
	SpawnStart = 0,
	Enemies = nil,
	UseBonus = true,
}

function Mission_Respawn:StartMission()
	for i = 1,3 do
		Board:SpawnPawn(self:NextPawn())
	end
end

function Mission_Respawn:UpdateMission()
	if Board:IsBusy() then return end

    self.Enemies = self.Enemies or {}
	local pawns = extract_table(Board:GetPawns(TEAM_ENEMY))
	
	for i, pawn_id in ipairs(pawns) do
		if Board:IsPawnAlive(pawn_id) then
			if self.Enemies[pawn_id] == nil then
				self.Enemies[pawn_id] = {id = pawn_id, name = Board:GetPawn(pawn_id):GetType()}
				Board:GetPawn(pawn_id):SetActive(true)
			end
			
			self.Enemies[pawn_id].space = Board:GetPawn(pawn_id):GetSpace()
		end
	end
end

function Mission_Respawn:NextTurn()
	if Game:GetTeamTurn() == TEAM_ENEMY then
		for id, enemy in pairs(self.Enemies) do
			if not Board:IsPawnAlive(enemy.id) then
				if enemy.space == nil or Board:IsBlocked(enemy.space, PATH_GROUND) then
					enemy.space = nil
					local zone = extract_table(Board:GetZone("enemy"))
					while #zone > 0 and enemy.space == nil do
						enemy.space = random_removal(zone)
						if Board:IsBlocked(enemy.space, PATH_GROUND) then
							enemy.space = nil
						end
					end
				end
				
				if enemy.space ~= nil then
					local pawn_data = _G[enemy.name]
					if pawn_data ~= nil  and not pawn_data.Minor then
						local animation = pawn_data.Image.."d"
						local script0 = "Board:AddAnimation("..enemy.space:GetString()..",\""..animation.."\","..ANIM_REVERSE + ANIM_DELAY..")"
						local script1 = "Board:AddPawn(\""..enemy.name.."\","..enemy.space:GetString()..")"

						local effect = SkillEffect()
						effect:AddScript(script0)
						effect:AddDelay(-1)
						effect:AddScript(script1)
						Board:AddEffect(effect)
					end
				end
				
				self.Enemies[id] = nil
			end
		end
	end
end