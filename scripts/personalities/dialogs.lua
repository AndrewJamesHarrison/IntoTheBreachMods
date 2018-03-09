--Unless noted here, dialogue event has a 100% chance of occurring

--[[

Possible actors in any dialog:

main = Character that engaged in the activity
		if no Character engaged, then it will randomly select a PILOT or the CEO

target = Secondary character in situations where someone else is directly involved
			Example: main pawn shot another pawn, the other pawn would be the target

ceo = The current corporation CEO
			
other = Any character not chosen already based on above conditions

During a Dialog, the positions are chosen and retained. For example, this would create a dialog between the engaged character and 1 other character
	Dialog({other = "Something"}, {main = "Something_Response"}, {other = "Something_else"})

--]]

local VE_Info = {
	VekKilled = { 
		Odds = 20, 
		{main = "VekKilled_Self"}, 
		{other = "VekKilled_Obs" }
	},
	
	BotKilled = {
		Odds = 20,
		{main = "BotKilled_Self"}, 
		{other = "BotKilled_Obs" }
	},
	
	VekKilled_Enemy = {
		Odds = 50,
		{other = "VekKilled_Vek"},
	},
	
	DoubleVekKill = {
		Odds = 50,
		{main = "DoubleVekKill_Self"},
		{other = "DoubleVekKill_Obs"},
	},
	
	DoubleVekKill_Enemy = {
		Odds = 50,
		{other = "DoubleVekKill_Vek"},
	},
	
	BldgDamaged = {
		Odds = 75,
		{main = "Bldg_Destroyed_Self"},
		{other = "Bldg_Destroyed_Obs"},
	},
	
	Bldg_Resisted = { Odds = 100 },
	
	BldgDamaged_Enemy = {
		Odds = 50,
		{other = "Bldg_Destroyed_Vek"},
	},
	
	MntDestroyed = {
		Odds = 25,
		{main = "MntDestroyed_Self"},
		{other = "MntDestroyed_Obs"},
	},
	
	MntDestroyed_Enemy = {
		Odds = 25,
		{other = "MntDestroyed_Vek"},
	},
	
	PowerCritical = {Odds = 100},
	
	Mech_WebBlocked = {{main = "Mech_Webbed"}, Odds = 100},--specifically for Disable Immunity pilot
	Mech_Webbed = {Odds = 50},
	Mech_Shielded = {Odds = 20},
	Mech_Repaired = {Odds = 75},
	Mech_ShieldDown = {Odds = 50},
	
	Emerge_Detected = {Odds = 3},
	Emerge_FailedMech = {Odds = 20},
	Emerge_FailedVek = {Odds = 3},
	Emerge_Success = {Odds = 3},
	
	Vek_Drown = {Odds = 50},
	Vek_Fall = {Odds = 50},
	Vek_Smoke = {Odds = 10},
	Vek_Frozen = {Odds = 35},
	
	Pilot_Selected = { Odds = 10 },
	Pilot_Undo = { Odds = 10 },
	Pilot_Moved = { Odds = 10 },

	MissionEnd_Retreat = { Odds = 50 },
	MissionEnd_Dead = { Odds = 75 },	
	
	Gamestart_Alien = { Dialog({main = "Gamestart"}, {other = "FTL_Start"}) },
	
	PodDetected = { Dialog({main = "PodIncoming"}, {other = "PodResponse"}) },
	
	PodDestroyed = {
		{other = "PodDestroyed_Obs"}, Odds = 100,
	},
	
	PodCollected = {
		{main = "PodCollected_Self"}, Odds = 100,
	},
	
	Pilot_Level = { {main = "Pilot_Level_Self"}, {other = "Pilot_Level_Obs"} },
	
	Gameover = { Dialog({main = "Gameover_Start"}, {other = "Gameover_Response"}) },
	
	PilotDeath = { 
		{main = "Death_Main"}, 
		{other = "Death_Response"}
	},
	
	PilotDeath_Hospital = {
		{other = "Death_Response_Medical"}
	},
	
	PilotDeath_AI = {
		{other = "Death_Response_AI"}
	},
	
	
	----------
	
	Mission_Freeze_Mines_Vek = { Odds = 30 },
	Mission_Mines_Vek = { Odds = 30 },
	Mission_Satellite_Imminent = { Odds = 30 },
	Mission_Satellite_Launch = { Odds = 30 },
	Mission_Cataclysm_Falling = { Odds = 30},
	Mission_Terraform_Attacks = { Odds = 30},
	Mission_Airstrike_Incoming = { Odds = 30},
	Mission_Lightning_Strike_Vek = { Odds = 30}, 
	
	Mission_Factory_Spawning = {Odds = 30}, 
	Mission_Reactivation_Thawed = {Odds = 30},
	Mission_SnowStorm_FrozenVek = {Odds = 30},
	Mission_SnowStorm_FrozenMech = {Odds = 75},
	
	Mission_Disposal_Activated = {Odds = 30},
	Mission_Barrels_Destroyed = {Odds = 30},
	Mission_Teleporter_Mech = {Odds = 30},
	Mission_Belt_Mech = {Odds = 30},
}

