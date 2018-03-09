
TILE_TOOLTIPS = {
	fire = {"Fire Tile", "Lights units on Fire."},
	forest = {"Forest Tile", "If damaged, lights on Fire."},
	forest_fire = {"Forest Fire", "Lights units on Fire. This fire was started when a Forest Tile was damaged."},
	smoke = {"Smoke Tile", "Units in Smoke cannot attack or repair."},
	electric_smoke = {"Electric Smoke", "Units in Smoke cannot attack or repair. \nElectricity damages enemy units."},
	emerging = { "Vek Emerging", "Enemy emerging next turn. Can be blocked."},
	critical = { "Critical", "This building is important to mission objectives." },
	pylon = { "Power Pylon", "Remote Power Pylons connect your Mechs to the Grid even underground. Not populated."},
	supervolcano = { "Super Volcano", "Indestructible volcano that blocks movement and projectiles."},
	powered = { "Civilian Building", "Your Power Grid is reduced when Grid Structures are damaged." },
	evacuated = { "Evacuated Building", "No effect when damaged." },
	building_rubble = { "Building Rubble", "No special effect." },
	mnt_rubble = {"Mountain Rubble", "No special effect." },
	ice = {"Ice Tile", "Turns into Water when destroyed. Must be hit twice."},
	acid_ice = {"A.C.I.D. Ice", "Turns into an A.C.I.D. tile when destroyed, but currently safe to stand on."},
	lava_ice = {"Frozen Lava", "Turns into a Lava tile when destroyed, but currently safe to stand on."},
	damaged_ice = {"Damaged Ice Tile", "Turns into a Water tile when destroyed. One hit will destroy it."},
	chasm = {"Chasm Tile", "Ground units pushed in will be \ndestroyed."},
	ground = { "Ground Tile", "No special effect."},
	sand = { "Sand Tile", "If damaged, turns into Smoke. \nUnits in Smoke cannot attack or repair." },
	mountain = { "Mountain Tile", "Blocks movement and projectiles. Damage twice to destroy." },
	damaged_mountain = { "Damaged Mountain", "Blocks movement and projectiles. One hit will destroy it." },
	water = { "Water Tile", "Units cannot attack in Water. Most non-flying enemies die in Water."},
	acid_water = { "A.C.I.D. Tile", "Behaves like Water, but inflicts A.C.I.D. on surviving units."},
	lava = {"Lava Tile", "Behaves like Water, but inflicts Fire on surviving units."},
	acid = { "A.C.I.D. Pool", "Inflicts A.C.I.D. on the 1st unit that steps on this space."},
	frozen_acid = { "Frozen A.C.I.D.", "Low temperatures have rendered the A.C.I.D. on this tile inert."},
	pod = {"Time Pod", "Destroyed if damaged or trampled by the enemy. Collect with a Mech, or defend until Vek retreat."},
	ftl_pod = {"Strange Pod", "Destroyed if damaged or trampled by the enemy. Collect with a Mech, or defend until Vek retreat."},
	ftl_button = {"Strange Object", "You're not sure what this could be."},
	ftl_button_destroyed = {"Destroyed Object", "You're not sure what this was, but it's gone now."},
	frozen_powered = { "Frozen Building", "Invincible while Frozen. Any damage will destroy the ice." },
	spawning = {"Emerging", "Vek will emerge here next turn. Any unit blocking this space will take one damage."},
	high_tide = {"High Tide","This tile will become Water at the start of the enemy turn."},
	air_strike = {"Air Strike", "Bombs will be dropped here, instantly killing any unit."},
	old_earth_mine = {"Old Earth Mine", "Any unit that stops on this space will trigger the mine and be killed."},
	freeze_mine = {"Freeze Mine", "Any unit that stops on this space will be Frozen."},
	evacuation = {"Evacuating", "This building will be evacuated \nnext turn."},
	seismic = {"Seismic Activity", "This tile will become a Chasm at the start of the enemy turn."},
	lightning = {"Lightning Strike", "Lightning will strike here, killing any unit."},
	falling_rock = {"Falling Rock", "A rock will fall here, killing any unit."},
	tentacle_lava = {"Tentacles", "The unit here will die and the tile will turn into Lava."},
	volcano_lava = {"Lava Flow", "The tile here will turn into Lava."},
	flying_rock = {"Volcanic Projectile", "A fireball will strike here, destroying anything present."},
	ice_storm = {"Ice Storm", "The storm causes anything present to become Frozen."},
	grassland = {"Grassland", "Your bonus objective is to terraform Grassland tiles into Sand."},
	terraformed = {"Terraformed", "This tile was terraformed as part of your bonus objective."},
	stasis = {"Stasis Bot", "This bot will power up and enter the fight if its Shield is damaged."},
	
	belt = {"Conveyor Belt", "This tile will push any unit in the direction marked on the belt."},
	
	tele = {"Teleporter Pad", "End movement here to warp to the matching pad. Swap with any present unit."},
	
	supply_drop = { "Supply Drop", "Collect this with a Mech to heal ALL friendly units and restore ALL limited use weapons." },	
}

