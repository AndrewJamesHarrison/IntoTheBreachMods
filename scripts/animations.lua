
--------------------------------------------------------------
---- Base Animation data, don't touch me please --------------
--------------------------------------------------------------
Animation =	{
	Image = "nullResource.png",
	NumFrames = 1,
	Time = 1.0,
	Loop = false,
	Layer = LAYER_SKY, --not always relevant
	PosX = 0,
	PosY = 0,
	Sound = ""
}

CreateClass(Animation)

ANIMS = {}
ANIMS.MechColors = GetColorCount()
ANIMS.Animation = Animation
ANIMS.LAYER_BACK = LAYER_BACK
ANIMS.LAYER_FRONT = LAYER_FRONT
ANIMS.LAYER_SKY = LAYER_SKY
ANIMS.LAYER_FLOOR = LAYER_FLOOR
setfenv(1, ANIMS)

---------------------------------------------------------------
---------------------------------------------------------------

SingleImage = Animation:new{Loop = true}


--- Pilot animations ---

Pilot_Look = Animation:new{
	Image = "portraits/pilots/Pilot_Original_glare.png",
	NumFrames = 6,
	Loop = false,
	Frames = {0,2,0,1,0},
	Lengths = {0.1, 0.2, 0.05, 0.25, 1.2},
	PosX = 0,
	PosY = 0
}

Pilot_Grimace = Animation:new{
	Image = "portraits/pilots/Pilot_Original_glare.png",
	NumFrames = 6,
	Loop = false,
	Lengths = {1.2,0.04,0.04,1,0.02},
	Frames = {0,3,4,5,3},
	PosX = 0,
	PosY = 0
}

Pilot_Blink = Animation:new{
	Image = "portraits/pilots/Pilot_Original_blink.png",
	NumFrames = 4,
	Loop = false,
	Lengths = {1, 0.04, 0.1, 0.04},
	PosX = 0,
	PosY = 0
}

Pilot_TimeTravel = Animation:new{
	Image = "effects/timetravel_portrait.png",
	NumFrames = 10,
	Time = 0.08,
	Loop = false,
	PosX = 0,
	PosY = 0
}

Pilot_TimeTravelDamaged = Pilot_TimeTravel:new{
	Image = "effects/timetravel_portrait2.png",
}

---------------------------------------------------------------
----------------Board Space Animations-------------------------
---------All positions are relative to space location----------
---------------------------------------------------------------

------- Tile Effects

FireBack = Animation:new{
	Image = "combat/fire_strip4.png",
	NumFrames = 4,
	Time = 0.19,
	Loop = true,
	PosX = -31,
	PosY = -6
}

FireForest = FireBack:new({Image = "combat/fire_forest_strip4.png"})

FireFront = FireBack:new{ Image = "combat/firefront_strip4.png" }

FireBack_cb = FireBack:new{Image = "combat/fire_strip4_cb.png"}
FireForest_cb = FireForest:new({Image = "combat/fire_forest_strip4_cb.png"})
FireFront_cb = FireFront:new{ Image = "combat/firefront_strip4_cb.png" }

Mech_TimeTravel = Animation:new{
	Image = "effects/timetravel.png",
	NumFrames = 19,
	Loop = false,
	PosX = -32,
	PosY = -145,
}

local timetravel_delay = 4.5 - 0.08*18

Mech_TimeTravel.Lengths = {}

for i = 1, 19 do
	if i == 1 then
		Mech_TimeTravel.Lengths[i] = timetravel_delay
	else
		Mech_TimeTravel.Lengths[i] = 0.08
	end
end

PsionAttack_Back = Animation:new{
	Image = "effects/psionattack_back.png",
	NumFrames = 9,
	Loop = false,
	Lengths = {0.04,0.04,0.04,0.04,0.2,.12,.12,0.09,0.08,0.07},
	PosX = -32,
	PosY = -8,
	Layer = LAYER_BACK
}

PsionAttack_Front = PsionAttack_Back:new{
	Image = "effects/psionattack_front.png",
	Layer = LAYER_FRONT,
	PosX = -23,
	PosY = -8,
}

Waterfall = Animation:new{
	NumFrames = 3,
	Time = 0.19,
	Loop = true,
}

--Perspective of the hole
Waterfall_D = Waterfall:new{
	Image = "combat/tiles_grass/waterfall_U.png", PosX = -28, PosY = 25 
}

Waterfall_L = Waterfall:new{
	Image = "combat/tiles_grass/waterfall_R.png", PosX = -27, PosY = 7
}

Waterfall_U = Waterfall:new{
	Image = "combat/tiles_grass/waterfall_D.png", PosX = -11, PosY = 7
}

Waterfall_R = Waterfall:new{
	Image = "combat/tiles_grass/waterfall_L.png", PosX = -10, PosY = 25
}

IceBlock_Emerge = Animation:new{
	Image = "combat/iceblock_emerge.png", PosX = -27, PosY = -14, NumFrames = 11, Time = 0.05, Loop = false
}

IceBlock_Death = Animation:new{
	Image = "combat/iceblock_death.png", PosX = -47, PosY = -19, NumFrames = 13, Time = 0.09, Loop = false 
}

Tentacle_Grab = Animation:new{
	Image = "effects/tentaclegrab.png", PosX = -29, PosY = -8, NumFrames = 20, Time = 0.09, Loop = false, Layer = LAYER_BACK,
	Lengths = {0.04,0.04,0.04,0.04,0.09,0.09,0.09,0.04,0.04,0.04,0.09,0.09,0.09,0.09,0.09,0.09,0.09,0.09,0.09,0.5},
}

Tentacle_Grab_Front = Tentacle_Grab:new{
	Image = "effects/tentaclegrab_front.png", Layer = LAYER_FRONT,
}

Shadow_Falling = Animation:new{
	Image = "combat/fall_shadow.png", NumFrames = 6
}

Shield_Emerge = Animation:new{
	Image = "combat/shield_front_turnon.png", PosX = -23, PosY = -4, NumFrames = 7, Time = 0.05, Loop = false 
}

Shield_Death = Shield_Emerge:new{ Image = "combat/shield_front_turnoff.png" }

Shield_Emerge2 = Shield_Emerge:new{Image = "combat/shield2_front_turnon.png", PosX = -26, PosY = -15}

Shield_Death2 = Shield_Emerge2:new{ Image = "combat/shield2_front_turnoff.png" }

Shield_Tall_Emerge = Shield_Emerge:new{Image = "combat/shieldhq_turnon.png", PosX = -23, PosY = -33 }

Shield_Tall_Death = Shield_Tall_Emerge:new{Image = "combat/shieldhq_turnoff.png" }

Shield_Train_Emerge = Shield_Emerge:new{Image = "combat/shieldtrain_turnon.png", PosX = -51, PosY = -6}

Shield_Train_Death = Shield_Train_Emerge:new{ Image = "combat/shieldtrain_turnoff.png" }

Shield_Dam_Emerge = Shield_Emerge:new{Image = "combat/shielddam_turnon.png", PosX = -25, PosY = -8}

Shield_Dam_Death = Shield_Dam_Emerge:new{ Image = "combat/shielddam_turnoff.png" }

Hold_Break = Animation:new{
	Image = "effects/hold_break.png", NumFrames = 7, Loop = false, Time = 0.07, PosX = -26, PosY = 9
}

Hold_Anim = Animation:new{ Time = 0.07, NumFrames = 4, Loop = false, Layer = LAYER_BACK,}

Hold_0 = Hold_Anim:new{
	Image = "effects/hold_0_death.png", PosX = -7, PosY = 2
}
Hold_1 = Hold_Anim:new{
	Image = "effects/hold_1_death.png", PosX = -7, PosY = 22
}
Hold_2 = Hold_Anim:new{
	Image = "effects/hold_2_death.png", PosX = -34, PosY = 22
}
Hold_3 = Hold_Anim:new{
	Image = "effects/hold_3_death.png", PosX = -31, PosY = -1
}

Hold_Anim_Emerge = Hold_Anim:new{Time = 0.075}

Hold_0_Emerge = Hold_Anim_Emerge:new{
	Image = "effects/hold_0_emerge.png", PosX = -8, PosY = 1
}
Hold_1_Emerge = Hold_Anim_Emerge:new{
	Image = "effects/hold_1_emerge.png", PosX = -8, PosY = 21
}
Hold_2_Emerge = Hold_Anim_Emerge:new{
	Image = "effects/hold_2_emerge.png", PosX = -35, PosY = 21
}
Hold_3_Emerge = Hold_Anim_Emerge:new{
	Image = "effects/hold_3_emerge.png", PosX = -32, PosY = -2
}

Hold_Off = Animation:new{
	Image = "effects/hold_death.png", 
	NumFrames = 8,
	Loop = false, 
	Time = 0.07, 
	Lengths = {0.07,0.07,0.07,0.07,0.07,0.07,0.07,Hold_Anim_Emerge.Time*4},--account for growth in reverse mode
	PosX = -17, 
	PosY = 12
}

Tentacle_Hit = Animation:new{
	Image = "units/aliens/infest_throw_1.png",
	NumFrames = 1,
	Loop = false,
	Time = 1,
	PosX = -29,
	PosY = -23,
}

Lightning_Hit = Animation:new{
	Image = "effects/laser_elec_hit.png",
	Time = 0.5, Loop = false, NumFrames = 1,
	PosX = -12,
	PosY = 3
}

Lightning_Attack = Animation:new{
    NumFrames = 1, Loop = false, Time = 0.5
}
--right
Lightning_Attack_1 = Lightning_Attack:new{
	Image = "effects/laser_elec_R.png",
	PosX = -12 - 28/2, 
	PosY = 3 - 21/2
}

--left
Lightning_Attack_3 = Lightning_Attack:new{
	Image = "effects/laser_elec_R.png",
	PosX = -12 + 28/2,
	PosY = 3 + 21/2
}

--up
Lightning_Attack_0 = Lightning_Attack:new{
	Image = "effects/laser_elec_U.png",
	PosX = -12 - 28/2,
	PosY = 3 + 21/2
}

--down
Lightning_Attack_2 = Lightning_Attack:new{
	Image = "effects/laser_elec_U.png",
	PosX = -12 + 28/2,
	PosY = 3 - 21/2
}

CreepBack = Animation:new{
	Image = "combat/creep_strip4.png",
	NumFrames = 4,
	Time = 0.25,
	Loop = true,
	
	PosX = -31,
	PosY = -2
}

CreepBackStart = CreepBack:new{ Image = "combat/creep_starting.png", NumFrames = 1 }

CreepFront = CreepBack:new{ Image = "combat/creepfront_strip4.png", PosY = 21 }

CreepFrontStart = CreepBack:new{ Image = "combat/creepfront_starting.png", NumFrames = 1 }

Conveyor_0 = Animation:new{
	Image = "combat/conveyor0a.png",
	NumFrames = 7,
	PosX = -28, PosY = 1,
	Loop = false,
	Time = 0.06,
	Layer = LAYER_FLOOR,
	Test = "Hello",
}

Conveyor_1 = Conveyor_0:new{Image = "combat/conveyor1a.png"} 
Conveyor_2 = Conveyor_0:new{Image = "combat/conveyor2a.png"} 
Conveyor_3 = Conveyor_0:new{Image = "combat/conveyor3a.png"} 

QueuedShot = Animation:new{ 	
	Image = "combat/warningstripes.png", 
	NumFrames = 6,
	PosX = -27, 
	PosY = 2, 
	Loop = true,
	Time = 0.3 
}

