
Personality = {} --- The global result of all of this work
local ftcsv = dofile(GetWorkingDir().."scripts/personalities/ftcsv.lua") -- script for parsing csv file

local function split(str, pat)
	local t = {} 
	local fpat = "(.-)" .. pat
	local last_end = 1
	local s, e, cap = str:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = str:find(fpat, last_end)
	end
	if last_end <= #str then
		cap = str:sub(last_end)
		table.insert(t, cap)
	end
	return t
end

local PilotPersonality = {Label = "NULL"}
CreateClass(PilotPersonality)

local Names = {}--ret[1]
local Keys = {}--ret[2]

local function GetKey(index)
	if index > 3 and Keys[index] ~= "" then return Keys[index] end
	return ""
end

local file_list = {
	{ file = GetWorkingDir().."scripts/personalities/pilots.csv", start = 8 },
	{ file = GetWorkingDir().."scripts/personalities/missions.csv", start = 3 }
}


for index, curr in ipairs(file_list) do
	local ret = ftcsv.parse(curr.file, ',', {headers = false})
	Names = ret[1]
	Keys = ret[2]
	
	for index, id in ipairs(ret[2]) do
		if index > 3 and id ~= "" then
			local parent = ret[3][index]
			
			if Personality[id] == nil then
				if parent == "" or Personality[parent] == nil then
					Personality[id] = PilotPersonality:new()
				else
					Personality[id] = Personality[parent]:new()
				end
			
				Personality[id].Label = Names[index]
				Personality[id].Name = ret[4][index]
			end
		end
	end
	
	for i,row in ipairs(ret) do
		local trigger = row[2]
		if i >= curr.start and trigger ~= "" then
			for index, text in ipairs(row) do
				if GetKey(index) ~= "" and text ~= "" then
					--text = "\""..text
					if string.sub(text,#text) == "," then
						text = string.sub(text,1,#text-1)
					end
					text = string.gsub(text,"“","")
					text = string.gsub(text,"”","")
					text = string.gsub(text,"‘","'")
					text = string.gsub(text,"…","...")
					text = string.gsub(text,"’","'")
					text = string.gsub(text,"–","-")
					
					local final_texts = {text}
                    if trigger ~= "Region_Names" then--don't split up Region_Names
                        final_texts = split(text,"\",%s*\n*")
                    end
                    
					for i, v in ipairs(final_texts) do
						final_texts[i] = string.gsub(v,"\"","")
					end
					
					Personality[GetKey(index)][trigger] = final_texts
					
					--if GetKey(index) == "CEO_Snow" then
					--	LOG("Found text for "..trigger)
					--end
				end
			end
		end
	end
end

--test it!
--[[for i,v in pairs(Personality["CEO_Grass"]) do
	print("\n\n")
	print("Trigger: "..i)
	
    if type(v) == "table" then
        for j, k in ipairs(v) do
	    	print(j.." = "..k)
	    end
	end
end]]--

function PilotPersonality:GetPilotDialog(event)
	if self[event] ~= nil then 
		if type(self[event]) == "table" then
			return random_element(self[event])
		end
		
		return self[event]
	end
	
	LOG("No pilot dialog found for "..event.." event in "..self.Label)
	return ""
end

function GetRandomName()
	return "Randomized Name"
end

function GetPersonalityName(id)
	if Personality[id] ~= nil and Personality[id].Name ~= nil and Personality[id].Name ~= "" then
		return Personality[id].Name
	else
		return GetRandomName()
	end
end

function GetPilotDialog(personality, event)
    if Personality[personality] == nil then
        LOG("No  dialog found for personality:"..personality..", event: ".. event)
        return ""
    end
    
    local text = Personality[personality]:GetPilotDialog(event)
	text = string.gsub(text, "#squad", Game:GetSquad())
	text = string.gsub(text, "#corp", Game:GetCorp().name)
	return text
end

