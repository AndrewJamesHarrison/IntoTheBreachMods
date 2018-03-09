
Event_Tester =
	{ Text = "Blah blah.", pilot = "all" }

---------------------------------

-- 		IMPORTANT FUNCTIONS		--

---------------------------------

function autoPercentage(amount)
	amount = string.sub(amount,1,string.len(amount)-1)
	amount = tonumber(amount)
	return amount > random_int(100)
end

function getAutoValue(item, amount)

	local negative = false
	if type(amount) == "string" and string.sub(amount,1,1) == "-" then 
		amount = string.sub(amount,2)
		negative = true
	end

	if item == "money" then
		amount = getAutoMoney(amount)
	elseif item == "bones" then
		amount = getAutoBones(amount)
	elseif item == "weapon" then
		amount = getAutoWeapon(amount)
	elseif item == "cores" then
		amount = getAutoCores(amount)
	elseif item == "stock" then
		if amount == "infinite" then return INT_MAX end
	end
	
	if negative then amount = -amount end
	
	return amount
	--LOG("auto value request failed, parameters: item = "..item.." amount = "..amount)
end

function getAutoCores(amount)
	if type(amount) ~= "string" then return amount end
	
	if amount == "low" then return 1 end
	if amount == "med" then return 2 end
	if amount == "high" then return 3 end
	
	LOG("auto cores request failed, parameters: amount = "..amount)
end

function getAutoBones(amount)
	if type(amount) ~= "string" then return amount end
	
	if string.find(amount,"%%") ~= nil then 
		if autoPercentage(amount) then
			return getAutoBones("low")
		else
			return 0
		end
	end
	
	if amount == "low" then return 1 end
	if amount == "med" then return 2 end
	if amount == "high" then return 3 end
	
	LOG("auto bones request failed, parameters: amount = "..amount)
end

function getAutoWeapon(amount)
	if string.find(amount,"%%") == nil then return amount end
	if autoPercentage(amount) then return "random" end
	return ""
end

function getAutoWeaponCost(amount)
	if type(amount) ~= "string" then return amount end
	
	if amount == "low" then return 20 end
	if amount == "med" then return 30 end
	if amount == "high" then return 40 end
	
	LOG("auto weapon cost request failed, parameters: amount = "..amount)
end

function getAutoMoney(amount)
	if type(amount) ~= "string" then return amount end
	
	if amount == "cost" then return INT_MAX end--Flags the game to use the items standard cost (only works for weapons)
	
	if amount == "cores" then return -15 end
	
	if amount == "low" then
		return 1
	elseif amount == "med" then 
		return 2
	elseif amount == "high" then 
		return 3
	end
	
	LOG("auto money request failed, parameters: amount = "..amount)
	return 0
end

--------- BACKEND CODE HERE --- IGNORE ME ------------------
			
--------This is an entry point from the C++ Side-------
function CreateChoiceEvent(event)
	---Pure text event has two choices:
		--The name of another defined event
		--Just the text of the event
	if type(event) == "string" then
		--LOG("Creating event: "..event)
		if _G[event] ~= nil then
			--LOG("Found in global space")
			return CreateChoiceEvent(_G[event]) ---Pass the actual event object back into this function
		else
			--LOG("Plain text event")
			return ChoiceEvent(event) -- Simple text-only event
		end
	end
	
	---Table events have two options:
		--Normal event definition, we just pass it on to the EventCreator
		--A list of multiple options, choose one and pass it on
			---Possible sub-table "Odds" might exist in that situation to help with selection
	if type(event) == "table" then
		if #event == 0 then
			return EventCreator(event) -- Ready for actual event creation, simple table of values
		else
			return CreateChoiceEvent(ListRandomizer(event)) -- Choose the table we'll actually use
		end
	end
	
	--Return an error, both to the log and to the choice box to make it clear
	local err = "Parameter passed to CreateChoiceEvent was invalid."
	LOG(err)
	return ChoiceEvent(err)
