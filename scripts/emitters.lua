
Emitter = {
	x = 0,
	y = 0,
	variance = 0,
	variance_x = 0,
	variance_y = 0,
	max_alpha = 0.5,
	min_alpha = 0,
	angle = 0,
	timer = -1, --won't stop
	angle_variance = 25,
	lifespan = 0.5,
	birth_rate = 0.01,
	speed = 0.25,
	rot_speed = 20,
	gravity = false,
	burst_count = 0,
	max_particles = 32,
	image_count = 1,
	layer = LAYER_BACK,
	seed = 0,
}

CreateClass(Emitter)

Emitter_Repair = Emitter:new{
	image = "combat/particle_repair.png",
	variance = 35,
	y = 15,
	angle = -90,
	rot_speed = 0,
	angle_variance = 0,
	lifespan = 1.2,
	birth_rate = 2,
	speed = 0.5,
	seed = 4,
	gravity = false,
	layer = LAYER_FRONT,
}
	
--For the pod screen
Emitter_Pod_Crashed = Emitter:new{
	image = "ui/combat/pod_smoke",
	image_count = 5,
	x = 295,
	y = 85,
	lifespan = 15,
	speed = 1.75,
	birth_rate = 20,
	variance = 30,
	angle = 255,
	min_alpha = 1,
}

--Pod smoke trail
Emitter_Pod = Emitter:new{
	image = "combat/pod/pod_smoke.png",
	speed = 1.25,
	birth_rate = 0.9,
	lifespan = 1,
}

--Pod crash burst
Emitter_Pod_Burst = Emitter_Pod:new{
	burst_count = 10,
	lifespan = 2.2,
	speed = 1.75,
	variance = 30,
	angle = 255,
}

--Missile smoke trail
Emitter_Missile = Emitter_Pod:new{
	image = "effects/smoke/art_smoke.png",
	birth_rate = 0.3,  -- was .2
	max_particles = 64,
	variance = 6,  --wasnt here 
	max_alpha = 0.5,  --wasnt here
}

--Fireball smoke trail
Emitter_Fireball = Emitter_Pod:new{
	image = "effects/smoke/fireball_smoke.png",
	birth_rate = 0.2,
	max_particles = 64,
}

---Acid smoke trail
Emitter_Acid = Emitter_Pod:new{
	image = "effects/smoke/acid_smoke.png",
	birth_rate = 0.15,
	gravity = true,
	speed = 0,
	max_particles = 64,
}

--Smoke from fire tiles
Emitter_Fire = Emitter:new{
	image = "combat/pod/pod_smoke.png",
	angle = 255,
	lifespan = 6,
	speed = 0.5,
	max_alpha = 0.25,
	birth_rate = 6,
	x = 5,
	y = 20,
	variance = 20,
	fade_in = true,
	layer = LAYER_FRONT,
	max_particles = 16
}

Emitter_AcidSmoke = Emitter_Fire:new{
	image = "effects/smoke/acid_smoke.png",
	variance = 15,
	x = 5,
	y = 25,
	lifespan = 4,
}

--Smoke from fire tiles
Emitter_FireOut = Emitter_Fire:new{
	burst_count = 30,
	max_particles = 30,
	birth_rate = 0,
	lifespan = 3,
	variance = 20,
	y = 5
}

--Unit Dust trail
Emitter_Dust = Emitter:new{
	image = "combat/tiles_grass/dust.png",
	x = 0,
	y = 10,
	max_alpha = 0.25,
	angle = 270,
	variance = 12,
	lifespan = 0.4,
	burst_count = 15,
	speed = 0.75,
	birth_rate = 0,
	gravity = false,
	layer = LAYER_FRONT
}

--tile specific variations on dust trail
Emitter_tiles_grass = Emitter_Dust:new{
	image = "combat/tiles_grass/dust.png",
}

--snow "bounces" instead of fading away so it looks like snow?
Emitter_tiles_snow = Emitter_Dust:new{
	image = "combat/tiles_snow/dust.png",
	gravity = true,
	max_alpha = 0.5
}

Emitter_tiles_acid = Emitter_Dust:new{
	image = "combat/tiles_acid/dust.png",
}

Emitter_tiles_sand = Emitter_Dust:new{
	image = "combat/tiles_sand/dust.png",
}

--Bigger dust burst based on ground matter
Emitter_Burst = Emitter:new{
	image = "combat/tiles_grass/dust.png",
	x = 0,
	y = 20,
	max_alpha = 0.2,
	angle = 270,
	variance_x = 30,
	variance_y = 15,
	lifespan = 1.5,
	burst_count = 40,
	speed = 1,
	birth_rate = 0,
	gravity = false,
	layer = LAYER_FRONT
}

--tile specific variations on dust trail
Emitter_Burst_tiles_grass = Emitter_Burst:new{
	image = "combat/tiles_grass/dust.png",
}

--snow "bounces" instead of fading away so it looks like snow?
Emitter_Burst_tiles_snow = Emitter_Burst:new{
	image = "combat/tiles_snow/dust.png",
	gravity = true,
	speed = 1,
	lifespan = 1,
	max_alpha = 0.5
}

Emitter_Burst_tiles_acid = Emitter_Burst:new{
	image = "combat/tiles_acid/dust.png",
}

Emitter_Burst_tiles_sand = Emitter_Burst:new{
	image = "combat/tiles_sand/dust.png",
}


Emitter_Wind_0 = Emitter:new{   --up
	image = "combat/tiles_grass/particle.png",
	x = -60,
	y = 40,
	max_alpha = 0.2,
	angle = -20,
	variance_x = 400,
	variance_y = 280,
	lifespan = 1,
	burst_count = 100,
	birth_rate = 0.001,
	timer = 2,
	max_particles = 300,
	speed = 12,
	gravity = false,
	layer = LAYER_BACK
}
Emitter_Wind_1 = Emitter_Wind_0:new{ x = -60, y = 0, angle = 40, }  --right
Emitter_Wind_2 = Emitter_Wind_0:new{ x = 60, y = 0, angle = 160, }  --down
Emitter_Wind_3 = Emitter_Wind_0:new{ x = 60, y = 40, angle = 220, }  --left