UnitFire0 = Animation:new{
	Image = "effects/fire_unit_1.png",
	NumFrames = 4,
	Loop = true,
	Time = 0.2
}

UnitFire1 = UnitFire0:new{ Image = "effects/fire_unit_2.png" }

UnitFire0_cb = UnitFire0:new{Image = "effects/fire_unit_1_cb.png",}
UnitFire1_cb = UnitFire1:new{ Image = "effects/fire_unit_2_cb.png" }

UnitAcid0 = Animation:new{
	Image = "effects/acid_unit_1.png",
	NumFrames = 6,
	Loop = true,
	Time = 0.2
}

UnitAcid1 = UnitAcid0:new{ Image = "effects/acid_unit_2.png", Time = 0.22}


SmokeAppear = Animation:new{
	Image = "effects/smoke_appear.png",
	NumFrames = 6,
	Loop = false,
	Time = 0.04,
	PosX = -23,
	PosY = 0,
}

SmokeFront = Animation:new{
	Image = "effects/smoke_front.png",
	NumFrames = 6,
	Loop = true,
	PosX = -23,
	PosY = 0,
	Time = 0.4 
}

SmokeBack = SmokeFront:new{
	Image = "effects/smoke_back.png",
}

SmokeOutline = SmokeFront:new{
	Image = "effects/smoke_back_OL.png",
}

SmokeFront_Electric = SmokeFront:new{
	NumFrames = 12,
	Image = "effects/smoke_electric_front.png",
}

SmokeBack_Electric = SmokeBack:new{
	NumFrames = 12,
	Image = "effects/smoke_electric_back.png",
}

Emerge = Animation:new{
	Image = "combat/emerge_loop.png",
	NumFrames = 6,
	Loop = true,
	PosX = -27,
	PosY = 0,
	Time = 0.1
}

EmergeStart  = Animation:new{
	Image = "combat/emerge_intro.png",
	NumFrames = 4,
	Loop = false,
	PosX = -27,
	PosY = 0,
	Time = 0.1
}

Water = Animation:new{
	Image = "combat/tiles_grass/water_anim.png",
	NumFrames = 5,
	Loop = true,
	PosX = -28,
	PosY = 1,
	Time = 0.4
}

AcidTile = Animation:new{
	Image = "combat/acid_front1.png",
	NumFrames = 12,
	Loop = true,
	PosX = -20,
	PosY = 11,
	Time = 0.19
}

BuildingA_Collapse = Animation:new{
	Image = "combat/tiles_grass/building_collapse.png",
	NumFrames = 12,
	Time = 0.13
}	

Building4A_Collapse0 = BuildingA_Collapse:new{ PosX = -15, PosY = -14 }
Building4A_Collapse1 = BuildingA_Collapse:new{ PosX = -3, PosY = -7 }
Building4A_Collapse2 = BuildingA_Collapse:new{ PosX = -27, PosY = -7 }
Building4A_Collapse3 = BuildingA_Collapse:new{ PosX = -15, PosY = 1}

Building3A_Collapse0 = BuildingA_Collapse:new{ PosX = -13, PosY = -17}
Building3A_Collapse1 = BuildingA_Collapse:new{ PosX = -10, PosY = -3}
Building3A_Collapse2 = BuildingA_Collapse:new{ PosX = -27, PosY = -8}

Building2A_Collapse0 = BuildingA_Collapse:new{ PosX = -25, PosY = -10}
Building2A_Collapse1 = BuildingA_Collapse:new{ PosX = -4, PosY = -7}

Building1A_Collapse0 = BuildingA_Collapse:new{ PosX = -25, PosY = -7 }

tiles_lava_AddBuilding = Animation:new{
	PosX = -21, PosY = -6, Image = "combat/tiles_grass/building_emerge.png", Loop = false, NumFrames = 10, 
	Lengths = {1.5, 0.1, 0.1, 0.1, 0.1,0.1,0.1,0.1,0.1,0.1,},
	Layer = LAYER_BACK
}

tiles_volcano_AddBuilding = tiles_lava_AddBuilding

Cave_Tentacle = Animation:new{
	PosX = 0, PosY = 0, Loop = true, Time = 0.1, NumFrames = 6
}

Cave_Tentacle_1 = Cave_Tentacle:new{Image = "combat/tiles_lava/bg_tile_1_a.png", Time = 0.12}
Cave_Tentacle_2 = Cave_Tentacle:new{Image = "combat/tiles_lava/bg_tile_2_a.png", Time = 0.13}
Cave_Tentacle_3 = Cave_Tentacle:new{Image = "combat/tiles_lava/bg_tile_3_a.png", Time = 0.09}
Cave_Tentacle_end = Cave_Tentacle:new{Image = "combat/tiles_lava/bg_tile_end_a.png", Time = 0.15}

Cave_Tentacle_Emerge = Animation:new{
	PosX = 0, PosY = 0, Loop = false, Time = 0.13, NumFrames = 7
}

Cave_Tentacle_1_e = Cave_Tentacle_Emerge:new{Image = "combat/tiles_lava/bg_tile_1_e.png"}
Cave_Tentacle_2_e = Cave_Tentacle_Emerge:new{Image = "combat/tiles_lava/bg_tile_2_e.png"}
Cave_Tentacle_3_e = Cave_Tentacle_Emerge:new{Image = "combat/tiles_lava/bg_tile_3_e.png"}
Cave_Tentacle_end_e = Cave_Tentacle_Emerge:new{Image = "combat/tiles_lava/bg_tile_end_e.png"}


Mountain_Collapse = Animation:new{
	Image = "combat/tiles_grass/mountain_explode.png",
	NumFrames = 13,
	Time = 0.1,
	PosX = -36,
	PosY = -12,
	Loop = false
}

LightningBolt0 = Animation:new{
	Image = "effects/lightning_bolt0.png",
	NumFrames = 1,
	Time = 0.8,
	PosX = -26,
	PosY = -55,
	Loop = false
}

LightningBolt1 = LightningBolt0:new{ Image = "effects/lightning_bolt1.png" }

LightningBoltBig = LightningBolt0:new{ 
	Image = "effects/lightning_big.png",
	PosX = -26,
	PosY = -90
}

----------- Explosions

ExploAir1 = Animation:new{
	Image = "effects/explo_air1.png",
	NumFrames = 8,
	Time = 0.1,
	
	PosX = -10,
	PosY = 5
}

ExploAir2 =	Animation:new{
	Image = "effects/explo_air2.png",
	NumFrames = 10,
	Time = 0.1,
	
	PosX = -30,
	PosY = -10
}

ExploArt0 = Animation:new{
	Image = "effects/explo_artillery0.png",
	NumFrames = 10,
	Time = 0.075,
	PosX = -20,
	PosY = -8
}

ExploArt1 = Animation:new{
	Image = "effects/explo_artillery1.png",
	NumFrames = 10,
	Time = 0.075,
	PosX = -20,
	PosY = -8
}

ExploArt2 = Animation:new{
	Image = "effects/explo_artillery2.png",
	NumFrames = 10,
	Time = 0.075,
	PosX = -20,
	PosY = -20
}

ExploArt3 = Animation:new{
	Image = "effects/explo_artillery3.png",
	NumFrames = 10,
	Time = 0.075,
	PosX = -20,
	PosY = -20
}

ExploRaining1 = Animation:new{
	Image = "effects/explo_raining1.png",
	NumFrames = 10,
	Time = 0.075,
	PosX = -20,
	PosY = -38
}

ExploRaining2 = Animation:new{
	Image = "effects/explo_raining2.png",
	NumFrames = 10,
	Time = 0.075,
	PosX = -20,
	PosY = -40
}

ExploRaining3 = Animation:new{
	Image = "effects/explo_raining3.png",
	NumFrames = 10,
	Time = 0.075,
	PosX = -20,
	PosY = -51
}



ExploArtCrab2 = Animation:new{
	Image = "effects/explo_artillery_crab2.png",
	NumFrames = 10,
	Time = 0.06,
	PosX = -20,
	PosY = -20
}

PulseBlast = Animation:new{
	Image = "effects/explo_pulse1.png",
	NumFrames = 8,
	Time = 0.075,
	PosX = -40,
	PosY = -20
}

GravBlast = Animation:new{
	Image = "effects/explo_pulse2.png",
	NumFrames = 8,
	Time = 0.075,
	PosX = -40,
	PosY = -20
}

explo_fire1 = Animation:new{
	Image = "effects/explo_fire1.png",
	NumFrames = 10,
	Time = 0.075,
	PosX = -27,
	PosY = -18
}

ExploRepulse1 = Animation:new{
	Image = "effects/explo_repulse1.png",
	NumFrames = 8,
	Time = 0.05,
	
	PosX = -33,
	PosY = -14
}
ExploRepulse2 = ExploRepulse1:new{ 	Image = "effects/explo_repulse2.png" }
ExploRepulse3 = ExploRepulse1:new{ 	Image = "effects/explo_repulse3.png" }

ExplIce1 = Animation:new{
	Image = "effects/explo_ice1.png",
	NumFrames = 10,
	Time = 0.05,
	
	PosX = -22,
	PosY = -5
}

Webland1 = Animation:new{
	Image = "effects/web_land1.png",
	NumFrames = 9,
	Time = 0.1,
	PosX = -20,
	PosY = 2
}

Splash = Animation:new{
	Image = "effects/splash_1.png",
	NumFrames = 7,
	Time = 0.09,
	PosX = -26,
	PosY = -12
}
Splash_acid = Splash:new{ Image = "effects/splash_2.png" }
Splash_lava = Splash:new{ Image = "effects/splash_3.png" }

----------- Melee

SwipeClaw1 = Animation:new{
	Image = "effects/swipe_claw_1.png",
	NumFrames = 6,
	Time = 0.05,
	
	PosX = -10,
	PosY = 5
}

Swipe2Claw1 = Animation:new{
	Image = "effects/swipe_2claw_1.png",
	NumFrames = 10,
	Time = 0.055,
	
	PosX = -14,
	PosY = 0
}

SwipeClaw2 = Animation:new{
	Image = "effects/swipe_claw_2.png",
	NumFrames = 6,
	Time = 0.05,
	
	PosX = -20,
	PosY = -5
}

ExploFirefly1 = Animation:new{
	Image = "effects/explo_firefly1.png",
	NumFrames = 8,
	Time = 0.08,
	
	PosX = -22,
	PosY = 1
}

ExploFirefly2 = Animation:new{
	Image = "effects/explo_firefly2.png",
	NumFrames = 8,
	Time = 0.08,
	
	PosX = -22,
	PosY = 1
}
-------
airpush_0 = Animation:new{
	Image = "effects/airpush_U.png",
	NumFrames = 8,
	Time = 0.06,
	PosX = -10,
	PosY = -4
}

airpush_1 = airpush_0:new{
	Image = "effects/airpush_R.png",
	PosX = -10,
	PosY = 11
}

airpush_2 = airpush_0:new{
	Image = "effects/airpush_D.png",
	PosX = -30,
	PosY = 11
}

airpush_3 = airpush_0:new{
	Image = "effects/airpush_L.png",
	PosX = -30,
	PosY = -4
}
--

explopush1_0 = Animation:new{
	Image = "effects/explo_push1_U.png",
	NumFrames = 9,
	Time = 0.06,
	PosX = -5,
	PosY = 2
}

explopush1_1 = explopush1_0:new{
	Image = "effects/explo_push1_R.png",
	PosX = -4,
	PosY = 13
}

explopush1_2 = explopush1_0:new{
	Image = "effects/explo_push1_D.png",
	PosX = -20,
	PosY = 13
}