end

function ListRandomizer(list)
	if #list == 0 then return list end
	
	local odds = {}
	---Either grab the manually defined odds, or compute the table
	if list["Odds"] ~= nil then
		odds = list["Odds"]
		---roll the die
		local randomRoll = random_int(100)
		
		local currTotal = 0
		--grab the selected event
		for i = 1, #odds do
			currTotal = currTotal + odds[i]
			if randomRoll < currTotal or i == #odds then
				return list[i]
			end
		end
	else
		return random_element(list)
	end
	
	local err = "If you're reading this, something went wrong with the randomizer"
	LOG(err)
	return list[1]
end

--[[function IsAutoValue(val)
	if type(val) == "string" then
		return val == "med" or val == "low" or val == "high" or string.find(amount,"%%") ~= nil
	end
	
	return false
end]]--

function CreateChoiceRequirement(val)
	local ret = Requirement()
	if val["skill"] ~= nil then
		ret.skill = val["skill"]
	end
	if val["required"] ~= nil then
		ret.skill = val["required"]
		ret.required = true
	end
	if val["level"] ~= nil then
		ret.level = val["level"]
	end
	
	if val["Text"] ~= nil then
		ret.Text = val["Text"]
	end
	
	return ret
end

function CreateEffect(data)
	local effect = Effect()
	local values = copy_table(data)
	
	if values.reward ~= nil then
		values.reward = ListRandomizer(values.reward)
		for i,v in pairs(values.reward) do
			values[i] = v
		end
		values.reward = nil
	end
	
	for i, v in pairs(values) do
		--if IsAutoValue(v) then 
		values[i] = getAutoValue(i, v)
		--end
	end
		
	--Go through every possible DIRECT pairing in the Effect object, and just set the value
	for i, v in pairs(values) do
		if effect[i] ~= nil then
			effect[i] = v
		end
	end
	
	return effect
end

function EventCreator(event)
	local ret = ChoiceEvent()

	if event["Hidden_Results"] ~= nil then
		ret:SetHiddenEffects(event["Hidden_Results"])
	end
	
	if event["Start"] ~= nil then
		ret:SetStartText(event["Start"])
	end
	
	if event["UniqueMech"] ~= nil then
		ret:SetUniqueMech(event["UniqueMech"])
	end
		
	ret:SetEffect(CreateEffect(event))
		
	local choiceNumber = 1
	while event["Choice_Text"..choiceNumber] ~= nil do
		local choice = Choice()
		choice["text"] = event["Choice_Text"..choiceNumber]	
		
		if event["Choice_Hidden"..choiceNumber] ~= nil then
			choice["bHidden"] = event["Choice_Hidden"..choiceNumber]
		end
		
		if event["Choice_Effect"..choiceNumber] ~= nil then
			choice["choiceEvent"] = CreateChoiceEvent(event["Choice_Effect"..choiceNumber])
		end
		
		if event["Choice_Failed"..choiceNumber] ~= nil then
			choice["failEvent"] = CreateChoiceEvent(event["Choice_Failed"..choiceNumber])
		end
		
		if event["Choice_Req"..choiceNumber] ~= nil then
			choice["req"] = CreateChoiceRequirement(event["Choice_Req"..choiceNumber])
		end
		
		ret:AddChoice(choice)
		choiceNumber = choiceNumber + 1
	end
	
	return ret
end

function extract_table(pointlist)
	local ret = {}
	for i = 1, pointlist:size() do
		ret[i] = pointlist:index(i)
	end
	
	return ret
end

function add_rewards(list1,list2)
	local base = copy_table(list1)
	
	if type(base[1]) == "table" then 
		for i,v in pairs(base) do
			if i == "Odds" then 
				--do nothing
			else 
				for j,k in pairs(list2) do
					v[j] = k
				end
			end
		end
	else
		for i,v in pairs(list2) do
			base[i] = v
		end
	end
	
	return base
end