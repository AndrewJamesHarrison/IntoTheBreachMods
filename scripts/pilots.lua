
local pilot_surnames = { "Huang", "Ferry", "Smith", "Kirk", "Waller", "Volkov", "Kim", "Perez", "Romano", "Correa", "Prieto", "Montes", "Berezin", "Patel", "Acharya", "Singh", "Kirby", "Sanchez", "Chavez", "Nguyen", "Lee", "Zhang", "Tigani", "Torcasio", "Koleda" } 

local female_given = { "Willow", "Alison", "Chloe", "Maria", "Ana", "Clara", "Amelia", "Tatiana", "Zoe", "Myra", "Esther", "Nadia", "Nora", "Ayesha", "Sofia", "Isabel", "Jill", "Isla", "Airilee", "Sam", "Urbana", "Estelle", "Ilona", "Mikayla", "Elizabeth", "Lauren" }

local male_given = { "Peter", "David", "Pierre", "Mateo", "Elijah", "Dylan", "Alexis", "Miguel", "Ori", "Omar", "Aidan", "Anton", "Leo", "Liam", "Nikola", "Stefan", "Maxim", "Fox", "Bigby", "Charlie", "Michael", "Nick", "Sergei", "Philip", "Thuy", "Collin", "Steve" }

local vek_given = { "Xakran", "Kxlatl", "Taaxetizl"}

local ai_given = { "Clare", "Serhina", "Coral", "Qualia", "Zera", "Mary", "Binary", "Genos", "Raine", "Penny", "Celestine", "Cinnabar", "Calypso", "Ganymede", "Leda", "Fenrir", "Zas" }

local curr_surnames = {}
local curr_female = {}
local curr_male = {}
local curr_vek = {}
local curr_ai = {}

function GetRandomName(sex)
		
	if #curr_vek == 0 then curr_vek = copy_table(vek_given) end
	if #curr_ai == 0 then curr_ai = copy_table(ai_given) end
	if #curr_surnames == 0 then curr_surnames = copy_table(pilot_surnames) end
	if #curr_female == 0 then curr_female = copy_table(female_given) end
	if #curr_male == 0 then curr_male = copy_table(male_given) end
	
	if sex == SEX_VEK then
		return random_removal(curr_vek)
	end
	
	if sex == SEX_AI then
		return random_removal(curr_ai)
	end
	
	local surname = random_removal(curr_surnames)
	
	if sex == SEX_MALE then
		return random_removal(curr_male).." "..surname
	else
		return random_removal(curr_female).." "..surname
	end
end

Pilot = {
	HealthBonus = {0,0},
	MoveBonus = {0,0},
	Skills = {"",""},
	Personality = "Standard",
	Sex = SEX_MALE, 
	Rarity = 1,
	PowerCost = 0,
	Cost = 2,
	Name = "",
	Skill = "",
	Portrait = "",
	Voice = "",
}

CreateClass(Pilot)

PilotList = {}