explopush1_3 = explopush1_0:new{
	Image = "effects/explo_push1_L.png",
	PosX = -22,
	PosY = 2
}
			
----
explopush2_0 = Animation:new{
	Image = "effects/explo_push2_U.png",
	NumFrames = 9,
	Time = 0.06,
	PosX = -8,
	PosY = -12
}

explopush2_1 = explopush1_0:new{
	Image = "effects/explo_push2_R.png",
	PosX = -8,
	PosY = 10
}

explopush2_2 = explopush1_0:new{
	Image = "effects/explo_push2_D.png",
	PosX = -33,
	PosY = 10
}

explopush2_3 = explopush1_0:new{
	Image = "effects/explo_push2_L.png",
	PosX = -33,
	PosY = -12
}
------
----- EXPLO OUTs - These 3 are versions of the other push animations but close to the center for things like self destruct rather than pushing
exploout0_0 = airpush_0:new{   
	PosX = -22,
	PosY = 5
}
exploout0_1 = airpush_1:new{
	PosX = -22,
	PosY = 2
}
exploout0_2 = airpush_2:new{
	PosX = -18,
	PosY = 2
}
exploout0_3 = airpush_3:new{
	PosX = -18,
	PosY = 5
}
--

exploout1_0 = explopush1_0:new{  -- Version that is closer to the center for self destructs
	PosX = -17,
	PosY = 9
}
exploout1_1 = explopush1_1:new{
	PosX = -16,
	PosY = 4
}
exploout1_2 = explopush1_2:new{
	PosX = -8,
	PosY = 4
}
exploout1_3 = explopush1_3:new{
	PosX = -10,
	PosY = 9
}
			
------
exploout2_0 = explopush2_0:new{  -- Version that is closer to the center for self destructs
	PosX = -24,
	PosY = 0
}
exploout2_1 = explopush2_1:new{
	PosX = -24,
	PosY = -6
}
exploout2_2 = explopush2_2:new{
	PosX = -17,
	PosY = -6
}
exploout2_3 = explopush2_3:new{
	PosX = -17,
	PosY = 0
}

----

ExploAcid1 = Animation:new{
	Image = "effects/explo_acid1.png",
	NumFrames = 8,
	Time = 0.07,
	PosX = -22,
	PosY = 1
}
			
---
explorocker_0 = Animation:new{
	Image = "effects/rocker_U.png",
	NumFrames = 11,
	Lengths = {0.06,0.06,0.06,0.06,1.0,0.06,0.06,0.06,0.06,0.06,0.06},
	PosX = -20,
	PosY = 8
}

explorocker_1 = explorocker_0:new{
	Image = "effects/rocker_R.png",
	PosX = -23,
	PosY = -2
}

explorocker_2 = explorocker_0:new{
	Image = "effects/rocker_D.png",
	PosX = -16,
	PosY = -3
}

explorocker_3 = explorocker_0:new{
	Image = "effects/rocker_L.png",
	PosX = -16,
	PosY = 11
}
			
----
			
---
explohornet_0 = Animation:new{
	Image = "effects/hornet_U.png",
	NumFrames = 12,
	Time = 0.05,
	PosX = -29,
	PosY = -16
}

explohornet_1 = explohornet_0:new{
	Image = "effects/hornet_R.png",
	PosX = -32,
	PosY = -18
}

explohornet_2 = explohornet_0:new{
	Image = "effects/hornet_D.png",
	PosX = -16,
	PosY = -16
}

explohornet_3 = explohornet_0:new{
	Image = "effects/hornet_L.png",
	PosX = -17,
	PosY = -15
}
			
----
			
---
explosword_0 = Animation:new{
	Image = "effects/sword_U.png",
	NumFrames = 6,
	Time = 0.07,
	PosX = -46,
	PosY = -7
}

explosword_1 = explosword_0:new{
	Image = "effects/sword_R.png",
	PosX = -42,
	PosY = -27
}

explosword_2 = explosword_0:new{
	Image = "effects/sword_D.png",
	PosX = -22,
	PosY = -22
}

explosword_3 = explosword_0:new{
	Image = "effects/sword_L.png",
	PosX = -18,
	PosY = -8
}


---
flamethrower1_0 = Animation:new{
	Image = "effects/flamethrower1_U.png",
	NumFrames = 9,
	Time = 0.07,
	PosX = -60,
	PosY = -8
}
flamethrower2_0 = flamethrower1_0:new{ Image = "effects/flamethrower2_U.png" }
flamethrower3_0 = flamethrower1_0:new{ Image = "effects/flamethrower3_U.png" }

flamethrower1_1 = flamethrower1_0:new{
	Image = "effects/flamethrower1_R.png",
	PosX = -62,
	PosY = -34
}
flamethrower2_1 = flamethrower1_1:new{ Image = "effects/flamethrower2_R.png" }
flamethrower3_1 = flamethrower1_1:new{ Image = "effects/flamethrower3_R.png" }

flamethrower1_2 = flamethrower1_0:new{
	Image = "effects/flamethrower1_D.png",
	PosX = -25,
	PosY = -34
}
flamethrower2_2 = flamethrower1_2:new{ Image = "effects/flamethrower2_D.png" }
flamethrower3_2 = flamethrower1_2:new{ Image = "effects/flamethrower3_D.png" }

flamethrower1_3 = flamethrower1_0:new{
	Image = "effects/flamethrower1_L.png",
	PosX = -22,
	PosY = -8
}
flamethrower2_3 = flamethrower1_3:new{ Image = "effects/flamethrower2_L.png" }
flamethrower3_3 = flamethrower1_3:new{ Image = "effects/flamethrower3_L.png" }


---
explopunch1_0 = Animation:new{
	Image = "effects/punch1_U.png",
	NumFrames = 6,
	Time = 0.06,
	PosX = -22,
	PosY = -8
}
explopunch1_1 = explopunch1_0:new{
	Image = "effects/punch1_R.png",
	PosX = -21,
	PosY = -6
}
explopunch1_2 = explopunch1_0:new{
	Image = "effects/punch1_D.png",
	PosX = -24,
	PosY = -6
}
explopunch1_3 = explopunch1_0:new{
	Image = "effects/punch1_L.png",
	PosX = -22,
	PosY = -8
}


---
explosmash_0 = Animation:new{
	Image = "effects/smash_U.png",
	NumFrames = 13,
	Time = 0.07,
	PosX = -35,
	PosY = -11
}

explosmash_1 = explosmash_0:new{
	Image = "effects/smash_R.png",
	PosX = -24,
	PosY = -18
}

explosmash_2 = explosmash_0:new{
	Image = "effects/smash_D.png",
	PosX = -22,
	PosY = -18
}

explosmash_3 = explosmash_0:new{
	Image = "effects/smash_L.png",
	PosX = -22,
	PosY = -10
}

---
explospear1_0 = Animation:new{
	Image = "effects/spear1_U.png",
	NumFrames = 6,
	Time = 0.07,
	PosX = -18,
	PosY = -33
}
explospear2_0 = explospear1_0:new{ 	Image = "effects/spear2_U.png", }
explospear3_0 = explospear1_0:new{	Image = "effects/spear3_U.png", }

explospear1_1 = explospear1_0:new{
	Image = "effects/spear1_R.png",
	PosX = -20,
	PosY = 0
}
explospear2_1 = explospear1_1:new{ 	Image = "effects/spear2_R.png", }
explospear3_1 = explospear1_1:new{	Image = "effects/spear3_R.png", }

explospear1_2 = explospear1_0:new{
	Image = "effects/spear1_D.png",
	PosX = -70,
	PosY = 4
}
explospear2_2 = explospear1_2:new{ 	Image = "effects/spear2_D.png", }
explospear3_2 = explospear1_2:new{	Image = "effects/spear3_D.png", }

explospear1_3 = explospear1_0:new{
	Image = "effects/spear1_L.png",
	PosX = -68,
	PosY = -32
}
explospear2_3 = explospear1_3:new{ 	Image = "effects/spear2_L.png", }
explospear3_3 = explospear1_3:new{	Image = "effects/spear3_L.png", }


--------- Hangar	

hangar_shadow = Animation:new{
	Image = "strategy/hangar_platform_shadow.png",
	NumFrames = 13,
}

hangar_drop = Animation:new{
	Image = "nope",--dummy image, just need to track frames
	NumFrames = 13,
	Time = 0.075,
}



------------ Pawns

ColorPatch = Animation:new { Image = "units/player/color_boxes.png", NumFrames = 1, Height = MechColors }

BaseUnit = Animation:new { Image = "units/player/mech_punch_1.png", PosX = -19, PosY = -4, Loop = true, Time = 0.3 }
EnemyUnit = BaseUnit:new { Height = 3 }
MechUnit = BaseUnit:new { Height = MechColors }
MechIcon = SingleImage:new{ Height = MechColors }

BaseEmerge = Animation:new { 
				Image = "units/aliens/firefly_1_emerge.png", 
				NumFrames = 10, 
				PosX = -24, 
				PosY = 0, 
				Loop = false, 
				Time = 0.15, 
				Sound = "/enemy/shared/crawl_out",
				Height = 3}
----
--- Taking this out caused problems, so i left it for now--
MechPunch1 =		MechUnit:new{ Image = "units/player/mech_punch_1.png", PosX = -17, PosY = -1 }
MechPunch1a =		MechUnit:new{ Image = "units/player/mech_punch_1a.png", PosX = -17, PosY = -1, NumFrames = 4 }
MechPunch1w =		MechUnit:new{ Image = "units/player/mech_punch_1w.png", PosX = -17, PosY = 10 }
MechPunch1_broken = 	MechUnit:new{ Image = "units/player/mech_punch_1_broken.png", PosX = -17, PosY = -1 }
MechPunch1w_broken = 	MechUnit:new{ Image = "units/player/mech_punch_1w_broken.png", PosX = -17, PosY = 10 }
MechPunch1_ns = 	MechIcon:new{ Image = "units/player/mech_punch_1_ns.png" }
--------------

--[Archive1]--
MechPunch =			MechUnit:new{ Image = "units/player/mech_punch.png", PosX = -17, PosY = -1 }
MechPuncha =		MechUnit:new{ Image = "units/player/mech_punch_a.png", PosX = -16, PosY = -1, NumFrames = 4 }
MechPunchw =		MechUnit:new{ Image = "units/player/mech_punch_w.png", PosX = -17, PosY = 8 }
MechPunch_broken = 	MechUnit:new{ Image = "units/player/mech_punch_broken.png", PosX = -15, PosY = -2 }
MechPunchw_broken = 	MechUnit:new{ Image = "units/player/mech_punch_w_broken.png", PosX = -17, PosY = 13 }
MechPunch_ns = 		MechIcon:new{ Image = "units/player/mech_punch_ns.png" }
  ----
MechTank = 			MechUnit:new{ Image = "units/player/mech_tank.png", PosX = -16, PosY = 8 }
MechTanka = 		MechUnit:new{ Image = "units/player/mech_tank_a.png", PosX = -16, PosY = 8, NumFrames = 3 }
MechTankw = 		MechUnit:new{ Image = "units/player/mech_tank_w.png", PosX = -16, PosY = 12 }
MechTank_broken = 	MechUnit:new{ Image = "units/player/mech_tank_broken.png", PosX = -16, PosY = 8 }
MechTankw_broken = MechUnit:new{ Image = "units/player/mech_tank_w_broken.png", PosX = -16, PosY = 12 }
MechTank_ns = 	MechIcon:new{ Image = "units/player/mech_tank_ns.png" }
  ----
