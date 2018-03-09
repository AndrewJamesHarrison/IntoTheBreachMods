
TILE_TOOLTIPS = {
	fire = {"Fire Tile", "Lights units on Fire."},
	forest = {"Forest Tile", "If damaged, lights on Fire."},
	forest_fire = {"Forest Fire", "Lights units on Fire. Forest tile was damaged, which started this fire."},
	smoke = {"Smoke Tile", "Units in smoke cannot attack or repair."},
	electric_smoke = {"Electric Smoke", "Units in smoke cannot attack or repair. \nElectricity damages enemy units."},
	emerging = { "Vek Emerging", "Enemy emerging next turn. Can be blocked."},
	critical = { "Critical", "This building is important to mission objectives." },
	pylon = { "Power Pylon", "Remote Power Pylons connect your Mechs to grid even underground. Not populated"},
	powered = { "Civilian Building", "Your Power Grid is reduced when Grid Structures are damaged." },
	evacuated = { "Evacuated Building", "No effect when damaged." },
	building_rubble = { "Building Rubble", "No special effect." },
	mnt_rubble = {"Mountain Rubble", "No special effect." },
	ice = {"Ice Tile", "Turns into Water when destroyed. Must be hit twice."},
	acid_ice = {"A.C.I.D. Ice", "Turns into an A.C.I.D. tile when destroyed, but currently safe to stand on"},
	lava_ice = {"Frozen Lava", "Turns into a Lava tile when destroyed, but currently safe to stand on"},
	damaged_ice = {"Damaged Ice Tile", "Turns into Water when destroyed. One hit will destroy it."},
	chasm = {"Chasm Tile", "Ground units pushed in will be \ndestroyed."},
	ground = { "Ground Tile", "No special effect" },
	sand = { "Sand Tile", "If damaged, turns into Smoke. \nUnits in Smoke cannot attack or repair." },
	mountain = { "Mountain Tile", "Blocks movement and projectiles. Hit twice to destroy." },
	damaged_mountain = { "Damaged Mountain", "Blocks movement and projectiles. One hit will destroy it." },
	water = { "Water Tile", "Units cannot attack in Water. Most non-flying enemies die in Water."},
	acid_water = { "A.C.I.D. Tile", "Behaves like Water, but inflicts A.C.I.D. on surviving units."},
	lava  = {"Lava Tile", "Behaves like Water, but inflicts Fire on surviving units."},
	acid = { "A.C.I.D. Pool", "Inflicts A.C.I.D. on the first unit that steps on this space."},
	frozen_acid = { "Frozen A.C.I.D.", "Low temperatures have rendered the A.C.I.D. on this tile inert."},
	pod = {"Time Pod", "Destroyed if damaged or trampled by the enemy. Collect with a Mech, or defend until Vek retreat."},
	frozen_powered = { "Frozen Building", "Invincible while Frozen. Any damage will destroy the ice." },
	
	high_tide = {"High Tide","This tile will become Water at the start of the enemy turn."},
	air_strike = {"Air Strike", "Bombs will be dropped here, instantly killing any unit"},
	old_earth_mine = {"Old Earth Mine", "Any unit that stops on this space will trigger the mine, taking 4 damage."},
	freeze_mine = {"Freeze Mine", "Any unit that stops on this space will be Frozen."},
	evacuation = {"Evacuating", "This building will be evacuated \nnext turn."},
	seismic = {"Seismic Activity", "This tile will become a Chasm at the start of the enemy turn."},
	lightning = {"Lightning Strike", "Lightning will strike here, killing any unit"},
	falling_rock = {"Falling Rock", "A rock will strike here, killing any unit"},
	tentacle_lava = {"Unstable Ground", "This tile will turn into lava"},
	ice_storm = {"Ice Storm", "The storm causes anything present to become Frozen."},
	grassland = {"Grassland", "Your bonus objective is to terraform Grassland tiles into Sand"},
	stasis = {"Stasis Bot", "This bot will power up and enter the fight if its shield is damaged"},
	
	belt = {"Conveyor Belt", "This tile will push any unit in the direction marked on the belt."},
	
	tele = {"Teleporter Pad", "End movement here to warp to the other teleporter pad of the same color."},
	
	supply_drop = { "Supply Drop", "Collect this with a mech to heal ALL friendly units and restore ALL limited use weapons" }
	
}

