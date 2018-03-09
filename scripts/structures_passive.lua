
Pass_Reactor = {
	Name = "Overcharged Reactors",
	Description = "+1 Reactor for all Mechs",
	Value = 1
}

Pass_Move = {
	Name = "Energized Servos",
	Description = "+1 Move for all Mechs",
	Value = 1
}

Pass_Health = {
	Name = "Titanite Reinforcement",
	Description = "+2 Health for all Mechs",
	Value = 2
}

Pass_Pods = {
	Name = "Pod Detection",
	Description = "Mark the location of incoming Time Pods",
	Value = 1
}

Pass_Limited = {
	Name = "Ammo Storage",
	Description = "All limited weapons gain +1 use",
	Value = 1
}

Pass_CrossClass = {
	Name = "Creative Engineering",
	Description = "No penalties when equipping cross-class weapons"
}

Pass_Death = {
	Name = "Emergency Medical Team",
	Description = "Pilots will no longer die when their Mechs are disabled"
}

-------------------------------------
------------COMBAT PASSIVES-----------
-------------------------------------

Air_Force = 
{
	Name = "Air Support: Strike",
	Description = "Deals 1 damage and pushes all adjacent squares",
	Skill = "Structure_Force"
}

Air_Repair = 
{
	Name = "Air Support: Repair",
	Description = "Heal all player units (including disabled Mechs)",
	Skill = "Structure_Repair"
}

CombatPass_Shield = {
	Name = "Invincibility",
	Description = "All player units are invulnerable until the first building is damaged in a mission."
}

CombatPass_Defense = {	
	Name = "Emergency Shields",
	Description = "When a building tile is damaged, but not destroyed, it is Shielded."
}

CombatPass_ShieldStart = {
	Name = "Mech Shielding",
	Description = "Mechs start every battle with a Shield"
}

CombatPass_Acid = {
	Name = "Acidic Blast",
	Description = "Inflict acid on a random enemy at the start of each battle"
}

CombatPass_Fire = {
	Name = "Flame Blast",
	Description = "Inflict fire on a random enemy at the start of each battle"
}

--Code Broke, taken out for now
--[[CombatPass_Emergency = {
	Name = "Energy Reserves",
	Description = "Survive game ending Power Grid damage (once per battle)"
}]]--

CombatPass_Reduce = {
	Name = "Grid Defenses",
	Description = "Power Grid Defense +10"
}