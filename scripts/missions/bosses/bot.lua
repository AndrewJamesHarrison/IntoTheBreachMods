
Mission_BotBoss = Mission_Boss:new{
	BossText = "Destroy the Bot Leader",
	SpawnStartMod = -1,
	BossPawn = "BotBoss",
	BossGeneric = false,--don't use generic boss briefing text
}

function Mission_BotBoss:StartMission()
	self:StartBoss()
	
	local frozen = self:NextRobot()
	frozen:SetFrozen(true)
	Board:AddPawn(frozen)
	frozen = self:NextRobot()
	frozen:SetFrozen(true)
	Board:AddPawn(frozen)
end

function Mission_BotBoss:GetBossPawn()
	local bosstype = "BotBoss"
	if GetSector() > 2 then
		 bosstype = "BotBoss2"
	end
	return bosstype
end

BossHeal = SelfTarget:new{
	Name = "Boss Heal"
}

function BossHeal:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local heal = SpaceDamage(p1,-5)
	heal.iShield = -1
	ret:AddQueuedDamage(heal)
	local shield = SpaceDamage(p1)
	shield.iShield = 1
	ret:AddDamage(shield)
	return ret
end

BotBoss = {
	Name = "Bot Leader",
	Health = 5,
	MoveSpeed = 3,
	SelfHeal = true,
	Image = "snow_boss",
	SoundLocation = "/enemy/snowart_1/",
	SkillList = { "SnowBossAtk", "BossHeal" },
	Massive = true,
	ImpactMaterial = IMPACT_METAL,
	DefaultFaction = FACTION_BOTS,
	DefaultTeam = TEAM_ENEMY,
	Tier = TIER_BOSS,
}

AddPawn("BotBoss")

function BotBoss:GetWeapon()  -- DUPLUCATE FOR NOW.  NOT NECESSARY
	if Pawn:IsDamaged() then
		return 2
	else
		return 1
	end
end

SnowBossAtk = SnowartAtk1:new{Damage = 2}


--- HARDER VERSION

BotBoss2 = BotBoss:new{	
	Health = 6, 
	SkillList = { "SnowBossAtk2", "BossHeal" },
}

AddPawnName("BotBoss")

SnowBossAtk2 = SnowartAtk1:new{Damage = 4}
