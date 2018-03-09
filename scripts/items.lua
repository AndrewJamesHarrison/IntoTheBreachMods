

local mine_damage = SpaceDamage(DAMAGE_DEATH)
mine_damage.sSound = "/props/exploding_mine"
mine_damage.sAnimation = "ExploAir2"

Item_Mine = { Image = "combat/mine.png", Damage = mine_damage, Tooltip = "old_earth_mine", Icon = "combat/icons/icon_mine_glow.png"}

local freeze_damage = SpaceDamage(0)
freeze_damage.sSound = "/props/freezing_mine"
freeze_damage.sAnimation = ""
freeze_damage.iFrozen = EFFECT_CREATE

Freeze_Mine = { Image = "combat/freeze_mine.png", Damage = freeze_damage, Tooltip = "freeze_mine", Icon = "combat/icons/icon_frozenmine_glow.png"}

Supply_Drop = { Image = "combat/pod/crashed_pod.png", Damage = SpaceDamage(0), Tooltip = "supply_drop"}