local STATUS_TOOLTIPS = {
	flying = {"Flying", "Flying units can move over any terrain tile."},
	hp = {"Healthy Psion", "The Vek Psion present is providing +1 HP"},
	psionboss = { "Super Psion", "The Psion Boss is enhancing all Vek. They have +1 HP and Regeneration, and will explode on death."},
	armor_leader = {"Psion Armor", "This reduces incoming weapon damage by 1. All other damage (Push, Blocking, Fire, etc.) is unaffected."},
	armor = {"Natural Armor", "Weapon damage to this unit is reduced by 1. All other damage (Push, Blocking, Fire, etc.) is unaffected."},
	armor_degraded = {"Degraded Armor", "A.C.I.D. is currently nulling the effects of Armor on this unit"},
	regen = {"Regen Psion", "The Vek Psion present is Regeneration, healing enemy units 1 point every turn."},
	explode_leader = {"Explosion Psion", "The Vek Psion present will cause enemies to explode on death, dealing 1 damage to adjacent tiles."},
	explode = {"Innate Explosions", "This unit will explode on death, dealing 1 damage to adjacent tiles."},
	arrow_0 = {"Conveyor Belt", "This unit will be pushed by the conveyor belt in the marked direction."},
	arrow_1 = {"Conveyor Belt", "This unit will be pushed by the conveyor belt in the marked direction."},
	arrow_2 = {"Conveyor Belt", "This unit will be pushed by the conveyor belt in the marked direction."},
	arrow_3 = {"Conveyor Belt", "This unit will be pushed by the conveyor belt in the marked direction."},
	tele_A = {"Teleporter Pad", "If another unit uses the RED teleport pad, this unit will swap locations with it."},
	tele_B = {"Teleporter Pad", "If another unit uses the BLUE teleport pad, this unit will swap locations with it."},
	moving = {"Move Bonus", "+2 Move for ONE turn"},
	grapple = {"Webbed", "Units Webbed by the Vek cannot move, but they can still attack."},
	poweroff = {"Not Powered", "Units without power are inactive and cannot move or attack."},
	massive = {"Massive", "Massive units can walk in Water (but Water will prevent shooting)"},
	water = {"Submerged", "Weapons do not work when submerged in Water"},
	acid_water = { "Submerged in A.C.I.D.", "Weapons do not work and the submerged Mech is inflicted with A.C.I.D."},
	lava = { "Submerged in Lava", "Weapons do not work and the submerged Mech inflicted with Fire"},
	fire = {"Fire", "Units on Fire take one damage at the start of every turn."},
	forest = {"On Forest", "Tile will light on Fire when damaged, posing great risk to this unit."},
	sand = {"On Sand", "Tile will turn into Smoke when damaged, preventing this unit from attacking."},
	ice = {"On Ice", "If an Ice tile takes damage twice, it will turn into Water."},
	icecrack = {"On Damaged Ice", "Damaged Ice will turn into Water if damaged again."},
	acid = {"Corroding A.C.I.D.", "Weapon damage against this unit is doubled. All other damage (Push, Blocking, Fire, etc.) is unaffected."},
	spawnblock = {"Blocking Spawn", "The new enemy unit will not spawn here, but this unit will take one damage."},
	smoke = {"Smoke", "Units in Smoke cannot attack or repair. "},
	electric_smoke = {"Electric Smoke", "Units in Smoke cannot attack or repair. Electricity damages enemy units."},
	shield = {"Shield", "Shields will block incoming damage one time, and are then removed."},
	guard = {"Stable", "Cannot be moved by any weapon effect (Push, Teleport, etc.)"},
	frozen = {"Frozen", "Invincible but unable to move or attack. Any damage will release the unit."},
	powerup = {"Kickoff Boosters", "+2 Movement this turn"},
	shifty = {"Shifty", "This unit earned one bonus movement after attacking"},
	youthful = {"Youthful Energy", "+3 Movement on the first turn in combat."},
}

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