MechArt = 			MechUnit:new{ Image = "units/player/mech_artillery.png", PosX = -17, PosY = 0 }
MechArta = 			MechUnit:new{ Image = "units/player/mech_artillery_a.png", PosX = -17, PosY = 0, NumFrames = 4 }
MechArt_broken = 	MechUnit:new{ Image = "units/player/mech_artillery_broken.png", PosX = -17, PosY = 0 }
MechArtw = 			MechUnit:new{ Image = "units/player/mech_artillery_w.png", PosX = -19, PosY = 10 }
MechArtw_broken = 	MechUnit:new{ Image = "units/player/mech_artillery_w_broken.png", PosX = -19, PosY = 13 }
MechArt_ns = 		MechIcon:new{ Image = "units/player/mech_artillery_ns.png" }
--------------

--[Archive2]--
MechJudo =		MechUnit:new{ Image = "units/player/mech_judo.png", PosX = -17, PosY = -2 }
MechJudoa =		MechUnit:new{ Image = "units/player/mech_judo_a.png", PosX = -17, PosY = -2, NumFrames = 4 }
MechJudow =		MechUnit:new{ Image = "units/player/mech_judo_w.png", PosX = -17, PosY = 8 }
MechJudo_broken = 	MechUnit:new{ Image = "units/player/mech_judo_broken.png", PosX = -17, PosY = -2 }
MechJudow_broken = 	MechUnit:new{ Image = "units/player/mech_judo_w_broken.png", PosX = -14, PosY = 6 }
MechJudo_ns = 		MechIcon:new{ Image = "units/player/mech_judo_ns.png" }
  ----
MechGrav = 		MechUnit:new{ Image = "units/player/mech_grav.png", PosX = -20, PosY = -1}
MechGrava = 	MechUnit:new{ Image = "units/player/mech_grav_a.png", PosX = -20, PosY = -1, NumFrames = 4 }
MechGravw = 		MechUnit:new{ Image = "units/player/mech_grav_w.png", PosX = -22, PosY = 8 }
MechGrav_broken = 	MechUnit:new{ Image = "units/player/mech_grav_broken.png", PosX = -20, PosY = 1 }
MechGravw_broken = 	MechUnit:new{ Image = "units/player/mech_grav_w_broken.png", PosX = -19, PosY = 10 }
MechGrav_ns = 		MechIcon:new{ Image = "units/player/mech_grav_ns.png" }
  ----
MechDStrike = 		MechUnit:new{ Image = "units/player/mech_dstrike.png", PosX = -18, PosY = -5 }
MechDStrikea = 		MechUnit:new{ Image = "units/player/mech_dstrike_a.png", PosX = -18, PosY = -5, NumFrames = 4 }
MechDStrikew = 		MechUnit:new{ Image = "units/player/mech_dstrike_w.png", PosX = -18, PosY = 8 }
MechDStrike_broken = 	MechUnit:new{ Image = "units/player/mech_dstrike_broken.png", PosX = -18, PosY = -5 }
MechDStrikew_broken = 	MechUnit:new{ Image = "units/player/mech_dstrike_w_broken.png", PosX = -18, PosY = 8 }
MechDStrike_ns =	 MechIcon:new{ Image = "units/player/mech_dstrike_ns.png" }
------------

--[RUST 1]--
MechRocket = 		MechUnit:new{ Image = "units/player/mech_rocket.png", PosX = -19, PosY = -1}
MechRocketa = 	MechUnit:new{ Image = "units/player/mech_rocket_a.png", PosX = -19, PosY = -4, NumFrames = 4 }
MechRocketw = 		MechUnit:new{ Image = "units/player/mech_rocket_w.png", PosX = -19, PosY = 9 }
MechRocket_broken = 	MechUnit:new{ Image = "units/player/mech_rocket_broken.png", PosX = -17, PosY = -1 }
MechRocketw_broken = 	MechUnit:new{ Image = "units/player/mech_rocket_w_broken.png", PosX = -18, PosY = 7 }
MechRocket_ns = 		MechIcon:new{ Image = "units/player/mech_rocket_ns.png" }
  ----
MechJet = 			MechUnit:new{ Image = "units/player/mech_jet.png", PosX = -20, PosY = -11 }
MechJeta = 			MechUnit:new{ Image = "units/player/mech_jet_a.png", PosX = -20, PosY = -11, NumFrames = 4 }
MechJet_broken = 	MechUnit:new{ Image = "units/player/mech_jet_broken.png", PosX = -20, PosY = 5 }
MechJetw_broken = 	MechUnit:new{ Image = "units/player/mech_jet_w_broken.png", PosX = -20, PosY = 11 }
MechJet_ns = 		MechIcon:new{ Image = "units/player/mech_jet_ns.png" }
  ----
MechPulse = 	MechUnit:new{ Image = "units/player/mech_pulse.png", PosX = -22, PosY = 0 }
MechPulsea = 	MechUnit:new{ Image = "units/player/mech_pulse_a.png", PosX = -22, PosY = -1, NumFrames = 4 }
MechPulsew = 	MechUnit:new{ Image = "units/player/mech_pulse_w.png", PosX = -24, PosY = 10 }
MechPulse_broken = 	MechUnit:new{ Image = "units/player/mech_pulse_broken.png", PosX = -18, PosY = 1 }
MechPulsew_broken = 	MechUnit:new{ Image = "units/player/mech_pulse_w_broken.png", PosX = -19, PosY = 11 }
MechPulse_ns = 	MechIcon:new{ Image = "units/player/mech_pulse_ns.png" }
-------------------

------[RUST 2]-----
MechFlame = 		MechUnit:new{ Image = "units/player/mech_flame.png", PosX = -20, PosY = -3}
MechFlamea = 		MechUnit:new{ Image = "units/player/mech_flame_a.png", PosX = -21, PosY = -3, NumFrames = 4 }
MechFlamew = 		MechUnit:new{ Image = "units/player/mech_flame_w.png", PosX = -19, PosY = 6 }
MechFlame_broken = 	MechUnit:new{ Image = "units/player/mech_flame_broken.png", PosX = -16, PosY = 2 }
MechFlamew_broken = MechUnit:new{ Image = "units/player/mech_flame_w_broken.png", PosX = -17, PosY = 8 }
MechFlame_ns = 		MechIcon:new{ Image = "units/player/mech_flame_ns.png" }
  ----
MechIgnite = 			MechUnit:new{ Image = "units/player/mech_ignite.png", PosX = -18, PosY = -4 }
MechIgnitea = 			MechUnit:new{ Image = "units/player/mech_ignite_a.png", PosX = -19, PosY = -5, NumFrames = 4 }
MechIgnitew = 			MechUnit:new{ Image = "units/player/mech_ignite_w.png", PosX = -19, PosY = 6}
MechIgnite_broken = 	MechUnit:new{ Image = "units/player/mech_ignite_broken.png", PosX = -14, PosY = 0 }
MechIgnitew_broken = 	MechUnit:new{ Image = "units/player/mech_ignite_w_broken.png", PosX = -16, PosY = 9 }
MechIgnite_ns = 		MechIcon:new{ Image = "units/player/mech_ignite_ns.png" }
  ----
MechTele = 		MechUnit:new{ Image = "units/player/mech_tele.png", PosX = -15, PosY = -5 }
MechTelea = 	MechUnit:new{ Image = "units/player/mech_tele_a.png", PosX = -15, PosY = -5, NumFrames = 4 }
MechTele_broken = 	MechUnit:new{ Image = "units/player/mech_tele_broken.png", PosX = -13, PosY = 1 }
MechTelew_broken = MechUnit:new{ Image = "units/player/mech_tele_w_broken.png", PosX = -15, PosY = 14 }
MechTele_ns = 	MechIcon:new{ Image = "units/player/mech_tele_ns.png" }
-----------------------

------[Pinnacle 1]-----
MechLaser =		MechUnit:new{ Image = "units/player/mech_laser.png", PosX = -15, PosY = -8 }
MechLasera =		MechUnit:new{ Image = "units/player/mech_laser_a.png", PosX = -15, PosY = -8, NumFrames = 4 }
MechLaserw =		MechUnit:new{ Image = "units/player/mech_laser_w.png", PosX = -15, PosY = 4 }
MechLaser_broken = MechUnit:new{ Image = "units/player/mech_laser_broken.png", PosX = -15, PosY = -1 }
MechLaserw_broken = MechUnit:new{ Image = "units/player/mech_laser_w_broken.png", PosX = -15, PosY = 9 }
MechLaser_ns =	 MechIcon:new{ Image = "units/player/mech_laser_ns.png" }
  ----
MechCharge = 		MechUnit:new{ Image = "units/player/mech_charge.png", PosX = -19, PosY = 5 }
MechChargea = 		MechUnit:new{ Image = "units/player/mech_charge_a.png", PosX = -19, PosY = 5, NumFrames = 4 }
MechChargew = 		MechUnit:new{ Image = "units/player/mech_charge_w.png", PosX = -19, PosY = 12 }
MechCharge_broken = MechUnit:new{ Image = "units/player/mech_charge_broken.png", PosX = -19, PosY = 7 }
MechChargew_broken = MechUnit:new{ Image = "units/player/mech_charge_w_broken.png", PosX = -20, PosY = 14 }
MechCharge_ns = 	MechIcon:new{ Image = "units/player/mech_charge_ns.png" }
  ----
MechScience = 		MechUnit:new{ Image = "units/player/mech_science.png", PosX = -12, PosY = -6 }
MechSciencea = 		MechUnit:new{ Image = "units/player/mech_science_a.png", PosX = -12, PosY = -9, NumFrames = 4 }
MechScience_broken = 	MechUnit:new{ Image = "units/player/mech_science_broken.png", PosX = -12, PosY = -6 }
MechSciencew_broken = 	MechUnit:new{ Image = "units/player/mech_science_w_broken.png", PosX = -12, PosY = -4 }
MechScience_ns = 	MechIcon:new{ Image = "units/player/mech_science_ns.png" }
-----------------------

------[Pinnacle 2]-----
MechIce = 		MechUnit:new{ Image = "units/player/mech_ice.png", PosX = -17, PosY = -6}
MechIcea = 	MechUnit:new{ Image = "units/player/mech_ice_a.png", PosX = -17, PosY = -8, NumFrames = 4 }
MechIce_broken = 	MechUnit:new{ Image = "units/player/mech_ice_broken.png", PosX = -17, PosY = 5 }
MechIcew_broken = 	MechUnit:new{ Image = "units/player/mech_ice_w_broken.png", PosX = -19, PosY = 12 }
MechIce_ns = 		MechIcon:new{ Image = "units/player/mech_ice_ns.png" }
  ----
MechGuard = 		MechUnit:new{ Image = "units/player/mech_guard.png", PosX = -17, PosY = -3}
MechGuarda = 	MechUnit:new{ Image = "units/player/mech_guard_a.png", PosX = -17, PosY = -3, NumFrames = 4 }
MechGuardw = 		MechUnit:new{ Image = "units/player/mech_guard_w.png", PosX = -19, PosY = 9 }
MechGuard_broken = 	MechUnit:new{ Image = "units/player/mech_guard_broken.png", PosX = -16, PosY = -5 }
MechGuardw_broken = 	MechUnit:new{ Image = "units/player/mech_guard_w_broken.png", PosX = -18, PosY = 8 }
MechGuard_ns = 		MechIcon:new{ Image = "units/player/mech_guard_ns.png" }
  ----
