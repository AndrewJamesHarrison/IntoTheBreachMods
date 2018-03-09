

FontStyles = {

	PilotBarks = StyleInfo( "fonts/NunitoSans_Regular.ttf", 14 ),  
	CeoBriefing = StyleInfo( "fonts/NunitoSans_Regular.ttf", 14),
	Objectives = StyleInfo( "fonts/NunitoSans_Regular.ttf", 12 ),  
	TooltipTitle = StyleInfo( "fonts/NunitoSans_Bold.ttf", 14), 
	TooltipText = StyleInfo("fonts/NunitoSans_Regular.ttf", 12),
	PilotXP = StyleInfo("fonts/NunitoSans_Regular.ttf", 12),
	BattleObjective = StyleInfo("fonts/NunitoSans_Regular.ttf", 12),
	
	CorpText = StyleInfo("fonts/NunitoSans_Regular.ttf", 15),
	CorpHeadings = StyleInfo("fonts/NunitoSans_Bold.ttf", 15),
	
	HangarNames = StyleInfo("fonts/NunitoSans_Bold.ttf", 15),
	Copyright = StyleInfo("fonts/NunitoSans_Bold.ttf", 15),
}	

FontStyles_Large = {

	PilotBarks = StyleInfo( "fonts/NunitoSans_Regular.ttf", 17 ),  
	CeoBriefing = StyleInfo( "fonts/NunitoSans_Regular.ttf", 17),
	Objectives = StyleInfo( "fonts/NunitoSans_Regular.ttf", 15 ),  
	TooltipTitle = StyleInfo( "fonts/NunitoSans_Bold.ttf", 16), 
	TooltipText = StyleInfo("fonts/NunitoSans_Regular.ttf", 15),
	PilotXP = StyleInfo("fonts/NunitoSans_Regular.ttf", 12),
	BattleObjective = StyleInfo("fonts/NunitoSans_Regular.ttf", 14),
	
	CorpText = StyleInfo("fonts/NunitoSans_Regular.ttf", 17),
	CorpHeadings = StyleInfo("fonts/NunitoSans_Bold.ttf", 17),
	
	HangarNames = StyleInfo("fonts/NunitoSans_Bold.ttf", 15),
	Copyright = StyleInfo("fonts/NunitoSans_Bold.ttf", 15),
}	

function GetFontStyle(style, large)
	local font_table = large and FontStyles_Large or FontStyles
		
	if font_table[style] ~= nil then return font_table[style] end
	return StyleInfo("classic",0)
end