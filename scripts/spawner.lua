
-- num_<x> values are "out of 5 spawns" 
	-- weak = weak pawns (off the weak pawns list)
	-- upgrades = tier 2 versions

-- upgrade_max = maximum # of upgrades on the map at once -- NOT "out of 5 spawns"



SectorSpawners = {

------------------------
-- EASY MODE SPAWNERS --
------------------------
	[DIFF_EASY] = {
		[1] = Spawner:new{
			num_weak = 4,
			num_upgrades = 0,
			upgrade_max = 0,
		},
		[2] = Spawner:new{
			num_weak = 4,
			num_upgrades = 0,
			upgrade_max = 0,
		},
		[3] = Spawner:new{
			num_weak = 4,
			num_upgrades = 1,
			upgrade_max = 2,
		},
		[4] = Spawner:new{
			num_weak = 4,
			num_upgrades = 2,
			upgrade_max = 4,
		},
	},

------------------------
-- NORMAL MODE SPAWNERS --
------------------------

	[DIFF_NORMAL] = {
		[1] = Spawner:new{	
			num_weak = 4,
			num_upgrades = 0,  
			upgrade_max = 0, 
		},
		[2] = Spawner:new{
			num_weak = 4,
			num_upgrades = 1,  
			upgrade_max = 2,  
		},
		[3] = Spawner:new{
			num_weak = 4,  --WAS 3
			num_upgrades = 2,  --WAS 3
			upgrade_max = 3,   -- WAS 4
		},
		[4] = Spawner:new{
			num_weak = 3, 
			num_upgrades = 4,  --WAS 5
			upgrade_max = 5, -- WAS 6
		},
	},

------------------------
-- HARD MODE SPAWNERS --
------------------------

	[DIFF_HARD] = {
		[1] = Spawner:new{	
			num_weak = 4,
			num_upgrades = 1,  
			upgrade_max = 1,  
		},
		[2] = Spawner:new{
			num_weak = 4,
			num_upgrades = 2,  
			upgrade_max = 3, 
		},
		[3] = Spawner:new{
			num_weak = 3,
			num_upgrades = 3,
			upgrade_max = 5,  
		},
		[4] = Spawner:new{
			num_weak = 3,
			num_upgrades = 5,
			upgrade_max = 6,
		},
	},
}




