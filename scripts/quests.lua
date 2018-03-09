local IslandQuest = { Goal = 0, Text = "", Test = "less" }

CreateClass(IslandQuest)

function IslandQuest:GetText(tracker)
	local ret = string.gsub(self.Text,"VAL",self.Goal)
	if self.Goal ~= 0 then
		ret = "("..tracker.."/"..self.Goal..") "..ret
	end
	return ret
end

local QuestList = {}

QuestList[QUEST_REPUTATION] = IslandQuest:new{ 
	Goal = 8, 
	Text = "Earn VAL or more Corporate Reputation.", 
	Test = "more"
}

QuestList[QUEST_BUILDINGS] = IslandQuest:new{ 
	Goal = 4, 
	Text = "Lose VAL or less total Grid Power.", 
	Test = "less"
}

QuestList[QUEST_MECH] = IslandQuest:new{ 
	Goal = 6, 
	Text = "Take VAL or less total Mech Damage", 
	Test = "less"
}

QuestList[QUEST_OBJECTIVES] = IslandQuest:new{ 
	Goal = 0, 
	Text = "Don't fail any Bonus Objective.", 
	Test = "less"
}

QuestList[QUEST_POWER] = IslandQuest:new{ 
	Goal = 3, 
	Text = "Earn VAL Grid Power or more.", 
	Test = "more"
}	

function getQuestType(quest)
	return QuestList[quest].Test
end

function getQuestGoal(quest)
	return QuestList[quest].Goal
end

function getQuestText(quest,tracker)
	return QuestList[quest]:GetText(tracker)
end