MechMirror = 		MechUnit:new{ Image = "units/player/mech_mirror.png", PosX = -20, PosY = 3}
MechMirrora = 	MechUnit:new{ Image = "units/player/mech_mirror_a.png", PosX = -20, PosY = 3, NumFrames = 4 }
MechMirrorw = 		MechUnit:new{ Image = "units/player/mech_mirror_w.png", PosX = -19, PosY = 12 }
MechMirror_broken = 	MechUnit:new{ Image = "units/player/mech_mirror_broken.png", PosX = -20, PosY = 3 }
MechMirrorw_broken = 	MechUnit:new{ Image = "units/player/mech_mirror_w_broken.png", PosX = -20, PosY = 11 }
MechMirror_ns = 		MechIcon:new{ Image = "units/player/mech_mirror_ns.png" }
-----------------------

------[Detritus 1]-----
MechElec = 		MechUnit:new{ Image = "units/player/mech_electric.png", PosX = -20, PosY = -14}
MechEleca = 	MechUnit:new{ Image = "units/player/mech_electric_a.png", PosX = -21, PosY = -14, NumFrames = 4 }
MechElecw = 		MechUnit:new{ Image = "units/player/mech_electric_w.png", PosX = -19, PosY = 1 }
MechElec_broken = 	MechUnit:new{ Image = "units/player/mech_electric_broken.png", PosX = -18, PosY = -10 }
MechElecw_broken = 	MechUnit:new{ Image = "units/player/mech_electric_w_broken.png", PosX = -19, PosY = 2 }
MechElec_ns = 		MechIcon:new{ Image = "units/player/mech_electric_ns.png" }
  ----
MechWall = 		MechUnit:new{ Image = "units/player/mech_wall.png", PosX = -18, PosY = 4}
MechWalla = 	MechUnit:new{ Image = "units/player/mech_wall_a.png", PosX = -18, PosY = 4, NumFrames = 4 }
MechWallw = 		MechUnit:new{ Image = "units/player/mech_wall_w.png", PosX = -21, PosY = 12 }
MechWall_broken = 	MechUnit:new{ Image = "units/player/mech_wall_broken.png", PosX = -18, PosY = 4 }
MechWallw_broken = 	MechUnit:new{ Image = "units/player/mech_wall_w_broken.png", PosX = -18, PosY = 12 }
MechWall_ns = 		MechIcon:new{ Image = "units/player/mech_wall_ns.png" }
  ----
MechRockart = 		MechUnit:new{ Image = "units/player/mech_rockart.png", PosX = -19, PosY = -9}
MechRockarta = 	MechUnit:new{ Image = "units/player/mech_rockart_a.png", PosX = -19, PosY = -9, NumFrames = 4 }
MechRockartw = 		MechUnit:new{ Image = "units/player/mech_rockart_w.png", PosX = -19, PosY = 0 }
MechRockart_broken = 	MechUnit:new{ Image = "units/player/mech_rockart_broken.png", PosX = -19, PosY = -5 }
MechRockartw_broken = 	MechUnit:new{ Image = "units/player/mech_rockart_w_broken.png", PosX = -18, PosY = 4 }
MechRockart_ns = 		MechIcon:new{ Image = "units/player/mech_rockart_ns.png" }
-----------------------

------[Detritius 2]-----
MechLeap = 		MechUnit:new{ Image = "units/player/mech_leap.png", PosX = -14, PosY = -7}
MechLeapa = 	MechUnit:new{ Image = "units/player/mech_leap_a.png", PosX = -16, PosY = -7, NumFrames = 4 }
MechLeap_broken = 	MechUnit:new{ Image = "units/player/mech_leap_broken.png", PosX = -15, PosY = -1 }
MechLeapw = 		MechUnit:new{ Image = "units/player/mech_leap_w.png", PosX = -14, PosY = 7 }
MechLeapw_broken = 	MechUnit:new{ Image = "units/player/mech_leap_w_broken.png", PosX = -15, PosY = 11 }
MechLeap_ns = 		MechIcon:new{ Image = "units/player/mech_leap_ns.png" }
  ----
MechUnstable = 		MechUnit:new{ Image = "units/player/mech_unstable.png", PosX = -16, PosY = 3 }
MechUnstablea = 		MechUnit:new{ Image = "units/player/mech_unstable_a.png", PosX = -15, PosY = 4, NumFrames = 3 }
MechUnstablew = 		MechUnit:new{ Image = "units/player/mech_unstable_w.png", PosX = -16, PosY = 9 }
MechUnstable_broken = MechUnit:new{ Image = "units/player/mech_unstable_broken.png", PosX = -16, PosY = 3 }
MechUnstablew_broken = MechUnit:new{ Image = "units/player/mech_unstable_w_broken.png", PosX = -16, PosY = 9 }
MechUnstable_ns = 	MechIcon:new{ Image = "units/player/mech_unstable_ns.png" }
  ----
MechNano = 		MechUnit:new{ Image = "units/player/mech_nano.png", PosX = -18, PosY = -3}
MechNanoa = 	MechUnit:new{ Image = "units/player/mech_nano_a.png", PosX = -18, PosY = -4, NumFrames = 4 }
MechNano_broken = 	MechUnit:new{ Image = "units/player/mech_nano_broken.png", PosX = -18, PosY = 8 }
MechNanow_broken = 	MechUnit:new{ Image = "units/player/mech_nano_w_broken.png", PosX = -17, PosY = 13 }
MechNano_ns = 		MechIcon:new{ Image = "units/player/mech_nano_ns.png" }


------[VEK SQUAD!]-----
MechBeetle = 		MechUnit:new{ Image = "units/player/vek_beetle.png", PosX = -17, PosY = 0}
MechBeetlea = 	MechUnit:new{ Image = "units/player/vek_beetle_a.png", PosX = -18, PosY = -1, NumFrames = 4 }
MechBeetle_broken = 	MechUnit:new{ Image = "units/player/vek_beetle_broken.png", PosX = -20, PosY = 7 }
MechBeetlew = 		MechUnit:new{ Image = "units/player/vek_beetle_w.png", PosX = -18, PosY = 7 }
MechBeetlew_broken = 	MechUnit:new{ Image = "units/player/vek_beetle_w_broken.png", PosX = -18, PosY = 14 }
MechBeetle_ns = 		MechIcon:new{ Image = "units/player/vek_beetle_ns.png" }
  ----
MechHornet = 		MechUnit:new{ Image = "units/player/vek_hornet.png", PosX = -15, PosY = -19}
MechHorneta = 	MechUnit:new{ Image = "units/player/vek_hornet_a.png", PosX = -16, PosY = -20, NumFrames = 4 }
MechHornet_broken = 	MechUnit:new{ Image = "units/player/vek_hornet_broken.png", PosX = -15, PosY = 7 }
MechHornetw_broken = 	MechUnit:new{ Image = "units/player/vek_hornet_w_broken.png", PosX = -15, PosY = 13 }
MechHornet_ns = 		MechIcon:new{ Image = "units/player/vek_hornet_ns.png" }
  ----
MechScarab = 		MechUnit:new{ Image = "units/player/vek_scarab.png", PosX = -15, PosY = -6}
MechScaraba = 	MechUnit:new{ Image = "units/player/vek_scarab_a.png", PosX = -19, PosY = -6, NumFrames = 4 }
MechScarab_broken = 	MechUnit:new{ Image = "units/player/vek_scarab_broken.png", PosX = -21, PosY = 7 }
MechScarabw = 		MechUnit:new{ Image = "units/player/vek_scarab_w.png", PosX = -16, PosY = 5 }
MechScarabw_broken = 	MechUnit:new{ Image = "units/player/vek_scarab_w_broken.png", PosX = -20, PosY = 15 }
MechScarab_ns = 		MechIcon:new{ Image = "units/player/vek_scarab_ns.png" }


-----------ENEMIES-------------

crab = 		EnemyUnit:new{ Image = "units/aliens/crab.png", PosX = -17, PosY = 3 }
craba = 	EnemyUnit:new{ Image = "units/aliens/craba.png", PosX = -17, PosY = 3, NumFrames = 4 }
crabe = 	BaseEmerge:new{ Image = "units/aliens/crab_emerge.png", PosX = -23, PosY = 5 } 
crabd = 	EnemyUnit:new{ Image = "units/aliens/crab_death.png", PosX = -21, PosY = 5, NumFrames = 8, Time = 0.14, Loop = false }
crabw = 	EnemyUnit:new{ Image = "units/aliens/crab_Bw.png", PosX = -18, PosY = 9 }
--
scarab = 	EnemyUnit:new{ Image = "units/aliens/scarab.png", PosX = -18, PosY = -3 }
scaraba = 	EnemyUnit:new{ Image = "units/aliens/scaraba.png", PosX = -20, PosY = -3, NumFrames = 4 }
scarabe = 	BaseEmerge:new{ Image = "units/aliens/scarab_emerge.png", PosX = -23, PosY = -3 } 
scarabd = 	EnemyUnit:new{ Image = "units/aliens/scarab_death.png", PosX = -21, PosY = -3, NumFrames = 8, Time = 0.14, Loop = false  }
scarabw = 	BaseUnit:new{ Image = "units/aliens/scarab_Bw.png", PosX = -16, PosY = 6 }
--
centipede = 	EnemyUnit:new{ Image = "units/aliens/centipede.png", PosX = -24, PosY = 4 }
centipedea = 	EnemyUnit:new{ Image = "units/aliens/centipedea.png", PosX = -26, PosY = 4, NumFrames = 4 }
centipedee = 	BaseEmerge:new{ Image = "units/aliens/centipede_emerge.png", PosX = -23, PosY = 2 } 
centipeded = 	EnemyUnit:new{ Image = "units/aliens/centipede_death.png", PosX = -27, PosY = 4, NumFrames = 8, Time = 0.14, Loop = false }
centipedew = 	BaseUnit:new{ Image = "units/aliens/centipede_Bw.png", PosX = -22, PosY = 15 }
--
firefly = 		EnemyUnit:new{ Image = "units/aliens/firefly.png", PosX = -18, PosY = -2, Height = 4 }
fireflya = 		firefly:new{ Image = "units/aliens/fireflya.png", PosX = -18, PosY = -2, NumFrames = 4 }
fireflye = 		BaseEmerge:new{ Image = "units/aliens/firefly_emerge.png", PosX = -23, PosY = -2, Height = 4 }
fireflyd = 		firefly:new{ Image = "units/aliens/firefly_death.png", PosX = -20, PosY = -2, NumFrames = 8, Time = 0.14, Loop = false }
fireflyw = 		BaseUnit:new{ Image = "units/aliens/firefly_Bw.png", PosX = -18, PosY = 6 }
--
scorpion = 		EnemyUnit:new{ Image = "units/aliens/scorpion.png", PosX = -16, PosY = -2, Height = 5 }
scorpiona = 	scorpion:new{ Image = "units/aliens/scorpiona.png", PosX = -15, PosY = -2, NumFrames = 4 }
scorpione =		BaseEmerge:new{ Image = "units/aliens/scorpion_emerge.png", PosX = -24, PosY = -1, Height = 5 }
scorpiond = 	scorpion:new{ Image = "units/aliens/scorpion_death.png", PosX = -18, PosY = -5, NumFrames = 8, Time = 0.14, Loop = false }
scorpionw = 	scorpion:new{ Image = "units/aliens/scorpion_Bw.png", PosX = -15, PosY = 6, Height = 1 }