local STATUS_TOOLTIPS = {
	flying = {"Flying", "Flying units can move over any terrain tile."},
	hp = {"Invigorating Spores", "The Soldier Psion is providing +1 HP to all Vek."},
	burrow = {"Burrower", "This Vek will hide underground after taking one or more damage."},
	psionboss = { "Overpowered", "The Psion Abomination is enhancing all Vek. They gain +1 HP, regeneration, and explode on death."},
	tentacle = { "Hive Targeted", "The Psion Tyrant will do 1 damage all friendly units every turn."},
	armor_leader = {"Hardened Carapace", "The Shell Psion is providing Armor to all Vek, reducing incoming weapon damage by 1. All other damage (Push, Blocking, Fire, etc.) is unaffected."},
	armor = {"Natural Armor", "Weapon damage to this unit is reduced by 1. All other damage (Push, Blocking, Fire, etc.) is unaffected."},
	armor_degraded = {"Degraded Armor", "A.C.I.D. is currently nullifying the effects of Armor on this unit."},
	regen = {"Regeneration", "The Blood Psion is healing all Vek 1 point every turn."},
	explode_leader = {"Explosive Decay", "The Blast Psion will cause all Vek to explode on death, dealing 1 damage to adjacent tiles."},
	explode = {"Explosive Decay", "Explodes on death, dealing 1 damage to adjacent tiles."}, --was Innate Explosions
	arrow_0 = {"Conveyor Belt", "This unit will be pushed by the conveyor belt in the marked direction."},
	arrow_1 = {"Conveyor Belt", "This unit will be pushed by the conveyor belt in the marked direction."},
	arrow_2 = {"Conveyor Belt", "This unit will be pushed by the conveyor belt in the marked direction."},
	arrow_3 = {"Conveyor Belt", "This unit will be pushed by the conveyor belt in the marked direction."},
	tele_A = {"Teleporter Pad", "If another unit uses the RED teleport pad, this unit will swap locations with it."},
	tele_B = {"Teleporter Pad", "If another unit uses the BLUE teleport pad, this unit will swap locations with it."},
	moving = {"Move Bonus", "+2 Move for ONE turn."},
	grapple = {"Webbed", "Units Webbed by the Vek cannot move, but they can still attack."},
	poweroff = {"Not Powered", "Units without power are inactive and cannot move or attack."},
	massive = {"Massive", "Massive units can walk in Water (but Water will prevent shooting)."},
	water = {"Submerged", "Weapons do not work when submerged in Water."},
	acid_water = { "Submerged in A.C.I.D.", "Weapons do not work and the submerged Mech is inflicted with A.C.I.D."},
	lava = { "Submerged in Lava", "Weapons do not work and the submerged Mech is on Fire."},
	fire = {"Fire", "Units on Fire take 1 damage at the start of every turn."},
	forest = {"On Forest", "Tile will light on Fire when damaged, posing great risk to this unit."},
	sand = {"On Sand", "Tile will turn into Smoke when damaged, preventing this unit from attacking."},
	ice = {"On Ice", "If an Ice tile takes damage twice, it will turn into Water."},
	icecrack = {"On Damaged Ice", "Damaged Ice will turn into Water if damaged again."},
	acid = {"Corroding A.C.I.D.", "Weapon damage against this unit is doubled. All other damage (Push, Blocking, Fire, etc.) is unaffected."},
	spawnblock = {"Blocking Spawn", "The new enemy unit will not spawn here, but this unit will take 1 damage."},
	smoke = {"Smoke", "Units in Smoke cannot attack or repair."},
	electric_smoke = {"Electric Smoke", "Units in Smoke cannot attack or repair. Electricity damages enemy units."},
	shield = {"Energy Shield", "Shields block damage and any negative effects (Fire, Freezing, A.C.I.D, etc.). Only direct damage will remove the Shield."},
	zoltan_shield = {"Zoltan Shield", "Same as a normal Shield, but regenerates at the start of every turn"},
	guard = {"Stable", "Cannot be moved by any weapon effect (Push, Teleport, etc.)."},
	frozen = {"Frozen", "Invincible but unable to move or attack. Any damage will free the unit."},
	kickoff = {"Kickoff Boosters", "+2 Move this turn."},
	shifty = {"Sidestep", "(Pilot Skill) This unit gets one bonus Tile move after attacking."},
	youthful = {"Impulsive", "This unit gains +3 Move on first turn of every mission."},
	doubleshot = {"Double Shot", "(Pilot Skill) This unit gets a bonus action because it did not move."}, 
	postmove = {"Fire-and-Forget", "(Pilot Skill) This unit can move after shooting."},
	fire_immune = {"Fire Immunity", "This unit cannot be set on Fire"},
	smoke_immune = {"Smoke Immunity", "This unit is unaffected by Smoke"},
	shield_heal = {"Self-Repairing", "If damaged, this unit will Shield itself and prepare to heal."},
	danger = {"Environment Danger", "The environment effect will affect this space next turn"},
	purple = {"Alpha Unit", "Alpha units are more powerful than their standard counterparts"},
	boss = {"Hive Leader", "These are the most powerful Vek. Immune to water, they can be more challenging to kill."},

}

