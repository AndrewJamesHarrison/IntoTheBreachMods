
Mission_Teleporter = Mission_Auto:new{ 
	UseBonus = true,
}

function Mission_Teleporter:StartMission()
	local teleports = {}

	local quarters = Environment:GetQuarters()
	
	for i,options in pairs(quarters) do
		local curr = Point(-1,-1)
		while #options > 0 and (not Board:IsValid(curr) or Board:IsBlocked(curr,PATH_GROUND)) do
			curr = random_removal(options)
		end
		teleports[#teleports+1] = curr
	end

	for i = 1, 2 do
		local start = random_removal(teleports)
		local finish = random_removal(teleports)
		Board:AddTeleport(start,finish)
	end
end