--
blobber = 		EnemyUnit:new{ Image = "units/aliens/blobber.png", PosX = -16, PosY = 1 }
blobbera = 		EnemyUnit:new{ Image = "units/aliens/blobbera.png", PosX = -16, PosY = 1, NumFrames = 4 }
blobbere =		BaseEmerge:new{ Image = "units/aliens/blobber_emerge.png", PosX = -23, PosY = 2 }
blobberd = 		EnemyUnit:new{ Image = "units/aliens/blobber_death.png", PosX = -17, PosY = 2, NumFrames = 8, Time = 0.14, Loop = false }
blobberw = 		BaseUnit:new{ Image = "units/aliens/blobber_Bw.png", PosX = -20, PosY = 11 }
--
blob = 			EnemyUnit:new{ Image = "units/aliens/blob.png", PosX = -13, PosY = 11 }
blobd = 		EnemyUnit:new{ Image = "units/aliens/blob_death.png", PosX = -20, PosY = 9, NumFrames = 6, Time = 0.14, Loop = false}

--boss
slimeb = 		BaseUnit:new{ Image = "units/aliens/slime_B.png", PosX = -28, PosY = -12 }
slimebw = 		BaseUnit:new{ Image = "units/aliens/slime_Bw.png", PosX = -26, PosY = 8 }
slimebd = 		BaseUnit:new{ Image = "units/aliens/slime_B.png", PosX = -28, PosY = -12, Loop = false, Time = 0.35 }
slimeb2 = 		BaseUnit:new{ Image = "units/aliens/slime_B2.png", PosX = -21, PosY = -3 }
slimeb2w = 		BaseUnit:new{ Image = "units/aliens/slime_B2w.png", PosX = -21, PosY = 15 }
slimeb2d = 		BaseUnit:new{ Image = "units/aliens/slime_B2.png", PosX = -21, PosY = -3, Loop = false, Time = 0.35 }
slimeb3 = 		BaseUnit:new{ Image = "units/aliens/slime_B3.png", PosX = -16, PosY = 7 }
slimeb3w = 		BaseUnit:new{ Image = "units/aliens/slime_B3w.png", PosX = -15, PosY = 19 }
slimeb3d = 		BaseUnit:new{ Image = "units/aliens/slime_B3_death.png", PosX = -21, PosY = 2, NumFrames = 7, Loop = false, Time = 0.14 }
--
blobspawn1 = 	BaseUnit:new{ Image = "units/aliens/blobspawn_1.png", PosX = -13, PosY = 11 }
--
leaper = 		EnemyUnit:new{ Image = "units/aliens/leaper.png", PosX = -22, PosY = -3 }
leapera = 		EnemyUnit:new{ Image = "units/aliens/leapera.png", PosX = -22, PosY = -3, NumFrames = 4 }
leapere = 		BaseEmerge:new{ Image = "units/aliens/leaper_emerge.png", PosX = -23, PosY = -3}
leaperd = 		EnemyUnit:new{ Image = "units/aliens/leaper_death.png", PosX = -31, PosY = -3, NumFrames = 8, Time = 0.14, Loop = false }
leaperw = 		BaseUnit:new{ Image = "units/aliens/leaper_Bw.png", PosX = -20, PosY = 11 }
--
spider = 		EnemyUnit:new{ Image = "units/aliens/spider.png", PosX = -18, PosY = 1 }
spidera = 		EnemyUnit:new{ Image = "units/aliens/spidera.png", PosX = -18, PosY = 1, NumFrames = 4 }
spidere = 		BaseEmerge:new{ Image = "units/aliens/spider_emerge.png", PosX = -23, PosY = -3}
spiderd = 		EnemyUnit:new{ Image = "units/aliens/spider_death.png", PosX = -18, PosY = 2, NumFrames = 8, Time = 0.14, Loop = false }
spiderw = 		BaseUnit:new{ Image = "units/aliens/spider_Bw.png", PosX = -18, PosY = 9 }
--
spiderling_egg1 = BaseUnit:new{ Image = "units/aliens/spiderling_1_egg.png", PosX = -11, PosY = 9 }
spiderling_egg1a = spiderling_egg1:new{}
spiderling_egg1d = spiderling_egg1:new{ Image = "units/aliens/spiderling_1_egg_death.png", PosX = -17, PosY = 10, NumFrames = 8, Time = 0.14, Loop = false }

--
webling_egg1 = BaseUnit:new{ Image = "units/aliens/webling_1_egg.png", PosX = -14, PosY = 7 }
webling_egg1a = webling_egg1:new{}
webling_egg1d = webling_egg1:new{ Image = "units/aliens/webling_1_egg_death.png", PosX = -18, PosY = 6, NumFrames = 8, Time = 0.14, Loop = false }
--
spiderling = 	EnemyUnit:new{ Image = "units/aliens/spiderling.png", PosX = -15, PosY = 9, Height = 2 }
spiderlinga = 	spiderling:new{ Image = "units/aliens/spiderlinga.png", PosX = -15, PosY = 9, NumFrames = 6  }
spiderlinge =	BaseEmerge:new{ Image = "units/aliens/spiderling_hatch.png", PosX = -15, PosY = 9, NumFrames = 5, Time =0.1, Sound = "/enemy/spiderling_egg/hatch", Height = 2 }
spiderlingd = 	spiderling:new{ Image = "units/aliens/spiderling_death.png", PosX = -21, PosY = 10, NumFrames = 8, Time = 0.14, Loop = false }

--
beetle = 		EnemyUnit:new{ Image = "units/aliens/beetle.png", PosX = -21, PosY = 1 }
beetlea = 		EnemyUnit:new{ Image = "units/aliens/beetlea.png", PosX = -21, PosY = 0, NumFrames = 4}
beetlee =		BaseEmerge:new{ Image = "units/aliens/beetle_emerge.png", PosX = -23, PosY = 6}
beetled = 		EnemyUnit:new{ Image = "units/aliens/beetle_death.png", PosX = -20, PosY = 7, NumFrames = 8, Time = 0.14, Loop = false }
beetlew = 		BaseUnit:new{ Image = "units/aliens/beetle_Bw.png", PosX = -21, PosY = 9 }
--
digger = 	EnemyUnit:new{ Image = "units/aliens/digger.png", PosX = -22, PosY = 5 }
diggera =	EnemyUnit:new{ Image = "units/aliens/diggera.png", PosX = -22, PosY = 5, NumFrames = 4}
diggere = 	BaseEmerge:new{ Image = "units/aliens/digger_emerge.png", PosX = -23, PosY = 5 }
diggerd = 	EnemyUnit:new{ Image = "units/aliens/digger_death.png", PosX = -22, PosY = 6, NumFrames = 8, Time = 0.14, Loop = false  }
diggerw = 	BaseUnit:new{ Image = "units/aliens/digger_Bw.png", PosX = -18, PosY = 12 }
--
hornet = 	EnemyUnit:new{ Image = "units/aliens/hornet.png", PosX = -11, PosY = -13, Height = 4 }
horneta =  	hornet:new{ Image = "units/aliens/horneta.png", PosX = -11, PosY = -13, NumFrames = 4}
hornete = 	BaseEmerge:new{ Image = "units/aliens/hornet_emerge.png", PosX = -22, PosY = -12, Height = 4 }
hornetd = 	hornet:new{ Image = "units/aliens/hornet_death.png", PosX = -10, PosY = -13, NumFrames = 8, Time = 0.14, Loop = false  }
--
burrower = EnemyUnit:new{ Image = "units/aliens/burrower.png", PosX = -23, PosY = -3 }
burrowera = EnemyUnit:new{ Image = "units/aliens/burrowera.png", PosX = -23, PosY = -3, NumFrames = 4 }
burrowere = BaseEmerge:new{ Image = "units/aliens/burrower_emerge.png", PosX = -23, PosY = -8 }
burrowerd = EnemyUnit:new{ Image = "units/aliens/burrower_death.png", PosX = -28, PosY = -6, NumFrames = 8, Time = 0.14, Loop = false  }

---
jelly = 	EnemyUnit:new{ Image = "units/aliens/jelly.png", PosX = -16, PosY = -14, Height = 7 }
jellya = 	jelly:new{ Image = "units/aliens/jellya.png", PosX = -17, PosY = -14, NumFrames = 4 }
jellye = 	BaseEmerge:new{ Image = "units/aliens/jelly_emerge.png", PosX = -23, PosY = -21, Height = 7 }
jellyd = 	jelly:new{ Image = "units/aliens/jelly_death.png", PosX = -18, PosY = -14, NumFrames = 8, Time = 0.14, Loop = false }

--
rock1 = 	BaseUnit:new{ Image = "units/aliens/rock_1.png", PosX = -18, PosY = -1 }
rock1d = 	rock1:new{ Image = "units/aliens/rock_1_death.png", PosX = -34, PosY = -9, NumFrames = 13, Time = 0.09, Loop = false }
rock1e = 	rock1:new{ Image = "units/aliens/rock_1_emerge.png", PosX = -23, PosY = 2, NumFrames = 6, Time = 0.07, Loop = false }

---
rockthrown = 	BaseUnit:new{ Image = "units/aliens/rock_1.png", PosX = -18, PosY = -1 }
rockthrownd = 	rock1:new{ Image = "units/aliens/rock_1_death.png", PosX = -34, PosY = -9, NumFrames = 13, Time = 0.09, Loop = false }
---
barrel1 = 	BaseUnit:new{ Image = "units/mission/barrel.png", PosX = -17, PosY = -5 }
barrel1d = 	barrel1:new{Loop = false, Time = 0.5}
------
bomb1 = 	BaseUnit:new{ Image = "units/mission/bomb.png", PosX = -15, PosY = 2 }
bomb1d = 	bomb1:new{Image = "units/mission/bomb_death.png", PosX = -24, PosY = -4, NumFrames = 11, Time = 0.09, Loop = false}
------
slug1 = 	BaseUnit:new{ Image = "units/aliens/slug_1.png", PosX = -20, PosY = -5 }
slug1a = 	slug1:new{ }
slug2 = 	slug1:new{ Image = "units/aliens/slug_2.png" }
slug2a =	slug2:new{ }

slugb = 	BaseUnit:new{ Image = "units/aliens/slug_B.png", PosX = -24, PosY = 3 }
slugba = 	BaseUnit:new{ Image = "units/aliens/slug_Ba.png", PosX = -24, PosY = 3, NumFrames = 4 }
slugbe = 	BaseEmerge:new{ Image = "units/aliens/slug_B_emerge.png", PosX = -24, PosY = -3, Height = 1 }
slugbd = 	BaseUnit:new{ Image = "units/aliens/slug_B_death.png", PosX = -29, PosY = 3, NumFrames = 8, Time = 0.14, Loop = false }
slugbw = 	BaseUnit:new{ Image = "units/aliens/slug_Bw.png", PosX = -20, PosY = 16 }

sluglingb = 	BaseUnit:new{ Image = "units/aliens/slugling_B.png", PosX = -13, PosY = 8 }
sluglingbd = 	BaseUnit:new{ Image = "units/aliens/slugling_B_death.png", PosX = -14, PosY = 3, NumFrames = 10, Time = 0.14, Loop = false }

-----------Snowbots-----------
snowtank1 = 	BaseUnit:new{ Image = "units/snowbots/snowtank_1.png", PosX = -20, PosY = -4 }
snowtank1a = 	snowtank1:new { Image = "units/snowbots/snowtank_1a.png", PosX = -20, PosY = -4, NumFrames = 3 }
snowtank1off = 	snowtank1:new {	Image = "units/snowbots/snowtank_1_off.png" }
snowtank1d =	snowtank1:new { Image = "units/snowbots/snowtank_1_death.png", PosX = -21, PosY = -5, NumFrames = 11, Time = 0.12, Loop = false }