local PilotSkills = {
	Disable_Immunity = PilotSkill("Evasion","Mech unaffected by Webbing and Smoke."),
	Extra_XP = PilotSkill("Experienced","Gain +2 bonus XP\nper kill."),
	Self_Shield = PilotSkill("Starting Shield","Mech starts every mission with a Shield."),
	Road_Runner = PilotSkill("Maneuverable","Mech can move through enemy units."),
	Shifty = PilotSkill("Sidestep","After attacking, gain 1 free tile movement."),
	Deploy_Anywhere = PilotSkill("Preemptive Strike", "Deploy anywhere on the map, damaging adjacent enemies."),
	Survive_Death = PilotSkill("Vek", "Normal Pilots cannot be equipped. Loses 25 XP when the unit is disabled."),
	Pain_Immunity = PilotSkill("Cauterize", "Fire heals instead of damaging Mech."),
	Power_Repair = PilotSkill("Frenzied Repair", "Push adjacent tiles when repairing."),
	Freeze_Walk = PilotSkill("Frozen Stance", "Stopping on any liquid tile freezes it, making it safe to stand on."),
	Armored = PilotSkill("Armored", "Mech gains Armored."),
	Flying = PilotSkill("Flying", "Mech gains Flying."),
	Double_Shot = PilotSkill("Double Shot", "Mech can act twice if it does not move."),
	Post_Move = PilotSkill("Fire-and-Forget", "Move again after shooting."),
	Youth_Move = PilotSkill("Impulsive", "Gain +3 Move on first turn of every mission."),
	Retaliation = PilotSkill("Retaliation", "Deal 1 damage to adjacent enemies after surviving damage."),
	TimeTravel = PilotSkill("Temporal Reset", "Gain 1 extra 'Reset Turn' every battle."),
	Mantis_Skill = PilotSkill("Mantis", "2 damage melee attack replaces Repair."),
	Rock_Skill = PilotSkill("Rockman", "+3 Health and\nImmune to Fire."),
	Zoltan_Skill = PilotSkill("Zoltan", "+1 Reactor Core.\nReduce Mech HP to 1.\nGain Shield every turn."),
}

function GetSkillInfo(skill)
	if skill == "" then return PilotSkill() end
	return PilotSkills[skill]
end

function GetTileTooltip(id)
	if TILE_TOOLTIPS[id] ~= nil then
		return TILE_TOOLTIPS[id]
	else
		return { id, "NOT FOUND"}
	end
end

function GetStatusTooltip(id)
	if STATUS_TOOLTIPS[id] ~= nil then
		return STATUS_TOOLTIPS[id]
	else
		return { id, "NOT FOUND"}
	end
end