function AddVoicePopup(event, id, cast)
	cast = cast or { main = id, target = -1, other = -1 }
	cast.self = id
		
	local pop = VoicePopup()
	local personality = ""
	local corp = Game:GetCorp()
	
	pop.timetravel = event == "TimeTravel_Win" or event == "TimeTravel_Loss"
	
	local names = { main = "", target = "", other = "", self = ""}
	
	if id == PAWN_ID_CEO then
		personality = corp.ceo_personality
	else
		if Game:GetPawn(id) ~= nil then
		
		    local death_event = event == "PilotDeath" or event == "Death_Main" or event == "Death_Response"
		    
			if Game:GetPawn(id):IsDead() and not death_event then
				return --no dead pilot events
			end
			
			personality = Game:GetPawn(id):GetPersonality()
		else
			return --primary speaker doesn't exist
		end
	end
	
	if Personality[personality] == nil then
	    return
	end
	
	repeat
		pop.text = Personality[personality]:GetPilotDialog(event)
	until (string.find(pop.text,"#saved_corp") == nil or names.saved_corp ~= "")
	
	pop.pawn = id
	
	if string.find(pop.text,"#") ~= nil then
	
		local final_names = {}--copy_table(names)
	    for id, value in pairs(names) do
	        if Game:GetPawn(cast[id]) ~= nil then
				final_names[id.."_mech"] = Game:GetPawn(cast[id]):GetMechName()
				final_names[id.."_reverse"] = Game:GetPawn(cast[id]):GetPilotName(NAME_REVERSE)
			    final_names[id.."_first"] = Game:GetPawn(cast[id]):GetPilotName(NAME_FIRST)
				final_names[id.."_second"] = Game:GetPawn(cast[id]):GetPilotName(NAME_SECOND)
				final_names[id.."_last"] = final_names[id.."_second"]
				final_names[id.."_full"] = Game:GetPawn(cast[id]):GetPilotName(NAME_NORMAL)
	    	end
	    end

		local ceo_names = {}
		for i in corp.ceo_name:gmatch("%w+") do table.insert(ceo_names,i) end
		final_names.ceo_full = corp.ceo_name
		final_names.ceo_first = ceo_names[1]
		final_names.ceo_last = ceo_names[#ceo_names]
		final_names.ceo_second = ceo_names[#ceo_names]
		
		final_names.corporation = corp.bark_name
		final_names.corp = corp.bark_name
		
		if final_names.corp == "" and string.find(pop.text,"#corp") ~= nil then
			return--just skip #corp lines if there's no valid replacement for them
		end
		
		final_names.squad = Game:GetSquad()
	    final_names.saved_corp = Game:GetSavedCorp()
		
		for tag, name in pairs(final_names) do
			pop.text = string.gsub(pop.text,"#"..tag,name)
		end
	end

	Game:AddVoicePopup(pop)
end

function PrepareVoiceEvent(name, pawn1, pawn2, custom_odds)
	pawn1 = pawn1 or -1
	pawn2 = pawn2 or -1
	TriggerVoiceEvent(VoiceEvent(name,pawn1,pawn2), custom_odds)
end

function TriggerVoiceEvent(event, custom_odds)
	local eventInfo = VE_Info[event.id]
		
	custom_odds = custom_odds or -1
	
	local mech = nil
	
	if event.pawn1 == -1 then
		if random_bool(8) then 
			event.pawn1 = PAWN_ID_CEO
		else
		    mech = Game:GetRandomVoice()
		end
	end
	
	if event.pawn1 == PAWN_ID_MECH and mech == nil then
		mech = Game:GetRandomVoice()
	end
	
	if mech ~= nil then
		event.pawn1 = mech:GetId()
	end
	
	if eventInfo == nil then
		AddVoicePopup(event.id, event.pawn1)
		return
	end
	
	local odds = eventInfo.Odds or 100
	
	if custom_odds ~= -1 then
		odds = custom_odds
	end
	
--	if odds ~= 100 then
	--	odds = 101
	--end
	
	if Game:IsVoicePopup() and odds ~= 100 then
		return --only push through 100% voice popups
	end
	
	--odds = odds > 24 and 100 or 0
	if odds < random_int(100) then 
		return 
	end
	
	if #eventInfo == 0 then
		AddVoicePopup(event.id, event.pawn1)
		return
	end

	local cast = { main = event.pawn1, target = event.pawn2, other = -1 }
		
	if cast.other == -1 then
		local other_mech = Game:GetAnotherVoice(cast.main, cast.target)
		if (other_mech == -1 or random_bool(4)) and cast.main ~= PAWN_ID_CEO then 
			cast.other = PAWN_ID_CEO
		else
			cast.other = other_mech
		end
	end
		
	local selectedDialog = random_element(eventInfo)
	
	if #selectedDialog == 0 then
		selectedDialog = {selectedDialog}
	end

	for i,segment in ipairs(selectedDialog) do
		if segment.main ~= nil then
			AddVoicePopup(segment.main, cast.main, cast)
		end
		if segment.target ~= nil then
			AddVoicePopup(segment.target, cast.target, cast)
		end
		if segment.other ~= nil then
			AddVoicePopup(segment.other, cast.other, cast)
		end
		if segment.ceo ~= nil then
			AddVoicePopup(segment.ceo, PAWN_ID_CEO, cast)
		end
	end
end