snowtank2 =		snowtank1:new{ Image = "units/snowbots/snowtank_2.png"}
snowtank2a = 	snowtank1a:new{ Image = "units/snowbots/snowtank_2a.png"}
snowtank2off = 	snowtank1off:new{ Image = "units/snowbots/snowtank_2_off.png"}
snowtank2d = 	snowtank1d:new { Image = "units/snowbots/snowtank_2_death.png"}
--
snowart1 = 		BaseUnit:new{ Image = "units/snowbots/snowart_1.png", PosX = -18, PosY = -9 }
snowart1a = 	snowart1:new{ Image = "units/snowbots/snowart_1a.png", NumFrames = 4 }
snowart1off = 	BaseUnit:new { Image = "units/snowbots/snowart_1_off.png", PosX = -18, PosY = -9 }
snowart1d = 	BaseUnit:new { Image = "units/snowbots/snowart_1_death.png", PosX = -22, PosY = -9, NumFrames = 11, Time = 0.12, Loop = false }

snowart2 = 		snowart1:new{ Image = "units/snowbots/snowart_2.png"}
snowart2a = 	snowart1a:new{ Image = "units/snowbots/snowart_2a.png"}
snowart2off = 	snowart1off:new{ Image = "units/snowbots/snowart_2_off.png"}
snowart2d =		snowart1d:new{ Image = "units/snowbots/snowart_2_death.png"}

----

snow_boss = 		snowart1:new{ Image = "units/snowbots/snowart_boss.png"}
snow_bossa = 	snowart1a:new{ Image = "units/snowbots/snowart_bossa.png"}
snow_bossoff = 	snowart1off:new{ Image = "units/snowbots/snowart_boss_off.png"}
snow_bossd =	snowart1d:new{ Image = "units/snowbots/snowart_boss_death.png"}
snow_bossw = 	snowart1:new { Image = "units/snowbots/snowart_boss_w.png", PosX = -15, PosY = 4 }
--
snowlaser1 = 	BaseUnit:new{ Image = "units/snowbots/snowlaser_1.png", PosX = -15, PosY = -2 }
snowlaser1a = 	snowlaser1:new{ Image = "units/snowbots/snowlaser_1a.png", PosX = -15, PosY = -2, NumFrames = 4 }
snowlaser1off = snowlaser1:new{ Image = "units/snowbots/snowlaser_1_off.png"}
snowlaser1d = 	snowlaser1:new{ Image = "units/snowbots/snowlaser_1_death.png", PosX = -19, PosY = -6, NumFrames = 11, Time = 0.12, Loop = false }

snowlaser2 = 	snowlaser1:new{ Image = "units/snowbots/snowlaser_2.png" }
snowlaser2a = 	snowlaser1a:new{ Image = "units/snowbots/snowlaser_2a.png" }
snowlaser2off = snowlaser1off:new{ Image = "units/snowbots/snowlaser_2_off.png" }
snowlaser2d = 	snowlaser1d:new{ Image = "units/snowbots/snowlaser_2_death.png"}
--
snowmine1 = 	BaseUnit:new{ Image = "units/snowbots/snowmine_1.png", PosX = -21, PosY = 4 }
snowmine1a = 	snowmine1:new{ Image = "units/snowbots/snowmine_1a.png", PosX = -21, PosY = 3, NumFrames = 4}
snowmine1off = 	snowmine1:new{ Image = "units/snowbots/snowmine_1_off.png" }
snowmine1d = 	BaseUnit:new{ Image = "units/snowbots/snowmine_1_death.png", PosX = -23, PosY = -4, NumFrames = 11, Time = 0.12, Loop = false }

snowmine2 = 	snowmine1:new{ Image = "units/snowbots/snowmine_2.png" }
snowmine2a = 	snowmine1a:new{ Image = "units/snowbots/snowmine_2a.png" }
snowmine2off = 	snowmine1off:new{ Image = "units/snowbots/snowmine_2_off.png" }
snowmine2d = 	snowmine1d:new{ Image = "units/snowbots/snowmine_2_death.png"}

---------NPC & Mission Stuff ----------------

--
SmallTank1 = 	BaseUnit:new{ Image = "units/mission/smalltank_1.png", PosX = -15, PosY = 12 }
SmallTank1a = 	BaseUnit:new{ Image = "units/mission/smalltank_1a.png", PosX = -15, PosY = 12, NumFrames = 2 }
SmallTank1d = 	SmallTank1:new{ Image = "units/mission/smalltank_1_death.png", PosX = -21, PosY = 3, NumFrames = 11, Time = 0.14, Loop = false }
SmallTank1_broken = SmallTank1:new{ Image = "units/mission/smalltank_1_broken.png", PosX = -21, PosY = 3 }
SmallTank1_ns  = SingleImage:new{ Image = "units/mission/smalltank_1_ns.png"}

SmallTank1_disabled = 	BaseUnit:new{ Image = "units/mission/smalltank_1_disabled.png", PosX = -15, PosY = 12 }
SmallTank1_disableda = 	SmallTank1_disabled:new{}
SmallTank1_disabledd = SmallTank1d:new{}
SmallTank1_disabled_broken = SmallTank1_broken:new{}
--
TankIce1 = 	BaseUnit:new{ Image = "units/mission/tankice_1.png", PosX = -15, PosY = 4 }
TankIce1a = 	BaseUnit:new{ Image = "units/mission/tankice_1a.png", PosX = -15, PosY = 4, NumFrames = 2 }
TankIce1d = 	TankIce1:new{ Image = "units/mission/tankice_1_death.png", PosX = -21, PosY = 3, NumFrames = 11, Time = 0.14, Loop = false }
TankIce1_broken = TankIce1:new{ Image = "units/mission/tankice_1_broken.png", PosX = -21, PosY = 3 }
TankIce1_ns = 	SingleImage:new{ Image = "units/mission/tankice_1_ns.png"}
--
TankAcid1 = 	BaseUnit:new{ Image = "units/mission/tankacid_1.png", PosX = -15, PosY = 4 }
TankAcid1a = 	BaseUnit:new{ Image = "units/mission/tankacid_1a.png", PosX = -15, PosY = 4, NumFrames = 2 }
TankAcid1d = 	TankAcid1:new{ Image = "units/mission/tankacid_1_death.png", PosX = -21, PosY = 3, NumFrames = 11, Time = 0.14, Loop = false }
TankAcid1_broken = TankAcid1:new{ Image = "units/mission/tankacid_1_broken.png", PosX = -21, PosY = 3 }
TankAcid1_ns = 	SingleImage:new{ Image = "units/mission/tankacid_1_ns.png"}
--
TankAcid2 = 	TankAcid1:new{ Image = "units/mission/tankacid_2.png",}
TankAcid2a = 	TankAcid1a:new{ Image = "units/mission/tankacid_2a.png", }
TankAcid2d = 	TankAcid1d:new{ Image = "units/mission/tankacid_2_death.png"}
TankAcid2_broken = TankAcid1_broken:new{ Image = "units/mission/tankacid_2_broken.png", }
TankAcid2_ns = 	TankAcid1_ns:new{ Image = "units/mission/tankacid_2_ns.png"}
--
ShieldTank1 = 	BaseUnit:new{ Image = "units/mission/tankshield_1.png", PosX = -15, PosY = 9 }
ShieldTank1a = 	BaseUnit:new{ Image = "units/mission/tankshield_1a.png", PosX = -15, PosY = 8, NumFrames = 2 }
ShieldTank1d = 	ShieldTank1:new{ Image = "units/mission/tankshield_1_death.png", PosX = -21, PosY = 0, NumFrames = 11, Time = 0.14, Loop = false }
ShieldTank1_broken = ShieldTank1:new{ Image = "units/mission/tankshield_1_broken.png", PosX = -21, PosY = 0 }
ShieldTank1_ns  = SingleImage:new{ Image = "units/mission/tankshield_1_ns.png"}
--
PullTank1 = 		BaseUnit:new{ Image = "units/mission/tankpull_1.png", PosX = -16, PosY = 3 }
PullTank1a = 		BaseUnit:new{ Image = "units/mission/tankpull_1a.png", PosX = -16, PosY = 2, NumFrames = 2 }
PullTank1d = 		PullTank1:new{ Image = "units/mission/tankpull_1_death.png", PosX = -20, PosY = -3, NumFrames = 11, Time = 0.14, Loop = false }
PullTank1_broken = PullTank1:new{ Image = "units/mission/tankpull_1_broken.png", PosX = -20, PosY = -3 }
PullTank1_ns  = 	SingleImage:new{ Image = "units/mission/tankpull_1_ns.png"}
--
PullTank2 = 		BaseUnit:new{ Image = "units/mission/tankpull_2.png", PosX = -14, PosY = -3 }
PullTank2a = 		BaseUnit:new{ Image = "units/mission/tankpull_2a.png", PosX = -14, PosY = -3, NumFrames = 4 }
PullTank2d = 		PullTank2:new{ Image = "units/mission/tankpull_2_death.png", PosX = -20, PosY = -3, NumFrames = 11, Time = 0.14, Loop = false }
PullTank2_broken = 	PullTank2:new{ Image = "units/mission/tankpull_2_broken.png", PosX = -20, PosY = -3 }
PullTank2_ns  = 	SingleImage:new{ Image = "units/mission/tankpull_2_ns.png"}
--
Civilian1 = 		BaseUnit:new{ Image = "units/mission/civilian_1.png", PosX = -11, PosY = 6 }
Civilian1a = 		BaseUnit:new{ Image = "units/mission/civilian_1a.png", PosX = -11, PosY = 5, NumFrames = 2 }
----
ArtSupport1 = 		BaseUnit:new{ Image = "units/mission/artillery_1.png", PosX = -15, PosY = 7 }
ArtSupport1a = 		BaseUnit:new{ Image = "units/mission/artillery_1a.png", PosX = -15, PosY = 6, NumFrames = 4 }
ArtSupport1d = 		BaseUnit:new{ Image = "units/mission/artillery_1_death.png", PosX = -19, PosY = -2, NumFrames = 11, Time = 0.14, Loop = false }
ArtSupport1d = 		BaseUnit:new{ Image = "units/mission/artillery_1_broken.png", PosX = -19, PosY = -2 }
ArtSupport1_ns = 	SingleImage:new{ Image = "units/mission/artillery_1_ns.png"}
--
HeliSupport1 = 		BaseUnit:new{ Image = "units/mission/helicopter_1.png", PosX = -15, PosY = 8 }
HeliSupport1a = 	BaseUnit:new{ Image = "units/mission/helicopter_1a.png", PosX = -15, PosY = 8, NumFrames = 4 }
HeliSupport1d = 	HeliSupport1:new{ Image = "units/mission/helicopter_1_death.png", PosX = -19, PosY = 9, NumFrames = 11, Time = 0.14, Loop = false }
--
DroneSupport1 = 	BaseUnit:new{ Image = "units/mission/drone_1.png", PosX = -17, PosY = -18 }
--
turretL1 = 	BaseUnit:new{ Image = "units/mission/turret_L_1.png", PosX = -21, PosY = 1 }
turretU1 = 	BaseUnit:new{ Image = "units/mission/turret_U_1.png", PosX = -21, PosY = 1 }
turretR1 = 	BaseUnit:new{ Image = "units/mission/turret_R_1.png", PosX = -21, PosY = 1 }
turretD1 = 	BaseUnit:new{ Image = "units/mission/turret_D_1.png", PosX = -21, PosY = 1 }
--
generator1 = BaseUnit:new{ Image = "units/mission/generator_1.png", PosX = -17, PosY = -10 }
generator1a = 	BaseUnit:new{ Image = "units/mission/generator_1a.png", PosX = -17, PosY = -12, NumFrames = 4 }
generator1d = 	BaseUnit:new{ Image = "units/mission/generator_1_death.png", PosX = -21, PosY = -13, NumFrames = 11, Time = 0.14, Loop = false }
generator1_broken = BaseUnit:new{ Image = "units/mission/generator_1_broken.png", PosX = -17, PosY = -10 }
generator1_ns = 	SingleImage:new{ Image = "units/mission/generator_1_ns.png"}

