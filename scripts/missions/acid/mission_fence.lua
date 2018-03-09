
Mission_Fence = Mission_Auto:new{ 
	UseBonus = true
}

function Mission_Fence:IsObstructed(p)
	return Board:GetTerrain(p) == TERRAIN_BUILDING or Board:GetTerrain(p) == TERRAIN_MOUNTAIN
end

function Mission_Fence:TrimFence(path)
	
	local front_trim = random_bool(2)
	
	local amount = #path/2
	
	for i = 1, amount do
		if front_trim then 
			table.remove(path,1)
		else
			table.remove(path,#path)
		end
	end
	
	return path
end

function Mission_Fence:StartMission()
	
	local options = {}
	local curr_path = {}
	
	local function update_path(x,y,dir)
		local p1 = Point(x,y)
		local p2 = p1 + DIR_VECTORS[dir]
			local obstructed = self:IsObstructed(p1) or self:IsObstructed(p2) or Board:GetTerrain(p1) == TERRAIN_WATER
			if not obstructed then
				curr_path[#curr_path+1] = p1
			end
			
			if obstructed or y == 6 then
				if #curr_path > 0 then
					for i, point in ipairs(curr_path) do
						options[#options+1] = {}
						options[#options].point = point
						options[#options].dir = dir
						options[#options].choke = #curr_path == 1
					end
				end
				curr_path = {}
			end
	end
	
	--horizontal paths
	for x = 1, 4 do
		curr_path = {}
		for y = 0, 7 do
			update_path(x,y,DIR_RIGHT)
		end
	end
	
	--[[vertical paths
	for y = 0, 6 do
		curr_path = {}
		for x = 0, 7 do
			update_path(x,y,DIR_DOWN)
		end
	end]]--
	
	local count = 0
	local choke_used = false
	while count < 5 and #options > 0 do
		local choice = random_removal(options)

        if choice.choke and choke_used then
            choice = nil
        else
            for dir = DIR_START, DIR_END do
                if Board:IsWall(choice.point + DIR_VECTORS[dir],DIR_ANY, PATH_GROUND) then
                    choice = nil
                    break
                end
            end
        end
		
		if choice ~= nil then
			count = count + 1
			if choice.choke then
			    choke_used = true
			end
			Board:SetWall(true,choice.point,choice.dir)
		end
	end
end