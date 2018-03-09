
local PopEvent = {
	Opening = { "We're saved!", "I knew they'd come!", "The #squad!", "It's the #squad!", "Now the Vek are going to get it!", "The Vek are going to be sorry now!", "Get my glasses!\nI want to see!", "Stop crowding the window!", "What's going on?", "The Mechs have landed!", "#corp sent Mechs!", "What's that noise?", "You hear something?", "Is it them?", "They're here!", "Mom, look!", "The Mechs!", "Dad, look!", "We're rescued!", "Finally!", "Help is here!", "They've come!", "The Mechs are here!", "They'll protect us!", },
	
	Closing = { "Thank you!", "They're on the run!", "The Vek are running!", "We're saved!", "That was amazing!", "Unbelievable!", "They did it!", "It's over!", "We won!", "We survived!", "Victory!", "They're gone!", "They're fleeing!", "You scared them off!", },
	
	Closing_Dead = { "Thank you!", "I can't believe it!", "Dead? All of them?", "They killed them all?", "They're all dead!", "We're saved!", "You wiped them out!", "The #squad beat them!", "The Mechs wiped them out!", "They're gone!", "No more Vek!", "Amazing!", "You won!", "We survived!",},
	
	Closing_Perfect = { "Thank you!", "We're all okay!", "Everybody all right?", "The #squad saved us!", "Three cheers for the #squad!", "#corp is saved!", "Nothing was damaged!", "The #squad are heroes!", "Perfect victory!", "Victory!" , "Did you see that?", "I can't believe it!" },
	
	Closing_Bad = { "Thanks... I guess.", "They did more harm than good...", "My family... gone...", "So many lost...", "Are they finally gone?", "Is it over?", "Time to rebuild..."},
	
	Threatened = { "It's attacking us!", "Uh-oh.", "Oh no!", "Everyone, brace yourselves!", "Get away from the windows!", "What's that shadow?", "This looks bad...", "Help!", "We're doomed!", "Our luck's run out...", "It's targeting us!", "Help! Anyone, help!", "Help us, #squad!", "#squad, help!", "We're done for.", "Save us!", "It's coming at us!", "Will the building hold?", "Help us!", "Save us!", Odds = 50 },
	
	Killed = {"Whoa.", "Yeah!", "Eat that, Vek!", "I can't believe it!", "It's down!", "They took it out!", "And stay dead!", "They killed it!", "It's dead!", "Did you see that?!", "Excellent!", "Yes!", "All right!", "Wow!", Odds = 50 },
	
	Shielded = { "We're safe!", "Will this hold?", "That'll stop them!", "Shielded!", "We're shielded!", "Shield up!", "Safe at last!", "Protection!", Odds = 50 },
	
	Frozen = { "It's so cold...", "Grab the blankets.", "Huddle together, everyone.", "The window's iced over!", "What happened?", "Feels like a freezer!", "It's freezing!", "It's too cold!", "At least we're safe?", Odds = 50 },
}

function GetPopulationTexts(event, count)
    
	local nullReturn = count == 1 and "" or {}
	
	if PopEvent[event] == nil then
		return nullReturn
	end
	
	if Game == nil then
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

	local corp_name = Game:GetCorp().bark_name
	local squad_name = Game:GetSquad()
	for i,v in ipairs(ret) do
		ret[i] = string.gsub(ret[i], "#squad", squad_name)
		ret[i] = string.gsub(ret[i], "#corp", corp_name)
	end
	
	if count == 1 then
		return ret[1]
	end
	
	return ret
end