function CreatePilot(data)
	_G[data.Id] = Pilot:new(data)
	
	if data.Rarity ~= 0 then
		PilotList[#PilotList+1] = data.Id
	end
end

Pilot_Recruits = {"Pilot_Archive", "Pilot_Rust", "Pilot_Detritus", "Pilot_Pinnacle"}

CreatePilot{
	Id = "Pilot_Original",
	Personality = "Original",
	Name = "Ralph Karlsson",
	HealthBonus = {2,0},
	MoveBonus = {0,1},
	Rarity = 1,
	Voice = "/voice/ralph",
	Skill = "Extra_XP",
}

--"recruit"
CreatePilot{
	Id = "Pilot_Rust",
	Personality = "Rust",
	Rarity = 0,
	Cost = 1,
	Sex = SEX_FEMALE,
	Portrait = "npcs/sand1",
	Voice = "/voice/rust",
}

CreatePilot{
	Id = "Pilot_Archive",
	Personality = "Archive",
	Rarity = 0,
	Cost = 1,
	Sex = SEX_FEMALE,
	Portrait = "npcs/grass1",
	Voice = "/voice/archive",
}

CreatePilot{
	Id = "Pilot_Detritus",
	Personality = "Detritus",
	Rarity = 0,
	Cost = 1,
	Sex = SEX_FEMALE,
	Portrait = "npcs/acid1",
	Voice = "/voice/detritus",
}

CreatePilot{
	Id = "Pilot_Pinnacle",
	Personality = "Pinnacle",
	Rarity = 0,
	Cost = 1,
	Sex = SEX_AI,
	Portrait = "npcs/ice1",
	Voice = "/voice/pinnacle",
}

CreatePilot{
	Id = "Pilot_Artificial",
	Personality = "Artificial",
	Rarity = 0,
	Name = "A.I. Unit",
	Voice = "/voice/ai",
}

CreatePilot{
	Id = "Pilot_BeetleMech",
	Personality = "Vek",
	Sex = SEX_VEK,
	Skill = "Survive_Death",
	Rarity = 0,
}

CreatePilot{
	Id = "Pilot_HornetMech",
	Personality = "Vek",
	Sex = SEX_VEK,
	Skill = "Survive_Death",
	Rarity = 0,
}

CreatePilot{
	Id = "Pilot_ScarabMech",
	Personality = "Vek",
	Sex = SEX_VEK,
	Skill = "Survive_Death",
	Rarity = 0,
}

--Pilots that can drop--

CreatePilot{
	Id = "Pilot_Soldier",
	Personality = "Soldier",
	Name = "Camila Vera",
	Sex = SEX_FEMALE,
	Skill = "Disable_Immunity",
	Voice = "/voice/camila",
}

CreatePilot{
	Id = "Pilot_Youth",
	Personality = "Youth",
	Name = "Lily Reed",
	Sex = SEX_FEMALE,
	Skill = "Youth_Move",
	Voice = "/voice/lily",
}

CreatePilot{
	Id = "Pilot_Warrior",
	Personality = "Warrior",
	Skill = "Deploy_Anywhere",
	PowerCost = 1,
	Name = "Gana",
	Sex = SEX_FEMALE,
	Voice = "/voice/gana",
}

CreatePilot{
	Id = "Pilot_Aquatic",
	Skill = "Post_Move",
	Personality = "Aquatic",
	PowerCost = 1,
	Name = "Archimedes",
	Voice = "/voice/archimedes",
}

CreatePilot{
	Id = "Pilot_Medic",
	Personality = "Medic",
	Skill = "TimeTravel",
	Name = "Isaac Jones",
	Voice = "/voice/isaac",
}

CreatePilot{
	Id = "Pilot_Hotshot",
	Personality = "Hotshot",
	Skill = "Road_Runner",
	Name = "Henry Kwan",
	Voice = "/voice/henry",
}

CreatePilot{
	Id = "Pilot_Genius",
	Personality = "Genius",
	Skill = "Self_Shield",
	Sex = SEX_FEMALE,
	Name = "Bethany Jones",
	Voice = "/voice/bethany",
}

CreatePilot{
	Id = "Pilot_Miner",
	Sex = SEX_FEMALE,
	Skill = "Double_Shot",
	Personality = "Miner",
	PowerCost = 2,
	Name = "Silica",
	Voice = "/voice/silica",
}

CreatePilot{
	Id = "Pilot_Recycler",
	Skill = "Flying",
	Personality = "Recycler",
	PowerCost = 1,
	Name = "Prospero",
	Voice = "/voice/prospero",
}

CreatePilot{
	Id = "Pilot_Assassin",
	Personality = "Assassin",
	Skill = "Armored",
	Name = "Abe Isamu",
	Voice = "/voice/abe",
}

CreatePilot{
	Id = "Pilot_Leader",
	Skill = "Shifty",
	Personality = "Leader",
	Sex = SEX_FEMALE,
	Name = "Chen Rong",
	Voice = "/voice/chen",
}
CreatePilot{
	Id = "Pilot_Repairman",
	Personality = "Repairman",
	Skill = "Power_Repair",
	Name = "Harold Schmidt",
	Voice = "/voice/harold",
}

CreatePilot{
	Id = "Pilot_Mantis",
	Personality = "Mantis",
	Skill = "Mantis_Skill",
	Name = "Kazaaakpleth",
	Voice = "/voice/kazaaakpleth",
	Rarity = 0,
}

CreatePilot{
	Id = "Pilot_Rock",
	Personality = "Rock",
	Skill = "Rock_Skill",
	Name = "Ariadne",
	Sex = SEX_FEMALE,
	Rarity = 0,
	Voice = "/voice/ariadne",
}
 
 
 CreatePilot{
	Id = "Pilot_Zoltan",
	Personality = "Zoltan",
	Skill = "Zoltan_Skill",
	Name = "Mafan",
	Sex = SEX_FEMALE,
	Rarity = 0,
	Voice = "/voice/mafan",
}
 




--[[

Pilot_Original
Pilot_Warrior
Pilot_Miner
Pilot_Medic
Pilot_Genius
Pilot_Aquatic
Pilot_Leader
Pilot_Hotshot
Pilot_Assassin
Pilot_Recycler
Pilot_Repairman
]]
