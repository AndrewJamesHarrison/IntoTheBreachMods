
local PopEvent = {
	Opening = { "We're saved!", "They're here!", "Mom, look!", "The Travelers!", "Dad, look!", "Help is here!", "They've come!", "The Mechs are here!", "They'll protect us!", },
	Closing = { "Thank you!", "The Vek are running!", "We're saved!", "Thank you, Travelers!", "That was amazing!", "They did it!", "It's over!", "We won!", "We survived!", "Victory!" },
	Threatened = { "It's attacking us!", "We're doomed!", "Help us!", "Save us!", Odds = 50 },
	Killed = {"They killed it!", "It's dead!", "Awesome!", "Excellent!", "Wow!", Odds = 50 }
}

function GetPopulationTexts(event, count)

	local nullReturn = count == 1 and "" or {}
	
	if PopEvent[event] == nil then
		return nullReturn
	end
	
	if PopEvent[event].Odds ~= nil and random_int(100) > PopEvent[event].Odds then
		return nullReturn
	end
	
	local list = copy_table(PopEvent[event])
	
	local ret = {}
	for i = 1, count do
		if #list == 0 then
			break
		end
		
		ret[#ret+1] = random_removal(list)
	end
	
	if #ret == 0 then
		return nullReturn
	end
	
	if count == 1 then
		return ret[1]
	end
	
	return ret
end