generator3 = 	generator1:new{ Image = "units/mission/generator_3.png", PosX = -17, PosY = -10 }
generator3a = 	generator1a:new{ Image = "units/mission/generator_3a.png", PosX = -17, PosY = -12, NumFrames = 4 }
generator3d = 	generator1d:new{ Image = "units/mission/generator_3_death.png", PosX = -21, PosY = -13, NumFrames = 11, Time = 0.14, Loop = false }
generator3_broken = generator1_broken:new{ Image = "units/mission/generator_3_broken.png", PosX = -17, PosY = -10 }
--
terraformer1 = 			BaseUnit:new{ Image = "units/mission/terraformer_1.png", PosX = -25, PosY = -8 }
terraformer1a = 	BaseUnit:new{ Image = "units/mission/terraformer_1a.png", PosX = -26, PosY = -8, NumFrames = 4 }
terraformer1d = 	BaseUnit:new{ Image = "units/mission/terraformer_1_death.png", PosX = -32, PosY = -7, NumFrames = 11, Time = 0.14, Loop = false }
terraformer1_broken = 	terraformer1:new{ Image = "units/mission/terraformer_1_broken.png"}

terraformer2 = 			terraformer1:new{ Image = "units/mission/terraformer_2.png"}
terraformer2a = 	terraformer1a:new{ Image = "units/mission/terraformer_2a.png" }
terraformer2d = 	terraformer1d:new{ Image = "units/mission/terraformer_2_death.png" }
terraformer2_broken = 	terraformer1_broken:new{ Image = "units/mission/terraformer_2_broken.png"}
terraformer2_ns = 	SingleImage:new{ Image = "units/mission/terraformer_2_ns.png"}

terraformer3 = 			terraformer1:new{ Image = "units/mission/terraformer_3.png"}
terraformer3a = 	terraformer1a:new{ Image = "units/mission/terraformer_3a.png" }
terraformer3d = 	terraformer1d:new{ Image = "units/mission/terraformer_3_death.png" }
terraformer3_broken = 	terraformer1_broken:new{ Image = "units/mission/terraformer_3_broken.png"}
terraformer3_ns = 	SingleImage:new{ Image = "units/mission/terraformer_3_ns.png"}
--
missile = BaseUnit:new{ Image = "units/mission/missilesilo_ready.png", PosX = -10, PosY = -31}
missileoff = BaseUnit:new{ Image = "units/mission/missilesilo_notready.png", PosX = -9, PosY = -10}
missile_broken = BaseUnit:new{ Image = "units/mission/missilesilo_broken.png", PosX = -8, PosY = 5}
missilea = missile
--missile_ready_broken = missile_notready_broken
missile_flying = BaseUnit:new{ Image = "units/mission/missilesilo_flying.png", PosX = -10, PosY = -31}
--
dam_dual = 	BaseUnit:new{ Image = "units/mission/str_dam1.png", PosX = -30, PosY = -9 }
dam_duala = 	BaseUnit:new{ Image = "units/mission/str_dam1_a.png", PosX = -30, PosY = -9, NumFrames = 5, Time = 0.4 }
dam_dual_broken = 	dam_dual:new{ Image = "units/mission/str_dam1_broken.png" }
dam_dualw_broken = 	dam_dual_broken
--

trapped_bldg = BaseUnit:new{ Image = "units/mission/trapped_1.png", PosX = -22, PosY = -2 }
trapped_bldgd = BaseUnit:new{ Image = "units/mission/trapped_1d.png", PosX = -27, PosY = -7, NumFrames = 12, Time = 0.14, Loop = false }

---

train_dual = 	BaseUnit:new{ Image = "units/mission/train.png", PosX = -51, PosY = 3 }
train_dual_broken = 	BaseUnit:new{ Image = "units/mission/train.png", PosX = -51, PosY = 3 }
train_dual_damaged = 	BaseUnit:new{ Image = "units/mission/train_A.png", PosX = -51, PosY = 3 }
train_dual_damagedd = 	BaseUnit:new{ Image = "units/mission/train_A_death.png", PosX = -51, PosY = 3, NumFrames = 12, Time = 0.14, Loop = false }
train_dual_damaged_broken = BaseUnit:new{ Image = "units/mission/train_broken.png", PosX = -51, PosY = 3 }
--

piston_u = BaseUnit:new{ Image = "units/mission/piston_U.png", PosX = -20, PosY = -15 }
piston_u_push = piston_u:new{ Image = "units/mission/piston_Ua.png", PosX = -20, PosY = -18, NumFrames = 11, Time = 0.03, Loop = false }
piston_u_broken = BaseUnit:new{ Image = "units/mission/piston_U_broken.png", PosX = -20, PosY = -15 }

piston_d = piston_u:new{ Image = "units/mission/piston_D.png", PosX = -22, PosY = -7 }
piston_d_push = piston_u_push:new{ Image = "units/mission/piston_Da.png", PosX = -35, PosY = -7 }
piston_d_broken = piston_u_push:new{ Image = "units/mission/piston_D_broken.png", PosX = -22, PosY = -7}

piston_r = piston_u:new{ Image = "units/mission/piston_R.png", PosX = -22, PosY = -7 }
piston_r_push = piston_u_push:new{ Image = "units/mission/piston_Ra.png", PosX = -22, PosY = -7 }
piston_r_broken = piston_u:new{ Image = "units/mission/piston_R_broken.png", PosX = -22, PosY = -7 }

piston_l = piston_u:new{ Image = "units/mission/piston_L.png", PosX = -20, PosY = -15 }
piston_l_push = piston_u_push:new{ Image = "units/mission/piston_La.png", PosX = -35, PosY = -18 }
piston_l_broken = piston_u:new{ Image = "units/mission/piston_L_broken.png", PosX = -20, PosY = -15 }


--TEST ENEMIES--
barnicle = 		BaseUnit:new{ Image = "units/aliens/barnicle_1.png", PosX = -14, PosY = 6 }
barniclef = 		BaseUnit:new{ Image = "units/aliens/barnicle_f_1.png", PosX = -18, PosY = 6 }


InfestArm =	 	Animation:new{ Image = "units/aliens/infest_arm_1.png", PosX = -31, PosY = -19 }
InfestThrow = 	InfestArm:new{ Image = "units/aliens/infest_throw_1.png" }

Bones = 	BaseUnit:new{ Image = "units/aliens/bones_1.png", PosX = -20, PosY = 4 }

------------

anim_airfield = BaseUnit:new{ Image = "combat/structures/str_airfield1_on.png", PosX = -24, PosY = -14 }

------

Anim_Structure = Animation:new{ PosX = -31, PosY = -19 }

Anim_Research = Anim_Structure:new { Image = "combat/structures/str_research1.png", PosX = -20, PosY = 0}

Anim_Factory = Anim_Structure:new { Image = "combat/structures/str_factory1.png", PosX = -20, PosY = 3}
		
Anim_Radar = Anim_Structure:new { Image = "combat/structures/str_radar1.png", PosX = -13, PosY = -7}
			
Anim_Timelab = Anim_Structure:new { Image = "combat/structures/str_timelab1.png"}
			
Anim_Shield = Anim_Structure:new { Image ="combat/structures/str_shield1.png"}
				

ArtWalker =	BaseUnit:new{
	Image = "units/player/gunwalker_1a.png",
	NumFrames = 4,
	PosX = -19, 
	PosY = -4
}

--[[
Firefly1 =	{
				Image = "units/player/firefly_1.png",	PosX = -17,		PosY = -1
			}
Firefly1 = ArtWalker:new(Firefly1)
Scorpion1 =	{
				Image = "units/player/firefly_1.png",	PosX = -17,		PosY = -1
			}
Scorpion1 = ArtWalker:new(Scorpion1)
Scorpion2 =	{
				Image = "units/player/scorpion_2.png",	PosX = -17,		PosY = -1
			}
Scorpion2 = ArtWalker:new(Scorpion2)
]]--

------ Effects?

Stunned = Animation:new{ 	
	Image = "combat/icons/stun_strip5.png",
	PosX = -8, PosY = -3,
	NumFrames = 5,
	Time = 0.1,
	Loop = true
}

ForestFire = Animation:new{
	Image = "combat/icons/icon_forest_burn_glow.png",
	PosX = -13, PosY = 22,
	Time = 0.15,
	Loop = true,
	NumFrames = 6
}

DesertSmoke = Animation:new{
	Image = "combat/icons/icon_sand_hit_glow.png",
	PosX = -13, PosY = 22,
	Time = 0.15,
	Loop = true,
	NumFrames = 6
}

IceWater = Animation:new{
	Image = "combat/icons/icon_ice_break_glow.png",
	PosX = -13, PosY = 22,
	Time = 0.15,
	Loop = true,
	NumFrames = 6
}

Guarding = Animation:new{ 	
	Image = "combat/icons/guard.png",
	PosX = -8, PosY = -6,
	NumFrames = 8,
	Time = 0.15,
	Loop = true
}

Energized = Animation:new{ 	
	Image = "combat/icons/icon_energized_glow.png",
	PosX = -14+13, PosY = 4,
	NumFrames = 1,
	Loop = true
}

OnFire = Animation:new{		
	Image = "combat/icons/icon_fire_glow.png",
	PosX = -25, PosY = -8,
	NumFrames = 1,
	Time = 0.15,
	Loop = true
}

Blocking = Animation:new{		
	Image = "combat/icons/icon_spawnblock_glow.png",
	PosX = -13, PosY = 20,
	NumFrames = 1,
	Time = 0.15,
	Loop = true
}
					
Acid = Animation:new{		
	Image = "combat/icons/icon_acid_glow.png",
	PosX = -3, PosY = -8,
	NumFrames = 1,
	Time = 0.15,
	Loop = true
}

Supply = Animation:new{		
	Image = "combat/icons/icon_supply_glow.png",
	PosX = -3, PosY = -8,
	NumFrames = 1,
	Time = 0.15,
	Loop = true
}

Radio = Animation:new{
	Image = "combat/icons/radio_animate.png",
	PosX = -16, PosY = -8,
	NumFrames = 3,
	Time = 0.2,
	Loop = true
}

----------------- UI ANIMATIONS --------------------------

Ping = Animation:new{ 
	Image = "ui/turnchange/ping.png", PosX = -43, PosY = -13,
	NumFrames = 12, Time = 0.04, Loop = false
}

UnitRift = Animation:new{ 
	Image = "combat/rift_unit.png", PosX = -33, PosY = -43,
	NumFrames = 11, Time = 0.04, Loop = false
}

Victory_2 = Animation:new{
	Image = "ui/hangar/victory_2.png",
	NumFrames = 4,
}

Victory_3 = Animation:new{
	Image = "ui/hangar/victory_3.png",
	NumFrames = 4,
}

Victory_4 = Animation:new{
	Image = "ui/hangar/victory_4.png",
	NumFrames = 4,
}
